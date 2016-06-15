
obj/user/faultbadhandler.debug:     file format elf64-x86-64


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
  80003c:	e8 4f 00 00 00       	callq  800090 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  80006d:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	c9                   	leaveq 
  80008f:	c3                   	retq   

0000000000800090 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800090:	55                   	push   %rbp
  800091:	48 89 e5             	mov    %rsp,%rbp
  800094:	48 83 ec 10          	sub    $0x10,%rsp
  800098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80009f:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  8000a6:	00 00 00 
  8000a9:	ff d0                	callq  *%rax
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	48 63 d0             	movslq %eax,%rdx
  8000b3:	48 89 d0             	mov    %rdx,%rax
  8000b6:	48 c1 e0 03          	shl    $0x3,%rax
  8000ba:	48 01 d0             	add    %rdx,%rax
  8000bd:	48 c1 e0 05          	shl    $0x5,%rax
  8000c1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c8:	00 00 00 
  8000cb:	48 01 c2             	add    %rax,%rdx
  8000ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000d5:	00 00 00 
  8000d8:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000df:	7e 14                	jle    8000f5 <libmain+0x65>
		binaryname = argv[0];
  8000e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e5:	48 8b 10             	mov    (%rax),%rdx
  8000e8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ef:	00 00 00 
  8000f2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fc:	48 89 d6             	mov    %rdx,%rsi
  8000ff:	89 c7                	mov    %eax,%edi
  800101:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80010d:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
}
  800119:	c9                   	leaveq 
  80011a:	c3                   	retq   

000000000080011b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011b:	55                   	push   %rbp
  80011c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80011f:	48 b8 8e 09 80 00 00 	movabs $0x80098e,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80012b:	bf 00 00 00 00       	mov    $0x0,%edi
  800130:	48 b8 54 02 80 00 00 	movabs $0x800254,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax

}
  80013c:	5d                   	pop    %rbp
  80013d:	c3                   	retq   

000000000080013e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	53                   	push   %rbx
  800143:	48 83 ec 48          	sub    $0x48,%rsp
  800147:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80014a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80014d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800151:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800155:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800159:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80015d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800160:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800164:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800168:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80016c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800170:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800174:	4c 89 c3             	mov    %r8,%rbx
  800177:	cd 30                	int    $0x30
  800179:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80017d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800181:	74 3e                	je     8001c1 <syscall+0x83>
  800183:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800188:	7e 37                	jle    8001c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80018e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800191:	49 89 d0             	mov    %rdx,%r8
  800194:	89 c1                	mov    %eax,%ecx
  800196:	48 ba aa 3e 80 00 00 	movabs $0x803eaa,%rdx
  80019d:	00 00 00 
  8001a0:	be 23 00 00 00       	mov    $0x23,%esi
  8001a5:	48 bf c7 3e 80 00 00 	movabs $0x803ec7,%rdi
  8001ac:	00 00 00 
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b4:	49 b9 d9 26 80 00 00 	movabs $0x8026d9,%r9
  8001bb:	00 00 00 
  8001be:	41 ff d1             	callq  *%r9

	return ret;
  8001c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001c5:	48 83 c4 48          	add    $0x48,%rsp
  8001c9:	5b                   	pop    %rbx
  8001ca:	5d                   	pop    %rbp
  8001cb:	c3                   	retq   

00000000008001cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 20          	sub    $0x20,%rsp
  8001d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001eb:	00 
  8001ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f8:	48 89 d1             	mov    %rdx,%rcx
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	be 00 00 00 00       	mov    $0x0,%esi
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
}
  800214:	c9                   	leaveq 
  800215:	c3                   	retq   

0000000000800216 <sys_cgetc>:

int
sys_cgetc(void)
{
  800216:	55                   	push   %rbp
  800217:	48 89 e5             	mov    %rsp,%rbp
  80021a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80021e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800225:	00 
  800226:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	ba 00 00 00 00       	mov    $0x0,%edx
  80023c:	be 00 00 00 00       	mov    $0x0,%esi
  800241:	bf 01 00 00 00       	mov    $0x1,%edi
  800246:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
}
  800252:	c9                   	leaveq 
  800253:	c3                   	retq   

0000000000800254 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800254:	55                   	push   %rbp
  800255:	48 89 e5             	mov    %rsp,%rbp
  800258:	48 83 ec 10          	sub    $0x10,%rsp
  80025c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80025f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800262:	48 98                	cltq   
  800264:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80026b:	00 
  80026c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800272:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800278:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027d:	48 89 c2             	mov    %rax,%rdx
  800280:	be 01 00 00 00       	mov    $0x1,%esi
  800285:	bf 03 00 00 00       	mov    $0x3,%edi
  80028a:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax
}
  800296:	c9                   	leaveq 
  800297:	c3                   	retq   

0000000000800298 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800298:	55                   	push   %rbp
  800299:	48 89 e5             	mov    %rsp,%rbp
  80029c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002a7:	00 
  8002a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002be:	be 00 00 00 00       	mov    $0x0,%esi
  8002c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8002c8:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax
}
  8002d4:	c9                   	leaveq 
  8002d5:	c3                   	retq   

00000000008002d6 <sys_yield>:

void
sys_yield(void)
{
  8002d6:	55                   	push   %rbp
  8002d7:	48 89 e5             	mov    %rsp,%rbp
  8002da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002e5:	00 
  8002e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	bf 0b 00 00 00       	mov    $0xb,%edi
  800306:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
}
  800312:	c9                   	leaveq 
  800313:	c3                   	retq   

0000000000800314 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800314:	55                   	push   %rbp
  800315:	48 89 e5             	mov    %rsp,%rbp
  800318:	48 83 ec 20          	sub    $0x20,%rsp
  80031c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80031f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800323:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800326:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800329:	48 63 c8             	movslq %eax,%rcx
  80032c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800333:	48 98                	cltq   
  800335:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80033c:	00 
  80033d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800343:	49 89 c8             	mov    %rcx,%r8
  800346:	48 89 d1             	mov    %rdx,%rcx
  800349:	48 89 c2             	mov    %rax,%rdx
  80034c:	be 01 00 00 00       	mov    $0x1,%esi
  800351:	bf 04 00 00 00       	mov    $0x4,%edi
  800356:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80035d:	00 00 00 
  800360:	ff d0                	callq  *%rax
}
  800362:	c9                   	leaveq 
  800363:	c3                   	retq   

0000000000800364 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	48 83 ec 30          	sub    $0x30,%rsp
  80036c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800373:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800376:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80037a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80037e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800381:	48 63 c8             	movslq %eax,%rcx
  800384:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800388:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80038b:	48 63 f0             	movslq %eax,%rsi
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800395:	48 98                	cltq   
  800397:	48 89 0c 24          	mov    %rcx,(%rsp)
  80039b:	49 89 f9             	mov    %rdi,%r9
  80039e:	49 89 f0             	mov    %rsi,%r8
  8003a1:	48 89 d1             	mov    %rdx,%rcx
  8003a4:	48 89 c2             	mov    %rax,%rdx
  8003a7:	be 01 00 00 00       	mov    $0x1,%esi
  8003ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8003b1:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	callq  *%rax
}
  8003bd:	c9                   	leaveq 
  8003be:	c3                   	retq   

00000000008003bf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003bf:	55                   	push   %rbp
  8003c0:	48 89 e5             	mov    %rsp,%rbp
  8003c3:	48 83 ec 20          	sub    $0x20,%rsp
  8003c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003d5:	48 98                	cltq   
  8003d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003de:	00 
  8003df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003eb:	48 89 d1             	mov    %rdx,%rcx
  8003ee:	48 89 c2             	mov    %rax,%rdx
  8003f1:	be 01 00 00 00       	mov    $0x1,%esi
  8003f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003fb:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
}
  800407:	c9                   	leaveq 
  800408:	c3                   	retq   

0000000000800409 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800409:	55                   	push   %rbp
  80040a:	48 89 e5             	mov    %rsp,%rbp
  80040d:	48 83 ec 10          	sub    $0x10,%rsp
  800411:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800414:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800417:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80041a:	48 63 d0             	movslq %eax,%rdx
  80041d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420:	48 98                	cltq   
  800422:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800429:	00 
  80042a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800430:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800436:	48 89 d1             	mov    %rdx,%rcx
  800439:	48 89 c2             	mov    %rax,%rdx
  80043c:	be 01 00 00 00       	mov    $0x1,%esi
  800441:	bf 08 00 00 00       	mov    $0x8,%edi
  800446:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
}
  800452:	c9                   	leaveq 
  800453:	c3                   	retq   

0000000000800454 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800454:	55                   	push   %rbp
  800455:	48 89 e5             	mov    %rsp,%rbp
  800458:	48 83 ec 20          	sub    $0x20,%rsp
  80045c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80045f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800463:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80046a:	48 98                	cltq   
  80046c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800473:	00 
  800474:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80047a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800480:	48 89 d1             	mov    %rdx,%rcx
  800483:	48 89 c2             	mov    %rax,%rdx
  800486:	be 01 00 00 00       	mov    $0x1,%esi
  80048b:	bf 09 00 00 00       	mov    $0x9,%edi
  800490:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	48 83 ec 20          	sub    $0x20,%rsp
  8004a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b4:	48 98                	cltq   
  8004b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004bd:	00 
  8004be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ca:	48 89 d1             	mov    %rdx,%rcx
  8004cd:	48 89 c2             	mov    %rax,%rdx
  8004d0:	be 01 00 00 00       	mov    $0x1,%esi
  8004d5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004da:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax
}
  8004e6:	c9                   	leaveq 
  8004e7:	c3                   	retq   

00000000008004e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	48 83 ec 20          	sub    $0x20,%rsp
  8004f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004fb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800501:	48 63 f0             	movslq %eax,%rsi
  800504:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800508:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050b:	48 98                	cltq   
  80050d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800511:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800518:	00 
  800519:	49 89 f1             	mov    %rsi,%r9
  80051c:	49 89 c8             	mov    %rcx,%r8
  80051f:	48 89 d1             	mov    %rdx,%rcx
  800522:	48 89 c2             	mov    %rax,%rdx
  800525:	be 00 00 00 00       	mov    $0x0,%esi
  80052a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80052f:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800536:	00 00 00 
  800539:	ff d0                	callq  *%rax
}
  80053b:	c9                   	leaveq 
  80053c:	c3                   	retq   

000000000080053d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80053d:	55                   	push   %rbp
  80053e:	48 89 e5             	mov    %rsp,%rbp
  800541:	48 83 ec 10          	sub    $0x10,%rsp
  800545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80054d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800554:	00 
  800555:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80055b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800561:	b9 00 00 00 00       	mov    $0x0,%ecx
  800566:	48 89 c2             	mov    %rax,%rdx
  800569:	be 01 00 00 00       	mov    $0x1,%esi
  80056e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800573:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
}
  80057f:	c9                   	leaveq 
  800580:	c3                   	retq   

0000000000800581 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800581:	55                   	push   %rbp
  800582:	48 89 e5             	mov    %rsp,%rbp
  800585:	48 83 ec 20          	sub    $0x20,%rsp
  800589:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80058d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800599:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005a0:	00 
  8005a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005ad:	48 89 d1             	mov    %rdx,%rcx
  8005b0:	48 89 c2             	mov    %rax,%rdx
  8005b3:	be 01 00 00 00       	mov    $0x1,%esi
  8005b8:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005bd:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8005c4:	00 00 00 
  8005c7:	ff d0                	callq  *%rax
}
  8005c9:	c9                   	leaveq 
  8005ca:	c3                   	retq   

00000000008005cb <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8005cb:	55                   	push   %rbp
  8005cc:	48 89 e5             	mov    %rsp,%rbp
  8005cf:	48 83 ec 10          	sub    $0x10,%rsp
  8005d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8005d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005e2:	00 
  8005e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f4:	48 89 c2             	mov    %rax,%rdx
  8005f7:	be 00 00 00 00       	mov    $0x0,%esi
  8005fc:	bf 10 00 00 00       	mov    $0x10,%edi
  800601:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800608:	00 00 00 
  80060b:	ff d0                	callq  *%rax
}
  80060d:	c9                   	leaveq 
  80060e:	c3                   	retq   

000000000080060f <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80060f:	55                   	push   %rbp
  800610:	48 89 e5             	mov    %rsp,%rbp
  800613:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800617:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80061e:	00 
  80061f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800625:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80062b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800630:	ba 00 00 00 00       	mov    $0x0,%edx
  800635:	be 00 00 00 00       	mov    $0x0,%esi
  80063a:	bf 0e 00 00 00       	mov    $0xe,%edi
  80063f:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800646:	00 00 00 
  800649:	ff d0                	callq  *%rax
}
  80064b:	c9                   	leaveq 
  80064c:	c3                   	retq   

000000000080064d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80064d:	55                   	push   %rbp
  80064e:	48 89 e5             	mov    %rsp,%rbp
  800651:	48 83 ec 08          	sub    $0x8,%rsp
  800655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800659:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80065d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800664:	ff ff ff 
  800667:	48 01 d0             	add    %rdx,%rax
  80066a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80066e:	c9                   	leaveq 
  80066f:	c3                   	retq   

0000000000800670 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800670:	55                   	push   %rbp
  800671:	48 89 e5             	mov    %rsp,%rbp
  800674:	48 83 ec 08          	sub    $0x8,%rsp
  800678:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80067c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800680:	48 89 c7             	mov    %rax,%rdi
  800683:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  80068a:	00 00 00 
  80068d:	ff d0                	callq  *%rax
  80068f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800695:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800699:	c9                   	leaveq 
  80069a:	c3                   	retq   

000000000080069b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80069b:	55                   	push   %rbp
  80069c:	48 89 e5             	mov    %rsp,%rbp
  80069f:	48 83 ec 18          	sub    $0x18,%rsp
  8006a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006ae:	eb 6b                	jmp    80071b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006b3:	48 98                	cltq   
  8006b5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006bb:	48 c1 e0 0c          	shl    $0xc,%rax
  8006bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c7:	48 c1 e8 15          	shr    $0x15,%rax
  8006cb:	48 89 c2             	mov    %rax,%rdx
  8006ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006d5:	01 00 00 
  8006d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006dc:	83 e0 01             	and    $0x1,%eax
  8006df:	48 85 c0             	test   %rax,%rax
  8006e2:	74 21                	je     800705 <fd_alloc+0x6a>
  8006e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8006ec:	48 89 c2             	mov    %rax,%rdx
  8006ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006f6:	01 00 00 
  8006f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006fd:	83 e0 01             	and    $0x1,%eax
  800700:	48 85 c0             	test   %rax,%rax
  800703:	75 12                	jne    800717 <fd_alloc+0x7c>
			*fd_store = fd;
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
  800715:	eb 1a                	jmp    800731 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800717:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80071b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80071f:	7e 8f                	jle    8006b0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800725:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80072c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800731:	c9                   	leaveq 
  800732:	c3                   	retq   

0000000000800733 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800733:	55                   	push   %rbp
  800734:	48 89 e5             	mov    %rsp,%rbp
  800737:	48 83 ec 20          	sub    $0x20,%rsp
  80073b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80073e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800742:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800746:	78 06                	js     80074e <fd_lookup+0x1b>
  800748:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80074c:	7e 07                	jle    800755 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80074e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800753:	eb 6c                	jmp    8007c1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800755:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800758:	48 98                	cltq   
  80075a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800760:	48 c1 e0 0c          	shl    $0xc,%rax
  800764:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80076c:	48 c1 e8 15          	shr    $0x15,%rax
  800770:	48 89 c2             	mov    %rax,%rdx
  800773:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80077a:	01 00 00 
  80077d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800781:	83 e0 01             	and    $0x1,%eax
  800784:	48 85 c0             	test   %rax,%rax
  800787:	74 21                	je     8007aa <fd_lookup+0x77>
  800789:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078d:	48 c1 e8 0c          	shr    $0xc,%rax
  800791:	48 89 c2             	mov    %rax,%rdx
  800794:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80079b:	01 00 00 
  80079e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007a2:	83 e0 01             	and    $0x1,%eax
  8007a5:	48 85 c0             	test   %rax,%rax
  8007a8:	75 07                	jne    8007b1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007af:	eb 10                	jmp    8007c1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007b9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c1:	c9                   	leaveq 
  8007c2:	c3                   	retq   

00000000008007c3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007c3:	55                   	push   %rbp
  8007c4:	48 89 e5             	mov    %rsp,%rbp
  8007c7:	48 83 ec 30          	sub    $0x30,%rsp
  8007cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007cf:	89 f0                	mov    %esi,%eax
  8007d1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d8:	48 89 c7             	mov    %rax,%rdi
  8007db:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	callq  *%rax
  8007e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8007eb:	48 89 d6             	mov    %rdx,%rsi
  8007ee:	89 c7                	mov    %eax,%edi
  8007f0:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8007f7:	00 00 00 
  8007fa:	ff d0                	callq  *%rax
  8007fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800803:	78 0a                	js     80080f <fd_close+0x4c>
	    || fd != fd2)
  800805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800809:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80080d:	74 12                	je     800821 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80080f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800813:	74 05                	je     80081a <fd_close+0x57>
  800815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800818:	eb 05                	jmp    80081f <fd_close+0x5c>
  80081a:	b8 00 00 00 00       	mov    $0x0,%eax
  80081f:	eb 69                	jmp    80088a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80082b:	48 89 d6             	mov    %rdx,%rsi
  80082e:	89 c7                	mov    %eax,%edi
  800830:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800837:	00 00 00 
  80083a:	ff d0                	callq  *%rax
  80083c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800843:	78 2a                	js     80086f <fd_close+0xac>
		if (dev->dev_close)
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	48 8b 40 20          	mov    0x20(%rax),%rax
  80084d:	48 85 c0             	test   %rax,%rax
  800850:	74 16                	je     800868 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	48 8b 40 20          	mov    0x20(%rax),%rax
  80085a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80085e:	48 89 d7             	mov    %rdx,%rdi
  800861:	ff d0                	callq  *%rax
  800863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800866:	eb 07                	jmp    80086f <fd_close+0xac>
		else
			r = 0;
  800868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80086f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800873:	48 89 c6             	mov    %rax,%rsi
  800876:	bf 00 00 00 00       	mov    $0x0,%edi
  80087b:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800882:	00 00 00 
  800885:	ff d0                	callq  *%rax
	return r;
  800887:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80088a:	c9                   	leaveq 
  80088b:	c3                   	retq   

