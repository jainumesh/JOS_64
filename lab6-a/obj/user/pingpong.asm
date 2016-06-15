
obj/user/pingpong.debug:     file format elf64-x86-64


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
  80003c:	e8 06 01 00 00       	callq  800147 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 20 1f 80 00 00 	movabs $0x801f20,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf 56 47 80 00 00 	movabs $0x804756,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 1a 03 80 00 00 	movabs $0x80031a,%r8
  800103:	00 00 00 
  800106:	41 ff d0             	callq  *%r8
		if (i == 10)
  800109:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010d:	75 02                	jne    800111 <umain+0xce>
			return;
  80010f:	eb 2f                	jmp    800140 <umain+0xfd>
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	75 02                	jne    80013b <umain+0xf8>
			return;
  800139:	eb 05                	jmp    800140 <umain+0xfd>
	}
  80013b:	e9 77 ff ff ff       	jmpq   8000b7 <umain+0x74>

}
  800140:	48 83 c4 28          	add    $0x28,%rsp
  800144:	5b                   	pop    %rbx
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800156:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	25 ff 03 00 00       	and    $0x3ff,%eax
  800167:	48 63 d0             	movslq %eax,%rdx
  80016a:	48 89 d0             	mov    %rdx,%rax
  80016d:	48 c1 e0 03          	shl    $0x3,%rax
  800171:	48 01 d0             	add    %rdx,%rax
  800174:	48 c1 e0 05          	shl    $0x5,%rax
  800178:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80017f:	00 00 00 
  800182:	48 01 c2             	add    %rax,%rdx
  800185:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018c:	00 00 00 
  80018f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800196:	7e 14                	jle    8001ac <libmain+0x65>
		binaryname = argv[0];
  800198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019c:	48 8b 10             	mov    (%rax),%rdx
  80019f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a6:	00 00 00 
  8001a9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b3:	48 89 d6             	mov    %rdx,%rsi
  8001b6:	89 c7                	mov    %eax,%edi
  8001b8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001bf:	00 00 00 
  8001c2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001c4:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
}
  8001d0:	c9                   	leaveq 
  8001d1:	c3                   	retq   

00000000008001d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d2:	55                   	push   %rbp
  8001d3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001d6:	48 b8 fc 26 80 00 00 	movabs $0x8026fc,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 3e 17 80 00 00 	movabs $0x80173e,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax

}
  8001f3:	5d                   	pop    %rbp
  8001f4:	c3                   	retq   

00000000008001f5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
  8001f9:	48 83 ec 10          	sub    $0x10,%rsp
  8001fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800200:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800208:	8b 00                	mov    (%rax),%eax
  80020a:	8d 48 01             	lea    0x1(%rax),%ecx
  80020d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800211:	89 0a                	mov    %ecx,(%rdx)
  800213:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800216:	89 d1                	mov    %edx,%ecx
  800218:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021c:	48 98                	cltq   
  80021e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800226:	8b 00                	mov    (%rax),%eax
  800228:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022d:	75 2c                	jne    80025b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80022f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800233:	8b 00                	mov    (%rax),%eax
  800235:	48 98                	cltq   
  800237:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023b:	48 83 c2 08          	add    $0x8,%rdx
  80023f:	48 89 c6             	mov    %rax,%rsi
  800242:	48 89 d7             	mov    %rdx,%rdi
  800245:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	callq  *%rax
        b->idx = 0;
  800251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800255:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80025b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025f:	8b 40 04             	mov    0x4(%rax),%eax
  800262:	8d 50 01             	lea    0x1(%rax),%edx
  800265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800269:	89 50 04             	mov    %edx,0x4(%rax)
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800279:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800280:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800287:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80028e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800295:	48 8b 0a             	mov    (%rdx),%rcx
  800298:	48 89 08             	mov    %rcx,(%rax)
  80029b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80029f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b2:	00 00 00 
    b.cnt = 0;
  8002b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002bc:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002bf:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002c6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002cd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d4:	48 89 c6             	mov    %rax,%rsi
  8002d7:	48 bf f5 01 80 00 00 	movabs $0x8001f5,%rdi
  8002de:	00 00 00 
  8002e1:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002ed:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f3:	48 98                	cltq   
  8002f5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002fc:	48 83 c2 08          	add    $0x8,%rdx
  800300:	48 89 c6             	mov    %rax,%rsi
  800303:	48 89 d7             	mov    %rdx,%rdi
  800306:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800312:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800325:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80032c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800333:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800341:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800348:	84 c0                	test   %al,%al
  80034a:	74 20                	je     80036c <cprintf+0x52>
  80034c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800350:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800354:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800358:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80035c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800360:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800364:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800368:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80036c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800373:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037a:	00 00 00 
  80037d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800384:	00 00 00 
  800387:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800392:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800399:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003ae:	48 8b 0a             	mov    (%rdx),%rcx
  8003b1:	48 89 08             	mov    %rcx,(%rax)
  8003b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003c4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d2:	48 89 d6             	mov    %rdx,%rsi
  8003d5:	48 89 c7             	mov    %rax,%rdi
  8003d8:	48 b8 6e 02 80 00 00 	movabs $0x80026e,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
  8003e4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003ea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f0:	c9                   	leaveq 
  8003f1:	c3                   	retq   

00000000008003f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f2:	55                   	push   %rbp
  8003f3:	48 89 e5             	mov    %rsp,%rbp
  8003f6:	53                   	push   %rbx
  8003f7:	48 83 ec 38          	sub    $0x38,%rsp
  8003fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800403:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800407:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80040e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800412:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800415:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800419:	77 3b                	ja     800456 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80041e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800422:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800429:	ba 00 00 00 00       	mov    $0x0,%edx
  80042e:	48 f7 f3             	div    %rbx
  800431:	48 89 c2             	mov    %rax,%rdx
  800434:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800437:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80043e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800442:	41 89 f9             	mov    %edi,%r9d
  800445:	48 89 c7             	mov    %rax,%rdi
  800448:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  80044f:	00 00 00 
  800452:	ff d0                	callq  *%rax
  800454:	eb 1e                	jmp    800474 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800456:	eb 12                	jmp    80046a <printnum+0x78>
			putch(padc, putdat);
  800458:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80045f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800463:	48 89 ce             	mov    %rcx,%rsi
  800466:	89 d7                	mov    %edx,%edi
  800468:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80046e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800472:	7f e4                	jg     800458 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800474:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
  800480:	48 f7 f1             	div    %rcx
  800483:	48 89 d0             	mov    %rdx,%rax
  800486:	48 ba 70 49 80 00 00 	movabs $0x804970,%rdx
  80048d:	00 00 00 
  800490:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800494:	0f be d0             	movsbl %al,%edx
  800497:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80049b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049f:	48 89 ce             	mov    %rcx,%rsi
  8004a2:	89 d7                	mov    %edx,%edi
  8004a4:	ff d0                	callq  *%rax
}
  8004a6:	48 83 c4 38          	add    $0x38,%rsp
  8004aa:	5b                   	pop    %rbx
  8004ab:	5d                   	pop    %rbp
  8004ac:	c3                   	retq   

00000000008004ad <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ad:	55                   	push   %rbp
  8004ae:	48 89 e5             	mov    %rsp,%rbp
  8004b1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c0:	7e 52                	jle    800514 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c6:	8b 00                	mov    (%rax),%eax
  8004c8:	83 f8 30             	cmp    $0x30,%eax
  8004cb:	73 24                	jae    8004f1 <getuint+0x44>
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	8b 00                	mov    (%rax),%eax
  8004db:	89 c0                	mov    %eax,%eax
  8004dd:	48 01 d0             	add    %rdx,%rax
  8004e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e4:	8b 12                	mov    (%rdx),%edx
  8004e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ed:	89 0a                	mov    %ecx,(%rdx)
  8004ef:	eb 17                	jmp    800508 <getuint+0x5b>
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f9:	48 89 d0             	mov    %rdx,%rax
  8004fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800508:	48 8b 00             	mov    (%rax),%rax
  80050b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80050f:	e9 a3 00 00 00       	jmpq   8005b7 <getuint+0x10a>
	else if (lflag)
  800514:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800518:	74 4f                	je     800569 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	83 f8 30             	cmp    $0x30,%eax
  800523:	73 24                	jae    800549 <getuint+0x9c>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	89 c0                	mov    %eax,%eax
  800535:	48 01 d0             	add    %rdx,%rax
  800538:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053c:	8b 12                	mov    (%rdx),%edx
  80053e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800541:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800545:	89 0a                	mov    %ecx,(%rdx)
  800547:	eb 17                	jmp    800560 <getuint+0xb3>
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800551:	48 89 d0             	mov    %rdx,%rax
  800554:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800558:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800560:	48 8b 00             	mov    (%rax),%rax
  800563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800567:	eb 4e                	jmp    8005b7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056d:	8b 00                	mov    (%rax),%eax
  80056f:	83 f8 30             	cmp    $0x30,%eax
  800572:	73 24                	jae    800598 <getuint+0xeb>
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	89 c0                	mov    %eax,%eax
  800584:	48 01 d0             	add    %rdx,%rax
  800587:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058b:	8b 12                	mov    (%rdx),%edx
  80058d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800594:	89 0a                	mov    %ecx,(%rdx)
  800596:	eb 17                	jmp    8005af <getuint+0x102>
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a0:	48 89 d0             	mov    %rdx,%rax
  8005a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005af:	8b 00                	mov    (%rax),%eax
  8005b1:	89 c0                	mov    %eax,%eax
  8005b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005bb:	c9                   	leaveq 
  8005bc:	c3                   	retq   

00000000008005bd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005bd:	55                   	push   %rbp
  8005be:	48 89 e5             	mov    %rsp,%rbp
  8005c1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005c9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005cc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d0:	7e 52                	jle    800624 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	83 f8 30             	cmp    $0x30,%eax
  8005db:	73 24                	jae    800601 <getint+0x44>
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	89 c0                	mov    %eax,%eax
  8005ed:	48 01 d0             	add    %rdx,%rax
  8005f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f4:	8b 12                	mov    (%rdx),%edx
  8005f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fd:	89 0a                	mov    %ecx,(%rdx)
  8005ff:	eb 17                	jmp    800618 <getint+0x5b>
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800609:	48 89 d0             	mov    %rdx,%rax
  80060c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800618:	48 8b 00             	mov    (%rax),%rax
  80061b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061f:	e9 a3 00 00 00       	jmpq   8006c7 <getint+0x10a>
	else if (lflag)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800628:	74 4f                	je     800679 <getint+0xbc>
		x=va_arg(*ap, long);
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	8b 00                	mov    (%rax),%eax
  800630:	83 f8 30             	cmp    $0x30,%eax
  800633:	73 24                	jae    800659 <getint+0x9c>
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	89 c0                	mov    %eax,%eax
  800645:	48 01 d0             	add    %rdx,%rax
  800648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064c:	8b 12                	mov    (%rdx),%edx
  80064e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800651:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800655:	89 0a                	mov    %ecx,(%rdx)
  800657:	eb 17                	jmp    800670 <getint+0xb3>
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800661:	48 89 d0             	mov    %rdx,%rax
  800664:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800670:	48 8b 00             	mov    (%rax),%rax
  800673:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800677:	eb 4e                	jmp    8006c7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067d:	8b 00                	mov    (%rax),%eax
  80067f:	83 f8 30             	cmp    $0x30,%eax
  800682:	73 24                	jae    8006a8 <getint+0xeb>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	89 c0                	mov    %eax,%eax
  800694:	48 01 d0             	add    %rdx,%rax
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	8b 12                	mov    (%rdx),%edx
  80069d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	89 0a                	mov    %ecx,(%rdx)
  8006a6:	eb 17                	jmp    8006bf <getint+0x102>
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b0:	48 89 d0             	mov    %rdx,%rax
  8006b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	48 98                	cltq   
  8006c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006cb:	c9                   	leaveq 
  8006cc:	c3                   	retq   

00000000008006cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006cd:	55                   	push   %rbp
  8006ce:	48 89 e5             	mov    %rsp,%rbp
  8006d1:	41 54                	push   %r12
  8006d3:	53                   	push   %rbx
  8006d4:	48 83 ec 60          	sub    $0x60,%rsp
  8006d8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006dc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ec:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f0:	48 8b 0a             	mov    (%rdx),%rcx
  8006f3:	48 89 08             	mov    %rcx,(%rax)
  8006f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800702:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800706:	eb 17                	jmp    80071f <vprintfmt+0x52>
			if (ch == '\0')
  800708:	85 db                	test   %ebx,%ebx
  80070a:	0f 84 cc 04 00 00    	je     800bdc <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800710:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800714:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800718:	48 89 d6             	mov    %rdx,%rsi
  80071b:	89 df                	mov    %ebx,%edi
  80071d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800727:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80072b:	0f b6 00             	movzbl (%rax),%eax
  80072e:	0f b6 d8             	movzbl %al,%ebx
  800731:	83 fb 25             	cmp    $0x25,%ebx
  800734:	75 d2                	jne    800708 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800736:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80073a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800741:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800748:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80074f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800756:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80075e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800762:	0f b6 00             	movzbl (%rax),%eax
  800765:	0f b6 d8             	movzbl %al,%ebx
  800768:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80076b:	83 f8 55             	cmp    $0x55,%eax
  80076e:	0f 87 34 04 00 00    	ja     800ba8 <vprintfmt+0x4db>
  800774:	89 c0                	mov    %eax,%eax
  800776:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80077d:	00 
  80077e:	48 b8 98 49 80 00 00 	movabs $0x804998,%rax
  800785:	00 00 00 
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 00             	mov    (%rax),%rax
  80078e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800790:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800794:	eb c0                	jmp    800756 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800796:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80079a:	eb ba                	jmp    800756 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a6:	89 d0                	mov    %edx,%eax
  8007a8:	c1 e0 02             	shl    $0x2,%eax
  8007ab:	01 d0                	add    %edx,%eax
  8007ad:	01 c0                	add    %eax,%eax
  8007af:	01 d8                	add    %ebx,%eax
  8007b1:	83 e8 30             	sub    $0x30,%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bb:	0f b6 00             	movzbl (%rax),%eax
  8007be:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c4:	7e 0c                	jle    8007d2 <vprintfmt+0x105>
  8007c6:	83 fb 39             	cmp    $0x39,%ebx
  8007c9:	7f 07                	jg     8007d2 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d0:	eb d1                	jmp    8007a3 <vprintfmt+0xd6>
			goto process_precision;
  8007d2:	eb 58                	jmp    80082c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d7:	83 f8 30             	cmp    $0x30,%eax
  8007da:	73 17                	jae    8007f3 <vprintfmt+0x126>
  8007dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007eb:	83 c2 08             	add    $0x8,%edx
  8007ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f1:	eb 0f                	jmp    800802 <vprintfmt+0x135>
  8007f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f7:	48 89 d0             	mov    %rdx,%rax
  8007fa:	48 83 c2 08          	add    $0x8,%rdx
  8007fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800802:	8b 00                	mov    (%rax),%eax
  800804:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800807:	eb 23                	jmp    80082c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800809:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080d:	79 0c                	jns    80081b <vprintfmt+0x14e>
				width = 0;
  80080f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800816:	e9 3b ff ff ff       	jmpq   800756 <vprintfmt+0x89>
  80081b:	e9 36 ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800820:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800827:	e9 2a ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80082c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800830:	79 12                	jns    800844 <vprintfmt+0x177>
				width = precision, precision = -1;
  800832:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800835:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800838:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80083f:	e9 12 ff ff ff       	jmpq   800756 <vprintfmt+0x89>
  800844:	e9 0d ff ff ff       	jmpq   800756 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80084d:	e9 04 ff ff ff       	jmpq   800756 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800852:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800855:	83 f8 30             	cmp    $0x30,%eax
  800858:	73 17                	jae    800871 <vprintfmt+0x1a4>
  80085a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800861:	89 c0                	mov    %eax,%eax
  800863:	48 01 d0             	add    %rdx,%rax
  800866:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800869:	83 c2 08             	add    $0x8,%edx
  80086c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086f:	eb 0f                	jmp    800880 <vprintfmt+0x1b3>
  800871:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800875:	48 89 d0             	mov    %rdx,%rax
  800878:	48 83 c2 08          	add    $0x8,%rdx
  80087c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800880:	8b 10                	mov    (%rax),%edx
  800882:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800886:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088a:	48 89 ce             	mov    %rcx,%rsi
  80088d:	89 d7                	mov    %edx,%edi
  80088f:	ff d0                	callq  *%rax
			break;
  800891:	e9 40 03 00 00       	jmpq   800bd6 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800896:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800899:	83 f8 30             	cmp    $0x30,%eax
  80089c:	73 17                	jae    8008b5 <vprintfmt+0x1e8>
  80089e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ad:	83 c2 08             	add    $0x8,%edx
  8008b0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b3:	eb 0f                	jmp    8008c4 <vprintfmt+0x1f7>
  8008b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b9:	48 89 d0             	mov    %rdx,%rax
  8008bc:	48 83 c2 08          	add    $0x8,%rdx
  8008c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c6:	85 db                	test   %ebx,%ebx
  8008c8:	79 02                	jns    8008cc <vprintfmt+0x1ff>
				err = -err;
  8008ca:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008cc:	83 fb 15             	cmp    $0x15,%ebx
  8008cf:	7f 16                	jg     8008e7 <vprintfmt+0x21a>
  8008d1:	48 b8 c0 48 80 00 00 	movabs $0x8048c0,%rax
  8008d8:	00 00 00 
  8008db:	48 63 d3             	movslq %ebx,%rdx
  8008de:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e2:	4d 85 e4             	test   %r12,%r12
  8008e5:	75 2e                	jne    800915 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ef:	89 d9                	mov    %ebx,%ecx
  8008f1:	48 ba 81 49 80 00 00 	movabs $0x804981,%rdx
  8008f8:	00 00 00 
  8008fb:	48 89 c7             	mov    %rax,%rdi
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	49 b8 e5 0b 80 00 00 	movabs $0x800be5,%r8
  80090a:	00 00 00 
  80090d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800910:	e9 c1 02 00 00       	jmpq   800bd6 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800915:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800919:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091d:	4c 89 e1             	mov    %r12,%rcx
  800920:	48 ba 8a 49 80 00 00 	movabs $0x80498a,%rdx
  800927:	00 00 00 
  80092a:	48 89 c7             	mov    %rax,%rdi
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
  800932:	49 b8 e5 0b 80 00 00 	movabs $0x800be5,%r8
  800939:	00 00 00 
  80093c:	41 ff d0             	callq  *%r8
			break;
  80093f:	e9 92 02 00 00       	jmpq   800bd6 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800947:	83 f8 30             	cmp    $0x30,%eax
  80094a:	73 17                	jae    800963 <vprintfmt+0x296>
  80094c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800953:	89 c0                	mov    %eax,%eax
  800955:	48 01 d0             	add    %rdx,%rax
  800958:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095b:	83 c2 08             	add    $0x8,%edx
  80095e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x2a5>
  800963:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800967:	48 89 d0             	mov    %rdx,%rax
  80096a:	48 83 c2 08          	add    $0x8,%rdx
  80096e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800972:	4c 8b 20             	mov    (%rax),%r12
  800975:	4d 85 e4             	test   %r12,%r12
  800978:	75 0a                	jne    800984 <vprintfmt+0x2b7>
				p = "(null)";
  80097a:	49 bc 8d 49 80 00 00 	movabs $0x80498d,%r12
  800981:	00 00 00 
			if (width > 0 && padc != '-')
  800984:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800988:	7e 3f                	jle    8009c9 <vprintfmt+0x2fc>
  80098a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80098e:	74 39                	je     8009c9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800990:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800993:	48 98                	cltq   
  800995:	48 89 c6             	mov    %rax,%rsi
  800998:	4c 89 e7             	mov    %r12,%rdi
  80099b:	48 b8 91 0e 80 00 00 	movabs $0x800e91,%rax
  8009a2:	00 00 00 
  8009a5:	ff d0                	callq  *%rax
  8009a7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009aa:	eb 17                	jmp    8009c3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ac:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b8:	48 89 ce             	mov    %rcx,%rsi
  8009bb:	89 d7                	mov    %edx,%edi
  8009bd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c7:	7f e3                	jg     8009ac <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c9:	eb 37                	jmp    800a02 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009cf:	74 1e                	je     8009ef <vprintfmt+0x322>
  8009d1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d4:	7e 05                	jle    8009db <vprintfmt+0x30e>
  8009d6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d9:	7e 14                	jle    8009ef <vprintfmt+0x322>
					putch('?', putdat);
  8009db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e3:	48 89 d6             	mov    %rdx,%rsi
  8009e6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009eb:	ff d0                	callq  *%rax
  8009ed:	eb 0f                	jmp    8009fe <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f7:	48 89 d6             	mov    %rdx,%rsi
  8009fa:	89 df                	mov    %ebx,%edi
  8009fc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a02:	4c 89 e0             	mov    %r12,%rax
  800a05:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a09:	0f b6 00             	movzbl (%rax),%eax
  800a0c:	0f be d8             	movsbl %al,%ebx
  800a0f:	85 db                	test   %ebx,%ebx
  800a11:	74 10                	je     800a23 <vprintfmt+0x356>
  800a13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a17:	78 b2                	js     8009cb <vprintfmt+0x2fe>
  800a19:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a21:	79 a8                	jns    8009cb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a23:	eb 16                	jmp    800a3b <vprintfmt+0x36e>
				putch(' ', putdat);
  800a25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2d:	48 89 d6             	mov    %rdx,%rsi
  800a30:	bf 20 00 00 00       	mov    $0x20,%edi
  800a35:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3f:	7f e4                	jg     800a25 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a41:	e9 90 01 00 00       	jmpq   800bd6 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4a:	be 03 00 00 00       	mov    $0x3,%esi
  800a4f:	48 89 c7             	mov    %rax,%rdi
  800a52:	48 b8 bd 05 80 00 00 	movabs $0x8005bd,%rax
  800a59:	00 00 00 
  800a5c:	ff d0                	callq  *%rax
  800a5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	48 85 c0             	test   %rax,%rax
  800a69:	79 1d                	jns    800a88 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 d6             	mov    %rdx,%rsi
  800a76:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a7b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 f7 d8             	neg    %rax
  800a84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a88:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8f:	e9 d5 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a98:	be 03 00 00 00       	mov    $0x3,%esi
  800a9d:	48 89 c7             	mov    %rax,%rdi
  800aa0:	48 b8 ad 04 80 00 00 	movabs $0x8004ad,%rax
  800aa7:	00 00 00 
  800aaa:	ff d0                	callq  *%rax
  800aac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab7:	e9 ad 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800abc:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800abf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac3:	89 d6                	mov    %edx,%esi
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	48 b8 bd 05 80 00 00 	movabs $0x8005bd,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800adf:	e9 85 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ae4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aec:	48 89 d6             	mov    %rdx,%rsi
  800aef:	bf 30 00 00 00       	mov    $0x30,%edi
  800af4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afe:	48 89 d6             	mov    %rdx,%rsi
  800b01:	bf 78 00 00 00       	mov    $0x78,%edi
  800b06:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0b:	83 f8 30             	cmp    $0x30,%eax
  800b0e:	73 17                	jae    800b27 <vprintfmt+0x45a>
  800b10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b17:	89 c0                	mov    %eax,%eax
  800b19:	48 01 d0             	add    %rdx,%rax
  800b1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1f:	83 c2 08             	add    $0x8,%edx
  800b22:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b25:	eb 0f                	jmp    800b36 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2b:	48 89 d0             	mov    %rdx,%rax
  800b2e:	48 83 c2 08          	add    $0x8,%rdx
  800b32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b36:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b3d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b44:	eb 23                	jmp    800b69 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4a:	be 03 00 00 00       	mov    $0x3,%esi
  800b4f:	48 89 c7             	mov    %rax,%rdi
  800b52:	48 b8 ad 04 80 00 00 	movabs $0x8004ad,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	callq  *%rax
  800b5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b62:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b69:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b71:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b78:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	45 89 c1             	mov    %r8d,%r9d
  800b83:	41 89 f8             	mov    %edi,%r8d
  800b86:	48 89 c7             	mov    %rax,%rdi
  800b89:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  800b90:	00 00 00 
  800b93:	ff d0                	callq  *%rax
			break;
  800b95:	eb 3f                	jmp    800bd6 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9f:	48 89 d6             	mov    %rdx,%rsi
  800ba2:	89 df                	mov    %ebx,%edi
  800ba4:	ff d0                	callq  *%rax
			break;
  800ba6:	eb 2e                	jmp    800bd6 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb0:	48 89 d6             	mov    %rdx,%rsi
  800bb3:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bba:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bbf:	eb 05                	jmp    800bc6 <vprintfmt+0x4f9>
  800bc1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bca:	48 83 e8 01          	sub    $0x1,%rax
  800bce:	0f b6 00             	movzbl (%rax),%eax
  800bd1:	3c 25                	cmp    $0x25,%al
  800bd3:	75 ec                	jne    800bc1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bd5:	90                   	nop
		}
	}
  800bd6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd7:	e9 43 fb ff ff       	jmpq   80071f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bdc:	48 83 c4 60          	add    $0x60,%rsp
  800be0:	5b                   	pop    %rbx
  800be1:	41 5c                	pop    %r12
  800be3:	5d                   	pop    %rbp
  800be4:	c3                   	retq   

