
obj/user/faultnostack.debug:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 39 00 00 00       	callq  80007a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 37 06 80 00 00 	movabs $0x800637,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	c9                   	leaveq 
  800079:	c3                   	retq   

000000000080007a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007a:	55                   	push   %rbp
  80007b:	48 89 e5             	mov    %rsp,%rbp
  80007e:	48 83 ec 10          	sub    $0x10,%rsp
  800082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800089:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  800090:	00 00 00 
  800093:	ff d0                	callq  *%rax
  800095:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009a:	48 63 d0             	movslq %eax,%rdx
  80009d:	48 89 d0             	mov    %rdx,%rax
  8000a0:	48 c1 e0 03          	shl    $0x3,%rax
  8000a4:	48 01 d0             	add    %rdx,%rax
  8000a7:	48 c1 e0 05          	shl    $0x5,%rax
  8000ab:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b2:	00 00 00 
  8000b5:	48 01 c2             	add    %rax,%rdx
  8000b8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000bf:	00 00 00 
  8000c2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c9:	7e 14                	jle    8000df <libmain+0x65>
		binaryname = argv[0];
  8000cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cf:	48 8b 10             	mov    (%rax),%rdx
  8000d2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d9:	00 00 00 
  8000dc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e6:	48 89 d6             	mov    %rdx,%rsi
  8000e9:	89 c7                	mov    %eax,%edi
  8000eb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8000f7:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	callq  *%rax
}
  800103:	c9                   	leaveq 
  800104:	c3                   	retq   

0000000000800105 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800105:	55                   	push   %rbp
  800106:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800109:	48 b8 ff 09 80 00 00 	movabs $0x8009ff,%rax
  800110:	00 00 00 
  800113:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800115:	bf 00 00 00 00       	mov    $0x0,%edi
  80011a:	48 b8 3e 02 80 00 00 	movabs $0x80023e,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax

}
  800126:	5d                   	pop    %rbp
  800127:	c3                   	retq   

0000000000800128 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800128:	55                   	push   %rbp
  800129:	48 89 e5             	mov    %rsp,%rbp
  80012c:	53                   	push   %rbx
  80012d:	48 83 ec 48          	sub    $0x48,%rsp
  800131:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800134:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800137:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800143:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800147:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800152:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800156:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015e:	4c 89 c3             	mov    %r8,%rbx
  800161:	cd 30                	int    $0x30
  800163:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800167:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016b:	74 3e                	je     8001ab <syscall+0x83>
  80016d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800172:	7e 37                	jle    8001ab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800174:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800178:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017b:	49 89 d0             	mov    %rdx,%r8
  80017e:	89 c1                	mov    %eax,%ecx
  800180:	48 ba ca 3f 80 00 00 	movabs $0x803fca,%rdx
  800187:	00 00 00 
  80018a:	be 23 00 00 00       	mov    $0x23,%esi
  80018f:	48 bf e7 3f 80 00 00 	movabs $0x803fe7,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	49 b9 4a 27 80 00 00 	movabs $0x80274a,%r9
  8001a5:	00 00 00 
  8001a8:	41 ff d1             	callq  *%r9

	return ret;
  8001ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001af:	48 83 c4 48          	add    $0x48,%rsp
  8001b3:	5b                   	pop    %rbx
  8001b4:	5d                   	pop    %rbp
  8001b5:	c3                   	retq   

00000000008001b6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b6:	55                   	push   %rbp
  8001b7:	48 89 e5             	mov    %rsp,%rbp
  8001ba:	48 83 ec 20          	sub    $0x20,%rsp
  8001be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d5:	00 
  8001d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e2:	48 89 d1             	mov    %rdx,%rcx
  8001e5:	48 89 c2             	mov    %rax,%rdx
  8001e8:	be 00 00 00 00       	mov    $0x0,%esi
  8001ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f2:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
}
  8001fe:	c9                   	leaveq 
  8001ff:	c3                   	retq   

0000000000800200 <sys_cgetc>:

int
sys_cgetc(void)
{
  800200:	55                   	push   %rbp
  800201:	48 89 e5             	mov    %rsp,%rbp
  800204:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800208:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020f:	00 
  800210:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800216:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800221:	ba 00 00 00 00       	mov    $0x0,%edx
  800226:	be 00 00 00 00       	mov    $0x0,%esi
  80022b:	bf 01 00 00 00       	mov    $0x1,%edi
  800230:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
}
  80023c:	c9                   	leaveq 
  80023d:	c3                   	retq   

000000000080023e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023e:	55                   	push   %rbp
  80023f:	48 89 e5             	mov    %rsp,%rbp
  800242:	48 83 ec 10          	sub    $0x10,%rsp
  800246:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024c:	48 98                	cltq   
  80024e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800255:	00 
  800256:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800262:	b9 00 00 00 00       	mov    $0x0,%ecx
  800267:	48 89 c2             	mov    %rax,%rdx
  80026a:	be 01 00 00 00       	mov    $0x1,%esi
  80026f:	bf 03 00 00 00       	mov    $0x3,%edi
  800274:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	c9                   	leaveq 
  800281:	c3                   	retq   

0000000000800282 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800291:	00 
  800292:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800298:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b2:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax
}
  8002be:	c9                   	leaveq 
  8002bf:	c3                   	retq   

00000000008002c0 <sys_yield>:

void
sys_yield(void)
{
  8002c0:	55                   	push   %rbp
  8002c1:	48 89 e5             	mov    %rsp,%rbp
  8002c4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002cf:	00 
  8002d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e6:	be 00 00 00 00       	mov    $0x0,%esi
  8002eb:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f0:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8002f7:	00 00 00 
  8002fa:	ff d0                	callq  *%rax
}
  8002fc:	c9                   	leaveq 
  8002fd:	c3                   	retq   

00000000008002fe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002fe:	55                   	push   %rbp
  8002ff:	48 89 e5             	mov    %rsp,%rbp
  800302:	48 83 ec 20          	sub    $0x20,%rsp
  800306:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800309:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800310:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800313:	48 63 c8             	movslq %eax,%rcx
  800316:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031d:	48 98                	cltq   
  80031f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800326:	00 
  800327:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032d:	49 89 c8             	mov    %rcx,%r8
  800330:	48 89 d1             	mov    %rdx,%rcx
  800333:	48 89 c2             	mov    %rax,%rdx
  800336:	be 01 00 00 00       	mov    $0x1,%esi
  80033b:	bf 04 00 00 00       	mov    $0x4,%edi
  800340:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax
}
  80034c:	c9                   	leaveq 
  80034d:	c3                   	retq   

000000000080034e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	48 83 ec 30          	sub    $0x30,%rsp
  800356:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800359:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800360:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800364:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036b:	48 63 c8             	movslq %eax,%rcx
  80036e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800372:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800375:	48 63 f0             	movslq %eax,%rsi
  800378:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037f:	48 98                	cltq   
  800381:	48 89 0c 24          	mov    %rcx,(%rsp)
  800385:	49 89 f9             	mov    %rdi,%r9
  800388:	49 89 f0             	mov    %rsi,%r8
  80038b:	48 89 d1             	mov    %rdx,%rcx
  80038e:	48 89 c2             	mov    %rax,%rdx
  800391:	be 01 00 00 00       	mov    $0x1,%esi
  800396:	bf 05 00 00 00       	mov    $0x5,%edi
  80039b:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	callq  *%rax
}
  8003a7:	c9                   	leaveq 
  8003a8:	c3                   	retq   

00000000008003a9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a9:	55                   	push   %rbp
  8003aa:	48 89 e5             	mov    %rsp,%rbp
  8003ad:	48 83 ec 20          	sub    $0x20,%rsp
  8003b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bf:	48 98                	cltq   
  8003c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c8:	00 
  8003c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d5:	48 89 d1             	mov    %rdx,%rcx
  8003d8:	48 89 c2             	mov    %rax,%rdx
  8003db:	be 01 00 00 00       	mov    $0x1,%esi
  8003e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e5:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8003ec:	00 00 00 
  8003ef:	ff d0                	callq  *%rax
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	48 83 ec 10          	sub    $0x10,%rsp
  8003fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800401:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800404:	48 63 d0             	movslq %eax,%rdx
  800407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040a:	48 98                	cltq   
  80040c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800413:	00 
  800414:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800420:	48 89 d1             	mov    %rdx,%rcx
  800423:	48 89 c2             	mov    %rax,%rdx
  800426:	be 01 00 00 00       	mov    $0x1,%esi
  80042b:	bf 08 00 00 00       	mov    $0x8,%edi
  800430:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800437:	00 00 00 
  80043a:	ff d0                	callq  *%rax
}
  80043c:	c9                   	leaveq 
  80043d:	c3                   	retq   

000000000080043e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80043e:	55                   	push   %rbp
  80043f:	48 89 e5             	mov    %rsp,%rbp
  800442:	48 83 ec 20          	sub    $0x20,%rsp
  800446:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800449:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	48 98                	cltq   
  800456:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045d:	00 
  80045e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046a:	48 89 d1             	mov    %rdx,%rcx
  80046d:	48 89 c2             	mov    %rax,%rdx
  800470:	be 01 00 00 00       	mov    $0x1,%esi
  800475:	bf 09 00 00 00       	mov    $0x9,%edi
  80047a:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
}
  800486:	c9                   	leaveq 
  800487:	c3                   	retq   

0000000000800488 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 20          	sub    $0x20,%rsp
  800490:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800493:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049e:	48 98                	cltq   
  8004a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a7:	00 
  8004a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b4:	48 89 d1             	mov    %rdx,%rcx
  8004b7:	48 89 c2             	mov    %rax,%rdx
  8004ba:	be 01 00 00 00       	mov    $0x1,%esi
  8004bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c4:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8004cb:	00 00 00 
  8004ce:	ff d0                	callq  *%rax
}
  8004d0:	c9                   	leaveq 
  8004d1:	c3                   	retq   

00000000008004d2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d2:	55                   	push   %rbp
  8004d3:	48 89 e5             	mov    %rsp,%rbp
  8004d6:	48 83 ec 20          	sub    $0x20,%rsp
  8004da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004eb:	48 63 f0             	movslq %eax,%rsi
  8004ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f5:	48 98                	cltq   
  8004f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800502:	00 
  800503:	49 89 f1             	mov    %rsi,%r9
  800506:	49 89 c8             	mov    %rcx,%r8
  800509:	48 89 d1             	mov    %rdx,%rcx
  80050c:	48 89 c2             	mov    %rax,%rdx
  80050f:	be 00 00 00 00       	mov    $0x0,%esi
  800514:	bf 0c 00 00 00       	mov    $0xc,%edi
  800519:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800520:	00 00 00 
  800523:	ff d0                	callq  *%rax
}
  800525:	c9                   	leaveq 
  800526:	c3                   	retq   

0000000000800527 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800527:	55                   	push   %rbp
  800528:	48 89 e5             	mov    %rsp,%rbp
  80052b:	48 83 ec 10          	sub    $0x10,%rsp
  80052f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800537:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80053e:	00 
  80053f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800545:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800550:	48 89 c2             	mov    %rax,%rdx
  800553:	be 01 00 00 00       	mov    $0x1,%esi
  800558:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055d:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800564:	00 00 00 
  800567:	ff d0                	callq  *%rax
}
  800569:	c9                   	leaveq 
  80056a:	c3                   	retq   

000000000080056b <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80056b:	55                   	push   %rbp
  80056c:	48 89 e5             	mov    %rsp,%rbp
  80056f:	48 83 ec 20          	sub    $0x20,%rsp
  800573:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800577:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  80057b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800583:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80058a:	00 
  80058b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800591:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800597:	48 89 d1             	mov    %rdx,%rcx
  80059a:	48 89 c2             	mov    %rax,%rdx
  80059d:	be 01 00 00 00       	mov    $0x1,%esi
  8005a2:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005a7:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8005ae:	00 00 00 
  8005b1:	ff d0                	callq  *%rax
}
  8005b3:	c9                   	leaveq 
  8005b4:	c3                   	retq   

00000000008005b5 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8005b5:	55                   	push   %rbp
  8005b6:	48 89 e5             	mov    %rsp,%rbp
  8005b9:	48 83 ec 10          	sub    $0x10,%rsp
  8005bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8005c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005cc:	00 
  8005cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005de:	48 89 c2             	mov    %rax,%rdx
  8005e1:	be 00 00 00 00       	mov    $0x0,%esi
  8005e6:	bf 10 00 00 00       	mov    $0x10,%edi
  8005eb:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8005f2:	00 00 00 
  8005f5:	ff d0                	callq  *%rax
}
  8005f7:	c9                   	leaveq 
  8005f8:	c3                   	retq   

00000000008005f9 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8005f9:	55                   	push   %rbp
  8005fa:	48 89 e5             	mov    %rsp,%rbp
  8005fd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800601:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800608:	00 
  800609:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80060f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	ba 00 00 00 00       	mov    $0x0,%edx
  80061f:	be 00 00 00 00       	mov    $0x0,%esi
  800624:	bf 0e 00 00 00       	mov    $0xe,%edi
  800629:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800630:	00 00 00 
  800633:	ff d0                	callq  *%rax
}
  800635:	c9                   	leaveq 
  800636:	c3                   	retq   

0000000000800637 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  800637:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80063a:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  800641:	00 00 00 
call *%rax
  800644:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  800646:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80064d:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80064e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  800655:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  800656:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80065a:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80065d:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  800664:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  800665:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  800669:	4c 8b 3c 24          	mov    (%rsp),%r15
  80066d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  800672:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  800677:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80067c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  800681:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  800686:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80068b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  800690:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  800695:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80069a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80069f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8006a4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8006a9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8006ae:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8006b3:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8006b7:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8006bb:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8006bc:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8006bd:	c3                   	retq   

00000000008006be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8006be:	55                   	push   %rbp
  8006bf:	48 89 e5             	mov    %rsp,%rbp
  8006c2:	48 83 ec 08          	sub    $0x8,%rsp
  8006c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006ce:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006d5:	ff ff ff 
  8006d8:	48 01 d0             	add    %rdx,%rax
  8006db:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006df:	c9                   	leaveq 
  8006e0:	c3                   	retq   

00000000008006e1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8006e1:	55                   	push   %rbp
  8006e2:	48 89 e5             	mov    %rsp,%rbp
  8006e5:	48 83 ec 08          	sub    $0x8,%rsp
  8006e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8006ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f1:	48 89 c7             	mov    %rax,%rdi
  8006f4:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8006fb:	00 00 00 
  8006fe:	ff d0                	callq  *%rax
  800700:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800706:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80070a:	c9                   	leaveq 
  80070b:	c3                   	retq   

000000000080070c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80070c:	55                   	push   %rbp
  80070d:	48 89 e5             	mov    %rsp,%rbp
  800710:	48 83 ec 18          	sub    $0x18,%rsp
  800714:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800718:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80071f:	eb 6b                	jmp    80078c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800724:	48 98                	cltq   
  800726:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80072c:	48 c1 e0 0c          	shl    $0xc,%rax
  800730:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800738:	48 c1 e8 15          	shr    $0x15,%rax
  80073c:	48 89 c2             	mov    %rax,%rdx
  80073f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800746:	01 00 00 
  800749:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80074d:	83 e0 01             	and    $0x1,%eax
  800750:	48 85 c0             	test   %rax,%rax
  800753:	74 21                	je     800776 <fd_alloc+0x6a>
  800755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800759:	48 c1 e8 0c          	shr    $0xc,%rax
  80075d:	48 89 c2             	mov    %rax,%rdx
  800760:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800767:	01 00 00 
  80076a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80076e:	83 e0 01             	and    $0x1,%eax
  800771:	48 85 c0             	test   %rax,%rax
  800774:	75 12                	jne    800788 <fd_alloc+0x7c>
			*fd_store = fd;
  800776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80077e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	eb 1a                	jmp    8007a2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800788:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80078c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800790:	7e 8f                	jle    800721 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80079d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8007a2:	c9                   	leaveq 
  8007a3:	c3                   	retq   

00000000008007a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007a4:	55                   	push   %rbp
  8007a5:	48 89 e5             	mov    %rsp,%rbp
  8007a8:	48 83 ec 20          	sub    $0x20,%rsp
  8007ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8007b7:	78 06                	js     8007bf <fd_lookup+0x1b>
  8007b9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8007bd:	7e 07                	jle    8007c6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c4:	eb 6c                	jmp    800832 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8007c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007c9:	48 98                	cltq   
  8007cb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8007d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8007d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007dd:	48 c1 e8 15          	shr    $0x15,%rax
  8007e1:	48 89 c2             	mov    %rax,%rdx
  8007e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007eb:	01 00 00 
  8007ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f2:	83 e0 01             	and    $0x1,%eax
  8007f5:	48 85 c0             	test   %rax,%rax
  8007f8:	74 21                	je     80081b <fd_lookup+0x77>
  8007fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007fe:	48 c1 e8 0c          	shr    $0xc,%rax
  800802:	48 89 c2             	mov    %rax,%rdx
  800805:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80080c:	01 00 00 
  80080f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800813:	83 e0 01             	and    $0x1,%eax
  800816:	48 85 c0             	test   %rax,%rax
  800819:	75 07                	jne    800822 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb 10                	jmp    800832 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800822:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800826:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80082a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80082d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800832:	c9                   	leaveq 
  800833:	c3                   	retq   

0000000000800834 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800834:	55                   	push   %rbp
  800835:	48 89 e5             	mov    %rsp,%rbp
  800838:	48 83 ec 30          	sub    $0x30,%rsp
  80083c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800840:	89 f0                	mov    %esi,%eax
  800842:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800849:	48 89 c7             	mov    %rax,%rdi
  80084c:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800853:	00 00 00 
  800856:	ff d0                	callq  *%rax
  800858:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80085c:	48 89 d6             	mov    %rdx,%rsi
  80085f:	89 c7                	mov    %eax,%edi
  800861:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800868:	00 00 00 
  80086b:	ff d0                	callq  *%rax
  80086d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800874:	78 0a                	js     800880 <fd_close+0x4c>
	    || fd != fd2)
  800876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80087a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80087e:	74 12                	je     800892 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800880:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800884:	74 05                	je     80088b <fd_close+0x57>
  800886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800889:	eb 05                	jmp    800890 <fd_close+0x5c>
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
  800890:	eb 69                	jmp    8008fb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800896:	8b 00                	mov    (%rax),%eax
  800898:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80089c:	48 89 d6             	mov    %rdx,%rsi
  80089f:	89 c7                	mov    %eax,%edi
  8008a1:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  8008a8:	00 00 00 
  8008ab:	ff d0                	callq  *%rax
  8008ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008b4:	78 2a                	js     8008e0 <fd_close+0xac>
		if (dev->dev_close)
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008be:	48 85 c0             	test   %rax,%rax
  8008c1:	74 16                	je     8008d9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8008cf:	48 89 d7             	mov    %rdx,%rdi
  8008d2:	ff d0                	callq  *%rax
  8008d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008d7:	eb 07                	jmp    8008e0 <fd_close+0xac>
		else
			r = 0;
  8008d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8008e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e4:	48 89 c6             	mov    %rax,%rsi
  8008e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ec:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8008f3:	00 00 00 
  8008f6:	ff d0                	callq  *%rax
	return r;
  8008f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008fb:	c9                   	leaveq 
  8008fc:	c3                   	retq   

