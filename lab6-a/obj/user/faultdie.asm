
obj/user/faultdie.debug:     file format elf64-x86-64


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
  80003c:	e8 9c 00 00 00       	callq  8000dd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	c9                   	leaveq 
  8000aa:	c3                   	retq   

00000000008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %rbp
  8000ac:	48 89 e5             	mov    %rsp,%rbp
  8000af:	48 83 ec 10          	sub    $0x10,%rsp
  8000b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000ba:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c1:	00 00 00 
  8000c4:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d0:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
  8000e1:	48 83 ec 10          	sub    $0x10,%rsp
  8000e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ec:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	48 63 d0             	movslq %eax,%rdx
  800100:	48 89 d0             	mov    %rdx,%rax
  800103:	48 c1 e0 03          	shl    $0x3,%rax
  800107:	48 01 d0             	add    %rdx,%rax
  80010a:	48 c1 e0 05          	shl    $0x5,%rax
  80010e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800115:	00 00 00 
  800118:	48 01 c2             	add    %rax,%rdx
  80011b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800122:	00 00 00 
  800125:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012c:	7e 14                	jle    800142 <libmain+0x65>
		binaryname = argv[0];
  80012e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800132:	48 8b 10             	mov    (%rax),%rdx
  800135:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80013c:	00 00 00 
  80013f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800142:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800149:	48 89 d6             	mov    %rdx,%rsi
  80014c:	89 c7                	mov    %eax,%edi
  80014e:	48 b8 ab 00 80 00 00 	movabs $0x8000ab,%rax
  800155:	00 00 00 
  800158:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80015a:	48 b8 68 01 80 00 00 	movabs $0x800168,%rax
  800161:	00 00 00 
  800164:	ff d0                	callq  *%rax
}
  800166:	c9                   	leaveq 
  800167:	c3                   	retq   

0000000000800168 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800168:	55                   	push   %rbp
  800169:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80016c:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  800173:	00 00 00 
  800176:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800178:	bf 00 00 00 00       	mov    $0x0,%edi
  80017d:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  800184:	00 00 00 
  800187:	ff d0                	callq  *%rax

}
  800189:	5d                   	pop    %rbp
  80018a:	c3                   	retq   

000000000080018b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	48 83 ec 10          	sub    $0x10,%rsp
  800193:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800196:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80019a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019e:	8b 00                	mov    (%rax),%eax
  8001a0:	8d 48 01             	lea    0x1(%rax),%ecx
  8001a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a7:	89 0a                	mov    %ecx,(%rdx)
  8001a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ac:	89 d1                	mov    %edx,%ecx
  8001ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b2:	48 98                	cltq   
  8001b4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	8b 00                	mov    (%rax),%eax
  8001be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c3:	75 2c                	jne    8001f1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c9:	8b 00                	mov    (%rax),%eax
  8001cb:	48 98                	cltq   
  8001cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d1:	48 83 c2 08          	add    $0x8,%rdx
  8001d5:	48 89 c6             	mov    %rax,%rsi
  8001d8:	48 89 d7             	mov    %rdx,%rdi
  8001db:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
        b->idx = 0;
  8001e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001eb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f5:	8b 40 04             	mov    0x4(%rax),%eax
  8001f8:	8d 50 01             	lea    0x1(%rax),%edx
  8001fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ff:	89 50 04             	mov    %edx,0x4(%rax)
}
  800202:	c9                   	leaveq 
  800203:	c3                   	retq   

0000000000800204 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800204:	55                   	push   %rbp
  800205:	48 89 e5             	mov    %rsp,%rbp
  800208:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80020f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800216:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80021d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800224:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80022b:	48 8b 0a             	mov    (%rdx),%rcx
  80022e:	48 89 08             	mov    %rcx,(%rax)
  800231:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800235:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800239:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80023d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800241:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800248:	00 00 00 
    b.cnt = 0;
  80024b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800252:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800255:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80025c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800263:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80026a:	48 89 c6             	mov    %rax,%rsi
  80026d:	48 bf 8b 01 80 00 00 	movabs $0x80018b,%rdi
  800274:	00 00 00 
  800277:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800283:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800289:	48 98                	cltq   
  80028b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800292:	48 83 c2 08          	add    $0x8,%rdx
  800296:	48 89 c6             	mov    %rax,%rsi
  800299:	48 89 d7             	mov    %rdx,%rdi
  80029c:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002ae:	c9                   	leaveq 
  8002af:	c3                   	retq   

00000000008002b0 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002b0:	55                   	push   %rbp
  8002b1:	48 89 e5             	mov    %rsp,%rbp
  8002b4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002bb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002c9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002d7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002de:	84 c0                	test   %al,%al
  8002e0:	74 20                	je     800302 <cprintf+0x52>
  8002e2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002e6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002ee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002f6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002fa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002fe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800302:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800309:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800310:	00 00 00 
  800313:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80031a:	00 00 00 
  80031d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800321:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800328:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80032f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800336:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80033d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800344:	48 8b 0a             	mov    (%rdx),%rcx
  800347:	48 89 08             	mov    %rcx,(%rax)
  80034a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800352:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800356:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80035a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800361:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800368:	48 89 d6             	mov    %rdx,%rsi
  80036b:	48 89 c7             	mov    %rax,%rdi
  80036e:	48 b8 04 02 80 00 00 	movabs $0x800204,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800380:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800386:	c9                   	leaveq 
  800387:	c3                   	retq   

0000000000800388 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	53                   	push   %rbx
  80038d:	48 83 ec 38          	sub    $0x38,%rsp
  800391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80039d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003a0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003a4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003ab:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003af:	77 3b                	ja     8003ec <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003b4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003b8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c4:	48 f7 f3             	div    %rbx
  8003c7:	48 89 c2             	mov    %rax,%rdx
  8003ca:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003cd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d8:	41 89 f9             	mov    %edi,%r9d
  8003db:	48 89 c7             	mov    %rax,%rdi
  8003de:	48 b8 88 03 80 00 00 	movabs $0x800388,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
  8003ea:	eb 1e                	jmp    80040a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ec:	eb 12                	jmp    800400 <printnum+0x78>
			putch(padc, putdat);
  8003ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f9:	48 89 ce             	mov    %rcx,%rsi
  8003fc:	89 d7                	mov    %edx,%edi
  8003fe:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800400:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800404:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800408:	7f e4                	jg     8003ee <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80040d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	48 f7 f1             	div    %rcx
  800419:	48 89 d0             	mov    %rdx,%rax
  80041c:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  800423:	00 00 00 
  800426:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80042a:	0f be d0             	movsbl %al,%edx
  80042d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800435:	48 89 ce             	mov    %rcx,%rsi
  800438:	89 d7                	mov    %edx,%edi
  80043a:	ff d0                	callq  *%rax
}
  80043c:	48 83 c4 38          	add    $0x38,%rsp
  800440:	5b                   	pop    %rbx
  800441:	5d                   	pop    %rbp
  800442:	c3                   	retq   

0000000000800443 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 1c          	sub    $0x1c,%rsp
  80044b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80044f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800452:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800456:	7e 52                	jle    8004aa <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045c:	8b 00                	mov    (%rax),%eax
  80045e:	83 f8 30             	cmp    $0x30,%eax
  800461:	73 24                	jae    800487 <getuint+0x44>
  800463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800467:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80046b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046f:	8b 00                	mov    (%rax),%eax
  800471:	89 c0                	mov    %eax,%eax
  800473:	48 01 d0             	add    %rdx,%rax
  800476:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047a:	8b 12                	mov    (%rdx),%edx
  80047c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80047f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800483:	89 0a                	mov    %ecx,(%rdx)
  800485:	eb 17                	jmp    80049e <getuint+0x5b>
  800487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048f:	48 89 d0             	mov    %rdx,%rax
  800492:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80049e:	48 8b 00             	mov    (%rax),%rax
  8004a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a5:	e9 a3 00 00 00       	jmpq   80054d <getuint+0x10a>
	else if (lflag)
  8004aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ae:	74 4f                	je     8004ff <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	8b 00                	mov    (%rax),%eax
  8004b6:	83 f8 30             	cmp    $0x30,%eax
  8004b9:	73 24                	jae    8004df <getuint+0x9c>
  8004bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	8b 00                	mov    (%rax),%eax
  8004c9:	89 c0                	mov    %eax,%eax
  8004cb:	48 01 d0             	add    %rdx,%rax
  8004ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d2:	8b 12                	mov    (%rdx),%edx
  8004d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	89 0a                	mov    %ecx,(%rdx)
  8004dd:	eb 17                	jmp    8004f6 <getuint+0xb3>
  8004df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004e7:	48 89 d0             	mov    %rdx,%rax
  8004ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f6:	48 8b 00             	mov    (%rax),%rax
  8004f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004fd:	eb 4e                	jmp    80054d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	8b 00                	mov    (%rax),%eax
  800505:	83 f8 30             	cmp    $0x30,%eax
  800508:	73 24                	jae    80052e <getuint+0xeb>
  80050a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800516:	8b 00                	mov    (%rax),%eax
  800518:	89 c0                	mov    %eax,%eax
  80051a:	48 01 d0             	add    %rdx,%rax
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	8b 12                	mov    (%rdx),%edx
  800523:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800526:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052a:	89 0a                	mov    %ecx,(%rdx)
  80052c:	eb 17                	jmp    800545 <getuint+0x102>
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800536:	48 89 d0             	mov    %rdx,%rax
  800539:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80053d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800541:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800545:	8b 00                	mov    (%rax),%eax
  800547:	89 c0                	mov    %eax,%eax
  800549:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80054d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800551:	c9                   	leaveq 
  800552:	c3                   	retq   

