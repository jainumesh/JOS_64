
obj/user/testpiperace.debug:     file format elf64-x86-64


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
  80003c:	e8 4c 03 00 00       	callq  80038d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 ae 3f 80 00 00 	movabs $0x803fae,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 99 49 80 00 00 	movabs $0x804999,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba b6 49 80 00 00 	movabs $0x8049b6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 77 42 80 00 00 	movabs $0x804277,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf bf 49 80 00 00 	movabs $0x8049bf,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 2b 25 80 00 00 	movabs $0x80252b,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf da 49 80 00 00 	movabs $0x8049da,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 63 d0             	movslq %eax,%rdx
  8001d1:	48 89 d0             	mov    %rdx,%rax
  8001d4:	48 c1 e0 03          	shl    $0x3,%rax
  8001d8:	48 01 d0             	add    %rdx,%rax
  8001db:	48 c1 e0 05          	shl    $0x5,%rax
  8001df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e6:	00 00 00 
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 29 c2             	sub    %rax,%rdx
  800201:	48 89 d0             	mov    %rdx,%rax
  800204:	48 c1 f8 05          	sar    $0x5,%rax
  800208:	48 89 c2             	mov    %rax,%rdx
  80020b:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  800212:	e3 38 8e 
  800215:	48 0f af c2          	imul   %rdx,%rax
  800219:	48 89 c6             	mov    %rax,%rsi
  80021c:	48 bf e5 49 80 00 00 	movabs $0x8049e5,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 84 2a 80 00 00 	movabs $0x802a84,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800269:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80026f:	83 f8 02             	cmp    $0x2,%eax
  800272:	74 db                	je     80024f <umain+0x20c>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800274:	48 bf f0 49 80 00 00 	movabs $0x8049f0,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 77 42 80 00 00 	movabs $0x804277,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  8002ba:	00 00 00 
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8002c9:	00 00 00 
  8002cc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002d5:	48 89 d6             	mov    %rdx,%rsi
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba 32 4a 80 00 00 	movabs $0x804a32,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf a2 49 80 00 00 	movabs $0x8049a2,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf 4a 4a 80 00 00 	movabs $0x804a4a,%rdi
  800355:	00 00 00 
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800364:	00 00 00 
  800367:	ff d2                	callq  *%rdx
  800369:	eb 20                	jmp    80038b <umain+0x348>
	else
		cprintf("\nrace didn't happen\n", max);
  80036b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80036e:	89 c6                	mov    %eax,%esi
  800370:	48 bf 60 4a 80 00 00 	movabs $0x804a60,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800386:	00 00 00 
  800389:	ff d2                	callq  *%rdx
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 10          	sub    $0x10,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80039c:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003ad:	48 63 d0             	movslq %eax,%rdx
  8003b0:	48 89 d0             	mov    %rdx,%rax
  8003b3:	48 c1 e0 03          	shl    $0x3,%rax
  8003b7:	48 01 d0             	add    %rdx,%rax
  8003ba:	48 c1 e0 05          	shl    $0x5,%rax
  8003be:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003c5:	00 00 00 
  8003c8:	48 01 c2             	add    %rax,%rdx
  8003cb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8003d2:	00 00 00 
  8003d5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003dc:	7e 14                	jle    8003f2 <libmain+0x65>
		binaryname = argv[0];
  8003de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e2:	48 8b 10             	mov    (%rax),%rdx
  8003e5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003ec:	00 00 00 
  8003ef:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f9:	48 89 d6             	mov    %rdx,%rsi
  8003fc:	89 c7                	mov    %eax,%edi
  8003fe:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800405:	00 00 00 
  800408:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80040a:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
}
  800416:	c9                   	leaveq 
  800417:	c3                   	retq   

0000000000800418 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800418:	55                   	push   %rbp
  800419:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80041c:	48 b8 56 2a 80 00 00 	movabs $0x802a56,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800428:	bf 00 00 00 00       	mov    $0x0,%edi
  80042d:	48 b8 98 1a 80 00 00 	movabs $0x801a98,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax

}
  800439:	5d                   	pop    %rbp
  80043a:	c3                   	retq   

000000000080043b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	53                   	push   %rbx
  800440:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800447:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80044e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800454:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80045b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800462:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800469:	84 c0                	test   %al,%al
  80046b:	74 23                	je     800490 <_panic+0x55>
  80046d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800474:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800478:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80047c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800480:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800484:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800488:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80048c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800490:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800497:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80049e:	00 00 00 
  8004a1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004a8:	00 00 00 
  8004ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004af:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004b6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004bd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8004cb:	00 00 00 
  8004ce:	48 8b 18             	mov    (%rax),%rbx
  8004d1:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ea:	41 89 c8             	mov    %ecx,%r8d
  8004ed:	48 89 d1             	mov    %rdx,%rcx
  8004f0:	48 89 da             	mov    %rbx,%rdx
  8004f3:	89 c6                	mov    %eax,%esi
  8004f5:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  8004fc:	00 00 00 
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	49 b9 74 06 80 00 00 	movabs $0x800674,%r9
  80050b:	00 00 00 
  80050e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800511:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800518:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80051f:	48 89 d6             	mov    %rdx,%rsi
  800522:	48 89 c7             	mov    %rax,%rdi
  800525:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  80052c:	00 00 00 
  80052f:	ff d0                	callq  *%rax
	cprintf("\n");
  800531:	48 bf a3 4a 80 00 00 	movabs $0x804aa3,%rdi
  800538:	00 00 00 
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  800547:	00 00 00 
  80054a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80054c:	cc                   	int3   
  80054d:	eb fd                	jmp    80054c <_panic+0x111>

000000000080054f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80054f:	55                   	push   %rbp
  800550:	48 89 e5             	mov    %rsp,%rbp
  800553:	48 83 ec 10          	sub    $0x10,%rsp
  800557:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80055a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	8d 48 01             	lea    0x1(%rax),%ecx
  800567:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056b:	89 0a                	mov    %ecx,(%rdx)
  80056d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800570:	89 d1                	mov    %edx,%ecx
  800572:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800576:	48 98                	cltq   
  800578:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80057c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058d:	8b 00                	mov    (%rax),%eax
  80058f:	48 98                	cltq   
  800591:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800595:	48 83 c2 08          	add    $0x8,%rdx
  800599:	48 89 c6             	mov    %rax,%rsi
  80059c:	48 89 d7             	mov    %rdx,%rdi
  80059f:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
        b->idx = 0;
  8005ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b9:	8b 40 04             	mov    0x4(%rax),%eax
  8005bc:	8d 50 01             	lea    0x1(%rax),%edx
  8005bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005c6:	c9                   	leaveq 
  8005c7:	c3                   	retq   

00000000008005c8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005c8:	55                   	push   %rbp
  8005c9:	48 89 e5             	mov    %rsp,%rbp
  8005cc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005da:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005e1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005e8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ef:	48 8b 0a             	mov    (%rdx),%rcx
  8005f2:	48 89 08             	mov    %rcx,(%rax)
  8005f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800601:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800605:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80060c:	00 00 00 
    b.cnt = 0;
  80060f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800616:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800619:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800620:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800627:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80062e:	48 89 c6             	mov    %rax,%rsi
  800631:	48 bf 4f 05 80 00 00 	movabs $0x80054f,%rdi
  800638:	00 00 00 
  80063b:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  800642:	00 00 00 
  800645:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800647:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80064d:	48 98                	cltq   
  80064f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800656:	48 83 c2 08          	add    $0x8,%rdx
  80065a:	48 89 c6             	mov    %rax,%rsi
  80065d:	48 89 d7             	mov    %rdx,%rdi
  800660:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  800667:	00 00 00 
  80066a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80066c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800672:	c9                   	leaveq 
  800673:	c3                   	retq   

0000000000800674 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800674:	55                   	push   %rbp
  800675:	48 89 e5             	mov    %rsp,%rbp
  800678:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80067f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800686:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80068d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800694:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80069b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a2:	84 c0                	test   %al,%al
  8006a4:	74 20                	je     8006c6 <cprintf+0x52>
  8006a6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006aa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006ae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006b6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006ba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006be:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006c6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006cd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d4:	00 00 00 
  8006d7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006de:	00 00 00 
  8006e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006fa:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800701:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800708:	48 8b 0a             	mov    (%rdx),%rcx
  80070b:	48 89 08             	mov    %rcx,(%rax)
  80070e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800712:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800716:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80071e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800725:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80072c:	48 89 d6             	mov    %rdx,%rsi
  80072f:	48 89 c7             	mov    %rax,%rdi
  800732:	48 b8 c8 05 80 00 00 	movabs $0x8005c8,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax
  80073e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800744:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80074a:	c9                   	leaveq 
  80074b:	c3                   	retq   

000000000080074c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80074c:	55                   	push   %rbp
  80074d:	48 89 e5             	mov    %rsp,%rbp
  800750:	53                   	push   %rbx
  800751:	48 83 ec 38          	sub    $0x38,%rsp
  800755:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800759:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80075d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800761:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800764:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800768:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80076c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80076f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800773:	77 3b                	ja     8007b0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800775:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800778:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80077c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80077f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	48 f7 f3             	div    %rbx
  80078b:	48 89 c2             	mov    %rax,%rdx
  80078e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800791:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800794:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	41 89 f9             	mov    %edi,%r9d
  80079f:	48 89 c7             	mov    %rax,%rdi
  8007a2:	48 b8 4c 07 80 00 00 	movabs $0x80074c,%rax
  8007a9:	00 00 00 
  8007ac:	ff d0                	callq  *%rax
  8007ae:	eb 1e                	jmp    8007ce <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b0:	eb 12                	jmp    8007c4 <printnum+0x78>
			putch(padc, putdat);
  8007b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007b6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 89 ce             	mov    %rcx,%rsi
  8007c0:	89 d7                	mov    %edx,%edi
  8007c2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007cc:	7f e4                	jg     8007b2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ce:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007da:	48 f7 f1             	div    %rcx
  8007dd:	48 89 d0             	mov    %rdx,%rax
  8007e0:	48 ba b0 4c 80 00 00 	movabs $0x804cb0,%rdx
  8007e7:	00 00 00 
  8007ea:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007ee:	0f be d0             	movsbl %al,%edx
  8007f1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f9:	48 89 ce             	mov    %rcx,%rsi
  8007fc:	89 d7                	mov    %edx,%edi
  8007fe:	ff d0                	callq  *%rax
}
  800800:	48 83 c4 38          	add    $0x38,%rsp
  800804:	5b                   	pop    %rbx
  800805:	5d                   	pop    %rbp
  800806:	c3                   	retq   

0000000000800807 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80080f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800813:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800816:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80081a:	7e 52                	jle    80086e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	8b 00                	mov    (%rax),%eax
  800822:	83 f8 30             	cmp    $0x30,%eax
  800825:	73 24                	jae    80084b <getuint+0x44>
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	8b 00                	mov    (%rax),%eax
  800835:	89 c0                	mov    %eax,%eax
  800837:	48 01 d0             	add    %rdx,%rax
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	8b 12                	mov    (%rdx),%edx
  800840:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800847:	89 0a                	mov    %ecx,(%rdx)
  800849:	eb 17                	jmp    800862 <getuint+0x5b>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800853:	48 89 d0             	mov    %rdx,%rax
  800856:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800862:	48 8b 00             	mov    (%rax),%rax
  800865:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800869:	e9 a3 00 00 00       	jmpq   800911 <getuint+0x10a>
	else if (lflag)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800872:	74 4f                	je     8008c3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	83 f8 30             	cmp    $0x30,%eax
  80087d:	73 24                	jae    8008a3 <getuint+0x9c>
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	8b 00                	mov    (%rax),%eax
  80088d:	89 c0                	mov    %eax,%eax
  80088f:	48 01 d0             	add    %rdx,%rax
  800892:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800896:	8b 12                	mov    (%rdx),%edx
  800898:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089f:	89 0a                	mov    %ecx,(%rdx)
  8008a1:	eb 17                	jmp    8008ba <getuint+0xb3>
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ab:	48 89 d0             	mov    %rdx,%rax
  8008ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ba:	48 8b 00             	mov    (%rax),%rax
  8008bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c1:	eb 4e                	jmp    800911 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	8b 00                	mov    (%rax),%eax
  8008c9:	83 f8 30             	cmp    $0x30,%eax
  8008cc:	73 24                	jae    8008f2 <getuint+0xeb>
  8008ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	89 c0                	mov    %eax,%eax
  8008de:	48 01 d0             	add    %rdx,%rax
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	8b 12                	mov    (%rdx),%edx
  8008e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ee:	89 0a                	mov    %ecx,(%rdx)
  8008f0:	eb 17                	jmp    800909 <getuint+0x102>
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fa:	48 89 d0             	mov    %rdx,%rax
  8008fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800905:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800909:	8b 00                	mov    (%rax),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800911:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800915:	c9                   	leaveq 
  800916:	c3                   	retq   

0000000000800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %rbp
  800918:	48 89 e5             	mov    %rsp,%rbp
  80091b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80091f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800923:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800926:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80092a:	7e 52                	jle    80097e <getint+0x67>
		x=va_arg(*ap, long long);
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	8b 00                	mov    (%rax),%eax
  800932:	83 f8 30             	cmp    $0x30,%eax
  800935:	73 24                	jae    80095b <getint+0x44>
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	8b 00                	mov    (%rax),%eax
  800945:	89 c0                	mov    %eax,%eax
  800947:	48 01 d0             	add    %rdx,%rax
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	8b 12                	mov    (%rdx),%edx
  800950:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800957:	89 0a                	mov    %ecx,(%rdx)
  800959:	eb 17                	jmp    800972 <getint+0x5b>
  80095b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800963:	48 89 d0             	mov    %rdx,%rax
  800966:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800972:	48 8b 00             	mov    (%rax),%rax
  800975:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800979:	e9 a3 00 00 00       	jmpq   800a21 <getint+0x10a>
	else if (lflag)
  80097e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800982:	74 4f                	je     8009d3 <getint+0xbc>
		x=va_arg(*ap, long);
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	83 f8 30             	cmp    $0x30,%eax
  80098d:	73 24                	jae    8009b3 <getint+0x9c>
  80098f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800993:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099b:	8b 00                	mov    (%rax),%eax
  80099d:	89 c0                	mov    %eax,%eax
  80099f:	48 01 d0             	add    %rdx,%rax
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	8b 12                	mov    (%rdx),%edx
  8009a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	89 0a                	mov    %ecx,(%rdx)
  8009b1:	eb 17                	jmp    8009ca <getint+0xb3>
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bb:	48 89 d0             	mov    %rdx,%rax
  8009be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ca:	48 8b 00             	mov    (%rax),%rax
  8009cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d1:	eb 4e                	jmp    800a21 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 24                	jae    800a02 <getint+0xeb>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	8b 12                	mov    (%rdx),%edx
  8009f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 0a                	mov    %ecx,(%rdx)
  800a00:	eb 17                	jmp    800a19 <getint+0x102>
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0a:	48 89 d0             	mov    %rdx,%rax
  800a0d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	48 98                	cltq   
  800a1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a25:	c9                   	leaveq 
  800a26:	c3                   	retq   