00000000008008fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008fd:	55                   	push   %rbp
  8008fe:	48 89 e5             	mov    %rsp,%rbp
  800901:	48 83 ec 20          	sub    $0x20,%rsp
  800905:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800908:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80090c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800913:	eb 41                	jmp    800956 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800915:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80091c:	00 00 00 
  80091f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800922:	48 63 d2             	movslq %edx,%rdx
  800925:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80092e:	75 22                	jne    800952 <dev_lookup+0x55>
			*dev = devtab[i];
  800930:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800937:	00 00 00 
  80093a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80093d:	48 63 d2             	movslq %edx,%rdx
  800940:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800944:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800948:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	eb 60                	jmp    8009b2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800952:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800956:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80095d:	00 00 00 
  800960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800963:	48 63 d2             	movslq %edx,%rdx
  800966:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80096a:	48 85 c0             	test   %rax,%rax
  80096d:	75 a6                	jne    800915 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80096f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800976:	00 00 00 
  800979:	48 8b 00             	mov    (%rax),%rax
  80097c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800982:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800985:	89 c6                	mov    %eax,%esi
  800987:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  80098e:	00 00 00 
  800991:	b8 00 00 00 00       	mov    $0x0,%eax
  800996:	48 b9 83 29 80 00 00 	movabs $0x802983,%rcx
  80099d:	00 00 00 
  8009a0:	ff d1                	callq  *%rcx
	*dev = 0;
  8009a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8009ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8009b2:	c9                   	leaveq 
  8009b3:	c3                   	retq   

00000000008009b4 <close>:

int
close(int fdnum)
{
  8009b4:	55                   	push   %rbp
  8009b5:	48 89 e5             	mov    %rsp,%rbp
  8009b8:	48 83 ec 20          	sub    $0x20,%rsp
  8009bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8009c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009c6:	48 89 d6             	mov    %rdx,%rsi
  8009c9:	89 c7                	mov    %eax,%edi
  8009cb:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009de:	79 05                	jns    8009e5 <close+0x31>
		return r;
  8009e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009e3:	eb 18                	jmp    8009fd <close+0x49>
	else
		return fd_close(fd, 1);
  8009e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009e9:	be 01 00 00 00       	mov    $0x1,%esi
  8009ee:	48 89 c7             	mov    %rax,%rdi
  8009f1:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  8009f8:	00 00 00 
  8009fb:	ff d0                	callq  *%rax
}
  8009fd:	c9                   	leaveq 
  8009fe:	c3                   	retq   

00000000008009ff <close_all>:

void
close_all(void)
{
  8009ff:	55                   	push   %rbp
  800a00:	48 89 e5             	mov    %rsp,%rbp
  800a03:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800a0e:	eb 15                	jmp    800a25 <close_all+0x26>
		close(i);
  800a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a13:	89 c7                	mov    %eax,%edi
  800a15:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  800a1c:	00 00 00 
  800a1f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800a21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800a25:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800a29:	7e e5                	jle    800a10 <close_all+0x11>
		close(i);
}
  800a2b:	c9                   	leaveq 
  800a2c:	c3                   	retq   

0000000000800a2d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800a2d:	55                   	push   %rbp
  800a2e:	48 89 e5             	mov    %rsp,%rbp
  800a31:	48 83 ec 40          	sub    $0x40,%rsp
  800a35:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800a38:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a3b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800a3f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800a42:	48 89 d6             	mov    %rdx,%rsi
  800a45:	89 c7                	mov    %eax,%edi
  800a47:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800a4e:	00 00 00 
  800a51:	ff d0                	callq  *%rax
  800a53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a5a:	79 08                	jns    800a64 <dup+0x37>
		return r;
  800a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a5f:	e9 70 01 00 00       	jmpq   800bd4 <dup+0x1a7>
	close(newfdnum);
  800a64:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a67:	89 c7                	mov    %eax,%edi
  800a69:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  800a70:	00 00 00 
  800a73:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a75:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a78:	48 98                	cltq   
  800a7a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a80:	48 c1 e0 0c          	shl    $0xc,%rax
  800a84:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a8c:	48 89 c7             	mov    %rax,%rdi
  800a8f:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800a96:	00 00 00 
  800a99:	ff d0                	callq  *%rax
  800a9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	48 c1 e8 15          	shr    $0x15,%rax
  800abe:	48 89 c2             	mov    %rax,%rdx
  800ac1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800ac8:	01 00 00 
  800acb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800acf:	83 e0 01             	and    $0x1,%eax
  800ad2:	48 85 c0             	test   %rax,%rax
  800ad5:	74 73                	je     800b4a <dup+0x11d>
  800ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adb:	48 c1 e8 0c          	shr    $0xc,%rax
  800adf:	48 89 c2             	mov    %rax,%rdx
  800ae2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ae9:	01 00 00 
  800aec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800af0:	83 e0 01             	and    $0x1,%eax
  800af3:	48 85 c0             	test   %rax,%rax
  800af6:	74 52                	je     800b4a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afc:	48 c1 e8 0c          	shr    $0xc,%rax
  800b00:	48 89 c2             	mov    %rax,%rdx
  800b03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b0a:	01 00 00 
  800b0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b11:	25 07 0e 00 00       	and    $0xe07,%eax
  800b16:	89 c1                	mov    %eax,%ecx
  800b18:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b20:	41 89 c8             	mov    %ecx,%r8d
  800b23:	48 89 d1             	mov    %rdx,%rcx
  800b26:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2b:	48 89 c6             	mov    %rax,%rsi
  800b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b33:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800b3a:	00 00 00 
  800b3d:	ff d0                	callq  *%rax
  800b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b46:	79 02                	jns    800b4a <dup+0x11d>
			goto err;
  800b48:	eb 57                	jmp    800ba1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b4e:	48 c1 e8 0c          	shr    $0xc,%rax
  800b52:	48 89 c2             	mov    %rax,%rdx
  800b55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b5c:	01 00 00 
  800b5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b63:	25 07 0e 00 00       	and    $0xe07,%eax
  800b68:	89 c1                	mov    %eax,%ecx
  800b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b72:	41 89 c8             	mov    %ecx,%r8d
  800b75:	48 89 d1             	mov    %rdx,%rcx
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	48 89 c6             	mov    %rax,%rsi
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
  800b85:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
  800b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b98:	79 02                	jns    800b9c <dup+0x16f>
		goto err;
  800b9a:	eb 05                	jmp    800ba1 <dup+0x174>

	return newfdnum;
  800b9c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b9f:	eb 33                	jmp    800bd4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ba5:	48 89 c6             	mov    %rax,%rsi
  800ba8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bad:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800bb4:	00 00 00 
  800bb7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bbd:	48 89 c6             	mov    %rax,%rsi
  800bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc5:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800bcc:	00 00 00 
  800bcf:	ff d0                	callq  *%rax
	return r;
  800bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bd4:	c9                   	leaveq 
  800bd5:	c3                   	retq   

0000000000800bd6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800bd6:	55                   	push   %rbp
  800bd7:	48 89 e5             	mov    %rsp,%rbp
  800bda:	48 83 ec 40          	sub    $0x40,%rsp
  800bde:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800be1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800be5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bf0:	48 89 d6             	mov    %rdx,%rsi
  800bf3:	89 c7                	mov    %eax,%edi
  800bf5:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800bfc:	00 00 00 
  800bff:	ff d0                	callq  *%rax
  800c01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c08:	78 24                	js     800c2e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0e:	8b 00                	mov    (%rax),%eax
  800c10:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c14:	48 89 d6             	mov    %rdx,%rsi
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	callq  *%rax
  800c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c2c:	79 05                	jns    800c33 <read+0x5d>
		return r;
  800c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c31:	eb 76                	jmp    800ca9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c37:	8b 40 08             	mov    0x8(%rax),%eax
  800c3a:	83 e0 03             	and    $0x3,%eax
  800c3d:	83 f8 01             	cmp    $0x1,%eax
  800c40:	75 3a                	jne    800c7c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c42:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800c49:	00 00 00 
  800c4c:	48 8b 00             	mov    (%rax),%rax
  800c4f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c55:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c58:	89 c6                	mov    %eax,%esi
  800c5a:	48 bf 17 40 80 00 00 	movabs $0x804017,%rdi
  800c61:	00 00 00 
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
  800c69:	48 b9 83 29 80 00 00 	movabs $0x802983,%rcx
  800c70:	00 00 00 
  800c73:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c7a:	eb 2d                	jmp    800ca9 <read+0xd3>
	}
	if (!dev->dev_read)
  800c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c80:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c84:	48 85 c0             	test   %rax,%rax
  800c87:	75 07                	jne    800c90 <read+0xba>
		return -E_NOT_SUPP;
  800c89:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c8e:	eb 19                	jmp    800ca9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c94:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c98:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800ca4:	48 89 cf             	mov    %rcx,%rdi
  800ca7:	ff d0                	callq  *%rax
}
  800ca9:	c9                   	leaveq 
  800caa:	c3                   	retq   

0000000000800cab <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800cab:	55                   	push   %rbp
  800cac:	48 89 e5             	mov    %rsp,%rbp
  800caf:	48 83 ec 30          	sub    $0x30,%rsp
  800cb3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800cba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800cc5:	eb 49                	jmp    800d10 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cca:	48 98                	cltq   
  800ccc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800cd0:	48 29 c2             	sub    %rax,%rdx
  800cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd6:	48 63 c8             	movslq %eax,%rcx
  800cd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cdd:	48 01 c1             	add    %rax,%rcx
  800ce0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ce3:	48 89 ce             	mov    %rcx,%rsi
  800ce6:	89 c7                	mov    %eax,%edi
  800ce8:	48 b8 d6 0b 80 00 00 	movabs $0x800bd6,%rax
  800cef:	00 00 00 
  800cf2:	ff d0                	callq  *%rax
  800cf4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800cf7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cfb:	79 05                	jns    800d02 <readn+0x57>
			return m;
  800cfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d00:	eb 1c                	jmp    800d1e <readn+0x73>
		if (m == 0)
  800d02:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d06:	75 02                	jne    800d0a <readn+0x5f>
			break;
  800d08:	eb 11                	jmp    800d1b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d0d:	01 45 fc             	add    %eax,-0x4(%rbp)
  800d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d13:	48 98                	cltq   
  800d15:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800d19:	72 ac                	jb     800cc7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d1e:	c9                   	leaveq 
  800d1f:	c3                   	retq   

0000000000800d20 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d20:	55                   	push   %rbp
  800d21:	48 89 e5             	mov    %rsp,%rbp
  800d24:	48 83 ec 40          	sub    $0x40,%rsp
  800d28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800d2f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d33:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	89 c7                	mov    %eax,%edi
  800d3f:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d52:	78 24                	js     800d78 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d58:	8b 00                	mov    (%rax),%eax
  800d5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d5e:	48 89 d6             	mov    %rdx,%rsi
  800d61:	89 c7                	mov    %eax,%edi
  800d63:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800d6a:	00 00 00 
  800d6d:	ff d0                	callq  *%rax
  800d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d76:	79 05                	jns    800d7d <write+0x5d>
		return r;
  800d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d7b:	eb 75                	jmp    800df2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d81:	8b 40 08             	mov    0x8(%rax),%eax
  800d84:	83 e0 03             	and    $0x3,%eax
  800d87:	85 c0                	test   %eax,%eax
  800d89:	75 3a                	jne    800dc5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d8b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d92:	00 00 00 
  800d95:	48 8b 00             	mov    (%rax),%rax
  800d98:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d9e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800da1:	89 c6                	mov    %eax,%esi
  800da3:	48 bf 33 40 80 00 00 	movabs $0x804033,%rdi
  800daa:	00 00 00 
  800dad:	b8 00 00 00 00       	mov    $0x0,%eax
  800db2:	48 b9 83 29 80 00 00 	movabs $0x802983,%rcx
  800db9:	00 00 00 
  800dbc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800dbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc3:	eb 2d                	jmp    800df2 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc9:	48 8b 40 18          	mov    0x18(%rax),%rax
  800dcd:	48 85 c0             	test   %rax,%rax
  800dd0:	75 07                	jne    800dd9 <write+0xb9>
		return -E_NOT_SUPP;
  800dd2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dd7:	eb 19                	jmp    800df2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddd:	48 8b 40 18          	mov    0x18(%rax),%rax
  800de1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800de5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800de9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800ded:	48 89 cf             	mov    %rcx,%rdi
  800df0:	ff d0                	callq  *%rax
}
  800df2:	c9                   	leaveq 
  800df3:	c3                   	retq   

0000000000800df4 <seek>:

int
seek(int fdnum, off_t offset)
{
  800df4:	55                   	push   %rbp
  800df5:	48 89 e5             	mov    %rsp,%rbp
  800df8:	48 83 ec 18          	sub    $0x18,%rsp
  800dfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800e09:	48 89 d6             	mov    %rdx,%rsi
  800e0c:	89 c7                	mov    %eax,%edi
  800e0e:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	callq  *%rax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e21:	79 05                	jns    800e28 <seek+0x34>
		return r;
  800e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e26:	eb 0f                	jmp    800e37 <seek+0x43>
	fd->fd_offset = offset;
  800e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800e2f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e37:	c9                   	leaveq 
  800e38:	c3                   	retq   

0000000000800e39 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e39:	55                   	push   %rbp
  800e3a:	48 89 e5             	mov    %rsp,%rbp
  800e3d:	48 83 ec 30          	sub    $0x30,%rsp
  800e41:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e44:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e4e:	48 89 d6             	mov    %rdx,%rsi
  800e51:	89 c7                	mov    %eax,%edi
  800e53:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
  800e5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e66:	78 24                	js     800e8c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	8b 00                	mov    (%rax),%eax
  800e6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e72:	48 89 d6             	mov    %rdx,%rsi
  800e75:	89 c7                	mov    %eax,%edi
  800e77:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800e7e:	00 00 00 
  800e81:	ff d0                	callq  *%rax
  800e83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e8a:	79 05                	jns    800e91 <ftruncate+0x58>
		return r;
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8f:	eb 72                	jmp    800f03 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	8b 40 08             	mov    0x8(%rax),%eax
  800e98:	83 e0 03             	and    $0x3,%eax
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 3a                	jne    800ed9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e9f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800ea6:	00 00 00 
  800ea9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800eac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800eb2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800eb5:	89 c6                	mov    %eax,%esi
  800eb7:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  800ebe:	00 00 00 
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	48 b9 83 29 80 00 00 	movabs $0x802983,%rcx
  800ecd:	00 00 00 
  800ed0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800ed2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed7:	eb 2a                	jmp    800f03 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edd:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ee1:	48 85 c0             	test   %rax,%rax
  800ee4:	75 07                	jne    800eed <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800ee6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eeb:	eb 16                	jmp    800f03 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef1:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ef5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800efc:	89 ce                	mov    %ecx,%esi
  800efe:	48 89 d7             	mov    %rdx,%rdi
  800f01:	ff d0                	callq  *%rax
}
  800f03:	c9                   	leaveq 
  800f04:	c3                   	retq   

0000000000800f05 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f05:	55                   	push   %rbp
  800f06:	48 89 e5             	mov    %rsp,%rbp
  800f09:	48 83 ec 30          	sub    $0x30,%rsp
  800f0d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800f10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800f18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800f1b:	48 89 d6             	mov    %rdx,%rsi
  800f1e:	89 c7                	mov    %eax,%edi
  800f20:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f33:	78 24                	js     800f59 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	8b 00                	mov    (%rax),%eax
  800f3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f3f:	48 89 d6             	mov    %rdx,%rsi
  800f42:	89 c7                	mov    %eax,%edi
  800f44:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800f4b:	00 00 00 
  800f4e:	ff d0                	callq  *%rax
  800f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f57:	79 05                	jns    800f5e <fstat+0x59>
		return r;
  800f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f5c:	eb 5e                	jmp    800fbc <fstat+0xb7>
	if (!dev->dev_stat)
  800f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f62:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f66:	48 85 c0             	test   %rax,%rax
  800f69:	75 07                	jne    800f72 <fstat+0x6d>
		return -E_NOT_SUPP;
  800f6b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f70:	eb 4a                	jmp    800fbc <fstat+0xb7>
	stat->st_name[0] = 0;
  800f72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f76:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f7d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f84:	00 00 00 
	stat->st_isdir = 0;
  800f87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f8b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f92:	00 00 00 
	stat->st_dev = dev;
  800f95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f9d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa8:	48 8b 40 28          	mov    0x28(%rax),%rax
  800fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800fb4:	48 89 ce             	mov    %rcx,%rsi
  800fb7:	48 89 d7             	mov    %rdx,%rdi
  800fba:	ff d0                	callq  *%rax
}
  800fbc:	c9                   	leaveq 
  800fbd:	c3                   	retq   

0000000000800fbe <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800fbe:	55                   	push   %rbp
  800fbf:	48 89 e5             	mov    %rsp,%rbp
  800fc2:	48 83 ec 20          	sub    $0x20,%rsp
  800fc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	be 00 00 00 00       	mov    $0x0,%esi
  800fd7:	48 89 c7             	mov    %rax,%rdi
  800fda:	48 b8 ac 10 80 00 00 	movabs $0x8010ac,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fed:	79 05                	jns    800ff4 <stat+0x36>
		return fd;
  800fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff2:	eb 2f                	jmp    801023 <stat+0x65>
	r = fstat(fd, stat);
  800ff4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ffb:	48 89 d6             	mov    %rdx,%rsi
  800ffe:	89 c7                	mov    %eax,%edi
  801000:	48 b8 05 0f 80 00 00 	movabs $0x800f05,%rax
  801007:	00 00 00 
  80100a:	ff d0                	callq  *%rax
  80100c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80100f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801012:	89 c7                	mov    %eax,%edi
  801014:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
	return r;
  801020:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801023:	c9                   	leaveq 
  801024:	c3                   	retq   

