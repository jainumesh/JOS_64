#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/spinlock.h>
#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>

void sched_halt(void);


#ifndef VMM_GUEST
#include <vmm/vmx.h>
static int
vmxon() {
	int r;
	if(!thiscpu->is_vmx_root) {
		r = vmx_init_vmxon();
		if(r < 0) {
			cprintf("Error executing VMXON: %e\n", r);
			return r;
		}
		cprintf("VMXON\n");
	}
	return 0;
}
#endif

// Choose a user environment to run and run it.
void
sched_yield(void)
{	
		// Implement simple round-robin scheduling.
		//
		// Search through 'envs' for an ENV_RUNNABLE environment in
		// circular fashion starting just after the env this CPU was
		// last running.  Switch to the first such environment found.
		//
		// If no envs are runnable, but the environment previously
		// running on this CPU is still ENV_RUNNING, it's okay to
		// choose that environment.
		//
		// Never choose an environment that's currently running on
		// another CPU (env_status == ENV_RUNNING). If there are
		// no runnable environments, simply drop through to the code
		// below to halt the cpu.	
	
		// LAB 4: Your code here.
		static uint32_t env_counter = 0;
		uint32_t i = 0;
		//cprintf("envcounter1 = [%d]\n",env_counter);
		for(i=1;i<= NENV;i++){
			if(envs[(env_counter+i)%NENV].env_status == ENV_RUNNABLE){
				env_counter = (env_counter+i)%NENV;
				//cprintf("going to run now = [%d],status is [%d]\n",env_counter,envs[env_counter].env_status);
			#ifndef VMM_GUEST
				if(envs[env_counter].env_type==ENV_TYPE_GUEST)
				{
					if(curenv != NULL){
				    	if(curenv->env_status==ENV_RUNNING)
					    	curenv->env_status=ENV_RUNNABLE;
				    }
				    curenv = &envs[env_counter];
				    curenv->env_status = ENV_RUNNING;
				    curenv->env_runs++;
					if(!vmxon())
				    	vmx_vmrun(&envs[env_counter]);
				}
				else
			#endif					
				{
					env_run(&envs[env_counter]);
				}
				break;
			}
		}
		//cprintf("envcounter2 = [%d]\n",env_counter);
		if(curenv && curenv->env_status == ENV_RUNNING){
		#ifndef VMM_GUEST
			if(curenv->env_type==ENV_TYPE_GUEST)
			{
				curenv->env_runs++;
				if(!vmxon())
					vmx_vmrun(curenv);
			}
			else
		#endif		
			{
				env_run(curenv);
			}
		}
		else{
			sched_halt();	
		}
	}


// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
	{
		int i;
	
		// For debugging and testing purposes, if there are no runnable
		// environments in the system, then drop into the kernel monitor.
		for (i = 0; i < NENV; i++) {
			if ((envs[i].env_status == ENV_RUNNABLE ||
				 envs[i].env_status == ENV_RUNNING ||
				 envs[i].env_status == ENV_DYING))
				break;
		}
		if (i == NENV) {
			cprintf("No runnable environments in the system!\n");
			while (1)
				monitor(NULL);
		}
	
		// Mark that no environment is running on this CPU
		curenv = NULL;
		lcr3(PADDR(boot_pml4e));
	
		// Mark that this CPU is in the HALT state, so that when
		// timer interupts come in, we know we should re-acquire the
		// big kernel lock
		xchg(&thiscpu->cpu_status, CPU_HALTED);
	
		// Release the big kernel lock as if we were "leaving" the kernel
		unlock_kernel();
	
		// Reset stack pointer, enable interrupts and then halt.
		asm volatile (
			"movq $0, %%rbp\n"
			"movq %0, %%rsp\n"
			"pushq $0\n"
			"pushq $0\n"
			"sti\n"
			"hlt\n"
			: : "a" (thiscpu->cpu_ts.ts_esp0));
	}


