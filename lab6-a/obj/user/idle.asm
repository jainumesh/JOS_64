
obj/user/idle.debug:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800059:	00 00 00 
  80005c:	48 ba 80 3e 80 00 00 	movabs $0x803e80,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	25 ff 03 00 00       	and    $0x3ff,%eax
  800097:	48 63 d0             	movslq %eax,%rdx
  80009a:	48 89 d0             	mov    %rdx,%rax
  80009d:	48 c1 e0 03          	shl    $0x3,%rax
  8000a1:	48 01 d0             	add    %rdx,%rax
  8000a4:	48 c1 e0 05          	shl    $0x5,%rax
  8000a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000af:	00 00 00 
  8000b2:	48 01 c2             	add    %rax,%rdx
  8000b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000bc:	00 00 00 
  8000bf:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c6:	7e 14                	jle    8000dc <libmain+0x65>
		binaryname = argv[0];
  8000c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cc:	48 8b 10             	mov    (%rax),%rdx
  8000cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e3:	48 89 d6             	mov    %rdx,%rsi
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8000f4:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800106:	48 b8 75 09 80 00 00 	movabs $0x800975,%rax
  80010d:	00 00 00 
  800110:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax

}
  800123:	5d                   	pop    %rbp
  800124:	c3                   	retq   

0000000000800125 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	53                   	push   %rbx
  80012a:	48 83 ec 48          	sub    $0x48,%rsp
  80012e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800131:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800134:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800138:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800140:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800144:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800147:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80014f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800153:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800157:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015b:	4c 89 c3             	mov    %r8,%rbx
  80015e:	cd 30                	int    $0x30
  800160:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800164:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800168:	74 3e                	je     8001a8 <syscall+0x83>
  80016a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80016f:	7e 37                	jle    8001a8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800175:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800178:	49 89 d0             	mov    %rdx,%r8
  80017b:	89 c1                	mov    %eax,%ecx
  80017d:	48 ba 8f 3e 80 00 00 	movabs $0x803e8f,%rdx
  800184:	00 00 00 
  800187:	be 23 00 00 00       	mov    $0x23,%esi
  80018c:	48 bf ac 3e 80 00 00 	movabs $0x803eac,%rdi
  800193:	00 00 00 
  800196:	b8 00 00 00 00       	mov    $0x0,%eax
  80019b:	49 b9 c0 26 80 00 00 	movabs $0x8026c0,%r9
  8001a2:	00 00 00 
  8001a5:	41 ff d1             	callq  *%r9

	return ret;
  8001a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001ac:	48 83 c4 48          	add    $0x48,%rsp
  8001b0:	5b                   	pop    %rbx
  8001b1:	5d                   	pop    %rbp
  8001b2:	c3                   	retq   

00000000008001b3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b3:	55                   	push   %rbp
  8001b4:	48 89 e5             	mov    %rsp,%rbp
  8001b7:	48 83 ec 20          	sub    $0x20,%rsp
  8001bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d2:	00 
  8001d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001df:	48 89 d1             	mov    %rdx,%rcx
  8001e2:	48 89 c2             	mov    %rax,%rdx
  8001e5:	be 00 00 00 00       	mov    $0x0,%esi
  8001ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ef:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8001f6:	00 00 00 
  8001f9:	ff d0                	callq  *%rax
}
  8001fb:	c9                   	leaveq 
  8001fc:	c3                   	retq   

00000000008001fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fd:	55                   	push   %rbp
  8001fe:	48 89 e5             	mov    %rsp,%rbp
  800201:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800205:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020c:	00 
  80020d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800213:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	be 00 00 00 00       	mov    $0x0,%esi
  800228:	bf 01 00 00 00       	mov    $0x1,%edi
  80022d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 83 ec 10          	sub    $0x10,%rsp
  800243:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800249:	48 98                	cltq   
  80024b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800252:	00 
  800253:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800259:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800264:	48 89 c2             	mov    %rax,%rdx
  800267:	be 01 00 00 00       	mov    $0x1,%esi
  80026c:	bf 03 00 00 00       	mov    $0x3,%edi
  800271:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
}
  80027d:	c9                   	leaveq 
  80027e:	c3                   	retq   

000000000080027f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800287:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80028e:	00 
  80028f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a5:	be 00 00 00 00       	mov    $0x0,%esi
  8002aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8002af:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	callq  *%rax
}
  8002bb:	c9                   	leaveq 
  8002bc:	c3                   	retq   

00000000008002bd <sys_yield>:

void
sys_yield(void)
{
  8002bd:	55                   	push   %rbp
  8002be:	48 89 e5             	mov    %rsp,%rbp
  8002c1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002cc:	00 
  8002cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002de:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e3:	be 00 00 00 00       	mov    $0x0,%esi
  8002e8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002ed:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
}
  8002f9:	c9                   	leaveq 
  8002fa:	c3                   	retq   

00000000008002fb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002fb:	55                   	push   %rbp
  8002fc:	48 89 e5             	mov    %rsp,%rbp
  8002ff:	48 83 ec 20          	sub    $0x20,%rsp
  800303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80030d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800310:	48 63 c8             	movslq %eax,%rcx
  800313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031a:	48 98                	cltq   
  80031c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800323:	00 
  800324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032a:	49 89 c8             	mov    %rcx,%r8
  80032d:	48 89 d1             	mov    %rdx,%rcx
  800330:	48 89 c2             	mov    %rax,%rdx
  800333:	be 01 00 00 00       	mov    $0x1,%esi
  800338:	bf 04 00 00 00       	mov    $0x4,%edi
  80033d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
}
  800349:	c9                   	leaveq 
  80034a:	c3                   	retq   

000000000080034b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034b:	55                   	push   %rbp
  80034c:	48 89 e5             	mov    %rsp,%rbp
  80034f:	48 83 ec 30          	sub    $0x30,%rsp
  800353:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800356:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80035d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800361:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800368:	48 63 c8             	movslq %eax,%rcx
  80036b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800372:	48 63 f0             	movslq %eax,%rsi
  800375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037c:	48 98                	cltq   
  80037e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800382:	49 89 f9             	mov    %rdi,%r9
  800385:	49 89 f0             	mov    %rsi,%r8
  800388:	48 89 d1             	mov    %rdx,%rcx
  80038b:	48 89 c2             	mov    %rax,%rdx
  80038e:	be 01 00 00 00       	mov    $0x1,%esi
  800393:	bf 05 00 00 00       	mov    $0x5,%edi
  800398:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	c9                   	leaveq 
  8003a5:	c3                   	retq   

00000000008003a6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp
  8003aa:	48 83 ec 20          	sub    $0x20,%rsp
  8003ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bc:	48 98                	cltq   
  8003be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c5:	00 
  8003c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d2:	48 89 d1             	mov    %rdx,%rcx
  8003d5:	48 89 c2             	mov    %rax,%rdx
  8003d8:	be 01 00 00 00       	mov    $0x1,%esi
  8003dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e2:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 10          	sub    $0x10,%rsp
  8003f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800401:	48 63 d0             	movslq %eax,%rdx
  800404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800407:	48 98                	cltq   
  800409:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800410:	00 
  800411:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041d:	48 89 d1             	mov    %rdx,%rcx
  800420:	48 89 c2             	mov    %rax,%rdx
  800423:	be 01 00 00 00       	mov    $0x1,%esi
  800428:	bf 08 00 00 00       	mov    $0x8,%edi
  80042d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax
}
  800439:	c9                   	leaveq 
  80043a:	c3                   	retq   

000000000080043b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	48 83 ec 20          	sub    $0x20,%rsp
  800443:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800451:	48 98                	cltq   
  800453:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045a:	00 
  80045b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800467:	48 89 d1             	mov    %rdx,%rcx
  80046a:	48 89 c2             	mov    %rax,%rdx
  80046d:	be 01 00 00 00       	mov    $0x1,%esi
  800472:	bf 09 00 00 00       	mov    $0x9,%edi
  800477:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
}
  800483:	c9                   	leaveq 
  800484:	c3                   	retq   

0000000000800485 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800485:	55                   	push   %rbp
  800486:	48 89 e5             	mov    %rsp,%rbp
  800489:	48 83 ec 20          	sub    $0x20,%rsp
  80048d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800494:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049b:	48 98                	cltq   
  80049d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a4:	00 
  8004a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b1:	48 89 d1             	mov    %rdx,%rcx
  8004b4:	48 89 c2             	mov    %rax,%rdx
  8004b7:	be 01 00 00 00       	mov    $0x1,%esi
  8004bc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c1:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
}
  8004cd:	c9                   	leaveq 
  8004ce:	c3                   	retq   

00000000008004cf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004cf:	55                   	push   %rbp
  8004d0:	48 89 e5             	mov    %rsp,%rbp
  8004d3:	48 83 ec 20          	sub    $0x20,%rsp
  8004d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004e8:	48 63 f0             	movslq %eax,%rsi
  8004eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f2:	48 98                	cltq   
  8004f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ff:	00 
  800500:	49 89 f1             	mov    %rsi,%r9
  800503:	49 89 c8             	mov    %rcx,%r8
  800506:	48 89 d1             	mov    %rdx,%rcx
  800509:	48 89 c2             	mov    %rax,%rdx
  80050c:	be 00 00 00 00       	mov    $0x0,%esi
  800511:	bf 0c 00 00 00       	mov    $0xc,%edi
  800516:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
}
  800522:	c9                   	leaveq 
  800523:	c3                   	retq   

0000000000800524 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800534:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80053b:	00 
  80053c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800542:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800548:	b9 00 00 00 00       	mov    $0x0,%ecx
  80054d:	48 89 c2             	mov    %rax,%rdx
  800550:	be 01 00 00 00       	mov    $0x1,%esi
  800555:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055a:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
}
  800566:	c9                   	leaveq 
  800567:	c3                   	retq   

0000000000800568 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800568:	55                   	push   %rbp
  800569:	48 89 e5             	mov    %rsp,%rbp
  80056c:	48 83 ec 20          	sub    $0x20,%rsp
  800570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800574:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  800578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800580:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800587:	00 
  800588:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80058e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800594:	48 89 d1             	mov    %rdx,%rcx
  800597:	48 89 c2             	mov    %rax,%rdx
  80059a:	be 01 00 00 00       	mov    $0x1,%esi
  80059f:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005a4:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
}
  8005b0:	c9                   	leaveq 
  8005b1:	c3                   	retq   

00000000008005b2 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8005b2:	55                   	push   %rbp
  8005b3:	48 89 e5             	mov    %rsp,%rbp
  8005b6:	48 83 ec 10          	sub    $0x10,%rsp
  8005ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8005be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005c9:	00 
  8005ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005db:	48 89 c2             	mov    %rax,%rdx
  8005de:	be 00 00 00 00       	mov    $0x0,%esi
  8005e3:	bf 10 00 00 00       	mov    $0x10,%edi
  8005e8:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8005ef:	00 00 00 
  8005f2:	ff d0                	callq  *%rax
}
  8005f4:	c9                   	leaveq 
  8005f5:	c3                   	retq   

00000000008005f6 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8005f6:	55                   	push   %rbp
  8005f7:	48 89 e5             	mov    %rsp,%rbp
  8005fa:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8005fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800605:	00 
  800606:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80060c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800612:	b9 00 00 00 00       	mov    $0x0,%ecx
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	be 00 00 00 00       	mov    $0x0,%esi
  800621:	bf 0e 00 00 00       	mov    $0xe,%edi
  800626:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80062d:	00 00 00 
  800630:	ff d0                	callq  *%rax
}
  800632:	c9                   	leaveq 
  800633:	c3                   	retq   

0000000000800634 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800634:	55                   	push   %rbp
  800635:	48 89 e5             	mov    %rsp,%rbp
  800638:	48 83 ec 08          	sub    $0x8,%rsp
  80063c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800640:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800644:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80064b:	ff ff ff 
  80064e:	48 01 d0             	add    %rdx,%rax
  800651:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800655:	c9                   	leaveq 
  800656:	c3                   	retq   

0000000000800657 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800657:	55                   	push   %rbp
  800658:	48 89 e5             	mov    %rsp,%rbp
  80065b:	48 83 ec 08          	sub    $0x8,%rsp
  80065f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800667:	48 89 c7             	mov    %rax,%rdi
  80066a:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800671:	00 00 00 
  800674:	ff d0                	callq  *%rax
  800676:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80067c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800680:	c9                   	leaveq 
  800681:	c3                   	retq   

0000000000800682 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800682:	55                   	push   %rbp
  800683:	48 89 e5             	mov    %rsp,%rbp
  800686:	48 83 ec 18          	sub    $0x18,%rsp
  80068a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80068e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800695:	eb 6b                	jmp    800702 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80069a:	48 98                	cltq   
  80069c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8006a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	48 c1 e8 15          	shr    $0x15,%rax
  8006b2:	48 89 c2             	mov    %rax,%rdx
  8006b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006bc:	01 00 00 
  8006bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c3:	83 e0 01             	and    $0x1,%eax
  8006c6:	48 85 c0             	test   %rax,%rax
  8006c9:	74 21                	je     8006ec <fd_alloc+0x6a>
  8006cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8006d3:	48 89 c2             	mov    %rax,%rdx
  8006d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006dd:	01 00 00 
  8006e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006e4:	83 e0 01             	and    $0x1,%eax
  8006e7:	48 85 c0             	test   %rax,%rax
  8006ea:	75 12                	jne    8006fe <fd_alloc+0x7c>
			*fd_store = fd;
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fc:	eb 1a                	jmp    800718 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006fe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800702:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800706:	7e 8f                	jle    800697 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800713:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800718:	c9                   	leaveq 
  800719:	c3                   	retq   

000000000080071a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80071a:	55                   	push   %rbp
  80071b:	48 89 e5             	mov    %rsp,%rbp
  80071e:	48 83 ec 20          	sub    $0x20,%rsp
  800722:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800725:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800729:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80072d:	78 06                	js     800735 <fd_lookup+0x1b>
  80072f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800733:	7e 07                	jle    80073c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073a:	eb 6c                	jmp    8007a8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80073c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80073f:	48 98                	cltq   
  800741:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800747:	48 c1 e0 0c          	shl    $0xc,%rax
  80074b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80074f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800753:	48 c1 e8 15          	shr    $0x15,%rax
  800757:	48 89 c2             	mov    %rax,%rdx
  80075a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800761:	01 00 00 
  800764:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800768:	83 e0 01             	and    $0x1,%eax
  80076b:	48 85 c0             	test   %rax,%rax
  80076e:	74 21                	je     800791 <fd_lookup+0x77>
  800770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800774:	48 c1 e8 0c          	shr    $0xc,%rax
  800778:	48 89 c2             	mov    %rax,%rdx
  80077b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800782:	01 00 00 
  800785:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800789:	83 e0 01             	and    $0x1,%eax
  80078c:	48 85 c0             	test   %rax,%rax
  80078f:	75 07                	jne    800798 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800791:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800796:	eb 10                	jmp    8007a8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800798:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80079c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007a0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007a8:	c9                   	leaveq 
  8007a9:	c3                   	retq   

00000000008007aa <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007aa:	55                   	push   %rbp
  8007ab:	48 89 e5             	mov    %rsp,%rbp
  8007ae:	48 83 ec 30          	sub    $0x30,%rsp
  8007b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007b6:	89 f0                	mov    %esi,%eax
  8007b8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bf:	48 89 c7             	mov    %rax,%rdi
  8007c2:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  8007c9:	00 00 00 
  8007cc:	ff d0                	callq  *%rax
  8007ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8007d2:	48 89 d6             	mov    %rdx,%rsi
  8007d5:	89 c7                	mov    %eax,%edi
  8007d7:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  8007de:	00 00 00 
  8007e1:	ff d0                	callq  *%rax
  8007e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007ea:	78 0a                	js     8007f6 <fd_close+0x4c>
	    || fd != fd2)
  8007ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007f0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007f4:	74 12                	je     800808 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007f6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007fa:	74 05                	je     800801 <fd_close+0x57>
  8007fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007ff:	eb 05                	jmp    800806 <fd_close+0x5c>
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 69                	jmp    800871 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080c:	8b 00                	mov    (%rax),%eax
  80080e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800812:	48 89 d6             	mov    %rdx,%rsi
  800815:	89 c7                	mov    %eax,%edi
  800817:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
  800823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80082a:	78 2a                	js     800856 <fd_close+0xac>
		if (dev->dev_close)
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 40 20          	mov    0x20(%rax),%rax
  800834:	48 85 c0             	test   %rax,%rax
  800837:	74 16                	je     80084f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083d:	48 8b 40 20          	mov    0x20(%rax),%rax
  800841:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800845:	48 89 d7             	mov    %rdx,%rdi
  800848:	ff d0                	callq  *%rax
  80084a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80084d:	eb 07                	jmp    800856 <fd_close+0xac>
		else
			r = 0;
  80084f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085a:	48 89 c6             	mov    %rax,%rsi
  80085d:	bf 00 00 00 00       	mov    $0x0,%edi
  800862:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800869:	00 00 00 
  80086c:	ff d0                	callq  *%rax
	return r;
  80086e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 20          	sub    $0x20,%rsp
  80087b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80087e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800882:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800889:	eb 41                	jmp    8008cc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80088b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800892:	00 00 00 
  800895:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800898:	48 63 d2             	movslq %edx,%rdx
  80089b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80089f:	8b 00                	mov    (%rax),%eax
  8008a1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008a4:	75 22                	jne    8008c8 <dev_lookup+0x55>
			*dev = devtab[i];
  8008a6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008ad:	00 00 00 
  8008b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008b3:	48 63 d2             	movslq %edx,%rdx
  8008b6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008be:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 60                	jmp    800928 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008cc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008d3:	00 00 00 
  8008d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008d9:	48 63 d2             	movslq %edx,%rdx
  8008dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008e0:	48 85 c0             	test   %rax,%rax
  8008e3:	75 a6                	jne    80088b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008ec:	00 00 00 
  8008ef:	48 8b 00             	mov    (%rax),%rax
  8008f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008fb:	89 c6                	mov    %eax,%esi
  8008fd:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  800904:	00 00 00 
  800907:	b8 00 00 00 00       	mov    $0x0,%eax
  80090c:	48 b9 f9 28 80 00 00 	movabs $0x8028f9,%rcx
  800913:	00 00 00 
  800916:	ff d1                	callq  *%rcx
	*dev = 0;
  800918:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80091c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800928:	c9                   	leaveq 
  800929:	c3                   	retq   