0000000000801025 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801025:	55                   	push   %rbp
  801026:	48 89 e5             	mov    %rsp,%rbp
  801029:	48 83 ec 10          	sub    $0x10,%rsp
  80102d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801030:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801034:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80103b:	00 00 00 
  80103e:	8b 00                	mov    (%rax),%eax
  801040:	85 c0                	test   %eax,%eax
  801042:	75 1d                	jne    801061 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801044:	bf 01 00 00 00       	mov    $0x1,%edi
  801049:	48 b8 b2 3e 80 00 00 	movabs $0x803eb2,%rax
  801050:	00 00 00 
  801053:	ff d0                	callq  *%rax
  801055:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80105c:	00 00 00 
  80105f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801061:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801068:	00 00 00 
  80106b:	8b 00                	mov    (%rax),%eax
  80106d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801070:	b9 07 00 00 00       	mov    $0x7,%ecx
  801075:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80107c:	00 00 00 
  80107f:	89 c7                	mov    %eax,%edi
  801081:	48 b8 50 3e 80 00 00 	movabs $0x803e50,%rax
  801088:	00 00 00 
  80108b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80108d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	48 89 c6             	mov    %rax,%rsi
  801099:	bf 00 00 00 00       	mov    $0x0,%edi
  80109e:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  8010a5:	00 00 00 
  8010a8:	ff d0                	callq  *%rax
}
  8010aa:	c9                   	leaveq 
  8010ab:	c3                   	retq   

00000000008010ac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8010ac:	55                   	push   %rbp
  8010ad:	48 89 e5             	mov    %rsp,%rbp
  8010b0:	48 83 ec 30          	sub    $0x30,%rsp
  8010b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8010b8:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8010bb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8010c2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8010c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8010d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010d5:	75 08                	jne    8010df <open+0x33>
	{
		return r;
  8010d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010da:	e9 f2 00 00 00       	jmpq   8011d1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8010df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010e3:	48 89 c7             	mov    %rax,%rdi
  8010e6:	48 b8 cc 34 80 00 00 	movabs $0x8034cc,%rax
  8010ed:	00 00 00 
  8010f0:	ff d0                	callq  *%rax
  8010f2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8010f5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8010fc:	7e 0a                	jle    801108 <open+0x5c>
	{
		return -E_BAD_PATH;
  8010fe:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801103:	e9 c9 00 00 00       	jmpq   8011d1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801108:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80110f:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801110:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801114:	48 89 c7             	mov    %rax,%rdi
  801117:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  80111e:	00 00 00 
  801121:	ff d0                	callq  *%rax
  801123:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801126:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80112a:	78 09                	js     801135 <open+0x89>
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	48 85 c0             	test   %rax,%rax
  801133:	75 08                	jne    80113d <open+0x91>
		{
			return r;
  801135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801138:	e9 94 00 00 00       	jmpq   8011d1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80113d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801141:	ba 00 04 00 00       	mov    $0x400,%edx
  801146:	48 89 c6             	mov    %rax,%rsi
  801149:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801150:	00 00 00 
  801153:	48 b8 ca 35 80 00 00 	movabs $0x8035ca,%rax
  80115a:	00 00 00 
  80115d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80115f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801166:	00 00 00 
  801169:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80116c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801176:	48 89 c6             	mov    %rax,%rsi
  801179:	bf 01 00 00 00       	mov    $0x1,%edi
  80117e:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
  80118a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80118d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801191:	79 2b                	jns    8011be <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801197:	be 00 00 00 00       	mov    $0x0,%esi
  80119c:	48 89 c7             	mov    %rax,%rdi
  80119f:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  8011a6:	00 00 00 
  8011a9:	ff d0                	callq  *%rax
  8011ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8011ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8011b2:	79 05                	jns    8011b9 <open+0x10d>
			{
				return d;
  8011b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011b7:	eb 18                	jmp    8011d1 <open+0x125>
			}
			return r;
  8011b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011bc:	eb 13                	jmp    8011d1 <open+0x125>
		}	
		return fd2num(fd_store);
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	48 89 c7             	mov    %rax,%rdi
  8011c5:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8011cc:	00 00 00 
  8011cf:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8011d1:	c9                   	leaveq 
  8011d2:	c3                   	retq   

00000000008011d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8011d3:	55                   	push   %rbp
  8011d4:	48 89 e5             	mov    %rsp,%rbp
  8011d7:	48 83 ec 10          	sub    $0x10,%rsp
  8011db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8011df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8011e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011ed:	00 00 00 
  8011f0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8011f2:	be 00 00 00 00       	mov    $0x0,%esi
  8011f7:	bf 06 00 00 00       	mov    $0x6,%edi
  8011fc:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  801203:	00 00 00 
  801206:	ff d0                	callq  *%rax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 83 ec 30          	sub    $0x30,%rsp
  801212:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801216:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801225:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122a:	74 07                	je     801233 <devfile_read+0x29>
  80122c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801231:	75 07                	jne    80123a <devfile_read+0x30>
		return -E_INVAL;
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb 77                	jmp    8012b1 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80123a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123e:	8b 50 0c             	mov    0xc(%rax),%edx
  801241:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801248:	00 00 00 
  80124b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80124d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801254:	00 00 00 
  801257:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80125b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80125f:	be 00 00 00 00       	mov    $0x0,%esi
  801264:	bf 03 00 00 00       	mov    $0x3,%edi
  801269:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  801270:	00 00 00 
  801273:	ff d0                	callq  *%rax
  801275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80127c:	7f 05                	jg     801283 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80127e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801281:	eb 2e                	jmp    8012b1 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801286:	48 63 d0             	movslq %eax,%rdx
  801289:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801294:	00 00 00 
  801297:	48 89 c7             	mov    %rax,%rdi
  80129a:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  8012a1:	00 00 00 
  8012a4:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8012a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8012ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 30          	sub    $0x30,%rsp
  8012bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8012c7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8012ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d3:	74 07                	je     8012dc <devfile_write+0x29>
  8012d5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012da:	75 08                	jne    8012e4 <devfile_write+0x31>
		return r;
  8012dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012df:	e9 9a 00 00 00       	jmpq   80137e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8012eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012f2:	00 00 00 
  8012f5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8012f7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8012fe:	00 
  8012ff:	76 08                	jbe    801309 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801301:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801308:	00 
	}
	fsipcbuf.write.req_n = n;
  801309:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801310:	00 00 00 
  801313:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801317:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80131b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80131f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801323:	48 89 c6             	mov    %rax,%rsi
  801326:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80132d:	00 00 00 
  801330:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80133c:	be 00 00 00 00       	mov    $0x0,%esi
  801341:	bf 04 00 00 00       	mov    $0x4,%edi
  801346:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  80134d:	00 00 00 
  801350:	ff d0                	callq  *%rax
  801352:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801355:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801359:	7f 20                	jg     80137b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80135b:	48 bf 76 40 80 00 00 	movabs $0x804076,%rdi
  801362:	00 00 00 
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  801371:	00 00 00 
  801374:	ff d2                	callq  *%rdx
		return r;
  801376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801379:	eb 03                	jmp    80137e <devfile_write+0xcb>
	}
	return r;
  80137b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 20          	sub    $0x20,%rsp
  801388:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801394:	8b 50 0c             	mov    0xc(%rax),%edx
  801397:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80139e:	00 00 00 
  8013a1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013a3:	be 00 00 00 00       	mov    $0x0,%esi
  8013a8:	bf 05 00 00 00       	mov    $0x5,%edi
  8013ad:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	callq  *%rax
  8013b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013c0:	79 05                	jns    8013c7 <devfile_stat+0x47>
		return r;
  8013c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c5:	eb 56                	jmp    80141d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8013d2:	00 00 00 
  8013d5:	48 89 c7             	mov    %rax,%rdi
  8013d8:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  8013df:	00 00 00 
  8013e2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8013e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013eb:	00 00 00 
  8013ee:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8013f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013fe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801405:	00 00 00 
  801408:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80140e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801412:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141d:	c9                   	leaveq 
  80141e:	c3                   	retq   

000000000080141f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80141f:	55                   	push   %rbp
  801420:	48 89 e5             	mov    %rsp,%rbp
  801423:	48 83 ec 10          	sub    $0x10,%rsp
  801427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	8b 50 0c             	mov    0xc(%rax),%edx
  801435:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80143c:	00 00 00 
  80143f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801441:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801448:	00 00 00 
  80144b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80144e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801451:	be 00 00 00 00       	mov    $0x0,%esi
  801456:	bf 02 00 00 00       	mov    $0x2,%edi
  80145b:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  801462:	00 00 00 
  801465:	ff d0                	callq  *%rax
}
  801467:	c9                   	leaveq 
  801468:	c3                   	retq   

0000000000801469 <remove>:

// Delete a file
int
remove(const char *path)
{
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	48 83 ec 10          	sub    $0x10,%rsp
  801471:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	48 89 c7             	mov    %rax,%rdi
  80147c:	48 b8 cc 34 80 00 00 	movabs $0x8034cc,%rax
  801483:	00 00 00 
  801486:	ff d0                	callq  *%rax
  801488:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80148d:	7e 07                	jle    801496 <remove+0x2d>
		return -E_BAD_PATH;
  80148f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801494:	eb 33                	jmp    8014c9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	48 89 c6             	mov    %rax,%rsi
  80149d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8014a4:	00 00 00 
  8014a7:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  8014ae:	00 00 00 
  8014b1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8014b3:	be 00 00 00 00       	mov    $0x0,%esi
  8014b8:	bf 07 00 00 00       	mov    $0x7,%edi
  8014bd:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  8014c4:	00 00 00 
  8014c7:	ff d0                	callq  *%rax
}
  8014c9:	c9                   	leaveq 
  8014ca:	c3                   	retq   

00000000008014cb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8014cf:	be 00 00 00 00       	mov    $0x0,%esi
  8014d4:	bf 08 00 00 00       	mov    $0x8,%edi
  8014d9:	48 b8 25 10 80 00 00 	movabs $0x801025,%rax
  8014e0:	00 00 00 
  8014e3:	ff d0                	callq  *%rax
}
  8014e5:	5d                   	pop    %rbp
  8014e6:	c3                   	retq   

00000000008014e7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8014f2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8014f9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801500:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801507:	be 00 00 00 00       	mov    $0x0,%esi
  80150c:	48 89 c7             	mov    %rax,%rdi
  80150f:	48 b8 ac 10 80 00 00 	movabs $0x8010ac,%rax
  801516:	00 00 00 
  801519:	ff d0                	callq  *%rax
  80151b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80151e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801522:	79 28                	jns    80154c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801527:	89 c6                	mov    %eax,%esi
  801529:	48 bf 92 40 80 00 00 	movabs $0x804092,%rdi
  801530:	00 00 00 
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
  801538:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  80153f:	00 00 00 
  801542:	ff d2                	callq  *%rdx
		return fd_src;
  801544:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801547:	e9 74 01 00 00       	jmpq   8016c0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80154c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801553:	be 01 01 00 00       	mov    $0x101,%esi
  801558:	48 89 c7             	mov    %rax,%rdi
  80155b:	48 b8 ac 10 80 00 00 	movabs $0x8010ac,%rax
  801562:	00 00 00 
  801565:	ff d0                	callq  *%rax
  801567:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80156a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80156e:	79 39                	jns    8015a9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801570:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801573:	89 c6                	mov    %eax,%esi
  801575:	48 bf a8 40 80 00 00 	movabs $0x8040a8,%rdi
  80157c:	00 00 00 
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  80158b:	00 00 00 
  80158e:	ff d2                	callq  *%rdx
		close(fd_src);
  801590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801593:	89 c7                	mov    %eax,%edi
  801595:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  80159c:	00 00 00 
  80159f:	ff d0                	callq  *%rax
		return fd_dest;
  8015a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015a4:	e9 17 01 00 00       	jmpq   8016c0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8015a9:	eb 74                	jmp    80161f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8015ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ae:	48 63 d0             	movslq %eax,%rdx
  8015b1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8015b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015bb:	48 89 ce             	mov    %rcx,%rsi
  8015be:	89 c7                	mov    %eax,%edi
  8015c0:	48 b8 20 0d 80 00 00 	movabs $0x800d20,%rax
  8015c7:	00 00 00 
  8015ca:	ff d0                	callq  *%rax
  8015cc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8015cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015d3:	79 4a                	jns    80161f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8015d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015d8:	89 c6                	mov    %eax,%esi
  8015da:	48 bf c2 40 80 00 00 	movabs $0x8040c2,%rdi
  8015e1:	00 00 00 
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e9:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  8015f0:	00 00 00 
  8015f3:	ff d2                	callq  *%rdx
			close(fd_src);
  8015f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f8:	89 c7                	mov    %eax,%edi
  8015fa:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  801601:	00 00 00 
  801604:	ff d0                	callq  *%rax
			close(fd_dest);
  801606:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801609:	89 c7                	mov    %eax,%edi
  80160b:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  801612:	00 00 00 
  801615:	ff d0                	callq  *%rax
			return write_size;
  801617:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80161a:	e9 a1 00 00 00       	jmpq   8016c0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80161f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801629:	ba 00 02 00 00       	mov    $0x200,%edx
  80162e:	48 89 ce             	mov    %rcx,%rsi
  801631:	89 c7                	mov    %eax,%edi
  801633:	48 b8 d6 0b 80 00 00 	movabs $0x800bd6,%rax
  80163a:	00 00 00 
  80163d:	ff d0                	callq  *%rax
  80163f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801642:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801646:	0f 8f 5f ff ff ff    	jg     8015ab <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80164c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801650:	79 47                	jns    801699 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801652:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801655:	89 c6                	mov    %eax,%esi
  801657:	48 bf d5 40 80 00 00 	movabs $0x8040d5,%rdi
  80165e:	00 00 00 
  801661:	b8 00 00 00 00       	mov    $0x0,%eax
  801666:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  80166d:	00 00 00 
  801670:	ff d2                	callq  *%rdx
		close(fd_src);
  801672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801675:	89 c7                	mov    %eax,%edi
  801677:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  80167e:	00 00 00 
  801681:	ff d0                	callq  *%rax
		close(fd_dest);
  801683:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801686:	89 c7                	mov    %eax,%edi
  801688:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
		return read_size;
  801694:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801697:	eb 27                	jmp    8016c0 <copy+0x1d9>
	}
	close(fd_src);
  801699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80169c:	89 c7                	mov    %eax,%edi
  80169e:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
	close(fd_dest);
  8016aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016ad:	89 c7                	mov    %eax,%edi
  8016af:	48 b8 b4 09 80 00 00 	movabs $0x8009b4,%rax
  8016b6:	00 00 00 
  8016b9:	ff d0                	callq  *%rax
	return 0;
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8016c0:	c9                   	leaveq 
  8016c1:	c3                   	retq   

00000000008016c2 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8016c2:	55                   	push   %rbp
  8016c3:	48 89 e5             	mov    %rsp,%rbp
  8016c6:	48 83 ec 20          	sub    $0x20,%rsp
  8016ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d4:	48 89 d6             	mov    %rdx,%rsi
  8016d7:	89 c7                	mov    %eax,%edi
  8016d9:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
  8016e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ec:	79 05                	jns    8016f3 <fd2sockid+0x31>
		return r;
  8016ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016f1:	eb 24                	jmp    801717 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	8b 10                	mov    (%rax),%edx
  8016f9:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801700:	00 00 00 
  801703:	8b 00                	mov    (%rax),%eax
  801705:	39 c2                	cmp    %eax,%edx
  801707:	74 07                	je     801710 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801709:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80170e:	eb 07                	jmp    801717 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801714:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 20          	sub    $0x20,%rsp
  801721:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801724:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801728:	48 89 c7             	mov    %rax,%rdi
  80172b:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  801732:	00 00 00 
  801735:	ff d0                	callq  *%rax
  801737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80173a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173e:	78 26                	js     801766 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801744:	ba 07 04 00 00       	mov    $0x407,%edx
  801749:	48 89 c6             	mov    %rax,%rsi
  80174c:	bf 00 00 00 00       	mov    $0x0,%edi
  801751:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801758:	00 00 00 
  80175b:	ff d0                	callq  *%rax
  80175d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801764:	79 16                	jns    80177c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801766:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801769:	89 c7                	mov    %eax,%edi
  80176b:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  801772:	00 00 00 
  801775:	ff d0                	callq  *%rax
		return r;
  801777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80177a:	eb 3a                	jmp    8017b6 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80177c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801780:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801787:	00 00 00 
  80178a:	8b 12                	mov    (%rdx),%edx
  80178c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80178e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801792:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8017a0:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8017a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a7:	48 89 c7             	mov    %rax,%rdi
  8017aa:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8017b1:	00 00 00 
  8017b4:	ff d0                	callq  *%rax
}
  8017b6:	c9                   	leaveq 
  8017b7:	c3                   	retq   

00000000008017b8 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017b8:	55                   	push   %rbp
  8017b9:	48 89 e5             	mov    %rsp,%rbp
  8017bc:	48 83 ec 30          	sub    $0x30,%rsp
  8017c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ce:	89 c7                	mov    %eax,%edi
  8017d0:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
  8017dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e3:	79 05                	jns    8017ea <accept+0x32>
		return r;
  8017e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e8:	eb 3b                	jmp    801825 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f5:	48 89 ce             	mov    %rcx,%rsi
  8017f8:	89 c7                	mov    %eax,%edi
  8017fa:	48 b8 03 1b 80 00 00 	movabs $0x801b03,%rax
  801801:	00 00 00 
  801804:	ff d0                	callq  *%rax
  801806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80180d:	79 05                	jns    801814 <accept+0x5c>
		return r;
  80180f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801812:	eb 11                	jmp    801825 <accept+0x6d>
	return alloc_sockfd(r);
  801814:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801817:	89 c7                	mov    %eax,%edi
  801819:	48 b8 19 17 80 00 00 	movabs $0x801719,%rax
  801820:	00 00 00 
  801823:	ff d0                	callq  *%rax
}
  801825:	c9                   	leaveq 
  801826:	c3                   	retq   

0000000000801827 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801827:	55                   	push   %rbp
  801828:	48 89 e5             	mov    %rsp,%rbp
  80182b:	48 83 ec 20          	sub    $0x20,%rsp
  80182f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801832:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801836:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801839:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183c:	89 c7                	mov    %eax,%edi
  80183e:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  801845:	00 00 00 
  801848:	ff d0                	callq  *%rax
  80184a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80184d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801851:	79 05                	jns    801858 <bind+0x31>
		return r;
  801853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801856:	eb 1b                	jmp    801873 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801858:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80185b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80185f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801862:	48 89 ce             	mov    %rcx,%rsi
  801865:	89 c7                	mov    %eax,%edi
  801867:	48 b8 82 1b 80 00 00 	movabs $0x801b82,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
}
  801873:	c9                   	leaveq 
  801874:	c3                   	retq   

0000000000801875 <shutdown>:

int
shutdown(int s, int how)
{
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	48 83 ec 20          	sub    $0x20,%rsp
  80187d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801880:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801883:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801886:	89 c7                	mov    %eax,%edi
  801888:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
  801894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189b:	79 05                	jns    8018a2 <shutdown+0x2d>
		return r;
  80189d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a0:	eb 16                	jmp    8018b8 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8018a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a8:	89 d6                	mov    %edx,%esi
  8018aa:	89 c7                	mov    %eax,%edi
  8018ac:	48 b8 e6 1b 80 00 00 	movabs $0x801be6,%rax
  8018b3:	00 00 00 
  8018b6:	ff d0                	callq  *%rax
}
  8018b8:	c9                   	leaveq 
  8018b9:	c3                   	retq   

