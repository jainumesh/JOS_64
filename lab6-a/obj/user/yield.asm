
obj/user/yield.debug:     file format elf64-x86-64


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
  80003c:	e8 c5 00 00 00       	callq  800106 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 20 3f 80 00 00 	movabs $0x803f20,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf 40 3f 80 00 00 	movabs $0x803f40,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
  80010a:	48 83 ec 10          	sub    $0x10,%rsp
  80010e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800111:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800115:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	48 63 d0             	movslq %eax,%rdx
  800129:	48 89 d0             	mov    %rdx,%rax
  80012c:	48 c1 e0 03          	shl    $0x3,%rax
  800130:	48 01 d0             	add    %rdx,%rax
  800133:	48 c1 e0 05          	shl    $0x5,%rax
  800137:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80013e:	00 00 00 
  800141:	48 01 c2             	add    %rax,%rdx
  800144:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014b:	00 00 00 
  80014e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800155:	7e 14                	jle    80016b <libmain+0x65>
		binaryname = argv[0];
  800157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015b:	48 8b 10             	mov    (%rax),%rdx
  80015e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800165:	00 00 00 
  800168:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80016b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800172:	48 89 d6             	mov    %rdx,%rsi
  800175:	89 c7                	mov    %eax,%edi
  800177:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800183:	48 b8 91 01 80 00 00 	movabs $0x800191,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
}
  80018f:	c9                   	leaveq 
  800190:	c3                   	retq   

0000000000800191 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800191:	55                   	push   %rbp
  800192:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800195:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a6:	48 b8 fd 16 80 00 00 	movabs $0x8016fd,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax

}
  8001b2:	5d                   	pop    %rbp
  8001b3:	c3                   	retq   

00000000008001b4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001b4:	55                   	push   %rbp
  8001b5:	48 89 e5             	mov    %rsp,%rbp
  8001b8:	48 83 ec 10          	sub    $0x10,%rsp
  8001bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c7:	8b 00                	mov    (%rax),%eax
  8001c9:	8d 48 01             	lea    0x1(%rax),%ecx
  8001cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d0:	89 0a                	mov    %ecx,(%rdx)
  8001d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001db:	48 98                	cltq   
  8001dd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e5:	8b 00                	mov    (%rax),%eax
  8001e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ec:	75 2c                	jne    80021a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f2:	8b 00                	mov    (%rax),%eax
  8001f4:	48 98                	cltq   
  8001f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001fa:	48 83 c2 08          	add    $0x8,%rdx
  8001fe:	48 89 c6             	mov    %rax,%rsi
  800201:	48 89 d7             	mov    %rdx,%rdi
  800204:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
        b->idx = 0;
  800210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800214:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 40 04             	mov    0x4(%rax),%eax
  800221:	8d 50 01             	lea    0x1(%rax),%edx
  800224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800228:	89 50 04             	mov    %edx,0x4(%rax)
}
  80022b:	c9                   	leaveq 
  80022c:	c3                   	retq   

000000000080022d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800238:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80023f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800246:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80024d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800254:	48 8b 0a             	mov    (%rdx),%rcx
  800257:	48 89 08             	mov    %rcx,(%rax)
  80025a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80025e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800262:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800266:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80026a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800271:	00 00 00 
    b.cnt = 0;
  800274:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80027b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80027e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800285:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80028c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800293:	48 89 c6             	mov    %rax,%rsi
  800296:	48 bf b4 01 80 00 00 	movabs $0x8001b4,%rdi
  80029d:	00 00 00 
  8002a0:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002ac:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002b2:	48 98                	cltq   
  8002b4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002bb:	48 83 c2 08          	add    $0x8,%rdx
  8002bf:	48 89 c6             	mov    %rax,%rsi
  8002c2:	48 89 d7             	mov    %rdx,%rdi
  8002c5:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002d7:	c9                   	leaveq 
  8002d8:	c3                   	retq   

00000000008002d9 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002d9:	55                   	push   %rbp
  8002da:	48 89 e5             	mov    %rsp,%rbp
  8002dd:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002e4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002eb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002f9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800300:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800307:	84 c0                	test   %al,%al
  800309:	74 20                	je     80032b <cprintf+0x52>
  80030b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80030f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800313:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800317:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80031b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80031f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800323:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800327:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80032b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800332:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800339:	00 00 00 
  80033c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800343:	00 00 00 
  800346:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80034a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800351:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800358:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80035f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800366:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80036d:	48 8b 0a             	mov    (%rdx),%rcx
  800370:	48 89 08             	mov    %rcx,(%rax)
  800373:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800377:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80037b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80037f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800383:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80038a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800391:	48 89 d6             	mov    %rdx,%rsi
  800394:	48 89 c7             	mov    %rax,%rdi
  800397:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
  8003a3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003a9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003af:	c9                   	leaveq 
  8003b0:	c3                   	retq   

00000000008003b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	53                   	push   %rbx
  8003b6:	48 83 ec 38          	sub    $0x38,%rsp
  8003ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003c6:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003c9:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003cd:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003d4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003d8:	77 3b                	ja     800415 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003da:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003dd:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003e1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	48 f7 f3             	div    %rbx
  8003f0:	48 89 c2             	mov    %rax,%rdx
  8003f3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003f9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800401:	41 89 f9             	mov    %edi,%r9d
  800404:	48 89 c7             	mov    %rax,%rdi
  800407:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  80040e:	00 00 00 
  800411:	ff d0                	callq  *%rax
  800413:	eb 1e                	jmp    800433 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800415:	eb 12                	jmp    800429 <printnum+0x78>
			putch(padc, putdat);
  800417:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80041b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80041e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800422:	48 89 ce             	mov    %rcx,%rsi
  800425:	89 d7                	mov    %edx,%edi
  800427:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800429:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80042d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800431:	7f e4                	jg     800417 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800433:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	48 f7 f1             	div    %rcx
  800442:	48 89 d0             	mov    %rdx,%rax
  800445:	48 ba 90 41 80 00 00 	movabs $0x804190,%rdx
  80044c:	00 00 00 
  80044f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800453:	0f be d0             	movsbl %al,%edx
  800456:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045e:	48 89 ce             	mov    %rcx,%rsi
  800461:	89 d7                	mov    %edx,%edi
  800463:	ff d0                	callq  *%rax
}
  800465:	48 83 c4 38          	add    $0x38,%rsp
  800469:	5b                   	pop    %rbx
  80046a:	5d                   	pop    %rbp
  80046b:	c3                   	retq   

000000000080046c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 83 ec 1c          	sub    $0x1c,%rsp
  800474:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800478:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80047b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80047f:	7e 52                	jle    8004d3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800485:	8b 00                	mov    (%rax),%eax
  800487:	83 f8 30             	cmp    $0x30,%eax
  80048a:	73 24                	jae    8004b0 <getuint+0x44>
  80048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800490:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800498:	8b 00                	mov    (%rax),%eax
  80049a:	89 c0                	mov    %eax,%eax
  80049c:	48 01 d0             	add    %rdx,%rax
  80049f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a3:	8b 12                	mov    (%rdx),%edx
  8004a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ac:	89 0a                	mov    %ecx,(%rdx)
  8004ae:	eb 17                	jmp    8004c7 <getuint+0x5b>
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004b8:	48 89 d0             	mov    %rdx,%rax
  8004bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004c7:	48 8b 00             	mov    (%rax),%rax
  8004ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ce:	e9 a3 00 00 00       	jmpq   800576 <getuint+0x10a>
	else if (lflag)
  8004d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004d7:	74 4f                	je     800528 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	83 f8 30             	cmp    $0x30,%eax
  8004e2:	73 24                	jae    800508 <getuint+0x9c>
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	89 c0                	mov    %eax,%eax
  8004f4:	48 01 d0             	add    %rdx,%rax
  8004f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fb:	8b 12                	mov    (%rdx),%edx
  8004fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	89 0a                	mov    %ecx,(%rdx)
  800506:	eb 17                	jmp    80051f <getuint+0xb3>
  800508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800510:	48 89 d0             	mov    %rdx,%rax
  800513:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800517:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80051f:	48 8b 00             	mov    (%rax),%rax
  800522:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800526:	eb 4e                	jmp    800576 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	83 f8 30             	cmp    $0x30,%eax
  800531:	73 24                	jae    800557 <getuint+0xeb>
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	8b 00                	mov    (%rax),%eax
  800541:	89 c0                	mov    %eax,%eax
  800543:	48 01 d0             	add    %rdx,%rax
  800546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054a:	8b 12                	mov    (%rdx),%edx
  80054c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800553:	89 0a                	mov    %ecx,(%rdx)
  800555:	eb 17                	jmp    80056e <getuint+0x102>
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055f:	48 89 d0             	mov    %rdx,%rax
  800562:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056e:	8b 00                	mov    (%rax),%eax
  800570:	89 c0                	mov    %eax,%eax
  800572:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80057a:	c9                   	leaveq 
  80057b:	c3                   	retq   

000000000080057c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	48 83 ec 1c          	sub    $0x1c,%rsp
  800584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80058b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80058f:	7e 52                	jle    8005e3 <getint+0x67>
		x=va_arg(*ap, long long);
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	8b 00                	mov    (%rax),%eax
  800597:	83 f8 30             	cmp    $0x30,%eax
  80059a:	73 24                	jae    8005c0 <getint+0x44>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	8b 00                	mov    (%rax),%eax
  8005aa:	89 c0                	mov    %eax,%eax
  8005ac:	48 01 d0             	add    %rdx,%rax
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	8b 12                	mov    (%rdx),%edx
  8005b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	89 0a                	mov    %ecx,(%rdx)
  8005be:	eb 17                	jmp    8005d7 <getint+0x5b>
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c8:	48 89 d0             	mov    %rdx,%rax
  8005cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d7:	48 8b 00             	mov    (%rax),%rax
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005de:	e9 a3 00 00 00       	jmpq   800686 <getint+0x10a>
	else if (lflag)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e7:	74 4f                	je     800638 <getint+0xbc>
		x=va_arg(*ap, long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getint+0x9c>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 17                	jmp    80062f <getint+0xb3>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800620:	48 89 d0             	mov    %rdx,%rax
  800623:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062f:	48 8b 00             	mov    (%rax),%rax
  800632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800636:	eb 4e                	jmp    800686 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getint+0xeb>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getint+0x102>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	48 98                	cltq   
  800682:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068a:	c9                   	leaveq 
  80068b:	c3                   	retq   

000000000080068c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80068c:	55                   	push   %rbp
  80068d:	48 89 e5             	mov    %rsp,%rbp
  800690:	41 54                	push   %r12
  800692:	53                   	push   %rbx
  800693:	48 83 ec 60          	sub    $0x60,%rsp
  800697:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80069b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80069f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006a7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ab:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006af:	48 8b 0a             	mov    (%rdx),%rcx
  8006b2:	48 89 08             	mov    %rcx,(%rax)
  8006b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	eb 17                	jmp    8006de <vprintfmt+0x52>
			if (ch == '\0')
  8006c7:	85 db                	test   %ebx,%ebx
  8006c9:	0f 84 cc 04 00 00    	je     800b9b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006cf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006d7:	48 89 d6             	mov    %rdx,%rsi
  8006da:	89 df                	mov    %ebx,%edi
  8006dc:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ea:	0f b6 00             	movzbl (%rax),%eax
  8006ed:	0f b6 d8             	movzbl %al,%ebx
  8006f0:	83 fb 25             	cmp    $0x25,%ebx
  8006f3:	75 d2                	jne    8006c7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006f5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006f9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800700:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800707:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80070e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800715:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800719:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80071d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800721:	0f b6 00             	movzbl (%rax),%eax
  800724:	0f b6 d8             	movzbl %al,%ebx
  800727:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80072a:	83 f8 55             	cmp    $0x55,%eax
  80072d:	0f 87 34 04 00 00    	ja     800b67 <vprintfmt+0x4db>
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80073c:	00 
  80073d:	48 b8 b8 41 80 00 00 	movabs $0x8041b8,%rax
  800744:	00 00 00 
  800747:	48 01 d0             	add    %rdx,%rax
  80074a:	48 8b 00             	mov    (%rax),%rax
  80074d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80074f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800753:	eb c0                	jmp    800715 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800755:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800759:	eb ba                	jmp    800715 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800762:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800765:	89 d0                	mov    %edx,%eax
  800767:	c1 e0 02             	shl    $0x2,%eax
  80076a:	01 d0                	add    %edx,%eax
  80076c:	01 c0                	add    %eax,%eax
  80076e:	01 d8                	add    %ebx,%eax
  800770:	83 e8 30             	sub    $0x30,%eax
  800773:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800776:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077a:	0f b6 00             	movzbl (%rax),%eax
  80077d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800780:	83 fb 2f             	cmp    $0x2f,%ebx
  800783:	7e 0c                	jle    800791 <vprintfmt+0x105>
  800785:	83 fb 39             	cmp    $0x39,%ebx
  800788:	7f 07                	jg     800791 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80078f:	eb d1                	jmp    800762 <vprintfmt+0xd6>
			goto process_precision;
  800791:	eb 58                	jmp    8007eb <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800793:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 17                	jae    8007b2 <vprintfmt+0x126>
  80079b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 01 d0             	add    %rdx,%rax
  8007a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007aa:	83 c2 08             	add    $0x8,%edx
  8007ad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b0:	eb 0f                	jmp    8007c1 <vprintfmt+0x135>
  8007b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 83 c2 08          	add    $0x8,%rdx
  8007bd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007c6:	eb 23                	jmp    8007eb <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cc:	79 0c                	jns    8007da <vprintfmt+0x14e>
				width = 0;
  8007ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007d5:	e9 3b ff ff ff       	jmpq   800715 <vprintfmt+0x89>
  8007da:	e9 36 ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007df:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007e6:	e9 2a ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ef:	79 12                	jns    800803 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007f1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007f4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007fe:	e9 12 ff ff ff       	jmpq   800715 <vprintfmt+0x89>
  800803:	e9 0d ff ff ff       	jmpq   800715 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800808:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80080c:	e9 04 ff ff ff       	jmpq   800715 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800811:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 17                	jae    800830 <vprintfmt+0x1a4>
  800819:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80081d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800820:	89 c0                	mov    %eax,%eax
  800822:	48 01 d0             	add    %rdx,%rax
  800825:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800828:	83 c2 08             	add    $0x8,%edx
  80082b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082e:	eb 0f                	jmp    80083f <vprintfmt+0x1b3>
  800830:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 83 c2 08          	add    $0x8,%rdx
  80083b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083f:	8b 10                	mov    (%rax),%edx
  800841:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800845:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800849:	48 89 ce             	mov    %rcx,%rsi
  80084c:	89 d7                	mov    %edx,%edi
  80084e:	ff d0                	callq  *%rax
			break;
  800850:	e9 40 03 00 00       	jmpq   800b95 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800855:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800858:	83 f8 30             	cmp    $0x30,%eax
  80085b:	73 17                	jae    800874 <vprintfmt+0x1e8>
  80085d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800861:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800864:	89 c0                	mov    %eax,%eax
  800866:	48 01 d0             	add    %rdx,%rax
  800869:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086c:	83 c2 08             	add    $0x8,%edx
  80086f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800872:	eb 0f                	jmp    800883 <vprintfmt+0x1f7>
  800874:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800878:	48 89 d0             	mov    %rdx,%rax
  80087b:	48 83 c2 08          	add    $0x8,%rdx
  80087f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800883:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800885:	85 db                	test   %ebx,%ebx
  800887:	79 02                	jns    80088b <vprintfmt+0x1ff>
				err = -err;
  800889:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80088b:	83 fb 15             	cmp    $0x15,%ebx
  80088e:	7f 16                	jg     8008a6 <vprintfmt+0x21a>
  800890:	48 b8 e0 40 80 00 00 	movabs $0x8040e0,%rax
  800897:	00 00 00 
  80089a:	48 63 d3             	movslq %ebx,%rdx
  80089d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008a1:	4d 85 e4             	test   %r12,%r12
  8008a4:	75 2e                	jne    8008d4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008a6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ae:	89 d9                	mov    %ebx,%ecx
  8008b0:	48 ba a1 41 80 00 00 	movabs $0x8041a1,%rdx
  8008b7:	00 00 00 
  8008ba:	48 89 c7             	mov    %rax,%rdi
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008c9:	00 00 00 
  8008cc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cf:	e9 c1 02 00 00       	jmpq   800b95 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008dc:	4c 89 e1             	mov    %r12,%rcx
  8008df:	48 ba aa 41 80 00 00 	movabs $0x8041aa,%rdx
  8008e6:	00 00 00 
  8008e9:	48 89 c7             	mov    %rax,%rdi
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008f8:	00 00 00 
  8008fb:	41 ff d0             	callq  *%r8
			break;
  8008fe:	e9 92 02 00 00       	jmpq   800b95 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 17                	jae    800922 <vprintfmt+0x296>
  80090b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091a:	83 c2 08             	add    $0x8,%edx
  80091d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800920:	eb 0f                	jmp    800931 <vprintfmt+0x2a5>
  800922:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800926:	48 89 d0             	mov    %rdx,%rax
  800929:	48 83 c2 08          	add    $0x8,%rdx
  80092d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800931:	4c 8b 20             	mov    (%rax),%r12
  800934:	4d 85 e4             	test   %r12,%r12
  800937:	75 0a                	jne    800943 <vprintfmt+0x2b7>
				p = "(null)";
  800939:	49 bc ad 41 80 00 00 	movabs $0x8041ad,%r12
  800940:	00 00 00 
			if (width > 0 && padc != '-')
  800943:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800947:	7e 3f                	jle    800988 <vprintfmt+0x2fc>
  800949:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80094d:	74 39                	je     800988 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800952:	48 98                	cltq   
  800954:	48 89 c6             	mov    %rax,%rsi
  800957:	4c 89 e7             	mov    %r12,%rdi
  80095a:	48 b8 50 0e 80 00 00 	movabs $0x800e50,%rax
  800961:	00 00 00 
  800964:	ff d0                	callq  *%rax
  800966:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800969:	eb 17                	jmp    800982 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80096b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80096f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800973:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800977:	48 89 ce             	mov    %rcx,%rsi
  80097a:	89 d7                	mov    %edx,%edi
  80097c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800982:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800986:	7f e3                	jg     80096b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800988:	eb 37                	jmp    8009c1 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80098a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80098e:	74 1e                	je     8009ae <vprintfmt+0x322>
  800990:	83 fb 1f             	cmp    $0x1f,%ebx
  800993:	7e 05                	jle    80099a <vprintfmt+0x30e>
  800995:	83 fb 7e             	cmp    $0x7e,%ebx
  800998:	7e 14                	jle    8009ae <vprintfmt+0x322>
					putch('?', putdat);
  80099a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a2:	48 89 d6             	mov    %rdx,%rsi
  8009a5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009aa:	ff d0                	callq  *%rax
  8009ac:	eb 0f                	jmp    8009bd <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b6:	48 89 d6             	mov    %rdx,%rsi
  8009b9:	89 df                	mov    %ebx,%edi
  8009bb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009bd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c1:	4c 89 e0             	mov    %r12,%rax
  8009c4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f be d8             	movsbl %al,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	74 10                	je     8009e2 <vprintfmt+0x356>
  8009d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009d6:	78 b2                	js     80098a <vprintfmt+0x2fe>
  8009d8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009e0:	79 a8                	jns    80098a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e2:	eb 16                	jmp    8009fa <vprintfmt+0x36e>
				putch(' ', putdat);
  8009e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ec:	48 89 d6             	mov    %rdx,%rsi
  8009ef:	bf 20 00 00 00       	mov    $0x20,%edi
  8009f4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	7f e4                	jg     8009e4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a00:	e9 90 01 00 00       	jmpq   800b95 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a09:	be 03 00 00 00       	mov    $0x3,%esi
  800a0e:	48 89 c7             	mov    %rax,%rdi
  800a11:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800a18:	00 00 00 
  800a1b:	ff d0                	callq  *%rax
  800a1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a25:	48 85 c0             	test   %rax,%rax
  800a28:	79 1d                	jns    800a47 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	48 89 d6             	mov    %rdx,%rsi
  800a35:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a3a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 f7 d8             	neg    %rax
  800a43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a47:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4e:	e9 d5 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a57:	be 03 00 00 00       	mov    $0x3,%esi
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 6c 04 80 00 00 	movabs $0x80046c,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a76:	e9 ad 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a7b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a82:	89 d6                	mov    %edx,%esi
  800a84:	48 89 c7             	mov    %rax,%rdi
  800a87:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
  800a93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a97:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a9e:	e9 85 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aab:	48 89 d6             	mov    %rdx,%rsi
  800aae:	bf 30 00 00 00       	mov    $0x30,%edi
  800ab3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ab5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abd:	48 89 d6             	mov    %rdx,%rsi
  800ac0:	bf 78 00 00 00       	mov    $0x78,%edi
  800ac5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 30             	cmp    $0x30,%eax
  800acd:	73 17                	jae    800ae6 <vprintfmt+0x45a>
  800acf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 01 d0             	add    %rdx,%rax
  800adb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ade:	83 c2 08             	add    $0x8,%edx
  800ae1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae4:	eb 0f                	jmp    800af5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ae6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aea:	48 89 d0             	mov    %rdx,%rax
  800aed:	48 83 c2 08          	add    $0x8,%rdx
  800af1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800afc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b03:	eb 23                	jmp    800b28 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b09:	be 03 00 00 00       	mov    $0x3,%esi
  800b0e:	48 89 c7             	mov    %rax,%rdi
  800b11:	48 b8 6c 04 80 00 00 	movabs $0x80046c,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
  800b1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b21:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b28:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b2d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b30:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b37:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3f:	45 89 c1             	mov    %r8d,%r9d
  800b42:	41 89 f8             	mov    %edi,%r8d
  800b45:	48 89 c7             	mov    %rax,%rdi
  800b48:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax
			break;
  800b54:	eb 3f                	jmp    800b95 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5e:	48 89 d6             	mov    %rdx,%rsi
  800b61:	89 df                	mov    %ebx,%edi
  800b63:	ff d0                	callq  *%rax
			break;
  800b65:	eb 2e                	jmp    800b95 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6f:	48 89 d6             	mov    %rdx,%rsi
  800b72:	bf 25 00 00 00       	mov    $0x25,%edi
  800b77:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b79:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b7e:	eb 05                	jmp    800b85 <vprintfmt+0x4f9>
  800b80:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b89:	48 83 e8 01          	sub    $0x1,%rax
  800b8d:	0f b6 00             	movzbl (%rax),%eax
  800b90:	3c 25                	cmp    $0x25,%al
  800b92:	75 ec                	jne    800b80 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b94:	90                   	nop
		}
	}
  800b95:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b96:	e9 43 fb ff ff       	jmpq   8006de <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b9b:	48 83 c4 60          	add    $0x60,%rsp
  800b9f:	5b                   	pop    %rbx
  800ba0:	41 5c                	pop    %r12
  800ba2:	5d                   	pop    %rbp
  800ba3:	c3                   	retq   