0000000000800a27 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a27:	55                   	push   %rbp
  800a28:	48 89 e5             	mov    %rsp,%rbp
  800a2b:	41 54                	push   %r12
  800a2d:	53                   	push   %rbx
  800a2e:	48 83 ec 60          	sub    $0x60,%rsp
  800a32:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a36:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a3a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a42:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a46:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a4a:	48 8b 0a             	mov    (%rdx),%rcx
  800a4d:	48 89 08             	mov    %rcx,(%rax)
  800a50:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a54:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a58:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a5c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a60:	eb 17                	jmp    800a79 <vprintfmt+0x52>
			if (ch == '\0')
  800a62:	85 db                	test   %ebx,%ebx
  800a64:	0f 84 cc 04 00 00    	je     800f36 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 d6             	mov    %rdx,%rsi
  800a75:	89 df                	mov    %ebx,%edi
  800a77:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a79:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a81:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a85:	0f b6 00             	movzbl (%rax),%eax
  800a88:	0f b6 d8             	movzbl %al,%ebx
  800a8b:	83 fb 25             	cmp    $0x25,%ebx
  800a8e:	75 d2                	jne    800a62 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a90:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a94:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a9b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aa9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ab8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800abc:	0f b6 00             	movzbl (%rax),%eax
  800abf:	0f b6 d8             	movzbl %al,%ebx
  800ac2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ac5:	83 f8 55             	cmp    $0x55,%eax
  800ac8:	0f 87 34 04 00 00    	ja     800f02 <vprintfmt+0x4db>
  800ace:	89 c0                	mov    %eax,%eax
  800ad0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ad7:	00 
  800ad8:	48 b8 d8 4c 80 00 00 	movabs $0x804cd8,%rax
  800adf:	00 00 00 
  800ae2:	48 01 d0             	add    %rdx,%rax
  800ae5:	48 8b 00             	mov    (%rax),%rax
  800ae8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aee:	eb c0                	jmp    800ab0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800af4:	eb ba                	jmp    800ab0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800afd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b00:	89 d0                	mov    %edx,%eax
  800b02:	c1 e0 02             	shl    $0x2,%eax
  800b05:	01 d0                	add    %edx,%eax
  800b07:	01 c0                	add    %eax,%eax
  800b09:	01 d8                	add    %ebx,%eax
  800b0b:	83 e8 30             	sub    $0x30,%eax
  800b0e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b15:	0f b6 00             	movzbl (%rax),%eax
  800b18:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b1b:	83 fb 2f             	cmp    $0x2f,%ebx
  800b1e:	7e 0c                	jle    800b2c <vprintfmt+0x105>
  800b20:	83 fb 39             	cmp    $0x39,%ebx
  800b23:	7f 07                	jg     800b2c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b25:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b2a:	eb d1                	jmp    800afd <vprintfmt+0xd6>
			goto process_precision;
  800b2c:	eb 58                	jmp    800b86 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b31:	83 f8 30             	cmp    $0x30,%eax
  800b34:	73 17                	jae    800b4d <vprintfmt+0x126>
  800b36:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3d:	89 c0                	mov    %eax,%eax
  800b3f:	48 01 d0             	add    %rdx,%rax
  800b42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b45:	83 c2 08             	add    $0x8,%edx
  800b48:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4b:	eb 0f                	jmp    800b5c <vprintfmt+0x135>
  800b4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b51:	48 89 d0             	mov    %rdx,%rax
  800b54:	48 83 c2 08          	add    $0x8,%rdx
  800b58:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5c:	8b 00                	mov    (%rax),%eax
  800b5e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b61:	eb 23                	jmp    800b86 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b67:	79 0c                	jns    800b75 <vprintfmt+0x14e>
				width = 0;
  800b69:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b70:	e9 3b ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>
  800b75:	e9 36 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b7a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b81:	e9 2a ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b86:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8a:	79 12                	jns    800b9e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b8c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b8f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b92:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b99:	e9 12 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>
  800b9e:	e9 0d ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ba7:	e9 04 ff ff ff       	jmpq   800ab0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800baf:	83 f8 30             	cmp    $0x30,%eax
  800bb2:	73 17                	jae    800bcb <vprintfmt+0x1a4>
  800bb4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbb:	89 c0                	mov    %eax,%eax
  800bbd:	48 01 d0             	add    %rdx,%rax
  800bc0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc3:	83 c2 08             	add    $0x8,%edx
  800bc6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc9:	eb 0f                	jmp    800bda <vprintfmt+0x1b3>
  800bcb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bcf:	48 89 d0             	mov    %rdx,%rax
  800bd2:	48 83 c2 08          	add    $0x8,%rdx
  800bd6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bda:	8b 10                	mov    (%rax),%edx
  800bdc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be4:	48 89 ce             	mov    %rcx,%rsi
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	ff d0                	callq  *%rax
			break;
  800beb:	e9 40 03 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf3:	83 f8 30             	cmp    $0x30,%eax
  800bf6:	73 17                	jae    800c0f <vprintfmt+0x1e8>
  800bf8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bff:	89 c0                	mov    %eax,%eax
  800c01:	48 01 d0             	add    %rdx,%rax
  800c04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c07:	83 c2 08             	add    $0x8,%edx
  800c0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0d:	eb 0f                	jmp    800c1e <vprintfmt+0x1f7>
  800c0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c13:	48 89 d0             	mov    %rdx,%rax
  800c16:	48 83 c2 08          	add    $0x8,%rdx
  800c1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c20:	85 db                	test   %ebx,%ebx
  800c22:	79 02                	jns    800c26 <vprintfmt+0x1ff>
				err = -err;
  800c24:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c26:	83 fb 15             	cmp    $0x15,%ebx
  800c29:	7f 16                	jg     800c41 <vprintfmt+0x21a>
  800c2b:	48 b8 00 4c 80 00 00 	movabs $0x804c00,%rax
  800c32:	00 00 00 
  800c35:	48 63 d3             	movslq %ebx,%rdx
  800c38:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c3c:	4d 85 e4             	test   %r12,%r12
  800c3f:	75 2e                	jne    800c6f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c49:	89 d9                	mov    %ebx,%ecx
  800c4b:	48 ba c1 4c 80 00 00 	movabs $0x804cc1,%rdx
  800c52:	00 00 00 
  800c55:	48 89 c7             	mov    %rax,%rdi
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	49 b8 3f 0f 80 00 00 	movabs $0x800f3f,%r8
  800c64:	00 00 00 
  800c67:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c6a:	e9 c1 02 00 00       	jmpq   800f30 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c6f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	4c 89 e1             	mov    %r12,%rcx
  800c7a:	48 ba ca 4c 80 00 00 	movabs $0x804cca,%rdx
  800c81:	00 00 00 
  800c84:	48 89 c7             	mov    %rax,%rdi
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	49 b8 3f 0f 80 00 00 	movabs $0x800f3f,%r8
  800c93:	00 00 00 
  800c96:	41 ff d0             	callq  *%r8
			break;
  800c99:	e9 92 02 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca1:	83 f8 30             	cmp    $0x30,%eax
  800ca4:	73 17                	jae    800cbd <vprintfmt+0x296>
  800ca6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cad:	89 c0                	mov    %eax,%eax
  800caf:	48 01 d0             	add    %rdx,%rax
  800cb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb5:	83 c2 08             	add    $0x8,%edx
  800cb8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbb:	eb 0f                	jmp    800ccc <vprintfmt+0x2a5>
  800cbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc1:	48 89 d0             	mov    %rdx,%rax
  800cc4:	48 83 c2 08          	add    $0x8,%rdx
  800cc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccc:	4c 8b 20             	mov    (%rax),%r12
  800ccf:	4d 85 e4             	test   %r12,%r12
  800cd2:	75 0a                	jne    800cde <vprintfmt+0x2b7>
				p = "(null)";
  800cd4:	49 bc cd 4c 80 00 00 	movabs $0x804ccd,%r12
  800cdb:	00 00 00 
			if (width > 0 && padc != '-')
  800cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce2:	7e 3f                	jle    800d23 <vprintfmt+0x2fc>
  800ce4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ce8:	74 39                	je     800d23 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ced:	48 98                	cltq   
  800cef:	48 89 c6             	mov    %rax,%rsi
  800cf2:	4c 89 e7             	mov    %r12,%rdi
  800cf5:	48 b8 eb 11 80 00 00 	movabs $0x8011eb,%rax
  800cfc:	00 00 00 
  800cff:	ff d0                	callq  *%rax
  800d01:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d04:	eb 17                	jmp    800d1d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d06:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d0a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d12:	48 89 ce             	mov    %rcx,%rsi
  800d15:	89 d7                	mov    %edx,%edi
  800d17:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d19:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d21:	7f e3                	jg     800d06 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d23:	eb 37                	jmp    800d5c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d29:	74 1e                	je     800d49 <vprintfmt+0x322>
  800d2b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2e:	7e 05                	jle    800d35 <vprintfmt+0x30e>
  800d30:	83 fb 7e             	cmp    $0x7e,%ebx
  800d33:	7e 14                	jle    800d49 <vprintfmt+0x322>
					putch('?', putdat);
  800d35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3d:	48 89 d6             	mov    %rdx,%rsi
  800d40:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d45:	ff d0                	callq  *%rax
  800d47:	eb 0f                	jmp    800d58 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d51:	48 89 d6             	mov    %rdx,%rsi
  800d54:	89 df                	mov    %ebx,%edi
  800d56:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d58:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d5c:	4c 89 e0             	mov    %r12,%rax
  800d5f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d63:	0f b6 00             	movzbl (%rax),%eax
  800d66:	0f be d8             	movsbl %al,%ebx
  800d69:	85 db                	test   %ebx,%ebx
  800d6b:	74 10                	je     800d7d <vprintfmt+0x356>
  800d6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d71:	78 b2                	js     800d25 <vprintfmt+0x2fe>
  800d73:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d77:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d7b:	79 a8                	jns    800d25 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7d:	eb 16                	jmp    800d95 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d87:	48 89 d6             	mov    %rdx,%rsi
  800d8a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d8f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d91:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d99:	7f e4                	jg     800d7f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d9b:	e9 90 01 00 00       	jmpq   800f30 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800da0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da4:	be 03 00 00 00       	mov    $0x3,%esi
  800da9:	48 89 c7             	mov    %rax,%rdi
  800dac:	48 b8 17 09 80 00 00 	movabs $0x800917,%rax
  800db3:	00 00 00 
  800db6:	ff d0                	callq  *%rax
  800db8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc0:	48 85 c0             	test   %rax,%rax
  800dc3:	79 1d                	jns    800de2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800dc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcd:	48 89 d6             	mov    %rdx,%rsi
  800dd0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dd5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddb:	48 f7 d8             	neg    %rax
  800dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800de2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de9:	e9 d5 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df2:	be 03 00 00 00       	mov    $0x3,%esi
  800df7:	48 89 c7             	mov    %rax,%rdi
  800dfa:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	callq  *%rax
  800e06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e11:	e9 ad 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e16:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e1d:	89 d6                	mov    %edx,%esi
  800e1f:	48 89 c7             	mov    %rax,%rdi
  800e22:	48 b8 17 09 80 00 00 	movabs $0x800917,%rax
  800e29:	00 00 00 
  800e2c:	ff d0                	callq  *%rax
  800e2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e32:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e39:	e9 85 00 00 00       	jmpq   800ec3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e46:	48 89 d6             	mov    %rdx,%rsi
  800e49:	bf 30 00 00 00       	mov    $0x30,%edi
  800e4e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e58:	48 89 d6             	mov    %rdx,%rsi
  800e5b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e60:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e65:	83 f8 30             	cmp    $0x30,%eax
  800e68:	73 17                	jae    800e81 <vprintfmt+0x45a>
  800e6a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e71:	89 c0                	mov    %eax,%eax
  800e73:	48 01 d0             	add    %rdx,%rax
  800e76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e79:	83 c2 08             	add    $0x8,%edx
  800e7c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7f:	eb 0f                	jmp    800e90 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e81:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e85:	48 89 d0             	mov    %rdx,%rax
  800e88:	48 83 c2 08          	add    $0x8,%rdx
  800e8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e90:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e97:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e9e:	eb 23                	jmp    800ec3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ea0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea4:	be 03 00 00 00       	mov    $0x3,%esi
  800ea9:	48 89 c7             	mov    %rax,%rdi
  800eac:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
  800eb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ebc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ec8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ecb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ece:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eda:	45 89 c1             	mov    %r8d,%r9d
  800edd:	41 89 f8             	mov    %edi,%r8d
  800ee0:	48 89 c7             	mov    %rax,%rdi
  800ee3:	48 b8 4c 07 80 00 00 	movabs $0x80074c,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
			break;
  800eef:	eb 3f                	jmp    800f30 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef9:	48 89 d6             	mov    %rdx,%rsi
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	ff d0                	callq  *%rax
			break;
  800f00:	eb 2e                	jmp    800f30 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0a:	48 89 d6             	mov    %rdx,%rsi
  800f0d:	bf 25 00 00 00       	mov    $0x25,%edi
  800f12:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f14:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f19:	eb 05                	jmp    800f20 <vprintfmt+0x4f9>
  800f1b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f20:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f24:	48 83 e8 01          	sub    $0x1,%rax
  800f28:	0f b6 00             	movzbl (%rax),%eax
  800f2b:	3c 25                	cmp    $0x25,%al
  800f2d:	75 ec                	jne    800f1b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f2f:	90                   	nop
		}
	}
  800f30:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f31:	e9 43 fb ff ff       	jmpq   800a79 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f36:	48 83 c4 60          	add    $0x60,%rsp
  800f3a:	5b                   	pop    %rbx
  800f3b:	41 5c                	pop    %r12
  800f3d:	5d                   	pop    %rbp
  800f3e:	c3                   	retq   

0000000000800f3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
  800f43:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f4a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f51:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f58:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f5f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f66:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f6d:	84 c0                	test   %al,%al
  800f6f:	74 20                	je     800f91 <printfmt+0x52>
  800f71:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f75:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f79:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f7d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f81:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f85:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f89:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f8d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f91:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f98:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f9f:	00 00 00 
  800fa2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fa9:	00 00 00 
  800fac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fb7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fbe:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fcc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fd3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fda:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fe1:	48 89 c7             	mov    %rax,%rdi
  800fe4:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 10          	sub    $0x10,%rsp
  800ffa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ffd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801005:	8b 40 10             	mov    0x10(%rax),%eax
  801008:	8d 50 01             	lea    0x1(%rax),%edx
  80100b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801012:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801016:	48 8b 10             	mov    (%rax),%rdx
  801019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801021:	48 39 c2             	cmp    %rax,%rdx
  801024:	73 17                	jae    80103d <sprintputch+0x4b>
		*b->buf++ = ch;
  801026:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102a:	48 8b 00             	mov    (%rax),%rax
  80102d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801031:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801035:	48 89 0a             	mov    %rcx,(%rdx)
  801038:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80103b:	88 10                	mov    %dl,(%rax)
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 50          	sub    $0x50,%rsp
  801047:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80104b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80104e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801052:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801056:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80105a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80105e:	48 8b 0a             	mov    (%rdx),%rcx
  801061:	48 89 08             	mov    %rcx,(%rax)
  801064:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801068:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80106c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801070:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801074:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801078:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80107c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80107f:	48 98                	cltq   
  801081:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801085:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801089:	48 01 d0             	add    %rdx,%rax
  80108c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801090:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801097:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80109c:	74 06                	je     8010a4 <vsnprintf+0x65>
  80109e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010a2:	7f 07                	jg     8010ab <vsnprintf+0x6c>
		return -E_INVAL;
  8010a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a9:	eb 2f                	jmp    8010da <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010ab:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010af:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010b3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010b7:	48 89 c6             	mov    %rax,%rsi
  8010ba:	48 bf f2 0f 80 00 00 	movabs $0x800ff2,%rdi
  8010c1:	00 00 00 
  8010c4:	48 b8 27 0a 80 00 00 	movabs $0x800a27,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010d7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010da:	c9                   	leaveq 
  8010db:	c3                   	retq   

00000000008010dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010dc:	55                   	push   %rbp
  8010dd:	48 89 e5             	mov    %rsp,%rbp
  8010e0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010e7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010ee:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801102:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801109:	84 c0                	test   %al,%al
  80110b:	74 20                	je     80112d <snprintf+0x51>
  80110d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801111:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801115:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801119:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80111d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801121:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801125:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801129:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80112d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801134:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80113b:	00 00 00 
  80113e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801145:	00 00 00 
  801148:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80114c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801153:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80115a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801161:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801168:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80116f:	48 8b 0a             	mov    (%rdx),%rcx
  801172:	48 89 08             	mov    %rcx,(%rax)
  801175:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801179:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80117d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801181:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801185:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80118c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801193:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801199:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011a0:	48 89 c7             	mov    %rax,%rdi
  8011a3:	48 b8 3f 10 80 00 00 	movabs $0x80103f,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
  8011af:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011b5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011bb:	c9                   	leaveq 
  8011bc:	c3                   	retq   

00000000008011bd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011bd:	55                   	push   %rbp
  8011be:	48 89 e5             	mov    %rsp,%rbp
  8011c1:	48 83 ec 18          	sub    $0x18,%rsp
  8011c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d0:	eb 09                	jmp    8011db <strlen+0x1e>
		n++;
  8011d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011d6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	0f b6 00             	movzbl (%rax),%eax
  8011e2:	84 c0                	test   %al,%al
  8011e4:	75 ec                	jne    8011d2 <strlen+0x15>
		n++;
	return n;
  8011e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011e9:	c9                   	leaveq 
  8011ea:	c3                   	retq   

00000000008011eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011eb:	55                   	push   %rbp
  8011ec:	48 89 e5             	mov    %rsp,%rbp
  8011ef:	48 83 ec 20          	sub    $0x20,%rsp
  8011f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801202:	eb 0e                	jmp    801212 <strnlen+0x27>
		n++;
  801204:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801208:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801212:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801217:	74 0b                	je     801224 <strnlen+0x39>
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	0f b6 00             	movzbl (%rax),%eax
  801220:	84 c0                	test   %al,%al
  801222:	75 e0                	jne    801204 <strnlen+0x19>
		n++;
	return n;
  801224:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 20          	sub    $0x20,%rsp
  801231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801241:	90                   	nop
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801246:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80124a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80124e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801252:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801256:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80125a:	0f b6 12             	movzbl (%rdx),%edx
  80125d:	88 10                	mov    %dl,(%rax)
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	75 dc                	jne    801242 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80126a:	c9                   	leaveq 
  80126b:	c3                   	retq   

000000000080126c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	48 83 ec 20          	sub    $0x20,%rsp
  801274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801278:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	48 89 c7             	mov    %rax,%rdi
  801283:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax
  80128f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801295:	48 63 d0             	movslq %eax,%rdx
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 01 c2             	add    %rax,%rdx
  80129f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a3:	48 89 c6             	mov    %rax,%rsi
  8012a6:	48 89 d7             	mov    %rdx,%rdi
  8012a9:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax
	return dst;
  8012b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 28          	sub    $0x28,%rsp
  8012c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012d7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012de:	00 
  8012df:	eb 2a                	jmp    80130b <strncpy+0x50>
		*dst++ = *src;
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f1:	0f b6 12             	movzbl (%rdx),%edx
  8012f4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	84 c0                	test   %al,%al
  8012ff:	74 05                	je     801306 <strncpy+0x4b>
			src++;
  801301:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801306:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801313:	72 cc                	jb     8012e1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 28          	sub    $0x28,%rsp
  801323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80133c:	74 3d                	je     80137b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80133e:	eb 1d                	jmp    80135d <strlcpy+0x42>
			*dst++ = *src++;
  801340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801344:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801348:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80134c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801350:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801354:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801358:	0f b6 12             	movzbl (%rdx),%edx
  80135b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801362:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801367:	74 0b                	je     801374 <strlcpy+0x59>
  801369:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	84 c0                	test   %al,%al
  801372:	75 cc                	jne    801340 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80137b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801383:	48 29 c2             	sub    %rax,%rdx
  801386:	48 89 d0             	mov    %rdx,%rax
}
  801389:	c9                   	leaveq 
  80138a:	c3                   	retq   

000000000080138b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80138b:	55                   	push   %rbp
  80138c:	48 89 e5             	mov    %rsp,%rbp
  80138f:	48 83 ec 10          	sub    $0x10,%rsp
  801393:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801397:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80139b:	eb 0a                	jmp    8013a7 <strcmp+0x1c>
		p++, q++;
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 12                	je     8013c4 <strcmp+0x39>
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	0f b6 10             	movzbl (%rax),%edx
  8013b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	38 c2                	cmp    %al,%dl
  8013c2:	74 d9                	je     80139d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	0f b6 d0             	movzbl %al,%edx
  8013ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	29 c2                	sub    %eax,%edx
  8013da:	89 d0                	mov    %edx,%eax
}
  8013dc:	c9                   	leaveq 
  8013dd:	c3                   	retq   

00000000008013de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013de:	55                   	push   %rbp
  8013df:	48 89 e5             	mov    %rsp,%rbp
  8013e2:	48 83 ec 18          	sub    $0x18,%rsp
  8013e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f2:	eb 0f                	jmp    801403 <strncmp+0x25>
		n--, p++, q++;
  8013f4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801403:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801408:	74 1d                	je     801427 <strncmp+0x49>
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	84 c0                	test   %al,%al
  801413:	74 12                	je     801427 <strncmp+0x49>
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	0f b6 10             	movzbl (%rax),%edx
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	38 c2                	cmp    %al,%dl
  801425:	74 cd                	je     8013f4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801427:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142c:	75 07                	jne    801435 <strncmp+0x57>
		return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	eb 18                	jmp    80144d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	0f b6 d0             	movzbl %al,%edx
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	0f b6 c0             	movzbl %al,%eax
  801449:	29 c2                	sub    %eax,%edx
  80144b:	89 d0                	mov    %edx,%eax
}
  80144d:	c9                   	leaveq 
  80144e:	c3                   	retq   

000000000080144f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144f:	55                   	push   %rbp
  801450:	48 89 e5             	mov    %rsp,%rbp
  801453:	48 83 ec 0c          	sub    $0xc,%rsp
  801457:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145b:	89 f0                	mov    %esi,%eax
  80145d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801460:	eb 17                	jmp    801479 <strchr+0x2a>
		if (*s == c)
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80146c:	75 06                	jne    801474 <strchr+0x25>
			return (char *) s;
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	eb 15                	jmp    801489 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801474:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	84 c0                	test   %al,%al
  801482:	75 de                	jne    801462 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 0c          	sub    $0xc,%rsp
  801493:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801497:	89 f0                	mov    %esi,%eax
  801499:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80149c:	eb 13                	jmp    8014b1 <strfind+0x26>
		if (*s == c)
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	0f b6 00             	movzbl (%rax),%eax
  8014a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014a8:	75 02                	jne    8014ac <strfind+0x21>
			break;
  8014aa:	eb 10                	jmp    8014bc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	0f b6 00             	movzbl (%rax),%eax
  8014b8:	84 c0                	test   %al,%al
  8014ba:	75 e2                	jne    80149e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014c0:	c9                   	leaveq 
  8014c1:	c3                   	retq   