00000000008018ba <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 10          	sub    $0x10,%rsp
  8018c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8018c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ca:	48 89 c7             	mov    %rax,%rdi
  8018cd:	48 b8 34 3f 80 00 00 	movabs $0x803f34,%rax
  8018d4:	00 00 00 
  8018d7:	ff d0                	callq  *%rax
  8018d9:	83 f8 01             	cmp    $0x1,%eax
  8018dc:	75 17                	jne    8018f5 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8018de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e2:	8b 40 0c             	mov    0xc(%rax),%eax
  8018e5:	89 c7                	mov    %eax,%edi
  8018e7:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  8018ee:	00 00 00 
  8018f1:	ff d0                	callq  *%rax
  8018f3:	eb 05                	jmp    8018fa <devsock_close+0x40>
	else
		return 0;
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 20          	sub    $0x20,%rsp
  801904:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801907:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80190b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80190e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801911:	89 c7                	mov    %eax,%edi
  801913:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
  80191f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801926:	79 05                	jns    80192d <connect+0x31>
		return r;
  801928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192b:	eb 1b                	jmp    801948 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80192d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801930:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801937:	48 89 ce             	mov    %rcx,%rsi
  80193a:	89 c7                	mov    %eax,%edi
  80193c:	48 b8 53 1c 80 00 00 	movabs $0x801c53,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <listen>:

int
listen(int s, int backlog)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	48 83 ec 20          	sub    $0x20,%rsp
  801952:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801955:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801958:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80195b:	89 c7                	mov    %eax,%edi
  80195d:	48 b8 c2 16 80 00 00 	movabs $0x8016c2,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
  801969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80196c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801970:	79 05                	jns    801977 <listen+0x2d>
		return r;
  801972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801975:	eb 16                	jmp    80198d <listen+0x43>
	return nsipc_listen(r, backlog);
  801977:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80197a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197d:	89 d6                	mov    %edx,%esi
  80197f:	89 c7                	mov    %eax,%edi
  801981:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  801988:	00 00 00 
  80198b:	ff d0                	callq  *%rax
}
  80198d:	c9                   	leaveq 
  80198e:	c3                   	retq   

000000000080198f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80198f:	55                   	push   %rbp
  801990:	48 89 e5             	mov    %rsp,%rbp
  801993:	48 83 ec 20          	sub    $0x20,%rsp
  801997:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80199b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a7:	89 c2                	mov    %eax,%edx
  8019a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ad:	8b 40 0c             	mov    0xc(%rax),%eax
  8019b0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8019b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b9:	89 c7                	mov    %eax,%edi
  8019bb:	48 b8 f7 1c 80 00 00 	movabs $0x801cf7,%rax
  8019c2:	00 00 00 
  8019c5:	ff d0                	callq  *%rax
}
  8019c7:	c9                   	leaveq 
  8019c8:	c3                   	retq   

00000000008019c9 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c9:	55                   	push   %rbp
  8019ca:	48 89 e5             	mov    %rsp,%rbp
  8019cd:	48 83 ec 20          	sub    $0x20,%rsp
  8019d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e7:	8b 40 0c             	mov    0xc(%rax),%eax
  8019ea:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8019ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f3:	89 c7                	mov    %eax,%edi
  8019f5:	48 b8 c3 1d 80 00 00 	movabs $0x801dc3,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 10          	sub    $0x10,%rsp
  801a0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a17:	48 be f0 40 80 00 00 	movabs $0x8040f0,%rsi
  801a1e:	00 00 00 
  801a21:	48 89 c7             	mov    %rax,%rdi
  801a24:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
	return 0;
  801a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 20          	sub    $0x20,%rsp
  801a3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a42:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801a45:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a48:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801a4b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801a4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a51:	89 ce                	mov    %ecx,%esi
  801a53:	89 c7                	mov    %eax,%edi
  801a55:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  801a5c:	00 00 00 
  801a5f:	ff d0                	callq  *%rax
  801a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a68:	79 05                	jns    801a6f <socket+0x38>
		return r;
  801a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6d:	eb 11                	jmp    801a80 <socket+0x49>
	return alloc_sockfd(r);
  801a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a72:	89 c7                	mov    %eax,%edi
  801a74:	48 b8 19 17 80 00 00 	movabs $0x801719,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a8d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a94:	00 00 00 
  801a97:	8b 00                	mov    (%rax),%eax
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	75 1d                	jne    801aba <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a9d:	bf 02 00 00 00       	mov    $0x2,%edi
  801aa2:	48 b8 b2 3e 80 00 00 	movabs $0x803eb2,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
  801aae:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801ab5:	00 00 00 
  801ab8:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aba:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801ac1:	00 00 00 
  801ac4:	8b 00                	mov    (%rax),%eax
  801ac6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ac9:	b9 07 00 00 00       	mov    $0x7,%ecx
  801ace:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801ad5:	00 00 00 
  801ad8:	89 c7                	mov    %eax,%edi
  801ada:	48 b8 50 3e 80 00 00 	movabs $0x803e50,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aeb:	be 00 00 00 00       	mov    $0x0,%esi
  801af0:	bf 00 00 00 00       	mov    $0x0,%edi
  801af5:	48 b8 4a 3d 80 00 00 	movabs $0x803d4a,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	callq  *%rax
}
  801b01:	c9                   	leaveq 
  801b02:	c3                   	retq   

0000000000801b03 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b03:	55                   	push   %rbp
  801b04:	48 89 e5             	mov    %rsp,%rbp
  801b07:	48 83 ec 30          	sub    $0x30,%rsp
  801b0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b12:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801b16:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b1d:	00 00 00 
  801b20:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801b23:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b25:	bf 01 00 00 00       	mov    $0x1,%edi
  801b2a:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
  801b36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b3d:	78 3e                	js     801b7d <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801b3f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b46:	00 00 00 
  801b49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b51:	8b 40 10             	mov    0x10(%rax),%eax
  801b54:	89 c2                	mov    %eax,%edx
  801b56:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b5e:	48 89 ce             	mov    %rcx,%rsi
  801b61:	48 89 c7             	mov    %rax,%rdi
  801b64:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b74:	8b 50 10             	mov    0x10(%rax),%edx
  801b77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b7b:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b80:	c9                   	leaveq 
  801b81:	c3                   	retq   

0000000000801b82 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b82:	55                   	push   %rbp
  801b83:	48 89 e5             	mov    %rsp,%rbp
  801b86:	48 83 ec 10          	sub    $0x10,%rsp
  801b8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b91:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b94:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b9b:	00 00 00 
  801b9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ba1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ba3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801baa:	48 89 c6             	mov    %rax,%rsi
  801bad:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801bb4:	00 00 00 
  801bb7:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801bc3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bca:	00 00 00 
  801bcd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801bd0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801bd3:	bf 02 00 00 00       	mov    $0x2,%edi
  801bd8:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 10          	sub    $0x10,%rsp
  801bee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801bf4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bfb:	00 00 00 
  801bfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c01:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801c03:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c0a:	00 00 00 
  801c0d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c10:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801c13:	bf 03 00 00 00       	mov    $0x3,%edi
  801c18:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <nsipc_close>:

int
nsipc_close(int s)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	48 83 ec 10          	sub    $0x10,%rsp
  801c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801c31:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c38:	00 00 00 
  801c3b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c3e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801c40:	bf 04 00 00 00       	mov    $0x4,%edi
  801c45:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	callq  *%rax
}
  801c51:	c9                   	leaveq 
  801c52:	c3                   	retq   

0000000000801c53 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c53:	55                   	push   %rbp
  801c54:	48 89 e5             	mov    %rsp,%rbp
  801c57:	48 83 ec 10          	sub    $0x10,%rsp
  801c5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c62:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801c65:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c6c:	00 00 00 
  801c6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c72:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7b:	48 89 c6             	mov    %rax,%rsi
  801c7e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801c85:	00 00 00 
  801c88:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c94:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c9b:	00 00 00 
  801c9e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ca1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801ca4:	bf 05 00 00 00       	mov    $0x5,%edi
  801ca9:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 10          	sub    $0x10,%rsp
  801cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801cc5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ccc:	00 00 00 
  801ccf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cd2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801cd4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cdb:	00 00 00 
  801cde:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ce1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801ce4:	bf 06 00 00 00       	mov    $0x6,%edi
  801ce9:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
}
  801cf5:	c9                   	leaveq 
  801cf6:	c3                   	retq   

0000000000801cf7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cf7:	55                   	push   %rbp
  801cf8:	48 89 e5             	mov    %rsp,%rbp
  801cfb:	48 83 ec 30          	sub    $0x30,%rsp
  801cff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d06:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801d09:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801d0c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d13:	00 00 00 
  801d16:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d19:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801d1b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d22:	00 00 00 
  801d25:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d28:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801d2b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d32:	00 00 00 
  801d35:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d38:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d3b:	bf 07 00 00 00       	mov    $0x7,%edi
  801d40:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
  801d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d53:	78 69                	js     801dbe <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801d55:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801d5c:	7f 08                	jg     801d66 <nsipc_recv+0x6f>
  801d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d61:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801d64:	7e 35                	jle    801d9b <nsipc_recv+0xa4>
  801d66:	48 b9 f7 40 80 00 00 	movabs $0x8040f7,%rcx
  801d6d:	00 00 00 
  801d70:	48 ba 0c 41 80 00 00 	movabs $0x80410c,%rdx
  801d77:	00 00 00 
  801d7a:	be 61 00 00 00       	mov    $0x61,%esi
  801d7f:	48 bf 21 41 80 00 00 	movabs $0x804121,%rdi
  801d86:	00 00 00 
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	49 b8 4a 27 80 00 00 	movabs $0x80274a,%r8
  801d95:	00 00 00 
  801d98:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9e:	48 63 d0             	movslq %eax,%rdx
  801da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801da5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801dac:	00 00 00 
  801daf:	48 89 c7             	mov    %rax,%rdi
  801db2:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
	}

	return r;
  801dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dc1:	c9                   	leaveq 
  801dc2:	c3                   	retq   

0000000000801dc3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dc3:	55                   	push   %rbp
  801dc4:	48 89 e5             	mov    %rsp,%rbp
  801dc7:	48 83 ec 20          	sub    $0x20,%rsp
  801dcb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dd5:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801dd8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ddf:	00 00 00 
  801de2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801de5:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801de7:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801dee:	7e 35                	jle    801e25 <nsipc_send+0x62>
  801df0:	48 b9 2d 41 80 00 00 	movabs $0x80412d,%rcx
  801df7:	00 00 00 
  801dfa:	48 ba 0c 41 80 00 00 	movabs $0x80410c,%rdx
  801e01:	00 00 00 
  801e04:	be 6c 00 00 00       	mov    $0x6c,%esi
  801e09:	48 bf 21 41 80 00 00 	movabs $0x804121,%rdi
  801e10:	00 00 00 
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
  801e18:	49 b8 4a 27 80 00 00 	movabs $0x80274a,%r8
  801e1f:	00 00 00 
  801e22:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e28:	48 63 d0             	movslq %eax,%rdx
  801e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2f:	48 89 c6             	mov    %rax,%rsi
  801e32:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801e39:	00 00 00 
  801e3c:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801e48:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e4f:	00 00 00 
  801e52:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e55:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801e58:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e5f:	00 00 00 
  801e62:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e65:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801e68:	bf 08 00 00 00       	mov    $0x8,%edi
  801e6d:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
}
  801e79:	c9                   	leaveq 
  801e7a:	c3                   	retq   

0000000000801e7b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 10          	sub    $0x10,%rsp
  801e83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e86:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801e89:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e8c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e93:	00 00 00 
  801e96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e99:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e9b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ea2:	00 00 00 
  801ea5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ea8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801eab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801eb2:	00 00 00 
  801eb5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801eb8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801ebb:	bf 09 00 00 00       	mov    $0x9,%edi
  801ec0:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	callq  *%rax
}
  801ecc:	c9                   	leaveq 
  801ecd:	c3                   	retq   

0000000000801ece <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ece:	55                   	push   %rbp
  801ecf:	48 89 e5             	mov    %rsp,%rbp
  801ed2:	53                   	push   %rbx
  801ed3:	48 83 ec 38          	sub    $0x38,%rsp
  801ed7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801edb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801edf:	48 89 c7             	mov    %rax,%rdi
  801ee2:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
  801eee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef5:	0f 88 bf 01 00 00    	js     8020ba <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eff:	ba 07 04 00 00       	mov    $0x407,%edx
  801f04:	48 89 c6             	mov    %rax,%rsi
  801f07:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0c:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f1f:	0f 88 95 01 00 00    	js     8020ba <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f25:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f29:	48 89 c7             	mov    %rax,%rdi
  801f2c:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  801f33:	00 00 00 
  801f36:	ff d0                	callq  *%rax
  801f38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f3f:	0f 88 5d 01 00 00    	js     8020a2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f49:	ba 07 04 00 00       	mov    $0x407,%edx
  801f4e:	48 89 c6             	mov    %rax,%rsi
  801f51:	bf 00 00 00 00       	mov    $0x0,%edi
  801f56:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
  801f62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f69:	0f 88 33 01 00 00    	js     8020a2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f73:	48 89 c7             	mov    %rax,%rdi
  801f76:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	callq  *%rax
  801f82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8a:	ba 07 04 00 00       	mov    $0x407,%edx
  801f8f:	48 89 c6             	mov    %rax,%rsi
  801f92:	bf 00 00 00 00       	mov    $0x0,%edi
  801f97:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801faa:	79 05                	jns    801fb1 <pipe+0xe3>
		goto err2;
  801fac:	e9 d9 00 00 00       	jmpq   80208a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb5:	48 89 c7             	mov    %rax,%rdi
  801fb8:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
  801fc4:	48 89 c2             	mov    %rax,%rdx
  801fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801fd1:	48 89 d1             	mov    %rdx,%rcx
  801fd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd9:	48 89 c6             	mov    %rax,%rsi
  801fdc:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe1:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  801fe8:	00 00 00 
  801feb:	ff d0                	callq  *%rax
  801fed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ff0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ff4:	79 1b                	jns    802011 <pipe+0x143>
		goto err3;
  801ff6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801ff7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ffb:	48 89 c6             	mov    %rax,%rsi
  801ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  802003:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
  80200f:	eb 79                	jmp    80208a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802015:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80201c:	00 00 00 
  80201f:	8b 12                	mov    (%rdx),%edx
  802021:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802023:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802027:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80202e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802032:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802039:	00 00 00 
  80203c:	8b 12                	mov    (%rdx),%edx
  80203e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802040:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802044:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80204b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204f:	48 89 c7             	mov    %rax,%rdi
  802052:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  802059:	00 00 00 
  80205c:	ff d0                	callq  *%rax
  80205e:	89 c2                	mov    %eax,%edx
  802060:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802064:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802066:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80206a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80206e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802072:	48 89 c7             	mov    %rax,%rdi
  802075:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 03                	mov    %eax,(%rbx)
	return 0;
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	eb 33                	jmp    8020bd <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80208a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80208e:	48 89 c6             	mov    %rax,%rsi
  802091:	bf 00 00 00 00       	mov    $0x0,%edi
  802096:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8020a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a6:	48 89 c6             	mov    %rax,%rsi
  8020a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ae:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8020b5:	00 00 00 
  8020b8:	ff d0                	callq  *%rax
err:
	return r;
  8020ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8020bd:	48 83 c4 38          	add    $0x38,%rsp
  8020c1:	5b                   	pop    %rbx
  8020c2:	5d                   	pop    %rbp
  8020c3:	c3                   	retq   

00000000008020c4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020c4:	55                   	push   %rbp
  8020c5:	48 89 e5             	mov    %rsp,%rbp
  8020c8:	53                   	push   %rbx
  8020c9:	48 83 ec 28          	sub    $0x28,%rsp
  8020cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020dc:	00 00 00 
  8020df:	48 8b 00             	mov    (%rax),%rax
  8020e2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8020eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ef:	48 89 c7             	mov    %rax,%rdi
  8020f2:	48 b8 34 3f 80 00 00 	movabs $0x803f34,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
  8020fe:	89 c3                	mov    %eax,%ebx
  802100:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802104:	48 89 c7             	mov    %rax,%rdi
  802107:	48 b8 34 3f 80 00 00 	movabs $0x803f34,%rax
  80210e:	00 00 00 
  802111:	ff d0                	callq  *%rax
  802113:	39 c3                	cmp    %eax,%ebx
  802115:	0f 94 c0             	sete   %al
  802118:	0f b6 c0             	movzbl %al,%eax
  80211b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80211e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802125:	00 00 00 
  802128:	48 8b 00             	mov    (%rax),%rax
  80212b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802131:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802134:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802137:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80213a:	75 05                	jne    802141 <_pipeisclosed+0x7d>
			return ret;
  80213c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80213f:	eb 4f                	jmp    802190 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802141:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802144:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802147:	74 42                	je     80218b <_pipeisclosed+0xc7>
  802149:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80214d:	75 3c                	jne    80218b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80214f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802156:	00 00 00 
  802159:	48 8b 00             	mov    (%rax),%rax
  80215c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802162:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802165:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802168:	89 c6                	mov    %eax,%esi
  80216a:	48 bf 3e 41 80 00 00 	movabs $0x80413e,%rdi
  802171:	00 00 00 
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	49 b8 83 29 80 00 00 	movabs $0x802983,%r8
  802180:	00 00 00 
  802183:	41 ff d0             	callq  *%r8
	}
  802186:	e9 4a ff ff ff       	jmpq   8020d5 <_pipeisclosed+0x11>
  80218b:	e9 45 ff ff ff       	jmpq   8020d5 <_pipeisclosed+0x11>
}
  802190:	48 83 c4 28          	add    $0x28,%rsp
  802194:	5b                   	pop    %rbx
  802195:	5d                   	pop    %rbp
  802196:	c3                   	retq   

0000000000802197 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802197:	55                   	push   %rbp
  802198:	48 89 e5             	mov    %rsp,%rbp
  80219b:	48 83 ec 30          	sub    $0x30,%rsp
  80219f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a9:	48 89 d6             	mov    %rdx,%rsi
  8021ac:	89 c7                	mov    %eax,%edi
  8021ae:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
  8021ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c1:	79 05                	jns    8021c8 <pipeisclosed+0x31>
		return r;
  8021c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c6:	eb 31                	jmp    8021f9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	48 89 c7             	mov    %rax,%rdi
  8021cf:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	callq  *%rax
  8021db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8021df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e7:	48 89 d6             	mov    %rdx,%rsi
  8021ea:	48 89 c7             	mov    %rax,%rdi
  8021ed:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
}
  8021f9:	c9                   	leaveq 
  8021fa:	c3                   	retq   

