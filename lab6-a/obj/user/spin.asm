
obj/user/spin.debug:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
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
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 21 1f 80 00 00 	movabs $0x801f21,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 68 47 80 00 00 	movabs $0x804768,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf 88 47 80 00 00 	movabs $0x804788,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf b0 47 80 00 00 	movabs $0x8047b0,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 10          	sub    $0x10,%rsp
  800150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800157:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	25 ff 03 00 00       	and    $0x3ff,%eax
  800168:	48 63 d0             	movslq %eax,%rdx
  80016b:	48 89 d0             	mov    %rdx,%rax
  80016e:	48 c1 e0 03          	shl    $0x3,%rax
  800172:	48 01 d0             	add    %rdx,%rax
  800175:	48 c1 e0 05          	shl    $0x5,%rax
  800179:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800180:	00 00 00 
  800183:	48 01 c2             	add    %rax,%rdx
  800186:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018d:	00 00 00 
  800190:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800197:	7e 14                	jle    8001ad <libmain+0x65>
		binaryname = argv[0];
  800199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019d:	48 8b 10             	mov    (%rax),%rdx
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b4:	48 89 d6             	mov    %rdx,%rsi
  8001b7:	89 c7                	mov    %eax,%edi
  8001b9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c0:	00 00 00 
  8001c3:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001c5:	48 b8 d3 01 80 00 00 	movabs $0x8001d3,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
}
  8001d1:	c9                   	leaveq 
  8001d2:	c3                   	retq   

00000000008001d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d3:	55                   	push   %rbp
  8001d4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001d7:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e8:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax

}
  8001f4:	5d                   	pop    %rbp
  8001f5:	c3                   	retq   

00000000008001f6 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
  8001fa:	48 83 ec 10          	sub    $0x10,%rsp
  8001fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800201:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800209:	8b 00                	mov    (%rax),%eax
  80020b:	8d 48 01             	lea    0x1(%rax),%ecx
  80020e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800212:	89 0a                	mov    %ecx,(%rdx)
  800214:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800217:	89 d1                	mov    %edx,%ecx
  800219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021d:	48 98                	cltq   
  80021f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800227:	8b 00                	mov    (%rax),%eax
  800229:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022e:	75 2c                	jne    80025c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800234:	8b 00                	mov    (%rax),%eax
  800236:	48 98                	cltq   
  800238:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023c:	48 83 c2 08          	add    $0x8,%rdx
  800240:	48 89 c6             	mov    %rax,%rsi
  800243:	48 89 d7             	mov    %rdx,%rdi
  800246:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
        b->idx = 0;
  800252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800256:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80025c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800260:	8b 40 04             	mov    0x4(%rax),%eax
  800263:	8d 50 01             	lea    0x1(%rax),%edx
  800266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80026d:	c9                   	leaveq 
  80026e:	c3                   	retq   

000000000080026f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80026f:	55                   	push   %rbp
  800270:	48 89 e5             	mov    %rsp,%rbp
  800273:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800281:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800288:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80028f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800296:	48 8b 0a             	mov    (%rdx),%rcx
  800299:	48 89 08             	mov    %rcx,(%rax)
  80029c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b3:	00 00 00 
    b.cnt = 0;
  8002b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002bd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002c0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002c7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002ce:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d5:	48 89 c6             	mov    %rax,%rsi
  8002d8:	48 bf f6 01 80 00 00 	movabs $0x8001f6,%rdi
  8002df:	00 00 00 
  8002e2:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002ee:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f4:	48 98                	cltq   
  8002f6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002fd:	48 83 c2 08          	add    $0x8,%rdx
  800301:	48 89 c6             	mov    %rax,%rsi
  800304:	48 89 d7             	mov    %rdx,%rdi
  800307:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80030e:	00 00 00 
  800311:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800313:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   

000000000080031b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80031b:	55                   	push   %rbp
  80031c:	48 89 e5             	mov    %rsp,%rbp
  80031f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800326:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80032d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800334:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800342:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800349:	84 c0                	test   %al,%al
  80034b:	74 20                	je     80036d <cprintf+0x52>
  80034d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800351:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800355:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800359:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80035d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800361:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800365:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800369:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80036d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800374:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037b:	00 00 00 
  80037e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800385:	00 00 00 
  800388:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800393:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003af:	48 8b 0a             	mov    (%rdx),%rcx
  8003b2:	48 89 08             	mov    %rcx,(%rax)
  8003b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003c5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d3:	48 89 d6             	mov    %rdx,%rsi
  8003d6:	48 89 c7             	mov    %rax,%rdi
  8003d9:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
  8003e5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003eb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	53                   	push   %rbx
  8003f8:	48 83 ec 38          	sub    $0x38,%rsp
  8003fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800400:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800408:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80040f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800413:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800416:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041a:	77 3b                	ja     800457 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80041f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800423:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042a:	ba 00 00 00 00       	mov    $0x0,%edx
  80042f:	48 f7 f3             	div    %rbx
  800432:	48 89 c2             	mov    %rax,%rdx
  800435:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800438:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80043f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800443:	41 89 f9             	mov    %edi,%r9d
  800446:	48 89 c7             	mov    %rax,%rdi
  800449:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  800450:	00 00 00 
  800453:	ff d0                	callq  *%rax
  800455:	eb 1e                	jmp    800475 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800457:	eb 12                	jmp    80046b <printnum+0x78>
			putch(padc, putdat);
  800459:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800464:	48 89 ce             	mov    %rcx,%rsi
  800467:	89 d7                	mov    %edx,%edi
  800469:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80046f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800473:	7f e4                	jg     800459 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800475:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80047c:	ba 00 00 00 00       	mov    $0x0,%edx
  800481:	48 f7 f1             	div    %rcx
  800484:	48 89 d0             	mov    %rdx,%rax
  800487:	48 ba f0 49 80 00 00 	movabs $0x8049f0,%rdx
  80048e:	00 00 00 
  800491:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800495:	0f be d0             	movsbl %al,%edx
  800498:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80049c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a0:	48 89 ce             	mov    %rcx,%rsi
  8004a3:	89 d7                	mov    %edx,%edi
  8004a5:	ff d0                	callq  *%rax
}
  8004a7:	48 83 c4 38          	add    $0x38,%rsp
  8004ab:	5b                   	pop    %rbx
  8004ac:	5d                   	pop    %rbp
  8004ad:	c3                   	retq   

00000000008004ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ae:	55                   	push   %rbp
  8004af:	48 89 e5             	mov    %rsp,%rbp
  8004b2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ba:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004bd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c1:	7e 52                	jle    800515 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	8b 00                	mov    (%rax),%eax
  8004c9:	83 f8 30             	cmp    $0x30,%eax
  8004cc:	73 24                	jae    8004f2 <getuint+0x44>
  8004ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004da:	8b 00                	mov    (%rax),%eax
  8004dc:	89 c0                	mov    %eax,%eax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e5:	8b 12                	mov    (%rdx),%edx
  8004e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ee:	89 0a                	mov    %ecx,(%rdx)
  8004f0:	eb 17                	jmp    800509 <getuint+0x5b>
  8004f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fa:	48 89 d0             	mov    %rdx,%rax
  8004fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800501:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800505:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800509:	48 8b 00             	mov    (%rax),%rax
  80050c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800510:	e9 a3 00 00 00       	jmpq   8005b8 <getuint+0x10a>
	else if (lflag)
  800515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800519:	74 4f                	je     80056a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051f:	8b 00                	mov    (%rax),%eax
  800521:	83 f8 30             	cmp    $0x30,%eax
  800524:	73 24                	jae    80054a <getuint+0x9c>
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	89 c0                	mov    %eax,%eax
  800536:	48 01 d0             	add    %rdx,%rax
  800539:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053d:	8b 12                	mov    (%rdx),%edx
  80053f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800546:	89 0a                	mov    %ecx,(%rdx)
  800548:	eb 17                	jmp    800561 <getuint+0xb3>
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800552:	48 89 d0             	mov    %rdx,%rax
  800555:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800559:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800561:	48 8b 00             	mov    (%rax),%rax
  800564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800568:	eb 4e                	jmp    8005b8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056e:	8b 00                	mov    (%rax),%eax
  800570:	83 f8 30             	cmp    $0x30,%eax
  800573:	73 24                	jae    800599 <getuint+0xeb>
  800575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800579:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	8b 00                	mov    (%rax),%eax
  800583:	89 c0                	mov    %eax,%eax
  800585:	48 01 d0             	add    %rdx,%rax
  800588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058c:	8b 12                	mov    (%rdx),%edx
  80058e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800591:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800595:	89 0a                	mov    %ecx,(%rdx)
  800597:	eb 17                	jmp    8005b0 <getuint+0x102>
  800599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a1:	48 89 d0             	mov    %rdx,%rax
  8005a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b0:	8b 00                	mov    (%rax),%eax
  8005b2:	89 c0                	mov    %eax,%eax
  8005b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005bc:	c9                   	leaveq 
  8005bd:	c3                   	retq   

00000000008005be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005be:	55                   	push   %rbp
  8005bf:	48 89 e5             	mov    %rsp,%rbp
  8005c2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d1:	7e 52                	jle    800625 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	83 f8 30             	cmp    $0x30,%eax
  8005dc:	73 24                	jae    800602 <getint+0x44>
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	89 c0                	mov    %eax,%eax
  8005ee:	48 01 d0             	add    %rdx,%rax
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	8b 12                	mov    (%rdx),%edx
  8005f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	89 0a                	mov    %ecx,(%rdx)
  800600:	eb 17                	jmp    800619 <getint+0x5b>
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800619:	48 8b 00             	mov    (%rax),%rax
  80061c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800620:	e9 a3 00 00 00       	jmpq   8006c8 <getint+0x10a>
	else if (lflag)
  800625:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800629:	74 4f                	je     80067a <getint+0xbc>
		x=va_arg(*ap, long);
  80062b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062f:	8b 00                	mov    (%rax),%eax
  800631:	83 f8 30             	cmp    $0x30,%eax
  800634:	73 24                	jae    80065a <getint+0x9c>
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	89 c0                	mov    %eax,%eax
  800646:	48 01 d0             	add    %rdx,%rax
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	8b 12                	mov    (%rdx),%edx
  80064f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	89 0a                	mov    %ecx,(%rdx)
  800658:	eb 17                	jmp    800671 <getint+0xb3>
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800662:	48 89 d0             	mov    %rdx,%rax
  800665:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800671:	48 8b 00             	mov    (%rax),%rax
  800674:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800678:	eb 4e                	jmp    8006c8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	83 f8 30             	cmp    $0x30,%eax
  800683:	73 24                	jae    8006a9 <getint+0xeb>
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	8b 00                	mov    (%rax),%eax
  800693:	89 c0                	mov    %eax,%eax
  800695:	48 01 d0             	add    %rdx,%rax
  800698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069c:	8b 12                	mov    (%rdx),%edx
  80069e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	89 0a                	mov    %ecx,(%rdx)
  8006a7:	eb 17                	jmp    8006c0 <getint+0x102>
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b1:	48 89 d0             	mov    %rdx,%rax
  8006b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c0:	8b 00                	mov    (%rax),%eax
  8006c2:	48 98                	cltq   
  8006c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006cc:	c9                   	leaveq 
  8006cd:	c3                   	retq   

00000000008006ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ce:	55                   	push   %rbp
  8006cf:	48 89 e5             	mov    %rsp,%rbp
  8006d2:	41 54                	push   %r12
  8006d4:	53                   	push   %rbx
  8006d5:	48 83 ec 60          	sub    $0x60,%rsp
  8006d9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006dd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006e9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ed:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f1:	48 8b 0a             	mov    (%rdx),%rcx
  8006f4:	48 89 08             	mov    %rcx,(%rax)
  8006f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800703:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x52>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 cc 04 00 00    	je     800bdd <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800711:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800715:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800719:	48 89 d6             	mov    %rdx,%rsi
  80071c:	89 df                	mov    %ebx,%edi
  80071e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800724:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800728:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80072c:	0f b6 00             	movzbl (%rax),%eax
  80072f:	0f b6 d8             	movzbl %al,%ebx
  800732:	83 fb 25             	cmp    $0x25,%ebx
  800735:	75 d2                	jne    800709 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800737:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80073b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800742:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800749:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800750:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800757:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80075f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800763:	0f b6 00             	movzbl (%rax),%eax
  800766:	0f b6 d8             	movzbl %al,%ebx
  800769:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80076c:	83 f8 55             	cmp    $0x55,%eax
  80076f:	0f 87 34 04 00 00    	ja     800ba9 <vprintfmt+0x4db>
  800775:	89 c0                	mov    %eax,%eax
  800777:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80077e:	00 
  80077f:	48 b8 18 4a 80 00 00 	movabs $0x804a18,%rax
  800786:	00 00 00 
  800789:	48 01 d0             	add    %rdx,%rax
  80078c:	48 8b 00             	mov    (%rax),%rax
  80078f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800791:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800795:	eb c0                	jmp    800757 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800797:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80079b:	eb ba                	jmp    800757 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a7:	89 d0                	mov    %edx,%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	01 d0                	add    %edx,%eax
  8007ae:	01 c0                	add    %eax,%eax
  8007b0:	01 d8                	add    %ebx,%eax
  8007b2:	83 e8 30             	sub    $0x30,%eax
  8007b5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bc:	0f b6 00             	movzbl (%rax),%eax
  8007bf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c5:	7e 0c                	jle    8007d3 <vprintfmt+0x105>
  8007c7:	83 fb 39             	cmp    $0x39,%ebx
  8007ca:	7f 07                	jg     8007d3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d1                	jmp    8007a4 <vprintfmt+0xd6>
			goto process_precision;
  8007d3:	eb 58                	jmp    80082d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d8:	83 f8 30             	cmp    $0x30,%eax
  8007db:	73 17                	jae    8007f4 <vprintfmt+0x126>
  8007dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e4:	89 c0                	mov    %eax,%eax
  8007e6:	48 01 d0             	add    %rdx,%rax
  8007e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ec:	83 c2 08             	add    $0x8,%edx
  8007ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f2:	eb 0f                	jmp    800803 <vprintfmt+0x135>
  8007f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f8:	48 89 d0             	mov    %rdx,%rax
  8007fb:	48 83 c2 08          	add    $0x8,%rdx
  8007ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800803:	8b 00                	mov    (%rax),%eax
  800805:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800808:	eb 23                	jmp    80082d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80080a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080e:	79 0c                	jns    80081c <vprintfmt+0x14e>
				width = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800817:	e9 3b ff ff ff       	jmpq   800757 <vprintfmt+0x89>
  80081c:	e9 36 ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800821:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800828:	e9 2a ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800831:	79 12                	jns    800845 <vprintfmt+0x177>
				width = precision, precision = -1;
  800833:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800836:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800839:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800840:	e9 12 ff ff ff       	jmpq   800757 <vprintfmt+0x89>
  800845:	e9 0d ff ff ff       	jmpq   800757 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80084e:	e9 04 ff ff ff       	jmpq   800757 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800853:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800856:	83 f8 30             	cmp    $0x30,%eax
  800859:	73 17                	jae    800872 <vprintfmt+0x1a4>
  80085b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800862:	89 c0                	mov    %eax,%eax
  800864:	48 01 d0             	add    %rdx,%rax
  800867:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086a:	83 c2 08             	add    $0x8,%edx
  80086d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800870:	eb 0f                	jmp    800881 <vprintfmt+0x1b3>
  800872:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 83 c2 08          	add    $0x8,%rdx
  80087d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800881:	8b 10                	mov    (%rax),%edx
  800883:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800887:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088b:	48 89 ce             	mov    %rcx,%rsi
  80088e:	89 d7                	mov    %edx,%edi
  800890:	ff d0                	callq  *%rax
			break;
  800892:	e9 40 03 00 00       	jmpq   800bd7 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800897:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 17                	jae    8008b6 <vprintfmt+0x1e8>
  80089f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a6:	89 c0                	mov    %eax,%eax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ae:	83 c2 08             	add    $0x8,%edx
  8008b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b4:	eb 0f                	jmp    8008c5 <vprintfmt+0x1f7>
  8008b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ba:	48 89 d0             	mov    %rdx,%rax
  8008bd:	48 83 c2 08          	add    $0x8,%rdx
  8008c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	79 02                	jns    8008cd <vprintfmt+0x1ff>
				err = -err;
  8008cb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008cd:	83 fb 15             	cmp    $0x15,%ebx
  8008d0:	7f 16                	jg     8008e8 <vprintfmt+0x21a>
  8008d2:	48 b8 40 49 80 00 00 	movabs $0x804940,%rax
  8008d9:	00 00 00 
  8008dc:	48 63 d3             	movslq %ebx,%rdx
  8008df:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e3:	4d 85 e4             	test   %r12,%r12
  8008e6:	75 2e                	jne    800916 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f0:	89 d9                	mov    %ebx,%ecx
  8008f2:	48 ba 01 4a 80 00 00 	movabs $0x804a01,%rdx
  8008f9:	00 00 00 
  8008fc:	48 89 c7             	mov    %rax,%rdi
  8008ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800904:	49 b8 e6 0b 80 00 00 	movabs $0x800be6,%r8
  80090b:	00 00 00 
  80090e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 c1 02 00 00       	jmpq   800bd7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091e:	4c 89 e1             	mov    %r12,%rcx
  800921:	48 ba 0a 4a 80 00 00 	movabs $0x804a0a,%rdx
  800928:	00 00 00 
  80092b:	48 89 c7             	mov    %rax,%rdi
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
  800933:	49 b8 e6 0b 80 00 00 	movabs $0x800be6,%r8
  80093a:	00 00 00 
  80093d:	41 ff d0             	callq  *%r8
			break;
  800940:	e9 92 02 00 00       	jmpq   800bd7 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800945:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800948:	83 f8 30             	cmp    $0x30,%eax
  80094b:	73 17                	jae    800964 <vprintfmt+0x296>
  80094d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800951:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800954:	89 c0                	mov    %eax,%eax
  800956:	48 01 d0             	add    %rdx,%rax
  800959:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095c:	83 c2 08             	add    $0x8,%edx
  80095f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800962:	eb 0f                	jmp    800973 <vprintfmt+0x2a5>
  800964:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800968:	48 89 d0             	mov    %rdx,%rax
  80096b:	48 83 c2 08          	add    $0x8,%rdx
  80096f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800973:	4c 8b 20             	mov    (%rax),%r12
  800976:	4d 85 e4             	test   %r12,%r12
  800979:	75 0a                	jne    800985 <vprintfmt+0x2b7>
				p = "(null)";
  80097b:	49 bc 0d 4a 80 00 00 	movabs $0x804a0d,%r12
  800982:	00 00 00 
			if (width > 0 && padc != '-')
  800985:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800989:	7e 3f                	jle    8009ca <vprintfmt+0x2fc>
  80098b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80098f:	74 39                	je     8009ca <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800994:	48 98                	cltq   
  800996:	48 89 c6             	mov    %rax,%rsi
  800999:	4c 89 e7             	mov    %r12,%rdi
  80099c:	48 b8 92 0e 80 00 00 	movabs $0x800e92,%rax
  8009a3:	00 00 00 
  8009a6:	ff d0                	callq  *%rax
  8009a8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009ab:	eb 17                	jmp    8009c4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ad:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b9:	48 89 ce             	mov    %rcx,%rsi
  8009bc:	89 d7                	mov    %edx,%edi
  8009be:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c8:	7f e3                	jg     8009ad <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	eb 37                	jmp    800a03 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d0:	74 1e                	je     8009f0 <vprintfmt+0x322>
  8009d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d5:	7e 05                	jle    8009dc <vprintfmt+0x30e>
  8009d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8009da:	7e 14                	jle    8009f0 <vprintfmt+0x322>
					putch('?', putdat);
  8009dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e4:	48 89 d6             	mov    %rdx,%rsi
  8009e7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009ec:	ff d0                	callq  *%rax
  8009ee:	eb 0f                	jmp    8009ff <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f8:	48 89 d6             	mov    %rdx,%rsi
  8009fb:	89 df                	mov    %ebx,%edi
  8009fd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ff:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a03:	4c 89 e0             	mov    %r12,%rax
  800a06:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a0a:	0f b6 00             	movzbl (%rax),%eax
  800a0d:	0f be d8             	movsbl %al,%ebx
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	74 10                	je     800a24 <vprintfmt+0x356>
  800a14:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a18:	78 b2                	js     8009cc <vprintfmt+0x2fe>
  800a1a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a22:	79 a8                	jns    8009cc <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a24:	eb 16                	jmp    800a3c <vprintfmt+0x36e>
				putch(' ', putdat);
  800a26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2e:	48 89 d6             	mov    %rdx,%rsi
  800a31:	bf 20 00 00 00       	mov    $0x20,%edi
  800a36:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a38:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a40:	7f e4                	jg     800a26 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a42:	e9 90 01 00 00       	jmpq   800bd7 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4b:	be 03 00 00 00       	mov    $0x3,%esi
  800a50:	48 89 c7             	mov    %rax,%rdi
  800a53:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800a5a:	00 00 00 
  800a5d:	ff d0                	callq  *%rax
  800a5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a67:	48 85 c0             	test   %rax,%rax
  800a6a:	79 1d                	jns    800a89 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a74:	48 89 d6             	mov    %rdx,%rsi
  800a77:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a7c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a82:	48 f7 d8             	neg    %rax
  800a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a89:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a90:	e9 d5 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a99:	be 03 00 00 00       	mov    $0x3,%esi
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800aa8:	00 00 00 
  800aab:	ff d0                	callq  *%rax
  800aad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab8:	e9 ad 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800abd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ac0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac4:	89 d6                	mov    %edx,%esi
  800ac6:	48 89 c7             	mov    %rax,%rdi
  800ac9:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800ad0:	00 00 00 
  800ad3:	ff d0                	callq  *%rax
  800ad5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ae0:	e9 85 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ae5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aed:	48 89 d6             	mov    %rdx,%rsi
  800af0:	bf 30 00 00 00       	mov    $0x30,%edi
  800af5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 d6             	mov    %rdx,%rsi
  800b02:	bf 78 00 00 00       	mov    $0x78,%edi
  800b07:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0c:	83 f8 30             	cmp    $0x30,%eax
  800b0f:	73 17                	jae    800b28 <vprintfmt+0x45a>
  800b11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b18:	89 c0                	mov    %eax,%eax
  800b1a:	48 01 d0             	add    %rdx,%rax
  800b1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b20:	83 c2 08             	add    $0x8,%edx
  800b23:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b26:	eb 0f                	jmp    800b37 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2c:	48 89 d0             	mov    %rdx,%rax
  800b2f:	48 83 c2 08          	add    $0x8,%rdx
  800b33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b37:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b3e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b45:	eb 23                	jmp    800b6a <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4b:	be 03 00 00 00       	mov    $0x3,%esi
  800b50:	48 89 c7             	mov    %rax,%rdi
  800b53:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	callq  *%rax
  800b5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b63:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b72:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b79:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b81:	45 89 c1             	mov    %r8d,%r9d
  800b84:	41 89 f8             	mov    %edi,%r8d
  800b87:	48 89 c7             	mov    %rax,%rdi
  800b8a:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  800b91:	00 00 00 
  800b94:	ff d0                	callq  *%rax
			break;
  800b96:	eb 3f                	jmp    800bd7 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	48 89 d6             	mov    %rdx,%rsi
  800ba3:	89 df                	mov    %ebx,%edi
  800ba5:	ff d0                	callq  *%rax
			break;
  800ba7:	eb 2e                	jmp    800bd7 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb1:	48 89 d6             	mov    %rdx,%rsi
  800bb4:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bbb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc0:	eb 05                	jmp    800bc7 <vprintfmt+0x4f9>
  800bc2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcb:	48 83 e8 01          	sub    $0x1,%rax
  800bcf:	0f b6 00             	movzbl (%rax),%eax
  800bd2:	3c 25                	cmp    $0x25,%al
  800bd4:	75 ec                	jne    800bc2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bd6:	90                   	nop
		}
	}
  800bd7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd8:	e9 43 fb ff ff       	jmpq   800720 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bdd:	48 83 c4 60          	add    $0x60,%rsp
  800be1:	5b                   	pop    %rbx
  800be2:	41 5c                	pop    %r12
  800be4:	5d                   	pop    %rbp
  800be5:	c3                   	retq   