000000000080092a <close>:

int
close(int fdnum)
{
  80092a:	55                   	push   %rbp
  80092b:	48 89 e5             	mov    %rsp,%rbp
  80092e:	48 83 ec 20          	sub    $0x20,%rsp
  800932:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800935:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80093c:	48 89 d6             	mov    %rdx,%rsi
  80093f:	89 c7                	mov    %eax,%edi
  800941:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800948:	00 00 00 
  80094b:	ff d0                	callq  *%rax
  80094d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800950:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800954:	79 05                	jns    80095b <close+0x31>
		return r;
  800956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800959:	eb 18                	jmp    800973 <close+0x49>
	else
		return fd_close(fd, 1);
  80095b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80095f:	be 01 00 00 00       	mov    $0x1,%esi
  800964:	48 89 c7             	mov    %rax,%rdi
  800967:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  80096e:	00 00 00 
  800971:	ff d0                	callq  *%rax
}
  800973:	c9                   	leaveq 
  800974:	c3                   	retq   

0000000000800975 <close_all>:

void
close_all(void)
{
  800975:	55                   	push   %rbp
  800976:	48 89 e5             	mov    %rsp,%rbp
  800979:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80097d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800984:	eb 15                	jmp    80099b <close_all+0x26>
		close(i);
  800986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800989:	89 c7                	mov    %eax,%edi
  80098b:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  800992:	00 00 00 
  800995:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800997:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80099b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80099f:	7e e5                	jle    800986 <close_all+0x11>
		close(i);
}
  8009a1:	c9                   	leaveq 
  8009a2:	c3                   	retq   

00000000008009a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009a3:	55                   	push   %rbp
  8009a4:	48 89 e5             	mov    %rsp,%rbp
  8009a7:	48 83 ec 40          	sub    $0x40,%rsp
  8009ab:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009ae:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009b1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009b8:	48 89 d6             	mov    %rdx,%rsi
  8009bb:	89 c7                	mov    %eax,%edi
  8009bd:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  8009c4:	00 00 00 
  8009c7:	ff d0                	callq  *%rax
  8009c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009d0:	79 08                	jns    8009da <dup+0x37>
		return r;
  8009d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009d5:	e9 70 01 00 00       	jmpq   800b4a <dup+0x1a7>
	close(newfdnum);
  8009da:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009dd:	89 c7                	mov    %eax,%edi
  8009df:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  8009e6:	00 00 00 
  8009e9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009ee:	48 98                	cltq   
  8009f0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8009fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a02:	48 89 c7             	mov    %rax,%rdi
  800a05:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  800a0c:	00 00 00 
  800a0f:	ff d0                	callq  *%rax
  800a11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a19:	48 89 c7             	mov    %rax,%rdi
  800a1c:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  800a23:	00 00 00 
  800a26:	ff d0                	callq  *%rax
  800a28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a30:	48 c1 e8 15          	shr    $0x15,%rax
  800a34:	48 89 c2             	mov    %rax,%rdx
  800a37:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a3e:	01 00 00 
  800a41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a45:	83 e0 01             	and    $0x1,%eax
  800a48:	48 85 c0             	test   %rax,%rax
  800a4b:	74 73                	je     800ac0 <dup+0x11d>
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a51:	48 c1 e8 0c          	shr    $0xc,%rax
  800a55:	48 89 c2             	mov    %rax,%rdx
  800a58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a5f:	01 00 00 
  800a62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a66:	83 e0 01             	and    $0x1,%eax
  800a69:	48 85 c0             	test   %rax,%rax
  800a6c:	74 52                	je     800ac0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a72:	48 c1 e8 0c          	shr    $0xc,%rax
  800a76:	48 89 c2             	mov    %rax,%rdx
  800a79:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a80:	01 00 00 
  800a83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a87:	25 07 0e 00 00       	and    $0xe07,%eax
  800a8c:	89 c1                	mov    %eax,%ecx
  800a8e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a96:	41 89 c8             	mov    %ecx,%r8d
  800a99:	48 89 d1             	mov    %rdx,%rcx
  800a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa1:	48 89 c6             	mov    %rax,%rsi
  800aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa9:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800ab0:	00 00 00 
  800ab3:	ff d0                	callq  *%rax
  800ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800abc:	79 02                	jns    800ac0 <dup+0x11d>
			goto err;
  800abe:	eb 57                	jmp    800b17 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ac4:	48 c1 e8 0c          	shr    $0xc,%rax
  800ac8:	48 89 c2             	mov    %rax,%rdx
  800acb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ad2:	01 00 00 
  800ad5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ad9:	25 07 0e 00 00       	and    $0xe07,%eax
  800ade:	89 c1                	mov    %eax,%ecx
  800ae0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ae8:	41 89 c8             	mov    %ecx,%r8d
  800aeb:	48 89 d1             	mov    %rdx,%rcx
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	48 89 c6             	mov    %rax,%rsi
  800af6:	bf 00 00 00 00       	mov    $0x0,%edi
  800afb:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800b02:	00 00 00 
  800b05:	ff d0                	callq  *%rax
  800b07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b0e:	79 02                	jns    800b12 <dup+0x16f>
		goto err;
  800b10:	eb 05                	jmp    800b17 <dup+0x174>

	return newfdnum;
  800b12:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b15:	eb 33                	jmp    800b4a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b1b:	48 89 c6             	mov    %rax,%rsi
  800b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b23:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800b2a:	00 00 00 
  800b2d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b33:	48 89 c6             	mov    %rax,%rsi
  800b36:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3b:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800b42:	00 00 00 
  800b45:	ff d0                	callq  *%rax
	return r;
  800b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b4a:	c9                   	leaveq 
  800b4b:	c3                   	retq   

0000000000800b4c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b4c:	55                   	push   %rbp
  800b4d:	48 89 e5             	mov    %rsp,%rbp
  800b50:	48 83 ec 40          	sub    $0x40,%rsp
  800b54:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b57:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b5b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b5f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b63:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b66:	48 89 d6             	mov    %rdx,%rsi
  800b69:	89 c7                	mov    %eax,%edi
  800b6b:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800b72:	00 00 00 
  800b75:	ff d0                	callq  *%rax
  800b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b7e:	78 24                	js     800ba4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b84:	8b 00                	mov    (%rax),%eax
  800b86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b8a:	48 89 d6             	mov    %rdx,%rsi
  800b8d:	89 c7                	mov    %eax,%edi
  800b8f:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800b96:	00 00 00 
  800b99:	ff d0                	callq  *%rax
  800b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ba2:	79 05                	jns    800ba9 <read+0x5d>
		return r;
  800ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ba7:	eb 76                	jmp    800c1f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bad:	8b 40 08             	mov    0x8(%rax),%eax
  800bb0:	83 e0 03             	and    $0x3,%eax
  800bb3:	83 f8 01             	cmp    $0x1,%eax
  800bb6:	75 3a                	jne    800bf2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bb8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800bbf:	00 00 00 
  800bc2:	48 8b 00             	mov    (%rax),%rax
  800bc5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800bcb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800bce:	89 c6                	mov    %eax,%esi
  800bd0:	48 bf df 3e 80 00 00 	movabs $0x803edf,%rdi
  800bd7:	00 00 00 
  800bda:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdf:	48 b9 f9 28 80 00 00 	movabs $0x8028f9,%rcx
  800be6:	00 00 00 
  800be9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800beb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bf0:	eb 2d                	jmp    800c1f <read+0xd3>
	}
	if (!dev->dev_read)
  800bf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf6:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bfa:	48 85 c0             	test   %rax,%rax
  800bfd:	75 07                	jne    800c06 <read+0xba>
		return -E_NOT_SUPP;
  800bff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c04:	eb 19                	jmp    800c1f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0a:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c0e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c12:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c16:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c1a:	48 89 cf             	mov    %rcx,%rdi
  800c1d:	ff d0                	callq  *%rax
}
  800c1f:	c9                   	leaveq 
  800c20:	c3                   	retq   

0000000000800c21 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c21:	55                   	push   %rbp
  800c22:	48 89 e5             	mov    %rsp,%rbp
  800c25:	48 83 ec 30          	sub    $0x30,%rsp
  800c29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c3b:	eb 49                	jmp    800c86 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c40:	48 98                	cltq   
  800c42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c46:	48 29 c2             	sub    %rax,%rdx
  800c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4c:	48 63 c8             	movslq %eax,%rcx
  800c4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c53:	48 01 c1             	add    %rax,%rcx
  800c56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c59:	48 89 ce             	mov    %rcx,%rsi
  800c5c:	89 c7                	mov    %eax,%edi
  800c5e:	48 b8 4c 0b 80 00 00 	movabs $0x800b4c,%rax
  800c65:	00 00 00 
  800c68:	ff d0                	callq  *%rax
  800c6a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c6d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c71:	79 05                	jns    800c78 <readn+0x57>
			return m;
  800c73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c76:	eb 1c                	jmp    800c94 <readn+0x73>
		if (m == 0)
  800c78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c7c:	75 02                	jne    800c80 <readn+0x5f>
			break;
  800c7e:	eb 11                	jmp    800c91 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c83:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c89:	48 98                	cltq   
  800c8b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c8f:	72 ac                	jb     800c3d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c94:	c9                   	leaveq 
  800c95:	c3                   	retq   

0000000000800c96 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c96:	55                   	push   %rbp
  800c97:	48 89 e5             	mov    %rsp,%rbp
  800c9a:	48 83 ec 40          	sub    $0x40,%rsp
  800c9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ca1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800ca5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ca9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cb0:	48 89 d6             	mov    %rdx,%rsi
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc8:	78 24                	js     800cee <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cce:	8b 00                	mov    (%rax),%eax
  800cd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cd4:	48 89 d6             	mov    %rdx,%rsi
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800ce0:	00 00 00 
  800ce3:	ff d0                	callq  *%rax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cec:	79 05                	jns    800cf3 <write+0x5d>
		return r;
  800cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf1:	eb 75                	jmp    800d68 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf7:	8b 40 08             	mov    0x8(%rax),%eax
  800cfa:	83 e0 03             	and    $0x3,%eax
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	75 3a                	jne    800d3b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d01:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d08:	00 00 00 
  800d0b:	48 8b 00             	mov    (%rax),%rax
  800d0e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d14:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d17:	89 c6                	mov    %eax,%esi
  800d19:	48 bf fb 3e 80 00 00 	movabs $0x803efb,%rdi
  800d20:	00 00 00 
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
  800d28:	48 b9 f9 28 80 00 00 	movabs $0x8028f9,%rcx
  800d2f:	00 00 00 
  800d32:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d39:	eb 2d                	jmp    800d68 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d43:	48 85 c0             	test   %rax,%rax
  800d46:	75 07                	jne    800d4f <write+0xb9>
		return -E_NOT_SUPP;
  800d48:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d4d:	eb 19                	jmp    800d68 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d53:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d57:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d63:	48 89 cf             	mov    %rcx,%rdi
  800d66:	ff d0                	callq  *%rax
}
  800d68:	c9                   	leaveq 
  800d69:	c3                   	retq   

0000000000800d6a <seek>:

int
seek(int fdnum, off_t offset)
{
  800d6a:	55                   	push   %rbp
  800d6b:	48 89 e5             	mov    %rsp,%rbp
  800d6e:	48 83 ec 18          	sub    $0x18,%rsp
  800d72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d75:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d78:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d7f:	48 89 d6             	mov    %rdx,%rsi
  800d82:	89 c7                	mov    %eax,%edi
  800d84:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
  800d90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d97:	79 05                	jns    800d9e <seek+0x34>
		return r;
  800d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d9c:	eb 0f                	jmp    800dad <seek+0x43>
	fd->fd_offset = offset;
  800d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800da5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dad:	c9                   	leaveq 
  800dae:	c3                   	retq   

0000000000800daf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
  800db3:	48 83 ec 30          	sub    $0x30,%rsp
  800db7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dba:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	89 c7                	mov    %eax,%edi
  800dc9:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800dd0:	00 00 00 
  800dd3:	ff d0                	callq  *%rax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ddc:	78 24                	js     800e02 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de2:	8b 00                	mov    (%rax),%eax
  800de4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de8:	48 89 d6             	mov    %rdx,%rsi
  800deb:	89 c7                	mov    %eax,%edi
  800ded:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800df4:	00 00 00 
  800df7:	ff d0                	callq  *%rax
  800df9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e00:	79 05                	jns    800e07 <ftruncate+0x58>
		return r;
  800e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e05:	eb 72                	jmp    800e79 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0b:	8b 40 08             	mov    0x8(%rax),%eax
  800e0e:	83 e0 03             	and    $0x3,%eax
  800e11:	85 c0                	test   %eax,%eax
  800e13:	75 3a                	jne    800e4f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e15:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800e1c:	00 00 00 
  800e1f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e22:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e28:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e2b:	89 c6                	mov    %eax,%esi
  800e2d:	48 bf 18 3f 80 00 00 	movabs $0x803f18,%rdi
  800e34:	00 00 00 
  800e37:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3c:	48 b9 f9 28 80 00 00 	movabs $0x8028f9,%rcx
  800e43:	00 00 00 
  800e46:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4d:	eb 2a                	jmp    800e79 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e53:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e57:	48 85 c0             	test   %rax,%rax
  800e5a:	75 07                	jne    800e63 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e5c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e61:	eb 16                	jmp    800e79 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e67:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e72:	89 ce                	mov    %ecx,%esi
  800e74:	48 89 d7             	mov    %rdx,%rdi
  800e77:	ff d0                	callq  *%rax
}
  800e79:	c9                   	leaveq 
  800e7a:	c3                   	retq   

0000000000800e7b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e7b:	55                   	push   %rbp
  800e7c:	48 89 e5             	mov    %rsp,%rbp
  800e7f:	48 83 ec 30          	sub    $0x30,%rsp
  800e83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e8a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e91:	48 89 d6             	mov    %rdx,%rsi
  800e94:	89 c7                	mov    %eax,%edi
  800e96:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
  800ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ea9:	78 24                	js     800ecf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	8b 00                	mov    (%rax),%eax
  800eb1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800eb5:	48 89 d6             	mov    %rdx,%rsi
  800eb8:	89 c7                	mov    %eax,%edi
  800eba:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ec9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ecd:	79 05                	jns    800ed4 <fstat+0x59>
		return r;
  800ecf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed2:	eb 5e                	jmp    800f32 <fstat+0xb7>
	if (!dev->dev_stat)
  800ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed8:	48 8b 40 28          	mov    0x28(%rax),%rax
  800edc:	48 85 c0             	test   %rax,%rax
  800edf:	75 07                	jne    800ee8 <fstat+0x6d>
		return -E_NOT_SUPP;
  800ee1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ee6:	eb 4a                	jmp    800f32 <fstat+0xb7>
	stat->st_name[0] = 0;
  800ee8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eec:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800eef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800efa:	00 00 00 
	stat->st_isdir = 0;
  800efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f01:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f08:	00 00 00 
	stat->st_dev = dev;
  800f0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f13:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1e:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f26:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f2a:	48 89 ce             	mov    %rcx,%rsi
  800f2d:	48 89 d7             	mov    %rdx,%rdi
  800f30:	ff d0                	callq  *%rax
}
  800f32:	c9                   	leaveq 
  800f33:	c3                   	retq   

0000000000800f34 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f34:	55                   	push   %rbp
  800f35:	48 89 e5             	mov    %rsp,%rbp
  800f38:	48 83 ec 20          	sub    $0x20,%rsp
  800f3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f48:	be 00 00 00 00       	mov    $0x0,%esi
  800f4d:	48 89 c7             	mov    %rax,%rdi
  800f50:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
  800f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f63:	79 05                	jns    800f6a <stat+0x36>
		return fd;
  800f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f68:	eb 2f                	jmp    800f99 <stat+0x65>
	r = fstat(fd, stat);
  800f6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f71:	48 89 d6             	mov    %rdx,%rsi
  800f74:	89 c7                	mov    %eax,%edi
  800f76:	48 b8 7b 0e 80 00 00 	movabs $0x800e7b,%rax
  800f7d:	00 00 00 
  800f80:	ff d0                	callq  *%rax
  800f82:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f88:	89 c7                	mov    %eax,%edi
  800f8a:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
	return r;
  800f96:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f99:	c9                   	leaveq 
  800f9a:	c3                   	retq   

0000000000800f9b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
  800f9f:	48 83 ec 10          	sub    $0x10,%rsp
  800fa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800faa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fb1:	00 00 00 
  800fb4:	8b 00                	mov    (%rax),%eax
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 1d                	jne    800fd7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fba:	bf 01 00 00 00       	mov    $0x1,%edi
  800fbf:	48 b8 6f 3d 80 00 00 	movabs $0x803d6f,%rax
  800fc6:	00 00 00 
  800fc9:	ff d0                	callq  *%rax
  800fcb:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fd2:	00 00 00 
  800fd5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fd7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fde:	00 00 00 
  800fe1:	8b 00                	mov    (%rax),%eax
  800fe3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fe6:	b9 07 00 00 00       	mov    $0x7,%ecx
  800feb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800ff2:	00 00 00 
  800ff5:	89 c7                	mov    %eax,%edi
  800ff7:	48 b8 0d 3d 80 00 00 	movabs $0x803d0d,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	ba 00 00 00 00       	mov    $0x0,%edx
  80100c:	48 89 c6             	mov    %rax,%rsi
  80100f:	bf 00 00 00 00       	mov    $0x0,%edi
  801014:	48 b8 07 3c 80 00 00 	movabs $0x803c07,%rax
  80101b:	00 00 00 
  80101e:	ff d0                	callq  *%rax
}
  801020:	c9                   	leaveq 
  801021:	c3                   	retq   