00000000008021fb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021fb:	55                   	push   %rbp
  8021fc:	48 89 e5             	mov    %rsp,%rbp
  8021ff:	48 83 ec 40          	sub    $0x40,%rsp
  802203:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802207:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80220b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80220f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802213:	48 89 c7             	mov    %rax,%rdi
  802216:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802226:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80222a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80222e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802235:	00 
  802236:	e9 92 00 00 00       	jmpq   8022cd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80223b:	eb 41                	jmp    80227e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80223d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802242:	74 09                	je     80224d <devpipe_read+0x52>
				return i;
  802244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802248:	e9 92 00 00 00       	jmpq   8022df <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80224d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802251:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802255:	48 89 d6             	mov    %rdx,%rsi
  802258:	48 89 c7             	mov    %rax,%rdi
  80225b:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802262:	00 00 00 
  802265:	ff d0                	callq  *%rax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 07                	je     802272 <devpipe_read+0x77>
				return 0;
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	eb 6d                	jmp    8022df <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802272:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80227e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802282:	8b 10                	mov    (%rax),%edx
  802284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802288:	8b 40 04             	mov    0x4(%rax),%eax
  80228b:	39 c2                	cmp    %eax,%edx
  80228d:	74 ae                	je     80223d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80228f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802293:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802297:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80229b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229f:	8b 00                	mov    (%rax),%eax
  8022a1:	99                   	cltd   
  8022a2:	c1 ea 1b             	shr    $0x1b,%edx
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	83 e0 1f             	and    $0x1f,%eax
  8022aa:	29 d0                	sub    %edx,%eax
  8022ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b0:	48 98                	cltq   
  8022b2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8022b7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8022b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022bd:	8b 00                	mov    (%rax),%eax
  8022bf:	8d 50 01             	lea    0x1(%rax),%edx
  8022c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8022d5:	0f 82 60 ff ff ff    	jb     80223b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022df:	c9                   	leaveq 
  8022e0:	c3                   	retq   

00000000008022e1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022e1:	55                   	push   %rbp
  8022e2:	48 89 e5             	mov    %rsp,%rbp
  8022e5:	48 83 ec 40          	sub    $0x40,%rsp
  8022e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f9:	48 89 c7             	mov    %rax,%rdi
  8022fc:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
  802308:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80230c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802310:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802314:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80231b:	00 
  80231c:	e9 8e 00 00 00       	jmpq   8023af <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802321:	eb 31                	jmp    802354 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232b:	48 89 d6             	mov    %rdx,%rsi
  80232e:	48 89 c7             	mov    %rax,%rdi
  802331:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802338:	00 00 00 
  80233b:	ff d0                	callq  *%rax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 07                	je     802348 <devpipe_write+0x67>
				return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	eb 79                	jmp    8023c1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802348:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802358:	8b 40 04             	mov    0x4(%rax),%eax
  80235b:	48 63 d0             	movslq %eax,%rdx
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	8b 00                	mov    (%rax),%eax
  802364:	48 98                	cltq   
  802366:	48 83 c0 20          	add    $0x20,%rax
  80236a:	48 39 c2             	cmp    %rax,%rdx
  80236d:	73 b4                	jae    802323 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80236f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802373:	8b 40 04             	mov    0x4(%rax),%eax
  802376:	99                   	cltd   
  802377:	c1 ea 1b             	shr    $0x1b,%edx
  80237a:	01 d0                	add    %edx,%eax
  80237c:	83 e0 1f             	and    $0x1f,%eax
  80237f:	29 d0                	sub    %edx,%eax
  802381:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802385:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802389:	48 01 ca             	add    %rcx,%rdx
  80238c:	0f b6 0a             	movzbl (%rdx),%ecx
  80238f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802393:	48 98                	cltq   
  802395:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239d:	8b 40 04             	mov    0x4(%rax),%eax
  8023a0:	8d 50 01             	lea    0x1(%rax),%edx
  8023a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8023b7:	0f 82 64 ff ff ff    	jb     802321 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023c1:	c9                   	leaveq 
  8023c2:	c3                   	retq   

00000000008023c3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023c3:	55                   	push   %rbp
  8023c4:	48 89 e5             	mov    %rsp,%rbp
  8023c7:	48 83 ec 20          	sub    $0x20,%rsp
  8023cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d7:	48 89 c7             	mov    %rax,%rdi
  8023da:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  8023e1:	00 00 00 
  8023e4:	ff d0                	callq  *%rax
  8023e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8023ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ee:	48 be 51 41 80 00 00 	movabs $0x804151,%rsi
  8023f5:	00 00 00 
  8023f8:	48 89 c7             	mov    %rax,%rdi
  8023fb:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240b:	8b 50 04             	mov    0x4(%rax),%edx
  80240e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802412:	8b 00                	mov    (%rax),%eax
  802414:	29 c2                	sub    %eax,%edx
  802416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802420:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802424:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80242b:	00 00 00 
	stat->st_dev = &devpipe;
  80242e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802432:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802439:	00 00 00 
  80243c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 10          	sub    $0x10,%rsp
  802452:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245a:	48 89 c6             	mov    %rax,%rsi
  80245d:	bf 00 00 00 00       	mov    $0x0,%edi
  802462:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  802469:	00 00 00 
  80246c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80246e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802472:	48 89 c7             	mov    %rax,%rdi
  802475:	48 b8 e1 06 80 00 00 	movabs $0x8006e1,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax
  802481:	48 89 c6             	mov    %rax,%rsi
  802484:	bf 00 00 00 00       	mov    $0x0,%edi
  802489:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  802490:	00 00 00 
  802493:	ff d0                	callq  *%rax
}
  802495:	c9                   	leaveq 
  802496:	c3                   	retq   

0000000000802497 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802497:	55                   	push   %rbp
  802498:	48 89 e5             	mov    %rsp,%rbp
  80249b:	48 83 ec 20          	sub    $0x20,%rsp
  80249f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8024a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024a8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8024ac:	be 01 00 00 00       	mov    $0x1,%esi
  8024b1:	48 89 c7             	mov    %rax,%rdi
  8024b4:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
}
  8024c0:	c9                   	leaveq 
  8024c1:	c3                   	retq   

00000000008024c2 <getchar>:

int
getchar(void)
{
  8024c2:	55                   	push   %rbp
  8024c3:	48 89 e5             	mov    %rsp,%rbp
  8024c6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024ca:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8024ce:	ba 01 00 00 00       	mov    $0x1,%edx
  8024d3:	48 89 c6             	mov    %rax,%rsi
  8024d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024db:	48 b8 d6 0b 80 00 00 	movabs $0x800bd6,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8024ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ee:	79 05                	jns    8024f5 <getchar+0x33>
		return r;
  8024f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f3:	eb 14                	jmp    802509 <getchar+0x47>
	if (r < 1)
  8024f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f9:	7f 07                	jg     802502 <getchar+0x40>
		return -E_EOF;
  8024fb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802500:	eb 07                	jmp    802509 <getchar+0x47>
	return c;
  802502:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802506:	0f b6 c0             	movzbl %al,%eax
}
  802509:	c9                   	leaveq 
  80250a:	c3                   	retq   

000000000080250b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80250b:	55                   	push   %rbp
  80250c:	48 89 e5             	mov    %rsp,%rbp
  80250f:	48 83 ec 20          	sub    $0x20,%rsp
  802513:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802516:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80251d:	48 89 d6             	mov    %rdx,%rsi
  802520:	89 c7                	mov    %eax,%edi
  802522:	48 b8 a4 07 80 00 00 	movabs $0x8007a4,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
  80252e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802531:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802535:	79 05                	jns    80253c <iscons+0x31>
		return r;
  802537:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253a:	eb 1a                	jmp    802556 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80253c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802540:	8b 10                	mov    (%rax),%edx
  802542:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802549:	00 00 00 
  80254c:	8b 00                	mov    (%rax),%eax
  80254e:	39 c2                	cmp    %eax,%edx
  802550:	0f 94 c0             	sete   %al
  802553:	0f b6 c0             	movzbl %al,%eax
}
  802556:	c9                   	leaveq 
  802557:	c3                   	retq   

0000000000802558 <opencons>:

int
opencons(void)
{
  802558:	55                   	push   %rbp
  802559:	48 89 e5             	mov    %rsp,%rbp
  80255c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802560:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802564:	48 89 c7             	mov    %rax,%rdi
  802567:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  80256e:	00 00 00 
  802571:	ff d0                	callq  *%rax
  802573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257a:	79 05                	jns    802581 <opencons+0x29>
		return r;
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	eb 5b                	jmp    8025dc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	ba 07 04 00 00       	mov    $0x407,%edx
  80258a:	48 89 c6             	mov    %rax,%rsi
  80258d:	bf 00 00 00 00       	mov    $0x0,%edi
  802592:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
  80259e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a5:	79 05                	jns    8025ac <opencons+0x54>
		return r;
  8025a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025aa:	eb 30                	jmp    8025dc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8025ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b0:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8025b7:	00 00 00 
  8025ba:	8b 12                	mov    (%rdx),%edx
  8025bc:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8025be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	48 89 c7             	mov    %rax,%rdi
  8025d0:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 30          	sub    $0x30,%rsp
  8025e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8025f2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025f7:	75 07                	jne    802600 <devcons_read+0x22>
		return 0;
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	eb 4b                	jmp    80264b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802600:	eb 0c                	jmp    80260e <devcons_read+0x30>
		sys_yield();
  802602:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  802609:	00 00 00 
  80260c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80260e:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802621:	74 df                	je     802602 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802623:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802627:	79 05                	jns    80262e <devcons_read+0x50>
		return c;
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	eb 1d                	jmp    80264b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80262e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802632:	75 07                	jne    80263b <devcons_read+0x5d>
		return 0;
  802634:	b8 00 00 00 00       	mov    $0x0,%eax
  802639:	eb 10                	jmp    80264b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80263b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263e:	89 c2                	mov    %eax,%edx
  802640:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802644:	88 10                	mov    %dl,(%rax)
	return 1;
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80264b:	c9                   	leaveq 
  80264c:	c3                   	retq   

000000000080264d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264d:	55                   	push   %rbp
  80264e:	48 89 e5             	mov    %rsp,%rbp
  802651:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802658:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80265f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802666:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80266d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802674:	eb 76                	jmp    8026ec <devcons_write+0x9f>
		m = n - tot;
  802676:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80267d:	89 c2                	mov    %eax,%edx
  80267f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802682:	29 c2                	sub    %eax,%edx
  802684:	89 d0                	mov    %edx,%eax
  802686:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802689:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80268c:	83 f8 7f             	cmp    $0x7f,%eax
  80268f:	76 07                	jbe    802698 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802691:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802698:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80269b:	48 63 d0             	movslq %eax,%rdx
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	48 63 c8             	movslq %eax,%rcx
  8026a4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8026ab:	48 01 c1             	add    %rax,%rcx
  8026ae:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8026b5:	48 89 ce             	mov    %rcx,%rsi
  8026b8:	48 89 c7             	mov    %rax,%rdi
  8026bb:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8026c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026ca:	48 63 d0             	movslq %eax,%rdx
  8026cd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8026d4:	48 89 d6             	mov    %rdx,%rsi
  8026d7:	48 89 c7             	mov    %rax,%rdi
  8026da:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ef:	48 98                	cltq   
  8026f1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8026f8:	0f 82 78 ff ff ff    	jb     802676 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8026fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802701:	c9                   	leaveq 
  802702:	c3                   	retq   

0000000000802703 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802703:	55                   	push   %rbp
  802704:	48 89 e5             	mov    %rsp,%rbp
  802707:	48 83 ec 08          	sub    $0x8,%rsp
  80270b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802714:	c9                   	leaveq 
  802715:	c3                   	retq   

0000000000802716 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802716:	55                   	push   %rbp
  802717:	48 89 e5             	mov    %rsp,%rbp
  80271a:	48 83 ec 10          	sub    $0x10,%rsp
  80271e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802722:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272a:	48 be 5d 41 80 00 00 	movabs $0x80415d,%rsi
  802731:	00 00 00 
  802734:	48 89 c7             	mov    %rax,%rdi
  802737:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
	return 0;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802748:	c9                   	leaveq 
  802749:	c3                   	retq   

000000000080274a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80274a:	55                   	push   %rbp
  80274b:	48 89 e5             	mov    %rsp,%rbp
  80274e:	53                   	push   %rbx
  80274f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802756:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80275d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802763:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80276a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802771:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802778:	84 c0                	test   %al,%al
  80277a:	74 23                	je     80279f <_panic+0x55>
  80277c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802783:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802787:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80278b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80278f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802793:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802797:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80279b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80279f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8027a6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8027ad:	00 00 00 
  8027b0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8027b7:	00 00 00 
  8027ba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027be:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8027c5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8027cc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027d3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8027da:	00 00 00 
  8027dd:	48 8b 18             	mov    (%rax),%rbx
  8027e0:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
  8027ec:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8027f2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027f9:	41 89 c8             	mov    %ecx,%r8d
  8027fc:	48 89 d1             	mov    %rdx,%rcx
  8027ff:	48 89 da             	mov    %rbx,%rdx
  802802:	89 c6                	mov    %eax,%esi
  802804:	48 bf 68 41 80 00 00 	movabs $0x804168,%rdi
  80280b:	00 00 00 
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	49 b9 83 29 80 00 00 	movabs $0x802983,%r9
  80281a:	00 00 00 
  80281d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802820:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802827:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80282e:	48 89 d6             	mov    %rdx,%rsi
  802831:	48 89 c7             	mov    %rax,%rdi
  802834:	48 b8 d7 28 80 00 00 	movabs $0x8028d7,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	callq  *%rax
	cprintf("\n");
  802840:	48 bf 8b 41 80 00 00 	movabs $0x80418b,%rdi
  802847:	00 00 00 
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
  80284f:	48 ba 83 29 80 00 00 	movabs $0x802983,%rdx
  802856:	00 00 00 
  802859:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80285b:	cc                   	int3   
  80285c:	eb fd                	jmp    80285b <_panic+0x111>

000000000080285e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80285e:	55                   	push   %rbp
  80285f:	48 89 e5             	mov    %rsp,%rbp
  802862:	48 83 ec 10          	sub    $0x10,%rsp
  802866:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80286d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802871:	8b 00                	mov    (%rax),%eax
  802873:	8d 48 01             	lea    0x1(%rax),%ecx
  802876:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80287a:	89 0a                	mov    %ecx,(%rdx)
  80287c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287f:	89 d1                	mov    %edx,%ecx
  802881:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802885:	48 98                	cltq   
  802887:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80288b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288f:	8b 00                	mov    (%rax),%eax
  802891:	3d ff 00 00 00       	cmp    $0xff,%eax
  802896:	75 2c                	jne    8028c4 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289c:	8b 00                	mov    (%rax),%eax
  80289e:	48 98                	cltq   
  8028a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028a4:	48 83 c2 08          	add    $0x8,%rdx
  8028a8:	48 89 c6             	mov    %rax,%rsi
  8028ab:	48 89 d7             	mov    %rdx,%rdi
  8028ae:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
        b->idx = 0;
  8028ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8028c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c8:	8b 40 04             	mov    0x4(%rax),%eax
  8028cb:	8d 50 01             	lea    0x1(%rax),%edx
  8028ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8028d5:	c9                   	leaveq 
  8028d6:	c3                   	retq   

00000000008028d7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8028d7:	55                   	push   %rbp
  8028d8:	48 89 e5             	mov    %rsp,%rbp
  8028db:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8028e2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8028e9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8028f0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8028f7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8028fe:	48 8b 0a             	mov    (%rdx),%rcx
  802901:	48 89 08             	mov    %rcx,(%rax)
  802904:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802908:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80290c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802910:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802914:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80291b:	00 00 00 
    b.cnt = 0;
  80291e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802925:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802928:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80292f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802936:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80293d:	48 89 c6             	mov    %rax,%rsi
  802940:	48 bf 5e 28 80 00 00 	movabs $0x80285e,%rdi
  802947:	00 00 00 
  80294a:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  802951:	00 00 00 
  802954:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802956:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80295c:	48 98                	cltq   
  80295e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802965:	48 83 c2 08          	add    $0x8,%rdx
  802969:	48 89 c6             	mov    %rax,%rsi
  80296c:	48 89 d7             	mov    %rdx,%rdi
  80296f:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80297b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80298e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802995:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80299c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029a3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8029aa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8029b1:	84 c0                	test   %al,%al
  8029b3:	74 20                	je     8029d5 <cprintf+0x52>
  8029b5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8029b9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8029bd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029c1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029c5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029c9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029cd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8029d1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8029d5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8029dc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8029e3:	00 00 00 
  8029e6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8029ed:	00 00 00 
  8029f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029f4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8029fb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a02:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802a09:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802a10:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802a17:	48 8b 0a             	mov    (%rdx),%rcx
  802a1a:	48 89 08             	mov    %rcx,(%rax)
  802a1d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a21:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a25:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a29:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802a2d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802a34:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802a3b:	48 89 d6             	mov    %rdx,%rsi
  802a3e:	48 89 c7             	mov    %rax,%rdi
  802a41:	48 b8 d7 28 80 00 00 	movabs $0x8028d7,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	callq  *%rax
  802a4d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802a53:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802a59:	c9                   	leaveq 
  802a5a:	c3                   	retq   

0000000000802a5b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802a5b:	55                   	push   %rbp
  802a5c:	48 89 e5             	mov    %rsp,%rbp
  802a5f:	53                   	push   %rbx
  802a60:	48 83 ec 38          	sub    $0x38,%rsp
  802a64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802a70:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a73:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a77:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a7b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a7e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a82:	77 3b                	ja     802abf <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a84:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a87:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a8b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a92:	ba 00 00 00 00       	mov    $0x0,%edx
  802a97:	48 f7 f3             	div    %rbx
  802a9a:	48 89 c2             	mov    %rax,%rdx
  802a9d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802aa0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802aa3:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aab:	41 89 f9             	mov    %edi,%r9d
  802aae:	48 89 c7             	mov    %rax,%rdi
  802ab1:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802ab8:	00 00 00 
  802abb:	ff d0                	callq  *%rax
  802abd:	eb 1e                	jmp    802add <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802abf:	eb 12                	jmp    802ad3 <printnum+0x78>
			putch(padc, putdat);
  802ac1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ac5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acc:	48 89 ce             	mov    %rcx,%rsi
  802acf:	89 d7                	mov    %edx,%edi
  802ad1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802ad3:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802ad7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802adb:	7f e4                	jg     802ac1 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802add:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802ae0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae9:	48 f7 f1             	div    %rcx
  802aec:	48 89 d0             	mov    %rdx,%rax
  802aef:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  802af6:	00 00 00 
  802af9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802afd:	0f be d0             	movsbl %al,%edx
  802b00:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b08:	48 89 ce             	mov    %rcx,%rsi
  802b0b:	89 d7                	mov    %edx,%edi
  802b0d:	ff d0                	callq  *%rax
}
  802b0f:	48 83 c4 38          	add    $0x38,%rsp
  802b13:	5b                   	pop    %rbx
  802b14:	5d                   	pop    %rbp
  802b15:	c3                   	retq   

