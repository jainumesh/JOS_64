// User-level IPC library routines

#include <inc/lib.h>
#ifdef VMM_GUEST
#include <inc/vmx.h>
#endif

// Receive a value via IPC and return it.
// If 'pg' is nonnull, then any page sent by the sender will be mapped at
//	that address.
// If 'from_env_store' is nonnull, then store the IPC sender's envid in
//	*from_env_store.
// If 'perm_store' is nonnull, then store the IPC sender's page permission
//	in *perm_store (this is nonzero iff a page was successfully
//	transferred to 'pg').
// If the system call fails, then store 0 in *fromenv and *perm (if
//	they're nonnull) and return the error.
// Otherwise, return the value sent by the sender
//
// Hint:
//   Use 'thisenv' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
		thisenv = &envs[ENVX(sys_getenvid())];
	}
	if(!pg)
		pg = (void*) UTOP;

	result = sys_ipc_recv(pg);
	if(result< 0){
		*from_env_store = 0;
		*perm_store =0;
		return result;
	}
	if(from_env_store)
		*from_env_store = thisenv->env_ipc_from;
	if(perm_store)
		*perm_store = thisenv->env_ipc_perm;
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;

	//panic("ipc_recv not implemented");
}

// Send 'val' (and 'pg' with 'perm', if 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result;
	if(!pg)
		pg = (void*)UTOP;
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
		if(-E_IPC_NOT_RECV == result)
			sys_yield();
	}while(-E_IPC_NOT_RECV == result);
	if(result != 0)
		cprintf("ipc_send result is [%d]",result);
	//panic("ipc_send not implemented");
}

#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
	int result = 0;
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
	    	return result;
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
    asm volatile("vmcall\n"
	    : "=a" (result)
	    : "a" (VMX_VMCALL_IPCRECV),
	      "d" (a1),
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
	return result;
	
	//panic("ipc_recv not implemented in VM guest");
}


// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
	int result = 0;
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
	else
		a3 = UTOP;

	cprintf("a3 is [%x]",a3);
	
	a1 =  to_env;
	a2 = val;
	a4 = perm;
	do{
		asm volatile("vmcall\n"
			: "=a" (result)
			: "a" (VMX_VMCALL_IPCSEND),
			  "d" (a1),
			  "c" (a2),
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
			sys_yield();
	}while(result == -E_IPC_NOT_RECV);
	
	if(result !=0)
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
}

#endif

// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
}