0000000000801022 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801022:	55                   	push   %rbp
  801023:	48 89 e5             	mov    %rsp,%rbp
  801026:	48 83 ec 30          	sub    $0x30,%rsp
  80102a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80102e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  801031:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  801038:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80103f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  801046:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80104b:	75 08                	jne    801055 <open+0x33>
	{
		return r;
  80104d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801050:	e9 f2 00 00 00       	jmpq   801147 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  801055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801059:	48 89 c7             	mov    %rax,%rdi
  80105c:	48 b8 42 34 80 00 00 	movabs $0x803442,%rax
  801063:	00 00 00 
  801066:	ff d0                	callq  *%rax
  801068:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80106b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801072:	7e 0a                	jle    80107e <open+0x5c>
	{
		return -E_BAD_PATH;
  801074:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801079:	e9 c9 00 00 00       	jmpq   801147 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80107e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801085:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801086:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80108a:	48 89 c7             	mov    %rax,%rdi
  80108d:	48 b8 82 06 80 00 00 	movabs $0x800682,%rax
  801094:	00 00 00 
  801097:	ff d0                	callq  *%rax
  801099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80109c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a0:	78 09                	js     8010ab <open+0x89>
  8010a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a6:	48 85 c0             	test   %rax,%rax
  8010a9:	75 08                	jne    8010b3 <open+0x91>
		{
			return r;
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	e9 94 00 00 00       	jmpq   801147 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8010b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010b7:	ba 00 04 00 00       	mov    $0x400,%edx
  8010bc:	48 89 c6             	mov    %rax,%rsi
  8010bf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010c6:	00 00 00 
  8010c9:	48 b8 40 35 80 00 00 	movabs $0x803540,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8010d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010dc:	00 00 00 
  8010df:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010e2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	48 89 c6             	mov    %rax,%rsi
  8010ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8010f4:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8010fb:	00 00 00 
  8010fe:	ff d0                	callq  *%rax
  801100:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801103:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801107:	79 2b                	jns    801134 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	be 00 00 00 00       	mov    $0x0,%esi
  801112:	48 89 c7             	mov    %rax,%rdi
  801115:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  80111c:	00 00 00 
  80111f:	ff d0                	callq  *%rax
  801121:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801124:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801128:	79 05                	jns    80112f <open+0x10d>
			{
				return d;
  80112a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80112d:	eb 18                	jmp    801147 <open+0x125>
			}
			return r;
  80112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801132:	eb 13                	jmp    801147 <open+0x125>
		}	
		return fd2num(fd_store);
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	48 89 c7             	mov    %rax,%rdi
  80113b:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  801142:	00 00 00 
  801145:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 10          	sub    $0x10,%rsp
  801151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801159:	8b 50 0c             	mov    0xc(%rax),%edx
  80115c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801163:	00 00 00 
  801166:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801168:	be 00 00 00 00       	mov    $0x0,%esi
  80116d:	bf 06 00 00 00       	mov    $0x6,%edi
  801172:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 30          	sub    $0x30,%rsp
  801188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801190:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80119b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a0:	74 07                	je     8011a9 <devfile_read+0x29>
  8011a2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011a7:	75 07                	jne    8011b0 <devfile_read+0x30>
		return -E_INVAL;
  8011a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ae:	eb 77                	jmp    801227 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8011b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011be:	00 00 00 
  8011c1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011c3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011ca:	00 00 00 
  8011cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011d1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8011d5:	be 00 00 00 00       	mov    $0x0,%esi
  8011da:	bf 03 00 00 00       	mov    $0x3,%edi
  8011df:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8011e6:	00 00 00 
  8011e9:	ff d0                	callq  *%rax
  8011eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011f2:	7f 05                	jg     8011f9 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8011f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f7:	eb 2e                	jmp    801227 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8011f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011fc:	48 63 d0             	movslq %eax,%rdx
  8011ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801203:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80120a:	00 00 00 
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801217:	00 00 00 
  80121a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80121c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801220:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801224:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 30          	sub    $0x30,%rsp
  801231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801239:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80123d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801244:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801249:	74 07                	je     801252 <devfile_write+0x29>
  80124b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801250:	75 08                	jne    80125a <devfile_write+0x31>
		return r;
  801252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801255:	e9 9a 00 00 00       	jmpq   8012f4 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80125a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125e:	8b 50 0c             	mov    0xc(%rax),%edx
  801261:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801268:	00 00 00 
  80126b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80126d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801274:	00 
  801275:	76 08                	jbe    80127f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801277:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80127e:	00 
	}
	fsipcbuf.write.req_n = n;
  80127f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801286:	00 00 00 
  801289:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80128d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801291:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801295:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801299:	48 89 c6             	mov    %rax,%rsi
  80129c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8012a3:	00 00 00 
  8012a6:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  8012ad:	00 00 00 
  8012b0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8012b2:	be 00 00 00 00       	mov    $0x0,%esi
  8012b7:	bf 04 00 00 00       	mov    $0x4,%edi
  8012bc:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8012c3:	00 00 00 
  8012c6:	ff d0                	callq  *%rax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012cf:	7f 20                	jg     8012f1 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8012d1:	48 bf 3e 3f 80 00 00 	movabs $0x803f3e,%rdi
  8012d8:	00 00 00 
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e0:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  8012e7:	00 00 00 
  8012ea:	ff d2                	callq  *%rdx
		return r;
  8012ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ef:	eb 03                	jmp    8012f4 <devfile_write+0xcb>
	}
	return r;
  8012f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8012f4:	c9                   	leaveq 
  8012f5:	c3                   	retq   

00000000008012f6 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012f6:	55                   	push   %rbp
  8012f7:	48 89 e5             	mov    %rsp,%rbp
  8012fa:	48 83 ec 20          	sub    $0x20,%rsp
  8012fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130a:	8b 50 0c             	mov    0xc(%rax),%edx
  80130d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801314:	00 00 00 
  801317:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801319:	be 00 00 00 00       	mov    $0x0,%esi
  80131e:	bf 05 00 00 00       	mov    $0x5,%edi
  801323:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  80132a:	00 00 00 
  80132d:	ff d0                	callq  *%rax
  80132f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801336:	79 05                	jns    80133d <devfile_stat+0x47>
		return r;
  801338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80133b:	eb 56                	jmp    801393 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80133d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801341:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801348:	00 00 00 
  80134b:	48 89 c7             	mov    %rax,%rdi
  80134e:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  801355:	00 00 00 
  801358:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80135a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801361:	00 00 00 
  801364:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80136a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801374:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80137b:	00 00 00 
  80137e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801388:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801393:	c9                   	leaveq 
  801394:	c3                   	retq   

0000000000801395 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	48 83 ec 10          	sub    $0x10,%rsp
  80139d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8013ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013b2:	00 00 00 
  8013b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8013b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013be:	00 00 00 
  8013c1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013c4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013c7:	be 00 00 00 00       	mov    $0x0,%esi
  8013cc:	bf 02 00 00 00       	mov    $0x2,%edi
  8013d1:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  8013d8:	00 00 00 
  8013db:	ff d0                	callq  *%rax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <remove>:

// Delete a file
int
remove(const char *path)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 10          	sub    $0x10,%rsp
  8013e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ef:	48 89 c7             	mov    %rax,%rdi
  8013f2:	48 b8 42 34 80 00 00 	movabs $0x803442,%rax
  8013f9:	00 00 00 
  8013fc:	ff d0                	callq  *%rax
  8013fe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801403:	7e 07                	jle    80140c <remove+0x2d>
		return -E_BAD_PATH;
  801405:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80140a:	eb 33                	jmp    80143f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801410:	48 89 c6             	mov    %rax,%rsi
  801413:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80141a:	00 00 00 
  80141d:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  801424:	00 00 00 
  801427:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801429:	be 00 00 00 00       	mov    $0x0,%esi
  80142e:	bf 07 00 00 00       	mov    $0x7,%edi
  801433:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  80143a:	00 00 00 
  80143d:	ff d0                	callq  *%rax
}
  80143f:	c9                   	leaveq 
  801440:	c3                   	retq   

0000000000801441 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801441:	55                   	push   %rbp
  801442:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801445:	be 00 00 00 00       	mov    $0x0,%esi
  80144a:	bf 08 00 00 00       	mov    $0x8,%edi
  80144f:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  801456:	00 00 00 
  801459:	ff d0                	callq  *%rax
}
  80145b:	5d                   	pop    %rbp
  80145c:	c3                   	retq   

000000000080145d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801468:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80146f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801476:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80147d:	be 00 00 00 00       	mov    $0x0,%esi
  801482:	48 89 c7             	mov    %rax,%rdi
  801485:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  80148c:	00 00 00 
  80148f:	ff d0                	callq  *%rax
  801491:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801498:	79 28                	jns    8014c2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80149a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80149d:	89 c6                	mov    %eax,%esi
  80149f:	48 bf 5a 3f 80 00 00 	movabs $0x803f5a,%rdi
  8014a6:	00 00 00 
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  8014b5:	00 00 00 
  8014b8:	ff d2                	callq  *%rdx
		return fd_src;
  8014ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014bd:	e9 74 01 00 00       	jmpq   801636 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8014c2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014c9:	be 01 01 00 00       	mov    $0x101,%esi
  8014ce:	48 89 c7             	mov    %rax,%rdi
  8014d1:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  8014d8:	00 00 00 
  8014db:	ff d0                	callq  *%rax
  8014dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014e4:	79 39                	jns    80151f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014e9:	89 c6                	mov    %eax,%esi
  8014eb:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  8014f2:	00 00 00 
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fa:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  801501:	00 00 00 
  801504:	ff d2                	callq  *%rdx
		close(fd_src);
  801506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801509:	89 c7                	mov    %eax,%edi
  80150b:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  801512:	00 00 00 
  801515:	ff d0                	callq  *%rax
		return fd_dest;
  801517:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80151a:	e9 17 01 00 00       	jmpq   801636 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80151f:	eb 74                	jmp    801595 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801521:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801524:	48 63 d0             	movslq %eax,%rdx
  801527:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80152e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801531:	48 89 ce             	mov    %rcx,%rsi
  801534:	89 c7                	mov    %eax,%edi
  801536:	48 b8 96 0c 80 00 00 	movabs $0x800c96,%rax
  80153d:	00 00 00 
  801540:	ff d0                	callq  *%rax
  801542:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801545:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801549:	79 4a                	jns    801595 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80154b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80154e:	89 c6                	mov    %eax,%esi
  801550:	48 bf 8a 3f 80 00 00 	movabs $0x803f8a,%rdi
  801557:	00 00 00 
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  801566:	00 00 00 
  801569:	ff d2                	callq  *%rdx
			close(fd_src);
  80156b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156e:	89 c7                	mov    %eax,%edi
  801570:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  801577:	00 00 00 
  80157a:	ff d0                	callq  *%rax
			close(fd_dest);
  80157c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80157f:	89 c7                	mov    %eax,%edi
  801581:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  801588:	00 00 00 
  80158b:	ff d0                	callq  *%rax
			return write_size;
  80158d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801590:	e9 a1 00 00 00       	jmpq   801636 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801595:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80159c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80159f:	ba 00 02 00 00       	mov    $0x200,%edx
  8015a4:	48 89 ce             	mov    %rcx,%rsi
  8015a7:	89 c7                	mov    %eax,%edi
  8015a9:	48 b8 4c 0b 80 00 00 	movabs $0x800b4c,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8015b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015bc:	0f 8f 5f ff ff ff    	jg     801521 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8015c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015c6:	79 47                	jns    80160f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	48 bf 9d 3f 80 00 00 	movabs $0x803f9d,%rdi
  8015d4:	00 00 00 
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  8015e3:	00 00 00 
  8015e6:	ff d2                	callq  *%rdx
		close(fd_src);
  8015e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015eb:	89 c7                	mov    %eax,%edi
  8015ed:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	callq  *%rax
		close(fd_dest);
  8015f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015fc:	89 c7                	mov    %eax,%edi
  8015fe:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  801605:	00 00 00 
  801608:	ff d0                	callq  *%rax
		return read_size;
  80160a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160d:	eb 27                	jmp    801636 <copy+0x1d9>
	}
	close(fd_src);
  80160f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801612:	89 c7                	mov    %eax,%edi
  801614:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  80161b:	00 00 00 
  80161e:	ff d0                	callq  *%rax
	close(fd_dest);
  801620:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801623:	89 c7                	mov    %eax,%edi
  801625:	48 b8 2a 09 80 00 00 	movabs $0x80092a,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	callq  *%rax
	return 0;
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801636:	c9                   	leaveq 
  801637:	c3                   	retq   

0000000000801638 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801638:	55                   	push   %rbp
  801639:	48 89 e5             	mov    %rsp,%rbp
  80163c:	48 83 ec 20          	sub    $0x20,%rsp
  801640:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801643:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801647:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80164a:	48 89 d6             	mov    %rdx,%rsi
  80164d:	89 c7                	mov    %eax,%edi
  80164f:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  801656:	00 00 00 
  801659:	ff d0                	callq  *%rax
  80165b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80165e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801662:	79 05                	jns    801669 <fd2sockid+0x31>
		return r;
  801664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801667:	eb 24                	jmp    80168d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166d:	8b 10                	mov    (%rax),%edx
  80166f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801676:	00 00 00 
  801679:	8b 00                	mov    (%rax),%eax
  80167b:	39 c2                	cmp    %eax,%edx
  80167d:	74 07                	je     801686 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80167f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801684:	eb 07                	jmp    80168d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80168d:	c9                   	leaveq 
  80168e:	c3                   	retq   

000000000080168f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80168f:	55                   	push   %rbp
  801690:	48 89 e5             	mov    %rsp,%rbp
  801693:	48 83 ec 20          	sub    $0x20,%rsp
  801697:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80169a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80169e:	48 89 c7             	mov    %rax,%rdi
  8016a1:	48 b8 82 06 80 00 00 	movabs $0x800682,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	callq  *%rax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b4:	78 26                	js     8016dc <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8016b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8016bf:	48 89 c6             	mov    %rax,%rsi
  8016c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c7:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  8016ce:	00 00 00 
  8016d1:	ff d0                	callq  *%rax
  8016d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016da:	79 16                	jns    8016f2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8016dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016df:	89 c7                	mov    %eax,%edi
  8016e1:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  8016e8:	00 00 00 
  8016eb:	ff d0                	callq  *%rax
		return r;
  8016ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016f0:	eb 3a                	jmp    80172c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8016f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8016fd:	00 00 00 
  801700:	8b 12                	mov    (%rdx),%edx
  801702:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801708:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80170f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801713:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801716:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 89 c7             	mov    %rax,%rdi
  801720:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  801727:	00 00 00 
  80172a:	ff d0                	callq  *%rax
}
  80172c:	c9                   	leaveq 
  80172d:	c3                   	retq   

000000000080172e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80172e:	55                   	push   %rbp
  80172f:	48 89 e5             	mov    %rsp,%rbp
  801732:	48 83 ec 30          	sub    $0x30,%rsp
  801736:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801739:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80173d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801741:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801744:	89 c7                	mov    %eax,%edi
  801746:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  80174d:	00 00 00 
  801750:	ff d0                	callq  *%rax
  801752:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801755:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801759:	79 05                	jns    801760 <accept+0x32>
		return r;
  80175b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175e:	eb 3b                	jmp    80179b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801760:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801764:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801768:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176b:	48 89 ce             	mov    %rcx,%rsi
  80176e:	89 c7                	mov    %eax,%edi
  801770:	48 b8 79 1a 80 00 00 	movabs $0x801a79,%rax
  801777:	00 00 00 
  80177a:	ff d0                	callq  *%rax
  80177c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80177f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801783:	79 05                	jns    80178a <accept+0x5c>
		return r;
  801785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801788:	eb 11                	jmp    80179b <accept+0x6d>
	return alloc_sockfd(r);
  80178a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80178d:	89 c7                	mov    %eax,%edi
  80178f:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801796:	00 00 00 
  801799:	ff d0                	callq  *%rax
}
  80179b:	c9                   	leaveq 
  80179c:	c3                   	retq   

000000000080179d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80179d:	55                   	push   %rbp
  80179e:	48 89 e5             	mov    %rsp,%rbp
  8017a1:	48 83 ec 20          	sub    $0x20,%rsp
  8017a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017ac:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b2:	89 c7                	mov    %eax,%edi
  8017b4:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
  8017c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017c7:	79 05                	jns    8017ce <bind+0x31>
		return r;
  8017c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cc:	eb 1b                	jmp    8017e9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8017ce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8017d1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d8:	48 89 ce             	mov    %rcx,%rsi
  8017db:	89 c7                	mov    %eax,%edi
  8017dd:	48 b8 f8 1a 80 00 00 	movabs $0x801af8,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
}
  8017e9:	c9                   	leaveq 
  8017ea:	c3                   	retq   

00000000008017eb <shutdown>:

int
shutdown(int s, int how)
{
  8017eb:	55                   	push   %rbp
  8017ec:	48 89 e5             	mov    %rsp,%rbp
  8017ef:	48 83 ec 20          	sub    $0x20,%rsp
  8017f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017f6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fc:	89 c7                	mov    %eax,%edi
  8017fe:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  801805:	00 00 00 
  801808:	ff d0                	callq  *%rax
  80180a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80180d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801811:	79 05                	jns    801818 <shutdown+0x2d>
		return r;
  801813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801816:	eb 16                	jmp    80182e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801818:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80181b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181e:	89 d6                	mov    %edx,%esi
  801820:	89 c7                	mov    %eax,%edi
  801822:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801829:	00 00 00 
  80182c:	ff d0                	callq  *%rax
}
  80182e:	c9                   	leaveq 
  80182f:	c3                   	retq   

0000000000801830 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 10          	sub    $0x10,%rsp
  801838:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80183c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801840:	48 89 c7             	mov    %rax,%rdi
  801843:	48 b8 f1 3d 80 00 00 	movabs $0x803df1,%rax
  80184a:	00 00 00 
  80184d:	ff d0                	callq  *%rax
  80184f:	83 f8 01             	cmp    $0x1,%eax
  801852:	75 17                	jne    80186b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801858:	8b 40 0c             	mov    0xc(%rax),%eax
  80185b:	89 c7                	mov    %eax,%edi
  80185d:	48 b8 9c 1b 80 00 00 	movabs $0x801b9c,%rax
  801864:	00 00 00 
  801867:	ff d0                	callq  *%rax
  801869:	eb 05                	jmp    801870 <devsock_close+0x40>
	else
		return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 20          	sub    $0x20,%rsp
  80187a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80187d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801881:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801884:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801887:	89 c7                	mov    %eax,%edi
  801889:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  801890:	00 00 00 
  801893:	ff d0                	callq  *%rax
  801895:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801898:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189c:	79 05                	jns    8018a3 <connect+0x31>
		return r;
  80189e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a1:	eb 1b                	jmp    8018be <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8018a3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018a6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8018aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ad:	48 89 ce             	mov    %rcx,%rsi
  8018b0:	89 c7                	mov    %eax,%edi
  8018b2:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  8018b9:	00 00 00 
  8018bc:	ff d0                	callq  *%rax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <listen>:

int
listen(int s, int backlog)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 20          	sub    $0x20,%rsp
  8018c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018d1:	89 c7                	mov    %eax,%edi
  8018d3:	48 b8 38 16 80 00 00 	movabs $0x801638,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	callq  *%rax
  8018df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018e6:	79 05                	jns    8018ed <listen+0x2d>
		return r;
  8018e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018eb:	eb 16                	jmp    801903 <listen+0x43>
	return nsipc_listen(r, backlog);
  8018ed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f3:	89 d6                	mov    %edx,%esi
  8018f5:	89 c7                	mov    %eax,%edi
  8018f7:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  8018fe:	00 00 00 
  801901:	ff d0                	callq  *%rax
}
  801903:	c9                   	leaveq 
  801904:	c3                   	retq   

0000000000801905 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801905:	55                   	push   %rbp
  801906:	48 89 e5             	mov    %rsp,%rbp
  801909:	48 83 ec 20          	sub    $0x20,%rsp
  80190d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801911:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801915:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191d:	89 c2                	mov    %eax,%edx
  80191f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801923:	8b 40 0c             	mov    0xc(%rax),%eax
  801926:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80192a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192f:	89 c7                	mov    %eax,%edi
  801931:	48 b8 6d 1c 80 00 00 	movabs $0x801c6d,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
}
  80193d:	c9                   	leaveq 
  80193e:	c3                   	retq   

000000000080193f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80193f:	55                   	push   %rbp
  801940:	48 89 e5             	mov    %rsp,%rbp
  801943:	48 83 ec 20          	sub    $0x20,%rsp
  801947:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80194b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80194f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801957:	89 c2                	mov    %eax,%edx
  801959:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195d:	8b 40 0c             	mov    0xc(%rax),%eax
  801960:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801964:	b9 00 00 00 00       	mov    $0x0,%ecx
  801969:	89 c7                	mov    %eax,%edi
  80196b:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  801972:	00 00 00 
  801975:	ff d0                	callq  *%rax
}
  801977:	c9                   	leaveq 
  801978:	c3                   	retq   

0000000000801979 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801979:	55                   	push   %rbp
  80197a:	48 89 e5             	mov    %rsp,%rbp
  80197d:	48 83 ec 10          	sub    $0x10,%rsp
  801981:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801985:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198d:	48 be b8 3f 80 00 00 	movabs $0x803fb8,%rsi
  801994:	00 00 00 
  801997:	48 89 c7             	mov    %rax,%rdi
  80199a:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
	return 0;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ab:	c9                   	leaveq 
  8019ac:	c3                   	retq   

00000000008019ad <socket>:

int
socket(int domain, int type, int protocol)
{
  8019ad:	55                   	push   %rbp
  8019ae:	48 89 e5             	mov    %rsp,%rbp
  8019b1:	48 83 ec 20          	sub    $0x20,%rsp
  8019b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8019bb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019be:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8019c1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8019c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019c7:	89 ce                	mov    %ecx,%esi
  8019c9:	89 c7                	mov    %eax,%edi
  8019cb:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	callq  *%rax
  8019d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019de:	79 05                	jns    8019e5 <socket+0x38>
		return r;
  8019e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e3:	eb 11                	jmp    8019f6 <socket+0x49>
	return alloc_sockfd(r);
  8019e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e8:	89 c7                	mov    %eax,%edi
  8019ea:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
}
  8019f6:	c9                   	leaveq 
  8019f7:	c3                   	retq   

00000000008019f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f8:	55                   	push   %rbp
  8019f9:	48 89 e5             	mov    %rsp,%rbp
  8019fc:	48 83 ec 10          	sub    $0x10,%rsp
  801a00:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a03:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a0a:	00 00 00 
  801a0d:	8b 00                	mov    (%rax),%eax
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	75 1d                	jne    801a30 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a13:	bf 02 00 00 00       	mov    $0x2,%edi
  801a18:	48 b8 6f 3d 80 00 00 	movabs $0x803d6f,%rax
  801a1f:	00 00 00 
  801a22:	ff d0                	callq  *%rax
  801a24:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801a2b:	00 00 00 
  801a2e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a30:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a37:	00 00 00 
  801a3a:	8b 00                	mov    (%rax),%eax
  801a3c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a3f:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a44:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801a4b:	00 00 00 
  801a4e:	89 c7                	mov    %eax,%edi
  801a50:	48 b8 0d 3d 80 00 00 	movabs $0x803d0d,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a61:	be 00 00 00 00       	mov    $0x0,%esi
  801a66:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6b:	48 b8 07 3c 80 00 00 	movabs $0x803c07,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	callq  *%rax
}
  801a77:	c9                   	leaveq 
  801a78:	c3                   	retq   

0000000000801a79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a79:	55                   	push   %rbp
  801a7a:	48 89 e5             	mov    %rsp,%rbp
  801a7d:	48 83 ec 30          	sub    $0x30,%rsp
  801a81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801a8c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a93:	00 00 00 
  801a96:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801a99:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a9b:	bf 01 00 00 00       	mov    $0x1,%edi
  801aa0:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801aa7:	00 00 00 
  801aaa:	ff d0                	callq  *%rax
  801aac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801aaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ab3:	78 3e                	js     801af3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801ab5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801abc:	00 00 00 
  801abf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac7:	8b 40 10             	mov    0x10(%rax),%eax
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ad0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad4:	48 89 ce             	mov    %rcx,%rsi
  801ad7:	48 89 c7             	mov    %rax,%rdi
  801ada:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aea:	8b 50 10             	mov    0x10(%rax),%edx
  801aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801af3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 10          	sub    $0x10,%rsp
  801b00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b07:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b0a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b11:	00 00 00 
  801b14:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b17:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b19:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b20:	48 89 c6             	mov    %rax,%rsi
  801b23:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801b2a:	00 00 00 
  801b2d:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801b34:	00 00 00 
  801b37:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801b39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b40:	00 00 00 
  801b43:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b46:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801b49:	bf 02 00 00 00       	mov    $0x2,%edi
  801b4e:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	callq  *%rax
}
  801b5a:	c9                   	leaveq 
  801b5b:	c3                   	retq   

0000000000801b5c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b5c:	55                   	push   %rbp
  801b5d:	48 89 e5             	mov    %rsp,%rbp
  801b60:	48 83 ec 10          	sub    $0x10,%rsp
  801b64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b67:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801b6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b71:	00 00 00 
  801b74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801b79:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b80:	00 00 00 
  801b83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b86:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801b89:	bf 03 00 00 00       	mov    $0x3,%edi
  801b8e:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
}
  801b9a:	c9                   	leaveq 
  801b9b:	c3                   	retq   

0000000000801b9c <nsipc_close>:

int
nsipc_close(int s)
{
  801b9c:	55                   	push   %rbp
  801b9d:	48 89 e5             	mov    %rsp,%rbp
  801ba0:	48 83 ec 10          	sub    $0x10,%rsp
  801ba4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801ba7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bae:	00 00 00 
  801bb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bb4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801bb6:	bf 04 00 00 00       	mov    $0x4,%edi
  801bbb:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	callq  *%rax
}
  801bc7:	c9                   	leaveq 
  801bc8:	c3                   	retq   

0000000000801bc9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
  801bcd:	48 83 ec 10          	sub    $0x10,%rsp
  801bd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801bdb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801be2:	00 00 00 
  801be5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801be8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf1:	48 89 c6             	mov    %rax,%rsi
  801bf4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801bfb:	00 00 00 
  801bfe:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c0a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c11:	00 00 00 
  801c14:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c17:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801c1a:	bf 05 00 00 00       	mov    $0x5,%edi
  801c1f:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
}
  801c2b:	c9                   	leaveq 
  801c2c:	c3                   	retq   

0000000000801c2d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c2d:	55                   	push   %rbp
  801c2e:	48 89 e5             	mov    %rsp,%rbp
  801c31:	48 83 ec 10          	sub    $0x10,%rsp
  801c35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c38:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801c3b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c42:	00 00 00 
  801c45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c48:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801c4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c51:	00 00 00 
  801c54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c57:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801c5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c5f:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801c66:	00 00 00 
  801c69:	ff d0                	callq  *%rax
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
  801c71:	48 83 ec 30          	sub    $0x30,%rsp
  801c75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c7c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801c7f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801c82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c89:	00 00 00 
  801c8c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c8f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801c91:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c98:	00 00 00 
  801c9b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c9e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801ca1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ca8:	00 00 00 
  801cab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cae:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cb1:	bf 07 00 00 00       	mov    $0x7,%edi
  801cb6:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
  801cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cc9:	78 69                	js     801d34 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801ccb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801cd2:	7f 08                	jg     801cdc <nsipc_recv+0x6f>
  801cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801cda:	7e 35                	jle    801d11 <nsipc_recv+0xa4>
  801cdc:	48 b9 bf 3f 80 00 00 	movabs $0x803fbf,%rcx
  801ce3:	00 00 00 
  801ce6:	48 ba d4 3f 80 00 00 	movabs $0x803fd4,%rdx
  801ced:	00 00 00 
  801cf0:	be 61 00 00 00       	mov    $0x61,%esi
  801cf5:	48 bf e9 3f 80 00 00 	movabs $0x803fe9,%rdi
  801cfc:	00 00 00 
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	49 b8 c0 26 80 00 00 	movabs $0x8026c0,%r8
  801d0b:	00 00 00 
  801d0e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d14:	48 63 d0             	movslq %eax,%rdx
  801d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d1b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801d22:	00 00 00 
  801d25:	48 89 c7             	mov    %rax,%rdi
  801d28:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801d2f:	00 00 00 
  801d32:	ff d0                	callq  *%rax
	}

	return r;
  801d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d37:	c9                   	leaveq 
  801d38:	c3                   	retq   

0000000000801d39 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d39:	55                   	push   %rbp
  801d3a:	48 89 e5             	mov    %rsp,%rbp
  801d3d:	48 83 ec 20          	sub    $0x20,%rsp
  801d41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d48:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d4b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801d4e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d55:	00 00 00 
  801d58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d5b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801d5d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801d64:	7e 35                	jle    801d9b <nsipc_send+0x62>
  801d66:	48 b9 f5 3f 80 00 00 	movabs $0x803ff5,%rcx
  801d6d:	00 00 00 
  801d70:	48 ba d4 3f 80 00 00 	movabs $0x803fd4,%rdx
  801d77:	00 00 00 
  801d7a:	be 6c 00 00 00       	mov    $0x6c,%esi
  801d7f:	48 bf e9 3f 80 00 00 	movabs $0x803fe9,%rdi
  801d86:	00 00 00 
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	49 b8 c0 26 80 00 00 	movabs $0x8026c0,%r8
  801d95:	00 00 00 
  801d98:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9e:	48 63 d0             	movslq %eax,%rdx
  801da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da5:	48 89 c6             	mov    %rax,%rsi
  801da8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801daf:	00 00 00 
  801db2:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801dbe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dc5:	00 00 00 
  801dc8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801dcb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801dce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dd5:	00 00 00 
  801dd8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ddb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801dde:	bf 08 00 00 00       	mov    $0x8,%edi
  801de3:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801dea:	00 00 00 
  801ded:	ff d0                	callq  *%rax
}
  801def:	c9                   	leaveq 
  801df0:	c3                   	retq   

0000000000801df1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801df1:	55                   	push   %rbp
  801df2:	48 89 e5             	mov    %rsp,%rbp
  801df5:	48 83 ec 10          	sub    $0x10,%rsp
  801df9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801dff:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e02:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e09:	00 00 00 
  801e0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e0f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e18:	00 00 00 
  801e1b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e1e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801e21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e28:	00 00 00 
  801e2b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e2e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801e31:	bf 09 00 00 00       	mov    $0x9,%edi
  801e36:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax
}
  801e42:	c9                   	leaveq 
  801e43:	c3                   	retq   

0000000000801e44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e44:	55                   	push   %rbp
  801e45:	48 89 e5             	mov    %rsp,%rbp
  801e48:	53                   	push   %rbx
  801e49:	48 83 ec 38          	sub    $0x38,%rsp
  801e4d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e51:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801e55:	48 89 c7             	mov    %rax,%rdi
  801e58:	48 b8 82 06 80 00 00 	movabs $0x800682,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
  801e64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e67:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e6b:	0f 88 bf 01 00 00    	js     802030 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e75:	ba 07 04 00 00       	mov    $0x407,%edx
  801e7a:	48 89 c6             	mov    %rax,%rsi
  801e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e82:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
  801e8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e95:	0f 88 95 01 00 00    	js     802030 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e9b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e9f:	48 89 c7             	mov    %rax,%rdi
  801ea2:	48 b8 82 06 80 00 00 	movabs $0x800682,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	callq  *%rax
  801eae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eb5:	0f 88 5d 01 00 00    	js     802018 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebf:	ba 07 04 00 00       	mov    $0x407,%edx
  801ec4:	48 89 c6             	mov    %rax,%rsi
  801ec7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecc:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
  801ed8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801edf:	0f 88 33 01 00 00    	js     802018 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ee5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee9:	48 89 c7             	mov    %rax,%rdi
  801eec:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	callq  *%rax
  801ef8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f00:	ba 07 04 00 00       	mov    $0x407,%edx
  801f05:	48 89 c6             	mov    %rax,%rsi
  801f08:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0d:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
  801f19:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f20:	79 05                	jns    801f27 <pipe+0xe3>
		goto err2;
  801f22:	e9 d9 00 00 00       	jmpq   802000 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f2b:	48 89 c7             	mov    %rax,%rdi
  801f2e:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  801f35:	00 00 00 
  801f38:	ff d0                	callq  *%rax
  801f3a:	48 89 c2             	mov    %rax,%rdx
  801f3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f41:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f47:	48 89 d1             	mov    %rdx,%rcx
  801f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4f:	48 89 c6             	mov    %rax,%rsi
  801f52:	bf 00 00 00 00       	mov    $0x0,%edi
  801f57:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
  801f63:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f66:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f6a:	79 1b                	jns    801f87 <pipe+0x143>
		goto err3;
  801f6c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801f6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f71:	48 89 c6             	mov    %rax,%rsi
  801f74:	bf 00 00 00 00       	mov    $0x0,%edi
  801f79:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  801f80:	00 00 00 
  801f83:	ff d0                	callq  *%rax
  801f85:	eb 79                	jmp    802000 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801f92:	00 00 00 
  801f95:	8b 12                	mov    (%rdx),%edx
  801f97:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801f99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fa4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801faf:	00 00 00 
  801fb2:	8b 12                	mov    (%rdx),%edx
  801fb4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc5:	48 89 c7             	mov    %rax,%rdi
  801fc8:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fda:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801fdc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fe0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801fe4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fe8:	48 89 c7             	mov    %rax,%rdi
  801feb:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  801ff2:	00 00 00 
  801ff5:	ff d0                	callq  *%rax
  801ff7:	89 03                	mov    %eax,(%rbx)
	return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	eb 33                	jmp    802033 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802000:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802004:	48 89 c6             	mov    %rax,%rsi
  802007:	bf 00 00 00 00       	mov    $0x0,%edi
  80200c:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  802013:	00 00 00 
  802016:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802018:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201c:	48 89 c6             	mov    %rax,%rsi
  80201f:	bf 00 00 00 00       	mov    $0x0,%edi
  802024:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
err:
	return r;
  802030:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802033:	48 83 c4 38          	add    $0x38,%rsp
  802037:	5b                   	pop    %rbx
  802038:	5d                   	pop    %rbp
  802039:	c3                   	retq   

000000000080203a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	53                   	push   %rbx
  80203f:	48 83 ec 28          	sub    $0x28,%rsp
  802043:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802047:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80204b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802052:	00 00 00 
  802055:	48 8b 00             	mov    (%rax),%rax
  802058:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80205e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802061:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802065:	48 89 c7             	mov    %rax,%rdi
  802068:	48 b8 f1 3d 80 00 00 	movabs $0x803df1,%rax
  80206f:	00 00 00 
  802072:	ff d0                	callq  *%rax
  802074:	89 c3                	mov    %eax,%ebx
  802076:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80207a:	48 89 c7             	mov    %rax,%rdi
  80207d:	48 b8 f1 3d 80 00 00 	movabs $0x803df1,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
  802089:	39 c3                	cmp    %eax,%ebx
  80208b:	0f 94 c0             	sete   %al
  80208e:	0f b6 c0             	movzbl %al,%eax
  802091:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802094:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80209b:	00 00 00 
  80209e:	48 8b 00             	mov    (%rax),%rax
  8020a1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020a7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ad:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020b0:	75 05                	jne    8020b7 <_pipeisclosed+0x7d>
			return ret;
  8020b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020b5:	eb 4f                	jmp    802106 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8020b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020bd:	74 42                	je     802101 <_pipeisclosed+0xc7>
  8020bf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8020c3:	75 3c                	jne    802101 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020c5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020cc:	00 00 00 
  8020cf:	48 8b 00             	mov    (%rax),%rax
  8020d2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8020d8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8020db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020de:	89 c6                	mov    %eax,%esi
  8020e0:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  8020e7:	00 00 00 
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ef:	49 b8 f9 28 80 00 00 	movabs $0x8028f9,%r8
  8020f6:	00 00 00 
  8020f9:	41 ff d0             	callq  *%r8
	}
  8020fc:	e9 4a ff ff ff       	jmpq   80204b <_pipeisclosed+0x11>
  802101:	e9 45 ff ff ff       	jmpq   80204b <_pipeisclosed+0x11>
}
  802106:	48 83 c4 28          	add    $0x28,%rsp
  80210a:	5b                   	pop    %rbx
  80210b:	5d                   	pop    %rbp
  80210c:	c3                   	retq   