000000000080088c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80088c:	55                   	push   %rbp
  80088d:	48 89 e5             	mov    %rsp,%rbp
  800890:	48 83 ec 20          	sub    $0x20,%rsp
  800894:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800897:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80089b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008a2:	eb 41                	jmp    8008e5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008a4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008ab:	00 00 00 
  8008ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008b1:	48 63 d2             	movslq %edx,%rdx
  8008b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008b8:	8b 00                	mov    (%rax),%eax
  8008ba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008bd:	75 22                	jne    8008e1 <dev_lookup+0x55>
			*dev = devtab[i];
  8008bf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008c6:	00 00 00 
  8008c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008cc:	48 63 d2             	movslq %edx,%rdx
  8008cf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008d7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	eb 60                	jmp    800941 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008e5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008ec:	00 00 00 
  8008ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008f2:	48 63 d2             	movslq %edx,%rdx
  8008f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008f9:	48 85 c0             	test   %rax,%rax
  8008fc:	75 a6                	jne    8008a4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008fe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800905:	00 00 00 
  800908:	48 8b 00             	mov    (%rax),%rax
  80090b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800911:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800914:	89 c6                	mov    %eax,%esi
  800916:	48 bf d8 3e 80 00 00 	movabs $0x803ed8,%rdi
  80091d:	00 00 00 
  800920:	b8 00 00 00 00       	mov    $0x0,%eax
  800925:	48 b9 12 29 80 00 00 	movabs $0x802912,%rcx
  80092c:	00 00 00 
  80092f:	ff d1                	callq  *%rcx
	*dev = 0;
  800931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800935:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80093c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800941:	c9                   	leaveq 
  800942:	c3                   	retq   

0000000000800943 <close>:

int
close(int fdnum)
{
  800943:	55                   	push   %rbp
  800944:	48 89 e5             	mov    %rsp,%rbp
  800947:	48 83 ec 20          	sub    $0x20,%rsp
  80094b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80094e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800955:	48 89 d6             	mov    %rdx,%rsi
  800958:	89 c7                	mov    %eax,%edi
  80095a:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800961:	00 00 00 
  800964:	ff d0                	callq  *%rax
  800966:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800969:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80096d:	79 05                	jns    800974 <close+0x31>
		return r;
  80096f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800972:	eb 18                	jmp    80098c <close+0x49>
	else
		return fd_close(fd, 1);
  800974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800978:	be 01 00 00 00       	mov    $0x1,%esi
  80097d:	48 89 c7             	mov    %rax,%rdi
  800980:	48 b8 c3 07 80 00 00 	movabs $0x8007c3,%rax
  800987:	00 00 00 
  80098a:	ff d0                	callq  *%rax
}
  80098c:	c9                   	leaveq 
  80098d:	c3                   	retq   

000000000080098e <close_all>:

void
close_all(void)
{
  80098e:	55                   	push   %rbp
  80098f:	48 89 e5             	mov    %rsp,%rbp
  800992:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80099d:	eb 15                	jmp    8009b4 <close_all+0x26>
		close(i);
  80099f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a2:	89 c7                	mov    %eax,%edi
  8009a4:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  8009ab:	00 00 00 
  8009ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009b8:	7e e5                	jle    80099f <close_all+0x11>
		close(i);
}
  8009ba:	c9                   	leaveq 
  8009bb:	c3                   	retq   

00000000008009bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009bc:	55                   	push   %rbp
  8009bd:	48 89 e5             	mov    %rsp,%rbp
  8009c0:	48 83 ec 40          	sub    $0x40,%rsp
  8009c4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009c7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009ca:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009d1:	48 89 d6             	mov    %rdx,%rsi
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8009dd:	00 00 00 
  8009e0:	ff d0                	callq  *%rax
  8009e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009e9:	79 08                	jns    8009f3 <dup+0x37>
		return r;
  8009eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009ee:	e9 70 01 00 00       	jmpq   800b63 <dup+0x1a7>
	close(newfdnum);
  8009f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009f6:	89 c7                	mov    %eax,%edi
  8009f8:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  8009ff:	00 00 00 
  800a02:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a04:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a07:	48 98                	cltq   
  800a09:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a0f:	48 c1 e0 0c          	shl    $0xc,%rax
  800a13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1b:	48 89 c7             	mov    %rax,%rdi
  800a1e:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  800a25:	00 00 00 
  800a28:	ff d0                	callq  *%rax
  800a2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a32:	48 89 c7             	mov    %rax,%rdi
  800a35:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  800a3c:	00 00 00 
  800a3f:	ff d0                	callq  *%rax
  800a41:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a49:	48 c1 e8 15          	shr    $0x15,%rax
  800a4d:	48 89 c2             	mov    %rax,%rdx
  800a50:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a57:	01 00 00 
  800a5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a5e:	83 e0 01             	and    $0x1,%eax
  800a61:	48 85 c0             	test   %rax,%rax
  800a64:	74 73                	je     800ad9 <dup+0x11d>
  800a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6a:	48 c1 e8 0c          	shr    $0xc,%rax
  800a6e:	48 89 c2             	mov    %rax,%rdx
  800a71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a78:	01 00 00 
  800a7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a7f:	83 e0 01             	and    $0x1,%eax
  800a82:	48 85 c0             	test   %rax,%rax
  800a85:	74 52                	je     800ad9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8b:	48 c1 e8 0c          	shr    $0xc,%rax
  800a8f:	48 89 c2             	mov    %rax,%rdx
  800a92:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a99:	01 00 00 
  800a9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800aa0:	25 07 0e 00 00       	and    $0xe07,%eax
  800aa5:	89 c1                	mov    %eax,%ecx
  800aa7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	41 89 c8             	mov    %ecx,%r8d
  800ab2:	48 89 d1             	mov    %rdx,%rcx
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	48 89 c6             	mov    %rax,%rsi
  800abd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac2:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  800ac9:	00 00 00 
  800acc:	ff d0                	callq  *%rax
  800ace:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad5:	79 02                	jns    800ad9 <dup+0x11d>
			goto err;
  800ad7:	eb 57                	jmp    800b30 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ad9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800add:	48 c1 e8 0c          	shr    $0xc,%rax
  800ae1:	48 89 c2             	mov    %rax,%rdx
  800ae4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800aeb:	01 00 00 
  800aee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800af2:	25 07 0e 00 00       	and    $0xe07,%eax
  800af7:	89 c1                	mov    %eax,%ecx
  800af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800afd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b01:	41 89 c8             	mov    %ecx,%r8d
  800b04:	48 89 d1             	mov    %rdx,%rcx
  800b07:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0c:	48 89 c6             	mov    %rax,%rsi
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b14:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  800b1b:	00 00 00 
  800b1e:	ff d0                	callq  *%rax
  800b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b27:	79 02                	jns    800b2b <dup+0x16f>
		goto err;
  800b29:	eb 05                	jmp    800b30 <dup+0x174>

	return newfdnum;
  800b2b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b2e:	eb 33                	jmp    800b63 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b34:	48 89 c6             	mov    %rax,%rsi
  800b37:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3c:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800b43:	00 00 00 
  800b46:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b4c:	48 89 c6             	mov    %rax,%rsi
  800b4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b54:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
	return r;
  800b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b63:	c9                   	leaveq 
  800b64:	c3                   	retq   

0000000000800b65 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b65:	55                   	push   %rbp
  800b66:	48 89 e5             	mov    %rsp,%rbp
  800b69:	48 83 ec 40          	sub    $0x40,%rsp
  800b6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b74:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b7f:	48 89 d6             	mov    %rdx,%rsi
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800b8b:	00 00 00 
  800b8e:	ff d0                	callq  *%rax
  800b90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b97:	78 24                	js     800bbd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9d:	8b 00                	mov    (%rax),%eax
  800b9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ba3:	48 89 d6             	mov    %rdx,%rsi
  800ba6:	89 c7                	mov    %eax,%edi
  800ba8:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800baf:	00 00 00 
  800bb2:	ff d0                	callq  *%rax
  800bb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bbb:	79 05                	jns    800bc2 <read+0x5d>
		return r;
  800bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc0:	eb 76                	jmp    800c38 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc6:	8b 40 08             	mov    0x8(%rax),%eax
  800bc9:	83 e0 03             	and    $0x3,%eax
  800bcc:	83 f8 01             	cmp    $0x1,%eax
  800bcf:	75 3a                	jne    800c0b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bd1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800bd8:	00 00 00 
  800bdb:	48 8b 00             	mov    (%rax),%rax
  800bde:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800be4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800be7:	89 c6                	mov    %eax,%esi
  800be9:	48 bf f7 3e 80 00 00 	movabs $0x803ef7,%rdi
  800bf0:	00 00 00 
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	48 b9 12 29 80 00 00 	movabs $0x802912,%rcx
  800bff:	00 00 00 
  800c02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c09:	eb 2d                	jmp    800c38 <read+0xd3>
	}
	if (!dev->dev_read)
  800c0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c13:	48 85 c0             	test   %rax,%rax
  800c16:	75 07                	jne    800c1f <read+0xba>
		return -E_NOT_SUPP;
  800c18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c1d:	eb 19                	jmp    800c38 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c23:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c2f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c33:	48 89 cf             	mov    %rcx,%rdi
  800c36:	ff d0                	callq  *%rax
}
  800c38:	c9                   	leaveq 
  800c39:	c3                   	retq   

0000000000800c3a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c3a:	55                   	push   %rbp
  800c3b:	48 89 e5             	mov    %rsp,%rbp
  800c3e:	48 83 ec 30          	sub    $0x30,%rsp
  800c42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c54:	eb 49                	jmp    800c9f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c59:	48 98                	cltq   
  800c5b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c5f:	48 29 c2             	sub    %rax,%rdx
  800c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c65:	48 63 c8             	movslq %eax,%rcx
  800c68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c6c:	48 01 c1             	add    %rax,%rcx
  800c6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c72:	48 89 ce             	mov    %rcx,%rsi
  800c75:	89 c7                	mov    %eax,%edi
  800c77:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  800c7e:	00 00 00 
  800c81:	ff d0                	callq  *%rax
  800c83:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c86:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c8a:	79 05                	jns    800c91 <readn+0x57>
			return m;
  800c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c8f:	eb 1c                	jmp    800cad <readn+0x73>
		if (m == 0)
  800c91:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c95:	75 02                	jne    800c99 <readn+0x5f>
			break;
  800c97:	eb 11                	jmp    800caa <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c9c:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ca2:	48 98                	cltq   
  800ca4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ca8:	72 ac                	jb     800c56 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800cad:	c9                   	leaveq 
  800cae:	c3                   	retq   

0000000000800caf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800caf:	55                   	push   %rbp
  800cb0:	48 89 e5             	mov    %rsp,%rbp
  800cb3:	48 83 ec 40          	sub    $0x40,%rsp
  800cb7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cbe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cc9:	48 89 d6             	mov    %rdx,%rsi
  800ccc:	89 c7                	mov    %eax,%edi
  800cce:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800cd5:	00 00 00 
  800cd8:	ff d0                	callq  *%rax
  800cda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce1:	78 24                	js     800d07 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce7:	8b 00                	mov    (%rax),%eax
  800ce9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ced:	48 89 d6             	mov    %rdx,%rsi
  800cf0:	89 c7                	mov    %eax,%edi
  800cf2:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	callq  *%rax
  800cfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d05:	79 05                	jns    800d0c <write+0x5d>
		return r;
  800d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d0a:	eb 75                	jmp    800d81 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d10:	8b 40 08             	mov    0x8(%rax),%eax
  800d13:	83 e0 03             	and    $0x3,%eax
  800d16:	85 c0                	test   %eax,%eax
  800d18:	75 3a                	jne    800d54 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d1a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d21:	00 00 00 
  800d24:	48 8b 00             	mov    (%rax),%rax
  800d27:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d2d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d30:	89 c6                	mov    %eax,%esi
  800d32:	48 bf 13 3f 80 00 00 	movabs $0x803f13,%rdi
  800d39:	00 00 00 
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	48 b9 12 29 80 00 00 	movabs $0x802912,%rcx
  800d48:	00 00 00 
  800d4b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d52:	eb 2d                	jmp    800d81 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800d54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d58:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d5c:	48 85 c0             	test   %rax,%rax
  800d5f:	75 07                	jne    800d68 <write+0xb9>
		return -E_NOT_SUPP;
  800d61:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d66:	eb 19                	jmp    800d81 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d70:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d74:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d78:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d7c:	48 89 cf             	mov    %rcx,%rdi
  800d7f:	ff d0                	callq  *%rax
}
  800d81:	c9                   	leaveq 
  800d82:	c3                   	retq   

0000000000800d83 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d83:	55                   	push   %rbp
  800d84:	48 89 e5             	mov    %rsp,%rbp
  800d87:	48 83 ec 18          	sub    $0x18,%rsp
  800d8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d8e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d91:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d98:	48 89 d6             	mov    %rdx,%rsi
  800d9b:	89 c7                	mov    %eax,%edi
  800d9d:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800db0:	79 05                	jns    800db7 <seek+0x34>
		return r;
  800db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800db5:	eb 0f                	jmp    800dc6 <seek+0x43>
	fd->fd_offset = offset;
  800db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dbb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800dbe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 30          	sub    $0x30,%rsp
  800dd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dd6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dda:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ddd:	48 89 d6             	mov    %rdx,%rsi
  800de0:	89 c7                	mov    %eax,%edi
  800de2:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800de9:	00 00 00 
  800dec:	ff d0                	callq  *%rax
  800dee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df5:	78 24                	js     800e1b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfb:	8b 00                	mov    (%rax),%eax
  800dfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e01:	48 89 d6             	mov    %rdx,%rsi
  800e04:	89 c7                	mov    %eax,%edi
  800e06:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800e0d:	00 00 00 
  800e10:	ff d0                	callq  *%rax
  800e12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e19:	79 05                	jns    800e20 <ftruncate+0x58>
		return r;
  800e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e1e:	eb 72                	jmp    800e92 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e24:	8b 40 08             	mov    0x8(%rax),%eax
  800e27:	83 e0 03             	and    $0x3,%eax
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 3a                	jne    800e68 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e2e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800e35:	00 00 00 
  800e38:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e3b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e41:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e44:	89 c6                	mov    %eax,%esi
  800e46:	48 bf 30 3f 80 00 00 	movabs $0x803f30,%rdi
  800e4d:	00 00 00 
  800e50:	b8 00 00 00 00       	mov    $0x0,%eax
  800e55:	48 b9 12 29 80 00 00 	movabs $0x802912,%rcx
  800e5c:	00 00 00 
  800e5f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e66:	eb 2a                	jmp    800e92 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e70:	48 85 c0             	test   %rax,%rax
  800e73:	75 07                	jne    800e7c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e75:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e7a:	eb 16                	jmp    800e92 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e80:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e88:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e8b:	89 ce                	mov    %ecx,%esi
  800e8d:	48 89 d7             	mov    %rdx,%rdi
  800e90:	ff d0                	callq  *%rax
}
  800e92:	c9                   	leaveq 
  800e93:	c3                   	retq   

0000000000800e94 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e94:	55                   	push   %rbp
  800e95:	48 89 e5             	mov    %rsp,%rbp
  800e98:	48 83 ec 30          	sub    $0x30,%rsp
  800e9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ea3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ea7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800eaa:	48 89 d6             	mov    %rdx,%rsi
  800ead:	89 c7                	mov    %eax,%edi
  800eaf:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ec2:	78 24                	js     800ee8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	8b 00                	mov    (%rax),%eax
  800eca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ece:	48 89 d6             	mov    %rdx,%rsi
  800ed1:	89 c7                	mov    %eax,%edi
  800ed3:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800eda:	00 00 00 
  800edd:	ff d0                	callq  *%rax
  800edf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ee6:	79 05                	jns    800eed <fstat+0x59>
		return r;
  800ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eeb:	eb 5e                	jmp    800f4b <fstat+0xb7>
	if (!dev->dev_stat)
  800eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef1:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ef5:	48 85 c0             	test   %rax,%rax
  800ef8:	75 07                	jne    800f01 <fstat+0x6d>
		return -E_NOT_SUPP;
  800efa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eff:	eb 4a                	jmp    800f4b <fstat+0xb7>
	stat->st_name[0] = 0;
  800f01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f05:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f0c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f13:	00 00 00 
	stat->st_isdir = 0;
  800f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f1a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f21:	00 00 00 
	stat->st_dev = dev;
  800f24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f37:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f43:	48 89 ce             	mov    %rcx,%rsi
  800f46:	48 89 d7             	mov    %rdx,%rdi
  800f49:	ff d0                	callq  *%rax
}
  800f4b:	c9                   	leaveq 
  800f4c:	c3                   	retq   

0000000000800f4d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
  800f51:	48 83 ec 20          	sub    $0x20,%rsp
  800f55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f61:	be 00 00 00 00       	mov    $0x0,%esi
  800f66:	48 89 c7             	mov    %rax,%rdi
  800f69:	48 b8 3b 10 80 00 00 	movabs $0x80103b,%rax
  800f70:	00 00 00 
  800f73:	ff d0                	callq  *%rax
  800f75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f7c:	79 05                	jns    800f83 <stat+0x36>
		return fd;
  800f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f81:	eb 2f                	jmp    800fb2 <stat+0x65>
	r = fstat(fd, stat);
  800f83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f8a:	48 89 d6             	mov    %rdx,%rsi
  800f8d:	89 c7                	mov    %eax,%edi
  800f8f:	48 b8 94 0e 80 00 00 	movabs $0x800e94,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	callq  *%rax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa1:	89 c7                	mov    %eax,%edi
  800fa3:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
	return r;
  800faf:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800fb2:	c9                   	leaveq 
  800fb3:	c3                   	retq   