0000000000800be5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be5:	55                   	push   %rbp
  800be6:	48 89 e5             	mov    %rsp,%rbp
  800be9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bfe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c05:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c13:	84 c0                	test   %al,%al
  800c15:	74 20                	je     800c37 <printfmt+0x52>
  800c17:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c1f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c23:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c27:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c2f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c33:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c37:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c45:	00 00 00 
  800c48:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c4f:	00 00 00 
  800c52:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c56:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c5d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c64:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c72:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c79:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c80:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c87:	48 89 c7             	mov    %rax,%rdi
  800c8a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c96:	c9                   	leaveq 
  800c97:	c3                   	retq   

0000000000800c98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c98:	55                   	push   %rbp
  800c99:	48 89 e5             	mov    %rsp,%rbp
  800c9c:	48 83 ec 10          	sub    $0x10,%rsp
  800ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cab:	8b 40 10             	mov    0x10(%rax),%eax
  800cae:	8d 50 01             	lea    0x1(%rax),%edx
  800cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbc:	48 8b 10             	mov    (%rax),%rdx
  800cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc7:	48 39 c2             	cmp    %rax,%rdx
  800cca:	73 17                	jae    800ce3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ccc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd0:	48 8b 00             	mov    (%rax),%rax
  800cd3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdb:	48 89 0a             	mov    %rcx,(%rdx)
  800cde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce1:	88 10                	mov    %dl,(%rax)
}
  800ce3:	c9                   	leaveq 
  800ce4:	c3                   	retq   

0000000000800ce5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce5:	55                   	push   %rbp
  800ce6:	48 89 e5             	mov    %rsp,%rbp
  800ce9:	48 83 ec 50          	sub    $0x50,%rsp
  800ced:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d00:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d04:	48 8b 0a             	mov    (%rdx),%rcx
  800d07:	48 89 08             	mov    %rcx,(%rax)
  800d0a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d12:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d16:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d22:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d25:	48 98                	cltq   
  800d27:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2f:	48 01 d0             	add    %rdx,%rax
  800d32:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d3d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d42:	74 06                	je     800d4a <vsnprintf+0x65>
  800d44:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d48:	7f 07                	jg     800d51 <vsnprintf+0x6c>
		return -E_INVAL;
  800d4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4f:	eb 2f                	jmp    800d80 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d51:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d55:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d59:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d5d:	48 89 c6             	mov    %rax,%rsi
  800d60:	48 bf 98 0c 80 00 00 	movabs $0x800c98,%rdi
  800d67:	00 00 00 
  800d6a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d7a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d7d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d80:	c9                   	leaveq 
  800d81:	c3                   	retq   

0000000000800d82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d82:	55                   	push   %rbp
  800d83:	48 89 e5             	mov    %rsp,%rbp
  800d86:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d8d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d94:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d9a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800daf:	84 c0                	test   %al,%al
  800db1:	74 20                	je     800dd3 <snprintf+0x51>
  800db3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dbf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dcf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dda:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de1:	00 00 00 
  800de4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800deb:	00 00 00 
  800dee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800df9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e07:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e15:	48 8b 0a             	mov    (%rdx),%rcx
  800e18:	48 89 08             	mov    %rcx,(%rax)
  800e1b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e1f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e23:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e27:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e2b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e32:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e39:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e3f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e46:	48 89 c7             	mov    %rax,%rdi
  800e49:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800e50:	00 00 00 
  800e53:	ff d0                	callq  *%rax
  800e55:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e5b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e61:	c9                   	leaveq 
  800e62:	c3                   	retq   

0000000000800e63 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e63:	55                   	push   %rbp
  800e64:	48 89 e5             	mov    %rsp,%rbp
  800e67:	48 83 ec 18          	sub    $0x18,%rsp
  800e6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e76:	eb 09                	jmp    800e81 <strlen+0x1e>
		n++;
  800e78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	0f b6 00             	movzbl (%rax),%eax
  800e88:	84 c0                	test   %al,%al
  800e8a:	75 ec                	jne    800e78 <strlen+0x15>
		n++;
	return n;
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8f:	c9                   	leaveq 
  800e90:	c3                   	retq   

0000000000800e91 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e91:	55                   	push   %rbp
  800e92:	48 89 e5             	mov    %rsp,%rbp
  800e95:	48 83 ec 20          	sub    $0x20,%rsp
  800e99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea8:	eb 0e                	jmp    800eb8 <strnlen+0x27>
		n++;
  800eaa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ebd:	74 0b                	je     800eca <strnlen+0x39>
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	0f b6 00             	movzbl (%rax),%eax
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e0                	jne    800eaa <strnlen+0x19>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ecd:	c9                   	leaveq 
  800ece:	c3                   	retq   

0000000000800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 83 ec 20          	sub    $0x20,%rsp
  800ed7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee7:	90                   	nop
  800ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f00:	0f b6 12             	movzbl (%rdx),%edx
  800f03:	88 10                	mov    %dl,(%rax)
  800f05:	0f b6 00             	movzbl (%rax),%eax
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 dc                	jne    800ee8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f10:	c9                   	leaveq 
  800f11:	c3                   	retq   

0000000000800f12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f12:	55                   	push   %rbp
  800f13:	48 89 e5             	mov    %rsp,%rbp
  800f16:	48 83 ec 20          	sub    $0x20,%rsp
  800f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
  800f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3b:	48 63 d0             	movslq %eax,%rdx
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	48 01 c2             	add    %rax,%rdx
  800f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f49:	48 89 c6             	mov    %rax,%rsi
  800f4c:	48 89 d7             	mov    %rdx,%rdi
  800f4f:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
	return dst;
  800f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 83 ec 28          	sub    $0x28,%rsp
  800f69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f71:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f7d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f84:	00 
  800f85:	eb 2a                	jmp    800fb1 <strncpy+0x50>
		*dst++ = *src;
  800f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f93:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f97:	0f b6 12             	movzbl (%rdx),%edx
  800f9a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa0:	0f b6 00             	movzbl (%rax),%eax
  800fa3:	84 c0                	test   %al,%al
  800fa5:	74 05                	je     800fac <strncpy+0x4b>
			src++;
  800fa7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fb9:	72 cc                	jb     800f87 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 28          	sub    $0x28,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fdd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe2:	74 3d                	je     801021 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe4:	eb 1d                	jmp    801003 <strlcpy+0x42>
			*dst++ = *src++;
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ffa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ffe:	0f b6 12             	movzbl (%rdx),%edx
  801001:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801003:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801008:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100d:	74 0b                	je     80101a <strlcpy+0x59>
  80100f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	84 c0                	test   %al,%al
  801018:	75 cc                	jne    800fe6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80101a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801021:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	48 29 c2             	sub    %rax,%rdx
  80102c:	48 89 d0             	mov    %rdx,%rax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	48 83 ec 10          	sub    $0x10,%rsp
  801039:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801041:	eb 0a                	jmp    80104d <strcmp+0x1c>
		p++, q++;
  801043:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801048:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801051:	0f b6 00             	movzbl (%rax),%eax
  801054:	84 c0                	test   %al,%al
  801056:	74 12                	je     80106a <strcmp+0x39>
  801058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105c:	0f b6 10             	movzbl (%rax),%edx
  80105f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801063:	0f b6 00             	movzbl (%rax),%eax
  801066:	38 c2                	cmp    %al,%dl
  801068:	74 d9                	je     801043 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80106a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	0f b6 d0             	movzbl %al,%edx
  801074:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801078:	0f b6 00             	movzbl (%rax),%eax
  80107b:	0f b6 c0             	movzbl %al,%eax
  80107e:	29 c2                	sub    %eax,%edx
  801080:	89 d0                	mov    %edx,%eax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 18          	sub    $0x18,%rsp
  80108c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801090:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801094:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801098:	eb 0f                	jmp    8010a9 <strncmp+0x25>
		n--, p++, q++;
  80109a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80109f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ae:	74 1d                	je     8010cd <strncmp+0x49>
  8010b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	74 12                	je     8010cd <strncmp+0x49>
  8010bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bf:	0f b6 10             	movzbl (%rax),%edx
  8010c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	38 c2                	cmp    %al,%dl
  8010cb:	74 cd                	je     80109a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d2:	75 07                	jne    8010db <strncmp+0x57>
		return 0;
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d9:	eb 18                	jmp    8010f3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	0f b6 d0             	movzbl %al,%edx
  8010e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	0f b6 c0             	movzbl %al,%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leaveq 
  8010f4:	c3                   	retq   

00000000008010f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f5:	55                   	push   %rbp
  8010f6:	48 89 e5             	mov    %rsp,%rbp
  8010f9:	48 83 ec 0c          	sub    $0xc,%rsp
  8010fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801101:	89 f0                	mov    %esi,%eax
  801103:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801106:	eb 17                	jmp    80111f <strchr+0x2a>
		if (*s == c)
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110c:	0f b6 00             	movzbl (%rax),%eax
  80110f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801112:	75 06                	jne    80111a <strchr+0x25>
			return (char *) s;
  801114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801118:	eb 15                	jmp    80112f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	84 c0                	test   %al,%al
  801128:	75 de                	jne    801108 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80112a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112f:	c9                   	leaveq 
  801130:	c3                   	retq   

0000000000801131 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801131:	55                   	push   %rbp
  801132:	48 89 e5             	mov    %rsp,%rbp
  801135:	48 83 ec 0c          	sub    $0xc,%rsp
  801139:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113d:	89 f0                	mov    %esi,%eax
  80113f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801142:	eb 13                	jmp    801157 <strfind+0x26>
		if (*s == c)
  801144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80114e:	75 02                	jne    801152 <strfind+0x21>
			break;
  801150:	eb 10                	jmp    801162 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801152:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115b:	0f b6 00             	movzbl (%rax),%eax
  80115e:	84 c0                	test   %al,%al
  801160:	75 e2                	jne    801144 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801166:	c9                   	leaveq 
  801167:	c3                   	retq   

0000000000801168 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801168:	55                   	push   %rbp
  801169:	48 89 e5             	mov    %rsp,%rbp
  80116c:	48 83 ec 18          	sub    $0x18,%rsp
  801170:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801174:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801177:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80117b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801180:	75 06                	jne    801188 <memset+0x20>
		return v;
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	eb 69                	jmp    8011f1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	83 e0 03             	and    $0x3,%eax
  80118f:	48 85 c0             	test   %rax,%rax
  801192:	75 48                	jne    8011dc <memset+0x74>
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	83 e0 03             	and    $0x3,%eax
  80119b:	48 85 c0             	test   %rax,%rax
  80119e:	75 3c                	jne    8011dc <memset+0x74>
		c &= 0xFF;
  8011a0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011aa:	c1 e0 18             	shl    $0x18,%eax
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b2:	c1 e0 10             	shl    $0x10,%eax
  8011b5:	09 c2                	or     %eax,%edx
  8011b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ba:	c1 e0 08             	shl    $0x8,%eax
  8011bd:	09 d0                	or     %edx,%eax
  8011bf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	48 c1 e8 02          	shr    $0x2,%rax
  8011ca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d4:	48 89 d7             	mov    %rdx,%rdi
  8011d7:	fc                   	cld    
  8011d8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011da:	eb 11                	jmp    8011ed <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e7:	48 89 d7             	mov    %rdx,%rdi
  8011ea:	fc                   	cld    
  8011eb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f1:	c9                   	leaveq 
  8011f2:	c3                   	retq   