0000000000800ba4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba4:	55                   	push   %rbp
  800ba5:	48 89 e5             	mov    %rsp,%rbp
  800ba8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800baf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bb6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bbd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bc4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bcb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bd2:	84 c0                	test   %al,%al
  800bd4:	74 20                	je     800bf6 <printfmt+0x52>
  800bd6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bde:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800be2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800be6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bf2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bf6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bfd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c04:	00 00 00 
  800c07:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c0e:	00 00 00 
  800c11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c15:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c23:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c2a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c31:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c38:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c3f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c46:	48 89 c7             	mov    %rax,%rdi
  800c49:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c55:	c9                   	leaveq 
  800c56:	c3                   	retq   

0000000000800c57 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c57:	55                   	push   %rbp
  800c58:	48 89 e5             	mov    %rsp,%rbp
  800c5b:	48 83 ec 10          	sub    $0x10,%rsp
  800c5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6a:	8b 40 10             	mov    0x10(%rax),%eax
  800c6d:	8d 50 01             	lea    0x1(%rax),%edx
  800c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c74:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7b:	48 8b 10             	mov    (%rax),%rdx
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c86:	48 39 c2             	cmp    %rax,%rdx
  800c89:	73 17                	jae    800ca2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	48 8b 00             	mov    (%rax),%rax
  800c92:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c9a:	48 89 0a             	mov    %rcx,(%rdx)
  800c9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ca0:	88 10                	mov    %dl,(%rax)
}
  800ca2:	c9                   	leaveq 
  800ca3:	c3                   	retq   

0000000000800ca4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca4:	55                   	push   %rbp
  800ca5:	48 89 e5             	mov    %rsp,%rbp
  800ca8:	48 83 ec 50          	sub    $0x50,%rsp
  800cac:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cb0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cb3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cb7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cbb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cbf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cc3:	48 8b 0a             	mov    (%rdx),%rcx
  800cc6:	48 89 08             	mov    %rcx,(%rax)
  800cc9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ccd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cd1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cd5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cdd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ce1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ce4:	48 98                	cltq   
  800ce6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cee:	48 01 d0             	add    %rdx,%rax
  800cf1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cf5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cfc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d01:	74 06                	je     800d09 <vsnprintf+0x65>
  800d03:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d07:	7f 07                	jg     800d10 <vsnprintf+0x6c>
		return -E_INVAL;
  800d09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d0e:	eb 2f                	jmp    800d3f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d10:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d14:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d18:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d1c:	48 89 c6             	mov    %rax,%rsi
  800d1f:	48 bf 57 0c 80 00 00 	movabs $0x800c57,%rdi
  800d26:	00 00 00 
  800d29:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d39:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d3c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d3f:	c9                   	leaveq 
  800d40:	c3                   	retq   

0000000000800d41 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d41:	55                   	push   %rbp
  800d42:	48 89 e5             	mov    %rsp,%rbp
  800d45:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d4c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d53:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d59:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d60:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d67:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6e:	84 c0                	test   %al,%al
  800d70:	74 20                	je     800d92 <snprintf+0x51>
  800d72:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d76:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d82:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d86:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d92:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d99:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800da0:	00 00 00 
  800da3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800daa:	00 00 00 
  800dad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800db8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dc6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dcd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dd4:	48 8b 0a             	mov    (%rdx),%rcx
  800dd7:	48 89 08             	mov    %rcx,(%rax)
  800dda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dde:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800de2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dea:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800df1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800df8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dfe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e05:	48 89 c7             	mov    %rax,%rdi
  800e08:	48 b8 a4 0c 80 00 00 	movabs $0x800ca4,%rax
  800e0f:	00 00 00 
  800e12:	ff d0                	callq  *%rax
  800e14:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e1a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e20:	c9                   	leaveq 
  800e21:	c3                   	retq   

0000000000800e22 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e22:	55                   	push   %rbp
  800e23:	48 89 e5             	mov    %rsp,%rbp
  800e26:	48 83 ec 18          	sub    $0x18,%rsp
  800e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e35:	eb 09                	jmp    800e40 <strlen+0x1e>
		n++;
  800e37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	0f b6 00             	movzbl (%rax),%eax
  800e47:	84 c0                	test   %al,%al
  800e49:	75 ec                	jne    800e37 <strlen+0x15>
		n++;
	return n;
  800e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e4e:	c9                   	leaveq 
  800e4f:	c3                   	retq   

0000000000800e50 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e50:	55                   	push   %rbp
  800e51:	48 89 e5             	mov    %rsp,%rbp
  800e54:	48 83 ec 20          	sub    $0x20,%rsp
  800e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e67:	eb 0e                	jmp    800e77 <strnlen+0x27>
		n++;
  800e69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e72:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e77:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e7c:	74 0b                	je     800e89 <strnlen+0x39>
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	0f b6 00             	movzbl (%rax),%eax
  800e85:	84 c0                	test   %al,%al
  800e87:	75 e0                	jne    800e69 <strnlen+0x19>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8c:	c9                   	leaveq 
  800e8d:	c3                   	retq   

0000000000800e8e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8e:	55                   	push   %rbp
  800e8f:	48 89 e5             	mov    %rsp,%rbp
  800e92:	48 83 ec 20          	sub    $0x20,%rsp
  800e96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ea6:	90                   	nop
  800ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eaf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eb3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eb7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ebb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ebf:	0f b6 12             	movzbl (%rdx),%edx
  800ec2:	88 10                	mov    %dl,(%rax)
  800ec4:	0f b6 00             	movzbl (%rax),%eax
  800ec7:	84 c0                	test   %al,%al
  800ec9:	75 dc                	jne    800ea7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ecf:	c9                   	leaveq 
  800ed0:	c3                   	retq   

0000000000800ed1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ed1:	55                   	push   %rbp
  800ed2:	48 89 e5             	mov    %rsp,%rbp
  800ed5:	48 83 ec 20          	sub    $0x20,%rsp
  800ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
  800ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ef7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800efa:	48 63 d0             	movslq %eax,%rdx
  800efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f01:	48 01 c2             	add    %rax,%rdx
  800f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f08:	48 89 c6             	mov    %rax,%rsi
  800f0b:	48 89 d7             	mov    %rdx,%rdi
  800f0e:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	callq  *%rax
	return dst;
  800f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 28          	sub    $0x28,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f3c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f43:	00 
  800f44:	eb 2a                	jmp    800f70 <strncpy+0x50>
		*dst++ = *src;
  800f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f56:	0f b6 12             	movzbl (%rdx),%edx
  800f59:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f5f:	0f b6 00             	movzbl (%rax),%eax
  800f62:	84 c0                	test   %al,%al
  800f64:	74 05                	je     800f6b <strncpy+0x4b>
			src++;
  800f66:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f6b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f78:	72 cc                	jb     800f46 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 28          	sub    $0x28,%rsp
  800f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f90:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa1:	74 3d                	je     800fe0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fa3:	eb 1d                	jmp    800fc2 <strlcpy+0x42>
			*dst++ = *src++;
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fbd:	0f b6 12             	movzbl (%rdx),%edx
  800fc0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fc7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fcc:	74 0b                	je     800fd9 <strlcpy+0x59>
  800fce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 cc                	jne    800fa5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fe0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe8:	48 29 c2             	sub    %rax,%rdx
  800feb:	48 89 d0             	mov    %rdx,%rax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 10          	sub    $0x10,%rsp
  800ff8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ffc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801000:	eb 0a                	jmp    80100c <strcmp+0x1c>
		p++, q++;
  801002:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801007:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80100c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	84 c0                	test   %al,%al
  801015:	74 12                	je     801029 <strcmp+0x39>
  801017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101b:	0f b6 10             	movzbl (%rax),%edx
  80101e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	38 c2                	cmp    %al,%dl
  801027:	74 d9                	je     801002 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	0f b6 d0             	movzbl %al,%edx
  801033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	0f b6 c0             	movzbl %al,%eax
  80103d:	29 c2                	sub    %eax,%edx
  80103f:	89 d0                	mov    %edx,%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 18          	sub    $0x18,%rsp
  80104b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801053:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801057:	eb 0f                	jmp    801068 <strncmp+0x25>
		n--, p++, q++;
  801059:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80105e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801063:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801068:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80106d:	74 1d                	je     80108c <strncmp+0x49>
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	84 c0                	test   %al,%al
  801078:	74 12                	je     80108c <strncmp+0x49>
  80107a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107e:	0f b6 10             	movzbl (%rax),%edx
  801081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801085:	0f b6 00             	movzbl (%rax),%eax
  801088:	38 c2                	cmp    %al,%dl
  80108a:	74 cd                	je     801059 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80108c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801091:	75 07                	jne    80109a <strncmp+0x57>
		return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	eb 18                	jmp    8010b2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	0f b6 d0             	movzbl %al,%edx
  8010a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a8:	0f b6 00             	movzbl (%rax),%eax
  8010ab:	0f b6 c0             	movzbl %al,%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
}
  8010b2:	c9                   	leaveq 
  8010b3:	c3                   	retq   

00000000008010b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b4:	55                   	push   %rbp
  8010b5:	48 89 e5             	mov    %rsp,%rbp
  8010b8:	48 83 ec 0c          	sub    $0xc,%rsp
  8010bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c0:	89 f0                	mov    %esi,%eax
  8010c2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010c5:	eb 17                	jmp    8010de <strchr+0x2a>
		if (*s == c)
  8010c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cb:	0f b6 00             	movzbl (%rax),%eax
  8010ce:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010d1:	75 06                	jne    8010d9 <strchr+0x25>
			return (char *) s;
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d7:	eb 15                	jmp    8010ee <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e2:	0f b6 00             	movzbl (%rax),%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 de                	jne    8010c7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leaveq 
  8010ef:	c3                   	retq   

