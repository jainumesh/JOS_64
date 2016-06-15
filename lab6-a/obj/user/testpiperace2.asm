
obj/user/testpiperace2.debug:     file format elf64-x86-64


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
  80003c:	e8 ea 02 00 00       	callq  80032b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf 20 49 80 00 00 	movabs $0x804920,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 d9 3c 80 00 00 	movabs $0x803cd9,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 42 49 80 00 00 	movabs $0x804942,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 69 49 80 00 00 	movabs $0x804969,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 38 28 80 00 00 	movabs $0x802838,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 63 d0             	movslq %eax,%rdx
  8001d3:	48 89 d0             	mov    %rdx,%rax
  8001d6:	48 c1 e0 03          	shl    $0x3,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c1 e0 05          	shl    $0x5,%rax
  8001e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e8:	00 00 00 
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f2:	eb 4d                	jmp    800241 <umain+0x1fe>
		if (pipeisclosed(p[0]) != 0) {
  8001f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001f7:	89 c7                	mov    %eax,%edi
  8001f9:	48 b8 a2 3f 80 00 00 	movabs $0x803fa2,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf 6d 49 80 00 00 	movabs $0x80496d,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  80021f:	00 00 00 
  800222:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800224:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800227:	89 c7                	mov    %eax,%edi
  800229:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
			exit();
  800235:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80024b:	83 f8 02             	cmp    $0x2,%eax
  80024e:	74 a4                	je     8001f4 <umain+0x1b1>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800250:	48 bf 89 49 80 00 00 	movabs $0x804989,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 a2 3f 80 00 00 	movabs $0x803fa2,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba a0 49 80 00 00 	movabs $0x8049a0,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  800296:	00 00 00 
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8002a5:	00 00 00 
  8002a8:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b1:	48 89 d6             	mov    %rdx,%rsi
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba ca 49 80 00 00 	movabs $0x8049ca,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf 4b 49 80 00 00 	movabs $0x80494b,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf e2 49 80 00 00 	movabs $0x8049e2,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  800324:	00 00 00 
  800327:	ff d2                	callq  *%rdx
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 83 ec 10          	sub    $0x10,%rsp
  800333:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800336:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80033a:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034b:	48 63 d0             	movslq %eax,%rdx
  80034e:	48 89 d0             	mov    %rdx,%rax
  800351:	48 c1 e0 03          	shl    $0x3,%rax
  800355:	48 01 d0             	add    %rdx,%rax
  800358:	48 c1 e0 05          	shl    $0x5,%rax
  80035c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800363:	00 00 00 
  800366:	48 01 c2             	add    %rax,%rdx
  800369:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800370:	00 00 00 
  800373:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037a:	7e 14                	jle    800390 <libmain+0x65>
		binaryname = argv[0];
  80037c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800380:	48 8b 10             	mov    (%rax),%rdx
  800383:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80038a:	00 00 00 
  80038d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800390:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800397:	48 89 d6             	mov    %rdx,%rsi
  80039a:	89 c7                	mov    %eax,%edi
  80039c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003a8:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
}
  8003b4:	c9                   	leaveq 
  8003b5:	c3                   	retq   

00000000008003b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003b6:	55                   	push   %rbp
  8003b7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ba:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003cb:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	callq  *%rax

}
  8003d7:	5d                   	pop    %rbp
  8003d8:	c3                   	retq   

00000000008003d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
  8003dd:	53                   	push   %rbx
  8003de:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003e5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003ec:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003f2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003f9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800400:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800407:	84 c0                	test   %al,%al
  800409:	74 23                	je     80042e <_panic+0x55>
  80040b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800412:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800416:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80041a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80041e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800422:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800426:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80042a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80042e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800435:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80043c:	00 00 00 
  80043f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800446:	00 00 00 
  800449:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80044d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800454:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80045b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800462:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800469:	00 00 00 
  80046c:	48 8b 18             	mov    (%rax),%rbx
  80046f:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
  80047b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800481:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800488:	41 89 c8             	mov    %ecx,%r8d
  80048b:	48 89 d1             	mov    %rdx,%rcx
  80048e:	48 89 da             	mov    %rbx,%rdx
  800491:	89 c6                	mov    %eax,%esi
  800493:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  80049a:	00 00 00 
  80049d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a2:	49 b9 12 06 80 00 00 	movabs $0x800612,%r9
  8004a9:	00 00 00 
  8004ac:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004af:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004b6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004bd:	48 89 d6             	mov    %rdx,%rsi
  8004c0:	48 89 c7             	mov    %rax,%rdi
  8004c3:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004cf:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
  8004d6:	00 00 00 
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  8004e5:	00 00 00 
  8004e8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ea:	cc                   	int3   
  8004eb:	eb fd                	jmp    8004ea <_panic+0x111>

00000000008004ed <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 10          	sub    $0x10,%rsp
  8004f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800500:	8b 00                	mov    (%rax),%eax
  800502:	8d 48 01             	lea    0x1(%rax),%ecx
  800505:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800509:	89 0a                	mov    %ecx,(%rdx)
  80050b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80050e:	89 d1                	mov    %edx,%ecx
  800510:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800514:	48 98                	cltq   
  800516:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80051a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	3d ff 00 00 00       	cmp    $0xff,%eax
  800525:	75 2c                	jne    800553 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052b:	8b 00                	mov    (%rax),%eax
  80052d:	48 98                	cltq   
  80052f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800533:	48 83 c2 08          	add    $0x8,%rdx
  800537:	48 89 c6             	mov    %rax,%rsi
  80053a:	48 89 d7             	mov    %rdx,%rdi
  80053d:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  800544:	00 00 00 
  800547:	ff d0                	callq  *%rax
        b->idx = 0;
  800549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800557:	8b 40 04             	mov    0x4(%rax),%eax
  80055a:	8d 50 01             	lea    0x1(%rax),%edx
  80055d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800561:	89 50 04             	mov    %edx,0x4(%rax)
}
  800564:	c9                   	leaveq 
  800565:	c3                   	retq   

0000000000800566 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800566:	55                   	push   %rbp
  800567:	48 89 e5             	mov    %rsp,%rbp
  80056a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800571:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800578:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80057f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800586:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80058d:	48 8b 0a             	mov    (%rdx),%rcx
  800590:	48 89 08             	mov    %rcx,(%rax)
  800593:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800597:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80059b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80059f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005aa:	00 00 00 
    b.cnt = 0;
  8005ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005b4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005b7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005be:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005c5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005cc:	48 89 c6             	mov    %rax,%rsi
  8005cf:	48 bf ed 04 80 00 00 	movabs $0x8004ed,%rdi
  8005d6:	00 00 00 
  8005d9:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  8005e0:	00 00 00 
  8005e3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005e5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005eb:	48 98                	cltq   
  8005ed:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005f4:	48 83 c2 08          	add    $0x8,%rdx
  8005f8:	48 89 c6             	mov    %rax,%rsi
  8005fb:	48 89 d7             	mov    %rdx,%rdi
  8005fe:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  800605:	00 00 00 
  800608:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80060a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800610:	c9                   	leaveq 
  800611:	c3                   	retq   

0000000000800612 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800612:	55                   	push   %rbp
  800613:	48 89 e5             	mov    %rsp,%rbp
  800616:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80061d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800624:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80062b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800632:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800639:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800640:	84 c0                	test   %al,%al
  800642:	74 20                	je     800664 <cprintf+0x52>
  800644:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800648:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80064c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800650:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800654:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800658:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80065c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800660:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800664:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80066b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800672:	00 00 00 
  800675:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80067c:	00 00 00 
  80067f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800683:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80068a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800691:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800698:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80069f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006a6:	48 8b 0a             	mov    (%rdx),%rcx
  8006a9:	48 89 08             	mov    %rcx,(%rax)
  8006ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006bc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ca:	48 89 d6             	mov    %rdx,%rsi
  8006cd:	48 89 c7             	mov    %rax,%rdi
  8006d0:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8006d7:	00 00 00 
  8006da:	ff d0                	callq  *%rax
  8006dc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006e2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006e8:	c9                   	leaveq 
  8006e9:	c3                   	retq   

00000000008006ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ea:	55                   	push   %rbp
  8006eb:	48 89 e5             	mov    %rsp,%rbp
  8006ee:	53                   	push   %rbx
  8006ef:	48 83 ec 38          	sub    $0x38,%rsp
  8006f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ff:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800702:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800706:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80070d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800711:	77 3b                	ja     80074e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800713:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800716:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80071a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80071d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	48 f7 f3             	div    %rbx
  800729:	48 89 c2             	mov    %rax,%rdx
  80072c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80072f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800732:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	41 89 f9             	mov    %edi,%r9d
  80073d:	48 89 c7             	mov    %rax,%rdi
  800740:	48 b8 ea 06 80 00 00 	movabs $0x8006ea,%rax
  800747:	00 00 00 
  80074a:	ff d0                	callq  *%rax
  80074c:	eb 1e                	jmp    80076c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80074e:	eb 12                	jmp    800762 <printnum+0x78>
			putch(padc, putdat);
  800750:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800754:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 89 ce             	mov    %rcx,%rsi
  80075e:	89 d7                	mov    %edx,%edi
  800760:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800762:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800766:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80076a:	7f e4                	jg     800750 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f1             	div    %rcx
  80077b:	48 89 d0             	mov    %rdx,%rax
  80077e:	48 ba 30 4c 80 00 00 	movabs $0x804c30,%rdx
  800785:	00 00 00 
  800788:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80078c:	0f be d0             	movsbl %al,%edx
  80078f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800797:	48 89 ce             	mov    %rcx,%rsi
  80079a:	89 d7                	mov    %edx,%edi
  80079c:	ff d0                	callq  *%rax
}
  80079e:	48 83 c4 38          	add    $0x38,%rsp
  8007a2:	5b                   	pop    %rbx
  8007a3:	5d                   	pop    %rbp
  8007a4:	c3                   	retq   

00000000008007a5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007a5:	55                   	push   %rbp
  8007a6:	48 89 e5             	mov    %rsp,%rbp
  8007a9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007b4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007b8:	7e 52                	jle    80080c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007be:	8b 00                	mov    (%rax),%eax
  8007c0:	83 f8 30             	cmp    $0x30,%eax
  8007c3:	73 24                	jae    8007e9 <getuint+0x44>
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	8b 00                	mov    (%rax),%eax
  8007d3:	89 c0                	mov    %eax,%eax
  8007d5:	48 01 d0             	add    %rdx,%rax
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	8b 12                	mov    (%rdx),%edx
  8007de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e5:	89 0a                	mov    %ecx,(%rdx)
  8007e7:	eb 17                	jmp    800800 <getuint+0x5b>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f1:	48 89 d0             	mov    %rdx,%rax
  8007f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800800:	48 8b 00             	mov    (%rax),%rax
  800803:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800807:	e9 a3 00 00 00       	jmpq   8008af <getuint+0x10a>
	else if (lflag)
  80080c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800810:	74 4f                	je     800861 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	8b 00                	mov    (%rax),%eax
  800818:	83 f8 30             	cmp    $0x30,%eax
  80081b:	73 24                	jae    800841 <getuint+0x9c>
  80081d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800821:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	89 c0                	mov    %eax,%eax
  80082d:	48 01 d0             	add    %rdx,%rax
  800830:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800834:	8b 12                	mov    (%rdx),%edx
  800836:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	89 0a                	mov    %ecx,(%rdx)
  80083f:	eb 17                	jmp    800858 <getuint+0xb3>
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800849:	48 89 d0             	mov    %rdx,%rax
  80084c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800850:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800854:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800858:	48 8b 00             	mov    (%rax),%rax
  80085b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80085f:	eb 4e                	jmp    8008af <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800865:	8b 00                	mov    (%rax),%eax
  800867:	83 f8 30             	cmp    $0x30,%eax
  80086a:	73 24                	jae    800890 <getuint+0xeb>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	89 c0                	mov    %eax,%eax
  80087c:	48 01 d0             	add    %rdx,%rax
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	8b 12                	mov    (%rdx),%edx
  800885:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	89 0a                	mov    %ecx,(%rdx)
  80088e:	eb 17                	jmp    8008a7 <getuint+0x102>
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b3:	c9                   	leaveq 
  8008b4:	c3                   	retq   

00000000008008b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b5:	55                   	push   %rbp
  8008b6:	48 89 e5             	mov    %rsp,%rbp
  8008b9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008c4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008c8:	7e 52                	jle    80091c <getint+0x67>
		x=va_arg(*ap, long long);
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	8b 00                	mov    (%rax),%eax
  8008d0:	83 f8 30             	cmp    $0x30,%eax
  8008d3:	73 24                	jae    8008f9 <getint+0x44>
  8008d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	8b 00                	mov    (%rax),%eax
  8008e3:	89 c0                	mov    %eax,%eax
  8008e5:	48 01 d0             	add    %rdx,%rax
  8008e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ec:	8b 12                	mov    (%rdx),%edx
  8008ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	89 0a                	mov    %ecx,(%rdx)
  8008f7:	eb 17                	jmp    800910 <getint+0x5b>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800901:	48 89 d0             	mov    %rdx,%rax
  800904:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800908:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800910:	48 8b 00             	mov    (%rax),%rax
  800913:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800917:	e9 a3 00 00 00       	jmpq   8009bf <getint+0x10a>
	else if (lflag)
  80091c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800920:	74 4f                	je     800971 <getint+0xbc>
		x=va_arg(*ap, long);
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	8b 00                	mov    (%rax),%eax
  800928:	83 f8 30             	cmp    $0x30,%eax
  80092b:	73 24                	jae    800951 <getint+0x9c>
  80092d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800931:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	89 c0                	mov    %eax,%eax
  80093d:	48 01 d0             	add    %rdx,%rax
  800940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800944:	8b 12                	mov    (%rdx),%edx
  800946:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800949:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094d:	89 0a                	mov    %ecx,(%rdx)
  80094f:	eb 17                	jmp    800968 <getint+0xb3>
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800959:	48 89 d0             	mov    %rdx,%rax
  80095c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800968:	48 8b 00             	mov    (%rax),%rax
  80096b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80096f:	eb 4e                	jmp    8009bf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	8b 00                	mov    (%rax),%eax
  800977:	83 f8 30             	cmp    $0x30,%eax
  80097a:	73 24                	jae    8009a0 <getint+0xeb>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 01 d0             	add    %rdx,%rax
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	8b 12                	mov    (%rdx),%edx
  800995:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800998:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099c:	89 0a                	mov    %ecx,(%rdx)
  80099e:	eb 17                	jmp    8009b7 <getint+0x102>
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a8:	48 89 d0             	mov    %rdx,%rax
  8009ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	48 98                	cltq   
  8009bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c3:	c9                   	leaveq 
  8009c4:	c3                   	retq   

