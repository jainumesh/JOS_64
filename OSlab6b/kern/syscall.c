/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>


#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>
#include <kern/time.h>
//#ifndef VMM_GUEST
#include <vmm/ept.h>
#include <vmm/vmx.h>
//#endif

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, (const void *)s, len, PTE_U );
	
	// Print the string supplied by the user.
	
	cprintf("%.*s", len, s);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	struct Env *newenv_store;
	uint32_t  result = 0;
	result= env_alloc(&newenv_store, curenv->env_id);

	if(result != 0)
		return result;
	//cprintf("curenv->env_id [%d], newenv_store->env_parent_id [%d],  newenv_store->env_id [%d]\n",curenv->env_id, newenv_store->env_parent_id,newenv_store->env_id);

	newenv_store->env_status = ENV_NOT_RUNNABLE;
	newenv_store->env_tf = curenv->env_tf;
	newenv_store->env_tf.tf_regs.reg_rax = 0x00;
	return newenv_store->env_id;

	//panic("sys_exofork not implemented");
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	uint32_t  result =0;
	struct Env *env_store;
	result = envid2env(envid,&env_store,1);

	if(result != 0)
		return result;
	if(status< 0 || status >4)
		return -E_INVAL;
	
	env_store->env_status = status;
	return result;
	//panic("sys_env_set_status not implemented");
}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
	{
		// LAB 5: Your code here.
		// Remember to check whether the user has supplied us with a good
		// address!
		//panic("sys_env_set_trapframe not implemented");
		uint32_t  result = 0;
		struct Env *env_store;
		if(!tf)
			return -E_BAD_ENV;
		result = envid2env(envid,&env_store,1);
		if(result < 0)
			return result;
		//user_mem_assert(env_store, tf, sizeof(struct Trapframe), PTE_U|PTE_P);
		tf->tf_cs |= 0x3;
		tf->tf_eflags |= FL_IF;
		env_store->env_tf = *tf;
		return result;
	}


// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	
	uint32_t  result =0;
	struct Env *env_store;
	result = envid2env(envid,&env_store,1);

	if(result != 0)
		return result;

	env_store->env_pgfault_upcall = func;
	return 0;
	//panic("sys_env_set_pgfault_upcall not implemented");
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	uint32_t  result =0;
	struct Env *env_store;
	struct PageInfo * pp;
	pte_t *pte_store;
	//cprintf("sys page alloc [%d]",result);
	result = envid2env(envid,&env_store,1);

	if(result != 0)
		return result;

	if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL))
		return -E_INVAL;

	if(((uint64_t)va%PGSIZE !=0) ||((uint64_t)va> UTOP))
		return -E_INVAL;
	
    pp = page_alloc(0);
	if(!pp)
		return -E_NO_MEM;
	

	result = page_insert(env_store->env_pml4e,pp,va,perm|PTE_P);
	//cprintf("sys page alloc [%d]",result);
	return result;
	//panic("sys_page_alloc not implemented");
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	...-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.

	
	uint32_t  result =0;
	struct Env *env_store_src;
	struct Env *env_store_dst;
	struct PageInfo * pp;
	pte_t *pte_store;
	result = envid2env(srcenvid,&env_store_src,1);

	if(result != 0){
		//cprintf("need 1stcheckperm to be 0\n");
		return result;
	}
	result = envid2env(dstenvid,&env_store_dst,0);
	if(result != 0){
		//cprintf("need 2ndcheckperm to be 0\n");
		return result;
	}

	if(!(perm & PTE_U) || !(perm & PTE_P) || (perm & ~PTE_SYSCALL))
		return -E_INVAL;

	
	if(((uint64_t)dstva%PGSIZE !=0 || (uint64_t)dstva> UTOP)||((uint64_t)srcva%PGSIZE !=0 || (uint64_t)srcva> UTOP))
		return -E_INVAL;
	pp = page_lookup(env_store_src->env_pml4e, srcva, &pte_store);
	if(NULL == pp || (((*(pte_store) & PTE_W) == 0) && ((perm & PTE_W) != 0)))
		return -E_INVAL;	

	
	result = page_insert(env_store_dst->env_pml4e,pp,dstva,perm);
	
	return result;
	//panic("sys_page_map not implemented");
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.

static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().
	
	// LAB 4: Your code here.
	struct Env* env;
	if(envid2env(envid, &env,1) != 0)
	{
		return -E_BAD_ENV;
	}
	if(va == NULL || (uint64_t)va >= UTOP || (uint64_t)va  % PGSIZE != 0)
	{
		return -E_INVAL;
	}
	page_remove(env->env_pml4e, va);
	return 0;
	//panic("sys_page_unmap not implemented");
}
	
// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	struct Env* dstenv;
	struct Env* srcenv;
	pte_t* pte_store;
	int srcperm , result;
	struct PageInfo *pp = NULL;
	perm|= PTE_P;
	if(envid2env(envid, &dstenv,0) != 0)
		return -E_BAD_ENV;

	if(envid2env(0, &srcenv,0) != 0)
		return -E_BAD_ENV;
	
	if(!dstenv->env_ipc_recving)
		return -E_IPC_NOT_RECV;
//#ifndef VMM_GUEST
		pp =page_lookup(srcenv->env_pml4e,srcva,&pte_store); 
		if(!pp)
			if(srcva <(void*)UTOP)
				return -E_INVAL;
//#else
		;;//result = ept_lookup_gpa(srcenv->env_pml4e, srcva,0,&pte_store);

//#endif
	srcperm = *pte_store&PTE_SYSCALL;
	if(srcva <(void*)UTOP)
		if((((uint64_t)srcva)%PGSIZE!=0) || ((srcperm & (PTE_U | PTE_P))!=(PTE_U | PTE_P)))
			return -E_INVAL;
	if((srcva <(void*)UTOP) && ((perm & PTE_W) !=0) &&(((srcperm& PTE_W) == 0)))
		return -E_INVAL;

	if(envid == curenv->env_id)
		panic("what the hell. how can this be????");

	dstenv->env_ipc_recving = 0;
	dstenv->env_ipc_from = srcenv->env_id;
	dstenv->env_ipc_value = value;
	//cprintf("dstenv -> envID is:[%d]\n",dstenv->env_id);
	if(srcva <(void*)UTOP && dstenv->env_ipc_dstva <(void*)UTOP){
		dstenv->env_ipc_perm = perm;
#ifndef VMM_GUEST
				// guest OS related changes : Lab7-ex7
				if ( curenv->env_type != ENV_TYPE_GUEST) {
#endif
					if(page_insert(dstenv->env_pml4e, pp, dstenv->env_ipc_dstva , perm) < 0) {
						cprintf("\n No memory to map the page to target env\n");
						return -E_NO_MEM;
					}
#ifndef VMM_GUEST
				}
				else {
					if (ept_page_insert(dstenv->env_pml4e, pp, dstenv->env_ipc_dstva, perm) <0) {
						cprintf("\n No memory to map the page to target env\n");
									return -E_NO_MEM;
								}
				}
#endif

	}
	dstenv->env_status = ENV_RUNNABLE;
	return 0;
	//panic("sys_ipc_try_send not implemented");
}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:

static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	struct Env* env;
	void *addr;
	addr = 0 ;
	if(envid2env(0, &env,0) != 0)
	{
		return -E_BAD_ENV;
	}
	if(dstva <(void*)UTOP && (uint64_t)dstva%PGSIZE!=0)
		return -E_INVAL;
	if(dstva <(void*)UTOP)
		env->env_ipc_dstva = dstva;

	env->env_ipc_recving = 1;
#ifndef VMM_GUEST
	if (curenv->env_type == ENV_TYPE_GUEST) {
		ept_gpa2hva(curenv->env_pml4e,dstva,&addr);
		curenv->env_ipc_dstva = addr;
	}
	else
		curenv->env_ipc_dstva = dstva;	
#endif

	env->env_status = ENV_NOT_RUNNABLE;
	env->env_tf.tf_regs.reg_rax = 0;
	sys_yield();
	
	//panic("sys_ipc_recv not implemented");
	return 0;
}


static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	panic("sys_time_msec not implemented");
	return time_msec();
}


// Maps a page from the evnironment corresponding to envid into the guest vm 
// environments phys addr space. 
//
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or guest doesn't currently exist,
//		or the caller doesn't have permission to change one of them.(checlperm = 1)
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or guest_pa >= guest physical size or guest_pa is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate 
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables. 
//
// Hint: The TA solution uses ept_map_hva2gpa().  A guest environment uses 
//       env_pml4e to store the root of the extended page tables.
// 
#ifndef VMM_GUEST
static void
sys_vmx_list_vms() {
	vmx_list_vms();
}

static bool
sys_vmx_sel_resume(int i) {
	return vmx_sel_resume(i);
}

static int
sys_vmx_get_vmdisk_number() {
	return vmx_get_vmdisk_number();
}

static void
sys_vmx_incr_vmdisk_number() {
	vmx_incr_vmdisk_number();
}