0000000000800be6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be6:	55                   	push   %rbp
  800be7:	48 89 e5             	mov    %rsp,%rbp
  800bea:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c14:	84 c0                	test   %al,%al
  800c16:	74 20                	je     800c38 <printfmt+0x52>
  800c18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c38:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c46:	00 00 00 
  800c49:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c50:	00 00 00 
  800c53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c57:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c65:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c73:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c7a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c81:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c88:	48 89 c7             	mov    %rax,%rdi
  800c8b:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800c92:	00 00 00 
  800c95:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c97:	c9                   	leaveq 
  800c98:	c3                   	retq   

0000000000800c99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c99:	55                   	push   %rbp
  800c9a:	48 89 e5             	mov    %rsp,%rbp
  800c9d:	48 83 ec 10          	sub    $0x10,%rsp
  800ca1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cac:	8b 40 10             	mov    0x10(%rax),%eax
  800caf:	8d 50 01             	lea    0x1(%rax),%edx
  800cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbd:	48 8b 10             	mov    (%rax),%rdx
  800cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc8:	48 39 c2             	cmp    %rax,%rdx
  800ccb:	73 17                	jae    800ce4 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdc:	48 89 0a             	mov    %rcx,(%rdx)
  800cdf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce2:	88 10                	mov    %dl,(%rax)
}
  800ce4:	c9                   	leaveq 
  800ce5:	c3                   	retq   

0000000000800ce6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce6:	55                   	push   %rbp
  800ce7:	48 89 e5             	mov    %rsp,%rbp
  800cea:	48 83 ec 50          	sub    $0x50,%rsp
  800cee:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d01:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d05:	48 8b 0a             	mov    (%rdx),%rcx
  800d08:	48 89 08             	mov    %rcx,(%rax)
  800d0b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d13:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d17:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d23:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d26:	48 98                	cltq   
  800d28:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d30:	48 01 d0             	add    %rdx,%rax
  800d33:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d3e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d43:	74 06                	je     800d4b <vsnprintf+0x65>
  800d45:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d49:	7f 07                	jg     800d52 <vsnprintf+0x6c>
		return -E_INVAL;
  800d4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d50:	eb 2f                	jmp    800d81 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d52:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d56:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d5a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d5e:	48 89 c6             	mov    %rax,%rsi
  800d61:	48 bf 99 0c 80 00 00 	movabs $0x800c99,%rdi
  800d68:	00 00 00 
  800d6b:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d7b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d7e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d81:	c9                   	leaveq 
  800d82:	c3                   	retq   

0000000000800d83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d83:	55                   	push   %rbp
  800d84:	48 89 e5             	mov    %rsp,%rbp
  800d87:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d8e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d95:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d9b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db0:	84 c0                	test   %al,%al
  800db2:	74 20                	je     800dd4 <snprintf+0x51>
  800db4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ddb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de2:	00 00 00 
  800de5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dec:	00 00 00 
  800def:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dfa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e01:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e08:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e16:	48 8b 0a             	mov    (%rdx),%rcx
  800e19:	48 89 08             	mov    %rcx,(%rax)
  800e1c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e20:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e24:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e28:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e2c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e33:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e3a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e40:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e5c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e62:	c9                   	leaveq 
  800e63:	c3                   	retq   

0000000000800e64 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e64:	55                   	push   %rbp
  800e65:	48 89 e5             	mov    %rsp,%rbp
  800e68:	48 83 ec 18          	sub    $0x18,%rsp
  800e6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e77:	eb 09                	jmp    800e82 <strlen+0x1e>
		n++;
  800e79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	0f b6 00             	movzbl (%rax),%eax
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 ec                	jne    800e79 <strlen+0x15>
		n++;
	return n;
  800e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e90:	c9                   	leaveq 
  800e91:	c3                   	retq   

0000000000800e92 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e92:	55                   	push   %rbp
  800e93:	48 89 e5             	mov    %rsp,%rbp
  800e96:	48 83 ec 20          	sub    $0x20,%rsp
  800e9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea9:	eb 0e                	jmp    800eb9 <strnlen+0x27>
		n++;
  800eab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eaf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ebe:	74 0b                	je     800ecb <strnlen+0x39>
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	0f b6 00             	movzbl (%rax),%eax
  800ec7:	84 c0                	test   %al,%al
  800ec9:	75 e0                	jne    800eab <strnlen+0x19>
		n++;
	return n;
  800ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ece:	c9                   	leaveq 
  800ecf:	c3                   	retq   

0000000000800ed0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	48 83 ec 20          	sub    $0x20,%rsp
  800ed8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee8:	90                   	nop
  800ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f01:	0f b6 12             	movzbl (%rdx),%edx
  800f04:	88 10                	mov    %dl,(%rax)
  800f06:	0f b6 00             	movzbl (%rax),%eax
  800f09:	84 c0                	test   %al,%al
  800f0b:	75 dc                	jne    800ee9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 20          	sub    $0x20,%rsp
  800f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f27:	48 89 c7             	mov    %rax,%rdi
  800f2a:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  800f31:	00 00 00 
  800f34:	ff d0                	callq  *%rax
  800f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3c:	48 63 d0             	movslq %eax,%rdx
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f43:	48 01 c2             	add    %rax,%rdx
  800f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4a:	48 89 c6             	mov    %rax,%rsi
  800f4d:	48 89 d7             	mov    %rdx,%rdi
  800f50:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
	return dst;
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f60:	c9                   	leaveq 
  800f61:	c3                   	retq   

0000000000800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 83 ec 28          	sub    $0x28,%rsp
  800f6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f7e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f85:	00 
  800f86:	eb 2a                	jmp    800fb2 <strncpy+0x50>
		*dst++ = *src;
  800f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f94:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f98:	0f b6 12             	movzbl (%rdx),%edx
  800f9b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa1:	0f b6 00             	movzbl (%rax),%eax
  800fa4:	84 c0                	test   %al,%al
  800fa6:	74 05                	je     800fad <strncpy+0x4b>
			src++;
  800fa8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fba:	72 cc                	jb     800f88 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 28          	sub    $0x28,%rsp
  800fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fde:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe3:	74 3d                	je     801022 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe5:	eb 1d                	jmp    801004 <strlcpy+0x42>
			*dst++ = *src++;
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ffb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fff:	0f b6 12             	movzbl (%rdx),%edx
  801002:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801004:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801009:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100e:	74 0b                	je     80101b <strlcpy+0x59>
  801010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	84 c0                	test   %al,%al
  801019:	75 cc                	jne    800fe7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80101b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801022:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102a:	48 29 c2             	sub    %rax,%rdx
  80102d:	48 89 d0             	mov    %rdx,%rax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 10          	sub    $0x10,%rsp
  80103a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801042:	eb 0a                	jmp    80104e <strcmp+0x1c>
		p++, q++;
  801044:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801049:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	74 12                	je     80106b <strcmp+0x39>
  801059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105d:	0f b6 10             	movzbl (%rax),%edx
  801060:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801064:	0f b6 00             	movzbl (%rax),%eax
  801067:	38 c2                	cmp    %al,%dl
  801069:	74 d9                	je     801044 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80106b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801079:	0f b6 00             	movzbl (%rax),%eax
  80107c:	0f b6 c0             	movzbl %al,%eax
  80107f:	29 c2                	sub    %eax,%edx
  801081:	89 d0                	mov    %edx,%eax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 18          	sub    $0x18,%rsp
  80108d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801091:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801095:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801099:	eb 0f                	jmp    8010aa <strncmp+0x25>
		n--, p++, q++;
  80109b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010af:	74 1d                	je     8010ce <strncmp+0x49>
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	74 12                	je     8010ce <strncmp+0x49>
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c0:	0f b6 10             	movzbl (%rax),%edx
  8010c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	38 c2                	cmp    %al,%dl
  8010cc:	74 cd                	je     80109b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d3:	75 07                	jne    8010dc <strncmp+0x57>
		return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb 18                	jmp    8010f4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	0f b6 d0             	movzbl %al,%edx
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	0f b6 00             	movzbl (%rax),%eax
  8010ed:	0f b6 c0             	movzbl %al,%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 0c          	sub    $0xc,%rsp
  8010fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801102:	89 f0                	mov    %esi,%eax
  801104:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801107:	eb 17                	jmp    801120 <strchr+0x2a>
		if (*s == c)
  801109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110d:	0f b6 00             	movzbl (%rax),%eax
  801110:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801113:	75 06                	jne    80111b <strchr+0x25>
			return (char *) s;
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	eb 15                	jmp    801130 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	84 c0                	test   %al,%al
  801129:	75 de                	jne    801109 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801130:	c9                   	leaveq 
  801131:	c3                   	retq   

0000000000801132 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	48 83 ec 0c          	sub    $0xc,%rsp
  80113a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113e:	89 f0                	mov    %esi,%eax
  801140:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801143:	eb 13                	jmp    801158 <strfind+0x26>
		if (*s == c)
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801149:	0f b6 00             	movzbl (%rax),%eax
  80114c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80114f:	75 02                	jne    801153 <strfind+0x21>
			break;
  801151:	eb 10                	jmp    801163 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801153:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115c:	0f b6 00             	movzbl (%rax),%eax
  80115f:	84 c0                	test   %al,%al
  801161:	75 e2                	jne    801145 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801167:	c9                   	leaveq 
  801168:	c3                   	retq   

0000000000801169 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	48 83 ec 18          	sub    $0x18,%rsp
  801171:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801175:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801178:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80117c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801181:	75 06                	jne    801189 <memset+0x20>
		return v;
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801187:	eb 69                	jmp    8011f2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	48 85 c0             	test   %rax,%rax
  801193:	75 48                	jne    8011dd <memset+0x74>
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 3c                	jne    8011dd <memset+0x74>
		c &= 0xFF;
  8011a1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ab:	c1 e0 18             	shl    $0x18,%eax
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b3:	c1 e0 10             	shl    $0x10,%eax
  8011b6:	09 c2                	or     %eax,%edx
  8011b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bb:	c1 e0 08             	shl    $0x8,%eax
  8011be:	09 d0                	or     %edx,%eax
  8011c0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c7:	48 c1 e8 02          	shr    $0x2,%rax
  8011cb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d5:	48 89 d7             	mov    %rdx,%rdi
  8011d8:	fc                   	cld    
  8011d9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011db:	eb 11                	jmp    8011ee <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e8:	48 89 d7             	mov    %rdx,%rdi
  8011eb:	fc                   	cld    
  8011ec:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f2:	c9                   	leaveq 
  8011f3:	c3                   	retq   