00000000008014c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c2:	55                   	push   %rbp
  8014c3:	48 89 e5             	mov    %rsp,%rbp
  8014c6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ce:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014da:	75 06                	jne    8014e2 <memset+0x20>
		return v;
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	eb 69                	jmp    80154b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e6:	83 e0 03             	and    $0x3,%eax
  8014e9:	48 85 c0             	test   %rax,%rax
  8014ec:	75 48                	jne    801536 <memset+0x74>
  8014ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f2:	83 e0 03             	and    $0x3,%eax
  8014f5:	48 85 c0             	test   %rax,%rax
  8014f8:	75 3c                	jne    801536 <memset+0x74>
		c &= 0xFF;
  8014fa:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801501:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801504:	c1 e0 18             	shl    $0x18,%eax
  801507:	89 c2                	mov    %eax,%edx
  801509:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150c:	c1 e0 10             	shl    $0x10,%eax
  80150f:	09 c2                	or     %eax,%edx
  801511:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801514:	c1 e0 08             	shl    $0x8,%eax
  801517:	09 d0                	or     %edx,%eax
  801519:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801520:	48 c1 e8 02          	shr    $0x2,%rax
  801524:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801527:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152e:	48 89 d7             	mov    %rdx,%rdi
  801531:	fc                   	cld    
  801532:	f3 ab                	rep stos %eax,%es:(%rdi)
  801534:	eb 11                	jmp    801547 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801536:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801541:	48 89 d7             	mov    %rdx,%rdi
  801544:	fc                   	cld    
  801545:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 28          	sub    $0x28,%rsp
  801555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801559:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801565:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801579:	0f 83 88 00 00 00    	jae    801607 <memmove+0xba>
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801587:	48 01 d0             	add    %rdx,%rax
  80158a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80158e:	76 77                	jbe    801607 <memmove+0xba>
		s += n;
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a4:	83 e0 03             	and    $0x3,%eax
  8015a7:	48 85 c0             	test   %rax,%rax
  8015aa:	75 3b                	jne    8015e7 <memmove+0x9a>
  8015ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b0:	83 e0 03             	and    $0x3,%eax
  8015b3:	48 85 c0             	test   %rax,%rax
  8015b6:	75 2f                	jne    8015e7 <memmove+0x9a>
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	83 e0 03             	and    $0x3,%eax
  8015bf:	48 85 c0             	test   %rax,%rax
  8015c2:	75 23                	jne    8015e7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c8:	48 83 e8 04          	sub    $0x4,%rax
  8015cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d0:	48 83 ea 04          	sub    $0x4,%rdx
  8015d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015d8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015dc:	48 89 c7             	mov    %rax,%rdi
  8015df:	48 89 d6             	mov    %rdx,%rsi
  8015e2:	fd                   	std    
  8015e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e5:	eb 1d                	jmp    801604 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	48 89 d7             	mov    %rdx,%rdi
  8015fe:	48 89 c1             	mov    %rax,%rcx
  801601:	fd                   	std    
  801602:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801604:	fc                   	cld    
  801605:	eb 57                	jmp    80165e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	83 e0 03             	and    $0x3,%eax
  80160e:	48 85 c0             	test   %rax,%rax
  801611:	75 36                	jne    801649 <memmove+0xfc>
  801613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801617:	83 e0 03             	and    $0x3,%eax
  80161a:	48 85 c0             	test   %rax,%rax
  80161d:	75 2a                	jne    801649 <memmove+0xfc>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	83 e0 03             	and    $0x3,%eax
  801626:	48 85 c0             	test   %rax,%rax
  801629:	75 1e                	jne    801649 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	48 c1 e8 02          	shr    $0x2,%rax
  801633:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 89 d6             	mov    %rdx,%rsi
  801644:	fc                   	cld    
  801645:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801647:	eb 15                	jmp    80165e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801651:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801655:	48 89 c7             	mov    %rax,%rdi
  801658:	48 89 d6             	mov    %rdx,%rsi
  80165b:	fc                   	cld    
  80165c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80165e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801662:	c9                   	leaveq 
  801663:	c3                   	retq   

0000000000801664 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801664:	55                   	push   %rbp
  801665:	48 89 e5             	mov    %rsp,%rbp
  801668:	48 83 ec 18          	sub    $0x18,%rsp
  80166c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801670:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801674:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801684:	48 89 ce             	mov    %rcx,%rsi
  801687:	48 89 c7             	mov    %rax,%rdi
  80168a:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801691:	00 00 00 
  801694:	ff d0                	callq  *%rax
}
  801696:	c9                   	leaveq 
  801697:	c3                   	retq   

0000000000801698 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	48 83 ec 28          	sub    $0x28,%rsp
  8016a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016bc:	eb 36                	jmp    8016f4 <memcmp+0x5c>
		if (*s1 != *s2)
  8016be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c2:	0f b6 10             	movzbl (%rax),%edx
  8016c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	38 c2                	cmp    %al,%dl
  8016ce:	74 1a                	je     8016ea <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	0f b6 d0             	movzbl %al,%edx
  8016da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	0f b6 c0             	movzbl %al,%eax
  8016e4:	29 c2                	sub    %eax,%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	eb 20                	jmp    80170a <memcmp+0x72>
		s1++, s2++;
  8016ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ef:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801700:	48 85 c0             	test   %rax,%rax
  801703:	75 b9                	jne    8016be <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170a:	c9                   	leaveq 
  80170b:	c3                   	retq   

000000000080170c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80170c:	55                   	push   %rbp
  80170d:	48 89 e5             	mov    %rsp,%rbp
  801710:	48 83 ec 28          	sub    $0x28,%rsp
  801714:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801718:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80171b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801727:	48 01 d0             	add    %rdx,%rax
  80172a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80172e:	eb 15                	jmp    801745 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	0f b6 10             	movzbl (%rax),%edx
  801737:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80173a:	38 c2                	cmp    %al,%dl
  80173c:	75 02                	jne    801740 <memfind+0x34>
			break;
  80173e:	eb 0f                	jmp    80174f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801740:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801749:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80174d:	72 e1                	jb     801730 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80174f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801753:	c9                   	leaveq 
  801754:	c3                   	retq   

0000000000801755 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801755:	55                   	push   %rbp
  801756:	48 89 e5             	mov    %rsp,%rbp
  801759:	48 83 ec 34          	sub    $0x34,%rsp
  80175d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801761:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801765:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80176f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801776:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801777:	eb 05                	jmp    80177e <strtol+0x29>
		s++;
  801779:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3c 20                	cmp    $0x20,%al
  801787:	74 f0                	je     801779 <strtol+0x24>
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	0f b6 00             	movzbl (%rax),%eax
  801790:	3c 09                	cmp    $0x9,%al
  801792:	74 e5                	je     801779 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	3c 2b                	cmp    $0x2b,%al
  80179d:	75 07                	jne    8017a6 <strtol+0x51>
		s++;
  80179f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a4:	eb 17                	jmp    8017bd <strtol+0x68>
	else if (*s == '-')
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	3c 2d                	cmp    $0x2d,%al
  8017af:	75 0c                	jne    8017bd <strtol+0x68>
		s++, neg = 1;
  8017b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c1:	74 06                	je     8017c9 <strtol+0x74>
  8017c3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017c7:	75 28                	jne    8017f1 <strtol+0x9c>
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 1d                	jne    8017f1 <strtol+0x9c>
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	48 83 c0 01          	add    $0x1,%rax
  8017dc:	0f b6 00             	movzbl (%rax),%eax
  8017df:	3c 78                	cmp    $0x78,%al
  8017e1:	75 0e                	jne    8017f1 <strtol+0x9c>
		s += 2, base = 16;
  8017e3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017e8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017ef:	eb 2c                	jmp    80181d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f5:	75 19                	jne    801810 <strtol+0xbb>
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	3c 30                	cmp    $0x30,%al
  801800:	75 0e                	jne    801810 <strtol+0xbb>
		s++, base = 8;
  801802:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801807:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80180e:	eb 0d                	jmp    80181d <strtol+0xc8>
	else if (base == 0)
  801810:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801814:	75 07                	jne    80181d <strtol+0xc8>
		base = 10;
  801816:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	3c 2f                	cmp    $0x2f,%al
  801826:	7e 1d                	jle    801845 <strtol+0xf0>
  801828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182c:	0f b6 00             	movzbl (%rax),%eax
  80182f:	3c 39                	cmp    $0x39,%al
  801831:	7f 12                	jg     801845 <strtol+0xf0>
			dig = *s - '0';
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	0f b6 00             	movzbl (%rax),%eax
  80183a:	0f be c0             	movsbl %al,%eax
  80183d:	83 e8 30             	sub    $0x30,%eax
  801840:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801843:	eb 4e                	jmp    801893 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	3c 60                	cmp    $0x60,%al
  80184e:	7e 1d                	jle    80186d <strtol+0x118>
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 7a                	cmp    $0x7a,%al
  801859:	7f 12                	jg     80186d <strtol+0x118>
			dig = *s - 'a' + 10;
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	0f be c0             	movsbl %al,%eax
  801865:	83 e8 57             	sub    $0x57,%eax
  801868:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80186b:	eb 26                	jmp    801893 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	3c 40                	cmp    $0x40,%al
  801876:	7e 48                	jle    8018c0 <strtol+0x16b>
  801878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187c:	0f b6 00             	movzbl (%rax),%eax
  80187f:	3c 5a                	cmp    $0x5a,%al
  801881:	7f 3d                	jg     8018c0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	0f be c0             	movsbl %al,%eax
  80188d:	83 e8 37             	sub    $0x37,%eax
  801890:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801893:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801896:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801899:	7c 02                	jl     80189d <strtol+0x148>
			break;
  80189b:	eb 23                	jmp    8018c0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80189d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018a5:	48 98                	cltq   
  8018a7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018ac:	48 89 c2             	mov    %rax,%rdx
  8018af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b2:	48 98                	cltq   
  8018b4:	48 01 d0             	add    %rdx,%rax
  8018b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018bb:	e9 5d ff ff ff       	jmpq   80181d <strtol+0xc8>

	if (endptr)
  8018c0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018c5:	74 0b                	je     8018d2 <strtol+0x17d>
		*endptr = (char *) s;
  8018c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018cf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018d6:	74 09                	je     8018e1 <strtol+0x18c>
  8018d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018dc:	48 f7 d8             	neg    %rax
  8018df:	eb 04                	jmp    8018e5 <strtol+0x190>
  8018e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 30          	sub    $0x30,%rsp
  8018ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ff:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801909:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80190d:	75 06                	jne    801915 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	eb 6b                	jmp    801980 <strstr+0x99>

	len = strlen(str);
  801915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801919:	48 89 c7             	mov    %rax,%rdi
  80191c:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
  801928:	48 98                	cltq   
  80192a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801936:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801940:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801944:	75 07                	jne    80194d <strstr+0x66>
				return (char *) 0;
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
  80194b:	eb 33                	jmp    801980 <strstr+0x99>
		} while (sc != c);
  80194d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801951:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801954:	75 d8                	jne    80192e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80195e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801962:	48 89 ce             	mov    %rcx,%rsi
  801965:	48 89 c7             	mov    %rax,%rdi
  801968:	48 b8 de 13 80 00 00 	movabs $0x8013de,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
  801974:	85 c0                	test   %eax,%eax
  801976:	75 b6                	jne    80192e <strstr+0x47>

	return (char *) (in - 1);
  801978:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197c:	48 83 e8 01          	sub    $0x1,%rax
}
  801980:	c9                   	leaveq 
  801981:	c3                   	retq   

0000000000801982 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801982:	55                   	push   %rbp
  801983:	48 89 e5             	mov    %rsp,%rbp
  801986:	53                   	push   %rbx
  801987:	48 83 ec 48          	sub    $0x48,%rsp
  80198b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80198e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801991:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801995:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801999:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80199d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019a8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019ac:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019b0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019b4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019b8:	4c 89 c3             	mov    %r8,%rbx
  8019bb:	cd 30                	int    $0x30
  8019bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019c5:	74 3e                	je     801a05 <syscall+0x83>
  8019c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019cc:	7e 37                	jle    801a05 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019d5:	49 89 d0             	mov    %rdx,%r8
  8019d8:	89 c1                	mov    %eax,%ecx
  8019da:	48 ba 88 4f 80 00 00 	movabs $0x804f88,%rdx
  8019e1:	00 00 00 
  8019e4:	be 23 00 00 00       	mov    $0x23,%esi
  8019e9:	48 bf a5 4f 80 00 00 	movabs $0x804fa5,%rdi
  8019f0:	00 00 00 
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f8:	49 b9 3b 04 80 00 00 	movabs $0x80043b,%r9
  8019ff:	00 00 00 
  801a02:	41 ff d1             	callq  *%r9

	return ret;
  801a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a09:	48 83 c4 48          	add    $0x48,%rsp
  801a0d:	5b                   	pop    %rbx
  801a0e:	5d                   	pop    %rbp
  801a0f:	c3                   	retq   

0000000000801a10 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	48 83 ec 20          	sub    $0x20,%rsp
  801a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2f:	00 
  801a30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3c:	48 89 d1             	mov    %rdx,%rcx
  801a3f:	48 89 c2             	mov    %rax,%rdx
  801a42:	be 00 00 00 00       	mov    $0x0,%esi
  801a47:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4c:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	callq  *%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a69:	00 
  801a6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a76:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	be 00 00 00 00       	mov    $0x0,%esi
  801a85:	bf 01 00 00 00       	mov    $0x1,%edi
  801a8a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801a91:	00 00 00 
  801a94:	ff d0                	callq  *%rax
}
  801a96:	c9                   	leaveq 
  801a97:	c3                   	retq   

0000000000801a98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a98:	55                   	push   %rbp
  801a99:	48 89 e5             	mov    %rsp,%rbp
  801a9c:	48 83 ec 10          	sub    $0x10,%rsp
  801aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa6:	48 98                	cltq   
  801aa8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aaf:	00 
  801ab0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	be 01 00 00 00       	mov    $0x1,%esi
  801ac9:	bf 03 00 00 00       	mov    $0x3,%edi
  801ace:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ae4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aeb:	00 
  801aec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afd:	ba 00 00 00 00       	mov    $0x0,%edx
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	bf 02 00 00 00       	mov    $0x2,%edi
  801b0c:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
}
  801b18:	c9                   	leaveq 
  801b19:	c3                   	retq   

0000000000801b1a <sys_yield>:

void
sys_yield(void)
{
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b4a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 20          	sub    $0x20,%rsp
  801b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b67:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 c8             	movslq %eax,%rcx
  801b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	49 89 c8             	mov    %rcx,%r8
  801b8a:	48 89 d1             	mov    %rdx,%rcx
  801b8d:	48 89 c2             	mov    %rax,%rdx
  801b90:	be 01 00 00 00       	mov    $0x1,%esi
  801b95:	bf 04 00 00 00       	mov    $0x4,%edi
  801b9a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
}
  801ba6:	c9                   	leaveq 
  801ba7:	c3                   	retq   

0000000000801ba8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 30          	sub    $0x30,%rsp
  801bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bbe:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bc2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc5:	48 63 c8             	movslq %eax,%rcx
  801bc8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcf:	48 63 f0             	movslq %eax,%rsi
  801bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd9:	48 98                	cltq   
  801bdb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bdf:	49 89 f9             	mov    %rdi,%r9
  801be2:	49 89 f0             	mov    %rsi,%r8
  801be5:	48 89 d1             	mov    %rdx,%rcx
  801be8:	48 89 c2             	mov    %rax,%rdx
  801beb:	be 01 00 00 00       	mov    $0x1,%esi
  801bf0:	bf 05 00 00 00       	mov    $0x5,%edi
  801bf5:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801bfc:	00 00 00 
  801bff:	ff d0                	callq  *%rax
}
  801c01:	c9                   	leaveq 
  801c02:	c3                   	retq   

0000000000801c03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c03:	55                   	push   %rbp
  801c04:	48 89 e5             	mov    %rsp,%rbp
  801c07:	48 83 ec 20          	sub    $0x20,%rsp
  801c0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c19:	48 98                	cltq   
  801c1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c22:	00 
  801c23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2f:	48 89 d1             	mov    %rdx,%rcx
  801c32:	48 89 c2             	mov    %rax,%rdx
  801c35:	be 01 00 00 00       	mov    $0x1,%esi
  801c3a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c3f:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
}
  801c4b:	c9                   	leaveq 
  801c4c:	c3                   	retq   

0000000000801c4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
  801c51:	48 83 ec 10          	sub    $0x10,%rsp
  801c55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c5e:	48 63 d0             	movslq %eax,%rdx
  801c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c64:	48 98                	cltq   
  801c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6d:	00 
  801c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7a:	48 89 d1             	mov    %rdx,%rcx
  801c7d:	48 89 c2             	mov    %rax,%rdx
  801c80:	be 01 00 00 00       	mov    $0x1,%esi
  801c85:	bf 08 00 00 00       	mov    $0x8,%edi
  801c8a:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
}
  801c96:	c9                   	leaveq 
  801c97:	c3                   	retq   

0000000000801c98 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	48 83 ec 20          	sub    $0x20,%rsp
  801ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cae:	48 98                	cltq   
  801cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb7:	00 
  801cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc4:	48 89 d1             	mov    %rdx,%rcx
  801cc7:	48 89 c2             	mov    %rax,%rdx
  801cca:	be 01 00 00 00       	mov    $0x1,%esi
  801ccf:	bf 09 00 00 00       	mov    $0x9,%edi
  801cd4:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801cdb:	00 00 00 
  801cde:	ff d0                	callq  *%rax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 20          	sub    $0x20,%rsp
  801cea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ced:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf8:	48 98                	cltq   
  801cfa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d01:	00 
  801d02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0e:	48 89 d1             	mov    %rdx,%rcx
  801d11:	48 89 c2             	mov    %rax,%rdx
  801d14:	be 01 00 00 00       	mov    $0x1,%esi
  801d19:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d1e:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	callq  *%rax
}
  801d2a:	c9                   	leaveq 
  801d2b:	c3                   	retq   

0000000000801d2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d2c:	55                   	push   %rbp
  801d2d:	48 89 e5             	mov    %rsp,%rbp
  801d30:	48 83 ec 20          	sub    $0x20,%rsp
  801d34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d3b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d3f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d45:	48 63 f0             	movslq %eax,%rsi
  801d48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4f:	48 98                	cltq   
  801d51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5c:	00 
  801d5d:	49 89 f1             	mov    %rsi,%r9
  801d60:	49 89 c8             	mov    %rcx,%r8
  801d63:	48 89 d1             	mov    %rdx,%rcx
  801d66:	48 89 c2             	mov    %rax,%rdx
  801d69:	be 00 00 00 00       	mov    $0x0,%esi
  801d6e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d73:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801d7a:	00 00 00 
  801d7d:	ff d0                	callq  *%rax
}
  801d7f:	c9                   	leaveq 
  801d80:	c3                   	retq   

0000000000801d81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d81:	55                   	push   %rbp
  801d82:	48 89 e5             	mov    %rsp,%rbp
  801d85:	48 83 ec 10          	sub    $0x10,%rsp
  801d89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d98:	00 
  801d99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801daa:	48 89 c2             	mov    %rax,%rdx
  801dad:	be 01 00 00 00       	mov    $0x1,%esi
  801db2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801db7:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
}
  801dc3:	c9                   	leaveq 
  801dc4:	c3                   	retq   

0000000000801dc5 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801dc5:	55                   	push   %rbp
  801dc6:	48 89 e5             	mov    %rsp,%rbp
  801dc9:	48 83 ec 20          	sub    $0x20,%rsp
  801dcd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de4:	00 
  801de5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801deb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df1:	48 89 d1             	mov    %rdx,%rcx
  801df4:	48 89 c2             	mov    %rax,%rdx
  801df7:	be 01 00 00 00       	mov    $0x1,%esi
  801dfc:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e01:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	callq  *%rax
}
  801e0d:	c9                   	leaveq 
  801e0e:	c3                   	retq   