0000000000800fb4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fb4:	55                   	push   %rbp
  800fb5:	48 89 e5             	mov    %rsp,%rbp
  800fb8:	48 83 ec 10          	sub    $0x10,%rsp
  800fbc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fc3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fca:	00 00 00 
  800fcd:	8b 00                	mov    (%rax),%eax
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	75 1d                	jne    800ff0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fd3:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd8:	48 b8 88 3d 80 00 00 	movabs $0x803d88,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
  800fe4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800feb:	00 00 00 
  800fee:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ff0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ff7:	00 00 00 
  800ffa:	8b 00                	mov    (%rax),%eax
  800ffc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fff:	b9 07 00 00 00       	mov    $0x7,%ecx
  801004:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80100b:	00 00 00 
  80100e:	89 c7                	mov    %eax,%edi
  801010:	48 b8 26 3d 80 00 00 	movabs $0x803d26,%rax
  801017:	00 00 00 
  80101a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80101c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801020:	ba 00 00 00 00       	mov    $0x0,%edx
  801025:	48 89 c6             	mov    %rax,%rsi
  801028:	bf 00 00 00 00       	mov    $0x0,%edi
  80102d:	48 b8 20 3c 80 00 00 	movabs $0x803c20,%rax
  801034:	00 00 00 
  801037:	ff d0                	callq  *%rax
}
  801039:	c9                   	leaveq 
  80103a:	c3                   	retq   

000000000080103b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80103b:	55                   	push   %rbp
  80103c:	48 89 e5             	mov    %rsp,%rbp
  80103f:	48 83 ec 30          	sub    $0x30,%rsp
  801043:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801047:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80104a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  801051:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  801058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80105f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801064:	75 08                	jne    80106e <open+0x33>
	{
		return r;
  801066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801069:	e9 f2 00 00 00       	jmpq   801160 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80106e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801072:	48 89 c7             	mov    %rax,%rdi
  801075:	48 b8 5b 34 80 00 00 	movabs $0x80345b,%rax
  80107c:	00 00 00 
  80107f:	ff d0                	callq  *%rax
  801081:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801084:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80108b:	7e 0a                	jle    801097 <open+0x5c>
	{
		return -E_BAD_PATH;
  80108d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801092:	e9 c9 00 00 00       	jmpq   801160 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801097:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80109e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80109f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010a3:	48 89 c7             	mov    %rax,%rdi
  8010a6:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  8010ad:	00 00 00 
  8010b0:	ff d0                	callq  *%rax
  8010b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010b9:	78 09                	js     8010c4 <open+0x89>
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bf:	48 85 c0             	test   %rax,%rax
  8010c2:	75 08                	jne    8010cc <open+0x91>
		{
			return r;
  8010c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c7:	e9 94 00 00 00       	jmpq   801160 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8010cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010d0:	ba 00 04 00 00       	mov    $0x400,%edx
  8010d5:	48 89 c6             	mov    %rax,%rsi
  8010d8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010df:	00 00 00 
  8010e2:	48 b8 59 35 80 00 00 	movabs $0x803559,%rax
  8010e9:	00 00 00 
  8010ec:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8010ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010f5:	00 00 00 
  8010f8:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010fb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	48 89 c6             	mov    %rax,%rsi
  801108:	bf 01 00 00 00       	mov    $0x1,%edi
  80110d:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801114:	00 00 00 
  801117:	ff d0                	callq  *%rax
  801119:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801120:	79 2b                	jns    80114d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	be 00 00 00 00       	mov    $0x0,%esi
  80112b:	48 89 c7             	mov    %rax,%rdi
  80112e:	48 b8 c3 07 80 00 00 	movabs $0x8007c3,%rax
  801135:	00 00 00 
  801138:	ff d0                	callq  *%rax
  80113a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80113d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801141:	79 05                	jns    801148 <open+0x10d>
			{
				return d;
  801143:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801146:	eb 18                	jmp    801160 <open+0x125>
			}
			return r;
  801148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80114b:	eb 13                	jmp    801160 <open+0x125>
		}	
		return fd2num(fd_store);
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	48 89 c7             	mov    %rax,%rdi
  801154:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  80115b:	00 00 00 
  80115e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801160:	c9                   	leaveq 
  801161:	c3                   	retq   

0000000000801162 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801162:	55                   	push   %rbp
  801163:	48 89 e5             	mov    %rsp,%rbp
  801166:	48 83 ec 10          	sub    $0x10,%rsp
  80116a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80116e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801172:	8b 50 0c             	mov    0xc(%rax),%edx
  801175:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80117c:	00 00 00 
  80117f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801181:	be 00 00 00 00       	mov    $0x0,%esi
  801186:	bf 06 00 00 00       	mov    $0x6,%edi
  80118b:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801192:	00 00 00 
  801195:	ff d0                	callq  *%rax
}
  801197:	c9                   	leaveq 
  801198:	c3                   	retq   

0000000000801199 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	48 83 ec 30          	sub    $0x30,%rsp
  8011a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8011ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8011b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011b9:	74 07                	je     8011c2 <devfile_read+0x29>
  8011bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011c0:	75 07                	jne    8011c9 <devfile_read+0x30>
		return -E_INVAL;
  8011c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c7:	eb 77                	jmp    801240 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8011c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8011d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011d7:	00 00 00 
  8011da:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011e3:	00 00 00 
  8011e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011ea:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8011ee:	be 00 00 00 00       	mov    $0x0,%esi
  8011f3:	bf 03 00 00 00       	mov    $0x3,%edi
  8011f8:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8011ff:	00 00 00 
  801202:	ff d0                	callq  *%rax
  801204:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801207:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80120b:	7f 05                	jg     801212 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80120d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801210:	eb 2e                	jmp    801240 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801215:	48 63 d0             	movslq %eax,%rdx
  801218:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801223:	00 00 00 
  801226:	48 89 c7             	mov    %rax,%rdi
  801229:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801230:	00 00 00 
  801233:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801235:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801239:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80123d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801240:	c9                   	leaveq 
  801241:	c3                   	retq   

0000000000801242 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801242:	55                   	push   %rbp
  801243:	48 89 e5             	mov    %rsp,%rbp
  801246:	48 83 ec 30          	sub    $0x30,%rsp
  80124a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801252:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801256:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80125d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801262:	74 07                	je     80126b <devfile_write+0x29>
  801264:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801269:	75 08                	jne    801273 <devfile_write+0x31>
		return r;
  80126b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126e:	e9 9a 00 00 00       	jmpq   80130d <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801277:	8b 50 0c             	mov    0xc(%rax),%edx
  80127a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801281:	00 00 00 
  801284:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801286:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80128d:	00 
  80128e:	76 08                	jbe    801298 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801290:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801297:	00 
	}
	fsipcbuf.write.req_n = n;
  801298:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80129f:	00 00 00 
  8012a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012a6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8012aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b2:	48 89 c6             	mov    %rax,%rsi
  8012b5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8012bc:	00 00 00 
  8012bf:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  8012c6:	00 00 00 
  8012c9:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8012cb:	be 00 00 00 00       	mov    $0x0,%esi
  8012d0:	bf 04 00 00 00       	mov    $0x4,%edi
  8012d5:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
  8012e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e8:	7f 20                	jg     80130a <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8012ea:	48 bf 56 3f 80 00 00 	movabs $0x803f56,%rdi
  8012f1:	00 00 00 
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f9:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  801300:	00 00 00 
  801303:	ff d2                	callq  *%rdx
		return r;
  801305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801308:	eb 03                	jmp    80130d <devfile_write+0xcb>
	}
	return r;
  80130a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 20          	sub    $0x20,%rsp
  801317:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	8b 50 0c             	mov    0xc(%rax),%edx
  801326:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80132d:	00 00 00 
  801330:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801332:	be 00 00 00 00       	mov    $0x0,%esi
  801337:	bf 05 00 00 00       	mov    $0x5,%edi
  80133c:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801343:	00 00 00 
  801346:	ff d0                	callq  *%rax
  801348:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80134b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80134f:	79 05                	jns    801356 <devfile_stat+0x47>
		return r;
  801351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801354:	eb 56                	jmp    8013ac <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801361:	00 00 00 
  801364:	48 89 c7             	mov    %rax,%rdi
  801367:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  80136e:	00 00 00 
  801371:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801373:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80137a:	00 00 00 
  80137d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801383:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801387:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80138d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801394:	00 00 00 
  801397:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80139d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ac:	c9                   	leaveq 
  8013ad:	c3                   	retq   

00000000008013ae <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013ae:	55                   	push   %rbp
  8013af:	48 89 e5             	mov    %rsp,%rbp
  8013b2:	48 83 ec 10          	sub    $0x10,%rsp
  8013b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ba:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8013c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013cb:	00 00 00 
  8013ce:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8013d0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013d7:	00 00 00 
  8013da:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013dd:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013e0:	be 00 00 00 00       	mov    $0x0,%esi
  8013e5:	bf 02 00 00 00       	mov    $0x2,%edi
  8013ea:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8013f1:	00 00 00 
  8013f4:	ff d0                	callq  *%rax
}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 10          	sub    $0x10,%rsp
  801400:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801408:	48 89 c7             	mov    %rax,%rdi
  80140b:	48 b8 5b 34 80 00 00 	movabs $0x80345b,%rax
  801412:	00 00 00 
  801415:	ff d0                	callq  *%rax
  801417:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80141c:	7e 07                	jle    801425 <remove+0x2d>
		return -E_BAD_PATH;
  80141e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801423:	eb 33                	jmp    801458 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	48 89 c6             	mov    %rax,%rsi
  80142c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801433:	00 00 00 
  801436:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  80143d:	00 00 00 
  801440:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801442:	be 00 00 00 00       	mov    $0x0,%esi
  801447:	bf 07 00 00 00       	mov    $0x7,%edi
  80144c:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801453:	00 00 00 
  801456:	ff d0                	callq  *%rax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80145e:	be 00 00 00 00       	mov    $0x0,%esi
  801463:	bf 08 00 00 00       	mov    $0x8,%edi
  801468:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  80146f:	00 00 00 
  801472:	ff d0                	callq  *%rax
}
  801474:	5d                   	pop    %rbp
  801475:	c3                   	retq   

0000000000801476 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801481:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801488:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80148f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801496:	be 00 00 00 00       	mov    $0x0,%esi
  80149b:	48 89 c7             	mov    %rax,%rdi
  80149e:	48 b8 3b 10 80 00 00 	movabs $0x80103b,%rax
  8014a5:	00 00 00 
  8014a8:	ff d0                	callq  *%rax
  8014aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8014ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b1:	79 28                	jns    8014db <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8014b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014b6:	89 c6                	mov    %eax,%esi
  8014b8:	48 bf 72 3f 80 00 00 	movabs $0x803f72,%rdi
  8014bf:	00 00 00 
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  8014ce:	00 00 00 
  8014d1:	ff d2                	callq  *%rdx
		return fd_src;
  8014d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d6:	e9 74 01 00 00       	jmpq   80164f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8014db:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014e2:	be 01 01 00 00       	mov    $0x101,%esi
  8014e7:	48 89 c7             	mov    %rax,%rdi
  8014ea:	48 b8 3b 10 80 00 00 	movabs $0x80103b,%rax
  8014f1:	00 00 00 
  8014f4:	ff d0                	callq  *%rax
  8014f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014f9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014fd:	79 39                	jns    801538 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801502:	89 c6                	mov    %eax,%esi
  801504:	48 bf 88 3f 80 00 00 	movabs $0x803f88,%rdi
  80150b:	00 00 00 
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  80151a:	00 00 00 
  80151d:	ff d2                	callq  *%rdx
		close(fd_src);
  80151f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801522:	89 c7                	mov    %eax,%edi
  801524:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  80152b:	00 00 00 
  80152e:	ff d0                	callq  *%rax
		return fd_dest;
  801530:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801533:	e9 17 01 00 00       	jmpq   80164f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801538:	eb 74                	jmp    8015ae <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	48 63 d0             	movslq %eax,%rdx
  801540:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801547:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80154a:	48 89 ce             	mov    %rcx,%rsi
  80154d:	89 c7                	mov    %eax,%edi
  80154f:	48 b8 af 0c 80 00 00 	movabs $0x800caf,%rax
  801556:	00 00 00 
  801559:	ff d0                	callq  *%rax
  80155b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80155e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801562:	79 4a                	jns    8015ae <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801564:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801567:	89 c6                	mov    %eax,%esi
  801569:	48 bf a2 3f 80 00 00 	movabs $0x803fa2,%rdi
  801570:	00 00 00 
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  80157f:	00 00 00 
  801582:	ff d2                	callq  *%rdx
			close(fd_src);
  801584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801587:	89 c7                	mov    %eax,%edi
  801589:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  801590:	00 00 00 
  801593:	ff d0                	callq  *%rax
			close(fd_dest);
  801595:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801598:	89 c7                	mov    %eax,%edi
  80159a:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  8015a1:	00 00 00 
  8015a4:	ff d0                	callq  *%rax
			return write_size;
  8015a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015a9:	e9 a1 00 00 00       	jmpq   80164f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8015ae:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8015b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015b8:	ba 00 02 00 00       	mov    $0x200,%edx
  8015bd:	48 89 ce             	mov    %rcx,%rsi
  8015c0:	89 c7                	mov    %eax,%edi
  8015c2:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	callq  *%rax
  8015ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8015d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015d5:	0f 8f 5f ff ff ff    	jg     80153a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8015db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015df:	79 47                	jns    801628 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e4:	89 c6                	mov    %eax,%esi
  8015e6:	48 bf b5 3f 80 00 00 	movabs $0x803fb5,%rdi
  8015ed:	00 00 00 
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f5:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  8015fc:	00 00 00 
  8015ff:	ff d2                	callq  *%rdx
		close(fd_src);
  801601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801604:	89 c7                	mov    %eax,%edi
  801606:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  80160d:	00 00 00 
  801610:	ff d0                	callq  *%rax
		close(fd_dest);
  801612:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801615:	89 c7                	mov    %eax,%edi
  801617:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  80161e:	00 00 00 
  801621:	ff d0                	callq  *%rax
		return read_size;
  801623:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801626:	eb 27                	jmp    80164f <copy+0x1d9>
	}
	close(fd_src);
  801628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80162b:	89 c7                	mov    %eax,%edi
  80162d:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  801634:	00 00 00 
  801637:	ff d0                	callq  *%rax
	close(fd_dest);
  801639:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80163c:	89 c7                	mov    %eax,%edi
  80163e:	48 b8 43 09 80 00 00 	movabs $0x800943,%rax
  801645:	00 00 00 
  801648:	ff d0                	callq  *%rax
	return 0;
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80164f:	c9                   	leaveq 
  801650:	c3                   	retq   

0000000000801651 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801651:	55                   	push   %rbp
  801652:	48 89 e5             	mov    %rsp,%rbp
  801655:	48 83 ec 20          	sub    $0x20,%rsp
  801659:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80165c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801660:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801663:	48 89 d6             	mov    %rdx,%rsi
  801666:	89 c7                	mov    %eax,%edi
  801668:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  80166f:	00 00 00 
  801672:	ff d0                	callq  *%rax
  801674:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801677:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167b:	79 05                	jns    801682 <fd2sockid+0x31>
		return r;
  80167d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801680:	eb 24                	jmp    8016a6 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801686:	8b 10                	mov    (%rax),%edx
  801688:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80168f:	00 00 00 
  801692:	8b 00                	mov    (%rax),%eax
  801694:	39 c2                	cmp    %eax,%edx
  801696:	74 07                	je     80169f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801698:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80169d:	eb 07                	jmp    8016a6 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80169f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a3:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8016a6:	c9                   	leaveq 
  8016a7:	c3                   	retq   

00000000008016a8 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8016a8:	55                   	push   %rbp
  8016a9:	48 89 e5             	mov    %rsp,%rbp
  8016ac:	48 83 ec 20          	sub    $0x20,%rsp
  8016b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8016b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8016b7:	48 89 c7             	mov    %rax,%rdi
  8016ba:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  8016c1:	00 00 00 
  8016c4:	ff d0                	callq  *%rax
  8016c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016cd:	78 26                	js     8016f5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	ba 07 04 00 00       	mov    $0x407,%edx
  8016d8:	48 89 c6             	mov    %rax,%rsi
  8016db:	bf 00 00 00 00       	mov    $0x0,%edi
  8016e0:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  8016e7:	00 00 00 
  8016ea:	ff d0                	callq  *%rax
  8016ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f3:	79 16                	jns    80170b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8016f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f8:	89 c7                	mov    %eax,%edi
  8016fa:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  801701:	00 00 00 
  801704:	ff d0                	callq  *%rax
		return r;
  801706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801709:	eb 3a                	jmp    801745 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80170b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170f:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801716:	00 00 00 
  801719:	8b 12                	mov    (%rdx),%edx
  80171b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80171d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801721:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80172f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801736:	48 89 c7             	mov    %rax,%rdi
  801739:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  801740:	00 00 00 
  801743:	ff d0                	callq  *%rax
}
  801745:	c9                   	leaveq 
  801746:	c3                   	retq   

0000000000801747 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801747:	55                   	push   %rbp
  801748:	48 89 e5             	mov    %rsp,%rbp
  80174b:	48 83 ec 30          	sub    $0x30,%rsp
  80174f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801752:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80175a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80175d:	89 c7                	mov    %eax,%edi
  80175f:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  801766:	00 00 00 
  801769:	ff d0                	callq  *%rax
  80176b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801772:	79 05                	jns    801779 <accept+0x32>
		return r;
  801774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801777:	eb 3b                	jmp    8017b4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801779:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80177d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801784:	48 89 ce             	mov    %rcx,%rsi
  801787:	89 c7                	mov    %eax,%edi
  801789:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  801790:	00 00 00 
  801793:	ff d0                	callq  *%rax
  801795:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801798:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80179c:	79 05                	jns    8017a3 <accept+0x5c>
		return r;
  80179e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a1:	eb 11                	jmp    8017b4 <accept+0x6d>
	return alloc_sockfd(r);
  8017a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a6:	89 c7                	mov    %eax,%edi
  8017a8:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8017af:	00 00 00 
  8017b2:	ff d0                	callq  *%rax
}
  8017b4:	c9                   	leaveq 
  8017b5:	c3                   	retq   