00000000008009c5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009c5:	55                   	push   %rbp
  8009c6:	48 89 e5             	mov    %rsp,%rbp
  8009c9:	41 54                	push   %r12
  8009cb:	53                   	push   %rbx
  8009cc:	48 83 ec 60          	sub    $0x60,%rsp
  8009d0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009d4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009dc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009e8:	48 8b 0a             	mov    (%rdx),%rcx
  8009eb:	48 89 08             	mov    %rcx,(%rax)
  8009ee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009f2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009f6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009fa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fe:	eb 17                	jmp    800a17 <vprintfmt+0x52>
			if (ch == '\0')
  800a00:	85 db                	test   %ebx,%ebx
  800a02:	0f 84 cc 04 00 00    	je     800ed4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a10:	48 89 d6             	mov    %rdx,%rsi
  800a13:	89 df                	mov    %ebx,%edi
  800a15:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a23:	0f b6 00             	movzbl (%rax),%eax
  800a26:	0f b6 d8             	movzbl %al,%ebx
  800a29:	83 fb 25             	cmp    $0x25,%ebx
  800a2c:	75 d2                	jne    800a00 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a2e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a32:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a39:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a47:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5a:	0f b6 00             	movzbl (%rax),%eax
  800a5d:	0f b6 d8             	movzbl %al,%ebx
  800a60:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a63:	83 f8 55             	cmp    $0x55,%eax
  800a66:	0f 87 34 04 00 00    	ja     800ea0 <vprintfmt+0x4db>
  800a6c:	89 c0                	mov    %eax,%eax
  800a6e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a75:	00 
  800a76:	48 b8 58 4c 80 00 00 	movabs $0x804c58,%rax
  800a7d:	00 00 00 
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	48 8b 00             	mov    (%rax),%rax
  800a86:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a88:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a8c:	eb c0                	jmp    800a4e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a92:	eb ba                	jmp    800a4e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a94:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a9b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a9e:	89 d0                	mov    %edx,%eax
  800aa0:	c1 e0 02             	shl    $0x2,%eax
  800aa3:	01 d0                	add    %edx,%eax
  800aa5:	01 c0                	add    %eax,%eax
  800aa7:	01 d8                	add    %ebx,%eax
  800aa9:	83 e8 30             	sub    $0x30,%eax
  800aac:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aaf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab3:	0f b6 00             	movzbl (%rax),%eax
  800ab6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ab9:	83 fb 2f             	cmp    $0x2f,%ebx
  800abc:	7e 0c                	jle    800aca <vprintfmt+0x105>
  800abe:	83 fb 39             	cmp    $0x39,%ebx
  800ac1:	7f 07                	jg     800aca <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ac8:	eb d1                	jmp    800a9b <vprintfmt+0xd6>
			goto process_precision;
  800aca:	eb 58                	jmp    800b24 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 17                	jae    800aeb <vprintfmt+0x126>
  800ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adb:	89 c0                	mov    %eax,%eax
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae3:	83 c2 08             	add    $0x8,%edx
  800ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae9:	eb 0f                	jmp    800afa <vprintfmt+0x135>
  800aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aef:	48 89 d0             	mov    %rdx,%rax
  800af2:	48 83 c2 08          	add    $0x8,%rdx
  800af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aff:	eb 23                	jmp    800b24 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b05:	79 0c                	jns    800b13 <vprintfmt+0x14e>
				width = 0;
  800b07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b0e:	e9 3b ff ff ff       	jmpq   800a4e <vprintfmt+0x89>
  800b13:	e9 36 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b18:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b1f:	e9 2a ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b28:	79 12                	jns    800b3c <vprintfmt+0x177>
				width = precision, precision = -1;
  800b2a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b30:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b37:	e9 12 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>
  800b3c:	e9 0d ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b41:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b45:	e9 04 ff ff ff       	jmpq   800a4e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4d:	83 f8 30             	cmp    $0x30,%eax
  800b50:	73 17                	jae    800b69 <vprintfmt+0x1a4>
  800b52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b59:	89 c0                	mov    %eax,%eax
  800b5b:	48 01 d0             	add    %rdx,%rax
  800b5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b61:	83 c2 08             	add    $0x8,%edx
  800b64:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x1b3>
  800b69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b6d:	48 89 d0             	mov    %rdx,%rax
  800b70:	48 83 c2 08          	add    $0x8,%rdx
  800b74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b78:	8b 10                	mov    (%rax),%edx
  800b7a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b82:	48 89 ce             	mov    %rcx,%rsi
  800b85:	89 d7                	mov    %edx,%edi
  800b87:	ff d0                	callq  *%rax
			break;
  800b89:	e9 40 03 00 00       	jmpq   800ece <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b91:	83 f8 30             	cmp    $0x30,%eax
  800b94:	73 17                	jae    800bad <vprintfmt+0x1e8>
  800b96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 01 d0             	add    %rdx,%rax
  800ba2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba5:	83 c2 08             	add    $0x8,%edx
  800ba8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bab:	eb 0f                	jmp    800bbc <vprintfmt+0x1f7>
  800bad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb1:	48 89 d0             	mov    %rdx,%rax
  800bb4:	48 83 c2 08          	add    $0x8,%rdx
  800bb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	79 02                	jns    800bc4 <vprintfmt+0x1ff>
				err = -err;
  800bc2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bc4:	83 fb 15             	cmp    $0x15,%ebx
  800bc7:	7f 16                	jg     800bdf <vprintfmt+0x21a>
  800bc9:	48 b8 80 4b 80 00 00 	movabs $0x804b80,%rax
  800bd0:	00 00 00 
  800bd3:	48 63 d3             	movslq %ebx,%rdx
  800bd6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bda:	4d 85 e4             	test   %r12,%r12
  800bdd:	75 2e                	jne    800c0d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bdf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	89 d9                	mov    %ebx,%ecx
  800be9:	48 ba 41 4c 80 00 00 	movabs $0x804c41,%rdx
  800bf0:	00 00 00 
  800bf3:	48 89 c7             	mov    %rax,%rdi
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	49 b8 dd 0e 80 00 00 	movabs $0x800edd,%r8
  800c02:	00 00 00 
  800c05:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c08:	e9 c1 02 00 00       	jmpq   800ece <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c0d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c15:	4c 89 e1             	mov    %r12,%rcx
  800c18:	48 ba 4a 4c 80 00 00 	movabs $0x804c4a,%rdx
  800c1f:	00 00 00 
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	49 b8 dd 0e 80 00 00 	movabs $0x800edd,%r8
  800c31:	00 00 00 
  800c34:	41 ff d0             	callq  *%r8
			break;
  800c37:	e9 92 02 00 00       	jmpq   800ece <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	83 f8 30             	cmp    $0x30,%eax
  800c42:	73 17                	jae    800c5b <vprintfmt+0x296>
  800c44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4b:	89 c0                	mov    %eax,%eax
  800c4d:	48 01 d0             	add    %rdx,%rax
  800c50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c53:	83 c2 08             	add    $0x8,%edx
  800c56:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c59:	eb 0f                	jmp    800c6a <vprintfmt+0x2a5>
  800c5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5f:	48 89 d0             	mov    %rdx,%rax
  800c62:	48 83 c2 08          	add    $0x8,%rdx
  800c66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6a:	4c 8b 20             	mov    (%rax),%r12
  800c6d:	4d 85 e4             	test   %r12,%r12
  800c70:	75 0a                	jne    800c7c <vprintfmt+0x2b7>
				p = "(null)";
  800c72:	49 bc 4d 4c 80 00 00 	movabs $0x804c4d,%r12
  800c79:	00 00 00 
			if (width > 0 && padc != '-')
  800c7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c80:	7e 3f                	jle    800cc1 <vprintfmt+0x2fc>
  800c82:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c86:	74 39                	je     800cc1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c88:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c8b:	48 98                	cltq   
  800c8d:	48 89 c6             	mov    %rax,%rsi
  800c90:	4c 89 e7             	mov    %r12,%rdi
  800c93:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  800c9a:	00 00 00 
  800c9d:	ff d0                	callq  *%rax
  800c9f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca2:	eb 17                	jmp    800cbb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ca4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ca8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb0:	48 89 ce             	mov    %rcx,%rsi
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbf:	7f e3                	jg     800ca4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc1:	eb 37                	jmp    800cfa <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cc7:	74 1e                	je     800ce7 <vprintfmt+0x322>
  800cc9:	83 fb 1f             	cmp    $0x1f,%ebx
  800ccc:	7e 05                	jle    800cd3 <vprintfmt+0x30e>
  800cce:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd1:	7e 14                	jle    800ce7 <vprintfmt+0x322>
					putch('?', putdat);
  800cd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdb:	48 89 d6             	mov    %rdx,%rsi
  800cde:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce3:	ff d0                	callq  *%rax
  800ce5:	eb 0f                	jmp    800cf6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ce7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ceb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cef:	48 89 d6             	mov    %rdx,%rsi
  800cf2:	89 df                	mov    %ebx,%edi
  800cf4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cfa:	4c 89 e0             	mov    %r12,%rax
  800cfd:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d01:	0f b6 00             	movzbl (%rax),%eax
  800d04:	0f be d8             	movsbl %al,%ebx
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	74 10                	je     800d1b <vprintfmt+0x356>
  800d0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d0f:	78 b2                	js     800cc3 <vprintfmt+0x2fe>
  800d11:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d15:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d19:	79 a8                	jns    800cc3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d1b:	eb 16                	jmp    800d33 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d25:	48 89 d6             	mov    %rdx,%rsi
  800d28:	bf 20 00 00 00       	mov    $0x20,%edi
  800d2d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d2f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d37:	7f e4                	jg     800d1d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d39:	e9 90 01 00 00       	jmpq   800ece <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d42:	be 03 00 00 00       	mov    $0x3,%esi
  800d47:	48 89 c7             	mov    %rax,%rdi
  800d4a:	48 b8 b5 08 80 00 00 	movabs $0x8008b5,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
  800d56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	48 85 c0             	test   %rax,%rax
  800d61:	79 1d                	jns    800d80 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6b:	48 89 d6             	mov    %rdx,%rsi
  800d6e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d73:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d79:	48 f7 d8             	neg    %rax
  800d7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d80:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d87:	e9 d5 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d90:	be 03 00 00 00       	mov    $0x3,%esi
  800d95:	48 89 c7             	mov    %rax,%rdi
  800d98:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800d9f:	00 00 00 
  800da2:	ff d0                	callq  *%rax
  800da4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800da8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800daf:	e9 ad 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800db4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800db7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbb:	89 d6                	mov    %edx,%esi
  800dbd:	48 89 c7             	mov    %rax,%rdi
  800dc0:	48 b8 b5 08 80 00 00 	movabs $0x8008b5,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	callq  *%rax
  800dcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dd0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dd7:	e9 85 00 00 00       	jmpq   800e61 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ddc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	bf 30 00 00 00       	mov    $0x30,%edi
  800dec:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df6:	48 89 d6             	mov    %rdx,%rsi
  800df9:	bf 78 00 00 00       	mov    $0x78,%edi
  800dfe:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e03:	83 f8 30             	cmp    $0x30,%eax
  800e06:	73 17                	jae    800e1f <vprintfmt+0x45a>
  800e08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0f:	89 c0                	mov    %eax,%eax
  800e11:	48 01 d0             	add    %rdx,%rax
  800e14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e17:	83 c2 08             	add    $0x8,%edx
  800e1a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e1d:	eb 0f                	jmp    800e2e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e23:	48 89 d0             	mov    %rdx,%rax
  800e26:	48 83 c2 08          	add    $0x8,%rdx
  800e2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e2e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e35:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e3c:	eb 23                	jmp    800e61 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e42:	be 03 00 00 00       	mov    $0x3,%esi
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e5a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e61:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e66:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e69:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e70:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e78:	45 89 c1             	mov    %r8d,%r9d
  800e7b:	41 89 f8             	mov    %edi,%r8d
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 ea 06 80 00 00 	movabs $0x8006ea,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
			break;
  800e8d:	eb 3f                	jmp    800ece <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e97:	48 89 d6             	mov    %rdx,%rsi
  800e9a:	89 df                	mov    %ebx,%edi
  800e9c:	ff d0                	callq  *%rax
			break;
  800e9e:	eb 2e                	jmp    800ece <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea8:	48 89 d6             	mov    %rdx,%rsi
  800eab:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eb2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eb7:	eb 05                	jmp    800ebe <vprintfmt+0x4f9>
  800eb9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ec2:	48 83 e8 01          	sub    $0x1,%rax
  800ec6:	0f b6 00             	movzbl (%rax),%eax
  800ec9:	3c 25                	cmp    $0x25,%al
  800ecb:	75 ec                	jne    800eb9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ecd:	90                   	nop
		}
	}
  800ece:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecf:	e9 43 fb ff ff       	jmpq   800a17 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ed4:	48 83 c4 60          	add    $0x60,%rsp
  800ed8:	5b                   	pop    %rbx
  800ed9:	41 5c                	pop    %r12
  800edb:	5d                   	pop    %rbp
  800edc:	c3                   	retq   

0000000000800edd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ee8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eef:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ef6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800efd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f04:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f0b:	84 c0                	test   %al,%al
  800f0d:	74 20                	je     800f2f <printfmt+0x52>
  800f0f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f13:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f17:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f1b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f23:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f27:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f2b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f2f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f36:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f3d:	00 00 00 
  800f40:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f47:	00 00 00 
  800f4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f4e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f55:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f5c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f63:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f6a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f71:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f78:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f7f:	48 89 c7             	mov    %rax,%rdi
  800f82:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f8e:	c9                   	leaveq 
  800f8f:	c3                   	retq   

0000000000800f90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f90:	55                   	push   %rbp
  800f91:	48 89 e5             	mov    %rsp,%rbp
  800f94:	48 83 ec 10          	sub    $0x10,%rsp
  800f98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa3:	8b 40 10             	mov    0x10(%rax),%eax
  800fa6:	8d 50 01             	lea    0x1(%rax),%edx
  800fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fad:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb4:	48 8b 10             	mov    (%rax),%rdx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fbf:	48 39 c2             	cmp    %rax,%rdx
  800fc2:	73 17                	jae    800fdb <sprintputch+0x4b>
		*b->buf++ = ch;
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	48 8b 00             	mov    (%rax),%rax
  800fcb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd3:	48 89 0a             	mov    %rcx,(%rdx)
  800fd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fd9:	88 10                	mov    %dl,(%rax)
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 50          	sub    $0x50,%rsp
  800fe5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fe9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fec:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ff4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ff8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ffc:	48 8b 0a             	mov    (%rdx),%rcx
  800fff:	48 89 08             	mov    %rcx,(%rax)
  801002:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801006:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80100a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801012:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801016:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80101a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80101d:	48 98                	cltq   
  80101f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801023:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801027:	48 01 d0             	add    %rdx,%rax
  80102a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80102e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801035:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80103a:	74 06                	je     801042 <vsnprintf+0x65>
  80103c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801040:	7f 07                	jg     801049 <vsnprintf+0x6c>
		return -E_INVAL;
  801042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801047:	eb 2f                	jmp    801078 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801049:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80104d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801051:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801055:	48 89 c6             	mov    %rax,%rsi
  801058:	48 bf 90 0f 80 00 00 	movabs $0x800f90,%rdi
  80105f:	00 00 00 
  801062:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  801069:	00 00 00 
  80106c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80106e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801072:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801075:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801085:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80108c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801092:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801099:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010a7:	84 c0                	test   %al,%al
  8010a9:	74 20                	je     8010cb <snprintf+0x51>
  8010ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010cb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010d2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010d9:	00 00 00 
  8010dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010e3:	00 00 00 
  8010e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801106:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80110d:	48 8b 0a             	mov    (%rdx),%rcx
  801110:	48 89 08             	mov    %rcx,(%rax)
  801113:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801117:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80111b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80111f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801123:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80112a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801131:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801137:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80113e:	48 89 c7             	mov    %rax,%rdi
  801141:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  801148:	00 00 00 
  80114b:	ff d0                	callq  *%rax
  80114d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801153:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801159:	c9                   	leaveq 
  80115a:	c3                   	retq   

000000000080115b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80115b:	55                   	push   %rbp
  80115c:	48 89 e5             	mov    %rsp,%rbp
  80115f:	48 83 ec 18          	sub    $0x18,%rsp
  801163:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80116e:	eb 09                	jmp    801179 <strlen+0x1e>
		n++;
  801170:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801174:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	0f b6 00             	movzbl (%rax),%eax
  801180:	84 c0                	test   %al,%al
  801182:	75 ec                	jne    801170 <strlen+0x15>
		n++;
	return n;
  801184:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 20          	sub    $0x20,%rsp
  801191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a0:	eb 0e                	jmp    8011b0 <strnlen+0x27>
		n++;
  8011a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ab:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011b5:	74 0b                	je     8011c2 <strnlen+0x39>
  8011b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 e0                	jne    8011a2 <strnlen+0x19>
		n++;
	return n;
  8011c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   

00000000008011c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 83 ec 20          	sub    $0x20,%rsp
  8011cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011df:	90                   	nop
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011f8:	0f b6 12             	movzbl (%rdx),%edx
  8011fb:	88 10                	mov    %dl,(%rax)
  8011fd:	0f b6 00             	movzbl (%rax),%eax
  801200:	84 c0                	test   %al,%al
  801202:	75 dc                	jne    8011e0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 83 ec 20          	sub    $0x20,%rsp
  801212:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801216:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	48 89 c7             	mov    %rax,%rdi
  801221:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  801228:	00 00 00 
  80122b:	ff d0                	callq  *%rax
  80122d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801233:	48 63 d0             	movslq %eax,%rdx
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	48 01 c2             	add    %rax,%rdx
  80123d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801241:	48 89 c6             	mov    %rax,%rsi
  801244:	48 89 d7             	mov    %rdx,%rdi
  801247:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80124e:	00 00 00 
  801251:	ff d0                	callq  *%rax
	return dst;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 83 ec 28          	sub    $0x28,%rsp
  801261:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801265:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801269:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801275:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80127c:	00 
  80127d:	eb 2a                	jmp    8012a9 <strncpy+0x50>
		*dst++ = *src;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801287:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80128b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80128f:	0f b6 12             	movzbl (%rdx),%edx
  801292:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801294:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	84 c0                	test   %al,%al
  80129d:	74 05                	je     8012a4 <strncpy+0x4b>
			src++;
  80129f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b1:	72 cc                	jb     80127f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 28          	sub    $0x28,%rsp
  8012c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012da:	74 3d                	je     801319 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012dc:	eb 1d                	jmp    8012fb <strlcpy+0x42>
			*dst++ = *src++;
  8012de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012f6:	0f b6 12             	movzbl (%rdx),%edx
  8012f9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012fb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801300:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801305:	74 0b                	je     801312 <strlcpy+0x59>
  801307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 cc                	jne    8012de <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	48 29 c2             	sub    %rax,%rdx
  801324:	48 89 d0             	mov    %rdx,%rax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 10          	sub    $0x10,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801339:	eb 0a                	jmp    801345 <strcmp+0x1c>
		p++, q++;
  80133b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801340:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801349:	0f b6 00             	movzbl (%rax),%eax
  80134c:	84 c0                	test   %al,%al
  80134e:	74 12                	je     801362 <strcmp+0x39>
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 10             	movzbl (%rax),%edx
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	38 c2                	cmp    %al,%dl
  801360:	74 d9                	je     80133b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	0f b6 d0             	movzbl %al,%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	0f b6 c0             	movzbl %al,%eax
  801376:	29 c2                	sub    %eax,%edx
  801378:	89 d0                	mov    %edx,%eax
}
  80137a:	c9                   	leaveq 
  80137b:	c3                   	retq   

000000000080137c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	48 83 ec 18          	sub    $0x18,%rsp
  801384:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801388:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80138c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801390:	eb 0f                	jmp    8013a1 <strncmp+0x25>
		n--, p++, q++;
  801392:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801397:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80139c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013a6:	74 1d                	je     8013c5 <strncmp+0x49>
  8013a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 12                	je     8013c5 <strncmp+0x49>
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b7:	0f b6 10             	movzbl (%rax),%edx
  8013ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	38 c2                	cmp    %al,%dl
  8013c3:	74 cd                	je     801392 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ca:	75 07                	jne    8013d3 <strncmp+0x57>
		return 0;
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d1:	eb 18                	jmp    8013eb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	0f b6 d0             	movzbl %al,%edx
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	0f b6 c0             	movzbl %al,%eax
  8013e7:	29 c2                	sub    %eax,%edx
  8013e9:	89 d0                	mov    %edx,%eax
}
  8013eb:	c9                   	leaveq 
  8013ec:	c3                   	retq   

00000000008013ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 83 ec 0c          	sub    $0xc,%rsp
  8013f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f9:	89 f0                	mov    %esi,%eax
  8013fb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013fe:	eb 17                	jmp    801417 <strchr+0x2a>
		if (*s == c)
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80140a:	75 06                	jne    801412 <strchr+0x25>
			return (char *) s;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801410:	eb 15                	jmp    801427 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801412:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	84 c0                	test   %al,%al
  801420:	75 de                	jne    801400 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801427:	c9                   	leaveq 
  801428:	c3                   	retq   

0000000000801429 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801429:	55                   	push   %rbp
  80142a:	48 89 e5             	mov    %rsp,%rbp
  80142d:	48 83 ec 0c          	sub    $0xc,%rsp
  801431:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801435:	89 f0                	mov    %esi,%eax
  801437:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80143a:	eb 13                	jmp    80144f <strfind+0x26>
		if (*s == c)
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801446:	75 02                	jne    80144a <strfind+0x21>
			break;
  801448:	eb 10                	jmp    80145a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80144a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801453:	0f b6 00             	movzbl (%rax),%eax
  801456:	84 c0                	test   %al,%al
  801458:	75 e2                	jne    80143c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145e:	c9                   	leaveq 
  80145f:	c3                   	retq   