00000000008011f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	48 83 ec 28          	sub    $0x28,%rsp
  8011fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801200:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801204:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801208:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801214:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801220:	0f 83 88 00 00 00    	jae    8012ae <memmove+0xba>
  801226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122e:	48 01 d0             	add    %rdx,%rax
  801231:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801235:	76 77                	jbe    8012ae <memmove+0xba>
		s += n;
  801237:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80123f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801243:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124b:	83 e0 03             	and    $0x3,%eax
  80124e:	48 85 c0             	test   %rax,%rax
  801251:	75 3b                	jne    80128e <memmove+0x9a>
  801253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801257:	83 e0 03             	and    $0x3,%eax
  80125a:	48 85 c0             	test   %rax,%rax
  80125d:	75 2f                	jne    80128e <memmove+0x9a>
  80125f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 23                	jne    80128e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126f:	48 83 e8 04          	sub    $0x4,%rax
  801273:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801277:	48 83 ea 04          	sub    $0x4,%rdx
  80127b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80127f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801283:	48 89 c7             	mov    %rax,%rdi
  801286:	48 89 d6             	mov    %rdx,%rsi
  801289:	fd                   	std    
  80128a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80128c:	eb 1d                	jmp    8012ab <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80129e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a2:	48 89 d7             	mov    %rdx,%rdi
  8012a5:	48 89 c1             	mov    %rax,%rcx
  8012a8:	fd                   	std    
  8012a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012ab:	fc                   	cld    
  8012ac:	eb 57                	jmp    801305 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	83 e0 03             	and    $0x3,%eax
  8012b5:	48 85 c0             	test   %rax,%rax
  8012b8:	75 36                	jne    8012f0 <memmove+0xfc>
  8012ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012be:	83 e0 03             	and    $0x3,%eax
  8012c1:	48 85 c0             	test   %rax,%rax
  8012c4:	75 2a                	jne    8012f0 <memmove+0xfc>
  8012c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ca:	83 e0 03             	and    $0x3,%eax
  8012cd:	48 85 c0             	test   %rax,%rax
  8012d0:	75 1e                	jne    8012f0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d6:	48 c1 e8 02          	shr    $0x2,%rax
  8012da:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e5:	48 89 c7             	mov    %rax,%rdi
  8012e8:	48 89 d6             	mov    %rdx,%rsi
  8012eb:	fc                   	cld    
  8012ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ee:	eb 15                	jmp    801305 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012fc:	48 89 c7             	mov    %rax,%rdi
  8012ff:	48 89 d6             	mov    %rdx,%rsi
  801302:	fc                   	cld    
  801303:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 18          	sub    $0x18,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80131b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80131f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801323:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132b:	48 89 ce             	mov    %rcx,%rsi
  80132e:	48 89 c7             	mov    %rax,%rdi
  801331:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801338:	00 00 00 
  80133b:	ff d0                	callq  *%rax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 28          	sub    $0x28,%rsp
  801347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801357:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80135b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801363:	eb 36                	jmp    80139b <memcmp+0x5c>
		if (*s1 != *s2)
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 10             	movzbl (%rax),%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 1a                	je     801391 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	0f b6 d0             	movzbl %al,%edx
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	0f b6 c0             	movzbl %al,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	eb 20                	jmp    8013b1 <memcmp+0x72>
		s1++, s2++;
  801391:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801396:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80139b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a7:	48 85 c0             	test   %rax,%rax
  8013aa:	75 b9                	jne    801365 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 28          	sub    $0x28,%rsp
  8013bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ce:	48 01 d0             	add    %rdx,%rax
  8013d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d5:	eb 15                	jmp    8013ec <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013db:	0f b6 10             	movzbl (%rax),%edx
  8013de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e1:	38 c2                	cmp    %al,%dl
  8013e3:	75 02                	jne    8013e7 <memfind+0x34>
			break;
  8013e5:	eb 0f                	jmp    8013f6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f4:	72 e1                	jb     8013d7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013fa:	c9                   	leaveq 
  8013fb:	c3                   	retq   

00000000008013fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 83 ec 34          	sub    $0x34,%rsp
  801404:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801408:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80140f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801416:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141e:	eb 05                	jmp    801425 <strtol+0x29>
		s++;
  801420:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	3c 20                	cmp    $0x20,%al
  80142e:	74 f0                	je     801420 <strtol+0x24>
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	3c 09                	cmp    $0x9,%al
  801439:	74 e5                	je     801420 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	3c 2b                	cmp    $0x2b,%al
  801444:	75 07                	jne    80144d <strtol+0x51>
		s++;
  801446:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144b:	eb 17                	jmp    801464 <strtol+0x68>
	else if (*s == '-')
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	3c 2d                	cmp    $0x2d,%al
  801456:	75 0c                	jne    801464 <strtol+0x68>
		s++, neg = 1;
  801458:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801464:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801468:	74 06                	je     801470 <strtol+0x74>
  80146a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146e:	75 28                	jne    801498 <strtol+0x9c>
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	3c 30                	cmp    $0x30,%al
  801479:	75 1d                	jne    801498 <strtol+0x9c>
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	48 83 c0 01          	add    $0x1,%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	3c 78                	cmp    $0x78,%al
  801488:	75 0e                	jne    801498 <strtol+0x9c>
		s += 2, base = 16;
  80148a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80148f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801496:	eb 2c                	jmp    8014c4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801498:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149c:	75 19                	jne    8014b7 <strtol+0xbb>
  80149e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a2:	0f b6 00             	movzbl (%rax),%eax
  8014a5:	3c 30                	cmp    $0x30,%al
  8014a7:	75 0e                	jne    8014b7 <strtol+0xbb>
		s++, base = 8;
  8014a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ae:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b5:	eb 0d                	jmp    8014c4 <strtol+0xc8>
	else if (base == 0)
  8014b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014bb:	75 07                	jne    8014c4 <strtol+0xc8>
		base = 10;
  8014bd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	3c 2f                	cmp    $0x2f,%al
  8014cd:	7e 1d                	jle    8014ec <strtol+0xf0>
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	3c 39                	cmp    $0x39,%al
  8014d8:	7f 12                	jg     8014ec <strtol+0xf0>
			dig = *s - '0';
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	0f be c0             	movsbl %al,%eax
  8014e4:	83 e8 30             	sub    $0x30,%eax
  8014e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ea:	eb 4e                	jmp    80153a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 60                	cmp    $0x60,%al
  8014f5:	7e 1d                	jle    801514 <strtol+0x118>
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	3c 7a                	cmp    $0x7a,%al
  801500:	7f 12                	jg     801514 <strtol+0x118>
			dig = *s - 'a' + 10;
  801502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 57             	sub    $0x57,%eax
  80150f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801512:	eb 26                	jmp    80153a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 40                	cmp    $0x40,%al
  80151d:	7e 48                	jle    801567 <strtol+0x16b>
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	3c 5a                	cmp    $0x5a,%al
  801528:	7f 3d                	jg     801567 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	0f be c0             	movsbl %al,%eax
  801534:	83 e8 37             	sub    $0x37,%eax
  801537:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801540:	7c 02                	jl     801544 <strtol+0x148>
			break;
  801542:	eb 23                	jmp    801567 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801544:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801549:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154c:	48 98                	cltq   
  80154e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801553:	48 89 c2             	mov    %rax,%rdx
  801556:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801559:	48 98                	cltq   
  80155b:	48 01 d0             	add    %rdx,%rax
  80155e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801562:	e9 5d ff ff ff       	jmpq   8014c4 <strtol+0xc8>

	if (endptr)
  801567:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80156c:	74 0b                	je     801579 <strtol+0x17d>
		*endptr = (char *) s;
  80156e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801572:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801576:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80157d:	74 09                	je     801588 <strtol+0x18c>
  80157f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801583:	48 f7 d8             	neg    %rax
  801586:	eb 04                	jmp    80158c <strtol+0x190>
  801588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strstr>:

char * strstr(const char *in, const char *str)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 30          	sub    $0x30,%rsp
  801596:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80159e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015b0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b4:	75 06                	jne    8015bc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	eb 6b                	jmp    801627 <strstr+0x99>

	len = strlen(str);
  8015bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c0:	48 89 c7             	mov    %rax,%rdi
  8015c3:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  8015ca:	00 00 00 
  8015cd:	ff d0                	callq  *%rax
  8015cf:	48 98                	cltq   
  8015d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015eb:	75 07                	jne    8015f4 <strstr+0x66>
				return (char *) 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	eb 33                	jmp    801627 <strstr+0x99>
		} while (sc != c);
  8015f4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015f8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015fb:	75 d8                	jne    8015d5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801601:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	48 89 ce             	mov    %rcx,%rsi
  80160c:	48 89 c7             	mov    %rax,%rdi
  80160f:	48 b8 85 10 80 00 00 	movabs $0x801085,%rax
  801616:	00 00 00 
  801619:	ff d0                	callq  *%rax
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 b6                	jne    8015d5 <strstr+0x47>

	return (char *) (in - 1);
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 83 e8 01          	sub    $0x1,%rax
}
  801627:	c9                   	leaveq 
  801628:	c3                   	retq   

0000000000801629 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801629:	55                   	push   %rbp
  80162a:	48 89 e5             	mov    %rsp,%rbp
  80162d:	53                   	push   %rbx
  80162e:	48 83 ec 48          	sub    $0x48,%rsp
  801632:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801635:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801638:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801640:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801644:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801648:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80164f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801653:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801657:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80165f:	4c 89 c3             	mov    %r8,%rbx
  801662:	cd 30                	int    $0x30
  801664:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801668:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166c:	74 3e                	je     8016ac <syscall+0x83>
  80166e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801673:	7e 37                	jle    8016ac <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801679:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167c:	49 89 d0             	mov    %rdx,%r8
  80167f:	89 c1                	mov    %eax,%ecx
  801681:	48 ba c8 4c 80 00 00 	movabs $0x804cc8,%rdx
  801688:	00 00 00 
  80168b:	be 23 00 00 00       	mov    $0x23,%esi
  801690:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  801697:	00 00 00 
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
  80169f:	49 b9 5e 42 80 00 00 	movabs $0x80425e,%r9
  8016a6:	00 00 00 
  8016a9:	41 ff d1             	callq  *%r9

	return ret;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b0:	48 83 c4 48          	add    $0x48,%rsp
  8016b4:	5b                   	pop    %rbx
  8016b5:	5d                   	pop    %rbp
  8016b6:	c3                   	retq   

00000000008016b7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
  8016bb:	48 83 ec 20          	sub    $0x20,%rsp
  8016bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d6:	00 
  8016d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e3:	48 89 d1             	mov    %rdx,%rcx
  8016e6:	48 89 c2             	mov    %rax,%rdx
  8016e9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f3:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8016fa:	00 00 00 
  8016fd:	ff d0                	callq  *%rax
}
  8016ff:	c9                   	leaveq 
  801700:	c3                   	retq   

0000000000801701 <sys_cgetc>:

int
sys_cgetc(void)
{
  801701:	55                   	push   %rbp
  801702:	48 89 e5             	mov    %rsp,%rbp
  801705:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801709:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801710:	00 
  801711:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801717:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	be 00 00 00 00       	mov    $0x0,%esi
  80172c:	bf 01 00 00 00       	mov    $0x1,%edi
  801731:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 10          	sub    $0x10,%rsp
  801747:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174d:	48 98                	cltq   
  80174f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801756:	00 
  801757:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801763:	b9 00 00 00 00       	mov    $0x0,%ecx
  801768:	48 89 c2             	mov    %rax,%rdx
  80176b:	be 01 00 00 00       	mov    $0x1,%esi
  801770:	bf 03 00 00 00       	mov    $0x3,%edi
  801775:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80177c:	00 00 00 
  80177f:	ff d0                	callq  *%rax
}
  801781:	c9                   	leaveq 
  801782:	c3                   	retq   

0000000000801783 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801783:	55                   	push   %rbp
  801784:	48 89 e5             	mov    %rsp,%rbp
  801787:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801792:	00 
  801793:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801799:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	be 00 00 00 00       	mov    $0x0,%esi
  8017ae:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b3:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	callq  *%rax
}
  8017bf:	c9                   	leaveq 
  8017c0:	c3                   	retq   

00000000008017c1 <sys_yield>:

void
sys_yield(void)
{
  8017c1:	55                   	push   %rbp
  8017c2:	48 89 e5             	mov    %rsp,%rbp
  8017c5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d0:	00 
  8017d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	be 00 00 00 00       	mov    $0x0,%esi
  8017ec:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f1:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
}
  8017fd:	c9                   	leaveq 
  8017fe:	c3                   	retq   

00000000008017ff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ff:	55                   	push   %rbp
  801800:	48 89 e5             	mov    %rsp,%rbp
  801803:	48 83 ec 20          	sub    $0x20,%rsp
  801807:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801811:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801814:	48 63 c8             	movslq %eax,%rcx
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181e:	48 98                	cltq   
  801820:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801827:	00 
  801828:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182e:	49 89 c8             	mov    %rcx,%r8
  801831:	48 89 d1             	mov    %rdx,%rcx
  801834:	48 89 c2             	mov    %rax,%rdx
  801837:	be 01 00 00 00       	mov    $0x1,%esi
  80183c:	bf 04 00 00 00       	mov    $0x4,%edi
  801841:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 30          	sub    $0x30,%rsp
  801857:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801861:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801865:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801869:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186c:	48 63 c8             	movslq %eax,%rcx
  80186f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801873:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801876:	48 63 f0             	movslq %eax,%rsi
  801879:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801880:	48 98                	cltq   
  801882:	48 89 0c 24          	mov    %rcx,(%rsp)
  801886:	49 89 f9             	mov    %rdi,%r9
  801889:	49 89 f0             	mov    %rsi,%r8
  80188c:	48 89 d1             	mov    %rdx,%rcx
  80188f:	48 89 c2             	mov    %rax,%rdx
  801892:	be 01 00 00 00       	mov    $0x1,%esi
  801897:	bf 05 00 00 00       	mov    $0x5,%edi
  80189c:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 20          	sub    $0x20,%rsp
  8018b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c0:	48 98                	cltq   
  8018c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c9:	00 
  8018ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d6:	48 89 d1             	mov    %rdx,%rcx
  8018d9:	48 89 c2             	mov    %rax,%rdx
  8018dc:	be 01 00 00 00       	mov    $0x1,%esi
  8018e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8018e6:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	callq  *%rax
}
  8018f2:	c9                   	leaveq 
  8018f3:	c3                   	retq   

00000000008018f4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	48 83 ec 10          	sub    $0x10,%rsp
  8018fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ff:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801902:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801905:	48 63 d0             	movslq %eax,%rdx
  801908:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190b:	48 98                	cltq   
  80190d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801914:	00 
  801915:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801921:	48 89 d1             	mov    %rdx,%rcx
  801924:	48 89 c2             	mov    %rax,%rdx
  801927:	be 01 00 00 00       	mov    $0x1,%esi
  80192c:	bf 08 00 00 00       	mov    $0x8,%edi
  801931:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
}
  80193d:	c9                   	leaveq 
  80193e:	c3                   	retq   

000000000080193f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80193f:	55                   	push   %rbp
  801940:	48 89 e5             	mov    %rsp,%rbp
  801943:	48 83 ec 20          	sub    $0x20,%rsp
  801947:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80194e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801955:	48 98                	cltq   
  801957:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195e:	00 
  80195f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196b:	48 89 d1             	mov    %rdx,%rcx
  80196e:	48 89 c2             	mov    %rax,%rdx
  801971:	be 01 00 00 00       	mov    $0x1,%esi
  801976:	bf 09 00 00 00       	mov    $0x9,%edi
  80197b:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801982:	00 00 00 
  801985:	ff d0                	callq  *%rax
}
  801987:	c9                   	leaveq 
  801988:	c3                   	retq   

0000000000801989 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
  80198d:	48 83 ec 20          	sub    $0x20,%rsp
  801991:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801994:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199f:	48 98                	cltq   
  8019a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a8:	00 
  8019a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b5:	48 89 d1             	mov    %rdx,%rcx
  8019b8:	48 89 c2             	mov    %rax,%rdx
  8019bb:	be 01 00 00 00       	mov    $0x1,%esi
  8019c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c5:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
}
  8019d1:	c9                   	leaveq 
  8019d2:	c3                   	retq   

00000000008019d3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	48 83 ec 20          	sub    $0x20,%rsp
  8019db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019e6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ec:	48 63 f0             	movslq %eax,%rsi
  8019ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f6:	48 98                	cltq   
  8019f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	49 89 f1             	mov    %rsi,%r9
  801a07:	49 89 c8             	mov    %rcx,%r8
  801a0a:	48 89 d1             	mov    %rdx,%rcx
  801a0d:	48 89 c2             	mov    %rax,%rdx
  801a10:	be 00 00 00 00       	mov    $0x0,%esi
  801a15:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a1a:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
}
  801a26:	c9                   	leaveq 
  801a27:	c3                   	retq   

0000000000801a28 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	48 83 ec 10          	sub    $0x10,%rsp
  801a30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3f:	00 
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a51:	48 89 c2             	mov    %rax,%rdx
  801a54:	be 01 00 00 00       	mov    $0x1,%esi
  801a59:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a5e:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8b:	00 
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	48 89 d1             	mov    %rdx,%rcx
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	be 01 00 00 00       	mov    $0x1,%esi
  801aa3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801aa8:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801aaf:	00 00 00 
  801ab2:	ff d0                	callq  *%rax
}
  801ab4:	c9                   	leaveq 
  801ab5:	c3                   	retq   

0000000000801ab6 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 10          	sub    $0x10,%rsp
  801abe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acd:	00 
  801ace:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ada:	b9 00 00 00 00       	mov    $0x0,%ecx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 00 00 00 00       	mov    $0x0,%esi
  801ae7:	bf 10 00 00 00       	mov    $0x10,%edi
  801aec:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b09:	00 
  801b0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b20:	be 00 00 00 00       	mov    $0x0,%esi
  801b25:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b2a:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 30          	sub    $0x30,%rsp
  801b40:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b48:	48 8b 00             	mov    (%rax),%rax
  801b4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b53:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b57:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b5a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b5d:	83 e0 02             	and    $0x2,%eax
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 4d                	jne    801bb1 <pgfault+0x79>
  801b64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b68:	48 c1 e8 0c          	shr    $0xc,%rax
  801b6c:	48 89 c2             	mov    %rax,%rdx
  801b6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b76:	01 00 00 
  801b79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b7d:	25 00 08 00 00       	and    $0x800,%eax
  801b82:	48 85 c0             	test   %rax,%rax
  801b85:	74 2a                	je     801bb1 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801b87:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  801b8e:	00 00 00 
  801b91:	be 23 00 00 00       	mov    $0x23,%esi
  801b96:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801b9d:	00 00 00 
  801ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba5:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801bac:	00 00 00 
  801baf:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801bb1:	ba 07 00 00 00       	mov    $0x7,%edx
  801bb6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc0:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 85 cd 00 00 00    	jne    801ca1 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801be6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801bea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bee:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf3:	48 89 c6             	mov    %rax,%rsi
  801bf6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bfb:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801c02:	00 00 00 
  801c05:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c11:	48 89 c1             	mov    %rax,%rcx
  801c14:	ba 00 00 00 00       	mov    $0x0,%edx
  801c19:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c23:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	callq  *%rax
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	79 2a                	jns    801c5d <pgfault+0x125>
				panic("Page map at temp address failed");
  801c33:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801c3a:	00 00 00 
  801c3d:	be 30 00 00 00       	mov    $0x30,%esi
  801c42:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801c49:	00 00 00 
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801c58:	00 00 00 
  801c5b:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c62:	bf 00 00 00 00       	mov    $0x0,%edi
  801c67:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
  801c73:	85 c0                	test   %eax,%eax
  801c75:	79 54                	jns    801ccb <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c77:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  801c7e:	00 00 00 
  801c81:	be 32 00 00 00       	mov    $0x32,%esi
  801c86:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801c8d:	00 00 00 
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801c9c:	00 00 00 
  801c9f:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ca1:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  801ca8:	00 00 00 
  801cab:	be 34 00 00 00       	mov    $0x34,%esi
  801cb0:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801cb7:	00 00 00 
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbf:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801cc6:	00 00 00 
  801cc9:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801ccb:	c9                   	leaveq 
  801ccc:	c3                   	retq   