00000000008011f3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	48 83 ec 28          	sub    $0x28,%rsp
  8011fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801203:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80120f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801213:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80121f:	0f 83 88 00 00 00    	jae    8012ad <memmove+0xba>
  801225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801229:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122d:	48 01 d0             	add    %rdx,%rax
  801230:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801234:	76 77                	jbe    8012ad <memmove+0xba>
		s += n;
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80123e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801242:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124a:	83 e0 03             	and    $0x3,%eax
  80124d:	48 85 c0             	test   %rax,%rax
  801250:	75 3b                	jne    80128d <memmove+0x9a>
  801252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801256:	83 e0 03             	and    $0x3,%eax
  801259:	48 85 c0             	test   %rax,%rax
  80125c:	75 2f                	jne    80128d <memmove+0x9a>
  80125e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801262:	83 e0 03             	and    $0x3,%eax
  801265:	48 85 c0             	test   %rax,%rax
  801268:	75 23                	jne    80128d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	48 83 e8 04          	sub    $0x4,%rax
  801272:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801276:	48 83 ea 04          	sub    $0x4,%rdx
  80127a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80127e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801282:	48 89 c7             	mov    %rax,%rdi
  801285:	48 89 d6             	mov    %rdx,%rsi
  801288:	fd                   	std    
  801289:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80128b:	eb 1d                	jmp    8012aa <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801299:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80129d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a1:	48 89 d7             	mov    %rdx,%rdi
  8012a4:	48 89 c1             	mov    %rax,%rcx
  8012a7:	fd                   	std    
  8012a8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012aa:	fc                   	cld    
  8012ab:	eb 57                	jmp    801304 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	83 e0 03             	and    $0x3,%eax
  8012b4:	48 85 c0             	test   %rax,%rax
  8012b7:	75 36                	jne    8012ef <memmove+0xfc>
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bd:	83 e0 03             	and    $0x3,%eax
  8012c0:	48 85 c0             	test   %rax,%rax
  8012c3:	75 2a                	jne    8012ef <memmove+0xfc>
  8012c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c9:	83 e0 03             	and    $0x3,%eax
  8012cc:	48 85 c0             	test   %rax,%rax
  8012cf:	75 1e                	jne    8012ef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d5:	48 c1 e8 02          	shr    $0x2,%rax
  8012d9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e4:	48 89 c7             	mov    %rax,%rdi
  8012e7:	48 89 d6             	mov    %rdx,%rsi
  8012ea:	fc                   	cld    
  8012eb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ed:	eb 15                	jmp    801304 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012fb:	48 89 c7             	mov    %rax,%rdi
  8012fe:	48 89 d6             	mov    %rdx,%rsi
  801301:	fc                   	cld    
  801302:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 18          	sub    $0x18,%rsp
  801312:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801316:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80131a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80131e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801322:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132a:	48 89 ce             	mov    %rcx,%rsi
  80132d:	48 89 c7             	mov    %rax,%rdi
  801330:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 28          	sub    $0x28,%rsp
  801346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801356:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80135a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801362:	eb 36                	jmp    80139a <memcmp+0x5c>
		if (*s1 != *s2)
  801364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801368:	0f b6 10             	movzbl (%rax),%edx
  80136b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	38 c2                	cmp    %al,%dl
  801374:	74 1a                	je     801390 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	0f b6 d0             	movzbl %al,%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 c0             	movzbl %al,%eax
  80138a:	29 c2                	sub    %eax,%edx
  80138c:	89 d0                	mov    %edx,%eax
  80138e:	eb 20                	jmp    8013b0 <memcmp+0x72>
		s1++, s2++;
  801390:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801395:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80139a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a6:	48 85 c0             	test   %rax,%rax
  8013a9:	75 b9                	jne    801364 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b0:	c9                   	leaveq 
  8013b1:	c3                   	retq   

00000000008013b2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	48 83 ec 28          	sub    $0x28,%rsp
  8013ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013cd:	48 01 d0             	add    %rdx,%rax
  8013d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d4:	eb 15                	jmp    8013eb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013da:	0f b6 10             	movzbl (%rax),%edx
  8013dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	75 02                	jne    8013e6 <memfind+0x34>
			break;
  8013e4:	eb 0f                	jmp    8013f5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ef:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f3:	72 e1                	jb     8013d6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 34          	sub    $0x34,%rsp
  801403:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801407:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80140e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801415:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141d:	eb 05                	jmp    801424 <strtol+0x29>
		s++;
  80141f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	3c 20                	cmp    $0x20,%al
  80142d:	74 f0                	je     80141f <strtol+0x24>
  80142f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	3c 09                	cmp    $0x9,%al
  801438:	74 e5                	je     80141f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	3c 2b                	cmp    $0x2b,%al
  801443:	75 07                	jne    80144c <strtol+0x51>
		s++;
  801445:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144a:	eb 17                	jmp    801463 <strtol+0x68>
	else if (*s == '-')
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3c 2d                	cmp    $0x2d,%al
  801455:	75 0c                	jne    801463 <strtol+0x68>
		s++, neg = 1;
  801457:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801463:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801467:	74 06                	je     80146f <strtol+0x74>
  801469:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146d:	75 28                	jne    801497 <strtol+0x9c>
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	3c 30                	cmp    $0x30,%al
  801478:	75 1d                	jne    801497 <strtol+0x9c>
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	48 83 c0 01          	add    $0x1,%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	3c 78                	cmp    $0x78,%al
  801487:	75 0e                	jne    801497 <strtol+0x9c>
		s += 2, base = 16;
  801489:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80148e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801495:	eb 2c                	jmp    8014c3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801497:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149b:	75 19                	jne    8014b6 <strtol+0xbb>
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	3c 30                	cmp    $0x30,%al
  8014a6:	75 0e                	jne    8014b6 <strtol+0xbb>
		s++, base = 8;
  8014a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ad:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b4:	eb 0d                	jmp    8014c3 <strtol+0xc8>
	else if (base == 0)
  8014b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014ba:	75 07                	jne    8014c3 <strtol+0xc8>
		base = 10;
  8014bc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	3c 2f                	cmp    $0x2f,%al
  8014cc:	7e 1d                	jle    8014eb <strtol+0xf0>
  8014ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	3c 39                	cmp    $0x39,%al
  8014d7:	7f 12                	jg     8014eb <strtol+0xf0>
			dig = *s - '0';
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	83 e8 30             	sub    $0x30,%eax
  8014e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e9:	eb 4e                	jmp    801539 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	3c 60                	cmp    $0x60,%al
  8014f4:	7e 1d                	jle    801513 <strtol+0x118>
  8014f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fa:	0f b6 00             	movzbl (%rax),%eax
  8014fd:	3c 7a                	cmp    $0x7a,%al
  8014ff:	7f 12                	jg     801513 <strtol+0x118>
			dig = *s - 'a' + 10;
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	0f be c0             	movsbl %al,%eax
  80150b:	83 e8 57             	sub    $0x57,%eax
  80150e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801511:	eb 26                	jmp    801539 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 48                	jle    801566 <strtol+0x16b>
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	3c 5a                	cmp    $0x5a,%al
  801527:	7f 3d                	jg     801566 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f be c0             	movsbl %al,%eax
  801533:	83 e8 37             	sub    $0x37,%eax
  801536:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80153f:	7c 02                	jl     801543 <strtol+0x148>
			break;
  801541:	eb 23                	jmp    801566 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801543:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801548:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154b:	48 98                	cltq   
  80154d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801552:	48 89 c2             	mov    %rax,%rdx
  801555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801558:	48 98                	cltq   
  80155a:	48 01 d0             	add    %rdx,%rax
  80155d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801561:	e9 5d ff ff ff       	jmpq   8014c3 <strtol+0xc8>

	if (endptr)
  801566:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80156b:	74 0b                	je     801578 <strtol+0x17d>
		*endptr = (char *) s;
  80156d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801571:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801575:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80157c:	74 09                	je     801587 <strtol+0x18c>
  80157e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801582:	48 f7 d8             	neg    %rax
  801585:	eb 04                	jmp    80158b <strtol+0x190>
  801587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158b:	c9                   	leaveq 
  80158c:	c3                   	retq   

000000000080158d <strstr>:

char * strstr(const char *in, const char *str)
{
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	48 83 ec 30          	sub    $0x30,%rsp
  801595:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801599:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80159d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015af:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b3:	75 06                	jne    8015bb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	eb 6b                	jmp    801626 <strstr+0x99>

	len = strlen(str);
  8015bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bf:	48 89 c7             	mov    %rax,%rdi
  8015c2:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	callq  *%rax
  8015ce:	48 98                	cltq   
  8015d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ea:	75 07                	jne    8015f3 <strstr+0x66>
				return (char *) 0;
  8015ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f1:	eb 33                	jmp    801626 <strstr+0x99>
		} while (sc != c);
  8015f3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015f7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015fa:	75 d8                	jne    8015d4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801600:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	48 89 ce             	mov    %rcx,%rsi
  80160b:	48 89 c7             	mov    %rax,%rdi
  80160e:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  801615:	00 00 00 
  801618:	ff d0                	callq  *%rax
  80161a:	85 c0                	test   %eax,%eax
  80161c:	75 b6                	jne    8015d4 <strstr+0x47>

	return (char *) (in - 1);
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	48 83 e8 01          	sub    $0x1,%rax
}
  801626:	c9                   	leaveq 
  801627:	c3                   	retq   

0000000000801628 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	53                   	push   %rbx
  80162d:	48 83 ec 48          	sub    $0x48,%rsp
  801631:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801634:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801637:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80163f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801643:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801647:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80164e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801652:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801656:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80165e:	4c 89 c3             	mov    %r8,%rbx
  801661:	cd 30                	int    $0x30
  801663:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801667:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166b:	74 3e                	je     8016ab <syscall+0x83>
  80166d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801672:	7e 37                	jle    8016ab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801678:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167b:	49 89 d0             	mov    %rdx,%r8
  80167e:	89 c1                	mov    %eax,%ecx
  801680:	48 ba 48 4c 80 00 00 	movabs $0x804c48,%rdx
  801687:	00 00 00 
  80168a:	be 23 00 00 00       	mov    $0x23,%esi
  80168f:	48 bf 65 4c 80 00 00 	movabs $0x804c65,%rdi
  801696:	00 00 00 
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	49 b9 47 44 80 00 00 	movabs $0x804447,%r9
  8016a5:	00 00 00 
  8016a8:	41 ff d1             	callq  *%r9

	return ret;
  8016ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016af:	48 83 c4 48          	add    $0x48,%rsp
  8016b3:	5b                   	pop    %rbx
  8016b4:	5d                   	pop    %rbp
  8016b5:	c3                   	retq   

00000000008016b6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016b6:	55                   	push   %rbp
  8016b7:	48 89 e5             	mov    %rsp,%rbp
  8016ba:	48 83 ec 20          	sub    $0x20,%rsp
  8016be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d5:	00 
  8016d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e2:	48 89 d1             	mov    %rdx,%rcx
  8016e5:	48 89 c2             	mov    %rax,%rdx
  8016e8:	be 00 00 00 00       	mov    $0x0,%esi
  8016ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f2:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
}
  8016fe:	c9                   	leaveq 
  8016ff:	c3                   	retq   

0000000000801700 <sys_cgetc>:

int
sys_cgetc(void)
{
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801708:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80170f:	00 
  801710:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801716:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801721:	ba 00 00 00 00       	mov    $0x0,%edx
  801726:	be 00 00 00 00       	mov    $0x0,%esi
  80172b:	bf 01 00 00 00       	mov    $0x1,%edi
  801730:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801737:	00 00 00 
  80173a:	ff d0                	callq  *%rax
}
  80173c:	c9                   	leaveq 
  80173d:	c3                   	retq   

000000000080173e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80173e:	55                   	push   %rbp
  80173f:	48 89 e5             	mov    %rsp,%rbp
  801742:	48 83 ec 10          	sub    $0x10,%rsp
  801746:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801749:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174c:	48 98                	cltq   
  80174e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801755:	00 
  801756:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	48 89 c2             	mov    %rax,%rdx
  80176a:	be 01 00 00 00       	mov    $0x1,%esi
  80176f:	bf 03 00 00 00       	mov    $0x3,%edi
  801774:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
}
  801780:	c9                   	leaveq 
  801781:	c3                   	retq   

0000000000801782 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801782:	55                   	push   %rbp
  801783:	48 89 e5             	mov    %rsp,%rbp
  801786:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801791:	00 
  801792:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801798:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a8:	be 00 00 00 00       	mov    $0x0,%esi
  8017ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b2:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	callq  *%rax
}
  8017be:	c9                   	leaveq 
  8017bf:	c3                   	retq   

00000000008017c0 <sys_yield>:

void
sys_yield(void)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cf:	00 
  8017d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	be 00 00 00 00       	mov    $0x0,%esi
  8017eb:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f0:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
}
  8017fc:	c9                   	leaveq 
  8017fd:	c3                   	retq   

00000000008017fe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017fe:	55                   	push   %rbp
  8017ff:	48 89 e5             	mov    %rsp,%rbp
  801802:	48 83 ec 20          	sub    $0x20,%rsp
  801806:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801809:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801810:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801813:	48 63 c8             	movslq %eax,%rcx
  801816:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181d:	48 98                	cltq   
  80181f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801826:	00 
  801827:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182d:	49 89 c8             	mov    %rcx,%r8
  801830:	48 89 d1             	mov    %rdx,%rcx
  801833:	48 89 c2             	mov    %rax,%rdx
  801836:	be 01 00 00 00       	mov    $0x1,%esi
  80183b:	bf 04 00 00 00       	mov    $0x4,%edi
  801840:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801847:	00 00 00 
  80184a:	ff d0                	callq  *%rax
}
  80184c:	c9                   	leaveq 
  80184d:	c3                   	retq   

000000000080184e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80184e:	55                   	push   %rbp
  80184f:	48 89 e5             	mov    %rsp,%rbp
  801852:	48 83 ec 30          	sub    $0x30,%rsp
  801856:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801859:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801860:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801864:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801868:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186b:	48 63 c8             	movslq %eax,%rcx
  80186e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801872:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801875:	48 63 f0             	movslq %eax,%rsi
  801878:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187f:	48 98                	cltq   
  801881:	48 89 0c 24          	mov    %rcx,(%rsp)
  801885:	49 89 f9             	mov    %rdi,%r9
  801888:	49 89 f0             	mov    %rsi,%r8
  80188b:	48 89 d1             	mov    %rdx,%rcx
  80188e:	48 89 c2             	mov    %rax,%rdx
  801891:	be 01 00 00 00       	mov    $0x1,%esi
  801896:	bf 05 00 00 00       	mov    $0x5,%edi
  80189b:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8018a2:	00 00 00 
  8018a5:	ff d0                	callq  *%rax
}
  8018a7:	c9                   	leaveq 
  8018a8:	c3                   	retq   

00000000008018a9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018a9:	55                   	push   %rbp
  8018aa:	48 89 e5             	mov    %rsp,%rbp
  8018ad:	48 83 ec 20          	sub    $0x20,%rsp
  8018b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bf:	48 98                	cltq   
  8018c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c8:	00 
  8018c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d5:	48 89 d1             	mov    %rdx,%rcx
  8018d8:	48 89 c2             	mov    %rax,%rdx
  8018db:	be 01 00 00 00       	mov    $0x1,%esi
  8018e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8018e5:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	callq  *%rax
}
  8018f1:	c9                   	leaveq 
  8018f2:	c3                   	retq   

00000000008018f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
  8018f7:	48 83 ec 10          	sub    $0x10,%rsp
  8018fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801904:	48 63 d0             	movslq %eax,%rdx
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	48 98                	cltq   
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	48 89 d1             	mov    %rdx,%rcx
  801923:	48 89 c2             	mov    %rax,%rdx
  801926:	be 01 00 00 00       	mov    $0x1,%esi
  80192b:	bf 08 00 00 00       	mov    $0x8,%edi
  801930:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
}
  80193c:	c9                   	leaveq 
  80193d:	c3                   	retq   

000000000080193e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	48 83 ec 20          	sub    $0x20,%rsp
  801946:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801949:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80194d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801954:	48 98                	cltq   
  801956:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195d:	00 
  80195e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801964:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196a:	48 89 d1             	mov    %rdx,%rcx
  80196d:	48 89 c2             	mov    %rax,%rdx
  801970:	be 01 00 00 00       	mov    $0x1,%esi
  801975:	bf 09 00 00 00       	mov    $0x9,%edi
  80197a:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801981:	00 00 00 
  801984:	ff d0                	callq  *%rax
}
  801986:	c9                   	leaveq 
  801987:	c3                   	retq   

0000000000801988 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	48 83 ec 20          	sub    $0x20,%rsp
  801990:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801993:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801997:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199e:	48 98                	cltq   
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	48 89 d1             	mov    %rdx,%rcx
  8019b7:	48 89 c2             	mov    %rax,%rdx
  8019ba:	be 01 00 00 00       	mov    $0x1,%esi
  8019bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c4:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 20          	sub    $0x20,%rsp
  8019da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019e5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019eb:	48 63 f0             	movslq %eax,%rsi
  8019ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f5:	48 98                	cltq   
  8019f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a02:	00 
  801a03:	49 89 f1             	mov    %rsi,%r9
  801a06:	49 89 c8             	mov    %rcx,%r8
  801a09:	48 89 d1             	mov    %rdx,%rcx
  801a0c:	48 89 c2             	mov    %rax,%rdx
  801a0f:	be 00 00 00 00       	mov    $0x0,%esi
  801a14:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a19:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 10          	sub    $0x10,%rsp
  801a2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3e:	00 
  801a3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a50:	48 89 c2             	mov    %rax,%rdx
  801a53:	be 01 00 00 00       	mov    $0x1,%esi
  801a58:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a5d:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	callq  *%rax
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
  801a6f:	48 83 ec 20          	sub    $0x20,%rsp
  801a73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a83:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8a:	00 
  801a8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a97:	48 89 d1             	mov    %rdx,%rcx
  801a9a:	48 89 c2             	mov    %rax,%rdx
  801a9d:	be 01 00 00 00       	mov    $0x1,%esi
  801aa2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801aa7:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801aae:	00 00 00 
  801ab1:	ff d0                	callq  *%rax
}
  801ab3:	c9                   	leaveq 
  801ab4:	c3                   	retq   

0000000000801ab5 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801ab5:	55                   	push   %rbp
  801ab6:	48 89 e5             	mov    %rsp,%rbp
  801ab9:	48 83 ec 10          	sub    $0x10,%rsp
  801abd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acc:	00 
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ade:	48 89 c2             	mov    %rax,%rdx
  801ae1:	be 00 00 00 00       	mov    $0x0,%esi
  801ae6:	bf 10 00 00 00       	mov    $0x10,%edi
  801aeb:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801af2:	00 00 00 
  801af5:	ff d0                	callq  *%rax
}
  801af7:	c9                   	leaveq 
  801af8:	c3                   	retq   

0000000000801af9 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b08:	00 
  801b09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b15:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1f:	be 00 00 00 00       	mov    $0x0,%esi
  801b24:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b29:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   