000000000080210d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80210d:	55                   	push   %rbp
  80210e:	48 89 e5             	mov    %rsp,%rbp
  802111:	48 83 ec 30          	sub    $0x30,%rsp
  802115:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802118:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80211c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80211f:	48 89 d6             	mov    %rdx,%rsi
  802122:	89 c7                	mov    %eax,%edi
  802124:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802137:	79 05                	jns    80213e <pipeisclosed+0x31>
		return r;
  802139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213c:	eb 31                	jmp    80216f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80213e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802142:	48 89 c7             	mov    %rax,%rdi
  802145:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax
  802151:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802159:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80215d:	48 89 d6             	mov    %rdx,%rsi
  802160:	48 89 c7             	mov    %rax,%rdi
  802163:	48 b8 3a 20 80 00 00 	movabs $0x80203a,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 40          	sub    $0x40,%rsp
  802179:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80217d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802181:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802189:	48 89 c7             	mov    %rax,%rdi
  80218c:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  802193:	00 00 00 
  802196:	ff d0                	callq  *%rax
  802198:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80219c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021ab:	00 
  8021ac:	e9 92 00 00 00       	jmpq   802243 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021b1:	eb 41                	jmp    8021f4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021b3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8021b8:	74 09                	je     8021c3 <devpipe_read+0x52>
				return i;
  8021ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021be:	e9 92 00 00 00       	jmpq   802255 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cb:	48 89 d6             	mov    %rdx,%rsi
  8021ce:	48 89 c7             	mov    %rax,%rdi
  8021d1:	48 b8 3a 20 80 00 00 	movabs $0x80203a,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	74 07                	je     8021e8 <devpipe_read+0x77>
				return 0;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e6:	eb 6d                	jmp    802255 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021e8:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f8:	8b 10                	mov    (%rax),%edx
  8021fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fe:	8b 40 04             	mov    0x4(%rax),%eax
  802201:	39 c2                	cmp    %eax,%edx
  802203:	74 ae                	je     8021b3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802209:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802215:	8b 00                	mov    (%rax),%eax
  802217:	99                   	cltd   
  802218:	c1 ea 1b             	shr    $0x1b,%edx
  80221b:	01 d0                	add    %edx,%eax
  80221d:	83 e0 1f             	and    $0x1f,%eax
  802220:	29 d0                	sub    %edx,%eax
  802222:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802226:	48 98                	cltq   
  802228:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80222d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	8b 00                	mov    (%rax),%eax
  802235:	8d 50 01             	lea    0x1(%rax),%edx
  802238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80223e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802247:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80224b:	0f 82 60 ff ff ff    	jb     8021b1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802255:	c9                   	leaveq 
  802256:	c3                   	retq   

0000000000802257 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802257:	55                   	push   %rbp
  802258:	48 89 e5             	mov    %rsp,%rbp
  80225b:	48 83 ec 40          	sub    $0x40,%rsp
  80225f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802263:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802267:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80226b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226f:	48 89 c7             	mov    %rax,%rdi
  802272:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802282:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802286:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80228a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802291:	00 
  802292:	e9 8e 00 00 00       	jmpq   802325 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802297:	eb 31                	jmp    8022ca <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802299:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a1:	48 89 d6             	mov    %rdx,%rsi
  8022a4:	48 89 c7             	mov    %rax,%rdi
  8022a7:	48 b8 3a 20 80 00 00 	movabs $0x80203a,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 07                	je     8022be <devpipe_write+0x67>
				return 0;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	eb 79                	jmp    802337 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022be:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	8b 40 04             	mov    0x4(%rax),%eax
  8022d1:	48 63 d0             	movslq %eax,%rdx
  8022d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d8:	8b 00                	mov    (%rax),%eax
  8022da:	48 98                	cltq   
  8022dc:	48 83 c0 20          	add    $0x20,%rax
  8022e0:	48 39 c2             	cmp    %rax,%rdx
  8022e3:	73 b4                	jae    802299 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e9:	8b 40 04             	mov    0x4(%rax),%eax
  8022ec:	99                   	cltd   
  8022ed:	c1 ea 1b             	shr    $0x1b,%edx
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	83 e0 1f             	and    $0x1f,%eax
  8022f5:	29 d0                	sub    %edx,%eax
  8022f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022fb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022ff:	48 01 ca             	add    %rcx,%rdx
  802302:	0f b6 0a             	movzbl (%rdx),%ecx
  802305:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802309:	48 98                	cltq   
  80230b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80230f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802313:	8b 40 04             	mov    0x4(%rax),%eax
  802316:	8d 50 01             	lea    0x1(%rax),%edx
  802319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802320:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802329:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80232d:	0f 82 64 ff ff ff    	jb     802297 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 20          	sub    $0x20,%rsp
  802341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234d:	48 89 c7             	mov    %rax,%rdi
  802350:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
  80235c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802360:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802364:	48 be 19 40 80 00 00 	movabs $0x804019,%rsi
  80236b:	00 00 00 
  80236e:	48 89 c7             	mov    %rax,%rdi
  802371:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80237d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802381:	8b 50 04             	mov    0x4(%rax),%edx
  802384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802388:	8b 00                	mov    (%rax),%eax
  80238a:	29 c2                	sub    %eax,%edx
  80238c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802390:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80239a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023a1:	00 00 00 
	stat->st_dev = &devpipe;
  8023a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a8:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8023af:	00 00 00 
  8023b2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023be:	c9                   	leaveq 
  8023bf:	c3                   	retq   

00000000008023c0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023c0:	55                   	push   %rbp
  8023c1:	48 89 e5             	mov    %rsp,%rbp
  8023c4:	48 83 ec 10          	sub    $0x10,%rsp
  8023c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8023cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d0:	48 89 c6             	mov    %rax,%rsi
  8023d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d8:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8023e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e8:	48 89 c7             	mov    %rax,%rdi
  8023eb:	48 b8 57 06 80 00 00 	movabs $0x800657,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
  8023f7:	48 89 c6             	mov    %rax,%rsi
  8023fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ff:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
}
  80240b:	c9                   	leaveq 
  80240c:	c3                   	retq   

000000000080240d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80240d:	55                   	push   %rbp
  80240e:	48 89 e5             	mov    %rsp,%rbp
  802411:	48 83 ec 20          	sub    $0x20,%rsp
  802415:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802418:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80241b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80241e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802422:	be 01 00 00 00       	mov    $0x1,%esi
  802427:	48 89 c7             	mov    %rax,%rdi
  80242a:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  802431:	00 00 00 
  802434:	ff d0                	callq  *%rax
}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <getchar>:

int
getchar(void)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
  80243c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802440:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802444:	ba 01 00 00 00       	mov    $0x1,%edx
  802449:	48 89 c6             	mov    %rax,%rsi
  80244c:	bf 00 00 00 00       	mov    $0x0,%edi
  802451:	48 b8 4c 0b 80 00 00 	movabs $0x800b4c,%rax
  802458:	00 00 00 
  80245b:	ff d0                	callq  *%rax
  80245d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802460:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802464:	79 05                	jns    80246b <getchar+0x33>
		return r;
  802466:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802469:	eb 14                	jmp    80247f <getchar+0x47>
	if (r < 1)
  80246b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246f:	7f 07                	jg     802478 <getchar+0x40>
		return -E_EOF;
  802471:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802476:	eb 07                	jmp    80247f <getchar+0x47>
	return c;
  802478:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80247c:	0f b6 c0             	movzbl %al,%eax
}
  80247f:	c9                   	leaveq 
  802480:	c3                   	retq   

0000000000802481 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802481:	55                   	push   %rbp
  802482:	48 89 e5             	mov    %rsp,%rbp
  802485:	48 83 ec 20          	sub    $0x20,%rsp
  802489:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802490:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802493:	48 89 d6             	mov    %rdx,%rsi
  802496:	89 c7                	mov    %eax,%edi
  802498:	48 b8 1a 07 80 00 00 	movabs $0x80071a,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
  8024a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ab:	79 05                	jns    8024b2 <iscons+0x31>
		return r;
  8024ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b0:	eb 1a                	jmp    8024cc <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8024b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b6:	8b 10                	mov    (%rax),%edx
  8024b8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8024bf:	00 00 00 
  8024c2:	8b 00                	mov    (%rax),%eax
  8024c4:	39 c2                	cmp    %eax,%edx
  8024c6:	0f 94 c0             	sete   %al
  8024c9:	0f b6 c0             	movzbl %al,%eax
}
  8024cc:	c9                   	leaveq 
  8024cd:	c3                   	retq   

00000000008024ce <opencons>:

int
opencons(void)
{
  8024ce:	55                   	push   %rbp
  8024cf:	48 89 e5             	mov    %rsp,%rbp
  8024d2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024d6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024da:	48 89 c7             	mov    %rax,%rdi
  8024dd:	48 b8 82 06 80 00 00 	movabs $0x800682,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
  8024e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f0:	79 05                	jns    8024f7 <opencons+0x29>
		return r;
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	eb 5b                	jmp    802552 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	ba 07 04 00 00       	mov    $0x407,%edx
  802500:	48 89 c6             	mov    %rax,%rsi
  802503:	bf 00 00 00 00       	mov    $0x0,%edi
  802508:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax
  802514:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802517:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251b:	79 05                	jns    802522 <opencons+0x54>
		return r;
  80251d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802520:	eb 30                	jmp    802552 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802526:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80252d:	00 00 00 
  802530:	8b 12                	mov    (%rdx),%edx
  802532:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802538:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	48 89 c7             	mov    %rax,%rdi
  802546:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax
}
  802552:	c9                   	leaveq 
  802553:	c3                   	retq   

0000000000802554 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	48 83 ec 30          	sub    $0x30,%rsp
  80255c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802564:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802568:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80256d:	75 07                	jne    802576 <devcons_read+0x22>
		return 0;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	eb 4b                	jmp    8025c1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802576:	eb 0c                	jmp    802584 <devcons_read+0x30>
		sys_yield();
  802578:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802584:	48 b8 fd 01 80 00 00 	movabs $0x8001fd,%rax
  80258b:	00 00 00 
  80258e:	ff d0                	callq  *%rax
  802590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802597:	74 df                	je     802578 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802599:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259d:	79 05                	jns    8025a4 <devcons_read+0x50>
		return c;
  80259f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a2:	eb 1d                	jmp    8025c1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025a4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025a8:	75 07                	jne    8025b1 <devcons_read+0x5d>
		return 0;
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025af:	eb 10                	jmp    8025c1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b4:	89 c2                	mov    %eax,%edx
  8025b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ba:	88 10                	mov    %dl,(%rax)
	return 1;
  8025bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   

00000000008025c3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
  8025c7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8025ce:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8025d5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8025dc:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025ea:	eb 76                	jmp    802662 <devcons_write+0x9f>
		m = n - tot;
  8025ec:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8025f3:	89 c2                	mov    %eax,%edx
  8025f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f8:	29 c2                	sub    %eax,%edx
  8025fa:	89 d0                	mov    %edx,%eax
  8025fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8025ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802602:	83 f8 7f             	cmp    $0x7f,%eax
  802605:	76 07                	jbe    80260e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802607:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80260e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802611:	48 63 d0             	movslq %eax,%rdx
  802614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802617:	48 63 c8             	movslq %eax,%rcx
  80261a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802621:	48 01 c1             	add    %rax,%rcx
  802624:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80262b:	48 89 ce             	mov    %rcx,%rsi
  80262e:	48 89 c7             	mov    %rax,%rdi
  802631:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  802638:	00 00 00 
  80263b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80263d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802640:	48 63 d0             	movslq %eax,%rdx
  802643:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80264a:	48 89 d6             	mov    %rdx,%rsi
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80265c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802665:	48 98                	cltq   
  802667:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80266e:	0f 82 78 ff ff ff    	jb     8025ec <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802674:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802677:	c9                   	leaveq 
  802678:	c3                   	retq   

0000000000802679 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802679:	55                   	push   %rbp
  80267a:	48 89 e5             	mov    %rsp,%rbp
  80267d:	48 83 ec 08          	sub    $0x8,%rsp
  802681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802685:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 10          	sub    $0x10,%rsp
  802694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802698:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80269c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a0:	48 be 25 40 80 00 00 	movabs $0x804025,%rsi
  8026a7:	00 00 00 
  8026aa:	48 89 c7             	mov    %rax,%rdi
  8026ad:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
	return 0;
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	53                   	push   %rbx
  8026c5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8026cc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8026d3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8026d9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8026e0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8026e7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8026ee:	84 c0                	test   %al,%al
  8026f0:	74 23                	je     802715 <_panic+0x55>
  8026f2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8026f9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8026fd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802701:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802705:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802709:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80270d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802711:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802715:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80271c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802723:	00 00 00 
  802726:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80272d:	00 00 00 
  802730:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802734:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80273b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802742:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802749:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802750:	00 00 00 
  802753:	48 8b 18             	mov    (%rax),%rbx
  802756:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802768:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80276f:	41 89 c8             	mov    %ecx,%r8d
  802772:	48 89 d1             	mov    %rdx,%rcx
  802775:	48 89 da             	mov    %rbx,%rdx
  802778:	89 c6                	mov    %eax,%esi
  80277a:	48 bf 30 40 80 00 00 	movabs $0x804030,%rdi
  802781:	00 00 00 
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
  802789:	49 b9 f9 28 80 00 00 	movabs $0x8028f9,%r9
  802790:	00 00 00 
  802793:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802796:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80279d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027a4:	48 89 d6             	mov    %rdx,%rsi
  8027a7:	48 89 c7             	mov    %rax,%rdi
  8027aa:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	callq  *%rax
	cprintf("\n");
  8027b6:	48 bf 53 40 80 00 00 	movabs $0x804053,%rdi
  8027bd:	00 00 00 
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	48 ba f9 28 80 00 00 	movabs $0x8028f9,%rdx
  8027cc:	00 00 00 
  8027cf:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027d1:	cc                   	int3   
  8027d2:	eb fd                	jmp    8027d1 <_panic+0x111>

00000000008027d4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8027d4:	55                   	push   %rbp
  8027d5:	48 89 e5             	mov    %rsp,%rbp
  8027d8:	48 83 ec 10          	sub    $0x10,%rsp
  8027dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8027e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e7:	8b 00                	mov    (%rax),%eax
  8027e9:	8d 48 01             	lea    0x1(%rax),%ecx
  8027ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027f0:	89 0a                	mov    %ecx,(%rdx)
  8027f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027f5:	89 d1                	mov    %edx,%ecx
  8027f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027fb:	48 98                	cltq   
  8027fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802801:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802805:	8b 00                	mov    (%rax),%eax
  802807:	3d ff 00 00 00       	cmp    $0xff,%eax
  80280c:	75 2c                	jne    80283a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80280e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802812:	8b 00                	mov    (%rax),%eax
  802814:	48 98                	cltq   
  802816:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80281a:	48 83 c2 08          	add    $0x8,%rdx
  80281e:	48 89 c6             	mov    %rax,%rsi
  802821:	48 89 d7             	mov    %rdx,%rdi
  802824:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
        b->idx = 0;
  802830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802834:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80283a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283e:	8b 40 04             	mov    0x4(%rax),%eax
  802841:	8d 50 01             	lea    0x1(%rax),%edx
  802844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802848:	89 50 04             	mov    %edx,0x4(%rax)
}
  80284b:	c9                   	leaveq 
  80284c:	c3                   	retq   

000000000080284d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80284d:	55                   	push   %rbp
  80284e:	48 89 e5             	mov    %rsp,%rbp
  802851:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802858:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80285f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802866:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80286d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802874:	48 8b 0a             	mov    (%rdx),%rcx
  802877:	48 89 08             	mov    %rcx,(%rax)
  80287a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80287e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802882:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802886:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80288a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802891:	00 00 00 
    b.cnt = 0;
  802894:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80289b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80289e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028a5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028ac:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8028b3:	48 89 c6             	mov    %rax,%rsi
  8028b6:	48 bf d4 27 80 00 00 	movabs $0x8027d4,%rdi
  8028bd:	00 00 00 
  8028c0:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  8028c7:	00 00 00 
  8028ca:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8028cc:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8028d2:	48 98                	cltq   
  8028d4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8028db:	48 83 c2 08          	add    $0x8,%rdx
  8028df:	48 89 c6             	mov    %rax,%rsi
  8028e2:	48 89 d7             	mov    %rdx,%rdi
  8028e5:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8028f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8028f7:	c9                   	leaveq 
  8028f8:	c3                   	retq   

00000000008028f9 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8028f9:	55                   	push   %rbp
  8028fa:	48 89 e5             	mov    %rsp,%rbp
  8028fd:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802904:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80290b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802912:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802919:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802920:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802927:	84 c0                	test   %al,%al
  802929:	74 20                	je     80294b <cprintf+0x52>
  80292b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80292f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802933:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802937:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80293b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80293f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802943:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802947:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80294b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802952:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802959:	00 00 00 
  80295c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802963:	00 00 00 
  802966:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80296a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802971:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802978:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80297f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802986:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80298d:	48 8b 0a             	mov    (%rdx),%rcx
  802990:	48 89 08             	mov    %rcx,(%rax)
  802993:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802997:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80299b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80299f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029a3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029aa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029b1:	48 89 d6             	mov    %rdx,%rsi
  8029b4:	48 89 c7             	mov    %rax,%rdi
  8029b7:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	callq  *%rax
  8029c3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8029c9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	53                   	push   %rbx
  8029d6:	48 83 ec 38          	sub    $0x38,%rsp
  8029da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8029e6:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8029e9:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8029ed:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8029f1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8029f4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029f8:	77 3b                	ja     802a35 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8029fa:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8029fd:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a01:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a08:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0d:	48 f7 f3             	div    %rbx
  802a10:	48 89 c2             	mov    %rax,%rdx
  802a13:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a16:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a19:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a21:	41 89 f9             	mov    %edi,%r9d
  802a24:	48 89 c7             	mov    %rax,%rdi
  802a27:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
  802a33:	eb 1e                	jmp    802a53 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a35:	eb 12                	jmp    802a49 <printnum+0x78>
			putch(padc, putdat);
  802a37:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a3b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a42:	48 89 ce             	mov    %rcx,%rsi
  802a45:	89 d7                	mov    %edx,%edi
  802a47:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a49:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a4d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a51:	7f e4                	jg     802a37 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802a53:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5f:	48 f7 f1             	div    %rcx
  802a62:	48 89 d0             	mov    %rdx,%rax
  802a65:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  802a6c:	00 00 00 
  802a6f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802a73:	0f be d0             	movsbl %al,%edx
  802a76:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7e:	48 89 ce             	mov    %rcx,%rsi
  802a81:	89 d7                	mov    %edx,%edi
  802a83:	ff d0                	callq  *%rax
}
  802a85:	48 83 c4 38          	add    $0x38,%rsp
  802a89:	5b                   	pop    %rbx
  802a8a:	5d                   	pop    %rbp
  802a8b:	c3                   	retq   