0000000000801ccd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	48 83 ec 20          	sub    $0x20,%rsp
  801cd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cd8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cdb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ce2:	01 00 00 
  801ce5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ce8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cec:	25 07 0e 00 00       	and    $0xe07,%eax
  801cf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801cf4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801cf7:	48 c1 e0 0c          	shl    $0xc,%rax
  801cfb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d02:	25 00 04 00 00       	and    $0x400,%eax
  801d07:	85 c0                	test   %eax,%eax
  801d09:	74 57                	je     801d62 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d0b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d0e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d12:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d19:	41 89 f0             	mov    %esi,%r8d
  801d1c:	48 89 c6             	mov    %rax,%rsi
  801d1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d24:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
  801d30:	85 c0                	test   %eax,%eax
  801d32:	0f 8e 52 01 00 00    	jle    801e8a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d38:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801d3f:	00 00 00 
  801d42:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d47:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801d4e:	00 00 00 
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
  801d56:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801d5d:	00 00 00 
  801d60:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d65:	83 e0 02             	and    $0x2,%eax
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	75 10                	jne    801d7c <duppage+0xaf>
  801d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6f:	25 00 08 00 00       	and    $0x800,%eax
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 84 bb 00 00 00    	je     801e37 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7f:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d84:	80 cc 08             	or     $0x8,%ah
  801d87:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d8a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d8d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d91:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d98:	41 89 f0             	mov    %esi,%r8d
  801d9b:	48 89 c6             	mov    %rax,%rsi
  801d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801da3:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
  801daf:	85 c0                	test   %eax,%eax
  801db1:	7e 2a                	jle    801ddd <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801db3:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801dba:	00 00 00 
  801dbd:	be 55 00 00 00       	mov    $0x55,%esi
  801dc2:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801dc9:	00 00 00 
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801dd8:	00 00 00 
  801ddb:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ddd:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801de0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de8:	41 89 c8             	mov    %ecx,%r8d
  801deb:	48 89 d1             	mov    %rdx,%rcx
  801dee:	ba 00 00 00 00       	mov    $0x0,%edx
  801df3:	48 89 c6             	mov    %rax,%rsi
  801df6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dfb:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	7e 2a                	jle    801e35 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e0b:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801e12:	00 00 00 
  801e15:	be 57 00 00 00       	mov    $0x57,%esi
  801e1a:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801e21:	00 00 00 
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801e30:	00 00 00 
  801e33:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e35:	eb 53                	jmp    801e8a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e37:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e3a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e45:	41 89 f0             	mov    %esi,%r8d
  801e48:	48 89 c6             	mov    %rax,%rsi
  801e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e50:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e57:	00 00 00 
  801e5a:	ff d0                	callq  *%rax
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	7e 2a                	jle    801e8a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e60:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801e67:	00 00 00 
  801e6a:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e6f:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801e76:	00 00 00 
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7e:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  801e85:	00 00 00 
  801e88:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 83 ec 18          	sub    $0x18,%rsp
  801e99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea9:	48 c1 e8 27          	shr    $0x27,%rax
  801ead:	48 89 c2             	mov    %rax,%rdx
  801eb0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801eb7:	01 00 00 
  801eba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebe:	83 e0 01             	and    $0x1,%eax
  801ec1:	48 85 c0             	test   %rax,%rax
  801ec4:	74 51                	je     801f17 <pt_is_mapped+0x86>
  801ec6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eca:	48 c1 e0 0c          	shl    $0xc,%rax
  801ece:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed2:	48 89 c2             	mov    %rax,%rdx
  801ed5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801edc:	01 00 00 
  801edf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee3:	83 e0 01             	and    $0x1,%eax
  801ee6:	48 85 c0             	test   %rax,%rax
  801ee9:	74 2c                	je     801f17 <pt_is_mapped+0x86>
  801eeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eef:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef3:	48 c1 e8 15          	shr    $0x15,%rax
  801ef7:	48 89 c2             	mov    %rax,%rdx
  801efa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f01:	01 00 00 
  801f04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f08:	83 e0 01             	and    $0x1,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	74 07                	je     801f17 <pt_is_mapped+0x86>
  801f10:	b8 01 00 00 00       	mov    $0x1,%eax
  801f15:	eb 05                	jmp    801f1c <pt_is_mapped+0x8b>
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1c:	83 e0 01             	and    $0x1,%eax
}
  801f1f:	c9                   	leaveq 
  801f20:	c3                   	retq   

0000000000801f21 <fork>:

envid_t
fork(void)
{
  801f21:	55                   	push   %rbp
  801f22:	48 89 e5             	mov    %rsp,%rbp
  801f25:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f29:	48 bf 38 1b 80 00 00 	movabs $0x801b38,%rdi
  801f30:	00 00 00 
  801f33:	48 b8 72 43 80 00 00 	movabs $0x804372,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f3f:	b8 07 00 00 00       	mov    $0x7,%eax
  801f44:	cd 30                	int    $0x30
  801f46:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f49:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f4c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f53:	79 30                	jns    801f85 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f55:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f58:	89 c1                	mov    %eax,%ecx
  801f5a:	48 ba d0 4d 80 00 00 	movabs $0x804dd0,%rdx
  801f61:	00 00 00 
  801f64:	be 86 00 00 00       	mov    $0x86,%esi
  801f69:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801f70:	00 00 00 
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	49 b8 5e 42 80 00 00 	movabs $0x80425e,%r8
  801f7f:	00 00 00 
  801f82:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f89:	75 46                	jne    801fd1 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801f8b:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax
  801f97:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f9c:	48 63 d0             	movslq %eax,%rdx
  801f9f:	48 89 d0             	mov    %rdx,%rax
  801fa2:	48 c1 e0 03          	shl    $0x3,%rax
  801fa6:	48 01 d0             	add    %rdx,%rax
  801fa9:	48 c1 e0 05          	shl    $0x5,%rax
  801fad:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fb4:	00 00 00 
  801fb7:	48 01 c2             	add    %rax,%rdx
  801fba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fc1:	00 00 00 
  801fc4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	e9 d1 01 00 00       	jmpq   8021a2 <fork+0x281>
	}
	uint64_t ad = 0;
  801fd1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fd8:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801fd9:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fe2:	e9 df 00 00 00       	jmpq   8020c6 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801feb:	48 c1 e8 27          	shr    $0x27,%rax
  801fef:	48 89 c2             	mov    %rax,%rdx
  801ff2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ff9:	01 00 00 
  801ffc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802000:	83 e0 01             	and    $0x1,%eax
  802003:	48 85 c0             	test   %rax,%rax
  802006:	0f 84 9e 00 00 00    	je     8020aa <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80200c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802010:	48 c1 e8 1e          	shr    $0x1e,%rax
  802014:	48 89 c2             	mov    %rax,%rdx
  802017:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80201e:	01 00 00 
  802021:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802025:	83 e0 01             	and    $0x1,%eax
  802028:	48 85 c0             	test   %rax,%rax
  80202b:	74 73                	je     8020a0 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80202d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802031:	48 c1 e8 15          	shr    $0x15,%rax
  802035:	48 89 c2             	mov    %rax,%rdx
  802038:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80203f:	01 00 00 
  802042:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802046:	83 e0 01             	and    $0x1,%eax
  802049:	48 85 c0             	test   %rax,%rax
  80204c:	74 48                	je     802096 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80204e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802052:	48 c1 e8 0c          	shr    $0xc,%rax
  802056:	48 89 c2             	mov    %rax,%rdx
  802059:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802060:	01 00 00 
  802063:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802067:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	83 e0 01             	and    $0x1,%eax
  802072:	48 85 c0             	test   %rax,%rax
  802075:	74 47                	je     8020be <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207b:	48 c1 e8 0c          	shr    $0xc,%rax
  80207f:	89 c2                	mov    %eax,%edx
  802081:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802084:	89 d6                	mov    %edx,%esi
  802086:	89 c7                	mov    %eax,%edi
  802088:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	eb 28                	jmp    8020be <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802096:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80209d:	00 
  80209e:	eb 1e                	jmp    8020be <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020a0:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020a7:	40 
  8020a8:	eb 14                	jmp    8020be <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ae:	48 c1 e8 27          	shr    $0x27,%rax
  8020b2:	48 83 c0 01          	add    $0x1,%rax
  8020b6:	48 c1 e0 27          	shl    $0x27,%rax
  8020ba:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020be:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020c5:	00 
  8020c6:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020cd:	00 
  8020ce:	0f 87 13 ff ff ff    	ja     801fe7 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d7:	ba 07 00 00 00       	mov    $0x7,%edx
  8020dc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020e1:	89 c7                	mov    %eax,%edi
  8020e3:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8020ea:	00 00 00 
  8020ed:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020fc:	89 c7                	mov    %eax,%edi
  8020fe:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80210a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802113:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802118:	ba 00 00 00 00       	mov    $0x0,%edx
  80211d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802122:	89 c7                	mov    %eax,%edi
  802124:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802130:	ba 00 10 00 00       	mov    $0x1000,%edx
  802135:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80213f:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80214b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802150:	bf 00 00 00 00       	mov    $0x0,%edi
  802155:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80215c:	00 00 00 
  80215f:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802168:	00 00 00 
  80216b:	48 8b 00             	mov    (%rax),%rax
  80216e:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802178:	48 89 d6             	mov    %rdx,%rsi
  80217b:	89 c7                	mov    %eax,%edi
  80217d:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802189:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80218c:	be 02 00 00 00       	mov    $0x2,%esi
  802191:	89 c7                	mov    %eax,%edi
  802193:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax

	return envid;
  80219f:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021a2:	c9                   	leaveq 
  8021a3:	c3                   	retq   

00000000008021a4 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021a4:	55                   	push   %rbp
  8021a5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021a8:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  8021af:	00 00 00 
  8021b2:	be bf 00 00 00       	mov    $0xbf,%esi
  8021b7:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  8021be:	00 00 00 
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c6:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  8021cd:	00 00 00 
  8021d0:	ff d1                	callq  *%rcx

00000000008021d2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 08          	sub    $0x8,%rsp
  8021da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021e2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021e9:	ff ff ff 
  8021ec:	48 01 d0             	add    %rdx,%rax
  8021ef:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021f3:	c9                   	leaveq 
  8021f4:	c3                   	retq   

00000000008021f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021f5:	55                   	push   %rbp
  8021f6:	48 89 e5             	mov    %rsp,%rbp
  8021f9:	48 83 ec 08          	sub    $0x8,%rsp
  8021fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802205:	48 89 c7             	mov    %rax,%rdi
  802208:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  80220f:	00 00 00 
  802212:	ff d0                	callq  *%rax
  802214:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80221a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80221e:	c9                   	leaveq 
  80221f:	c3                   	retq   

0000000000802220 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	48 83 ec 18          	sub    $0x18,%rsp
  802228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80222c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802233:	eb 6b                	jmp    8022a0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802238:	48 98                	cltq   
  80223a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802240:	48 c1 e0 0c          	shl    $0xc,%rax
  802244:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224c:	48 c1 e8 15          	shr    $0x15,%rax
  802250:	48 89 c2             	mov    %rax,%rdx
  802253:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80225a:	01 00 00 
  80225d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802261:	83 e0 01             	and    $0x1,%eax
  802264:	48 85 c0             	test   %rax,%rax
  802267:	74 21                	je     80228a <fd_alloc+0x6a>
  802269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226d:	48 c1 e8 0c          	shr    $0xc,%rax
  802271:	48 89 c2             	mov    %rax,%rdx
  802274:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227b:	01 00 00 
  80227e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802282:	83 e0 01             	and    $0x1,%eax
  802285:	48 85 c0             	test   %rax,%rax
  802288:	75 12                	jne    80229c <fd_alloc+0x7c>
			*fd_store = fd;
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802292:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802295:	b8 00 00 00 00       	mov    $0x0,%eax
  80229a:	eb 1a                	jmp    8022b6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80229c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022a0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022a4:	7e 8f                	jle    802235 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022aa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022b1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022b6:	c9                   	leaveq 
  8022b7:	c3                   	retq   

00000000008022b8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022b8:	55                   	push   %rbp
  8022b9:	48 89 e5             	mov    %rsp,%rbp
  8022bc:	48 83 ec 20          	sub    $0x20,%rsp
  8022c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022cb:	78 06                	js     8022d3 <fd_lookup+0x1b>
  8022cd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022d1:	7e 07                	jle    8022da <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d8:	eb 6c                	jmp    802346 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022dd:	48 98                	cltq   
  8022df:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022e5:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f1:	48 c1 e8 15          	shr    $0x15,%rax
  8022f5:	48 89 c2             	mov    %rax,%rdx
  8022f8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ff:	01 00 00 
  802302:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802306:	83 e0 01             	and    $0x1,%eax
  802309:	48 85 c0             	test   %rax,%rax
  80230c:	74 21                	je     80232f <fd_lookup+0x77>
  80230e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802312:	48 c1 e8 0c          	shr    $0xc,%rax
  802316:	48 89 c2             	mov    %rax,%rdx
  802319:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802320:	01 00 00 
  802323:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802327:	83 e0 01             	and    $0x1,%eax
  80232a:	48 85 c0             	test   %rax,%rax
  80232d:	75 07                	jne    802336 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80232f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802334:	eb 10                	jmp    802346 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802336:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80233a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80233e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802346:	c9                   	leaveq 
  802347:	c3                   	retq   

0000000000802348 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802348:	55                   	push   %rbp
  802349:	48 89 e5             	mov    %rsp,%rbp
  80234c:	48 83 ec 30          	sub    $0x30,%rsp
  802350:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802354:	89 f0                	mov    %esi,%eax
  802356:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235d:	48 89 c7             	mov    %rax,%rdi
  802360:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802367:	00 00 00 
  80236a:	ff d0                	callq  *%rax
  80236c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802370:	48 89 d6             	mov    %rdx,%rsi
  802373:	89 c7                	mov    %eax,%edi
  802375:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  80237c:	00 00 00 
  80237f:	ff d0                	callq  *%rax
  802381:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802384:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802388:	78 0a                	js     802394 <fd_close+0x4c>
	    || fd != fd2)
  80238a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802392:	74 12                	je     8023a6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802394:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802398:	74 05                	je     80239f <fd_close+0x57>
  80239a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239d:	eb 05                	jmp    8023a4 <fd_close+0x5c>
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a4:	eb 69                	jmp    80240f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023aa:	8b 00                	mov    (%rax),%eax
  8023ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b0:	48 89 d6             	mov    %rdx,%rsi
  8023b3:	89 c7                	mov    %eax,%edi
  8023b5:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c8:	78 2a                	js     8023f4 <fd_close+0xac>
		if (dev->dev_close)
  8023ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023d2:	48 85 c0             	test   %rax,%rax
  8023d5:	74 16                	je     8023ed <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023db:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023e3:	48 89 d7             	mov    %rdx,%rdi
  8023e6:	ff d0                	callq  *%rax
  8023e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023eb:	eb 07                	jmp    8023f4 <fd_close+0xac>
		else
			r = 0;
  8023ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f8:	48 89 c6             	mov    %rax,%rsi
  8023fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802400:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  802407:	00 00 00 
  80240a:	ff d0                	callq  *%rax
	return r;
  80240c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80240f:	c9                   	leaveq 
  802410:	c3                   	retq   

0000000000802411 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802411:	55                   	push   %rbp
  802412:	48 89 e5             	mov    %rsp,%rbp
  802415:	48 83 ec 20          	sub    $0x20,%rsp
  802419:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80241c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802427:	eb 41                	jmp    80246a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802429:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802430:	00 00 00 
  802433:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802436:	48 63 d2             	movslq %edx,%rdx
  802439:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243d:	8b 00                	mov    (%rax),%eax
  80243f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802442:	75 22                	jne    802466 <dev_lookup+0x55>
			*dev = devtab[i];
  802444:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80244b:	00 00 00 
  80244e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802451:	48 63 d2             	movslq %edx,%rdx
  802454:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802458:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80245c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	eb 60                	jmp    8024c6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802466:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802471:	00 00 00 
  802474:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802477:	48 63 d2             	movslq %edx,%rdx
  80247a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247e:	48 85 c0             	test   %rax,%rax
  802481:	75 a6                	jne    802429 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802483:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80248a:	00 00 00 
  80248d:	48 8b 00             	mov    (%rax),%rax
  802490:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802496:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802499:	89 c6                	mov    %eax,%esi
  80249b:	48 bf 00 4e 80 00 00 	movabs $0x804e00,%rdi
  8024a2:	00 00 00 
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024aa:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8024b1:	00 00 00 
  8024b4:	ff d1                	callq  *%rcx
	*dev = 0;
  8024b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024c6:	c9                   	leaveq 
  8024c7:	c3                   	retq   

00000000008024c8 <close>:

int
close(int fdnum)
{
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	48 83 ec 20          	sub    $0x20,%rsp
  8024d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024da:	48 89 d6             	mov    %rdx,%rsi
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f2:	79 05                	jns    8024f9 <close+0x31>
		return r;
  8024f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f7:	eb 18                	jmp    802511 <close+0x49>
	else
		return fd_close(fd, 1);
  8024f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fd:	be 01 00 00 00       	mov    $0x1,%esi
  802502:	48 89 c7             	mov    %rax,%rdi
  802505:	48 b8 48 23 80 00 00 	movabs $0x802348,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <close_all>:

void
close_all(void)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80251b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802522:	eb 15                	jmp    802539 <close_all+0x26>
		close(i);
  802524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802535:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802539:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80253d:	7e e5                	jle    802524 <close_all+0x11>
		close(i);
}
  80253f:	c9                   	leaveq 
  802540:	c3                   	retq   

