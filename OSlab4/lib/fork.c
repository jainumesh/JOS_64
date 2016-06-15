// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800


static __inline uint64_t
read_rsp(void)
{
        uint64_t esp;
        __asm __volatile("movq %%rsp,%0" : "=r" (esp));
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	void *Pageaddr ;
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
		panic("Page isnt writable/ COW, why did I get a pagefault \n");


	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_USER)){
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
		memmove(PFTEMP, Pageaddr, PGSIZE);
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_USER))
				panic("Page map at temp address failed");
		if(0> sys_page_unmap(0,PFTEMP))
				panic("Page unmap from temp location failed");
	}else{
		panic("Page Allocation Failed during handling page fault");
	}
	//panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = (uvpt[pn])&0x1FF; // Doubtful..
	void* addr = (void*)((uint64_t)pn *PGSIZE);
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", pn,perm);
	// LAB 4: Your code  here.
	if(perm& PTE_W || perm& PTE_COW){
		perm = (perm|(PTE_P|PTE_U|PTE_COW))&(~PTE_W);
		
		//cprintf("Hello I3 AM duppage\n");
		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
			panic("Page alloc with COW  failed.\n");
	}else{
	
	//cprintf("Hello I2 AM duppage\n");
		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		}

	//panic("duppage not implemented");
	
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
#if 1
envid_t
fork(void)
{
	// LAB 4: Your code here.
	envid_t envId; 
	extern void _pgfault_upcall(void);
	uint8_t *addr;
	extern char end[];
	uint64_t stackend = read_rsp();
	//cprintf("entering fork function here.\n");
	set_pgfault_handler(pgfault);
	
	envId = sys_exofork();
	if (envId < 0){
		panic("new process creation failed\n");	
	}
	if (envId == 0){
		/*Child's stuff here*/
		thisenv = &envs[ENVX(sys_getenvid())];
		return envId;
		
	}else{
		/*parents's stuff here*/
		/*How to do a page lookup here???, since this is user env page_lookup isnt allowed*/
		/*what if we create another system call for page_lookup, to make things easier????*/
		/*if look up succeeds, then call duppage on that page for child's process*/

		for (addr = (uint8_t*)USTACKTOP-PGSIZE ; addr >=(uint8_t*)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???  
		/*Do we really need to scan all the pages????*/
			if(uvpml4e[VPML4E(addr)]& PTE_P){
				if( uvpde[VPDPE(addr)] & PTE_P){
					if( uvpd[VPD(addr)] & PTE_P){
						if(uvpt[VPN(addr)]& PTE_P){
							//cprintf("addr = [%ld]\n",addr/PGSIZE);
							duppage(envId, VPN(addr));	
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
					}
				}else{
					addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
				}

			}else{
			/*uvpml4e.. move by */
				;;//addr -= NPDENTRIES*NPDENTRIES*NPDENTRIES*PGSIZE;
			}

		}

		//duppage(envId, USTACKTOP-PGSIZE);
		if(0< sys_env_set_pgfault_upcall(envId, (void*)_pgfault_upcall))
			panic("child's page fault upcall not set, who will allocate pages ??  Go panic \n");
		if(0< sys_page_alloc(envId,(void*)UXSTACKTOP-PGSIZE ,PTE_USER))
			panic("child's exception stack not created, where will it fault ??	Go panic \n");
		
		if(0> sys_env_set_status(envId,ENV_RUNNABLE)){
			panic("Child not set Runnable,what's the use of creatng it, so panic\n");
		}
	
		}
		//cprintf("Exiting fork function\n");
		return envId;
		//panic("fork not implemented");
	}


#else
envid_t
fork(void)
{
	int r=0;
	set_pgfault_handler(pgfault);
	envid_t childid = sys_exofork();
	if(childid < 0) {
		panic("\n couldn't call fork %e\n",childid);
	}
	if(childid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];	// some how figured how to get this thing...
		return 0; //this is for the child
	}
	r = sys_page_alloc(childid, (void*)(UXSTACKTOP-PGSIZE), PTE_P|PTE_W|PTE_U);
	if (r < 0)
		panic("\n couldn't call fork %e\n", r);
    
	uint64_t pml;
	uint64_t pdpe;
	uint64_t pde;
	uint64_t pte;
	uint64_t each_pde = 0;
	uint64_t each_pte = 0;
	uint64_t each_pdpe = 0;
	for(pml = 0; pml < VPML4E(UTOP); pml++) {
		if(uvpml4e[pml] & PTE_P) {
			
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++, each_pdpe++) {
				if(uvpde[each_pdpe] & PTE_P) {
					
					for(pde= 0; pde < NPDENTRIES; pde++, each_pde++) {
						if(uvpd[each_pde] & PTE_P) {
							
							for(pte = 0; pte < NPTENTRIES; pte++, each_pte++) {
								if(uvpt[each_pte] & PTE_P) {
									
									if(each_pte != VPN(UXSTACKTOP-PGSIZE)) {
										r = duppage(childid, (unsigned)each_pte);
										if (r < 0)
											panic("\n couldn't call fork %e\n", r);

									}
								}
							}

						}
						else {
							each_pte = (each_pde+1)*NPTENTRIES;		
						}

					}

				}
				else {
					each_pde = (each_pdpe+1)* NPDENTRIES;
				}

			}

		}
		else {
			each_pdpe = (pml+1) *NPDPENTRIES;
		}
	}

	extern void _pgfault_upcall(void);	
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
	if (r < 0)
		panic("\n couldn't call fork %e\n", r);

	r = sys_env_set_status(childid, ENV_RUNNABLE);
	if (r < 0)
		panic("\n couldn't call fork %e\n", r);
	
	// LAB 4: Your code here.
	//panic("fork not implemented");
	return childid;
}


#endif	
// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