0000000000802a8c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802a8c:	55                   	push   %rbp
  802a8d:	48 89 e5             	mov    %rsp,%rbp
  802a90:	48 83 ec 1c          	sub    $0x1c,%rsp
  802a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a98:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802a9b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802a9f:	7e 52                	jle    802af3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	8b 00                	mov    (%rax),%eax
  802aa7:	83 f8 30             	cmp    $0x30,%eax
  802aaa:	73 24                	jae    802ad0 <getuint+0x44>
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab8:	8b 00                	mov    (%rax),%eax
  802aba:	89 c0                	mov    %eax,%eax
  802abc:	48 01 d0             	add    %rdx,%rax
  802abf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac3:	8b 12                	mov    (%rdx),%edx
  802ac5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ac8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802acc:	89 0a                	mov    %ecx,(%rdx)
  802ace:	eb 17                	jmp    802ae7 <getuint+0x5b>
  802ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ad8:	48 89 d0             	mov    %rdx,%rax
  802adb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802adf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802ae7:	48 8b 00             	mov    (%rax),%rax
  802aea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802aee:	e9 a3 00 00 00       	jmpq   802b96 <getuint+0x10a>
	else if (lflag)
  802af3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802af7:	74 4f                	je     802b48 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afd:	8b 00                	mov    (%rax),%eax
  802aff:	83 f8 30             	cmp    $0x30,%eax
  802b02:	73 24                	jae    802b28 <getuint+0x9c>
  802b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b08:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b10:	8b 00                	mov    (%rax),%eax
  802b12:	89 c0                	mov    %eax,%eax
  802b14:	48 01 d0             	add    %rdx,%rax
  802b17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b1b:	8b 12                	mov    (%rdx),%edx
  802b1d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b24:	89 0a                	mov    %ecx,(%rdx)
  802b26:	eb 17                	jmp    802b3f <getuint+0xb3>
  802b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b30:	48 89 d0             	mov    %rdx,%rax
  802b33:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b3f:	48 8b 00             	mov    (%rax),%rax
  802b42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b46:	eb 4e                	jmp    802b96 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4c:	8b 00                	mov    (%rax),%eax
  802b4e:	83 f8 30             	cmp    $0x30,%eax
  802b51:	73 24                	jae    802b77 <getuint+0xeb>
  802b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b57:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5f:	8b 00                	mov    (%rax),%eax
  802b61:	89 c0                	mov    %eax,%eax
  802b63:	48 01 d0             	add    %rdx,%rax
  802b66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b6a:	8b 12                	mov    (%rdx),%edx
  802b6c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b73:	89 0a                	mov    %ecx,(%rdx)
  802b75:	eb 17                	jmp    802b8e <getuint+0x102>
  802b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b7f:	48 89 d0             	mov    %rdx,%rax
  802b82:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b8e:	8b 00                	mov    (%rax),%eax
  802b90:	89 c0                	mov    %eax,%eax
  802b92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802b9a:	c9                   	leaveq 
  802b9b:	c3                   	retq   

0000000000802b9c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802b9c:	55                   	push   %rbp
  802b9d:	48 89 e5             	mov    %rsp,%rbp
  802ba0:	48 83 ec 1c          	sub    $0x1c,%rsp
  802ba4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ba8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802bab:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802baf:	7e 52                	jle    802c03 <getint+0x67>
		x=va_arg(*ap, long long);
  802bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb5:	8b 00                	mov    (%rax),%eax
  802bb7:	83 f8 30             	cmp    $0x30,%eax
  802bba:	73 24                	jae    802be0 <getint+0x44>
  802bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	8b 00                	mov    (%rax),%eax
  802bca:	89 c0                	mov    %eax,%eax
  802bcc:	48 01 d0             	add    %rdx,%rax
  802bcf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd3:	8b 12                	mov    (%rdx),%edx
  802bd5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bd8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bdc:	89 0a                	mov    %ecx,(%rdx)
  802bde:	eb 17                	jmp    802bf7 <getint+0x5b>
  802be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802be8:	48 89 d0             	mov    %rdx,%rax
  802beb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bf7:	48 8b 00             	mov    (%rax),%rax
  802bfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802bfe:	e9 a3 00 00 00       	jmpq   802ca6 <getint+0x10a>
	else if (lflag)
  802c03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c07:	74 4f                	je     802c58 <getint+0xbc>
		x=va_arg(*ap, long);
  802c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0d:	8b 00                	mov    (%rax),%eax
  802c0f:	83 f8 30             	cmp    $0x30,%eax
  802c12:	73 24                	jae    802c38 <getint+0x9c>
  802c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c18:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c20:	8b 00                	mov    (%rax),%eax
  802c22:	89 c0                	mov    %eax,%eax
  802c24:	48 01 d0             	add    %rdx,%rax
  802c27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c2b:	8b 12                	mov    (%rdx),%edx
  802c2d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c34:	89 0a                	mov    %ecx,(%rdx)
  802c36:	eb 17                	jmp    802c4f <getint+0xb3>
  802c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c40:	48 89 d0             	mov    %rdx,%rax
  802c43:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c4b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c4f:	48 8b 00             	mov    (%rax),%rax
  802c52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c56:	eb 4e                	jmp    802ca6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802c58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5c:	8b 00                	mov    (%rax),%eax
  802c5e:	83 f8 30             	cmp    $0x30,%eax
  802c61:	73 24                	jae    802c87 <getint+0xeb>
  802c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c67:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6f:	8b 00                	mov    (%rax),%eax
  802c71:	89 c0                	mov    %eax,%eax
  802c73:	48 01 d0             	add    %rdx,%rax
  802c76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c7a:	8b 12                	mov    (%rdx),%edx
  802c7c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c83:	89 0a                	mov    %ecx,(%rdx)
  802c85:	eb 17                	jmp    802c9e <getint+0x102>
  802c87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c8f:	48 89 d0             	mov    %rdx,%rax
  802c92:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c9e:	8b 00                	mov    (%rax),%eax
  802ca0:	48 98                	cltq   
  802ca2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802caa:	c9                   	leaveq 
  802cab:	c3                   	retq   

0000000000802cac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802cac:	55                   	push   %rbp
  802cad:	48 89 e5             	mov    %rsp,%rbp
  802cb0:	41 54                	push   %r12
  802cb2:	53                   	push   %rbx
  802cb3:	48 83 ec 60          	sub    $0x60,%rsp
  802cb7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802cbb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802cbf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802cc3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802cc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ccb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ccf:	48 8b 0a             	mov    (%rdx),%rcx
  802cd2:	48 89 08             	mov    %rcx,(%rax)
  802cd5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802cd9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cdd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ce1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ce5:	eb 17                	jmp    802cfe <vprintfmt+0x52>
			if (ch == '\0')
  802ce7:	85 db                	test   %ebx,%ebx
  802ce9:	0f 84 cc 04 00 00    	je     8031bb <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802cef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cf7:	48 89 d6             	mov    %rdx,%rsi
  802cfa:	89 df                	mov    %ebx,%edi
  802cfc:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802cfe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d02:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d06:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d0a:	0f b6 00             	movzbl (%rax),%eax
  802d0d:	0f b6 d8             	movzbl %al,%ebx
  802d10:	83 fb 25             	cmp    $0x25,%ebx
  802d13:	75 d2                	jne    802ce7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d15:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d19:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d20:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d41:	0f b6 00             	movzbl (%rax),%eax
  802d44:	0f b6 d8             	movzbl %al,%ebx
  802d47:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802d4a:	83 f8 55             	cmp    $0x55,%eax
  802d4d:	0f 87 34 04 00 00    	ja     803187 <vprintfmt+0x4db>
  802d53:	89 c0                	mov    %eax,%eax
  802d55:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d5c:	00 
  802d5d:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  802d64:	00 00 00 
  802d67:	48 01 d0             	add    %rdx,%rax
  802d6a:	48 8b 00             	mov    (%rax),%rax
  802d6d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802d6f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802d73:	eb c0                	jmp    802d35 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802d75:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802d79:	eb ba                	jmp    802d35 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802d7b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802d82:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d85:	89 d0                	mov    %edx,%eax
  802d87:	c1 e0 02             	shl    $0x2,%eax
  802d8a:	01 d0                	add    %edx,%eax
  802d8c:	01 c0                	add    %eax,%eax
  802d8e:	01 d8                	add    %ebx,%eax
  802d90:	83 e8 30             	sub    $0x30,%eax
  802d93:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802d96:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d9a:	0f b6 00             	movzbl (%rax),%eax
  802d9d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802da0:	83 fb 2f             	cmp    $0x2f,%ebx
  802da3:	7e 0c                	jle    802db1 <vprintfmt+0x105>
  802da5:	83 fb 39             	cmp    $0x39,%ebx
  802da8:	7f 07                	jg     802db1 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802daa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802daf:	eb d1                	jmp    802d82 <vprintfmt+0xd6>
			goto process_precision;
  802db1:	eb 58                	jmp    802e0b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802db3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802db6:	83 f8 30             	cmp    $0x30,%eax
  802db9:	73 17                	jae    802dd2 <vprintfmt+0x126>
  802dbb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dc2:	89 c0                	mov    %eax,%eax
  802dc4:	48 01 d0             	add    %rdx,%rax
  802dc7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802dca:	83 c2 08             	add    $0x8,%edx
  802dcd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802dd0:	eb 0f                	jmp    802de1 <vprintfmt+0x135>
  802dd2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802dd6:	48 89 d0             	mov    %rdx,%rax
  802dd9:	48 83 c2 08          	add    $0x8,%rdx
  802ddd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802de1:	8b 00                	mov    (%rax),%eax
  802de3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802de6:	eb 23                	jmp    802e0b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802de8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802dec:	79 0c                	jns    802dfa <vprintfmt+0x14e>
				width = 0;
  802dee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802df5:	e9 3b ff ff ff       	jmpq   802d35 <vprintfmt+0x89>
  802dfa:	e9 36 ff ff ff       	jmpq   802d35 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802dff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e06:	e9 2a ff ff ff       	jmpq   802d35 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e0f:	79 12                	jns    802e23 <vprintfmt+0x177>
				width = precision, precision = -1;
  802e11:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e14:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e17:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e1e:	e9 12 ff ff ff       	jmpq   802d35 <vprintfmt+0x89>
  802e23:	e9 0d ff ff ff       	jmpq   802d35 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e28:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e2c:	e9 04 ff ff ff       	jmpq   802d35 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e34:	83 f8 30             	cmp    $0x30,%eax
  802e37:	73 17                	jae    802e50 <vprintfmt+0x1a4>
  802e39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e40:	89 c0                	mov    %eax,%eax
  802e42:	48 01 d0             	add    %rdx,%rax
  802e45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e48:	83 c2 08             	add    $0x8,%edx
  802e4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e4e:	eb 0f                	jmp    802e5f <vprintfmt+0x1b3>
  802e50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e54:	48 89 d0             	mov    %rdx,%rax
  802e57:	48 83 c2 08          	add    $0x8,%rdx
  802e5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e5f:	8b 10                	mov    (%rax),%edx
  802e61:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802e65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e69:	48 89 ce             	mov    %rcx,%rsi
  802e6c:	89 d7                	mov    %edx,%edi
  802e6e:	ff d0                	callq  *%rax
			break;
  802e70:	e9 40 03 00 00       	jmpq   8031b5 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802e75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e78:	83 f8 30             	cmp    $0x30,%eax
  802e7b:	73 17                	jae    802e94 <vprintfmt+0x1e8>
  802e7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e84:	89 c0                	mov    %eax,%eax
  802e86:	48 01 d0             	add    %rdx,%rax
  802e89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e8c:	83 c2 08             	add    $0x8,%edx
  802e8f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e92:	eb 0f                	jmp    802ea3 <vprintfmt+0x1f7>
  802e94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e98:	48 89 d0             	mov    %rdx,%rax
  802e9b:	48 83 c2 08          	add    $0x8,%rdx
  802e9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ea3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802ea5:	85 db                	test   %ebx,%ebx
  802ea7:	79 02                	jns    802eab <vprintfmt+0x1ff>
				err = -err;
  802ea9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802eab:	83 fb 15             	cmp    $0x15,%ebx
  802eae:	7f 16                	jg     802ec6 <vprintfmt+0x21a>
  802eb0:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  802eb7:	00 00 00 
  802eba:	48 63 d3             	movslq %ebx,%rdx
  802ebd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802ec1:	4d 85 e4             	test   %r12,%r12
  802ec4:	75 2e                	jne    802ef4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802ec6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802eca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ece:	89 d9                	mov    %ebx,%ecx
  802ed0:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  802ed7:	00 00 00 
  802eda:	48 89 c7             	mov    %rax,%rdi
  802edd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee2:	49 b8 c4 31 80 00 00 	movabs $0x8031c4,%r8
  802ee9:	00 00 00 
  802eec:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802eef:	e9 c1 02 00 00       	jmpq   8031b5 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802ef4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ef8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802efc:	4c 89 e1             	mov    %r12,%rcx
  802eff:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  802f06:	00 00 00 
  802f09:	48 89 c7             	mov    %rax,%rdi
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f11:	49 b8 c4 31 80 00 00 	movabs $0x8031c4,%r8
  802f18:	00 00 00 
  802f1b:	41 ff d0             	callq  *%r8
			break;
  802f1e:	e9 92 02 00 00       	jmpq   8031b5 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f26:	83 f8 30             	cmp    $0x30,%eax
  802f29:	73 17                	jae    802f42 <vprintfmt+0x296>
  802f2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f32:	89 c0                	mov    %eax,%eax
  802f34:	48 01 d0             	add    %rdx,%rax
  802f37:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f3a:	83 c2 08             	add    $0x8,%edx
  802f3d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f40:	eb 0f                	jmp    802f51 <vprintfmt+0x2a5>
  802f42:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f46:	48 89 d0             	mov    %rdx,%rax
  802f49:	48 83 c2 08          	add    $0x8,%rdx
  802f4d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f51:	4c 8b 20             	mov    (%rax),%r12
  802f54:	4d 85 e4             	test   %r12,%r12
  802f57:	75 0a                	jne    802f63 <vprintfmt+0x2b7>
				p = "(null)";
  802f59:	49 bc 6d 42 80 00 00 	movabs $0x80426d,%r12
  802f60:	00 00 00 
			if (width > 0 && padc != '-')
  802f63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f67:	7e 3f                	jle    802fa8 <vprintfmt+0x2fc>
  802f69:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802f6d:	74 39                	je     802fa8 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802f6f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f72:	48 98                	cltq   
  802f74:	48 89 c6             	mov    %rax,%rsi
  802f77:	4c 89 e7             	mov    %r12,%rdi
  802f7a:	48 b8 70 34 80 00 00 	movabs $0x803470,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
  802f86:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802f89:	eb 17                	jmp    802fa2 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802f8b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802f8f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f97:	48 89 ce             	mov    %rcx,%rsi
  802f9a:	89 d7                	mov    %edx,%edi
  802f9c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802f9e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fa2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fa6:	7f e3                	jg     802f8b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fa8:	eb 37                	jmp    802fe1 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802faa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802fae:	74 1e                	je     802fce <vprintfmt+0x322>
  802fb0:	83 fb 1f             	cmp    $0x1f,%ebx
  802fb3:	7e 05                	jle    802fba <vprintfmt+0x30e>
  802fb5:	83 fb 7e             	cmp    $0x7e,%ebx
  802fb8:	7e 14                	jle    802fce <vprintfmt+0x322>
					putch('?', putdat);
  802fba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fc2:	48 89 d6             	mov    %rdx,%rsi
  802fc5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802fca:	ff d0                	callq  *%rax
  802fcc:	eb 0f                	jmp    802fdd <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802fce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fd6:	48 89 d6             	mov    %rdx,%rsi
  802fd9:	89 df                	mov    %ebx,%edi
  802fdb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fdd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fe1:	4c 89 e0             	mov    %r12,%rax
  802fe4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802fe8:	0f b6 00             	movzbl (%rax),%eax
  802feb:	0f be d8             	movsbl %al,%ebx
  802fee:	85 db                	test   %ebx,%ebx
  802ff0:	74 10                	je     803002 <vprintfmt+0x356>
  802ff2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ff6:	78 b2                	js     802faa <vprintfmt+0x2fe>
  802ff8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802ffc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803000:	79 a8                	jns    802faa <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803002:	eb 16                	jmp    80301a <vprintfmt+0x36e>
				putch(' ', putdat);
  803004:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803008:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80300c:	48 89 d6             	mov    %rdx,%rsi
  80300f:	bf 20 00 00 00       	mov    $0x20,%edi
  803014:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803016:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80301a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80301e:	7f e4                	jg     803004 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803020:	e9 90 01 00 00       	jmpq   8031b5 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803025:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803029:	be 03 00 00 00       	mov    $0x3,%esi
  80302e:	48 89 c7             	mov    %rax,%rdi
  803031:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803045:	48 85 c0             	test   %rax,%rax
  803048:	79 1d                	jns    803067 <vprintfmt+0x3bb>
				putch('-', putdat);
  80304a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80304e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803052:	48 89 d6             	mov    %rdx,%rsi
  803055:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80305a:	ff d0                	callq  *%rax
				num = -(long long) num;
  80305c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803060:	48 f7 d8             	neg    %rax
  803063:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803067:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80306e:	e9 d5 00 00 00       	jmpq   803148 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803073:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803077:	be 03 00 00 00       	mov    $0x3,%esi
  80307c:	48 89 c7             	mov    %rax,%rdi
  80307f:	48 b8 8c 2a 80 00 00 	movabs $0x802a8c,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
  80308b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80308f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803096:	e9 ad 00 00 00       	jmpq   803148 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80309b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80309e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030a2:	89 d6                	mov    %edx,%esi
  8030a4:	48 89 c7             	mov    %rax,%rdi
  8030a7:	48 b8 9c 2b 80 00 00 	movabs $0x802b9c,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8030b7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8030be:	e9 85 00 00 00       	jmpq   803148 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8030c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030cb:	48 89 d6             	mov    %rdx,%rsi
  8030ce:	bf 30 00 00 00       	mov    $0x30,%edi
  8030d3:	ff d0                	callq  *%rax
			putch('x', putdat);
  8030d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030dd:	48 89 d6             	mov    %rdx,%rsi
  8030e0:	bf 78 00 00 00       	mov    $0x78,%edi
  8030e5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8030e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030ea:	83 f8 30             	cmp    $0x30,%eax
  8030ed:	73 17                	jae    803106 <vprintfmt+0x45a>
  8030ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030f6:	89 c0                	mov    %eax,%eax
  8030f8:	48 01 d0             	add    %rdx,%rax
  8030fb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030fe:	83 c2 08             	add    $0x8,%edx
  803101:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803104:	eb 0f                	jmp    803115 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803106:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80310a:	48 89 d0             	mov    %rdx,%rax
  80310d:	48 83 c2 08          	add    $0x8,%rdx
  803111:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803115:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803118:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80311c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803123:	eb 23                	jmp    803148 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803125:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803129:	be 03 00 00 00       	mov    $0x3,%esi
  80312e:	48 89 c7             	mov    %rax,%rdi
  803131:	48 b8 8c 2a 80 00 00 	movabs $0x802a8c,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803141:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803148:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80314d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803150:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803153:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803157:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80315b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80315f:	45 89 c1             	mov    %r8d,%r9d
  803162:	41 89 f8             	mov    %edi,%r8d
  803165:	48 89 c7             	mov    %rax,%rdi
  803168:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
			break;
  803174:	eb 3f                	jmp    8031b5 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803176:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80317a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80317e:	48 89 d6             	mov    %rdx,%rsi
  803181:	89 df                	mov    %ebx,%edi
  803183:	ff d0                	callq  *%rax
			break;
  803185:	eb 2e                	jmp    8031b5 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803187:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80318b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80318f:	48 89 d6             	mov    %rdx,%rsi
  803192:	bf 25 00 00 00       	mov    $0x25,%edi
  803197:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803199:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80319e:	eb 05                	jmp    8031a5 <vprintfmt+0x4f9>
  8031a0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031a5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031a9:	48 83 e8 01          	sub    $0x1,%rax
  8031ad:	0f b6 00             	movzbl (%rax),%eax
  8031b0:	3c 25                	cmp    $0x25,%al
  8031b2:	75 ec                	jne    8031a0 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8031b4:	90                   	nop
		}
	}
  8031b5:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031b6:	e9 43 fb ff ff       	jmpq   802cfe <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8031bb:	48 83 c4 60          	add    $0x60,%rsp
  8031bf:	5b                   	pop    %rbx
  8031c0:	41 5c                	pop    %r12
  8031c2:	5d                   	pop    %rbp
  8031c3:	c3                   	retq   