0000000000801e0f <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801e0f:	55                   	push   %rbp
  801e10:	48 89 e5             	mov    %rsp,%rbp
  801e13:	48 83 ec 10          	sub    $0x10,%rsp
  801e17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e26:	00 
  801e27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e38:	48 89 c2             	mov    %rax,%rdx
  801e3b:	be 00 00 00 00       	mov    $0x0,%esi
  801e40:	bf 10 00 00 00       	mov    $0x10,%edi
  801e45:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	callq  *%rax
}
  801e51:	c9                   	leaveq 
  801e52:	c3                   	retq   

0000000000801e53 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e53:	55                   	push   %rbp
  801e54:	48 89 e5             	mov    %rsp,%rbp
  801e57:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e62:	00 
  801e63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e74:	ba 00 00 00 00       	mov    $0x0,%edx
  801e79:	be 00 00 00 00       	mov    $0x0,%esi
  801e7e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e83:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 83 ec 30          	sub    $0x30,%rsp
  801e99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea1:	48 8b 00             	mov    (%rax),%rax
  801ea4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eac:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eb0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801eb3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eb6:	83 e0 02             	and    $0x2,%eax
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	75 4d                	jne    801f0a <pgfault+0x79>
  801ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec1:	48 c1 e8 0c          	shr    $0xc,%rax
  801ec5:	48 89 c2             	mov    %rax,%rdx
  801ec8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ecf:	01 00 00 
  801ed2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed6:	25 00 08 00 00       	and    $0x800,%eax
  801edb:	48 85 c0             	test   %rax,%rax
  801ede:	74 2a                	je     801f0a <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ee0:	48 ba b8 4f 80 00 00 	movabs $0x804fb8,%rdx
  801ee7:	00 00 00 
  801eea:	be 23 00 00 00       	mov    $0x23,%esi
  801eef:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801ef6:	00 00 00 
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801f05:	00 00 00 
  801f08:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f0a:	ba 07 00 00 00       	mov    $0x7,%edx
  801f0f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f14:	bf 00 00 00 00       	mov    $0x0,%edi
  801f19:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
  801f25:	85 c0                	test   %eax,%eax
  801f27:	0f 85 cd 00 00 00    	jne    801ffa <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f39:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f3f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f47:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f4c:	48 89 c6             	mov    %rax,%rsi
  801f4f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f54:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f64:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f6a:	48 89 c1             	mov    %rax,%rcx
  801f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f72:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f77:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7c:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	79 2a                	jns    801fb6 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f8c:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  801f93:	00 00 00 
  801f96:	be 30 00 00 00       	mov    $0x30,%esi
  801f9b:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801fa2:	00 00 00 
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801fb1:	00 00 00 
  801fb4:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801fb6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc0:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	callq  *%rax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	79 54                	jns    802024 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801fd0:	48 ba 18 50 80 00 00 	movabs $0x805018,%rdx
  801fd7:	00 00 00 
  801fda:	be 32 00 00 00       	mov    $0x32,%esi
  801fdf:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  801fe6:	00 00 00 
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  801ff5:	00 00 00 
  801ff8:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ffa:	48 ba 40 50 80 00 00 	movabs $0x805040,%rdx
  802001:	00 00 00 
  802004:	be 34 00 00 00       	mov    $0x34,%esi
  802009:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802010:	00 00 00 
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  80201f:	00 00 00 
  802022:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802024:	c9                   	leaveq 
  802025:	c3                   	retq   

0000000000802026 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802026:	55                   	push   %rbp
  802027:	48 89 e5             	mov    %rsp,%rbp
  80202a:	48 83 ec 20          	sub    $0x20,%rsp
  80202e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802031:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802034:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80203b:	01 00 00 
  80203e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802041:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802045:	25 07 0e 00 00       	and    $0xe07,%eax
  80204a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80204d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802050:	48 c1 e0 0c          	shl    $0xc,%rax
  802054:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205b:	25 00 04 00 00       	and    $0x400,%eax
  802060:	85 c0                	test   %eax,%eax
  802062:	74 57                	je     8020bb <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802064:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802067:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80206b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80206e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802072:	41 89 f0             	mov    %esi,%r8d
  802075:	48 89 c6             	mov    %rax,%rsi
  802078:	bf 00 00 00 00       	mov    $0x0,%edi
  80207d:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 8e 52 01 00 00    	jle    8021e3 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802091:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  802098:	00 00 00 
  80209b:	be 4e 00 00 00       	mov    $0x4e,%esi
  8020a0:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8020a7:	00 00 00 
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8020b6:	00 00 00 
  8020b9:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8020bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020be:	83 e0 02             	and    $0x2,%eax
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	75 10                	jne    8020d5 <duppage+0xaf>
  8020c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c8:	25 00 08 00 00       	and    $0x800,%eax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	0f 84 bb 00 00 00    	je     802190 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8020d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d8:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8020dd:	80 cc 08             	or     $0x8,%ah
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020e3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020e6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020ea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f1:	41 89 f0             	mov    %esi,%r8d
  8020f4:	48 89 c6             	mov    %rax,%rsi
  8020f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fc:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802103:	00 00 00 
  802106:	ff d0                	callq  *%rax
  802108:	85 c0                	test   %eax,%eax
  80210a:	7e 2a                	jle    802136 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80210c:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  802113:	00 00 00 
  802116:	be 55 00 00 00       	mov    $0x55,%esi
  80211b:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802122:	00 00 00 
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
  80212a:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802131:	00 00 00 
  802134:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802136:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802139:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802141:	41 89 c8             	mov    %ecx,%r8d
  802144:	48 89 d1             	mov    %rdx,%rcx
  802147:	ba 00 00 00 00       	mov    $0x0,%edx
  80214c:	48 89 c6             	mov    %rax,%rsi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	85 c0                	test   %eax,%eax
  802162:	7e 2a                	jle    80218e <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802164:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  80216b:	00 00 00 
  80216e:	be 57 00 00 00       	mov    $0x57,%esi
  802173:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  80217a:	00 00 00 
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802189:	00 00 00 
  80218c:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80218e:	eb 53                	jmp    8021e3 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802190:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802193:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802197:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80219a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219e:	41 89 f0             	mov    %esi,%r8d
  8021a1:	48 89 c6             	mov    %rax,%rsi
  8021a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a9:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	callq  *%rax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	7e 2a                	jle    8021e3 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8021b9:	48 ba 72 50 80 00 00 	movabs $0x805072,%rdx
  8021c0:	00 00 00 
  8021c3:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021c8:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8021cf:	00 00 00 
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8021de:	00 00 00 
  8021e1:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e8:	c9                   	leaveq 
  8021e9:	c3                   	retq   

00000000008021ea <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8021ea:	55                   	push   %rbp
  8021eb:	48 89 e5             	mov    %rsp,%rbp
  8021ee:	48 83 ec 18          	sub    $0x18,%rsp
  8021f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802202:	48 c1 e8 27          	shr    $0x27,%rax
  802206:	48 89 c2             	mov    %rax,%rdx
  802209:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802210:	01 00 00 
  802213:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802217:	83 e0 01             	and    $0x1,%eax
  80221a:	48 85 c0             	test   %rax,%rax
  80221d:	74 51                	je     802270 <pt_is_mapped+0x86>
  80221f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802223:	48 c1 e0 0c          	shl    $0xc,%rax
  802227:	48 c1 e8 1e          	shr    $0x1e,%rax
  80222b:	48 89 c2             	mov    %rax,%rdx
  80222e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802235:	01 00 00 
  802238:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223c:	83 e0 01             	and    $0x1,%eax
  80223f:	48 85 c0             	test   %rax,%rax
  802242:	74 2c                	je     802270 <pt_is_mapped+0x86>
  802244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802248:	48 c1 e0 0c          	shl    $0xc,%rax
  80224c:	48 c1 e8 15          	shr    $0x15,%rax
  802250:	48 89 c2             	mov    %rax,%rdx
  802253:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80225a:	01 00 00 
  80225d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802261:	83 e0 01             	and    $0x1,%eax
  802264:	48 85 c0             	test   %rax,%rax
  802267:	74 07                	je     802270 <pt_is_mapped+0x86>
  802269:	b8 01 00 00 00       	mov    $0x1,%eax
  80226e:	eb 05                	jmp    802275 <pt_is_mapped+0x8b>
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	83 e0 01             	and    $0x1,%eax
}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <fork>:

envid_t
fork(void)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
  80227e:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802282:	48 bf 91 1e 80 00 00 	movabs $0x801e91,%rdi
  802289:	00 00 00 
  80228c:	48 b8 2a 48 80 00 00 	movabs $0x80482a,%rax
  802293:	00 00 00 
  802296:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802298:	b8 07 00 00 00       	mov    $0x7,%eax
  80229d:	cd 30                	int    $0x30
  80229f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8022a5:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8022a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022ac:	79 30                	jns    8022de <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8022ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022b1:	89 c1                	mov    %eax,%ecx
  8022b3:	48 ba 90 50 80 00 00 	movabs $0x805090,%rdx
  8022ba:	00 00 00 
  8022bd:	be 86 00 00 00       	mov    $0x86,%esi
  8022c2:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  8022c9:	00 00 00 
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  8022d8:	00 00 00 
  8022db:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022e2:	75 46                	jne    80232a <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8022e4:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	callq  *%rax
  8022f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022f5:	48 63 d0             	movslq %eax,%rdx
  8022f8:	48 89 d0             	mov    %rdx,%rax
  8022fb:	48 c1 e0 03          	shl    $0x3,%rax
  8022ff:	48 01 d0             	add    %rdx,%rax
  802302:	48 c1 e0 05          	shl    $0x5,%rax
  802306:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80230d:	00 00 00 
  802310:	48 01 c2             	add    %rax,%rdx
  802313:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80231a:	00 00 00 
  80231d:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	e9 d1 01 00 00       	jmpq   8024fb <fork+0x281>
	}
	uint64_t ad = 0;
  80232a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802331:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802332:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802337:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80233b:	e9 df 00 00 00       	jmpq   80241f <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802344:	48 c1 e8 27          	shr    $0x27,%rax
  802348:	48 89 c2             	mov    %rax,%rdx
  80234b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802352:	01 00 00 
  802355:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802359:	83 e0 01             	and    $0x1,%eax
  80235c:	48 85 c0             	test   %rax,%rax
  80235f:	0f 84 9e 00 00 00    	je     802403 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802369:	48 c1 e8 1e          	shr    $0x1e,%rax
  80236d:	48 89 c2             	mov    %rax,%rdx
  802370:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802377:	01 00 00 
  80237a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237e:	83 e0 01             	and    $0x1,%eax
  802381:	48 85 c0             	test   %rax,%rax
  802384:	74 73                	je     8023f9 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80238a:	48 c1 e8 15          	shr    $0x15,%rax
  80238e:	48 89 c2             	mov    %rax,%rdx
  802391:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802398:	01 00 00 
  80239b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239f:	83 e0 01             	and    $0x1,%eax
  8023a2:	48 85 c0             	test   %rax,%rax
  8023a5:	74 48                	je     8023ef <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8023a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8023af:	48 89 c2             	mov    %rax,%rdx
  8023b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b9:	01 00 00 
  8023bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c8:	83 e0 01             	and    $0x1,%eax
  8023cb:	48 85 c0             	test   %rax,%rax
  8023ce:	74 47                	je     802417 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8023d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023d8:	89 c2                	mov    %eax,%edx
  8023da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023dd:	89 d6                	mov    %edx,%esi
  8023df:	89 c7                	mov    %eax,%edi
  8023e1:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  8023e8:	00 00 00 
  8023eb:	ff d0                	callq  *%rax
  8023ed:	eb 28                	jmp    802417 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8023ef:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023f6:	00 
  8023f7:	eb 1e                	jmp    802417 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023f9:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802400:	40 
  802401:	eb 14                	jmp    802417 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802407:	48 c1 e8 27          	shr    $0x27,%rax
  80240b:	48 83 c0 01          	add    $0x1,%rax
  80240f:	48 c1 e0 27          	shl    $0x27,%rax
  802413:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802417:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80241e:	00 
  80241f:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802426:	00 
  802427:	0f 87 13 ff ff ff    	ja     802340 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80242d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802430:	ba 07 00 00 00       	mov    $0x7,%edx
  802435:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80243a:	89 c7                	mov    %eax,%edi
  80243c:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802448:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244b:	ba 07 00 00 00       	mov    $0x7,%edx
  802450:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802455:	89 c7                	mov    %eax,%edi
  802457:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80245e:	00 00 00 
  802461:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802463:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802466:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80246c:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802471:	ba 00 00 00 00       	mov    $0x0,%edx
  802476:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80247b:	89 c7                	mov    %eax,%edi
  80247d:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802484:	00 00 00 
  802487:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802489:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802493:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802498:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8024a4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ae:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8024ba:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024c1:	00 00 00 
  8024c4:	48 8b 00             	mov    (%rax),%rax
  8024c7:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8024ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d1:	48 89 d6             	mov    %rdx,%rsi
  8024d4:	89 c7                	mov    %eax,%edi
  8024d6:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8024e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024e5:	be 02 00 00 00       	mov    $0x2,%esi
  8024ea:	89 c7                	mov    %eax,%edi
  8024ec:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax

	return envid;
  8024f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024fb:	c9                   	leaveq 
  8024fc:	c3                   	retq   

00000000008024fd <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024fd:	55                   	push   %rbp
  8024fe:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802501:	48 ba a8 50 80 00 00 	movabs $0x8050a8,%rdx
  802508:	00 00 00 
  80250b:	be bf 00 00 00       	mov    $0xbf,%esi
  802510:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  802517:	00 00 00 
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  802526:	00 00 00 
  802529:	ff d1                	callq  *%rcx

000000000080252b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80252b:	55                   	push   %rbp
  80252c:	48 89 e5             	mov    %rsp,%rbp
  80252f:	48 83 ec 30          	sub    $0x30,%rsp
  802533:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802537:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80253b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80253f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802546:	00 00 00 
  802549:	48 8b 00             	mov    (%rax),%rax
  80254c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	75 3c                	jne    802592 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802556:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80255d:	00 00 00 
  802560:	ff d0                	callq  *%rax
  802562:	25 ff 03 00 00       	and    $0x3ff,%eax
  802567:	48 63 d0             	movslq %eax,%rdx
  80256a:	48 89 d0             	mov    %rdx,%rax
  80256d:	48 c1 e0 03          	shl    $0x3,%rax
  802571:	48 01 d0             	add    %rdx,%rax
  802574:	48 c1 e0 05          	shl    $0x5,%rax
  802578:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80257f:	00 00 00 
  802582:	48 01 c2             	add    %rax,%rdx
  802585:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80258c:	00 00 00 
  80258f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802592:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802597:	75 0e                	jne    8025a7 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802599:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025a0:	00 00 00 
  8025a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8025a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ab:	48 89 c7             	mov    %rax,%rdi
  8025ae:	48 b8 81 1d 80 00 00 	movabs $0x801d81,%rax
  8025b5:	00 00 00 
  8025b8:	ff d0                	callq  *%rax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8025bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c1:	79 19                	jns    8025dc <ipc_recv+0xb1>
		*from_env_store = 0;
  8025c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8025cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8025d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025da:	eb 53                	jmp    80262f <ipc_recv+0x104>
	}
	if(from_env_store)
  8025dc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025e1:	74 19                	je     8025fc <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8025e3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025ea:	00 00 00 
  8025ed:	48 8b 00             	mov    (%rax),%rax
  8025f0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8025f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fa:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8025fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802601:	74 19                	je     80261c <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802603:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80260a:	00 00 00 
  80260d:	48 8b 00             	mov    (%rax),%rax
  802610:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261a:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80261c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802623:	00 00 00 
  802626:	48 8b 00             	mov    (%rax),%rax
  802629:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80262f:	c9                   	leaveq 
  802630:	c3                   	retq   

0000000000802631 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	48 83 ec 30          	sub    $0x30,%rsp
  802639:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80263c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80263f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802643:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802646:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80264b:	75 0e                	jne    80265b <ipc_send+0x2a>
		pg = (void*)UTOP;
  80264d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802654:	00 00 00 
  802657:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80265b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80265e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802661:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802665:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802668:	89 c7                	mov    %eax,%edi
  80266a:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
  802676:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802679:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80267d:	75 0c                	jne    80268b <ipc_send+0x5a>
			sys_yield();
  80267f:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80268b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80268f:	74 ca                	je     80265b <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802691:	c9                   	leaveq 
  802692:	c3                   	retq   

0000000000802693 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802693:	55                   	push   %rbp
  802694:	48 89 e5             	mov    %rsp,%rbp
  802697:	48 83 ec 14          	sub    $0x14,%rsp
  80269b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80269e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a5:	eb 5e                	jmp    802705 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8026a7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8026ae:	00 00 00 
  8026b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b4:	48 63 d0             	movslq %eax,%rdx
  8026b7:	48 89 d0             	mov    %rdx,%rax
  8026ba:	48 c1 e0 03          	shl    $0x3,%rax
  8026be:	48 01 d0             	add    %rdx,%rax
  8026c1:	48 c1 e0 05          	shl    $0x5,%rax
  8026c5:	48 01 c8             	add    %rcx,%rax
  8026c8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8026ce:	8b 00                	mov    (%rax),%eax
  8026d0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026d3:	75 2c                	jne    802701 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8026d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8026dc:	00 00 00 
  8026df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e2:	48 63 d0             	movslq %eax,%rdx
  8026e5:	48 89 d0             	mov    %rdx,%rax
  8026e8:	48 c1 e0 03          	shl    $0x3,%rax
  8026ec:	48 01 d0             	add    %rdx,%rax
  8026ef:	48 c1 e0 05          	shl    $0x5,%rax
  8026f3:	48 01 c8             	add    %rcx,%rax
  8026f6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8026fc:	8b 40 08             	mov    0x8(%rax),%eax
  8026ff:	eb 12                	jmp    802713 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802701:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802705:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80270c:	7e 99                	jle    8026a7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802713:	c9                   	leaveq 
  802714:	c3                   	retq   

0000000000802715 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802715:	55                   	push   %rbp
  802716:	48 89 e5             	mov    %rsp,%rbp
  802719:	48 83 ec 08          	sub    $0x8,%rsp
  80271d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802721:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802725:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80272c:	ff ff ff 
  80272f:	48 01 d0             	add    %rdx,%rax
  802732:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802736:	c9                   	leaveq 
  802737:	c3                   	retq   

0000000000802738 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 08          	sub    $0x8,%rsp
  802740:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802748:	48 89 c7             	mov    %rax,%rdi
  80274b:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802752:	00 00 00 
  802755:	ff d0                	callq  *%rax
  802757:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80275d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802761:	c9                   	leaveq 
  802762:	c3                   	retq   

0000000000802763 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802763:	55                   	push   %rbp
  802764:	48 89 e5             	mov    %rsp,%rbp
  802767:	48 83 ec 18          	sub    $0x18,%rsp
  80276b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80276f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802776:	eb 6b                	jmp    8027e3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802778:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277b:	48 98                	cltq   
  80277d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802783:	48 c1 e0 0c          	shl    $0xc,%rax
  802787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80278b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278f:	48 c1 e8 15          	shr    $0x15,%rax
  802793:	48 89 c2             	mov    %rax,%rdx
  802796:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80279d:	01 00 00 
  8027a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a4:	83 e0 01             	and    $0x1,%eax
  8027a7:	48 85 c0             	test   %rax,%rax
  8027aa:	74 21                	je     8027cd <fd_alloc+0x6a>
  8027ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b4:	48 89 c2             	mov    %rax,%rdx
  8027b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027be:	01 00 00 
  8027c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c5:	83 e0 01             	and    $0x1,%eax
  8027c8:	48 85 c0             	test   %rax,%rax
  8027cb:	75 12                	jne    8027df <fd_alloc+0x7c>
			*fd_store = fd;
  8027cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027d5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dd:	eb 1a                	jmp    8027f9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027e3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027e7:	7e 8f                	jle    802778 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ed:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027f4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027f9:	c9                   	leaveq 
  8027fa:	c3                   	retq   