00000000008017b6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8017b6:	55                   	push   %rbp
  8017b7:	48 89 e5             	mov    %rsp,%rbp
  8017ba:	48 83 ec 20          	sub    $0x20,%rsp
  8017be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017cb:	89 c7                	mov    %eax,%edi
  8017cd:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	callq  *%rax
  8017d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e0:	79 05                	jns    8017e7 <bind+0x31>
		return r;
  8017e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e5:	eb 1b                	jmp    801802 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8017e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8017ea:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f1:	48 89 ce             	mov    %rcx,%rsi
  8017f4:	89 c7                	mov    %eax,%edi
  8017f6:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <shutdown>:

int
shutdown(int s, int how)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 20          	sub    $0x20,%rsp
  80180c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80180f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801812:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801815:	89 c7                	mov    %eax,%edi
  801817:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
  801823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80182a:	79 05                	jns    801831 <shutdown+0x2d>
		return r;
  80182c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182f:	eb 16                	jmp    801847 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801831:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801834:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801837:	89 d6                	mov    %edx,%esi
  801839:	89 c7                	mov    %eax,%edi
  80183b:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  801842:	00 00 00 
  801845:	ff d0                	callq  *%rax
}
  801847:	c9                   	leaveq 
  801848:	c3                   	retq   

0000000000801849 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801849:	55                   	push   %rbp
  80184a:	48 89 e5             	mov    %rsp,%rbp
  80184d:	48 83 ec 10          	sub    $0x10,%rsp
  801851:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801859:	48 89 c7             	mov    %rax,%rdi
  80185c:	48 b8 0a 3e 80 00 00 	movabs $0x803e0a,%rax
  801863:	00 00 00 
  801866:	ff d0                	callq  *%rax
  801868:	83 f8 01             	cmp    $0x1,%eax
  80186b:	75 17                	jne    801884 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80186d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801871:	8b 40 0c             	mov    0xc(%rax),%eax
  801874:	89 c7                	mov    %eax,%edi
  801876:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
  801882:	eb 05                	jmp    801889 <devsock_close+0x40>
	else
		return 0;
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 20          	sub    $0x20,%rsp
  801893:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801896:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80189a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80189d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018a0:	89 c7                	mov    %eax,%edi
  8018a2:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  8018a9:	00 00 00 
  8018ac:	ff d0                	callq  *%rax
  8018ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018b5:	79 05                	jns    8018bc <connect+0x31>
		return r;
  8018b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ba:	eb 1b                	jmp    8018d7 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8018bc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018bf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8018c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c6:	48 89 ce             	mov    %rcx,%rsi
  8018c9:	89 c7                	mov    %eax,%edi
  8018cb:	48 b8 e2 1b 80 00 00 	movabs $0x801be2,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	callq  *%rax
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <listen>:

int
listen(int s, int backlog)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 83 ec 20          	sub    $0x20,%rsp
  8018e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018e4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018ea:	89 c7                	mov    %eax,%edi
  8018ec:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018ff:	79 05                	jns    801906 <listen+0x2d>
		return r;
  801901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801904:	eb 16                	jmp    80191c <listen+0x43>
	return nsipc_listen(r, backlog);
  801906:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190c:	89 d6                	mov    %edx,%esi
  80190e:	89 c7                	mov    %eax,%edi
  801910:	48 b8 46 1c 80 00 00 	movabs $0x801c46,%rax
  801917:	00 00 00 
  80191a:	ff d0                	callq  *%rax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 20          	sub    $0x20,%rsp
  801926:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80192a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80192e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801936:	89 c2                	mov    %eax,%edx
  801938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193c:	8b 40 0c             	mov    0xc(%rax),%eax
  80193f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801943:	b9 00 00 00 00       	mov    $0x0,%ecx
  801948:	89 c7                	mov    %eax,%edi
  80194a:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 20          	sub    $0x20,%rsp
  801960:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801964:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801968:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80196c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801970:	89 c2                	mov    %eax,%edx
  801972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801976:	8b 40 0c             	mov    0xc(%rax),%eax
  801979:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80197d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801982:	89 c7                	mov    %eax,%edi
  801984:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80198b:	00 00 00 
  80198e:	ff d0                	callq  *%rax
}
  801990:	c9                   	leaveq 
  801991:	c3                   	retq   

0000000000801992 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801992:	55                   	push   %rbp
  801993:	48 89 e5             	mov    %rsp,%rbp
  801996:	48 83 ec 10          	sub    $0x10,%rsp
  80199a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80199e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8019a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a6:	48 be d0 3f 80 00 00 	movabs $0x803fd0,%rsi
  8019ad:	00 00 00 
  8019b0:	48 89 c7             	mov    %rax,%rdi
  8019b3:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
	return 0;
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c4:	c9                   	leaveq 
  8019c5:	c3                   	retq   

00000000008019c6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	48 83 ec 20          	sub    $0x20,%rsp
  8019ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019d1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8019d4:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019d7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8019da:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8019dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019e0:	89 ce                	mov    %ecx,%esi
  8019e2:	89 c7                	mov    %eax,%edi
  8019e4:	48 b8 0a 1e 80 00 00 	movabs $0x801e0a,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	callq  *%rax
  8019f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f7:	79 05                	jns    8019fe <socket+0x38>
		return r;
  8019f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fc:	eb 11                	jmp    801a0f <socket+0x49>
	return alloc_sockfd(r);
  8019fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a01:	89 c7                	mov    %eax,%edi
  801a03:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  801a0a:	00 00 00 
  801a0d:	ff d0                	callq  *%rax
}
  801a0f:	c9                   	leaveq 
  801a10:	c3                   	retq   

0000000000801a11 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a11:	55                   	push   %rbp
  801a12:	48 89 e5             	mov    %rsp,%rbp
  801a15:	48 83 ec 10          	sub    $0x10,%rsp
  801a19:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a1c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a23:	00 00 00 
  801a26:	8b 00                	mov    (%rax),%eax
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	75 1d                	jne    801a49 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a2c:	bf 02 00 00 00       	mov    $0x2,%edi
  801a31:	48 b8 88 3d 80 00 00 	movabs $0x803d88,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	callq  *%rax
  801a3d:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801a44:	00 00 00 
  801a47:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a49:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a50:	00 00 00 
  801a53:	8b 00                	mov    (%rax),%eax
  801a55:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a58:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a5d:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801a64:	00 00 00 
  801a67:	89 c7                	mov    %eax,%edi
  801a69:	48 b8 26 3d 80 00 00 	movabs $0x803d26,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801a75:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7a:	be 00 00 00 00       	mov    $0x0,%esi
  801a7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801a84:	48 b8 20 3c 80 00 00 	movabs $0x803c20,%rax
  801a8b:	00 00 00 
  801a8e:	ff d0                	callq  *%rax
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 30          	sub    $0x30,%rsp
  801a9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801aa1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801aa5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801aac:	00 00 00 
  801aaf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ab2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab4:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab9:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801ac0:	00 00 00 
  801ac3:	ff d0                	callq  *%rax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801acc:	78 3e                	js     801b0c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801ace:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ad5:	00 00 00 
  801ad8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae0:	8b 40 10             	mov    0x10(%rax),%eax
  801ae3:	89 c2                	mov    %eax,%edx
  801ae5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ae9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aed:	48 89 ce             	mov    %rcx,%rsi
  801af0:	48 89 c7             	mov    %rax,%rdi
  801af3:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801aff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b03:	8b 50 10             	mov    0x10(%rax),%edx
  801b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 10          	sub    $0x10,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b20:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b23:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b2a:	00 00 00 
  801b2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b30:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b32:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b39:	48 89 c6             	mov    %rax,%rsi
  801b3c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801b43:	00 00 00 
  801b46:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801b52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b59:	00 00 00 
  801b5c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b5f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801b62:	bf 02 00 00 00       	mov    $0x2,%edi
  801b67:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	callq  *%rax
}
  801b73:	c9                   	leaveq 
  801b74:	c3                   	retq   

0000000000801b75 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b75:	55                   	push   %rbp
  801b76:	48 89 e5             	mov    %rsp,%rbp
  801b79:	48 83 ec 10          	sub    $0x10,%rsp
  801b7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b80:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801b83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b8a:	00 00 00 
  801b8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b90:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801b92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b99:	00 00 00 
  801b9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b9f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801ba2:	bf 03 00 00 00       	mov    $0x3,%edi
  801ba7:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	callq  *%rax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <nsipc_close>:

int
nsipc_close(int s)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 10          	sub    $0x10,%rsp
  801bbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801bc0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bc7:	00 00 00 
  801bca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bcd:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801bcf:	bf 04 00 00 00       	mov    $0x4,%edi
  801bd4:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801bdb:	00 00 00 
  801bde:	ff d0                	callq  *%rax
}
  801be0:	c9                   	leaveq 
  801be1:	c3                   	retq   

0000000000801be2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801be2:	55                   	push   %rbp
  801be3:	48 89 e5             	mov    %rsp,%rbp
  801be6:	48 83 ec 10          	sub    $0x10,%rsp
  801bea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801bf4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bfb:	00 00 00 
  801bfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c01:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c03:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c0a:	48 89 c6             	mov    %rax,%rsi
  801c0d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801c14:	00 00 00 
  801c17:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c23:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c2a:	00 00 00 
  801c2d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c30:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801c33:	bf 05 00 00 00       	mov    $0x5,%edi
  801c38:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	48 83 ec 10          	sub    $0x10,%rsp
  801c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c51:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801c54:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c5b:	00 00 00 
  801c5e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c61:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801c63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c6a:	00 00 00 
  801c6d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c70:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801c73:	bf 06 00 00 00       	mov    $0x6,%edi
  801c78:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
}
  801c84:	c9                   	leaveq 
  801c85:	c3                   	retq   

0000000000801c86 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c86:	55                   	push   %rbp
  801c87:	48 89 e5             	mov    %rsp,%rbp
  801c8a:	48 83 ec 30          	sub    $0x30,%rsp
  801c8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c95:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801c98:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801c9b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ca2:	00 00 00 
  801ca5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ca8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801caa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cb1:	00 00 00 
  801cb4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801cb7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801cba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cc1:	00 00 00 
  801cc4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cc7:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cca:	bf 07 00 00 00       	mov    $0x7,%edi
  801ccf:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce2:	78 69                	js     801d4d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801ce4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801ceb:	7f 08                	jg     801cf5 <nsipc_recv+0x6f>
  801ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801cf3:	7e 35                	jle    801d2a <nsipc_recv+0xa4>
  801cf5:	48 b9 d7 3f 80 00 00 	movabs $0x803fd7,%rcx
  801cfc:	00 00 00 
  801cff:	48 ba ec 3f 80 00 00 	movabs $0x803fec,%rdx
  801d06:	00 00 00 
  801d09:	be 61 00 00 00       	mov    $0x61,%esi
  801d0e:	48 bf 01 40 80 00 00 	movabs $0x804001,%rdi
  801d15:	00 00 00 
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	49 b8 d9 26 80 00 00 	movabs $0x8026d9,%r8
  801d24:	00 00 00 
  801d27:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2d:	48 63 d0             	movslq %eax,%rdx
  801d30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d34:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801d3b:	00 00 00 
  801d3e:	48 89 c7             	mov    %rax,%rdi
  801d41:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
	}

	return r;
  801d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d50:	c9                   	leaveq 
  801d51:	c3                   	retq   

0000000000801d52 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	48 83 ec 20          	sub    $0x20,%rsp
  801d5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d61:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d64:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801d67:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d6e:	00 00 00 
  801d71:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d74:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801d76:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801d7d:	7e 35                	jle    801db4 <nsipc_send+0x62>
  801d7f:	48 b9 0d 40 80 00 00 	movabs $0x80400d,%rcx
  801d86:	00 00 00 
  801d89:	48 ba ec 3f 80 00 00 	movabs $0x803fec,%rdx
  801d90:	00 00 00 
  801d93:	be 6c 00 00 00       	mov    $0x6c,%esi
  801d98:	48 bf 01 40 80 00 00 	movabs $0x804001,%rdi
  801d9f:	00 00 00 
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	49 b8 d9 26 80 00 00 	movabs $0x8026d9,%r8
  801dae:	00 00 00 
  801db1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db7:	48 63 d0             	movslq %eax,%rdx
  801dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbe:	48 89 c6             	mov    %rax,%rsi
  801dc1:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801dc8:	00 00 00 
  801dcb:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801dd7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dde:	00 00 00 
  801de1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801de4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801de7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dee:	00 00 00 
  801df1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801df4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801df7:	bf 08 00 00 00       	mov    $0x8,%edi
  801dfc:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
}
  801e08:	c9                   	leaveq 
  801e09:	c3                   	retq   

0000000000801e0a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e0a:	55                   	push   %rbp
  801e0b:	48 89 e5             	mov    %rsp,%rbp
  801e0e:	48 83 ec 10          	sub    $0x10,%rsp
  801e12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e15:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801e18:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e1b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e22:	00 00 00 
  801e25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e28:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e31:	00 00 00 
  801e34:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e37:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801e3a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e41:	00 00 00 
  801e44:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e47:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801e4a:	bf 09 00 00 00       	mov    $0x9,%edi
  801e4f:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
}
  801e5b:	c9                   	leaveq 
  801e5c:	c3                   	retq   

0000000000801e5d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e5d:	55                   	push   %rbp
  801e5e:	48 89 e5             	mov    %rsp,%rbp
  801e61:	53                   	push   %rbx
  801e62:	48 83 ec 38          	sub    $0x38,%rsp
  801e66:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e6a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801e6e:	48 89 c7             	mov    %rax,%rdi
  801e71:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e80:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e84:	0f 88 bf 01 00 00    	js     802049 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8e:	ba 07 04 00 00       	mov    $0x407,%edx
  801e93:	48 89 c6             	mov    %rax,%rsi
  801e96:	bf 00 00 00 00       	mov    $0x0,%edi
  801e9b:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
  801ea7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eaa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eae:	0f 88 95 01 00 00    	js     802049 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801eb4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801eb8:	48 89 c7             	mov    %rax,%rdi
  801ebb:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  801ec2:	00 00 00 
  801ec5:	ff d0                	callq  *%rax
  801ec7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ece:	0f 88 5d 01 00 00    	js     802031 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed8:	ba 07 04 00 00       	mov    $0x407,%edx
  801edd:	48 89 c6             	mov    %rax,%rsi
  801ee0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee5:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801eec:	00 00 00 
  801eef:	ff d0                	callq  *%rax
  801ef1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef8:	0f 88 33 01 00 00    	js     802031 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f02:	48 89 c7             	mov    %rax,%rdi
  801f05:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
  801f11:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f19:	ba 07 04 00 00       	mov    $0x407,%edx
  801f1e:	48 89 c6             	mov    %rax,%rsi
  801f21:	bf 00 00 00 00       	mov    $0x0,%edi
  801f26:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
  801f32:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f39:	79 05                	jns    801f40 <pipe+0xe3>
		goto err2;
  801f3b:	e9 d9 00 00 00       	jmpq   802019 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f44:	48 89 c7             	mov    %rax,%rdi
  801f47:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax
  801f53:	48 89 c2             	mov    %rax,%rdx
  801f56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f5a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f60:	48 89 d1             	mov    %rdx,%rcx
  801f63:	ba 00 00 00 00       	mov    $0x0,%edx
  801f68:	48 89 c6             	mov    %rax,%rsi
  801f6b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f70:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	callq  *%rax
  801f7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f83:	79 1b                	jns    801fa0 <pipe+0x143>
		goto err3;
  801f85:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801f86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f8a:	48 89 c6             	mov    %rax,%rsi
  801f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f92:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  801f99:	00 00 00 
  801f9c:	ff d0                	callq  *%rax
  801f9e:	eb 79                	jmp    802019 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801fab:	00 00 00 
  801fae:	8b 12                	mov    (%rdx),%edx
  801fb0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801fb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fbd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801fc8:	00 00 00 
  801fcb:	8b 12                	mov    (%rdx),%edx
  801fcd:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801fcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fd3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fde:	48 89 c7             	mov    %rax,%rdi
  801fe1:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  801fe8:	00 00 00 
  801feb:	ff d0                	callq  *%rax
  801fed:	89 c2                	mov    %eax,%edx
  801fef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ff3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801ff5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ff9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801ffd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802001:	48 89 c7             	mov    %rax,%rdi
  802004:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  80200b:	00 00 00 
  80200e:	ff d0                	callq  *%rax
  802010:	89 03                	mov    %eax,(%rbx)
	return 0;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	eb 33                	jmp    80204c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802019:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80201d:	48 89 c6             	mov    %rax,%rsi
  802020:	bf 00 00 00 00       	mov    $0x0,%edi
  802025:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802035:	48 89 c6             	mov    %rax,%rsi
  802038:	bf 00 00 00 00       	mov    $0x0,%edi
  80203d:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  802044:	00 00 00 
  802047:	ff d0                	callq  *%rax
err:
	return r;
  802049:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80204c:	48 83 c4 38          	add    $0x38,%rsp
  802050:	5b                   	pop    %rbx
  802051:	5d                   	pop    %rbp
  802052:	c3                   	retq   

0000000000802053 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802053:	55                   	push   %rbp
  802054:	48 89 e5             	mov    %rsp,%rbp
  802057:	53                   	push   %rbx
  802058:	48 83 ec 28          	sub    $0x28,%rsp
  80205c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802060:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802064:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80206b:	00 00 00 
  80206e:	48 8b 00             	mov    (%rax),%rax
  802071:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802077:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80207a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207e:	48 89 c7             	mov    %rax,%rdi
  802081:	48 b8 0a 3e 80 00 00 	movabs $0x803e0a,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	89 c3                	mov    %eax,%ebx
  80208f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802093:	48 89 c7             	mov    %rax,%rdi
  802096:	48 b8 0a 3e 80 00 00 	movabs $0x803e0a,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
  8020a2:	39 c3                	cmp    %eax,%ebx
  8020a4:	0f 94 c0             	sete   %al
  8020a7:	0f b6 c0             	movzbl %al,%eax
  8020aa:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8020ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020b4:	00 00 00 
  8020b7:	48 8b 00             	mov    (%rax),%rax
  8020ba:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020c0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020c9:	75 05                	jne    8020d0 <_pipeisclosed+0x7d>
			return ret;
  8020cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020ce:	eb 4f                	jmp    80211f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8020d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020d3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020d6:	74 42                	je     80211a <_pipeisclosed+0xc7>
  8020d8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8020dc:	75 3c                	jne    80211a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020e5:	00 00 00 
  8020e8:	48 8b 00             	mov    (%rax),%rax
  8020eb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8020f1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8020f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f7:	89 c6                	mov    %eax,%esi
  8020f9:	48 bf 1e 40 80 00 00 	movabs $0x80401e,%rdi
  802100:	00 00 00 
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	49 b8 12 29 80 00 00 	movabs $0x802912,%r8
  80210f:	00 00 00 
  802112:	41 ff d0             	callq  *%r8
	}
  802115:	e9 4a ff ff ff       	jmpq   802064 <_pipeisclosed+0x11>
  80211a:	e9 45 ff ff ff       	jmpq   802064 <_pipeisclosed+0x11>
}
  80211f:	48 83 c4 28          	add    $0x28,%rsp
  802123:	5b                   	pop    %rbx
  802124:	5d                   	pop    %rbp
  802125:	c3                   	retq   