0000000000802541 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
  802545:	48 83 ec 40          	sub    $0x40,%rsp
  802549:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80254c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80254f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802553:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802556:	48 89 d6             	mov    %rdx,%rsi
  802559:	89 c7                	mov    %eax,%edi
  80255b:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  802562:	00 00 00 
  802565:	ff d0                	callq  *%rax
  802567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256e:	79 08                	jns    802578 <dup+0x37>
		return r;
  802570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802573:	e9 70 01 00 00       	jmpq   8026e8 <dup+0x1a7>
	close(newfdnum);
  802578:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802589:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80258c:	48 98                	cltq   
  80258e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802594:	48 c1 e0 0c          	shl    $0xc,%rax
  802598:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80259c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a0:	48 89 c7             	mov    %rax,%rdi
  8025a3:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  8025aa:	00 00 00 
  8025ad:	ff d0                	callq  *%rax
  8025af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b7:	48 89 c7             	mov    %rax,%rdi
  8025ba:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
  8025c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ce:	48 c1 e8 15          	shr    $0x15,%rax
  8025d2:	48 89 c2             	mov    %rax,%rdx
  8025d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025dc:	01 00 00 
  8025df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e3:	83 e0 01             	and    $0x1,%eax
  8025e6:	48 85 c0             	test   %rax,%rax
  8025e9:	74 73                	je     80265e <dup+0x11d>
  8025eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8025f3:	48 89 c2             	mov    %rax,%rdx
  8025f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025fd:	01 00 00 
  802600:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802604:	83 e0 01             	and    $0x1,%eax
  802607:	48 85 c0             	test   %rax,%rax
  80260a:	74 52                	je     80265e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80260c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802610:	48 c1 e8 0c          	shr    $0xc,%rax
  802614:	48 89 c2             	mov    %rax,%rdx
  802617:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261e:	01 00 00 
  802621:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802625:	25 07 0e 00 00       	and    $0xe07,%eax
  80262a:	89 c1                	mov    %eax,%ecx
  80262c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802634:	41 89 c8             	mov    %ecx,%r8d
  802637:	48 89 d1             	mov    %rdx,%rcx
  80263a:	ba 00 00 00 00       	mov    $0x0,%edx
  80263f:	48 89 c6             	mov    %rax,%rsi
  802642:	bf 00 00 00 00       	mov    $0x0,%edi
  802647:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
  802653:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802656:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265a:	79 02                	jns    80265e <dup+0x11d>
			goto err;
  80265c:	eb 57                	jmp    8026b5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80265e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802662:	48 c1 e8 0c          	shr    $0xc,%rax
  802666:	48 89 c2             	mov    %rax,%rdx
  802669:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802670:	01 00 00 
  802673:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802677:	25 07 0e 00 00       	and    $0xe07,%eax
  80267c:	89 c1                	mov    %eax,%ecx
  80267e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802682:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802686:	41 89 c8             	mov    %ecx,%r8d
  802689:	48 89 d1             	mov    %rdx,%rcx
  80268c:	ba 00 00 00 00       	mov    $0x0,%edx
  802691:	48 89 c6             	mov    %rax,%rsi
  802694:	bf 00 00 00 00       	mov    $0x0,%edi
  802699:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8026a0:	00 00 00 
  8026a3:	ff d0                	callq  *%rax
  8026a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ac:	79 02                	jns    8026b0 <dup+0x16f>
		goto err;
  8026ae:	eb 05                	jmp    8026b5 <dup+0x174>

	return newfdnum;
  8026b0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026b3:	eb 33                	jmp    8026e8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b9:	48 89 c6             	mov    %rax,%rsi
  8026bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c1:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d1:	48 89 c6             	mov    %rax,%rsi
  8026d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d9:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
	return r;
  8026e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e8:	c9                   	leaveq 
  8026e9:	c3                   	retq   

00000000008026ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026ea:	55                   	push   %rbp
  8026eb:	48 89 e5             	mov    %rsp,%rbp
  8026ee:	48 83 ec 40          	sub    $0x40,%rsp
  8026f2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026f9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802701:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802704:	48 89 d6             	mov    %rdx,%rsi
  802707:	89 c7                	mov    %eax,%edi
  802709:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  802710:	00 00 00 
  802713:	ff d0                	callq  *%rax
  802715:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271c:	78 24                	js     802742 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80271e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802722:	8b 00                	mov    (%rax),%eax
  802724:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802728:	48 89 d6             	mov    %rdx,%rsi
  80272b:	89 c7                	mov    %eax,%edi
  80272d:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
  802739:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802740:	79 05                	jns    802747 <read+0x5d>
		return r;
  802742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802745:	eb 76                	jmp    8027bd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274b:	8b 40 08             	mov    0x8(%rax),%eax
  80274e:	83 e0 03             	and    $0x3,%eax
  802751:	83 f8 01             	cmp    $0x1,%eax
  802754:	75 3a                	jne    802790 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802756:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80275d:	00 00 00 
  802760:	48 8b 00             	mov    (%rax),%rax
  802763:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802769:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80276c:	89 c6                	mov    %eax,%esi
  80276e:	48 bf 1f 4e 80 00 00 	movabs $0x804e1f,%rdi
  802775:	00 00 00 
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  802784:	00 00 00 
  802787:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802789:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80278e:	eb 2d                	jmp    8027bd <read+0xd3>
	}
	if (!dev->dev_read)
  802790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802794:	48 8b 40 10          	mov    0x10(%rax),%rax
  802798:	48 85 c0             	test   %rax,%rax
  80279b:	75 07                	jne    8027a4 <read+0xba>
		return -E_NOT_SUPP;
  80279d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a2:	eb 19                	jmp    8027bd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027b4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027b8:	48 89 cf             	mov    %rcx,%rdi
  8027bb:	ff d0                	callq  *%rax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 83 ec 30          	sub    $0x30,%rsp
  8027c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027d9:	eb 49                	jmp    802824 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027de:	48 98                	cltq   
  8027e0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e4:	48 29 c2             	sub    %rax,%rdx
  8027e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ea:	48 63 c8             	movslq %eax,%rcx
  8027ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f1:	48 01 c1             	add    %rax,%rcx
  8027f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f7:	48 89 ce             	mov    %rcx,%rsi
  8027fa:	89 c7                	mov    %eax,%edi
  8027fc:	48 b8 ea 26 80 00 00 	movabs $0x8026ea,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
  802808:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80280b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80280f:	79 05                	jns    802816 <readn+0x57>
			return m;
  802811:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802814:	eb 1c                	jmp    802832 <readn+0x73>
		if (m == 0)
  802816:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80281a:	75 02                	jne    80281e <readn+0x5f>
			break;
  80281c:	eb 11                	jmp    80282f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80281e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802821:	01 45 fc             	add    %eax,-0x4(%rbp)
  802824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802827:	48 98                	cltq   
  802829:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80282d:	72 ac                	jb     8027db <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802832:	c9                   	leaveq 
  802833:	c3                   	retq   

0000000000802834 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802834:	55                   	push   %rbp
  802835:	48 89 e5             	mov    %rsp,%rbp
  802838:	48 83 ec 40          	sub    $0x40,%rsp
  80283c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80283f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802843:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802847:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80284b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80284e:	48 89 d6             	mov    %rdx,%rsi
  802851:	89 c7                	mov    %eax,%edi
  802853:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
  80285f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802866:	78 24                	js     80288c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286c:	8b 00                	mov    (%rax),%eax
  80286e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802872:	48 89 d6             	mov    %rdx,%rsi
  802875:	89 c7                	mov    %eax,%edi
  802877:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
  802883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288a:	79 05                	jns    802891 <write+0x5d>
		return r;
  80288c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288f:	eb 75                	jmp    802906 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802895:	8b 40 08             	mov    0x8(%rax),%eax
  802898:	83 e0 03             	and    $0x3,%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	75 3a                	jne    8028d9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80289f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a6:	00 00 00 
  8028a9:	48 8b 00             	mov    (%rax),%rax
  8028ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028b5:	89 c6                	mov    %eax,%esi
  8028b7:	48 bf 3b 4e 80 00 00 	movabs $0x804e3b,%rdi
  8028be:	00 00 00 
  8028c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c6:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8028cd:	00 00 00 
  8028d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d7:	eb 2d                	jmp    802906 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8028d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028e1:	48 85 c0             	test   %rax,%rax
  8028e4:	75 07                	jne    8028ed <write+0xb9>
		return -E_NOT_SUPP;
  8028e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028eb:	eb 19                	jmp    802906 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802901:	48 89 cf             	mov    %rcx,%rdi
  802904:	ff d0                	callq  *%rax
}
  802906:	c9                   	leaveq 
  802907:	c3                   	retq   

0000000000802908 <seek>:

int
seek(int fdnum, off_t offset)
{
  802908:	55                   	push   %rbp
  802909:	48 89 e5             	mov    %rsp,%rbp
  80290c:	48 83 ec 18          	sub    $0x18,%rsp
  802910:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802913:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802916:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80291a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80291d:	48 89 d6             	mov    %rdx,%rsi
  802920:	89 c7                	mov    %eax,%edi
  802922:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  802929:	00 00 00 
  80292c:	ff d0                	callq  *%rax
  80292e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802931:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802935:	79 05                	jns    80293c <seek+0x34>
		return r;
  802937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293a:	eb 0f                	jmp    80294b <seek+0x43>
	fd->fd_offset = offset;
  80293c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802940:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802943:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294b:	c9                   	leaveq 
  80294c:	c3                   	retq   

000000000080294d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80294d:	55                   	push   %rbp
  80294e:	48 89 e5             	mov    %rsp,%rbp
  802951:	48 83 ec 30          	sub    $0x30,%rsp
  802955:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802958:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80295f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802962:	48 89 d6             	mov    %rdx,%rsi
  802965:	89 c7                	mov    %eax,%edi
  802967:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
  802973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297a:	78 24                	js     8029a0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802980:	8b 00                	mov    (%rax),%eax
  802982:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802986:	48 89 d6             	mov    %rdx,%rsi
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
  802997:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299e:	79 05                	jns    8029a5 <ftruncate+0x58>
		return r;
  8029a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a3:	eb 72                	jmp    802a17 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a9:	8b 40 08             	mov    0x8(%rax),%eax
  8029ac:	83 e0 03             	and    $0x3,%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 3a                	jne    8029ed <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029b3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029ba:	00 00 00 
  8029bd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029c9:	89 c6                	mov    %eax,%esi
  8029cb:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  8029d2:	00 00 00 
  8029d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029da:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8029e1:	00 00 00 
  8029e4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029eb:	eb 2a                	jmp    802a17 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029f5:	48 85 c0             	test   %rax,%rax
  8029f8:	75 07                	jne    802a01 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029ff:	eb 16                	jmp    802a17 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a05:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a0d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a10:	89 ce                	mov    %ecx,%esi
  802a12:	48 89 d7             	mov    %rdx,%rdi
  802a15:	ff d0                	callq  *%rax
}
  802a17:	c9                   	leaveq 
  802a18:	c3                   	retq   

0000000000802a19 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 30          	sub    $0x30,%rsp
  802a21:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a24:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a2f:	48 89 d6             	mov    %rdx,%rsi
  802a32:	89 c7                	mov    %eax,%edi
  802a34:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
  802a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a47:	78 24                	js     802a6d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4d:	8b 00                	mov    (%rax),%eax
  802a4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a53:	48 89 d6             	mov    %rdx,%rsi
  802a56:	89 c7                	mov    %eax,%edi
  802a58:	48 b8 11 24 80 00 00 	movabs $0x802411,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
  802a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6b:	79 05                	jns    802a72 <fstat+0x59>
		return r;
  802a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a70:	eb 5e                	jmp    802ad0 <fstat+0xb7>
	if (!dev->dev_stat)
  802a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a76:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a7a:	48 85 c0             	test   %rax,%rax
  802a7d:	75 07                	jne    802a86 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a7f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a84:	eb 4a                	jmp    802ad0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a8a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a91:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a98:	00 00 00 
	stat->st_isdir = 0;
  802a9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a9f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802aa6:	00 00 00 
	stat->st_dev = dev;
  802aa9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ab1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ac0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ac8:	48 89 ce             	mov    %rcx,%rsi
  802acb:	48 89 d7             	mov    %rdx,%rdi
  802ace:	ff d0                	callq  *%rax
}
  802ad0:	c9                   	leaveq 
  802ad1:	c3                   	retq   

0000000000802ad2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ad2:	55                   	push   %rbp
  802ad3:	48 89 e5             	mov    %rsp,%rbp
  802ad6:	48 83 ec 20          	sub    $0x20,%rsp
  802ada:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ade:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae6:	be 00 00 00 00       	mov    $0x0,%esi
  802aeb:	48 89 c7             	mov    %rax,%rdi
  802aee:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b01:	79 05                	jns    802b08 <stat+0x36>
		return fd;
  802b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b06:	eb 2f                	jmp    802b37 <stat+0x65>
	r = fstat(fd, stat);
  802b08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0f:	48 89 d6             	mov    %rdx,%rsi
  802b12:	89 c7                	mov    %eax,%edi
  802b14:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
  802b20:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b26:	89 c7                	mov    %eax,%edi
  802b28:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
	return r;
  802b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b37:	c9                   	leaveq 
  802b38:	c3                   	retq   

0000000000802b39 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b39:	55                   	push   %rbp
  802b3a:	48 89 e5             	mov    %rsp,%rbp
  802b3d:	48 83 ec 10          	sub    $0x10,%rsp
  802b41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b4f:	00 00 00 
  802b52:	8b 00                	mov    (%rax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	75 1d                	jne    802b75 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b58:	bf 01 00 00 00       	mov    $0x1,%edi
  802b5d:	48 b8 1a 46 80 00 00 	movabs $0x80461a,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
  802b69:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b70:	00 00 00 
  802b73:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b75:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b7c:	00 00 00 
  802b7f:	8b 00                	mov    (%rax),%eax
  802b81:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b84:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b89:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b90:	00 00 00 
  802b93:	89 c7                	mov    %eax,%edi
  802b95:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  802baa:	48 89 c6             	mov    %rax,%rsi
  802bad:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb2:	48 b8 b2 44 80 00 00 	movabs $0x8044b2,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 30          	sub    $0x30,%rsp
  802bc8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802bcc:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bcf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bd6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802be4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802be9:	75 08                	jne    802bf3 <open+0x33>
	{
		return r;
  802beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bee:	e9 f2 00 00 00       	jmpq   802ce5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802bf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf7:	48 89 c7             	mov    %rax,%rdi
  802bfa:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c09:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c10:	7e 0a                	jle    802c1c <open+0x5c>
	{
		return -E_BAD_PATH;
  802c12:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c17:	e9 c9 00 00 00       	jmpq   802ce5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c1c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c23:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c24:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c28:	48 89 c7             	mov    %rax,%rdi
  802c2b:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	callq  *%rax
  802c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3e:	78 09                	js     802c49 <open+0x89>
  802c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c44:	48 85 c0             	test   %rax,%rax
  802c47:	75 08                	jne    802c51 <open+0x91>
		{
			return r;
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	e9 94 00 00 00       	jmpq   802ce5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c55:	ba 00 04 00 00       	mov    $0x400,%edx
  802c5a:	48 89 c6             	mov    %rax,%rsi
  802c5d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c64:	00 00 00 
  802c67:	48 b8 62 0f 80 00 00 	movabs $0x800f62,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c7a:	00 00 00 
  802c7d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c80:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8a:	48 89 c6             	mov    %rax,%rsi
  802c8d:	bf 01 00 00 00       	mov    $0x1,%edi
  802c92:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	79 2b                	jns    802cd2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cab:	be 00 00 00 00       	mov    $0x0,%esi
  802cb0:	48 89 c7             	mov    %rax,%rdi
  802cb3:	48 b8 48 23 80 00 00 	movabs $0x802348,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
  802cbf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802cc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cc6:	79 05                	jns    802ccd <open+0x10d>
			{
				return d;
  802cc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ccb:	eb 18                	jmp    802ce5 <open+0x125>
			}
			return r;
  802ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd0:	eb 13                	jmp    802ce5 <open+0x125>
		}	
		return fd2num(fd_store);
  802cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd6:	48 89 c7             	mov    %rax,%rdi
  802cd9:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802ce5:	c9                   	leaveq 
  802ce6:	c3                   	retq   

0000000000802ce7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ce7:	55                   	push   %rbp
  802ce8:	48 89 e5             	mov    %rsp,%rbp
  802ceb:	48 83 ec 10          	sub    $0x10,%rsp
  802cef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf7:	8b 50 0c             	mov    0xc(%rax),%edx
  802cfa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d01:	00 00 00 
  802d04:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d06:	be 00 00 00 00       	mov    $0x0,%esi
  802d0b:	bf 06 00 00 00       	mov    $0x6,%edi
  802d10:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
}
  802d1c:	c9                   	leaveq 
  802d1d:	c3                   	retq   

0000000000802d1e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 30          	sub    $0x30,%rsp
  802d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d39:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d3e:	74 07                	je     802d47 <devfile_read+0x29>
  802d40:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d45:	75 07                	jne    802d4e <devfile_read+0x30>
		return -E_INVAL;
  802d47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d4c:	eb 77                	jmp    802dc5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d52:	8b 50 0c             	mov    0xc(%rax),%edx
  802d55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d5c:	00 00 00 
  802d5f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d68:	00 00 00 
  802d6b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d6f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d73:	be 00 00 00 00       	mov    $0x0,%esi
  802d78:	bf 03 00 00 00       	mov    $0x3,%edi
  802d7d:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d90:	7f 05                	jg     802d97 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d95:	eb 2e                	jmp    802dc5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9a:	48 63 d0             	movslq %eax,%rdx
  802d9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802da8:	00 00 00 
  802dab:	48 89 c7             	mov    %rax,%rdi
  802dae:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802dba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dbe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 30          	sub    $0x30,%rsp
  802dcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802ddb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802de2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802de7:	74 07                	je     802df0 <devfile_write+0x29>
  802de9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dee:	75 08                	jne    802df8 <devfile_write+0x31>
		return r;
  802df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df3:	e9 9a 00 00 00       	jmpq   802e92 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfc:	8b 50 0c             	mov    0xc(%rax),%edx
  802dff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e06:	00 00 00 
  802e09:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802e0b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e12:	00 
  802e13:	76 08                	jbe    802e1d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e15:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e1c:	00 
	}
	fsipcbuf.write.req_n = n;
  802e1d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e24:	00 00 00 
  802e27:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e2b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e37:	48 89 c6             	mov    %rax,%rsi
  802e3a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e41:	00 00 00 
  802e44:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e50:	be 00 00 00 00       	mov    $0x0,%esi
  802e55:	bf 04 00 00 00       	mov    $0x4,%edi
  802e5a:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
  802e66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6d:	7f 20                	jg     802e8f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e6f:	48 bf 7e 4e 80 00 00 	movabs $0x804e7e,%rdi
  802e76:	00 00 00 
  802e79:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7e:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  802e85:	00 00 00 
  802e88:	ff d2                	callq  *%rdx
		return r;
  802e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8d:	eb 03                	jmp    802e92 <devfile_write+0xcb>
	}
	return r;
  802e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e92:	c9                   	leaveq 
  802e93:	c3                   	retq   