0000000000802b16 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	48 83 ec 1c          	sub    $0x1c,%rsp
  802b1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b22:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802b25:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802b29:	7e 52                	jle    802b7d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2f:	8b 00                	mov    (%rax),%eax
  802b31:	83 f8 30             	cmp    $0x30,%eax
  802b34:	73 24                	jae    802b5a <getuint+0x44>
  802b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b42:	8b 00                	mov    (%rax),%eax
  802b44:	89 c0                	mov    %eax,%eax
  802b46:	48 01 d0             	add    %rdx,%rax
  802b49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b4d:	8b 12                	mov    (%rdx),%edx
  802b4f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b56:	89 0a                	mov    %ecx,(%rdx)
  802b58:	eb 17                	jmp    802b71 <getuint+0x5b>
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b62:	48 89 d0             	mov    %rdx,%rax
  802b65:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b6d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b71:	48 8b 00             	mov    (%rax),%rax
  802b74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b78:	e9 a3 00 00 00       	jmpq   802c20 <getuint+0x10a>
	else if (lflag)
  802b7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b81:	74 4f                	je     802bd2 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b87:	8b 00                	mov    (%rax),%eax
  802b89:	83 f8 30             	cmp    $0x30,%eax
  802b8c:	73 24                	jae    802bb2 <getuint+0x9c>
  802b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b92:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9a:	8b 00                	mov    (%rax),%eax
  802b9c:	89 c0                	mov    %eax,%eax
  802b9e:	48 01 d0             	add    %rdx,%rax
  802ba1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ba5:	8b 12                	mov    (%rdx),%edx
  802ba7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bae:	89 0a                	mov    %ecx,(%rdx)
  802bb0:	eb 17                	jmp    802bc9 <getuint+0xb3>
  802bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bba:	48 89 d0             	mov    %rdx,%rax
  802bbd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bc5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bc9:	48 8b 00             	mov    (%rax),%rax
  802bcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802bd0:	eb 4e                	jmp    802c20 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd6:	8b 00                	mov    (%rax),%eax
  802bd8:	83 f8 30             	cmp    $0x30,%eax
  802bdb:	73 24                	jae    802c01 <getuint+0xeb>
  802bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be9:	8b 00                	mov    (%rax),%eax
  802beb:	89 c0                	mov    %eax,%eax
  802bed:	48 01 d0             	add    %rdx,%rax
  802bf0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf4:	8b 12                	mov    (%rdx),%edx
  802bf6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bfd:	89 0a                	mov    %ecx,(%rdx)
  802bff:	eb 17                	jmp    802c18 <getuint+0x102>
  802c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c05:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c09:	48 89 d0             	mov    %rdx,%rax
  802c0c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c14:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c18:	8b 00                	mov    (%rax),%eax
  802c1a:	89 c0                	mov    %eax,%eax
  802c1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c24:	c9                   	leaveq 
  802c25:	c3                   	retq   

0000000000802c26 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802c26:	55                   	push   %rbp
  802c27:	48 89 e5             	mov    %rsp,%rbp
  802c2a:	48 83 ec 1c          	sub    $0x1c,%rsp
  802c2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c32:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802c35:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802c39:	7e 52                	jle    802c8d <getint+0x67>
		x=va_arg(*ap, long long);
  802c3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3f:	8b 00                	mov    (%rax),%eax
  802c41:	83 f8 30             	cmp    $0x30,%eax
  802c44:	73 24                	jae    802c6a <getint+0x44>
  802c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c52:	8b 00                	mov    (%rax),%eax
  802c54:	89 c0                	mov    %eax,%eax
  802c56:	48 01 d0             	add    %rdx,%rax
  802c59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c5d:	8b 12                	mov    (%rdx),%edx
  802c5f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c66:	89 0a                	mov    %ecx,(%rdx)
  802c68:	eb 17                	jmp    802c81 <getint+0x5b>
  802c6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c72:	48 89 d0             	mov    %rdx,%rax
  802c75:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c7d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c81:	48 8b 00             	mov    (%rax),%rax
  802c84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c88:	e9 a3 00 00 00       	jmpq   802d30 <getint+0x10a>
	else if (lflag)
  802c8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c91:	74 4f                	je     802ce2 <getint+0xbc>
		x=va_arg(*ap, long);
  802c93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c97:	8b 00                	mov    (%rax),%eax
  802c99:	83 f8 30             	cmp    $0x30,%eax
  802c9c:	73 24                	jae    802cc2 <getint+0x9c>
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caa:	8b 00                	mov    (%rax),%eax
  802cac:	89 c0                	mov    %eax,%eax
  802cae:	48 01 d0             	add    %rdx,%rax
  802cb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb5:	8b 12                	mov    (%rdx),%edx
  802cb7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802cba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cbe:	89 0a                	mov    %ecx,(%rdx)
  802cc0:	eb 17                	jmp    802cd9 <getint+0xb3>
  802cc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802cca:	48 89 d0             	mov    %rdx,%rax
  802ccd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802cd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cd5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cd9:	48 8b 00             	mov    (%rax),%rax
  802cdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802ce0:	eb 4e                	jmp    802d30 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802ce2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce6:	8b 00                	mov    (%rax),%eax
  802ce8:	83 f8 30             	cmp    $0x30,%eax
  802ceb:	73 24                	jae    802d11 <getint+0xeb>
  802ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf9:	8b 00                	mov    (%rax),%eax
  802cfb:	89 c0                	mov    %eax,%eax
  802cfd:	48 01 d0             	add    %rdx,%rax
  802d00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d04:	8b 12                	mov    (%rdx),%edx
  802d06:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0d:	89 0a                	mov    %ecx,(%rdx)
  802d0f:	eb 17                	jmp    802d28 <getint+0x102>
  802d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d15:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802d19:	48 89 d0             	mov    %rdx,%rax
  802d1c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802d20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d24:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d28:	8b 00                	mov    (%rax),%eax
  802d2a:	48 98                	cltq   
  802d2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d34:	c9                   	leaveq 
  802d35:	c3                   	retq   

0000000000802d36 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802d36:	55                   	push   %rbp
  802d37:	48 89 e5             	mov    %rsp,%rbp
  802d3a:	41 54                	push   %r12
  802d3c:	53                   	push   %rbx
  802d3d:	48 83 ec 60          	sub    $0x60,%rsp
  802d41:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802d45:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802d49:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d4d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802d51:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d55:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802d59:	48 8b 0a             	mov    (%rdx),%rcx
  802d5c:	48 89 08             	mov    %rcx,(%rax)
  802d5f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802d63:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802d67:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802d6b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d6f:	eb 17                	jmp    802d88 <vprintfmt+0x52>
			if (ch == '\0')
  802d71:	85 db                	test   %ebx,%ebx
  802d73:	0f 84 cc 04 00 00    	je     803245 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802d79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d81:	48 89 d6             	mov    %rdx,%rsi
  802d84:	89 df                	mov    %ebx,%edi
  802d86:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d88:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d8c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d90:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d94:	0f b6 00             	movzbl (%rax),%eax
  802d97:	0f b6 d8             	movzbl %al,%ebx
  802d9a:	83 fb 25             	cmp    $0x25,%ebx
  802d9d:	75 d2                	jne    802d71 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d9f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802da3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802daa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802db8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802dbf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802dc3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802dc7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802dcb:	0f b6 00             	movzbl (%rax),%eax
  802dce:	0f b6 d8             	movzbl %al,%ebx
  802dd1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802dd4:	83 f8 55             	cmp    $0x55,%eax
  802dd7:	0f 87 34 04 00 00    	ja     803211 <vprintfmt+0x4db>
  802ddd:	89 c0                	mov    %eax,%eax
  802ddf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802de6:	00 
  802de7:	48 b8 b8 43 80 00 00 	movabs $0x8043b8,%rax
  802dee:	00 00 00 
  802df1:	48 01 d0             	add    %rdx,%rax
  802df4:	48 8b 00             	mov    (%rax),%rax
  802df7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802df9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802dfd:	eb c0                	jmp    802dbf <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802dff:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802e03:	eb ba                	jmp    802dbf <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e05:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802e0c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e0f:	89 d0                	mov    %edx,%eax
  802e11:	c1 e0 02             	shl    $0x2,%eax
  802e14:	01 d0                	add    %edx,%eax
  802e16:	01 c0                	add    %eax,%eax
  802e18:	01 d8                	add    %ebx,%eax
  802e1a:	83 e8 30             	sub    $0x30,%eax
  802e1d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802e20:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802e24:	0f b6 00             	movzbl (%rax),%eax
  802e27:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802e2a:	83 fb 2f             	cmp    $0x2f,%ebx
  802e2d:	7e 0c                	jle    802e3b <vprintfmt+0x105>
  802e2f:	83 fb 39             	cmp    $0x39,%ebx
  802e32:	7f 07                	jg     802e3b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e34:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802e39:	eb d1                	jmp    802e0c <vprintfmt+0xd6>
			goto process_precision;
  802e3b:	eb 58                	jmp    802e95 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802e3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e40:	83 f8 30             	cmp    $0x30,%eax
  802e43:	73 17                	jae    802e5c <vprintfmt+0x126>
  802e45:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e4c:	89 c0                	mov    %eax,%eax
  802e4e:	48 01 d0             	add    %rdx,%rax
  802e51:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e54:	83 c2 08             	add    $0x8,%edx
  802e57:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e5a:	eb 0f                	jmp    802e6b <vprintfmt+0x135>
  802e5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e60:	48 89 d0             	mov    %rdx,%rax
  802e63:	48 83 c2 08          	add    $0x8,%rdx
  802e67:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e6b:	8b 00                	mov    (%rax),%eax
  802e6d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802e70:	eb 23                	jmp    802e95 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802e72:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e76:	79 0c                	jns    802e84 <vprintfmt+0x14e>
				width = 0;
  802e78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e7f:	e9 3b ff ff ff       	jmpq   802dbf <vprintfmt+0x89>
  802e84:	e9 36 ff ff ff       	jmpq   802dbf <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e89:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e90:	e9 2a ff ff ff       	jmpq   802dbf <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e99:	79 12                	jns    802ead <vprintfmt+0x177>
				width = precision, precision = -1;
  802e9b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e9e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802ea1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802ea8:	e9 12 ff ff ff       	jmpq   802dbf <vprintfmt+0x89>
  802ead:	e9 0d ff ff ff       	jmpq   802dbf <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802eb2:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802eb6:	e9 04 ff ff ff       	jmpq   802dbf <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802ebb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ebe:	83 f8 30             	cmp    $0x30,%eax
  802ec1:	73 17                	jae    802eda <vprintfmt+0x1a4>
  802ec3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802eca:	89 c0                	mov    %eax,%eax
  802ecc:	48 01 d0             	add    %rdx,%rax
  802ecf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ed2:	83 c2 08             	add    $0x8,%edx
  802ed5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ed8:	eb 0f                	jmp    802ee9 <vprintfmt+0x1b3>
  802eda:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ede:	48 89 d0             	mov    %rdx,%rax
  802ee1:	48 83 c2 08          	add    $0x8,%rdx
  802ee5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ee9:	8b 10                	mov    (%rax),%edx
  802eeb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802eef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ef3:	48 89 ce             	mov    %rcx,%rsi
  802ef6:	89 d7                	mov    %edx,%edi
  802ef8:	ff d0                	callq  *%rax
			break;
  802efa:	e9 40 03 00 00       	jmpq   80323f <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802eff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f02:	83 f8 30             	cmp    $0x30,%eax
  802f05:	73 17                	jae    802f1e <vprintfmt+0x1e8>
  802f07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f0e:	89 c0                	mov    %eax,%eax
  802f10:	48 01 d0             	add    %rdx,%rax
  802f13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f16:	83 c2 08             	add    $0x8,%edx
  802f19:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f1c:	eb 0f                	jmp    802f2d <vprintfmt+0x1f7>
  802f1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f22:	48 89 d0             	mov    %rdx,%rax
  802f25:	48 83 c2 08          	add    $0x8,%rdx
  802f29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f2d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802f2f:	85 db                	test   %ebx,%ebx
  802f31:	79 02                	jns    802f35 <vprintfmt+0x1ff>
				err = -err;
  802f33:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802f35:	83 fb 15             	cmp    $0x15,%ebx
  802f38:	7f 16                	jg     802f50 <vprintfmt+0x21a>
  802f3a:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  802f41:	00 00 00 
  802f44:	48 63 d3             	movslq %ebx,%rdx
  802f47:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802f4b:	4d 85 e4             	test   %r12,%r12
  802f4e:	75 2e                	jne    802f7e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802f50:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f58:	89 d9                	mov    %ebx,%ecx
  802f5a:	48 ba a1 43 80 00 00 	movabs $0x8043a1,%rdx
  802f61:	00 00 00 
  802f64:	48 89 c7             	mov    %rax,%rdi
  802f67:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6c:	49 b8 4e 32 80 00 00 	movabs $0x80324e,%r8
  802f73:	00 00 00 
  802f76:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f79:	e9 c1 02 00 00       	jmpq   80323f <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f7e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f86:	4c 89 e1             	mov    %r12,%rcx
  802f89:	48 ba aa 43 80 00 00 	movabs $0x8043aa,%rdx
  802f90:	00 00 00 
  802f93:	48 89 c7             	mov    %rax,%rdi
  802f96:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9b:	49 b8 4e 32 80 00 00 	movabs $0x80324e,%r8
  802fa2:	00 00 00 
  802fa5:	41 ff d0             	callq  *%r8
			break;
  802fa8:	e9 92 02 00 00       	jmpq   80323f <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802fad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fb0:	83 f8 30             	cmp    $0x30,%eax
  802fb3:	73 17                	jae    802fcc <vprintfmt+0x296>
  802fb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fbc:	89 c0                	mov    %eax,%eax
  802fbe:	48 01 d0             	add    %rdx,%rax
  802fc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802fc4:	83 c2 08             	add    $0x8,%edx
  802fc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802fca:	eb 0f                	jmp    802fdb <vprintfmt+0x2a5>
  802fcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802fd0:	48 89 d0             	mov    %rdx,%rax
  802fd3:	48 83 c2 08          	add    $0x8,%rdx
  802fd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fdb:	4c 8b 20             	mov    (%rax),%r12
  802fde:	4d 85 e4             	test   %r12,%r12
  802fe1:	75 0a                	jne    802fed <vprintfmt+0x2b7>
				p = "(null)";
  802fe3:	49 bc ad 43 80 00 00 	movabs $0x8043ad,%r12
  802fea:	00 00 00 
			if (width > 0 && padc != '-')
  802fed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802ff1:	7e 3f                	jle    803032 <vprintfmt+0x2fc>
  802ff3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802ff7:	74 39                	je     803032 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802ff9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ffc:	48 98                	cltq   
  802ffe:	48 89 c6             	mov    %rax,%rsi
  803001:	4c 89 e7             	mov    %r12,%rdi
  803004:	48 b8 fa 34 80 00 00 	movabs $0x8034fa,%rax
  80300b:	00 00 00 
  80300e:	ff d0                	callq  *%rax
  803010:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803013:	eb 17                	jmp    80302c <vprintfmt+0x2f6>
					putch(padc, putdat);
  803015:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803019:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80301d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803021:	48 89 ce             	mov    %rcx,%rsi
  803024:	89 d7                	mov    %edx,%edi
  803026:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803028:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80302c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803030:	7f e3                	jg     803015 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803032:	eb 37                	jmp    80306b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803034:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803038:	74 1e                	je     803058 <vprintfmt+0x322>
  80303a:	83 fb 1f             	cmp    $0x1f,%ebx
  80303d:	7e 05                	jle    803044 <vprintfmt+0x30e>
  80303f:	83 fb 7e             	cmp    $0x7e,%ebx
  803042:	7e 14                	jle    803058 <vprintfmt+0x322>
					putch('?', putdat);
  803044:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803048:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80304c:	48 89 d6             	mov    %rdx,%rsi
  80304f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803054:	ff d0                	callq  *%rax
  803056:	eb 0f                	jmp    803067 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803058:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80305c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803060:	48 89 d6             	mov    %rdx,%rsi
  803063:	89 df                	mov    %ebx,%edi
  803065:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803067:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80306b:	4c 89 e0             	mov    %r12,%rax
  80306e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803072:	0f b6 00             	movzbl (%rax),%eax
  803075:	0f be d8             	movsbl %al,%ebx
  803078:	85 db                	test   %ebx,%ebx
  80307a:	74 10                	je     80308c <vprintfmt+0x356>
  80307c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803080:	78 b2                	js     803034 <vprintfmt+0x2fe>
  803082:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803086:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80308a:	79 a8                	jns    803034 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80308c:	eb 16                	jmp    8030a4 <vprintfmt+0x36e>
				putch(' ', putdat);
  80308e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803092:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803096:	48 89 d6             	mov    %rdx,%rsi
  803099:	bf 20 00 00 00       	mov    $0x20,%edi
  80309e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8030a0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8030a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8030a8:	7f e4                	jg     80308e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8030aa:	e9 90 01 00 00       	jmpq   80323f <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8030af:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030b3:	be 03 00 00 00       	mov    $0x3,%esi
  8030b8:	48 89 c7             	mov    %rax,%rdi
  8030bb:	48 b8 26 2c 80 00 00 	movabs $0x802c26,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
  8030c7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8030cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030cf:	48 85 c0             	test   %rax,%rax
  8030d2:	79 1d                	jns    8030f1 <vprintfmt+0x3bb>
				putch('-', putdat);
  8030d4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030dc:	48 89 d6             	mov    %rdx,%rsi
  8030df:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8030e4:	ff d0                	callq  *%rax
				num = -(long long) num;
  8030e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ea:	48 f7 d8             	neg    %rax
  8030ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8030f1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030f8:	e9 d5 00 00 00       	jmpq   8031d2 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8030fd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803101:	be 03 00 00 00       	mov    $0x3,%esi
  803106:	48 89 c7             	mov    %rax,%rdi
  803109:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803119:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803120:	e9 ad 00 00 00       	jmpq   8031d2 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803125:	8b 55 e0             	mov    -0x20(%rbp),%edx
  803128:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80312c:	89 d6                	mov    %edx,%esi
  80312e:	48 89 c7             	mov    %rax,%rdi
  803131:	48 b8 26 2c 80 00 00 	movabs $0x802c26,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803141:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803148:	e9 85 00 00 00       	jmpq   8031d2 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  80314d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803151:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803155:	48 89 d6             	mov    %rdx,%rsi
  803158:	bf 30 00 00 00       	mov    $0x30,%edi
  80315d:	ff d0                	callq  *%rax
			putch('x', putdat);
  80315f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803163:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803167:	48 89 d6             	mov    %rdx,%rsi
  80316a:	bf 78 00 00 00       	mov    $0x78,%edi
  80316f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803171:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803174:	83 f8 30             	cmp    $0x30,%eax
  803177:	73 17                	jae    803190 <vprintfmt+0x45a>
  803179:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80317d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803180:	89 c0                	mov    %eax,%eax
  803182:	48 01 d0             	add    %rdx,%rax
  803185:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803188:	83 c2 08             	add    $0x8,%edx
  80318b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80318e:	eb 0f                	jmp    80319f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803190:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803194:	48 89 d0             	mov    %rdx,%rax
  803197:	48 83 c2 08          	add    $0x8,%rdx
  80319b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80319f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8031a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8031a6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8031ad:	eb 23                	jmp    8031d2 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8031af:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031b3:	be 03 00 00 00       	mov    $0x3,%esi
  8031b8:	48 89 c7             	mov    %rax,%rdi
  8031bb:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	callq  *%rax
  8031c7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8031cb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8031d2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8031d7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031da:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8031dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031e1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8031e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031e9:	45 89 c1             	mov    %r8d,%r9d
  8031ec:	41 89 f8             	mov    %edi,%r8d
  8031ef:	48 89 c7             	mov    %rax,%rdi
  8031f2:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
			break;
  8031fe:	eb 3f                	jmp    80323f <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803200:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803204:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803208:	48 89 d6             	mov    %rdx,%rsi
  80320b:	89 df                	mov    %ebx,%edi
  80320d:	ff d0                	callq  *%rax
			break;
  80320f:	eb 2e                	jmp    80323f <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803211:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803215:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803219:	48 89 d6             	mov    %rdx,%rsi
  80321c:	bf 25 00 00 00       	mov    $0x25,%edi
  803221:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803223:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803228:	eb 05                	jmp    80322f <vprintfmt+0x4f9>
  80322a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80322f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803233:	48 83 e8 01          	sub    $0x1,%rax
  803237:	0f b6 00             	movzbl (%rax),%eax
  80323a:	3c 25                	cmp    $0x25,%al
  80323c:	75 ec                	jne    80322a <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80323e:	90                   	nop
		}
	}
  80323f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803240:	e9 43 fb ff ff       	jmpq   802d88 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803245:	48 83 c4 60          	add    $0x60,%rsp
  803249:	5b                   	pop    %rbx
  80324a:	41 5c                	pop    %r12
  80324c:	5d                   	pop    %rbp
  80324d:	c3                   	retq   