0000000000802126 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 30          	sub    $0x30,%rsp
  80212e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802131:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802135:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802138:	48 89 d6             	mov    %rdx,%rsi
  80213b:	89 c7                	mov    %eax,%edi
  80213d:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  802149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80214c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802150:	79 05                	jns    802157 <pipeisclosed+0x31>
		return r;
  802152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802155:	eb 31                	jmp    802188 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215b:	48 89 c7             	mov    %rax,%rdi
  80215e:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
  80216a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802176:	48 89 d6             	mov    %rdx,%rsi
  802179:	48 89 c7             	mov    %rax,%rdi
  80217c:	48 b8 53 20 80 00 00 	movabs $0x802053,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
}
  802188:	c9                   	leaveq 
  802189:	c3                   	retq   

000000000080218a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80218a:	55                   	push   %rbp
  80218b:	48 89 e5             	mov    %rsp,%rbp
  80218e:	48 83 ec 40          	sub    $0x40,%rsp
  802192:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802196:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80219a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80219e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a2:	48 89 c7             	mov    %rax,%rdi
  8021a5:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8021b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021bd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021c4:	00 
  8021c5:	e9 92 00 00 00       	jmpq   80225c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021ca:	eb 41                	jmp    80220d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021cc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8021d1:	74 09                	je     8021dc <devpipe_read+0x52>
				return i;
  8021d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d7:	e9 92 00 00 00       	jmpq   80226e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e4:	48 89 d6             	mov    %rdx,%rsi
  8021e7:	48 89 c7             	mov    %rax,%rdi
  8021ea:	48 b8 53 20 80 00 00 	movabs $0x802053,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	74 07                	je     802201 <devpipe_read+0x77>
				return 0;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ff:	eb 6d                	jmp    80226e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802201:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80220d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802211:	8b 10                	mov    (%rax),%edx
  802213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802217:	8b 40 04             	mov    0x4(%rax),%eax
  80221a:	39 c2                	cmp    %eax,%edx
  80221c:	74 ae                	je     8021cc <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80221e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802222:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802226:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80222a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222e:	8b 00                	mov    (%rax),%eax
  802230:	99                   	cltd   
  802231:	c1 ea 1b             	shr    $0x1b,%edx
  802234:	01 d0                	add    %edx,%eax
  802236:	83 e0 1f             	and    $0x1f,%eax
  802239:	29 d0                	sub    %edx,%eax
  80223b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223f:	48 98                	cltq   
  802241:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802246:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224c:	8b 00                	mov    (%rax),%eax
  80224e:	8d 50 01             	lea    0x1(%rax),%edx
  802251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802255:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802257:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80225c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802260:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802264:	0f 82 60 ff ff ff    	jb     8021ca <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80226a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80226e:	c9                   	leaveq 
  80226f:	c3                   	retq   

0000000000802270 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802270:	55                   	push   %rbp
  802271:	48 89 e5             	mov    %rsp,%rbp
  802274:	48 83 ec 40          	sub    $0x40,%rsp
  802278:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80227c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802280:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802288:	48 89 c7             	mov    %rax,%rdi
  80228b:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax
  802297:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80229b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80229f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8022a3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022aa:	00 
  8022ab:	e9 8e 00 00 00       	jmpq   80233e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022b0:	eb 31                	jmp    8022e3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ba:	48 89 d6             	mov    %rdx,%rsi
  8022bd:	48 89 c7             	mov    %rax,%rdi
  8022c0:	48 b8 53 20 80 00 00 	movabs $0x802053,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	callq  *%rax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 07                	je     8022d7 <devpipe_write+0x67>
				return 0;
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d5:	eb 79                	jmp    802350 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022d7:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e7:	8b 40 04             	mov    0x4(%rax),%eax
  8022ea:	48 63 d0             	movslq %eax,%rdx
  8022ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f1:	8b 00                	mov    (%rax),%eax
  8022f3:	48 98                	cltq   
  8022f5:	48 83 c0 20          	add    $0x20,%rax
  8022f9:	48 39 c2             	cmp    %rax,%rdx
  8022fc:	73 b4                	jae    8022b2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802302:	8b 40 04             	mov    0x4(%rax),%eax
  802305:	99                   	cltd   
  802306:	c1 ea 1b             	shr    $0x1b,%edx
  802309:	01 d0                	add    %edx,%eax
  80230b:	83 e0 1f             	and    $0x1f,%eax
  80230e:	29 d0                	sub    %edx,%eax
  802310:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802314:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802318:	48 01 ca             	add    %rcx,%rdx
  80231b:	0f b6 0a             	movzbl (%rdx),%ecx
  80231e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802322:	48 98                	cltq   
  802324:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232c:	8b 40 04             	mov    0x4(%rax),%eax
  80232f:	8d 50 01             	lea    0x1(%rax),%edx
  802332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802336:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802339:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80233e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802342:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802346:	0f 82 64 ff ff ff    	jb     8022b0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80234c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802350:	c9                   	leaveq 
  802351:	c3                   	retq   

0000000000802352 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802352:	55                   	push   %rbp
  802353:	48 89 e5             	mov    %rsp,%rbp
  802356:	48 83 ec 20          	sub    $0x20,%rsp
  80235a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80235e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802366:	48 89 c7             	mov    %rax,%rdi
  802369:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax
  802375:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802379:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237d:	48 be 31 40 80 00 00 	movabs $0x804031,%rsi
  802384:	00 00 00 
  802387:	48 89 c7             	mov    %rax,%rdi
  80238a:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  802391:	00 00 00 
  802394:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239a:	8b 50 04             	mov    0x4(%rax),%edx
  80239d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a1:	8b 00                	mov    (%rax),%eax
  8023a3:	29 c2                	sub    %eax,%edx
  8023a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8023af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023ba:	00 00 00 
	stat->st_dev = &devpipe;
  8023bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c1:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8023c8:	00 00 00 
  8023cb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d7:	c9                   	leaveq 
  8023d8:	c3                   	retq   

00000000008023d9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023d9:	55                   	push   %rbp
  8023da:	48 89 e5             	mov    %rsp,%rbp
  8023dd:	48 83 ec 10          	sub    $0x10,%rsp
  8023e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8023e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e9:	48 89 c6             	mov    %rax,%rsi
  8023ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f1:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8023fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802401:	48 89 c7             	mov    %rax,%rdi
  802404:	48 b8 70 06 80 00 00 	movabs $0x800670,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	48 89 c6             	mov    %rax,%rsi
  802413:	bf 00 00 00 00       	mov    $0x0,%edi
  802418:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
}
  802424:	c9                   	leaveq 
  802425:	c3                   	retq   

0000000000802426 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802426:	55                   	push   %rbp
  802427:	48 89 e5             	mov    %rsp,%rbp
  80242a:	48 83 ec 20          	sub    $0x20,%rsp
  80242e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802431:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802434:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802437:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80243b:	be 01 00 00 00       	mov    $0x1,%esi
  802440:	48 89 c7             	mov    %rax,%rdi
  802443:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
}
  80244f:	c9                   	leaveq 
  802450:	c3                   	retq   

0000000000802451 <getchar>:

int
getchar(void)
{
  802451:	55                   	push   %rbp
  802452:	48 89 e5             	mov    %rsp,%rbp
  802455:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802459:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80245d:	ba 01 00 00 00       	mov    $0x1,%edx
  802462:	48 89 c6             	mov    %rax,%rsi
  802465:	bf 00 00 00 00       	mov    $0x0,%edi
  80246a:	48 b8 65 0b 80 00 00 	movabs $0x800b65,%rax
  802471:	00 00 00 
  802474:	ff d0                	callq  *%rax
  802476:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247d:	79 05                	jns    802484 <getchar+0x33>
		return r;
  80247f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802482:	eb 14                	jmp    802498 <getchar+0x47>
	if (r < 1)
  802484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802488:	7f 07                	jg     802491 <getchar+0x40>
		return -E_EOF;
  80248a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80248f:	eb 07                	jmp    802498 <getchar+0x47>
	return c;
  802491:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802495:	0f b6 c0             	movzbl %al,%eax
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	48 83 ec 20          	sub    $0x20,%rsp
  8024a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ac:	48 89 d6             	mov    %rdx,%rsi
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax
  8024bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c4:	79 05                	jns    8024cb <iscons+0x31>
		return r;
  8024c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c9:	eb 1a                	jmp    8024e5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8024cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cf:	8b 10                	mov    (%rax),%edx
  8024d1:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8024d8:	00 00 00 
  8024db:	8b 00                	mov    (%rax),%eax
  8024dd:	39 c2                	cmp    %eax,%edx
  8024df:	0f 94 c0             	sete   %al
  8024e2:	0f b6 c0             	movzbl %al,%eax
}
  8024e5:	c9                   	leaveq 
  8024e6:	c3                   	retq   

00000000008024e7 <opencons>:

int
opencons(void)
{
  8024e7:	55                   	push   %rbp
  8024e8:	48 89 e5             	mov    %rsp,%rbp
  8024eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024ef:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024f3:	48 89 c7             	mov    %rax,%rdi
  8024f6:	48 b8 9b 06 80 00 00 	movabs $0x80069b,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802505:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802509:	79 05                	jns    802510 <opencons+0x29>
		return r;
  80250b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250e:	eb 5b                	jmp    80256b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802514:	ba 07 04 00 00       	mov    $0x407,%edx
  802519:	48 89 c6             	mov    %rax,%rsi
  80251c:	bf 00 00 00 00       	mov    $0x0,%edi
  802521:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
  80252d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802534:	79 05                	jns    80253b <opencons+0x54>
		return r;
  802536:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802539:	eb 30                	jmp    80256b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80253b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253f:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802546:	00 00 00 
  802549:	8b 12                	mov    (%rdx),%edx
  80254b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80254d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802551:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255c:	48 89 c7             	mov    %rax,%rdi
  80255f:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  802566:	00 00 00 
  802569:	ff d0                	callq  *%rax
}
  80256b:	c9                   	leaveq 
  80256c:	c3                   	retq   

000000000080256d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80256d:	55                   	push   %rbp
  80256e:	48 89 e5             	mov    %rsp,%rbp
  802571:	48 83 ec 30          	sub    $0x30,%rsp
  802575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80257d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802581:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802586:	75 07                	jne    80258f <devcons_read+0x22>
		return 0;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	eb 4b                	jmp    8025da <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80258f:	eb 0c                	jmp    80259d <devcons_read+0x30>
		sys_yield();
  802591:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  802598:	00 00 00 
  80259b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80259d:	48 b8 16 02 80 00 00 	movabs $0x800216,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
  8025a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b0:	74 df                	je     802591 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8025b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b6:	79 05                	jns    8025bd <devcons_read+0x50>
		return c;
  8025b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bb:	eb 1d                	jmp    8025da <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025bd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025c1:	75 07                	jne    8025ca <devcons_read+0x5d>
		return 0;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	eb 10                	jmp    8025da <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025cd:	89 c2                	mov    %eax,%edx
  8025cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d3:	88 10                	mov    %dl,(%rax)
	return 1;
  8025d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8025e7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8025ee:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8025f5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802603:	eb 76                	jmp    80267b <devcons_write+0x9f>
		m = n - tot;
  802605:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80260c:	89 c2                	mov    %eax,%edx
  80260e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802611:	29 c2                	sub    %eax,%edx
  802613:	89 d0                	mov    %edx,%eax
  802615:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802618:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80261b:	83 f8 7f             	cmp    $0x7f,%eax
  80261e:	76 07                	jbe    802627 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802620:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80262a:	48 63 d0             	movslq %eax,%rdx
  80262d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802630:	48 63 c8             	movslq %eax,%rcx
  802633:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80263a:	48 01 c1             	add    %rax,%rcx
  80263d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802644:	48 89 ce             	mov    %rcx,%rsi
  802647:	48 89 c7             	mov    %rax,%rdi
  80264a:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802656:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802659:	48 63 d0             	movslq %eax,%rdx
  80265c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802663:	48 89 d6             	mov    %rdx,%rsi
  802666:	48 89 c7             	mov    %rax,%rdi
  802669:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802670:	00 00 00 
  802673:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802675:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802678:	01 45 fc             	add    %eax,-0x4(%rbp)
  80267b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267e:	48 98                	cltq   
  802680:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802687:	0f 82 78 ff ff ff    	jb     802605 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80268d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802690:	c9                   	leaveq 
  802691:	c3                   	retq   

0000000000802692 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802692:	55                   	push   %rbp
  802693:	48 89 e5             	mov    %rsp,%rbp
  802696:	48 83 ec 08          	sub    $0x8,%rsp
  80269a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a3:	c9                   	leaveq 
  8026a4:	c3                   	retq   

00000000008026a5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a5:	55                   	push   %rbp
  8026a6:	48 89 e5             	mov    %rsp,%rbp
  8026a9:	48 83 ec 10          	sub    $0x10,%rsp
  8026ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8026b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b9:	48 be 3d 40 80 00 00 	movabs $0x80403d,%rsi
  8026c0:	00 00 00 
  8026c3:	48 89 c7             	mov    %rax,%rdi
  8026c6:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
	return 0;
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d7:	c9                   	leaveq 
  8026d8:	c3                   	retq   

00000000008026d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026d9:	55                   	push   %rbp
  8026da:	48 89 e5             	mov    %rsp,%rbp
  8026dd:	53                   	push   %rbx
  8026de:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8026e5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8026ec:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8026f2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8026f9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802700:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802707:	84 c0                	test   %al,%al
  802709:	74 23                	je     80272e <_panic+0x55>
  80270b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802712:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802716:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80271a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80271e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802722:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802726:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80272a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80272e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802735:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80273c:	00 00 00 
  80273f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802746:	00 00 00 
  802749:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80274d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802754:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80275b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802769:	00 00 00 
  80276c:	48 8b 18             	mov    (%rax),%rbx
  80276f:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802781:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802788:	41 89 c8             	mov    %ecx,%r8d
  80278b:	48 89 d1             	mov    %rdx,%rcx
  80278e:	48 89 da             	mov    %rbx,%rdx
  802791:	89 c6                	mov    %eax,%esi
  802793:	48 bf 48 40 80 00 00 	movabs $0x804048,%rdi
  80279a:	00 00 00 
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	49 b9 12 29 80 00 00 	movabs $0x802912,%r9
  8027a9:	00 00 00 
  8027ac:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027af:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8027b6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027bd:	48 89 d6             	mov    %rdx,%rsi
  8027c0:	48 89 c7             	mov    %rax,%rdi
  8027c3:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8027ca:	00 00 00 
  8027cd:	ff d0                	callq  *%rax
	cprintf("\n");
  8027cf:	48 bf 6b 40 80 00 00 	movabs $0x80406b,%rdi
  8027d6:	00 00 00 
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	48 ba 12 29 80 00 00 	movabs $0x802912,%rdx
  8027e5:	00 00 00 
  8027e8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027ea:	cc                   	int3   
  8027eb:	eb fd                	jmp    8027ea <_panic+0x111>

00000000008027ed <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8027ed:	55                   	push   %rbp
  8027ee:	48 89 e5             	mov    %rsp,%rbp
  8027f1:	48 83 ec 10          	sub    $0x10,%rsp
  8027f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8027fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802800:	8b 00                	mov    (%rax),%eax
  802802:	8d 48 01             	lea    0x1(%rax),%ecx
  802805:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802809:	89 0a                	mov    %ecx,(%rdx)
  80280b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80280e:	89 d1                	mov    %edx,%ecx
  802810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802814:	48 98                	cltq   
  802816:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80281a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281e:	8b 00                	mov    (%rax),%eax
  802820:	3d ff 00 00 00       	cmp    $0xff,%eax
  802825:	75 2c                	jne    802853 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	8b 00                	mov    (%rax),%eax
  80282d:	48 98                	cltq   
  80282f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802833:	48 83 c2 08          	add    $0x8,%rdx
  802837:	48 89 c6             	mov    %rax,%rsi
  80283a:	48 89 d7             	mov    %rdx,%rdi
  80283d:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax
        b->idx = 0;
  802849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802853:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802857:	8b 40 04             	mov    0x4(%rax),%eax
  80285a:	8d 50 01             	lea    0x1(%rax),%edx
  80285d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802861:	89 50 04             	mov    %edx,0x4(%rax)
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802871:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802878:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80287f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802886:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80288d:	48 8b 0a             	mov    (%rdx),%rcx
  802890:	48 89 08             	mov    %rcx,(%rax)
  802893:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802897:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80289b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80289f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8028a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8028aa:	00 00 00 
    b.cnt = 0;
  8028ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8028b4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8028b7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028be:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028c5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8028cc:	48 89 c6             	mov    %rax,%rsi
  8028cf:	48 bf ed 27 80 00 00 	movabs $0x8027ed,%rdi
  8028d6:	00 00 00 
  8028d9:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8028e5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8028eb:	48 98                	cltq   
  8028ed:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8028f4:	48 83 c2 08          	add    $0x8,%rdx
  8028f8:	48 89 c6             	mov    %rax,%rsi
  8028fb:	48 89 d7             	mov    %rdx,%rdi
  8028fe:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80290a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80291d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802924:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80292b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802932:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802939:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802940:	84 c0                	test   %al,%al
  802942:	74 20                	je     802964 <cprintf+0x52>
  802944:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802948:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80294c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802950:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802954:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802958:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80295c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802960:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802964:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80296b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802972:	00 00 00 
  802975:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80297c:	00 00 00 
  80297f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802983:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80298a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802991:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802998:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80299f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029a6:	48 8b 0a             	mov    (%rdx),%rcx
  8029a9:	48 89 08             	mov    %rcx,(%rax)
  8029ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029bc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029ca:	48 89 d6             	mov    %rdx,%rsi
  8029cd:	48 89 c7             	mov    %rax,%rdi
  8029d0:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8029e2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	53                   	push   %rbx
  8029ef:	48 83 ec 38          	sub    $0x38,%rsp
  8029f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8029ff:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a02:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a06:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a0a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a0d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a11:	77 3b                	ja     802a4e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a13:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a16:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a1a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a21:	ba 00 00 00 00       	mov    $0x0,%edx
  802a26:	48 f7 f3             	div    %rbx
  802a29:	48 89 c2             	mov    %rax,%rdx
  802a2c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a2f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a32:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3a:	41 89 f9             	mov    %edi,%r9d
  802a3d:	48 89 c7             	mov    %rax,%rdi
  802a40:	48 b8 ea 29 80 00 00 	movabs $0x8029ea,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
  802a4c:	eb 1e                	jmp    802a6c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a4e:	eb 12                	jmp    802a62 <printnum+0x78>
			putch(padc, putdat);
  802a50:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a54:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5b:	48 89 ce             	mov    %rcx,%rsi
  802a5e:	89 d7                	mov    %edx,%edi
  802a60:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a62:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a66:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a6a:	7f e4                	jg     802a50 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802a6c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a73:	ba 00 00 00 00       	mov    $0x0,%edx
  802a78:	48 f7 f1             	div    %rcx
  802a7b:	48 89 d0             	mov    %rdx,%rax
  802a7e:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  802a85:	00 00 00 
  802a88:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802a8c:	0f be d0             	movsbl %al,%edx
  802a8f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	48 89 ce             	mov    %rcx,%rsi
  802a9a:	89 d7                	mov    %edx,%edi
  802a9c:	ff d0                	callq  *%rax
}
  802a9e:	48 83 c4 38          	add    $0x38,%rsp
  802aa2:	5b                   	pop    %rbx
  802aa3:	5d                   	pop    %rbp
  802aa4:	c3                   	retq   