0000000000801460 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	48 83 ec 18          	sub    $0x18,%rsp
  801468:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801473:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801478:	75 06                	jne    801480 <memset+0x20>
		return v;
  80147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147e:	eb 69                	jmp    8014e9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	83 e0 03             	and    $0x3,%eax
  801487:	48 85 c0             	test   %rax,%rax
  80148a:	75 48                	jne    8014d4 <memset+0x74>
  80148c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 3c                	jne    8014d4 <memset+0x74>
		c &= 0xFF;
  801498:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80149f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a2:	c1 e0 18             	shl    $0x18,%eax
  8014a5:	89 c2                	mov    %eax,%edx
  8014a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014aa:	c1 e0 10             	shl    $0x10,%eax
  8014ad:	09 c2                	or     %eax,%edx
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	c1 e0 08             	shl    $0x8,%eax
  8014b5:	09 d0                	or     %edx,%eax
  8014b7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	48 c1 e8 02          	shr    $0x2,%rax
  8014c2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cc:	48 89 d7             	mov    %rdx,%rdi
  8014cf:	fc                   	cld    
  8014d0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014d2:	eb 11                	jmp    8014e5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014df:	48 89 d7             	mov    %rdx,%rdi
  8014e2:	fc                   	cld    
  8014e3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 28          	sub    $0x28,%rsp
  8014f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801503:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801517:	0f 83 88 00 00 00    	jae    8015a5 <memmove+0xba>
  80151d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801521:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801525:	48 01 d0             	add    %rdx,%rax
  801528:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80152c:	76 77                	jbe    8015a5 <memmove+0xba>
		s += n;
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	83 e0 03             	and    $0x3,%eax
  801545:	48 85 c0             	test   %rax,%rax
  801548:	75 3b                	jne    801585 <memmove+0x9a>
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 2f                	jne    801585 <memmove+0x9a>
  801556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155a:	83 e0 03             	and    $0x3,%eax
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	75 23                	jne    801585 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801566:	48 83 e8 04          	sub    $0x4,%rax
  80156a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156e:	48 83 ea 04          	sub    $0x4,%rdx
  801572:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801576:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80157a:	48 89 c7             	mov    %rax,%rdi
  80157d:	48 89 d6             	mov    %rdx,%rsi
  801580:	fd                   	std    
  801581:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801583:	eb 1d                	jmp    8015a2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80158d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801591:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 89 d7             	mov    %rdx,%rdi
  80159c:	48 89 c1             	mov    %rax,%rcx
  80159f:	fd                   	std    
  8015a0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015a2:	fc                   	cld    
  8015a3:	eb 57                	jmp    8015fc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	48 85 c0             	test   %rax,%rax
  8015af:	75 36                	jne    8015e7 <memmove+0xfc>
  8015b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	48 85 c0             	test   %rax,%rax
  8015bb:	75 2a                	jne    8015e7 <memmove+0xfc>
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	48 85 c0             	test   %rax,%rax
  8015c7:	75 1e                	jne    8015e7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 c1 e8 02          	shr    $0x2,%rax
  8015d1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015dc:	48 89 c7             	mov    %rax,%rdi
  8015df:	48 89 d6             	mov    %rdx,%rsi
  8015e2:	fc                   	cld    
  8015e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e5:	eb 15                	jmp    8015fc <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f3:	48 89 c7             	mov    %rax,%rdi
  8015f6:	48 89 d6             	mov    %rdx,%rsi
  8015f9:	fc                   	cld    
  8015fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801600:	c9                   	leaveq 
  801601:	c3                   	retq   

0000000000801602 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801602:	55                   	push   %rbp
  801603:	48 89 e5             	mov    %rsp,%rbp
  801606:	48 83 ec 18          	sub    $0x18,%rsp
  80160a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801612:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	48 89 ce             	mov    %rcx,%rsi
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 28          	sub    $0x28,%rsp
  80163e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801646:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80164a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801656:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80165a:	eb 36                	jmp    801692 <memcmp+0x5c>
		if (*s1 != *s2)
  80165c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801660:	0f b6 10             	movzbl (%rax),%edx
  801663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	38 c2                	cmp    %al,%dl
  80166c:	74 1a                	je     801688 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	0f b6 d0             	movzbl %al,%edx
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	0f b6 c0             	movzbl %al,%eax
  801682:	29 c2                	sub    %eax,%edx
  801684:	89 d0                	mov    %edx,%eax
  801686:	eb 20                	jmp    8016a8 <memcmp+0x72>
		s1++, s2++;
  801688:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80168d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80169a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80169e:	48 85 c0             	test   %rax,%rax
  8016a1:	75 b9                	jne    80165c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a8:	c9                   	leaveq 
  8016a9:	c3                   	retq   

00000000008016aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016aa:	55                   	push   %rbp
  8016ab:	48 89 e5             	mov    %rsp,%rbp
  8016ae:	48 83 ec 28          	sub    $0x28,%rsp
  8016b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c5:	48 01 d0             	add    %rdx,%rax
  8016c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016cc:	eb 15                	jmp    8016e3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d2:	0f b6 10             	movzbl (%rax),%edx
  8016d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016d8:	38 c2                	cmp    %al,%dl
  8016da:	75 02                	jne    8016de <memfind+0x34>
			break;
  8016dc:	eb 0f                	jmp    8016ed <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016de:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016eb:	72 e1                	jb     8016ce <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 34          	sub    $0x34,%rsp
  8016fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801703:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80170d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801714:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801715:	eb 05                	jmp    80171c <strtol+0x29>
		s++;
  801717:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	3c 20                	cmp    $0x20,%al
  801725:	74 f0                	je     801717 <strtol+0x24>
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	3c 09                	cmp    $0x9,%al
  801730:	74 e5                	je     801717 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	3c 2b                	cmp    $0x2b,%al
  80173b:	75 07                	jne    801744 <strtol+0x51>
		s++;
  80173d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801742:	eb 17                	jmp    80175b <strtol+0x68>
	else if (*s == '-')
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	3c 2d                	cmp    $0x2d,%al
  80174d:	75 0c                	jne    80175b <strtol+0x68>
		s++, neg = 1;
  80174f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801754:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80175b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80175f:	74 06                	je     801767 <strtol+0x74>
  801761:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801765:	75 28                	jne    80178f <strtol+0x9c>
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 30                	cmp    $0x30,%al
  801770:	75 1d                	jne    80178f <strtol+0x9c>
  801772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801776:	48 83 c0 01          	add    $0x1,%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 78                	cmp    $0x78,%al
  80177f:	75 0e                	jne    80178f <strtol+0x9c>
		s += 2, base = 16;
  801781:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801786:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80178d:	eb 2c                	jmp    8017bb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80178f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801793:	75 19                	jne    8017ae <strtol+0xbb>
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 30                	cmp    $0x30,%al
  80179e:	75 0e                	jne    8017ae <strtol+0xbb>
		s++, base = 8;
  8017a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017ac:	eb 0d                	jmp    8017bb <strtol+0xc8>
	else if (base == 0)
  8017ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b2:	75 07                	jne    8017bb <strtol+0xc8>
		base = 10;
  8017b4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	3c 2f                	cmp    $0x2f,%al
  8017c4:	7e 1d                	jle    8017e3 <strtol+0xf0>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 39                	cmp    $0x39,%al
  8017cf:	7f 12                	jg     8017e3 <strtol+0xf0>
			dig = *s - '0';
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	0f b6 00             	movzbl (%rax),%eax
  8017d8:	0f be c0             	movsbl %al,%eax
  8017db:	83 e8 30             	sub    $0x30,%eax
  8017de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e1:	eb 4e                	jmp    801831 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	0f b6 00             	movzbl (%rax),%eax
  8017ea:	3c 60                	cmp    $0x60,%al
  8017ec:	7e 1d                	jle    80180b <strtol+0x118>
  8017ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f2:	0f b6 00             	movzbl (%rax),%eax
  8017f5:	3c 7a                	cmp    $0x7a,%al
  8017f7:	7f 12                	jg     80180b <strtol+0x118>
			dig = *s - 'a' + 10;
  8017f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fd:	0f b6 00             	movzbl (%rax),%eax
  801800:	0f be c0             	movsbl %al,%eax
  801803:	83 e8 57             	sub    $0x57,%eax
  801806:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801809:	eb 26                	jmp    801831 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80180b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	3c 40                	cmp    $0x40,%al
  801814:	7e 48                	jle    80185e <strtol+0x16b>
  801816:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181a:	0f b6 00             	movzbl (%rax),%eax
  80181d:	3c 5a                	cmp    $0x5a,%al
  80181f:	7f 3d                	jg     80185e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801821:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801825:	0f b6 00             	movzbl (%rax),%eax
  801828:	0f be c0             	movsbl %al,%eax
  80182b:	83 e8 37             	sub    $0x37,%eax
  80182e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801834:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801837:	7c 02                	jl     80183b <strtol+0x148>
			break;
  801839:	eb 23                	jmp    80185e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80183b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801840:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801843:	48 98                	cltq   
  801845:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80184a:	48 89 c2             	mov    %rax,%rdx
  80184d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801850:	48 98                	cltq   
  801852:	48 01 d0             	add    %rdx,%rax
  801855:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801859:	e9 5d ff ff ff       	jmpq   8017bb <strtol+0xc8>

	if (endptr)
  80185e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801863:	74 0b                	je     801870 <strtol+0x17d>
		*endptr = (char *) s;
  801865:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801869:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80186d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801874:	74 09                	je     80187f <strtol+0x18c>
  801876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187a:	48 f7 d8             	neg    %rax
  80187d:	eb 04                	jmp    801883 <strtol+0x190>
  80187f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801883:	c9                   	leaveq 
  801884:	c3                   	retq   

0000000000801885 <strstr>:

char * strstr(const char *in, const char *str)
{
  801885:	55                   	push   %rbp
  801886:	48 89 e5             	mov    %rsp,%rbp
  801889:	48 83 ec 30          	sub    $0x30,%rsp
  80188d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801891:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801895:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801899:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80189d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018a7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ab:	75 06                	jne    8018b3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	eb 6b                	jmp    80191e <strstr+0x99>

	len = strlen(str);
  8018b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b7:	48 89 c7             	mov    %rax,%rdi
  8018ba:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
  8018c6:	48 98                	cltq   
  8018c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018de:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018e2:	75 07                	jne    8018eb <strstr+0x66>
				return (char *) 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	eb 33                	jmp    80191e <strstr+0x99>
		} while (sc != c);
  8018eb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018ef:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018f2:	75 d8                	jne    8018cc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801900:	48 89 ce             	mov    %rcx,%rsi
  801903:	48 89 c7             	mov    %rax,%rdi
  801906:	48 b8 7c 13 80 00 00 	movabs $0x80137c,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
  801912:	85 c0                	test   %eax,%eax
  801914:	75 b6                	jne    8018cc <strstr+0x47>

	return (char *) (in - 1);
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	48 83 e8 01          	sub    $0x1,%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	53                   	push   %rbx
  801925:	48 83 ec 48          	sub    $0x48,%rsp
  801929:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80192c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80192f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801933:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801937:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80193b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801942:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801946:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80194a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80194e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801952:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801956:	4c 89 c3             	mov    %r8,%rbx
  801959:	cd 30                	int    $0x30
  80195b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80195f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801963:	74 3e                	je     8019a3 <syscall+0x83>
  801965:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80196a:	7e 37                	jle    8019a3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80196c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801970:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801973:	49 89 d0             	mov    %rdx,%r8
  801976:	89 c1                	mov    %eax,%ecx
  801978:	48 ba 08 4f 80 00 00 	movabs $0x804f08,%rdx
  80197f:	00 00 00 
  801982:	be 23 00 00 00       	mov    $0x23,%esi
  801987:	48 bf 25 4f 80 00 00 	movabs $0x804f25,%rdi
  80198e:	00 00 00 
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	49 b9 d9 03 80 00 00 	movabs $0x8003d9,%r9
  80199d:	00 00 00 
  8019a0:	41 ff d1             	callq  *%r9

	return ret;
  8019a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019a7:	48 83 c4 48          	add    $0x48,%rsp
  8019ab:	5b                   	pop    %rbx
  8019ac:	5d                   	pop    %rbp
  8019ad:	c3                   	retq   

00000000008019ae <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 20          	sub    $0x20,%rsp
  8019b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cd:	00 
  8019ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019da:	48 89 d1             	mov    %rdx,%rcx
  8019dd:	48 89 c2             	mov    %rax,%rdx
  8019e0:	be 00 00 00 00       	mov    $0x0,%esi
  8019e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ea:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
}
  8019f6:	c9                   	leaveq 
  8019f7:	c3                   	retq   

00000000008019f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f8:	55                   	push   %rbp
  8019f9:	48 89 e5             	mov    %rsp,%rbp
  8019fc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a07:	00 
  801a08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	bf 01 00 00 00       	mov    $0x1,%edi
  801a28:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	48 83 ec 10          	sub    $0x10,%rsp
  801a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a44:	48 98                	cltq   
  801a46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4d:	00 
  801a4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5f:	48 89 c2             	mov    %rax,%rdx
  801a62:	be 01 00 00 00       	mov    $0x1,%esi
  801a67:	bf 03 00 00 00       	mov    $0x3,%edi
  801a6c:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aaa:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_yield>:

void
sys_yield(void)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ac0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac7:	00 
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ae8:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 20          	sub    $0x20,%rsp
  801afe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b05:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0b:	48 63 c8             	movslq %eax,%rcx
  801b0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b15:	48 98                	cltq   
  801b17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1e:	00 
  801b1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b25:	49 89 c8             	mov    %rcx,%r8
  801b28:	48 89 d1             	mov    %rdx,%rcx
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	be 01 00 00 00       	mov    $0x1,%esi
  801b33:	bf 04 00 00 00       	mov    $0x4,%edi
  801b38:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 30          	sub    $0x30,%rsp
  801b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b55:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b5c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b63:	48 63 c8             	movslq %eax,%rcx
  801b66:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 f0             	movslq %eax,%rsi
  801b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b7d:	49 89 f9             	mov    %rdi,%r9
  801b80:	49 89 f0             	mov    %rsi,%r8
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 01 00 00 00       	mov    $0x1,%esi
  801b8e:	bf 05 00 00 00       	mov    $0x5,%edi
  801b93:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 20          	sub    $0x20,%rsp
  801ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb7:	48 98                	cltq   
  801bb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc0:	00 
  801bc1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcd:	48 89 d1             	mov    %rdx,%rcx
  801bd0:	48 89 c2             	mov    %rax,%rdx
  801bd3:	be 01 00 00 00       	mov    $0x1,%esi
  801bd8:	bf 06 00 00 00       	mov    $0x6,%edi
  801bdd:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
}
  801be9:	c9                   	leaveq 
  801bea:	c3                   	retq   

0000000000801beb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801beb:	55                   	push   %rbp
  801bec:	48 89 e5             	mov    %rsp,%rbp
  801bef:	48 83 ec 10          	sub    $0x10,%rsp
  801bf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bfc:	48 63 d0             	movslq %eax,%rdx
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0b:	00 
  801c0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c18:	48 89 d1             	mov    %rdx,%rcx
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	be 01 00 00 00       	mov    $0x1,%esi
  801c23:	bf 08 00 00 00       	mov    $0x8,%edi
  801c28:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	callq  *%rax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 20          	sub    $0x20,%rsp
  801c3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4c:	48 98                	cltq   
  801c4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c55:	00 
  801c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c62:	48 89 d1             	mov    %rdx,%rcx
  801c65:	48 89 c2             	mov    %rax,%rdx
  801c68:	be 01 00 00 00       	mov    $0x1,%esi
  801c6d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c72:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	callq  *%rax
}
  801c7e:	c9                   	leaveq 
  801c7f:	c3                   	retq   

0000000000801c80 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 20          	sub    $0x20,%rsp
  801c88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c96:	48 98                	cltq   
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cac:	48 89 d1             	mov    %rdx,%rcx
  801caf:	48 89 c2             	mov    %rax,%rdx
  801cb2:	be 01 00 00 00       	mov    $0x1,%esi
  801cb7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cbc:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 83 ec 20          	sub    $0x20,%rsp
  801cd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cdd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ce0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce3:	48 63 f0             	movslq %eax,%rsi
  801ce6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ced:	48 98                	cltq   
  801cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfa:	00 
  801cfb:	49 89 f1             	mov    %rsi,%r9
  801cfe:	49 89 c8             	mov    %rcx,%r8
  801d01:	48 89 d1             	mov    %rdx,%rcx
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d11:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 10          	sub    $0x10,%rsp
  801d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d36:	00 
  801d37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d48:	48 89 c2             	mov    %rax,%rdx
  801d4b:	be 01 00 00 00       	mov    $0x1,%esi
  801d50:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d55:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 20          	sub    $0x20,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d82:	00 
  801d83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8f:	48 89 d1             	mov    %rdx,%rcx
  801d92:	48 89 c2             	mov    %rax,%rdx
  801d95:	be 01 00 00 00       	mov    $0x1,%esi
  801d9a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d9f:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 10          	sub    $0x10,%rsp
  801db5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc4:	00 
  801dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd6:	48 89 c2             	mov    %rax,%rdx
  801dd9:	be 00 00 00 00       	mov    $0x0,%esi
  801dde:	bf 10 00 00 00       	mov    $0x10,%edi
  801de3:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801dea:	00 00 00 
  801ded:	ff d0                	callq  *%rax
}
  801def:	c9                   	leaveq 
  801df0:	c3                   	retq   

0000000000801df1 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801df1:	55                   	push   %rbp
  801df2:	48 89 e5             	mov    %rsp,%rbp
  801df5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801df9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e00:	00 
  801e01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	be 00 00 00 00       	mov    $0x0,%esi
  801e1c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e21:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	callq  *%rax
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	48 83 ec 30          	sub    $0x30,%rsp
  801e37:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3f:	48 8b 00             	mov    (%rax),%rax
  801e42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e54:	83 e0 02             	and    $0x2,%eax
  801e57:	85 c0                	test   %eax,%eax
  801e59:	75 4d                	jne    801ea8 <pgfault+0x79>
  801e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e63:	48 89 c2             	mov    %rax,%rdx
  801e66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6d:	01 00 00 
  801e70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e74:	25 00 08 00 00       	and    $0x800,%eax
  801e79:	48 85 c0             	test   %rax,%rax
  801e7c:	74 2a                	je     801ea8 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e7e:	48 ba 38 4f 80 00 00 	movabs $0x804f38,%rdx
  801e85:	00 00 00 
  801e88:	be 23 00 00 00       	mov    $0x23,%esi
  801e8d:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801e94:	00 00 00 
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9c:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801ea3:	00 00 00 
  801ea6:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ea8:	ba 07 00 00 00       	mov    $0x7,%edx
  801ead:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb7:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 85 cd 00 00 00    	jne    801f98 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801edd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801ee1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801eea:	48 89 c6             	mov    %rax,%rsi
  801eed:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ef2:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f02:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f08:	48 89 c1             	mov    %rax,%rcx
  801f0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f10:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f15:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1a:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
  801f26:	85 c0                	test   %eax,%eax
  801f28:	79 2a                	jns    801f54 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f2a:	48 ba 78 4f 80 00 00 	movabs $0x804f78,%rdx
  801f31:	00 00 00 
  801f34:	be 30 00 00 00       	mov    $0x30,%esi
  801f39:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801f40:	00 00 00 
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801f4f:	00 00 00 
  801f52:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f54:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f59:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5e:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	callq  *%rax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	79 54                	jns    801fc2 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f6e:	48 ba 98 4f 80 00 00 	movabs $0x804f98,%rdx
  801f75:	00 00 00 
  801f78:	be 32 00 00 00       	mov    $0x32,%esi
  801f7d:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801f84:	00 00 00 
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801f93:	00 00 00 
  801f96:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f98:	48 ba c0 4f 80 00 00 	movabs $0x804fc0,%rdx
  801f9f:	00 00 00 
  801fa2:	be 34 00 00 00       	mov    $0x34,%esi
  801fa7:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  801fae:	00 00 00 
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  801fbd:	00 00 00 
  801fc0:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fc2:	c9                   	leaveq 
  801fc3:	c3                   	retq   