0000000000800553 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800553:	55                   	push   %rbp
  800554:	48 89 e5             	mov    %rsp,%rbp
  800557:	48 83 ec 1c          	sub    $0x1c,%rsp
  80055b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80055f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800562:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800566:	7e 52                	jle    8005ba <getint+0x67>
		x=va_arg(*ap, long long);
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	83 f8 30             	cmp    $0x30,%eax
  800571:	73 24                	jae    800597 <getint+0x44>
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	8b 00                	mov    (%rax),%eax
  800581:	89 c0                	mov    %eax,%eax
  800583:	48 01 d0             	add    %rdx,%rax
  800586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058a:	8b 12                	mov    (%rdx),%edx
  80058c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800593:	89 0a                	mov    %ecx,(%rdx)
  800595:	eb 17                	jmp    8005ae <getint+0x5b>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80059f:	48 89 d0             	mov    %rdx,%rax
  8005a2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ae:	48 8b 00             	mov    (%rax),%rax
  8005b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b5:	e9 a3 00 00 00       	jmpq   80065d <getint+0x10a>
	else if (lflag)
  8005ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005be:	74 4f                	je     80060f <getint+0xbc>
		x=va_arg(*ap, long);
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	8b 00                	mov    (%rax),%eax
  8005c6:	83 f8 30             	cmp    $0x30,%eax
  8005c9:	73 24                	jae    8005ef <getint+0x9c>
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	89 c0                	mov    %eax,%eax
  8005db:	48 01 d0             	add    %rdx,%rax
  8005de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e2:	8b 12                	mov    (%rdx),%edx
  8005e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	89 0a                	mov    %ecx,(%rdx)
  8005ed:	eb 17                	jmp    800606 <getint+0xb3>
  8005ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005f7:	48 89 d0             	mov    %rdx,%rax
  8005fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800606:	48 8b 00             	mov    (%rax),%rax
  800609:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80060d:	eb 4e                	jmp    80065d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	83 f8 30             	cmp    $0x30,%eax
  800618:	73 24                	jae    80063e <getint+0xeb>
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	89 c0                	mov    %eax,%eax
  80062a:	48 01 d0             	add    %rdx,%rax
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	8b 12                	mov    (%rdx),%edx
  800633:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063a:	89 0a                	mov    %ecx,(%rdx)
  80063c:	eb 17                	jmp    800655 <getint+0x102>
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800646:	48 89 d0             	mov    %rdx,%rax
  800649:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800655:	8b 00                	mov    (%rax),%eax
  800657:	48 98                	cltq   
  800659:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80065d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	41 54                	push   %r12
  800669:	53                   	push   %rbx
  80066a:	48 83 ec 60          	sub    $0x60,%rsp
  80066e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800672:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800676:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80067e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800682:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800686:	48 8b 0a             	mov    (%rdx),%rcx
  800689:	48 89 08             	mov    %rcx,(%rax)
  80068c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800690:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800694:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800698:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069c:	eb 17                	jmp    8006b5 <vprintfmt+0x52>
			if (ch == '\0')
  80069e:	85 db                	test   %ebx,%ebx
  8006a0:	0f 84 cc 04 00 00    	je     800b72 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006a6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ae:	48 89 d6             	mov    %rdx,%rsi
  8006b1:	89 df                	mov    %ebx,%edi
  8006b3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006bd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c1:	0f b6 00             	movzbl (%rax),%eax
  8006c4:	0f b6 d8             	movzbl %al,%ebx
  8006c7:	83 fb 25             	cmp    $0x25,%ebx
  8006ca:	75 d2                	jne    80069e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006cc:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006e5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f8:	0f b6 00             	movzbl (%rax),%eax
  8006fb:	0f b6 d8             	movzbl %al,%ebx
  8006fe:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800701:	83 f8 55             	cmp    $0x55,%eax
  800704:	0f 87 34 04 00 00    	ja     800b3e <vprintfmt+0x4db>
  80070a:	89 c0                	mov    %eax,%eax
  80070c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800713:	00 
  800714:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  80071b:	00 00 00 
  80071e:	48 01 d0             	add    %rdx,%rax
  800721:	48 8b 00             	mov    (%rax),%rax
  800724:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800726:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80072a:	eb c0                	jmp    8006ec <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80072c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800730:	eb ba                	jmp    8006ec <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800732:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800739:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80073c:	89 d0                	mov    %edx,%eax
  80073e:	c1 e0 02             	shl    $0x2,%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	01 c0                	add    %eax,%eax
  800745:	01 d8                	add    %ebx,%eax
  800747:	83 e8 30             	sub    $0x30,%eax
  80074a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80074d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800751:	0f b6 00             	movzbl (%rax),%eax
  800754:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800757:	83 fb 2f             	cmp    $0x2f,%ebx
  80075a:	7e 0c                	jle    800768 <vprintfmt+0x105>
  80075c:	83 fb 39             	cmp    $0x39,%ebx
  80075f:	7f 07                	jg     800768 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800761:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800766:	eb d1                	jmp    800739 <vprintfmt+0xd6>
			goto process_precision;
  800768:	eb 58                	jmp    8007c2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80076a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076d:	83 f8 30             	cmp    $0x30,%eax
  800770:	73 17                	jae    800789 <vprintfmt+0x126>
  800772:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800776:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800779:	89 c0                	mov    %eax,%eax
  80077b:	48 01 d0             	add    %rdx,%rax
  80077e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800781:	83 c2 08             	add    $0x8,%edx
  800784:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800787:	eb 0f                	jmp    800798 <vprintfmt+0x135>
  800789:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078d:	48 89 d0             	mov    %rdx,%rax
  800790:	48 83 c2 08          	add    $0x8,%rdx
  800794:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80079d:	eb 23                	jmp    8007c2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80079f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a3:	79 0c                	jns    8007b1 <vprintfmt+0x14e>
				width = 0;
  8007a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ac:	e9 3b ff ff ff       	jmpq   8006ec <vprintfmt+0x89>
  8007b1:	e9 36 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007b6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007bd:	e9 2a ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c6:	79 12                	jns    8007da <vprintfmt+0x177>
				width = precision, precision = -1;
  8007c8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007cb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007d5:	e9 12 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>
  8007da:	e9 0d ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007df:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007e3:	e9 04 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 17                	jae    800807 <vprintfmt+0x1a4>
  8007f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ff:	83 c2 08             	add    $0x8,%edx
  800802:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800805:	eb 0f                	jmp    800816 <vprintfmt+0x1b3>
  800807:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080b:	48 89 d0             	mov    %rdx,%rax
  80080e:	48 83 c2 08          	add    $0x8,%rdx
  800812:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800816:	8b 10                	mov    (%rax),%edx
  800818:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80081c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800820:	48 89 ce             	mov    %rcx,%rsi
  800823:	89 d7                	mov    %edx,%edi
  800825:	ff d0                	callq  *%rax
			break;
  800827:	e9 40 03 00 00       	jmpq   800b6c <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80082c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082f:	83 f8 30             	cmp    $0x30,%eax
  800832:	73 17                	jae    80084b <vprintfmt+0x1e8>
  800834:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800838:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083b:	89 c0                	mov    %eax,%eax
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800843:	83 c2 08             	add    $0x8,%edx
  800846:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800849:	eb 0f                	jmp    80085a <vprintfmt+0x1f7>
  80084b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084f:	48 89 d0             	mov    %rdx,%rax
  800852:	48 83 c2 08          	add    $0x8,%rdx
  800856:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80085c:	85 db                	test   %ebx,%ebx
  80085e:	79 02                	jns    800862 <vprintfmt+0x1ff>
				err = -err;
  800860:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800862:	83 fb 15             	cmp    $0x15,%ebx
  800865:	7f 16                	jg     80087d <vprintfmt+0x21a>
  800867:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  80086e:	00 00 00 
  800871:	48 63 d3             	movslq %ebx,%rdx
  800874:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800878:	4d 85 e4             	test   %r12,%r12
  80087b:	75 2e                	jne    8008ab <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80087d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800885:	89 d9                	mov    %ebx,%ecx
  800887:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  80088e:	00 00 00 
  800891:	48 89 c7             	mov    %rax,%rdi
  800894:	b8 00 00 00 00       	mov    $0x0,%eax
  800899:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  8008a0:	00 00 00 
  8008a3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a6:	e9 c1 02 00 00       	jmpq   800b6c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ab:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b3:	4c 89 e1             	mov    %r12,%rcx
  8008b6:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  8008bd:	00 00 00 
  8008c0:	48 89 c7             	mov    %rax,%rdi
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  8008cf:	00 00 00 
  8008d2:	41 ff d0             	callq  *%r8
			break;
  8008d5:	e9 92 02 00 00       	jmpq   800b6c <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dd:	83 f8 30             	cmp    $0x30,%eax
  8008e0:	73 17                	jae    8008f9 <vprintfmt+0x296>
  8008e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e9:	89 c0                	mov    %eax,%eax
  8008eb:	48 01 d0             	add    %rdx,%rax
  8008ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f1:	83 c2 08             	add    $0x8,%edx
  8008f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f7:	eb 0f                	jmp    800908 <vprintfmt+0x2a5>
  8008f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fd:	48 89 d0             	mov    %rdx,%rax
  800900:	48 83 c2 08          	add    $0x8,%rdx
  800904:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800908:	4c 8b 20             	mov    (%rax),%r12
  80090b:	4d 85 e4             	test   %r12,%r12
  80090e:	75 0a                	jne    80091a <vprintfmt+0x2b7>
				p = "(null)";
  800910:	49 bc 6d 42 80 00 00 	movabs $0x80426d,%r12
  800917:	00 00 00 
			if (width > 0 && padc != '-')
  80091a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091e:	7e 3f                	jle    80095f <vprintfmt+0x2fc>
  800920:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800924:	74 39                	je     80095f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800926:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800929:	48 98                	cltq   
  80092b:	48 89 c6             	mov    %rax,%rsi
  80092e:	4c 89 e7             	mov    %r12,%rdi
  800931:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  800938:	00 00 00 
  80093b:	ff d0                	callq  *%rax
  80093d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800940:	eb 17                	jmp    800959 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800942:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800946:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80094a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094e:	48 89 ce             	mov    %rcx,%rsi
  800951:	89 d7                	mov    %edx,%edi
  800953:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800959:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095d:	7f e3                	jg     800942 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095f:	eb 37                	jmp    800998 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800961:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800965:	74 1e                	je     800985 <vprintfmt+0x322>
  800967:	83 fb 1f             	cmp    $0x1f,%ebx
  80096a:	7e 05                	jle    800971 <vprintfmt+0x30e>
  80096c:	83 fb 7e             	cmp    $0x7e,%ebx
  80096f:	7e 14                	jle    800985 <vprintfmt+0x322>
					putch('?', putdat);
  800971:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800975:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800979:	48 89 d6             	mov    %rdx,%rsi
  80097c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800981:	ff d0                	callq  *%rax
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	89 df                	mov    %ebx,%edi
  800992:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800994:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800998:	4c 89 e0             	mov    %r12,%rax
  80099b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80099f:	0f b6 00             	movzbl (%rax),%eax
  8009a2:	0f be d8             	movsbl %al,%ebx
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	74 10                	je     8009b9 <vprintfmt+0x356>
  8009a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ad:	78 b2                	js     800961 <vprintfmt+0x2fe>
  8009af:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b7:	79 a8                	jns    800961 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b9:	eb 16                	jmp    8009d1 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c3:	48 89 d6             	mov    %rdx,%rsi
  8009c6:	bf 20 00 00 00       	mov    $0x20,%edi
  8009cb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d5:	7f e4                	jg     8009bb <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009d7:	e9 90 01 00 00       	jmpq   800b6c <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009dc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e0:	be 03 00 00 00       	mov    $0x3,%esi
  8009e5:	48 89 c7             	mov    %rax,%rdi
  8009e8:	48 b8 53 05 80 00 00 	movabs $0x800553,%rax
  8009ef:	00 00 00 
  8009f2:	ff d0                	callq  *%rax
  8009f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	48 85 c0             	test   %rax,%rax
  8009ff:	79 1d                	jns    800a1e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a11:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 f7 d8             	neg    %rax
  800a1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a25:	e9 d5 00 00 00       	jmpq   800aff <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2e:	be 03 00 00 00       	mov    $0x3,%esi
  800a33:	48 89 c7             	mov    %rax,%rdi
  800a36:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  800a3d:	00 00 00 
  800a40:	ff d0                	callq  *%rax
  800a42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a46:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4d:	e9 ad 00 00 00       	jmpq   800aff <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a52:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a59:	89 d6                	mov    %edx,%esi
  800a5b:	48 89 c7             	mov    %rax,%rdi
  800a5e:	48 b8 53 05 80 00 00 	movabs $0x800553,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	callq  *%rax
  800a6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a6e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a75:	e9 85 00 00 00       	jmpq   800aff <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800a7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	48 89 d6             	mov    %rdx,%rsi
  800a85:	bf 30 00 00 00       	mov    $0x30,%edi
  800a8a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a94:	48 89 d6             	mov    %rdx,%rsi
  800a97:	bf 78 00 00 00       	mov    $0x78,%edi
  800a9c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa1:	83 f8 30             	cmp    $0x30,%eax
  800aa4:	73 17                	jae    800abd <vprintfmt+0x45a>
  800aa6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aad:	89 c0                	mov    %eax,%eax
  800aaf:	48 01 d0             	add    %rdx,%rax
  800ab2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab5:	83 c2 08             	add    $0x8,%edx
  800ab8:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abb:	eb 0f                	jmp    800acc <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800abd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac1:	48 89 d0             	mov    %rdx,%rax
  800ac4:	48 83 c2 08          	add    $0x8,%rdx
  800ac8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800acc:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ad3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ada:	eb 23                	jmp    800aff <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800adc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae0:	be 03 00 00 00       	mov    $0x3,%esi
  800ae5:	48 89 c7             	mov    %rax,%rdi
  800ae8:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	callq  *%rax
  800af4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800af8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aff:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b04:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b07:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b16:	45 89 c1             	mov    %r8d,%r9d
  800b19:	41 89 f8             	mov    %edi,%r8d
  800b1c:	48 89 c7             	mov    %rax,%rdi
  800b1f:	48 b8 88 03 80 00 00 	movabs $0x800388,%rax
  800b26:	00 00 00 
  800b29:	ff d0                	callq  *%rax
			break;
  800b2b:	eb 3f                	jmp    800b6c <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	89 df                	mov    %ebx,%edi
  800b3a:	ff d0                	callq  *%rax
			break;
  800b3c:	eb 2e                	jmp    800b6c <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b46:	48 89 d6             	mov    %rdx,%rsi
  800b49:	bf 25 00 00 00       	mov    $0x25,%edi
  800b4e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b55:	eb 05                	jmp    800b5c <vprintfmt+0x4f9>
  800b57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b60:	48 83 e8 01          	sub    $0x1,%rax
  800b64:	0f b6 00             	movzbl (%rax),%eax
  800b67:	3c 25                	cmp    $0x25,%al
  800b69:	75 ec                	jne    800b57 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b6b:	90                   	nop
		}
	}
  800b6c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6d:	e9 43 fb ff ff       	jmpq   8006b5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b72:	48 83 c4 60          	add    $0x60,%rsp
  800b76:	5b                   	pop    %rbx
  800b77:	41 5c                	pop    %r12
  800b79:	5d                   	pop    %rbp
  800b7a:	c3                   	retq   

0000000000800b7b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7b:	55                   	push   %rbp
  800b7c:	48 89 e5             	mov    %rsp,%rbp
  800b7f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b86:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b8d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b94:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b9b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 20                	je     800bcd <printfmt+0x52>
  800bad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bb5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bb9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bbd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bc5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bc9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bcd:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bd4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bdb:	00 00 00 
  800bde:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800be5:	00 00 00 
  800be8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bf3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bfa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c01:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c08:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c0f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c16:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c1d:	48 89 c7             	mov    %rax,%rdi
  800c20:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  800c27:	00 00 00 
  800c2a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c2c:	c9                   	leaveq 
  800c2d:	c3                   	retq   

0000000000800c2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2e:	55                   	push   %rbp
  800c2f:	48 89 e5             	mov    %rsp,%rbp
  800c32:	48 83 ec 10          	sub    $0x10,%rsp
  800c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c41:	8b 40 10             	mov    0x10(%rax),%eax
  800c44:	8d 50 01             	lea    0x1(%rax),%edx
  800c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c52:	48 8b 10             	mov    (%rax),%rdx
  800c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c59:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c5d:	48 39 c2             	cmp    %rax,%rdx
  800c60:	73 17                	jae    800c79 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	48 8b 00             	mov    (%rax),%rax
  800c69:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c71:	48 89 0a             	mov    %rcx,(%rdx)
  800c74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c77:	88 10                	mov    %dl,(%rax)
}
  800c79:	c9                   	leaveq 
  800c7a:	c3                   	retq   

0000000000800c7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c7b:	55                   	push   %rbp
  800c7c:	48 89 e5             	mov    %rsp,%rbp
  800c7f:	48 83 ec 50          	sub    $0x50,%rsp
  800c83:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c87:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c8a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c8e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c92:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c96:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c9a:	48 8b 0a             	mov    (%rdx),%rcx
  800c9d:	48 89 08             	mov    %rcx,(%rax)
  800ca0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cb8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cbb:	48 98                	cltq   
  800cbd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cc1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc5:	48 01 d0             	add    %rdx,%rax
  800cc8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ccc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cd3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cd8:	74 06                	je     800ce0 <vsnprintf+0x65>
  800cda:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cde:	7f 07                	jg     800ce7 <vsnprintf+0x6c>
		return -E_INVAL;
  800ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce5:	eb 2f                	jmp    800d16 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ce7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ceb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cf3:	48 89 c6             	mov    %rax,%rsi
  800cf6:	48 bf 2e 0c 80 00 00 	movabs $0x800c2e,%rdi
  800cfd:	00 00 00 
  800d00:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d10:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d13:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d16:	c9                   	leaveq 
  800d17:	c3                   	retq   

0000000000800d18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d18:	55                   	push   %rbp
  800d19:	48 89 e5             	mov    %rsp,%rbp
  800d1c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d23:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d2a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d45:	84 c0                	test   %al,%al
  800d47:	74 20                	je     800d69 <snprintf+0x51>
  800d49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d69:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d70:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d77:	00 00 00 
  800d7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d81:	00 00 00 
  800d84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dab:	48 8b 0a             	mov    (%rdx),%rcx
  800dae:	48 89 08             	mov    %rcx,(%rax)
  800db1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dc1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dc8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dcf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dd5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	48 b8 7b 0c 80 00 00 	movabs $0x800c7b,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800df1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df7:	c9                   	leaveq 
  800df8:	c3                   	retq   

0000000000800df9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800df9:	55                   	push   %rbp
  800dfa:	48 89 e5             	mov    %rsp,%rbp
  800dfd:	48 83 ec 18          	sub    $0x18,%rsp
  800e01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0c:	eb 09                	jmp    800e17 <strlen+0x1e>
		n++;
  800e0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	0f b6 00             	movzbl (%rax),%eax
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 ec                	jne    800e0e <strlen+0x15>
		n++;
	return n;
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 20          	sub    $0x20,%rsp
  800e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e3e:	eb 0e                	jmp    800e4e <strnlen+0x27>
		n++;
  800e40:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e44:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e49:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e4e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e53:	74 0b                	je     800e60 <strnlen+0x39>
  800e55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e59:	0f b6 00             	movzbl (%rax),%eax
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 e0                	jne    800e40 <strnlen+0x19>
		n++;
	return n;
  800e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e63:	c9                   	leaveq 
  800e64:	c3                   	retq   

0000000000800e65 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e65:	55                   	push   %rbp
  800e66:	48 89 e5             	mov    %rsp,%rbp
  800e69:	48 83 ec 20          	sub    $0x20,%rsp
  800e6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e7d:	90                   	nop
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e86:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e8a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e8e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e92:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e96:	0f b6 12             	movzbl (%rdx),%edx
  800e99:	88 10                	mov    %dl,(%rax)
  800e9b:	0f b6 00             	movzbl (%rax),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	75 dc                	jne    800e7e <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ea6:	c9                   	leaveq 
  800ea7:	c3                   	retq   

0000000000800ea8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ea8:	55                   	push   %rbp
  800ea9:	48 89 e5             	mov    %rsp,%rbp
  800eac:	48 83 ec 20          	sub    $0x20,%rsp
  800eb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	48 89 c7             	mov    %rax,%rdi
  800ebf:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  800ec6:	00 00 00 
  800ec9:	ff d0                	callq  *%rax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed1:	48 63 d0             	movslq %eax,%rdx
  800ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed8:	48 01 c2             	add    %rax,%rdx
  800edb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800edf:	48 89 c6             	mov    %rax,%rsi
  800ee2:	48 89 d7             	mov    %rdx,%rdi
  800ee5:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  800eec:	00 00 00 
  800eef:	ff d0                	callq  *%rax
	return dst;
  800ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ef5:	c9                   	leaveq 
  800ef6:	c3                   	retq   

0000000000800ef7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef7:	55                   	push   %rbp
  800ef8:	48 89 e5             	mov    %rsp,%rbp
  800efb:	48 83 ec 28          	sub    $0x28,%rsp
  800eff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f03:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f07:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f13:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f1a:	00 
  800f1b:	eb 2a                	jmp    800f47 <strncpy+0x50>
		*dst++ = *src;
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f29:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2d:	0f b6 12             	movzbl (%rdx),%edx
  800f30:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f36:	0f b6 00             	movzbl (%rax),%eax
  800f39:	84 c0                	test   %al,%al
  800f3b:	74 05                	je     800f42 <strncpy+0x4b>
			src++;
  800f3d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f42:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f4f:	72 cc                	jb     800f1d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f55:	c9                   	leaveq 
  800f56:	c3                   	retq   

0000000000800f57 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f57:	55                   	push   %rbp
  800f58:	48 89 e5             	mov    %rsp,%rbp
  800f5b:	48 83 ec 28          	sub    $0x28,%rsp
  800f5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f73:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f78:	74 3d                	je     800fb7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f7a:	eb 1d                	jmp    800f99 <strlcpy+0x42>
			*dst++ = *src++;
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f84:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f88:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f8c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f90:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f94:	0f b6 12             	movzbl (%rdx),%edx
  800f97:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f99:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f9e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa3:	74 0b                	je     800fb0 <strlcpy+0x59>
  800fa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa9:	0f b6 00             	movzbl (%rax),%eax
  800fac:	84 c0                	test   %al,%al
  800fae:	75 cc                	jne    800f7c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbf:	48 29 c2             	sub    %rax,%rdx
  800fc2:	48 89 d0             	mov    %rdx,%rax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 10          	sub    $0x10,%rsp
  800fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fd7:	eb 0a                	jmp    800fe3 <strcmp+0x1c>
		p++, q++;
  800fd9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fde:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe7:	0f b6 00             	movzbl (%rax),%eax
  800fea:	84 c0                	test   %al,%al
  800fec:	74 12                	je     801000 <strcmp+0x39>
  800fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff2:	0f b6 10             	movzbl (%rax),%edx
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	0f b6 00             	movzbl (%rax),%eax
  800ffc:	38 c2                	cmp    %al,%dl
  800ffe:	74 d9                	je     800fd9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801004:	0f b6 00             	movzbl (%rax),%eax
  801007:	0f b6 d0             	movzbl %al,%edx
  80100a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	0f b6 c0             	movzbl %al,%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
}
  801018:	c9                   	leaveq 
  801019:	c3                   	retq   

000000000080101a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80101a:	55                   	push   %rbp
  80101b:	48 89 e5             	mov    %rsp,%rbp
  80101e:	48 83 ec 18          	sub    $0x18,%rsp
  801022:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801026:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80102a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80102e:	eb 0f                	jmp    80103f <strncmp+0x25>
		n--, p++, q++;
  801030:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801035:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80103a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80103f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801044:	74 1d                	je     801063 <strncmp+0x49>
  801046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	74 12                	je     801063 <strncmp+0x49>
  801051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801055:	0f b6 10             	movzbl (%rax),%edx
  801058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105c:	0f b6 00             	movzbl (%rax),%eax
  80105f:	38 c2                	cmp    %al,%dl
  801061:	74 cd                	je     801030 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801063:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801068:	75 07                	jne    801071 <strncmp+0x57>
		return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
  80106f:	eb 18                	jmp    801089 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801075:	0f b6 00             	movzbl (%rax),%eax
  801078:	0f b6 d0             	movzbl %al,%edx
  80107b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107f:	0f b6 00             	movzbl (%rax),%eax
  801082:	0f b6 c0             	movzbl %al,%eax
  801085:	29 c2                	sub    %eax,%edx
  801087:	89 d0                	mov    %edx,%eax
}
  801089:	c9                   	leaveq 
  80108a:	c3                   	retq   