0000000000802aa5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802aa5:	55                   	push   %rbp
  802aa6:	48 89 e5             	mov    %rsp,%rbp
  802aa9:	48 83 ec 1c          	sub    $0x1c,%rsp
  802aad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ab1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802ab4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802ab8:	7e 52                	jle    802b0c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abe:	8b 00                	mov    (%rax),%eax
  802ac0:	83 f8 30             	cmp    $0x30,%eax
  802ac3:	73 24                	jae    802ae9 <getuint+0x44>
  802ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad1:	8b 00                	mov    (%rax),%eax
  802ad3:	89 c0                	mov    %eax,%eax
  802ad5:	48 01 d0             	add    %rdx,%rax
  802ad8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802adc:	8b 12                	mov    (%rdx),%edx
  802ade:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae5:	89 0a                	mov    %ecx,(%rdx)
  802ae7:	eb 17                	jmp    802b00 <getuint+0x5b>
  802ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802af1:	48 89 d0             	mov    %rdx,%rax
  802af4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802afc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b00:	48 8b 00             	mov    (%rax),%rax
  802b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b07:	e9 a3 00 00 00       	jmpq   802baf <getuint+0x10a>
	else if (lflag)
  802b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b10:	74 4f                	je     802b61 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b16:	8b 00                	mov    (%rax),%eax
  802b18:	83 f8 30             	cmp    $0x30,%eax
  802b1b:	73 24                	jae    802b41 <getuint+0x9c>
  802b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b29:	8b 00                	mov    (%rax),%eax
  802b2b:	89 c0                	mov    %eax,%eax
  802b2d:	48 01 d0             	add    %rdx,%rax
  802b30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b34:	8b 12                	mov    (%rdx),%edx
  802b36:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3d:	89 0a                	mov    %ecx,(%rdx)
  802b3f:	eb 17                	jmp    802b58 <getuint+0xb3>
  802b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b45:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b49:	48 89 d0             	mov    %rdx,%rax
  802b4c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b54:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b58:	48 8b 00             	mov    (%rax),%rax
  802b5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b5f:	eb 4e                	jmp    802baf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	8b 00                	mov    (%rax),%eax
  802b67:	83 f8 30             	cmp    $0x30,%eax
  802b6a:	73 24                	jae    802b90 <getuint+0xeb>
  802b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b78:	8b 00                	mov    (%rax),%eax
  802b7a:	89 c0                	mov    %eax,%eax
  802b7c:	48 01 d0             	add    %rdx,%rax
  802b7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b83:	8b 12                	mov    (%rdx),%edx
  802b85:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8c:	89 0a                	mov    %ecx,(%rdx)
  802b8e:	eb 17                	jmp    802ba7 <getuint+0x102>
  802b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b94:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b98:	48 89 d0             	mov    %rdx,%rax
  802b9b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ba3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802ba7:	8b 00                	mov    (%rax),%eax
  802ba9:	89 c0                	mov    %eax,%eax
  802bab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bb3:	c9                   	leaveq 
  802bb4:	c3                   	retq   

0000000000802bb5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802bb5:	55                   	push   %rbp
  802bb6:	48 89 e5             	mov    %rsp,%rbp
  802bb9:	48 83 ec 1c          	sub    $0x1c,%rsp
  802bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802bc4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802bc8:	7e 52                	jle    802c1c <getint+0x67>
		x=va_arg(*ap, long long);
  802bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bce:	8b 00                	mov    (%rax),%eax
  802bd0:	83 f8 30             	cmp    $0x30,%eax
  802bd3:	73 24                	jae    802bf9 <getint+0x44>
  802bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be1:	8b 00                	mov    (%rax),%eax
  802be3:	89 c0                	mov    %eax,%eax
  802be5:	48 01 d0             	add    %rdx,%rax
  802be8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bec:	8b 12                	mov    (%rdx),%edx
  802bee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf5:	89 0a                	mov    %ecx,(%rdx)
  802bf7:	eb 17                	jmp    802c10 <getint+0x5b>
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c01:	48 89 d0             	mov    %rdx,%rax
  802c04:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c10:	48 8b 00             	mov    (%rax),%rax
  802c13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c17:	e9 a3 00 00 00       	jmpq   802cbf <getint+0x10a>
	else if (lflag)
  802c1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c20:	74 4f                	je     802c71 <getint+0xbc>
		x=va_arg(*ap, long);
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	8b 00                	mov    (%rax),%eax
  802c28:	83 f8 30             	cmp    $0x30,%eax
  802c2b:	73 24                	jae    802c51 <getint+0x9c>
  802c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c39:	8b 00                	mov    (%rax),%eax
  802c3b:	89 c0                	mov    %eax,%eax
  802c3d:	48 01 d0             	add    %rdx,%rax
  802c40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c44:	8b 12                	mov    (%rdx),%edx
  802c46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c4d:	89 0a                	mov    %ecx,(%rdx)
  802c4f:	eb 17                	jmp    802c68 <getint+0xb3>
  802c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c59:	48 89 d0             	mov    %rdx,%rax
  802c5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c68:	48 8b 00             	mov    (%rax),%rax
  802c6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c6f:	eb 4e                	jmp    802cbf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c75:	8b 00                	mov    (%rax),%eax
  802c77:	83 f8 30             	cmp    $0x30,%eax
  802c7a:	73 24                	jae    802ca0 <getint+0xeb>
  802c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c80:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c88:	8b 00                	mov    (%rax),%eax
  802c8a:	89 c0                	mov    %eax,%eax
  802c8c:	48 01 d0             	add    %rdx,%rax
  802c8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c93:	8b 12                	mov    (%rdx),%edx
  802c95:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9c:	89 0a                	mov    %ecx,(%rdx)
  802c9e:	eb 17                	jmp    802cb7 <getint+0x102>
  802ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ca8:	48 89 d0             	mov    %rdx,%rax
  802cab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802caf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cb7:	8b 00                	mov    (%rax),%eax
  802cb9:	48 98                	cltq   
  802cbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cc3:	c9                   	leaveq 
  802cc4:	c3                   	retq   

0000000000802cc5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802cc5:	55                   	push   %rbp
  802cc6:	48 89 e5             	mov    %rsp,%rbp
  802cc9:	41 54                	push   %r12
  802ccb:	53                   	push   %rbx
  802ccc:	48 83 ec 60          	sub    $0x60,%rsp
  802cd0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802cd4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802cd8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802cdc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802ce0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ce4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ce8:	48 8b 0a             	mov    (%rdx),%rcx
  802ceb:	48 89 08             	mov    %rcx,(%rax)
  802cee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802cf2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cf6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802cfa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802cfe:	eb 17                	jmp    802d17 <vprintfmt+0x52>
			if (ch == '\0')
  802d00:	85 db                	test   %ebx,%ebx
  802d02:	0f 84 cc 04 00 00    	je     8031d4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d10:	48 89 d6             	mov    %rdx,%rsi
  802d13:	89 df                	mov    %ebx,%edi
  802d15:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d23:	0f b6 00             	movzbl (%rax),%eax
  802d26:	0f b6 d8             	movzbl %al,%ebx
  802d29:	83 fb 25             	cmp    $0x25,%ebx
  802d2c:	75 d2                	jne    802d00 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d2e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d32:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d39:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d47:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d5a:	0f b6 00             	movzbl (%rax),%eax
  802d5d:	0f b6 d8             	movzbl %al,%ebx
  802d60:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802d63:	83 f8 55             	cmp    $0x55,%eax
  802d66:	0f 87 34 04 00 00    	ja     8031a0 <vprintfmt+0x4db>
  802d6c:	89 c0                	mov    %eax,%eax
  802d6e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d75:	00 
  802d76:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  802d7d:	00 00 00 
  802d80:	48 01 d0             	add    %rdx,%rax
  802d83:	48 8b 00             	mov    (%rax),%rax
  802d86:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802d88:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802d8c:	eb c0                	jmp    802d4e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802d8e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802d92:	eb ba                	jmp    802d4e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802d94:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802d9b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d9e:	89 d0                	mov    %edx,%eax
  802da0:	c1 e0 02             	shl    $0x2,%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	01 c0                	add    %eax,%eax
  802da7:	01 d8                	add    %ebx,%eax
  802da9:	83 e8 30             	sub    $0x30,%eax
  802dac:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802daf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802db3:	0f b6 00             	movzbl (%rax),%eax
  802db6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802db9:	83 fb 2f             	cmp    $0x2f,%ebx
  802dbc:	7e 0c                	jle    802dca <vprintfmt+0x105>
  802dbe:	83 fb 39             	cmp    $0x39,%ebx
  802dc1:	7f 07                	jg     802dca <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802dc3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802dc8:	eb d1                	jmp    802d9b <vprintfmt+0xd6>
			goto process_precision;
  802dca:	eb 58                	jmp    802e24 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802dcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dcf:	83 f8 30             	cmp    $0x30,%eax
  802dd2:	73 17                	jae    802deb <vprintfmt+0x126>
  802dd4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ddb:	89 c0                	mov    %eax,%eax
  802ddd:	48 01 d0             	add    %rdx,%rax
  802de0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802de3:	83 c2 08             	add    $0x8,%edx
  802de6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802de9:	eb 0f                	jmp    802dfa <vprintfmt+0x135>
  802deb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802def:	48 89 d0             	mov    %rdx,%rax
  802df2:	48 83 c2 08          	add    $0x8,%rdx
  802df6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802dfa:	8b 00                	mov    (%rax),%eax
  802dfc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802dff:	eb 23                	jmp    802e24 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802e01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e05:	79 0c                	jns    802e13 <vprintfmt+0x14e>
				width = 0;
  802e07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e0e:	e9 3b ff ff ff       	jmpq   802d4e <vprintfmt+0x89>
  802e13:	e9 36 ff ff ff       	jmpq   802d4e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e18:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e1f:	e9 2a ff ff ff       	jmpq   802d4e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e28:	79 12                	jns    802e3c <vprintfmt+0x177>
				width = precision, precision = -1;
  802e2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e2d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e37:	e9 12 ff ff ff       	jmpq   802d4e <vprintfmt+0x89>
  802e3c:	e9 0d ff ff ff       	jmpq   802d4e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e41:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e45:	e9 04 ff ff ff       	jmpq   802d4e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e4d:	83 f8 30             	cmp    $0x30,%eax
  802e50:	73 17                	jae    802e69 <vprintfmt+0x1a4>
  802e52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e59:	89 c0                	mov    %eax,%eax
  802e5b:	48 01 d0             	add    %rdx,%rax
  802e5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e61:	83 c2 08             	add    $0x8,%edx
  802e64:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e67:	eb 0f                	jmp    802e78 <vprintfmt+0x1b3>
  802e69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e6d:	48 89 d0             	mov    %rdx,%rax
  802e70:	48 83 c2 08          	add    $0x8,%rdx
  802e74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e78:	8b 10                	mov    (%rax),%edx
  802e7a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802e7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e82:	48 89 ce             	mov    %rcx,%rsi
  802e85:	89 d7                	mov    %edx,%edi
  802e87:	ff d0                	callq  *%rax
			break;
  802e89:	e9 40 03 00 00       	jmpq   8031ce <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802e8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e91:	83 f8 30             	cmp    $0x30,%eax
  802e94:	73 17                	jae    802ead <vprintfmt+0x1e8>
  802e96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e9d:	89 c0                	mov    %eax,%eax
  802e9f:	48 01 d0             	add    %rdx,%rax
  802ea2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ea5:	83 c2 08             	add    $0x8,%edx
  802ea8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802eab:	eb 0f                	jmp    802ebc <vprintfmt+0x1f7>
  802ead:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802eb1:	48 89 d0             	mov    %rdx,%rax
  802eb4:	48 83 c2 08          	add    $0x8,%rdx
  802eb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ebc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802ebe:	85 db                	test   %ebx,%ebx
  802ec0:	79 02                	jns    802ec4 <vprintfmt+0x1ff>
				err = -err;
  802ec2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802ec4:	83 fb 15             	cmp    $0x15,%ebx
  802ec7:	7f 16                	jg     802edf <vprintfmt+0x21a>
  802ec9:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  802ed0:	00 00 00 
  802ed3:	48 63 d3             	movslq %ebx,%rdx
  802ed6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802eda:	4d 85 e4             	test   %r12,%r12
  802edd:	75 2e                	jne    802f0d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802edf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ee3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ee7:	89 d9                	mov    %ebx,%ecx
  802ee9:	48 ba 81 42 80 00 00 	movabs $0x804281,%rdx
  802ef0:	00 00 00 
  802ef3:	48 89 c7             	mov    %rax,%rdi
  802ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  802efb:	49 b8 dd 31 80 00 00 	movabs $0x8031dd,%r8
  802f02:	00 00 00 
  802f05:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f08:	e9 c1 02 00 00       	jmpq   8031ce <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f0d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f15:	4c 89 e1             	mov    %r12,%rcx
  802f18:	48 ba 8a 42 80 00 00 	movabs $0x80428a,%rdx
  802f1f:	00 00 00 
  802f22:	48 89 c7             	mov    %rax,%rdi
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2a:	49 b8 dd 31 80 00 00 	movabs $0x8031dd,%r8
  802f31:	00 00 00 
  802f34:	41 ff d0             	callq  *%r8
			break;
  802f37:	e9 92 02 00 00       	jmpq   8031ce <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f3f:	83 f8 30             	cmp    $0x30,%eax
  802f42:	73 17                	jae    802f5b <vprintfmt+0x296>
  802f44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f4b:	89 c0                	mov    %eax,%eax
  802f4d:	48 01 d0             	add    %rdx,%rax
  802f50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f53:	83 c2 08             	add    $0x8,%edx
  802f56:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f59:	eb 0f                	jmp    802f6a <vprintfmt+0x2a5>
  802f5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f5f:	48 89 d0             	mov    %rdx,%rax
  802f62:	48 83 c2 08          	add    $0x8,%rdx
  802f66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f6a:	4c 8b 20             	mov    (%rax),%r12
  802f6d:	4d 85 e4             	test   %r12,%r12
  802f70:	75 0a                	jne    802f7c <vprintfmt+0x2b7>
				p = "(null)";
  802f72:	49 bc 8d 42 80 00 00 	movabs $0x80428d,%r12
  802f79:	00 00 00 
			if (width > 0 && padc != '-')
  802f7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f80:	7e 3f                	jle    802fc1 <vprintfmt+0x2fc>
  802f82:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802f86:	74 39                	je     802fc1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802f88:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f8b:	48 98                	cltq   
  802f8d:	48 89 c6             	mov    %rax,%rsi
  802f90:	4c 89 e7             	mov    %r12,%rdi
  802f93:	48 b8 89 34 80 00 00 	movabs $0x803489,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
  802f9f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802fa2:	eb 17                	jmp    802fbb <vprintfmt+0x2f6>
					putch(padc, putdat);
  802fa4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802fa8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802fac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fb0:	48 89 ce             	mov    %rcx,%rsi
  802fb3:	89 d7                	mov    %edx,%edi
  802fb5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802fb7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fbf:	7f e3                	jg     802fa4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fc1:	eb 37                	jmp    802ffa <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802fc3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802fc7:	74 1e                	je     802fe7 <vprintfmt+0x322>
  802fc9:	83 fb 1f             	cmp    $0x1f,%ebx
  802fcc:	7e 05                	jle    802fd3 <vprintfmt+0x30e>
  802fce:	83 fb 7e             	cmp    $0x7e,%ebx
  802fd1:	7e 14                	jle    802fe7 <vprintfmt+0x322>
					putch('?', putdat);
  802fd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fdb:	48 89 d6             	mov    %rdx,%rsi
  802fde:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802fe3:	ff d0                	callq  *%rax
  802fe5:	eb 0f                	jmp    802ff6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802fe7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802feb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fef:	48 89 d6             	mov    %rdx,%rsi
  802ff2:	89 df                	mov    %ebx,%edi
  802ff4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ff6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802ffa:	4c 89 e0             	mov    %r12,%rax
  802ffd:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803001:	0f b6 00             	movzbl (%rax),%eax
  803004:	0f be d8             	movsbl %al,%ebx
  803007:	85 db                	test   %ebx,%ebx
  803009:	74 10                	je     80301b <vprintfmt+0x356>
  80300b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80300f:	78 b2                	js     802fc3 <vprintfmt+0x2fe>
  803011:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803015:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803019:	79 a8                	jns    802fc3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80301b:	eb 16                	jmp    803033 <vprintfmt+0x36e>
				putch(' ', putdat);
  80301d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803021:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803025:	48 89 d6             	mov    %rdx,%rsi
  803028:	bf 20 00 00 00       	mov    $0x20,%edi
  80302d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80302f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803033:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803037:	7f e4                	jg     80301d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803039:	e9 90 01 00 00       	jmpq   8031ce <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80303e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803042:	be 03 00 00 00       	mov    $0x3,%esi
  803047:	48 89 c7             	mov    %rax,%rdi
  80304a:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  803051:	00 00 00 
  803054:	ff d0                	callq  *%rax
  803056:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80305a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305e:	48 85 c0             	test   %rax,%rax
  803061:	79 1d                	jns    803080 <vprintfmt+0x3bb>
				putch('-', putdat);
  803063:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803067:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80306b:	48 89 d6             	mov    %rdx,%rsi
  80306e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803073:	ff d0                	callq  *%rax
				num = -(long long) num;
  803075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803079:	48 f7 d8             	neg    %rax
  80307c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803080:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803087:	e9 d5 00 00 00       	jmpq   803161 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80308c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803090:	be 03 00 00 00       	mov    $0x3,%esi
  803095:	48 89 c7             	mov    %rax,%rdi
  803098:	48 b8 a5 2a 80 00 00 	movabs $0x802aa5,%rax
  80309f:	00 00 00 
  8030a2:	ff d0                	callq  *%rax
  8030a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8030a8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030af:	e9 ad 00 00 00       	jmpq   803161 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8030b4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8030b7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030bb:	89 d6                	mov    %edx,%esi
  8030bd:	48 89 c7             	mov    %rax,%rdi
  8030c0:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8030d0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8030d7:	e9 85 00 00 00       	jmpq   803161 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8030dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030e4:	48 89 d6             	mov    %rdx,%rsi
  8030e7:	bf 30 00 00 00       	mov    $0x30,%edi
  8030ec:	ff d0                	callq  *%rax
			putch('x', putdat);
  8030ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030f6:	48 89 d6             	mov    %rdx,%rsi
  8030f9:	bf 78 00 00 00       	mov    $0x78,%edi
  8030fe:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803100:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803103:	83 f8 30             	cmp    $0x30,%eax
  803106:	73 17                	jae    80311f <vprintfmt+0x45a>
  803108:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80310c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80310f:	89 c0                	mov    %eax,%eax
  803111:	48 01 d0             	add    %rdx,%rax
  803114:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803117:	83 c2 08             	add    $0x8,%edx
  80311a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80311d:	eb 0f                	jmp    80312e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80311f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803123:	48 89 d0             	mov    %rdx,%rax
  803126:	48 83 c2 08          	add    $0x8,%rdx
  80312a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80312e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803131:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803135:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80313c:	eb 23                	jmp    803161 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80313e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803142:	be 03 00 00 00       	mov    $0x3,%esi
  803147:	48 89 c7             	mov    %rax,%rdi
  80314a:	48 b8 a5 2a 80 00 00 	movabs $0x802aa5,%rax
  803151:	00 00 00 
  803154:	ff d0                	callq  *%rax
  803156:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80315a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803161:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803166:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803169:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80316c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803170:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803174:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803178:	45 89 c1             	mov    %r8d,%r9d
  80317b:	41 89 f8             	mov    %edi,%r8d
  80317e:	48 89 c7             	mov    %rax,%rdi
  803181:	48 b8 ea 29 80 00 00 	movabs $0x8029ea,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
			break;
  80318d:	eb 3f                	jmp    8031ce <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80318f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803193:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803197:	48 89 d6             	mov    %rdx,%rsi
  80319a:	89 df                	mov    %ebx,%edi
  80319c:	ff d0                	callq  *%rax
			break;
  80319e:	eb 2e                	jmp    8031ce <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8031a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031a8:	48 89 d6             	mov    %rdx,%rsi
  8031ab:	bf 25 00 00 00       	mov    $0x25,%edi
  8031b0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8031b2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031b7:	eb 05                	jmp    8031be <vprintfmt+0x4f9>
  8031b9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031be:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031c2:	48 83 e8 01          	sub    $0x1,%rax
  8031c6:	0f b6 00             	movzbl (%rax),%eax
  8031c9:	3c 25                	cmp    $0x25,%al
  8031cb:	75 ec                	jne    8031b9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8031cd:	90                   	nop
		}
	}
  8031ce:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031cf:	e9 43 fb ff ff       	jmpq   802d17 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8031d4:	48 83 c4 60          	add    $0x60,%rsp
  8031d8:	5b                   	pop    %rbx
  8031d9:	41 5c                	pop    %r12
  8031db:	5d                   	pop    %rbp
  8031dc:	c3                   	retq   