0000000000801fc4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
  801fc8:	48 83 ec 20          	sub    $0x20,%rsp
  801fcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fcf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801fd2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd9:	01 00 00 
  801fdc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe3:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801feb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fee:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff9:	25 00 04 00 00       	and    $0x400,%eax
  801ffe:	85 c0                	test   %eax,%eax
  802000:	74 57                	je     802059 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802002:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802005:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802009:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80200c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802010:	41 89 f0             	mov    %esi,%r8d
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	bf 00 00 00 00       	mov    $0x0,%edi
  80201b:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802022:	00 00 00 
  802025:	ff d0                	callq  *%rax
  802027:	85 c0                	test   %eax,%eax
  802029:	0f 8e 52 01 00 00    	jle    802181 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80202f:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  802036:	00 00 00 
  802039:	be 4e 00 00 00       	mov    $0x4e,%esi
  80203e:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802045:	00 00 00 
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  802054:	00 00 00 
  802057:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205c:	83 e0 02             	and    $0x2,%eax
  80205f:	85 c0                	test   %eax,%eax
  802061:	75 10                	jne    802073 <duppage+0xaf>
  802063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802066:	25 00 08 00 00       	and    $0x800,%eax
  80206b:	85 c0                	test   %eax,%eax
  80206d:	0f 84 bb 00 00 00    	je     80212e <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802076:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80207b:	80 cc 08             	or     $0x8,%ah
  80207e:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802081:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802084:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802088:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80208b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208f:	41 89 f0             	mov    %esi,%r8d
  802092:	48 89 c6             	mov    %rax,%rsi
  802095:	bf 00 00 00 00       	mov    $0x0,%edi
  80209a:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	7e 2a                	jle    8020d4 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020aa:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  8020b1:	00 00 00 
  8020b4:	be 55 00 00 00       	mov    $0x55,%esi
  8020b9:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  8020c0:	00 00 00 
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8020cf:	00 00 00 
  8020d2:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020d4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020df:	41 89 c8             	mov    %ecx,%r8d
  8020e2:	48 89 d1             	mov    %rdx,%rcx
  8020e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ea:	48 89 c6             	mov    %rax,%rsi
  8020ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f2:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	7e 2a                	jle    80212c <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802102:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  802109:	00 00 00 
  80210c:	be 57 00 00 00       	mov    $0x57,%esi
  802111:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802118:	00 00 00 
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  802127:	00 00 00 
  80212a:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80212c:	eb 53                	jmp    802181 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80212e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802131:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802135:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213c:	41 89 f0             	mov    %esi,%r8d
  80213f:	48 89 c6             	mov    %rax,%rsi
  802142:	bf 00 00 00 00       	mov    $0x0,%edi
  802147:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80214e:	00 00 00 
  802151:	ff d0                	callq  *%rax
  802153:	85 c0                	test   %eax,%eax
  802155:	7e 2a                	jle    802181 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802157:	48 ba f2 4f 80 00 00 	movabs $0x804ff2,%rdx
  80215e:	00 00 00 
  802161:	be 5b 00 00 00       	mov    $0x5b,%esi
  802166:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  80216d:	00 00 00 
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  80217c:	00 00 00 
  80217f:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
  80218c:	48 83 ec 18          	sub    $0x18,%rsp
  802190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80219c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a0:	48 c1 e8 27          	shr    $0x27,%rax
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021ae:	01 00 00 
  8021b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b5:	83 e0 01             	and    $0x1,%eax
  8021b8:	48 85 c0             	test   %rax,%rax
  8021bb:	74 51                	je     80220e <pt_is_mapped+0x86>
  8021bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c1:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021c9:	48 89 c2             	mov    %rax,%rdx
  8021cc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021d3:	01 00 00 
  8021d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021da:	83 e0 01             	and    $0x1,%eax
  8021dd:	48 85 c0             	test   %rax,%rax
  8021e0:	74 2c                	je     80220e <pt_is_mapped+0x86>
  8021e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e6:	48 c1 e0 0c          	shl    $0xc,%rax
  8021ea:	48 c1 e8 15          	shr    $0x15,%rax
  8021ee:	48 89 c2             	mov    %rax,%rdx
  8021f1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f8:	01 00 00 
  8021fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ff:	83 e0 01             	and    $0x1,%eax
  802202:	48 85 c0             	test   %rax,%rax
  802205:	74 07                	je     80220e <pt_is_mapped+0x86>
  802207:	b8 01 00 00 00       	mov    $0x1,%eax
  80220c:	eb 05                	jmp    802213 <pt_is_mapped+0x8b>
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
  802213:	83 e0 01             	and    $0x1,%eax
}
  802216:	c9                   	leaveq 
  802217:	c3                   	retq   

0000000000802218 <fork>:

envid_t
fork(void)
{
  802218:	55                   	push   %rbp
  802219:	48 89 e5             	mov    %rsp,%rbp
  80221c:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802220:	48 bf 2f 1e 80 00 00 	movabs $0x801e2f,%rdi
  802227:	00 00 00 
  80222a:	48 b8 55 45 80 00 00 	movabs $0x804555,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802236:	b8 07 00 00 00       	mov    $0x7,%eax
  80223b:	cd 30                	int    $0x30
  80223d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802240:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802243:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802246:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80224a:	79 30                	jns    80227c <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80224c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	48 ba 10 50 80 00 00 	movabs $0x805010,%rdx
  802258:	00 00 00 
  80225b:	be 86 00 00 00       	mov    $0x86,%esi
  802260:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  802267:	00 00 00 
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  802276:	00 00 00 
  802279:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80227c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802280:	75 46                	jne    8022c8 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802282:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  802289:	00 00 00 
  80228c:	ff d0                	callq  *%rax
  80228e:	25 ff 03 00 00       	and    $0x3ff,%eax
  802293:	48 63 d0             	movslq %eax,%rdx
  802296:	48 89 d0             	mov    %rdx,%rax
  802299:	48 c1 e0 03          	shl    $0x3,%rax
  80229d:	48 01 d0             	add    %rdx,%rax
  8022a0:	48 c1 e0 05          	shl    $0x5,%rax
  8022a4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022ab:	00 00 00 
  8022ae:	48 01 c2             	add    %rax,%rdx
  8022b1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022b8:	00 00 00 
  8022bb:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	e9 d1 01 00 00       	jmpq   802499 <fork+0x281>
	}
	uint64_t ad = 0;
  8022c8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022cf:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022d0:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022d9:	e9 df 00 00 00       	jmpq   8023bd <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e2:	48 c1 e8 27          	shr    $0x27,%rax
  8022e6:	48 89 c2             	mov    %rax,%rdx
  8022e9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022f0:	01 00 00 
  8022f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f7:	83 e0 01             	and    $0x1,%eax
  8022fa:	48 85 c0             	test   %rax,%rax
  8022fd:	0f 84 9e 00 00 00    	je     8023a1 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802307:	48 c1 e8 1e          	shr    $0x1e,%rax
  80230b:	48 89 c2             	mov    %rax,%rdx
  80230e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802315:	01 00 00 
  802318:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231c:	83 e0 01             	and    $0x1,%eax
  80231f:	48 85 c0             	test   %rax,%rax
  802322:	74 73                	je     802397 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802328:	48 c1 e8 15          	shr    $0x15,%rax
  80232c:	48 89 c2             	mov    %rax,%rdx
  80232f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802336:	01 00 00 
  802339:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233d:	83 e0 01             	and    $0x1,%eax
  802340:	48 85 c0             	test   %rax,%rax
  802343:	74 48                	je     80238d <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802349:	48 c1 e8 0c          	shr    $0xc,%rax
  80234d:	48 89 c2             	mov    %rax,%rdx
  802350:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802357:	01 00 00 
  80235a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802366:	83 e0 01             	and    $0x1,%eax
  802369:	48 85 c0             	test   %rax,%rax
  80236c:	74 47                	je     8023b5 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80236e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802372:	48 c1 e8 0c          	shr    $0xc,%rax
  802376:	89 c2                	mov    %eax,%edx
  802378:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80237b:	89 d6                	mov    %edx,%esi
  80237d:	89 c7                	mov    %eax,%edi
  80237f:	48 b8 c4 1f 80 00 00 	movabs $0x801fc4,%rax
  802386:	00 00 00 
  802389:	ff d0                	callq  *%rax
  80238b:	eb 28                	jmp    8023b5 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80238d:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802394:	00 
  802395:	eb 1e                	jmp    8023b5 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802397:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80239e:	40 
  80239f:	eb 14                	jmp    8023b5 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8023a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a5:	48 c1 e8 27          	shr    $0x27,%rax
  8023a9:	48 83 c0 01          	add    $0x1,%rax
  8023ad:	48 c1 e0 27          	shl    $0x27,%rax
  8023b1:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023b5:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023bc:	00 
  8023bd:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023c4:	00 
  8023c5:	0f 87 13 ff ff ff    	ja     8022de <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023ce:	ba 07 00 00 00       	mov    $0x7,%edx
  8023d3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023d8:	89 c7                	mov    %eax,%edi
  8023da:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8023e1:	00 00 00 
  8023e4:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023e9:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ee:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023f3:	89 c7                	mov    %eax,%edi
  8023f5:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802401:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802404:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80240a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80240f:	ba 00 00 00 00       	mov    $0x0,%edx
  802414:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802427:	ba 00 10 00 00       	mov    $0x1000,%edx
  80242c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802431:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802436:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802442:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802447:	bf 00 00 00 00       	mov    $0x0,%edi
  80244c:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  802453:	00 00 00 
  802456:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802458:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80245f:	00 00 00 
  802462:	48 8b 00             	mov    (%rax),%rax
  802465:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80246c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246f:	48 89 d6             	mov    %rdx,%rsi
  802472:	89 c7                	mov    %eax,%edi
  802474:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802480:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802483:	be 02 00 00 00       	mov    $0x2,%esi
  802488:	89 c7                	mov    %eax,%edi
  80248a:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax

	return envid;
  802496:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802499:	c9                   	leaveq 
  80249a:	c3                   	retq   

000000000080249b <sfork>:

	
// Challenge!
int
sfork(void)
{
  80249b:	55                   	push   %rbp
  80249c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80249f:	48 ba 28 50 80 00 00 	movabs $0x805028,%rdx
  8024a6:	00 00 00 
  8024a9:	be bf 00 00 00       	mov    $0xbf,%esi
  8024ae:	48 bf 6d 4f 80 00 00 	movabs $0x804f6d,%rdi
  8024b5:	00 00 00 
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8024c4:	00 00 00 
  8024c7:	ff d1                	callq  *%rcx

00000000008024c9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024c9:	55                   	push   %rbp
  8024ca:	48 89 e5             	mov    %rsp,%rbp
  8024cd:	48 83 ec 08          	sub    $0x8,%rsp
  8024d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024d9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024e0:	ff ff ff 
  8024e3:	48 01 d0             	add    %rdx,%rax
  8024e6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024ea:	c9                   	leaveq 
  8024eb:	c3                   	retq   

00000000008024ec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024ec:	55                   	push   %rbp
  8024ed:	48 89 e5             	mov    %rsp,%rbp
  8024f0:	48 83 ec 08          	sub    $0x8,%rsp
  8024f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fc:	48 89 c7             	mov    %rax,%rdi
  8024ff:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
  80250b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802511:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802515:	c9                   	leaveq 
  802516:	c3                   	retq   

0000000000802517 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802517:	55                   	push   %rbp
  802518:	48 89 e5             	mov    %rsp,%rbp
  80251b:	48 83 ec 18          	sub    $0x18,%rsp
  80251f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802523:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80252a:	eb 6b                	jmp    802597 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80252c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252f:	48 98                	cltq   
  802531:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802537:	48 c1 e0 0c          	shl    $0xc,%rax
  80253b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	48 c1 e8 15          	shr    $0x15,%rax
  802547:	48 89 c2             	mov    %rax,%rdx
  80254a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802551:	01 00 00 
  802554:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802558:	83 e0 01             	and    $0x1,%eax
  80255b:	48 85 c0             	test   %rax,%rax
  80255e:	74 21                	je     802581 <fd_alloc+0x6a>
  802560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802564:	48 c1 e8 0c          	shr    $0xc,%rax
  802568:	48 89 c2             	mov    %rax,%rdx
  80256b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802572:	01 00 00 
  802575:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802579:	83 e0 01             	and    $0x1,%eax
  80257c:	48 85 c0             	test   %rax,%rax
  80257f:	75 12                	jne    802593 <fd_alloc+0x7c>
			*fd_store = fd;
  802581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802585:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802589:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	eb 1a                	jmp    8025ad <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802593:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802597:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80259b:	7e 8f                	jle    80252c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025a8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 20          	sub    $0x20,%rsp
  8025b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025c2:	78 06                	js     8025ca <fd_lookup+0x1b>
  8025c4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025c8:	7e 07                	jle    8025d1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cf:	eb 6c                	jmp    80263d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d4:	48 98                	cltq   
  8025d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8025e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e8:	48 c1 e8 15          	shr    $0x15,%rax
  8025ec:	48 89 c2             	mov    %rax,%rdx
  8025ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f6:	01 00 00 
  8025f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fd:	83 e0 01             	and    $0x1,%eax
  802600:	48 85 c0             	test   %rax,%rax
  802603:	74 21                	je     802626 <fd_lookup+0x77>
  802605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802609:	48 c1 e8 0c          	shr    $0xc,%rax
  80260d:	48 89 c2             	mov    %rax,%rdx
  802610:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802617:	01 00 00 
  80261a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261e:	83 e0 01             	and    $0x1,%eax
  802621:	48 85 c0             	test   %rax,%rax
  802624:	75 07                	jne    80262d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80262b:	eb 10                	jmp    80263d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80262d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802631:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802635:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263d:	c9                   	leaveq 
  80263e:	c3                   	retq   

000000000080263f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
  802643:	48 83 ec 30          	sub    $0x30,%rsp
  802647:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80264b:	89 f0                	mov    %esi,%eax
  80264d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802654:	48 89 c7             	mov    %rax,%rdi
  802657:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  80265e:	00 00 00 
  802661:	ff d0                	callq  *%rax
  802663:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802667:	48 89 d6             	mov    %rdx,%rsi
  80266a:	89 c7                	mov    %eax,%edi
  80266c:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802673:	00 00 00 
  802676:	ff d0                	callq  *%rax
  802678:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267f:	78 0a                	js     80268b <fd_close+0x4c>
	    || fd != fd2)
  802681:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802685:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802689:	74 12                	je     80269d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80268b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80268f:	74 05                	je     802696 <fd_close+0x57>
  802691:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802694:	eb 05                	jmp    80269b <fd_close+0x5c>
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	eb 69                	jmp    802706 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80269d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a1:	8b 00                	mov    (%rax),%eax
  8026a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026a7:	48 89 d6             	mov    %rdx,%rsi
  8026aa:	89 c7                	mov    %eax,%edi
  8026ac:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
  8026b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bf:	78 2a                	js     8026eb <fd_close+0xac>
		if (dev->dev_close)
  8026c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026c9:	48 85 c0             	test   %rax,%rax
  8026cc:	74 16                	je     8026e4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026da:	48 89 d7             	mov    %rdx,%rdi
  8026dd:	ff d0                	callq  *%rax
  8026df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e2:	eb 07                	jmp    8026eb <fd_close+0xac>
		else
			r = 0;
  8026e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ef:	48 89 c6             	mov    %rax,%rsi
  8026f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f7:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	callq  *%rax
	return r;
  802703:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802706:	c9                   	leaveq 
  802707:	c3                   	retq   

0000000000802708 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802708:	55                   	push   %rbp
  802709:	48 89 e5             	mov    %rsp,%rbp
  80270c:	48 83 ec 20          	sub    $0x20,%rsp
  802710:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802713:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802717:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80271e:	eb 41                	jmp    802761 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802720:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802727:	00 00 00 
  80272a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80272d:	48 63 d2             	movslq %edx,%rdx
  802730:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802734:	8b 00                	mov    (%rax),%eax
  802736:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802739:	75 22                	jne    80275d <dev_lookup+0x55>
			*dev = devtab[i];
  80273b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802742:	00 00 00 
  802745:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802748:	48 63 d2             	movslq %edx,%rdx
  80274b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80274f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802753:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
  80275b:	eb 60                	jmp    8027bd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80275d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802761:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802768:	00 00 00 
  80276b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276e:	48 63 d2             	movslq %edx,%rdx
  802771:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802775:	48 85 c0             	test   %rax,%rax
  802778:	75 a6                	jne    802720 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80277a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802781:	00 00 00 
  802784:	48 8b 00             	mov    (%rax),%rax
  802787:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802790:	89 c6                	mov    %eax,%esi
  802792:	48 bf 40 50 80 00 00 	movabs $0x805040,%rdi
  802799:	00 00 00 
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  8027a8:	00 00 00 
  8027ab:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <close>:

int
close(int fdnum)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 83 ec 20          	sub    $0x20,%rsp
  8027c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d1:	48 89 d6             	mov    %rdx,%rsi
  8027d4:	89 c7                	mov    %eax,%edi
  8027d6:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e9:	79 05                	jns    8027f0 <close+0x31>
		return r;
  8027eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ee:	eb 18                	jmp    802808 <close+0x49>
	else
		return fd_close(fd, 1);
  8027f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f4:	be 01 00 00 00       	mov    $0x1,%esi
  8027f9:	48 89 c7             	mov    %rax,%rdi
  8027fc:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <close_all>:

void
close_all(void)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802812:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802819:	eb 15                	jmp    802830 <close_all+0x26>
		close(i);
  80281b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281e:	89 c7                	mov    %eax,%edi
  802820:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80282c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802830:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802834:	7e e5                	jle    80281b <close_all+0x11>
		close(i);
}
  802836:	c9                   	leaveq 
  802837:	c3                   	retq   

0000000000802838 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802838:	55                   	push   %rbp
  802839:	48 89 e5             	mov    %rsp,%rbp
  80283c:	48 83 ec 40          	sub    $0x40,%rsp
  802840:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802843:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802846:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80284a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80284d:	48 89 d6             	mov    %rdx,%rsi
  802850:	89 c7                	mov    %eax,%edi
  802852:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802859:	00 00 00 
  80285c:	ff d0                	callq  *%rax
  80285e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802861:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802865:	79 08                	jns    80286f <dup+0x37>
		return r;
  802867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286a:	e9 70 01 00 00       	jmpq   8029df <dup+0x1a7>
	close(newfdnum);
  80286f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802872:	89 c7                	mov    %eax,%edi
  802874:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802880:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802883:	48 98                	cltq   
  802885:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80288b:	48 c1 e0 0c          	shl    $0xc,%rax
  80288f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802897:	48 89 c7             	mov    %rax,%rdi
  80289a:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	48 89 c7             	mov    %rax,%rdi
  8028b1:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c5:	48 c1 e8 15          	shr    $0x15,%rax
  8028c9:	48 89 c2             	mov    %rax,%rdx
  8028cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028d3:	01 00 00 
  8028d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028da:	83 e0 01             	and    $0x1,%eax
  8028dd:	48 85 c0             	test   %rax,%rax
  8028e0:	74 73                	je     802955 <dup+0x11d>
  8028e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ea:	48 89 c2             	mov    %rax,%rdx
  8028ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f4:	01 00 00 
  8028f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028fb:	83 e0 01             	and    $0x1,%eax
  8028fe:	48 85 c0             	test   %rax,%rax
  802901:	74 52                	je     802955 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802907:	48 c1 e8 0c          	shr    $0xc,%rax
  80290b:	48 89 c2             	mov    %rax,%rdx
  80290e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802915:	01 00 00 
  802918:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291c:	25 07 0e 00 00       	and    $0xe07,%eax
  802921:	89 c1                	mov    %eax,%ecx
  802923:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	41 89 c8             	mov    %ecx,%r8d
  80292e:	48 89 d1             	mov    %rdx,%rcx
  802931:	ba 00 00 00 00       	mov    $0x0,%edx
  802936:	48 89 c6             	mov    %rax,%rsi
  802939:	bf 00 00 00 00       	mov    $0x0,%edi
  80293e:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
  80294a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802951:	79 02                	jns    802955 <dup+0x11d>
			goto err;
  802953:	eb 57                	jmp    8029ac <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802959:	48 c1 e8 0c          	shr    $0xc,%rax
  80295d:	48 89 c2             	mov    %rax,%rdx
  802960:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802967:	01 00 00 
  80296a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296e:	25 07 0e 00 00       	and    $0xe07,%eax
  802973:	89 c1                	mov    %eax,%ecx
  802975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802979:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80297d:	41 89 c8             	mov    %ecx,%r8d
  802980:	48 89 d1             	mov    %rdx,%rcx
  802983:	ba 00 00 00 00       	mov    $0x0,%edx
  802988:	48 89 c6             	mov    %rax,%rsi
  80298b:	bf 00 00 00 00       	mov    $0x0,%edi
  802990:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax
  80299c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a3:	79 02                	jns    8029a7 <dup+0x16f>
		goto err;
  8029a5:	eb 05                	jmp    8029ac <dup+0x174>

	return newfdnum;
  8029a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029aa:	eb 33                	jmp    8029df <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b0:	48 89 c6             	mov    %rax,%rsi
  8029b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b8:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c8:	48 89 c6             	mov    %rax,%rsi
  8029cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d0:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
	return r;
  8029dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029df:	c9                   	leaveq 
  8029e0:	c3                   	retq   

00000000008029e1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029e1:	55                   	push   %rbp
  8029e2:	48 89 e5             	mov    %rsp,%rbp
  8029e5:	48 83 ec 40          	sub    $0x40,%rsp
  8029e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fb:	48 89 d6             	mov    %rdx,%rsi
  8029fe:	89 c7                	mov    %eax,%edi
  802a00:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
  802a0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a13:	78 24                	js     802a39 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a19:	8b 00                	mov    (%rax),%eax
  802a1b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1f:	48 89 d6             	mov    %rdx,%rsi
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a37:	79 05                	jns    802a3e <read+0x5d>
		return r;
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	eb 76                	jmp    802ab4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a42:	8b 40 08             	mov    0x8(%rax),%eax
  802a45:	83 e0 03             	and    $0x3,%eax
  802a48:	83 f8 01             	cmp    $0x1,%eax
  802a4b:	75 3a                	jne    802a87 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a4d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a54:	00 00 00 
  802a57:	48 8b 00             	mov    (%rax),%rax
  802a5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a63:	89 c6                	mov    %eax,%esi
  802a65:	48 bf 5f 50 80 00 00 	movabs $0x80505f,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802a7b:	00 00 00 
  802a7e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a85:	eb 2d                	jmp    802ab4 <read+0xd3>
	}
	if (!dev->dev_read)
  802a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a8f:	48 85 c0             	test   %rax,%rax
  802a92:	75 07                	jne    802a9b <read+0xba>
		return -E_NOT_SUPP;
  802a94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a99:	eb 19                	jmp    802ab4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aa7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aaf:	48 89 cf             	mov    %rcx,%rdi
  802ab2:	ff d0                	callq  *%rax
}
  802ab4:	c9                   	leaveq 
  802ab5:	c3                   	retq   

0000000000802ab6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ab6:	55                   	push   %rbp
  802ab7:	48 89 e5             	mov    %rsp,%rbp
  802aba:	48 83 ec 30          	sub    $0x30,%rsp
  802abe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ac9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ad0:	eb 49                	jmp    802b1b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad5:	48 98                	cltq   
  802ad7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802adb:	48 29 c2             	sub    %rax,%rdx
  802ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae1:	48 63 c8             	movslq %eax,%rcx
  802ae4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae8:	48 01 c1             	add    %rax,%rcx
  802aeb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aee:	48 89 ce             	mov    %rcx,%rsi
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 e1 29 80 00 00 	movabs $0x8029e1,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
  802aff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b02:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b06:	79 05                	jns    802b0d <readn+0x57>
			return m;
  802b08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b0b:	eb 1c                	jmp    802b29 <readn+0x73>
		if (m == 0)
  802b0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b11:	75 02                	jne    802b15 <readn+0x5f>
			break;
  802b13:	eb 11                	jmp    802b26 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b18:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1e:	48 98                	cltq   
  802b20:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b24:	72 ac                	jb     802ad2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b29:	c9                   	leaveq 
  802b2a:	c3                   	retq   

0000000000802b2b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
  802b2f:	48 83 ec 40          	sub    $0x40,%rsp
  802b33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b45:	48 89 d6             	mov    %rdx,%rsi
  802b48:	89 c7                	mov    %eax,%edi
  802b4a:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
  802b56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5d:	78 24                	js     802b83 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	8b 00                	mov    (%rax),%eax
  802b65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b69:	48 89 d6             	mov    %rdx,%rsi
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802b75:	00 00 00 
  802b78:	ff d0                	callq  *%rax
  802b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b81:	79 05                	jns    802b88 <write+0x5d>
		return r;
  802b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b86:	eb 75                	jmp    802bfd <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8c:	8b 40 08             	mov    0x8(%rax),%eax
  802b8f:	83 e0 03             	and    $0x3,%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	75 3a                	jne    802bd0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b96:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b9d:	00 00 00 
  802ba0:	48 8b 00             	mov    (%rax),%rax
  802ba3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ba9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bac:	89 c6                	mov    %eax,%esi
  802bae:	48 bf 7b 50 80 00 00 	movabs $0x80507b,%rdi
  802bb5:	00 00 00 
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbd:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802bc4:	00 00 00 
  802bc7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bce:	eb 2d                	jmp    802bfd <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802bd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bd8:	48 85 c0             	test   %rax,%rax
  802bdb:	75 07                	jne    802be4 <write+0xb9>
		return -E_NOT_SUPP;
  802bdd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be2:	eb 19                	jmp    802bfd <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bec:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bf0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bf4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bf8:	48 89 cf             	mov    %rcx,%rdi
  802bfb:	ff d0                	callq  *%rax
}
  802bfd:	c9                   	leaveq 
  802bfe:	c3                   	retq   

0000000000802bff <seek>:

int
seek(int fdnum, off_t offset)
{
  802bff:	55                   	push   %rbp
  802c00:	48 89 e5             	mov    %rsp,%rbp
  802c03:	48 83 ec 18          	sub    $0x18,%rsp
  802c07:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c0a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c0d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c14:	48 89 d6             	mov    %rdx,%rsi
  802c17:	89 c7                	mov    %eax,%edi
  802c19:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
  802c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2c:	79 05                	jns    802c33 <seek+0x34>
		return r;
  802c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c31:	eb 0f                	jmp    802c42 <seek+0x43>
	fd->fd_offset = offset;
  802c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c37:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c42:	c9                   	leaveq 
  802c43:	c3                   	retq   

0000000000802c44 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c44:	55                   	push   %rbp
  802c45:	48 89 e5             	mov    %rsp,%rbp
  802c48:	48 83 ec 30          	sub    $0x30,%rsp
  802c4c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c56:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c59:	48 89 d6             	mov    %rdx,%rsi
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c71:	78 24                	js     802c97 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c77:	8b 00                	mov    (%rax),%eax
  802c79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7d:	48 89 d6             	mov    %rdx,%rsi
  802c80:	89 c7                	mov    %eax,%edi
  802c82:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802c89:	00 00 00 
  802c8c:	ff d0                	callq  *%rax
  802c8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c95:	79 05                	jns    802c9c <ftruncate+0x58>
		return r;
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9a:	eb 72                	jmp    802d0e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca0:	8b 40 08             	mov    0x8(%rax),%eax
  802ca3:	83 e0 03             	and    $0x3,%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	75 3a                	jne    802ce4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802caa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802cb1:	00 00 00 
  802cb4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cb7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cbd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cc0:	89 c6                	mov    %eax,%esi
  802cc2:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  802cc9:	00 00 00 
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd1:	48 b9 12 06 80 00 00 	movabs $0x800612,%rcx
  802cd8:	00 00 00 
  802cdb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ce2:	eb 2a                	jmp    802d0e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cec:	48 85 c0             	test   %rax,%rax
  802cef:	75 07                	jne    802cf8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cf1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf6:	eb 16                	jmp    802d0e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfc:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d04:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d07:	89 ce                	mov    %ecx,%esi
  802d09:	48 89 d7             	mov    %rdx,%rdi
  802d0c:	ff d0                	callq  *%rax
}
  802d0e:	c9                   	leaveq 
  802d0f:	c3                   	retq   

0000000000802d10 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d10:	55                   	push   %rbp
  802d11:	48 89 e5             	mov    %rsp,%rbp
  802d14:	48 83 ec 30          	sub    $0x30,%rsp
  802d18:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d1f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d26:	48 89 d6             	mov    %rdx,%rsi
  802d29:	89 c7                	mov    %eax,%edi
  802d2b:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax
  802d37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3e:	78 24                	js     802d64 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d44:	8b 00                	mov    (%rax),%eax
  802d46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d4a:	48 89 d6             	mov    %rdx,%rsi
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	79 05                	jns    802d69 <fstat+0x59>
		return r;
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	eb 5e                	jmp    802dc7 <fstat+0xb7>
	if (!dev->dev_stat)
  802d69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d71:	48 85 c0             	test   %rax,%rax
  802d74:	75 07                	jne    802d7d <fstat+0x6d>
		return -E_NOT_SUPP;
  802d76:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d7b:	eb 4a                	jmp    802dc7 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d81:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d88:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d8f:	00 00 00 
	stat->st_isdir = 0;
  802d92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d96:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d9d:	00 00 00 
	stat->st_dev = dev;
  802da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802db7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dbb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dbf:	48 89 ce             	mov    %rcx,%rsi
  802dc2:	48 89 d7             	mov    %rdx,%rdi
  802dc5:	ff d0                	callq  *%rax
}
  802dc7:	c9                   	leaveq 
  802dc8:	c3                   	retq   

0000000000802dc9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dc9:	55                   	push   %rbp
  802dca:	48 89 e5             	mov    %rsp,%rbp
  802dcd:	48 83 ec 20          	sub    $0x20,%rsp
  802dd1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddd:	be 00 00 00 00       	mov    $0x0,%esi
  802de2:	48 89 c7             	mov    %rax,%rdi
  802de5:	48 b8 b7 2e 80 00 00 	movabs $0x802eb7,%rax
  802dec:	00 00 00 
  802def:	ff d0                	callq  *%rax
  802df1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df8:	79 05                	jns    802dff <stat+0x36>
		return fd;
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	eb 2f                	jmp    802e2e <stat+0x65>
	r = fstat(fd, stat);
  802dff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e06:	48 89 d6             	mov    %rdx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1d:	89 c7                	mov    %eax,%edi
  802e1f:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  802e26:	00 00 00 
  802e29:	ff d0                	callq  *%rax
	return r;
  802e2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e2e:	c9                   	leaveq 
  802e2f:	c3                   	retq   

0000000000802e30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	48 83 ec 10          	sub    $0x10,%rsp
  802e38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e46:	00 00 00 
  802e49:	8b 00                	mov    (%rax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	75 1d                	jne    802e6c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e4f:	bf 01 00 00 00       	mov    $0x1,%edi
  802e54:	48 b8 fd 47 80 00 00 	movabs $0x8047fd,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e67:	00 00 00 
  802e6a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e6c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e73:	00 00 00 
  802e76:	8b 00                	mov    (%rax),%eax
  802e78:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e7b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e80:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e87:	00 00 00 
  802e8a:	89 c7                	mov    %eax,%edi
  802e8c:	48 b8 9b 47 80 00 00 	movabs $0x80479b,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea1:	48 89 c6             	mov    %rax,%rsi
  802ea4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea9:	48 b8 95 46 80 00 00 	movabs $0x804695,%rax
  802eb0:	00 00 00 
  802eb3:	ff d0                	callq  *%rax
}
  802eb5:	c9                   	leaveq 
  802eb6:	c3                   	retq   

0000000000802eb7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802eb7:	55                   	push   %rbp
  802eb8:	48 89 e5             	mov    %rsp,%rbp
  802ebb:	48 83 ec 30          	sub    $0x30,%rsp
  802ebf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ec3:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ec6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802ecd:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802edb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ee0:	75 08                	jne    802eea <open+0x33>
	{
		return r;
  802ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee5:	e9 f2 00 00 00       	jmpq   802fdc <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eee:	48 89 c7             	mov    %rax,%rdi
  802ef1:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f00:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f07:	7e 0a                	jle    802f13 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f09:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f0e:	e9 c9 00 00 00       	jmpq   802fdc <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f13:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f1a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f1b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f1f:	48 89 c7             	mov    %rax,%rdi
  802f22:	48 b8 17 25 80 00 00 	movabs $0x802517,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f35:	78 09                	js     802f40 <open+0x89>
  802f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3b:	48 85 c0             	test   %rax,%rax
  802f3e:	75 08                	jne    802f48 <open+0x91>
		{
			return r;
  802f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f43:	e9 94 00 00 00       	jmpq   802fdc <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4c:	ba 00 04 00 00       	mov    $0x400,%edx
  802f51:	48 89 c6             	mov    %rax,%rsi
  802f54:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f5b:	00 00 00 
  802f5e:	48 b8 59 12 80 00 00 	movabs $0x801259,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f6a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f71:	00 00 00 
  802f74:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f77:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f81:	48 89 c6             	mov    %rax,%rsi
  802f84:	bf 01 00 00 00       	mov    $0x1,%edi
  802f89:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
  802f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9c:	79 2b                	jns    802fc9 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa2:	be 00 00 00 00       	mov    $0x0,%esi
  802fa7:	48 89 c7             	mov    %rax,%rdi
  802faa:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
  802fb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802fb9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fbd:	79 05                	jns    802fc4 <open+0x10d>
			{
				return d;
  802fbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc2:	eb 18                	jmp    802fdc <open+0x125>
			}
			return r;
  802fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc7:	eb 13                	jmp    802fdc <open+0x125>
		}	
		return fd2num(fd_store);
  802fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fcd:	48 89 c7             	mov    %rax,%rdi
  802fd0:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	48 83 ec 10          	sub    $0x10,%rsp
  802fe6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fee:	8b 50 0c             	mov    0xc(%rax),%edx
  802ff1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ff8:	00 00 00 
  802ffb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ffd:	be 00 00 00 00       	mov    $0x0,%esi
  803002:	bf 06 00 00 00       	mov    $0x6,%edi
  803007:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 30          	sub    $0x30,%rsp
  80301d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803025:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803030:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803035:	74 07                	je     80303e <devfile_read+0x29>
  803037:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80303c:	75 07                	jne    803045 <devfile_read+0x30>
		return -E_INVAL;
  80303e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803043:	eb 77                	jmp    8030bc <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803049:	8b 50 0c             	mov    0xc(%rax),%edx
  80304c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803053:	00 00 00 
  803056:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803058:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80305f:	00 00 00 
  803062:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803066:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80306a:	be 00 00 00 00       	mov    $0x0,%esi
  80306f:	bf 03 00 00 00       	mov    $0x3,%edi
  803074:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
  803080:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803083:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803087:	7f 05                	jg     80308e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308c:	eb 2e                	jmp    8030bc <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	48 63 d0             	movslq %eax,%rdx
  803094:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803098:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80309f:	00 00 00 
  8030a2:	48 89 c7             	mov    %rax,%rdi
  8030a5:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8030b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8030b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030bc:	c9                   	leaveq 
  8030bd:	c3                   	retq   

00000000008030be <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030be:	55                   	push   %rbp
  8030bf:	48 89 e5             	mov    %rsp,%rbp
  8030c2:	48 83 ec 30          	sub    $0x30,%rsp
  8030c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8030d2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030de:	74 07                	je     8030e7 <devfile_write+0x29>
  8030e0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030e5:	75 08                	jne    8030ef <devfile_write+0x31>
		return r;
  8030e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ea:	e9 9a 00 00 00       	jmpq   803189 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030fd:	00 00 00 
  803100:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803102:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803109:	00 
  80310a:	76 08                	jbe    803114 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80310c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803113:	00 
	}
	fsipcbuf.write.req_n = n;
  803114:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80311b:	00 00 00 
  80311e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803122:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803126:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80312a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80312e:	48 89 c6             	mov    %rax,%rsi
  803131:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803138:	00 00 00 
  80313b:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803147:	be 00 00 00 00       	mov    $0x0,%esi
  80314c:	bf 04 00 00 00       	mov    $0x4,%edi
  803151:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  803158:	00 00 00 
  80315b:	ff d0                	callq  *%rax
  80315d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803164:	7f 20                	jg     803186 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803166:	48 bf be 50 80 00 00 	movabs $0x8050be,%rdi
  80316d:	00 00 00 
  803170:	b8 00 00 00 00       	mov    $0x0,%eax
  803175:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  80317c:	00 00 00 
  80317f:	ff d2                	callq  *%rdx
		return r;
  803181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803184:	eb 03                	jmp    803189 <devfile_write+0xcb>
	}
	return r;
  803186:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803189:	c9                   	leaveq 
  80318a:	c3                   	retq   