00000000008027fb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027fb:	55                   	push   %rbp
  8027fc:	48 89 e5             	mov    %rsp,%rbp
  8027ff:	48 83 ec 20          	sub    $0x20,%rsp
  802803:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802806:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80280a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80280e:	78 06                	js     802816 <fd_lookup+0x1b>
  802810:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802814:	7e 07                	jle    80281d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80281b:	eb 6c                	jmp    802889 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80281d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802820:	48 98                	cltq   
  802822:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802828:	48 c1 e0 0c          	shl    $0xc,%rax
  80282c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802830:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802834:	48 c1 e8 15          	shr    $0x15,%rax
  802838:	48 89 c2             	mov    %rax,%rdx
  80283b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802842:	01 00 00 
  802845:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802849:	83 e0 01             	and    $0x1,%eax
  80284c:	48 85 c0             	test   %rax,%rax
  80284f:	74 21                	je     802872 <fd_lookup+0x77>
  802851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802855:	48 c1 e8 0c          	shr    $0xc,%rax
  802859:	48 89 c2             	mov    %rax,%rdx
  80285c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802863:	01 00 00 
  802866:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286a:	83 e0 01             	and    $0x1,%eax
  80286d:	48 85 c0             	test   %rax,%rax
  802870:	75 07                	jne    802879 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802872:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802877:	eb 10                	jmp    802889 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802881:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802889:	c9                   	leaveq 
  80288a:	c3                   	retq   

000000000080288b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80288b:	55                   	push   %rbp
  80288c:	48 89 e5             	mov    %rsp,%rbp
  80288f:	48 83 ec 30          	sub    $0x30,%rsp
  802893:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802897:	89 f0                	mov    %esi,%eax
  802899:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80289c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b3:	48 89 d6             	mov    %rdx,%rsi
  8028b6:	89 c7                	mov    %eax,%edi
  8028b8:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
  8028c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cb:	78 0a                	js     8028d7 <fd_close+0x4c>
	    || fd != fd2)
  8028cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8028d5:	74 12                	je     8028e9 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8028d7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8028db:	74 05                	je     8028e2 <fd_close+0x57>
  8028dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e0:	eb 05                	jmp    8028e7 <fd_close+0x5c>
  8028e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e7:	eb 69                	jmp    802952 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ed:	8b 00                	mov    (%rax),%eax
  8028ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028f3:	48 89 d6             	mov    %rdx,%rsi
  8028f6:	89 c7                	mov    %eax,%edi
  8028f8:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290b:	78 2a                	js     802937 <fd_close+0xac>
		if (dev->dev_close)
  80290d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802911:	48 8b 40 20          	mov    0x20(%rax),%rax
  802915:	48 85 c0             	test   %rax,%rax
  802918:	74 16                	je     802930 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80291a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802922:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802926:	48 89 d7             	mov    %rdx,%rdi
  802929:	ff d0                	callq  *%rax
  80292b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292e:	eb 07                	jmp    802937 <fd_close+0xac>
		else
			r = 0;
  802930:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293b:	48 89 c6             	mov    %rax,%rsi
  80293e:	bf 00 00 00 00       	mov    $0x0,%edi
  802943:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
	return r;
  80294f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802952:	c9                   	leaveq 
  802953:	c3                   	retq   

0000000000802954 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802954:	55                   	push   %rbp
  802955:	48 89 e5             	mov    %rsp,%rbp
  802958:	48 83 ec 20          	sub    $0x20,%rsp
  80295c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80295f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802963:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80296a:	eb 41                	jmp    8029ad <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80296c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802973:	00 00 00 
  802976:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802979:	48 63 d2             	movslq %edx,%rdx
  80297c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802980:	8b 00                	mov    (%rax),%eax
  802982:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802985:	75 22                	jne    8029a9 <dev_lookup+0x55>
			*dev = devtab[i];
  802987:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80298e:	00 00 00 
  802991:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802994:	48 63 d2             	movslq %edx,%rdx
  802997:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80299b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a7:	eb 60                	jmp    802a09 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8029a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029ad:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8029b4:	00 00 00 
  8029b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029ba:	48 63 d2             	movslq %edx,%rdx
  8029bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c1:	48 85 c0             	test   %rax,%rax
  8029c4:	75 a6                	jne    80296c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8029c6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029cd:	00 00 00 
  8029d0:	48 8b 00             	mov    (%rax),%rax
  8029d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029d9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8029dc:	89 c6                	mov    %eax,%esi
  8029de:	48 bf c0 50 80 00 00 	movabs $0x8050c0,%rdi
  8029e5:	00 00 00 
  8029e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ed:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  8029f4:	00 00 00 
  8029f7:	ff d1                	callq  *%rcx
	*dev = 0;
  8029f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a09:	c9                   	leaveq 
  802a0a:	c3                   	retq   

0000000000802a0b <close>:

int
close(int fdnum)
{
  802a0b:	55                   	push   %rbp
  802a0c:	48 89 e5             	mov    %rsp,%rbp
  802a0f:	48 83 ec 20          	sub    $0x20,%rsp
  802a13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a1d:	48 89 d6             	mov    %rdx,%rsi
  802a20:	89 c7                	mov    %eax,%edi
  802a22:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <close+0x31>
		return r;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 18                	jmp    802a54 <close+0x49>
	else
		return fd_close(fd, 1);
  802a3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a40:	be 01 00 00 00       	mov    $0x1,%esi
  802a45:	48 89 c7             	mov    %rax,%rdi
  802a48:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	callq  *%rax
}
  802a54:	c9                   	leaveq 
  802a55:	c3                   	retq   

0000000000802a56 <close_all>:

void
close_all(void)
{
  802a56:	55                   	push   %rbp
  802a57:	48 89 e5             	mov    %rsp,%rbp
  802a5a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a65:	eb 15                	jmp    802a7c <close_all+0x26>
		close(i);
  802a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6a:	89 c7                	mov    %eax,%edi
  802a6c:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a7c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a80:	7e e5                	jle    802a67 <close_all+0x11>
		close(i);
}
  802a82:	c9                   	leaveq 
  802a83:	c3                   	retq   

0000000000802a84 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a84:	55                   	push   %rbp
  802a85:	48 89 e5             	mov    %rsp,%rbp
  802a88:	48 83 ec 40          	sub    $0x40,%rsp
  802a8c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a8f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a92:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a96:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a99:	48 89 d6             	mov    %rdx,%rsi
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab1:	79 08                	jns    802abb <dup+0x37>
		return r;
  802ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab6:	e9 70 01 00 00       	jmpq   802c2b <dup+0x1a7>
	close(newfdnum);
  802abb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802abe:	89 c7                	mov    %eax,%edi
  802ac0:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802acc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802acf:	48 98                	cltq   
  802ad1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ad7:	48 c1 e0 0c          	shl    $0xc,%rax
  802adb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802adf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae3:	48 89 c7             	mov    %rax,%rdi
  802ae6:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
  802af2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802af6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afa:	48 89 c7             	mov    %rax,%rdi
  802afd:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
  802b09:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b11:	48 c1 e8 15          	shr    $0x15,%rax
  802b15:	48 89 c2             	mov    %rax,%rdx
  802b18:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b1f:	01 00 00 
  802b22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b26:	83 e0 01             	and    $0x1,%eax
  802b29:	48 85 c0             	test   %rax,%rax
  802b2c:	74 73                	je     802ba1 <dup+0x11d>
  802b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b32:	48 c1 e8 0c          	shr    $0xc,%rax
  802b36:	48 89 c2             	mov    %rax,%rdx
  802b39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b40:	01 00 00 
  802b43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b47:	83 e0 01             	and    $0x1,%eax
  802b4a:	48 85 c0             	test   %rax,%rax
  802b4d:	74 52                	je     802ba1 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b53:	48 c1 e8 0c          	shr    $0xc,%rax
  802b57:	48 89 c2             	mov    %rax,%rdx
  802b5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b61:	01 00 00 
  802b64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b68:	25 07 0e 00 00       	and    $0xe07,%eax
  802b6d:	89 c1                	mov    %eax,%ecx
  802b6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b77:	41 89 c8             	mov    %ecx,%r8d
  802b7a:	48 89 d1             	mov    %rdx,%rcx
  802b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b82:	48 89 c6             	mov    %rax,%rsi
  802b85:	bf 00 00 00 00       	mov    $0x0,%edi
  802b8a:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
  802b96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9d:	79 02                	jns    802ba1 <dup+0x11d>
			goto err;
  802b9f:	eb 57                	jmp    802bf8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ba1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba5:	48 c1 e8 0c          	shr    $0xc,%rax
  802ba9:	48 89 c2             	mov    %rax,%rdx
  802bac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bb3:	01 00 00 
  802bb6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bba:	25 07 0e 00 00       	and    $0xe07,%eax
  802bbf:	89 c1                	mov    %eax,%ecx
  802bc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc9:	41 89 c8             	mov    %ecx,%r8d
  802bcc:	48 89 d1             	mov    %rdx,%rcx
  802bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd4:	48 89 c6             	mov    %rax,%rsi
  802bd7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bdc:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
  802be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bef:	79 02                	jns    802bf3 <dup+0x16f>
		goto err;
  802bf1:	eb 05                	jmp    802bf8 <dup+0x174>

	return newfdnum;
  802bf3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bf6:	eb 33                	jmp    802c2b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfc:	48 89 c6             	mov    %rax,%rsi
  802bff:	bf 00 00 00 00       	mov    $0x0,%edi
  802c04:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c14:	48 89 c6             	mov    %rax,%rsi
  802c17:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1c:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
	return r;
  802c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c2b:	c9                   	leaveq 
  802c2c:	c3                   	retq   

0000000000802c2d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c2d:	55                   	push   %rbp
  802c2e:	48 89 e5             	mov    %rsp,%rbp
  802c31:	48 83 ec 40          	sub    $0x40,%rsp
  802c35:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c3c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c40:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c44:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c47:	48 89 d6             	mov    %rdx,%rsi
  802c4a:	89 c7                	mov    %eax,%edi
  802c4c:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5f:	78 24                	js     802c85 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	8b 00                	mov    (%rax),%eax
  802c67:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c6b:	48 89 d6             	mov    %rdx,%rsi
  802c6e:	89 c7                	mov    %eax,%edi
  802c70:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	callq  *%rax
  802c7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c83:	79 05                	jns    802c8a <read+0x5d>
		return r;
  802c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c88:	eb 76                	jmp    802d00 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8e:	8b 40 08             	mov    0x8(%rax),%eax
  802c91:	83 e0 03             	and    $0x3,%eax
  802c94:	83 f8 01             	cmp    $0x1,%eax
  802c97:	75 3a                	jne    802cd3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c99:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ca0:	00 00 00 
  802ca3:	48 8b 00             	mov    (%rax),%rax
  802ca6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cac:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802caf:	89 c6                	mov    %eax,%esi
  802cb1:	48 bf df 50 80 00 00 	movabs $0x8050df,%rdi
  802cb8:	00 00 00 
  802cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc0:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802cc7:	00 00 00 
  802cca:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ccc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cd1:	eb 2d                	jmp    802d00 <read+0xd3>
	}
	if (!dev->dev_read)
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cdb:	48 85 c0             	test   %rax,%rax
  802cde:	75 07                	jne    802ce7 <read+0xba>
		return -E_NOT_SUPP;
  802ce0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ce5:	eb 19                	jmp    802d00 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ceb:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cf3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cf7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cfb:	48 89 cf             	mov    %rcx,%rdi
  802cfe:	ff d0                	callq  *%rax
}
  802d00:	c9                   	leaveq 
  802d01:	c3                   	retq   

0000000000802d02 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d02:	55                   	push   %rbp
  802d03:	48 89 e5             	mov    %rsp,%rbp
  802d06:	48 83 ec 30          	sub    $0x30,%rsp
  802d0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d11:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d1c:	eb 49                	jmp    802d67 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d21:	48 98                	cltq   
  802d23:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d27:	48 29 c2             	sub    %rax,%rdx
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	48 63 c8             	movslq %eax,%rcx
  802d30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d34:	48 01 c1             	add    %rax,%rcx
  802d37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3a:	48 89 ce             	mov    %rcx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d4e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d52:	79 05                	jns    802d59 <readn+0x57>
			return m;
  802d54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d57:	eb 1c                	jmp    802d75 <readn+0x73>
		if (m == 0)
  802d59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d5d:	75 02                	jne    802d61 <readn+0x5f>
			break;
  802d5f:	eb 11                	jmp    802d72 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d64:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6a:	48 98                	cltq   
  802d6c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d70:	72 ac                	jb     802d1e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d75:	c9                   	leaveq 
  802d76:	c3                   	retq   

0000000000802d77 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d77:	55                   	push   %rbp
  802d78:	48 89 e5             	mov    %rsp,%rbp
  802d7b:	48 83 ec 40          	sub    $0x40,%rsp
  802d7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d86:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d8a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d8e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d91:	48 89 d6             	mov    %rdx,%rsi
  802d94:	89 c7                	mov    %eax,%edi
  802d96:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802d9d:	00 00 00 
  802da0:	ff d0                	callq  *%rax
  802da2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da9:	78 24                	js     802dcf <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daf:	8b 00                	mov    (%rax),%eax
  802db1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802db5:	48 89 d6             	mov    %rdx,%rsi
  802db8:	89 c7                	mov    %eax,%edi
  802dba:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
  802dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcd:	79 05                	jns    802dd4 <write+0x5d>
		return r;
  802dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd2:	eb 75                	jmp    802e49 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd8:	8b 40 08             	mov    0x8(%rax),%eax
  802ddb:	83 e0 03             	and    $0x3,%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	75 3a                	jne    802e1c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802de2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802de9:	00 00 00 
  802dec:	48 8b 00             	mov    (%rax),%rax
  802def:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802df5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802df8:	89 c6                	mov    %eax,%esi
  802dfa:	48 bf fb 50 80 00 00 	movabs $0x8050fb,%rdi
  802e01:	00 00 00 
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802e10:	00 00 00 
  802e13:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e1a:	eb 2d                	jmp    802e49 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e20:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e24:	48 85 c0             	test   %rax,%rax
  802e27:	75 07                	jne    802e30 <write+0xb9>
		return -E_NOT_SUPP;
  802e29:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e2e:	eb 19                	jmp    802e49 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802e30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e34:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e40:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e44:	48 89 cf             	mov    %rcx,%rdi
  802e47:	ff d0                	callq  *%rax
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <seek>:

int
seek(int fdnum, off_t offset)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 18          	sub    $0x18,%rsp
  802e53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e56:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e59:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e60:	48 89 d6             	mov    %rdx,%rsi
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
  802e71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e78:	79 05                	jns    802e7f <seek+0x34>
		return r;
  802e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7d:	eb 0f                	jmp    802e8e <seek+0x43>
	fd->fd_offset = offset;
  802e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e83:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8e:	c9                   	leaveq 
  802e8f:	c3                   	retq   

0000000000802e90 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e90:	55                   	push   %rbp
  802e91:	48 89 e5             	mov    %rsp,%rbp
  802e94:	48 83 ec 30          	sub    $0x30,%rsp
  802e98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e9b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e9e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ea2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ea5:	48 89 d6             	mov    %rdx,%rsi
  802ea8:	89 c7                	mov    %eax,%edi
  802eaa:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
  802eb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebd:	78 24                	js     802ee3 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	8b 00                	mov    (%rax),%eax
  802ec5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ec9:	48 89 d6             	mov    %rdx,%rsi
  802ecc:	89 c7                	mov    %eax,%edi
  802ece:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
  802eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee1:	79 05                	jns    802ee8 <ftruncate+0x58>
		return r;
  802ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee6:	eb 72                	jmp    802f5a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eec:	8b 40 08             	mov    0x8(%rax),%eax
  802eef:	83 e0 03             	and    $0x3,%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	75 3a                	jne    802f30 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ef6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802efd:	00 00 00 
  802f00:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f03:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f09:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f0c:	89 c6                	mov    %eax,%esi
  802f0e:	48 bf 18 51 80 00 00 	movabs $0x805118,%rdi
  802f15:	00 00 00 
  802f18:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1d:	48 b9 74 06 80 00 00 	movabs $0x800674,%rcx
  802f24:	00 00 00 
  802f27:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f2e:	eb 2a                	jmp    802f5a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f34:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f38:	48 85 c0             	test   %rax,%rax
  802f3b:	75 07                	jne    802f44 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f3d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f42:	eb 16                	jmp    802f5a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f48:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f50:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f53:	89 ce                	mov    %ecx,%esi
  802f55:	48 89 d7             	mov    %rdx,%rdi
  802f58:	ff d0                	callq  *%rax
}
  802f5a:	c9                   	leaveq 
  802f5b:	c3                   	retq   

0000000000802f5c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f5c:	55                   	push   %rbp
  802f5d:	48 89 e5             	mov    %rsp,%rbp
  802f60:	48 83 ec 30          	sub    $0x30,%rsp
  802f64:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f6b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f6f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f72:	48 89 d6             	mov    %rdx,%rsi
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	78 24                	js     802fb0 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f90:	8b 00                	mov    (%rax),%eax
  802f92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f96:	48 89 d6             	mov    %rdx,%rsi
  802f99:	89 c7                	mov    %eax,%edi
  802f9b:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
  802fa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fae:	79 05                	jns    802fb5 <fstat+0x59>
		return r;
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb3:	eb 5e                	jmp    803013 <fstat+0xb7>
	if (!dev->dev_stat)
  802fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb9:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fbd:	48 85 c0             	test   %rax,%rax
  802fc0:	75 07                	jne    802fc9 <fstat+0x6d>
		return -E_NOT_SUPP;
  802fc2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fc7:	eb 4a                	jmp    803013 <fstat+0xb7>
	stat->st_name[0] = 0;
  802fc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fcd:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802fd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802fdb:	00 00 00 
	stat->st_isdir = 0;
  802fde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fe9:	00 00 00 
	stat->st_dev = dev;
  802fec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ff0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ff4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	48 8b 40 28          	mov    0x28(%rax),%rax
  803003:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803007:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80300b:	48 89 ce             	mov    %rcx,%rsi
  80300e:	48 89 d7             	mov    %rdx,%rdi
  803011:	ff d0                	callq  *%rax
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 20          	sub    $0x20,%rsp
  80301d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803029:	be 00 00 00 00       	mov    $0x0,%esi
  80302e:	48 89 c7             	mov    %rax,%rdi
  803031:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803044:	79 05                	jns    80304b <stat+0x36>
		return fd;
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803049:	eb 2f                	jmp    80307a <stat+0x65>
	r = fstat(fd, stat);
  80304b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80304f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803052:	48 89 d6             	mov    %rdx,%rsi
  803055:	89 c7                	mov    %eax,%edi
  803057:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
  803063:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803069:	89 c7                	mov    %eax,%edi
  80306b:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
	return r;
  803077:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80307a:	c9                   	leaveq 
  80307b:	c3                   	retq   