000000000080108b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	48 83 ec 0c          	sub    $0xc,%rsp
  801093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801097:	89 f0                	mov    %esi,%eax
  801099:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109c:	eb 17                	jmp    8010b5 <strchr+0x2a>
		if (*s == c)
  80109e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a8:	75 06                	jne    8010b0 <strchr+0x25>
			return (char *) s;
  8010aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ae:	eb 15                	jmp    8010c5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 de                	jne    80109e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 0c          	sub    $0xc,%rsp
  8010cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d3:	89 f0                	mov    %esi,%eax
  8010d5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d8:	eb 13                	jmp    8010ed <strfind+0x26>
		if (*s == c)
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	0f b6 00             	movzbl (%rax),%eax
  8010e1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e4:	75 02                	jne    8010e8 <strfind+0x21>
			break;
  8010e6:	eb 10                	jmp    8010f8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	0f b6 00             	movzbl (%rax),%eax
  8010f4:	84 c0                	test   %al,%al
  8010f6:	75 e2                	jne    8010da <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 18          	sub    $0x18,%rsp
  801106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80110d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801111:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801116:	75 06                	jne    80111e <memset+0x20>
		return v;
  801118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111c:	eb 69                	jmp    801187 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	83 e0 03             	and    $0x3,%eax
  801125:	48 85 c0             	test   %rax,%rax
  801128:	75 48                	jne    801172 <memset+0x74>
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112e:	83 e0 03             	and    $0x3,%eax
  801131:	48 85 c0             	test   %rax,%rax
  801134:	75 3c                	jne    801172 <memset+0x74>
		c &= 0xFF;
  801136:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801140:	c1 e0 18             	shl    $0x18,%eax
  801143:	89 c2                	mov    %eax,%edx
  801145:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801148:	c1 e0 10             	shl    $0x10,%eax
  80114b:	09 c2                	or     %eax,%edx
  80114d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801150:	c1 e0 08             	shl    $0x8,%eax
  801153:	09 d0                	or     %edx,%eax
  801155:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	48 c1 e8 02          	shr    $0x2,%rax
  801160:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801163:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801167:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80116a:	48 89 d7             	mov    %rdx,%rdi
  80116d:	fc                   	cld    
  80116e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801170:	eb 11                	jmp    801183 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801172:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801179:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80117d:	48 89 d7             	mov    %rdx,%rdi
  801180:	fc                   	cld    
  801181:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 28          	sub    $0x28,%rsp
  801191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801199:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80119d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011b5:	0f 83 88 00 00 00    	jae    801243 <memmove+0xba>
  8011bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c3:	48 01 d0             	add    %rdx,%rax
  8011c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011ca:	76 77                	jbe    801243 <memmove+0xba>
		s += n;
  8011cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	83 e0 03             	and    $0x3,%eax
  8011e3:	48 85 c0             	test   %rax,%rax
  8011e6:	75 3b                	jne    801223 <memmove+0x9a>
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ec:	83 e0 03             	and    $0x3,%eax
  8011ef:	48 85 c0             	test   %rax,%rax
  8011f2:	75 2f                	jne    801223 <memmove+0x9a>
  8011f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f8:	83 e0 03             	and    $0x3,%eax
  8011fb:	48 85 c0             	test   %rax,%rax
  8011fe:	75 23                	jne    801223 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801204:	48 83 e8 04          	sub    $0x4,%rax
  801208:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80120c:	48 83 ea 04          	sub    $0x4,%rdx
  801210:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801214:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801218:	48 89 c7             	mov    %rax,%rdi
  80121b:	48 89 d6             	mov    %rdx,%rsi
  80121e:	fd                   	std    
  80121f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801221:	eb 1d                	jmp    801240 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801227:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801237:	48 89 d7             	mov    %rdx,%rdi
  80123a:	48 89 c1             	mov    %rax,%rcx
  80123d:	fd                   	std    
  80123e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801240:	fc                   	cld    
  801241:	eb 57                	jmp    80129a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	83 e0 03             	and    $0x3,%eax
  80124a:	48 85 c0             	test   %rax,%rax
  80124d:	75 36                	jne    801285 <memmove+0xfc>
  80124f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801253:	83 e0 03             	and    $0x3,%eax
  801256:	48 85 c0             	test   %rax,%rax
  801259:	75 2a                	jne    801285 <memmove+0xfc>
  80125b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125f:	83 e0 03             	and    $0x3,%eax
  801262:	48 85 c0             	test   %rax,%rax
  801265:	75 1e                	jne    801285 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801267:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126b:	48 c1 e8 02          	shr    $0x2,%rax
  80126f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801276:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127a:	48 89 c7             	mov    %rax,%rdi
  80127d:	48 89 d6             	mov    %rdx,%rsi
  801280:	fc                   	cld    
  801281:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801283:	eb 15                	jmp    80129a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801291:	48 89 c7             	mov    %rax,%rdi
  801294:	48 89 d6             	mov    %rdx,%rsi
  801297:	fc                   	cld    
  801298:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 18          	sub    $0x18,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	48 89 ce             	mov    %rcx,%rsi
  8012c3:	48 89 c7             	mov    %rax,%rdi
  8012c6:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8012cd:	00 00 00 
  8012d0:	ff d0                	callq  *%rax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 28          	sub    $0x28,%rsp
  8012dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012f8:	eb 36                	jmp    801330 <memcmp+0x5c>
		if (*s1 != *s2)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	0f b6 10             	movzbl (%rax),%edx
  801301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	38 c2                	cmp    %al,%dl
  80130a:	74 1a                	je     801326 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801310:	0f b6 00             	movzbl (%rax),%eax
  801313:	0f b6 d0             	movzbl %al,%edx
  801316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	0f b6 c0             	movzbl %al,%eax
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	eb 20                	jmp    801346 <memcmp+0x72>
		s1++, s2++;
  801326:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801334:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801338:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80133c:	48 85 c0             	test   %rax,%rax
  80133f:	75 b9                	jne    8012fa <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801346:	c9                   	leaveq 
  801347:	c3                   	retq   

0000000000801348 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	48 83 ec 28          	sub    $0x28,%rsp
  801350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801354:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801357:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80135b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801363:	48 01 d0             	add    %rdx,%rax
  801366:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80136a:	eb 15                	jmp    801381 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801370:	0f b6 10             	movzbl (%rax),%edx
  801373:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801376:	38 c2                	cmp    %al,%dl
  801378:	75 02                	jne    80137c <memfind+0x34>
			break;
  80137a:	eb 0f                	jmp    80138b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801389:	72 e1                	jb     80136c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138f:	c9                   	leaveq 
  801390:	c3                   	retq   

0000000000801391 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	48 83 ec 34          	sub    $0x34,%rsp
  801399:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80139d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013a1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ab:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013b2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b3:	eb 05                	jmp    8013ba <strtol+0x29>
		s++;
  8013b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	3c 20                	cmp    $0x20,%al
  8013c3:	74 f0                	je     8013b5 <strtol+0x24>
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	3c 09                	cmp    $0x9,%al
  8013ce:	74 e5                	je     8013b5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	3c 2b                	cmp    $0x2b,%al
  8013d9:	75 07                	jne    8013e2 <strtol+0x51>
		s++;
  8013db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e0:	eb 17                	jmp    8013f9 <strtol+0x68>
	else if (*s == '-')
  8013e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	3c 2d                	cmp    $0x2d,%al
  8013eb:	75 0c                	jne    8013f9 <strtol+0x68>
		s++, neg = 1;
  8013ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013fd:	74 06                	je     801405 <strtol+0x74>
  8013ff:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801403:	75 28                	jne    80142d <strtol+0x9c>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3c 30                	cmp    $0x30,%al
  80140e:	75 1d                	jne    80142d <strtol+0x9c>
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 83 c0 01          	add    $0x1,%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0e                	jne    80142d <strtol+0x9c>
		s += 2, base = 16;
  80141f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801424:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80142b:	eb 2c                	jmp    801459 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80142d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801431:	75 19                	jne    80144c <strtol+0xbb>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 30                	cmp    $0x30,%al
  80143c:	75 0e                	jne    80144c <strtol+0xbb>
		s++, base = 8;
  80143e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801443:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80144a:	eb 0d                	jmp    801459 <strtol+0xc8>
	else if (base == 0)
  80144c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801450:	75 07                	jne    801459 <strtol+0xc8>
		base = 10;
  801452:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 2f                	cmp    $0x2f,%al
  801462:	7e 1d                	jle    801481 <strtol+0xf0>
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 39                	cmp    $0x39,%al
  80146d:	7f 12                	jg     801481 <strtol+0xf0>
			dig = *s - '0';
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	0f be c0             	movsbl %al,%eax
  801479:	83 e8 30             	sub    $0x30,%eax
  80147c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80147f:	eb 4e                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 60                	cmp    $0x60,%al
  80148a:	7e 1d                	jle    8014a9 <strtol+0x118>
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 7a                	cmp    $0x7a,%al
  801495:	7f 12                	jg     8014a9 <strtol+0x118>
			dig = *s - 'a' + 10;
  801497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	0f be c0             	movsbl %al,%eax
  8014a1:	83 e8 57             	sub    $0x57,%eax
  8014a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a7:	eb 26                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 40                	cmp    $0x40,%al
  8014b2:	7e 48                	jle    8014fc <strtol+0x16b>
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	3c 5a                	cmp    $0x5a,%al
  8014bd:	7f 3d                	jg     8014fc <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c3:	0f b6 00             	movzbl (%rax),%eax
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	83 e8 37             	sub    $0x37,%eax
  8014cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014d5:	7c 02                	jl     8014d9 <strtol+0x148>
			break;
  8014d7:	eb 23                	jmp    8014fc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014e1:	48 98                	cltq   
  8014e3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014e8:	48 89 c2             	mov    %rax,%rdx
  8014eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ee:	48 98                	cltq   
  8014f0:	48 01 d0             	add    %rdx,%rax
  8014f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014f7:	e9 5d ff ff ff       	jmpq   801459 <strtol+0xc8>

	if (endptr)
  8014fc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801501:	74 0b                	je     80150e <strtol+0x17d>
		*endptr = (char *) s;
  801503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801507:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80150e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801512:	74 09                	je     80151d <strtol+0x18c>
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 f7 d8             	neg    %rax
  80151b:	eb 04                	jmp    801521 <strtol+0x190>
  80151d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801521:	c9                   	leaveq 
  801522:	c3                   	retq   

0000000000801523 <strstr>:

char * strstr(const char *in, const char *str)
{
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	48 83 ec 30          	sub    $0x30,%rsp
  80152b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801537:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801545:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801549:	75 06                	jne    801551 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	eb 6b                	jmp    8015bc <strstr+0x99>

	len = strlen(str);
  801551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801555:	48 89 c7             	mov    %rax,%rdi
  801558:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  80155f:	00 00 00 
  801562:	ff d0                	callq  *%rax
  801564:	48 98                	cltq   
  801566:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801572:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801576:	0f b6 00             	movzbl (%rax),%eax
  801579:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80157c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801580:	75 07                	jne    801589 <strstr+0x66>
				return (char *) 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
  801587:	eb 33                	jmp    8015bc <strstr+0x99>
		} while (sc != c);
  801589:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80158d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801590:	75 d8                	jne    80156a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801592:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801596:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	48 89 ce             	mov    %rcx,%rsi
  8015a1:	48 89 c7             	mov    %rax,%rdi
  8015a4:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  8015ab:	00 00 00 
  8015ae:	ff d0                	callq  *%rax
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	75 b6                	jne    80156a <strstr+0x47>

	return (char *) (in - 1);
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	48 83 e8 01          	sub    $0x1,%rax
}
  8015bc:	c9                   	leaveq 
  8015bd:	c3                   	retq   

00000000008015be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	53                   	push   %rbx
  8015c3:	48 83 ec 48          	sub    $0x48,%rsp
  8015c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015ca:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015d1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015d5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015d9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015e4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015e8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015ec:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015f0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015f4:	4c 89 c3             	mov    %r8,%rbx
  8015f7:	cd 30                	int    $0x30
  8015f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801601:	74 3e                	je     801641 <syscall+0x83>
  801603:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801608:	7e 37                	jle    801641 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80160a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80160e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801611:	49 89 d0             	mov    %rdx,%r8
  801614:	89 c1                	mov    %eax,%ecx
  801616:	48 ba 28 45 80 00 00 	movabs $0x804528,%rdx
  80161d:	00 00 00 
  801620:	be 23 00 00 00       	mov    $0x23,%esi
  801625:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  80162c:	00 00 00 
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	49 b9 99 3c 80 00 00 	movabs $0x803c99,%r9
  80163b:	00 00 00 
  80163e:	41 ff d1             	callq  *%r9

	return ret;
  801641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801645:	48 83 c4 48          	add    $0x48,%rsp
  801649:	5b                   	pop    %rbx
  80164a:	5d                   	pop    %rbp
  80164b:	c3                   	retq   

000000000080164c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80164c:	55                   	push   %rbp
  80164d:	48 89 e5             	mov    %rsp,%rbp
  801650:	48 83 ec 20          	sub    $0x20,%rsp
  801654:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801658:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80165c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801660:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801664:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80166b:	00 
  80166c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801672:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801678:	48 89 d1             	mov    %rdx,%rcx
  80167b:	48 89 c2             	mov    %rax,%rdx
  80167e:	be 00 00 00 00       	mov    $0x0,%esi
  801683:	bf 00 00 00 00       	mov    $0x0,%edi
  801688:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <sys_cgetc>:

int
sys_cgetc(void)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80169e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a5:	00 
  8016a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	be 00 00 00 00       	mov    $0x0,%esi
  8016c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016c6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8016cd:	00 00 00 
  8016d0:	ff d0                	callq  *%rax
}
  8016d2:	c9                   	leaveq 
  8016d3:	c3                   	retq   

00000000008016d4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	48 83 ec 10          	sub    $0x10,%rsp
  8016dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016e2:	48 98                	cltq   
  8016e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016eb:	00 
  8016ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fd:	48 89 c2             	mov    %rax,%rdx
  801700:	be 01 00 00 00       	mov    $0x1,%esi
  801705:	bf 03 00 00 00       	mov    $0x3,%edi
  80170a:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801711:	00 00 00 
  801714:	ff d0                	callq  *%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801720:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801727:	00 
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	b9 00 00 00 00       	mov    $0x0,%ecx
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	bf 02 00 00 00       	mov    $0x2,%edi
  801748:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <sys_yield>:

void
sys_yield(void)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80175e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801765:	00 
  801766:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801772:	b9 00 00 00 00       	mov    $0x0,%ecx
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	be 00 00 00 00       	mov    $0x0,%esi
  801781:	bf 0b 00 00 00       	mov    $0xb,%edi
  801786:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80178d:	00 00 00 
  801790:	ff d0                	callq  *%rax
}
  801792:	c9                   	leaveq 
  801793:	c3                   	retq   

0000000000801794 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801794:	55                   	push   %rbp
  801795:	48 89 e5             	mov    %rsp,%rbp
  801798:	48 83 ec 20          	sub    $0x20,%rsp
  80179c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80179f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017a9:	48 63 c8             	movslq %eax,%rcx
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b3:	48 98                	cltq   
  8017b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bc:	00 
  8017bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c3:	49 89 c8             	mov    %rcx,%r8
  8017c6:	48 89 d1             	mov    %rdx,%rcx
  8017c9:	48 89 c2             	mov    %rax,%rdx
  8017cc:	be 01 00 00 00       	mov    $0x1,%esi
  8017d1:	bf 04 00 00 00       	mov    $0x4,%edi
  8017d6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	callq  *%rax
}
  8017e2:	c9                   	leaveq 
  8017e3:	c3                   	retq   