00000000008010f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	48 83 ec 0c          	sub    $0xc,%rsp
  8010f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fc:	89 f0                	mov    %esi,%eax
  8010fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801101:	eb 13                	jmp    801116 <strfind+0x26>
		if (*s == c)
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80110d:	75 02                	jne    801111 <strfind+0x21>
			break;
  80110f:	eb 10                	jmp    801121 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801111:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	75 e2                	jne    801103 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 18          	sub    $0x18,%rsp
  80112f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801133:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801136:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80113a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80113f:	75 06                	jne    801147 <memset+0x20>
		return v;
  801141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801145:	eb 69                	jmp    8011b0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114b:	83 e0 03             	and    $0x3,%eax
  80114e:	48 85 c0             	test   %rax,%rax
  801151:	75 48                	jne    80119b <memset+0x74>
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801157:	83 e0 03             	and    $0x3,%eax
  80115a:	48 85 c0             	test   %rax,%rax
  80115d:	75 3c                	jne    80119b <memset+0x74>
		c &= 0xFF;
  80115f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801166:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801169:	c1 e0 18             	shl    $0x18,%eax
  80116c:	89 c2                	mov    %eax,%edx
  80116e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801171:	c1 e0 10             	shl    $0x10,%eax
  801174:	09 c2                	or     %eax,%edx
  801176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801179:	c1 e0 08             	shl    $0x8,%eax
  80117c:	09 d0                	or     %edx,%eax
  80117e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 c1 e8 02          	shr    $0x2,%rax
  801189:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80118c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801190:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801193:	48 89 d7             	mov    %rdx,%rdi
  801196:	fc                   	cld    
  801197:	f3 ab                	rep stos %eax,%es:(%rdi)
  801199:	eb 11                	jmp    8011ac <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80119b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80119f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011a6:	48 89 d7             	mov    %rdx,%rdi
  8011a9:	fc                   	cld    
  8011aa:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 28          	sub    $0x28,%rsp
  8011ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011de:	0f 83 88 00 00 00    	jae    80126c <memmove+0xba>
  8011e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ec:	48 01 d0             	add    %rdx,%rax
  8011ef:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f3:	76 77                	jbe    80126c <memmove+0xba>
		s += n;
  8011f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801201:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	83 e0 03             	and    $0x3,%eax
  80120c:	48 85 c0             	test   %rax,%rax
  80120f:	75 3b                	jne    80124c <memmove+0x9a>
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	83 e0 03             	and    $0x3,%eax
  801218:	48 85 c0             	test   %rax,%rax
  80121b:	75 2f                	jne    80124c <memmove+0x9a>
  80121d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 23                	jne    80124c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	48 83 e8 04          	sub    $0x4,%rax
  801231:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801235:	48 83 ea 04          	sub    $0x4,%rdx
  801239:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80123d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 89 d6             	mov    %rdx,%rsi
  801247:	fd                   	std    
  801248:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80124a:	eb 1d                	jmp    801269 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80124c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801250:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80125c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801260:	48 89 d7             	mov    %rdx,%rdi
  801263:	48 89 c1             	mov    %rax,%rcx
  801266:	fd                   	std    
  801267:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801269:	fc                   	cld    
  80126a:	eb 57                	jmp    8012c3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	83 e0 03             	and    $0x3,%eax
  801273:	48 85 c0             	test   %rax,%rax
  801276:	75 36                	jne    8012ae <memmove+0xfc>
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	83 e0 03             	and    $0x3,%eax
  80127f:	48 85 c0             	test   %rax,%rax
  801282:	75 2a                	jne    8012ae <memmove+0xfc>
  801284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801288:	83 e0 03             	and    $0x3,%eax
  80128b:	48 85 c0             	test   %rax,%rax
  80128e:	75 1e                	jne    8012ae <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801294:	48 c1 e8 02          	shr    $0x2,%rax
  801298:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a3:	48 89 c7             	mov    %rax,%rdi
  8012a6:	48 89 d6             	mov    %rdx,%rsi
  8012a9:	fc                   	cld    
  8012aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ac:	eb 15                	jmp    8012c3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012ba:	48 89 c7             	mov    %rax,%rdi
  8012bd:	48 89 d6             	mov    %rdx,%rsi
  8012c0:	fc                   	cld    
  8012c1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 18          	sub    $0x18,%rsp
  8012d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e9:	48 89 ce             	mov    %rcx,%rsi
  8012ec:	48 89 c7             	mov    %rax,%rdi
  8012ef:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 28          	sub    $0x28,%rsp
  801305:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801321:	eb 36                	jmp    801359 <memcmp+0x5c>
		if (*s1 != *s2)
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	0f b6 10             	movzbl (%rax),%edx
  80132a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	38 c2                	cmp    %al,%dl
  801333:	74 1a                	je     80134f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	0f b6 d0             	movzbl %al,%edx
  80133f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801343:	0f b6 00             	movzbl (%rax),%eax
  801346:	0f b6 c0             	movzbl %al,%eax
  801349:	29 c2                	sub    %eax,%edx
  80134b:	89 d0                	mov    %edx,%eax
  80134d:	eb 20                	jmp    80136f <memcmp+0x72>
		s1++, s2++;
  80134f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801354:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801361:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801365:	48 85 c0             	test   %rax,%rax
  801368:	75 b9                	jne    801323 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136f:	c9                   	leaveq 
  801370:	c3                   	retq   

0000000000801371 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801371:	55                   	push   %rbp
  801372:	48 89 e5             	mov    %rsp,%rbp
  801375:	48 83 ec 28          	sub    $0x28,%rsp
  801379:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801380:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80138c:	48 01 d0             	add    %rdx,%rax
  80138f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801393:	eb 15                	jmp    8013aa <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	0f b6 10             	movzbl (%rax),%edx
  80139c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80139f:	38 c2                	cmp    %al,%dl
  8013a1:	75 02                	jne    8013a5 <memfind+0x34>
			break;
  8013a3:	eb 0f                	jmp    8013b4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013b2:	72 e1                	jb     801395 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 34          	sub    $0x34,%rsp
  8013c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ca:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013d4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013db:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013dc:	eb 05                	jmp    8013e3 <strtol+0x29>
		s++;
  8013de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	3c 20                	cmp    $0x20,%al
  8013ec:	74 f0                	je     8013de <strtol+0x24>
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	3c 09                	cmp    $0x9,%al
  8013f7:	74 e5                	je     8013de <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	0f b6 00             	movzbl (%rax),%eax
  801400:	3c 2b                	cmp    $0x2b,%al
  801402:	75 07                	jne    80140b <strtol+0x51>
		s++;
  801404:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801409:	eb 17                	jmp    801422 <strtol+0x68>
	else if (*s == '-')
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3c 2d                	cmp    $0x2d,%al
  801414:	75 0c                	jne    801422 <strtol+0x68>
		s++, neg = 1;
  801416:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80141b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801422:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801426:	74 06                	je     80142e <strtol+0x74>
  801428:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80142c:	75 28                	jne    801456 <strtol+0x9c>
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	3c 30                	cmp    $0x30,%al
  801437:	75 1d                	jne    801456 <strtol+0x9c>
  801439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143d:	48 83 c0 01          	add    $0x1,%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 78                	cmp    $0x78,%al
  801446:	75 0e                	jne    801456 <strtol+0x9c>
		s += 2, base = 16;
  801448:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80144d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801454:	eb 2c                	jmp    801482 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801456:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80145a:	75 19                	jne    801475 <strtol+0xbb>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	3c 30                	cmp    $0x30,%al
  801465:	75 0e                	jne    801475 <strtol+0xbb>
		s++, base = 8;
  801467:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801473:	eb 0d                	jmp    801482 <strtol+0xc8>
	else if (base == 0)
  801475:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801479:	75 07                	jne    801482 <strtol+0xc8>
		base = 10;
  80147b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	3c 2f                	cmp    $0x2f,%al
  80148b:	7e 1d                	jle    8014aa <strtol+0xf0>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 39                	cmp    $0x39,%al
  801496:	7f 12                	jg     8014aa <strtol+0xf0>
			dig = *s - '0';
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 30             	sub    $0x30,%eax
  8014a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a8:	eb 4e                	jmp    8014f8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 60                	cmp    $0x60,%al
  8014b3:	7e 1d                	jle    8014d2 <strtol+0x118>
  8014b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	3c 7a                	cmp    $0x7a,%al
  8014be:	7f 12                	jg     8014d2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c4:	0f b6 00             	movzbl (%rax),%eax
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	83 e8 57             	sub    $0x57,%eax
  8014cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014d0:	eb 26                	jmp    8014f8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	3c 40                	cmp    $0x40,%al
  8014db:	7e 48                	jle    801525 <strtol+0x16b>
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 5a                	cmp    $0x5a,%al
  8014e6:	7f 3d                	jg     801525 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	0f be c0             	movsbl %al,%eax
  8014f2:	83 e8 37             	sub    $0x37,%eax
  8014f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014fe:	7c 02                	jl     801502 <strtol+0x148>
			break;
  801500:	eb 23                	jmp    801525 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801502:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801507:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80150a:	48 98                	cltq   
  80150c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801511:	48 89 c2             	mov    %rax,%rdx
  801514:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801517:	48 98                	cltq   
  801519:	48 01 d0             	add    %rdx,%rax
  80151c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801520:	e9 5d ff ff ff       	jmpq   801482 <strtol+0xc8>

	if (endptr)
  801525:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80152a:	74 0b                	je     801537 <strtol+0x17d>
		*endptr = (char *) s;
  80152c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801530:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801534:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801537:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80153b:	74 09                	je     801546 <strtol+0x18c>
  80153d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801541:	48 f7 d8             	neg    %rax
  801544:	eb 04                	jmp    80154a <strtol+0x190>
  801546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <strstr>:

char * strstr(const char *in, const char *str)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 30          	sub    $0x30,%rsp
  801554:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801558:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80155c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801560:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801564:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80156e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801572:	75 06                	jne    80157a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	eb 6b                	jmp    8015e5 <strstr+0x99>

	len = strlen(str);
  80157a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157e:	48 89 c7             	mov    %rax,%rdi
  801581:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  801588:	00 00 00 
  80158b:	ff d0                	callq  *%rax
  80158d:	48 98                	cltq   
  80158f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80159b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015a5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015a9:	75 07                	jne    8015b2 <strstr+0x66>
				return (char *) 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	eb 33                	jmp    8015e5 <strstr+0x99>
		} while (sc != c);
  8015b2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015b6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015b9:	75 d8                	jne    801593 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015bf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	48 89 ce             	mov    %rcx,%rsi
  8015ca:	48 89 c7             	mov    %rax,%rdi
  8015cd:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	callq  *%rax
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 b6                	jne    801593 <strstr+0x47>

	return (char *) (in - 1);
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	48 83 e8 01          	sub    $0x1,%rax
}
  8015e5:	c9                   	leaveq 
  8015e6:	c3                   	retq   

00000000008015e7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015e7:	55                   	push   %rbp
  8015e8:	48 89 e5             	mov    %rsp,%rbp
  8015eb:	53                   	push   %rbx
  8015ec:	48 83 ec 48          	sub    $0x48,%rsp
  8015f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015f3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015f6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015fa:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015fe:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801602:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801606:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801609:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80160d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801611:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801615:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801619:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80161d:	4c 89 c3             	mov    %r8,%rbx
  801620:	cd 30                	int    $0x30
  801622:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801626:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80162a:	74 3e                	je     80166a <syscall+0x83>
  80162c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801631:	7e 37                	jle    80166a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801637:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80163a:	49 89 d0             	mov    %rdx,%r8
  80163d:	89 c1                	mov    %eax,%ecx
  80163f:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  801646:	00 00 00 
  801649:	be 23 00 00 00       	mov    $0x23,%esi
  80164e:	48 bf 85 44 80 00 00 	movabs $0x804485,%rdi
  801655:	00 00 00 
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
  80165d:	49 b9 82 3b 80 00 00 	movabs $0x803b82,%r9
  801664:	00 00 00 
  801667:	41 ff d1             	callq  *%r9

	return ret;
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80166e:	48 83 c4 48          	add    $0x48,%rsp
  801672:	5b                   	pop    %rbx
  801673:	5d                   	pop    %rbp
  801674:	c3                   	retq   

0000000000801675 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 20          	sub    $0x20,%rsp
  80167d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801681:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801689:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80168d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801694:	00 
  801695:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a1:	48 89 d1             	mov    %rdx,%rcx
  8016a4:	48 89 c2             	mov    %rax,%rdx
  8016a7:	be 00 00 00 00       	mov    $0x0,%esi
  8016ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b1:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8016b8:	00 00 00 
  8016bb:	ff d0                	callq  *%rax
}
  8016bd:	c9                   	leaveq 
  8016be:	c3                   	retq   

00000000008016bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8016bf:	55                   	push   %rbp
  8016c0:	48 89 e5             	mov    %rsp,%rbp
  8016c3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ce:	00 
  8016cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8016ef:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8016f6:	00 00 00 
  8016f9:	ff d0                	callq  *%rax
}
  8016fb:	c9                   	leaveq 
  8016fc:	c3                   	retq   

00000000008016fd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016fd:	55                   	push   %rbp
  8016fe:	48 89 e5             	mov    %rsp,%rbp
  801701:	48 83 ec 10          	sub    $0x10,%rsp
  801705:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80170b:	48 98                	cltq   
  80170d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801714:	00 
  801715:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801721:	b9 00 00 00 00       	mov    $0x0,%ecx
  801726:	48 89 c2             	mov    %rax,%rdx
  801729:	be 01 00 00 00       	mov    $0x1,%esi
  80172e:	bf 03 00 00 00       	mov    $0x3,%edi
  801733:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	callq  *%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801749:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801750:	00 
  801751:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801757:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80175d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	be 00 00 00 00       	mov    $0x0,%esi
  80176c:	bf 02 00 00 00       	mov    $0x2,%edi
  801771:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801778:	00 00 00 
  80177b:	ff d0                	callq  *%rax
}
  80177d:	c9                   	leaveq 
  80177e:	c3                   	retq   

000000000080177f <sys_yield>:

void
sys_yield(void)
{
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801787:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178e:	00 
  80178f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801795:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	be 00 00 00 00       	mov    $0x0,%esi
  8017aa:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017af:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	callq  *%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	48 83 ec 20          	sub    $0x20,%rsp
  8017c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d2:	48 63 c8             	movslq %eax,%rcx
  8017d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017dc:	48 98                	cltq   
  8017de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e5:	00 
  8017e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ec:	49 89 c8             	mov    %rcx,%r8
  8017ef:	48 89 d1             	mov    %rdx,%rcx
  8017f2:	48 89 c2             	mov    %rax,%rdx
  8017f5:	be 01 00 00 00       	mov    $0x1,%esi
  8017fa:	bf 04 00 00 00       	mov    $0x4,%edi
  8017ff:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801806:	00 00 00 
  801809:	ff d0                	callq  *%rax
}
  80180b:	c9                   	leaveq 
  80180c:	c3                   	retq   

000000000080180d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80180d:	55                   	push   %rbp
  80180e:	48 89 e5             	mov    %rsp,%rbp
  801811:	48 83 ec 30          	sub    $0x30,%rsp
  801815:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801818:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80181f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801823:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801827:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80182a:	48 63 c8             	movslq %eax,%rcx
  80182d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801831:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801834:	48 63 f0             	movslq %eax,%rsi
  801837:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80183e:	48 98                	cltq   
  801840:	48 89 0c 24          	mov    %rcx,(%rsp)
  801844:	49 89 f9             	mov    %rdi,%r9
  801847:	49 89 f0             	mov    %rsi,%r8
  80184a:	48 89 d1             	mov    %rdx,%rcx
  80184d:	48 89 c2             	mov    %rax,%rdx
  801850:	be 01 00 00 00       	mov    $0x1,%esi
  801855:	bf 05 00 00 00       	mov    $0x5,%edi
  80185a:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801861:	00 00 00 
  801864:	ff d0                	callq  *%rax
}
  801866:	c9                   	leaveq 
  801867:	c3                   	retq   