0000000000801b37 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b37:	55                   	push   %rbp
  801b38:	48 89 e5             	mov    %rsp,%rbp
  801b3b:	48 83 ec 30          	sub    $0x30,%rsp
  801b3f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b47:	48 8b 00             	mov    (%rax),%rax
  801b4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b52:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b56:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b59:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b5c:	83 e0 02             	and    $0x2,%eax
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	75 4d                	jne    801bb0 <pgfault+0x79>
  801b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b67:	48 c1 e8 0c          	shr    $0xc,%rax
  801b6b:	48 89 c2             	mov    %rax,%rdx
  801b6e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b75:	01 00 00 
  801b78:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b7c:	25 00 08 00 00       	and    $0x800,%eax
  801b81:	48 85 c0             	test   %rax,%rax
  801b84:	74 2a                	je     801bb0 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801b86:	48 ba 78 4c 80 00 00 	movabs $0x804c78,%rdx
  801b8d:	00 00 00 
  801b90:	be 23 00 00 00       	mov    $0x23,%esi
  801b95:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801b9c:	00 00 00 
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801bab:	00 00 00 
  801bae:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801bb0:	ba 07 00 00 00       	mov    $0x7,%edx
  801bb5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bba:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbf:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  801bc6:	00 00 00 
  801bc9:	ff d0                	callq  *%rax
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	0f 85 cd 00 00 00    	jne    801ca0 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801be5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801be9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bed:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf2:	48 89 c6             	mov    %rax,%rsi
  801bf5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bfa:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c10:	48 89 c1             	mov    %rax,%rcx
  801c13:	ba 00 00 00 00       	mov    $0x0,%edx
  801c18:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c22:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	callq  *%rax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	79 2a                	jns    801c5c <pgfault+0x125>
				panic("Page map at temp address failed");
  801c32:	48 ba b8 4c 80 00 00 	movabs $0x804cb8,%rdx
  801c39:	00 00 00 
  801c3c:	be 30 00 00 00       	mov    $0x30,%esi
  801c41:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801c48:	00 00 00 
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801c57:	00 00 00 
  801c5a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c5c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c61:	bf 00 00 00 00       	mov    $0x0,%edi
  801c66:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  801c6d:	00 00 00 
  801c70:	ff d0                	callq  *%rax
  801c72:	85 c0                	test   %eax,%eax
  801c74:	79 54                	jns    801cca <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c76:	48 ba d8 4c 80 00 00 	movabs $0x804cd8,%rdx
  801c7d:	00 00 00 
  801c80:	be 32 00 00 00       	mov    $0x32,%esi
  801c85:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801c8c:	00 00 00 
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801c9b:	00 00 00 
  801c9e:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801ca0:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  801ca7:	00 00 00 
  801caa:	be 34 00 00 00       	mov    $0x34,%esi
  801caf:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801cb6:	00 00 00 
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801cc5:	00 00 00 
  801cc8:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 20          	sub    $0x20,%rsp
  801cd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cd7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cda:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ce1:	01 00 00 
  801ce4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ce7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ceb:	25 07 0e 00 00       	and    $0xe07,%eax
  801cf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801cf3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801cf6:	48 c1 e0 0c          	shl    $0xc,%rax
  801cfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d01:	25 00 04 00 00       	and    $0x400,%eax
  801d06:	85 c0                	test   %eax,%eax
  801d08:	74 57                	je     801d61 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d0a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d0d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d11:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d18:	41 89 f0             	mov    %esi,%r8d
  801d1b:	48 89 c6             	mov    %rax,%rsi
  801d1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d23:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801d2a:	00 00 00 
  801d2d:	ff d0                	callq  *%rax
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	0f 8e 52 01 00 00    	jle    801e89 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d37:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801d3e:	00 00 00 
  801d41:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d46:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801d4d:	00 00 00 
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801d5c:	00 00 00 
  801d5f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d64:	83 e0 02             	and    $0x2,%eax
  801d67:	85 c0                	test   %eax,%eax
  801d69:	75 10                	jne    801d7b <duppage+0xaf>
  801d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6e:	25 00 08 00 00       	and    $0x800,%eax
  801d73:	85 c0                	test   %eax,%eax
  801d75:	0f 84 bb 00 00 00    	je     801e36 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7e:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d83:	80 cc 08             	or     $0x8,%ah
  801d86:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d89:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d8c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d90:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d97:	41 89 f0             	mov    %esi,%r8d
  801d9a:	48 89 c6             	mov    %rax,%rsi
  801d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801da2:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
  801dae:	85 c0                	test   %eax,%eax
  801db0:	7e 2a                	jle    801ddc <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801db2:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801db9:	00 00 00 
  801dbc:	be 55 00 00 00       	mov    $0x55,%esi
  801dc1:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801dc8:	00 00 00 
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801dd7:	00 00 00 
  801dda:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ddc:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ddf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de7:	41 89 c8             	mov    %ecx,%r8d
  801dea:	48 89 d1             	mov    %rdx,%rcx
  801ded:	ba 00 00 00 00       	mov    $0x0,%edx
  801df2:	48 89 c6             	mov    %rax,%rsi
  801df5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dfa:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801e01:	00 00 00 
  801e04:	ff d0                	callq  *%rax
  801e06:	85 c0                	test   %eax,%eax
  801e08:	7e 2a                	jle    801e34 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e0a:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801e11:	00 00 00 
  801e14:	be 57 00 00 00       	mov    $0x57,%esi
  801e19:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801e20:	00 00 00 
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801e2f:	00 00 00 
  801e32:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e34:	eb 53                	jmp    801e89 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e36:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e39:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e44:	41 89 f0             	mov    %esi,%r8d
  801e47:	48 89 c6             	mov    %rax,%rsi
  801e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4f:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	7e 2a                	jle    801e89 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e5f:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801e66:	00 00 00 
  801e69:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e6e:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801e75:	00 00 00 
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  801e84:	00 00 00 
  801e87:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8e:	c9                   	leaveq 
  801e8f:	c3                   	retq   

0000000000801e90 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	48 83 ec 18          	sub    $0x18,%rsp
  801e98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea8:	48 c1 e8 27          	shr    $0x27,%rax
  801eac:	48 89 c2             	mov    %rax,%rdx
  801eaf:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801eb6:	01 00 00 
  801eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebd:	83 e0 01             	and    $0x1,%eax
  801ec0:	48 85 c0             	test   %rax,%rax
  801ec3:	74 51                	je     801f16 <pt_is_mapped+0x86>
  801ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec9:	48 c1 e0 0c          	shl    $0xc,%rax
  801ecd:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed1:	48 89 c2             	mov    %rax,%rdx
  801ed4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801edb:	01 00 00 
  801ede:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee2:	83 e0 01             	and    $0x1,%eax
  801ee5:	48 85 c0             	test   %rax,%rax
  801ee8:	74 2c                	je     801f16 <pt_is_mapped+0x86>
  801eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eee:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef2:	48 c1 e8 15          	shr    $0x15,%rax
  801ef6:	48 89 c2             	mov    %rax,%rdx
  801ef9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f00:	01 00 00 
  801f03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f07:	83 e0 01             	and    $0x1,%eax
  801f0a:	48 85 c0             	test   %rax,%rax
  801f0d:	74 07                	je     801f16 <pt_is_mapped+0x86>
  801f0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f14:	eb 05                	jmp    801f1b <pt_is_mapped+0x8b>
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	83 e0 01             	and    $0x1,%eax
}
  801f1e:	c9                   	leaveq 
  801f1f:	c3                   	retq   

0000000000801f20 <fork>:

envid_t
fork(void)
{
  801f20:	55                   	push   %rbp
  801f21:	48 89 e5             	mov    %rsp,%rbp
  801f24:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f28:	48 bf 37 1b 80 00 00 	movabs $0x801b37,%rdi
  801f2f:	00 00 00 
  801f32:	48 b8 5b 45 80 00 00 	movabs $0x80455b,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f3e:	b8 07 00 00 00       	mov    $0x7,%eax
  801f43:	cd 30                	int    $0x30
  801f45:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f4b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f52:	79 30                	jns    801f84 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f57:	89 c1                	mov    %eax,%ecx
  801f59:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  801f60:	00 00 00 
  801f63:	be 86 00 00 00       	mov    $0x86,%esi
  801f68:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801f6f:	00 00 00 
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	49 b8 47 44 80 00 00 	movabs $0x804447,%r8
  801f7e:	00 00 00 
  801f81:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801f84:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f88:	75 46                	jne    801fd0 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801f8a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	callq  *%rax
  801f96:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f9b:	48 63 d0             	movslq %eax,%rdx
  801f9e:	48 89 d0             	mov    %rdx,%rax
  801fa1:	48 c1 e0 03          	shl    $0x3,%rax
  801fa5:	48 01 d0             	add    %rdx,%rax
  801fa8:	48 c1 e0 05          	shl    $0x5,%rax
  801fac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fb3:	00 00 00 
  801fb6:	48 01 c2             	add    %rax,%rdx
  801fb9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fc0:	00 00 00 
  801fc3:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	e9 d1 01 00 00       	jmpq   8021a1 <fork+0x281>
	}
	uint64_t ad = 0;
  801fd0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fd7:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801fd8:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fe1:	e9 df 00 00 00       	jmpq   8020c5 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fea:	48 c1 e8 27          	shr    $0x27,%rax
  801fee:	48 89 c2             	mov    %rax,%rdx
  801ff1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ff8:	01 00 00 
  801ffb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fff:	83 e0 01             	and    $0x1,%eax
  802002:	48 85 c0             	test   %rax,%rax
  802005:	0f 84 9e 00 00 00    	je     8020a9 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80200b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802013:	48 89 c2             	mov    %rax,%rdx
  802016:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80201d:	01 00 00 
  802020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802024:	83 e0 01             	and    $0x1,%eax
  802027:	48 85 c0             	test   %rax,%rax
  80202a:	74 73                	je     80209f <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80202c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802030:	48 c1 e8 15          	shr    $0x15,%rax
  802034:	48 89 c2             	mov    %rax,%rdx
  802037:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80203e:	01 00 00 
  802041:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802045:	83 e0 01             	and    $0x1,%eax
  802048:	48 85 c0             	test   %rax,%rax
  80204b:	74 48                	je     802095 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80204d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802051:	48 c1 e8 0c          	shr    $0xc,%rax
  802055:	48 89 c2             	mov    %rax,%rdx
  802058:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80205f:	01 00 00 
  802062:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80206a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206e:	83 e0 01             	and    $0x1,%eax
  802071:	48 85 c0             	test   %rax,%rax
  802074:	74 47                	je     8020bd <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207a:	48 c1 e8 0c          	shr    $0xc,%rax
  80207e:	89 c2                	mov    %eax,%edx
  802080:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802083:	89 d6                	mov    %edx,%esi
  802085:	89 c7                	mov    %eax,%edi
  802087:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80208e:	00 00 00 
  802091:	ff d0                	callq  *%rax
  802093:	eb 28                	jmp    8020bd <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802095:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80209c:	00 
  80209d:	eb 1e                	jmp    8020bd <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80209f:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020a6:	40 
  8020a7:	eb 14                	jmp    8020bd <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ad:	48 c1 e8 27          	shr    $0x27,%rax
  8020b1:	48 83 c0 01          	add    $0x1,%rax
  8020b5:	48 c1 e0 27          	shl    $0x27,%rax
  8020b9:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020bd:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020c4:	00 
  8020c5:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020cc:	00 
  8020cd:	0f 87 13 ff ff ff    	ja     801fe6 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d6:	ba 07 00 00 00       	mov    $0x7,%edx
  8020db:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020e0:	89 c7                	mov    %eax,%edi
  8020e2:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f1:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f6:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020fb:	89 c7                	mov    %eax,%edi
  8020fd:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802109:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802112:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802117:	ba 00 00 00 00       	mov    $0x0,%edx
  80211c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802121:	89 c7                	mov    %eax,%edi
  802123:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80212f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802134:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802139:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80213e:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80214a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802160:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802167:	00 00 00 
  80216a:	48 8b 00             	mov    (%rax),%rax
  80216d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802174:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802177:	48 89 d6             	mov    %rdx,%rsi
  80217a:	89 c7                	mov    %eax,%edi
  80217c:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802188:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80218b:	be 02 00 00 00       	mov    $0x2,%esi
  802190:	89 c7                	mov    %eax,%edi
  802192:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax

	return envid;
  80219e:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021a1:	c9                   	leaveq 
  8021a2:	c3                   	retq   

00000000008021a3 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021a3:	55                   	push   %rbp
  8021a4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021a7:	48 ba 68 4d 80 00 00 	movabs $0x804d68,%rdx
  8021ae:	00 00 00 
  8021b1:	be bf 00 00 00       	mov    $0xbf,%esi
  8021b6:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  8021bd:	00 00 00 
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  8021cc:	00 00 00 
  8021cf:	ff d1                	callq  *%rcx

00000000008021d1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d1:	55                   	push   %rbp
  8021d2:	48 89 e5             	mov    %rsp,%rbp
  8021d5:	48 83 ec 30          	sub    $0x30,%rsp
  8021d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8021e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ec:	00 00 00 
  8021ef:	48 8b 00             	mov    (%rax),%rax
  8021f2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 3c                	jne    802238 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8021fc:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax
  802208:	25 ff 03 00 00       	and    $0x3ff,%eax
  80220d:	48 63 d0             	movslq %eax,%rdx
  802210:	48 89 d0             	mov    %rdx,%rax
  802213:	48 c1 e0 03          	shl    $0x3,%rax
  802217:	48 01 d0             	add    %rdx,%rax
  80221a:	48 c1 e0 05          	shl    $0x5,%rax
  80221e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802225:	00 00 00 
  802228:	48 01 c2             	add    %rax,%rdx
  80222b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802232:	00 00 00 
  802235:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802238:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80223d:	75 0e                	jne    80224d <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80223f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802246:	00 00 00 
  802249:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80224d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802251:	48 89 c7             	mov    %rax,%rdi
  802254:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	callq  *%rax
  802260:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802267:	79 19                	jns    802282 <ipc_recv+0xb1>
		*from_env_store = 0;
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802273:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802277:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80227d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802280:	eb 53                	jmp    8022d5 <ipc_recv+0x104>
	}
	if(from_env_store)
  802282:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802287:	74 19                	je     8022a2 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802289:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802290:	00 00 00 
  802293:	48 8b 00             	mov    (%rax),%rax
  802296:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80229c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a0:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8022a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022a7:	74 19                	je     8022c2 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8022a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022b0:	00 00 00 
  8022b3:	48 8b 00             	mov    (%rax),%rax
  8022b6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c0:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8022c2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022c9:	00 00 00 
  8022cc:	48 8b 00             	mov    (%rax),%rax
  8022cf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8022d5:	c9                   	leaveq 
  8022d6:	c3                   	retq   

00000000008022d7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022d7:	55                   	push   %rbp
  8022d8:	48 89 e5             	mov    %rsp,%rbp
  8022db:	48 83 ec 30          	sub    $0x30,%rsp
  8022df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022e5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022e9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8022ec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022f1:	75 0e                	jne    802301 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8022f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022fa:	00 00 00 
  8022fd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802301:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802304:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802307:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80230b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80230e:	89 c7                	mov    %eax,%edi
  802310:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  802317:	00 00 00 
  80231a:	ff d0                	callq  *%rax
  80231c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80231f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802323:	75 0c                	jne    802331 <ipc_send+0x5a>
			sys_yield();
  802325:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802331:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802335:	74 ca                	je     802301 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 14          	sub    $0x14,%rsp
  802341:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80234b:	eb 5e                	jmp    8023ab <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80234d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802354:	00 00 00 
  802357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235a:	48 63 d0             	movslq %eax,%rdx
  80235d:	48 89 d0             	mov    %rdx,%rax
  802360:	48 c1 e0 03          	shl    $0x3,%rax
  802364:	48 01 d0             	add    %rdx,%rax
  802367:	48 c1 e0 05          	shl    $0x5,%rax
  80236b:	48 01 c8             	add    %rcx,%rax
  80236e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802374:	8b 00                	mov    (%rax),%eax
  802376:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802379:	75 2c                	jne    8023a7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80237b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802382:	00 00 00 
  802385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802388:	48 63 d0             	movslq %eax,%rdx
  80238b:	48 89 d0             	mov    %rdx,%rax
  80238e:	48 c1 e0 03          	shl    $0x3,%rax
  802392:	48 01 d0             	add    %rdx,%rax
  802395:	48 c1 e0 05          	shl    $0x5,%rax
  802399:	48 01 c8             	add    %rcx,%rax
  80239c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8023a2:	8b 40 08             	mov    0x8(%rax),%eax
  8023a5:	eb 12                	jmp    8023b9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8023a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ab:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023b2:	7e 99                	jle    80234d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b9:	c9                   	leaveq 
  8023ba:	c3                   	retq   

00000000008023bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023bb:	55                   	push   %rbp
  8023bc:	48 89 e5             	mov    %rsp,%rbp
  8023bf:	48 83 ec 08          	sub    $0x8,%rsp
  8023c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023cb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023d2:	ff ff ff 
  8023d5:	48 01 d0             	add    %rdx,%rax
  8023d8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023dc:	c9                   	leaveq 
  8023dd:	c3                   	retq   

00000000008023de <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023de:	55                   	push   %rbp
  8023df:	48 89 e5             	mov    %rsp,%rbp
  8023e2:	48 83 ec 08          	sub    $0x8,%rsp
  8023e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ee:	48 89 c7             	mov    %rax,%rdi
  8023f1:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802403:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802407:	c9                   	leaveq 
  802408:	c3                   	retq   

0000000000802409 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	48 83 ec 18          	sub    $0x18,%rsp
  802411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802415:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80241c:	eb 6b                	jmp    802489 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80241e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802421:	48 98                	cltq   
  802423:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802429:	48 c1 e0 0c          	shl    $0xc,%rax
  80242d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802435:	48 c1 e8 15          	shr    $0x15,%rax
  802439:	48 89 c2             	mov    %rax,%rdx
  80243c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802443:	01 00 00 
  802446:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244a:	83 e0 01             	and    $0x1,%eax
  80244d:	48 85 c0             	test   %rax,%rax
  802450:	74 21                	je     802473 <fd_alloc+0x6a>
  802452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802456:	48 c1 e8 0c          	shr    $0xc,%rax
  80245a:	48 89 c2             	mov    %rax,%rdx
  80245d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802464:	01 00 00 
  802467:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246b:	83 e0 01             	and    $0x1,%eax
  80246e:	48 85 c0             	test   %rax,%rax
  802471:	75 12                	jne    802485 <fd_alloc+0x7c>
			*fd_store = fd;
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80247b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
  802483:	eb 1a                	jmp    80249f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802485:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802489:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80248d:	7e 8f                	jle    80241e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80248f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802493:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80249a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80249f:	c9                   	leaveq 
  8024a0:	c3                   	retq   

00000000008024a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024a1:	55                   	push   %rbp
  8024a2:	48 89 e5             	mov    %rsp,%rbp
  8024a5:	48 83 ec 20          	sub    $0x20,%rsp
  8024a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024b4:	78 06                	js     8024bc <fd_lookup+0x1b>
  8024b6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024ba:	7e 07                	jle    8024c3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c1:	eb 6c                	jmp    80252f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c6:	48 98                	cltq   
  8024c8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ce:	48 c1 e0 0c          	shl    $0xc,%rax
  8024d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024da:	48 c1 e8 15          	shr    $0x15,%rax
  8024de:	48 89 c2             	mov    %rax,%rdx
  8024e1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e8:	01 00 00 
  8024eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ef:	83 e0 01             	and    $0x1,%eax
  8024f2:	48 85 c0             	test   %rax,%rax
  8024f5:	74 21                	je     802518 <fd_lookup+0x77>
  8024f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ff:	48 89 c2             	mov    %rax,%rdx
  802502:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802509:	01 00 00 
  80250c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802510:	83 e0 01             	and    $0x1,%eax
  802513:	48 85 c0             	test   %rax,%rax
  802516:	75 07                	jne    80251f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802518:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80251d:	eb 10                	jmp    80252f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80251f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802523:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802527:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80252a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252f:	c9                   	leaveq 
  802530:	c3                   	retq   