00000000008031c4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8031c4:	55                   	push   %rbp
  8031c5:	48 89 e5             	mov    %rsp,%rbp
  8031c8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8031cf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8031d6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8031dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031f2:	84 c0                	test   %al,%al
  8031f4:	74 20                	je     803216 <printfmt+0x52>
  8031f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803202:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803206:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80320a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80320e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803212:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803216:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80321d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803224:	00 00 00 
  803227:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80322e:	00 00 00 
  803231:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803235:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80323c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803243:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80324a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803251:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803258:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80325f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803266:	48 89 c7             	mov    %rax,%rdi
  803269:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
	va_end(ap);
}
  803275:	c9                   	leaveq 
  803276:	c3                   	retq   

0000000000803277 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803277:	55                   	push   %rbp
  803278:	48 89 e5             	mov    %rsp,%rbp
  80327b:	48 83 ec 10          	sub    $0x10,%rsp
  80327f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803282:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328a:	8b 40 10             	mov    0x10(%rax),%eax
  80328d:	8d 50 01             	lea    0x1(%rax),%edx
  803290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803294:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329b:	48 8b 10             	mov    (%rax),%rdx
  80329e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032a6:	48 39 c2             	cmp    %rax,%rdx
  8032a9:	73 17                	jae    8032c2 <sprintputch+0x4b>
		*b->buf++ = ch;
  8032ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032af:	48 8b 00             	mov    (%rax),%rax
  8032b2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8032b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ba:	48 89 0a             	mov    %rcx,(%rdx)
  8032bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c0:	88 10                	mov    %dl,(%rax)
}
  8032c2:	c9                   	leaveq 
  8032c3:	c3                   	retq   

00000000008032c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8032c4:	55                   	push   %rbp
  8032c5:	48 89 e5             	mov    %rsp,%rbp
  8032c8:	48 83 ec 50          	sub    $0x50,%rsp
  8032cc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8032d0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8032d3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8032d7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8032db:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032df:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8032e3:	48 8b 0a             	mov    (%rdx),%rcx
  8032e6:	48 89 08             	mov    %rcx,(%rax)
  8032e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8032ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8032f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8032f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8032f9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032fd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803301:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803304:	48 98                	cltq   
  803306:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80330a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80330e:	48 01 d0             	add    %rdx,%rax
  803311:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803315:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80331c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803321:	74 06                	je     803329 <vsnprintf+0x65>
  803323:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803327:	7f 07                	jg     803330 <vsnprintf+0x6c>
		return -E_INVAL;
  803329:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80332e:	eb 2f                	jmp    80335f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803330:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803334:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803338:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80333c:	48 89 c6             	mov    %rax,%rsi
  80333f:	48 bf 77 32 80 00 00 	movabs $0x803277,%rdi
  803346:	00 00 00 
  803349:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803355:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803359:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80335c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80335f:	c9                   	leaveq 
  803360:	c3                   	retq   

0000000000803361 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803361:	55                   	push   %rbp
  803362:	48 89 e5             	mov    %rsp,%rbp
  803365:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80336c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803373:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803379:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803380:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803387:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80338e:	84 c0                	test   %al,%al
  803390:	74 20                	je     8033b2 <snprintf+0x51>
  803392:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803396:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80339a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80339e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033b2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8033b9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8033c0:	00 00 00 
  8033c3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033ca:	00 00 00 
  8033cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033df:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8033e6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8033ed:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033f4:	48 8b 0a             	mov    (%rdx),%rcx
  8033f7:	48 89 08             	mov    %rcx,(%rax)
  8033fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8033fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803402:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803406:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80340a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803411:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803418:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80341e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803425:	48 89 c7             	mov    %rax,%rdi
  803428:	48 b8 c4 32 80 00 00 	movabs $0x8032c4,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80343a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803440:	c9                   	leaveq 
  803441:	c3                   	retq   

0000000000803442 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803442:	55                   	push   %rbp
  803443:	48 89 e5             	mov    %rsp,%rbp
  803446:	48 83 ec 18          	sub    $0x18,%rsp
  80344a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80344e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803455:	eb 09                	jmp    803460 <strlen+0x1e>
		n++;
  803457:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80345b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803464:	0f b6 00             	movzbl (%rax),%eax
  803467:	84 c0                	test   %al,%al
  803469:	75 ec                	jne    803457 <strlen+0x15>
		n++;
	return n;
  80346b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80346e:	c9                   	leaveq 
  80346f:	c3                   	retq   

0000000000803470 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803470:	55                   	push   %rbp
  803471:	48 89 e5             	mov    %rsp,%rbp
  803474:	48 83 ec 20          	sub    $0x20,%rsp
  803478:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80347c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803487:	eb 0e                	jmp    803497 <strnlen+0x27>
		n++;
  803489:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80348d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803492:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803497:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80349c:	74 0b                	je     8034a9 <strnlen+0x39>
  80349e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a2:	0f b6 00             	movzbl (%rax),%eax
  8034a5:	84 c0                	test   %al,%al
  8034a7:	75 e0                	jne    803489 <strnlen+0x19>
		n++;
	return n;
  8034a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034ac:	c9                   	leaveq 
  8034ad:	c3                   	retq   

00000000008034ae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8034ae:	55                   	push   %rbp
  8034af:	48 89 e5             	mov    %rsp,%rbp
  8034b2:	48 83 ec 20          	sub    $0x20,%rsp
  8034b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8034be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8034c6:	90                   	nop
  8034c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8034d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034d7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8034db:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8034df:	0f b6 12             	movzbl (%rdx),%edx
  8034e2:	88 10                	mov    %dl,(%rax)
  8034e4:	0f b6 00             	movzbl (%rax),%eax
  8034e7:	84 c0                	test   %al,%al
  8034e9:	75 dc                	jne    8034c7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8034eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034ef:	c9                   	leaveq 
  8034f0:	c3                   	retq   

00000000008034f1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8034f1:	55                   	push   %rbp
  8034f2:	48 89 e5             	mov    %rsp,%rbp
  8034f5:	48 83 ec 20          	sub    $0x20,%rsp
  8034f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	48 89 c7             	mov    %rax,%rdi
  803508:	48 b8 42 34 80 00 00 	movabs $0x803442,%rax
  80350f:	00 00 00 
  803512:	ff d0                	callq  *%rax
  803514:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351a:	48 63 d0             	movslq %eax,%rdx
  80351d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803521:	48 01 c2             	add    %rax,%rdx
  803524:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803528:	48 89 c6             	mov    %rax,%rsi
  80352b:	48 89 d7             	mov    %rdx,%rdi
  80352e:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
	return dst;
  80353a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80353e:	c9                   	leaveq 
  80353f:	c3                   	retq   

0000000000803540 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803540:	55                   	push   %rbp
  803541:	48 89 e5             	mov    %rsp,%rbp
  803544:	48 83 ec 28          	sub    $0x28,%rsp
  803548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80354c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803550:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803558:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80355c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803563:	00 
  803564:	eb 2a                	jmp    803590 <strncpy+0x50>
		*dst++ = *src;
  803566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80356e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803572:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803576:	0f b6 12             	movzbl (%rdx),%edx
  803579:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80357b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357f:	0f b6 00             	movzbl (%rax),%eax
  803582:	84 c0                	test   %al,%al
  803584:	74 05                	je     80358b <strncpy+0x4b>
			src++;
  803586:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80358b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803594:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803598:	72 cc                	jb     803566 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80359a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80359e:	c9                   	leaveq 
  80359f:	c3                   	retq   

00000000008035a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8035a0:	55                   	push   %rbp
  8035a1:	48 89 e5             	mov    %rsp,%rbp
  8035a4:	48 83 ec 28          	sub    $0x28,%rsp
  8035a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8035b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8035bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035c1:	74 3d                	je     803600 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8035c3:	eb 1d                	jmp    8035e2 <strlcpy+0x42>
			*dst++ = *src++;
  8035c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035d5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8035d9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8035dd:	0f b6 12             	movzbl (%rdx),%edx
  8035e0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8035e2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8035e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035ec:	74 0b                	je     8035f9 <strlcpy+0x59>
  8035ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f2:	0f b6 00             	movzbl (%rax),%eax
  8035f5:	84 c0                	test   %al,%al
  8035f7:	75 cc                	jne    8035c5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8035f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803600:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803608:	48 29 c2             	sub    %rax,%rdx
  80360b:	48 89 d0             	mov    %rdx,%rax
}
  80360e:	c9                   	leaveq 
  80360f:	c3                   	retq   

0000000000803610 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803610:	55                   	push   %rbp
  803611:	48 89 e5             	mov    %rsp,%rbp
  803614:	48 83 ec 10          	sub    $0x10,%rsp
  803618:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80361c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803620:	eb 0a                	jmp    80362c <strcmp+0x1c>
		p++, q++;
  803622:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803627:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80362c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803630:	0f b6 00             	movzbl (%rax),%eax
  803633:	84 c0                	test   %al,%al
  803635:	74 12                	je     803649 <strcmp+0x39>
  803637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363b:	0f b6 10             	movzbl (%rax),%edx
  80363e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803642:	0f b6 00             	movzbl (%rax),%eax
  803645:	38 c2                	cmp    %al,%dl
  803647:	74 d9                	je     803622 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364d:	0f b6 00             	movzbl (%rax),%eax
  803650:	0f b6 d0             	movzbl %al,%edx
  803653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803657:	0f b6 00             	movzbl (%rax),%eax
  80365a:	0f b6 c0             	movzbl %al,%eax
  80365d:	29 c2                	sub    %eax,%edx
  80365f:	89 d0                	mov    %edx,%eax
}
  803661:	c9                   	leaveq 
  803662:	c3                   	retq   

0000000000803663 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  803663:	55                   	push   %rbp
  803664:	48 89 e5             	mov    %rsp,%rbp
  803667:	48 83 ec 18          	sub    $0x18,%rsp
  80366b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80366f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803673:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803677:	eb 0f                	jmp    803688 <strncmp+0x25>
		n--, p++, q++;
  803679:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80367e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803683:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803688:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80368d:	74 1d                	je     8036ac <strncmp+0x49>
  80368f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803693:	0f b6 00             	movzbl (%rax),%eax
  803696:	84 c0                	test   %al,%al
  803698:	74 12                	je     8036ac <strncmp+0x49>
  80369a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369e:	0f b6 10             	movzbl (%rax),%edx
  8036a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a5:	0f b6 00             	movzbl (%rax),%eax
  8036a8:	38 c2                	cmp    %al,%dl
  8036aa:	74 cd                	je     803679 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8036ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036b1:	75 07                	jne    8036ba <strncmp+0x57>
		return 0;
  8036b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b8:	eb 18                	jmp    8036d2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8036ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036be:	0f b6 00             	movzbl (%rax),%eax
  8036c1:	0f b6 d0             	movzbl %al,%edx
  8036c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c8:	0f b6 00             	movzbl (%rax),%eax
  8036cb:	0f b6 c0             	movzbl %al,%eax
  8036ce:	29 c2                	sub    %eax,%edx
  8036d0:	89 d0                	mov    %edx,%eax
}
  8036d2:	c9                   	leaveq 
  8036d3:	c3                   	retq   

00000000008036d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8036d4:	55                   	push   %rbp
  8036d5:	48 89 e5             	mov    %rsp,%rbp
  8036d8:	48 83 ec 0c          	sub    $0xc,%rsp
  8036dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e0:	89 f0                	mov    %esi,%eax
  8036e2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8036e5:	eb 17                	jmp    8036fe <strchr+0x2a>
		if (*s == c)
  8036e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036eb:	0f b6 00             	movzbl (%rax),%eax
  8036ee:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8036f1:	75 06                	jne    8036f9 <strchr+0x25>
			return (char *) s;
  8036f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f7:	eb 15                	jmp    80370e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8036f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803702:	0f b6 00             	movzbl (%rax),%eax
  803705:	84 c0                	test   %al,%al
  803707:	75 de                	jne    8036e7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80370e:	c9                   	leaveq 
  80370f:	c3                   	retq   

0000000000803710 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	48 83 ec 0c          	sub    $0xc,%rsp
  803718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371c:	89 f0                	mov    %esi,%eax
  80371e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803721:	eb 13                	jmp    803736 <strfind+0x26>
		if (*s == c)
  803723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803727:	0f b6 00             	movzbl (%rax),%eax
  80372a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80372d:	75 02                	jne    803731 <strfind+0x21>
			break;
  80372f:	eb 10                	jmp    803741 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803731:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373a:	0f b6 00             	movzbl (%rax),%eax
  80373d:	84 c0                	test   %al,%al
  80373f:	75 e2                	jne    803723 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  803741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803745:	c9                   	leaveq 
  803746:	c3                   	retq   

0000000000803747 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803747:	55                   	push   %rbp
  803748:	48 89 e5             	mov    %rsp,%rbp
  80374b:	48 83 ec 18          	sub    $0x18,%rsp
  80374f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803753:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803756:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80375a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80375f:	75 06                	jne    803767 <memset+0x20>
		return v;
  803761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803765:	eb 69                	jmp    8037d0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376b:	83 e0 03             	and    $0x3,%eax
  80376e:	48 85 c0             	test   %rax,%rax
  803771:	75 48                	jne    8037bb <memset+0x74>
  803773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803777:	83 e0 03             	and    $0x3,%eax
  80377a:	48 85 c0             	test   %rax,%rax
  80377d:	75 3c                	jne    8037bb <memset+0x74>
		c &= 0xFF;
  80377f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803786:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803789:	c1 e0 18             	shl    $0x18,%eax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803791:	c1 e0 10             	shl    $0x10,%eax
  803794:	09 c2                	or     %eax,%edx
  803796:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803799:	c1 e0 08             	shl    $0x8,%eax
  80379c:	09 d0                	or     %edx,%eax
  80379e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8037a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a5:	48 c1 e8 02          	shr    $0x2,%rax
  8037a9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8037ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b3:	48 89 d7             	mov    %rdx,%rdi
  8037b6:	fc                   	cld    
  8037b7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8037b9:	eb 11                	jmp    8037cc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8037bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037c6:	48 89 d7             	mov    %rdx,%rdi
  8037c9:	fc                   	cld    
  8037ca:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8037cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037d0:	c9                   	leaveq 
  8037d1:	c3                   	retq   