0000000000801868 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 20          	sub    $0x20,%rsp
  801870:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801873:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801877:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187e:	48 98                	cltq   
  801880:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801887:	00 
  801888:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801894:	48 89 d1             	mov    %rdx,%rcx
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	be 01 00 00 00       	mov    $0x1,%esi
  80189f:	bf 06 00 00 00       	mov    $0x6,%edi
  8018a4:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
  8018ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018bd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c3:	48 63 d0             	movslq %eax,%rdx
  8018c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c9:	48 98                	cltq   
  8018cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d2:	00 
  8018d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018df:	48 89 d1             	mov    %rdx,%rcx
  8018e2:	48 89 c2             	mov    %rax,%rdx
  8018e5:	be 01 00 00 00       	mov    $0x1,%esi
  8018ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8018ef:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 20          	sub    $0x20,%rsp
  801905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801908:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80190c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801913:	48 98                	cltq   
  801915:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191c:	00 
  80191d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801923:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801929:	48 89 d1             	mov    %rdx,%rcx
  80192c:	48 89 c2             	mov    %rax,%rdx
  80192f:	be 01 00 00 00       	mov    $0x1,%esi
  801934:	bf 09 00 00 00       	mov    $0x9,%edi
  801939:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
}
  801945:	c9                   	leaveq 
  801946:	c3                   	retq   

0000000000801947 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801947:	55                   	push   %rbp
  801948:	48 89 e5             	mov    %rsp,%rbp
  80194b:	48 83 ec 20          	sub    $0x20,%rsp
  80194f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801952:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195d:	48 98                	cltq   
  80195f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801966:	00 
  801967:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801973:	48 89 d1             	mov    %rdx,%rcx
  801976:	48 89 c2             	mov    %rax,%rdx
  801979:	be 01 00 00 00       	mov    $0x1,%esi
  80197e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801983:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	callq  *%rax
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 20          	sub    $0x20,%rsp
  801999:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019aa:	48 63 f0             	movslq %eax,%rsi
  8019ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b4:	48 98                	cltq   
  8019b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c1:	00 
  8019c2:	49 89 f1             	mov    %rsi,%r9
  8019c5:	49 89 c8             	mov    %rcx,%r8
  8019c8:	48 89 d1             	mov    %rdx,%rcx
  8019cb:	48 89 c2             	mov    %rax,%rdx
  8019ce:	be 00 00 00 00       	mov    $0x0,%esi
  8019d3:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019d8:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 10          	sub    $0x10,%rsp
  8019ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fd:	00 
  8019fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a1c:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 20          	sub    $0x20,%rsp
  801a32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a49:	00 
  801a4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a56:	48 89 d1             	mov    %rdx,%rcx
  801a59:	48 89 c2             	mov    %rax,%rdx
  801a5c:	be 01 00 00 00       	mov    $0x1,%esi
  801a61:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a66:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	callq  *%rax
}
  801a72:	c9                   	leaveq 
  801a73:	c3                   	retq   

0000000000801a74 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801a74:	55                   	push   %rbp
  801a75:	48 89 e5             	mov    %rsp,%rbp
  801a78:	48 83 ec 10          	sub    $0x10,%rsp
  801a7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8b:	00 
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	bf 10 00 00 00       	mov    $0x10,%edi
  801aaa:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ac0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac7:	00 
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ae8:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 08          	sub    $0x8,%rsp
  801afe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b06:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b0d:	ff ff ff 
  801b10:	48 01 d0             	add    %rdx,%rax
  801b13:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b17:	c9                   	leaveq 
  801b18:	c3                   	retq   

0000000000801b19 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b19:	55                   	push   %rbp
  801b1a:	48 89 e5             	mov    %rsp,%rbp
  801b1d:	48 83 ec 08          	sub    $0x8,%rsp
  801b21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b29:	48 89 c7             	mov    %rax,%rdi
  801b2c:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801b33:	00 00 00 
  801b36:	ff d0                	callq  *%rax
  801b38:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b3e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b42:	c9                   	leaveq 
  801b43:	c3                   	retq   

0000000000801b44 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b44:	55                   	push   %rbp
  801b45:	48 89 e5             	mov    %rsp,%rbp
  801b48:	48 83 ec 18          	sub    $0x18,%rsp
  801b4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b57:	eb 6b                	jmp    801bc4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5c:	48 98                	cltq   
  801b5e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b64:	48 c1 e0 0c          	shl    $0xc,%rax
  801b68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b70:	48 c1 e8 15          	shr    $0x15,%rax
  801b74:	48 89 c2             	mov    %rax,%rdx
  801b77:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b7e:	01 00 00 
  801b81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b85:	83 e0 01             	and    $0x1,%eax
  801b88:	48 85 c0             	test   %rax,%rax
  801b8b:	74 21                	je     801bae <fd_alloc+0x6a>
  801b8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b91:	48 c1 e8 0c          	shr    $0xc,%rax
  801b95:	48 89 c2             	mov    %rax,%rdx
  801b98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b9f:	01 00 00 
  801ba2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ba6:	83 e0 01             	and    $0x1,%eax
  801ba9:	48 85 c0             	test   %rax,%rax
  801bac:	75 12                	jne    801bc0 <fd_alloc+0x7c>
			*fd_store = fd;
  801bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbe:	eb 1a                	jmp    801bda <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bc4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bc8:	7e 8f                	jle    801b59 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801bd5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801bda:	c9                   	leaveq 
  801bdb:	c3                   	retq   

0000000000801bdc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801bdc:	55                   	push   %rbp
  801bdd:	48 89 e5             	mov    %rsp,%rbp
  801be0:	48 83 ec 20          	sub    $0x20,%rsp
  801be4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801be7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bef:	78 06                	js     801bf7 <fd_lookup+0x1b>
  801bf1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801bf5:	7e 07                	jle    801bfe <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bfc:	eb 6c                	jmp    801c6a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801bfe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c01:	48 98                	cltq   
  801c03:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c09:	48 c1 e0 0c          	shl    $0xc,%rax
  801c0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c15:	48 c1 e8 15          	shr    $0x15,%rax
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c23:	01 00 00 
  801c26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2a:	83 e0 01             	and    $0x1,%eax
  801c2d:	48 85 c0             	test   %rax,%rax
  801c30:	74 21                	je     801c53 <fd_lookup+0x77>
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	48 c1 e8 0c          	shr    $0xc,%rax
  801c3a:	48 89 c2             	mov    %rax,%rdx
  801c3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c44:	01 00 00 
  801c47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4b:	83 e0 01             	and    $0x1,%eax
  801c4e:	48 85 c0             	test   %rax,%rax
  801c51:	75 07                	jne    801c5a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c58:	eb 10                	jmp    801c6a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c62:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	c9                   	leaveq 
  801c6b:	c3                   	retq   

0000000000801c6c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 30          	sub    $0x30,%rsp
  801c74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c78:	89 f0                	mov    %esi,%eax
  801c7a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c81:	48 89 c7             	mov    %rax,%rdi
  801c84:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
  801c90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c94:	48 89 d6             	mov    %rdx,%rsi
  801c97:	89 c7                	mov    %eax,%edi
  801c99:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
  801ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cac:	78 0a                	js     801cb8 <fd_close+0x4c>
	    || fd != fd2)
  801cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cb6:	74 12                	je     801cca <fd_close+0x5e>
		return (must_exist ? r : 0);
  801cb8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cbc:	74 05                	je     801cc3 <fd_close+0x57>
  801cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc1:	eb 05                	jmp    801cc8 <fd_close+0x5c>
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb 69                	jmp    801d33 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cce:	8b 00                	mov    (%rax),%eax
  801cd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cd4:	48 89 d6             	mov    %rdx,%rsi
  801cd7:	89 c7                	mov    %eax,%edi
  801cd9:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  801ce0:	00 00 00 
  801ce3:	ff d0                	callq  *%rax
  801ce5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cec:	78 2a                	js     801d18 <fd_close+0xac>
		if (dev->dev_close)
  801cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf2:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cf6:	48 85 c0             	test   %rax,%rax
  801cf9:	74 16                	je     801d11 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cff:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d07:	48 89 d7             	mov    %rdx,%rdi
  801d0a:	ff d0                	callq  *%rax
  801d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d0f:	eb 07                	jmp    801d18 <fd_close+0xac>
		else
			r = 0;
  801d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1c:	48 89 c6             	mov    %rax,%rsi
  801d1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d24:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
	return r;
  801d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d33:	c9                   	leaveq 
  801d34:	c3                   	retq   

0000000000801d35 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	48 83 ec 20          	sub    $0x20,%rsp
  801d3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d4b:	eb 41                	jmp    801d8e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d4d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d54:	00 00 00 
  801d57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d5a:	48 63 d2             	movslq %edx,%rdx
  801d5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d61:	8b 00                	mov    (%rax),%eax
  801d63:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d66:	75 22                	jne    801d8a <dev_lookup+0x55>
			*dev = devtab[i];
  801d68:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d6f:	00 00 00 
  801d72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d75:	48 63 d2             	movslq %edx,%rdx
  801d78:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801d7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d80:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d83:	b8 00 00 00 00       	mov    $0x0,%eax
  801d88:	eb 60                	jmp    801dea <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d8e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d95:	00 00 00 
  801d98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d9b:	48 63 d2             	movslq %edx,%rdx
  801d9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da2:	48 85 c0             	test   %rax,%rax
  801da5:	75 a6                	jne    801d4d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801da7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801dae:	00 00 00 
  801db1:	48 8b 00             	mov    (%rax),%rax
  801db4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801dba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dbd:	89 c6                	mov    %eax,%esi
  801dbf:	48 bf 98 44 80 00 00 	movabs $0x804498,%rdi
  801dc6:	00 00 00 
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  801dd5:	00 00 00 
  801dd8:	ff d1                	callq  *%rcx
	*dev = 0;
  801dda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dde:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801de5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <close>:

int
close(int fdnum)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 20          	sub    $0x20,%rsp
  801df4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801df7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dfb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dfe:	48 89 d6             	mov    %rdx,%rsi
  801e01:	89 c7                	mov    %eax,%edi
  801e03:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
  801e0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e16:	79 05                	jns    801e1d <close+0x31>
		return r;
  801e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1b:	eb 18                	jmp    801e35 <close+0x49>
	else
		return fd_close(fd, 1);
  801e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e21:	be 01 00 00 00       	mov    $0x1,%esi
  801e26:	48 89 c7             	mov    %rax,%rdi
  801e29:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax
}
  801e35:	c9                   	leaveq 
  801e36:	c3                   	retq   

0000000000801e37 <close_all>:

void
close_all(void)
{
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e46:	eb 15                	jmp    801e5d <close_all+0x26>
		close(i);
  801e48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e5d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e61:	7e e5                	jle    801e48 <close_all+0x11>
		close(i);
}
  801e63:	c9                   	leaveq 
  801e64:	c3                   	retq   

0000000000801e65 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e65:	55                   	push   %rbp
  801e66:	48 89 e5             	mov    %rsp,%rbp
  801e69:	48 83 ec 40          	sub    $0x40,%rsp
  801e6d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e70:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e73:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801e77:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e7a:	48 89 d6             	mov    %rdx,%rsi
  801e7d:	89 c7                	mov    %eax,%edi
  801e7f:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  801e86:	00 00 00 
  801e89:	ff d0                	callq  *%rax
  801e8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e92:	79 08                	jns    801e9c <dup+0x37>
		return r;
  801e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e97:	e9 70 01 00 00       	jmpq   80200c <dup+0x1a7>
	close(newfdnum);
  801e9c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e9f:	89 c7                	mov    %eax,%edi
  801ea1:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ead:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801eb0:	48 98                	cltq   
  801eb2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eb8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ebc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ec0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec4:	48 89 c7             	mov    %rax,%rdi
  801ec7:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edb:	48 89 c7             	mov    %rax,%rdi
  801ede:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
  801eea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef2:	48 c1 e8 15          	shr    $0x15,%rax
  801ef6:	48 89 c2             	mov    %rax,%rdx
  801ef9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f00:	01 00 00 
  801f03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f07:	83 e0 01             	and    $0x1,%eax
  801f0a:	48 85 c0             	test   %rax,%rax
  801f0d:	74 73                	je     801f82 <dup+0x11d>
  801f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f13:	48 c1 e8 0c          	shr    $0xc,%rax
  801f17:	48 89 c2             	mov    %rax,%rdx
  801f1a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f21:	01 00 00 
  801f24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f28:	83 e0 01             	and    $0x1,%eax
  801f2b:	48 85 c0             	test   %rax,%rax
  801f2e:	74 52                	je     801f82 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f34:	48 c1 e8 0c          	shr    $0xc,%rax
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f42:	01 00 00 
  801f45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f49:	25 07 0e 00 00       	and    $0xe07,%eax
  801f4e:	89 c1                	mov    %eax,%ecx
  801f50:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f58:	41 89 c8             	mov    %ecx,%r8d
  801f5b:	48 89 d1             	mov    %rdx,%rcx
  801f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f63:	48 89 c6             	mov    %rax,%rsi
  801f66:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6b:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
  801f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7e:	79 02                	jns    801f82 <dup+0x11d>
			goto err;
  801f80:	eb 57                	jmp    801fd9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f86:	48 c1 e8 0c          	shr    $0xc,%rax
  801f8a:	48 89 c2             	mov    %rax,%rdx
  801f8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f94:	01 00 00 
  801f97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9b:	25 07 0e 00 00       	and    $0xe07,%eax
  801fa0:	89 c1                	mov    %eax,%ecx
  801fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801faa:	41 89 c8             	mov    %ecx,%r8d
  801fad:	48 89 d1             	mov    %rdx,%rcx
  801fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb5:	48 89 c6             	mov    %rax,%rsi
  801fb8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbd:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  801fc4:	00 00 00 
  801fc7:	ff d0                	callq  *%rax
  801fc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd0:	79 02                	jns    801fd4 <dup+0x16f>
		goto err;
  801fd2:	eb 05                	jmp    801fd9 <dup+0x174>

	return newfdnum;
  801fd4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fd7:	eb 33                	jmp    80200c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdd:	48 89 c6             	mov    %rax,%rsi
  801fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe5:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801fec:	00 00 00 
  801fef:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801ff1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff5:	48 89 c6             	mov    %rax,%rsi
  801ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffd:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802004:	00 00 00 
  802007:	ff d0                	callq  *%rax
	return r;
  802009:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80200c:	c9                   	leaveq 
  80200d:	c3                   	retq   

000000000080200e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80200e:	55                   	push   %rbp
  80200f:	48 89 e5             	mov    %rsp,%rbp
  802012:	48 83 ec 40          	sub    $0x40,%rsp
  802016:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802019:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80201d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802021:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802025:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802028:	48 89 d6             	mov    %rdx,%rsi
  80202b:	89 c7                	mov    %eax,%edi
  80202d:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
  802039:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80203c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802040:	78 24                	js     802066 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802046:	8b 00                	mov    (%rax),%eax
  802048:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80204c:	48 89 d6             	mov    %rdx,%rsi
  80204f:	89 c7                	mov    %eax,%edi
  802051:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802064:	79 05                	jns    80206b <read+0x5d>
		return r;
  802066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802069:	eb 76                	jmp    8020e1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	8b 40 08             	mov    0x8(%rax),%eax
  802072:	83 e0 03             	and    $0x3,%eax
  802075:	83 f8 01             	cmp    $0x1,%eax
  802078:	75 3a                	jne    8020b4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80207a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802081:	00 00 00 
  802084:	48 8b 00             	mov    (%rax),%rax
  802087:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80208d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802090:	89 c6                	mov    %eax,%esi
  802092:	48 bf b7 44 80 00 00 	movabs $0x8044b7,%rdi
  802099:	00 00 00 
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  8020a8:	00 00 00 
  8020ab:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020b2:	eb 2d                	jmp    8020e1 <read+0xd3>
	}
	if (!dev->dev_read)
  8020b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020bc:	48 85 c0             	test   %rax,%rax
  8020bf:	75 07                	jne    8020c8 <read+0xba>
		return -E_NOT_SUPP;
  8020c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020c6:	eb 19                	jmp    8020e1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8020c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020d8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8020dc:	48 89 cf             	mov    %rcx,%rdi
  8020df:	ff d0                	callq  *%rax
}
  8020e1:	c9                   	leaveq 
  8020e2:	c3                   	retq   