000000000080324e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80324e:	55                   	push   %rbp
  80324f:	48 89 e5             	mov    %rsp,%rbp
  803252:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803259:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803260:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803267:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80326e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803275:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80327c:	84 c0                	test   %al,%al
  80327e:	74 20                	je     8032a0 <printfmt+0x52>
  803280:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803284:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803288:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80328c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803290:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803294:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803298:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80329c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032a0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032a7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8032ae:	00 00 00 
  8032b1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8032b8:	00 00 00 
  8032bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032bf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8032c6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032cd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8032d4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8032db:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032e2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8032e9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8032f0:	48 89 c7             	mov    %rax,%rdi
  8032f3:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
	va_end(ap);
}
  8032ff:	c9                   	leaveq 
  803300:	c3                   	retq   

0000000000803301 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803301:	55                   	push   %rbp
  803302:	48 89 e5             	mov    %rsp,%rbp
  803305:	48 83 ec 10          	sub    $0x10,%rsp
  803309:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80330c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803314:	8b 40 10             	mov    0x10(%rax),%eax
  803317:	8d 50 01             	lea    0x1(%rax),%edx
  80331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803325:	48 8b 10             	mov    (%rax),%rdx
  803328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803330:	48 39 c2             	cmp    %rax,%rdx
  803333:	73 17                	jae    80334c <sprintputch+0x4b>
		*b->buf++ = ch;
  803335:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803339:	48 8b 00             	mov    (%rax),%rax
  80333c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803344:	48 89 0a             	mov    %rcx,(%rdx)
  803347:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80334a:	88 10                	mov    %dl,(%rax)
}
  80334c:	c9                   	leaveq 
  80334d:	c3                   	retq   

000000000080334e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80334e:	55                   	push   %rbp
  80334f:	48 89 e5             	mov    %rsp,%rbp
  803352:	48 83 ec 50          	sub    $0x50,%rsp
  803356:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80335a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80335d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803361:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803365:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803369:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80336d:	48 8b 0a             	mov    (%rdx),%rcx
  803370:	48 89 08             	mov    %rcx,(%rax)
  803373:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803377:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80337b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80337f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803383:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803387:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80338b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80338e:	48 98                	cltq   
  803390:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803394:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803398:	48 01 d0             	add    %rdx,%rax
  80339b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80339f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8033a6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8033ab:	74 06                	je     8033b3 <vsnprintf+0x65>
  8033ad:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8033b1:	7f 07                	jg     8033ba <vsnprintf+0x6c>
		return -E_INVAL;
  8033b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033b8:	eb 2f                	jmp    8033e9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8033ba:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8033be:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8033c2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033c6:	48 89 c6             	mov    %rax,%rsi
  8033c9:	48 bf 01 33 80 00 00 	movabs $0x803301,%rdi
  8033d0:	00 00 00 
  8033d3:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8033df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8033e6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8033f6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8033fd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803403:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80340a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803411:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803418:	84 c0                	test   %al,%al
  80341a:	74 20                	je     80343c <snprintf+0x51>
  80341c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803420:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803424:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803428:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80342c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803430:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803434:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803438:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80343c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803443:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80344a:	00 00 00 
  80344d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803454:	00 00 00 
  803457:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80345b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803462:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803469:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803470:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803477:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80347e:	48 8b 0a             	mov    (%rdx),%rcx
  803481:	48 89 08             	mov    %rcx,(%rax)
  803484:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803488:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80348c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803490:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803494:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80349b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8034a2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8034a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034af:	48 89 c7             	mov    %rax,%rdi
  8034b2:	48 b8 4e 33 80 00 00 	movabs $0x80334e,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
  8034be:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8034c4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034ca:	c9                   	leaveq 
  8034cb:	c3                   	retq   

00000000008034cc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8034cc:	55                   	push   %rbp
  8034cd:	48 89 e5             	mov    %rsp,%rbp
  8034d0:	48 83 ec 18          	sub    $0x18,%rsp
  8034d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8034d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034df:	eb 09                	jmp    8034ea <strlen+0x1e>
		n++;
  8034e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8034e5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ee:	0f b6 00             	movzbl (%rax),%eax
  8034f1:	84 c0                	test   %al,%al
  8034f3:	75 ec                	jne    8034e1 <strlen+0x15>
		n++;
	return n;
  8034f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034f8:	c9                   	leaveq 
  8034f9:	c3                   	retq   

00000000008034fa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8034fa:	55                   	push   %rbp
  8034fb:	48 89 e5             	mov    %rsp,%rbp
  8034fe:	48 83 ec 20          	sub    $0x20,%rsp
  803502:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803506:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80350a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803511:	eb 0e                	jmp    803521 <strnlen+0x27>
		n++;
  803513:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803517:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80351c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803521:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803526:	74 0b                	je     803533 <strnlen+0x39>
  803528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352c:	0f b6 00             	movzbl (%rax),%eax
  80352f:	84 c0                	test   %al,%al
  803531:	75 e0                	jne    803513 <strnlen+0x19>
		n++;
	return n;
  803533:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803536:	c9                   	leaveq 
  803537:	c3                   	retq   

0000000000803538 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803538:	55                   	push   %rbp
  803539:	48 89 e5             	mov    %rsp,%rbp
  80353c:	48 83 ec 20          	sub    $0x20,%rsp
  803540:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803544:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803550:	90                   	nop
  803551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803555:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803559:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80355d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803561:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803565:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803569:	0f b6 12             	movzbl (%rdx),%edx
  80356c:	88 10                	mov    %dl,(%rax)
  80356e:	0f b6 00             	movzbl (%rax),%eax
  803571:	84 c0                	test   %al,%al
  803573:	75 dc                	jne    803551 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803579:	c9                   	leaveq 
  80357a:	c3                   	retq   

000000000080357b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80357b:	55                   	push   %rbp
  80357c:	48 89 e5             	mov    %rsp,%rbp
  80357f:	48 83 ec 20          	sub    $0x20,%rsp
  803583:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803587:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80358b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358f:	48 89 c7             	mov    %rax,%rdi
  803592:	48 b8 cc 34 80 00 00 	movabs $0x8034cc,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	48 63 d0             	movslq %eax,%rdx
  8035a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ab:	48 01 c2             	add    %rax,%rdx
  8035ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b2:	48 89 c6             	mov    %rax,%rsi
  8035b5:	48 89 d7             	mov    %rdx,%rdi
  8035b8:	48 b8 38 35 80 00 00 	movabs $0x803538,%rax
  8035bf:	00 00 00 
  8035c2:	ff d0                	callq  *%rax
	return dst;
  8035c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8035c8:	c9                   	leaveq 
  8035c9:	c3                   	retq   

00000000008035ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8035ca:	55                   	push   %rbp
  8035cb:	48 89 e5             	mov    %rsp,%rbp
  8035ce:	48 83 ec 28          	sub    $0x28,%rsp
  8035d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8035de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8035e6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035ed:	00 
  8035ee:	eb 2a                	jmp    80361a <strncpy+0x50>
		*dst++ = *src;
  8035f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803600:	0f b6 12             	movzbl (%rdx),%edx
  803603:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803605:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803609:	0f b6 00             	movzbl (%rax),%eax
  80360c:	84 c0                	test   %al,%al
  80360e:	74 05                	je     803615 <strncpy+0x4b>
			src++;
  803610:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803615:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80361a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803622:	72 cc                	jb     8035f0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803624:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803628:	c9                   	leaveq 
  803629:	c3                   	retq   

000000000080362a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80362a:	55                   	push   %rbp
  80362b:	48 89 e5             	mov    %rsp,%rbp
  80362e:	48 83 ec 28          	sub    $0x28,%rsp
  803632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803636:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80363a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80363e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803642:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803646:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80364b:	74 3d                	je     80368a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80364d:	eb 1d                	jmp    80366c <strlcpy+0x42>
			*dst++ = *src++;
  80364f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803653:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803657:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80365b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80365f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803663:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803667:	0f b6 12             	movzbl (%rdx),%edx
  80366a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80366c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803671:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803676:	74 0b                	je     803683 <strlcpy+0x59>
  803678:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80367c:	0f b6 00             	movzbl (%rax),%eax
  80367f:	84 c0                	test   %al,%al
  803681:	75 cc                	jne    80364f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803687:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80368a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80368e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803692:	48 29 c2             	sub    %rax,%rdx
  803695:	48 89 d0             	mov    %rdx,%rax
}
  803698:	c9                   	leaveq 
  803699:	c3                   	retq   

000000000080369a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80369a:	55                   	push   %rbp
  80369b:	48 89 e5             	mov    %rsp,%rbp
  80369e:	48 83 ec 10          	sub    $0x10,%rsp
  8036a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8036aa:	eb 0a                	jmp    8036b6 <strcmp+0x1c>
		p++, q++;
  8036ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036b1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8036b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ba:	0f b6 00             	movzbl (%rax),%eax
  8036bd:	84 c0                	test   %al,%al
  8036bf:	74 12                	je     8036d3 <strcmp+0x39>
  8036c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c5:	0f b6 10             	movzbl (%rax),%edx
  8036c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cc:	0f b6 00             	movzbl (%rax),%eax
  8036cf:	38 c2                	cmp    %al,%dl
  8036d1:	74 d9                	je     8036ac <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8036d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d7:	0f b6 00             	movzbl (%rax),%eax
  8036da:	0f b6 d0             	movzbl %al,%edx
  8036dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e1:	0f b6 00             	movzbl (%rax),%eax
  8036e4:	0f b6 c0             	movzbl %al,%eax
  8036e7:	29 c2                	sub    %eax,%edx
  8036e9:	89 d0                	mov    %edx,%eax
}
  8036eb:	c9                   	leaveq 
  8036ec:	c3                   	retq   

00000000008036ed <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8036ed:	55                   	push   %rbp
  8036ee:	48 89 e5             	mov    %rsp,%rbp
  8036f1:	48 83 ec 18          	sub    $0x18,%rsp
  8036f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803701:	eb 0f                	jmp    803712 <strncmp+0x25>
		n--, p++, q++;
  803703:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803708:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80370d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803712:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803717:	74 1d                	je     803736 <strncmp+0x49>
  803719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371d:	0f b6 00             	movzbl (%rax),%eax
  803720:	84 c0                	test   %al,%al
  803722:	74 12                	je     803736 <strncmp+0x49>
  803724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803728:	0f b6 10             	movzbl (%rax),%edx
  80372b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372f:	0f b6 00             	movzbl (%rax),%eax
  803732:	38 c2                	cmp    %al,%dl
  803734:	74 cd                	je     803703 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803736:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80373b:	75 07                	jne    803744 <strncmp+0x57>
		return 0;
  80373d:	b8 00 00 00 00       	mov    $0x0,%eax
  803742:	eb 18                	jmp    80375c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  803744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803748:	0f b6 00             	movzbl (%rax),%eax
  80374b:	0f b6 d0             	movzbl %al,%edx
  80374e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803752:	0f b6 00             	movzbl (%rax),%eax
  803755:	0f b6 c0             	movzbl %al,%eax
  803758:	29 c2                	sub    %eax,%edx
  80375a:	89 d0                	mov    %edx,%eax
}
  80375c:	c9                   	leaveq 
  80375d:	c3                   	retq   

000000000080375e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80375e:	55                   	push   %rbp
  80375f:	48 89 e5             	mov    %rsp,%rbp
  803762:	48 83 ec 0c          	sub    $0xc,%rsp
  803766:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80376a:	89 f0                	mov    %esi,%eax
  80376c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80376f:	eb 17                	jmp    803788 <strchr+0x2a>
		if (*s == c)
  803771:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803775:	0f b6 00             	movzbl (%rax),%eax
  803778:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80377b:	75 06                	jne    803783 <strchr+0x25>
			return (char *) s;
  80377d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803781:	eb 15                	jmp    803798 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803783:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378c:	0f b6 00             	movzbl (%rax),%eax
  80378f:	84 c0                	test   %al,%al
  803791:	75 de                	jne    803771 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803798:	c9                   	leaveq 
  803799:	c3                   	retq   

000000000080379a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80379a:	55                   	push   %rbp
  80379b:	48 89 e5             	mov    %rsp,%rbp
  80379e:	48 83 ec 0c          	sub    $0xc,%rsp
  8037a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a6:	89 f0                	mov    %esi,%eax
  8037a8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8037ab:	eb 13                	jmp    8037c0 <strfind+0x26>
		if (*s == c)
  8037ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b1:	0f b6 00             	movzbl (%rax),%eax
  8037b4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8037b7:	75 02                	jne    8037bb <strfind+0x21>
			break;
  8037b9:	eb 10                	jmp    8037cb <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8037bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c4:	0f b6 00             	movzbl (%rax),%eax
  8037c7:	84 c0                	test   %al,%al
  8037c9:	75 e2                	jne    8037ad <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8037cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037cf:	c9                   	leaveq 
  8037d0:	c3                   	retq   

00000000008037d1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8037d1:	55                   	push   %rbp
  8037d2:	48 89 e5             	mov    %rsp,%rbp
  8037d5:	48 83 ec 18          	sub    $0x18,%rsp
  8037d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037dd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8037e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8037e4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8037e9:	75 06                	jne    8037f1 <memset+0x20>
		return v;
  8037eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ef:	eb 69                	jmp    80385a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8037f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f5:	83 e0 03             	and    $0x3,%eax
  8037f8:	48 85 c0             	test   %rax,%rax
  8037fb:	75 48                	jne    803845 <memset+0x74>
  8037fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803801:	83 e0 03             	and    $0x3,%eax
  803804:	48 85 c0             	test   %rax,%rax
  803807:	75 3c                	jne    803845 <memset+0x74>
		c &= 0xFF;
  803809:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803810:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803813:	c1 e0 18             	shl    $0x18,%eax
  803816:	89 c2                	mov    %eax,%edx
  803818:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80381b:	c1 e0 10             	shl    $0x10,%eax
  80381e:	09 c2                	or     %eax,%edx
  803820:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803823:	c1 e0 08             	shl    $0x8,%eax
  803826:	09 d0                	or     %edx,%eax
  803828:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80382b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382f:	48 c1 e8 02          	shr    $0x2,%rax
  803833:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803836:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80383a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80383d:	48 89 d7             	mov    %rdx,%rdi
  803840:	fc                   	cld    
  803841:	f3 ab                	rep stos %eax,%es:(%rdi)
  803843:	eb 11                	jmp    803856 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803845:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803849:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80384c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803850:	48 89 d7             	mov    %rdx,%rdi
  803853:	fc                   	cld    
  803854:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  803856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80385a:	c9                   	leaveq 
  80385b:	c3                   	retq   

000000000080385c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80385c:	55                   	push   %rbp
  80385d:	48 89 e5             	mov    %rsp,%rbp
  803860:	48 83 ec 28          	sub    $0x28,%rsp
  803864:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803868:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80386c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  803870:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803874:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  803880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803884:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803888:	0f 83 88 00 00 00    	jae    803916 <memmove+0xba>
  80388e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803892:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803896:	48 01 d0             	add    %rdx,%rax
  803899:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80389d:	76 77                	jbe    803916 <memmove+0xba>
		s += n;
  80389f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8038a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ab:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8038af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b3:	83 e0 03             	and    $0x3,%eax
  8038b6:	48 85 c0             	test   %rax,%rax
  8038b9:	75 3b                	jne    8038f6 <memmove+0x9a>
  8038bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bf:	83 e0 03             	and    $0x3,%eax
  8038c2:	48 85 c0             	test   %rax,%rax
  8038c5:	75 2f                	jne    8038f6 <memmove+0x9a>
  8038c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cb:	83 e0 03             	and    $0x3,%eax
  8038ce:	48 85 c0             	test   %rax,%rax
  8038d1:	75 23                	jne    8038f6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8038d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d7:	48 83 e8 04          	sub    $0x4,%rax
  8038db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038df:	48 83 ea 04          	sub    $0x4,%rdx
  8038e3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038e7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8038eb:	48 89 c7             	mov    %rax,%rdi
  8038ee:	48 89 d6             	mov    %rdx,%rsi
  8038f1:	fd                   	std    
  8038f2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038f4:	eb 1d                	jmp    803913 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8038f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8038fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803902:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390a:	48 89 d7             	mov    %rdx,%rdi
  80390d:	48 89 c1             	mov    %rax,%rcx
  803910:	fd                   	std    
  803911:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803913:	fc                   	cld    
  803914:	eb 57                	jmp    80396d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391a:	83 e0 03             	and    $0x3,%eax
  80391d:	48 85 c0             	test   %rax,%rax
  803920:	75 36                	jne    803958 <memmove+0xfc>
  803922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803926:	83 e0 03             	and    $0x3,%eax
  803929:	48 85 c0             	test   %rax,%rax
  80392c:	75 2a                	jne    803958 <memmove+0xfc>
  80392e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803932:	83 e0 03             	and    $0x3,%eax
  803935:	48 85 c0             	test   %rax,%rax
  803938:	75 1e                	jne    803958 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80393a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393e:	48 c1 e8 02          	shr    $0x2,%rax
  803942:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803949:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80394d:	48 89 c7             	mov    %rax,%rdi
  803950:	48 89 d6             	mov    %rdx,%rsi
  803953:	fc                   	cld    
  803954:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803956:	eb 15                	jmp    80396d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803960:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803964:	48 89 c7             	mov    %rax,%rdi
  803967:	48 89 d6             	mov    %rdx,%rsi
  80396a:	fc                   	cld    
  80396b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80396d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803971:	c9                   	leaveq 
  803972:	c3                   	retq   