0000000000802531 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802531:	55                   	push   %rbp
  802532:	48 89 e5             	mov    %rsp,%rbp
  802535:	48 83 ec 30          	sub    $0x30,%rsp
  802539:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80253d:	89 f0                	mov    %esi,%eax
  80253f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802546:	48 89 c7             	mov    %rax,%rdi
  802549:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
  802555:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802559:	48 89 d6             	mov    %rdx,%rsi
  80255c:	89 c7                	mov    %eax,%edi
  80255e:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  802565:	00 00 00 
  802568:	ff d0                	callq  *%rax
  80256a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802571:	78 0a                	js     80257d <fd_close+0x4c>
	    || fd != fd2)
  802573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802577:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80257b:	74 12                	je     80258f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80257d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802581:	74 05                	je     802588 <fd_close+0x57>
  802583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802586:	eb 05                	jmp    80258d <fd_close+0x5c>
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	eb 69                	jmp    8025f8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80258f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802593:	8b 00                	mov    (%rax),%eax
  802595:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802599:	48 89 d6             	mov    %rdx,%rsi
  80259c:	89 c7                	mov    %eax,%edi
  80259e:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8025a5:	00 00 00 
  8025a8:	ff d0                	callq  *%rax
  8025aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b1:	78 2a                	js     8025dd <fd_close+0xac>
		if (dev->dev_close)
  8025b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025bb:	48 85 c0             	test   %rax,%rax
  8025be:	74 16                	je     8025d6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025cc:	48 89 d7             	mov    %rdx,%rdi
  8025cf:	ff d0                	callq  *%rax
  8025d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d4:	eb 07                	jmp    8025dd <fd_close+0xac>
		else
			r = 0;
  8025d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e1:	48 89 c6             	mov    %rax,%rsi
  8025e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e9:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8025f0:	00 00 00 
  8025f3:	ff d0                	callq  *%rax
	return r;
  8025f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025f8:	c9                   	leaveq 
  8025f9:	c3                   	retq   

00000000008025fa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	48 83 ec 20          	sub    $0x20,%rsp
  802602:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802605:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802610:	eb 41                	jmp    802653 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802612:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802619:	00 00 00 
  80261c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80261f:	48 63 d2             	movslq %edx,%rdx
  802622:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802626:	8b 00                	mov    (%rax),%eax
  802628:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80262b:	75 22                	jne    80264f <dev_lookup+0x55>
			*dev = devtab[i];
  80262d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802634:	00 00 00 
  802637:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80263a:	48 63 d2             	movslq %edx,%rdx
  80263d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802641:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802645:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	eb 60                	jmp    8026af <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80264f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802653:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80265a:	00 00 00 
  80265d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802660:	48 63 d2             	movslq %edx,%rdx
  802663:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802667:	48 85 c0             	test   %rax,%rax
  80266a:	75 a6                	jne    802612 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80266c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802673:	00 00 00 
  802676:	48 8b 00             	mov    (%rax),%rax
  802679:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80267f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802682:	89 c6                	mov    %eax,%esi
  802684:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  80268b:	00 00 00 
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
  802693:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  80269a:	00 00 00 
  80269d:	ff d1                	callq  *%rcx
	*dev = 0;
  80269f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026af:	c9                   	leaveq 
  8026b0:	c3                   	retq   

00000000008026b1 <close>:

int
close(int fdnum)
{
  8026b1:	55                   	push   %rbp
  8026b2:	48 89 e5             	mov    %rsp,%rbp
  8026b5:	48 83 ec 20          	sub    $0x20,%rsp
  8026b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026c3:	48 89 d6             	mov    %rdx,%rsi
  8026c6:	89 c7                	mov    %eax,%edi
  8026c8:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	callq  *%rax
  8026d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026db:	79 05                	jns    8026e2 <close+0x31>
		return r;
  8026dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e0:	eb 18                	jmp    8026fa <close+0x49>
	else
		return fd_close(fd, 1);
  8026e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e6:	be 01 00 00 00       	mov    $0x1,%esi
  8026eb:	48 89 c7             	mov    %rax,%rdi
  8026ee:	48 b8 31 25 80 00 00 	movabs $0x802531,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
}
  8026fa:	c9                   	leaveq 
  8026fb:	c3                   	retq   

00000000008026fc <close_all>:

void
close_all(void)
{
  8026fc:	55                   	push   %rbp
  8026fd:	48 89 e5             	mov    %rsp,%rbp
  802700:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802704:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80270b:	eb 15                	jmp    802722 <close_all+0x26>
		close(i);
  80270d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802710:	89 c7                	mov    %eax,%edi
  802712:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80271e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802722:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802726:	7e e5                	jle    80270d <close_all+0x11>
		close(i);
}
  802728:	c9                   	leaveq 
  802729:	c3                   	retq   

000000000080272a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80272a:	55                   	push   %rbp
  80272b:	48 89 e5             	mov    %rsp,%rbp
  80272e:	48 83 ec 40          	sub    $0x40,%rsp
  802732:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802735:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802738:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80273c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80273f:	48 89 d6             	mov    %rdx,%rsi
  802742:	89 c7                	mov    %eax,%edi
  802744:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
  802750:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802757:	79 08                	jns    802761 <dup+0x37>
		return r;
  802759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275c:	e9 70 01 00 00       	jmpq   8028d1 <dup+0x1a7>
	close(newfdnum);
  802761:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802764:	89 c7                	mov    %eax,%edi
  802766:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802772:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802775:	48 98                	cltq   
  802777:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80277d:	48 c1 e0 0c          	shl    $0xc,%rax
  802781:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80279c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a0:	48 89 c7             	mov    %rax,%rdi
  8027a3:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b7:	48 c1 e8 15          	shr    $0x15,%rax
  8027bb:	48 89 c2             	mov    %rax,%rdx
  8027be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027c5:	01 00 00 
  8027c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cc:	83 e0 01             	and    $0x1,%eax
  8027cf:	48 85 c0             	test   %rax,%rax
  8027d2:	74 73                	je     802847 <dup+0x11d>
  8027d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8027dc:	48 89 c2             	mov    %rax,%rdx
  8027df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027e6:	01 00 00 
  8027e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ed:	83 e0 01             	and    $0x1,%eax
  8027f0:	48 85 c0             	test   %rax,%rax
  8027f3:	74 52                	je     802847 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8027fd:	48 89 c2             	mov    %rax,%rdx
  802800:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802807:	01 00 00 
  80280a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280e:	25 07 0e 00 00       	and    $0xe07,%eax
  802813:	89 c1                	mov    %eax,%ecx
  802815:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281d:	41 89 c8             	mov    %ecx,%r8d
  802820:	48 89 d1             	mov    %rdx,%rcx
  802823:	ba 00 00 00 00       	mov    $0x0,%edx
  802828:	48 89 c6             	mov    %rax,%rsi
  80282b:	bf 00 00 00 00       	mov    $0x0,%edi
  802830:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	79 02                	jns    802847 <dup+0x11d>
			goto err;
  802845:	eb 57                	jmp    80289e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284b:	48 c1 e8 0c          	shr    $0xc,%rax
  80284f:	48 89 c2             	mov    %rax,%rdx
  802852:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802859:	01 00 00 
  80285c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802860:	25 07 0e 00 00       	and    $0xe07,%eax
  802865:	89 c1                	mov    %eax,%ecx
  802867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80286f:	41 89 c8             	mov    %ecx,%r8d
  802872:	48 89 d1             	mov    %rdx,%rcx
  802875:	ba 00 00 00 00       	mov    $0x0,%edx
  80287a:	48 89 c6             	mov    %rax,%rsi
  80287d:	bf 00 00 00 00       	mov    $0x0,%edi
  802882:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 02                	jns    802899 <dup+0x16f>
		goto err;
  802897:	eb 05                	jmp    80289e <dup+0x174>

	return newfdnum;
  802899:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80289c:	eb 33                	jmp    8028d1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80289e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a2:	48 89 c6             	mov    %rax,%rsi
  8028a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028aa:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ba:	48 89 c6             	mov    %rax,%rsi
  8028bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c2:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
	return r;
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 40          	sub    $0x40,%rsp
  8028db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ed:	48 89 d6             	mov    %rdx,%rsi
  8028f0:	89 c7                	mov    %eax,%edi
  8028f2:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax
  8028fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802901:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802905:	78 24                	js     80292b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290b:	8b 00                	mov    (%rax),%eax
  80290d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802911:	48 89 d6             	mov    %rdx,%rsi
  802914:	89 c7                	mov    %eax,%edi
  802916:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax
  802922:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802929:	79 05                	jns    802930 <read+0x5d>
		return r;
  80292b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292e:	eb 76                	jmp    8029a6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	8b 40 08             	mov    0x8(%rax),%eax
  802937:	83 e0 03             	and    $0x3,%eax
  80293a:	83 f8 01             	cmp    $0x1,%eax
  80293d:	75 3a                	jne    802979 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80293f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802946:	00 00 00 
  802949:	48 8b 00             	mov    (%rax),%rax
  80294c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802952:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802955:	89 c6                	mov    %eax,%esi
  802957:	48 bf 9f 4d 80 00 00 	movabs $0x804d9f,%rdi
  80295e:	00 00 00 
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
  802966:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  80296d:	00 00 00 
  802970:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802972:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802977:	eb 2d                	jmp    8029a6 <read+0xd3>
	}
	if (!dev->dev_read)
  802979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802981:	48 85 c0             	test   %rax,%rax
  802984:	75 07                	jne    80298d <read+0xba>
		return -E_NOT_SUPP;
  802986:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80298b:	eb 19                	jmp    8029a6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80298d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802991:	48 8b 40 10          	mov    0x10(%rax),%rax
  802995:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802999:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80299d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029a1:	48 89 cf             	mov    %rcx,%rdi
  8029a4:	ff d0                	callq  *%rax
}
  8029a6:	c9                   	leaveq 
  8029a7:	c3                   	retq   

00000000008029a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029a8:	55                   	push   %rbp
  8029a9:	48 89 e5             	mov    %rsp,%rbp
  8029ac:	48 83 ec 30          	sub    $0x30,%rsp
  8029b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c2:	eb 49                	jmp    802a0d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c7:	48 98                	cltq   
  8029c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029cd:	48 29 c2             	sub    %rax,%rdx
  8029d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d3:	48 63 c8             	movslq %eax,%rcx
  8029d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029da:	48 01 c1             	add    %rax,%rcx
  8029dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029e0:	48 89 ce             	mov    %rcx,%rsi
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029f8:	79 05                	jns    8029ff <readn+0x57>
			return m;
  8029fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029fd:	eb 1c                	jmp    802a1b <readn+0x73>
		if (m == 0)
  8029ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a03:	75 02                	jne    802a07 <readn+0x5f>
			break;
  802a05:	eb 11                	jmp    802a18 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a0a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a10:	48 98                	cltq   
  802a12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a16:	72 ac                	jb     8029c4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a1b:	c9                   	leaveq 
  802a1c:	c3                   	retq   

0000000000802a1d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a1d:	55                   	push   %rbp
  802a1e:	48 89 e5             	mov    %rsp,%rbp
  802a21:	48 83 ec 40          	sub    $0x40,%rsp
  802a25:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a2c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a30:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a34:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a37:	48 89 d6             	mov    %rdx,%rsi
  802a3a:	89 c7                	mov    %eax,%edi
  802a3c:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4f:	78 24                	js     802a75 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a55:	8b 00                	mov    (%rax),%eax
  802a57:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a5b:	48 89 d6             	mov    %rdx,%rsi
  802a5e:	89 c7                	mov    %eax,%edi
  802a60:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
  802a6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a73:	79 05                	jns    802a7a <write+0x5d>
		return r;
  802a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a78:	eb 75                	jmp    802aef <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7e:	8b 40 08             	mov    0x8(%rax),%eax
  802a81:	83 e0 03             	and    $0x3,%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	75 3a                	jne    802ac2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a88:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a8f:	00 00 00 
  802a92:	48 8b 00             	mov    (%rax),%rax
  802a95:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a9b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a9e:	89 c6                	mov    %eax,%esi
  802aa0:	48 bf bb 4d 80 00 00 	movabs $0x804dbb,%rdi
  802aa7:	00 00 00 
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaf:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  802ab6:	00 00 00 
  802ab9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802abb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ac0:	eb 2d                	jmp    802aef <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aca:	48 85 c0             	test   %rax,%rax
  802acd:	75 07                	jne    802ad6 <write+0xb9>
		return -E_NOT_SUPP;
  802acf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ad4:	eb 19                	jmp    802aef <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ad6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ada:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ade:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ae2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ae6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aea:	48 89 cf             	mov    %rcx,%rdi
  802aed:	ff d0                	callq  *%rax
}
  802aef:	c9                   	leaveq 
  802af0:	c3                   	retq   

0000000000802af1 <seek>:

int
seek(int fdnum, off_t offset)
{
  802af1:	55                   	push   %rbp
  802af2:	48 89 e5             	mov    %rsp,%rbp
  802af5:	48 83 ec 18          	sub    $0x18,%rsp
  802af9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802afc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b06:	48 89 d6             	mov    %rdx,%rsi
  802b09:	89 c7                	mov    %eax,%edi
  802b0b:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1e:	79 05                	jns    802b25 <seek+0x34>
		return r;
  802b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b23:	eb 0f                	jmp    802b34 <seek+0x43>
	fd->fd_offset = offset;
  802b25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b29:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b34:	c9                   	leaveq 
  802b35:	c3                   	retq   

0000000000802b36 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b36:	55                   	push   %rbp
  802b37:	48 89 e5             	mov    %rsp,%rbp
  802b3a:	48 83 ec 30          	sub    $0x30,%rsp
  802b3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b41:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b44:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b48:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b4b:	48 89 d6             	mov    %rdx,%rsi
  802b4e:	89 c7                	mov    %eax,%edi
  802b50:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
  802b5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b63:	78 24                	js     802b89 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b69:	8b 00                	mov    (%rax),%eax
  802b6b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b6f:	48 89 d6             	mov    %rdx,%rsi
  802b72:	89 c7                	mov    %eax,%edi
  802b74:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
  802b80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b87:	79 05                	jns    802b8e <ftruncate+0x58>
		return r;
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8c:	eb 72                	jmp    802c00 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b92:	8b 40 08             	mov    0x8(%rax),%eax
  802b95:	83 e0 03             	and    $0x3,%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	75 3a                	jne    802bd6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b9c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ba3:	00 00 00 
  802ba6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ba9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802baf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bb2:	89 c6                	mov    %eax,%esi
  802bb4:	48 bf d8 4d 80 00 00 	movabs $0x804dd8,%rdi
  802bbb:	00 00 00 
  802bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc3:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  802bca:	00 00 00 
  802bcd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bcf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bd4:	eb 2a                	jmp    802c00 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bda:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bde:	48 85 c0             	test   %rax,%rax
  802be1:	75 07                	jne    802bea <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802be3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be8:	eb 16                	jmp    802c00 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bee:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bf2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bf9:	89 ce                	mov    %ecx,%esi
  802bfb:	48 89 d7             	mov    %rdx,%rdi
  802bfe:	ff d0                	callq  *%rax
}
  802c00:	c9                   	leaveq 
  802c01:	c3                   	retq   

0000000000802c02 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c02:	55                   	push   %rbp
  802c03:	48 89 e5             	mov    %rsp,%rbp
  802c06:	48 83 ec 30          	sub    $0x30,%rsp
  802c0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c18:	48 89 d6             	mov    %rdx,%rsi
  802c1b:	89 c7                	mov    %eax,%edi
  802c1d:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c30:	78 24                	js     802c56 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c36:	8b 00                	mov    (%rax),%eax
  802c38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3c:	48 89 d6             	mov    %rdx,%rsi
  802c3f:	89 c7                	mov    %eax,%edi
  802c41:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c54:	79 05                	jns    802c5b <fstat+0x59>
		return r;
  802c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c59:	eb 5e                	jmp    802cb9 <fstat+0xb7>
	if (!dev->dev_stat)
  802c5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c63:	48 85 c0             	test   %rax,%rax
  802c66:	75 07                	jne    802c6f <fstat+0x6d>
		return -E_NOT_SUPP;
  802c68:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c6d:	eb 4a                	jmp    802cb9 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c73:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c81:	00 00 00 
	stat->st_isdir = 0;
  802c84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c88:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c8f:	00 00 00 
	stat->st_dev = dev;
  802c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c9a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ca9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cad:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cb1:	48 89 ce             	mov    %rcx,%rsi
  802cb4:	48 89 d7             	mov    %rdx,%rdi
  802cb7:	ff d0                	callq  *%rax
}
  802cb9:	c9                   	leaveq 
  802cba:	c3                   	retq   

0000000000802cbb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cbb:	55                   	push   %rbp
  802cbc:	48 89 e5             	mov    %rsp,%rbp
  802cbf:	48 83 ec 20          	sub    $0x20,%rsp
  802cc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccf:	be 00 00 00 00       	mov    $0x0,%esi
  802cd4:	48 89 c7             	mov    %rax,%rdi
  802cd7:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	callq  *%rax
  802ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cea:	79 05                	jns    802cf1 <stat+0x36>
		return fd;
  802cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cef:	eb 2f                	jmp    802d20 <stat+0x65>
	r = fstat(fd, stat);
  802cf1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf8:	48 89 d6             	mov    %rdx,%rsi
  802cfb:	89 c7                	mov    %eax,%edi
  802cfd:	48 b8 02 2c 80 00 00 	movabs $0x802c02,%rax
  802d04:	00 00 00 
  802d07:	ff d0                	callq  *%rax
  802d09:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0f:	89 c7                	mov    %eax,%edi
  802d11:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
	return r;
  802d1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d20:	c9                   	leaveq 
  802d21:	c3                   	retq   