00000000008020e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020e3:	55                   	push   %rbp
  8020e4:	48 89 e5             	mov    %rsp,%rbp
  8020e7:	48 83 ec 30          	sub    $0x30,%rsp
  8020eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020fd:	eb 49                	jmp    802148 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802102:	48 98                	cltq   
  802104:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802108:	48 29 c2             	sub    %rax,%rdx
  80210b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210e:	48 63 c8             	movslq %eax,%rcx
  802111:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802115:	48 01 c1             	add    %rax,%rcx
  802118:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211b:	48 89 ce             	mov    %rcx,%rsi
  80211e:	89 c7                	mov    %eax,%edi
  802120:	48 b8 0e 20 80 00 00 	movabs $0x80200e,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax
  80212c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80212f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802133:	79 05                	jns    80213a <readn+0x57>
			return m;
  802135:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802138:	eb 1c                	jmp    802156 <readn+0x73>
		if (m == 0)
  80213a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80213e:	75 02                	jne    802142 <readn+0x5f>
			break;
  802140:	eb 11                	jmp    802153 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802142:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802145:	01 45 fc             	add    %eax,-0x4(%rbp)
  802148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214b:	48 98                	cltq   
  80214d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802151:	72 ac                	jb     8020ff <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802153:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802156:	c9                   	leaveq 
  802157:	c3                   	retq   

0000000000802158 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802158:	55                   	push   %rbp
  802159:	48 89 e5             	mov    %rsp,%rbp
  80215c:	48 83 ec 40          	sub    $0x40,%rsp
  802160:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802163:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802167:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80216b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80216f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802172:	48 89 d6             	mov    %rdx,%rsi
  802175:	89 c7                	mov    %eax,%edi
  802177:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  80217e:	00 00 00 
  802181:	ff d0                	callq  *%rax
  802183:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802186:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218a:	78 24                	js     8021b0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80218c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802190:	8b 00                	mov    (%rax),%eax
  802192:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802196:	48 89 d6             	mov    %rdx,%rsi
  802199:	89 c7                	mov    %eax,%edi
  80219b:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	callq  *%rax
  8021a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ae:	79 05                	jns    8021b5 <write+0x5d>
		return r;
  8021b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b3:	eb 75                	jmp    80222a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b9:	8b 40 08             	mov    0x8(%rax),%eax
  8021bc:	83 e0 03             	and    $0x3,%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 3a                	jne    8021fd <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021c3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ca:	00 00 00 
  8021cd:	48 8b 00             	mov    (%rax),%rax
  8021d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021d9:	89 c6                	mov    %eax,%esi
  8021db:	48 bf d3 44 80 00 00 	movabs $0x8044d3,%rdi
  8021e2:	00 00 00 
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  8021f1:	00 00 00 
  8021f4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021fb:	eb 2d                	jmp    80222a <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8021fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802201:	48 8b 40 18          	mov    0x18(%rax),%rax
  802205:	48 85 c0             	test   %rax,%rax
  802208:	75 07                	jne    802211 <write+0xb9>
		return -E_NOT_SUPP;
  80220a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80220f:	eb 19                	jmp    80222a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802215:	48 8b 40 18          	mov    0x18(%rax),%rax
  802219:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80221d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802221:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802225:	48 89 cf             	mov    %rcx,%rdi
  802228:	ff d0                	callq  *%rax
}
  80222a:	c9                   	leaveq 
  80222b:	c3                   	retq   

000000000080222c <seek>:

int
seek(int fdnum, off_t offset)
{
  80222c:	55                   	push   %rbp
  80222d:	48 89 e5             	mov    %rsp,%rbp
  802230:	48 83 ec 18          	sub    $0x18,%rsp
  802234:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802237:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80223a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80223e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802241:	48 89 d6             	mov    %rdx,%rsi
  802244:	89 c7                	mov    %eax,%edi
  802246:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802259:	79 05                	jns    802260 <seek+0x34>
		return r;
  80225b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225e:	eb 0f                	jmp    80226f <seek+0x43>
	fd->fd_offset = offset;
  802260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802264:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802267:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226f:	c9                   	leaveq 
  802270:	c3                   	retq   

0000000000802271 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802271:	55                   	push   %rbp
  802272:	48 89 e5             	mov    %rsp,%rbp
  802275:	48 83 ec 30          	sub    $0x30,%rsp
  802279:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80227f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802283:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802286:	48 89 d6             	mov    %rdx,%rsi
  802289:	89 c7                	mov    %eax,%edi
  80228b:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax
  802297:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229e:	78 24                	js     8022c4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a4:	8b 00                	mov    (%rax),%eax
  8022a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022aa:	48 89 d6             	mov    %rdx,%rsi
  8022ad:	89 c7                	mov    %eax,%edi
  8022af:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
  8022bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c2:	79 05                	jns    8022c9 <ftruncate+0x58>
		return r;
  8022c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c7:	eb 72                	jmp    80233b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	8b 40 08             	mov    0x8(%rax),%eax
  8022d0:	83 e0 03             	and    $0x3,%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	75 3a                	jne    802311 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8022d7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022de:	00 00 00 
  8022e1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022e4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022ed:	89 c6                	mov    %eax,%esi
  8022ef:	48 bf f0 44 80 00 00 	movabs $0x8044f0,%rdi
  8022f6:	00 00 00 
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  802305:	00 00 00 
  802308:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80230a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80230f:	eb 2a                	jmp    80233b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802315:	48 8b 40 30          	mov    0x30(%rax),%rax
  802319:	48 85 c0             	test   %rax,%rax
  80231c:	75 07                	jne    802325 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80231e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802323:	eb 16                	jmp    80233b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802325:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802329:	48 8b 40 30          	mov    0x30(%rax),%rax
  80232d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802331:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802334:	89 ce                	mov    %ecx,%esi
  802336:	48 89 d7             	mov    %rdx,%rdi
  802339:	ff d0                	callq  *%rax
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	48 83 ec 30          	sub    $0x30,%rsp
  802345:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802348:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80234c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802350:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802353:	48 89 d6             	mov    %rdx,%rsi
  802356:	89 c7                	mov    %eax,%edi
  802358:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  80235f:	00 00 00 
  802362:	ff d0                	callq  *%rax
  802364:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236b:	78 24                	js     802391 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80236d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802371:	8b 00                	mov    (%rax),%eax
  802373:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802377:	48 89 d6             	mov    %rdx,%rsi
  80237a:	89 c7                	mov    %eax,%edi
  80237c:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
  802388:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238f:	79 05                	jns    802396 <fstat+0x59>
		return r;
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802394:	eb 5e                	jmp    8023f4 <fstat+0xb7>
	if (!dev->dev_stat)
  802396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80239e:	48 85 c0             	test   %rax,%rax
  8023a1:	75 07                	jne    8023aa <fstat+0x6d>
		return -E_NOT_SUPP;
  8023a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023a8:	eb 4a                	jmp    8023f4 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ae:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023b5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023bc:	00 00 00 
	stat->st_isdir = 0;
  8023bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023c3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023ca:	00 00 00 
	stat->st_dev = dev;
  8023cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023d5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8023dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023ec:	48 89 ce             	mov    %rcx,%rsi
  8023ef:	48 89 d7             	mov    %rdx,%rdi
  8023f2:	ff d0                	callq  *%rax
}
  8023f4:	c9                   	leaveq 
  8023f5:	c3                   	retq   

00000000008023f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023f6:	55                   	push   %rbp
  8023f7:	48 89 e5             	mov    %rsp,%rbp
  8023fa:	48 83 ec 20          	sub    $0x20,%rsp
  8023fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802402:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240a:	be 00 00 00 00       	mov    $0x0,%esi
  80240f:	48 89 c7             	mov    %rax,%rdi
  802412:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
  80241e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802421:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802425:	79 05                	jns    80242c <stat+0x36>
		return fd;
  802427:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242a:	eb 2f                	jmp    80245b <stat+0x65>
	r = fstat(fd, stat);
  80242c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802430:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802433:	48 89 d6             	mov    %rdx,%rsi
  802436:	89 c7                	mov    %eax,%edi
  802438:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  80243f:	00 00 00 
  802442:	ff d0                	callq  *%rax
  802444:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802447:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80244a:	89 c7                	mov    %eax,%edi
  80244c:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802453:	00 00 00 
  802456:	ff d0                	callq  *%rax
	return r;
  802458:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80245b:	c9                   	leaveq 
  80245c:	c3                   	retq   

000000000080245d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80245d:	55                   	push   %rbp
  80245e:	48 89 e5             	mov    %rsp,%rbp
  802461:	48 83 ec 10          	sub    $0x10,%rsp
  802465:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802468:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80246c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802473:	00 00 00 
  802476:	8b 00                	mov    (%rax),%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	75 1d                	jne    802499 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80247c:	bf 01 00 00 00       	mov    $0x1,%edi
  802481:	48 b8 fe 3d 80 00 00 	movabs $0x803dfe,%rax
  802488:	00 00 00 
  80248b:	ff d0                	callq  *%rax
  80248d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802494:	00 00 00 
  802497:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802499:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024a0:	00 00 00 
  8024a3:	8b 00                	mov    (%rax),%eax
  8024a5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024a8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024ad:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024b4:	00 00 00 
  8024b7:	89 c7                	mov    %eax,%edi
  8024b9:	48 b8 9c 3d 80 00 00 	movabs $0x803d9c,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ce:	48 89 c6             	mov    %rax,%rsi
  8024d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d6:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	callq  *%rax
}
  8024e2:	c9                   	leaveq 
  8024e3:	c3                   	retq   

00000000008024e4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8024e4:	55                   	push   %rbp
  8024e5:	48 89 e5             	mov    %rsp,%rbp
  8024e8:	48 83 ec 30          	sub    $0x30,%rsp
  8024ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024f0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8024f3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8024fa:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802501:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802508:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80250d:	75 08                	jne    802517 <open+0x33>
	{
		return r;
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	e9 f2 00 00 00       	jmpq   802609 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80251b:	48 89 c7             	mov    %rax,%rdi
  80251e:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
  80252a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80252d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802534:	7e 0a                	jle    802540 <open+0x5c>
	{
		return -E_BAD_PATH;
  802536:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80253b:	e9 c9 00 00 00       	jmpq   802609 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802540:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802547:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802548:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80254c:	48 89 c7             	mov    %rax,%rdi
  80254f:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  802556:	00 00 00 
  802559:	ff d0                	callq  *%rax
  80255b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802562:	78 09                	js     80256d <open+0x89>
  802564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802568:	48 85 c0             	test   %rax,%rax
  80256b:	75 08                	jne    802575 <open+0x91>
		{
			return r;
  80256d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802570:	e9 94 00 00 00       	jmpq   802609 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802579:	ba 00 04 00 00       	mov    $0x400,%edx
  80257e:	48 89 c6             	mov    %rax,%rsi
  802581:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802588:	00 00 00 
  80258b:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802597:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80259e:	00 00 00 
  8025a1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8025a4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8025aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ae:	48 89 c6             	mov    %rax,%rsi
  8025b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b6:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	79 2b                	jns    8025f6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8025cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cf:	be 00 00 00 00       	mov    $0x0,%esi
  8025d4:	48 89 c7             	mov    %rax,%rdi
  8025d7:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  8025de:	00 00 00 
  8025e1:	ff d0                	callq  *%rax
  8025e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8025e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025ea:	79 05                	jns    8025f1 <open+0x10d>
			{
				return d;
  8025ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ef:	eb 18                	jmp    802609 <open+0x125>
			}
			return r;
  8025f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f4:	eb 13                	jmp    802609 <open+0x125>
		}	
		return fd2num(fd_store);
  8025f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fa:	48 89 c7             	mov    %rax,%rdi
  8025fd:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802604:	00 00 00 
  802607:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802609:	c9                   	leaveq 
  80260a:	c3                   	retq   

000000000080260b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80260b:	55                   	push   %rbp
  80260c:	48 89 e5             	mov    %rsp,%rbp
  80260f:	48 83 ec 10          	sub    $0x10,%rsp
  802613:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261b:	8b 50 0c             	mov    0xc(%rax),%edx
  80261e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802625:	00 00 00 
  802628:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80262a:	be 00 00 00 00       	mov    $0x0,%esi
  80262f:	bf 06 00 00 00       	mov    $0x6,%edi
  802634:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
}
  802640:	c9                   	leaveq 
  802641:	c3                   	retq   

0000000000802642 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802642:	55                   	push   %rbp
  802643:	48 89 e5             	mov    %rsp,%rbp
  802646:	48 83 ec 30          	sub    $0x30,%rsp
  80264a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802652:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80265d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802662:	74 07                	je     80266b <devfile_read+0x29>
  802664:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802669:	75 07                	jne    802672 <devfile_read+0x30>
		return -E_INVAL;
  80266b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802670:	eb 77                	jmp    8026e9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802676:	8b 50 0c             	mov    0xc(%rax),%edx
  802679:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802680:	00 00 00 
  802683:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802685:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80268c:	00 00 00 
  80268f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802693:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802697:	be 00 00 00 00       	mov    $0x0,%esi
  80269c:	bf 03 00 00 00       	mov    $0x3,%edi
  8026a1:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
  8026ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b4:	7f 05                	jg     8026bb <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8026b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b9:	eb 2e                	jmp    8026e9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8026bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026be:	48 63 d0             	movslq %eax,%rdx
  8026c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026c5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8026cc:	00 00 00 
  8026cf:	48 89 c7             	mov    %rax,%rdi
  8026d2:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8026de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8026e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8026e9:	c9                   	leaveq 
  8026ea:	c3                   	retq   

00000000008026eb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026eb:	55                   	push   %rbp
  8026ec:	48 89 e5             	mov    %rsp,%rbp
  8026ef:	48 83 ec 30          	sub    $0x30,%rsp
  8026f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8026ff:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802706:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80270b:	74 07                	je     802714 <devfile_write+0x29>
  80270d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802712:	75 08                	jne    80271c <devfile_write+0x31>
		return r;
  802714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802717:	e9 9a 00 00 00       	jmpq   8027b6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	8b 50 0c             	mov    0xc(%rax),%edx
  802723:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80272a:	00 00 00 
  80272d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80272f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802736:	00 
  802737:	76 08                	jbe    802741 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802739:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802740:	00 
	}
	fsipcbuf.write.req_n = n;
  802741:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802748:	00 00 00 
  80274b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80274f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802753:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802757:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80275b:	48 89 c6             	mov    %rax,%rsi
  80275e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802765:	00 00 00 
  802768:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  80276f:	00 00 00 
  802772:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802774:	be 00 00 00 00       	mov    $0x0,%esi
  802779:	bf 04 00 00 00       	mov    $0x4,%edi
  80277e:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
  80278a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802791:	7f 20                	jg     8027b3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802793:	48 bf 16 45 80 00 00 	movabs $0x804516,%rdi
  80279a:	00 00 00 
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8027a9:	00 00 00 
  8027ac:	ff d2                	callq  *%rdx
		return r;
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b1:	eb 03                	jmp    8027b6 <devfile_write+0xcb>
	}
	return r;
  8027b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8027b6:	c9                   	leaveq 
  8027b7:	c3                   	retq   

00000000008027b8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027b8:	55                   	push   %rbp
  8027b9:	48 89 e5             	mov    %rsp,%rbp
  8027bc:	48 83 ec 20          	sub    $0x20,%rsp
  8027c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8027cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027d6:	00 00 00 
  8027d9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027db:	be 00 00 00 00       	mov    $0x0,%esi
  8027e0:	bf 05 00 00 00       	mov    $0x5,%edi
  8027e5:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  8027ec:	00 00 00 
  8027ef:	ff d0                	callq  *%rax
  8027f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f8:	79 05                	jns    8027ff <devfile_stat+0x47>
		return r;
  8027fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fd:	eb 56                	jmp    802855 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802803:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80280a:	00 00 00 
  80280d:	48 89 c7             	mov    %rax,%rdi
  802810:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80281c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802823:	00 00 00 
  802826:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80282c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802830:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802836:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283d:	00 00 00 
  802840:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802846:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802855:	c9                   	leaveq 
  802856:	c3                   	retq   