00000000008017e4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017e4:	55                   	push   %rbp
  8017e5:	48 89 e5             	mov    %rsp,%rbp
  8017e8:	48 83 ec 30          	sub    $0x30,%rsp
  8017ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017f6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017fa:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017fe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801801:	48 63 c8             	movslq %eax,%rcx
  801804:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801808:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80180b:	48 63 f0             	movslq %eax,%rsi
  80180e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801815:	48 98                	cltq   
  801817:	48 89 0c 24          	mov    %rcx,(%rsp)
  80181b:	49 89 f9             	mov    %rdi,%r9
  80181e:	49 89 f0             	mov    %rsi,%r8
  801821:	48 89 d1             	mov    %rdx,%rcx
  801824:	48 89 c2             	mov    %rax,%rdx
  801827:	be 01 00 00 00       	mov    $0x1,%esi
  80182c:	bf 05 00 00 00       	mov    $0x5,%edi
  801831:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801838:	00 00 00 
  80183b:	ff d0                	callq  *%rax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 20          	sub    $0x20,%rsp
  801847:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80184e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801855:	48 98                	cltq   
  801857:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185e:	00 
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	48 89 d1             	mov    %rdx,%rcx
  80186e:	48 89 c2             	mov    %rax,%rdx
  801871:	be 01 00 00 00       	mov    $0x1,%esi
  801876:	bf 06 00 00 00       	mov    $0x6,%edi
  80187b:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 10          	sub    $0x10,%rsp
  801891:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801894:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801897:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80189a:	48 63 d0             	movslq %eax,%rdx
  80189d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a0:	48 98                	cltq   
  8018a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a9:	00 
  8018aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b6:	48 89 d1             	mov    %rdx,%rcx
  8018b9:	48 89 c2             	mov    %rax,%rdx
  8018bc:	be 01 00 00 00       	mov    $0x1,%esi
  8018c1:	bf 08 00 00 00       	mov    $0x8,%edi
  8018c6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8018cd:	00 00 00 
  8018d0:	ff d0                	callq  *%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 20          	sub    $0x20,%rsp
  8018dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	48 98                	cltq   
  8018ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f3:	00 
  8018f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801900:	48 89 d1             	mov    %rdx,%rcx
  801903:	48 89 c2             	mov    %rax,%rdx
  801906:	be 01 00 00 00       	mov    $0x1,%esi
  80190b:	bf 09 00 00 00       	mov    $0x9,%edi
  801910:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801917:	00 00 00 
  80191a:	ff d0                	callq  *%rax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 20          	sub    $0x20,%rsp
  801926:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801929:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80192d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801934:	48 98                	cltq   
  801936:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193d:	00 
  80193e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801944:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194a:	48 89 d1             	mov    %rdx,%rcx
  80194d:	48 89 c2             	mov    %rax,%rdx
  801950:	be 01 00 00 00       	mov    $0x1,%esi
  801955:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195a:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 20          	sub    $0x20,%rsp
  801970:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801973:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801977:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80197b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80197e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801981:	48 63 f0             	movslq %eax,%rsi
  801984:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198b:	48 98                	cltq   
  80198d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801991:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801998:	00 
  801999:	49 89 f1             	mov    %rsi,%r9
  80199c:	49 89 c8             	mov    %rcx,%r8
  80199f:	48 89 d1             	mov    %rdx,%rcx
  8019a2:	48 89 c2             	mov    %rax,%rdx
  8019a5:	be 00 00 00 00       	mov    $0x0,%esi
  8019aa:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019af:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 10          	sub    $0x10,%rsp
  8019c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d4:	00 
  8019d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e6:	48 89 c2             	mov    %rax,%rdx
  8019e9:	be 01 00 00 00       	mov    $0x1,%esi
  8019ee:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019f3:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8019fa:	00 00 00 
  8019fd:	ff d0                	callq  *%rax
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 20          	sub    $0x20,%rsp
  801a09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a20:	00 
  801a21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2d:	48 89 d1             	mov    %rdx,%rcx
  801a30:	48 89 c2             	mov    %rax,%rdx
  801a33:	be 01 00 00 00       	mov    $0x1,%esi
  801a38:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a3d:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801a44:	00 00 00 
  801a47:	ff d0                	callq  *%rax
}
  801a49:	c9                   	leaveq 
  801a4a:	c3                   	retq   

0000000000801a4b <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801a4b:	55                   	push   %rbp
  801a4c:	48 89 e5             	mov    %rsp,%rbp
  801a4f:	48 83 ec 10          	sub    $0x10,%rsp
  801a53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a62:	00 
  801a63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a74:	48 89 c2             	mov    %rax,%rdx
  801a77:	be 00 00 00 00       	mov    $0x0,%esi
  801a7c:	bf 10 00 00 00       	mov    $0x10,%edi
  801a81:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801a88:	00 00 00 
  801a8b:	ff d0                	callq  *%rax
}
  801a8d:	c9                   	leaveq 
  801a8e:	c3                   	retq   

0000000000801a8f <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801a8f:	55                   	push   %rbp
  801a90:	48 89 e5             	mov    %rsp,%rbp
  801a93:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9e:	00 
  801a9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	be 00 00 00 00       	mov    $0x0,%esi
  801aba:	bf 0e 00 00 00       	mov    $0xe,%edi
  801abf:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801ac6:	00 00 00 
  801ac9:	ff d0                	callq  *%rax
}
  801acb:	c9                   	leaveq 
  801acc:	c3                   	retq   

0000000000801acd <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801acd:	55                   	push   %rbp
  801ace:	48 89 e5             	mov    %rsp,%rbp
  801ad1:	48 83 ec 10          	sub    $0x10,%rsp
  801ad5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801ad9:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801ae0:	00 00 00 
  801ae3:	48 8b 00             	mov    (%rax),%rax
  801ae6:	48 85 c0             	test   %rax,%rax
  801ae9:	0f 85 84 00 00 00    	jne    801b73 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801aef:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801af6:	00 00 00 
  801af9:	48 8b 00             	mov    (%rax),%rax
  801afc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b02:	ba 07 00 00 00       	mov    $0x7,%edx
  801b07:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b0c:	89 c7                	mov    %eax,%edi
  801b0e:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  801b15:	00 00 00 
  801b18:	ff d0                	callq  *%rax
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	79 2a                	jns    801b48 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801b1e:	48 ba 58 45 80 00 00 	movabs $0x804558,%rdx
  801b25:	00 00 00 
  801b28:	be 23 00 00 00       	mov    $0x23,%esi
  801b2d:	48 bf 7f 45 80 00 00 	movabs $0x80457f,%rdi
  801b34:	00 00 00 
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3c:	48 b9 99 3c 80 00 00 	movabs $0x803c99,%rcx
  801b43:	00 00 00 
  801b46:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801b48:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801b4f:	00 00 00 
  801b52:	48 8b 00             	mov    (%rax),%rax
  801b55:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b5b:	48 be 86 1b 80 00 00 	movabs $0x801b86,%rsi
  801b62:	00 00 00 
  801b65:	89 c7                	mov    %eax,%edi
  801b67:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801b73:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801b7a:	00 00 00 
  801b7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b81:	48 89 10             	mov    %rdx,(%rax)
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801b86:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801b89:	48 a1 10 70 80 00 00 	movabs 0x807010,%rax
  801b90:	00 00 00 
call *%rax
  801b93:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  801b95:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801b9c:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801b9d:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801ba4:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801ba5:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801ba9:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801bac:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801bb3:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801bb4:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801bb8:	4c 8b 3c 24          	mov    (%rsp),%r15
  801bbc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801bc1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801bc6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801bcb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801bd0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801bd5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801bda:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801bdf:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801be4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801be9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801bee:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801bf3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801bf8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801bfd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801c02:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801c06:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801c0a:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801c0b:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801c0c:	c3                   	retq   

0000000000801c0d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	48 83 ec 08          	sub    $0x8,%rsp
  801c15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c1d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c24:	ff ff ff 
  801c27:	48 01 d0             	add    %rdx,%rax
  801c2a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	48 83 ec 08          	sub    $0x8,%rsp
  801c38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c40:	48 89 c7             	mov    %rax,%rdi
  801c43:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  801c4a:	00 00 00 
  801c4d:	ff d0                	callq  *%rax
  801c4f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c55:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 18          	sub    $0x18,%rsp
  801c63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c6e:	eb 6b                	jmp    801cdb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c73:	48 98                	cltq   
  801c75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801c7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c87:	48 c1 e8 15          	shr    $0x15,%rax
  801c8b:	48 89 c2             	mov    %rax,%rdx
  801c8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c95:	01 00 00 
  801c98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c9c:	83 e0 01             	and    $0x1,%eax
  801c9f:	48 85 c0             	test   %rax,%rax
  801ca2:	74 21                	je     801cc5 <fd_alloc+0x6a>
  801ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca8:	48 c1 e8 0c          	shr    $0xc,%rax
  801cac:	48 89 c2             	mov    %rax,%rdx
  801caf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cb6:	01 00 00 
  801cb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cbd:	83 e0 01             	and    $0x1,%eax
  801cc0:	48 85 c0             	test   %rax,%rax
  801cc3:	75 12                	jne    801cd7 <fd_alloc+0x7c>
			*fd_store = fd;
  801cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ccd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd5:	eb 1a                	jmp    801cf1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cd7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cdb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cdf:	7e 8f                	jle    801c70 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801cf1:	c9                   	leaveq 
  801cf2:	c3                   	retq   

0000000000801cf3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801cf3:	55                   	push   %rbp
  801cf4:	48 89 e5             	mov    %rsp,%rbp
  801cf7:	48 83 ec 20          	sub    $0x20,%rsp
  801cfb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cfe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d06:	78 06                	js     801d0e <fd_lookup+0x1b>
  801d08:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d0c:	7e 07                	jle    801d15 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d13:	eb 6c                	jmp    801d81 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d18:	48 98                	cltq   
  801d1a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d20:	48 c1 e0 0c          	shl    $0xc,%rax
  801d24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2c:	48 c1 e8 15          	shr    $0x15,%rax
  801d30:	48 89 c2             	mov    %rax,%rdx
  801d33:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d3a:	01 00 00 
  801d3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d41:	83 e0 01             	and    $0x1,%eax
  801d44:	48 85 c0             	test   %rax,%rax
  801d47:	74 21                	je     801d6a <fd_lookup+0x77>
  801d49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4d:	48 c1 e8 0c          	shr    $0xc,%rax
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5b:	01 00 00 
  801d5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d62:	83 e0 01             	and    $0x1,%eax
  801d65:	48 85 c0             	test   %rax,%rax
  801d68:	75 07                	jne    801d71 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d6f:	eb 10                	jmp    801d81 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d79:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	c9                   	leaveq 
  801d82:	c3                   	retq   

0000000000801d83 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	48 83 ec 30          	sub    $0x30,%rsp
  801d8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d8f:	89 f0                	mov    %esi,%eax
  801d91:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d98:	48 89 c7             	mov    %rax,%rdi
  801d9b:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
  801da7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dab:	48 89 d6             	mov    %rdx,%rsi
  801dae:	89 c7                	mov    %eax,%edi
  801db0:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dc3:	78 0a                	js     801dcf <fd_close+0x4c>
	    || fd != fd2)
  801dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dcd:	74 12                	je     801de1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dcf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801dd3:	74 05                	je     801dda <fd_close+0x57>
  801dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd8:	eb 05                	jmp    801ddf <fd_close+0x5c>
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	eb 69                	jmp    801e4a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de5:	8b 00                	mov    (%rax),%eax
  801de7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801deb:	48 89 d6             	mov    %rdx,%rsi
  801dee:	89 c7                	mov    %eax,%edi
  801df0:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801df7:	00 00 00 
  801dfa:	ff d0                	callq  *%rax
  801dfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e03:	78 2a                	js     801e2f <fd_close+0xac>
		if (dev->dev_close)
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e0d:	48 85 c0             	test   %rax,%rax
  801e10:	74 16                	je     801e28 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e16:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e1a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e1e:	48 89 d7             	mov    %rdx,%rdi
  801e21:	ff d0                	callq  *%rax
  801e23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e26:	eb 07                	jmp    801e2f <fd_close+0xac>
		else
			r = 0;
  801e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e33:	48 89 c6             	mov    %rax,%rsi
  801e36:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3b:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801e42:	00 00 00 
  801e45:	ff d0                	callq  *%rax
	return r;
  801e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 20          	sub    $0x20,%rsp
  801e54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e57:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e62:	eb 41                	jmp    801ea5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e64:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e6b:	00 00 00 
  801e6e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e71:	48 63 d2             	movslq %edx,%rdx
  801e74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e78:	8b 00                	mov    (%rax),%eax
  801e7a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e7d:	75 22                	jne    801ea1 <dev_lookup+0x55>
			*dev = devtab[i];
  801e7f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e86:	00 00 00 
  801e89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e8c:	48 63 d2             	movslq %edx,%rdx
  801e8f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e97:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	eb 60                	jmp    801f01 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ea1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ea5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801eac:	00 00 00 
  801eaf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eb2:	48 63 d2             	movslq %edx,%rdx
  801eb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb9:	48 85 c0             	test   %rax,%rax
  801ebc:	75 a6                	jne    801e64 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ebe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ec5:	00 00 00 
  801ec8:	48 8b 00             	mov    (%rax),%rax
  801ecb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ed1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ed4:	89 c6                	mov    %eax,%esi
  801ed6:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  801edd:	00 00 00 
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee5:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  801eec:	00 00 00 
  801eef:	ff d1                	callq  *%rcx
	*dev = 0;
  801ef1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801efc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f01:	c9                   	leaveq 
  801f02:	c3                   	retq   

0000000000801f03 <close>:

int
close(int fdnum)
{
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 20          	sub    $0x20,%rsp
  801f0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f0e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f15:	48 89 d6             	mov    %rdx,%rsi
  801f18:	89 c7                	mov    %eax,%edi
  801f1a:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
  801f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f2d:	79 05                	jns    801f34 <close+0x31>
		return r;
  801f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f32:	eb 18                	jmp    801f4c <close+0x49>
	else
		return fd_close(fd, 1);
  801f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f38:	be 01 00 00 00       	mov    $0x1,%esi
  801f3d:	48 89 c7             	mov    %rax,%rdi
  801f40:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	callq  *%rax
}
  801f4c:	c9                   	leaveq 
  801f4d:	c3                   	retq   

0000000000801f4e <close_all>:

void
close_all(void)
{
  801f4e:	55                   	push   %rbp
  801f4f:	48 89 e5             	mov    %rsp,%rbp
  801f52:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f5d:	eb 15                	jmp    801f74 <close_all+0x26>
		close(i);
  801f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f62:	89 c7                	mov    %eax,%edi
  801f64:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f70:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f74:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f78:	7e e5                	jle    801f5f <close_all+0x11>
		close(i);
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	48 83 ec 40          	sub    $0x40,%rsp
  801f84:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f87:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f8a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f8e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f91:	48 89 d6             	mov    %rdx,%rsi
  801f94:	89 c7                	mov    %eax,%edi
  801f96:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
  801fa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa9:	79 08                	jns    801fb3 <dup+0x37>
		return r;
  801fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fae:	e9 70 01 00 00       	jmpq   802123 <dup+0x1a7>
	close(newfdnum);
  801fb3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fb6:	89 c7                	mov    %eax,%edi
  801fb8:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fc4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fc7:	48 98                	cltq   
  801fc9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fcf:	48 c1 e0 0c          	shl    $0xc,%rax
  801fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdb:	48 89 c7             	mov    %rax,%rdi
  801fde:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	callq  *%rax
  801fea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ff2:	48 89 c7             	mov    %rax,%rdi
  801ff5:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  801ffc:	00 00 00 
  801fff:	ff d0                	callq  *%rax
  802001:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802009:	48 c1 e8 15          	shr    $0x15,%rax
  80200d:	48 89 c2             	mov    %rax,%rdx
  802010:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802017:	01 00 00 
  80201a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201e:	83 e0 01             	and    $0x1,%eax
  802021:	48 85 c0             	test   %rax,%rax
  802024:	74 73                	je     802099 <dup+0x11d>
  802026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202a:	48 c1 e8 0c          	shr    $0xc,%rax
  80202e:	48 89 c2             	mov    %rax,%rdx
  802031:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802038:	01 00 00 
  80203b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203f:	83 e0 01             	and    $0x1,%eax
  802042:	48 85 c0             	test   %rax,%rax
  802045:	74 52                	je     802099 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204b:	48 c1 e8 0c          	shr    $0xc,%rax
  80204f:	48 89 c2             	mov    %rax,%rdx
  802052:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802059:	01 00 00 
  80205c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802060:	25 07 0e 00 00       	and    $0xe07,%eax
  802065:	89 c1                	mov    %eax,%ecx
  802067:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	41 89 c8             	mov    %ecx,%r8d
  802072:	48 89 d1             	mov    %rdx,%rcx
  802075:	ba 00 00 00 00       	mov    $0x0,%edx
  80207a:	48 89 c6             	mov    %rax,%rsi
  80207d:	bf 00 00 00 00       	mov    $0x0,%edi
  802082:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802091:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802095:	79 02                	jns    802099 <dup+0x11d>
			goto err;
  802097:	eb 57                	jmp    8020f0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802099:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209d:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a1:	48 89 c2             	mov    %rax,%rdx
  8020a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ab:	01 00 00 
  8020ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8020b7:	89 c1                	mov    %eax,%ecx
  8020b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c1:	41 89 c8             	mov    %ecx,%r8d
  8020c4:	48 89 d1             	mov    %rdx,%rcx
  8020c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020cc:	48 89 c6             	mov    %rax,%rsi
  8020cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d4:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	callq  *%rax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e7:	79 02                	jns    8020eb <dup+0x16f>
		goto err;
  8020e9:	eb 05                	jmp    8020f0 <dup+0x174>

	return newfdnum;
  8020eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ee:	eb 33                	jmp    802123 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8020f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f4:	48 89 c6             	mov    %rax,%rsi
  8020f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fc:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802103:	00 00 00 
  802106:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802108:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80210c:	48 89 c6             	mov    %rax,%rsi
  80210f:	bf 00 00 00 00       	mov    $0x0,%edi
  802114:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	callq  *%rax
	return r;
  802120:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	48 83 ec 40          	sub    $0x40,%rsp
  80212d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802130:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802134:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802138:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80213c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80213f:	48 89 d6             	mov    %rdx,%rsi
  802142:	89 c7                	mov    %eax,%edi
  802144:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
  802150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802157:	78 24                	js     80217d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215d:	8b 00                	mov    (%rax),%eax
  80215f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802163:	48 89 d6             	mov    %rdx,%rsi
  802166:	89 c7                	mov    %eax,%edi
  802168:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80216f:	00 00 00 
  802172:	ff d0                	callq  *%rax
  802174:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802177:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217b:	79 05                	jns    802182 <read+0x5d>
		return r;
  80217d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802180:	eb 76                	jmp    8021f8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802186:	8b 40 08             	mov    0x8(%rax),%eax
  802189:	83 e0 03             	and    $0x3,%eax
  80218c:	83 f8 01             	cmp    $0x1,%eax
  80218f:	75 3a                	jne    8021cb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802191:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802198:	00 00 00 
  80219b:	48 8b 00             	mov    (%rax),%rax
  80219e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021a7:	89 c6                	mov    %eax,%esi
  8021a9:	48 bf af 45 80 00 00 	movabs $0x8045af,%rdi
  8021b0:	00 00 00 
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  8021bf:	00 00 00 
  8021c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021c9:	eb 2d                	jmp    8021f8 <read+0xd3>
	}
	if (!dev->dev_read)
  8021cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021d3:	48 85 c0             	test   %rax,%rax
  8021d6:	75 07                	jne    8021df <read+0xba>
		return -E_NOT_SUPP;
  8021d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021dd:	eb 19                	jmp    8021f8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021ef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021f3:	48 89 cf             	mov    %rcx,%rdi
  8021f6:	ff d0                	callq  *%rax
}
  8021f8:	c9                   	leaveq 
  8021f9:	c3                   	retq   