0000000000803973 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803973:	55                   	push   %rbp
  803974:	48 89 e5             	mov    %rsp,%rbp
  803977:	48 83 ec 18          	sub    $0x18,%rsp
  80397b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80397f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803983:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803987:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80398b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80398f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803993:	48 89 ce             	mov    %rcx,%rsi
  803996:	48 89 c7             	mov    %rax,%rdi
  803999:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
}
  8039a5:	c9                   	leaveq 
  8039a6:	c3                   	retq   

00000000008039a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8039a7:	55                   	push   %rbp
  8039a8:	48 89 e5             	mov    %rsp,%rbp
  8039ab:	48 83 ec 28          	sub    $0x28,%rsp
  8039af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8039bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8039c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8039cb:	eb 36                	jmp    803a03 <memcmp+0x5c>
		if (*s1 != *s2)
  8039cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d1:	0f b6 10             	movzbl (%rax),%edx
  8039d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d8:	0f b6 00             	movzbl (%rax),%eax
  8039db:	38 c2                	cmp    %al,%dl
  8039dd:	74 1a                	je     8039f9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8039df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e3:	0f b6 00             	movzbl (%rax),%eax
  8039e6:	0f b6 d0             	movzbl %al,%edx
  8039e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ed:	0f b6 00             	movzbl (%rax),%eax
  8039f0:	0f b6 c0             	movzbl %al,%eax
  8039f3:	29 c2                	sub    %eax,%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	eb 20                	jmp    803a19 <memcmp+0x72>
		s1++, s2++;
  8039f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a07:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803a0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803a0f:	48 85 c0             	test   %rax,%rax
  803a12:	75 b9                	jne    8039cd <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a19:	c9                   	leaveq 
  803a1a:	c3                   	retq   

0000000000803a1b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803a1b:	55                   	push   %rbp
  803a1c:	48 89 e5             	mov    %rsp,%rbp
  803a1f:	48 83 ec 28          	sub    $0x28,%rsp
  803a23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a27:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803a2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a36:	48 01 d0             	add    %rdx,%rax
  803a39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803a3d:	eb 15                	jmp    803a54 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a43:	0f b6 10             	movzbl (%rax),%edx
  803a46:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a49:	38 c2                	cmp    %al,%dl
  803a4b:	75 02                	jne    803a4f <memfind+0x34>
			break;
  803a4d:	eb 0f                	jmp    803a5e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803a4f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a58:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803a5c:	72 e1                	jb     803a3f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803a62:	c9                   	leaveq 
  803a63:	c3                   	retq   

0000000000803a64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803a64:	55                   	push   %rbp
  803a65:	48 89 e5             	mov    %rsp,%rbp
  803a68:	48 83 ec 34          	sub    $0x34,%rsp
  803a6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a74:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803a77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803a7e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803a85:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a86:	eb 05                	jmp    803a8d <strtol+0x29>
		s++;
  803a88:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a91:	0f b6 00             	movzbl (%rax),%eax
  803a94:	3c 20                	cmp    $0x20,%al
  803a96:	74 f0                	je     803a88 <strtol+0x24>
  803a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9c:	0f b6 00             	movzbl (%rax),%eax
  803a9f:	3c 09                	cmp    $0x9,%al
  803aa1:	74 e5                	je     803a88 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803aa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa7:	0f b6 00             	movzbl (%rax),%eax
  803aaa:	3c 2b                	cmp    $0x2b,%al
  803aac:	75 07                	jne    803ab5 <strtol+0x51>
		s++;
  803aae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803ab3:	eb 17                	jmp    803acc <strtol+0x68>
	else if (*s == '-')
  803ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab9:	0f b6 00             	movzbl (%rax),%eax
  803abc:	3c 2d                	cmp    $0x2d,%al
  803abe:	75 0c                	jne    803acc <strtol+0x68>
		s++, neg = 1;
  803ac0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803ac5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803acc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803ad0:	74 06                	je     803ad8 <strtol+0x74>
  803ad2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803ad6:	75 28                	jne    803b00 <strtol+0x9c>
  803ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803adc:	0f b6 00             	movzbl (%rax),%eax
  803adf:	3c 30                	cmp    $0x30,%al
  803ae1:	75 1d                	jne    803b00 <strtol+0x9c>
  803ae3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae7:	48 83 c0 01          	add    $0x1,%rax
  803aeb:	0f b6 00             	movzbl (%rax),%eax
  803aee:	3c 78                	cmp    $0x78,%al
  803af0:	75 0e                	jne    803b00 <strtol+0x9c>
		s += 2, base = 16;
  803af2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803af7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803afe:	eb 2c                	jmp    803b2c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803b00:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803b04:	75 19                	jne    803b1f <strtol+0xbb>
  803b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0a:	0f b6 00             	movzbl (%rax),%eax
  803b0d:	3c 30                	cmp    $0x30,%al
  803b0f:	75 0e                	jne    803b1f <strtol+0xbb>
		s++, base = 8;
  803b11:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b16:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803b1d:	eb 0d                	jmp    803b2c <strtol+0xc8>
	else if (base == 0)
  803b1f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803b23:	75 07                	jne    803b2c <strtol+0xc8>
		base = 10;
  803b25:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803b2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b30:	0f b6 00             	movzbl (%rax),%eax
  803b33:	3c 2f                	cmp    $0x2f,%al
  803b35:	7e 1d                	jle    803b54 <strtol+0xf0>
  803b37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3b:	0f b6 00             	movzbl (%rax),%eax
  803b3e:	3c 39                	cmp    $0x39,%al
  803b40:	7f 12                	jg     803b54 <strtol+0xf0>
			dig = *s - '0';
  803b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b46:	0f b6 00             	movzbl (%rax),%eax
  803b49:	0f be c0             	movsbl %al,%eax
  803b4c:	83 e8 30             	sub    $0x30,%eax
  803b4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b52:	eb 4e                	jmp    803ba2 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b58:	0f b6 00             	movzbl (%rax),%eax
  803b5b:	3c 60                	cmp    $0x60,%al
  803b5d:	7e 1d                	jle    803b7c <strtol+0x118>
  803b5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b63:	0f b6 00             	movzbl (%rax),%eax
  803b66:	3c 7a                	cmp    $0x7a,%al
  803b68:	7f 12                	jg     803b7c <strtol+0x118>
			dig = *s - 'a' + 10;
  803b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6e:	0f b6 00             	movzbl (%rax),%eax
  803b71:	0f be c0             	movsbl %al,%eax
  803b74:	83 e8 57             	sub    $0x57,%eax
  803b77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b7a:	eb 26                	jmp    803ba2 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803b7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b80:	0f b6 00             	movzbl (%rax),%eax
  803b83:	3c 40                	cmp    $0x40,%al
  803b85:	7e 48                	jle    803bcf <strtol+0x16b>
  803b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b8b:	0f b6 00             	movzbl (%rax),%eax
  803b8e:	3c 5a                	cmp    $0x5a,%al
  803b90:	7f 3d                	jg     803bcf <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b96:	0f b6 00             	movzbl (%rax),%eax
  803b99:	0f be c0             	movsbl %al,%eax
  803b9c:	83 e8 37             	sub    $0x37,%eax
  803b9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803ba2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba5:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803ba8:	7c 02                	jl     803bac <strtol+0x148>
			break;
  803baa:	eb 23                	jmp    803bcf <strtol+0x16b>
		s++, val = (val * base) + dig;
  803bac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803bb1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803bb4:	48 98                	cltq   
  803bb6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803bbb:	48 89 c2             	mov    %rax,%rdx
  803bbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc1:	48 98                	cltq   
  803bc3:	48 01 d0             	add    %rdx,%rax
  803bc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803bca:	e9 5d ff ff ff       	jmpq   803b2c <strtol+0xc8>

	if (endptr)
  803bcf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803bd4:	74 0b                	je     803be1 <strtol+0x17d>
		*endptr = (char *) s;
  803bd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bda:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bde:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be5:	74 09                	je     803bf0 <strtol+0x18c>
  803be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803beb:	48 f7 d8             	neg    %rax
  803bee:	eb 04                	jmp    803bf4 <strtol+0x190>
  803bf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803bf4:	c9                   	leaveq 
  803bf5:	c3                   	retq   

0000000000803bf6 <strstr>:

char * strstr(const char *in, const char *str)
{
  803bf6:	55                   	push   %rbp
  803bf7:	48 89 e5             	mov    %rsp,%rbp
  803bfa:	48 83 ec 30          	sub    $0x30,%rsp
  803bfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803c06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803c0e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803c12:	0f b6 00             	movzbl (%rax),%eax
  803c15:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803c18:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803c1c:	75 06                	jne    803c24 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803c1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c22:	eb 6b                	jmp    803c8f <strstr+0x99>

	len = strlen(str);
  803c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c28:	48 89 c7             	mov    %rax,%rdi
  803c2b:	48 b8 cc 34 80 00 00 	movabs $0x8034cc,%rax
  803c32:	00 00 00 
  803c35:	ff d0                	callq  *%rax
  803c37:	48 98                	cltq   
  803c39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803c3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803c45:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803c49:	0f b6 00             	movzbl (%rax),%eax
  803c4c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803c4f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803c53:	75 07                	jne    803c5c <strstr+0x66>
				return (char *) 0;
  803c55:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5a:	eb 33                	jmp    803c8f <strstr+0x99>
		} while (sc != c);
  803c5c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803c60:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803c63:	75 d8                	jne    803c3d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803c65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c69:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803c6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c71:	48 89 ce             	mov    %rcx,%rsi
  803c74:	48 89 c7             	mov    %rax,%rdi
  803c77:	48 b8 ed 36 80 00 00 	movabs $0x8036ed,%rax
  803c7e:	00 00 00 
  803c81:	ff d0                	callq  *%rax
  803c83:	85 c0                	test   %eax,%eax
  803c85:	75 b6                	jne    803c3d <strstr+0x47>

	return (char *) (in - 1);
  803c87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8b:	48 83 e8 01          	sub    $0x1,%rax
}
  803c8f:	c9                   	leaveq 
  803c90:	c3                   	retq   

0000000000803c91 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c91:	55                   	push   %rbp
  803c92:	48 89 e5             	mov    %rsp,%rbp
  803c95:	48 83 ec 10          	sub    $0x10,%rsp
  803c99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803c9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca4:	00 00 00 
  803ca7:	48 8b 00             	mov    (%rax),%rax
  803caa:	48 85 c0             	test   %rax,%rax
  803cad:	0f 85 84 00 00 00    	jne    803d37 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803cb3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cba:	00 00 00 
  803cbd:	48 8b 00             	mov    (%rax),%rax
  803cc0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803cc6:	ba 07 00 00 00       	mov    $0x7,%edx
  803ccb:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803cd0:	89 c7                	mov    %eax,%edi
  803cd2:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	79 2a                	jns    803d0c <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ce2:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  803ce9:	00 00 00 
  803cec:	be 23 00 00 00       	mov    $0x23,%esi
  803cf1:	48 bf 8f 46 80 00 00 	movabs $0x80468f,%rdi
  803cf8:	00 00 00 
  803cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803d00:	48 b9 4a 27 80 00 00 	movabs $0x80274a,%rcx
  803d07:	00 00 00 
  803d0a:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803d0c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d13:	00 00 00 
  803d16:	48 8b 00             	mov    (%rax),%rax
  803d19:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d1f:	48 be 37 06 80 00 00 	movabs $0x800637,%rsi
  803d26:	00 00 00 
  803d29:	89 c7                	mov    %eax,%edi
  803d2b:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  803d32:	00 00 00 
  803d35:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803d37:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d3e:	00 00 00 
  803d41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d45:	48 89 10             	mov    %rdx,(%rax)
}
  803d48:	c9                   	leaveq 
  803d49:	c3                   	retq   

0000000000803d4a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d4a:	55                   	push   %rbp
  803d4b:	48 89 e5             	mov    %rsp,%rbp
  803d4e:	48 83 ec 30          	sub    $0x30,%rsp
  803d52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803d5e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d65:	00 00 00 
  803d68:	48 8b 00             	mov    (%rax),%rax
  803d6b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d71:	85 c0                	test   %eax,%eax
  803d73:	75 3c                	jne    803db1 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d75:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  803d7c:	00 00 00 
  803d7f:	ff d0                	callq  *%rax
  803d81:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d86:	48 63 d0             	movslq %eax,%rdx
  803d89:	48 89 d0             	mov    %rdx,%rax
  803d8c:	48 c1 e0 03          	shl    $0x3,%rax
  803d90:	48 01 d0             	add    %rdx,%rax
  803d93:	48 c1 e0 05          	shl    $0x5,%rax
  803d97:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d9e:	00 00 00 
  803da1:	48 01 c2             	add    %rax,%rdx
  803da4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dab:	00 00 00 
  803dae:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803db1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803db6:	75 0e                	jne    803dc6 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803db8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dbf:	00 00 00 
  803dc2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803dc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dca:	48 89 c7             	mov    %rax,%rdi
  803dcd:	48 b8 27 05 80 00 00 	movabs $0x800527,%rax
  803dd4:	00 00 00 
  803dd7:	ff d0                	callq  *%rax
  803dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de0:	79 19                	jns    803dfb <ipc_recv+0xb1>
		*from_env_store = 0;
  803de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803dec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df9:	eb 53                	jmp    803e4e <ipc_recv+0x104>
	}
	if(from_env_store)
  803dfb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e00:	74 19                	je     803e1b <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803e02:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e09:	00 00 00 
  803e0c:	48 8b 00             	mov    (%rax),%rax
  803e0f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e19:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e20:	74 19                	je     803e3b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803e22:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e29:	00 00 00 
  803e2c:	48 8b 00             	mov    (%rax),%rax
  803e2f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e39:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e3b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e42:	00 00 00 
  803e45:	48 8b 00             	mov    (%rax),%rax
  803e48:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e4e:	c9                   	leaveq 
  803e4f:	c3                   	retq   

0000000000803e50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e50:	55                   	push   %rbp
  803e51:	48 89 e5             	mov    %rsp,%rbp
  803e54:	48 83 ec 30          	sub    $0x30,%rsp
  803e58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e5e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e62:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803e65:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e6a:	75 0e                	jne    803e7a <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e6c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e73:	00 00 00 
  803e76:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e7a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e7d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e80:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e87:	89 c7                	mov    %eax,%edi
  803e89:	48 b8 d2 04 80 00 00 	movabs $0x8004d2,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
  803e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e98:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e9c:	75 0c                	jne    803eaa <ipc_send+0x5a>
			sys_yield();
  803e9e:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803eaa:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803eae:	74 ca                	je     803e7a <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803eb0:	c9                   	leaveq 
  803eb1:	c3                   	retq   

0000000000803eb2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803eb2:	55                   	push   %rbp
  803eb3:	48 89 e5             	mov    %rsp,%rbp
  803eb6:	48 83 ec 14          	sub    $0x14,%rsp
  803eba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ebd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ec4:	eb 5e                	jmp    803f24 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ec6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ecd:	00 00 00 
  803ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed3:	48 63 d0             	movslq %eax,%rdx
  803ed6:	48 89 d0             	mov    %rdx,%rax
  803ed9:	48 c1 e0 03          	shl    $0x3,%rax
  803edd:	48 01 d0             	add    %rdx,%rax
  803ee0:	48 c1 e0 05          	shl    $0x5,%rax
  803ee4:	48 01 c8             	add    %rcx,%rax
  803ee7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803eed:	8b 00                	mov    (%rax),%eax
  803eef:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ef2:	75 2c                	jne    803f20 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ef4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803efb:	00 00 00 
  803efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f01:	48 63 d0             	movslq %eax,%rdx
  803f04:	48 89 d0             	mov    %rdx,%rax
  803f07:	48 c1 e0 03          	shl    $0x3,%rax
  803f0b:	48 01 d0             	add    %rdx,%rax
  803f0e:	48 c1 e0 05          	shl    $0x5,%rax
  803f12:	48 01 c8             	add    %rcx,%rax
  803f15:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f1b:	8b 40 08             	mov    0x8(%rax),%eax
  803f1e:	eb 12                	jmp    803f32 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f20:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f24:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f2b:	7e 99                	jle    803ec6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f32:	c9                   	leaveq 
  803f33:	c3                   	retq   

0000000000803f34 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f34:	55                   	push   %rbp
  803f35:	48 89 e5             	mov    %rsp,%rbp
  803f38:	48 83 ec 18          	sub    $0x18,%rsp
  803f3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f44:	48 c1 e8 15          	shr    $0x15,%rax
  803f48:	48 89 c2             	mov    %rax,%rdx
  803f4b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f52:	01 00 00 
  803f55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f59:	83 e0 01             	and    $0x1,%eax
  803f5c:	48 85 c0             	test   %rax,%rax
  803f5f:	75 07                	jne    803f68 <pageref+0x34>
		return 0;
  803f61:	b8 00 00 00 00       	mov    $0x0,%eax
  803f66:	eb 53                	jmp    803fbb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6c:	48 c1 e8 0c          	shr    $0xc,%rax
  803f70:	48 89 c2             	mov    %rax,%rdx
  803f73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f7a:	01 00 00 
  803f7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f81:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f89:	83 e0 01             	and    $0x1,%eax
  803f8c:	48 85 c0             	test   %rax,%rax
  803f8f:	75 07                	jne    803f98 <pageref+0x64>
		return 0;
  803f91:	b8 00 00 00 00       	mov    $0x0,%eax
  803f96:	eb 23                	jmp    803fbb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f9c:	48 c1 e8 0c          	shr    $0xc,%rax
  803fa0:	48 89 c2             	mov    %rax,%rdx
  803fa3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803faa:	00 00 00 
  803fad:	48 c1 e2 04          	shl    $0x4,%rdx
  803fb1:	48 01 d0             	add    %rdx,%rax
  803fb4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fb8:	0f b7 c0             	movzwl %ax,%eax
}
  803fbb:	c9                   	leaveq 
  803fbc:	c3                   	retq   