0000000000802857 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802857:	55                   	push   %rbp
  802858:	48 89 e5             	mov    %rsp,%rbp
  80285b:	48 83 ec 10          	sub    $0x10,%rsp
  80285f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802863:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80286a:	8b 50 0c             	mov    0xc(%rax),%edx
  80286d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802874:	00 00 00 
  802877:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802879:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802880:	00 00 00 
  802883:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802886:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802889:	be 00 00 00 00       	mov    $0x0,%esi
  80288e:	bf 02 00 00 00       	mov    $0x2,%edi
  802893:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
}
  80289f:	c9                   	leaveq 
  8028a0:	c3                   	retq   

00000000008028a1 <remove>:

// Delete a file
int
remove(const char *path)
{
  8028a1:	55                   	push   %rbp
  8028a2:	48 89 e5             	mov    %rsp,%rbp
  8028a5:	48 83 ec 10          	sub    $0x10,%rsp
  8028a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b1:	48 89 c7             	mov    %rax,%rdi
  8028b4:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028c5:	7e 07                	jle    8028ce <remove+0x2d>
		return -E_BAD_PATH;
  8028c7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028cc:	eb 33                	jmp    802901 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8028ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d2:	48 89 c6             	mov    %rax,%rsi
  8028d5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028dc:	00 00 00 
  8028df:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8028eb:	be 00 00 00 00       	mov    $0x0,%esi
  8028f0:	bf 07 00 00 00       	mov    $0x7,%edi
  8028f5:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
}
  802901:	c9                   	leaveq 
  802902:	c3                   	retq   

0000000000802903 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802903:	55                   	push   %rbp
  802904:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802907:	be 00 00 00 00       	mov    $0x0,%esi
  80290c:	bf 08 00 00 00       	mov    $0x8,%edi
  802911:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
}
  80291d:	5d                   	pop    %rbp
  80291e:	c3                   	retq   

000000000080291f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80291f:	55                   	push   %rbp
  802920:	48 89 e5             	mov    %rsp,%rbp
  802923:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80292a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802931:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802938:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80293f:	be 00 00 00 00       	mov    $0x0,%esi
  802944:	48 89 c7             	mov    %rax,%rdi
  802947:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
  802953:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295a:	79 28                	jns    802984 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	89 c6                	mov    %eax,%esi
  802961:	48 bf 32 45 80 00 00 	movabs $0x804532,%rdi
  802968:	00 00 00 
  80296b:	b8 00 00 00 00       	mov    $0x0,%eax
  802970:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  802977:	00 00 00 
  80297a:	ff d2                	callq  *%rdx
		return fd_src;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297f:	e9 74 01 00 00       	jmpq   802af8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802984:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80298b:	be 01 01 00 00       	mov    $0x101,%esi
  802990:	48 89 c7             	mov    %rax,%rdi
  802993:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax
  80299f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8029a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029a6:	79 39                	jns    8029e1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8029a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ab:	89 c6                	mov    %eax,%esi
  8029ad:	48 bf 48 45 80 00 00 	movabs $0x804548,%rdi
  8029b4:	00 00 00 
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8029c3:	00 00 00 
  8029c6:	ff d2                	callq  *%rdx
		close(fd_src);
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cb:	89 c7                	mov    %eax,%edi
  8029cd:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
		return fd_dest;
  8029d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029dc:	e9 17 01 00 00       	jmpq   802af8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029e1:	eb 74                	jmp    802a57 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8029e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029e6:	48 63 d0             	movslq %eax,%rdx
  8029e9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029f3:	48 89 ce             	mov    %rcx,%rsi
  8029f6:	89 c7                	mov    %eax,%edi
  8029f8:	48 b8 58 21 80 00 00 	movabs $0x802158,%rax
  8029ff:	00 00 00 
  802a02:	ff d0                	callq  *%rax
  802a04:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a07:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a0b:	79 4a                	jns    802a57 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a0d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a10:	89 c6                	mov    %eax,%esi
  802a12:	48 bf 62 45 80 00 00 	movabs $0x804562,%rdi
  802a19:	00 00 00 
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  802a28:	00 00 00 
  802a2b:	ff d2                	callq  *%rdx
			close(fd_src);
  802a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a30:	89 c7                	mov    %eax,%edi
  802a32:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax
			close(fd_dest);
  802a3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a41:	89 c7                	mov    %eax,%edi
  802a43:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802a4a:	00 00 00 
  802a4d:	ff d0                	callq  *%rax
			return write_size;
  802a4f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a52:	e9 a1 00 00 00       	jmpq   802af8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a57:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a61:	ba 00 02 00 00       	mov    $0x200,%edx
  802a66:	48 89 ce             	mov    %rcx,%rsi
  802a69:	89 c7                	mov    %eax,%edi
  802a6b:	48 b8 0e 20 80 00 00 	movabs $0x80200e,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
  802a77:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a7e:	0f 8f 5f ff ff ff    	jg     8029e3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a88:	79 47                	jns    802ad1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	48 bf 75 45 80 00 00 	movabs $0x804575,%rdi
  802a96:	00 00 00 
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  802aa5:	00 00 00 
  802aa8:	ff d2                	callq  *%rdx
		close(fd_src);
  802aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aad:	89 c7                	mov    %eax,%edi
  802aaf:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
		close(fd_dest);
  802abb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802abe:	89 c7                	mov    %eax,%edi
  802ac0:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
		return read_size;
  802acc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802acf:	eb 27                	jmp    802af8 <copy+0x1d9>
	}
	close(fd_src);
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	89 c7                	mov    %eax,%edi
  802ad6:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	callq  *%rax
	close(fd_dest);
  802ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae5:	89 c7                	mov    %eax,%edi
  802ae7:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
	return 0;
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802af8:	c9                   	leaveq 
  802af9:	c3                   	retq   

0000000000802afa <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802afa:	55                   	push   %rbp
  802afb:	48 89 e5             	mov    %rsp,%rbp
  802afe:	48 83 ec 20          	sub    $0x20,%rsp
  802b02:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802b05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b0c:	48 89 d6             	mov    %rdx,%rsi
  802b0f:	89 c7                	mov    %eax,%edi
  802b11:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b24:	79 05                	jns    802b2b <fd2sockid+0x31>
		return r;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	eb 24                	jmp    802b4f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2f:	8b 10                	mov    (%rax),%edx
  802b31:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802b38:	00 00 00 
  802b3b:	8b 00                	mov    (%rax),%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	74 07                	je     802b48 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802b41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b46:	eb 07                	jmp    802b4f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 20          	sub    $0x20,%rsp
  802b59:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b5c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b60:	48 89 c7             	mov    %rax,%rdi
  802b63:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  802b6a:	00 00 00 
  802b6d:	ff d0                	callq  *%rax
  802b6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b76:	78 26                	js     802b9e <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7c:	ba 07 04 00 00       	mov    $0x407,%edx
  802b81:	48 89 c6             	mov    %rax,%rsi
  802b84:	bf 00 00 00 00       	mov    $0x0,%edi
  802b89:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 16                	jns    802bb4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802b9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	48 b8 5e 30 80 00 00 	movabs $0x80305e,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
		return r;
  802baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb2:	eb 3a                	jmp    802bee <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb8:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802bbf:	00 00 00 
  802bc2:	8b 12                	mov    (%rdx),%edx
  802bc4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802bc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bd8:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdf:	48 89 c7             	mov    %rax,%rdi
  802be2:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
}
  802bee:	c9                   	leaveq 
  802bef:	c3                   	retq   

0000000000802bf0 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802bf0:	55                   	push   %rbp
  802bf1:	48 89 e5             	mov    %rsp,%rbp
  802bf4:	48 83 ec 30          	sub    $0x30,%rsp
  802bf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c06:	89 c7                	mov    %eax,%edi
  802c08:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1b:	79 05                	jns    802c22 <accept+0x32>
		return r;
  802c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c20:	eb 3b                	jmp    802c5d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c26:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2d:	48 89 ce             	mov    %rcx,%rsi
  802c30:	89 c7                	mov    %eax,%edi
  802c32:	48 b8 3b 2f 80 00 00 	movabs $0x802f3b,%rax
  802c39:	00 00 00 
  802c3c:	ff d0                	callq  *%rax
  802c3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c45:	79 05                	jns    802c4c <accept+0x5c>
		return r;
  802c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4a:	eb 11                	jmp    802c5d <accept+0x6d>
	return alloc_sockfd(r);
  802c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4f:	89 c7                	mov    %eax,%edi
  802c51:	48 b8 51 2b 80 00 00 	movabs $0x802b51,%rax
  802c58:	00 00 00 
  802c5b:	ff d0                	callq  *%rax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 20          	sub    $0x20,%rsp
  802c67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c6e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c89:	79 05                	jns    802c90 <bind+0x31>
		return r;
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	eb 1b                	jmp    802cab <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802c90:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c93:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9a:	48 89 ce             	mov    %rcx,%rsi
  802c9d:	89 c7                	mov    %eax,%edi
  802c9f:	48 b8 ba 2f 80 00 00 	movabs $0x802fba,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
}
  802cab:	c9                   	leaveq 
  802cac:	c3                   	retq   

0000000000802cad <shutdown>:

int
shutdown(int s, int how)
{
  802cad:	55                   	push   %rbp
  802cae:	48 89 e5             	mov    %rsp,%rbp
  802cb1:	48 83 ec 20          	sub    $0x20,%rsp
  802cb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cb8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cbe:	89 c7                	mov    %eax,%edi
  802cc0:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
  802ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd3:	79 05                	jns    802cda <shutdown+0x2d>
		return r;
  802cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd8:	eb 16                	jmp    802cf0 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802cda:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce0:	89 d6                	mov    %edx,%esi
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	48 b8 1e 30 80 00 00 	movabs $0x80301e,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
}
  802cf0:	c9                   	leaveq 
  802cf1:	c3                   	retq   

0000000000802cf2 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802cf2:	55                   	push   %rbp
  802cf3:	48 89 e5             	mov    %rsp,%rbp
  802cf6:	48 83 ec 10          	sub    $0x10,%rsp
  802cfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d02:	48 89 c7             	mov    %rax,%rdi
  802d05:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	83 f8 01             	cmp    $0x1,%eax
  802d14:	75 17                	jne    802d2d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1a:	8b 40 0c             	mov    0xc(%rax),%eax
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 5e 30 80 00 00 	movabs $0x80305e,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	eb 05                	jmp    802d32 <devsock_close+0x40>
	else
		return 0;
  802d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d32:	c9                   	leaveq 
  802d33:	c3                   	retq   

0000000000802d34 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d34:	55                   	push   %rbp
  802d35:	48 89 e5             	mov    %rsp,%rbp
  802d38:	48 83 ec 20          	sub    $0x20,%rsp
  802d3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d43:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d49:	89 c7                	mov    %eax,%edi
  802d4b:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5e:	79 05                	jns    802d65 <connect+0x31>
		return r;
  802d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d63:	eb 1b                	jmp    802d80 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d65:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d68:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6f:	48 89 ce             	mov    %rcx,%rsi
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 8b 30 80 00 00 	movabs $0x80308b,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
}
  802d80:	c9                   	leaveq 
  802d81:	c3                   	retq   

0000000000802d82 <listen>:

int
listen(int s, int backlog)
{
  802d82:	55                   	push   %rbp
  802d83:	48 89 e5             	mov    %rsp,%rbp
  802d86:	48 83 ec 20          	sub    $0x20,%rsp
  802d8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d8d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d93:	89 c7                	mov    %eax,%edi
  802d95:	48 b8 fa 2a 80 00 00 	movabs $0x802afa,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
  802da1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da8:	79 05                	jns    802daf <listen+0x2d>
		return r;
  802daa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dad:	eb 16                	jmp    802dc5 <listen+0x43>
	return nsipc_listen(r, backlog);
  802daf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	89 d6                	mov    %edx,%esi
  802db7:	89 c7                	mov    %eax,%edi
  802db9:	48 b8 ef 30 80 00 00 	movabs $0x8030ef,%rax
  802dc0:	00 00 00 
  802dc3:	ff d0                	callq  *%rax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 20          	sub    $0x20,%rsp
  802dcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddf:	89 c2                	mov    %eax,%edx
  802de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de5:	8b 40 0c             	mov    0xc(%rax),%eax
  802de8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802dec:	b9 00 00 00 00       	mov    $0x0,%ecx
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 2f 31 80 00 00 	movabs $0x80312f,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
}
  802dff:	c9                   	leaveq 
  802e00:	c3                   	retq   

0000000000802e01 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802e01:	55                   	push   %rbp
  802e02:	48 89 e5             	mov    %rsp,%rbp
  802e05:	48 83 ec 20          	sub    $0x20,%rsp
  802e09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e11:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e19:	89 c2                	mov    %eax,%edx
  802e1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1f:	8b 40 0c             	mov    0xc(%rax),%eax
  802e22:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e26:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e2b:	89 c7                	mov    %eax,%edi
  802e2d:	48 b8 fb 31 80 00 00 	movabs $0x8031fb,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
}
  802e39:	c9                   	leaveq 
  802e3a:	c3                   	retq   

0000000000802e3b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e3b:	55                   	push   %rbp
  802e3c:	48 89 e5             	mov    %rsp,%rbp
  802e3f:	48 83 ec 10          	sub    $0x10,%rsp
  802e43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4f:	48 be 90 45 80 00 00 	movabs $0x804590,%rsi
  802e56:	00 00 00 
  802e59:	48 89 c7             	mov    %rax,%rdi
  802e5c:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
	return 0;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6d:	c9                   	leaveq 
  802e6e:	c3                   	retq   

0000000000802e6f <socket>:

int
socket(int domain, int type, int protocol)
{
  802e6f:	55                   	push   %rbp
  802e70:	48 89 e5             	mov    %rsp,%rbp
  802e73:	48 83 ec 20          	sub    $0x20,%rsp
  802e77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e7d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e80:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e83:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e89:	89 ce                	mov    %ecx,%esi
  802e8b:	89 c7                	mov    %eax,%edi
  802e8d:	48 b8 b3 32 80 00 00 	movabs $0x8032b3,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
  802e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea0:	79 05                	jns    802ea7 <socket+0x38>
		return r;
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	eb 11                	jmp    802eb8 <socket+0x49>
	return alloc_sockfd(r);
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	89 c7                	mov    %eax,%edi
  802eac:	48 b8 51 2b 80 00 00 	movabs $0x802b51,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
}
  802eb8:	c9                   	leaveq 
  802eb9:	c3                   	retq   

0000000000802eba <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802eba:	55                   	push   %rbp
  802ebb:	48 89 e5             	mov    %rsp,%rbp
  802ebe:	48 83 ec 10          	sub    $0x10,%rsp
  802ec2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802ec5:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ecc:	00 00 00 
  802ecf:	8b 00                	mov    (%rax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	75 1d                	jne    802ef2 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802ed5:	bf 02 00 00 00       	mov    $0x2,%edi
  802eda:	48 b8 fe 3d 80 00 00 	movabs $0x803dfe,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802eed:	00 00 00 
  802ef0:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802ef2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ef9:	00 00 00 
  802efc:	8b 00                	mov    (%rax),%eax
  802efe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f01:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f06:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f0d:	00 00 00 
  802f10:	89 c7                	mov    %eax,%edi
  802f12:	48 b8 9c 3d 80 00 00 	movabs $0x803d9c,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f23:	be 00 00 00 00       	mov    $0x0,%esi
  802f28:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2d:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
}
  802f39:	c9                   	leaveq 
  802f3a:	c3                   	retq   

0000000000802f3b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f3b:	55                   	push   %rbp
  802f3c:	48 89 e5             	mov    %rsp,%rbp
  802f3f:	48 83 ec 30          	sub    $0x30,%rsp
  802f43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f4e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f55:	00 00 00 
  802f58:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f5b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f5d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f62:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f75:	78 3e                	js     802fb5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f77:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f7e:	00 00 00 
  802f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f89:	8b 40 10             	mov    0x10(%rax),%eax
  802f8c:	89 c2                	mov    %eax,%edx
  802f8e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f96:	48 89 ce             	mov    %rcx,%rsi
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fac:	8b 50 10             	mov    0x10(%rax),%edx
  802faf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fb8:	c9                   	leaveq 
  802fb9:	c3                   	retq   