00000000008021fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021fa:	55                   	push   %rbp
  8021fb:	48 89 e5             	mov    %rsp,%rbp
  8021fe:	48 83 ec 30          	sub    $0x30,%rsp
  802202:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802205:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802209:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80220d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802214:	eb 49                	jmp    80225f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802219:	48 98                	cltq   
  80221b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80221f:	48 29 c2             	sub    %rax,%rdx
  802222:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802225:	48 63 c8             	movslq %eax,%rcx
  802228:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80222c:	48 01 c1             	add    %rax,%rcx
  80222f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802232:	48 89 ce             	mov    %rcx,%rsi
  802235:	89 c7                	mov    %eax,%edi
  802237:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
  802243:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802246:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80224a:	79 05                	jns    802251 <readn+0x57>
			return m;
  80224c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80224f:	eb 1c                	jmp    80226d <readn+0x73>
		if (m == 0)
  802251:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802255:	75 02                	jne    802259 <readn+0x5f>
			break;
  802257:	eb 11                	jmp    80226a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802259:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80225c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80225f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802262:	48 98                	cltq   
  802264:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802268:	72 ac                	jb     802216 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80226a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
  802273:	48 83 ec 40          	sub    $0x40,%rsp
  802277:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80227e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802282:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802286:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802289:	48 89 d6             	mov    %rdx,%rsi
  80228c:	89 c7                	mov    %eax,%edi
  80228e:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a1:	78 24                	js     8022c7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a7:	8b 00                	mov    (%rax),%eax
  8022a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ad:	48 89 d6             	mov    %rdx,%rsi
  8022b0:	89 c7                	mov    %eax,%edi
  8022b2:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax
  8022be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c5:	79 05                	jns    8022cc <write+0x5d>
		return r;
  8022c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ca:	eb 75                	jmp    802341 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d0:	8b 40 08             	mov    0x8(%rax),%eax
  8022d3:	83 e0 03             	and    $0x3,%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	75 3a                	jne    802314 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022e1:	00 00 00 
  8022e4:	48 8b 00             	mov    (%rax),%rax
  8022e7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022f0:	89 c6                	mov    %eax,%esi
  8022f2:	48 bf cb 45 80 00 00 	movabs $0x8045cb,%rdi
  8022f9:	00 00 00 
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802301:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  802308:	00 00 00 
  80230b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80230d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802312:	eb 2d                	jmp    802341 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802318:	48 8b 40 18          	mov    0x18(%rax),%rax
  80231c:	48 85 c0             	test   %rax,%rax
  80231f:	75 07                	jne    802328 <write+0xb9>
		return -E_NOT_SUPP;
  802321:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802326:	eb 19                	jmp    802341 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802330:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802334:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802338:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80233c:	48 89 cf             	mov    %rcx,%rdi
  80233f:	ff d0                	callq  *%rax
}
  802341:	c9                   	leaveq 
  802342:	c3                   	retq   

0000000000802343 <seek>:

int
seek(int fdnum, off_t offset)
{
  802343:	55                   	push   %rbp
  802344:	48 89 e5             	mov    %rsp,%rbp
  802347:	48 83 ec 18          	sub    $0x18,%rsp
  80234b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80234e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802351:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802355:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802358:	48 89 d6             	mov    %rdx,%rsi
  80235b:	89 c7                	mov    %eax,%edi
  80235d:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  802364:	00 00 00 
  802367:	ff d0                	callq  *%rax
  802369:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802370:	79 05                	jns    802377 <seek+0x34>
		return r;
  802372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802375:	eb 0f                	jmp    802386 <seek+0x43>
	fd->fd_offset = offset;
  802377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80237e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802386:	c9                   	leaveq 
  802387:	c3                   	retq   

0000000000802388 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802388:	55                   	push   %rbp
  802389:	48 89 e5             	mov    %rsp,%rbp
  80238c:	48 83 ec 30          	sub    $0x30,%rsp
  802390:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802393:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802396:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80239d:	48 89 d6             	mov    %rdx,%rsi
  8023a0:	89 c7                	mov    %eax,%edi
  8023a2:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  8023a9:	00 00 00 
  8023ac:	ff d0                	callq  *%rax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b5:	78 24                	js     8023db <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	8b 00                	mov    (%rax),%eax
  8023bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c1:	48 89 d6             	mov    %rdx,%rsi
  8023c4:	89 c7                	mov    %eax,%edi
  8023c6:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8023cd:	00 00 00 
  8023d0:	ff d0                	callq  *%rax
  8023d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d9:	79 05                	jns    8023e0 <ftruncate+0x58>
		return r;
  8023db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023de:	eb 72                	jmp    802452 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e4:	8b 40 08             	mov    0x8(%rax),%eax
  8023e7:	83 e0 03             	and    $0x3,%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	75 3a                	jne    802428 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023ee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023f5:	00 00 00 
  8023f8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802401:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802404:	89 c6                	mov    %eax,%esi
  802406:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  80240d:	00 00 00 
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  80241c:	00 00 00 
  80241f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802421:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802426:	eb 2a                	jmp    802452 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802430:	48 85 c0             	test   %rax,%rax
  802433:	75 07                	jne    80243c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802435:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80243a:	eb 16                	jmp    802452 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80243c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802440:	48 8b 40 30          	mov    0x30(%rax),%rax
  802444:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802448:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80244b:	89 ce                	mov    %ecx,%esi
  80244d:	48 89 d7             	mov    %rdx,%rdi
  802450:	ff d0                	callq  *%rax
}
  802452:	c9                   	leaveq 
  802453:	c3                   	retq   

0000000000802454 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802454:	55                   	push   %rbp
  802455:	48 89 e5             	mov    %rsp,%rbp
  802458:	48 83 ec 30          	sub    $0x30,%rsp
  80245c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80245f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802463:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802467:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80246a:	48 89 d6             	mov    %rdx,%rsi
  80246d:	89 c7                	mov    %eax,%edi
  80246f:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
  80247b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802482:	78 24                	js     8024a8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802488:	8b 00                	mov    (%rax),%eax
  80248a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248e:	48 89 d6             	mov    %rdx,%rsi
  802491:	89 c7                	mov    %eax,%edi
  802493:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80249a:	00 00 00 
  80249d:	ff d0                	callq  *%rax
  80249f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a6:	79 05                	jns    8024ad <fstat+0x59>
		return r;
  8024a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ab:	eb 5e                	jmp    80250b <fstat+0xb7>
	if (!dev->dev_stat)
  8024ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024b5:	48 85 c0             	test   %rax,%rax
  8024b8:	75 07                	jne    8024c1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024bf:	eb 4a                	jmp    80250b <fstat+0xb7>
	stat->st_name[0] = 0;
  8024c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024c5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024cc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024d3:	00 00 00 
	stat->st_isdir = 0;
  8024d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024da:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024e1:	00 00 00 
	stat->st_dev = dev;
  8024e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ec:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ff:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802503:	48 89 ce             	mov    %rcx,%rsi
  802506:	48 89 d7             	mov    %rdx,%rdi
  802509:	ff d0                	callq  *%rax
}
  80250b:	c9                   	leaveq 
  80250c:	c3                   	retq   

000000000080250d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80250d:	55                   	push   %rbp
  80250e:	48 89 e5             	mov    %rsp,%rbp
  802511:	48 83 ec 20          	sub    $0x20,%rsp
  802515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802519:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80251d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802521:	be 00 00 00 00       	mov    $0x0,%esi
  802526:	48 89 c7             	mov    %rax,%rdi
  802529:	48 b8 fb 25 80 00 00 	movabs $0x8025fb,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	79 05                	jns    802543 <stat+0x36>
		return fd;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802541:	eb 2f                	jmp    802572 <stat+0x65>
	r = fstat(fd, stat);
  802543:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254a:	48 89 d6             	mov    %rdx,%rsi
  80254d:	89 c7                	mov    %eax,%edi
  80254f:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  802556:	00 00 00 
  802559:	ff d0                	callq  *%rax
  80255b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80255e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802561:	89 c7                	mov    %eax,%edi
  802563:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax
	return r;
  80256f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802572:	c9                   	leaveq 
  802573:	c3                   	retq   

0000000000802574 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802574:	55                   	push   %rbp
  802575:	48 89 e5             	mov    %rsp,%rbp
  802578:	48 83 ec 10          	sub    $0x10,%rsp
  80257c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80257f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802583:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80258a:	00 00 00 
  80258d:	8b 00                	mov    (%rax),%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	75 1d                	jne    8025b0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802593:	bf 01 00 00 00       	mov    $0x1,%edi
  802598:	48 b8 15 3f 80 00 00 	movabs $0x803f15,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025ab:	00 00 00 
  8025ae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025b0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025b7:	00 00 00 
  8025ba:	8b 00                	mov    (%rax),%eax
  8025bc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025bf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025c4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8025cb:	00 00 00 
  8025ce:	89 c7                	mov    %eax,%edi
  8025d0:	48 b8 b3 3e 80 00 00 	movabs $0x803eb3,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e5:	48 89 c6             	mov    %rax,%rsi
  8025e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ed:	48 b8 ad 3d 80 00 00 	movabs $0x803dad,%rax
  8025f4:	00 00 00 
  8025f7:	ff d0                	callq  *%rax
}
  8025f9:	c9                   	leaveq 
  8025fa:	c3                   	retq   

00000000008025fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025fb:	55                   	push   %rbp
  8025fc:	48 89 e5             	mov    %rsp,%rbp
  8025ff:	48 83 ec 30          	sub    $0x30,%rsp
  802603:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802607:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80260a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802611:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80261f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802624:	75 08                	jne    80262e <open+0x33>
	{
		return r;
  802626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802629:	e9 f2 00 00 00       	jmpq   802720 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80262e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802632:	48 89 c7             	mov    %rax,%rdi
  802635:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
  802641:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802644:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80264b:	7e 0a                	jle    802657 <open+0x5c>
	{
		return -E_BAD_PATH;
  80264d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802652:	e9 c9 00 00 00       	jmpq   802720 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802657:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80265e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80265f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802663:	48 89 c7             	mov    %rax,%rdi
  802666:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
  802672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802679:	78 09                	js     802684 <open+0x89>
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	48 85 c0             	test   %rax,%rax
  802682:	75 08                	jne    80268c <open+0x91>
		{
			return r;
  802684:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802687:	e9 94 00 00 00       	jmpq   802720 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80268c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802690:	ba 00 04 00 00       	mov    $0x400,%edx
  802695:	48 89 c6             	mov    %rax,%rsi
  802698:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80269f:	00 00 00 
  8026a2:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8026ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026b5:	00 00 00 
  8026b8:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8026bb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8026c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c5:	48 89 c6             	mov    %rax,%rsi
  8026c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8026cd:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
  8026d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e0:	79 2b                	jns    80270d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8026e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e6:	be 00 00 00 00       	mov    $0x0,%esi
  8026eb:	48 89 c7             	mov    %rax,%rdi
  8026ee:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
  8026fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802701:	79 05                	jns    802708 <open+0x10d>
			{
				return d;
  802703:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802706:	eb 18                	jmp    802720 <open+0x125>
			}
			return r;
  802708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270b:	eb 13                	jmp    802720 <open+0x125>
		}	
		return fd2num(fd_store);
  80270d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802711:	48 89 c7             	mov    %rax,%rdi
  802714:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802720:	c9                   	leaveq 
  802721:	c3                   	retq   

0000000000802722 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802722:	55                   	push   %rbp
  802723:	48 89 e5             	mov    %rsp,%rbp
  802726:	48 83 ec 10          	sub    $0x10,%rsp
  80272a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80272e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802732:	8b 50 0c             	mov    0xc(%rax),%edx
  802735:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80273c:	00 00 00 
  80273f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802741:	be 00 00 00 00       	mov    $0x0,%esi
  802746:	bf 06 00 00 00       	mov    $0x6,%edi
  80274b:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  802752:	00 00 00 
  802755:	ff d0                	callq  *%rax
}
  802757:	c9                   	leaveq 
  802758:	c3                   	retq   

0000000000802759 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802759:	55                   	push   %rbp
  80275a:	48 89 e5             	mov    %rsp,%rbp
  80275d:	48 83 ec 30          	sub    $0x30,%rsp
  802761:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802765:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802769:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80276d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802774:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802779:	74 07                	je     802782 <devfile_read+0x29>
  80277b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802780:	75 07                	jne    802789 <devfile_read+0x30>
		return -E_INVAL;
  802782:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802787:	eb 77                	jmp    802800 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278d:	8b 50 0c             	mov    0xc(%rax),%edx
  802790:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802797:	00 00 00 
  80279a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80279c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027a3:	00 00 00 
  8027a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027aa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8027ae:	be 00 00 00 00       	mov    $0x0,%esi
  8027b3:	bf 03 00 00 00       	mov    $0x3,%edi
  8027b8:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cb:	7f 05                	jg     8027d2 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8027cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d0:	eb 2e                	jmp    802800 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8027d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d5:	48 63 d0             	movslq %eax,%rdx
  8027d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027dc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027e3:	00 00 00 
  8027e6:	48 89 c7             	mov    %rax,%rdi
  8027e9:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8027f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802800:	c9                   	leaveq 
  802801:	c3                   	retq   

0000000000802802 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802802:	55                   	push   %rbp
  802803:	48 89 e5             	mov    %rsp,%rbp
  802806:	48 83 ec 30          	sub    $0x30,%rsp
  80280a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802812:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802816:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80281d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802822:	74 07                	je     80282b <devfile_write+0x29>
  802824:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802829:	75 08                	jne    802833 <devfile_write+0x31>
		return r;
  80282b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282e:	e9 9a 00 00 00       	jmpq   8028cd <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802837:	8b 50 0c             	mov    0xc(%rax),%edx
  80283a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802841:	00 00 00 
  802844:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802846:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80284d:	00 
  80284e:	76 08                	jbe    802858 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802850:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802857:	00 
	}
	fsipcbuf.write.req_n = n;
  802858:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285f:	00 00 00 
  802862:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802866:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80286a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80286e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802872:	48 89 c6             	mov    %rax,%rsi
  802875:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80287c:	00 00 00 
  80287f:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80288b:	be 00 00 00 00       	mov    $0x0,%esi
  802890:	bf 04 00 00 00       	mov    $0x4,%edi
  802895:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
  8028a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a8:	7f 20                	jg     8028ca <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8028aa:	48 bf 0e 46 80 00 00 	movabs $0x80460e,%rdi
  8028b1:	00 00 00 
  8028b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b9:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  8028c0:	00 00 00 
  8028c3:	ff d2                	callq  *%rdx
		return r;
  8028c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c8:	eb 03                	jmp    8028cd <devfile_write+0xcb>
	}
	return r;
  8028ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8028cd:	c9                   	leaveq 
  8028ce:	c3                   	retq   