0000000000802e94 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e94:	55                   	push   %rbp
  802e95:	48 89 e5             	mov    %rsp,%rbp
  802e98:	48 83 ec 20          	sub    $0x20,%rsp
  802e9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea8:	8b 50 0c             	mov    0xc(%rax),%edx
  802eab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb2:	00 00 00 
  802eb5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802eb7:	be 00 00 00 00       	mov    $0x0,%esi
  802ebc:	bf 05 00 00 00       	mov    $0x5,%edi
  802ec1:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
  802ecd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed4:	79 05                	jns    802edb <devfile_stat+0x47>
		return r;
  802ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed9:	eb 56                	jmp    802f31 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802edb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ee6:	00 00 00 
  802ee9:	48 89 c7             	mov    %rax,%rdi
  802eec:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ef8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eff:	00 00 00 
  802f02:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f0c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f19:	00 00 00 
  802f1c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f26:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f31:	c9                   	leaveq 
  802f32:	c3                   	retq   

0000000000802f33 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f33:	55                   	push   %rbp
  802f34:	48 89 e5             	mov    %rsp,%rbp
  802f37:	48 83 ec 10          	sub    $0x10,%rsp
  802f3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f3f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f46:	8b 50 0c             	mov    0xc(%rax),%edx
  802f49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f50:	00 00 00 
  802f53:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5c:	00 00 00 
  802f5f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f62:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f65:	be 00 00 00 00       	mov    $0x0,%esi
  802f6a:	bf 02 00 00 00       	mov    $0x2,%edi
  802f6f:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802f76:	00 00 00 
  802f79:	ff d0                	callq  *%rax
}
  802f7b:	c9                   	leaveq 
  802f7c:	c3                   	retq   

0000000000802f7d <remove>:

// Delete a file
int
remove(const char *path)
{
  802f7d:	55                   	push   %rbp
  802f7e:	48 89 e5             	mov    %rsp,%rbp
  802f81:	48 83 ec 10          	sub    $0x10,%rsp
  802f85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8d:	48 89 c7             	mov    %rax,%rdi
  802f90:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fa1:	7e 07                	jle    802faa <remove+0x2d>
		return -E_BAD_PATH;
  802fa3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fa8:	eb 33                	jmp    802fdd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802faa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fae:	48 89 c6             	mov    %rax,%rsi
  802fb1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fb8:	00 00 00 
  802fbb:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802fc2:	00 00 00 
  802fc5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fc7:	be 00 00 00 00       	mov    $0x0,%esi
  802fcc:	bf 07 00 00 00       	mov    $0x7,%edi
  802fd1:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
}
  802fdd:	c9                   	leaveq 
  802fde:	c3                   	retq   

0000000000802fdf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fdf:	55                   	push   %rbp
  802fe0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802fe3:	be 00 00 00 00       	mov    $0x0,%esi
  802fe8:	bf 08 00 00 00       	mov    $0x8,%edi
  802fed:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
}
  802ff9:	5d                   	pop    %rbp
  802ffa:	c3                   	retq   

0000000000802ffb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ffb:	55                   	push   %rbp
  802ffc:	48 89 e5             	mov    %rsp,%rbp
  802fff:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803006:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80300d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803014:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80301b:	be 00 00 00 00       	mov    $0x0,%esi
  803020:	48 89 c7             	mov    %rax,%rdi
  803023:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  80302a:	00 00 00 
  80302d:	ff d0                	callq  *%rax
  80302f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803032:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803036:	79 28                	jns    803060 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303b:	89 c6                	mov    %eax,%esi
  80303d:	48 bf 9a 4e 80 00 00 	movabs $0x804e9a,%rdi
  803044:	00 00 00 
  803047:	b8 00 00 00 00       	mov    $0x0,%eax
  80304c:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  803053:	00 00 00 
  803056:	ff d2                	callq  *%rdx
		return fd_src;
  803058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305b:	e9 74 01 00 00       	jmpq   8031d4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803060:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803067:	be 01 01 00 00       	mov    $0x101,%esi
  80306c:	48 89 c7             	mov    %rax,%rdi
  80306f:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
  80307b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80307e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803082:	79 39                	jns    8030bd <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803084:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803087:	89 c6                	mov    %eax,%esi
  803089:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  803090:	00 00 00 
  803093:	b8 00 00 00 00       	mov    $0x0,%eax
  803098:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  80309f:	00 00 00 
  8030a2:	ff d2                	callq  *%rdx
		close(fd_src);
  8030a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a7:	89 c7                	mov    %eax,%edi
  8030a9:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
		return fd_dest;
  8030b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b8:	e9 17 01 00 00       	jmpq   8031d4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030bd:	eb 74                	jmp    803133 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030c2:	48 63 d0             	movslq %eax,%rdx
  8030c5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030cf:	48 89 ce             	mov    %rcx,%rsi
  8030d2:	89 c7                	mov    %eax,%edi
  8030d4:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	callq  *%rax
  8030e0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030e7:	79 4a                	jns    803133 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030ec:	89 c6                	mov    %eax,%esi
  8030ee:	48 bf ca 4e 80 00 00 	movabs $0x804eca,%rdi
  8030f5:	00 00 00 
  8030f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fd:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  803104:	00 00 00 
  803107:	ff d2                	callq  *%rdx
			close(fd_src);
  803109:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310c:	89 c7                	mov    %eax,%edi
  80310e:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803115:	00 00 00 
  803118:	ff d0                	callq  *%rax
			close(fd_dest);
  80311a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80311d:	89 c7                	mov    %eax,%edi
  80311f:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
			return write_size;
  80312b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80312e:	e9 a1 00 00 00       	jmpq   8031d4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803133:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	ba 00 02 00 00       	mov    $0x200,%edx
  803142:	48 89 ce             	mov    %rcx,%rsi
  803145:	89 c7                	mov    %eax,%edi
  803147:	48 b8 ea 26 80 00 00 	movabs $0x8026ea,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
  803153:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803156:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80315a:	0f 8f 5f ff ff ff    	jg     8030bf <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803160:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803164:	79 47                	jns    8031ad <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803166:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803169:	89 c6                	mov    %eax,%esi
  80316b:	48 bf dd 4e 80 00 00 	movabs $0x804edd,%rdi
  803172:	00 00 00 
  803175:	b8 00 00 00 00       	mov    $0x0,%eax
  80317a:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  803181:	00 00 00 
  803184:	ff d2                	callq  *%rdx
		close(fd_src);
  803186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803189:	89 c7                	mov    %eax,%edi
  80318b:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
		close(fd_dest);
  803197:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319a:	89 c7                	mov    %eax,%edi
  80319c:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8031a3:	00 00 00 
  8031a6:	ff d0                	callq  *%rax
		return read_size;
  8031a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031ab:	eb 27                	jmp    8031d4 <copy+0x1d9>
	}
	close(fd_src);
  8031ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b0:	89 c7                	mov    %eax,%edi
  8031b2:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
	close(fd_dest);
  8031be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
	return 0;
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031d4:	c9                   	leaveq 
  8031d5:	c3                   	retq   

00000000008031d6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031d6:	55                   	push   %rbp
  8031d7:	48 89 e5             	mov    %rsp,%rbp
  8031da:	48 83 ec 20          	sub    $0x20,%rsp
  8031de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e8:	48 89 d6             	mov    %rdx,%rsi
  8031eb:	89 c7                	mov    %eax,%edi
  8031ed:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803200:	79 05                	jns    803207 <fd2sockid+0x31>
		return r;
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803205:	eb 24                	jmp    80322b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320b:	8b 10                	mov    (%rax),%edx
  80320d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803214:	00 00 00 
  803217:	8b 00                	mov    (%rax),%eax
  803219:	39 c2                	cmp    %eax,%edx
  80321b:	74 07                	je     803224 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80321d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803222:	eb 07                	jmp    80322b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803228:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80322b:	c9                   	leaveq 
  80322c:	c3                   	retq   

000000000080322d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80322d:	55                   	push   %rbp
  80322e:	48 89 e5             	mov    %rsp,%rbp
  803231:	48 83 ec 20          	sub    $0x20,%rsp
  803235:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803238:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80323c:	48 89 c7             	mov    %rax,%rdi
  80323f:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803252:	78 26                	js     80327a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803258:	ba 07 04 00 00       	mov    $0x407,%edx
  80325d:	48 89 c6             	mov    %rax,%rsi
  803260:	bf 00 00 00 00       	mov    $0x0,%edi
  803265:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803274:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803278:	79 16                	jns    803290 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80327a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327d:	89 c7                	mov    %eax,%edi
  80327f:	48 b8 3a 37 80 00 00 	movabs $0x80373a,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
		return r;
  80328b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328e:	eb 3a                	jmp    8032ca <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803294:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80329b:	00 00 00 
  80329e:	8b 12                	mov    (%rdx),%edx
  8032a0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
}
  8032ca:	c9                   	leaveq 
  8032cb:	c3                   	retq   

00000000008032cc <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032cc:	55                   	push   %rbp
  8032cd:	48 89 e5             	mov    %rsp,%rbp
  8032d0:	48 83 ec 30          	sub    $0x30,%rsp
  8032d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e2:	89 c7                	mov    %eax,%edi
  8032e4:	48 b8 d6 31 80 00 00 	movabs $0x8031d6,%rax
  8032eb:	00 00 00 
  8032ee:	ff d0                	callq  *%rax
  8032f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f7:	79 05                	jns    8032fe <accept+0x32>
		return r;
  8032f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fc:	eb 3b                	jmp    803339 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803302:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803309:	48 89 ce             	mov    %rcx,%rsi
  80330c:	89 c7                	mov    %eax,%edi
  80330e:	48 b8 17 36 80 00 00 	movabs $0x803617,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
  80331a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803321:	79 05                	jns    803328 <accept+0x5c>
		return r;
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	eb 11                	jmp    803339 <accept+0x6d>
	return alloc_sockfd(r);
  803328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332b:	89 c7                	mov    %eax,%edi
  80332d:	48 b8 2d 32 80 00 00 	movabs $0x80322d,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
}
  803339:	c9                   	leaveq 
  80333a:	c3                   	retq   

000000000080333b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80333b:	55                   	push   %rbp
  80333c:	48 89 e5             	mov    %rsp,%rbp
  80333f:	48 83 ec 20          	sub    $0x20,%rsp
  803343:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80334a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80334d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803350:	89 c7                	mov    %eax,%edi
  803352:	48 b8 d6 31 80 00 00 	movabs $0x8031d6,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803361:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803365:	79 05                	jns    80336c <bind+0x31>
		return r;
  803367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336a:	eb 1b                	jmp    803387 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80336c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80336f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803376:	48 89 ce             	mov    %rcx,%rsi
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 96 36 80 00 00 	movabs $0x803696,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <shutdown>:

int
shutdown(int s, int how)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 20          	sub    $0x20,%rsp
  803391:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803394:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803397:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80339a:	89 c7                	mov    %eax,%edi
  80339c:	48 b8 d6 31 80 00 00 	movabs $0x8031d6,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
  8033a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033af:	79 05                	jns    8033b6 <shutdown+0x2d>
		return r;
  8033b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b4:	eb 16                	jmp    8033cc <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033bc:	89 d6                	mov    %edx,%esi
  8033be:	89 c7                	mov    %eax,%edi
  8033c0:	48 b8 fa 36 80 00 00 	movabs $0x8036fa,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
}
  8033cc:	c9                   	leaveq 
  8033cd:	c3                   	retq   

00000000008033ce <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033ce:	55                   	push   %rbp
  8033cf:	48 89 e5             	mov    %rsp,%rbp
  8033d2:	48 83 ec 10          	sub    $0x10,%rsp
  8033d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033de:	48 89 c7             	mov    %rax,%rdi
  8033e1:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  8033e8:	00 00 00 
  8033eb:	ff d0                	callq  *%rax
  8033ed:	83 f8 01             	cmp    $0x1,%eax
  8033f0:	75 17                	jne    803409 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f6:	8b 40 0c             	mov    0xc(%rax),%eax
  8033f9:	89 c7                	mov    %eax,%edi
  8033fb:	48 b8 3a 37 80 00 00 	movabs $0x80373a,%rax
  803402:	00 00 00 
  803405:	ff d0                	callq  *%rax
  803407:	eb 05                	jmp    80340e <devsock_close+0x40>
	else
		return 0;
  803409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340e:	c9                   	leaveq 
  80340f:	c3                   	retq   

0000000000803410 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803410:	55                   	push   %rbp
  803411:	48 89 e5             	mov    %rsp,%rbp
  803414:	48 83 ec 20          	sub    $0x20,%rsp
  803418:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80341b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80341f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803422:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803425:	89 c7                	mov    %eax,%edi
  803427:	48 b8 d6 31 80 00 00 	movabs $0x8031d6,%rax
  80342e:	00 00 00 
  803431:	ff d0                	callq  *%rax
  803433:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343a:	79 05                	jns    803441 <connect+0x31>
		return r;
  80343c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343f:	eb 1b                	jmp    80345c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803441:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803444:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344b:	48 89 ce             	mov    %rcx,%rsi
  80344e:	89 c7                	mov    %eax,%edi
  803450:	48 b8 67 37 80 00 00 	movabs $0x803767,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <listen>:

int
listen(int s, int backlog)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 20          	sub    $0x20,%rsp
  803466:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803469:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80346c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346f:	89 c7                	mov    %eax,%edi
  803471:	48 b8 d6 31 80 00 00 	movabs $0x8031d6,%rax
  803478:	00 00 00 
  80347b:	ff d0                	callq  *%rax
  80347d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803484:	79 05                	jns    80348b <listen+0x2d>
		return r;
  803486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803489:	eb 16                	jmp    8034a1 <listen+0x43>
	return nsipc_listen(r, backlog);
  80348b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80348e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803491:	89 d6                	mov    %edx,%esi
  803493:	89 c7                	mov    %eax,%edi
  803495:	48 b8 cb 37 80 00 00 	movabs $0x8037cb,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
}
  8034a1:	c9                   	leaveq 
  8034a2:	c3                   	retq   

00000000008034a3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034a3:	55                   	push   %rbp
  8034a4:	48 89 e5             	mov    %rsp,%rbp
  8034a7:	48 83 ec 20          	sub    $0x20,%rsp
  8034ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bb:	89 c2                	mov    %eax,%edx
  8034bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034cd:	89 c7                	mov    %eax,%edi
  8034cf:	48 b8 0b 38 80 00 00 	movabs $0x80380b,%rax
  8034d6:	00 00 00 
  8034d9:	ff d0                	callq  *%rax
}
  8034db:	c9                   	leaveq 
  8034dc:	c3                   	retq   

00000000008034dd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034dd:	55                   	push   %rbp
  8034de:	48 89 e5             	mov    %rsp,%rbp
  8034e1:	48 83 ec 20          	sub    $0x20,%rsp
  8034e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f5:	89 c2                	mov    %eax,%edx
  8034f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fb:	8b 40 0c             	mov    0xc(%rax),%eax
  8034fe:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803502:	b9 00 00 00 00       	mov    $0x0,%ecx
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 d7 38 80 00 00 	movabs $0x8038d7,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
}
  803515:	c9                   	leaveq 
  803516:	c3                   	retq   

0000000000803517 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803517:	55                   	push   %rbp
  803518:	48 89 e5             	mov    %rsp,%rbp
  80351b:	48 83 ec 10          	sub    $0x10,%rsp
  80351f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803523:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352b:	48 be f8 4e 80 00 00 	movabs $0x804ef8,%rsi
  803532:	00 00 00 
  803535:	48 89 c7             	mov    %rax,%rdi
  803538:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
	return 0;
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803549:	c9                   	leaveq 
  80354a:	c3                   	retq   

000000000080354b <socket>:

int
socket(int domain, int type, int protocol)
{
  80354b:	55                   	push   %rbp
  80354c:	48 89 e5             	mov    %rsp,%rbp
  80354f:	48 83 ec 20          	sub    $0x20,%rsp
  803553:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803556:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803559:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80355c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80355f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803562:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803565:	89 ce                	mov    %ecx,%esi
  803567:	89 c7                	mov    %eax,%edi
  803569:	48 b8 8f 39 80 00 00 	movabs $0x80398f,%rax
  803570:	00 00 00 
  803573:	ff d0                	callq  *%rax
  803575:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357c:	79 05                	jns    803583 <socket+0x38>
		return r;
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803581:	eb 11                	jmp    803594 <socket+0x49>
	return alloc_sockfd(r);
  803583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803586:	89 c7                	mov    %eax,%edi
  803588:	48 b8 2d 32 80 00 00 	movabs $0x80322d,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
}
  803594:	c9                   	leaveq 
  803595:	c3                   	retq   

0000000000803596 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803596:	55                   	push   %rbp
  803597:	48 89 e5             	mov    %rsp,%rbp
  80359a:	48 83 ec 10          	sub    $0x10,%rsp
  80359e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035a1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035a8:	00 00 00 
  8035ab:	8b 00                	mov    (%rax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	75 1d                	jne    8035ce <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035b1:	bf 02 00 00 00       	mov    $0x2,%edi
  8035b6:	48 b8 1a 46 80 00 00 	movabs $0x80461a,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
  8035c2:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8035c9:	00 00 00 
  8035cc:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035ce:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035d5:	00 00 00 
  8035d8:	8b 00                	mov    (%rax),%eax
  8035da:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035e2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035e9:	00 00 00 
  8035ec:	89 c7                	mov    %eax,%edi
  8035ee:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ff:	be 00 00 00 00       	mov    $0x0,%esi
  803604:	bf 00 00 00 00       	mov    $0x0,%edi
  803609:	48 b8 b2 44 80 00 00 	movabs $0x8044b2,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
}
  803615:	c9                   	leaveq 
  803616:	c3                   	retq   