00000000008037d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8037d2:	55                   	push   %rbp
  8037d3:	48 89 e5             	mov    %rsp,%rbp
  8037d6:	48 83 ec 28          	sub    $0x28,%rsp
  8037da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8037e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8037ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8037f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8037fe:	0f 83 88 00 00 00    	jae    80388c <memmove+0xba>
  803804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803808:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80380c:	48 01 d0             	add    %rdx,%rax
  80380f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803813:	76 77                	jbe    80388c <memmove+0xba>
		s += n;
  803815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803819:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80381d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803821:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803829:	83 e0 03             	and    $0x3,%eax
  80382c:	48 85 c0             	test   %rax,%rax
  80382f:	75 3b                	jne    80386c <memmove+0x9a>
  803831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803835:	83 e0 03             	and    $0x3,%eax
  803838:	48 85 c0             	test   %rax,%rax
  80383b:	75 2f                	jne    80386c <memmove+0x9a>
  80383d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803841:	83 e0 03             	and    $0x3,%eax
  803844:	48 85 c0             	test   %rax,%rax
  803847:	75 23                	jne    80386c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384d:	48 83 e8 04          	sub    $0x4,%rax
  803851:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803855:	48 83 ea 04          	sub    $0x4,%rdx
  803859:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80385d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803861:	48 89 c7             	mov    %rax,%rdi
  803864:	48 89 d6             	mov    %rdx,%rsi
  803867:	fd                   	std    
  803868:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80386a:	eb 1d                	jmp    803889 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80386c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803870:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803878:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80387c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803880:	48 89 d7             	mov    %rdx,%rdi
  803883:	48 89 c1             	mov    %rax,%rcx
  803886:	fd                   	std    
  803887:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803889:	fc                   	cld    
  80388a:	eb 57                	jmp    8038e3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80388c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803890:	83 e0 03             	and    $0x3,%eax
  803893:	48 85 c0             	test   %rax,%rax
  803896:	75 36                	jne    8038ce <memmove+0xfc>
  803898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389c:	83 e0 03             	and    $0x3,%eax
  80389f:	48 85 c0             	test   %rax,%rax
  8038a2:	75 2a                	jne    8038ce <memmove+0xfc>
  8038a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a8:	83 e0 03             	and    $0x3,%eax
  8038ab:	48 85 c0             	test   %rax,%rax
  8038ae:	75 1e                	jne    8038ce <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8038b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b4:	48 c1 e8 02          	shr    $0x2,%rax
  8038b8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8038bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038c3:	48 89 c7             	mov    %rax,%rdi
  8038c6:	48 89 d6             	mov    %rdx,%rsi
  8038c9:	fc                   	cld    
  8038ca:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038cc:	eb 15                	jmp    8038e3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8038ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038d6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038da:	48 89 c7             	mov    %rax,%rdi
  8038dd:	48 89 d6             	mov    %rdx,%rsi
  8038e0:	fc                   	cld    
  8038e1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8038e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8038e7:	c9                   	leaveq 
  8038e8:	c3                   	retq   

00000000008038e9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8038e9:	55                   	push   %rbp
  8038ea:	48 89 e5             	mov    %rsp,%rbp
  8038ed:	48 83 ec 18          	sub    $0x18,%rsp
  8038f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8038fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803901:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803909:	48 89 ce             	mov    %rcx,%rsi
  80390c:	48 89 c7             	mov    %rax,%rdi
  80390f:	48 b8 d2 37 80 00 00 	movabs $0x8037d2,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
}
  80391b:	c9                   	leaveq 
  80391c:	c3                   	retq   

000000000080391d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80391d:	55                   	push   %rbp
  80391e:	48 89 e5             	mov    %rsp,%rbp
  803921:	48 83 ec 28          	sub    $0x28,%rsp
  803925:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803929:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80392d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803935:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803941:	eb 36                	jmp    803979 <memcmp+0x5c>
		if (*s1 != *s2)
  803943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803947:	0f b6 10             	movzbl (%rax),%edx
  80394a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394e:	0f b6 00             	movzbl (%rax),%eax
  803951:	38 c2                	cmp    %al,%dl
  803953:	74 1a                	je     80396f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803959:	0f b6 00             	movzbl (%rax),%eax
  80395c:	0f b6 d0             	movzbl %al,%edx
  80395f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803963:	0f b6 00             	movzbl (%rax),%eax
  803966:	0f b6 c0             	movzbl %al,%eax
  803969:	29 c2                	sub    %eax,%edx
  80396b:	89 d0                	mov    %edx,%eax
  80396d:	eb 20                	jmp    80398f <memcmp+0x72>
		s1++, s2++;
  80396f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803974:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803981:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803985:	48 85 c0             	test   %rax,%rax
  803988:	75 b9                	jne    803943 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80398a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80398f:	c9                   	leaveq 
  803990:	c3                   	retq   

0000000000803991 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803991:	55                   	push   %rbp
  803992:	48 89 e5             	mov    %rsp,%rbp
  803995:	48 83 ec 28          	sub    $0x28,%rsp
  803999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80399d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8039a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8039a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ac:	48 01 d0             	add    %rdx,%rax
  8039af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8039b3:	eb 15                	jmp    8039ca <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8039b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b9:	0f b6 10             	movzbl (%rax),%edx
  8039bc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8039bf:	38 c2                	cmp    %al,%dl
  8039c1:	75 02                	jne    8039c5 <memfind+0x34>
			break;
  8039c3:	eb 0f                	jmp    8039d4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8039c5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8039ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ce:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8039d2:	72 e1                	jb     8039b5 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8039d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8039d8:	c9                   	leaveq 
  8039d9:	c3                   	retq   

00000000008039da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8039da:	55                   	push   %rbp
  8039db:	48 89 e5             	mov    %rsp,%rbp
  8039de:	48 83 ec 34          	sub    $0x34,%rsp
  8039e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ea:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8039ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8039f4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8039fb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8039fc:	eb 05                	jmp    803a03 <strtol+0x29>
		s++;
  8039fe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a07:	0f b6 00             	movzbl (%rax),%eax
  803a0a:	3c 20                	cmp    $0x20,%al
  803a0c:	74 f0                	je     8039fe <strtol+0x24>
  803a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a12:	0f b6 00             	movzbl (%rax),%eax
  803a15:	3c 09                	cmp    $0x9,%al
  803a17:	74 e5                	je     8039fe <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1d:	0f b6 00             	movzbl (%rax),%eax
  803a20:	3c 2b                	cmp    $0x2b,%al
  803a22:	75 07                	jne    803a2b <strtol+0x51>
		s++;
  803a24:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a29:	eb 17                	jmp    803a42 <strtol+0x68>
	else if (*s == '-')
  803a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2f:	0f b6 00             	movzbl (%rax),%eax
  803a32:	3c 2d                	cmp    $0x2d,%al
  803a34:	75 0c                	jne    803a42 <strtol+0x68>
		s++, neg = 1;
  803a36:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a3b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803a42:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a46:	74 06                	je     803a4e <strtol+0x74>
  803a48:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803a4c:	75 28                	jne    803a76 <strtol+0x9c>
  803a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a52:	0f b6 00             	movzbl (%rax),%eax
  803a55:	3c 30                	cmp    $0x30,%al
  803a57:	75 1d                	jne    803a76 <strtol+0x9c>
  803a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5d:	48 83 c0 01          	add    $0x1,%rax
  803a61:	0f b6 00             	movzbl (%rax),%eax
  803a64:	3c 78                	cmp    $0x78,%al
  803a66:	75 0e                	jne    803a76 <strtol+0x9c>
		s += 2, base = 16;
  803a68:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803a6d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803a74:	eb 2c                	jmp    803aa2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803a76:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a7a:	75 19                	jne    803a95 <strtol+0xbb>
  803a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a80:	0f b6 00             	movzbl (%rax),%eax
  803a83:	3c 30                	cmp    $0x30,%al
  803a85:	75 0e                	jne    803a95 <strtol+0xbb>
		s++, base = 8;
  803a87:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a8c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803a93:	eb 0d                	jmp    803aa2 <strtol+0xc8>
	else if (base == 0)
  803a95:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a99:	75 07                	jne    803aa2 <strtol+0xc8>
		base = 10;
  803a9b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803aa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa6:	0f b6 00             	movzbl (%rax),%eax
  803aa9:	3c 2f                	cmp    $0x2f,%al
  803aab:	7e 1d                	jle    803aca <strtol+0xf0>
  803aad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab1:	0f b6 00             	movzbl (%rax),%eax
  803ab4:	3c 39                	cmp    $0x39,%al
  803ab6:	7f 12                	jg     803aca <strtol+0xf0>
			dig = *s - '0';
  803ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803abc:	0f b6 00             	movzbl (%rax),%eax
  803abf:	0f be c0             	movsbl %al,%eax
  803ac2:	83 e8 30             	sub    $0x30,%eax
  803ac5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac8:	eb 4e                	jmp    803b18 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803aca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ace:	0f b6 00             	movzbl (%rax),%eax
  803ad1:	3c 60                	cmp    $0x60,%al
  803ad3:	7e 1d                	jle    803af2 <strtol+0x118>
  803ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad9:	0f b6 00             	movzbl (%rax),%eax
  803adc:	3c 7a                	cmp    $0x7a,%al
  803ade:	7f 12                	jg     803af2 <strtol+0x118>
			dig = *s - 'a' + 10;
  803ae0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae4:	0f b6 00             	movzbl (%rax),%eax
  803ae7:	0f be c0             	movsbl %al,%eax
  803aea:	83 e8 57             	sub    $0x57,%eax
  803aed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803af0:	eb 26                	jmp    803b18 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af6:	0f b6 00             	movzbl (%rax),%eax
  803af9:	3c 40                	cmp    $0x40,%al
  803afb:	7e 48                	jle    803b45 <strtol+0x16b>
  803afd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b01:	0f b6 00             	movzbl (%rax),%eax
  803b04:	3c 5a                	cmp    $0x5a,%al
  803b06:	7f 3d                	jg     803b45 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0c:	0f b6 00             	movzbl (%rax),%eax
  803b0f:	0f be c0             	movsbl %al,%eax
  803b12:	83 e8 37             	sub    $0x37,%eax
  803b15:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803b18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b1b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803b1e:	7c 02                	jl     803b22 <strtol+0x148>
			break;
  803b20:	eb 23                	jmp    803b45 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803b22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b27:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b2a:	48 98                	cltq   
  803b2c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803b31:	48 89 c2             	mov    %rax,%rdx
  803b34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b37:	48 98                	cltq   
  803b39:	48 01 d0             	add    %rdx,%rax
  803b3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803b40:	e9 5d ff ff ff       	jmpq   803aa2 <strtol+0xc8>

	if (endptr)
  803b45:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803b4a:	74 0b                	je     803b57 <strtol+0x17d>
		*endptr = (char *) s;
  803b4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b54:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5b:	74 09                	je     803b66 <strtol+0x18c>
  803b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b61:	48 f7 d8             	neg    %rax
  803b64:	eb 04                	jmp    803b6a <strtol+0x190>
  803b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803b6a:	c9                   	leaveq 
  803b6b:	c3                   	retq   

0000000000803b6c <strstr>:

char * strstr(const char *in, const char *str)
{
  803b6c:	55                   	push   %rbp
  803b6d:	48 89 e5             	mov    %rsp,%rbp
  803b70:	48 83 ec 30          	sub    $0x30,%rsp
  803b74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b78:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803b7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b84:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803b88:	0f b6 00             	movzbl (%rax),%eax
  803b8b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803b8e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803b92:	75 06                	jne    803b9a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803b94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b98:	eb 6b                	jmp    803c05 <strstr+0x99>

	len = strlen(str);
  803b9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b9e:	48 89 c7             	mov    %rax,%rdi
  803ba1:	48 b8 42 34 80 00 00 	movabs $0x803442,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	48 98                	cltq   
  803baf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803bb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bbb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803bbf:	0f b6 00             	movzbl (%rax),%eax
  803bc2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803bc5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803bc9:	75 07                	jne    803bd2 <strstr+0x66>
				return (char *) 0;
  803bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd0:	eb 33                	jmp    803c05 <strstr+0x99>
		} while (sc != c);
  803bd2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803bd6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803bd9:	75 d8                	jne    803bb3 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803bdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bdf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803be3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be7:	48 89 ce             	mov    %rcx,%rsi
  803bea:	48 89 c7             	mov    %rax,%rdi
  803bed:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  803bf4:	00 00 00 
  803bf7:	ff d0                	callq  *%rax
  803bf9:	85 c0                	test   %eax,%eax
  803bfb:	75 b6                	jne    803bb3 <strstr+0x47>

	return (char *) (in - 1);
  803bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c01:	48 83 e8 01          	sub    $0x1,%rax
}
  803c05:	c9                   	leaveq 
  803c06:	c3                   	retq   

0000000000803c07 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c07:	55                   	push   %rbp
  803c08:	48 89 e5             	mov    %rsp,%rbp
  803c0b:	48 83 ec 30          	sub    $0x30,%rsp
  803c0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c1b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c22:	00 00 00 
  803c25:	48 8b 00             	mov    (%rax),%rax
  803c28:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 3c                	jne    803c6e <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c32:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  803c39:	00 00 00 
  803c3c:	ff d0                	callq  *%rax
  803c3e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c43:	48 63 d0             	movslq %eax,%rdx
  803c46:	48 89 d0             	mov    %rdx,%rax
  803c49:	48 c1 e0 03          	shl    $0x3,%rax
  803c4d:	48 01 d0             	add    %rdx,%rax
  803c50:	48 c1 e0 05          	shl    $0x5,%rax
  803c54:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c5b:	00 00 00 
  803c5e:	48 01 c2             	add    %rax,%rdx
  803c61:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c68:	00 00 00 
  803c6b:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c6e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c73:	75 0e                	jne    803c83 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c75:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c7c:	00 00 00 
  803c7f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c87:	48 89 c7             	mov    %rax,%rdi
  803c8a:	48 b8 24 05 80 00 00 	movabs $0x800524,%rax
  803c91:	00 00 00 
  803c94:	ff d0                	callq  *%rax
  803c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9d:	79 19                	jns    803cb8 <ipc_recv+0xb1>
		*from_env_store = 0;
  803c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb6:	eb 53                	jmp    803d0b <ipc_recv+0x104>
	}
	if(from_env_store)
  803cb8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cbd:	74 19                	je     803cd8 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803cbf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cc6:	00 00 00 
  803cc9:	48 8b 00             	mov    (%rax),%rax
  803ccc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd6:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cdd:	74 19                	je     803cf8 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cdf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ce6:	00 00 00 
  803ce9:	48 8b 00             	mov    (%rax),%rax
  803cec:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803cf2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf6:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803cf8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cff:	00 00 00 
  803d02:	48 8b 00             	mov    (%rax),%rax
  803d05:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d0b:	c9                   	leaveq 
  803d0c:	c3                   	retq   

0000000000803d0d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d0d:	55                   	push   %rbp
  803d0e:	48 89 e5             	mov    %rsp,%rbp
  803d11:	48 83 ec 30          	sub    $0x30,%rsp
  803d15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d18:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d1b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d1f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d22:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d27:	75 0e                	jne    803d37 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d29:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d30:	00 00 00 
  803d33:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d37:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d3a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d3d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d44:	89 c7                	mov    %eax,%edi
  803d46:	48 b8 cf 04 80 00 00 	movabs $0x8004cf,%rax
  803d4d:	00 00 00 
  803d50:	ff d0                	callq  *%rax
  803d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d55:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d59:	75 0c                	jne    803d67 <ipc_send+0x5a>
			sys_yield();
  803d5b:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  803d62:	00 00 00 
  803d65:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d67:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d6b:	74 ca                	je     803d37 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d6d:	c9                   	leaveq 
  803d6e:	c3                   	retq   

0000000000803d6f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d6f:	55                   	push   %rbp
  803d70:	48 89 e5             	mov    %rsp,%rbp
  803d73:	48 83 ec 14          	sub    $0x14,%rsp
  803d77:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d81:	eb 5e                	jmp    803de1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d83:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d8a:	00 00 00 
  803d8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d90:	48 63 d0             	movslq %eax,%rdx
  803d93:	48 89 d0             	mov    %rdx,%rax
  803d96:	48 c1 e0 03          	shl    $0x3,%rax
  803d9a:	48 01 d0             	add    %rdx,%rax
  803d9d:	48 c1 e0 05          	shl    $0x5,%rax
  803da1:	48 01 c8             	add    %rcx,%rax
  803da4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803daa:	8b 00                	mov    (%rax),%eax
  803dac:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803daf:	75 2c                	jne    803ddd <ipc_find_env+0x6e>
			return envs[i].env_id;
  803db1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803db8:	00 00 00 
  803dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbe:	48 63 d0             	movslq %eax,%rdx
  803dc1:	48 89 d0             	mov    %rdx,%rax
  803dc4:	48 c1 e0 03          	shl    $0x3,%rax
  803dc8:	48 01 d0             	add    %rdx,%rax
  803dcb:	48 c1 e0 05          	shl    $0x5,%rax
  803dcf:	48 01 c8             	add    %rcx,%rax
  803dd2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803dd8:	8b 40 08             	mov    0x8(%rax),%eax
  803ddb:	eb 12                	jmp    803def <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ddd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803de1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803de8:	7e 99                	jle    803d83 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803def:	c9                   	leaveq 
  803df0:	c3                   	retq   

0000000000803df1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803df1:	55                   	push   %rbp
  803df2:	48 89 e5             	mov    %rsp,%rbp
  803df5:	48 83 ec 18          	sub    $0x18,%rsp
  803df9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e01:	48 c1 e8 15          	shr    $0x15,%rax
  803e05:	48 89 c2             	mov    %rax,%rdx
  803e08:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e0f:	01 00 00 
  803e12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e16:	83 e0 01             	and    $0x1,%eax
  803e19:	48 85 c0             	test   %rax,%rax
  803e1c:	75 07                	jne    803e25 <pageref+0x34>
		return 0;
  803e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e23:	eb 53                	jmp    803e78 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e29:	48 c1 e8 0c          	shr    $0xc,%rax
  803e2d:	48 89 c2             	mov    %rax,%rdx
  803e30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e37:	01 00 00 
  803e3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e46:	83 e0 01             	and    $0x1,%eax
  803e49:	48 85 c0             	test   %rax,%rax
  803e4c:	75 07                	jne    803e55 <pageref+0x64>
		return 0;
  803e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e53:	eb 23                	jmp    803e78 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e59:	48 c1 e8 0c          	shr    $0xc,%rax
  803e5d:	48 89 c2             	mov    %rax,%rdx
  803e60:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e67:	00 00 00 
  803e6a:	48 c1 e2 04          	shl    $0x4,%rdx
  803e6e:	48 01 d0             	add    %rdx,%rax
  803e71:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e75:	0f b7 c0             	movzwl %ax,%eax
}
  803e78:	c9                   	leaveq 
  803e79:	c3                   	retq   