000000000080307c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80307c:	55                   	push   %rbp
  80307d:	48 89 e5             	mov    %rsp,%rbp
  803080:	48 83 ec 10          	sub    $0x10,%rsp
  803084:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803087:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80308b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803092:	00 00 00 
  803095:	8b 00                	mov    (%rax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	75 1d                	jne    8030b8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80309b:	bf 01 00 00 00       	mov    $0x1,%edi
  8030a0:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
  8030ac:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8030b3:	00 00 00 
  8030b6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bf:	00 00 00 
  8030c2:	8b 00                	mov    (%rax),%eax
  8030c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030c7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030cc:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8030d3:	00 00 00 
  8030d6:	89 c7                	mov    %eax,%edi
  8030d8:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8030ed:	48 89 c6             	mov    %rax,%rsi
  8030f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f5:	48 b8 2b 25 80 00 00 	movabs $0x80252b,%rax
  8030fc:	00 00 00 
  8030ff:	ff d0                	callq  *%rax
}
  803101:	c9                   	leaveq 
  803102:	c3                   	retq   

0000000000803103 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	48 83 ec 30          	sub    $0x30,%rsp
  80310b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80310f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803112:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803119:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803127:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80312c:	75 08                	jne    803136 <open+0x33>
	{
		return r;
  80312e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803131:	e9 f2 00 00 00       	jmpq   803228 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803136:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80314c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803153:	7e 0a                	jle    80315f <open+0x5c>
	{
		return -E_BAD_PATH;
  803155:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80315a:	e9 c9 00 00 00       	jmpq   803228 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80315f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803166:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803167:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80316b:	48 89 c7             	mov    %rax,%rdi
  80316e:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	78 09                	js     80318c <open+0x89>
  803183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803187:	48 85 c0             	test   %rax,%rax
  80318a:	75 08                	jne    803194 <open+0x91>
		{
			return r;
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	e9 94 00 00 00       	jmpq   803228 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803198:	ba 00 04 00 00       	mov    $0x400,%edx
  80319d:	48 89 c6             	mov    %rax,%rsi
  8031a0:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8031a7:	00 00 00 
  8031aa:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8031b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8031c3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8031c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cd:	48 89 c6             	mov    %rax,%rsi
  8031d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8031d5:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	callq  *%rax
  8031e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e8:	79 2b                	jns    803215 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8031ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ee:	be 00 00 00 00       	mov    $0x0,%esi
  8031f3:	48 89 c7             	mov    %rax,%rdi
  8031f6:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
  803202:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803205:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803209:	79 05                	jns    803210 <open+0x10d>
			{
				return d;
  80320b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80320e:	eb 18                	jmp    803228 <open+0x125>
			}
			return r;
  803210:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803213:	eb 13                	jmp    803228 <open+0x125>
		}	
		return fd2num(fd_store);
  803215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803219:	48 89 c7             	mov    %rax,%rdi
  80321c:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803228:	c9                   	leaveq 
  803229:	c3                   	retq   

000000000080322a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80322a:	55                   	push   %rbp
  80322b:	48 89 e5             	mov    %rsp,%rbp
  80322e:	48 83 ec 10          	sub    $0x10,%rsp
  803232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323a:	8b 50 0c             	mov    0xc(%rax),%edx
  80323d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803244:	00 00 00 
  803247:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803249:	be 00 00 00 00       	mov    $0x0,%esi
  80324e:	bf 06 00 00 00       	mov    $0x6,%edi
  803253:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
}
  80325f:	c9                   	leaveq 
  803260:	c3                   	retq   

0000000000803261 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803261:	55                   	push   %rbp
  803262:	48 89 e5             	mov    %rsp,%rbp
  803265:	48 83 ec 30          	sub    $0x30,%rsp
  803269:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80326d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803271:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80327c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803281:	74 07                	je     80328a <devfile_read+0x29>
  803283:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803288:	75 07                	jne    803291 <devfile_read+0x30>
		return -E_INVAL;
  80328a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80328f:	eb 77                	jmp    803308 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803295:	8b 50 0c             	mov    0xc(%rax),%edx
  803298:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80329f:	00 00 00 
  8032a2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032a4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ab:	00 00 00 
  8032ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8032b6:	be 00 00 00 00       	mov    $0x0,%esi
  8032bb:	bf 03 00 00 00       	mov    $0x3,%edi
  8032c0:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
  8032cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d3:	7f 05                	jg     8032da <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8032d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d8:	eb 2e                	jmp    803308 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	48 63 d0             	movslq %eax,%rdx
  8032e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e4:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032eb:	00 00 00 
  8032ee:	48 89 c7             	mov    %rax,%rdi
  8032f1:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8032fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803301:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803308:	c9                   	leaveq 
  803309:	c3                   	retq   

000000000080330a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80330a:	55                   	push   %rbp
  80330b:	48 89 e5             	mov    %rsp,%rbp
  80330e:	48 83 ec 30          	sub    $0x30,%rsp
  803312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803316:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80331a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80331e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803325:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80332a:	74 07                	je     803333 <devfile_write+0x29>
  80332c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803331:	75 08                	jne    80333b <devfile_write+0x31>
		return r;
  803333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803336:	e9 9a 00 00 00       	jmpq   8033d5 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80333b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333f:	8b 50 0c             	mov    0xc(%rax),%edx
  803342:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803349:	00 00 00 
  80334c:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80334e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803355:	00 
  803356:	76 08                	jbe    803360 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803358:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80335f:	00 
	}
	fsipcbuf.write.req_n = n;
  803360:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803367:	00 00 00 
  80336a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80336e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803372:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337a:	48 89 c6             	mov    %rax,%rsi
  80337d:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803384:	00 00 00 
  803387:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803393:	be 00 00 00 00       	mov    $0x0,%esi
  803398:	bf 04 00 00 00       	mov    $0x4,%edi
  80339d:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
  8033a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b0:	7f 20                	jg     8033d2 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8033b2:	48 bf 3e 51 80 00 00 	movabs $0x80513e,%rdi
  8033b9:	00 00 00 
  8033bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c1:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8033c8:	00 00 00 
  8033cb:	ff d2                	callq  *%rdx
		return r;
  8033cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d0:	eb 03                	jmp    8033d5 <devfile_write+0xcb>
	}
	return r;
  8033d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8033d5:	c9                   	leaveq 
  8033d6:	c3                   	retq   

00000000008033d7 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	48 83 ec 20          	sub    $0x20,%rsp
  8033df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ee:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f5:	00 00 00 
  8033f8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033fa:	be 00 00 00 00       	mov    $0x0,%esi
  8033ff:	bf 05 00 00 00       	mov    $0x5,%edi
  803404:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  80340b:	00 00 00 
  80340e:	ff d0                	callq  *%rax
  803410:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803417:	79 05                	jns    80341e <devfile_stat+0x47>
		return r;
  803419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341c:	eb 56                	jmp    803474 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80341e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803422:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803429:	00 00 00 
  80342c:	48 89 c7             	mov    %rax,%rdi
  80342f:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80343b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803442:	00 00 00 
  803445:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80344b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803455:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80345c:	00 00 00 
  80345f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803465:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803469:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80346f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803474:	c9                   	leaveq 
  803475:	c3                   	retq   

0000000000803476 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803476:	55                   	push   %rbp
  803477:	48 89 e5             	mov    %rsp,%rbp
  80347a:	48 83 ec 10          	sub    $0x10,%rsp
  80347e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803482:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803489:	8b 50 0c             	mov    0xc(%rax),%edx
  80348c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803493:	00 00 00 
  803496:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803498:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80349f:	00 00 00 
  8034a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034a5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8034a8:	be 00 00 00 00       	mov    $0x0,%esi
  8034ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8034b2:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
}
  8034be:	c9                   	leaveq 
  8034bf:	c3                   	retq   

00000000008034c0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8034c0:	55                   	push   %rbp
  8034c1:	48 89 e5             	mov    %rsp,%rbp
  8034c4:	48 83 ec 10          	sub    $0x10,%rsp
  8034c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d0:	48 89 c7             	mov    %rax,%rdi
  8034d3:	48 b8 bd 11 80 00 00 	movabs $0x8011bd,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034e4:	7e 07                	jle    8034ed <remove+0x2d>
		return -E_BAD_PATH;
  8034e6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034eb:	eb 33                	jmp    803520 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f1:	48 89 c6             	mov    %rax,%rsi
  8034f4:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034fb:	00 00 00 
  8034fe:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803505:	00 00 00 
  803508:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80350a:	be 00 00 00 00       	mov    $0x0,%esi
  80350f:	bf 07 00 00 00       	mov    $0x7,%edi
  803514:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
}
  803520:	c9                   	leaveq 
  803521:	c3                   	retq   

0000000000803522 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803522:	55                   	push   %rbp
  803523:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803526:	be 00 00 00 00       	mov    $0x0,%esi
  80352b:	bf 08 00 00 00       	mov    $0x8,%edi
  803530:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
}
  80353c:	5d                   	pop    %rbp
  80353d:	c3                   	retq   

000000000080353e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80353e:	55                   	push   %rbp
  80353f:	48 89 e5             	mov    %rsp,%rbp
  803542:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803549:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803550:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803557:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80355e:	be 00 00 00 00       	mov    $0x0,%esi
  803563:	48 89 c7             	mov    %rax,%rdi
  803566:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
  803572:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803575:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803579:	79 28                	jns    8035a3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80357b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357e:	89 c6                	mov    %eax,%esi
  803580:	48 bf 5a 51 80 00 00 	movabs $0x80515a,%rdi
  803587:	00 00 00 
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
  80358f:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  803596:	00 00 00 
  803599:	ff d2                	callq  *%rdx
		return fd_src;
  80359b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359e:	e9 74 01 00 00       	jmpq   803717 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8035a3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8035aa:	be 01 01 00 00       	mov    $0x101,%esi
  8035af:	48 89 c7             	mov    %rax,%rdi
  8035b2:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  8035b9:	00 00 00 
  8035bc:	ff d0                	callq  *%rax
  8035be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8035c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035c5:	79 39                	jns    803600 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ca:	89 c6                	mov    %eax,%esi
  8035cc:	48 bf 70 51 80 00 00 	movabs $0x805170,%rdi
  8035d3:	00 00 00 
  8035d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035db:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8035e2:	00 00 00 
  8035e5:	ff d2                	callq  *%rdx
		close(fd_src);
  8035e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ea:	89 c7                	mov    %eax,%edi
  8035ec:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
		return fd_dest;
  8035f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fb:	e9 17 01 00 00       	jmpq   803717 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803600:	eb 74                	jmp    803676 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803602:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803605:	48 63 d0             	movslq %eax,%rdx
  803608:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80360f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803612:	48 89 ce             	mov    %rcx,%rsi
  803615:	89 c7                	mov    %eax,%edi
  803617:	48 b8 77 2d 80 00 00 	movabs $0x802d77,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
  803623:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803626:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80362a:	79 4a                	jns    803676 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80362c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80362f:	89 c6                	mov    %eax,%esi
  803631:	48 bf 8a 51 80 00 00 	movabs $0x80518a,%rdi
  803638:	00 00 00 
  80363b:	b8 00 00 00 00       	mov    $0x0,%eax
  803640:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  803647:	00 00 00 
  80364a:	ff d2                	callq  *%rdx
			close(fd_src);
  80364c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364f:	89 c7                	mov    %eax,%edi
  803651:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
			close(fd_dest);
  80365d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803660:	89 c7                	mov    %eax,%edi
  803662:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
			return write_size;
  80366e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803671:	e9 a1 00 00 00       	jmpq   803717 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803676:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80367d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803680:	ba 00 02 00 00       	mov    $0x200,%edx
  803685:	48 89 ce             	mov    %rcx,%rsi
  803688:	89 c7                	mov    %eax,%edi
  80368a:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803699:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80369d:	0f 8f 5f ff ff ff    	jg     803602 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8036a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036a7:	79 47                	jns    8036f0 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8036a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036ac:	89 c6                	mov    %eax,%esi
  8036ae:	48 bf 9d 51 80 00 00 	movabs $0x80519d,%rdi
  8036b5:	00 00 00 
  8036b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bd:	48 ba 74 06 80 00 00 	movabs $0x800674,%rdx
  8036c4:	00 00 00 
  8036c7:	ff d2                	callq  *%rdx
		close(fd_src);
  8036c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cc:	89 c7                	mov    %eax,%edi
  8036ce:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  8036d5:	00 00 00 
  8036d8:	ff d0                	callq  *%rax
		close(fd_dest);
  8036da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036dd:	89 c7                	mov    %eax,%edi
  8036df:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  8036e6:	00 00 00 
  8036e9:	ff d0                	callq  *%rax
		return read_size;
  8036eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036ee:	eb 27                	jmp    803717 <copy+0x1d9>
	}
	close(fd_src);
  8036f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f3:	89 c7                	mov    %eax,%edi
  8036f5:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  8036fc:	00 00 00 
  8036ff:	ff d0                	callq  *%rax
	close(fd_dest);
  803701:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803704:	89 c7                	mov    %eax,%edi
  803706:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
	return 0;
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 18          	sub    $0x18,%rsp
  803721:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803729:	48 c1 e8 15          	shr    $0x15,%rax
  80372d:	48 89 c2             	mov    %rax,%rdx
  803730:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803737:	01 00 00 
  80373a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80373e:	83 e0 01             	and    $0x1,%eax
  803741:	48 85 c0             	test   %rax,%rax
  803744:	75 07                	jne    80374d <pageref+0x34>
		return 0;
  803746:	b8 00 00 00 00       	mov    $0x0,%eax
  80374b:	eb 53                	jmp    8037a0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80374d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803751:	48 c1 e8 0c          	shr    $0xc,%rax
  803755:	48 89 c2             	mov    %rax,%rdx
  803758:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80375f:	01 00 00 
  803762:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803766:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80376a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376e:	83 e0 01             	and    $0x1,%eax
  803771:	48 85 c0             	test   %rax,%rax
  803774:	75 07                	jne    80377d <pageref+0x64>
		return 0;
  803776:	b8 00 00 00 00       	mov    $0x0,%eax
  80377b:	eb 23                	jmp    8037a0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80377d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803781:	48 c1 e8 0c          	shr    $0xc,%rax
  803785:	48 89 c2             	mov    %rax,%rdx
  803788:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80378f:	00 00 00 
  803792:	48 c1 e2 04          	shl    $0x4,%rdx
  803796:	48 01 d0             	add    %rdx,%rax
  803799:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80379d:	0f b7 c0             	movzwl %ax,%eax
}
  8037a0:	c9                   	leaveq 
  8037a1:	c3                   	retq   

00000000008037a2 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037a2:	55                   	push   %rbp
  8037a3:	48 89 e5             	mov    %rsp,%rbp
  8037a6:	48 83 ec 20          	sub    $0x20,%rsp
  8037aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b4:	48 89 d6             	mov    %rdx,%rsi
  8037b7:	89 c7                	mov    %eax,%edi
  8037b9:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
  8037c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cc:	79 05                	jns    8037d3 <fd2sockid+0x31>
		return r;
  8037ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d1:	eb 24                	jmp    8037f7 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	8b 10                	mov    (%rax),%edx
  8037d9:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8037e0:	00 00 00 
  8037e3:	8b 00                	mov    (%rax),%eax
  8037e5:	39 c2                	cmp    %eax,%edx
  8037e7:	74 07                	je     8037f0 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8037e9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8037ee:	eb 07                	jmp    8037f7 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8037f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f4:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8037f7:	c9                   	leaveq 
  8037f8:	c3                   	retq   

00000000008037f9 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8037f9:	55                   	push   %rbp
  8037fa:	48 89 e5             	mov    %rsp,%rbp
  8037fd:	48 83 ec 20          	sub    $0x20,%rsp
  803801:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803804:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803808:	48 89 c7             	mov    %rax,%rdi
  80380b:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
  803817:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381e:	78 26                	js     803846 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803824:	ba 07 04 00 00       	mov    $0x407,%edx
  803829:	48 89 c6             	mov    %rax,%rsi
  80382c:	bf 00 00 00 00       	mov    $0x0,%edi
  803831:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803844:	79 16                	jns    80385c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803849:	89 c7                	mov    %eax,%edi
  80384b:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
		return r;
  803857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385a:	eb 3a                	jmp    803896 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803867:	00 00 00 
  80386a:	8b 12                	mov    (%rdx),%edx
  80386c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80386e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803872:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803880:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803887:	48 89 c7             	mov    %rax,%rdi
  80388a:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
}
  803896:	c9                   	leaveq 
  803897:	c3                   	retq   

0000000000803898 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803898:	55                   	push   %rbp
  803899:	48 89 e5             	mov    %rsp,%rbp
  80389c:	48 83 ec 30          	sub    $0x30,%rsp
  8038a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ae:	89 c7                	mov    %eax,%edi
  8038b0:	48 b8 a2 37 80 00 00 	movabs $0x8037a2,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c3:	79 05                	jns    8038ca <accept+0x32>
		return r;
  8038c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c8:	eb 3b                	jmp    803905 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d5:	48 89 ce             	mov    %rcx,%rsi
  8038d8:	89 c7                	mov    %eax,%edi
  8038da:	48 b8 e3 3b 80 00 00 	movabs $0x803be3,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
  8038e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ed:	79 05                	jns    8038f4 <accept+0x5c>
		return r;
  8038ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f2:	eb 11                	jmp    803905 <accept+0x6d>
	return alloc_sockfd(r);
  8038f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f7:	89 c7                	mov    %eax,%edi
  8038f9:	48 b8 f9 37 80 00 00 	movabs $0x8037f9,%rax
  803900:	00 00 00 
  803903:	ff d0                	callq  *%rax
}
  803905:	c9                   	leaveq 
  803906:	c3                   	retq   

0000000000803907 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803907:	55                   	push   %rbp
  803908:	48 89 e5             	mov    %rsp,%rbp
  80390b:	48 83 ec 20          	sub    $0x20,%rsp
  80390f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803912:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803916:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803919:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391c:	89 c7                	mov    %eax,%edi
  80391e:	48 b8 a2 37 80 00 00 	movabs $0x8037a2,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803931:	79 05                	jns    803938 <bind+0x31>
		return r;
  803933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803936:	eb 1b                	jmp    803953 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803938:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80393b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80393f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803942:	48 89 ce             	mov    %rcx,%rsi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 62 3c 80 00 00 	movabs $0x803c62,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
}
  803953:	c9                   	leaveq 
  803954:	c3                   	retq   

0000000000803955 <shutdown>:

int
shutdown(int s, int how)
{
  803955:	55                   	push   %rbp
  803956:	48 89 e5             	mov    %rsp,%rbp
  803959:	48 83 ec 20          	sub    $0x20,%rsp
  80395d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803960:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803963:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803966:	89 c7                	mov    %eax,%edi
  803968:	48 b8 a2 37 80 00 00 	movabs $0x8037a2,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
  803974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397b:	79 05                	jns    803982 <shutdown+0x2d>
		return r;
  80397d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803980:	eb 16                	jmp    803998 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803982:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803988:	89 d6                	mov    %edx,%esi
  80398a:	89 c7                	mov    %eax,%edi
  80398c:	48 b8 c6 3c 80 00 00 	movabs $0x803cc6,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
}
  803998:	c9                   	leaveq 
  803999:	c3                   	retq   