00000000008031dd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8031dd:	55                   	push   %rbp
  8031de:	48 89 e5             	mov    %rsp,%rbp
  8031e1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8031e8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8031ef:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8031f6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031fd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803204:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80320b:	84 c0                	test   %al,%al
  80320d:	74 20                	je     80322f <printfmt+0x52>
  80320f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803213:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803217:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80321b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80321f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803223:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803227:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80322b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80322f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803236:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80323d:	00 00 00 
  803240:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803247:	00 00 00 
  80324a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80324e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803255:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80325c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803263:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80326a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803271:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803278:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80327f:	48 89 c7             	mov    %rax,%rdi
  803282:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80328e:	c9                   	leaveq 
  80328f:	c3                   	retq   

0000000000803290 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803290:	55                   	push   %rbp
  803291:	48 89 e5             	mov    %rsp,%rbp
  803294:	48 83 ec 10          	sub    $0x10,%rsp
  803298:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80329b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80329f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a3:	8b 40 10             	mov    0x10(%rax),%eax
  8032a6:	8d 50 01             	lea    0x1(%rax),%edx
  8032a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ad:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8032b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b4:	48 8b 10             	mov    (%rax),%rdx
  8032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032bf:	48 39 c2             	cmp    %rax,%rdx
  8032c2:	73 17                	jae    8032db <sprintputch+0x4b>
		*b->buf++ = ch;
  8032c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c8:	48 8b 00             	mov    (%rax),%rax
  8032cb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8032cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d3:	48 89 0a             	mov    %rcx,(%rdx)
  8032d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d9:	88 10                	mov    %dl,(%rax)
}
  8032db:	c9                   	leaveq 
  8032dc:	c3                   	retq   

00000000008032dd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8032dd:	55                   	push   %rbp
  8032de:	48 89 e5             	mov    %rsp,%rbp
  8032e1:	48 83 ec 50          	sub    $0x50,%rsp
  8032e5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8032e9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8032ec:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8032f0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8032f4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032f8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8032fc:	48 8b 0a             	mov    (%rdx),%rcx
  8032ff:	48 89 08             	mov    %rcx,(%rax)
  803302:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803306:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80330a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80330e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803312:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803316:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80331a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80331d:	48 98                	cltq   
  80331f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803323:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803327:	48 01 d0             	add    %rdx,%rax
  80332a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80332e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803335:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80333a:	74 06                	je     803342 <vsnprintf+0x65>
  80333c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803340:	7f 07                	jg     803349 <vsnprintf+0x6c>
		return -E_INVAL;
  803342:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803347:	eb 2f                	jmp    803378 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803349:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80334d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803351:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803355:	48 89 c6             	mov    %rax,%rsi
  803358:	48 bf 90 32 80 00 00 	movabs $0x803290,%rdi
  80335f:	00 00 00 
  803362:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80336e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803372:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803375:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803378:	c9                   	leaveq 
  803379:	c3                   	retq   

000000000080337a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80337a:	55                   	push   %rbp
  80337b:	48 89 e5             	mov    %rsp,%rbp
  80337e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803385:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80338c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803392:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803399:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033a7:	84 c0                	test   %al,%al
  8033a9:	74 20                	je     8033cb <snprintf+0x51>
  8033ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033cb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8033d2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8033d9:	00 00 00 
  8033dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033e3:	00 00 00 
  8033e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8033ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803406:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80340d:	48 8b 0a             	mov    (%rdx),%rcx
  803410:	48 89 08             	mov    %rcx,(%rax)
  803413:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803417:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80341b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80341f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803423:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80342a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803431:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803437:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80343e:	48 89 c7             	mov    %rax,%rdi
  803441:	48 b8 dd 32 80 00 00 	movabs $0x8032dd,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
  80344d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803453:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803459:	c9                   	leaveq 
  80345a:	c3                   	retq   

000000000080345b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80345b:	55                   	push   %rbp
  80345c:	48 89 e5             	mov    %rsp,%rbp
  80345f:	48 83 ec 18          	sub    $0x18,%rsp
  803463:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803467:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80346e:	eb 09                	jmp    803479 <strlen+0x1e>
		n++;
  803470:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803474:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347d:	0f b6 00             	movzbl (%rax),%eax
  803480:	84 c0                	test   %al,%al
  803482:	75 ec                	jne    803470 <strlen+0x15>
		n++;
	return n;
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803487:	c9                   	leaveq 
  803488:	c3                   	retq   

0000000000803489 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	48 83 ec 20          	sub    $0x20,%rsp
  803491:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803495:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803499:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034a0:	eb 0e                	jmp    8034b0 <strnlen+0x27>
		n++;
  8034a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8034a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034ab:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8034b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034b5:	74 0b                	je     8034c2 <strnlen+0x39>
  8034b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bb:	0f b6 00             	movzbl (%rax),%eax
  8034be:	84 c0                	test   %al,%al
  8034c0:	75 e0                	jne    8034a2 <strnlen+0x19>
		n++;
	return n;
  8034c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 20          	sub    $0x20,%rsp
  8034cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8034d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8034df:	90                   	nop
  8034e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8034ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034f0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8034f4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8034f8:	0f b6 12             	movzbl (%rdx),%edx
  8034fb:	88 10                	mov    %dl,(%rax)
  8034fd:	0f b6 00             	movzbl (%rax),%eax
  803500:	84 c0                	test   %al,%al
  803502:	75 dc                	jne    8034e0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803508:	c9                   	leaveq 
  803509:	c3                   	retq   

000000000080350a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80350a:	55                   	push   %rbp
  80350b:	48 89 e5             	mov    %rsp,%rbp
  80350e:	48 83 ec 20          	sub    $0x20,%rsp
  803512:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803516:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80351a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351e:	48 89 c7             	mov    %rax,%rdi
  803521:	48 b8 5b 34 80 00 00 	movabs $0x80345b,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803533:	48 63 d0             	movslq %eax,%rdx
  803536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353a:	48 01 c2             	add    %rax,%rdx
  80353d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803541:	48 89 c6             	mov    %rax,%rsi
  803544:	48 89 d7             	mov    %rdx,%rdi
  803547:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
	return dst;
  803553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803557:	c9                   	leaveq 
  803558:	c3                   	retq   

0000000000803559 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	48 83 ec 28          	sub    $0x28,%rsp
  803561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803565:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803569:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80356d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803571:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803575:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80357c:	00 
  80357d:	eb 2a                	jmp    8035a9 <strncpy+0x50>
		*dst++ = *src;
  80357f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803583:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803587:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80358b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80358f:	0f b6 12             	movzbl (%rdx),%edx
  803592:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803594:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803598:	0f b6 00             	movzbl (%rax),%eax
  80359b:	84 c0                	test   %al,%al
  80359d:	74 05                	je     8035a4 <strncpy+0x4b>
			src++;
  80359f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8035a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8035b1:	72 cc                	jb     80357f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8035b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8035b7:	c9                   	leaveq 
  8035b8:	c3                   	retq   

00000000008035b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 28          	sub    $0x28,%rsp
  8035c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8035cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8035d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035da:	74 3d                	je     803619 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8035dc:	eb 1d                	jmp    8035fb <strlcpy+0x42>
			*dst++ = *src++;
  8035de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035ee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8035f2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8035f6:	0f b6 12             	movzbl (%rdx),%edx
  8035f9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8035fb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  803600:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803605:	74 0b                	je     803612 <strlcpy+0x59>
  803607:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80360b:	0f b6 00             	movzbl (%rax),%eax
  80360e:	84 c0                	test   %al,%al
  803610:	75 cc                	jne    8035de <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803616:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803619:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803621:	48 29 c2             	sub    %rax,%rdx
  803624:	48 89 d0             	mov    %rdx,%rax
}
  803627:	c9                   	leaveq 
  803628:	c3                   	retq   

0000000000803629 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803629:	55                   	push   %rbp
  80362a:	48 89 e5             	mov    %rsp,%rbp
  80362d:	48 83 ec 10          	sub    $0x10,%rsp
  803631:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803635:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803639:	eb 0a                	jmp    803645 <strcmp+0x1c>
		p++, q++;
  80363b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803640:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  803645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803649:	0f b6 00             	movzbl (%rax),%eax
  80364c:	84 c0                	test   %al,%al
  80364e:	74 12                	je     803662 <strcmp+0x39>
  803650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803654:	0f b6 10             	movzbl (%rax),%edx
  803657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365b:	0f b6 00             	movzbl (%rax),%eax
  80365e:	38 c2                	cmp    %al,%dl
  803660:	74 d9                	je     80363b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803666:	0f b6 00             	movzbl (%rax),%eax
  803669:	0f b6 d0             	movzbl %al,%edx
  80366c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803670:	0f b6 00             	movzbl (%rax),%eax
  803673:	0f b6 c0             	movzbl %al,%eax
  803676:	29 c2                	sub    %eax,%edx
  803678:	89 d0                	mov    %edx,%eax
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 18          	sub    $0x18,%rsp
  803684:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803688:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80368c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803690:	eb 0f                	jmp    8036a1 <strncmp+0x25>
		n--, p++, q++;
  803692:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803697:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80369c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8036a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036a6:	74 1d                	je     8036c5 <strncmp+0x49>
  8036a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ac:	0f b6 00             	movzbl (%rax),%eax
  8036af:	84 c0                	test   %al,%al
  8036b1:	74 12                	je     8036c5 <strncmp+0x49>
  8036b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b7:	0f b6 10             	movzbl (%rax),%edx
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	0f b6 00             	movzbl (%rax),%eax
  8036c1:	38 c2                	cmp    %al,%dl
  8036c3:	74 cd                	je     803692 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8036c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036ca:	75 07                	jne    8036d3 <strncmp+0x57>
		return 0;
  8036cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d1:	eb 18                	jmp    8036eb <strncmp+0x6f>
	else
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

00000000008036ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8036ed:	55                   	push   %rbp
  8036ee:	48 89 e5             	mov    %rsp,%rbp
  8036f1:	48 83 ec 0c          	sub    $0xc,%rsp
  8036f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036f9:	89 f0                	mov    %esi,%eax
  8036fb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8036fe:	eb 17                	jmp    803717 <strchr+0x2a>
		if (*s == c)
  803700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803704:	0f b6 00             	movzbl (%rax),%eax
  803707:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80370a:	75 06                	jne    803712 <strchr+0x25>
			return (char *) s;
  80370c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803710:	eb 15                	jmp    803727 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803712:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371b:	0f b6 00             	movzbl (%rax),%eax
  80371e:	84 c0                	test   %al,%al
  803720:	75 de                	jne    803700 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803727:	c9                   	leaveq 
  803728:	c3                   	retq   

0000000000803729 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803729:	55                   	push   %rbp
  80372a:	48 89 e5             	mov    %rsp,%rbp
  80372d:	48 83 ec 0c          	sub    $0xc,%rsp
  803731:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803735:	89 f0                	mov    %esi,%eax
  803737:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80373a:	eb 13                	jmp    80374f <strfind+0x26>
		if (*s == c)
  80373c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803740:	0f b6 00             	movzbl (%rax),%eax
  803743:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803746:	75 02                	jne    80374a <strfind+0x21>
			break;
  803748:	eb 10                	jmp    80375a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80374a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80374f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803753:	0f b6 00             	movzbl (%rax),%eax
  803756:	84 c0                	test   %al,%al
  803758:	75 e2                	jne    80373c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80375a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80375e:	c9                   	leaveq 
  80375f:	c3                   	retq   

0000000000803760 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803760:	55                   	push   %rbp
  803761:	48 89 e5             	mov    %rsp,%rbp
  803764:	48 83 ec 18          	sub    $0x18,%rsp
  803768:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80376c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80376f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803773:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803778:	75 06                	jne    803780 <memset+0x20>
		return v;
  80377a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377e:	eb 69                	jmp    8037e9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803784:	83 e0 03             	and    $0x3,%eax
  803787:	48 85 c0             	test   %rax,%rax
  80378a:	75 48                	jne    8037d4 <memset+0x74>
  80378c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803790:	83 e0 03             	and    $0x3,%eax
  803793:	48 85 c0             	test   %rax,%rax
  803796:	75 3c                	jne    8037d4 <memset+0x74>
		c &= 0xFF;
  803798:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80379f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037a2:	c1 e0 18             	shl    $0x18,%eax
  8037a5:	89 c2                	mov    %eax,%edx
  8037a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037aa:	c1 e0 10             	shl    $0x10,%eax
  8037ad:	09 c2                	or     %eax,%edx
  8037af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b2:	c1 e0 08             	shl    $0x8,%eax
  8037b5:	09 d0                	or     %edx,%eax
  8037b7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8037ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037be:	48 c1 e8 02          	shr    $0x2,%rax
  8037c2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8037c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037cc:	48 89 d7             	mov    %rdx,%rdi
  8037cf:	fc                   	cld    
  8037d0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8037d2:	eb 11                	jmp    8037e5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8037d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037df:	48 89 d7             	mov    %rdx,%rdi
  8037e2:	fc                   	cld    
  8037e3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8037e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e9:	c9                   	leaveq 
  8037ea:	c3                   	retq   

