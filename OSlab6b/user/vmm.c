#include <inc/lib.h>
#include <inc/vmx.h>
#include <inc/elf.h>
#include <inc/ept.h>
#include <inc/stdio.h>

#define GUEST_KERN "/vmm/kernel"
#define GUEST_BOOT "/vmm/boot"

#define JOS_ENTRY 0x7000

// Map a region of file fd into the guest at guest physical address gpa.
// The file region to map should start at fileoffset and be length filesz.
// The region to map in the guest should be memsz.  The region can span multiple pages.
//
// Return 0 on success, <0 on failure.
//

static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz, 
	      int fd, size_t filesz, off_t fileoffset ) {
	/* Your code here */
	int i=0;
	int result = 0;
	int rdsize =0;
	/*1st of all round down/up all the sizes*/
	ROUNDDOWN(gpa,PGSIZE);
	ROUNDDOWN(fileoffset,PGSIZE);
	ROUNDUP(memsz,PGSIZE);
	ROUNDUP(filesz,PGSIZE);

	/*copy memsz at gpa*/
	for (i = 0;i< memsz;i+=PGSIZE){

		if((result = sys_page_alloc(0,UTEMP,__EPTE_FULL))<0)
			return -E_NO_SYS; 	
		//if file is smaller than memsz, dont return error, simply map empty pages. 
		if(i<filesz){
			if((result = seek(fd,fileoffset+i))<0)
				return -E_NO_SYS; 
			rdsize = (filesz-i > PGSIZE) ? PGSIZE:filesz-i;
			if((result = readn(fd, UTEMP,rdsize))<0)
				return -E_NO_SYS; 
		}
		//cprintf("going to call or gpa = [%x], rdsize = [%d]\n",gpa+i,rdsize);
		if((result = sys_ept_map(0,UTEMP,guest,(void*)(gpa+i),__EPTE_FULL))<0)
			return -E_NO_SYS; 
		if((result = sys_page_unmap(0,UTEMP))<0)
			return -E_NO_SYS; 
			
	}
	return 0;
//	return -E_NO_SYS;

} 
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {

/* Your code here */
int fd;
int result = 0;
struct PageInfo *p;
struct Elf * elfHeader;
struct Proghdr *ph, *eph;
char buf[512] = {0};
int bytesRead = 0;

if(fname == NULL)
{
        return -E_NO_SYS;
}
if ((fd = open(fname, O_RDONLY)) < 0 ) {
        cprintf("open %s for read: %e\n", fname, fd );
        return -E_INVAL;
}

bytesRead = read(fd, buf, 512);
if(bytesRead < 512)
{
        close(fd);
        cprintf("Error in reading ELF header bytes read are %d\n", bytesRead);
        return -E_NOT_EXEC;
}
elfHeader = (struct Elf *) buf;
// is this a valid ELF?
if (elfHeader->e_magic != ELF_MAGIC){
        close(fd);
        cprintf("loading ELF header Failed due to Corrupt Kernel ELF\n");
        return -E_NOT_EXEC;
}

   ph = (struct Proghdr *) (buf + elfHeader->e_phoff);
		eph = ph + elfHeader->e_phnum;

		for (;ph < eph; ph++){
				if(ELF_PROG_LOAD == ph->p_type){
						if(ph->p_filesz <= ph->p_memsz){
								if ((result = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset)) < 0) {
										cprintf("Error mapping bootloader into the guest - %d\n.", result);
										close(fd);
										return -E_INVAL;
								}
						}
				}
		}
		close(fd);
		return 0;
}


// Read the ELF headers of kernel file specified by fname,
// mapping all valid segments into guest physical memory as appropriate.
//
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.

void
umain(int argc, char **argv) {
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
		cprintf("Error creating a guest OS env: %e\n", ret );
		exit();
	}
	guest = ret;

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
		cprintf("Error copying page into the guest - %d\n.", ret);
		exit();
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
		exit();
	}

	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
		cprintf("Error mapping bootloader into the guest - %d\n.", ret);
		exit();
	}
#ifndef VMM_GUEST	
	sys_vmx_incr_vmdisk_number();	//increase the vmdisk number
	//create a new guest disk image
	
	vmdisk_number = sys_vmx_get_vmdisk_number();
	snprintf(filename_buffer, 50, "/vmm/fs%d.img", vmdisk_number);
	
	cprintf("Creating a new virtual HDD at /vmm/fs%d.img\n", vmdisk_number);
        //r = copy("vmm/clean-fs.img", filename_buffer);
        r = 0;
        if (r < 0) {
        	cprintf("Create new virtual HDD failed: %e\n", r);
        	exit();
        }
        
        cprintf("Create VHD finished\n");
#endif
	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
	wait(guest);
}