000000000080399a <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80399a:	55                   	push   %rbp
  80399b:	48 89 e5             	mov    %rsp,%rbp
  80399e:	48 83 ec 10          	sub    $0x10,%rsp
  8039a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8039a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039aa:	48 89 c7             	mov    %rax,%rdi
  8039ad:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  8039b4:	00 00 00 
  8039b7:	ff d0                	callq  *%rax
  8039b9:	83 f8 01             	cmp    $0x1,%eax
  8039bc:	75 17                	jne    8039d5 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8039be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c2:	8b 40 0c             	mov    0xc(%rax),%eax
  8039c5:	89 c7                	mov    %eax,%edi
  8039c7:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  8039ce:	00 00 00 
  8039d1:	ff d0                	callq  *%rax
  8039d3:	eb 05                	jmp    8039da <devsock_close+0x40>
	else
		return 0;
  8039d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039da:	c9                   	leaveq 
  8039db:	c3                   	retq   

00000000008039dc <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039dc:	55                   	push   %rbp
  8039dd:	48 89 e5             	mov    %rsp,%rbp
  8039e0:	48 83 ec 20          	sub    $0x20,%rsp
  8039e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039eb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f1:	89 c7                	mov    %eax,%edi
  8039f3:	48 b8 a2 37 80 00 00 	movabs $0x8037a2,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
  8039ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a06:	79 05                	jns    803a0d <connect+0x31>
		return r;
  803a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0b:	eb 1b                	jmp    803a28 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a0d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a10:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a17:	48 89 ce             	mov    %rcx,%rsi
  803a1a:	89 c7                	mov    %eax,%edi
  803a1c:	48 b8 33 3d 80 00 00 	movabs $0x803d33,%rax
  803a23:	00 00 00 
  803a26:	ff d0                	callq  *%rax
}
  803a28:	c9                   	leaveq 
  803a29:	c3                   	retq   

0000000000803a2a <listen>:

int
listen(int s, int backlog)
{
  803a2a:	55                   	push   %rbp
  803a2b:	48 89 e5             	mov    %rsp,%rbp
  803a2e:	48 83 ec 20          	sub    $0x20,%rsp
  803a32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a35:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a3b:	89 c7                	mov    %eax,%edi
  803a3d:	48 b8 a2 37 80 00 00 	movabs $0x8037a2,%rax
  803a44:	00 00 00 
  803a47:	ff d0                	callq  *%rax
  803a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a50:	79 05                	jns    803a57 <listen+0x2d>
		return r;
  803a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a55:	eb 16                	jmp    803a6d <listen+0x43>
	return nsipc_listen(r, backlog);
  803a57:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	89 d6                	mov    %edx,%esi
  803a5f:	89 c7                	mov    %eax,%edi
  803a61:	48 b8 97 3d 80 00 00 	movabs $0x803d97,%rax
  803a68:	00 00 00 
  803a6b:	ff d0                	callq  *%rax
}
  803a6d:	c9                   	leaveq 
  803a6e:	c3                   	retq   

0000000000803a6f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a6f:	55                   	push   %rbp
  803a70:	48 89 e5             	mov    %rsp,%rbp
  803a73:	48 83 ec 20          	sub    $0x20,%rsp
  803a77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a87:	89 c2                	mov    %eax,%edx
  803a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8d:	8b 40 0c             	mov    0xc(%rax),%eax
  803a90:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a94:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a99:	89 c7                	mov    %eax,%edi
  803a9b:	48 b8 d7 3d 80 00 00 	movabs $0x803dd7,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 20          	sub    $0x20,%rsp
  803ab1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ab5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ab9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ac1:	89 c2                	mov    %eax,%edx
  803ac3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac7:	8b 40 0c             	mov    0xc(%rax),%eax
  803aca:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ad3:	89 c7                	mov    %eax,%edi
  803ad5:	48 b8 a3 3e 80 00 00 	movabs $0x803ea3,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
}
  803ae1:	c9                   	leaveq 
  803ae2:	c3                   	retq   

0000000000803ae3 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ae3:	55                   	push   %rbp
  803ae4:	48 89 e5             	mov    %rsp,%rbp
  803ae7:	48 83 ec 10          	sub    $0x10,%rsp
  803aeb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803af3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af7:	48 be b8 51 80 00 00 	movabs $0x8051b8,%rsi
  803afe:	00 00 00 
  803b01:	48 89 c7             	mov    %rax,%rdi
  803b04:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
	return 0;
  803b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b15:	c9                   	leaveq 
  803b16:	c3                   	retq   

0000000000803b17 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b17:	55                   	push   %rbp
  803b18:	48 89 e5             	mov    %rsp,%rbp
  803b1b:	48 83 ec 20          	sub    $0x20,%rsp
  803b1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b22:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b25:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b28:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803b2b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b31:	89 ce                	mov    %ecx,%esi
  803b33:	89 c7                	mov    %eax,%edi
  803b35:	48 b8 5b 3f 80 00 00 	movabs $0x803f5b,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b48:	79 05                	jns    803b4f <socket+0x38>
		return r;
  803b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4d:	eb 11                	jmp    803b60 <socket+0x49>
	return alloc_sockfd(r);
  803b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b52:	89 c7                	mov    %eax,%edi
  803b54:	48 b8 f9 37 80 00 00 	movabs $0x8037f9,%rax
  803b5b:	00 00 00 
  803b5e:	ff d0                	callq  *%rax
}
  803b60:	c9                   	leaveq 
  803b61:	c3                   	retq   

0000000000803b62 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b62:	55                   	push   %rbp
  803b63:	48 89 e5             	mov    %rsp,%rbp
  803b66:	48 83 ec 10          	sub    $0x10,%rsp
  803b6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b6d:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b74:	00 00 00 
  803b77:	8b 00                	mov    (%rax),%eax
  803b79:	85 c0                	test   %eax,%eax
  803b7b:	75 1d                	jne    803b9a <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b7d:	bf 02 00 00 00       	mov    $0x2,%edi
  803b82:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	callq  *%rax
  803b8e:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803b95:	00 00 00 
  803b98:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b9a:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ba1:	00 00 00 
  803ba4:	8b 00                	mov    (%rax),%eax
  803ba6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ba9:	b9 07 00 00 00       	mov    $0x7,%ecx
  803bae:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803bb5:	00 00 00 
  803bb8:	89 c7                	mov    %eax,%edi
  803bba:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  803bcb:	be 00 00 00 00       	mov    $0x0,%esi
  803bd0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd5:	48 b8 2b 25 80 00 00 	movabs $0x80252b,%rax
  803bdc:	00 00 00 
  803bdf:	ff d0                	callq  *%rax
}
  803be1:	c9                   	leaveq 
  803be2:	c3                   	retq   

0000000000803be3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803be3:	55                   	push   %rbp
  803be4:	48 89 e5             	mov    %rsp,%rbp
  803be7:	48 83 ec 30          	sub    $0x30,%rsp
  803beb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803bf6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bfd:	00 00 00 
  803c00:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c03:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c05:	bf 01 00 00 00       	mov    $0x1,%edi
  803c0a:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
  803c16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1d:	78 3e                	js     803c5d <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c26:	00 00 00 
  803c29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c31:	8b 40 10             	mov    0x10(%rax),%eax
  803c34:	89 c2                	mov    %eax,%edx
  803c36:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3e:	48 89 ce             	mov    %rcx,%rsi
  803c41:	48 89 c7             	mov    %rax,%rdi
  803c44:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803c4b:	00 00 00 
  803c4e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c54:	8b 50 10             	mov    0x10(%rax),%edx
  803c57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5b:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c60:	c9                   	leaveq 
  803c61:	c3                   	retq   

0000000000803c62 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c62:	55                   	push   %rbp
  803c63:	48 89 e5             	mov    %rsp,%rbp
  803c66:	48 83 ec 10          	sub    $0x10,%rsp
  803c6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c71:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c74:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7b:	00 00 00 
  803c7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c81:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c83:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8a:	48 89 c6             	mov    %rax,%rsi
  803c8d:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c94:	00 00 00 
  803c97:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ca3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803caa:	00 00 00 
  803cad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803cb3:	bf 02 00 00 00       	mov    $0x2,%edi
  803cb8:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
}
  803cc4:	c9                   	leaveq 
  803cc5:	c3                   	retq   

0000000000803cc6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803cc6:	55                   	push   %rbp
  803cc7:	48 89 e5             	mov    %rsp,%rbp
  803cca:	48 83 ec 10          	sub    $0x10,%rsp
  803cce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cd1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803cd4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cdb:	00 00 00 
  803cde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ce1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ce3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cea:	00 00 00 
  803ced:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cf0:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803cf3:	bf 03 00 00 00       	mov    $0x3,%edi
  803cf8:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
}
  803d04:	c9                   	leaveq 
  803d05:	c3                   	retq   

0000000000803d06 <nsipc_close>:

int
nsipc_close(int s)
{
  803d06:	55                   	push   %rbp
  803d07:	48 89 e5             	mov    %rsp,%rbp
  803d0a:	48 83 ec 10          	sub    $0x10,%rsp
  803d0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d11:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d18:	00 00 00 
  803d1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d1e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d20:	bf 04 00 00 00       	mov    $0x4,%edi
  803d25:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803d2c:	00 00 00 
  803d2f:	ff d0                	callq  *%rax
}
  803d31:	c9                   	leaveq 
  803d32:	c3                   	retq   

0000000000803d33 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d33:	55                   	push   %rbp
  803d34:	48 89 e5             	mov    %rsp,%rbp
  803d37:	48 83 ec 10          	sub    $0x10,%rsp
  803d3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d42:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4c:	00 00 00 
  803d4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d52:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5b:	48 89 c6             	mov    %rax,%rsi
  803d5e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d65:	00 00 00 
  803d68:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d74:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d7b:	00 00 00 
  803d7e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d81:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d84:	bf 05 00 00 00       	mov    $0x5,%edi
  803d89:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803d90:	00 00 00 
  803d93:	ff d0                	callq  *%rax
}
  803d95:	c9                   	leaveq 
  803d96:	c3                   	retq   

0000000000803d97 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d97:	55                   	push   %rbp
  803d98:	48 89 e5             	mov    %rsp,%rbp
  803d9b:	48 83 ec 10          	sub    $0x10,%rsp
  803d9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803da2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803da5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dac:	00 00 00 
  803daf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803db2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803db4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dbb:	00 00 00 
  803dbe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dc1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803dc4:	bf 06 00 00 00       	mov    $0x6,%edi
  803dc9:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
}
  803dd5:	c9                   	leaveq 
  803dd6:	c3                   	retq   

0000000000803dd7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803dd7:	55                   	push   %rbp
  803dd8:	48 89 e5             	mov    %rsp,%rbp
  803ddb:	48 83 ec 30          	sub    $0x30,%rsp
  803ddf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803de2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803de6:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803de9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803dec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df3:	00 00 00 
  803df6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803df9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803dfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e02:	00 00 00 
  803e05:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e08:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e0b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e12:	00 00 00 
  803e15:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e18:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e1b:	bf 07 00 00 00       	mov    $0x7,%edi
  803e20:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803e27:	00 00 00 
  803e2a:	ff d0                	callq  *%rax
  803e2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e33:	78 69                	js     803e9e <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e35:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e3c:	7f 08                	jg     803e46 <nsipc_recv+0x6f>
  803e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e41:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e44:	7e 35                	jle    803e7b <nsipc_recv+0xa4>
  803e46:	48 b9 bf 51 80 00 00 	movabs $0x8051bf,%rcx
  803e4d:	00 00 00 
  803e50:	48 ba d4 51 80 00 00 	movabs $0x8051d4,%rdx
  803e57:	00 00 00 
  803e5a:	be 61 00 00 00       	mov    $0x61,%esi
  803e5f:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  803e66:	00 00 00 
  803e69:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6e:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  803e75:	00 00 00 
  803e78:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7e:	48 63 d0             	movslq %eax,%rdx
  803e81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e85:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e8c:	00 00 00 
  803e8f:	48 89 c7             	mov    %rax,%rdi
  803e92:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803e99:	00 00 00 
  803e9c:	ff d0                	callq  *%rax
	}

	return r;
  803e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ea1:	c9                   	leaveq 
  803ea2:	c3                   	retq   

0000000000803ea3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ea3:	55                   	push   %rbp
  803ea4:	48 89 e5             	mov    %rsp,%rbp
  803ea7:	48 83 ec 20          	sub    $0x20,%rsp
  803eab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eb2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803eb5:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803eb8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ebf:	00 00 00 
  803ec2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ec5:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803ec7:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ece:	7e 35                	jle    803f05 <nsipc_send+0x62>
  803ed0:	48 b9 f5 51 80 00 00 	movabs $0x8051f5,%rcx
  803ed7:	00 00 00 
  803eda:	48 ba d4 51 80 00 00 	movabs $0x8051d4,%rdx
  803ee1:	00 00 00 
  803ee4:	be 6c 00 00 00       	mov    $0x6c,%esi
  803ee9:	48 bf e9 51 80 00 00 	movabs $0x8051e9,%rdi
  803ef0:	00 00 00 
  803ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef8:	49 b8 3b 04 80 00 00 	movabs $0x80043b,%r8
  803eff:	00 00 00 
  803f02:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f08:	48 63 d0             	movslq %eax,%rdx
  803f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0f:	48 89 c6             	mov    %rax,%rsi
  803f12:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803f19:	00 00 00 
  803f1c:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803f28:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f2f:	00 00 00 
  803f32:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f35:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f38:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f3f:	00 00 00 
  803f42:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f45:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f48:	bf 08 00 00 00       	mov    $0x8,%edi
  803f4d:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
}
  803f59:	c9                   	leaveq 
  803f5a:	c3                   	retq   

0000000000803f5b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f5b:	55                   	push   %rbp
  803f5c:	48 89 e5             	mov    %rsp,%rbp
  803f5f:	48 83 ec 10          	sub    $0x10,%rsp
  803f63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f66:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f69:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f6c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f73:	00 00 00 
  803f76:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f79:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f7b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f82:	00 00 00 
  803f85:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f88:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f92:	00 00 00 
  803f95:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f98:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f9b:	bf 09 00 00 00       	mov    $0x9,%edi
  803fa0:	48 b8 62 3b 80 00 00 	movabs $0x803b62,%rax
  803fa7:	00 00 00 
  803faa:	ff d0                	callq  *%rax
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   

0000000000803fae <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803fae:	55                   	push   %rbp
  803faf:	48 89 e5             	mov    %rsp,%rbp
  803fb2:	53                   	push   %rbx
  803fb3:	48 83 ec 38          	sub    $0x38,%rsp
  803fb7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803fbb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803fbf:	48 89 c7             	mov    %rax,%rdi
  803fc2:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  803fc9:	00 00 00 
  803fcc:	ff d0                	callq  *%rax
  803fce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd5:	0f 88 bf 01 00 00    	js     80419a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fdf:	ba 07 04 00 00       	mov    $0x407,%edx
  803fe4:	48 89 c6             	mov    %rax,%rsi
  803fe7:	bf 00 00 00 00       	mov    $0x0,%edi
  803fec:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  803ff3:	00 00 00 
  803ff6:	ff d0                	callq  *%rax
  803ff8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ffb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fff:	0f 88 95 01 00 00    	js     80419a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804005:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804009:	48 89 c7             	mov    %rax,%rdi
  80400c:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80401b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80401f:	0f 88 5d 01 00 00    	js     804182 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804025:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804029:	ba 07 04 00 00       	mov    $0x407,%edx
  80402e:	48 89 c6             	mov    %rax,%rsi
  804031:	bf 00 00 00 00       	mov    $0x0,%edi
  804036:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80403d:	00 00 00 
  804040:	ff d0                	callq  *%rax
  804042:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804045:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804049:	0f 88 33 01 00 00    	js     804182 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80404f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804053:	48 89 c7             	mov    %rax,%rdi
  804056:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  80405d:	00 00 00 
  804060:	ff d0                	callq  *%rax
  804062:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804066:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80406a:	ba 07 04 00 00       	mov    $0x407,%edx
  80406f:	48 89 c6             	mov    %rax,%rsi
  804072:	bf 00 00 00 00       	mov    $0x0,%edi
  804077:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  80407e:	00 00 00 
  804081:	ff d0                	callq  *%rax
  804083:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804086:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80408a:	79 05                	jns    804091 <pipe+0xe3>
		goto err2;
  80408c:	e9 d9 00 00 00       	jmpq   80416a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804091:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804095:	48 89 c7             	mov    %rax,%rdi
  804098:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  80409f:	00 00 00 
  8040a2:	ff d0                	callq  *%rax
  8040a4:	48 89 c2             	mov    %rax,%rdx
  8040a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ab:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040b1:	48 89 d1             	mov    %rdx,%rcx
  8040b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8040b9:	48 89 c6             	mov    %rax,%rsi
  8040bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c1:	48 b8 a8 1b 80 00 00 	movabs $0x801ba8,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d4:	79 1b                	jns    8040f1 <pipe+0x143>
		goto err3;
  8040d6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040db:	48 89 c6             	mov    %rax,%rsi
  8040de:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e3:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  8040ea:	00 00 00 
  8040ed:	ff d0                	callq  *%rax
  8040ef:	eb 79                	jmp    80416a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8040f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f5:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040fc:	00 00 00 
  8040ff:	8b 12                	mov    (%rdx),%edx
  804101:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80410e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804112:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804119:	00 00 00 
  80411c:	8b 12                	mov    (%rdx),%edx
  80411e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804120:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804124:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80412b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412f:	48 89 c7             	mov    %rax,%rdi
  804132:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  804139:	00 00 00 
  80413c:	ff d0                	callq  *%rax
  80413e:	89 c2                	mov    %eax,%edx
  804140:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804144:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804146:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80414a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80414e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804152:	48 89 c7             	mov    %rax,%rdi
  804155:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  80415c:	00 00 00 
  80415f:	ff d0                	callq  *%rax
  804161:	89 03                	mov    %eax,(%rbx)
	return 0;
  804163:	b8 00 00 00 00       	mov    $0x0,%eax
  804168:	eb 33                	jmp    80419d <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80416a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416e:	48 89 c6             	mov    %rax,%rsi
  804171:	bf 00 00 00 00       	mov    $0x0,%edi
  804176:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  80417d:	00 00 00 
  804180:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804186:	48 89 c6             	mov    %rax,%rsi
  804189:	bf 00 00 00 00       	mov    $0x0,%edi
  80418e:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
err:
	return r;
  80419a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80419d:	48 83 c4 38          	add    $0x38,%rsp
  8041a1:	5b                   	pop    %rbx
  8041a2:	5d                   	pop    %rbp
  8041a3:	c3                   	retq   