0000000000802fba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fba:	55                   	push   %rbp
  802fbb:	48 89 e5             	mov    %rsp,%rbp
  802fbe:	48 83 ec 10          	sub    $0x10,%rsp
  802fc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fc9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802fcc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fd3:	00 00 00 
  802fd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fd9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802fdb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe2:	48 89 c6             	mov    %rax,%rsi
  802fe5:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802fec:	00 00 00 
  802fef:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802ffb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803002:	00 00 00 
  803005:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803008:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80300b:	bf 02 00 00 00       	mov    $0x2,%edi
  803010:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
}
  80301c:	c9                   	leaveq 
  80301d:	c3                   	retq   

000000000080301e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80301e:	55                   	push   %rbp
  80301f:	48 89 e5             	mov    %rsp,%rbp
  803022:	48 83 ec 10          	sub    $0x10,%rsp
  803026:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803029:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80302c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803033:	00 00 00 
  803036:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803039:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80303b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803042:	00 00 00 
  803045:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803048:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80304b:	bf 03 00 00 00       	mov    $0x3,%edi
  803050:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
}
  80305c:	c9                   	leaveq 
  80305d:	c3                   	retq   

000000000080305e <nsipc_close>:

int
nsipc_close(int s)
{
  80305e:	55                   	push   %rbp
  80305f:	48 89 e5             	mov    %rsp,%rbp
  803062:	48 83 ec 10          	sub    $0x10,%rsp
  803066:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803069:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803070:	00 00 00 
  803073:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803076:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803078:	bf 04 00 00 00       	mov    $0x4,%edi
  80307d:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
}
  803089:	c9                   	leaveq 
  80308a:	c3                   	retq   

000000000080308b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80308b:	55                   	push   %rbp
  80308c:	48 89 e5             	mov    %rsp,%rbp
  80308f:	48 83 ec 10          	sub    $0x10,%rsp
  803093:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803096:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80309a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80309d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a4:	00 00 00 
  8030a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030aa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030bd:	00 00 00 
  8030c0:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8030cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030d3:	00 00 00 
  8030d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030d9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8030dc:	bf 05 00 00 00       	mov    $0x5,%edi
  8030e1:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  8030e8:	00 00 00 
  8030eb:	ff d0                	callq  *%rax
}
  8030ed:	c9                   	leaveq 
  8030ee:	c3                   	retq   

00000000008030ef <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8030ef:	55                   	push   %rbp
  8030f0:	48 89 e5             	mov    %rsp,%rbp
  8030f3:	48 83 ec 10          	sub    $0x10,%rsp
  8030f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030fa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8030fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803104:	00 00 00 
  803107:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80310a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80310c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803113:	00 00 00 
  803116:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80311c:	bf 06 00 00 00       	mov    $0x6,%edi
  803121:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  803128:	00 00 00 
  80312b:	ff d0                	callq  *%rax
}
  80312d:	c9                   	leaveq 
  80312e:	c3                   	retq   

000000000080312f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80312f:	55                   	push   %rbp
  803130:	48 89 e5             	mov    %rsp,%rbp
  803133:	48 83 ec 30          	sub    $0x30,%rsp
  803137:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80313a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803141:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803144:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80314b:	00 00 00 
  80314e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803151:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803153:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80315a:	00 00 00 
  80315d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803160:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803163:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80316a:	00 00 00 
  80316d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803170:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803173:	bf 07 00 00 00       	mov    $0x7,%edi
  803178:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
  803184:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318b:	78 69                	js     8031f6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80318d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803194:	7f 08                	jg     80319e <nsipc_recv+0x6f>
  803196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803199:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80319c:	7e 35                	jle    8031d3 <nsipc_recv+0xa4>
  80319e:	48 b9 97 45 80 00 00 	movabs $0x804597,%rcx
  8031a5:	00 00 00 
  8031a8:	48 ba ac 45 80 00 00 	movabs $0x8045ac,%rdx
  8031af:	00 00 00 
  8031b2:	be 61 00 00 00       	mov    $0x61,%esi
  8031b7:	48 bf c1 45 80 00 00 	movabs $0x8045c1,%rdi
  8031be:	00 00 00 
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c6:	49 b8 82 3b 80 00 00 	movabs $0x803b82,%r8
  8031cd:	00 00 00 
  8031d0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8031d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d6:	48 63 d0             	movslq %eax,%rdx
  8031d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031dd:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031e4:	00 00 00 
  8031e7:	48 89 c7             	mov    %rax,%rdi
  8031ea:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
	}

	return r;
  8031f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031f9:	c9                   	leaveq 
  8031fa:	c3                   	retq   

00000000008031fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8031fb:	55                   	push   %rbp
  8031fc:	48 89 e5             	mov    %rsp,%rbp
  8031ff:	48 83 ec 20          	sub    $0x20,%rsp
  803203:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803206:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80320a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80320d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803210:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803217:	00 00 00 
  80321a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80321d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80321f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803226:	7e 35                	jle    80325d <nsipc_send+0x62>
  803228:	48 b9 cd 45 80 00 00 	movabs $0x8045cd,%rcx
  80322f:	00 00 00 
  803232:	48 ba ac 45 80 00 00 	movabs $0x8045ac,%rdx
  803239:	00 00 00 
  80323c:	be 6c 00 00 00       	mov    $0x6c,%esi
  803241:	48 bf c1 45 80 00 00 	movabs $0x8045c1,%rdi
  803248:	00 00 00 
  80324b:	b8 00 00 00 00       	mov    $0x0,%eax
  803250:	49 b8 82 3b 80 00 00 	movabs $0x803b82,%r8
  803257:	00 00 00 
  80325a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80325d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803260:	48 63 d0             	movslq %eax,%rdx
  803263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803267:	48 89 c6             	mov    %rax,%rsi
  80326a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803271:	00 00 00 
  803274:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803280:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803287:	00 00 00 
  80328a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803290:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803297:	00 00 00 
  80329a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80329d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8032a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8032a5:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
}
  8032b1:	c9                   	leaveq 
  8032b2:	c3                   	retq   

00000000008032b3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8032b3:	55                   	push   %rbp
  8032b4:	48 89 e5             	mov    %rsp,%rbp
  8032b7:	48 83 ec 10          	sub    $0x10,%rsp
  8032bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032be:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8032c1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8032c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032cb:	00 00 00 
  8032ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8032d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032da:	00 00 00 
  8032dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032e0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8032e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ea:	00 00 00 
  8032ed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032f0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8032f3:	bf 09 00 00 00       	mov    $0x9,%edi
  8032f8:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	53                   	push   %rbx
  80330b:	48 83 ec 38          	sub    $0x38,%rsp
  80330f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803313:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803317:	48 89 c7             	mov    %rax,%rdi
  80331a:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80332d:	0f 88 bf 01 00 00    	js     8034f2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803337:	ba 07 04 00 00       	mov    $0x407,%edx
  80333c:	48 89 c6             	mov    %rax,%rsi
  80333f:	bf 00 00 00 00       	mov    $0x0,%edi
  803344:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
  803350:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803353:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803357:	0f 88 95 01 00 00    	js     8034f2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80335d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803361:	48 89 c7             	mov    %rax,%rdi
  803364:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
  803370:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803373:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803377:	0f 88 5d 01 00 00    	js     8034da <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80337d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803381:	ba 07 04 00 00       	mov    $0x407,%edx
  803386:	48 89 c6             	mov    %rax,%rsi
  803389:	bf 00 00 00 00       	mov    $0x0,%edi
  80338e:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
  80339a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a1:	0f 88 33 01 00 00    	js     8034da <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ab:	48 89 c7             	mov    %rax,%rdi
  8033ae:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
  8033ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8033c7:	48 89 c6             	mov    %rax,%rsi
  8033ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8033cf:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033e2:	79 05                	jns    8033e9 <pipe+0xe3>
		goto err2;
  8033e4:	e9 d9 00 00 00       	jmpq   8034c2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ed:	48 89 c7             	mov    %rax,%rdi
  8033f0:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  8033f7:	00 00 00 
  8033fa:	ff d0                	callq  *%rax
  8033fc:	48 89 c2             	mov    %rax,%rdx
  8033ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803403:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803409:	48 89 d1             	mov    %rdx,%rcx
  80340c:	ba 00 00 00 00       	mov    $0x0,%edx
  803411:	48 89 c6             	mov    %rax,%rsi
  803414:	bf 00 00 00 00       	mov    $0x0,%edi
  803419:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
  803425:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803428:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80342c:	79 1b                	jns    803449 <pipe+0x143>
		goto err3;
  80342e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80342f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803433:	48 89 c6             	mov    %rax,%rsi
  803436:	bf 00 00 00 00       	mov    $0x0,%edi
  80343b:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
  803447:	eb 79                	jmp    8034c2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803454:	00 00 00 
  803457:	8b 12                	mov    (%rdx),%edx
  803459:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80345b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80345f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803466:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803471:	00 00 00 
  803474:	8b 12                	mov    (%rdx),%edx
  803476:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803478:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803487:	48 89 c7             	mov    %rax,%rdi
  80348a:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
  803496:	89 c2                	mov    %eax,%edx
  803498:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80349c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80349e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034a2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034aa:	48 89 c7             	mov    %rax,%rdi
  8034ad:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8034b4:	00 00 00 
  8034b7:	ff d0                	callq  *%rax
  8034b9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c0:	eb 33                	jmp    8034f5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8034c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c6:	48 89 c6             	mov    %rax,%rsi
  8034c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ce:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8034da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034de:	48 89 c6             	mov    %rax,%rsi
  8034e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e6:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
err:
	return r;
  8034f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034f5:	48 83 c4 38          	add    $0x38,%rsp
  8034f9:	5b                   	pop    %rbx
  8034fa:	5d                   	pop    %rbp
  8034fb:	c3                   	retq   

00000000008034fc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034fc:	55                   	push   %rbp
  8034fd:	48 89 e5             	mov    %rsp,%rbp
  803500:	53                   	push   %rbx
  803501:	48 83 ec 28          	sub    $0x28,%rsp
  803505:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803509:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80350d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803514:	00 00 00 
  803517:	48 8b 00             	mov    (%rax),%rax
  80351a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803520:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803527:	48 89 c7             	mov    %rax,%rdi
  80352a:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
  803536:	89 c3                	mov    %eax,%ebx
  803538:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80353c:	48 89 c7             	mov    %rax,%rdi
  80353f:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
  80354b:	39 c3                	cmp    %eax,%ebx
  80354d:	0f 94 c0             	sete   %al
  803550:	0f b6 c0             	movzbl %al,%eax
  803553:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803556:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80355d:	00 00 00 
  803560:	48 8b 00             	mov    (%rax),%rax
  803563:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803569:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80356c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80356f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803572:	75 05                	jne    803579 <_pipeisclosed+0x7d>
			return ret;
  803574:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803577:	eb 4f                	jmp    8035c8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803579:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80357f:	74 42                	je     8035c3 <_pipeisclosed+0xc7>
  803581:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803585:	75 3c                	jne    8035c3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803587:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80358e:	00 00 00 
  803591:	48 8b 00             	mov    (%rax),%rax
  803594:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80359a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80359d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a0:	89 c6                	mov    %eax,%esi
  8035a2:	48 bf de 45 80 00 00 	movabs $0x8045de,%rdi
  8035a9:	00 00 00 
  8035ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b1:	49 b8 d9 02 80 00 00 	movabs $0x8002d9,%r8
  8035b8:	00 00 00 
  8035bb:	41 ff d0             	callq  *%r8
	}
  8035be:	e9 4a ff ff ff       	jmpq   80350d <_pipeisclosed+0x11>
  8035c3:	e9 45 ff ff ff       	jmpq   80350d <_pipeisclosed+0x11>
}
  8035c8:	48 83 c4 28          	add    $0x28,%rsp
  8035cc:	5b                   	pop    %rbx
  8035cd:	5d                   	pop    %rbp
  8035ce:	c3                   	retq   

00000000008035cf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8035cf:	55                   	push   %rbp
  8035d0:	48 89 e5             	mov    %rsp,%rbp
  8035d3:	48 83 ec 30          	sub    $0x30,%rsp
  8035d7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035e1:	48 89 d6             	mov    %rdx,%rsi
  8035e4:	89 c7                	mov    %eax,%edi
  8035e6:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f9:	79 05                	jns    803600 <pipeisclosed+0x31>
		return r;
  8035fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fe:	eb 31                	jmp    803631 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803604:	48 89 c7             	mov    %rax,%rdi
  803607:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  80360e:	00 00 00 
  803611:	ff d0                	callq  *%rax
  803613:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80361f:	48 89 d6             	mov    %rdx,%rsi
  803622:	48 89 c7             	mov    %rax,%rdi
  803625:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  80362c:	00 00 00 
  80362f:	ff d0                	callq  *%rax
}
  803631:	c9                   	leaveq 
  803632:	c3                   	retq   

0000000000803633 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803633:	55                   	push   %rbp
  803634:	48 89 e5             	mov    %rsp,%rbp
  803637:	48 83 ec 40          	sub    $0x40,%rsp
  80363b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80363f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803643:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364b:	48 89 c7             	mov    %rax,%rdi
  80364e:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
  80365a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80365e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803662:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803666:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80366d:	00 
  80366e:	e9 92 00 00 00       	jmpq   803705 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803673:	eb 41                	jmp    8036b6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803675:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80367a:	74 09                	je     803685 <devpipe_read+0x52>
				return i;
  80367c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803680:	e9 92 00 00 00       	jmpq   803717 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803685:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368d:	48 89 d6             	mov    %rdx,%rsi
  803690:	48 89 c7             	mov    %rax,%rdi
  803693:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	74 07                	je     8036aa <devpipe_read+0x77>
				return 0;
  8036a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a8:	eb 6d                	jmp    803717 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036aa:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ba:	8b 10                	mov    (%rax),%edx
  8036bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c0:	8b 40 04             	mov    0x4(%rax),%eax
  8036c3:	39 c2                	cmp    %eax,%edx
  8036c5:	74 ae                	je     803675 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036cf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d7:	8b 00                	mov    (%rax),%eax
  8036d9:	99                   	cltd   
  8036da:	c1 ea 1b             	shr    $0x1b,%edx
  8036dd:	01 d0                	add    %edx,%eax
  8036df:	83 e0 1f             	and    $0x1f,%eax
  8036e2:	29 d0                	sub    %edx,%eax
  8036e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e8:	48 98                	cltq   
  8036ea:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036ef:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f5:	8b 00                	mov    (%rax),%eax
  8036f7:	8d 50 01             	lea    0x1(%rax),%edx
  8036fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fe:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803700:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803709:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80370d:	0f 82 60 ff ff ff    	jb     803673 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 40          	sub    $0x40,%rsp
  803721:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803725:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803729:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80372d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803731:	48 89 c7             	mov    %rax,%rdi
  803734:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
  803740:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803748:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80374c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803753:	00 
  803754:	e9 8e 00 00 00       	jmpq   8037e7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803759:	eb 31                	jmp    80378c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80375b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80375f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803763:	48 89 d6             	mov    %rdx,%rsi
  803766:	48 89 c7             	mov    %rax,%rdi
  803769:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 07                	je     803780 <devpipe_write+0x67>
				return 0;
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
  80377e:	eb 79                	jmp    8037f9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803780:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  803787:	00 00 00 
  80378a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80378c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803790:	8b 40 04             	mov    0x4(%rax),%eax
  803793:	48 63 d0             	movslq %eax,%rdx
  803796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379a:	8b 00                	mov    (%rax),%eax
  80379c:	48 98                	cltq   
  80379e:	48 83 c0 20          	add    $0x20,%rax
  8037a2:	48 39 c2             	cmp    %rax,%rdx
  8037a5:	73 b4                	jae    80375b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ab:	8b 40 04             	mov    0x4(%rax),%eax
  8037ae:	99                   	cltd   
  8037af:	c1 ea 1b             	shr    $0x1b,%edx
  8037b2:	01 d0                	add    %edx,%eax
  8037b4:	83 e0 1f             	and    $0x1f,%eax
  8037b7:	29 d0                	sub    %edx,%eax
  8037b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037c1:	48 01 ca             	add    %rcx,%rdx
  8037c4:	0f b6 0a             	movzbl (%rdx),%ecx
  8037c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037cb:	48 98                	cltq   
  8037cd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d5:	8b 40 04             	mov    0x4(%rax),%eax
  8037d8:	8d 50 01             	lea    0x1(%rax),%edx
  8037db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037df:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037ef:	0f 82 64 ff ff ff    	jb     803759 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037f9:	c9                   	leaveq 
  8037fa:	c3                   	retq   