0000000000803617 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803617:	55                   	push   %rbp
  803618:	48 89 e5             	mov    %rsp,%rbp
  80361b:	48 83 ec 30          	sub    $0x30,%rsp
  80361f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803622:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803626:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80362a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803631:	00 00 00 
  803634:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803637:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803639:	bf 01 00 00 00       	mov    $0x1,%edi
  80363e:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	78 3e                	js     803691 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803653:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80365a:	00 00 00 
  80365d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803665:	8b 40 10             	mov    0x10(%rax),%eax
  803668:	89 c2                	mov    %eax,%edx
  80366a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80366e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803672:	48 89 ce             	mov    %rcx,%rsi
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803688:	8b 50 10             	mov    0x10(%rax),%edx
  80368b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803691:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
  80369e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036a5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036af:	00 00 00 
  8036b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036b5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036be:	48 89 c6             	mov    %rax,%rsi
  8036c1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036c8:	00 00 00 
  8036cb:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036de:	00 00 00 
  8036e1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8036ec:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
}
  8036f8:	c9                   	leaveq 
  8036f9:	c3                   	retq   

00000000008036fa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036fa:	55                   	push   %rbp
  8036fb:	48 89 e5             	mov    %rsp,%rbp
  8036fe:	48 83 ec 10          	sub    $0x10,%rsp
  803702:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803705:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803708:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370f:	00 00 00 
  803712:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803715:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803717:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371e:	00 00 00 
  803721:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803724:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803727:	bf 03 00 00 00       	mov    $0x3,%edi
  80372c:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <nsipc_close>:

int
nsipc_close(int s)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 10          	sub    $0x10,%rsp
  803742:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803745:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374c:	00 00 00 
  80374f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803752:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803754:	bf 04 00 00 00       	mov    $0x4,%edi
  803759:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
}
  803765:	c9                   	leaveq 
  803766:	c3                   	retq   

0000000000803767 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803767:	55                   	push   %rbp
  803768:	48 89 e5             	mov    %rsp,%rbp
  80376b:	48 83 ec 10          	sub    $0x10,%rsp
  80376f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803772:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803776:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803779:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803780:	00 00 00 
  803783:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803786:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803788:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80378b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378f:	48 89 c6             	mov    %rax,%rsi
  803792:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803799:	00 00 00 
  80379c:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037a8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037af:	00 00 00 
  8037b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037b5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037b8:	bf 05 00 00 00       	mov    $0x5,%edi
  8037bd:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
}
  8037c9:	c9                   	leaveq 
  8037ca:	c3                   	retq   

00000000008037cb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037cb:	55                   	push   %rbp
  8037cc:	48 89 e5             	mov    %rsp,%rbp
  8037cf:	48 83 ec 10          	sub    $0x10,%rsp
  8037d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e0:	00 00 00 
  8037e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ef:	00 00 00 
  8037f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037f8:	bf 06 00 00 00       	mov    $0x6,%edi
  8037fd:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  803804:	00 00 00 
  803807:	ff d0                	callq  *%rax
}
  803809:	c9                   	leaveq 
  80380a:	c3                   	retq   

000000000080380b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80380b:	55                   	push   %rbp
  80380c:	48 89 e5             	mov    %rsp,%rbp
  80380f:	48 83 ec 30          	sub    $0x30,%rsp
  803813:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803816:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80381a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80381d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803820:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803827:	00 00 00 
  80382a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80382d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80382f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803836:	00 00 00 
  803839:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80383c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80383f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803846:	00 00 00 
  803849:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80384c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80384f:	bf 07 00 00 00       	mov    $0x7,%edi
  803854:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803867:	78 69                	js     8038d2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803869:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803870:	7f 08                	jg     80387a <nsipc_recv+0x6f>
  803872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803875:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803878:	7e 35                	jle    8038af <nsipc_recv+0xa4>
  80387a:	48 b9 ff 4e 80 00 00 	movabs $0x804eff,%rcx
  803881:	00 00 00 
  803884:	48 ba 14 4f 80 00 00 	movabs $0x804f14,%rdx
  80388b:	00 00 00 
  80388e:	be 61 00 00 00       	mov    $0x61,%esi
  803893:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  80389a:	00 00 00 
  80389d:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a2:	49 b8 5e 42 80 00 00 	movabs $0x80425e,%r8
  8038a9:	00 00 00 
  8038ac:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b2:	48 63 d0             	movslq %eax,%rdx
  8038b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038c0:	00 00 00 
  8038c3:	48 89 c7             	mov    %rax,%rdi
  8038c6:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
	}

	return r;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 20          	sub    $0x20,%rsp
  8038df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038e9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f3:	00 00 00 
  8038f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038fb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803902:	7e 35                	jle    803939 <nsipc_send+0x62>
  803904:	48 b9 35 4f 80 00 00 	movabs $0x804f35,%rcx
  80390b:	00 00 00 
  80390e:	48 ba 14 4f 80 00 00 	movabs $0x804f14,%rdx
  803915:	00 00 00 
  803918:	be 6c 00 00 00       	mov    $0x6c,%esi
  80391d:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  803924:	00 00 00 
  803927:	b8 00 00 00 00       	mov    $0x0,%eax
  80392c:	49 b8 5e 42 80 00 00 	movabs $0x80425e,%r8
  803933:	00 00 00 
  803936:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803939:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80393c:	48 63 d0             	movslq %eax,%rdx
  80393f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803943:	48 89 c6             	mov    %rax,%rsi
  803946:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80394d:	00 00 00 
  803950:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80395c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803963:	00 00 00 
  803966:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803969:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80396c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803973:	00 00 00 
  803976:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803979:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80397c:	bf 08 00 00 00       	mov    $0x8,%edi
  803981:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
}
  80398d:	c9                   	leaveq 
  80398e:	c3                   	retq   

000000000080398f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80398f:	55                   	push   %rbp
  803990:	48 89 e5             	mov    %rsp,%rbp
  803993:	48 83 ec 10          	sub    $0x10,%rsp
  803997:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80399a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80399d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039a0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a7:	00 00 00 
  8039aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ad:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b6:	00 00 00 
  8039b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c6:	00 00 00 
  8039c9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039cc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039cf:	bf 09 00 00 00       	mov    $0x9,%edi
  8039d4:	48 b8 96 35 80 00 00 	movabs $0x803596,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   

00000000008039e2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	53                   	push   %rbx
  8039e7:	48 83 ec 38          	sub    $0x38,%rsp
  8039eb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039ef:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039f3:	48 89 c7             	mov    %rax,%rdi
  8039f6:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  8039fd:	00 00 00 
  803a00:	ff d0                	callq  *%rax
  803a02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a09:	0f 88 bf 01 00 00    	js     803bce <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a13:	ba 07 04 00 00       	mov    $0x407,%edx
  803a18:	48 89 c6             	mov    %rax,%rsi
  803a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a20:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a33:	0f 88 95 01 00 00    	js     803bce <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a39:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a3d:	48 89 c7             	mov    %rax,%rdi
  803a40:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a53:	0f 88 5d 01 00 00    	js     803bb6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a5d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a62:	48 89 c6             	mov    %rax,%rsi
  803a65:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6a:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7d:	0f 88 33 01 00 00    	js     803bb6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9e:	ba 07 04 00 00       	mov    $0x407,%edx
  803aa3:	48 89 c6             	mov    %rax,%rsi
  803aa6:	bf 00 00 00 00       	mov    $0x0,%edi
  803aab:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
  803ab7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abe:	79 05                	jns    803ac5 <pipe+0xe3>
		goto err2;
  803ac0:	e9 d9 00 00 00       	jmpq   803b9e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ac5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac9:	48 89 c7             	mov    %rax,%rdi
  803acc:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
  803ad8:	48 89 c2             	mov    %rax,%rdx
  803adb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803adf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ae5:	48 89 d1             	mov    %rdx,%rcx
  803ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  803aed:	48 89 c6             	mov    %rax,%rsi
  803af0:	bf 00 00 00 00       	mov    $0x0,%edi
  803af5:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
  803b01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b08:	79 1b                	jns    803b25 <pipe+0x143>
		goto err3;
  803b0a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0f:	48 89 c6             	mov    %rax,%rsi
  803b12:	bf 00 00 00 00       	mov    $0x0,%edi
  803b17:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
  803b23:	eb 79                	jmp    803b9e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b29:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b30:	00 00 00 
  803b33:	8b 12                	mov    (%rdx),%edx
  803b35:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b46:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4d:	00 00 00 
  803b50:	8b 12                	mov    (%rdx),%edx
  803b52:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b58:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b63:	48 89 c7             	mov    %rax,%rdi
  803b66:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
  803b72:	89 c2                	mov    %eax,%edx
  803b74:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b78:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b7e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b86:	48 89 c7             	mov    %rax,%rdi
  803b89:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  803b90:	00 00 00 
  803b93:	ff d0                	callq  *%rax
  803b95:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b97:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9c:	eb 33                	jmp    803bd1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba2:	48 89 c6             	mov    %rax,%rsi
  803ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  803baa:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bba:	48 89 c6             	mov    %rax,%rsi
  803bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc2:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
err:
	return r;
  803bce:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bd1:	48 83 c4 38          	add    $0x38,%rsp
  803bd5:	5b                   	pop    %rbx
  803bd6:	5d                   	pop    %rbp
  803bd7:	c3                   	retq   

0000000000803bd8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bd8:	55                   	push   %rbp
  803bd9:	48 89 e5             	mov    %rsp,%rbp
  803bdc:	53                   	push   %rbx
  803bdd:	48 83 ec 28          	sub    $0x28,%rsp
  803be1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803be5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803be9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bf0:	00 00 00 
  803bf3:	48 8b 00             	mov    (%rax),%rax
  803bf6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bfc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c03:	48 89 c7             	mov    %rax,%rdi
  803c06:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  803c0d:	00 00 00 
  803c10:	ff d0                	callq  *%rax
  803c12:	89 c3                	mov    %eax,%ebx
  803c14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c18:	48 89 c7             	mov    %rax,%rdi
  803c1b:	48 b8 9c 46 80 00 00 	movabs $0x80469c,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	39 c3                	cmp    %eax,%ebx
  803c29:	0f 94 c0             	sete   %al
  803c2c:	0f b6 c0             	movzbl %al,%eax
  803c2f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c32:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c39:	00 00 00 
  803c3c:	48 8b 00             	mov    (%rax),%rax
  803c3f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c45:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c4e:	75 05                	jne    803c55 <_pipeisclosed+0x7d>
			return ret;
  803c50:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c53:	eb 4f                	jmp    803ca4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c58:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c5b:	74 42                	je     803c9f <_pipeisclosed+0xc7>
  803c5d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c61:	75 3c                	jne    803c9f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c63:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c6a:	00 00 00 
  803c6d:	48 8b 00             	mov    (%rax),%rax
  803c70:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c76:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7c:	89 c6                	mov    %eax,%esi
  803c7e:	48 bf 46 4f 80 00 00 	movabs $0x804f46,%rdi
  803c85:	00 00 00 
  803c88:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8d:	49 b8 1b 03 80 00 00 	movabs $0x80031b,%r8
  803c94:	00 00 00 
  803c97:	41 ff d0             	callq  *%r8
	}
  803c9a:	e9 4a ff ff ff       	jmpq   803be9 <_pipeisclosed+0x11>
  803c9f:	e9 45 ff ff ff       	jmpq   803be9 <_pipeisclosed+0x11>
}
  803ca4:	48 83 c4 28          	add    $0x28,%rsp
  803ca8:	5b                   	pop    %rbx
  803ca9:	5d                   	pop    %rbp
  803caa:	c3                   	retq   

0000000000803cab <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803cab:	55                   	push   %rbp
  803cac:	48 89 e5             	mov    %rsp,%rbp
  803caf:	48 83 ec 30          	sub    $0x30,%rsp
  803cb3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cb6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cbd:	48 89 d6             	mov    %rdx,%rsi
  803cc0:	89 c7                	mov    %eax,%edi
  803cc2:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd5:	79 05                	jns    803cdc <pipeisclosed+0x31>
		return r;
  803cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cda:	eb 31                	jmp    803d0d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ce0:	48 89 c7             	mov    %rax,%rdi
  803ce3:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803cea:	00 00 00 
  803ced:	ff d0                	callq  *%rax
  803cef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cfb:	48 89 d6             	mov    %rdx,%rsi
  803cfe:	48 89 c7             	mov    %rax,%rdi
  803d01:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
}
  803d0d:	c9                   	leaveq 
  803d0e:	c3                   	retq   

0000000000803d0f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d0f:	55                   	push   %rbp
  803d10:	48 89 e5             	mov    %rsp,%rbp
  803d13:	48 83 ec 40          	sub    $0x40,%rsp
  803d17:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d27:	48 89 c7             	mov    %rax,%rdi
  803d2a:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
  803d36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d42:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d49:	00 
  803d4a:	e9 92 00 00 00       	jmpq   803de1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d4f:	eb 41                	jmp    803d92 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d51:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d56:	74 09                	je     803d61 <devpipe_read+0x52>
				return i;
  803d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d5c:	e9 92 00 00 00       	jmpq   803df3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d69:	48 89 d6             	mov    %rdx,%rsi
  803d6c:	48 89 c7             	mov    %rax,%rdi
  803d6f:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
  803d7b:	85 c0                	test   %eax,%eax
  803d7d:	74 07                	je     803d86 <devpipe_read+0x77>
				return 0;
  803d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d84:	eb 6d                	jmp    803df3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d86:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  803d8d:	00 00 00 
  803d90:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d96:	8b 10                	mov    (%rax),%edx
  803d98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9c:	8b 40 04             	mov    0x4(%rax),%eax
  803d9f:	39 c2                	cmp    %eax,%edx
  803da1:	74 ae                	je     803d51 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dab:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db3:	8b 00                	mov    (%rax),%eax
  803db5:	99                   	cltd   
  803db6:	c1 ea 1b             	shr    $0x1b,%edx
  803db9:	01 d0                	add    %edx,%eax
  803dbb:	83 e0 1f             	and    $0x1f,%eax
  803dbe:	29 d0                	sub    %edx,%eax
  803dc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dc4:	48 98                	cltq   
  803dc6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803dcb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd1:	8b 00                	mov    (%rax),%eax
  803dd3:	8d 50 01             	lea    0x1(%rax),%edx
  803dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dda:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ddc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803de9:	0f 82 60 ff ff ff    	jb     803d4f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803df3:	c9                   	leaveq 
  803df4:	c3                   	retq   

0000000000803df5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803df5:	55                   	push   %rbp
  803df6:	48 89 e5             	mov    %rsp,%rbp
  803df9:	48 83 ec 40          	sub    $0x40,%rsp
  803dfd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e0d:	48 89 c7             	mov    %rax,%rdi
  803e10:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
  803e1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e28:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e2f:	00 
  803e30:	e9 8e 00 00 00       	jmpq   803ec3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e35:	eb 31                	jmp    803e68 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3f:	48 89 d6             	mov    %rdx,%rsi
  803e42:	48 89 c7             	mov    %rax,%rdi
  803e45:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803e4c:	00 00 00 
  803e4f:	ff d0                	callq  *%rax
  803e51:	85 c0                	test   %eax,%eax
  803e53:	74 07                	je     803e5c <devpipe_write+0x67>
				return 0;
  803e55:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5a:	eb 79                	jmp    803ed5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e5c:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  803e63:	00 00 00 
  803e66:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6c:	8b 40 04             	mov    0x4(%rax),%eax
  803e6f:	48 63 d0             	movslq %eax,%rdx
  803e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e76:	8b 00                	mov    (%rax),%eax
  803e78:	48 98                	cltq   
  803e7a:	48 83 c0 20          	add    $0x20,%rax
  803e7e:	48 39 c2             	cmp    %rax,%rdx
  803e81:	73 b4                	jae    803e37 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e87:	8b 40 04             	mov    0x4(%rax),%eax
  803e8a:	99                   	cltd   
  803e8b:	c1 ea 1b             	shr    $0x1b,%edx
  803e8e:	01 d0                	add    %edx,%eax
  803e90:	83 e0 1f             	and    $0x1f,%eax
  803e93:	29 d0                	sub    %edx,%eax
  803e95:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e9d:	48 01 ca             	add    %rcx,%rdx
  803ea0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ea3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea7:	48 98                	cltq   
  803ea9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb1:	8b 40 04             	mov    0x4(%rax),%eax
  803eb4:	8d 50 01             	lea    0x1(%rax),%edx
  803eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ebe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ecb:	0f 82 64 ff ff ff    	jb     803e35 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ed5:	c9                   	leaveq 
  803ed6:	c3                   	retq   

0000000000803ed7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ed7:	55                   	push   %rbp
  803ed8:	48 89 e5             	mov    %rsp,%rbp
  803edb:	48 83 ec 20          	sub    $0x20,%rsp
  803edf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ee3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eeb:	48 89 c7             	mov    %rax,%rdi
  803eee:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f02:	48 be 59 4f 80 00 00 	movabs $0x804f59,%rsi
  803f09:	00 00 00 
  803f0c:	48 89 c7             	mov    %rax,%rdi
  803f0f:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  803f16:	00 00 00 
  803f19:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1f:	8b 50 04             	mov    0x4(%rax),%edx
  803f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f26:	8b 00                	mov    (%rax),%eax
  803f28:	29 c2                	sub    %eax,%edx
  803f2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f2e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f38:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f3f:	00 00 00 
	stat->st_dev = &devpipe;
  803f42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f46:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f4d:	00 00 00 
  803f50:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f5c:	c9                   	leaveq 
  803f5d:	c3                   	retq   