00000000008041a4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041a4:	55                   	push   %rbp
  8041a5:	48 89 e5             	mov    %rsp,%rbp
  8041a8:	53                   	push   %rbx
  8041a9:	48 83 ec 28          	sub    $0x28,%rsp
  8041ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8041b5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041bc:	00 00 00 
  8041bf:	48 8b 00             	mov    (%rax),%rax
  8041c2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8041cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cf:	48 89 c7             	mov    %rax,%rdi
  8041d2:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
  8041de:	89 c3                	mov    %eax,%ebx
  8041e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e4:	48 89 c7             	mov    %rax,%rdi
  8041e7:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  8041ee:	00 00 00 
  8041f1:	ff d0                	callq  *%rax
  8041f3:	39 c3                	cmp    %eax,%ebx
  8041f5:	0f 94 c0             	sete   %al
  8041f8:	0f b6 c0             	movzbl %al,%eax
  8041fb:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8041fe:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804205:	00 00 00 
  804208:	48 8b 00             	mov    (%rax),%rax
  80420b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804211:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804214:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804217:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80421a:	75 05                	jne    804221 <_pipeisclosed+0x7d>
			return ret;
  80421c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80421f:	eb 4f                	jmp    804270 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804221:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804224:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804227:	74 42                	je     80426b <_pipeisclosed+0xc7>
  804229:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80422d:	75 3c                	jne    80426b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80422f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804236:	00 00 00 
  804239:	48 8b 00             	mov    (%rax),%rax
  80423c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804242:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804245:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804248:	89 c6                	mov    %eax,%esi
  80424a:	48 bf 06 52 80 00 00 	movabs $0x805206,%rdi
  804251:	00 00 00 
  804254:	b8 00 00 00 00       	mov    $0x0,%eax
  804259:	49 b8 74 06 80 00 00 	movabs $0x800674,%r8
  804260:	00 00 00 
  804263:	41 ff d0             	callq  *%r8
	}
  804266:	e9 4a ff ff ff       	jmpq   8041b5 <_pipeisclosed+0x11>
  80426b:	e9 45 ff ff ff       	jmpq   8041b5 <_pipeisclosed+0x11>
}
  804270:	48 83 c4 28          	add    $0x28,%rsp
  804274:	5b                   	pop    %rbx
  804275:	5d                   	pop    %rbp
  804276:	c3                   	retq   

0000000000804277 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804277:	55                   	push   %rbp
  804278:	48 89 e5             	mov    %rsp,%rbp
  80427b:	48 83 ec 30          	sub    $0x30,%rsp
  80427f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804282:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804286:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804289:	48 89 d6             	mov    %rdx,%rsi
  80428c:	89 c7                	mov    %eax,%edi
  80428e:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  804295:	00 00 00 
  804298:	ff d0                	callq  *%rax
  80429a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80429d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a1:	79 05                	jns    8042a8 <pipeisclosed+0x31>
		return r;
  8042a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a6:	eb 31                	jmp    8042d9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ac:	48 89 c7             	mov    %rax,%rdi
  8042af:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  8042b6:	00 00 00 
  8042b9:	ff d0                	callq  *%rax
  8042bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8042bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042c7:	48 89 d6             	mov    %rdx,%rsi
  8042ca:	48 89 c7             	mov    %rax,%rdi
  8042cd:	48 b8 a4 41 80 00 00 	movabs $0x8041a4,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
}
  8042d9:	c9                   	leaveq 
  8042da:	c3                   	retq   

00000000008042db <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042db:	55                   	push   %rbp
  8042dc:	48 89 e5             	mov    %rsp,%rbp
  8042df:	48 83 ec 40          	sub    $0x40,%rsp
  8042e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8042ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f3:	48 89 c7             	mov    %rax,%rdi
  8042f6:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  8042fd:	00 00 00 
  804300:	ff d0                	callq  *%rax
  804302:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804306:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80430a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80430e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804315:	00 
  804316:	e9 92 00 00 00       	jmpq   8043ad <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80431b:	eb 41                	jmp    80435e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80431d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804322:	74 09                	je     80432d <devpipe_read+0x52>
				return i;
  804324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804328:	e9 92 00 00 00       	jmpq   8043bf <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80432d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804335:	48 89 d6             	mov    %rdx,%rsi
  804338:	48 89 c7             	mov    %rax,%rdi
  80433b:	48 b8 a4 41 80 00 00 	movabs $0x8041a4,%rax
  804342:	00 00 00 
  804345:	ff d0                	callq  *%rax
  804347:	85 c0                	test   %eax,%eax
  804349:	74 07                	je     804352 <devpipe_read+0x77>
				return 0;
  80434b:	b8 00 00 00 00       	mov    $0x0,%eax
  804350:	eb 6d                	jmp    8043bf <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804352:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  804359:	00 00 00 
  80435c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80435e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804362:	8b 10                	mov    (%rax),%edx
  804364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804368:	8b 40 04             	mov    0x4(%rax),%eax
  80436b:	39 c2                	cmp    %eax,%edx
  80436d:	74 ae                	je     80431d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80436f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804373:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804377:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80437b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437f:	8b 00                	mov    (%rax),%eax
  804381:	99                   	cltd   
  804382:	c1 ea 1b             	shr    $0x1b,%edx
  804385:	01 d0                	add    %edx,%eax
  804387:	83 e0 1f             	and    $0x1f,%eax
  80438a:	29 d0                	sub    %edx,%eax
  80438c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804390:	48 98                	cltq   
  804392:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804397:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439d:	8b 00                	mov    (%rax),%eax
  80439f:	8d 50 01             	lea    0x1(%rax),%edx
  8043a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043b5:	0f 82 60 ff ff ff    	jb     80431b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8043bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043bf:	c9                   	leaveq 
  8043c0:	c3                   	retq   

00000000008043c1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043c1:	55                   	push   %rbp
  8043c2:	48 89 e5             	mov    %rsp,%rbp
  8043c5:	48 83 ec 40          	sub    $0x40,%rsp
  8043c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043d1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d9:	48 89 c7             	mov    %rax,%rdi
  8043dc:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  8043e3:	00 00 00 
  8043e6:	ff d0                	callq  *%rax
  8043e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8043ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8043f4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043fb:	00 
  8043fc:	e9 8e 00 00 00       	jmpq   80448f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804401:	eb 31                	jmp    804434 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804403:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440b:	48 89 d6             	mov    %rdx,%rsi
  80440e:	48 89 c7             	mov    %rax,%rdi
  804411:	48 b8 a4 41 80 00 00 	movabs $0x8041a4,%rax
  804418:	00 00 00 
  80441b:	ff d0                	callq  *%rax
  80441d:	85 c0                	test   %eax,%eax
  80441f:	74 07                	je     804428 <devpipe_write+0x67>
				return 0;
  804421:	b8 00 00 00 00       	mov    $0x0,%eax
  804426:	eb 79                	jmp    8044a1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804428:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  80442f:	00 00 00 
  804432:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804438:	8b 40 04             	mov    0x4(%rax),%eax
  80443b:	48 63 d0             	movslq %eax,%rdx
  80443e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804442:	8b 00                	mov    (%rax),%eax
  804444:	48 98                	cltq   
  804446:	48 83 c0 20          	add    $0x20,%rax
  80444a:	48 39 c2             	cmp    %rax,%rdx
  80444d:	73 b4                	jae    804403 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80444f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804453:	8b 40 04             	mov    0x4(%rax),%eax
  804456:	99                   	cltd   
  804457:	c1 ea 1b             	shr    $0x1b,%edx
  80445a:	01 d0                	add    %edx,%eax
  80445c:	83 e0 1f             	and    $0x1f,%eax
  80445f:	29 d0                	sub    %edx,%eax
  804461:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804465:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804469:	48 01 ca             	add    %rcx,%rdx
  80446c:	0f b6 0a             	movzbl (%rdx),%ecx
  80446f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804473:	48 98                	cltq   
  804475:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447d:	8b 40 04             	mov    0x4(%rax),%eax
  804480:	8d 50 01             	lea    0x1(%rax),%edx
  804483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804487:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80448a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80448f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804493:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804497:	0f 82 64 ff ff ff    	jb     804401 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80449d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8044a1:	c9                   	leaveq 
  8044a2:	c3                   	retq   

00000000008044a3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044a3:	55                   	push   %rbp
  8044a4:	48 89 e5             	mov    %rsp,%rbp
  8044a7:	48 83 ec 20          	sub    $0x20,%rsp
  8044ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b7:	48 89 c7             	mov    %rax,%rdi
  8044ba:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  8044c1:	00 00 00 
  8044c4:	ff d0                	callq  *%rax
  8044c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8044ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044ce:	48 be 19 52 80 00 00 	movabs $0x805219,%rsi
  8044d5:	00 00 00 
  8044d8:	48 89 c7             	mov    %rax,%rdi
  8044db:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8044e2:	00 00 00 
  8044e5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8044e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044eb:	8b 50 04             	mov    0x4(%rax),%edx
  8044ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f2:	8b 00                	mov    (%rax),%eax
  8044f4:	29 c2                	sub    %eax,%edx
  8044f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044fa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804500:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804504:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80450b:	00 00 00 
	stat->st_dev = &devpipe;
  80450e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804512:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804519:	00 00 00 
  80451c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804528:	c9                   	leaveq 
  804529:	c3                   	retq   

000000000080452a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80452a:	55                   	push   %rbp
  80452b:	48 89 e5             	mov    %rsp,%rbp
  80452e:	48 83 ec 10          	sub    $0x10,%rsp
  804532:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80453a:	48 89 c6             	mov    %rax,%rsi
  80453d:	bf 00 00 00 00       	mov    $0x0,%edi
  804542:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804549:	00 00 00 
  80454c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80454e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804552:	48 89 c7             	mov    %rax,%rdi
  804555:	48 b8 38 27 80 00 00 	movabs $0x802738,%rax
  80455c:	00 00 00 
  80455f:	ff d0                	callq  *%rax
  804561:	48 89 c6             	mov    %rax,%rsi
  804564:	bf 00 00 00 00       	mov    $0x0,%edi
  804569:	48 b8 03 1c 80 00 00 	movabs $0x801c03,%rax
  804570:	00 00 00 
  804573:	ff d0                	callq  *%rax
}
  804575:	c9                   	leaveq 
  804576:	c3                   	retq   

0000000000804577 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804577:	55                   	push   %rbp
  804578:	48 89 e5             	mov    %rsp,%rbp
  80457b:	48 83 ec 20          	sub    $0x20,%rsp
  80457f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804582:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804585:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804588:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80458c:	be 01 00 00 00       	mov    $0x1,%esi
  804591:	48 89 c7             	mov    %rax,%rdi
  804594:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  80459b:	00 00 00 
  80459e:	ff d0                	callq  *%rax
}
  8045a0:	c9                   	leaveq 
  8045a1:	c3                   	retq   

00000000008045a2 <getchar>:

int
getchar(void)
{
  8045a2:	55                   	push   %rbp
  8045a3:	48 89 e5             	mov    %rsp,%rbp
  8045a6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045aa:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045ae:	ba 01 00 00 00       	mov    $0x1,%edx
  8045b3:	48 89 c6             	mov    %rax,%rsi
  8045b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8045bb:	48 b8 2d 2c 80 00 00 	movabs $0x802c2d,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ce:	79 05                	jns    8045d5 <getchar+0x33>
		return r;
  8045d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d3:	eb 14                	jmp    8045e9 <getchar+0x47>
	if (r < 1)
  8045d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045d9:	7f 07                	jg     8045e2 <getchar+0x40>
		return -E_EOF;
  8045db:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045e0:	eb 07                	jmp    8045e9 <getchar+0x47>
	return c;
  8045e2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045e6:	0f b6 c0             	movzbl %al,%eax
}
  8045e9:	c9                   	leaveq 
  8045ea:	c3                   	retq   

00000000008045eb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045eb:	55                   	push   %rbp
  8045ec:	48 89 e5             	mov    %rsp,%rbp
  8045ef:	48 83 ec 20          	sub    $0x20,%rsp
  8045f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045fd:	48 89 d6             	mov    %rdx,%rsi
  804600:	89 c7                	mov    %eax,%edi
  804602:	48 b8 fb 27 80 00 00 	movabs $0x8027fb,%rax
  804609:	00 00 00 
  80460c:	ff d0                	callq  *%rax
  80460e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804611:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804615:	79 05                	jns    80461c <iscons+0x31>
		return r;
  804617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80461a:	eb 1a                	jmp    804636 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80461c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804620:	8b 10                	mov    (%rax),%edx
  804622:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804629:	00 00 00 
  80462c:	8b 00                	mov    (%rax),%eax
  80462e:	39 c2                	cmp    %eax,%edx
  804630:	0f 94 c0             	sete   %al
  804633:	0f b6 c0             	movzbl %al,%eax
}
  804636:	c9                   	leaveq 
  804637:	c3                   	retq   

0000000000804638 <opencons>:

int
opencons(void)
{
  804638:	55                   	push   %rbp
  804639:	48 89 e5             	mov    %rsp,%rbp
  80463c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804640:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804644:	48 89 c7             	mov    %rax,%rdi
  804647:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  80464e:	00 00 00 
  804651:	ff d0                	callq  *%rax
  804653:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804656:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80465a:	79 05                	jns    804661 <opencons+0x29>
		return r;
  80465c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465f:	eb 5b                	jmp    8046bc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804665:	ba 07 04 00 00       	mov    $0x407,%edx
  80466a:	48 89 c6             	mov    %rax,%rsi
  80466d:	bf 00 00 00 00       	mov    $0x0,%edi
  804672:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  804679:	00 00 00 
  80467c:	ff d0                	callq  *%rax
  80467e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804681:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804685:	79 05                	jns    80468c <opencons+0x54>
		return r;
  804687:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468a:	eb 30                	jmp    8046bc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80468c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804690:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804697:	00 00 00 
  80469a:	8b 12                	mov    (%rdx),%edx
  80469c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80469e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ad:	48 89 c7             	mov    %rax,%rdi
  8046b0:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  8046b7:	00 00 00 
  8046ba:	ff d0                	callq  *%rax
}
  8046bc:	c9                   	leaveq 
  8046bd:	c3                   	retq   

00000000008046be <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046be:	55                   	push   %rbp
  8046bf:	48 89 e5             	mov    %rsp,%rbp
  8046c2:	48 83 ec 30          	sub    $0x30,%rsp
  8046c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046d7:	75 07                	jne    8046e0 <devcons_read+0x22>
		return 0;
  8046d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046de:	eb 4b                	jmp    80472b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046e0:	eb 0c                	jmp    8046ee <devcons_read+0x30>
		sys_yield();
  8046e2:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  8046e9:	00 00 00 
  8046ec:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8046ee:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8046f5:	00 00 00 
  8046f8:	ff d0                	callq  *%rax
  8046fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804701:	74 df                	je     8046e2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804707:	79 05                	jns    80470e <devcons_read+0x50>
		return c;
  804709:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80470c:	eb 1d                	jmp    80472b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80470e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804712:	75 07                	jne    80471b <devcons_read+0x5d>
		return 0;
  804714:	b8 00 00 00 00       	mov    $0x0,%eax
  804719:	eb 10                	jmp    80472b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80471b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80471e:	89 c2                	mov    %eax,%edx
  804720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804724:	88 10                	mov    %dl,(%rax)
	return 1;
  804726:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80472b:	c9                   	leaveq 
  80472c:	c3                   	retq   

000000000080472d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80472d:	55                   	push   %rbp
  80472e:	48 89 e5             	mov    %rsp,%rbp
  804731:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804738:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80473f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804746:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80474d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804754:	eb 76                	jmp    8047cc <devcons_write+0x9f>
		m = n - tot;
  804756:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80475d:	89 c2                	mov    %eax,%edx
  80475f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804762:	29 c2                	sub    %eax,%edx
  804764:	89 d0                	mov    %edx,%eax
  804766:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804769:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80476c:	83 f8 7f             	cmp    $0x7f,%eax
  80476f:	76 07                	jbe    804778 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804771:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804778:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80477b:	48 63 d0             	movslq %eax,%rdx
  80477e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804781:	48 63 c8             	movslq %eax,%rcx
  804784:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80478b:	48 01 c1             	add    %rax,%rcx
  80478e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804795:	48 89 ce             	mov    %rcx,%rsi
  804798:	48 89 c7             	mov    %rax,%rdi
  80479b:	48 b8 4d 15 80 00 00 	movabs $0x80154d,%rax
  8047a2:	00 00 00 
  8047a5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047aa:	48 63 d0             	movslq %eax,%rdx
  8047ad:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047b4:	48 89 d6             	mov    %rdx,%rsi
  8047b7:	48 89 c7             	mov    %rax,%rdi
  8047ba:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8047c1:	00 00 00 
  8047c4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047c9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047cf:	48 98                	cltq   
  8047d1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047d8:	0f 82 78 ff ff ff    	jb     804756 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8047de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047e1:	c9                   	leaveq 
  8047e2:	c3                   	retq   

00000000008047e3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047e3:	55                   	push   %rbp
  8047e4:	48 89 e5             	mov    %rsp,%rbp
  8047e7:	48 83 ec 08          	sub    $0x8,%rsp
  8047eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047f4:	c9                   	leaveq 
  8047f5:	c3                   	retq   

00000000008047f6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047f6:	55                   	push   %rbp
  8047f7:	48 89 e5             	mov    %rsp,%rbp
  8047fa:	48 83 ec 10          	sub    $0x10,%rsp
  8047fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804802:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80480a:	48 be 25 52 80 00 00 	movabs $0x805225,%rsi
  804811:	00 00 00 
  804814:	48 89 c7             	mov    %rax,%rdi
  804817:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80481e:	00 00 00 
  804821:	ff d0                	callq  *%rax
	return 0;
  804823:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804828:	c9                   	leaveq 
  804829:	c3                   	retq   

000000000080482a <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80482a:	55                   	push   %rbp
  80482b:	48 89 e5             	mov    %rsp,%rbp
  80482e:	48 83 ec 10          	sub    $0x10,%rsp
  804832:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804836:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80483d:	00 00 00 
  804840:	48 8b 00             	mov    (%rax),%rax
  804843:	48 85 c0             	test   %rax,%rax
  804846:	0f 85 84 00 00 00    	jne    8048d0 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80484c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804853:	00 00 00 
  804856:	48 8b 00             	mov    (%rax),%rax
  804859:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80485f:	ba 07 00 00 00       	mov    $0x7,%edx
  804864:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804869:	89 c7                	mov    %eax,%edi
  80486b:	48 b8 58 1b 80 00 00 	movabs $0x801b58,%rax
  804872:	00 00 00 
  804875:	ff d0                	callq  *%rax
  804877:	85 c0                	test   %eax,%eax
  804879:	79 2a                	jns    8048a5 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80487b:	48 ba 30 52 80 00 00 	movabs $0x805230,%rdx
  804882:	00 00 00 
  804885:	be 23 00 00 00       	mov    $0x23,%esi
  80488a:	48 bf 57 52 80 00 00 	movabs $0x805257,%rdi
  804891:	00 00 00 
  804894:	b8 00 00 00 00       	mov    $0x0,%eax
  804899:	48 b9 3b 04 80 00 00 	movabs $0x80043b,%rcx
  8048a0:	00 00 00 
  8048a3:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8048a5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048ac:	00 00 00 
  8048af:	48 8b 00             	mov    (%rax),%rax
  8048b2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8048b8:	48 be e3 48 80 00 00 	movabs $0x8048e3,%rsi
  8048bf:	00 00 00 
  8048c2:	89 c7                	mov    %eax,%edi
  8048c4:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8048cb:	00 00 00 
  8048ce:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8048d0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048d7:	00 00 00 
  8048da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048de:	48 89 10             	mov    %rdx,(%rax)
}
  8048e1:	c9                   	leaveq 
  8048e2:	c3                   	retq   

00000000008048e3 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8048e3:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8048e6:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8048ed:	00 00 00 
call *%rax
  8048f0:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8048f2:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8048f9:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8048fa:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804901:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804902:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804906:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804909:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804910:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804911:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804915:	4c 8b 3c 24          	mov    (%rsp),%r15
  804919:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80491e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804923:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804928:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80492d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804932:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804937:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80493c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804941:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804946:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80494b:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804950:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804955:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80495a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80495f:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804963:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804967:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804968:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804969:	c3                   	retq   