0000000000802d22 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d22:	55                   	push   %rbp
  802d23:	48 89 e5             	mov    %rsp,%rbp
  802d26:	48 83 ec 10          	sub    $0x10,%rsp
  802d2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d31:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d38:	00 00 00 
  802d3b:	8b 00                	mov    (%rax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	75 1d                	jne    802d5e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d41:	bf 01 00 00 00       	mov    $0x1,%edi
  802d46:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d59:	00 00 00 
  802d5c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d5e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d65:	00 00 00 
  802d68:	8b 00                	mov    (%rax),%eax
  802d6a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d6d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d72:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d79:	00 00 00 
  802d7c:	89 c7                	mov    %eax,%edi
  802d7e:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d93:	48 89 c6             	mov    %rax,%rsi
  802d96:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9b:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 30          	sub    $0x30,%rsp
  802db1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802db5:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802db8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802dbf:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802dcd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802dd2:	75 08                	jne    802ddc <open+0x33>
	{
		return r;
  802dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd7:	e9 f2 00 00 00       	jmpq   802ece <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ddc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802df2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802df9:	7e 0a                	jle    802e05 <open+0x5c>
	{
		return -E_BAD_PATH;
  802dfb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e00:	e9 c9 00 00 00       	jmpq   802ece <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e0c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e0d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e11:	48 89 c7             	mov    %rax,%rdi
  802e14:	48 b8 09 24 80 00 00 	movabs $0x802409,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e27:	78 09                	js     802e32 <open+0x89>
  802e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2d:	48 85 c0             	test   %rax,%rax
  802e30:	75 08                	jne    802e3a <open+0x91>
		{
			return r;
  802e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e35:	e9 94 00 00 00       	jmpq   802ece <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802e3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e3e:	ba 00 04 00 00       	mov    $0x400,%edx
  802e43:	48 89 c6             	mov    %rax,%rsi
  802e46:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e4d:	00 00 00 
  802e50:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802e5c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e63:	00 00 00 
  802e66:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802e69:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e73:	48 89 c6             	mov    %rax,%rsi
  802e76:	bf 01 00 00 00       	mov    $0x1,%edi
  802e7b:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	callq  *%rax
  802e87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8e:	79 2b                	jns    802ebb <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802e90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e94:	be 00 00 00 00       	mov    $0x0,%esi
  802e99:	48 89 c7             	mov    %rax,%rdi
  802e9c:	48 b8 31 25 80 00 00 	movabs $0x802531,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
  802ea8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802eab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802eaf:	79 05                	jns    802eb6 <open+0x10d>
			{
				return d;
  802eb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eb4:	eb 18                	jmp    802ece <open+0x125>
			}
			return r;
  802eb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb9:	eb 13                	jmp    802ece <open+0x125>
		}	
		return fd2num(fd_store);
  802ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebf:	48 89 c7             	mov    %rax,%rdi
  802ec2:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802ece:	c9                   	leaveq 
  802ecf:	c3                   	retq   

0000000000802ed0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ed0:	55                   	push   %rbp
  802ed1:	48 89 e5             	mov    %rsp,%rbp
  802ed4:	48 83 ec 10          	sub    $0x10,%rsp
  802ed8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ee3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eea:	00 00 00 
  802eed:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802eef:	be 00 00 00 00       	mov    $0x0,%esi
  802ef4:	bf 06 00 00 00       	mov    $0x6,%edi
  802ef9:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
}
  802f05:	c9                   	leaveq 
  802f06:	c3                   	retq   

0000000000802f07 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f07:	55                   	push   %rbp
  802f08:	48 89 e5             	mov    %rsp,%rbp
  802f0b:	48 83 ec 30          	sub    $0x30,%rsp
  802f0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f22:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f27:	74 07                	je     802f30 <devfile_read+0x29>
  802f29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f2e:	75 07                	jne    802f37 <devfile_read+0x30>
		return -E_INVAL;
  802f30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f35:	eb 77                	jmp    802fae <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f3e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f45:	00 00 00 
  802f48:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f51:	00 00 00 
  802f54:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f58:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802f5c:	be 00 00 00 00       	mov    $0x0,%esi
  802f61:	bf 03 00 00 00       	mov    $0x3,%edi
  802f66:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
  802f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f79:	7f 05                	jg     802f80 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7e:	eb 2e                	jmp    802fae <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f83:	48 63 d0             	movslq %eax,%rdx
  802f86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f91:	00 00 00 
  802f94:	48 89 c7             	mov    %rax,%rdi
  802f97:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802fa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802fae:	c9                   	leaveq 
  802faf:	c3                   	retq   

0000000000802fb0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fb0:	55                   	push   %rbp
  802fb1:	48 89 e5             	mov    %rsp,%rbp
  802fb4:	48 83 ec 30          	sub    $0x30,%rsp
  802fb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802fc4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802fcb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fd0:	74 07                	je     802fd9 <devfile_write+0x29>
  802fd2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fd7:	75 08                	jne    802fe1 <devfile_write+0x31>
		return r;
  802fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdc:	e9 9a 00 00 00       	jmpq   80307b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe5:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fef:	00 00 00 
  802ff2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ff4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ffb:	00 
  802ffc:	76 08                	jbe    803006 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ffe:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803005:	00 
	}
	fsipcbuf.write.req_n = n;
  803006:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300d:	00 00 00 
  803010:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803014:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803018:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80301c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803020:	48 89 c6             	mov    %rax,%rsi
  803023:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80302a:	00 00 00 
  80302d:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803039:	be 00 00 00 00       	mov    $0x0,%esi
  80303e:	bf 04 00 00 00       	mov    $0x4,%edi
  803043:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
  80304f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803052:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803056:	7f 20                	jg     803078 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803058:	48 bf fe 4d 80 00 00 	movabs $0x804dfe,%rdi
  80305f:	00 00 00 
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  80306e:	00 00 00 
  803071:	ff d2                	callq  *%rdx
		return r;
  803073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803076:	eb 03                	jmp    80307b <devfile_write+0xcb>
	}
	return r;
  803078:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80307b:	c9                   	leaveq 
  80307c:	c3                   	retq   

000000000080307d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80307d:	55                   	push   %rbp
  80307e:	48 89 e5             	mov    %rsp,%rbp
  803081:	48 83 ec 20          	sub    $0x20,%rsp
  803085:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803089:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80308d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803091:	8b 50 0c             	mov    0xc(%rax),%edx
  803094:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80309b:	00 00 00 
  80309e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030a0:	be 00 00 00 00       	mov    $0x0,%esi
  8030a5:	bf 05 00 00 00       	mov    $0x5,%edi
  8030aa:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bd:	79 05                	jns    8030c4 <devfile_stat+0x47>
		return r;
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	eb 56                	jmp    80311a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030cf:	00 00 00 
  8030d2:	48 89 c7             	mov    %rax,%rdi
  8030d5:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8030dc:	00 00 00 
  8030df:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e8:	00 00 00 
  8030eb:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803102:	00 00 00 
  803105:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80310b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80311a:	c9                   	leaveq 
  80311b:	c3                   	retq   

000000000080311c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80311c:	55                   	push   %rbp
  80311d:	48 89 e5             	mov    %rsp,%rbp
  803120:	48 83 ec 10          	sub    $0x10,%rsp
  803124:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803128:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80312b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312f:	8b 50 0c             	mov    0xc(%rax),%edx
  803132:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803139:	00 00 00 
  80313c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80313e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803145:	00 00 00 
  803148:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80314b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80314e:	be 00 00 00 00       	mov    $0x0,%esi
  803153:	bf 02 00 00 00       	mov    $0x2,%edi
  803158:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
}
  803164:	c9                   	leaveq 
  803165:	c3                   	retq   

0000000000803166 <remove>:

// Delete a file
int
remove(const char *path)
{
  803166:	55                   	push   %rbp
  803167:	48 89 e5             	mov    %rsp,%rbp
  80316a:	48 83 ec 10          	sub    $0x10,%rsp
  80316e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803176:	48 89 c7             	mov    %rax,%rdi
  803179:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
  803185:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80318a:	7e 07                	jle    803193 <remove+0x2d>
		return -E_BAD_PATH;
  80318c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803191:	eb 33                	jmp    8031c6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803197:	48 89 c6             	mov    %rax,%rsi
  80319a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031a1:	00 00 00 
  8031a4:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031b0:	be 00 00 00 00       	mov    $0x0,%esi
  8031b5:	bf 07 00 00 00       	mov    $0x7,%edi
  8031ba:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031cc:	be 00 00 00 00       	mov    $0x0,%esi
  8031d1:	bf 08 00 00 00       	mov    $0x8,%edi
  8031d6:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
}
  8031e2:	5d                   	pop    %rbp
  8031e3:	c3                   	retq   

00000000008031e4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8031e4:	55                   	push   %rbp
  8031e5:	48 89 e5             	mov    %rsp,%rbp
  8031e8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8031ef:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8031f6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8031fd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803204:	be 00 00 00 00       	mov    $0x0,%esi
  803209:	48 89 c7             	mov    %rax,%rdi
  80320c:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  803213:	00 00 00 
  803216:	ff d0                	callq  *%rax
  803218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80321b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321f:	79 28                	jns    803249 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803224:	89 c6                	mov    %eax,%esi
  803226:	48 bf 1a 4e 80 00 00 	movabs $0x804e1a,%rdi
  80322d:	00 00 00 
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  80323c:	00 00 00 
  80323f:	ff d2                	callq  *%rdx
		return fd_src;
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803244:	e9 74 01 00 00       	jmpq   8033bd <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803249:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803250:	be 01 01 00 00       	mov    $0x101,%esi
  803255:	48 89 c7             	mov    %rax,%rdi
  803258:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  80325f:	00 00 00 
  803262:	ff d0                	callq  *%rax
  803264:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803267:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80326b:	79 39                	jns    8032a6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80326d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803270:	89 c6                	mov    %eax,%esi
  803272:	48 bf 30 4e 80 00 00 	movabs $0x804e30,%rdi
  803279:	00 00 00 
  80327c:	b8 00 00 00 00       	mov    $0x0,%eax
  803281:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  803288:	00 00 00 
  80328b:	ff d2                	callq  *%rdx
		close(fd_src);
  80328d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803290:	89 c7                	mov    %eax,%edi
  803292:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
		return fd_dest;
  80329e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a1:	e9 17 01 00 00       	jmpq   8033bd <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032a6:	eb 74                	jmp    80331c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8032a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032ab:	48 63 d0             	movslq %eax,%rdx
  8032ae:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b8:	48 89 ce             	mov    %rcx,%rsi
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 b8 1d 2a 80 00 00 	movabs $0x802a1d,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
  8032c9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8032cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8032d0:	79 4a                	jns    80331c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8032d2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032d5:	89 c6                	mov    %eax,%esi
  8032d7:	48 bf 4a 4e 80 00 00 	movabs $0x804e4a,%rdi
  8032de:	00 00 00 
  8032e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e6:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  8032ed:	00 00 00 
  8032f0:	ff d2                	callq  *%rdx
			close(fd_src);
  8032f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f5:	89 c7                	mov    %eax,%edi
  8032f7:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
			close(fd_dest);
  803303:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803306:	89 c7                	mov    %eax,%edi
  803308:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
			return write_size;
  803314:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803317:	e9 a1 00 00 00       	jmpq   8033bd <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80331c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	ba 00 02 00 00       	mov    $0x200,%edx
  80332b:	48 89 ce             	mov    %rcx,%rsi
  80332e:	89 c7                	mov    %eax,%edi
  803330:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80333f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803343:	0f 8f 5f ff ff ff    	jg     8032a8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803349:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80334d:	79 47                	jns    803396 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80334f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803352:	89 c6                	mov    %eax,%esi
  803354:	48 bf 5d 4e 80 00 00 	movabs $0x804e5d,%rdi
  80335b:	00 00 00 
  80335e:	b8 00 00 00 00       	mov    $0x0,%eax
  803363:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  80336a:	00 00 00 
  80336d:	ff d2                	callq  *%rdx
		close(fd_src);
  80336f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803372:	89 c7                	mov    %eax,%edi
  803374:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
		close(fd_dest);
  803380:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803383:	89 c7                	mov    %eax,%edi
  803385:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
		return read_size;
  803391:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803394:	eb 27                	jmp    8033bd <copy+0x1d9>
	}
	close(fd_src);
  803396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803399:	89 c7                	mov    %eax,%edi
  80339b:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
	close(fd_dest);
  8033a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033aa:	89 c7                	mov    %eax,%edi
  8033ac:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  8033b3:	00 00 00 
  8033b6:	ff d0                	callq  *%rax
	return 0;
  8033b8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8033bd:	c9                   	leaveq 
  8033be:	c3                   	retq   

00000000008033bf <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8033bf:	55                   	push   %rbp
  8033c0:	48 89 e5             	mov    %rsp,%rbp
  8033c3:	48 83 ec 20          	sub    $0x20,%rsp
  8033c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8033ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d1:	48 89 d6             	mov    %rdx,%rsi
  8033d4:	89 c7                	mov    %eax,%edi
  8033d6:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e9:	79 05                	jns    8033f0 <fd2sockid+0x31>
		return r;
  8033eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ee:	eb 24                	jmp    803414 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8033f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f4:	8b 10                	mov    (%rax),%edx
  8033f6:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8033fd:	00 00 00 
  803400:	8b 00                	mov    (%rax),%eax
  803402:	39 c2                	cmp    %eax,%edx
  803404:	74 07                	je     80340d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803406:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80340b:	eb 07                	jmp    803414 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80340d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803411:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803414:	c9                   	leaveq 
  803415:	c3                   	retq   

0000000000803416 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803416:	55                   	push   %rbp
  803417:	48 89 e5             	mov    %rsp,%rbp
  80341a:	48 83 ec 20          	sub    $0x20,%rsp
  80341e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803421:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803425:	48 89 c7             	mov    %rax,%rdi
  803428:	48 b8 09 24 80 00 00 	movabs $0x802409,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343b:	78 26                	js     803463 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80343d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803441:	ba 07 04 00 00       	mov    $0x407,%edx
  803446:	48 89 c6             	mov    %rax,%rsi
  803449:	bf 00 00 00 00       	mov    $0x0,%edi
  80344e:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803461:	79 16                	jns    803479 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803463:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803466:	89 c7                	mov    %eax,%edi
  803468:	48 b8 23 39 80 00 00 	movabs $0x803923,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
		return r;
  803474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803477:	eb 3a                	jmp    8034b3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803484:	00 00 00 
  803487:	8b 12                	mov    (%rdx),%edx
  803489:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80348b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80349d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a4:	48 89 c7             	mov    %rax,%rdi
  8034a7:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
}
  8034b3:	c9                   	leaveq 
  8034b4:	c3                   	retq   

00000000008034b5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034b5:	55                   	push   %rbp
  8034b6:	48 89 e5             	mov    %rsp,%rbp
  8034b9:	48 83 ec 30          	sub    $0x30,%rsp
  8034bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e0:	79 05                	jns    8034e7 <accept+0x32>
		return r;
  8034e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e5:	eb 3b                	jmp    803522 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034eb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f2:	48 89 ce             	mov    %rcx,%rsi
  8034f5:	89 c7                	mov    %eax,%edi
  8034f7:	48 b8 00 38 80 00 00 	movabs $0x803800,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
  803503:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350a:	79 05                	jns    803511 <accept+0x5c>
		return r;
  80350c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350f:	eb 11                	jmp    803522 <accept+0x6d>
	return alloc_sockfd(r);
  803511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803514:	89 c7                	mov    %eax,%edi
  803516:	48 b8 16 34 80 00 00 	movabs $0x803416,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
}
  803522:	c9                   	leaveq 
  803523:	c3                   	retq   

0000000000803524 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803524:	55                   	push   %rbp
  803525:	48 89 e5             	mov    %rsp,%rbp
  803528:	48 83 ec 20          	sub    $0x20,%rsp
  80352c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80352f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803533:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803536:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803539:	89 c7                	mov    %eax,%edi
  80353b:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
  803547:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354e:	79 05                	jns    803555 <bind+0x31>
		return r;
  803550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803553:	eb 1b                	jmp    803570 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803555:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803558:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80355c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355f:	48 89 ce             	mov    %rcx,%rsi
  803562:	89 c7                	mov    %eax,%edi
  803564:	48 b8 7f 38 80 00 00 	movabs $0x80387f,%rax
  80356b:	00 00 00 
  80356e:	ff d0                	callq  *%rax
}
  803570:	c9                   	leaveq 
  803571:	c3                   	retq   

0000000000803572 <shutdown>:

int
shutdown(int s, int how)
{
  803572:	55                   	push   %rbp
  803573:	48 89 e5             	mov    %rsp,%rbp
  803576:	48 83 ec 20          	sub    $0x20,%rsp
  80357a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80357d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803580:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803583:	89 c7                	mov    %eax,%edi
  803585:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  80358c:	00 00 00 
  80358f:	ff d0                	callq  *%rax
  803591:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803594:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803598:	79 05                	jns    80359f <shutdown+0x2d>
		return r;
  80359a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359d:	eb 16                	jmp    8035b5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80359f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a5:	89 d6                	mov    %edx,%esi
  8035a7:	89 c7                	mov    %eax,%edi
  8035a9:	48 b8 e3 38 80 00 00 	movabs $0x8038e3,%rax
  8035b0:	00 00 00 
  8035b3:	ff d0                	callq  *%rax
}
  8035b5:	c9                   	leaveq 
  8035b6:	c3                   	retq   

00000000008035b7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035b7:	55                   	push   %rbp
  8035b8:	48 89 e5             	mov    %rsp,%rbp
  8035bb:	48 83 ec 10          	sub    $0x10,%rsp
  8035bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8035c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c7:	48 89 c7             	mov    %rax,%rdi
  8035ca:	48 b8 9b 46 80 00 00 	movabs $0x80469b,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
  8035d6:	83 f8 01             	cmp    $0x1,%eax
  8035d9:	75 17                	jne    8035f2 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8035db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035df:	8b 40 0c             	mov    0xc(%rax),%eax
  8035e2:	89 c7                	mov    %eax,%edi
  8035e4:	48 b8 23 39 80 00 00 	movabs $0x803923,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	eb 05                	jmp    8035f7 <devsock_close+0x40>
	else
		return 0;
  8035f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f7:	c9                   	leaveq 
  8035f8:	c3                   	retq   

00000000008035f9 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 83 ec 20          	sub    $0x20,%rsp
  803601:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803604:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803608:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80360b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80360e:	89 c7                	mov    %eax,%edi
  803610:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80361f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803623:	79 05                	jns    80362a <connect+0x31>
		return r;
  803625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803628:	eb 1b                	jmp    803645 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80362a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80362d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	48 89 ce             	mov    %rcx,%rsi
  803637:	89 c7                	mov    %eax,%edi
  803639:	48 b8 50 39 80 00 00 	movabs $0x803950,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <listen>:

int
listen(int s, int backlog)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 20          	sub    $0x20,%rsp
  80364f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803652:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803655:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366d:	79 05                	jns    803674 <listen+0x2d>
		return r;
  80366f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803672:	eb 16                	jmp    80368a <listen+0x43>
	return nsipc_listen(r, backlog);
  803674:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367a:	89 d6                	mov    %edx,%esi
  80367c:	89 c7                	mov    %eax,%edi
  80367e:	48 b8 b4 39 80 00 00 	movabs $0x8039b4,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
}
  80368a:	c9                   	leaveq 
  80368b:	c3                   	retq   

000000000080368c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80368c:	55                   	push   %rbp
  80368d:	48 89 e5             	mov    %rsp,%rbp
  803690:	48 83 ec 20          	sub    $0x20,%rsp
  803694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803698:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80369c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a4:	89 c2                	mov    %eax,%edx
  8036a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036aa:	8b 40 0c             	mov    0xc(%rax),%eax
  8036ad:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 f4 39 80 00 00 	movabs $0x8039f4,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
}
  8036c4:	c9                   	leaveq 
  8036c5:	c3                   	retq   