00000000008028cf <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028cf:	55                   	push   %rbp
  8028d0:	48 89 e5             	mov    %rsp,%rbp
  8028d3:	48 83 ec 20          	sub    $0x20,%rsp
  8028d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028ed:	00 00 00 
  8028f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028f2:	be 00 00 00 00       	mov    $0x0,%esi
  8028f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8028fc:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
  802908:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290f:	79 05                	jns    802916 <devfile_stat+0x47>
		return r;
  802911:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802914:	eb 56                	jmp    80296c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802916:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80291a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802921:	00 00 00 
  802924:	48 89 c7             	mov    %rax,%rdi
  802927:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802933:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80293a:	00 00 00 
  80293d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802943:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802947:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80294d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802954:	00 00 00 
  802957:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80295d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802961:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296c:	c9                   	leaveq 
  80296d:	c3                   	retq   

000000000080296e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80296e:	55                   	push   %rbp
  80296f:	48 89 e5             	mov    %rsp,%rbp
  802972:	48 83 ec 10          	sub    $0x10,%rsp
  802976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80297a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80297d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802981:	8b 50 0c             	mov    0xc(%rax),%edx
  802984:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80298b:	00 00 00 
  80298e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802990:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802997:	00 00 00 
  80299a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80299d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029a0:	be 00 00 00 00       	mov    $0x0,%esi
  8029a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8029aa:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
}
  8029b6:	c9                   	leaveq 
  8029b7:	c3                   	retq   

00000000008029b8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 10          	sub    $0x10,%rsp
  8029c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c8:	48 89 c7             	mov    %rax,%rdi
  8029cb:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  8029d2:	00 00 00 
  8029d5:	ff d0                	callq  *%rax
  8029d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029dc:	7e 07                	jle    8029e5 <remove+0x2d>
		return -E_BAD_PATH;
  8029de:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029e3:	eb 33                	jmp    802a18 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e9:	48 89 c6             	mov    %rax,%rsi
  8029ec:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029f3:	00 00 00 
  8029f6:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a02:	be 00 00 00 00       	mov    $0x0,%esi
  802a07:	bf 07 00 00 00       	mov    $0x7,%edi
  802a0c:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
}
  802a18:	c9                   	leaveq 
  802a19:	c3                   	retq   

0000000000802a1a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a1a:	55                   	push   %rbp
  802a1b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a1e:	be 00 00 00 00       	mov    $0x0,%esi
  802a23:	bf 08 00 00 00       	mov    $0x8,%edi
  802a28:	48 b8 74 25 80 00 00 	movabs $0x802574,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
}
  802a34:	5d                   	pop    %rbp
  802a35:	c3                   	retq   

0000000000802a36 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a41:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a48:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a4f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a56:	be 00 00 00 00       	mov    $0x0,%esi
  802a5b:	48 89 c7             	mov    %rax,%rdi
  802a5e:	48 b8 fb 25 80 00 00 	movabs $0x8025fb,%rax
  802a65:	00 00 00 
  802a68:	ff d0                	callq  *%rax
  802a6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a71:	79 28                	jns    802a9b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a76:	89 c6                	mov    %eax,%esi
  802a78:	48 bf 2a 46 80 00 00 	movabs $0x80462a,%rdi
  802a7f:	00 00 00 
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
  802a87:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  802a8e:	00 00 00 
  802a91:	ff d2                	callq  *%rdx
		return fd_src;
  802a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a96:	e9 74 01 00 00       	jmpq   802c0f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a9b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802aa2:	be 01 01 00 00       	mov    $0x101,%esi
  802aa7:	48 89 c7             	mov    %rax,%rdi
  802aaa:	48 b8 fb 25 80 00 00 	movabs $0x8025fb,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
  802ab6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ab9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802abd:	79 39                	jns    802af8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802abf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ac2:	89 c6                	mov    %eax,%esi
  802ac4:	48 bf 40 46 80 00 00 	movabs $0x804640,%rdi
  802acb:	00 00 00 
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad3:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  802ada:	00 00 00 
  802add:	ff d2                	callq  *%rdx
		close(fd_src);
  802adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae2:	89 c7                	mov    %eax,%edi
  802ae4:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
		return fd_dest;
  802af0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af3:	e9 17 01 00 00       	jmpq   802c0f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802af8:	eb 74                	jmp    802b6e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802afa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802afd:	48 63 d0             	movslq %eax,%rdx
  802b00:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b0a:	48 89 ce             	mov    %rcx,%rsi
  802b0d:	89 c7                	mov    %eax,%edi
  802b0f:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b22:	79 4a                	jns    802b6e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b24:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b27:	89 c6                	mov    %eax,%esi
  802b29:	48 bf 5a 46 80 00 00 	movabs $0x80465a,%rdi
  802b30:	00 00 00 
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  802b3f:	00 00 00 
  802b42:	ff d2                	callq  *%rdx
			close(fd_src);
  802b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
			close(fd_dest);
  802b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b58:	89 c7                	mov    %eax,%edi
  802b5a:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
			return write_size;
  802b66:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b69:	e9 a1 00 00 00       	jmpq   802c0f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b6e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b78:	ba 00 02 00 00       	mov    $0x200,%edx
  802b7d:	48 89 ce             	mov    %rcx,%rsi
  802b80:	89 c7                	mov    %eax,%edi
  802b82:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b95:	0f 8f 5f ff ff ff    	jg     802afa <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b9f:	79 47                	jns    802be8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802ba1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ba4:	89 c6                	mov    %eax,%esi
  802ba6:	48 bf 6d 46 80 00 00 	movabs $0x80466d,%rdi
  802bad:	00 00 00 
  802bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb5:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  802bbc:	00 00 00 
  802bbf:	ff d2                	callq  *%rdx
		close(fd_src);
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	89 c7                	mov    %eax,%edi
  802bc6:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
		close(fd_dest);
  802bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
		return read_size;
  802be3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802be6:	eb 27                	jmp    802c0f <copy+0x1d9>
	}
	close(fd_src);
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	89 c7                	mov    %eax,%edi
  802bed:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
	close(fd_dest);
  802bf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
	return 0;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c0f:	c9                   	leaveq 
  802c10:	c3                   	retq   

0000000000802c11 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802c11:	55                   	push   %rbp
  802c12:	48 89 e5             	mov    %rsp,%rbp
  802c15:	48 83 ec 20          	sub    $0x20,%rsp
  802c19:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802c1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c23:	48 89 d6             	mov    %rdx,%rsi
  802c26:	89 c7                	mov    %eax,%edi
  802c28:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
  802c34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3b:	79 05                	jns    802c42 <fd2sockid+0x31>
		return r;
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	eb 24                	jmp    802c66 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c46:	8b 10                	mov    (%rax),%edx
  802c48:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802c4f:	00 00 00 
  802c52:	8b 00                	mov    (%rax),%eax
  802c54:	39 c2                	cmp    %eax,%edx
  802c56:	74 07                	je     802c5f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802c58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c5d:	eb 07                	jmp    802c66 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c63:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802c66:	c9                   	leaveq 
  802c67:	c3                   	retq   

0000000000802c68 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802c68:	55                   	push   %rbp
  802c69:	48 89 e5             	mov    %rsp,%rbp
  802c6c:	48 83 ec 20          	sub    $0x20,%rsp
  802c70:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802c73:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c77:	48 89 c7             	mov    %rax,%rdi
  802c7a:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
  802c86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8d:	78 26                	js     802cb5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c93:	ba 07 04 00 00       	mov    $0x407,%edx
  802c98:	48 89 c6             	mov    %rax,%rsi
  802c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca0:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
  802cac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb3:	79 16                	jns    802ccb <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802cb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb8:	89 c7                	mov    %eax,%edi
  802cba:	48 b8 75 31 80 00 00 	movabs $0x803175,%rax
  802cc1:	00 00 00 
  802cc4:	ff d0                	callq  *%rax
		return r;
  802cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc9:	eb 3a                	jmp    802d05 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccf:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802cd6:	00 00 00 
  802cd9:	8b 12                	mov    (%rdx),%edx
  802cdb:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802cef:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf6:	48 89 c7             	mov    %rax,%rdi
  802cf9:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
}
  802d05:	c9                   	leaveq 
  802d06:	c3                   	retq   

0000000000802d07 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	48 83 ec 30          	sub    $0x30,%rsp
  802d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d32:	79 05                	jns    802d39 <accept+0x32>
		return r;
  802d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d37:	eb 3b                	jmp    802d74 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802d39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d3d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d44:	48 89 ce             	mov    %rcx,%rsi
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	48 b8 52 30 80 00 00 	movabs $0x803052,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
  802d55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5c:	79 05                	jns    802d63 <accept+0x5c>
		return r;
  802d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d61:	eb 11                	jmp    802d74 <accept+0x6d>
	return alloc_sockfd(r);
  802d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d66:	89 c7                	mov    %eax,%edi
  802d68:	48 b8 68 2c 80 00 00 	movabs $0x802c68,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax
}
  802d74:	c9                   	leaveq 
  802d75:	c3                   	retq   

0000000000802d76 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d76:	55                   	push   %rbp
  802d77:	48 89 e5             	mov    %rsp,%rbp
  802d7a:	48 83 ec 20          	sub    $0x20,%rsp
  802d7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d85:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8b:	89 c7                	mov    %eax,%edi
  802d8d:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da0:	79 05                	jns    802da7 <bind+0x31>
		return r;
  802da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da5:	eb 1b                	jmp    802dc2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802da7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802daa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db1:	48 89 ce             	mov    %rcx,%rsi
  802db4:	89 c7                	mov    %eax,%edi
  802db6:	48 b8 d1 30 80 00 00 	movabs $0x8030d1,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
}
  802dc2:	c9                   	leaveq 
  802dc3:	c3                   	retq   

0000000000802dc4 <shutdown>:

int
shutdown(int s, int how)
{
  802dc4:	55                   	push   %rbp
  802dc5:	48 89 e5             	mov    %rsp,%rbp
  802dc8:	48 83 ec 20          	sub    $0x20,%rsp
  802dcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dcf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd5:	89 c7                	mov    %eax,%edi
  802dd7:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802dde:	00 00 00 
  802de1:	ff d0                	callq  *%rax
  802de3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dea:	79 05                	jns    802df1 <shutdown+0x2d>
		return r;
  802dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802def:	eb 16                	jmp    802e07 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802df1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df7:	89 d6                	mov    %edx,%esi
  802df9:	89 c7                	mov    %eax,%edi
  802dfb:	48 b8 35 31 80 00 00 	movabs $0x803135,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	callq  *%rax
}
  802e07:	c9                   	leaveq 
  802e08:	c3                   	retq   

0000000000802e09 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802e09:	55                   	push   %rbp
  802e0a:	48 89 e5             	mov    %rsp,%rbp
  802e0d:	48 83 ec 10          	sub    $0x10,%rsp
  802e11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e19:	48 89 c7             	mov    %rax,%rdi
  802e1c:	48 b8 97 3f 80 00 00 	movabs $0x803f97,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	83 f8 01             	cmp    $0x1,%eax
  802e2b:	75 17                	jne    802e44 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e31:	8b 40 0c             	mov    0xc(%rax),%eax
  802e34:	89 c7                	mov    %eax,%edi
  802e36:	48 b8 75 31 80 00 00 	movabs $0x803175,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
  802e42:	eb 05                	jmp    802e49 <devsock_close+0x40>
	else
		return 0;
  802e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 20          	sub    $0x20,%rsp
  802e53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e5a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e60:	89 c7                	mov    %eax,%edi
  802e62:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e75:	79 05                	jns    802e7c <connect+0x31>
		return r;
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	eb 1b                	jmp    802e97 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802e7c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e7f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e86:	48 89 ce             	mov    %rcx,%rsi
  802e89:	89 c7                	mov    %eax,%edi
  802e8b:	48 b8 a2 31 80 00 00 	movabs $0x8031a2,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	callq  *%rax
}
  802e97:	c9                   	leaveq 
  802e98:	c3                   	retq   

0000000000802e99 <listen>:

int
listen(int s, int backlog)
{
  802e99:	55                   	push   %rbp
  802e9a:	48 89 e5             	mov    %rsp,%rbp
  802e9d:	48 83 ec 20          	sub    $0x20,%rsp
  802ea1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ea4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ea7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eaa:	89 c7                	mov    %eax,%edi
  802eac:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
  802eb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebf:	79 05                	jns    802ec6 <listen+0x2d>
		return r;
  802ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec4:	eb 16                	jmp    802edc <listen+0x43>
	return nsipc_listen(r, backlog);
  802ec6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecc:	89 d6                	mov    %edx,%esi
  802ece:	89 c7                	mov    %eax,%edi
  802ed0:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  802ed7:	00 00 00 
  802eda:	ff d0                	callq  *%rax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 20          	sub    $0x20,%rsp
  802ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802eee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef6:	89 c2                	mov    %eax,%edx
  802ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efc:	8b 40 0c             	mov    0xc(%rax),%eax
  802eff:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f03:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f08:	89 c7                	mov    %eax,%edi
  802f0a:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
}
  802f16:	c9                   	leaveq 
  802f17:	c3                   	retq   

0000000000802f18 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802f18:	55                   	push   %rbp
  802f19:	48 89 e5             	mov    %rsp,%rbp
  802f1c:	48 83 ec 20          	sub    $0x20,%rsp
  802f20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f28:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f30:	89 c2                	mov    %eax,%edx
  802f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f36:	8b 40 0c             	mov    0xc(%rax),%eax
  802f39:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f42:	89 c7                	mov    %eax,%edi
  802f44:	48 b8 12 33 80 00 00 	movabs $0x803312,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
}
  802f50:	c9                   	leaveq 
  802f51:	c3                   	retq   

0000000000802f52 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802f52:	55                   	push   %rbp
  802f53:	48 89 e5             	mov    %rsp,%rbp
  802f56:	48 83 ec 10          	sub    $0x10,%rsp
  802f5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f66:	48 be 88 46 80 00 00 	movabs $0x804688,%rsi
  802f6d:	00 00 00 
  802f70:	48 89 c7             	mov    %rax,%rdi
  802f73:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
	return 0;
  802f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f84:	c9                   	leaveq 
  802f85:	c3                   	retq   

0000000000802f86 <socket>:

int
socket(int domain, int type, int protocol)
{
  802f86:	55                   	push   %rbp
  802f87:	48 89 e5             	mov    %rsp,%rbp
  802f8a:	48 83 ec 20          	sub    $0x20,%rsp
  802f8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f91:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802f94:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802f97:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f9a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802f9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa0:	89 ce                	mov    %ecx,%esi
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 ca 33 80 00 00 	movabs $0x8033ca,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
  802fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb7:	79 05                	jns    802fbe <socket+0x38>
		return r;
  802fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbc:	eb 11                	jmp    802fcf <socket+0x49>
	return alloc_sockfd(r);
  802fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc1:	89 c7                	mov    %eax,%edi
  802fc3:	48 b8 68 2c 80 00 00 	movabs $0x802c68,%rax
  802fca:	00 00 00 
  802fcd:	ff d0                	callq  *%rax
}
  802fcf:	c9                   	leaveq 
  802fd0:	c3                   	retq   

0000000000802fd1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802fd1:	55                   	push   %rbp
  802fd2:	48 89 e5             	mov    %rsp,%rbp
  802fd5:	48 83 ec 10          	sub    $0x10,%rsp
  802fd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802fdc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802fe3:	00 00 00 
  802fe6:	8b 00                	mov    (%rax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	75 1d                	jne    803009 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802fec:	bf 02 00 00 00       	mov    $0x2,%edi
  802ff1:	48 b8 15 3f 80 00 00 	movabs $0x803f15,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
  802ffd:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803004:	00 00 00 
  803007:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803009:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803010:	00 00 00 
  803013:	8b 00                	mov    (%rax),%eax
  803015:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803018:	b9 07 00 00 00       	mov    $0x7,%ecx
  80301d:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803024:	00 00 00 
  803027:	89 c7                	mov    %eax,%edi
  803029:	48 b8 b3 3e 80 00 00 	movabs $0x803eb3,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803035:	ba 00 00 00 00       	mov    $0x0,%edx
  80303a:	be 00 00 00 00       	mov    $0x0,%esi
  80303f:	bf 00 00 00 00       	mov    $0x0,%edi
  803044:	48 b8 ad 3d 80 00 00 	movabs $0x803dad,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
}
  803050:	c9                   	leaveq 
  803051:	c3                   	retq   