000000000080318b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80318b:	55                   	push   %rbp
  80318c:	48 89 e5             	mov    %rsp,%rbp
  80318f:	48 83 ec 20          	sub    $0x20,%rsp
  803193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803197:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80319b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319f:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a9:	00 00 00 
  8031ac:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031ae:	be 00 00 00 00       	mov    $0x0,%esi
  8031b3:	bf 05 00 00 00       	mov    $0x5,%edi
  8031b8:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
  8031c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cb:	79 05                	jns    8031d2 <devfile_stat+0x47>
		return r;
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	eb 56                	jmp    803228 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031dd:	00 00 00 
  8031e0:	48 89 c7             	mov    %rax,%rdi
  8031e3:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f6:	00 00 00 
  8031f9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803203:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803209:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803210:	00 00 00 
  803213:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803219:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803228:	c9                   	leaveq 
  803229:	c3                   	retq   

000000000080322a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80322a:	55                   	push   %rbp
  80322b:	48 89 e5             	mov    %rsp,%rbp
  80322e:	48 83 ec 10          	sub    $0x10,%rsp
  803232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803236:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323d:	8b 50 0c             	mov    0xc(%rax),%edx
  803240:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803247:	00 00 00 
  80324a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80324c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803253:	00 00 00 
  803256:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803259:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80325c:	be 00 00 00 00       	mov    $0x0,%esi
  803261:	bf 02 00 00 00       	mov    $0x2,%edi
  803266:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <remove>:

// Delete a file
int
remove(const char *path)
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	48 83 ec 10          	sub    $0x10,%rsp
  80327c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803284:	48 89 c7             	mov    %rax,%rdi
  803287:	48 b8 5b 11 80 00 00 	movabs $0x80115b,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803298:	7e 07                	jle    8032a1 <remove+0x2d>
		return -E_BAD_PATH;
  80329a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80329f:	eb 33                	jmp    8032d4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a5:	48 89 c6             	mov    %rax,%rsi
  8032a8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032af:	00 00 00 
  8032b2:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032be:	be 00 00 00 00       	mov    $0x0,%esi
  8032c3:	bf 07 00 00 00       	mov    $0x7,%edi
  8032c8:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
}
  8032d4:	c9                   	leaveq 
  8032d5:	c3                   	retq   

00000000008032d6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032d6:	55                   	push   %rbp
  8032d7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032da:	be 00 00 00 00       	mov    $0x0,%esi
  8032df:	bf 08 00 00 00       	mov    $0x8,%edi
  8032e4:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8032eb:	00 00 00 
  8032ee:	ff d0                	callq  *%rax
}
  8032f0:	5d                   	pop    %rbp
  8032f1:	c3                   	retq   

00000000008032f2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032f2:	55                   	push   %rbp
  8032f3:	48 89 e5             	mov    %rsp,%rbp
  8032f6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032fd:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803304:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80330b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803312:	be 00 00 00 00       	mov    $0x0,%esi
  803317:	48 89 c7             	mov    %rax,%rdi
  80331a:	48 b8 b7 2e 80 00 00 	movabs $0x802eb7,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332d:	79 28                	jns    803357 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80332f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803332:	89 c6                	mov    %eax,%esi
  803334:	48 bf da 50 80 00 00 	movabs $0x8050da,%rdi
  80333b:	00 00 00 
  80333e:	b8 00 00 00 00       	mov    $0x0,%eax
  803343:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  80334a:	00 00 00 
  80334d:	ff d2                	callq  *%rdx
		return fd_src;
  80334f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803352:	e9 74 01 00 00       	jmpq   8034cb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803357:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80335e:	be 01 01 00 00       	mov    $0x101,%esi
  803363:	48 89 c7             	mov    %rax,%rdi
  803366:	48 b8 b7 2e 80 00 00 	movabs $0x802eb7,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
  803372:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803375:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803379:	79 39                	jns    8033b4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80337b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337e:	89 c6                	mov    %eax,%esi
  803380:	48 bf f0 50 80 00 00 	movabs $0x8050f0,%rdi
  803387:	00 00 00 
  80338a:	b8 00 00 00 00       	mov    $0x0,%eax
  80338f:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  803396:	00 00 00 
  803399:	ff d2                	callq  *%rdx
		close(fd_src);
  80339b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339e:	89 c7                	mov    %eax,%edi
  8033a0:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
		return fd_dest;
  8033ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033af:	e9 17 01 00 00       	jmpq   8034cb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033b4:	eb 74                	jmp    80342a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8033b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033b9:	48 63 d0             	movslq %eax,%rdx
  8033bc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c6:	48 89 ce             	mov    %rcx,%rsi
  8033c9:	89 c7                	mov    %eax,%edi
  8033cb:	48 b8 2b 2b 80 00 00 	movabs $0x802b2b,%rax
  8033d2:	00 00 00 
  8033d5:	ff d0                	callq  *%rax
  8033d7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033da:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033de:	79 4a                	jns    80342a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033e3:	89 c6                	mov    %eax,%esi
  8033e5:	48 bf 0a 51 80 00 00 	movabs $0x80510a,%rdi
  8033ec:	00 00 00 
  8033ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f4:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  8033fb:	00 00 00 
  8033fe:	ff d2                	callq  *%rdx
			close(fd_src);
  803400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803403:	89 c7                	mov    %eax,%edi
  803405:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
			close(fd_dest);
  803411:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803414:	89 c7                	mov    %eax,%edi
  803416:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
			return write_size;
  803422:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803425:	e9 a1 00 00 00       	jmpq   8034cb <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80342a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	ba 00 02 00 00       	mov    $0x200,%edx
  803439:	48 89 ce             	mov    %rcx,%rsi
  80343c:	89 c7                	mov    %eax,%edi
  80343e:	48 b8 e1 29 80 00 00 	movabs $0x8029e1,%rax
  803445:	00 00 00 
  803448:	ff d0                	callq  *%rax
  80344a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80344d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803451:	0f 8f 5f ff ff ff    	jg     8033b6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803457:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80345b:	79 47                	jns    8034a4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80345d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803460:	89 c6                	mov    %eax,%esi
  803462:	48 bf 1d 51 80 00 00 	movabs $0x80511d,%rdi
  803469:	00 00 00 
  80346c:	b8 00 00 00 00       	mov    $0x0,%eax
  803471:	48 ba 12 06 80 00 00 	movabs $0x800612,%rdx
  803478:	00 00 00 
  80347b:	ff d2                	callq  *%rdx
		close(fd_src);
  80347d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803480:	89 c7                	mov    %eax,%edi
  803482:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
		close(fd_dest);
  80348e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803491:	89 c7                	mov    %eax,%edi
  803493:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
		return read_size;
  80349f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a2:	eb 27                	jmp    8034cb <copy+0x1d9>
	}
	close(fd_src);
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	89 c7                	mov    %eax,%edi
  8034a9:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
	close(fd_dest);
  8034b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b8:	89 c7                	mov    %eax,%edi
  8034ba:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	callq  *%rax
	return 0;
  8034c6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034cb:	c9                   	leaveq 
  8034cc:	c3                   	retq   

00000000008034cd <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 20          	sub    $0x20,%rsp
  8034d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034df:	48 89 d6             	mov    %rdx,%rsi
  8034e2:	89 c7                	mov    %eax,%edi
  8034e4:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
  8034f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f7:	79 05                	jns    8034fe <fd2sockid+0x31>
		return r;
  8034f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fc:	eb 24                	jmp    803522 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803502:	8b 10                	mov    (%rax),%edx
  803504:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80350b:	00 00 00 
  80350e:	8b 00                	mov    (%rax),%eax
  803510:	39 c2                	cmp    %eax,%edx
  803512:	74 07                	je     80351b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803514:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803519:	eb 07                	jmp    803522 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80351b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803522:	c9                   	leaveq 
  803523:	c3                   	retq   

0000000000803524 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803524:	55                   	push   %rbp
  803525:	48 89 e5             	mov    %rsp,%rbp
  803528:	48 83 ec 20          	sub    $0x20,%rsp
  80352c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80352f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 17 25 80 00 00 	movabs $0x802517,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803545:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803549:	78 26                	js     803571 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80354b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354f:	ba 07 04 00 00       	mov    $0x407,%edx
  803554:	48 89 c6             	mov    %rax,%rsi
  803557:	bf 00 00 00 00       	mov    $0x0,%edi
  80355c:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80356b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356f:	79 16                	jns    803587 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803571:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803574:	89 c7                	mov    %eax,%edi
  803576:	48 b8 31 3a 80 00 00 	movabs $0x803a31,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
		return r;
  803582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803585:	eb 3a                	jmp    8035c1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358b:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803592:	00 00 00 
  803595:	8b 12                	mov    (%rdx),%edx
  803597:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035ab:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b2:	48 89 c7             	mov    %rax,%rdi
  8035b5:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  8035bc:	00 00 00 
  8035bf:	ff d0                	callq  *%rax
}
  8035c1:	c9                   	leaveq 
  8035c2:	c3                   	retq   

00000000008035c3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035c3:	55                   	push   %rbp
  8035c4:	48 89 e5             	mov    %rsp,%rbp
  8035c7:	48 83 ec 30          	sub    $0x30,%rsp
  8035cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d9:	89 c7                	mov    %eax,%edi
  8035db:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
  8035e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ee:	79 05                	jns    8035f5 <accept+0x32>
		return r;
  8035f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f3:	eb 3b                	jmp    803630 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035f5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035f9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803600:	48 89 ce             	mov    %rcx,%rsi
  803603:	89 c7                	mov    %eax,%edi
  803605:	48 b8 0e 39 80 00 00 	movabs $0x80390e,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
  803611:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803614:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803618:	79 05                	jns    80361f <accept+0x5c>
		return r;
  80361a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361d:	eb 11                	jmp    803630 <accept+0x6d>
	return alloc_sockfd(r);
  80361f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803622:	89 c7                	mov    %eax,%edi
  803624:	48 b8 24 35 80 00 00 	movabs $0x803524,%rax
  80362b:	00 00 00 
  80362e:	ff d0                	callq  *%rax
}
  803630:	c9                   	leaveq 
  803631:	c3                   	retq   

0000000000803632 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803632:	55                   	push   %rbp
  803633:	48 89 e5             	mov    %rsp,%rbp
  803636:	48 83 ec 20          	sub    $0x20,%rsp
  80363a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80363d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803641:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803644:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803647:	89 c7                	mov    %eax,%edi
  803649:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
  803655:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803658:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365c:	79 05                	jns    803663 <bind+0x31>
		return r;
  80365e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803661:	eb 1b                	jmp    80367e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803663:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803666:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80366a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366d:	48 89 ce             	mov    %rcx,%rsi
  803670:	89 c7                	mov    %eax,%edi
  803672:	48 b8 8d 39 80 00 00 	movabs $0x80398d,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
}
  80367e:	c9                   	leaveq 
  80367f:	c3                   	retq   

0000000000803680 <shutdown>:

int
shutdown(int s, int how)
{
  803680:	55                   	push   %rbp
  803681:	48 89 e5             	mov    %rsp,%rbp
  803684:	48 83 ec 20          	sub    $0x20,%rsp
  803688:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80368e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803691:	89 c7                	mov    %eax,%edi
  803693:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
  80369f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a6:	79 05                	jns    8036ad <shutdown+0x2d>
		return r;
  8036a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ab:	eb 16                	jmp    8036c3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036ad:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	89 d6                	mov    %edx,%esi
  8036b5:	89 c7                	mov    %eax,%edi
  8036b7:	48 b8 f1 39 80 00 00 	movabs $0x8039f1,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
}
  8036c3:	c9                   	leaveq 
  8036c4:	c3                   	retq   

00000000008036c5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8036c5:	55                   	push   %rbp
  8036c6:	48 89 e5             	mov    %rsp,%rbp
  8036c9:	48 83 ec 10          	sub    $0x10,%rsp
  8036cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d5:	48 89 c7             	mov    %rax,%rdi
  8036d8:	48 b8 7f 48 80 00 00 	movabs $0x80487f,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	83 f8 01             	cmp    $0x1,%eax
  8036e7:	75 17                	jne    803700 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ed:	8b 40 0c             	mov    0xc(%rax),%eax
  8036f0:	89 c7                	mov    %eax,%edi
  8036f2:	48 b8 31 3a 80 00 00 	movabs $0x803a31,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
  8036fe:	eb 05                	jmp    803705 <devsock_close+0x40>
	else
		return 0;
  803700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803705:	c9                   	leaveq 
  803706:	c3                   	retq   

0000000000803707 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803707:	55                   	push   %rbp
  803708:	48 89 e5             	mov    %rsp,%rbp
  80370b:	48 83 ec 20          	sub    $0x20,%rsp
  80370f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803712:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803716:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803719:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371c:	89 c7                	mov    %eax,%edi
  80371e:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
  80372a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803731:	79 05                	jns    803738 <connect+0x31>
		return r;
  803733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803736:	eb 1b                	jmp    803753 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803738:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80373b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803742:	48 89 ce             	mov    %rcx,%rsi
  803745:	89 c7                	mov    %eax,%edi
  803747:	48 b8 5e 3a 80 00 00 	movabs $0x803a5e,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
}
  803753:	c9                   	leaveq 
  803754:	c3                   	retq   

0000000000803755 <listen>:

int
listen(int s, int backlog)
{
  803755:	55                   	push   %rbp
  803756:	48 89 e5             	mov    %rsp,%rbp
  803759:	48 83 ec 20          	sub    $0x20,%rsp
  80375d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803760:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803763:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803766:	89 c7                	mov    %eax,%edi
  803768:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
  803774:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803777:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377b:	79 05                	jns    803782 <listen+0x2d>
		return r;
  80377d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803780:	eb 16                	jmp    803798 <listen+0x43>
	return nsipc_listen(r, backlog);
  803782:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803788:	89 d6                	mov    %edx,%esi
  80378a:	89 c7                	mov    %eax,%edi
  80378c:	48 b8 c2 3a 80 00 00 	movabs $0x803ac2,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
}
  803798:	c9                   	leaveq 
  803799:	c3                   	retq   

000000000080379a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80379a:	55                   	push   %rbp
  80379b:	48 89 e5             	mov    %rsp,%rbp
  80379e:	48 83 ec 20          	sub    $0x20,%rsp
  8037a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b2:	89 c2                	mov    %eax,%edx
  8037b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b8:	8b 40 0c             	mov    0xc(%rax),%eax
  8037bb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037c4:	89 c7                	mov    %eax,%edi
  8037c6:	48 b8 02 3b 80 00 00 	movabs $0x803b02,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
}
  8037d2:	c9                   	leaveq 
  8037d3:	c3                   	retq   

00000000008037d4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037d4:	55                   	push   %rbp
  8037d5:	48 89 e5             	mov    %rsp,%rbp
  8037d8:	48 83 ec 20          	sub    $0x20,%rsp
  8037dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ec:	89 c2                	mov    %eax,%edx
  8037ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f2:	8b 40 0c             	mov    0xc(%rax),%eax
  8037f5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037fe:	89 c7                	mov    %eax,%edi
  803800:	48 b8 ce 3b 80 00 00 	movabs $0x803bce,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
}
  80380c:	c9                   	leaveq 
  80380d:	c3                   	retq   

000000000080380e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80380e:	55                   	push   %rbp
  80380f:	48 89 e5             	mov    %rsp,%rbp
  803812:	48 83 ec 10          	sub    $0x10,%rsp
  803816:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80381a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80381e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803822:	48 be 38 51 80 00 00 	movabs $0x805138,%rsi
  803829:	00 00 00 
  80382c:	48 89 c7             	mov    %rax,%rdi
  80382f:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
	return 0;
  80383b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803840:	c9                   	leaveq 
  803841:	c3                   	retq   

0000000000803842 <socket>:

int
socket(int domain, int type, int protocol)
{
  803842:	55                   	push   %rbp
  803843:	48 89 e5             	mov    %rsp,%rbp
  803846:	48 83 ec 20          	sub    $0x20,%rsp
  80384a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803850:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803853:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803856:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803859:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385c:	89 ce                	mov    %ecx,%esi
  80385e:	89 c7                	mov    %eax,%edi
  803860:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803873:	79 05                	jns    80387a <socket+0x38>
		return r;
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	eb 11                	jmp    80388b <socket+0x49>
	return alloc_sockfd(r);
  80387a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387d:	89 c7                	mov    %eax,%edi
  80387f:	48 b8 24 35 80 00 00 	movabs $0x803524,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
}
  80388b:	c9                   	leaveq 
  80388c:	c3                   	retq   

000000000080388d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80388d:	55                   	push   %rbp
  80388e:	48 89 e5             	mov    %rsp,%rbp
  803891:	48 83 ec 10          	sub    $0x10,%rsp
  803895:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803898:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80389f:	00 00 00 
  8038a2:	8b 00                	mov    (%rax),%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	75 1d                	jne    8038c5 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8038ad:	48 b8 fd 47 80 00 00 	movabs $0x8047fd,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
  8038b9:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8038c0:	00 00 00 
  8038c3:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8038c5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038cc:	00 00 00 
  8038cf:	8b 00                	mov    (%rax),%eax
  8038d1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038d4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038d9:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8038e0:	00 00 00 
  8038e3:	89 c7                	mov    %eax,%edi
  8038e5:	48 b8 9b 47 80 00 00 	movabs $0x80479b,%rax
  8038ec:	00 00 00 
  8038ef:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8038f6:	be 00 00 00 00       	mov    $0x0,%esi
  8038fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803900:	48 b8 95 46 80 00 00 	movabs $0x804695,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
}
  80390c:	c9                   	leaveq 
  80390d:	c3                   	retq   