00000000008036c6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036c6:	55                   	push   %rbp
  8036c7:	48 89 e5             	mov    %rsp,%rbp
  8036ca:	48 83 ec 20          	sub    $0x20,%rsp
  8036ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036de:	89 c2                	mov    %eax,%edx
  8036e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e4:	8b 40 0c             	mov    0xc(%rax),%eax
  8036e7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036f0:	89 c7                	mov    %eax,%edi
  8036f2:	48 b8 c0 3a 80 00 00 	movabs $0x803ac0,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 10          	sub    $0x10,%rsp
  803708:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80370c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	48 be 78 4e 80 00 00 	movabs $0x804e78,%rsi
  80371b:	00 00 00 
  80371e:	48 89 c7             	mov    %rax,%rdi
  803721:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  803728:	00 00 00 
  80372b:	ff d0                	callq  *%rax
	return 0;
  80372d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803732:	c9                   	leaveq 
  803733:	c3                   	retq   

0000000000803734 <socket>:

int
socket(int domain, int type, int protocol)
{
  803734:	55                   	push   %rbp
  803735:	48 89 e5             	mov    %rsp,%rbp
  803738:	48 83 ec 20          	sub    $0x20,%rsp
  80373c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80373f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803742:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803745:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803748:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80374b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374e:	89 ce                	mov    %ecx,%esi
  803750:	89 c7                	mov    %eax,%edi
  803752:	48 b8 78 3b 80 00 00 	movabs $0x803b78,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803765:	79 05                	jns    80376c <socket+0x38>
		return r;
  803767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376a:	eb 11                	jmp    80377d <socket+0x49>
	return alloc_sockfd(r);
  80376c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376f:	89 c7                	mov    %eax,%edi
  803771:	48 b8 16 34 80 00 00 	movabs $0x803416,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
}
  80377d:	c9                   	leaveq 
  80377e:	c3                   	retq   

000000000080377f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80377f:	55                   	push   %rbp
  803780:	48 89 e5             	mov    %rsp,%rbp
  803783:	48 83 ec 10          	sub    $0x10,%rsp
  803787:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80378a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803791:	00 00 00 
  803794:	8b 00                	mov    (%rax),%eax
  803796:	85 c0                	test   %eax,%eax
  803798:	75 1d                	jne    8037b7 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80379a:	bf 02 00 00 00       	mov    $0x2,%edi
  80379f:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8037b2:	00 00 00 
  8037b5:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037b7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8037be:	00 00 00 
  8037c1:	8b 00                	mov    (%rax),%eax
  8037c3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037c6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037cb:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8037d2:	00 00 00 
  8037d5:	89 c7                	mov    %eax,%edi
  8037d7:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  8037de:	00 00 00 
  8037e1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8037e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8037e8:	be 00 00 00 00       	mov    $0x0,%esi
  8037ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f2:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
}
  8037fe:	c9                   	leaveq 
  8037ff:	c3                   	retq   

0000000000803800 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803800:	55                   	push   %rbp
  803801:	48 89 e5             	mov    %rsp,%rbp
  803804:	48 83 ec 30          	sub    $0x30,%rsp
  803808:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80380b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80380f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803813:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381a:	00 00 00 
  80381d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803820:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803822:	bf 01 00 00 00       	mov    $0x1,%edi
  803827:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
  803833:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803836:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383a:	78 3e                	js     80387a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80383c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803843:	00 00 00 
  803846:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80384a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384e:	8b 40 10             	mov    0x10(%rax),%eax
  803851:	89 c2                	mov    %eax,%edx
  803853:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803857:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385b:	48 89 ce             	mov    %rcx,%rsi
  80385e:	48 89 c7             	mov    %rax,%rdi
  803861:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  803868:	00 00 00 
  80386b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80386d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803871:	8b 50 10             	mov    0x10(%rax),%edx
  803874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803878:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80387a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80387d:	c9                   	leaveq 
  80387e:	c3                   	retq   

000000000080387f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80387f:	55                   	push   %rbp
  803880:	48 89 e5             	mov    %rsp,%rbp
  803883:	48 83 ec 10          	sub    $0x10,%rsp
  803887:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80388a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80388e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803891:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803898:	00 00 00 
  80389b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80389e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a7:	48 89 c6             	mov    %rax,%rsi
  8038aa:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038b1:	00 00 00 
  8038b4:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  8038bb:	00 00 00 
  8038be:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8038c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c7:	00 00 00 
  8038ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038cd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8038d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8038d5:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
}
  8038e1:	c9                   	leaveq 
  8038e2:	c3                   	retq   

00000000008038e3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038e3:	55                   	push   %rbp
  8038e4:	48 89 e5             	mov    %rsp,%rbp
  8038e7:	48 83 ec 10          	sub    $0x10,%rsp
  8038eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8038f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f8:	00 00 00 
  8038fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038fe:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803900:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803907:	00 00 00 
  80390a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80390d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803910:	bf 03 00 00 00       	mov    $0x3,%edi
  803915:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  80391c:	00 00 00 
  80391f:	ff d0                	callq  *%rax
}
  803921:	c9                   	leaveq 
  803922:	c3                   	retq   

0000000000803923 <nsipc_close>:

int
nsipc_close(int s)
{
  803923:	55                   	push   %rbp
  803924:	48 89 e5             	mov    %rsp,%rbp
  803927:	48 83 ec 10          	sub    $0x10,%rsp
  80392b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80392e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803935:	00 00 00 
  803938:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80393b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80393d:	bf 04 00 00 00       	mov    $0x4,%edi
  803942:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
}
  80394e:	c9                   	leaveq 
  80394f:	c3                   	retq   

0000000000803950 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803950:	55                   	push   %rbp
  803951:	48 89 e5             	mov    %rsp,%rbp
  803954:	48 83 ec 10          	sub    $0x10,%rsp
  803958:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80395b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80395f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803962:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803969:	00 00 00 
  80396c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80396f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803971:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803978:	48 89 c6             	mov    %rax,%rsi
  80397b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803982:	00 00 00 
  803985:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803991:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803998:	00 00 00 
  80399b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80399e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039a1:	bf 05 00 00 00       	mov    $0x5,%edi
  8039a6:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  8039ad:	00 00 00 
  8039b0:	ff d0                	callq  *%rax
}
  8039b2:	c9                   	leaveq 
  8039b3:	c3                   	retq   

00000000008039b4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039b4:	55                   	push   %rbp
  8039b5:	48 89 e5             	mov    %rsp,%rbp
  8039b8:	48 83 ec 10          	sub    $0x10,%rsp
  8039bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039bf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8039c2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c9:	00 00 00 
  8039cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8039d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d8:	00 00 00 
  8039db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039de:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8039e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8039e6:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  8039ed:	00 00 00 
  8039f0:	ff d0                	callq  *%rax
}
  8039f2:	c9                   	leaveq 
  8039f3:	c3                   	retq   

00000000008039f4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8039f4:	55                   	push   %rbp
  8039f5:	48 89 e5             	mov    %rsp,%rbp
  8039f8:	48 83 ec 30          	sub    $0x30,%rsp
  8039fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a03:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a06:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a09:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a10:	00 00 00 
  803a13:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a16:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a18:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a1f:	00 00 00 
  803a22:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a25:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a28:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a2f:	00 00 00 
  803a32:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a35:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a38:	bf 07 00 00 00       	mov    $0x7,%edi
  803a3d:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  803a44:	00 00 00 
  803a47:	ff d0                	callq  *%rax
  803a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a50:	78 69                	js     803abb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a52:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a59:	7f 08                	jg     803a63 <nsipc_recv+0x6f>
  803a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a61:	7e 35                	jle    803a98 <nsipc_recv+0xa4>
  803a63:	48 b9 7f 4e 80 00 00 	movabs $0x804e7f,%rcx
  803a6a:	00 00 00 
  803a6d:	48 ba 94 4e 80 00 00 	movabs $0x804e94,%rdx
  803a74:	00 00 00 
  803a77:	be 61 00 00 00       	mov    $0x61,%esi
  803a7c:	48 bf a9 4e 80 00 00 	movabs $0x804ea9,%rdi
  803a83:	00 00 00 
  803a86:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8b:	49 b8 47 44 80 00 00 	movabs $0x804447,%r8
  803a92:	00 00 00 
  803a95:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9b:	48 63 d0             	movslq %eax,%rdx
  803a9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa2:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803aa9:	00 00 00 
  803aac:	48 89 c7             	mov    %rax,%rdi
  803aaf:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  803ab6:	00 00 00 
  803ab9:	ff d0                	callq  *%rax
	}

	return r;
  803abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803abe:	c9                   	leaveq 
  803abf:	c3                   	retq   

0000000000803ac0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 83 ec 20          	sub    $0x20,%rsp
  803ac8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803acb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803acf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ad2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ad5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803adc:	00 00 00 
  803adf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803ae4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803aeb:	7e 35                	jle    803b22 <nsipc_send+0x62>
  803aed:	48 b9 b5 4e 80 00 00 	movabs $0x804eb5,%rcx
  803af4:	00 00 00 
  803af7:	48 ba 94 4e 80 00 00 	movabs $0x804e94,%rdx
  803afe:	00 00 00 
  803b01:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b06:	48 bf a9 4e 80 00 00 	movabs $0x804ea9,%rdi
  803b0d:	00 00 00 
  803b10:	b8 00 00 00 00       	mov    $0x0,%eax
  803b15:	49 b8 47 44 80 00 00 	movabs $0x804447,%r8
  803b1c:	00 00 00 
  803b1f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b25:	48 63 d0             	movslq %eax,%rdx
  803b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2c:	48 89 c6             	mov    %rax,%rsi
  803b2f:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803b36:	00 00 00 
  803b39:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b45:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b4c:	00 00 00 
  803b4f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b52:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b5c:	00 00 00 
  803b5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b62:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b65:	bf 08 00 00 00       	mov    $0x8,%edi
  803b6a:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  803b71:	00 00 00 
  803b74:	ff d0                	callq  *%rax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 10          	sub    $0x10,%rsp
  803b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b83:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b86:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b90:	00 00 00 
  803b93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b96:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b98:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b9f:	00 00 00 
  803ba2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ba5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ba8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803baf:	00 00 00 
  803bb2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bb5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803bb8:	bf 09 00 00 00       	mov    $0x9,%edi
  803bbd:	48 b8 7f 37 80 00 00 	movabs $0x80377f,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
}
  803bc9:	c9                   	leaveq 
  803bca:	c3                   	retq   

0000000000803bcb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803bcb:	55                   	push   %rbp
  803bcc:	48 89 e5             	mov    %rsp,%rbp
  803bcf:	53                   	push   %rbx
  803bd0:	48 83 ec 38          	sub    $0x38,%rsp
  803bd4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803bd8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803bdc:	48 89 c7             	mov    %rax,%rdi
  803bdf:	48 b8 09 24 80 00 00 	movabs $0x802409,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bf2:	0f 88 bf 01 00 00    	js     803db7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfc:	ba 07 04 00 00       	mov    $0x407,%edx
  803c01:	48 89 c6             	mov    %rax,%rsi
  803c04:	bf 00 00 00 00       	mov    $0x0,%edi
  803c09:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
  803c15:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c18:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c1c:	0f 88 95 01 00 00    	js     803db7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c22:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c26:	48 89 c7             	mov    %rax,%rdi
  803c29:	48 b8 09 24 80 00 00 	movabs $0x802409,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
  803c35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3c:	0f 88 5d 01 00 00    	js     803d9f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c46:	ba 07 04 00 00       	mov    $0x407,%edx
  803c4b:	48 89 c6             	mov    %rax,%rsi
  803c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c53:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  803c5a:	00 00 00 
  803c5d:	ff d0                	callq  *%rax
  803c5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c62:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c66:	0f 88 33 01 00 00    	js     803d9f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c70:	48 89 c7             	mov    %rax,%rdi
  803c73:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
  803c7f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c87:	ba 07 04 00 00       	mov    $0x407,%edx
  803c8c:	48 89 c6             	mov    %rax,%rsi
  803c8f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c94:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
  803ca0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ca7:	79 05                	jns    803cae <pipe+0xe3>
		goto err2;
  803ca9:	e9 d9 00 00 00       	jmpq   803d87 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb2:	48 89 c7             	mov    %rax,%rdi
  803cb5:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
  803cc1:	48 89 c2             	mov    %rax,%rdx
  803cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803cce:	48 89 d1             	mov    %rdx,%rcx
  803cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  803cd6:	48 89 c6             	mov    %rax,%rsi
  803cd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cde:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ced:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cf1:	79 1b                	jns    803d0e <pipe+0x143>
		goto err3;
  803cf3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803cf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf8:	48 89 c6             	mov    %rax,%rsi
  803cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  803d00:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  803d07:	00 00 00 
  803d0a:	ff d0                	callq  *%rax
  803d0c:	eb 79                	jmp    803d87 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d12:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803d19:	00 00 00 
  803d1c:	8b 12                	mov    (%rdx),%edx
  803d1e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d2f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803d36:	00 00 00 
  803d39:	8b 12                	mov    (%rdx),%edx
  803d3b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d41:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4c:	48 89 c7             	mov    %rax,%rdi
  803d4f:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
  803d5b:	89 c2                	mov    %eax,%edx
  803d5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d61:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d63:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d67:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d6f:	48 89 c7             	mov    %rax,%rdi
  803d72:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  803d79:	00 00 00 
  803d7c:	ff d0                	callq  *%rax
  803d7e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d80:	b8 00 00 00 00       	mov    $0x0,%eax
  803d85:	eb 33                	jmp    803dba <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8b:	48 89 c6             	mov    %rax,%rsi
  803d8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d93:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  803d9a:	00 00 00 
  803d9d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803da3:	48 89 c6             	mov    %rax,%rsi
  803da6:	bf 00 00 00 00       	mov    $0x0,%edi
  803dab:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  803db2:	00 00 00 
  803db5:	ff d0                	callq  *%rax
err:
	return r;
  803db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803dba:	48 83 c4 38          	add    $0x38,%rsp
  803dbe:	5b                   	pop    %rbx
  803dbf:	5d                   	pop    %rbp
  803dc0:	c3                   	retq   

0000000000803dc1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803dc1:	55                   	push   %rbp
  803dc2:	48 89 e5             	mov    %rsp,%rbp
  803dc5:	53                   	push   %rbx
  803dc6:	48 83 ec 28          	sub    $0x28,%rsp
  803dca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803dd2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dd9:	00 00 00 
  803ddc:	48 8b 00             	mov    (%rax),%rax
  803ddf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803de5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803de8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dec:	48 89 c7             	mov    %rax,%rdi
  803def:	48 b8 9b 46 80 00 00 	movabs $0x80469b,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
  803dfb:	89 c3                	mov    %eax,%ebx
  803dfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e01:	48 89 c7             	mov    %rax,%rdi
  803e04:	48 b8 9b 46 80 00 00 	movabs $0x80469b,%rax
  803e0b:	00 00 00 
  803e0e:	ff d0                	callq  *%rax
  803e10:	39 c3                	cmp    %eax,%ebx
  803e12:	0f 94 c0             	sete   %al
  803e15:	0f b6 c0             	movzbl %al,%eax
  803e18:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e1b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e22:	00 00 00 
  803e25:	48 8b 00             	mov    (%rax),%rax
  803e28:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e2e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e34:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e37:	75 05                	jne    803e3e <_pipeisclosed+0x7d>
			return ret;
  803e39:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e3c:	eb 4f                	jmp    803e8d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803e3e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e41:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e44:	74 42                	je     803e88 <_pipeisclosed+0xc7>
  803e46:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e4a:	75 3c                	jne    803e88 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e4c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e53:	00 00 00 
  803e56:	48 8b 00             	mov    (%rax),%rax
  803e59:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e5f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e65:	89 c6                	mov    %eax,%esi
  803e67:	48 bf c6 4e 80 00 00 	movabs $0x804ec6,%rdi
  803e6e:	00 00 00 
  803e71:	b8 00 00 00 00       	mov    $0x0,%eax
  803e76:	49 b8 1a 03 80 00 00 	movabs $0x80031a,%r8
  803e7d:	00 00 00 
  803e80:	41 ff d0             	callq  *%r8
	}
  803e83:	e9 4a ff ff ff       	jmpq   803dd2 <_pipeisclosed+0x11>
  803e88:	e9 45 ff ff ff       	jmpq   803dd2 <_pipeisclosed+0x11>
}
  803e8d:	48 83 c4 28          	add    $0x28,%rsp
  803e91:	5b                   	pop    %rbx
  803e92:	5d                   	pop    %rbp
  803e93:	c3                   	retq   

0000000000803e94 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e94:	55                   	push   %rbp
  803e95:	48 89 e5             	mov    %rsp,%rbp
  803e98:	48 83 ec 30          	sub    $0x30,%rsp
  803e9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e9f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ea3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ea6:	48 89 d6             	mov    %rdx,%rsi
  803ea9:	89 c7                	mov    %eax,%edi
  803eab:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
  803eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebe:	79 05                	jns    803ec5 <pipeisclosed+0x31>
		return r;
  803ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec3:	eb 31                	jmp    803ef6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec9:	48 89 c7             	mov    %rax,%rdi
  803ecc:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803ed3:	00 00 00 
  803ed6:	ff d0                	callq  *%rax
  803ed8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ee4:	48 89 d6             	mov    %rdx,%rsi
  803ee7:	48 89 c7             	mov    %rax,%rdi
  803eea:	48 b8 c1 3d 80 00 00 	movabs $0x803dc1,%rax
  803ef1:	00 00 00 
  803ef4:	ff d0                	callq  *%rax
}
  803ef6:	c9                   	leaveq 
  803ef7:	c3                   	retq   

0000000000803ef8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ef8:	55                   	push   %rbp
  803ef9:	48 89 e5             	mov    %rsp,%rbp
  803efc:	48 83 ec 40          	sub    $0x40,%rsp
  803f00:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f04:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f08:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f10:	48 89 c7             	mov    %rax,%rdi
  803f13:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
  803f1f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f2b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f32:	00 
  803f33:	e9 92 00 00 00       	jmpq   803fca <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f38:	eb 41                	jmp    803f7b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f3a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f3f:	74 09                	je     803f4a <devpipe_read+0x52>
				return i;
  803f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f45:	e9 92 00 00 00       	jmpq   803fdc <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f52:	48 89 d6             	mov    %rdx,%rsi
  803f55:	48 89 c7             	mov    %rax,%rdi
  803f58:	48 b8 c1 3d 80 00 00 	movabs $0x803dc1,%rax
  803f5f:	00 00 00 
  803f62:	ff d0                	callq  *%rax
  803f64:	85 c0                	test   %eax,%eax
  803f66:	74 07                	je     803f6f <devpipe_read+0x77>
				return 0;
  803f68:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6d:	eb 6d                	jmp    803fdc <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f6f:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f7f:	8b 10                	mov    (%rax),%edx
  803f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f85:	8b 40 04             	mov    0x4(%rax),%eax
  803f88:	39 c2                	cmp    %eax,%edx
  803f8a:	74 ae                	je     803f3a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f94:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f9c:	8b 00                	mov    (%rax),%eax
  803f9e:	99                   	cltd   
  803f9f:	c1 ea 1b             	shr    $0x1b,%edx
  803fa2:	01 d0                	add    %edx,%eax
  803fa4:	83 e0 1f             	and    $0x1f,%eax
  803fa7:	29 d0                	sub    %edx,%eax
  803fa9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fad:	48 98                	cltq   
  803faf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803fb4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fba:	8b 00                	mov    (%rax),%eax
  803fbc:	8d 50 01             	lea    0x1(%rax),%edx
  803fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fc5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fd2:	0f 82 60 ff ff ff    	jb     803f38 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fdc:	c9                   	leaveq 
  803fdd:	c3                   	retq   