static int
sys_ept_map(envid_t srcenvid, void *srcva,
	    envid_t guest, void* guest_pa, int perm)
{
	uint32_t  result =0;
	struct Env *env_store_src;
	struct Env *env_store_guest;
	struct PageInfo * pp;
	pte_t *pte_store;
	result = envid2env(srcenvid,&env_store_src,1);
		if(result != 0){
			cprintf("failed here 1\n");
			return -E_BAD_ENV;
			}
	
	result = envid2env(guest,&env_store_guest,1);
	if(result != 0){
		cprintf("failed here 2\n");
		return result;
	}


	if(((uint64_t)guest_pa%PGSIZE !=0 || (uint64_t)guest_pa >= (env_store_guest->env_vmxinfo.phys_sz)) 
			||((uint64_t)srcva%PGSIZE !=0 || (uint64_t)srcva>= UTOP) || (env_store_guest->env_type != ENV_TYPE_GUEST)){
		
		cprintf("failed here 3[%x] , env_type[%x]\n",srcva,guest_pa);
		return -E_INVAL;
	}

	if((!(perm &__EPTE_FULL))||(!(perm &__EPTE_READ))) {
		
		cprintf("failed here 4\n");
		return -E_INVAL;
	}
		
	pp = page_lookup(env_store_src->env_pml4e, srcva, &pte_store);
	if(NULL == pp || (((*(pte_store) & PTE_W) == 0) && ((perm & PTE_W) != 0))){
		
		cprintf("failed here 5\n");
		return -E_INVAL;	
	}

	result = ept_map_hva2gpa(env_store_guest->env_pml4e, page2kva(pp), guest_pa, perm, 0);


	//result = ept_page_insert(env_store_guest->env_pml4e, pp,guest_pa,perm);
	
	if(result != 0){
		
		cprintf("failed here 6\n");
		return result;
	}else{
		pp->pp_ref++;
	}
	/* Your code here */
	//panic ("sys_ept_map not implemented");
	return 0;
}

static envid_t
	sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
	int r;
	struct Env *e;

	// Check if the processor has VMX support.
	if ( !vmx_check_support() ) {
		return -E_NO_VMX;
	} else if ( !vmx_check_ept() ) {
		return -E_NO_EPT;
	} 
	if ((r = env_guest_alloc(&e, curenv->env_id)) < 0)
		return r;
	e->env_status = ENV_NOT_RUNNABLE;
	e->env_vmxinfo.phys_sz = gphysz;
	e->env_tf.tf_rip = gRIP;
	return e->env_id;
}
#endif //!VMM_GUEST


// Dispatches to the correct kernel function, passing the arguments.
int64_t
syscall(uint64_t syscallno, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");
	int64_t result = -E_NO_SYS;

	switch (syscallno) {
#ifndef VMM_GUEST
	case SYS_ept_map:
		return sys_ept_map(a1, (void*) a2, a3, (void*) a4, a5);
	case SYS_env_mkguest:
		return sys_env_mkguest(a1, a2);
	case SYS_vmx_list_vms:
		sys_vmx_list_vms();
		return 0;
	case SYS_vmx_sel_resume:
		return sys_vmx_sel_resume(a1);
	case SYS_vmx_get_vmdisk_number:
		return sys_vmx_get_vmdisk_number();
	case SYS_vmx_incr_vmdisk_number:
		sys_vmx_incr_vmdisk_number();
		return 0;
#endif
		
		case SYS_cputs:
			sys_cputs((const char *)a1, a2);
			result = 0;
			break;
		case SYS_cgetc:
			result = sys_cgetc();
			break;
		case SYS_getenvid:
			result = sys_getenvid();
			break;
		case SYS_env_destroy:
			result = sys_env_destroy(a1);
			break;
		case SYS_yield:
			sys_yield();
			result = 0;
			break;
		case SYS_exofork:
			return sys_exofork();
			break;
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
			break;
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void*)a2);
			break;
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void*)a3, a4);
			break;
		case SYS_ipc_recv:
			return sys_ipc_recv((void*)a1);
			break;
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void*)a2, a3);
			break;	
		case SYS_page_map:
			return sys_page_map(a1, (void*)a2, a3, (void*)a4, a5);
			break;
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void*)a2);
			break;
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case SYS_time_msec:
			return sys_time_msec();
		default:		
			return -E_NO_SYS;
	}
	return result;	
}

#ifdef TEST_EPT_MAP
int
_export_sys_ept_map(envid_t srcenvid, void *srcva,
		    envid_t guest, void* guest_pa, int perm)
{
	return sys_ept_map(srcenvid, srcva, guest, guest_pa, perm);
}
#endif