0000000000803f5e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f5e:	55                   	push   %rbp
  803f5f:	48 89 e5             	mov    %rsp,%rbp
  803f62:	48 83 ec 10          	sub    $0x10,%rsp
  803f66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6e:	48 89 c6             	mov    %rax,%rsi
  803f71:	bf 00 00 00 00       	mov    $0x0,%edi
  803f76:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f86:	48 89 c7             	mov    %rax,%rdi
  803f89:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803f90:	00 00 00 
  803f93:	ff d0                	callq  *%rax
  803f95:	48 89 c6             	mov    %rax,%rsi
  803f98:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9d:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
}
  803fa9:	c9                   	leaveq 
  803faa:	c3                   	retq   

0000000000803fab <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fab:	55                   	push   %rbp
  803fac:	48 89 e5             	mov    %rsp,%rbp
  803faf:	48 83 ec 20          	sub    $0x20,%rsp
  803fb3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fbc:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803fc0:	be 01 00 00 00       	mov    $0x1,%esi
  803fc5:	48 89 c7             	mov    %rax,%rdi
  803fc8:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  803fcf:	00 00 00 
  803fd2:	ff d0                	callq  *%rax
}
  803fd4:	c9                   	leaveq 
  803fd5:	c3                   	retq   

0000000000803fd6 <getchar>:

int
getchar(void)
{
  803fd6:	55                   	push   %rbp
  803fd7:	48 89 e5             	mov    %rsp,%rbp
  803fda:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fde:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fe2:	ba 01 00 00 00       	mov    $0x1,%edx
  803fe7:	48 89 c6             	mov    %rax,%rsi
  803fea:	bf 00 00 00 00       	mov    $0x0,%edi
  803fef:	48 b8 ea 26 80 00 00 	movabs $0x8026ea,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804002:	79 05                	jns    804009 <getchar+0x33>
		return r;
  804004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804007:	eb 14                	jmp    80401d <getchar+0x47>
	if (r < 1)
  804009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400d:	7f 07                	jg     804016 <getchar+0x40>
		return -E_EOF;
  80400f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804014:	eb 07                	jmp    80401d <getchar+0x47>
	return c;
  804016:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80401a:	0f b6 c0             	movzbl %al,%eax
}
  80401d:	c9                   	leaveq 
  80401e:	c3                   	retq   

000000000080401f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80401f:	55                   	push   %rbp
  804020:	48 89 e5             	mov    %rsp,%rbp
  804023:	48 83 ec 20          	sub    $0x20,%rsp
  804027:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80402a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80402e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804031:	48 89 d6             	mov    %rdx,%rsi
  804034:	89 c7                	mov    %eax,%edi
  804036:	48 b8 b8 22 80 00 00 	movabs $0x8022b8,%rax
  80403d:	00 00 00 
  804040:	ff d0                	callq  *%rax
  804042:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804049:	79 05                	jns    804050 <iscons+0x31>
		return r;
  80404b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404e:	eb 1a                	jmp    80406a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804054:	8b 10                	mov    (%rax),%edx
  804056:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80405d:	00 00 00 
  804060:	8b 00                	mov    (%rax),%eax
  804062:	39 c2                	cmp    %eax,%edx
  804064:	0f 94 c0             	sete   %al
  804067:	0f b6 c0             	movzbl %al,%eax
}
  80406a:	c9                   	leaveq 
  80406b:	c3                   	retq   

000000000080406c <opencons>:

int
opencons(void)
{
  80406c:	55                   	push   %rbp
  80406d:	48 89 e5             	mov    %rsp,%rbp
  804070:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804078:	48 89 c7             	mov    %rax,%rdi
  80407b:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
  804087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80408a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408e:	79 05                	jns    804095 <opencons+0x29>
		return r;
  804090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804093:	eb 5b                	jmp    8040f0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804099:	ba 07 04 00 00       	mov    $0x407,%edx
  80409e:	48 89 c6             	mov    %rax,%rsi
  8040a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040a6:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8040ad:	00 00 00 
  8040b0:	ff d0                	callq  *%rax
  8040b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b9:	79 05                	jns    8040c0 <opencons+0x54>
		return r;
  8040bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040be:	eb 30                	jmp    8040f0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c4:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040cb:	00 00 00 
  8040ce:	8b 12                	mov    (%rdx),%edx
  8040d0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e1:	48 89 c7             	mov    %rax,%rdi
  8040e4:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8040eb:	00 00 00 
  8040ee:	ff d0                	callq  *%rax
}
  8040f0:	c9                   	leaveq 
  8040f1:	c3                   	retq   

00000000008040f2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040f2:	55                   	push   %rbp
  8040f3:	48 89 e5             	mov    %rsp,%rbp
  8040f6:	48 83 ec 30          	sub    $0x30,%rsp
  8040fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804102:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804106:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80410b:	75 07                	jne    804114 <devcons_read+0x22>
		return 0;
  80410d:	b8 00 00 00 00       	mov    $0x0,%eax
  804112:	eb 4b                	jmp    80415f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804114:	eb 0c                	jmp    804122 <devcons_read+0x30>
		sys_yield();
  804116:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  80411d:	00 00 00 
  804120:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804122:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  804129:	00 00 00 
  80412c:	ff d0                	callq  *%rax
  80412e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804135:	74 df                	je     804116 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80413b:	79 05                	jns    804142 <devcons_read+0x50>
		return c;
  80413d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804140:	eb 1d                	jmp    80415f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804142:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804146:	75 07                	jne    80414f <devcons_read+0x5d>
		return 0;
  804148:	b8 00 00 00 00       	mov    $0x0,%eax
  80414d:	eb 10                	jmp    80415f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80414f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804152:	89 c2                	mov    %eax,%edx
  804154:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804158:	88 10                	mov    %dl,(%rax)
	return 1;
  80415a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80415f:	c9                   	leaveq 
  804160:	c3                   	retq   

0000000000804161 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804161:	55                   	push   %rbp
  804162:	48 89 e5             	mov    %rsp,%rbp
  804165:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80416c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804173:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80417a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804181:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804188:	eb 76                	jmp    804200 <devcons_write+0x9f>
		m = n - tot;
  80418a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804191:	89 c2                	mov    %eax,%edx
  804193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804196:	29 c2                	sub    %eax,%edx
  804198:	89 d0                	mov    %edx,%eax
  80419a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80419d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041a0:	83 f8 7f             	cmp    $0x7f,%eax
  8041a3:	76 07                	jbe    8041ac <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041a5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041af:	48 63 d0             	movslq %eax,%rdx
  8041b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b5:	48 63 c8             	movslq %eax,%rcx
  8041b8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041bf:	48 01 c1             	add    %rax,%rcx
  8041c2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041c9:	48 89 ce             	mov    %rcx,%rsi
  8041cc:	48 89 c7             	mov    %rax,%rdi
  8041cf:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8041d6:	00 00 00 
  8041d9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041de:	48 63 d0             	movslq %eax,%rdx
  8041e1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041e8:	48 89 d6             	mov    %rdx,%rsi
  8041eb:	48 89 c7             	mov    %rax,%rdi
  8041ee:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8041f5:	00 00 00 
  8041f8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041fd:	01 45 fc             	add    %eax,-0x4(%rbp)
  804200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804203:	48 98                	cltq   
  804205:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80420c:	0f 82 78 ff ff ff    	jb     80418a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804212:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804215:	c9                   	leaveq 
  804216:	c3                   	retq   

0000000000804217 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804217:	55                   	push   %rbp
  804218:	48 89 e5             	mov    %rsp,%rbp
  80421b:	48 83 ec 08          	sub    $0x8,%rsp
  80421f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804228:	c9                   	leaveq 
  804229:	c3                   	retq   

000000000080422a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80422a:	55                   	push   %rbp
  80422b:	48 89 e5             	mov    %rsp,%rbp
  80422e:	48 83 ec 10          	sub    $0x10,%rsp
  804232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804236:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80423a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423e:	48 be 65 4f 80 00 00 	movabs $0x804f65,%rsi
  804245:	00 00 00 
  804248:	48 89 c7             	mov    %rax,%rdi
  80424b:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  804252:	00 00 00 
  804255:	ff d0                	callq  *%rax
	return 0;
  804257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80425c:	c9                   	leaveq 
  80425d:	c3                   	retq   

000000000080425e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80425e:	55                   	push   %rbp
  80425f:	48 89 e5             	mov    %rsp,%rbp
  804262:	53                   	push   %rbx
  804263:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80426a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  804271:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804277:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80427e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804285:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80428c:	84 c0                	test   %al,%al
  80428e:	74 23                	je     8042b3 <_panic+0x55>
  804290:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804297:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80429b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80429f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8042a3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8042a7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8042ab:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8042af:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8042b3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8042ba:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8042c1:	00 00 00 
  8042c4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8042cb:	00 00 00 
  8042ce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8042d2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8042d9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042e0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8042e7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8042ee:	00 00 00 
  8042f1:	48 8b 18             	mov    (%rax),%rbx
  8042f4:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804306:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80430d:	41 89 c8             	mov    %ecx,%r8d
  804310:	48 89 d1             	mov    %rdx,%rcx
  804313:	48 89 da             	mov    %rbx,%rdx
  804316:	89 c6                	mov    %eax,%esi
  804318:	48 bf 70 4f 80 00 00 	movabs $0x804f70,%rdi
  80431f:	00 00 00 
  804322:	b8 00 00 00 00       	mov    $0x0,%eax
  804327:	49 b9 1b 03 80 00 00 	movabs $0x80031b,%r9
  80432e:	00 00 00 
  804331:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804334:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80433b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804342:	48 89 d6             	mov    %rdx,%rsi
  804345:	48 89 c7             	mov    %rax,%rdi
  804348:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  80434f:	00 00 00 
  804352:	ff d0                	callq  *%rax
	cprintf("\n");
  804354:	48 bf 93 4f 80 00 00 	movabs $0x804f93,%rdi
  80435b:	00 00 00 
  80435e:	b8 00 00 00 00       	mov    $0x0,%eax
  804363:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  80436a:	00 00 00 
  80436d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80436f:	cc                   	int3   
  804370:	eb fd                	jmp    80436f <_panic+0x111>

0000000000804372 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804372:	55                   	push   %rbp
  804373:	48 89 e5             	mov    %rsp,%rbp
  804376:	48 83 ec 10          	sub    $0x10,%rsp
  80437a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80437e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804385:	00 00 00 
  804388:	48 8b 00             	mov    (%rax),%rax
  80438b:	48 85 c0             	test   %rax,%rax
  80438e:	0f 85 84 00 00 00    	jne    804418 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804394:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80439b:	00 00 00 
  80439e:	48 8b 00             	mov    (%rax),%rax
  8043a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043a7:	ba 07 00 00 00       	mov    $0x7,%edx
  8043ac:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8043b1:	89 c7                	mov    %eax,%edi
  8043b3:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8043ba:	00 00 00 
  8043bd:	ff d0                	callq  *%rax
  8043bf:	85 c0                	test   %eax,%eax
  8043c1:	79 2a                	jns    8043ed <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8043c3:	48 ba 98 4f 80 00 00 	movabs $0x804f98,%rdx
  8043ca:	00 00 00 
  8043cd:	be 23 00 00 00       	mov    $0x23,%esi
  8043d2:	48 bf bf 4f 80 00 00 	movabs $0x804fbf,%rdi
  8043d9:	00 00 00 
  8043dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e1:	48 b9 5e 42 80 00 00 	movabs $0x80425e,%rcx
  8043e8:	00 00 00 
  8043eb:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8043ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043f4:	00 00 00 
  8043f7:	48 8b 00             	mov    (%rax),%rax
  8043fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804400:	48 be 2b 44 80 00 00 	movabs $0x80442b,%rsi
  804407:	00 00 00 
  80440a:	89 c7                	mov    %eax,%edi
  80440c:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  804413:	00 00 00 
  804416:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804418:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80441f:	00 00 00 
  804422:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804426:	48 89 10             	mov    %rdx,(%rax)
}
  804429:	c9                   	leaveq 
  80442a:	c3                   	retq   

000000000080442b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80442b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80442e:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804435:	00 00 00 
call *%rax
  804438:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  80443a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804441:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804442:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804449:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  80444a:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80444e:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804451:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804458:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804459:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80445d:	4c 8b 3c 24          	mov    (%rsp),%r15
  804461:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804466:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80446b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804470:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804475:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80447a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80447f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804484:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804489:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80448e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804493:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804498:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80449d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044a2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044a7:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8044ab:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8044af:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8044b0:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8044b1:	c3                   	retq   

00000000008044b2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044b2:	55                   	push   %rbp
  8044b3:	48 89 e5             	mov    %rsp,%rbp
  8044b6:	48 83 ec 30          	sub    $0x30,%rsp
  8044ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8044c6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8044cd:	00 00 00 
  8044d0:	48 8b 00             	mov    (%rax),%rax
  8044d3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8044d9:	85 c0                	test   %eax,%eax
  8044db:	75 3c                	jne    804519 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8044dd:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  8044e4:	00 00 00 
  8044e7:	ff d0                	callq  *%rax
  8044e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8044ee:	48 63 d0             	movslq %eax,%rdx
  8044f1:	48 89 d0             	mov    %rdx,%rax
  8044f4:	48 c1 e0 03          	shl    $0x3,%rax
  8044f8:	48 01 d0             	add    %rdx,%rax
  8044fb:	48 c1 e0 05          	shl    $0x5,%rax
  8044ff:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804506:	00 00 00 
  804509:	48 01 c2             	add    %rax,%rdx
  80450c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804513:	00 00 00 
  804516:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804519:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80451e:	75 0e                	jne    80452e <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804520:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804527:	00 00 00 
  80452a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80452e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804532:	48 89 c7             	mov    %rax,%rdi
  804535:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  80453c:	00 00 00 
  80453f:	ff d0                	callq  *%rax
  804541:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804548:	79 19                	jns    804563 <ipc_recv+0xb1>
		*from_env_store = 0;
  80454a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80454e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804558:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80455e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804561:	eb 53                	jmp    8045b6 <ipc_recv+0x104>
	}
	if(from_env_store)
  804563:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804568:	74 19                	je     804583 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80456a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804571:	00 00 00 
  804574:	48 8b 00             	mov    (%rax),%rax
  804577:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80457d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804581:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804583:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804588:	74 19                	je     8045a3 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80458a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804591:	00 00 00 
  804594:	48 8b 00             	mov    (%rax),%rax
  804597:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80459d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a1:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8045a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045aa:	00 00 00 
  8045ad:	48 8b 00             	mov    (%rax),%rax
  8045b0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8045b6:	c9                   	leaveq 
  8045b7:	c3                   	retq   

00000000008045b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045b8:	55                   	push   %rbp
  8045b9:	48 89 e5             	mov    %rsp,%rbp
  8045bc:	48 83 ec 30          	sub    $0x30,%rsp
  8045c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045c3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045c6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045ca:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8045cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045d2:	75 0e                	jne    8045e2 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8045d4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8045db:	00 00 00 
  8045de:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8045e2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045e5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ef:	89 c7                	mov    %eax,%edi
  8045f1:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  8045f8:	00 00 00 
  8045fb:	ff d0                	callq  *%rax
  8045fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804600:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804604:	75 0c                	jne    804612 <ipc_send+0x5a>
			sys_yield();
  804606:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  80460d:	00 00 00 
  804610:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804612:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804616:	74 ca                	je     8045e2 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804618:	c9                   	leaveq 
  804619:	c3                   	retq   

000000000080461a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80461a:	55                   	push   %rbp
  80461b:	48 89 e5             	mov    %rsp,%rbp
  80461e:	48 83 ec 14          	sub    $0x14,%rsp
  804622:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804625:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80462c:	eb 5e                	jmp    80468c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80462e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804635:	00 00 00 
  804638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463b:	48 63 d0             	movslq %eax,%rdx
  80463e:	48 89 d0             	mov    %rdx,%rax
  804641:	48 c1 e0 03          	shl    $0x3,%rax
  804645:	48 01 d0             	add    %rdx,%rax
  804648:	48 c1 e0 05          	shl    $0x5,%rax
  80464c:	48 01 c8             	add    %rcx,%rax
  80464f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804655:	8b 00                	mov    (%rax),%eax
  804657:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80465a:	75 2c                	jne    804688 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80465c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804663:	00 00 00 
  804666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804669:	48 63 d0             	movslq %eax,%rdx
  80466c:	48 89 d0             	mov    %rdx,%rax
  80466f:	48 c1 e0 03          	shl    $0x3,%rax
  804673:	48 01 d0             	add    %rdx,%rax
  804676:	48 c1 e0 05          	shl    $0x5,%rax
  80467a:	48 01 c8             	add    %rcx,%rax
  80467d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804683:	8b 40 08             	mov    0x8(%rax),%eax
  804686:	eb 12                	jmp    80469a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804688:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80468c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804693:	7e 99                	jle    80462e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80469a:	c9                   	leaveq 
  80469b:	c3                   	retq   

000000000080469c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80469c:	55                   	push   %rbp
  80469d:	48 89 e5             	mov    %rsp,%rbp
  8046a0:	48 83 ec 18          	sub    $0x18,%rsp
  8046a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046ac:	48 c1 e8 15          	shr    $0x15,%rax
  8046b0:	48 89 c2             	mov    %rax,%rdx
  8046b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046ba:	01 00 00 
  8046bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046c1:	83 e0 01             	and    $0x1,%eax
  8046c4:	48 85 c0             	test   %rax,%rax
  8046c7:	75 07                	jne    8046d0 <pageref+0x34>
		return 0;
  8046c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ce:	eb 53                	jmp    804723 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8046d8:	48 89 c2             	mov    %rax,%rdx
  8046db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046e2:	01 00 00 
  8046e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f1:	83 e0 01             	and    $0x1,%eax
  8046f4:	48 85 c0             	test   %rax,%rax
  8046f7:	75 07                	jne    804700 <pageref+0x64>
		return 0;
  8046f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fe:	eb 23                	jmp    804723 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804704:	48 c1 e8 0c          	shr    $0xc,%rax
  804708:	48 89 c2             	mov    %rax,%rdx
  80470b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804712:	00 00 00 
  804715:	48 c1 e2 04          	shl    $0x4,%rdx
  804719:	48 01 d0             	add    %rdx,%rax
  80471c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804720:	0f b7 c0             	movzwl %ax,%eax
}
  804723:	c9                   	leaveq 
  804724:	c3                   	retq   