0000000000803fde <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fde:	55                   	push   %rbp
  803fdf:	48 89 e5             	mov    %rsp,%rbp
  803fe2:	48 83 ec 40          	sub    $0x40,%rsp
  803fe6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ff2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff6:	48 89 c7             	mov    %rax,%rdi
  803ff9:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  804000:	00 00 00 
  804003:	ff d0                	callq  *%rax
  804005:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804009:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804011:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804018:	00 
  804019:	e9 8e 00 00 00       	jmpq   8040ac <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80401e:	eb 31                	jmp    804051 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804020:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804024:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804028:	48 89 d6             	mov    %rdx,%rsi
  80402b:	48 89 c7             	mov    %rax,%rdi
  80402e:	48 b8 c1 3d 80 00 00 	movabs $0x803dc1,%rax
  804035:	00 00 00 
  804038:	ff d0                	callq  *%rax
  80403a:	85 c0                	test   %eax,%eax
  80403c:	74 07                	je     804045 <devpipe_write+0x67>
				return 0;
  80403e:	b8 00 00 00 00       	mov    $0x0,%eax
  804043:	eb 79                	jmp    8040be <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804045:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80404c:	00 00 00 
  80404f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804051:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804055:	8b 40 04             	mov    0x4(%rax),%eax
  804058:	48 63 d0             	movslq %eax,%rdx
  80405b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405f:	8b 00                	mov    (%rax),%eax
  804061:	48 98                	cltq   
  804063:	48 83 c0 20          	add    $0x20,%rax
  804067:	48 39 c2             	cmp    %rax,%rdx
  80406a:	73 b4                	jae    804020 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80406c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804070:	8b 40 04             	mov    0x4(%rax),%eax
  804073:	99                   	cltd   
  804074:	c1 ea 1b             	shr    $0x1b,%edx
  804077:	01 d0                	add    %edx,%eax
  804079:	83 e0 1f             	and    $0x1f,%eax
  80407c:	29 d0                	sub    %edx,%eax
  80407e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804082:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804086:	48 01 ca             	add    %rcx,%rdx
  804089:	0f b6 0a             	movzbl (%rdx),%ecx
  80408c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804090:	48 98                	cltq   
  804092:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409a:	8b 40 04             	mov    0x4(%rax),%eax
  80409d:	8d 50 01             	lea    0x1(%rax),%edx
  8040a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040b4:	0f 82 64 ff ff ff    	jb     80401e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040be:	c9                   	leaveq 
  8040bf:	c3                   	retq   

00000000008040c0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040c0:	55                   	push   %rbp
  8040c1:	48 89 e5             	mov    %rsp,%rbp
  8040c4:	48 83 ec 20          	sub    $0x20,%rsp
  8040c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d4:	48 89 c7             	mov    %rax,%rdi
  8040d7:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  8040de:	00 00 00 
  8040e1:	ff d0                	callq  *%rax
  8040e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8040e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040eb:	48 be d9 4e 80 00 00 	movabs $0x804ed9,%rsi
  8040f2:	00 00 00 
  8040f5:	48 89 c7             	mov    %rax,%rdi
  8040f8:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8040ff:	00 00 00 
  804102:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804108:	8b 50 04             	mov    0x4(%rax),%edx
  80410b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410f:	8b 00                	mov    (%rax),%eax
  804111:	29 c2                	sub    %eax,%edx
  804113:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804117:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80411d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804121:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804128:	00 00 00 
	stat->st_dev = &devpipe;
  80412b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80412f:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  804136:	00 00 00 
  804139:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804145:	c9                   	leaveq 
  804146:	c3                   	retq   

0000000000804147 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804147:	55                   	push   %rbp
  804148:	48 89 e5             	mov    %rsp,%rbp
  80414b:	48 83 ec 10          	sub    $0x10,%rsp
  80414f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804157:	48 89 c6             	mov    %rax,%rsi
  80415a:	bf 00 00 00 00       	mov    $0x0,%edi
  80415f:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  804166:	00 00 00 
  804169:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80416b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416f:	48 89 c7             	mov    %rax,%rdi
  804172:	48 b8 de 23 80 00 00 	movabs $0x8023de,%rax
  804179:	00 00 00 
  80417c:	ff d0                	callq  *%rax
  80417e:	48 89 c6             	mov    %rax,%rsi
  804181:	bf 00 00 00 00       	mov    $0x0,%edi
  804186:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  80418d:	00 00 00 
  804190:	ff d0                	callq  *%rax
}
  804192:	c9                   	leaveq 
  804193:	c3                   	retq   

0000000000804194 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804194:	55                   	push   %rbp
  804195:	48 89 e5             	mov    %rsp,%rbp
  804198:	48 83 ec 20          	sub    $0x20,%rsp
  80419c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80419f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041a2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8041a5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8041a9:	be 01 00 00 00       	mov    $0x1,%esi
  8041ae:	48 89 c7             	mov    %rax,%rdi
  8041b1:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  8041b8:	00 00 00 
  8041bb:	ff d0                	callq  *%rax
}
  8041bd:	c9                   	leaveq 
  8041be:	c3                   	retq   

00000000008041bf <getchar>:

int
getchar(void)
{
  8041bf:	55                   	push   %rbp
  8041c0:	48 89 e5             	mov    %rsp,%rbp
  8041c3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8041c7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8041cb:	ba 01 00 00 00       	mov    $0x1,%edx
  8041d0:	48 89 c6             	mov    %rax,%rsi
  8041d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8041d8:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  8041df:	00 00 00 
  8041e2:	ff d0                	callq  *%rax
  8041e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8041e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041eb:	79 05                	jns    8041f2 <getchar+0x33>
		return r;
  8041ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f0:	eb 14                	jmp    804206 <getchar+0x47>
	if (r < 1)
  8041f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f6:	7f 07                	jg     8041ff <getchar+0x40>
		return -E_EOF;
  8041f8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8041fd:	eb 07                	jmp    804206 <getchar+0x47>
	return c;
  8041ff:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804203:	0f b6 c0             	movzbl %al,%eax
}
  804206:	c9                   	leaveq 
  804207:	c3                   	retq   

0000000000804208 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804208:	55                   	push   %rbp
  804209:	48 89 e5             	mov    %rsp,%rbp
  80420c:	48 83 ec 20          	sub    $0x20,%rsp
  804210:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804213:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804217:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80421a:	48 89 d6             	mov    %rdx,%rsi
  80421d:	89 c7                	mov    %eax,%edi
  80421f:	48 b8 a1 24 80 00 00 	movabs $0x8024a1,%rax
  804226:	00 00 00 
  804229:	ff d0                	callq  *%rax
  80422b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80422e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804232:	79 05                	jns    804239 <iscons+0x31>
		return r;
  804234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804237:	eb 1a                	jmp    804253 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423d:	8b 10                	mov    (%rax),%edx
  80423f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804246:	00 00 00 
  804249:	8b 00                	mov    (%rax),%eax
  80424b:	39 c2                	cmp    %eax,%edx
  80424d:	0f 94 c0             	sete   %al
  804250:	0f b6 c0             	movzbl %al,%eax
}
  804253:	c9                   	leaveq 
  804254:	c3                   	retq   

0000000000804255 <opencons>:

int
opencons(void)
{
  804255:	55                   	push   %rbp
  804256:	48 89 e5             	mov    %rsp,%rbp
  804259:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80425d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804261:	48 89 c7             	mov    %rax,%rdi
  804264:	48 b8 09 24 80 00 00 	movabs $0x802409,%rax
  80426b:	00 00 00 
  80426e:	ff d0                	callq  *%rax
  804270:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804273:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804277:	79 05                	jns    80427e <opencons+0x29>
		return r;
  804279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427c:	eb 5b                	jmp    8042d9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80427e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804282:	ba 07 04 00 00       	mov    $0x407,%edx
  804287:	48 89 c6             	mov    %rax,%rsi
  80428a:	bf 00 00 00 00       	mov    $0x0,%edi
  80428f:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  804296:	00 00 00 
  804299:	ff d0                	callq  *%rax
  80429b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80429e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a2:	79 05                	jns    8042a9 <opencons+0x54>
		return r;
  8042a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a7:	eb 30                	jmp    8042d9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8042a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ad:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8042b4:	00 00 00 
  8042b7:	8b 12                	mov    (%rdx),%edx
  8042b9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8042bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8042c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ca:	48 89 c7             	mov    %rax,%rdi
  8042cd:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
}
  8042d9:	c9                   	leaveq 
  8042da:	c3                   	retq   

00000000008042db <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8042db:	55                   	push   %rbp
  8042dc:	48 89 e5             	mov    %rsp,%rbp
  8042df:	48 83 ec 30          	sub    $0x30,%rsp
  8042e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8042ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042f4:	75 07                	jne    8042fd <devcons_read+0x22>
		return 0;
  8042f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042fb:	eb 4b                	jmp    804348 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8042fd:	eb 0c                	jmp    80430b <devcons_read+0x30>
		sys_yield();
  8042ff:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  804306:	00 00 00 
  804309:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80430b:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  804312:	00 00 00 
  804315:	ff d0                	callq  *%rax
  804317:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80431a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80431e:	74 df                	je     8042ff <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804324:	79 05                	jns    80432b <devcons_read+0x50>
		return c;
  804326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804329:	eb 1d                	jmp    804348 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80432b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80432f:	75 07                	jne    804338 <devcons_read+0x5d>
		return 0;
  804331:	b8 00 00 00 00       	mov    $0x0,%eax
  804336:	eb 10                	jmp    804348 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80433b:	89 c2                	mov    %eax,%edx
  80433d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804341:	88 10                	mov    %dl,(%rax)
	return 1;
  804343:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804348:	c9                   	leaveq 
  804349:	c3                   	retq   

000000000080434a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80434a:	55                   	push   %rbp
  80434b:	48 89 e5             	mov    %rsp,%rbp
  80434e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804355:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80435c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804363:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80436a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804371:	eb 76                	jmp    8043e9 <devcons_write+0x9f>
		m = n - tot;
  804373:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80437a:	89 c2                	mov    %eax,%edx
  80437c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80437f:	29 c2                	sub    %eax,%edx
  804381:	89 d0                	mov    %edx,%eax
  804383:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804386:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804389:	83 f8 7f             	cmp    $0x7f,%eax
  80438c:	76 07                	jbe    804395 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80438e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804395:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804398:	48 63 d0             	movslq %eax,%rdx
  80439b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80439e:	48 63 c8             	movslq %eax,%rcx
  8043a1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8043a8:	48 01 c1             	add    %rax,%rcx
  8043ab:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8043b2:	48 89 ce             	mov    %rcx,%rsi
  8043b5:	48 89 c7             	mov    %rax,%rdi
  8043b8:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  8043bf:	00 00 00 
  8043c2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8043c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043c7:	48 63 d0             	movslq %eax,%rdx
  8043ca:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8043d1:	48 89 d6             	mov    %rdx,%rsi
  8043d4:	48 89 c7             	mov    %rax,%rdi
  8043d7:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  8043de:	00 00 00 
  8043e1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8043e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043e6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8043e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ec:	48 98                	cltq   
  8043ee:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8043f5:	0f 82 78 ff ff ff    	jb     804373 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8043fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8043fe:	c9                   	leaveq 
  8043ff:	c3                   	retq   

0000000000804400 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804400:	55                   	push   %rbp
  804401:	48 89 e5             	mov    %rsp,%rbp
  804404:	48 83 ec 08          	sub    $0x8,%rsp
  804408:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80440c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804411:	c9                   	leaveq 
  804412:	c3                   	retq   

0000000000804413 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804413:	55                   	push   %rbp
  804414:	48 89 e5             	mov    %rsp,%rbp
  804417:	48 83 ec 10          	sub    $0x10,%rsp
  80441b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80441f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804427:	48 be e5 4e 80 00 00 	movabs $0x804ee5,%rsi
  80442e:	00 00 00 
  804431:	48 89 c7             	mov    %rax,%rdi
  804434:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80443b:	00 00 00 
  80443e:	ff d0                	callq  *%rax
	return 0;
  804440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804445:	c9                   	leaveq 
  804446:	c3                   	retq   

0000000000804447 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804447:	55                   	push   %rbp
  804448:	48 89 e5             	mov    %rsp,%rbp
  80444b:	53                   	push   %rbx
  80444c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804453:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80445a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804460:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804467:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80446e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804475:	84 c0                	test   %al,%al
  804477:	74 23                	je     80449c <_panic+0x55>
  804479:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804480:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804484:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804488:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80448c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804490:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804494:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804498:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80449c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8044a3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8044aa:	00 00 00 
  8044ad:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8044b4:	00 00 00 
  8044b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8044bb:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8044c2:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8044c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8044d0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8044d7:	00 00 00 
  8044da:	48 8b 18             	mov    (%rax),%rbx
  8044dd:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8044e4:	00 00 00 
  8044e7:	ff d0                	callq  *%rax
  8044e9:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8044ef:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8044f6:	41 89 c8             	mov    %ecx,%r8d
  8044f9:	48 89 d1             	mov    %rdx,%rcx
  8044fc:	48 89 da             	mov    %rbx,%rdx
  8044ff:	89 c6                	mov    %eax,%esi
  804501:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  804508:	00 00 00 
  80450b:	b8 00 00 00 00       	mov    $0x0,%eax
  804510:	49 b9 1a 03 80 00 00 	movabs $0x80031a,%r9
  804517:	00 00 00 
  80451a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80451d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804524:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80452b:	48 89 d6             	mov    %rdx,%rsi
  80452e:	48 89 c7             	mov    %rax,%rdi
  804531:	48 b8 6e 02 80 00 00 	movabs $0x80026e,%rax
  804538:	00 00 00 
  80453b:	ff d0                	callq  *%rax
	cprintf("\n");
  80453d:	48 bf 13 4f 80 00 00 	movabs $0x804f13,%rdi
  804544:	00 00 00 
  804547:	b8 00 00 00 00       	mov    $0x0,%eax
  80454c:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  804553:	00 00 00 
  804556:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804558:	cc                   	int3   
  804559:	eb fd                	jmp    804558 <_panic+0x111>

000000000080455b <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80455b:	55                   	push   %rbp
  80455c:	48 89 e5             	mov    %rsp,%rbp
  80455f:	48 83 ec 10          	sub    $0x10,%rsp
  804563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804567:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80456e:	00 00 00 
  804571:	48 8b 00             	mov    (%rax),%rax
  804574:	48 85 c0             	test   %rax,%rax
  804577:	0f 85 84 00 00 00    	jne    804601 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80457d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804584:	00 00 00 
  804587:	48 8b 00             	mov    (%rax),%rax
  80458a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804590:	ba 07 00 00 00       	mov    $0x7,%edx
  804595:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80459a:	89 c7                	mov    %eax,%edi
  80459c:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  8045a3:	00 00 00 
  8045a6:	ff d0                	callq  *%rax
  8045a8:	85 c0                	test   %eax,%eax
  8045aa:	79 2a                	jns    8045d6 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8045ac:	48 ba 18 4f 80 00 00 	movabs $0x804f18,%rdx
  8045b3:	00 00 00 
  8045b6:	be 23 00 00 00       	mov    $0x23,%esi
  8045bb:	48 bf 3f 4f 80 00 00 	movabs $0x804f3f,%rdi
  8045c2:	00 00 00 
  8045c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ca:	48 b9 47 44 80 00 00 	movabs $0x804447,%rcx
  8045d1:	00 00 00 
  8045d4:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8045d6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045dd:	00 00 00 
  8045e0:	48 8b 00             	mov    (%rax),%rax
  8045e3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8045e9:	48 be 14 46 80 00 00 	movabs $0x804614,%rsi
  8045f0:	00 00 00 
  8045f3:	89 c7                	mov    %eax,%edi
  8045f5:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  8045fc:	00 00 00 
  8045ff:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804601:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804608:	00 00 00 
  80460b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80460f:	48 89 10             	mov    %rdx,(%rax)
}
  804612:	c9                   	leaveq 
  804613:	c3                   	retq   

0000000000804614 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804614:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804617:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80461e:	00 00 00 
call *%rax
  804621:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804623:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80462a:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80462b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804632:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804633:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804637:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80463a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804641:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804642:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804646:	4c 8b 3c 24          	mov    (%rsp),%r15
  80464a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80464f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804654:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804659:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80465e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804663:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804668:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80466d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804672:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804677:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80467c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804681:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804686:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80468b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804690:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804694:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804698:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804699:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80469a:	c3                   	retq   

000000000080469b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80469b:	55                   	push   %rbp
  80469c:	48 89 e5             	mov    %rsp,%rbp
  80469f:	48 83 ec 18          	sub    $0x18,%rsp
  8046a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046ab:	48 c1 e8 15          	shr    $0x15,%rax
  8046af:	48 89 c2             	mov    %rax,%rdx
  8046b2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046b9:	01 00 00 
  8046bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046c0:	83 e0 01             	and    $0x1,%eax
  8046c3:	48 85 c0             	test   %rax,%rax
  8046c6:	75 07                	jne    8046cf <pageref+0x34>
		return 0;
  8046c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cd:	eb 53                	jmp    804722 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8046d7:	48 89 c2             	mov    %rax,%rdx
  8046da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046e1:	01 00 00 
  8046e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f0:	83 e0 01             	and    $0x1,%eax
  8046f3:	48 85 c0             	test   %rax,%rax
  8046f6:	75 07                	jne    8046ff <pageref+0x64>
		return 0;
  8046f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fd:	eb 23                	jmp    804722 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804703:	48 c1 e8 0c          	shr    $0xc,%rax
  804707:	48 89 c2             	mov    %rax,%rdx
  80470a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804711:	00 00 00 
  804714:	48 c1 e2 04          	shl    $0x4,%rdx
  804718:	48 01 d0             	add    %rdx,%rax
  80471b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80471f:	0f b7 c0             	movzwl %ax,%eax
}
  804722:	c9                   	leaveq 
  804723:	c3                   	retq   