000000000080390e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80390e:	55                   	push   %rbp
  80390f:	48 89 e5             	mov    %rsp,%rbp
  803912:	48 83 ec 30          	sub    $0x30,%rsp
  803916:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803919:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80391d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803921:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803928:	00 00 00 
  80392b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80392e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803930:	bf 01 00 00 00       	mov    $0x1,%edi
  803935:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
  803941:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803948:	78 3e                	js     803988 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80394a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803951:	00 00 00 
  803954:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	8b 40 10             	mov    0x10(%rax),%eax
  80395f:	89 c2                	mov    %eax,%edx
  803961:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803969:	48 89 ce             	mov    %rcx,%rsi
  80396c:	48 89 c7             	mov    %rax,%rdi
  80396f:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80397b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397f:	8b 50 10             	mov    0x10(%rax),%edx
  803982:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803986:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803988:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80398b:	c9                   	leaveq 
  80398c:	c3                   	retq   

000000000080398d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80398d:	55                   	push   %rbp
  80398e:	48 89 e5             	mov    %rsp,%rbp
  803991:	48 83 ec 10          	sub    $0x10,%rsp
  803995:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803998:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80399c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80399f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a6:	00 00 00 
  8039a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ac:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039ae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b5:	48 89 c6             	mov    %rax,%rsi
  8039b8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039bf:	00 00 00 
  8039c2:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8039c9:	00 00 00 
  8039cc:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039d5:	00 00 00 
  8039d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039db:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039de:	bf 02 00 00 00       	mov    $0x2,%edi
  8039e3:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
}
  8039ef:	c9                   	leaveq 
  8039f0:	c3                   	retq   

00000000008039f1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039f1:	55                   	push   %rbp
  8039f2:	48 89 e5             	mov    %rsp,%rbp
  8039f5:	48 83 ec 10          	sub    $0x10,%rsp
  8039f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039ff:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a06:	00 00 00 
  803a09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a0e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a15:	00 00 00 
  803a18:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a1b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a1e:	bf 03 00 00 00       	mov    $0x3,%edi
  803a23:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
}
  803a2f:	c9                   	leaveq 
  803a30:	c3                   	retq   

0000000000803a31 <nsipc_close>:

int
nsipc_close(int s)
{
  803a31:	55                   	push   %rbp
  803a32:	48 89 e5             	mov    %rsp,%rbp
  803a35:	48 83 ec 10          	sub    $0x10,%rsp
  803a39:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a3c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a43:	00 00 00 
  803a46:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a49:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a4b:	bf 04 00 00 00       	mov    $0x4,%edi
  803a50:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803a57:	00 00 00 
  803a5a:	ff d0                	callq  *%rax
}
  803a5c:	c9                   	leaveq 
  803a5d:	c3                   	retq   

0000000000803a5e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a5e:	55                   	push   %rbp
  803a5f:	48 89 e5             	mov    %rsp,%rbp
  803a62:	48 83 ec 10          	sub    $0x10,%rsp
  803a66:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a6d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a70:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a77:	00 00 00 
  803a7a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a86:	48 89 c6             	mov    %rax,%rsi
  803a89:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a90:	00 00 00 
  803a93:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa6:	00 00 00 
  803aa9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aac:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803aaf:	bf 05 00 00 00       	mov    $0x5,%edi
  803ab4:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
}
  803ac0:	c9                   	leaveq 
  803ac1:	c3                   	retq   

0000000000803ac2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ac2:	55                   	push   %rbp
  803ac3:	48 89 e5             	mov    %rsp,%rbp
  803ac6:	48 83 ec 10          	sub    $0x10,%rsp
  803aca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803acd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ad0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad7:	00 00 00 
  803ada:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803add:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803adf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae6:	00 00 00 
  803ae9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aec:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803aef:	bf 06 00 00 00       	mov    $0x6,%edi
  803af4:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
}
  803b00:	c9                   	leaveq 
  803b01:	c3                   	retq   

0000000000803b02 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b02:	55                   	push   %rbp
  803b03:	48 89 e5             	mov    %rsp,%rbp
  803b06:	48 83 ec 30          	sub    $0x30,%rsp
  803b0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b11:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b14:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b17:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b1e:	00 00 00 
  803b21:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b24:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b26:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2d:	00 00 00 
  803b30:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b33:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b36:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b3d:	00 00 00 
  803b40:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b43:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b46:	bf 07 00 00 00       	mov    $0x7,%edi
  803b4b:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
  803b57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5e:	78 69                	js     803bc9 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b60:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b67:	7f 08                	jg     803b71 <nsipc_recv+0x6f>
  803b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b6f:	7e 35                	jle    803ba6 <nsipc_recv+0xa4>
  803b71:	48 b9 3f 51 80 00 00 	movabs $0x80513f,%rcx
  803b78:	00 00 00 
  803b7b:	48 ba 54 51 80 00 00 	movabs $0x805154,%rdx
  803b82:	00 00 00 
  803b85:	be 61 00 00 00       	mov    $0x61,%esi
  803b8a:	48 bf 69 51 80 00 00 	movabs $0x805169,%rdi
  803b91:	00 00 00 
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
  803b99:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  803ba0:	00 00 00 
  803ba3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba9:	48 63 d0             	movslq %eax,%rdx
  803bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb0:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803bb7:	00 00 00 
  803bba:	48 89 c7             	mov    %rax,%rdi
  803bbd:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
	}

	return r;
  803bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bcc:	c9                   	leaveq 
  803bcd:	c3                   	retq   

0000000000803bce <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bce:	55                   	push   %rbp
  803bcf:	48 89 e5             	mov    %rsp,%rbp
  803bd2:	48 83 ec 20          	sub    $0x20,%rsp
  803bd6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bdd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803be0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803be3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bea:	00 00 00 
  803bed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bf0:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bf2:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bf9:	7e 35                	jle    803c30 <nsipc_send+0x62>
  803bfb:	48 b9 75 51 80 00 00 	movabs $0x805175,%rcx
  803c02:	00 00 00 
  803c05:	48 ba 54 51 80 00 00 	movabs $0x805154,%rdx
  803c0c:	00 00 00 
  803c0f:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c14:	48 bf 69 51 80 00 00 	movabs $0x805169,%rdi
  803c1b:	00 00 00 
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c23:	49 b8 d9 03 80 00 00 	movabs $0x8003d9,%r8
  803c2a:	00 00 00 
  803c2d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c33:	48 63 d0             	movslq %eax,%rdx
  803c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3a:	48 89 c6             	mov    %rax,%rsi
  803c3d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c44:	00 00 00 
  803c47:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5a:	00 00 00 
  803c5d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c60:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c63:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6a:	00 00 00 
  803c6d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c70:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c73:	bf 08 00 00 00       	mov    $0x8,%edi
  803c78:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
}
  803c84:	c9                   	leaveq 
  803c85:	c3                   	retq   

0000000000803c86 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c86:	55                   	push   %rbp
  803c87:	48 89 e5             	mov    %rsp,%rbp
  803c8a:	48 83 ec 10          	sub    $0x10,%rsp
  803c8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c91:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c94:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c97:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c9e:	00 00 00 
  803ca1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ca4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ca6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cad:	00 00 00 
  803cb0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803cb6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cbd:	00 00 00 
  803cc0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803cc3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803cc6:	bf 09 00 00 00       	mov    $0x9,%edi
  803ccb:	48 b8 8d 38 80 00 00 	movabs $0x80388d,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
}
  803cd7:	c9                   	leaveq 
  803cd8:	c3                   	retq   

0000000000803cd9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cd9:	55                   	push   %rbp
  803cda:	48 89 e5             	mov    %rsp,%rbp
  803cdd:	53                   	push   %rbx
  803cde:	48 83 ec 38          	sub    $0x38,%rsp
  803ce2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ce6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cea:	48 89 c7             	mov    %rax,%rdi
  803ced:	48 b8 17 25 80 00 00 	movabs $0x802517,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
  803cf9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d00:	0f 88 bf 01 00 00    	js     803ec5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0a:	ba 07 04 00 00       	mov    $0x407,%edx
  803d0f:	48 89 c6             	mov    %rax,%rsi
  803d12:	bf 00 00 00 00       	mov    $0x0,%edi
  803d17:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803d1e:	00 00 00 
  803d21:	ff d0                	callq  *%rax
  803d23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d26:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d2a:	0f 88 95 01 00 00    	js     803ec5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d30:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d34:	48 89 c7             	mov    %rax,%rdi
  803d37:	48 b8 17 25 80 00 00 	movabs $0x802517,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
  803d43:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d46:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d4a:	0f 88 5d 01 00 00    	js     803ead <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d54:	ba 07 04 00 00       	mov    $0x407,%edx
  803d59:	48 89 c6             	mov    %rax,%rsi
  803d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d61:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
  803d6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d74:	0f 88 33 01 00 00    	js     803ead <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7e:	48 89 c7             	mov    %rax,%rdi
  803d81:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
  803d8d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d95:	ba 07 04 00 00       	mov    $0x407,%edx
  803d9a:	48 89 c6             	mov    %rax,%rsi
  803d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  803da2:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803da9:	00 00 00 
  803dac:	ff d0                	callq  *%rax
  803dae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db5:	79 05                	jns    803dbc <pipe+0xe3>
		goto err2;
  803db7:	e9 d9 00 00 00       	jmpq   803e95 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc0:	48 89 c7             	mov    %rax,%rdi
  803dc3:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
  803dcf:	48 89 c2             	mov    %rax,%rdx
  803dd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd6:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ddc:	48 89 d1             	mov    %rdx,%rcx
  803ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  803de4:	48 89 c6             	mov    %rax,%rsi
  803de7:	bf 00 00 00 00       	mov    $0x0,%edi
  803dec:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803df3:	00 00 00 
  803df6:	ff d0                	callq  *%rax
  803df8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dff:	79 1b                	jns    803e1c <pipe+0x143>
		goto err3;
  803e01:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e06:	48 89 c6             	mov    %rax,%rsi
  803e09:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0e:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
  803e1a:	eb 79                	jmp    803e95 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e20:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e27:	00 00 00 
  803e2a:	8b 12                	mov    (%rdx),%edx
  803e2c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e44:	00 00 00 
  803e47:	8b 12                	mov    (%rdx),%edx
  803e49:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5a:	48 89 c7             	mov    %rax,%rdi
  803e5d:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
  803e69:	89 c2                	mov    %eax,%edx
  803e6b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e6f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e71:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e75:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e7d:	48 89 c7             	mov    %rax,%rdi
  803e80:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
  803e8c:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e93:	eb 33                	jmp    803ec8 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e95:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e99:	48 89 c6             	mov    %rax,%rsi
  803e9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea1:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb1:	48 89 c6             	mov    %rax,%rsi
  803eb4:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb9:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
err:
	return r;
  803ec5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ec8:	48 83 c4 38          	add    $0x38,%rsp
  803ecc:	5b                   	pop    %rbx
  803ecd:	5d                   	pop    %rbp
  803ece:	c3                   	retq   

0000000000803ecf <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ecf:	55                   	push   %rbp
  803ed0:	48 89 e5             	mov    %rsp,%rbp
  803ed3:	53                   	push   %rbx
  803ed4:	48 83 ec 28          	sub    $0x28,%rsp
  803ed8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803edc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ee0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ee7:	00 00 00 
  803eea:	48 8b 00             	mov    (%rax),%rax
  803eed:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ef3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ef6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803efa:	48 89 c7             	mov    %rax,%rdi
  803efd:	48 b8 7f 48 80 00 00 	movabs $0x80487f,%rax
  803f04:	00 00 00 
  803f07:	ff d0                	callq  *%rax
  803f09:	89 c3                	mov    %eax,%ebx
  803f0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f0f:	48 89 c7             	mov    %rax,%rdi
  803f12:	48 b8 7f 48 80 00 00 	movabs $0x80487f,%rax
  803f19:	00 00 00 
  803f1c:	ff d0                	callq  *%rax
  803f1e:	39 c3                	cmp    %eax,%ebx
  803f20:	0f 94 c0             	sete   %al
  803f23:	0f b6 c0             	movzbl %al,%eax
  803f26:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f29:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f30:	00 00 00 
  803f33:	48 8b 00             	mov    (%rax),%rax
  803f36:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f3c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f42:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f45:	75 05                	jne    803f4c <_pipeisclosed+0x7d>
			return ret;
  803f47:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f4a:	eb 4f                	jmp    803f9b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f4f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f52:	74 42                	je     803f96 <_pipeisclosed+0xc7>
  803f54:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f58:	75 3c                	jne    803f96 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f5a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f61:	00 00 00 
  803f64:	48 8b 00             	mov    (%rax),%rax
  803f67:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f6d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f73:	89 c6                	mov    %eax,%esi
  803f75:	48 bf 86 51 80 00 00 	movabs $0x805186,%rdi
  803f7c:	00 00 00 
  803f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f84:	49 b8 12 06 80 00 00 	movabs $0x800612,%r8
  803f8b:	00 00 00 
  803f8e:	41 ff d0             	callq  *%r8
	}
  803f91:	e9 4a ff ff ff       	jmpq   803ee0 <_pipeisclosed+0x11>
  803f96:	e9 45 ff ff ff       	jmpq   803ee0 <_pipeisclosed+0x11>
}
  803f9b:	48 83 c4 28          	add    $0x28,%rsp
  803f9f:	5b                   	pop    %rbx
  803fa0:	5d                   	pop    %rbp
  803fa1:	c3                   	retq   

0000000000803fa2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fa2:	55                   	push   %rbp
  803fa3:	48 89 e5             	mov    %rsp,%rbp
  803fa6:	48 83 ec 30          	sub    $0x30,%rsp
  803faa:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fb1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fb4:	48 89 d6             	mov    %rdx,%rsi
  803fb7:	89 c7                	mov    %eax,%edi
  803fb9:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  803fc0:	00 00 00 
  803fc3:	ff d0                	callq  *%rax
  803fc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcc:	79 05                	jns    803fd3 <pipeisclosed+0x31>
		return r;
  803fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd1:	eb 31                	jmp    804004 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd7:	48 89 c7             	mov    %rax,%rdi
  803fda:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
  803fe6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ff2:	48 89 d6             	mov    %rdx,%rsi
  803ff5:	48 89 c7             	mov    %rax,%rdi
  803ff8:	48 b8 cf 3e 80 00 00 	movabs $0x803ecf,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
}
  804004:	c9                   	leaveq 
  804005:	c3                   	retq   

0000000000804006 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804006:	55                   	push   %rbp
  804007:	48 89 e5             	mov    %rsp,%rbp
  80400a:	48 83 ec 40          	sub    $0x40,%rsp
  80400e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804012:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804016:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80401a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80401e:	48 89 c7             	mov    %rax,%rdi
  804021:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  804028:	00 00 00 
  80402b:	ff d0                	callq  *%rax
  80402d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804031:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804035:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804039:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804040:	00 
  804041:	e9 92 00 00 00       	jmpq   8040d8 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804046:	eb 41                	jmp    804089 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804048:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80404d:	74 09                	je     804058 <devpipe_read+0x52>
				return i;
  80404f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804053:	e9 92 00 00 00       	jmpq   8040ea <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804058:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804060:	48 89 d6             	mov    %rdx,%rsi
  804063:	48 89 c7             	mov    %rax,%rdi
  804066:	48 b8 cf 3e 80 00 00 	movabs $0x803ecf,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
  804072:	85 c0                	test   %eax,%eax
  804074:	74 07                	je     80407d <devpipe_read+0x77>
				return 0;
  804076:	b8 00 00 00 00       	mov    $0x0,%eax
  80407b:	eb 6d                	jmp    8040ea <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80407d:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  804084:	00 00 00 
  804087:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408d:	8b 10                	mov    (%rax),%edx
  80408f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804093:	8b 40 04             	mov    0x4(%rax),%eax
  804096:	39 c2                	cmp    %eax,%edx
  804098:	74 ae                	je     804048 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80409a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040a2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	8b 00                	mov    (%rax),%eax
  8040ac:	99                   	cltd   
  8040ad:	c1 ea 1b             	shr    $0x1b,%edx
  8040b0:	01 d0                	add    %edx,%eax
  8040b2:	83 e0 1f             	and    $0x1f,%eax
  8040b5:	29 d0                	sub    %edx,%eax
  8040b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040bb:	48 98                	cltq   
  8040bd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040c2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c8:	8b 00                	mov    (%rax),%eax
  8040ca:	8d 50 01             	lea    0x1(%rax),%edx
  8040cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040dc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040e0:	0f 82 60 ff ff ff    	jb     804046 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040ea:	c9                   	leaveq 
  8040eb:	c3                   	retq   

00000000008040ec <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040ec:	55                   	push   %rbp
  8040ed:	48 89 e5             	mov    %rsp,%rbp
  8040f0:	48 83 ec 40          	sub    $0x40,%rsp
  8040f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804100:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804104:	48 89 c7             	mov    %rax,%rdi
  804107:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  80410e:	00 00 00 
  804111:	ff d0                	callq  *%rax
  804113:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804117:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80411f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804126:	00 
  804127:	e9 8e 00 00 00       	jmpq   8041ba <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80412c:	eb 31                	jmp    80415f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80412e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804136:	48 89 d6             	mov    %rdx,%rsi
  804139:	48 89 c7             	mov    %rax,%rdi
  80413c:	48 b8 cf 3e 80 00 00 	movabs $0x803ecf,%rax
  804143:	00 00 00 
  804146:	ff d0                	callq  *%rax
  804148:	85 c0                	test   %eax,%eax
  80414a:	74 07                	je     804153 <devpipe_write+0x67>
				return 0;
  80414c:	b8 00 00 00 00       	mov    $0x0,%eax
  804151:	eb 79                	jmp    8041cc <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804153:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  80415a:	00 00 00 
  80415d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80415f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804163:	8b 40 04             	mov    0x4(%rax),%eax
  804166:	48 63 d0             	movslq %eax,%rdx
  804169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416d:	8b 00                	mov    (%rax),%eax
  80416f:	48 98                	cltq   
  804171:	48 83 c0 20          	add    $0x20,%rax
  804175:	48 39 c2             	cmp    %rax,%rdx
  804178:	73 b4                	jae    80412e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80417a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417e:	8b 40 04             	mov    0x4(%rax),%eax
  804181:	99                   	cltd   
  804182:	c1 ea 1b             	shr    $0x1b,%edx
  804185:	01 d0                	add    %edx,%eax
  804187:	83 e0 1f             	and    $0x1f,%eax
  80418a:	29 d0                	sub    %edx,%eax
  80418c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804190:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804194:	48 01 ca             	add    %rcx,%rdx
  804197:	0f b6 0a             	movzbl (%rdx),%ecx
  80419a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80419e:	48 98                	cltq   
  8041a0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a8:	8b 40 04             	mov    0x4(%rax),%eax
  8041ab:	8d 50 01             	lea    0x1(%rax),%edx
  8041ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041be:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041c2:	0f 82 64 ff ff ff    	jb     80412c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041cc:	c9                   	leaveq 
  8041cd:	c3                   	retq   