0000000000803052 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803052:	55                   	push   %rbp
  803053:	48 89 e5             	mov    %rsp,%rbp
  803056:	48 83 ec 30          	sub    $0x30,%rsp
  80305a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80305d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803061:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803065:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80306c:	00 00 00 
  80306f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803072:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803074:	bf 01 00 00 00       	mov    $0x1,%edi
  803079:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308c:	78 3e                	js     8030cc <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80308e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803095:	00 00 00 
  803098:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80309c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a0:	8b 40 10             	mov    0x10(%rax),%eax
  8030a3:	89 c2                	mov    %eax,%edx
  8030a5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	48 89 ce             	mov    %rcx,%rsi
  8030b0:	48 89 c7             	mov    %rax,%rdi
  8030b3:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8030ba:	00 00 00 
  8030bd:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8030bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c3:	8b 50 10             	mov    0x10(%rax),%edx
  8030c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ca:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030cf:	c9                   	leaveq 
  8030d0:	c3                   	retq   

00000000008030d1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8030d1:	55                   	push   %rbp
  8030d2:	48 89 e5             	mov    %rsp,%rbp
  8030d5:	48 83 ec 10          	sub    $0x10,%rsp
  8030d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030e0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8030e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ea:	00 00 00 
  8030ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030f0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8030f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f9:	48 89 c6             	mov    %rax,%rsi
  8030fc:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803103:	00 00 00 
  803106:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803112:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803119:	00 00 00 
  80311c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80311f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803122:	bf 02 00 00 00       	mov    $0x2,%edi
  803127:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
}
  803133:	c9                   	leaveq 
  803134:	c3                   	retq   

0000000000803135 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803135:	55                   	push   %rbp
  803136:	48 89 e5             	mov    %rsp,%rbp
  803139:	48 83 ec 10          	sub    $0x10,%rsp
  80313d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803140:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803143:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80314a:	00 00 00 
  80314d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803150:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803152:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803159:	00 00 00 
  80315c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803162:	bf 03 00 00 00       	mov    $0x3,%edi
  803167:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
}
  803173:	c9                   	leaveq 
  803174:	c3                   	retq   

0000000000803175 <nsipc_close>:

int
nsipc_close(int s)
{
  803175:	55                   	push   %rbp
  803176:	48 89 e5             	mov    %rsp,%rbp
  803179:	48 83 ec 10          	sub    $0x10,%rsp
  80317d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803180:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803187:	00 00 00 
  80318a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80318d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80318f:	bf 04 00 00 00       	mov    $0x4,%edi
  803194:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  80319b:	00 00 00 
  80319e:	ff d0                	callq  *%rax
}
  8031a0:	c9                   	leaveq 
  8031a1:	c3                   	retq   

00000000008031a2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031a2:	55                   	push   %rbp
  8031a3:	48 89 e5             	mov    %rsp,%rbp
  8031a6:	48 83 ec 10          	sub    $0x10,%rsp
  8031aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031b1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8031b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bb:	00 00 00 
  8031be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031c1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8031c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ca:	48 89 c6             	mov    %rax,%rsi
  8031cd:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031d4:	00 00 00 
  8031d7:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8031e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ea:	00 00 00 
  8031ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031f0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8031f3:	bf 05 00 00 00       	mov    $0x5,%edi
  8031f8:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
}
  803204:	c9                   	leaveq 
  803205:	c3                   	retq   

0000000000803206 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803206:	55                   	push   %rbp
  803207:	48 89 e5             	mov    %rsp,%rbp
  80320a:	48 83 ec 10          	sub    $0x10,%rsp
  80320e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803211:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803214:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80321b:	00 00 00 
  80321e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803221:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803223:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80322a:	00 00 00 
  80322d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803230:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803233:	bf 06 00 00 00       	mov    $0x6,%edi
  803238:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 30          	sub    $0x30,%rsp
  80324e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803251:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803255:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803258:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80325b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803262:	00 00 00 
  803265:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803268:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80326a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803271:	00 00 00 
  803274:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80327a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803281:	00 00 00 
  803284:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803287:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80328a:	bf 07 00 00 00       	mov    $0x7,%edi
  80328f:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
  80329b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80329e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a2:	78 69                	js     80330d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8032a4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8032ab:	7f 08                	jg     8032b5 <nsipc_recv+0x6f>
  8032ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8032b3:	7e 35                	jle    8032ea <nsipc_recv+0xa4>
  8032b5:	48 b9 8f 46 80 00 00 	movabs $0x80468f,%rcx
  8032bc:	00 00 00 
  8032bf:	48 ba a4 46 80 00 00 	movabs $0x8046a4,%rdx
  8032c6:	00 00 00 
  8032c9:	be 61 00 00 00       	mov    $0x61,%esi
  8032ce:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  8032d5:	00 00 00 
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dd:	49 b8 99 3c 80 00 00 	movabs $0x803c99,%r8
  8032e4:	00 00 00 
  8032e7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8032ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ed:	48 63 d0             	movslq %eax,%rdx
  8032f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f4:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8032fb:	00 00 00 
  8032fe:	48 89 c7             	mov    %rax,%rdi
  803301:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
	}

	return r;
  80330d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803310:	c9                   	leaveq 
  803311:	c3                   	retq   

0000000000803312 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803312:	55                   	push   %rbp
  803313:	48 89 e5             	mov    %rsp,%rbp
  803316:	48 83 ec 20          	sub    $0x20,%rsp
  80331a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80331d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803321:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803324:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803327:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80332e:	00 00 00 
  803331:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803334:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803336:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80333d:	7e 35                	jle    803374 <nsipc_send+0x62>
  80333f:	48 b9 c5 46 80 00 00 	movabs $0x8046c5,%rcx
  803346:	00 00 00 
  803349:	48 ba a4 46 80 00 00 	movabs $0x8046a4,%rdx
  803350:	00 00 00 
  803353:	be 6c 00 00 00       	mov    $0x6c,%esi
  803358:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  80335f:	00 00 00 
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
  803367:	49 b8 99 3c 80 00 00 	movabs $0x803c99,%r8
  80336e:	00 00 00 
  803371:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803374:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803377:	48 63 d0             	movslq %eax,%rdx
  80337a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337e:	48 89 c6             	mov    %rax,%rsi
  803381:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803388:	00 00 00 
  80338b:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803397:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339e:	00 00 00 
  8033a1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8033a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ae:	00 00 00 
  8033b1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033b4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8033b7:	bf 08 00 00 00       	mov    $0x8,%edi
  8033bc:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
}
  8033c8:	c9                   	leaveq 
  8033c9:	c3                   	retq   

00000000008033ca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8033ca:	55                   	push   %rbp
  8033cb:	48 89 e5             	mov    %rsp,%rbp
  8033ce:	48 83 ec 10          	sub    $0x10,%rsp
  8033d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033d5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8033d8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8033db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e2:	00 00 00 
  8033e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033e8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8033ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f1:	00 00 00 
  8033f4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8033fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803401:	00 00 00 
  803404:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803407:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80340a:	bf 09 00 00 00       	mov    $0x9,%edi
  80340f:	48 b8 d1 2f 80 00 00 	movabs $0x802fd1,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
}
  80341b:	c9                   	leaveq 
  80341c:	c3                   	retq   

000000000080341d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80341d:	55                   	push   %rbp
  80341e:	48 89 e5             	mov    %rsp,%rbp
  803421:	53                   	push   %rbx
  803422:	48 83 ec 38          	sub    $0x38,%rsp
  803426:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80342a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80342e:	48 89 c7             	mov    %rax,%rdi
  803431:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
  80343d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803440:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803444:	0f 88 bf 01 00 00    	js     803609 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80344a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344e:	ba 07 04 00 00       	mov    $0x407,%edx
  803453:	48 89 c6             	mov    %rax,%rsi
  803456:	bf 00 00 00 00       	mov    $0x0,%edi
  80345b:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  803462:	00 00 00 
  803465:	ff d0                	callq  *%rax
  803467:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80346a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80346e:	0f 88 95 01 00 00    	js     803609 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803474:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803478:	48 89 c7             	mov    %rax,%rdi
  80347b:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
  803487:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80348a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80348e:	0f 88 5d 01 00 00    	js     8035f1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803494:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803498:	ba 07 04 00 00       	mov    $0x407,%edx
  80349d:	48 89 c6             	mov    %rax,%rsi
  8034a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a5:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
  8034b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b8:	0f 88 33 01 00 00    	js     8035f1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8034be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c2:	48 89 c7             	mov    %rax,%rdi
  8034c5:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
  8034d1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8034de:	48 89 c6             	mov    %rax,%rsi
  8034e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e6:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
  8034f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034f9:	79 05                	jns    803500 <pipe+0xe3>
		goto err2;
  8034fb:	e9 d9 00 00 00       	jmpq   8035d9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803500:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803504:	48 89 c7             	mov    %rax,%rdi
  803507:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
  803513:	48 89 c2             	mov    %rax,%rdx
  803516:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80351a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803520:	48 89 d1             	mov    %rdx,%rcx
  803523:	ba 00 00 00 00       	mov    $0x0,%edx
  803528:	48 89 c6             	mov    %rax,%rsi
  80352b:	bf 00 00 00 00       	mov    $0x0,%edi
  803530:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803543:	79 1b                	jns    803560 <pipe+0x143>
		goto err3;
  803545:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803546:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354a:	48 89 c6             	mov    %rax,%rsi
  80354d:	bf 00 00 00 00       	mov    $0x0,%edi
  803552:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
  80355e:	eb 79                	jmp    8035d9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803564:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80356b:	00 00 00 
  80356e:	8b 12                	mov    (%rdx),%edx
  803570:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803576:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80357d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803581:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803588:	00 00 00 
  80358b:	8b 12                	mov    (%rdx),%edx
  80358d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80358f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803593:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80359a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359e:	48 89 c7             	mov    %rax,%rdi
  8035a1:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
  8035ad:	89 c2                	mov    %eax,%edx
  8035af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035b3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035b5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035b9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c1:	48 89 c7             	mov    %rax,%rdi
  8035c4:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
  8035d0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8035d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d7:	eb 33                	jmp    80360c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8035d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035dd:	48 89 c6             	mov    %rax,%rsi
  8035e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e5:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f5:	48 89 c6             	mov    %rax,%rsi
  8035f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035fd:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
err:
	return r;
  803609:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80360c:	48 83 c4 38          	add    $0x38,%rsp
  803610:	5b                   	pop    %rbx
  803611:	5d                   	pop    %rbp
  803612:	c3                   	retq   

0000000000803613 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803613:	55                   	push   %rbp
  803614:	48 89 e5             	mov    %rsp,%rbp
  803617:	53                   	push   %rbx
  803618:	48 83 ec 28          	sub    $0x28,%rsp
  80361c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803620:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803624:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80362b:	00 00 00 
  80362e:	48 8b 00             	mov    (%rax),%rax
  803631:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803637:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80363a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363e:	48 89 c7             	mov    %rax,%rdi
  803641:	48 b8 97 3f 80 00 00 	movabs $0x803f97,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
  80364d:	89 c3                	mov    %eax,%ebx
  80364f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803653:	48 89 c7             	mov    %rax,%rdi
  803656:	48 b8 97 3f 80 00 00 	movabs $0x803f97,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
  803662:	39 c3                	cmp    %eax,%ebx
  803664:	0f 94 c0             	sete   %al
  803667:	0f b6 c0             	movzbl %al,%eax
  80366a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80366d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803674:	00 00 00 
  803677:	48 8b 00             	mov    (%rax),%rax
  80367a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803680:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803683:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803686:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803689:	75 05                	jne    803690 <_pipeisclosed+0x7d>
			return ret;
  80368b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80368e:	eb 4f                	jmp    8036df <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803690:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803693:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803696:	74 42                	je     8036da <_pipeisclosed+0xc7>
  803698:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80369c:	75 3c                	jne    8036da <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80369e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036a5:	00 00 00 
  8036a8:	48 8b 00             	mov    (%rax),%rax
  8036ab:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8036b1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b7:	89 c6                	mov    %eax,%esi
  8036b9:	48 bf d6 46 80 00 00 	movabs $0x8046d6,%rdi
  8036c0:	00 00 00 
  8036c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c8:	49 b8 b0 02 80 00 00 	movabs $0x8002b0,%r8
  8036cf:	00 00 00 
  8036d2:	41 ff d0             	callq  *%r8
	}
  8036d5:	e9 4a ff ff ff       	jmpq   803624 <_pipeisclosed+0x11>
  8036da:	e9 45 ff ff ff       	jmpq   803624 <_pipeisclosed+0x11>
}
  8036df:	48 83 c4 28          	add    $0x28,%rsp
  8036e3:	5b                   	pop    %rbx
  8036e4:	5d                   	pop    %rbp
  8036e5:	c3                   	retq   

00000000008036e6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036e6:	55                   	push   %rbp
  8036e7:	48 89 e5             	mov    %rsp,%rbp
  8036ea:	48 83 ec 30          	sub    $0x30,%rsp
  8036ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036f8:	48 89 d6             	mov    %rdx,%rsi
  8036fb:	89 c7                	mov    %eax,%edi
  8036fd:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  803704:	00 00 00 
  803707:	ff d0                	callq  *%rax
  803709:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803710:	79 05                	jns    803717 <pipeisclosed+0x31>
		return r;
  803712:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803715:	eb 31                	jmp    803748 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80371b:	48 89 c7             	mov    %rax,%rdi
  80371e:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
  80372a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80372e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803732:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803736:	48 89 d6             	mov    %rdx,%rsi
  803739:	48 89 c7             	mov    %rax,%rdi
  80373c:	48 b8 13 36 80 00 00 	movabs $0x803613,%rax
  803743:	00 00 00 
  803746:	ff d0                	callq  *%rax
}
  803748:	c9                   	leaveq 
  803749:	c3                   	retq   

000000000080374a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80374a:	55                   	push   %rbp
  80374b:	48 89 e5             	mov    %rsp,%rbp
  80374e:	48 83 ec 40          	sub    $0x40,%rsp
  803752:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803756:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80375a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80375e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803762:	48 89 c7             	mov    %rax,%rdi
  803765:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
  803771:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803775:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803779:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80377d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803784:	00 
  803785:	e9 92 00 00 00       	jmpq   80381c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80378a:	eb 41                	jmp    8037cd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80378c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803791:	74 09                	je     80379c <devpipe_read+0x52>
				return i;
  803793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803797:	e9 92 00 00 00       	jmpq   80382e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80379c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a4:	48 89 d6             	mov    %rdx,%rsi
  8037a7:	48 89 c7             	mov    %rax,%rdi
  8037aa:	48 b8 13 36 80 00 00 	movabs $0x803613,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
  8037b6:	85 c0                	test   %eax,%eax
  8037b8:	74 07                	je     8037c1 <devpipe_read+0x77>
				return 0;
  8037ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bf:	eb 6d                	jmp    80382e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037c1:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  8037c8:	00 00 00 
  8037cb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d1:	8b 10                	mov    (%rax),%edx
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	8b 40 04             	mov    0x4(%rax),%eax
  8037da:	39 c2                	cmp    %eax,%edx
  8037dc:	74 ae                	je     80378c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037e6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ee:	8b 00                	mov    (%rax),%eax
  8037f0:	99                   	cltd   
  8037f1:	c1 ea 1b             	shr    $0x1b,%edx
  8037f4:	01 d0                	add    %edx,%eax
  8037f6:	83 e0 1f             	and    $0x1f,%eax
  8037f9:	29 d0                	sub    %edx,%eax
  8037fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037ff:	48 98                	cltq   
  803801:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803806:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380c:	8b 00                	mov    (%rax),%eax
  80380e:	8d 50 01             	lea    0x1(%rax),%edx
  803811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803815:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803817:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80381c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803820:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803824:	0f 82 60 ff ff ff    	jb     80378a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80382a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80382e:	c9                   	leaveq 
  80382f:	c3                   	retq   

0000000000803830 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803830:	55                   	push   %rbp
  803831:	48 89 e5             	mov    %rsp,%rbp
  803834:	48 83 ec 40          	sub    $0x40,%rsp
  803838:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80383c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803840:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803848:	48 89 c7             	mov    %rax,%rdi
  80384b:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80385b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80385f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803863:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80386a:	00 
  80386b:	e9 8e 00 00 00       	jmpq   8038fe <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803870:	eb 31                	jmp    8038a3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803872:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387a:	48 89 d6             	mov    %rdx,%rsi
  80387d:	48 89 c7             	mov    %rax,%rdi
  803880:	48 b8 13 36 80 00 00 	movabs $0x803613,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
  80388c:	85 c0                	test   %eax,%eax
  80388e:	74 07                	je     803897 <devpipe_write+0x67>
				return 0;
  803890:	b8 00 00 00 00       	mov    $0x0,%eax
  803895:	eb 79                	jmp    803910 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803897:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a7:	8b 40 04             	mov    0x4(%rax),%eax
  8038aa:	48 63 d0             	movslq %eax,%rdx
  8038ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b1:	8b 00                	mov    (%rax),%eax
  8038b3:	48 98                	cltq   
  8038b5:	48 83 c0 20          	add    $0x20,%rax
  8038b9:	48 39 c2             	cmp    %rax,%rdx
  8038bc:	73 b4                	jae    803872 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8038be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c2:	8b 40 04             	mov    0x4(%rax),%eax
  8038c5:	99                   	cltd   
  8038c6:	c1 ea 1b             	shr    $0x1b,%edx
  8038c9:	01 d0                	add    %edx,%eax
  8038cb:	83 e0 1f             	and    $0x1f,%eax
  8038ce:	29 d0                	sub    %edx,%eax
  8038d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038d4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038d8:	48 01 ca             	add    %rcx,%rdx
  8038db:	0f b6 0a             	movzbl (%rdx),%ecx
  8038de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038e2:	48 98                	cltq   
  8038e4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ec:	8b 40 04             	mov    0x4(%rax),%eax
  8038ef:	8d 50 01             	lea    0x1(%rax),%edx
  8038f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803902:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803906:	0f 82 64 ff ff ff    	jb     803870 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80390c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803910:	c9                   	leaveq 
  803911:	c3                   	retq   