00000000008037eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8037eb:	55                   	push   %rbp
  8037ec:	48 89 e5             	mov    %rsp,%rbp
  8037ef:	48 83 ec 28          	sub    $0x28,%rsp
  8037f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8037ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803803:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80380f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803813:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803817:	0f 83 88 00 00 00    	jae    8038a5 <memmove+0xba>
  80381d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803821:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803825:	48 01 d0             	add    %rdx,%rax
  803828:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80382c:	76 77                	jbe    8038a5 <memmove+0xba>
		s += n;
  80382e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803832:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80383e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803842:	83 e0 03             	and    $0x3,%eax
  803845:	48 85 c0             	test   %rax,%rax
  803848:	75 3b                	jne    803885 <memmove+0x9a>
  80384a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384e:	83 e0 03             	and    $0x3,%eax
  803851:	48 85 c0             	test   %rax,%rax
  803854:	75 2f                	jne    803885 <memmove+0x9a>
  803856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385a:	83 e0 03             	and    $0x3,%eax
  80385d:	48 85 c0             	test   %rax,%rax
  803860:	75 23                	jne    803885 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803866:	48 83 e8 04          	sub    $0x4,%rax
  80386a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80386e:	48 83 ea 04          	sub    $0x4,%rdx
  803872:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803876:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80387a:	48 89 c7             	mov    %rax,%rdi
  80387d:	48 89 d6             	mov    %rdx,%rsi
  803880:	fd                   	std    
  803881:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803883:	eb 1d                	jmp    8038a2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  803885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803889:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80388d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803891:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803895:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803899:	48 89 d7             	mov    %rdx,%rdi
  80389c:	48 89 c1             	mov    %rax,%rcx
  80389f:	fd                   	std    
  8038a0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8038a2:	fc                   	cld    
  8038a3:	eb 57                	jmp    8038fc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8038a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a9:	83 e0 03             	and    $0x3,%eax
  8038ac:	48 85 c0             	test   %rax,%rax
  8038af:	75 36                	jne    8038e7 <memmove+0xfc>
  8038b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b5:	83 e0 03             	and    $0x3,%eax
  8038b8:	48 85 c0             	test   %rax,%rax
  8038bb:	75 2a                	jne    8038e7 <memmove+0xfc>
  8038bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c1:	83 e0 03             	and    $0x3,%eax
  8038c4:	48 85 c0             	test   %rax,%rax
  8038c7:	75 1e                	jne    8038e7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8038c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cd:	48 c1 e8 02          	shr    $0x2,%rax
  8038d1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8038d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 89 d6             	mov    %rdx,%rsi
  8038e2:	fc                   	cld    
  8038e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038e5:	eb 15                	jmp    8038fc <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8038e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038f3:	48 89 c7             	mov    %rax,%rdi
  8038f6:	48 89 d6             	mov    %rdx,%rsi
  8038f9:	fc                   	cld    
  8038fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8038fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803900:	c9                   	leaveq 
  803901:	c3                   	retq   

0000000000803902 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803902:	55                   	push   %rbp
  803903:	48 89 e5             	mov    %rsp,%rbp
  803906:	48 83 ec 18          	sub    $0x18,%rsp
  80390a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80390e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803912:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803916:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80391a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80391e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803922:	48 89 ce             	mov    %rcx,%rsi
  803925:	48 89 c7             	mov    %rax,%rdi
  803928:	48 b8 eb 37 80 00 00 	movabs $0x8037eb,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
}
  803934:	c9                   	leaveq 
  803935:	c3                   	retq   

0000000000803936 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803936:	55                   	push   %rbp
  803937:	48 89 e5             	mov    %rsp,%rbp
  80393a:	48 83 ec 28          	sub    $0x28,%rsp
  80393e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803942:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803946:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80394a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803952:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803956:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80395a:	eb 36                	jmp    803992 <memcmp+0x5c>
		if (*s1 != *s2)
  80395c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803960:	0f b6 10             	movzbl (%rax),%edx
  803963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803967:	0f b6 00             	movzbl (%rax),%eax
  80396a:	38 c2                	cmp    %al,%dl
  80396c:	74 1a                	je     803988 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80396e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803972:	0f b6 00             	movzbl (%rax),%eax
  803975:	0f b6 d0             	movzbl %al,%edx
  803978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397c:	0f b6 00             	movzbl (%rax),%eax
  80397f:	0f b6 c0             	movzbl %al,%eax
  803982:	29 c2                	sub    %eax,%edx
  803984:	89 d0                	mov    %edx,%eax
  803986:	eb 20                	jmp    8039a8 <memcmp+0x72>
		s1++, s2++;
  803988:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80398d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803996:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80399a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80399e:	48 85 c0             	test   %rax,%rax
  8039a1:	75 b9                	jne    80395c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8039a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039a8:	c9                   	leaveq 
  8039a9:	c3                   	retq   

00000000008039aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8039aa:	55                   	push   %rbp
  8039ab:	48 89 e5             	mov    %rsp,%rbp
  8039ae:	48 83 ec 28          	sub    $0x28,%rsp
  8039b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8039b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8039bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c5:	48 01 d0             	add    %rdx,%rax
  8039c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8039cc:	eb 15                	jmp    8039e3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8039ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d2:	0f b6 10             	movzbl (%rax),%edx
  8039d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8039d8:	38 c2                	cmp    %al,%dl
  8039da:	75 02                	jne    8039de <memfind+0x34>
			break;
  8039dc:	eb 0f                	jmp    8039ed <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8039de:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8039e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8039eb:	72 e1                	jb     8039ce <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8039ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 83 ec 34          	sub    $0x34,%rsp
  8039fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a03:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803a0d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803a14:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a15:	eb 05                	jmp    803a1c <strtol+0x29>
		s++;
  803a17:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a20:	0f b6 00             	movzbl (%rax),%eax
  803a23:	3c 20                	cmp    $0x20,%al
  803a25:	74 f0                	je     803a17 <strtol+0x24>
  803a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2b:	0f b6 00             	movzbl (%rax),%eax
  803a2e:	3c 09                	cmp    $0x9,%al
  803a30:	74 e5                	je     803a17 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a36:	0f b6 00             	movzbl (%rax),%eax
  803a39:	3c 2b                	cmp    $0x2b,%al
  803a3b:	75 07                	jne    803a44 <strtol+0x51>
		s++;
  803a3d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a42:	eb 17                	jmp    803a5b <strtol+0x68>
	else if (*s == '-')
  803a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a48:	0f b6 00             	movzbl (%rax),%eax
  803a4b:	3c 2d                	cmp    $0x2d,%al
  803a4d:	75 0c                	jne    803a5b <strtol+0x68>
		s++, neg = 1;
  803a4f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803a5b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a5f:	74 06                	je     803a67 <strtol+0x74>
  803a61:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803a65:	75 28                	jne    803a8f <strtol+0x9c>
  803a67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6b:	0f b6 00             	movzbl (%rax),%eax
  803a6e:	3c 30                	cmp    $0x30,%al
  803a70:	75 1d                	jne    803a8f <strtol+0x9c>
  803a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a76:	48 83 c0 01          	add    $0x1,%rax
  803a7a:	0f b6 00             	movzbl (%rax),%eax
  803a7d:	3c 78                	cmp    $0x78,%al
  803a7f:	75 0e                	jne    803a8f <strtol+0x9c>
		s += 2, base = 16;
  803a81:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803a86:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803a8d:	eb 2c                	jmp    803abb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803a8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a93:	75 19                	jne    803aae <strtol+0xbb>
  803a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a99:	0f b6 00             	movzbl (%rax),%eax
  803a9c:	3c 30                	cmp    $0x30,%al
  803a9e:	75 0e                	jne    803aae <strtol+0xbb>
		s++, base = 8;
  803aa0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803aa5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803aac:	eb 0d                	jmp    803abb <strtol+0xc8>
	else if (base == 0)
  803aae:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803ab2:	75 07                	jne    803abb <strtol+0xc8>
		base = 10;
  803ab4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803abf:	0f b6 00             	movzbl (%rax),%eax
  803ac2:	3c 2f                	cmp    $0x2f,%al
  803ac4:	7e 1d                	jle    803ae3 <strtol+0xf0>
  803ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aca:	0f b6 00             	movzbl (%rax),%eax
  803acd:	3c 39                	cmp    $0x39,%al
  803acf:	7f 12                	jg     803ae3 <strtol+0xf0>
			dig = *s - '0';
  803ad1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad5:	0f b6 00             	movzbl (%rax),%eax
  803ad8:	0f be c0             	movsbl %al,%eax
  803adb:	83 e8 30             	sub    $0x30,%eax
  803ade:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ae1:	eb 4e                	jmp    803b31 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803ae3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae7:	0f b6 00             	movzbl (%rax),%eax
  803aea:	3c 60                	cmp    $0x60,%al
  803aec:	7e 1d                	jle    803b0b <strtol+0x118>
  803aee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af2:	0f b6 00             	movzbl (%rax),%eax
  803af5:	3c 7a                	cmp    $0x7a,%al
  803af7:	7f 12                	jg     803b0b <strtol+0x118>
			dig = *s - 'a' + 10;
  803af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afd:	0f b6 00             	movzbl (%rax),%eax
  803b00:	0f be c0             	movsbl %al,%eax
  803b03:	83 e8 57             	sub    $0x57,%eax
  803b06:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b09:	eb 26                	jmp    803b31 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0f:	0f b6 00             	movzbl (%rax),%eax
  803b12:	3c 40                	cmp    $0x40,%al
  803b14:	7e 48                	jle    803b5e <strtol+0x16b>
  803b16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1a:	0f b6 00             	movzbl (%rax),%eax
  803b1d:	3c 5a                	cmp    $0x5a,%al
  803b1f:	7f 3d                	jg     803b5e <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b25:	0f b6 00             	movzbl (%rax),%eax
  803b28:	0f be c0             	movsbl %al,%eax
  803b2b:	83 e8 37             	sub    $0x37,%eax
  803b2e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803b31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b34:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803b37:	7c 02                	jl     803b3b <strtol+0x148>
			break;
  803b39:	eb 23                	jmp    803b5e <strtol+0x16b>
		s++, val = (val * base) + dig;
  803b3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b40:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b43:	48 98                	cltq   
  803b45:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803b4a:	48 89 c2             	mov    %rax,%rdx
  803b4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b50:	48 98                	cltq   
  803b52:	48 01 d0             	add    %rdx,%rax
  803b55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803b59:	e9 5d ff ff ff       	jmpq   803abb <strtol+0xc8>

	if (endptr)
  803b5e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803b63:	74 0b                	je     803b70 <strtol+0x17d>
		*endptr = (char *) s;
  803b65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b6d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b74:	74 09                	je     803b7f <strtol+0x18c>
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	48 f7 d8             	neg    %rax
  803b7d:	eb 04                	jmp    803b83 <strtol+0x190>
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803b83:	c9                   	leaveq 
  803b84:	c3                   	retq   

0000000000803b85 <strstr>:

char * strstr(const char *in, const char *str)
{
  803b85:	55                   	push   %rbp
  803b86:	48 89 e5             	mov    %rsp,%rbp
  803b89:	48 83 ec 30          	sub    $0x30,%rsp
  803b8d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803b95:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b9d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803ba1:	0f b6 00             	movzbl (%rax),%eax
  803ba4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803ba7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803bab:	75 06                	jne    803bb3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803bad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb1:	eb 6b                	jmp    803c1e <strstr+0x99>

	len = strlen(str);
  803bb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb7:	48 89 c7             	mov    %rax,%rdi
  803bba:	48 b8 5b 34 80 00 00 	movabs $0x80345b,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
  803bc6:	48 98                	cltq   
  803bc8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803bcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bd4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803bd8:	0f b6 00             	movzbl (%rax),%eax
  803bdb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803bde:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803be2:	75 07                	jne    803beb <strstr+0x66>
				return (char *) 0;
  803be4:	b8 00 00 00 00       	mov    $0x0,%eax
  803be9:	eb 33                	jmp    803c1e <strstr+0x99>
		} while (sc != c);
  803beb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803bef:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803bf2:	75 d8                	jne    803bcc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803bf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bf8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803bfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c00:	48 89 ce             	mov    %rcx,%rsi
  803c03:	48 89 c7             	mov    %rax,%rdi
  803c06:	48 b8 7c 36 80 00 00 	movabs $0x80367c,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
  803c12:	85 c0                	test   %eax,%eax
  803c14:	75 b6                	jne    803bcc <strstr+0x47>

	return (char *) (in - 1);
  803c16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1a:	48 83 e8 01          	sub    $0x1,%rax
}
  803c1e:	c9                   	leaveq 
  803c1f:	c3                   	retq   

0000000000803c20 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c20:	55                   	push   %rbp
  803c21:	48 89 e5             	mov    %rsp,%rbp
  803c24:	48 83 ec 30          	sub    $0x30,%rsp
  803c28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c3b:	00 00 00 
  803c3e:	48 8b 00             	mov    (%rax),%rax
  803c41:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c47:	85 c0                	test   %eax,%eax
  803c49:	75 3c                	jne    803c87 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c4b:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
  803c57:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c5c:	48 63 d0             	movslq %eax,%rdx
  803c5f:	48 89 d0             	mov    %rdx,%rax
  803c62:	48 c1 e0 03          	shl    $0x3,%rax
  803c66:	48 01 d0             	add    %rdx,%rax
  803c69:	48 c1 e0 05          	shl    $0x5,%rax
  803c6d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c74:	00 00 00 
  803c77:	48 01 c2             	add    %rax,%rdx
  803c7a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c81:	00 00 00 
  803c84:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c87:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c8c:	75 0e                	jne    803c9c <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c8e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c95:	00 00 00 
  803c98:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ca0:	48 89 c7             	mov    %rax,%rdi
  803ca3:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803cb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb6:	79 19                	jns    803cd1 <ipc_recv+0xb1>
		*from_env_store = 0;
  803cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803cc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccf:	eb 53                	jmp    803d24 <ipc_recv+0x104>
	}
	if(from_env_store)
  803cd1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cd6:	74 19                	je     803cf1 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803cd8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cdf:	00 00 00 
  803ce2:	48 8b 00             	mov    (%rax),%rax
  803ce5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cef:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cf1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cf6:	74 19                	je     803d11 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cf8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cff:	00 00 00 
  803d02:	48 8b 00             	mov    (%rax),%rax
  803d05:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d11:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d18:	00 00 00 
  803d1b:	48 8b 00             	mov    (%rax),%rax
  803d1e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d24:	c9                   	leaveq 
  803d25:	c3                   	retq   

0000000000803d26 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d26:	55                   	push   %rbp
  803d27:	48 89 e5             	mov    %rsp,%rbp
  803d2a:	48 83 ec 30          	sub    $0x30,%rsp
  803d2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d31:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d34:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d38:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d3b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d40:	75 0e                	jne    803d50 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d42:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d49:	00 00 00 
  803d4c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d50:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d53:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5d:	89 c7                	mov    %eax,%edi
  803d5f:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
  803d6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d6e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d72:	75 0c                	jne    803d80 <ipc_send+0x5a>
			sys_yield();
  803d74:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d80:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d84:	74 ca                	je     803d50 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d86:	c9                   	leaveq 
  803d87:	c3                   	retq   

0000000000803d88 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d88:	55                   	push   %rbp
  803d89:	48 89 e5             	mov    %rsp,%rbp
  803d8c:	48 83 ec 14          	sub    $0x14,%rsp
  803d90:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d9a:	eb 5e                	jmp    803dfa <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d9c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803da3:	00 00 00 
  803da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da9:	48 63 d0             	movslq %eax,%rdx
  803dac:	48 89 d0             	mov    %rdx,%rax
  803daf:	48 c1 e0 03          	shl    $0x3,%rax
  803db3:	48 01 d0             	add    %rdx,%rax
  803db6:	48 c1 e0 05          	shl    $0x5,%rax
  803dba:	48 01 c8             	add    %rcx,%rax
  803dbd:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dc3:	8b 00                	mov    (%rax),%eax
  803dc5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dc8:	75 2c                	jne    803df6 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dca:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dd1:	00 00 00 
  803dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd7:	48 63 d0             	movslq %eax,%rdx
  803dda:	48 89 d0             	mov    %rdx,%rax
  803ddd:	48 c1 e0 03          	shl    $0x3,%rax
  803de1:	48 01 d0             	add    %rdx,%rax
  803de4:	48 c1 e0 05          	shl    $0x5,%rax
  803de8:	48 01 c8             	add    %rcx,%rax
  803deb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803df1:	8b 40 08             	mov    0x8(%rax),%eax
  803df4:	eb 12                	jmp    803e08 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803df6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dfa:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e01:	7e 99                	jle    803d9c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e08:	c9                   	leaveq 
  803e09:	c3                   	retq   

0000000000803e0a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e0a:	55                   	push   %rbp
  803e0b:	48 89 e5             	mov    %rsp,%rbp
  803e0e:	48 83 ec 18          	sub    $0x18,%rsp
  803e12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1a:	48 c1 e8 15          	shr    $0x15,%rax
  803e1e:	48 89 c2             	mov    %rax,%rdx
  803e21:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e28:	01 00 00 
  803e2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e2f:	83 e0 01             	and    $0x1,%eax
  803e32:	48 85 c0             	test   %rax,%rax
  803e35:	75 07                	jne    803e3e <pageref+0x34>
		return 0;
  803e37:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3c:	eb 53                	jmp    803e91 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e42:	48 c1 e8 0c          	shr    $0xc,%rax
  803e46:	48 89 c2             	mov    %rax,%rdx
  803e49:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e50:	01 00 00 
  803e53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e5f:	83 e0 01             	and    $0x1,%eax
  803e62:	48 85 c0             	test   %rax,%rax
  803e65:	75 07                	jne    803e6e <pageref+0x64>
		return 0;
  803e67:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6c:	eb 23                	jmp    803e91 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e72:	48 c1 e8 0c          	shr    $0xc,%rax
  803e76:	48 89 c2             	mov    %rax,%rdx
  803e79:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e80:	00 00 00 
  803e83:	48 c1 e2 04          	shl    $0x4,%rdx
  803e87:	48 01 d0             	add    %rdx,%rax
  803e8a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e8e:	0f b7 c0             	movzwl %ax,%eax
}
  803e91:	c9                   	leaveq 
  803e92:	c3                   	retq   