00000000008037fb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037fb:	55                   	push   %rbp
  8037fc:	48 89 e5             	mov    %rsp,%rbp
  8037ff:	48 83 ec 20          	sub    $0x20,%rsp
  803803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803807:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80380b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380f:	48 89 c7             	mov    %rax,%rdi
  803812:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
  80381e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803822:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803826:	48 be f1 45 80 00 00 	movabs $0x8045f1,%rsi
  80382d:	00 00 00 
  803830:	48 89 c7             	mov    %rax,%rdi
  803833:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80383f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803843:	8b 50 04             	mov    0x4(%rax),%edx
  803846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384a:	8b 00                	mov    (%rax),%eax
  80384c:	29 c2                	sub    %eax,%edx
  80384e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803852:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803858:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803863:	00 00 00 
	stat->st_dev = &devpipe;
  803866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803871:	00 00 00 
  803874:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80387b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803880:	c9                   	leaveq 
  803881:	c3                   	retq   

0000000000803882 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803882:	55                   	push   %rbp
  803883:	48 89 e5             	mov    %rsp,%rbp
  803886:	48 83 ec 10          	sub    $0x10,%rsp
  80388a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80388e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803892:	48 89 c6             	mov    %rax,%rsi
  803895:	bf 00 00 00 00       	mov    $0x0,%edi
  80389a:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8038a1:	00 00 00 
  8038a4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8038a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038aa:	48 89 c7             	mov    %rax,%rdi
  8038ad:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
  8038b9:	48 89 c6             	mov    %rax,%rsi
  8038bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c1:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
}
  8038cd:	c9                   	leaveq 
  8038ce:	c3                   	retq   

00000000008038cf <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038cf:	55                   	push   %rbp
  8038d0:	48 89 e5             	mov    %rsp,%rbp
  8038d3:	48 83 ec 20          	sub    $0x20,%rsp
  8038d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038dd:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038e0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038e4:	be 01 00 00 00       	mov    $0x1,%esi
  8038e9:	48 89 c7             	mov    %rax,%rdi
  8038ec:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  8038f3:	00 00 00 
  8038f6:	ff d0                	callq  *%rax
}
  8038f8:	c9                   	leaveq 
  8038f9:	c3                   	retq   

00000000008038fa <getchar>:

int
getchar(void)
{
  8038fa:	55                   	push   %rbp
  8038fb:	48 89 e5             	mov    %rsp,%rbp
  8038fe:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803902:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803906:	ba 01 00 00 00       	mov    $0x1,%edx
  80390b:	48 89 c6             	mov    %rax,%rsi
  80390e:	bf 00 00 00 00       	mov    $0x0,%edi
  803913:	48 b8 0e 20 80 00 00 	movabs $0x80200e,%rax
  80391a:	00 00 00 
  80391d:	ff d0                	callq  *%rax
  80391f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803926:	79 05                	jns    80392d <getchar+0x33>
		return r;
  803928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392b:	eb 14                	jmp    803941 <getchar+0x47>
	if (r < 1)
  80392d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803931:	7f 07                	jg     80393a <getchar+0x40>
		return -E_EOF;
  803933:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803938:	eb 07                	jmp    803941 <getchar+0x47>
	return c;
  80393a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80393e:	0f b6 c0             	movzbl %al,%eax
}
  803941:	c9                   	leaveq 
  803942:	c3                   	retq   

0000000000803943 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803943:	55                   	push   %rbp
  803944:	48 89 e5             	mov    %rsp,%rbp
  803947:	48 83 ec 20          	sub    $0x20,%rsp
  80394b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80394e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803955:	48 89 d6             	mov    %rdx,%rsi
  803958:	89 c7                	mov    %eax,%edi
  80395a:	48 b8 dc 1b 80 00 00 	movabs $0x801bdc,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
  803966:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803969:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80396d:	79 05                	jns    803974 <iscons+0x31>
		return r;
  80396f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803972:	eb 1a                	jmp    80398e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803978:	8b 10                	mov    (%rax),%edx
  80397a:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803981:	00 00 00 
  803984:	8b 00                	mov    (%rax),%eax
  803986:	39 c2                	cmp    %eax,%edx
  803988:	0f 94 c0             	sete   %al
  80398b:	0f b6 c0             	movzbl %al,%eax
}
  80398e:	c9                   	leaveq 
  80398f:	c3                   	retq   

0000000000803990 <opencons>:

int
opencons(void)
{
  803990:	55                   	push   %rbp
  803991:	48 89 e5             	mov    %rsp,%rbp
  803994:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803998:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80399c:	48 89 c7             	mov    %rax,%rdi
  80399f:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
  8039ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b2:	79 05                	jns    8039b9 <opencons+0x29>
		return r;
  8039b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b7:	eb 5b                	jmp    803a14 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8039c2:	48 89 c6             	mov    %rax,%rsi
  8039c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ca:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039dd:	79 05                	jns    8039e4 <opencons+0x54>
		return r;
  8039df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e2:	eb 30                	jmp    803a14 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e8:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8039ef:	00 00 00 
  8039f2:	8b 12                	mov    (%rdx),%edx
  8039f4:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
}
  803a14:	c9                   	leaveq 
  803a15:	c3                   	retq   

0000000000803a16 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a16:	55                   	push   %rbp
  803a17:	48 89 e5             	mov    %rsp,%rbp
  803a1a:	48 83 ec 30          	sub    $0x30,%rsp
  803a1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a2a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a2f:	75 07                	jne    803a38 <devcons_read+0x22>
		return 0;
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	eb 4b                	jmp    803a83 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a38:	eb 0c                	jmp    803a46 <devcons_read+0x30>
		sys_yield();
  803a3a:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  803a41:	00 00 00 
  803a44:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a46:	48 b8 bf 16 80 00 00 	movabs $0x8016bf,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
  803a52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a59:	74 df                	je     803a3a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a5f:	79 05                	jns    803a66 <devcons_read+0x50>
		return c;
  803a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a64:	eb 1d                	jmp    803a83 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a66:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a6a:	75 07                	jne    803a73 <devcons_read+0x5d>
		return 0;
  803a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a71:	eb 10                	jmp    803a83 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a76:	89 c2                	mov    %eax,%edx
  803a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7c:	88 10                	mov    %dl,(%rax)
	return 1;
  803a7e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a83:	c9                   	leaveq 
  803a84:	c3                   	retq   

0000000000803a85 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a85:	55                   	push   %rbp
  803a86:	48 89 e5             	mov    %rsp,%rbp
  803a89:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a90:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a97:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a9e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803aac:	eb 76                	jmp    803b24 <devcons_write+0x9f>
		m = n - tot;
  803aae:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ab5:	89 c2                	mov    %eax,%edx
  803ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aba:	29 c2                	sub    %eax,%edx
  803abc:	89 d0                	mov    %edx,%eax
  803abe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ac4:	83 f8 7f             	cmp    $0x7f,%eax
  803ac7:	76 07                	jbe    803ad0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ac9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ad0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ad3:	48 63 d0             	movslq %eax,%rdx
  803ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad9:	48 63 c8             	movslq %eax,%rcx
  803adc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ae3:	48 01 c1             	add    %rax,%rcx
  803ae6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aed:	48 89 ce             	mov    %rcx,%rsi
  803af0:	48 89 c7             	mov    %rax,%rdi
  803af3:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803aff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b02:	48 63 d0             	movslq %eax,%rdx
  803b05:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b0c:	48 89 d6             	mov    %rdx,%rsi
  803b0f:	48 89 c7             	mov    %rax,%rdi
  803b12:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b21:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b27:	48 98                	cltq   
  803b29:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b30:	0f 82 78 ff ff ff    	jb     803aae <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b39:	c9                   	leaveq 
  803b3a:	c3                   	retq   

0000000000803b3b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b3b:	55                   	push   %rbp
  803b3c:	48 89 e5             	mov    %rsp,%rbp
  803b3f:	48 83 ec 08          	sub    $0x8,%rsp
  803b43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b4c:	c9                   	leaveq 
  803b4d:	c3                   	retq   

0000000000803b4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b4e:	55                   	push   %rbp
  803b4f:	48 89 e5             	mov    %rsp,%rbp
  803b52:	48 83 ec 10          	sub    $0x10,%rsp
  803b56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b62:	48 be fd 45 80 00 00 	movabs $0x8045fd,%rsi
  803b69:	00 00 00 
  803b6c:	48 89 c7             	mov    %rax,%rdi
  803b6f:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  803b76:	00 00 00 
  803b79:	ff d0                	callq  *%rax
	return 0;
  803b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b80:	c9                   	leaveq 
  803b81:	c3                   	retq   

0000000000803b82 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803b82:	55                   	push   %rbp
  803b83:	48 89 e5             	mov    %rsp,%rbp
  803b86:	53                   	push   %rbx
  803b87:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803b8e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b95:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b9b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ba2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ba9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803bb0:	84 c0                	test   %al,%al
  803bb2:	74 23                	je     803bd7 <_panic+0x55>
  803bb4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803bbb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803bbf:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803bc3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803bc7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803bcb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803bcf:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803bd3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803bd7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803bde:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803be5:	00 00 00 
  803be8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803bef:	00 00 00 
  803bf2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803bf6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803bfd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803c04:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803c0b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803c12:	00 00 00 
  803c15:	48 8b 18             	mov    (%rax),%rbx
  803c18:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
  803c24:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803c2a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c31:	41 89 c8             	mov    %ecx,%r8d
  803c34:	48 89 d1             	mov    %rdx,%rcx
  803c37:	48 89 da             	mov    %rbx,%rdx
  803c3a:	89 c6                	mov    %eax,%esi
  803c3c:	48 bf 08 46 80 00 00 	movabs $0x804608,%rdi
  803c43:	00 00 00 
  803c46:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4b:	49 b9 d9 02 80 00 00 	movabs $0x8002d9,%r9
  803c52:	00 00 00 
  803c55:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803c58:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803c5f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803c66:	48 89 d6             	mov    %rdx,%rsi
  803c69:	48 89 c7             	mov    %rax,%rdi
  803c6c:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
	cprintf("\n");
  803c78:	48 bf 2b 46 80 00 00 	movabs $0x80462b,%rdi
  803c7f:	00 00 00 
  803c82:	b8 00 00 00 00       	mov    $0x0,%eax
  803c87:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  803c8e:	00 00 00 
  803c91:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c93:	cc                   	int3   
  803c94:	eb fd                	jmp    803c93 <_panic+0x111>

0000000000803c96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	48 83 ec 30          	sub    $0x30,%rsp
  803c9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ca6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803caa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cb1:	00 00 00 
  803cb4:	48 8b 00             	mov    (%rax),%rax
  803cb7:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803cbd:	85 c0                	test   %eax,%eax
  803cbf:	75 3c                	jne    803cfd <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803cc1:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
  803ccd:	25 ff 03 00 00       	and    $0x3ff,%eax
  803cd2:	48 63 d0             	movslq %eax,%rdx
  803cd5:	48 89 d0             	mov    %rdx,%rax
  803cd8:	48 c1 e0 03          	shl    $0x3,%rax
  803cdc:	48 01 d0             	add    %rdx,%rax
  803cdf:	48 c1 e0 05          	shl    $0x5,%rax
  803ce3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803cea:	00 00 00 
  803ced:	48 01 c2             	add    %rax,%rdx
  803cf0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cf7:	00 00 00 
  803cfa:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803cfd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d02:	75 0e                	jne    803d12 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803d04:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d0b:	00 00 00 
  803d0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2c:	79 19                	jns    803d47 <ipc_recv+0xb1>
		*from_env_store = 0;
  803d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d32:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d45:	eb 53                	jmp    803d9a <ipc_recv+0x104>
	}
	if(from_env_store)
  803d47:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d4c:	74 19                	je     803d67 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d4e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d55:	00 00 00 
  803d58:	48 8b 00             	mov    (%rax),%rax
  803d5b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d65:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803d67:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d6c:	74 19                	je     803d87 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803d6e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d75:	00 00 00 
  803d78:	48 8b 00             	mov    (%rax),%rax
  803d7b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d85:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d87:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d8e:	00 00 00 
  803d91:	48 8b 00             	mov    (%rax),%rax
  803d94:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d9a:	c9                   	leaveq 
  803d9b:	c3                   	retq   

0000000000803d9c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d9c:	55                   	push   %rbp
  803d9d:	48 89 e5             	mov    %rsp,%rbp
  803da0:	48 83 ec 30          	sub    $0x30,%rsp
  803da4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803da7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803daa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803dae:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803db1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803db6:	75 0e                	jne    803dc6 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803db8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dbf:	00 00 00 
  803dc2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803dc6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803dc9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803dcc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803dd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd3:	89 c7                	mov    %eax,%edi
  803dd5:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
  803de1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803de4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803de8:	75 0c                	jne    803df6 <ipc_send+0x5a>
			sys_yield();
  803dea:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803df6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803dfa:	74 ca                	je     803dc6 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803dfc:	c9                   	leaveq 
  803dfd:	c3                   	retq   

0000000000803dfe <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803dfe:	55                   	push   %rbp
  803dff:	48 89 e5             	mov    %rsp,%rbp
  803e02:	48 83 ec 14          	sub    $0x14,%rsp
  803e06:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e10:	eb 5e                	jmp    803e70 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e12:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e19:	00 00 00 
  803e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1f:	48 63 d0             	movslq %eax,%rdx
  803e22:	48 89 d0             	mov    %rdx,%rax
  803e25:	48 c1 e0 03          	shl    $0x3,%rax
  803e29:	48 01 d0             	add    %rdx,%rax
  803e2c:	48 c1 e0 05          	shl    $0x5,%rax
  803e30:	48 01 c8             	add    %rcx,%rax
  803e33:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e39:	8b 00                	mov    (%rax),%eax
  803e3b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e3e:	75 2c                	jne    803e6c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e40:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e47:	00 00 00 
  803e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4d:	48 63 d0             	movslq %eax,%rdx
  803e50:	48 89 d0             	mov    %rdx,%rax
  803e53:	48 c1 e0 03          	shl    $0x3,%rax
  803e57:	48 01 d0             	add    %rdx,%rax
  803e5a:	48 c1 e0 05          	shl    $0x5,%rax
  803e5e:	48 01 c8             	add    %rcx,%rax
  803e61:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e67:	8b 40 08             	mov    0x8(%rax),%eax
  803e6a:	eb 12                	jmp    803e7e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803e6c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e70:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e77:	7e 99                	jle    803e12 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e7e:	c9                   	leaveq 
  803e7f:	c3                   	retq   

0000000000803e80 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e80:	55                   	push   %rbp
  803e81:	48 89 e5             	mov    %rsp,%rbp
  803e84:	48 83 ec 18          	sub    $0x18,%rsp
  803e88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e90:	48 c1 e8 15          	shr    $0x15,%rax
  803e94:	48 89 c2             	mov    %rax,%rdx
  803e97:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e9e:	01 00 00 
  803ea1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ea5:	83 e0 01             	and    $0x1,%eax
  803ea8:	48 85 c0             	test   %rax,%rax
  803eab:	75 07                	jne    803eb4 <pageref+0x34>
		return 0;
  803ead:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb2:	eb 53                	jmp    803f07 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb8:	48 c1 e8 0c          	shr    $0xc,%rax
  803ebc:	48 89 c2             	mov    %rax,%rdx
  803ebf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ec6:	01 00 00 
  803ec9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ecd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed5:	83 e0 01             	and    $0x1,%eax
  803ed8:	48 85 c0             	test   %rax,%rax
  803edb:	75 07                	jne    803ee4 <pageref+0x64>
		return 0;
  803edd:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee2:	eb 23                	jmp    803f07 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee8:	48 c1 e8 0c          	shr    $0xc,%rax
  803eec:	48 89 c2             	mov    %rax,%rdx
  803eef:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ef6:	00 00 00 
  803ef9:	48 c1 e2 04          	shl    $0x4,%rdx
  803efd:	48 01 d0             	add    %rdx,%rax
  803f00:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f04:	0f b7 c0             	movzwl %ax,%eax
}
  803f07:	c9                   	leaveq 
  803f08:	c3                   	retq   