00000000008041ce <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041ce:	55                   	push   %rbp
  8041cf:	48 89 e5             	mov    %rsp,%rbp
  8041d2:	48 83 ec 20          	sub    $0x20,%rsp
  8041d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e2:	48 89 c7             	mov    %rax,%rdi
  8041e5:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8041ec:	00 00 00 
  8041ef:	ff d0                	callq  *%rax
  8041f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f9:	48 be 99 51 80 00 00 	movabs $0x805199,%rsi
  804200:	00 00 00 
  804203:	48 89 c7             	mov    %rax,%rdi
  804206:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  80420d:	00 00 00 
  804210:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804216:	8b 50 04             	mov    0x4(%rax),%edx
  804219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421d:	8b 00                	mov    (%rax),%eax
  80421f:	29 c2                	sub    %eax,%edx
  804221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804225:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80422b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80422f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804236:	00 00 00 
	stat->st_dev = &devpipe;
  804239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80423d:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804244:	00 00 00 
  804247:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80424e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804253:	c9                   	leaveq 
  804254:	c3                   	retq   

0000000000804255 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804255:	55                   	push   %rbp
  804256:	48 89 e5             	mov    %rsp,%rbp
  804259:	48 83 ec 10          	sub    $0x10,%rsp
  80425d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804265:	48 89 c6             	mov    %rax,%rsi
  804268:	bf 00 00 00 00       	mov    $0x0,%edi
  80426d:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  804274:	00 00 00 
  804277:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427d:	48 89 c7             	mov    %rax,%rdi
  804280:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  804287:	00 00 00 
  80428a:	ff d0                	callq  *%rax
  80428c:	48 89 c6             	mov    %rax,%rsi
  80428f:	bf 00 00 00 00       	mov    $0x0,%edi
  804294:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80429b:	00 00 00 
  80429e:	ff d0                	callq  *%rax
}
  8042a0:	c9                   	leaveq 
  8042a1:	c3                   	retq   

00000000008042a2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8042a2:	55                   	push   %rbp
  8042a3:	48 89 e5             	mov    %rsp,%rbp
  8042a6:	48 83 ec 20          	sub    $0x20,%rsp
  8042aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042b0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8042b3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8042b7:	be 01 00 00 00       	mov    $0x1,%esi
  8042bc:	48 89 c7             	mov    %rax,%rdi
  8042bf:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8042c6:	00 00 00 
  8042c9:	ff d0                	callq  *%rax
}
  8042cb:	c9                   	leaveq 
  8042cc:	c3                   	retq   

00000000008042cd <getchar>:

int
getchar(void)
{
  8042cd:	55                   	push   %rbp
  8042ce:	48 89 e5             	mov    %rsp,%rbp
  8042d1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8042d5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8042d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8042de:	48 89 c6             	mov    %rax,%rsi
  8042e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e6:	48 b8 e1 29 80 00 00 	movabs $0x8029e1,%rax
  8042ed:	00 00 00 
  8042f0:	ff d0                	callq  *%rax
  8042f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042f9:	79 05                	jns    804300 <getchar+0x33>
		return r;
  8042fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042fe:	eb 14                	jmp    804314 <getchar+0x47>
	if (r < 1)
  804300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804304:	7f 07                	jg     80430d <getchar+0x40>
		return -E_EOF;
  804306:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80430b:	eb 07                	jmp    804314 <getchar+0x47>
	return c;
  80430d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804311:	0f b6 c0             	movzbl %al,%eax
}
  804314:	c9                   	leaveq 
  804315:	c3                   	retq   

0000000000804316 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804316:	55                   	push   %rbp
  804317:	48 89 e5             	mov    %rsp,%rbp
  80431a:	48 83 ec 20          	sub    $0x20,%rsp
  80431e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804321:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804325:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804328:	48 89 d6             	mov    %rdx,%rsi
  80432b:	89 c7                	mov    %eax,%edi
  80432d:	48 b8 af 25 80 00 00 	movabs $0x8025af,%rax
  804334:	00 00 00 
  804337:	ff d0                	callq  *%rax
  804339:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80433c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804340:	79 05                	jns    804347 <iscons+0x31>
		return r;
  804342:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804345:	eb 1a                	jmp    804361 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80434b:	8b 10                	mov    (%rax),%edx
  80434d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804354:	00 00 00 
  804357:	8b 00                	mov    (%rax),%eax
  804359:	39 c2                	cmp    %eax,%edx
  80435b:	0f 94 c0             	sete   %al
  80435e:	0f b6 c0             	movzbl %al,%eax
}
  804361:	c9                   	leaveq 
  804362:	c3                   	retq   

0000000000804363 <opencons>:

int
opencons(void)
{
  804363:	55                   	push   %rbp
  804364:	48 89 e5             	mov    %rsp,%rbp
  804367:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80436b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80436f:	48 89 c7             	mov    %rax,%rdi
  804372:	48 b8 17 25 80 00 00 	movabs $0x802517,%rax
  804379:	00 00 00 
  80437c:	ff d0                	callq  *%rax
  80437e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804385:	79 05                	jns    80438c <opencons+0x29>
		return r;
  804387:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80438a:	eb 5b                	jmp    8043e7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80438c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804390:	ba 07 04 00 00       	mov    $0x407,%edx
  804395:	48 89 c6             	mov    %rax,%rsi
  804398:	bf 00 00 00 00       	mov    $0x0,%edi
  80439d:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8043a4:	00 00 00 
  8043a7:	ff d0                	callq  *%rax
  8043a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b0:	79 05                	jns    8043b7 <opencons+0x54>
		return r;
  8043b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b5:	eb 30                	jmp    8043e7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8043b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043bb:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8043c2:	00 00 00 
  8043c5:	8b 12                	mov    (%rdx),%edx
  8043c7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8043c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8043d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d8:	48 89 c7             	mov    %rax,%rdi
  8043db:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  8043e2:	00 00 00 
  8043e5:	ff d0                	callq  *%rax
}
  8043e7:	c9                   	leaveq 
  8043e8:	c3                   	retq   

00000000008043e9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043e9:	55                   	push   %rbp
  8043ea:	48 89 e5             	mov    %rsp,%rbp
  8043ed:	48 83 ec 30          	sub    $0x30,%rsp
  8043f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043fd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804402:	75 07                	jne    80440b <devcons_read+0x22>
		return 0;
  804404:	b8 00 00 00 00       	mov    $0x0,%eax
  804409:	eb 4b                	jmp    804456 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80440b:	eb 0c                	jmp    804419 <devcons_read+0x30>
		sys_yield();
  80440d:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804419:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  804420:	00 00 00 
  804423:	ff d0                	callq  *%rax
  804425:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804428:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80442c:	74 df                	je     80440d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80442e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804432:	79 05                	jns    804439 <devcons_read+0x50>
		return c;
  804434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804437:	eb 1d                	jmp    804456 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804439:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80443d:	75 07                	jne    804446 <devcons_read+0x5d>
		return 0;
  80443f:	b8 00 00 00 00       	mov    $0x0,%eax
  804444:	eb 10                	jmp    804456 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804449:	89 c2                	mov    %eax,%edx
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	88 10                	mov    %dl,(%rax)
	return 1;
  804451:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804456:	c9                   	leaveq 
  804457:	c3                   	retq   

0000000000804458 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804458:	55                   	push   %rbp
  804459:	48 89 e5             	mov    %rsp,%rbp
  80445c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804463:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80446a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804471:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80447f:	eb 76                	jmp    8044f7 <devcons_write+0x9f>
		m = n - tot;
  804481:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804488:	89 c2                	mov    %eax,%edx
  80448a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448d:	29 c2                	sub    %eax,%edx
  80448f:	89 d0                	mov    %edx,%eax
  804491:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804494:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804497:	83 f8 7f             	cmp    $0x7f,%eax
  80449a:	76 07                	jbe    8044a3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80449c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8044a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044a6:	48 63 d0             	movslq %eax,%rdx
  8044a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ac:	48 63 c8             	movslq %eax,%rcx
  8044af:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8044b6:	48 01 c1             	add    %rax,%rcx
  8044b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044c0:	48 89 ce             	mov    %rcx,%rsi
  8044c3:	48 89 c7             	mov    %rax,%rdi
  8044c6:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  8044cd:	00 00 00 
  8044d0:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8044d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044d5:	48 63 d0             	movslq %eax,%rdx
  8044d8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044df:	48 89 d6             	mov    %rdx,%rsi
  8044e2:	48 89 c7             	mov    %rax,%rdi
  8044e5:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8044ec:	00 00 00 
  8044ef:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044f4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fa:	48 98                	cltq   
  8044fc:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804503:	0f 82 78 ff ff ff    	jb     804481 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804509:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80450c:	c9                   	leaveq 
  80450d:	c3                   	retq   

000000000080450e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80450e:	55                   	push   %rbp
  80450f:	48 89 e5             	mov    %rsp,%rbp
  804512:	48 83 ec 08          	sub    $0x8,%rsp
  804516:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80451a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80451f:	c9                   	leaveq 
  804520:	c3                   	retq   

0000000000804521 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804521:	55                   	push   %rbp
  804522:	48 89 e5             	mov    %rsp,%rbp
  804525:	48 83 ec 10          	sub    $0x10,%rsp
  804529:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80452d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804535:	48 be a5 51 80 00 00 	movabs $0x8051a5,%rsi
  80453c:	00 00 00 
  80453f:	48 89 c7             	mov    %rax,%rdi
  804542:	48 b8 c7 11 80 00 00 	movabs $0x8011c7,%rax
  804549:	00 00 00 
  80454c:	ff d0                	callq  *%rax
	return 0;
  80454e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804553:	c9                   	leaveq 
  804554:	c3                   	retq   

0000000000804555 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804555:	55                   	push   %rbp
  804556:	48 89 e5             	mov    %rsp,%rbp
  804559:	48 83 ec 10          	sub    $0x10,%rsp
  80455d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804561:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804568:	00 00 00 
  80456b:	48 8b 00             	mov    (%rax),%rax
  80456e:	48 85 c0             	test   %rax,%rax
  804571:	0f 85 84 00 00 00    	jne    8045fb <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804577:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80457e:	00 00 00 
  804581:	48 8b 00             	mov    (%rax),%rax
  804584:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80458a:	ba 07 00 00 00       	mov    $0x7,%edx
  80458f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804594:	89 c7                	mov    %eax,%edi
  804596:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  80459d:	00 00 00 
  8045a0:	ff d0                	callq  *%rax
  8045a2:	85 c0                	test   %eax,%eax
  8045a4:	79 2a                	jns    8045d0 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8045a6:	48 ba b0 51 80 00 00 	movabs $0x8051b0,%rdx
  8045ad:	00 00 00 
  8045b0:	be 23 00 00 00       	mov    $0x23,%esi
  8045b5:	48 bf d7 51 80 00 00 	movabs $0x8051d7,%rdi
  8045bc:	00 00 00 
  8045bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c4:	48 b9 d9 03 80 00 00 	movabs $0x8003d9,%rcx
  8045cb:	00 00 00 
  8045ce:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8045d0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045d7:	00 00 00 
  8045da:	48 8b 00             	mov    (%rax),%rax
  8045dd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8045e3:	48 be 0e 46 80 00 00 	movabs $0x80460e,%rsi
  8045ea:	00 00 00 
  8045ed:	89 c7                	mov    %eax,%edi
  8045ef:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8045f6:	00 00 00 
  8045f9:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8045fb:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804602:	00 00 00 
  804605:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804609:	48 89 10             	mov    %rdx,(%rax)
}
  80460c:	c9                   	leaveq 
  80460d:	c3                   	retq   

000000000080460e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80460e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804611:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804618:	00 00 00 
call *%rax
  80461b:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  80461d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804624:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804625:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80462c:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  80462d:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804631:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804634:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80463b:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  80463c:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804640:	4c 8b 3c 24          	mov    (%rsp),%r15
  804644:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804649:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80464e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804653:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804658:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80465d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804662:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804667:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80466c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804671:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804676:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80467b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804680:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804685:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80468a:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  80468e:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804692:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804693:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804694:	c3                   	retq   

0000000000804695 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804695:	55                   	push   %rbp
  804696:	48 89 e5             	mov    %rsp,%rbp
  804699:	48 83 ec 30          	sub    $0x30,%rsp
  80469d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8046a9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046b0:	00 00 00 
  8046b3:	48 8b 00             	mov    (%rax),%rax
  8046b6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8046bc:	85 c0                	test   %eax,%eax
  8046be:	75 3c                	jne    8046fc <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8046c0:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8046c7:	00 00 00 
  8046ca:	ff d0                	callq  *%rax
  8046cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8046d1:	48 63 d0             	movslq %eax,%rdx
  8046d4:	48 89 d0             	mov    %rdx,%rax
  8046d7:	48 c1 e0 03          	shl    $0x3,%rax
  8046db:	48 01 d0             	add    %rdx,%rax
  8046de:	48 c1 e0 05          	shl    $0x5,%rax
  8046e2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046e9:	00 00 00 
  8046ec:	48 01 c2             	add    %rax,%rdx
  8046ef:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046f6:	00 00 00 
  8046f9:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8046fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804701:	75 0e                	jne    804711 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804703:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80470a:	00 00 00 
  80470d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804715:	48 89 c7             	mov    %rax,%rdi
  804718:	48 b8 1f 1d 80 00 00 	movabs $0x801d1f,%rax
  80471f:	00 00 00 
  804722:	ff d0                	callq  *%rax
  804724:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472b:	79 19                	jns    804746 <ipc_recv+0xb1>
		*from_env_store = 0;
  80472d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804731:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80473b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804744:	eb 53                	jmp    804799 <ipc_recv+0x104>
	}
	if(from_env_store)
  804746:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80474b:	74 19                	je     804766 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80474d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804754:	00 00 00 
  804757:	48 8b 00             	mov    (%rax),%rax
  80475a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804764:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804766:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80476b:	74 19                	je     804786 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80476d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804774:	00 00 00 
  804777:	48 8b 00             	mov    (%rax),%rax
  80477a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804784:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804786:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80478d:	00 00 00 
  804790:	48 8b 00             	mov    (%rax),%rax
  804793:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804799:	c9                   	leaveq 
  80479a:	c3                   	retq   

000000000080479b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80479b:	55                   	push   %rbp
  80479c:	48 89 e5             	mov    %rsp,%rbp
  80479f:	48 83 ec 30          	sub    $0x30,%rsp
  8047a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047a9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047ad:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8047b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047b5:	75 0e                	jne    8047c5 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8047b7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047be:	00 00 00 
  8047c1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8047c5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047c8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047d2:	89 c7                	mov    %eax,%edi
  8047d4:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  8047db:	00 00 00 
  8047de:	ff d0                	callq  *%rax
  8047e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8047e3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047e7:	75 0c                	jne    8047f5 <ipc_send+0x5a>
			sys_yield();
  8047e9:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8047f0:	00 00 00 
  8047f3:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8047f5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047f9:	74 ca                	je     8047c5 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8047fb:	c9                   	leaveq 
  8047fc:	c3                   	retq   

00000000008047fd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8047fd:	55                   	push   %rbp
  8047fe:	48 89 e5             	mov    %rsp,%rbp
  804801:	48 83 ec 14          	sub    $0x14,%rsp
  804805:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804808:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80480f:	eb 5e                	jmp    80486f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804811:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804818:	00 00 00 
  80481b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481e:	48 63 d0             	movslq %eax,%rdx
  804821:	48 89 d0             	mov    %rdx,%rax
  804824:	48 c1 e0 03          	shl    $0x3,%rax
  804828:	48 01 d0             	add    %rdx,%rax
  80482b:	48 c1 e0 05          	shl    $0x5,%rax
  80482f:	48 01 c8             	add    %rcx,%rax
  804832:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804838:	8b 00                	mov    (%rax),%eax
  80483a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80483d:	75 2c                	jne    80486b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80483f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804846:	00 00 00 
  804849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484c:	48 63 d0             	movslq %eax,%rdx
  80484f:	48 89 d0             	mov    %rdx,%rax
  804852:	48 c1 e0 03          	shl    $0x3,%rax
  804856:	48 01 d0             	add    %rdx,%rax
  804859:	48 c1 e0 05          	shl    $0x5,%rax
  80485d:	48 01 c8             	add    %rcx,%rax
  804860:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804866:	8b 40 08             	mov    0x8(%rax),%eax
  804869:	eb 12                	jmp    80487d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80486b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80486f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804876:	7e 99                	jle    804811 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80487d:	c9                   	leaveq 
  80487e:	c3                   	retq   

000000000080487f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80487f:	55                   	push   %rbp
  804880:	48 89 e5             	mov    %rsp,%rbp
  804883:	48 83 ec 18          	sub    $0x18,%rsp
  804887:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80488b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80488f:	48 c1 e8 15          	shr    $0x15,%rax
  804893:	48 89 c2             	mov    %rax,%rdx
  804896:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80489d:	01 00 00 
  8048a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048a4:	83 e0 01             	and    $0x1,%eax
  8048a7:	48 85 c0             	test   %rax,%rax
  8048aa:	75 07                	jne    8048b3 <pageref+0x34>
		return 0;
  8048ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b1:	eb 53                	jmp    804906 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8048bb:	48 89 c2             	mov    %rax,%rdx
  8048be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048c5:	01 00 00 
  8048c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d4:	83 e0 01             	and    $0x1,%eax
  8048d7:	48 85 c0             	test   %rax,%rax
  8048da:	75 07                	jne    8048e3 <pageref+0x64>
		return 0;
  8048dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8048e1:	eb 23                	jmp    804906 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8048eb:	48 89 c2             	mov    %rax,%rdx
  8048ee:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048f5:	00 00 00 
  8048f8:	48 c1 e2 04          	shl    $0x4,%rdx
  8048fc:	48 01 d0             	add    %rdx,%rax
  8048ff:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804903:	0f b7 c0             	movzwl %ax,%eax
}
  804906:	c9                   	leaveq 
  804907:	c3                   	retq   