0000000000803912 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803912:	55                   	push   %rbp
  803913:	48 89 e5             	mov    %rsp,%rbp
  803916:	48 83 ec 20          	sub    $0x20,%rsp
  80391a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80391e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803926:	48 89 c7             	mov    %rax,%rdi
  803929:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
  803935:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393d:	48 be e9 46 80 00 00 	movabs $0x8046e9,%rsi
  803944:	00 00 00 
  803947:	48 89 c7             	mov    %rax,%rdi
  80394a:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  803951:	00 00 00 
  803954:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803956:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395a:	8b 50 04             	mov    0x4(%rax),%edx
  80395d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803961:	8b 00                	mov    (%rax),%eax
  803963:	29 c2                	sub    %eax,%edx
  803965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803969:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80396f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803973:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80397a:	00 00 00 
	stat->st_dev = &devpipe;
  80397d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803981:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803988:	00 00 00 
  80398b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803997:	c9                   	leaveq 
  803998:	c3                   	retq   

0000000000803999 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803999:	55                   	push   %rbp
  80399a:	48 89 e5             	mov    %rsp,%rbp
  80399d:	48 83 ec 10          	sub    $0x10,%rsp
  8039a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8039a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a9:	48 89 c6             	mov    %rax,%rsi
  8039ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b1:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8039bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c1:	48 89 c7             	mov    %rax,%rdi
  8039c4:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8039cb:	00 00 00 
  8039ce:	ff d0                	callq  *%rax
  8039d0:	48 89 c6             	mov    %rax,%rsi
  8039d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d8:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
}
  8039e4:	c9                   	leaveq 
  8039e5:	c3                   	retq   

00000000008039e6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8039e6:	55                   	push   %rbp
  8039e7:	48 89 e5             	mov    %rsp,%rbp
  8039ea:	48 83 ec 20          	sub    $0x20,%rsp
  8039ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8039f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8039f7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8039fb:	be 01 00 00 00       	mov    $0x1,%esi
  803a00:	48 89 c7             	mov    %rax,%rdi
  803a03:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
}
  803a0f:	c9                   	leaveq 
  803a10:	c3                   	retq   

0000000000803a11 <getchar>:

int
getchar(void)
{
  803a11:	55                   	push   %rbp
  803a12:	48 89 e5             	mov    %rsp,%rbp
  803a15:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a19:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a1d:	ba 01 00 00 00       	mov    $0x1,%edx
  803a22:	48 89 c6             	mov    %rax,%rsi
  803a25:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2a:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  803a31:	00 00 00 
  803a34:	ff d0                	callq  *%rax
  803a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3d:	79 05                	jns    803a44 <getchar+0x33>
		return r;
  803a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a42:	eb 14                	jmp    803a58 <getchar+0x47>
	if (r < 1)
  803a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a48:	7f 07                	jg     803a51 <getchar+0x40>
		return -E_EOF;
  803a4a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a4f:	eb 07                	jmp    803a58 <getchar+0x47>
	return c;
  803a51:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a55:	0f b6 c0             	movzbl %al,%eax
}
  803a58:	c9                   	leaveq 
  803a59:	c3                   	retq   

0000000000803a5a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a5a:	55                   	push   %rbp
  803a5b:	48 89 e5             	mov    %rsp,%rbp
  803a5e:	48 83 ec 20          	sub    $0x20,%rsp
  803a62:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a6c:	48 89 d6             	mov    %rdx,%rsi
  803a6f:	89 c7                	mov    %eax,%edi
  803a71:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
  803a7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a84:	79 05                	jns    803a8b <iscons+0x31>
		return r;
  803a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a89:	eb 1a                	jmp    803aa5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8f:	8b 10                	mov    (%rax),%edx
  803a91:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803a98:	00 00 00 
  803a9b:	8b 00                	mov    (%rax),%eax
  803a9d:	39 c2                	cmp    %eax,%edx
  803a9f:	0f 94 c0             	sete   %al
  803aa2:	0f b6 c0             	movzbl %al,%eax
}
  803aa5:	c9                   	leaveq 
  803aa6:	c3                   	retq   

0000000000803aa7 <opencons>:

int
opencons(void)
{
  803aa7:	55                   	push   %rbp
  803aa8:	48 89 e5             	mov    %rsp,%rbp
  803aab:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803aaf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 5b 1c 80 00 00 	movabs $0x801c5b,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac9:	79 05                	jns    803ad0 <opencons+0x29>
		return r;
  803acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ace:	eb 5b                	jmp    803b2b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ad9:	48 89 c6             	mov    %rax,%rsi
  803adc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae1:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
  803aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af4:	79 05                	jns    803afb <opencons+0x54>
		return r;
  803af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af9:	eb 30                	jmp    803b2b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aff:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803b06:	00 00 00 
  803b09:	8b 12                	mov    (%rdx),%edx
  803b0b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1c:	48 89 c7             	mov    %rax,%rdi
  803b1f:	48 b8 0d 1c 80 00 00 	movabs $0x801c0d,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
}
  803b2b:	c9                   	leaveq 
  803b2c:	c3                   	retq   

0000000000803b2d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b2d:	55                   	push   %rbp
  803b2e:	48 89 e5             	mov    %rsp,%rbp
  803b31:	48 83 ec 30          	sub    $0x30,%rsp
  803b35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803b41:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b46:	75 07                	jne    803b4f <devcons_read+0x22>
		return 0;
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4d:	eb 4b                	jmp    803b9a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803b4f:	eb 0c                	jmp    803b5d <devcons_read+0x30>
		sys_yield();
  803b51:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b5d:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b70:	74 df                	je     803b51 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b76:	79 05                	jns    803b7d <devcons_read+0x50>
		return c;
  803b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7b:	eb 1d                	jmp    803b9a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803b7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803b81:	75 07                	jne    803b8a <devcons_read+0x5d>
		return 0;
  803b83:	b8 00 00 00 00       	mov    $0x0,%eax
  803b88:	eb 10                	jmp    803b9a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8d:	89 c2                	mov    %eax,%edx
  803b8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b93:	88 10                	mov    %dl,(%rax)
	return 1;
  803b95:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b9a:	c9                   	leaveq 
  803b9b:	c3                   	retq   

0000000000803b9c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b9c:	55                   	push   %rbp
  803b9d:	48 89 e5             	mov    %rsp,%rbp
  803ba0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ba7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803bae:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803bb5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bc3:	eb 76                	jmp    803c3b <devcons_write+0x9f>
		m = n - tot;
  803bc5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803bcc:	89 c2                	mov    %eax,%edx
  803bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd1:	29 c2                	sub    %eax,%edx
  803bd3:	89 d0                	mov    %edx,%eax
  803bd5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803bd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bdb:	83 f8 7f             	cmp    $0x7f,%eax
  803bde:	76 07                	jbe    803be7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803be0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803be7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bea:	48 63 d0             	movslq %eax,%rdx
  803bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf0:	48 63 c8             	movslq %eax,%rcx
  803bf3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803bfa:	48 01 c1             	add    %rax,%rcx
  803bfd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c04:	48 89 ce             	mov    %rcx,%rsi
  803c07:	48 89 c7             	mov    %rax,%rdi
  803c0a:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c19:	48 63 d0             	movslq %eax,%rdx
  803c1c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c23:	48 89 d6             	mov    %rdx,%rsi
  803c26:	48 89 c7             	mov    %rax,%rdi
  803c29:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c38:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3e:	48 98                	cltq   
  803c40:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803c47:	0f 82 78 ff ff ff    	jb     803bc5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c50:	c9                   	leaveq 
  803c51:	c3                   	retq   

0000000000803c52 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c52:	55                   	push   %rbp
  803c53:	48 89 e5             	mov    %rsp,%rbp
  803c56:	48 83 ec 08          	sub    $0x8,%rsp
  803c5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 10          	sub    $0x10,%rsp
  803c6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	48 be f5 46 80 00 00 	movabs $0x8046f5,%rsi
  803c80:	00 00 00 
  803c83:	48 89 c7             	mov    %rax,%rdi
  803c86:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  803c8d:	00 00 00 
  803c90:	ff d0                	callq  *%rax
	return 0;
  803c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c97:	c9                   	leaveq 
  803c98:	c3                   	retq   

0000000000803c99 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803c99:	55                   	push   %rbp
  803c9a:	48 89 e5             	mov    %rsp,%rbp
  803c9d:	53                   	push   %rbx
  803c9e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ca5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803cac:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803cb2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803cb9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803cc0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803cc7:	84 c0                	test   %al,%al
  803cc9:	74 23                	je     803cee <_panic+0x55>
  803ccb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803cd2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803cd6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803cda:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803cde:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803ce2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803ce6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803cea:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803cee:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803cf5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803cfc:	00 00 00 
  803cff:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803d06:	00 00 00 
  803d09:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d0d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803d14:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803d1b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803d22:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803d29:	00 00 00 
  803d2c:	48 8b 18             	mov    (%rax),%rbx
  803d2f:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803d36:	00 00 00 
  803d39:	ff d0                	callq  *%rax
  803d3b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803d41:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803d48:	41 89 c8             	mov    %ecx,%r8d
  803d4b:	48 89 d1             	mov    %rdx,%rcx
  803d4e:	48 89 da             	mov    %rbx,%rdx
  803d51:	89 c6                	mov    %eax,%esi
  803d53:	48 bf 00 47 80 00 00 	movabs $0x804700,%rdi
  803d5a:	00 00 00 
  803d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d62:	49 b9 b0 02 80 00 00 	movabs $0x8002b0,%r9
  803d69:	00 00 00 
  803d6c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803d6f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803d76:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803d7d:	48 89 d6             	mov    %rdx,%rsi
  803d80:	48 89 c7             	mov    %rax,%rdi
  803d83:	48 b8 04 02 80 00 00 	movabs $0x800204,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
	cprintf("\n");
  803d8f:	48 bf 23 47 80 00 00 	movabs $0x804723,%rdi
  803d96:	00 00 00 
  803d99:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9e:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  803da5:	00 00 00 
  803da8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803daa:	cc                   	int3   
  803dab:	eb fd                	jmp    803daa <_panic+0x111>

0000000000803dad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803dad:	55                   	push   %rbp
  803dae:	48 89 e5             	mov    %rsp,%rbp
  803db1:	48 83 ec 30          	sub    $0x30,%rsp
  803db5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803db9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dbd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803dc1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dc8:	00 00 00 
  803dcb:	48 8b 00             	mov    (%rax),%rax
  803dce:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803dd4:	85 c0                	test   %eax,%eax
  803dd6:	75 3c                	jne    803e14 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803dd8:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803ddf:	00 00 00 
  803de2:	ff d0                	callq  *%rax
  803de4:	25 ff 03 00 00       	and    $0x3ff,%eax
  803de9:	48 63 d0             	movslq %eax,%rdx
  803dec:	48 89 d0             	mov    %rdx,%rax
  803def:	48 c1 e0 03          	shl    $0x3,%rax
  803df3:	48 01 d0             	add    %rdx,%rax
  803df6:	48 c1 e0 05          	shl    $0x5,%rax
  803dfa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e01:	00 00 00 
  803e04:	48 01 c2             	add    %rax,%rdx
  803e07:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e0e:	00 00 00 
  803e11:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803e14:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e19:	75 0e                	jne    803e29 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803e1b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e22:	00 00 00 
  803e25:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803e29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e2d:	48 89 c7             	mov    %rax,%rdi
  803e30:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  803e37:	00 00 00 
  803e3a:	ff d0                	callq  *%rax
  803e3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803e3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e43:	79 19                	jns    803e5e <ipc_recv+0xb1>
		*from_env_store = 0;
  803e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e49:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5c:	eb 53                	jmp    803eb1 <ipc_recv+0x104>
	}
	if(from_env_store)
  803e5e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e63:	74 19                	je     803e7e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803e65:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e6c:	00 00 00 
  803e6f:	48 8b 00             	mov    (%rax),%rax
  803e72:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e7c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e7e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e83:	74 19                	je     803e9e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803e85:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e8c:	00 00 00 
  803e8f:	48 8b 00             	mov    (%rax),%rax
  803e92:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e9e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ea5:	00 00 00 
  803ea8:	48 8b 00             	mov    (%rax),%rax
  803eab:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803eb1:	c9                   	leaveq 
  803eb2:	c3                   	retq   

0000000000803eb3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803eb3:	55                   	push   %rbp
  803eb4:	48 89 e5             	mov    %rsp,%rbp
  803eb7:	48 83 ec 30          	sub    $0x30,%rsp
  803ebb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ebe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ec1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ec5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803ec8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ecd:	75 0e                	jne    803edd <ipc_send+0x2a>
		pg = (void*)UTOP;
  803ecf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ed6:	00 00 00 
  803ed9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803edd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ee0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ee3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ee7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eea:	89 c7                	mov    %eax,%edi
  803eec:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
  803ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803efb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803eff:	75 0c                	jne    803f0d <ipc_send+0x5a>
			sys_yield();
  803f01:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803f0d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f11:	74 ca                	je     803edd <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803f13:	c9                   	leaveq 
  803f14:	c3                   	retq   

0000000000803f15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f15:	55                   	push   %rbp
  803f16:	48 89 e5             	mov    %rsp,%rbp
  803f19:	48 83 ec 14          	sub    $0x14,%rsp
  803f1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f27:	eb 5e                	jmp    803f87 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803f29:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f30:	00 00 00 
  803f33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f36:	48 63 d0             	movslq %eax,%rdx
  803f39:	48 89 d0             	mov    %rdx,%rax
  803f3c:	48 c1 e0 03          	shl    $0x3,%rax
  803f40:	48 01 d0             	add    %rdx,%rax
  803f43:	48 c1 e0 05          	shl    $0x5,%rax
  803f47:	48 01 c8             	add    %rcx,%rax
  803f4a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f50:	8b 00                	mov    (%rax),%eax
  803f52:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f55:	75 2c                	jne    803f83 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803f57:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f5e:	00 00 00 
  803f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f64:	48 63 d0             	movslq %eax,%rdx
  803f67:	48 89 d0             	mov    %rdx,%rax
  803f6a:	48 c1 e0 03          	shl    $0x3,%rax
  803f6e:	48 01 d0             	add    %rdx,%rax
  803f71:	48 c1 e0 05          	shl    $0x5,%rax
  803f75:	48 01 c8             	add    %rcx,%rax
  803f78:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f7e:	8b 40 08             	mov    0x8(%rax),%eax
  803f81:	eb 12                	jmp    803f95 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f87:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f8e:	7e 99                	jle    803f29 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f95:	c9                   	leaveq 
  803f96:	c3                   	retq   

0000000000803f97 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f97:	55                   	push   %rbp
  803f98:	48 89 e5             	mov    %rsp,%rbp
  803f9b:	48 83 ec 18          	sub    $0x18,%rsp
  803f9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa7:	48 c1 e8 15          	shr    $0x15,%rax
  803fab:	48 89 c2             	mov    %rax,%rdx
  803fae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803fb5:	01 00 00 
  803fb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fbc:	83 e0 01             	and    $0x1,%eax
  803fbf:	48 85 c0             	test   %rax,%rax
  803fc2:	75 07                	jne    803fcb <pageref+0x34>
		return 0;
  803fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803fc9:	eb 53                	jmp    80401e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fcf:	48 c1 e8 0c          	shr    $0xc,%rax
  803fd3:	48 89 c2             	mov    %rax,%rdx
  803fd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fdd:	01 00 00 
  803fe0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fe4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fec:	83 e0 01             	and    $0x1,%eax
  803fef:	48 85 c0             	test   %rax,%rax
  803ff2:	75 07                	jne    803ffb <pageref+0x64>
		return 0;
  803ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff9:	eb 23                	jmp    80401e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fff:	48 c1 e8 0c          	shr    $0xc,%rax
  804003:	48 89 c2             	mov    %rax,%rdx
  804006:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80400d:	00 00 00 
  804010:	48 c1 e2 04          	shl    $0x4,%rdx
  804014:	48 01 d0             	add    %rdx,%rax
  804017:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80401b:	0f b7 c0             	movzwl %ax,%eax
}
  80401e:	c9                   	leaveq 
  80401f:	c3                   	retq   
