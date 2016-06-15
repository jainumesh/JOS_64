
obj/user/fairness.debug:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf 40 3f 80 00 00 	movabs $0x803f40,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf 51 3f 80 00 00 	movabs $0x803f51,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80012d:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013e:	48 63 d0             	movslq %eax,%rdx
  800141:	48 89 d0             	mov    %rdx,%rax
  800144:	48 c1 e0 03          	shl    $0x3,%rax
  800148:	48 01 d0             	add    %rdx,%rax
  80014b:	48 c1 e0 05          	shl    $0x5,%rax
  80014f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800156:	00 00 00 
  800159:	48 01 c2             	add    %rax,%rdx
  80015c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800163:	00 00 00 
  800166:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016d:	7e 14                	jle    800183 <libmain+0x65>
		binaryname = argv[0];
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	48 8b 10             	mov    (%rax),%rdx
  800176:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80017d:	00 00 00 
  800180:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	48 89 d6             	mov    %rdx,%rsi
  80018d:	89 c7                	mov    %eax,%edi
  80018f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80019b:	48 b8 a9 01 80 00 00 	movabs $0x8001a9,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	callq  *%rax
}
  8001a7:	c9                   	leaveq 
  8001a8:	c3                   	retq   

00000000008001a9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a9:	55                   	push   %rbp
  8001aa:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ad:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001be:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax

}
  8001ca:	5d                   	pop    %rbp
  8001cb:	c3                   	retq   

00000000008001cc <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	8b 00                	mov    (%rax),%eax
  8001e1:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e8:	89 0a                	mov    %ecx,(%rdx)
  8001ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ed:	89 d1                	mov    %edx,%ecx
  8001ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f3:	48 98                	cltq   
  8001f5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fd:	8b 00                	mov    (%rax),%eax
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	75 2c                	jne    800232 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	8b 00                	mov    (%rax),%eax
  80020c:	48 98                	cltq   
  80020e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800212:	48 83 c2 08          	add    $0x8,%rdx
  800216:	48 89 c6             	mov    %rax,%rsi
  800219:	48 89 d7             	mov    %rdx,%rdi
  80021c:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
        b->idx = 0;
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800236:	8b 40 04             	mov    0x4(%rax),%eax
  800239:	8d 50 01             	lea    0x1(%rax),%edx
  80023c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800240:	89 50 04             	mov    %edx,0x4(%rax)
}
  800243:	c9                   	leaveq 
  800244:	c3                   	retq   

0000000000800245 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
  800249:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800250:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800257:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80025e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800265:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80026c:	48 8b 0a             	mov    (%rdx),%rcx
  80026f:	48 89 08             	mov    %rcx,(%rax)
  800272:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800276:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80027a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80027e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800289:	00 00 00 
    b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800293:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800296:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80029d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	48 bf cc 01 80 00 00 	movabs $0x8001cc,%rdi
  8002b5:	00 00 00 
  8002b8:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002c4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002ca:	48 98                	cltq   
  8002cc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d3:	48 83 c2 08          	add    $0x8,%rdx
  8002d7:	48 89 c6             	mov    %rax,%rsi
  8002da:	48 89 d7             	mov    %rdx,%rdi
  8002dd:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002ef:	c9                   	leaveq 
  8002f0:	c3                   	retq   

00000000008002f1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002f1:	55                   	push   %rbp
  8002f2:	48 89 e5             	mov    %rsp,%rbp
  8002f5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002fc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800303:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80030a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800311:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800318:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80031f:	84 c0                	test   %al,%al
  800321:	74 20                	je     800343 <cprintf+0x52>
  800323:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800327:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80032b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80032f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800333:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800337:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80033b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80033f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800343:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80034a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800351:	00 00 00 
  800354:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80035b:	00 00 00 
  80035e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800362:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800369:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800370:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800377:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80037e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800385:	48 8b 0a             	mov    (%rdx),%rcx
  800388:	48 89 08             	mov    %rcx,(%rax)
  80038b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80038f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800393:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800397:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80039b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003a9:	48 89 d6             	mov    %rdx,%rsi
  8003ac:	48 89 c7             	mov    %rax,%rdi
  8003af:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  8003b6:	00 00 00 
  8003b9:	ff d0                	callq  *%rax
  8003bb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003c1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003c7:	c9                   	leaveq 
  8003c8:	c3                   	retq   

00000000008003c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	53                   	push   %rbx
  8003ce:	48 83 ec 38          	sub    $0x38,%rsp
  8003d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003de:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003e5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003f0:	77 3b                	ja     80042d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003f5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003f9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800400:	ba 00 00 00 00       	mov    $0x0,%edx
  800405:	48 f7 f3             	div    %rbx
  800408:	48 89 c2             	mov    %rax,%rdx
  80040b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80040e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800411:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800419:	41 89 f9             	mov    %edi,%r9d
  80041c:	48 89 c7             	mov    %rax,%rdi
  80041f:	48 b8 c9 03 80 00 00 	movabs $0x8003c9,%rax
  800426:	00 00 00 
  800429:	ff d0                	callq  *%rax
  80042b:	eb 1e                	jmp    80044b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042d:	eb 12                	jmp    800441 <printnum+0x78>
			putch(padc, putdat);
  80042f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800433:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 89 ce             	mov    %rcx,%rsi
  80043d:	89 d7                	mov    %edx,%edi
  80043f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800441:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800445:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800449:	7f e4                	jg     80042f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80044e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	48 f7 f1             	div    %rcx
  80045a:	48 89 d0             	mov    %rdx,%rax
  80045d:	48 ba 70 41 80 00 00 	movabs $0x804170,%rdx
  800464:	00 00 00 
  800467:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80046b:	0f be d0             	movsbl %al,%edx
  80046e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 d7                	mov    %edx,%edi
  80047b:	ff d0                	callq  *%rax
}
  80047d:	48 83 c4 38          	add    $0x38,%rsp
  800481:	5b                   	pop    %rbx
  800482:	5d                   	pop    %rbp
  800483:	c3                   	retq   

0000000000800484 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800484:	55                   	push   %rbp
  800485:	48 89 e5             	mov    %rsp,%rbp
  800488:	48 83 ec 1c          	sub    $0x1c,%rsp
  80048c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800490:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800493:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800497:	7e 52                	jle    8004eb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	8b 00                	mov    (%rax),%eax
  80049f:	83 f8 30             	cmp    $0x30,%eax
  8004a2:	73 24                	jae    8004c8 <getuint+0x44>
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	8b 00                	mov    (%rax),%eax
  8004b2:	89 c0                	mov    %eax,%eax
  8004b4:	48 01 d0             	add    %rdx,%rax
  8004b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bb:	8b 12                	mov    (%rdx),%edx
  8004bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c4:	89 0a                	mov    %ecx,(%rdx)
  8004c6:	eb 17                	jmp    8004df <getuint+0x5b>
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d0:	48 89 d0             	mov    %rdx,%rax
  8004d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004df:	48 8b 00             	mov    (%rax),%rax
  8004e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004e6:	e9 a3 00 00 00       	jmpq   80058e <getuint+0x10a>
	else if (lflag)
  8004eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ef:	74 4f                	je     800540 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	8b 00                	mov    (%rax),%eax
  8004f7:	83 f8 30             	cmp    $0x30,%eax
  8004fa:	73 24                	jae    800520 <getuint+0x9c>
  8004fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800500:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	89 c0                	mov    %eax,%eax
  80050c:	48 01 d0             	add    %rdx,%rax
  80050f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800513:	8b 12                	mov    (%rdx),%edx
  800515:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051c:	89 0a                	mov    %ecx,(%rdx)
  80051e:	eb 17                	jmp    800537 <getuint+0xb3>
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800528:	48 89 d0             	mov    %rdx,%rax
  80052b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80052f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800533:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800537:	48 8b 00             	mov    (%rax),%rax
  80053a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80053e:	eb 4e                	jmp    80058e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	83 f8 30             	cmp    $0x30,%eax
  800549:	73 24                	jae    80056f <getuint+0xeb>
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800557:	8b 00                	mov    (%rax),%eax
  800559:	89 c0                	mov    %eax,%eax
  80055b:	48 01 d0             	add    %rdx,%rax
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	8b 12                	mov    (%rdx),%edx
  800564:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	89 0a                	mov    %ecx,(%rdx)
  80056d:	eb 17                	jmp    800586 <getuint+0x102>
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800577:	48 89 d0             	mov    %rdx,%rax
  80057a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800582:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80058e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800592:	c9                   	leaveq 
  800593:	c3                   	retq   

0000000000800594 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 83 ec 1c          	sub    $0x1c,%rsp
  80059c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005a7:	7e 52                	jle    8005fb <getint+0x67>
		x=va_arg(*ap, long long);
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	83 f8 30             	cmp    $0x30,%eax
  8005b2:	73 24                	jae    8005d8 <getint+0x44>
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	8b 00                	mov    (%rax),%eax
  8005c2:	89 c0                	mov    %eax,%eax
  8005c4:	48 01 d0             	add    %rdx,%rax
  8005c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cb:	8b 12                	mov    (%rdx),%edx
  8005cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d4:	89 0a                	mov    %ecx,(%rdx)
  8005d6:	eb 17                	jmp    8005ef <getint+0x5b>
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e0:	48 89 d0             	mov    %rdx,%rax
  8005e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ef:	48 8b 00             	mov    (%rax),%rax
  8005f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005f6:	e9 a3 00 00 00       	jmpq   80069e <getint+0x10a>
	else if (lflag)
  8005fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ff:	74 4f                	je     800650 <getint+0xbc>
		x=va_arg(*ap, long);
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	83 f8 30             	cmp    $0x30,%eax
  80060a:	73 24                	jae    800630 <getint+0x9c>
  80060c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800610:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	89 c0                	mov    %eax,%eax
  80061c:	48 01 d0             	add    %rdx,%rax
  80061f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800623:	8b 12                	mov    (%rdx),%edx
  800625:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	89 0a                	mov    %ecx,(%rdx)
  80062e:	eb 17                	jmp    800647 <getint+0xb3>
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800638:	48 89 d0             	mov    %rdx,%rax
  80063b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800643:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800647:	48 8b 00             	mov    (%rax),%rax
  80064a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80064e:	eb 4e                	jmp    80069e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	83 f8 30             	cmp    $0x30,%eax
  800659:	73 24                	jae    80067f <getint+0xeb>
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	8b 00                	mov    (%rax),%eax
  800669:	89 c0                	mov    %eax,%eax
  80066b:	48 01 d0             	add    %rdx,%rax
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	8b 12                	mov    (%rdx),%edx
  800674:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067b:	89 0a                	mov    %ecx,(%rdx)
  80067d:	eb 17                	jmp    800696 <getint+0x102>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800687:	48 89 d0             	mov    %rdx,%rax
  80068a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800692:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800696:	8b 00                	mov    (%rax),%eax
  800698:	48 98                	cltq   
  80069a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80069e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a2:	c9                   	leaveq 
  8006a3:	c3                   	retq   

00000000008006a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a4:	55                   	push   %rbp
  8006a5:	48 89 e5             	mov    %rsp,%rbp
  8006a8:	41 54                	push   %r12
  8006aa:	53                   	push   %rbx
  8006ab:	48 83 ec 60          	sub    $0x60,%rsp
  8006af:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006b7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006bf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006c7:	48 8b 0a             	mov    (%rdx),%rcx
  8006ca:	48 89 08             	mov    %rcx,(%rax)
  8006cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006dd:	eb 17                	jmp    8006f6 <vprintfmt+0x52>
			if (ch == '\0')
  8006df:	85 db                	test   %ebx,%ebx
  8006e1:	0f 84 cc 04 00 00    	je     800bb3 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ef:	48 89 d6             	mov    %rdx,%rsi
  8006f2:	89 df                	mov    %ebx,%edi
  8006f4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800702:	0f b6 00             	movzbl (%rax),%eax
  800705:	0f b6 d8             	movzbl %al,%ebx
  800708:	83 fb 25             	cmp    $0x25,%ebx
  80070b:	75 d2                	jne    8006df <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80070d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800711:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800718:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80071f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800726:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800731:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800735:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800739:	0f b6 00             	movzbl (%rax),%eax
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800742:	83 f8 55             	cmp    $0x55,%eax
  800745:	0f 87 34 04 00 00    	ja     800b7f <vprintfmt+0x4db>
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800754:	00 
  800755:	48 b8 98 41 80 00 00 	movabs $0x804198,%rax
  80075c:	00 00 00 
  80075f:	48 01 d0             	add    %rdx,%rax
  800762:	48 8b 00             	mov    (%rax),%rax
  800765:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800767:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80076b:	eb c0                	jmp    80072d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800771:	eb ba                	jmp    80072d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800773:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80077a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80077d:	89 d0                	mov    %edx,%eax
  80077f:	c1 e0 02             	shl    $0x2,%eax
  800782:	01 d0                	add    %edx,%eax
  800784:	01 c0                	add    %eax,%eax
  800786:	01 d8                	add    %ebx,%eax
  800788:	83 e8 30             	sub    $0x30,%eax
  80078b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80078e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800792:	0f b6 00             	movzbl (%rax),%eax
  800795:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800798:	83 fb 2f             	cmp    $0x2f,%ebx
  80079b:	7e 0c                	jle    8007a9 <vprintfmt+0x105>
  80079d:	83 fb 39             	cmp    $0x39,%ebx
  8007a0:	7f 07                	jg     8007a9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a7:	eb d1                	jmp    80077a <vprintfmt+0xd6>
			goto process_precision;
  8007a9:	eb 58                	jmp    800803 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ae:	83 f8 30             	cmp    $0x30,%eax
  8007b1:	73 17                	jae    8007ca <vprintfmt+0x126>
  8007b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	89 c0                	mov    %eax,%eax
  8007bc:	48 01 d0             	add    %rdx,%rax
  8007bf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c2:	83 c2 08             	add    $0x8,%edx
  8007c5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c8:	eb 0f                	jmp    8007d9 <vprintfmt+0x135>
  8007ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ce:	48 89 d0             	mov    %rdx,%rax
  8007d1:	48 83 c2 08          	add    $0x8,%rdx
  8007d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007de:	eb 23                	jmp    800803 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e4:	79 0c                	jns    8007f2 <vprintfmt+0x14e>
				width = 0;
  8007e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ed:	e9 3b ff ff ff       	jmpq   80072d <vprintfmt+0x89>
  8007f2:	e9 36 ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007fe:	e9 2a ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800803:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800807:	79 12                	jns    80081b <vprintfmt+0x177>
				width = precision, precision = -1;
  800809:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80080c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80080f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800816:	e9 12 ff ff ff       	jmpq   80072d <vprintfmt+0x89>
  80081b:	e9 0d ff ff ff       	jmpq   80072d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800820:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800824:	e9 04 ff ff ff       	jmpq   80072d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800829:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082c:	83 f8 30             	cmp    $0x30,%eax
  80082f:	73 17                	jae    800848 <vprintfmt+0x1a4>
  800831:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800835:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800838:	89 c0                	mov    %eax,%eax
  80083a:	48 01 d0             	add    %rdx,%rax
  80083d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800840:	83 c2 08             	add    $0x8,%edx
  800843:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800846:	eb 0f                	jmp    800857 <vprintfmt+0x1b3>
  800848:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084c:	48 89 d0             	mov    %rdx,%rax
  80084f:	48 83 c2 08          	add    $0x8,%rdx
  800853:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800857:	8b 10                	mov    (%rax),%edx
  800859:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80085d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800861:	48 89 ce             	mov    %rcx,%rsi
  800864:	89 d7                	mov    %edx,%edi
  800866:	ff d0                	callq  *%rax
			break;
  800868:	e9 40 03 00 00       	jmpq   800bad <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80086d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800870:	83 f8 30             	cmp    $0x30,%eax
  800873:	73 17                	jae    80088c <vprintfmt+0x1e8>
  800875:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800884:	83 c2 08             	add    $0x8,%edx
  800887:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088a:	eb 0f                	jmp    80089b <vprintfmt+0x1f7>
  80088c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800890:	48 89 d0             	mov    %rdx,%rax
  800893:	48 83 c2 08          	add    $0x8,%rdx
  800897:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80089d:	85 db                	test   %ebx,%ebx
  80089f:	79 02                	jns    8008a3 <vprintfmt+0x1ff>
				err = -err;
  8008a1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a3:	83 fb 15             	cmp    $0x15,%ebx
  8008a6:	7f 16                	jg     8008be <vprintfmt+0x21a>
  8008a8:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8008af:	00 00 00 
  8008b2:	48 63 d3             	movslq %ebx,%rdx
  8008b5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008b9:	4d 85 e4             	test   %r12,%r12
  8008bc:	75 2e                	jne    8008ec <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008be:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c6:	89 d9                	mov    %ebx,%ecx
  8008c8:	48 ba 81 41 80 00 00 	movabs $0x804181,%rdx
  8008cf:	00 00 00 
  8008d2:	48 89 c7             	mov    %rax,%rdi
  8008d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008da:	49 b8 bc 0b 80 00 00 	movabs $0x800bbc,%r8
  8008e1:	00 00 00 
  8008e4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e7:	e9 c1 02 00 00       	jmpq   800bad <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f4:	4c 89 e1             	mov    %r12,%rcx
  8008f7:	48 ba 8a 41 80 00 00 	movabs $0x80418a,%rdx
  8008fe:	00 00 00 
  800901:	48 89 c7             	mov    %rax,%rdi
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	49 b8 bc 0b 80 00 00 	movabs $0x800bbc,%r8
  800910:	00 00 00 
  800913:	41 ff d0             	callq  *%r8
			break;
  800916:	e9 92 02 00 00       	jmpq   800bad <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	83 f8 30             	cmp    $0x30,%eax
  800921:	73 17                	jae    80093a <vprintfmt+0x296>
  800923:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800927:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092a:	89 c0                	mov    %eax,%eax
  80092c:	48 01 d0             	add    %rdx,%rax
  80092f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800932:	83 c2 08             	add    $0x8,%edx
  800935:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800938:	eb 0f                	jmp    800949 <vprintfmt+0x2a5>
  80093a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093e:	48 89 d0             	mov    %rdx,%rax
  800941:	48 83 c2 08          	add    $0x8,%rdx
  800945:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800949:	4c 8b 20             	mov    (%rax),%r12
  80094c:	4d 85 e4             	test   %r12,%r12
  80094f:	75 0a                	jne    80095b <vprintfmt+0x2b7>
				p = "(null)";
  800951:	49 bc 8d 41 80 00 00 	movabs $0x80418d,%r12
  800958:	00 00 00 
			if (width > 0 && padc != '-')
  80095b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095f:	7e 3f                	jle    8009a0 <vprintfmt+0x2fc>
  800961:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800965:	74 39                	je     8009a0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800967:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80096a:	48 98                	cltq   
  80096c:	48 89 c6             	mov    %rax,%rsi
  80096f:	4c 89 e7             	mov    %r12,%rdi
  800972:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800981:	eb 17                	jmp    80099a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800983:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800987:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80098b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098f:	48 89 ce             	mov    %rcx,%rsi
  800992:	89 d7                	mov    %edx,%edi
  800994:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800996:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099e:	7f e3                	jg     800983 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a0:	eb 37                	jmp    8009d9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009a6:	74 1e                	je     8009c6 <vprintfmt+0x322>
  8009a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ab:	7e 05                	jle    8009b2 <vprintfmt+0x30e>
  8009ad:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b0:	7e 14                	jle    8009c6 <vprintfmt+0x322>
					putch('?', putdat);
  8009b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ba:	48 89 d6             	mov    %rdx,%rsi
  8009bd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c2:	ff d0                	callq  *%rax
  8009c4:	eb 0f                	jmp    8009d5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ce:	48 89 d6             	mov    %rdx,%rsi
  8009d1:	89 df                	mov    %ebx,%edi
  8009d3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d9:	4c 89 e0             	mov    %r12,%rax
  8009dc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009e0:	0f b6 00             	movzbl (%rax),%eax
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 10                	je     8009fa <vprintfmt+0x356>
  8009ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ee:	78 b2                	js     8009a2 <vprintfmt+0x2fe>
  8009f0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f8:	79 a8                	jns    8009a2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fa:	eb 16                	jmp    800a12 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a04:	48 89 d6             	mov    %rdx,%rsi
  800a07:	bf 20 00 00 00       	mov    $0x20,%edi
  800a0c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a16:	7f e4                	jg     8009fc <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a18:	e9 90 01 00 00       	jmpq   800bad <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a21:	be 03 00 00 00       	mov    $0x3,%esi
  800a26:	48 89 c7             	mov    %rax,%rdi
  800a29:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  800a30:	00 00 00 
  800a33:	ff d0                	callq  *%rax
  800a35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	48 85 c0             	test   %rax,%rax
  800a40:	79 1d                	jns    800a5f <vprintfmt+0x3bb>
				putch('-', putdat);
  800a42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4a:	48 89 d6             	mov    %rdx,%rsi
  800a4d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a52:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 f7 d8             	neg    %rax
  800a5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a5f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a66:	e9 d5 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a6b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6f:	be 03 00 00 00       	mov    $0x3,%esi
  800a74:	48 89 c7             	mov    %rax,%rdi
  800a77:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  800a7e:	00 00 00 
  800a81:	ff d0                	callq  *%rax
  800a83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a87:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8e:	e9 ad 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a93:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9a:	89 d6                	mov    %edx,%esi
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
  800aab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aaf:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ab6:	e9 85 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800abb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	bf 30 00 00 00       	mov    $0x30,%edi
  800acb:	ff d0                	callq  *%rax
			putch('x', putdat);
  800acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad5:	48 89 d6             	mov    %rdx,%rsi
  800ad8:	bf 78 00 00 00       	mov    $0x78,%edi
  800add:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae2:	83 f8 30             	cmp    $0x30,%eax
  800ae5:	73 17                	jae    800afe <vprintfmt+0x45a>
  800ae7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	89 c0                	mov    %eax,%eax
  800af0:	48 01 d0             	add    %rdx,%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	83 c2 08             	add    $0x8,%edx
  800af9:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afc:	eb 0f                	jmp    800b0d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b14:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b1b:	eb 23                	jmp    800b40 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b21:	be 03 00 00 00       	mov    $0x3,%esi
  800b26:	48 89 c7             	mov    %rax,%rdi
  800b29:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
  800b35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b39:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b40:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b45:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b48:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b57:	45 89 c1             	mov    %r8d,%r9d
  800b5a:	41 89 f8             	mov    %edi,%r8d
  800b5d:	48 89 c7             	mov    %rax,%rdi
  800b60:	48 b8 c9 03 80 00 00 	movabs $0x8003c9,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	callq  *%rax
			break;
  800b6c:	eb 3f                	jmp    800bad <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b76:	48 89 d6             	mov    %rdx,%rsi
  800b79:	89 df                	mov    %ebx,%edi
  800b7b:	ff d0                	callq  *%rax
			break;
  800b7d:	eb 2e                	jmp    800bad <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b87:	48 89 d6             	mov    %rdx,%rsi
  800b8a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b8f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b91:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b96:	eb 05                	jmp    800b9d <vprintfmt+0x4f9>
  800b98:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba1:	48 83 e8 01          	sub    $0x1,%rax
  800ba5:	0f b6 00             	movzbl (%rax),%eax
  800ba8:	3c 25                	cmp    $0x25,%al
  800baa:	75 ec                	jne    800b98 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bac:	90                   	nop
		}
	}
  800bad:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bae:	e9 43 fb ff ff       	jmpq   8006f6 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bb3:	48 83 c4 60          	add    $0x60,%rsp
  800bb7:	5b                   	pop    %rbx
  800bb8:	41 5c                	pop    %r12
  800bba:	5d                   	pop    %rbp
  800bbb:	c3                   	retq   

0000000000800bbc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbc:	55                   	push   %rbp
  800bbd:	48 89 e5             	mov    %rsp,%rbp
  800bc0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bc7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bce:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bd5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bdc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bea:	84 c0                	test   %al,%al
  800bec:	74 20                	je     800c0e <printfmt+0x52>
  800bee:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bf6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bfa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bfe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c02:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c06:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c0a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c0e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c15:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c1c:	00 00 00 
  800c1f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c26:	00 00 00 
  800c29:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c2d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c34:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c3b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c42:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c49:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c50:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c57:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c5e:	48 89 c7             	mov    %rax,%rdi
  800c61:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  800c68:	00 00 00 
  800c6b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c6d:	c9                   	leaveq 
  800c6e:	c3                   	retq   

0000000000800c6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6f:	55                   	push   %rbp
  800c70:	48 89 e5             	mov    %rsp,%rbp
  800c73:	48 83 ec 10          	sub    $0x10,%rsp
  800c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	8b 40 10             	mov    0x10(%rax),%eax
  800c85:	8d 50 01             	lea    0x1(%rax),%edx
  800c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c93:	48 8b 10             	mov    (%rax),%rdx
  800c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9e:	48 39 c2             	cmp    %rax,%rdx
  800ca1:	73 17                	jae    800cba <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca7:	48 8b 00             	mov    (%rax),%rax
  800caa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb2:	48 89 0a             	mov    %rcx,(%rdx)
  800cb5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cb8:	88 10                	mov    %dl,(%rax)
}
  800cba:	c9                   	leaveq 
  800cbb:	c3                   	retq   

0000000000800cbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
  800cc0:	48 83 ec 50          	sub    $0x50,%rsp
  800cc4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cc8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ccb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ccf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cd7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cdb:	48 8b 0a             	mov    (%rdx),%rcx
  800cde:	48 89 08             	mov    %rcx,(%rax)
  800ce1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ced:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cf9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cfc:	48 98                	cltq   
  800cfe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d06:	48 01 d0             	add    %rdx,%rax
  800d09:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d14:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d19:	74 06                	je     800d21 <vsnprintf+0x65>
  800d1b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d1f:	7f 07                	jg     800d28 <vsnprintf+0x6c>
		return -E_INVAL;
  800d21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d26:	eb 2f                	jmp    800d57 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d28:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d2c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d30:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d34:	48 89 c6             	mov    %rax,%rsi
  800d37:	48 bf 6f 0c 80 00 00 	movabs $0x800c6f,%rdi
  800d3e:	00 00 00 
  800d41:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  800d48:	00 00 00 
  800d4b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d51:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d54:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d57:	c9                   	leaveq 
  800d58:	c3                   	retq   

0000000000800d59 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d59:	55                   	push   %rbp
  800d5a:	48 89 e5             	mov    %rsp,%rbp
  800d5d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d64:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d6b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d71:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d78:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d7f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d86:	84 c0                	test   %al,%al
  800d88:	74 20                	je     800daa <snprintf+0x51>
  800d8a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d92:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d96:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800daa:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800db8:	00 00 00 
  800dbb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc2:	00 00 00 
  800dc5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dde:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dec:	48 8b 0a             	mov    (%rdx),%rcx
  800def:	48 89 08             	mov    %rcx,(%rax)
  800df2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dfa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dfe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e02:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e09:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e10:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e16:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e1d:	48 89 c7             	mov    %rax,%rdi
  800e20:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800e27:	00 00 00 
  800e2a:	ff d0                	callq  *%rax
  800e2c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e32:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e38:	c9                   	leaveq 
  800e39:	c3                   	retq   

0000000000800e3a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e3a:	55                   	push   %rbp
  800e3b:	48 89 e5             	mov    %rsp,%rbp
  800e3e:	48 83 ec 18          	sub    $0x18,%rsp
  800e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e4d:	eb 09                	jmp    800e58 <strlen+0x1e>
		n++;
  800e4f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e53:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5c:	0f b6 00             	movzbl (%rax),%eax
  800e5f:	84 c0                	test   %al,%al
  800e61:	75 ec                	jne    800e4f <strlen+0x15>
		n++;
	return n;
  800e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e66:	c9                   	leaveq 
  800e67:	c3                   	retq   

0000000000800e68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e68:	55                   	push   %rbp
  800e69:	48 89 e5             	mov    %rsp,%rbp
  800e6c:	48 83 ec 20          	sub    $0x20,%rsp
  800e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e7f:	eb 0e                	jmp    800e8f <strnlen+0x27>
		n++;
  800e81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e85:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e8f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e94:	74 0b                	je     800ea1 <strnlen+0x39>
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	0f b6 00             	movzbl (%rax),%eax
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e0                	jne    800e81 <strnlen+0x19>
		n++;
	return n;
  800ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea4:	c9                   	leaveq 
  800ea5:	c3                   	retq   

0000000000800ea6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea6:	55                   	push   %rbp
  800ea7:	48 89 e5             	mov    %rsp,%rbp
  800eaa:	48 83 ec 20          	sub    $0x20,%rsp
  800eae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ebe:	90                   	nop
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ecb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ecf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ed7:	0f b6 12             	movzbl (%rdx),%edx
  800eda:	88 10                	mov    %dl,(%rax)
  800edc:	0f b6 00             	movzbl (%rax),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 dc                	jne    800ebf <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee7:	c9                   	leaveq 
  800ee8:	c3                   	retq   

0000000000800ee9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ee9:	55                   	push   %rbp
  800eea:	48 89 e5             	mov    %rsp,%rbp
  800eed:	48 83 ec 20          	sub    $0x20,%rsp
  800ef1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	48 89 c7             	mov    %rax,%rdi
  800f00:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	callq  *%rax
  800f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f12:	48 63 d0             	movslq %eax,%rdx
  800f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f19:	48 01 c2             	add    %rax,%rdx
  800f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f20:	48 89 c6             	mov    %rax,%rsi
  800f23:	48 89 d7             	mov    %rdx,%rdi
  800f26:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  800f2d:	00 00 00 
  800f30:	ff d0                	callq  *%rax
	return dst;
  800f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f36:	c9                   	leaveq 
  800f37:	c3                   	retq   

0000000000800f38 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f38:	55                   	push   %rbp
  800f39:	48 89 e5             	mov    %rsp,%rbp
  800f3c:	48 83 ec 28          	sub    $0x28,%rsp
  800f40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f54:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f5b:	00 
  800f5c:	eb 2a                	jmp    800f88 <strncpy+0x50>
		*dst++ = *src;
  800f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6e:	0f b6 12             	movzbl (%rdx),%edx
  800f71:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	84 c0                	test   %al,%al
  800f7c:	74 05                	je     800f83 <strncpy+0x4b>
			src++;
  800f7e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f83:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f90:	72 cc                	jb     800f5e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 28          	sub    $0x28,%rsp
  800fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fb4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fb9:	74 3d                	je     800ff8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fbb:	eb 1d                	jmp    800fda <strlcpy+0x42>
			*dst++ = *src++;
  800fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fc9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fcd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fd1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fd5:	0f b6 12             	movzbl (%rdx),%edx
  800fd8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fda:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fdf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe4:	74 0b                	je     800ff1 <strlcpy+0x59>
  800fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fea:	0f b6 00             	movzbl (%rax),%eax
  800fed:	84 c0                	test   %al,%al
  800fef:	75 cc                	jne    800fbd <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ff8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801000:	48 29 c2             	sub    %rax,%rdx
  801003:	48 89 d0             	mov    %rdx,%rax
}
  801006:	c9                   	leaveq 
  801007:	c3                   	retq   

0000000000801008 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801008:	55                   	push   %rbp
  801009:	48 89 e5             	mov    %rsp,%rbp
  80100c:	48 83 ec 10          	sub    $0x10,%rsp
  801010:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801014:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801018:	eb 0a                	jmp    801024 <strcmp+0x1c>
		p++, q++;
  80101a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801028:	0f b6 00             	movzbl (%rax),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	74 12                	je     801041 <strcmp+0x39>
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801033:	0f b6 10             	movzbl (%rax),%edx
  801036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103a:	0f b6 00             	movzbl (%rax),%eax
  80103d:	38 c2                	cmp    %al,%dl
  80103f:	74 d9                	je     80101a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	0f b6 d0             	movzbl %al,%edx
  80104b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	0f b6 c0             	movzbl %al,%eax
  801055:	29 c2                	sub    %eax,%edx
  801057:	89 d0                	mov    %edx,%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 18          	sub    $0x18,%rsp
  801063:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801067:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80106b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80106f:	eb 0f                	jmp    801080 <strncmp+0x25>
		n--, p++, q++;
  801071:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801076:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801080:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801085:	74 1d                	je     8010a4 <strncmp+0x49>
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	0f b6 00             	movzbl (%rax),%eax
  80108e:	84 c0                	test   %al,%al
  801090:	74 12                	je     8010a4 <strncmp+0x49>
  801092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801096:	0f b6 10             	movzbl (%rax),%edx
  801099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109d:	0f b6 00             	movzbl (%rax),%eax
  8010a0:	38 c2                	cmp    %al,%dl
  8010a2:	74 cd                	je     801071 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a9:	75 07                	jne    8010b2 <strncmp+0x57>
		return 0;
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b0:	eb 18                	jmp    8010ca <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	0f b6 d0             	movzbl %al,%edx
  8010bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	0f b6 c0             	movzbl %al,%eax
  8010c6:	29 c2                	sub    %eax,%edx
  8010c8:	89 d0                	mov    %edx,%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8010d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d8:	89 f0                	mov    %esi,%eax
  8010da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010dd:	eb 17                	jmp    8010f6 <strchr+0x2a>
		if (*s == c)
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e3:	0f b6 00             	movzbl (%rax),%eax
  8010e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e9:	75 06                	jne    8010f1 <strchr+0x25>
			return (char *) s;
  8010eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ef:	eb 15                	jmp    801106 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	75 de                	jne    8010df <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 0c          	sub    $0xc,%rsp
  801110:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801114:	89 f0                	mov    %esi,%eax
  801116:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801119:	eb 13                	jmp    80112e <strfind+0x26>
		if (*s == c)
  80111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111f:	0f b6 00             	movzbl (%rax),%eax
  801122:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801125:	75 02                	jne    801129 <strfind+0x21>
			break;
  801127:	eb 10                	jmp    801139 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801129:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801132:	0f b6 00             	movzbl (%rax),%eax
  801135:	84 c0                	test   %al,%al
  801137:	75 e2                	jne    80111b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 18          	sub    $0x18,%rsp
  801147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80114e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801152:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801157:	75 06                	jne    80115f <memset+0x20>
		return v;
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115d:	eb 69                	jmp    8011c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801163:	83 e0 03             	and    $0x3,%eax
  801166:	48 85 c0             	test   %rax,%rax
  801169:	75 48                	jne    8011b3 <memset+0x74>
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116f:	83 e0 03             	and    $0x3,%eax
  801172:	48 85 c0             	test   %rax,%rax
  801175:	75 3c                	jne    8011b3 <memset+0x74>
		c &= 0xFF;
  801177:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80117e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801181:	c1 e0 18             	shl    $0x18,%eax
  801184:	89 c2                	mov    %eax,%edx
  801186:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801189:	c1 e0 10             	shl    $0x10,%eax
  80118c:	09 c2                	or     %eax,%edx
  80118e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801191:	c1 e0 08             	shl    $0x8,%eax
  801194:	09 d0                	or     %edx,%eax
  801196:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119d:	48 c1 e8 02          	shr    $0x2,%rax
  8011a1:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ab:	48 89 d7             	mov    %rdx,%rdi
  8011ae:	fc                   	cld    
  8011af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011b1:	eb 11                	jmp    8011c4 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011be:	48 89 d7             	mov    %rdx,%rdi
  8011c1:	fc                   	cld    
  8011c2:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 83 ec 28          	sub    $0x28,%rsp
  8011d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f6:	0f 83 88 00 00 00    	jae    801284 <memmove+0xba>
  8011fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801200:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801204:	48 01 d0             	add    %rdx,%rax
  801207:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80120b:	76 77                	jbe    801284 <memmove+0xba>
		s += n;
  80120d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801211:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801219:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 3b                	jne    801264 <memmove+0x9a>
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	83 e0 03             	and    $0x3,%eax
  801230:	48 85 c0             	test   %rax,%rax
  801233:	75 2f                	jne    801264 <memmove+0x9a>
  801235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801239:	83 e0 03             	and    $0x3,%eax
  80123c:	48 85 c0             	test   %rax,%rax
  80123f:	75 23                	jne    801264 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801245:	48 83 e8 04          	sub    $0x4,%rax
  801249:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124d:	48 83 ea 04          	sub    $0x4,%rdx
  801251:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801255:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801259:	48 89 c7             	mov    %rax,%rdi
  80125c:	48 89 d6             	mov    %rdx,%rsi
  80125f:	fd                   	std    
  801260:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801262:	eb 1d                	jmp    801281 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801268:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	48 89 d7             	mov    %rdx,%rdi
  80127b:	48 89 c1             	mov    %rax,%rcx
  80127e:	fd                   	std    
  80127f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801281:	fc                   	cld    
  801282:	eb 57                	jmp    8012db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	83 e0 03             	and    $0x3,%eax
  80128b:	48 85 c0             	test   %rax,%rax
  80128e:	75 36                	jne    8012c6 <memmove+0xfc>
  801290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801294:	83 e0 03             	and    $0x3,%eax
  801297:	48 85 c0             	test   %rax,%rax
  80129a:	75 2a                	jne    8012c6 <memmove+0xfc>
  80129c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a0:	83 e0 03             	and    $0x3,%eax
  8012a3:	48 85 c0             	test   %rax,%rax
  8012a6:	75 1e                	jne    8012c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ac:	48 c1 e8 02          	shr    $0x2,%rax
  8012b0:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bb:	48 89 c7             	mov    %rax,%rdi
  8012be:	48 89 d6             	mov    %rdx,%rsi
  8012c1:	fc                   	cld    
  8012c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c4:	eb 15                	jmp    8012db <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 89 d6             	mov    %rdx,%rsi
  8012d8:	fc                   	cld    
  8012d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 18          	sub    $0x18,%rsp
  8012e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	48 89 ce             	mov    %rcx,%rsi
  801304:	48 89 c7             	mov    %rax,%rdi
  801307:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80130e:	00 00 00 
  801311:	ff d0                	callq  *%rax
}
  801313:	c9                   	leaveq 
  801314:	c3                   	retq   

0000000000801315 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801315:	55                   	push   %rbp
  801316:	48 89 e5             	mov    %rsp,%rbp
  801319:	48 83 ec 28          	sub    $0x28,%rsp
  80131d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801325:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801339:	eb 36                	jmp    801371 <memcmp+0x5c>
		if (*s1 != *s2)
  80133b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133f:	0f b6 10             	movzbl (%rax),%edx
  801342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801346:	0f b6 00             	movzbl (%rax),%eax
  801349:	38 c2                	cmp    %al,%dl
  80134b:	74 1a                	je     801367 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	0f b6 d0             	movzbl %al,%edx
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	0f b6 c0             	movzbl %al,%eax
  801361:	29 c2                	sub    %eax,%edx
  801363:	89 d0                	mov    %edx,%eax
  801365:	eb 20                	jmp    801387 <memcmp+0x72>
		s1++, s2++;
  801367:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801375:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801379:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 b9                	jne    80133b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 28          	sub    $0x28,%rsp
  801391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801395:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801398:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a4:	48 01 d0             	add    %rdx,%rax
  8013a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ab:	eb 15                	jmp    8013c2 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b1:	0f b6 10             	movzbl (%rax),%edx
  8013b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013b7:	38 c2                	cmp    %al,%dl
  8013b9:	75 02                	jne    8013bd <memfind+0x34>
			break;
  8013bb:	eb 0f                	jmp    8013cc <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013ca:	72 e1                	jb     8013ad <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d0:	c9                   	leaveq 
  8013d1:	c3                   	retq   

00000000008013d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d2:	55                   	push   %rbp
  8013d3:	48 89 e5             	mov    %rsp,%rbp
  8013d6:	48 83 ec 34          	sub    $0x34,%rsp
  8013da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ec:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f4:	eb 05                	jmp    8013fb <strtol+0x29>
		s++;
  8013f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	3c 20                	cmp    $0x20,%al
  801404:	74 f0                	je     8013f6 <strtol+0x24>
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3c 09                	cmp    $0x9,%al
  80140f:	74 e5                	je     8013f6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	3c 2b                	cmp    $0x2b,%al
  80141a:	75 07                	jne    801423 <strtol+0x51>
		s++;
  80141c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801421:	eb 17                	jmp    80143a <strtol+0x68>
	else if (*s == '-')
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	3c 2d                	cmp    $0x2d,%al
  80142c:	75 0c                	jne    80143a <strtol+0x68>
		s++, neg = 1;
  80142e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801433:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80143e:	74 06                	je     801446 <strtol+0x74>
  801440:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801444:	75 28                	jne    80146e <strtol+0x9c>
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3c 30                	cmp    $0x30,%al
  80144f:	75 1d                	jne    80146e <strtol+0x9c>
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	48 83 c0 01          	add    $0x1,%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3c 78                	cmp    $0x78,%al
  80145e:	75 0e                	jne    80146e <strtol+0x9c>
		s += 2, base = 16;
  801460:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801465:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80146c:	eb 2c                	jmp    80149a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80146e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801472:	75 19                	jne    80148d <strtol+0xbb>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	3c 30                	cmp    $0x30,%al
  80147d:	75 0e                	jne    80148d <strtol+0xbb>
		s++, base = 8;
  80147f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801484:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80148b:	eb 0d                	jmp    80149a <strtol+0xc8>
	else if (base == 0)
  80148d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801491:	75 07                	jne    80149a <strtol+0xc8>
		base = 10;
  801493:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 2f                	cmp    $0x2f,%al
  8014a3:	7e 1d                	jle    8014c2 <strtol+0xf0>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	3c 39                	cmp    $0x39,%al
  8014ae:	7f 12                	jg     8014c2 <strtol+0xf0>
			dig = *s - '0';
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	0f be c0             	movsbl %al,%eax
  8014ba:	83 e8 30             	sub    $0x30,%eax
  8014bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c0:	eb 4e                	jmp    801510 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 60                	cmp    $0x60,%al
  8014cb:	7e 1d                	jle    8014ea <strtol+0x118>
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	3c 7a                	cmp    $0x7a,%al
  8014d6:	7f 12                	jg     8014ea <strtol+0x118>
			dig = *s - 'a' + 10;
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	0f be c0             	movsbl %al,%eax
  8014e2:	83 e8 57             	sub    $0x57,%eax
  8014e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e8:	eb 26                	jmp    801510 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 40                	cmp    $0x40,%al
  8014f3:	7e 48                	jle    80153d <strtol+0x16b>
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	3c 5a                	cmp    $0x5a,%al
  8014fe:	7f 3d                	jg     80153d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	0f be c0             	movsbl %al,%eax
  80150a:	83 e8 37             	sub    $0x37,%eax
  80150d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801513:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801516:	7c 02                	jl     80151a <strtol+0x148>
			break;
  801518:	eb 23                	jmp    80153d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80151a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80151f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801522:	48 98                	cltq   
  801524:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801529:	48 89 c2             	mov    %rax,%rdx
  80152c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80152f:	48 98                	cltq   
  801531:	48 01 d0             	add    %rdx,%rax
  801534:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801538:	e9 5d ff ff ff       	jmpq   80149a <strtol+0xc8>

	if (endptr)
  80153d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801542:	74 0b                	je     80154f <strtol+0x17d>
		*endptr = (char *) s;
  801544:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801548:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80154c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80154f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801553:	74 09                	je     80155e <strtol+0x18c>
  801555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801559:	48 f7 d8             	neg    %rax
  80155c:	eb 04                	jmp    801562 <strtol+0x190>
  80155e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801562:	c9                   	leaveq 
  801563:	c3                   	retq   

0000000000801564 <strstr>:

char * strstr(const char *in, const char *str)
{
  801564:	55                   	push   %rbp
  801565:	48 89 e5             	mov    %rsp,%rbp
  801568:	48 83 ec 30          	sub    $0x30,%rsp
  80156c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801570:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801574:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801578:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80157c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801586:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80158a:	75 06                	jne    801592 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	eb 6b                	jmp    8015fd <strstr+0x99>

	len = strlen(str);
  801592:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801596:	48 89 c7             	mov    %rax,%rdi
  801599:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
  8015a5:	48 98                	cltq   
  8015a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c1:	75 07                	jne    8015ca <strstr+0x66>
				return (char *) 0;
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	eb 33                	jmp    8015fd <strstr+0x99>
		} while (sc != c);
  8015ca:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015ce:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d1:	75 d8                	jne    8015ab <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 89 ce             	mov    %rcx,%rsi
  8015e2:	48 89 c7             	mov    %rax,%rdi
  8015e5:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  8015ec:	00 00 00 
  8015ef:	ff d0                	callq  *%rax
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	75 b6                	jne    8015ab <strstr+0x47>

	return (char *) (in - 1);
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	48 83 e8 01          	sub    $0x1,%rax
}
  8015fd:	c9                   	leaveq 
  8015fe:	c3                   	retq   

00000000008015ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015ff:	55                   	push   %rbp
  801600:	48 89 e5             	mov    %rsp,%rbp
  801603:	53                   	push   %rbx
  801604:	48 83 ec 48          	sub    $0x48,%rsp
  801608:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80160b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80160e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801612:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801616:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80161a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801621:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801625:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801629:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80162d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801631:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801635:	4c 89 c3             	mov    %r8,%rbx
  801638:	cd 30                	int    $0x30
  80163a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80163e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801642:	74 3e                	je     801682 <syscall+0x83>
  801644:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801649:	7e 37                	jle    801682 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80164b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801652:	49 89 d0             	mov    %rdx,%r8
  801655:	89 c1                	mov    %eax,%ecx
  801657:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  80165e:	00 00 00 
  801661:	be 23 00 00 00       	mov    $0x23,%esi
  801666:	48 bf 65 44 80 00 00 	movabs $0x804465,%rdi
  80166d:	00 00 00 
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	49 b9 84 3d 80 00 00 	movabs $0x803d84,%r9
  80167c:	00 00 00 
  80167f:	41 ff d1             	callq  *%r9

	return ret;
  801682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801686:	48 83 c4 48          	add    $0x48,%rsp
  80168a:	5b                   	pop    %rbx
  80168b:	5d                   	pop    %rbp
  80168c:	c3                   	retq   

000000000080168d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	48 83 ec 20          	sub    $0x20,%rsp
  801695:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801699:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80169d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ac:	00 
  8016ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b9:	48 89 d1             	mov    %rdx,%rcx
  8016bc:	48 89 c2             	mov    %rax,%rdx
  8016bf:	be 00 00 00 00       	mov    $0x0,%esi
  8016c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c9:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	callq  *%rax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e6:	00 
  8016e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	be 00 00 00 00       	mov    $0x0,%esi
  801702:	bf 01 00 00 00       	mov    $0x1,%edi
  801707:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80170e:	00 00 00 
  801711:	ff d0                	callq  *%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	48 83 ec 10          	sub    $0x10,%rsp
  80171d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801720:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801723:	48 98                	cltq   
  801725:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172c:	00 
  80172d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801733:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173e:	48 89 c2             	mov    %rax,%rdx
  801741:	be 01 00 00 00       	mov    $0x1,%esi
  801746:	bf 03 00 00 00       	mov    $0x3,%edi
  80174b:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801752:	00 00 00 
  801755:	ff d0                	callq  *%rax
}
  801757:	c9                   	leaveq 
  801758:	c3                   	retq   

0000000000801759 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801759:	55                   	push   %rbp
  80175a:	48 89 e5             	mov    %rsp,%rbp
  80175d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801761:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801768:	00 
  801769:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801775:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	be 00 00 00 00       	mov    $0x0,%esi
  801784:	bf 02 00 00 00       	mov    $0x2,%edi
  801789:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801790:	00 00 00 
  801793:	ff d0                	callq  *%rax
}
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   

0000000000801797 <sys_yield>:

void
sys_yield(void)
{
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80179f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a6:	00 
  8017a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	be 00 00 00 00       	mov    $0x0,%esi
  8017c2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017c7:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8017ce:	00 00 00 
  8017d1:	ff d0                	callq  *%rax
}
  8017d3:	c9                   	leaveq 
  8017d4:	c3                   	retq   

00000000008017d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017d5:	55                   	push   %rbp
  8017d6:	48 89 e5             	mov    %rsp,%rbp
  8017d9:	48 83 ec 20          	sub    $0x20,%rsp
  8017dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ea:	48 63 c8             	movslq %eax,%rcx
  8017ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f4:	48 98                	cltq   
  8017f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fd:	00 
  8017fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801804:	49 89 c8             	mov    %rcx,%r8
  801807:	48 89 d1             	mov    %rdx,%rcx
  80180a:	48 89 c2             	mov    %rax,%rdx
  80180d:	be 01 00 00 00       	mov    $0x1,%esi
  801812:	bf 04 00 00 00       	mov    $0x4,%edi
  801817:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
}
  801823:	c9                   	leaveq 
  801824:	c3                   	retq   

0000000000801825 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	48 83 ec 30          	sub    $0x30,%rsp
  80182d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801834:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801837:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80183b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80183f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801842:	48 63 c8             	movslq %eax,%rcx
  801845:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801849:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184c:	48 63 f0             	movslq %eax,%rsi
  80184f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801856:	48 98                	cltq   
  801858:	48 89 0c 24          	mov    %rcx,(%rsp)
  80185c:	49 89 f9             	mov    %rdi,%r9
  80185f:	49 89 f0             	mov    %rsi,%r8
  801862:	48 89 d1             	mov    %rdx,%rcx
  801865:	48 89 c2             	mov    %rax,%rdx
  801868:	be 01 00 00 00       	mov    $0x1,%esi
  80186d:	bf 05 00 00 00       	mov    $0x5,%edi
  801872:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801879:	00 00 00 
  80187c:	ff d0                	callq  *%rax
}
  80187e:	c9                   	leaveq 
  80187f:	c3                   	retq   

0000000000801880 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 20          	sub    $0x20,%rsp
  801888:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80188f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801896:	48 98                	cltq   
  801898:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189f:	00 
  8018a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ac:	48 89 d1             	mov    %rdx,%rcx
  8018af:	48 89 c2             	mov    %rax,%rdx
  8018b2:	be 01 00 00 00       	mov    $0x1,%esi
  8018b7:	bf 06 00 00 00       	mov    $0x6,%edi
  8018bc:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8018c3:	00 00 00 
  8018c6:	ff d0                	callq  *%rax
}
  8018c8:	c9                   	leaveq 
  8018c9:	c3                   	retq   

00000000008018ca <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	48 83 ec 10          	sub    $0x10,%rsp
  8018d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018db:	48 63 d0             	movslq %eax,%rdx
  8018de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e1:	48 98                	cltq   
  8018e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ea:	00 
  8018eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f7:	48 89 d1             	mov    %rdx,%rcx
  8018fa:	48 89 c2             	mov    %rax,%rdx
  8018fd:	be 01 00 00 00       	mov    $0x1,%esi
  801902:	bf 08 00 00 00       	mov    $0x8,%edi
  801907:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 20          	sub    $0x20,%rsp
  80191d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801920:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801924:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192b:	48 98                	cltq   
  80192d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801934:	00 
  801935:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801941:	48 89 d1             	mov    %rdx,%rcx
  801944:	48 89 c2             	mov    %rax,%rdx
  801947:	be 01 00 00 00       	mov    $0x1,%esi
  80194c:	bf 09 00 00 00       	mov    $0x9,%edi
  801951:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
}
  80195d:	c9                   	leaveq 
  80195e:	c3                   	retq   

000000000080195f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	48 83 ec 20          	sub    $0x20,%rsp
  801967:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80196e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801975:	48 98                	cltq   
  801977:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197e:	00 
  80197f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801985:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198b:	48 89 d1             	mov    %rdx,%rcx
  80198e:	48 89 c2             	mov    %rax,%rdx
  801991:	be 01 00 00 00       	mov    $0x1,%esi
  801996:	bf 0a 00 00 00       	mov    $0xa,%edi
  80199b:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 20          	sub    $0x20,%rsp
  8019b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019bc:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c2:	48 63 f0             	movslq %eax,%rsi
  8019c5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cc:	48 98                	cltq   
  8019ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d9:	00 
  8019da:	49 89 f1             	mov    %rsi,%r9
  8019dd:	49 89 c8             	mov    %rcx,%r8
  8019e0:	48 89 d1             	mov    %rdx,%rcx
  8019e3:	48 89 c2             	mov    %rax,%rdx
  8019e6:	be 00 00 00 00       	mov    $0x0,%esi
  8019eb:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f0:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
}
  8019fc:	c9                   	leaveq 
  8019fd:	c3                   	retq   

00000000008019fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019fe:	55                   	push   %rbp
  8019ff:	48 89 e5             	mov    %rsp,%rbp
  801a02:	48 83 ec 10          	sub    $0x10,%rsp
  801a06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a15:	00 
  801a16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	48 89 c2             	mov    %rax,%rdx
  801a2a:	be 01 00 00 00       	mov    $0x1,%esi
  801a2f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a34:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
}
  801a40:	c9                   	leaveq 
  801a41:	c3                   	retq   

0000000000801a42 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	48 83 ec 20          	sub    $0x20,%rsp
  801a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a61:	00 
  801a62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6e:	48 89 d1             	mov    %rdx,%rcx
  801a71:	48 89 c2             	mov    %rax,%rdx
  801a74:	be 01 00 00 00       	mov    $0x1,%esi
  801a79:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a7e:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 10          	sub    $0x10,%rsp
  801a94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa3:	00 
  801aa4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab5:	48 89 c2             	mov    %rax,%rdx
  801ab8:	be 00 00 00 00       	mov    $0x0,%esi
  801abd:	bf 10 00 00 00       	mov    $0x10,%edi
  801ac2:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ad8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adf:	00 
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af1:	ba 00 00 00 00       	mov    $0x0,%edx
  801af6:	be 00 00 00 00       	mov    $0x0,%esi
  801afb:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b00:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 30          	sub    $0x30,%rsp
  801b16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  801b22:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801b29:	00 00 00 
  801b2c:	48 8b 00             	mov    (%rax),%rax
  801b2f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  801b35:	85 c0                	test   %eax,%eax
  801b37:	75 3c                	jne    801b75 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b39:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  801b40:	00 00 00 
  801b43:	ff d0                	callq  *%rax
  801b45:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b4a:	48 63 d0             	movslq %eax,%rdx
  801b4d:	48 89 d0             	mov    %rdx,%rax
  801b50:	48 c1 e0 03          	shl    $0x3,%rax
  801b54:	48 01 d0             	add    %rdx,%rax
  801b57:	48 c1 e0 05          	shl    $0x5,%rax
  801b5b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801b62:	00 00 00 
  801b65:	48 01 c2             	add    %rax,%rdx
  801b68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801b6f:	00 00 00 
  801b72:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  801b75:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b7a:	75 0e                	jne    801b8a <ipc_recv+0x7c>
		pg = (void*) UTOP;
  801b7c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801b83:	00 00 00 
  801b86:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  801b8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b8e:	48 89 c7             	mov    %rax,%rdi
  801b91:	48 b8 fe 19 80 00 00 	movabs $0x8019fe,%rax
  801b98:	00 00 00 
  801b9b:	ff d0                	callq  *%rax
  801b9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  801ba0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ba4:	79 19                	jns    801bbf <ipc_recv+0xb1>
		*from_env_store = 0;
  801ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801baa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  801bb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  801bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbd:	eb 53                	jmp    801c12 <ipc_recv+0x104>
	}
	if(from_env_store)
  801bbf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc4:	74 19                	je     801bdf <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  801bc6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801bcd:	00 00 00 
  801bd0:	48 8b 00             	mov    (%rax),%rax
  801bd3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdd:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  801bdf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801be4:	74 19                	je     801bff <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  801be6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801bed:	00 00 00 
  801bf0:	48 8b 00             	mov    (%rax),%rax
  801bf3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfd:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  801bff:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801c06:	00 00 00 
  801c09:	48 8b 00             	mov    (%rax),%rax
  801c0c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 30          	sub    $0x30,%rsp
  801c1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c1f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801c22:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801c26:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  801c29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801c2e:	75 0e                	jne    801c3e <ipc_send+0x2a>
		pg = (void*)UTOP;
  801c30:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801c37:	00 00 00 
  801c3a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  801c3e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801c41:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c44:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c4b:	89 c7                	mov    %eax,%edi
  801c4d:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
  801c59:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  801c5c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801c60:	75 0c                	jne    801c6e <ipc_send+0x5a>
			sys_yield();
  801c62:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  801c6e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801c72:	74 ca                	je     801c3e <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  801c74:	c9                   	leaveq 
  801c75:	c3                   	retq   

0000000000801c76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c76:	55                   	push   %rbp
  801c77:	48 89 e5             	mov    %rsp,%rbp
  801c7a:	48 83 ec 14          	sub    $0x14,%rsp
  801c7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c88:	eb 5e                	jmp    801ce8 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801c8a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801c91:	00 00 00 
  801c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c97:	48 63 d0             	movslq %eax,%rdx
  801c9a:	48 89 d0             	mov    %rdx,%rax
  801c9d:	48 c1 e0 03          	shl    $0x3,%rax
  801ca1:	48 01 d0             	add    %rdx,%rax
  801ca4:	48 c1 e0 05          	shl    $0x5,%rax
  801ca8:	48 01 c8             	add    %rcx,%rax
  801cab:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801cb1:	8b 00                	mov    (%rax),%eax
  801cb3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801cb6:	75 2c                	jne    801ce4 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801cb8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801cbf:	00 00 00 
  801cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc5:	48 63 d0             	movslq %eax,%rdx
  801cc8:	48 89 d0             	mov    %rdx,%rax
  801ccb:	48 c1 e0 03          	shl    $0x3,%rax
  801ccf:	48 01 d0             	add    %rdx,%rax
  801cd2:	48 c1 e0 05          	shl    $0x5,%rax
  801cd6:	48 01 c8             	add    %rcx,%rax
  801cd9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801cdf:	8b 40 08             	mov    0x8(%rax),%eax
  801ce2:	eb 12                	jmp    801cf6 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  801ce4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ce8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801cef:	7e 99                	jle    801c8a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf6:	c9                   	leaveq 
  801cf7:	c3                   	retq   

0000000000801cf8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf8:	55                   	push   %rbp
  801cf9:	48 89 e5             	mov    %rsp,%rbp
  801cfc:	48 83 ec 08          	sub    $0x8,%rsp
  801d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d08:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d0f:	ff ff ff 
  801d12:	48 01 d0             	add    %rdx,%rax
  801d15:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 08          	sub    $0x8,%rsp
  801d23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2b:	48 89 c7             	mov    %rax,%rdi
  801d2e:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d40:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 18          	sub    $0x18,%rsp
  801d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d59:	eb 6b                	jmp    801dc6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5e:	48 98                	cltq   
  801d60:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d66:	48 c1 e0 0c          	shl    $0xc,%rax
  801d6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d72:	48 c1 e8 15          	shr    $0x15,%rax
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d80:	01 00 00 
  801d83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d87:	83 e0 01             	and    $0x1,%eax
  801d8a:	48 85 c0             	test   %rax,%rax
  801d8d:	74 21                	je     801db0 <fd_alloc+0x6a>
  801d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d93:	48 c1 e8 0c          	shr    $0xc,%rax
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da1:	01 00 00 
  801da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da8:	83 e0 01             	and    $0x1,%eax
  801dab:	48 85 c0             	test   %rax,%rax
  801dae:	75 12                	jne    801dc2 <fd_alloc+0x7c>
			*fd_store = fd;
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	eb 1a                	jmp    801ddc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dca:	7e 8f                	jle    801d5b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 20          	sub    $0x20,%rsp
  801de6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ded:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801df1:	78 06                	js     801df9 <fd_lookup+0x1b>
  801df3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df7:	7e 07                	jle    801e00 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfe:	eb 6c                	jmp    801e6c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e0b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e17:	48 c1 e8 15          	shr    $0x15,%rax
  801e1b:	48 89 c2             	mov    %rax,%rdx
  801e1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e25:	01 00 00 
  801e28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2c:	83 e0 01             	and    $0x1,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	74 21                	je     801e55 <fd_lookup+0x77>
  801e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e38:	48 c1 e8 0c          	shr    $0xc,%rax
  801e3c:	48 89 c2             	mov    %rax,%rdx
  801e3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e46:	01 00 00 
  801e49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4d:	83 e0 01             	and    $0x1,%eax
  801e50:	48 85 c0             	test   %rax,%rax
  801e53:	75 07                	jne    801e5c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e5a:	eb 10                	jmp    801e6c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e64:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 30          	sub    $0x30,%rsp
  801e76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e7a:	89 f0                	mov    %esi,%eax
  801e7c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	48 89 c7             	mov    %rax,%rdi
  801e86:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
  801e92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e96:	48 89 d6             	mov    %rdx,%rsi
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
  801ea7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eae:	78 0a                	js     801eba <fd_close+0x4c>
	    || fd != fd2)
  801eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb8:	74 12                	je     801ecc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eba:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ebe:	74 05                	je     801ec5 <fd_close+0x57>
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	eb 05                	jmp    801eca <fd_close+0x5c>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb 69                	jmp    801f35 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed0:	8b 00                	mov    (%rax),%eax
  801ed2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed6:	48 89 d6             	mov    %rdx,%rsi
  801ed9:	89 c7                	mov    %eax,%edi
  801edb:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eee:	78 2a                	js     801f1a <fd_close+0xac>
		if (dev->dev_close)
  801ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef8:	48 85 c0             	test   %rax,%rax
  801efb:	74 16                	je     801f13 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f01:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f09:	48 89 d7             	mov    %rdx,%rdi
  801f0c:	ff d0                	callq  *%rax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f11:	eb 07                	jmp    801f1a <fd_close+0xac>
		else
			r = 0;
  801f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	48 89 c6             	mov    %rax,%rsi
  801f21:	bf 00 00 00 00       	mov    $0x0,%edi
  801f26:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
	return r;
  801f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
  801f3b:	48 83 ec 20          	sub    $0x20,%rsp
  801f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4d:	eb 41                	jmp    801f90 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f4f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f56:	00 00 00 
  801f59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5c:	48 63 d2             	movslq %edx,%rdx
  801f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f63:	8b 00                	mov    (%rax),%eax
  801f65:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f68:	75 22                	jne    801f8c <dev_lookup+0x55>
			*dev = devtab[i];
  801f6a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f71:	00 00 00 
  801f74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f77:	48 63 d2             	movslq %edx,%rdx
  801f7a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f82:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	eb 60                	jmp    801fec <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f90:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f97:	00 00 00 
  801f9a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f9d:	48 63 d2             	movslq %edx,%rdx
  801fa0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa4:	48 85 c0             	test   %rax,%rax
  801fa7:	75 a6                	jne    801f4f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fb0:	00 00 00 
  801fb3:	48 8b 00             	mov    (%rax),%rax
  801fb6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbf:	89 c6                	mov    %eax,%esi
  801fc1:	48 bf 78 44 80 00 00 	movabs $0x804478,%rdi
  801fc8:	00 00 00 
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  801fd7:	00 00 00 
  801fda:	ff d1                	callq  *%rcx
	*dev = 0;
  801fdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <close>:

int
close(int fdnum)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 20          	sub    $0x20,%rsp
  801ff6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802000:	48 89 d6             	mov    %rdx,%rsi
  802003:	89 c7                	mov    %eax,%edi
  802005:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802018:	79 05                	jns    80201f <close+0x31>
		return r;
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	eb 18                	jmp    802037 <close+0x49>
	else
		return fd_close(fd, 1);
  80201f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802023:	be 01 00 00 00       	mov    $0x1,%esi
  802028:	48 89 c7             	mov    %rax,%rdi
  80202b:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <close_all>:

void
close_all(void)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802048:	eb 15                	jmp    80205f <close_all+0x26>
		close(i);
  80204a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80205b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802063:	7e e5                	jle    80204a <close_all+0x11>
		close(i);
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 40          	sub    $0x40,%rsp
  80206f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802072:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802075:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802079:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80207c:	48 89 d6             	mov    %rdx,%rsi
  80207f:	89 c7                	mov    %eax,%edi
  802081:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802094:	79 08                	jns    80209e <dup+0x37>
		return r;
  802096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802099:	e9 70 01 00 00       	jmpq   80220e <dup+0x1a7>
	close(newfdnum);
  80209e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b2:	48 98                	cltq   
  8020b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8020be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c6:	48 89 c7             	mov    %rax,%rdi
  8020c9:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	48 89 c7             	mov    %rax,%rdi
  8020e0:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
  8020ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f4:	48 c1 e8 15          	shr    $0x15,%rax
  8020f8:	48 89 c2             	mov    %rax,%rdx
  8020fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802102:	01 00 00 
  802105:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802109:	83 e0 01             	and    $0x1,%eax
  80210c:	48 85 c0             	test   %rax,%rax
  80210f:	74 73                	je     802184 <dup+0x11d>
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	48 c1 e8 0c          	shr    $0xc,%rax
  802119:	48 89 c2             	mov    %rax,%rdx
  80211c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802123:	01 00 00 
  802126:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212a:	83 e0 01             	and    $0x1,%eax
  80212d:	48 85 c0             	test   %rax,%rax
  802130:	74 52                	je     802184 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802136:	48 c1 e8 0c          	shr    $0xc,%rax
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802144:	01 00 00 
  802147:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214b:	25 07 0e 00 00       	and    $0xe07,%eax
  802150:	89 c1                	mov    %eax,%ecx
  802152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215a:	41 89 c8             	mov    %ecx,%r8d
  80215d:	48 89 d1             	mov    %rdx,%rcx
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
  802165:	48 89 c6             	mov    %rax,%rsi
  802168:	bf 00 00 00 00       	mov    $0x0,%edi
  80216d:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802180:	79 02                	jns    802184 <dup+0x11d>
			goto err;
  802182:	eb 57                	jmp    8021db <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802184:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802188:	48 c1 e8 0c          	shr    $0xc,%rax
  80218c:	48 89 c2             	mov    %rax,%rdx
  80218f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802196:	01 00 00 
  802199:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219d:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ac:	41 89 c8             	mov    %ecx,%r8d
  8021af:	48 89 d1             	mov    %rdx,%rcx
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b7:	48 89 c6             	mov    %rax,%rsi
  8021ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bf:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d2:	79 02                	jns    8021d6 <dup+0x16f>
		goto err;
  8021d4:	eb 05                	jmp    8021db <dup+0x174>

	return newfdnum;
  8021d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d9:	eb 33                	jmp    80220e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021df:	48 89 c6             	mov    %rax,%rsi
  8021e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e7:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f7:	48 89 c6             	mov    %rax,%rsi
  8021fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ff:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
	return r;
  80220b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 40          	sub    $0x40,%rsp
  802218:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80221b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80221f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802223:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802227:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80222a:	48 89 d6             	mov    %rdx,%rsi
  80222d:	89 c7                	mov    %eax,%edi
  80222f:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
  80223b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802242:	78 24                	js     802268 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	8b 00                	mov    (%rax),%eax
  80224a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80224e:	48 89 d6             	mov    %rdx,%rsi
  802251:	89 c7                	mov    %eax,%edi
  802253:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
  80225f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802262:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802266:	79 05                	jns    80226d <read+0x5d>
		return r;
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	eb 76                	jmp    8022e3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80226d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802271:	8b 40 08             	mov    0x8(%rax),%eax
  802274:	83 e0 03             	and    $0x3,%eax
  802277:	83 f8 01             	cmp    $0x1,%eax
  80227a:	75 3a                	jne    8022b6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80227c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802283:	00 00 00 
  802286:	48 8b 00             	mov    (%rax),%rax
  802289:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80228f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802292:	89 c6                	mov    %eax,%esi
  802294:	48 bf 97 44 80 00 00 	movabs $0x804497,%rdi
  80229b:	00 00 00 
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8022aa:	00 00 00 
  8022ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b4:	eb 2d                	jmp    8022e3 <read+0xd3>
	}
	if (!dev->dev_read)
  8022b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ba:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022be:	48 85 c0             	test   %rax,%rax
  8022c1:	75 07                	jne    8022ca <read+0xba>
		return -E_NOT_SUPP;
  8022c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c8:	eb 19                	jmp    8022e3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022de:	48 89 cf             	mov    %rcx,%rdi
  8022e1:	ff d0                	callq  *%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 30          	sub    $0x30,%rsp
  8022ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ff:	eb 49                	jmp    80234a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802304:	48 98                	cltq   
  802306:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80230a:	48 29 c2             	sub    %rax,%rdx
  80230d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802310:	48 63 c8             	movslq %eax,%rcx
  802313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802317:	48 01 c1             	add    %rax,%rcx
  80231a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231d:	48 89 ce             	mov    %rcx,%rsi
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802331:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802335:	79 05                	jns    80233c <readn+0x57>
			return m;
  802337:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80233a:	eb 1c                	jmp    802358 <readn+0x73>
		if (m == 0)
  80233c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802340:	75 02                	jne    802344 <readn+0x5f>
			break;
  802342:	eb 11                	jmp    802355 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802347:	01 45 fc             	add    %eax,-0x4(%rbp)
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	48 98                	cltq   
  80234f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802353:	72 ac                	jb     802301 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802355:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802358:	c9                   	leaveq 
  802359:	c3                   	retq   

000000000080235a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80235a:	55                   	push   %rbp
  80235b:	48 89 e5             	mov    %rsp,%rbp
  80235e:	48 83 ec 40          	sub    $0x40,%rsp
  802362:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802365:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802369:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802371:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802374:	48 89 d6             	mov    %rdx,%rsi
  802377:	89 c7                	mov    %eax,%edi
  802379:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
  802385:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802388:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238c:	78 24                	js     8023b2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	8b 00                	mov    (%rax),%eax
  802394:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802398:	48 89 d6             	mov    %rdx,%rsi
  80239b:	89 c7                	mov    %eax,%edi
  80239d:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
  8023a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b0:	79 05                	jns    8023b7 <write+0x5d>
		return r;
  8023b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b5:	eb 75                	jmp    80242c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	8b 40 08             	mov    0x8(%rax),%eax
  8023be:	83 e0 03             	and    $0x3,%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	75 3a                	jne    8023ff <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023c5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023cc:	00 00 00 
  8023cf:	48 8b 00             	mov    (%rax),%rax
  8023d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023db:	89 c6                	mov    %eax,%esi
  8023dd:	48 bf b3 44 80 00 00 	movabs $0x8044b3,%rdi
  8023e4:	00 00 00 
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8023f3:	00 00 00 
  8023f6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023fd:	eb 2d                	jmp    80242c <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8023ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802403:	48 8b 40 18          	mov    0x18(%rax),%rax
  802407:	48 85 c0             	test   %rax,%rax
  80240a:	75 07                	jne    802413 <write+0xb9>
		return -E_NOT_SUPP;
  80240c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802411:	eb 19                	jmp    80242c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802417:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80241f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802423:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802427:	48 89 cf             	mov    %rcx,%rdi
  80242a:	ff d0                	callq  *%rax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <seek>:

int
seek(int fdnum, off_t offset)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 18          	sub    $0x18,%rsp
  802436:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802439:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802440:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802443:	48 89 d6             	mov    %rdx,%rsi
  802446:	89 c7                	mov    %eax,%edi
  802448:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
  802454:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245b:	79 05                	jns    802462 <seek+0x34>
		return r;
  80245d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802460:	eb 0f                	jmp    802471 <seek+0x43>
	fd->fd_offset = offset;
  802462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802466:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802469:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 30          	sub    $0x30,%rsp
  80247b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802481:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802485:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802488:	48 89 d6             	mov    %rdx,%rsi
  80248b:	89 c7                	mov    %eax,%edi
  80248d:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802494:	00 00 00 
  802497:	ff d0                	callq  *%rax
  802499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a0:	78 24                	js     8024c6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a6:	8b 00                	mov    (%rax),%eax
  8024a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ac:	48 89 d6             	mov    %rdx,%rsi
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax
  8024bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c4:	79 05                	jns    8024cb <ftruncate+0x58>
		return r;
  8024c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c9:	eb 72                	jmp    80253d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cf:	8b 40 08             	mov    0x8(%rax),%eax
  8024d2:	83 e0 03             	and    $0x3,%eax
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	75 3a                	jne    802513 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024e0:	00 00 00 
  8024e3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	48 bf d0 44 80 00 00 	movabs $0x8044d0,%rdi
  8024f8:	00 00 00 
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  802507:	00 00 00 
  80250a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80250c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802511:	eb 2a                	jmp    80253d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802517:	48 8b 40 30          	mov    0x30(%rax),%rax
  80251b:	48 85 c0             	test   %rax,%rax
  80251e:	75 07                	jne    802527 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802520:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802525:	eb 16                	jmp    80253d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802533:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802536:	89 ce                	mov    %ecx,%esi
  802538:	48 89 d7             	mov    %rdx,%rdi
  80253b:	ff d0                	callq  *%rax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 30          	sub    $0x30,%rsp
  802547:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802552:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802555:	48 89 d6             	mov    %rdx,%rsi
  802558:	89 c7                	mov    %eax,%edi
  80255a:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax
  802566:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256d:	78 24                	js     802593 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802573:	8b 00                	mov    (%rax),%eax
  802575:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802579:	48 89 d6             	mov    %rdx,%rsi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802591:	79 05                	jns    802598 <fstat+0x59>
		return r;
  802593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802596:	eb 5e                	jmp    8025f6 <fstat+0xb7>
	if (!dev->dev_stat)
  802598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025a0:	48 85 c0             	test   %rax,%rax
  8025a3:	75 07                	jne    8025ac <fstat+0x6d>
		return -E_NOT_SUPP;
  8025a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025aa:	eb 4a                	jmp    8025f6 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025be:	00 00 00 
	stat->st_isdir = 0;
  8025c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025cc:	00 00 00 
	stat->st_dev = dev;
  8025cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025ea:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025ee:	48 89 ce             	mov    %rcx,%rsi
  8025f1:	48 89 d7             	mov    %rdx,%rdi
  8025f4:	ff d0                	callq  *%rax
}
  8025f6:	c9                   	leaveq 
  8025f7:	c3                   	retq   

00000000008025f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025f8:	55                   	push   %rbp
  8025f9:	48 89 e5             	mov    %rsp,%rbp
  8025fc:	48 83 ec 20          	sub    $0x20,%rsp
  802600:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802604:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	be 00 00 00 00       	mov    $0x0,%esi
  802611:	48 89 c7             	mov    %rax,%rdi
  802614:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
  802620:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802623:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802627:	79 05                	jns    80262e <stat+0x36>
		return fd;
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	eb 2f                	jmp    80265d <stat+0x65>
	r = fstat(fd, stat);
  80262e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802635:	48 89 d6             	mov    %rdx,%rsi
  802638:	89 c7                	mov    %eax,%edi
  80263a:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
	return r;
  80265a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80265d:	c9                   	leaveq 
  80265e:	c3                   	retq   

000000000080265f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80265f:	55                   	push   %rbp
  802660:	48 89 e5             	mov    %rsp,%rbp
  802663:	48 83 ec 10          	sub    $0x10,%rsp
  802667:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80266a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80266e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802675:	00 00 00 
  802678:	8b 00                	mov    (%rax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	75 1d                	jne    80269b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80267e:	bf 01 00 00 00       	mov    $0x1,%edi
  802683:	48 b8 76 1c 80 00 00 	movabs $0x801c76,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
  80268f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802696:	00 00 00 
  802699:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80269b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026a2:	00 00 00 
  8026a5:	8b 00                	mov    (%rax),%eax
  8026a7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026aa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026af:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026b6:	00 00 00 
  8026b9:	89 c7                	mov    %eax,%edi
  8026bb:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	48 89 c6             	mov    %rax,%rsi
  8026d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d8:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
}
  8026e4:	c9                   	leaveq 
  8026e5:	c3                   	retq   

00000000008026e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026e6:	55                   	push   %rbp
  8026e7:	48 89 e5             	mov    %rsp,%rbp
  8026ea:	48 83 ec 30          	sub    $0x30,%rsp
  8026ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026f2:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026f5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026fc:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80270a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80270f:	75 08                	jne    802719 <open+0x33>
	{
		return r;
  802711:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802714:	e9 f2 00 00 00       	jmpq   80280b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271d:	48 89 c7             	mov    %rax,%rdi
  802720:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80272f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802736:	7e 0a                	jle    802742 <open+0x5c>
	{
		return -E_BAD_PATH;
  802738:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80273d:	e9 c9 00 00 00       	jmpq   80280b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802742:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802749:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80274a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80274e:	48 89 c7             	mov    %rax,%rdi
  802751:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	78 09                	js     80276f <open+0x89>
  802766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276a:	48 85 c0             	test   %rax,%rax
  80276d:	75 08                	jne    802777 <open+0x91>
		{
			return r;
  80276f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802772:	e9 94 00 00 00       	jmpq   80280b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277b:	ba 00 04 00 00       	mov    $0x400,%edx
  802780:	48 89 c6             	mov    %rax,%rsi
  802783:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80278a:	00 00 00 
  80278d:	48 b8 38 0f 80 00 00 	movabs $0x800f38,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802799:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027a0:	00 00 00 
  8027a3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027a6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	48 89 c6             	mov    %rax,%rsi
  8027b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8027b8:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cb:	79 2b                	jns    8027f8 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d1:	be 00 00 00 00       	mov    $0x0,%esi
  8027d6:	48 89 c7             	mov    %rax,%rdi
  8027d9:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ec:	79 05                	jns    8027f3 <open+0x10d>
			{
				return d;
  8027ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027f1:	eb 18                	jmp    80280b <open+0x125>
			}
			return r;
  8027f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f6:	eb 13                	jmp    80280b <open+0x125>
		}	
		return fd2num(fd_store);
  8027f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fc:	48 89 c7             	mov    %rax,%rdi
  8027ff:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80280b:	c9                   	leaveq 
  80280c:	c3                   	retq   

000000000080280d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80280d:	55                   	push   %rbp
  80280e:	48 89 e5             	mov    %rsp,%rbp
  802811:	48 83 ec 10          	sub    $0x10,%rsp
  802815:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281d:	8b 50 0c             	mov    0xc(%rax),%edx
  802820:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802827:	00 00 00 
  80282a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80282c:	be 00 00 00 00       	mov    $0x0,%esi
  802831:	bf 06 00 00 00       	mov    $0x6,%edi
  802836:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  80283d:	00 00 00 
  802840:	ff d0                	callq  *%rax
}
  802842:	c9                   	leaveq 
  802843:	c3                   	retq   

0000000000802844 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802844:	55                   	push   %rbp
  802845:	48 89 e5             	mov    %rsp,%rbp
  802848:	48 83 ec 30          	sub    $0x30,%rsp
  80284c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802850:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802854:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80285f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802864:	74 07                	je     80286d <devfile_read+0x29>
  802866:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80286b:	75 07                	jne    802874 <devfile_read+0x30>
		return -E_INVAL;
  80286d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802872:	eb 77                	jmp    8028eb <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	8b 50 0c             	mov    0xc(%rax),%edx
  80287b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802882:	00 00 00 
  802885:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802887:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288e:	00 00 00 
  802891:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802895:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802899:	be 00 00 00 00       	mov    $0x0,%esi
  80289e:	bf 03 00 00 00       	mov    $0x3,%edi
  8028a3:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	7f 05                	jg     8028bd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bb:	eb 2e                	jmp    8028eb <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c0:	48 63 d0             	movslq %eax,%rdx
  8028c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028ce:	00 00 00 
  8028d1:	48 89 c7             	mov    %rax,%rdi
  8028d4:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028eb:	c9                   	leaveq 
  8028ec:	c3                   	retq   

00000000008028ed <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028ed:	55                   	push   %rbp
  8028ee:	48 89 e5             	mov    %rsp,%rbp
  8028f1:	48 83 ec 30          	sub    $0x30,%rsp
  8028f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802901:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802908:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80290d:	74 07                	je     802916 <devfile_write+0x29>
  80290f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802914:	75 08                	jne    80291e <devfile_write+0x31>
		return r;
  802916:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802919:	e9 9a 00 00 00       	jmpq   8029b8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80291e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802922:	8b 50 0c             	mov    0xc(%rax),%edx
  802925:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292c:	00 00 00 
  80292f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802931:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802938:	00 
  802939:	76 08                	jbe    802943 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80293b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802942:	00 
	}
	fsipcbuf.write.req_n = n;
  802943:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80294a:	00 00 00 
  80294d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802951:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802955:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802959:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295d:	48 89 c6             	mov    %rax,%rsi
  802960:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802967:	00 00 00 
  80296a:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802976:	be 00 00 00 00       	mov    $0x0,%esi
  80297b:	bf 04 00 00 00       	mov    $0x4,%edi
  802980:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
  80298c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802993:	7f 20                	jg     8029b5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802995:	48 bf f6 44 80 00 00 	movabs $0x8044f6,%rdi
  80299c:	00 00 00 
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  8029ab:	00 00 00 
  8029ae:	ff d2                	callq  *%rdx
		return r;
  8029b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b3:	eb 03                	jmp    8029b8 <devfile_write+0xcb>
	}
	return r;
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029b8:	c9                   	leaveq 
  8029b9:	c3                   	retq   

00000000008029ba <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 20          	sub    $0x20,%rsp
  8029c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ce:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d8:	00 00 00 
  8029db:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029dd:	be 00 00 00 00       	mov    $0x0,%esi
  8029e2:	bf 05 00 00 00       	mov    $0x5,%edi
  8029e7:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fa:	79 05                	jns    802a01 <devfile_stat+0x47>
		return r;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ff:	eb 56                	jmp    802a57 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a05:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a0c:	00 00 00 
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a25:	00 00 00 
  802a28:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a32:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3f:	00 00 00 
  802a42:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a57:	c9                   	leaveq 
  802a58:	c3                   	retq   

0000000000802a59 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a59:	55                   	push   %rbp
  802a5a:	48 89 e5             	mov    %rsp,%rbp
  802a5d:	48 83 ec 10          	sub    $0x10,%rsp
  802a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a65:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a76:	00 00 00 
  802a79:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a82:	00 00 00 
  802a85:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a8b:	be 00 00 00 00       	mov    $0x0,%esi
  802a90:	bf 02 00 00 00       	mov    $0x2,%edi
  802a95:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
}
  802aa1:	c9                   	leaveq 
  802aa2:	c3                   	retq   

0000000000802aa3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 10          	sub    $0x10,%rsp
  802aab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab3:	48 89 c7             	mov    %rax,%rdi
  802ab6:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
  802ac2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ac7:	7e 07                	jle    802ad0 <remove+0x2d>
		return -E_BAD_PATH;
  802ac9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ace:	eb 33                	jmp    802b03 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad4:	48 89 c6             	mov    %rax,%rsi
  802ad7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ade:	00 00 00 
  802ae1:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aed:	be 00 00 00 00       	mov    $0x0,%esi
  802af2:	bf 07 00 00 00       	mov    $0x7,%edi
  802af7:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b09:	be 00 00 00 00       	mov    $0x0,%esi
  802b0e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b13:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
}
  802b1f:	5d                   	pop    %rbp
  802b20:	c3                   	retq   

0000000000802b21 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b2c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b33:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b3a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b41:	be 00 00 00 00       	mov    $0x0,%esi
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5c:	79 28                	jns    802b86 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	89 c6                	mov    %eax,%esi
  802b63:	48 bf 12 45 80 00 00 	movabs $0x804512,%rdi
  802b6a:	00 00 00 
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802b79:	00 00 00 
  802b7c:	ff d2                	callq  *%rdx
		return fd_src;
  802b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b81:	e9 74 01 00 00       	jmpq   802cfa <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b86:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b8d:	be 01 01 00 00       	mov    $0x101,%esi
  802b92:	48 89 c7             	mov    %rax,%rdi
  802b95:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ba4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ba8:	79 39                	jns    802be3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802baa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bad:	89 c6                	mov    %eax,%esi
  802baf:	48 bf 28 45 80 00 00 	movabs $0x804528,%rdi
  802bb6:	00 00 00 
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbe:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802bc5:	00 00 00 
  802bc8:	ff d2                	callq  *%rdx
		close(fd_src);
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcd:	89 c7                	mov    %eax,%edi
  802bcf:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
		return fd_dest;
  802bdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bde:	e9 17 01 00 00       	jmpq   802cfa <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802be3:	eb 74                	jmp    802c59 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802be5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802be8:	48 63 d0             	movslq %eax,%rdx
  802beb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bf2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf5:	48 89 ce             	mov    %rcx,%rsi
  802bf8:	89 c7                	mov    %eax,%edi
  802bfa:	48 b8 5a 23 80 00 00 	movabs $0x80235a,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c0d:	79 4a                	jns    802c59 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c0f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c12:	89 c6                	mov    %eax,%esi
  802c14:	48 bf 42 45 80 00 00 	movabs $0x804542,%rdi
  802c1b:	00 00 00 
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802c2a:	00 00 00 
  802c2d:	ff d2                	callq  *%rdx
			close(fd_src);
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
			close(fd_dest);
  802c40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
			return write_size;
  802c51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c54:	e9 a1 00 00 00       	jmpq   802cfa <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c59:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c63:	ba 00 02 00 00       	mov    $0x200,%edx
  802c68:	48 89 ce             	mov    %rcx,%rsi
  802c6b:	89 c7                	mov    %eax,%edi
  802c6d:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c80:	0f 8f 5f ff ff ff    	jg     802be5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c8a:	79 47                	jns    802cd3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c8f:	89 c6                	mov    %eax,%esi
  802c91:	48 bf 55 45 80 00 00 	movabs $0x804555,%rdi
  802c98:	00 00 00 
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802ca7:	00 00 00 
  802caa:	ff d2                	callq  *%rdx
		close(fd_src);
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
		close(fd_dest);
  802cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
		return read_size;
  802cce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cd1:	eb 27                	jmp    802cfa <copy+0x1d9>
	}
	close(fd_src);
  802cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd6:	89 c7                	mov    %eax,%edi
  802cd8:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
	close(fd_dest);
  802ce4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce7:	89 c7                	mov    %eax,%edi
  802ce9:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	callq  *%rax
	return 0;
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cfa:	c9                   	leaveq 
  802cfb:	c3                   	retq   

0000000000802cfc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802cfc:	55                   	push   %rbp
  802cfd:	48 89 e5             	mov    %rsp,%rbp
  802d00:	48 83 ec 20          	sub    $0x20,%rsp
  802d04:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d0e:	48 89 d6             	mov    %rdx,%rsi
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
  802d1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d26:	79 05                	jns    802d2d <fd2sockid+0x31>
		return r;
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	eb 24                	jmp    802d51 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d31:	8b 10                	mov    (%rax),%edx
  802d33:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d3a:	00 00 00 
  802d3d:	8b 00                	mov    (%rax),%eax
  802d3f:	39 c2                	cmp    %eax,%edx
  802d41:	74 07                	je     802d4a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d43:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d48:	eb 07                	jmp    802d51 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d51:	c9                   	leaveq 
  802d52:	c3                   	retq   

0000000000802d53 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d53:	55                   	push   %rbp
  802d54:	48 89 e5             	mov    %rsp,%rbp
  802d57:	48 83 ec 20          	sub    $0x20,%rsp
  802d5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d5e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d62:	48 89 c7             	mov    %rax,%rdi
  802d65:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d78:	78 26                	js     802da0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7e:	ba 07 04 00 00       	mov    $0x407,%edx
  802d83:	48 89 c6             	mov    %rax,%rsi
  802d86:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8b:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
  802d97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9e:	79 16                	jns    802db6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802da0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802da3:	89 c7                	mov    %eax,%edi
  802da5:	48 b8 60 32 80 00 00 	movabs $0x803260,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
		return r;
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	eb 3a                	jmp    802df0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802db6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dba:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802dc1:	00 00 00 
  802dc4:	8b 12                	mov    (%rdx),%edx
  802dc6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802dd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dda:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de1:	48 89 c7             	mov    %rax,%rdi
  802de4:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 30          	sub    $0x30,%rsp
  802dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e08:	89 c7                	mov    %eax,%edi
  802e0a:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
  802e16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1d:	79 05                	jns    802e24 <accept+0x32>
		return r;
  802e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e22:	eb 3b                	jmp    802e5f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e24:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e28:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2f:	48 89 ce             	mov    %rcx,%rsi
  802e32:	89 c7                	mov    %eax,%edi
  802e34:	48 b8 3d 31 80 00 00 	movabs $0x80313d,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e47:	79 05                	jns    802e4e <accept+0x5c>
		return r;
  802e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4c:	eb 11                	jmp    802e5f <accept+0x6d>
	return alloc_sockfd(r);
  802e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e51:	89 c7                	mov    %eax,%edi
  802e53:	48 b8 53 2d 80 00 00 	movabs $0x802d53,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax
}
  802e5f:	c9                   	leaveq 
  802e60:	c3                   	retq   

0000000000802e61 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 83 ec 20          	sub    $0x20,%rsp
  802e69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e70:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e76:	89 c7                	mov    %eax,%edi
  802e78:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  802e7f:	00 00 00 
  802e82:	ff d0                	callq  *%rax
  802e84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8b:	79 05                	jns    802e92 <bind+0x31>
		return r;
  802e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e90:	eb 1b                	jmp    802ead <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e92:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e95:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9c:	48 89 ce             	mov    %rcx,%rsi
  802e9f:	89 c7                	mov    %eax,%edi
  802ea1:	48 b8 bc 31 80 00 00 	movabs $0x8031bc,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
}
  802ead:	c9                   	leaveq 
  802eae:	c3                   	retq   

0000000000802eaf <shutdown>:

int
shutdown(int s, int how)
{
  802eaf:	55                   	push   %rbp
  802eb0:	48 89 e5             	mov    %rsp,%rbp
  802eb3:	48 83 ec 20          	sub    $0x20,%rsp
  802eb7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ebd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec0:	89 c7                	mov    %eax,%edi
  802ec2:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
  802ece:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed5:	79 05                	jns    802edc <shutdown+0x2d>
		return r;
  802ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eda:	eb 16                	jmp    802ef2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802edc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee2:	89 d6                	mov    %edx,%esi
  802ee4:	89 c7                	mov    %eax,%edi
  802ee6:	48 b8 20 32 80 00 00 	movabs $0x803220,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
}
  802ef2:	c9                   	leaveq 
  802ef3:	c3                   	retq   

0000000000802ef4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ef4:	55                   	push   %rbp
  802ef5:	48 89 e5             	mov    %rsp,%rbp
  802ef8:	48 83 ec 10          	sub    $0x10,%rsp
  802efc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f04:	48 89 c7             	mov    %rax,%rdi
  802f07:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
  802f13:	83 f8 01             	cmp    $0x1,%eax
  802f16:	75 17                	jne    802f2f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1c:	8b 40 0c             	mov    0xc(%rax),%eax
  802f1f:	89 c7                	mov    %eax,%edi
  802f21:	48 b8 60 32 80 00 00 	movabs $0x803260,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
  802f2d:	eb 05                	jmp    802f34 <devsock_close+0x40>
	else
		return 0;
  802f2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 20          	sub    $0x20,%rsp
  802f3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f45:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f4b:	89 c7                	mov    %eax,%edi
  802f4d:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
  802f59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f60:	79 05                	jns    802f67 <connect+0x31>
		return r;
  802f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f65:	eb 1b                	jmp    802f82 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f67:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f6a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f71:	48 89 ce             	mov    %rcx,%rsi
  802f74:	89 c7                	mov    %eax,%edi
  802f76:	48 b8 8d 32 80 00 00 	movabs $0x80328d,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
}
  802f82:	c9                   	leaveq 
  802f83:	c3                   	retq   

0000000000802f84 <listen>:

int
listen(int s, int backlog)
{
  802f84:	55                   	push   %rbp
  802f85:	48 89 e5             	mov    %rsp,%rbp
  802f88:	48 83 ec 20          	sub    $0x20,%rsp
  802f8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f8f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
  802fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802faa:	79 05                	jns    802fb1 <listen+0x2d>
		return r;
  802fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faf:	eb 16                	jmp    802fc7 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fb1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb7:	89 d6                	mov    %edx,%esi
  802fb9:	89 c7                	mov    %eax,%edi
  802fbb:	48 b8 f1 32 80 00 00 	movabs $0x8032f1,%rax
  802fc2:	00 00 00 
  802fc5:	ff d0                	callq  *%rax
}
  802fc7:	c9                   	leaveq 
  802fc8:	c3                   	retq   

0000000000802fc9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802fc9:	55                   	push   %rbp
  802fca:	48 89 e5             	mov    %rsp,%rbp
  802fcd:	48 83 ec 20          	sub    $0x20,%rsp
  802fd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe1:	89 c2                	mov    %eax,%edx
  802fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe7:	8b 40 0c             	mov    0xc(%rax),%eax
  802fea:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fee:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ff3:	89 c7                	mov    %eax,%edi
  802ff5:	48 b8 31 33 80 00 00 	movabs $0x803331,%rax
  802ffc:	00 00 00 
  802fff:	ff d0                	callq  *%rax
}
  803001:	c9                   	leaveq 
  803002:	c3                   	retq   

0000000000803003 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803003:	55                   	push   %rbp
  803004:	48 89 e5             	mov    %rsp,%rbp
  803007:	48 83 ec 20          	sub    $0x20,%rsp
  80300b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80300f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803013:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301b:	89 c2                	mov    %eax,%edx
  80301d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803021:	8b 40 0c             	mov    0xc(%rax),%eax
  803024:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803028:	b9 00 00 00 00       	mov    $0x0,%ecx
  80302d:	89 c7                	mov    %eax,%edi
  80302f:	48 b8 fd 33 80 00 00 	movabs $0x8033fd,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
}
  80303b:	c9                   	leaveq 
  80303c:	c3                   	retq   

000000000080303d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80303d:	55                   	push   %rbp
  80303e:	48 89 e5             	mov    %rsp,%rbp
  803041:	48 83 ec 10          	sub    $0x10,%rsp
  803045:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803049:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80304d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803051:	48 be 70 45 80 00 00 	movabs $0x804570,%rsi
  803058:	00 00 00 
  80305b:	48 89 c7             	mov    %rax,%rdi
  80305e:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
	return 0;
  80306a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306f:	c9                   	leaveq 
  803070:	c3                   	retq   

0000000000803071 <socket>:

int
socket(int domain, int type, int protocol)
{
  803071:	55                   	push   %rbp
  803072:	48 89 e5             	mov    %rsp,%rbp
  803075:	48 83 ec 20          	sub    $0x20,%rsp
  803079:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80307f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803082:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803085:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803088:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80308b:	89 ce                	mov    %ecx,%esi
  80308d:	89 c7                	mov    %eax,%edi
  80308f:	48 b8 b5 34 80 00 00 	movabs $0x8034b5,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a2:	79 05                	jns    8030a9 <socket+0x38>
		return r;
  8030a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a7:	eb 11                	jmp    8030ba <socket+0x49>
	return alloc_sockfd(r);
  8030a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ac:	89 c7                	mov    %eax,%edi
  8030ae:	48 b8 53 2d 80 00 00 	movabs $0x802d53,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 10          	sub    $0x10,%rsp
  8030c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030c7:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030ce:	00 00 00 
  8030d1:	8b 00                	mov    (%rax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	75 1d                	jne    8030f4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8030dc:	48 b8 76 1c 80 00 00 	movabs $0x801c76,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
  8030e8:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030ef:	00 00 00 
  8030f2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030f4:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030fb:	00 00 00 
  8030fe:	8b 00                	mov    (%rax),%eax
  803100:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803103:	b9 07 00 00 00       	mov    $0x7,%ecx
  803108:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80310f:	00 00 00 
  803112:	89 c7                	mov    %eax,%edi
  803114:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803120:	ba 00 00 00 00       	mov    $0x0,%edx
  803125:	be 00 00 00 00       	mov    $0x0,%esi
  80312a:	bf 00 00 00 00       	mov    $0x0,%edi
  80312f:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
}
  80313b:	c9                   	leaveq 
  80313c:	c3                   	retq   

000000000080313d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80313d:	55                   	push   %rbp
  80313e:	48 89 e5             	mov    %rsp,%rbp
  803141:	48 83 ec 30          	sub    $0x30,%rsp
  803145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80314c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803150:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803157:	00 00 00 
  80315a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80315d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80315f:	bf 01 00 00 00       	mov    $0x1,%edi
  803164:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80316b:	00 00 00 
  80316e:	ff d0                	callq  *%rax
  803170:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803173:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803177:	78 3e                	js     8031b7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803179:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803180:	00 00 00 
  803183:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318b:	8b 40 10             	mov    0x10(%rax),%eax
  80318e:	89 c2                	mov    %eax,%edx
  803190:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803198:	48 89 ce             	mov    %rcx,%rsi
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ae:	8b 50 10             	mov    0x10(%rax),%edx
  8031b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031ba:	c9                   	leaveq 
  8031bb:	c3                   	retq   

00000000008031bc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031bc:	55                   	push   %rbp
  8031bd:	48 89 e5             	mov    %rsp,%rbp
  8031c0:	48 83 ec 10          	sub    $0x10,%rsp
  8031c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d5:	00 00 00 
  8031d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031db:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e4:	48 89 c6             	mov    %rax,%rsi
  8031e7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031ee:	00 00 00 
  8031f1:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8031fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803204:	00 00 00 
  803207:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80320a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80320d:	bf 02 00 00 00       	mov    $0x2,%edi
  803212:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
}
  80321e:	c9                   	leaveq 
  80321f:	c3                   	retq   

0000000000803220 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803220:	55                   	push   %rbp
  803221:	48 89 e5             	mov    %rsp,%rbp
  803224:	48 83 ec 10          	sub    $0x10,%rsp
  803228:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80322b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80322e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803235:	00 00 00 
  803238:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80323b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80323d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803244:	00 00 00 
  803247:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80324d:	bf 03 00 00 00       	mov    $0x3,%edi
  803252:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
}
  80325e:	c9                   	leaveq 
  80325f:	c3                   	retq   

0000000000803260 <nsipc_close>:

int
nsipc_close(int s)
{
  803260:	55                   	push   %rbp
  803261:	48 89 e5             	mov    %rsp,%rbp
  803264:	48 83 ec 10          	sub    $0x10,%rsp
  803268:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80326b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803272:	00 00 00 
  803275:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803278:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80327a:	bf 04 00 00 00       	mov    $0x4,%edi
  80327f:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
}
  80328b:	c9                   	leaveq 
  80328c:	c3                   	retq   

000000000080328d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80328d:	55                   	push   %rbp
  80328e:	48 89 e5             	mov    %rsp,%rbp
  803291:	48 83 ec 10          	sub    $0x10,%rsp
  803295:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803298:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80329c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80329f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a6:	00 00 00 
  8032a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032ac:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032ae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b5:	48 89 c6             	mov    %rax,%rsi
  8032b8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032bf:	00 00 00 
  8032c2:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d5:	00 00 00 
  8032d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032db:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032de:	bf 05 00 00 00       	mov    $0x5,%edi
  8032e3:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
}
  8032ef:	c9                   	leaveq 
  8032f0:	c3                   	retq   

00000000008032f1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8032f1:	55                   	push   %rbp
  8032f2:	48 89 e5             	mov    %rsp,%rbp
  8032f5:	48 83 ec 10          	sub    $0x10,%rsp
  8032f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8032ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803306:	00 00 00 
  803309:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80330c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80330e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803315:	00 00 00 
  803318:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80331e:	bf 06 00 00 00       	mov    $0x6,%edi
  803323:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
}
  80332f:	c9                   	leaveq 
  803330:	c3                   	retq   

0000000000803331 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803331:	55                   	push   %rbp
  803332:	48 89 e5             	mov    %rsp,%rbp
  803335:	48 83 ec 30          	sub    $0x30,%rsp
  803339:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80333c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803340:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803343:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803346:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80334d:	00 00 00 
  803350:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803353:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803355:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335c:	00 00 00 
  80335f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803362:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803365:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336c:	00 00 00 
  80336f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803372:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803375:	bf 07 00 00 00       	mov    $0x7,%edi
  80337a:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803381:	00 00 00 
  803384:	ff d0                	callq  *%rax
  803386:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803389:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338d:	78 69                	js     8033f8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80338f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803396:	7f 08                	jg     8033a0 <nsipc_recv+0x6f>
  803398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80339e:	7e 35                	jle    8033d5 <nsipc_recv+0xa4>
  8033a0:	48 b9 77 45 80 00 00 	movabs $0x804577,%rcx
  8033a7:	00 00 00 
  8033aa:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  8033b1:	00 00 00 
  8033b4:	be 61 00 00 00       	mov    $0x61,%esi
  8033b9:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  8033c0:	00 00 00 
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	49 b8 84 3d 80 00 00 	movabs $0x803d84,%r8
  8033cf:	00 00 00 
  8033d2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d8:	48 63 d0             	movslq %eax,%rdx
  8033db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033df:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033e6:	00 00 00 
  8033e9:	48 89 c7             	mov    %rax,%rdi
  8033ec:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8033f3:	00 00 00 
  8033f6:	ff d0                	callq  *%rax
	}

	return r;
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033fb:	c9                   	leaveq 
  8033fc:	c3                   	retq   

00000000008033fd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033fd:	55                   	push   %rbp
  8033fe:	48 89 e5             	mov    %rsp,%rbp
  803401:	48 83 ec 20          	sub    $0x20,%rsp
  803405:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803408:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80340c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80340f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803412:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803419:	00 00 00 
  80341c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80341f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803421:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803428:	7e 35                	jle    80345f <nsipc_send+0x62>
  80342a:	48 b9 ad 45 80 00 00 	movabs $0x8045ad,%rcx
  803431:	00 00 00 
  803434:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  80343b:	00 00 00 
  80343e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803443:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  80344a:	00 00 00 
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	49 b8 84 3d 80 00 00 	movabs $0x803d84,%r8
  803459:	00 00 00 
  80345c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80345f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803462:	48 63 d0             	movslq %eax,%rdx
  803465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803469:	48 89 c6             	mov    %rax,%rsi
  80346c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803473:	00 00 00 
  803476:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803482:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803489:	00 00 00 
  80348c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80348f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803492:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803499:	00 00 00 
  80349c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80349f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034a2:	bf 08 00 00 00       	mov    $0x8,%edi
  8034a7:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
}
  8034b3:	c9                   	leaveq 
  8034b4:	c3                   	retq   

00000000008034b5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034b5:	55                   	push   %rbp
  8034b6:	48 89 e5             	mov    %rsp,%rbp
  8034b9:	48 83 ec 10          	sub    $0x10,%rsp
  8034bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034c0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034c3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034cd:	00 00 00 
  8034d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034d3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8034d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034dc:	00 00 00 
  8034df:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ec:	00 00 00 
  8034ef:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034f2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8034f5:	bf 09 00 00 00       	mov    $0x9,%edi
  8034fa:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   

0000000000803508 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	53                   	push   %rbx
  80350d:	48 83 ec 38          	sub    $0x38,%rsp
  803511:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803515:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803519:	48 89 c7             	mov    %rax,%rdi
  80351c:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803523:	00 00 00 
  803526:	ff d0                	callq  *%rax
  803528:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80352b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80352f:	0f 88 bf 01 00 00    	js     8036f4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803539:	ba 07 04 00 00       	mov    $0x407,%edx
  80353e:	48 89 c6             	mov    %rax,%rsi
  803541:	bf 00 00 00 00       	mov    $0x0,%edi
  803546:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
  803552:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803555:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803559:	0f 88 95 01 00 00    	js     8036f4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80355f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803563:	48 89 c7             	mov    %rax,%rdi
  803566:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
  803572:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803575:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803579:	0f 88 5d 01 00 00    	js     8036dc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80357f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803583:	ba 07 04 00 00       	mov    $0x407,%edx
  803588:	48 89 c6             	mov    %rax,%rsi
  80358b:	bf 00 00 00 00       	mov    $0x0,%edi
  803590:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80359f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a3:	0f 88 33 01 00 00    	js     8036dc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ad:	48 89 c7             	mov    %rax,%rdi
  8035b0:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
  8035bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c4:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c9:	48 89 c6             	mov    %rax,%rsi
  8035cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d1:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e4:	79 05                	jns    8035eb <pipe+0xe3>
		goto err2;
  8035e6:	e9 d9 00 00 00       	jmpq   8036c4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ef:	48 89 c7             	mov    %rax,%rdi
  8035f2:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	48 89 c2             	mov    %rax,%rdx
  803601:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803605:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80360b:	48 89 d1             	mov    %rdx,%rcx
  80360e:	ba 00 00 00 00       	mov    $0x0,%edx
  803613:	48 89 c6             	mov    %rax,%rsi
  803616:	bf 00 00 00 00       	mov    $0x0,%edi
  80361b:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
  803627:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80362a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80362e:	79 1b                	jns    80364b <pipe+0x143>
		goto err3;
  803630:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803631:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803635:	48 89 c6             	mov    %rax,%rsi
  803638:	bf 00 00 00 00       	mov    $0x0,%edi
  80363d:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	eb 79                	jmp    8036c4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80364b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803656:	00 00 00 
  803659:	8b 12                	mov    (%rdx),%edx
  80365b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80365d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803661:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803668:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803673:	00 00 00 
  803676:	8b 12                	mov    (%rdx),%edx
  803678:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80367a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803689:	48 89 c7             	mov    %rax,%rdi
  80368c:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
  803698:	89 c2                	mov    %eax,%edx
  80369a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80369e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036a4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ac:	48 89 c7             	mov    %rax,%rdi
  8036af:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c2:	eb 33                	jmp    8036f7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8036c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c8:	48 89 c6             	mov    %rax,%rsi
  8036cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d0:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e0:	48 89 c6             	mov    %rax,%rsi
  8036e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e8:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
err:
	return r;
  8036f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036f7:	48 83 c4 38          	add    $0x38,%rsp
  8036fb:	5b                   	pop    %rbx
  8036fc:	5d                   	pop    %rbp
  8036fd:	c3                   	retq   

00000000008036fe <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036fe:	55                   	push   %rbp
  8036ff:	48 89 e5             	mov    %rsp,%rbp
  803702:	53                   	push   %rbx
  803703:	48 83 ec 28          	sub    $0x28,%rsp
  803707:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80370b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80370f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803716:	00 00 00 
  803719:	48 8b 00             	mov    (%rax),%rax
  80371c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803722:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803729:	48 89 c7             	mov    %rax,%rdi
  80372c:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
  803738:	89 c3                	mov    %eax,%ebx
  80373a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80373e:	48 89 c7             	mov    %rax,%rdi
  803741:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
  80374d:	39 c3                	cmp    %eax,%ebx
  80374f:	0f 94 c0             	sete   %al
  803752:	0f b6 c0             	movzbl %al,%eax
  803755:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803758:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80375f:	00 00 00 
  803762:	48 8b 00             	mov    (%rax),%rax
  803765:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80376b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80376e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803771:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803774:	75 05                	jne    80377b <_pipeisclosed+0x7d>
			return ret;
  803776:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803779:	eb 4f                	jmp    8037ca <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80377b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803781:	74 42                	je     8037c5 <_pipeisclosed+0xc7>
  803783:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803787:	75 3c                	jne    8037c5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803789:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803790:	00 00 00 
  803793:	48 8b 00             	mov    (%rax),%rax
  803796:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80379c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80379f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037a2:	89 c6                	mov    %eax,%esi
  8037a4:	48 bf be 45 80 00 00 	movabs $0x8045be,%rdi
  8037ab:	00 00 00 
  8037ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b3:	49 b8 f1 02 80 00 00 	movabs $0x8002f1,%r8
  8037ba:	00 00 00 
  8037bd:	41 ff d0             	callq  *%r8
	}
  8037c0:	e9 4a ff ff ff       	jmpq   80370f <_pipeisclosed+0x11>
  8037c5:	e9 45 ff ff ff       	jmpq   80370f <_pipeisclosed+0x11>
}
  8037ca:	48 83 c4 28          	add    $0x28,%rsp
  8037ce:	5b                   	pop    %rbx
  8037cf:	5d                   	pop    %rbp
  8037d0:	c3                   	retq   

00000000008037d1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037d1:	55                   	push   %rbp
  8037d2:	48 89 e5             	mov    %rsp,%rbp
  8037d5:	48 83 ec 30          	sub    $0x30,%rsp
  8037d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037e3:	48 89 d6             	mov    %rdx,%rsi
  8037e6:	89 c7                	mov    %eax,%edi
  8037e8:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
  8037f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fb:	79 05                	jns    803802 <pipeisclosed+0x31>
		return r;
  8037fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803800:	eb 31                	jmp    803833 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803806:	48 89 c7             	mov    %rax,%rdi
  803809:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803810:	00 00 00 
  803813:	ff d0                	callq  *%rax
  803815:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80381d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803821:	48 89 d6             	mov    %rdx,%rsi
  803824:	48 89 c7             	mov    %rax,%rdi
  803827:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
}
  803833:	c9                   	leaveq 
  803834:	c3                   	retq   

0000000000803835 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803835:	55                   	push   %rbp
  803836:	48 89 e5             	mov    %rsp,%rbp
  803839:	48 83 ec 40          	sub    $0x40,%rsp
  80383d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803841:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803845:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
  80385c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803860:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803864:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803868:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80386f:	00 
  803870:	e9 92 00 00 00       	jmpq   803907 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803875:	eb 41                	jmp    8038b8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803877:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80387c:	74 09                	je     803887 <devpipe_read+0x52>
				return i;
  80387e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803882:	e9 92 00 00 00       	jmpq   803919 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803887:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80388b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388f:	48 89 d6             	mov    %rdx,%rsi
  803892:	48 89 c7             	mov    %rax,%rdi
  803895:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 07                	je     8038ac <devpipe_read+0x77>
				return 0;
  8038a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038aa:	eb 6d                	jmp    803919 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038ac:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bc:	8b 10                	mov    (%rax),%edx
  8038be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c2:	8b 40 04             	mov    0x4(%rax),%eax
  8038c5:	39 c2                	cmp    %eax,%edx
  8038c7:	74 ae                	je     803877 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038d1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d9:	8b 00                	mov    (%rax),%eax
  8038db:	99                   	cltd   
  8038dc:	c1 ea 1b             	shr    $0x1b,%edx
  8038df:	01 d0                	add    %edx,%eax
  8038e1:	83 e0 1f             	and    $0x1f,%eax
  8038e4:	29 d0                	sub    %edx,%eax
  8038e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038ea:	48 98                	cltq   
  8038ec:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038f1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f7:	8b 00                	mov    (%rax),%eax
  8038f9:	8d 50 01             	lea    0x1(%rax),%edx
  8038fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803900:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803902:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80390f:	0f 82 60 ff ff ff    	jb     803875 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803915:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803919:	c9                   	leaveq 
  80391a:	c3                   	retq   

000000000080391b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80391b:	55                   	push   %rbp
  80391c:	48 89 e5             	mov    %rsp,%rbp
  80391f:	48 83 ec 40          	sub    $0x40,%rsp
  803923:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803927:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80392b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80392f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803933:	48 89 c7             	mov    %rax,%rdi
  803936:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
  803942:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80394e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803955:	00 
  803956:	e9 8e 00 00 00       	jmpq   8039e9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80395b:	eb 31                	jmp    80398e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80395d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803961:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803965:	48 89 d6             	mov    %rdx,%rsi
  803968:	48 89 c7             	mov    %rax,%rdi
  80396b:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	85 c0                	test   %eax,%eax
  803979:	74 07                	je     803982 <devpipe_write+0x67>
				return 0;
  80397b:	b8 00 00 00 00       	mov    $0x0,%eax
  803980:	eb 79                	jmp    8039fb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803982:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  803989:	00 00 00 
  80398c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80398e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803992:	8b 40 04             	mov    0x4(%rax),%eax
  803995:	48 63 d0             	movslq %eax,%rdx
  803998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399c:	8b 00                	mov    (%rax),%eax
  80399e:	48 98                	cltq   
  8039a0:	48 83 c0 20          	add    $0x20,%rax
  8039a4:	48 39 c2             	cmp    %rax,%rdx
  8039a7:	73 b4                	jae    80395d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ad:	8b 40 04             	mov    0x4(%rax),%eax
  8039b0:	99                   	cltd   
  8039b1:	c1 ea 1b             	shr    $0x1b,%edx
  8039b4:	01 d0                	add    %edx,%eax
  8039b6:	83 e0 1f             	and    $0x1f,%eax
  8039b9:	29 d0                	sub    %edx,%eax
  8039bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039bf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039c3:	48 01 ca             	add    %rcx,%rdx
  8039c6:	0f b6 0a             	movzbl (%rdx),%ecx
  8039c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039cd:	48 98                	cltq   
  8039cf:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d7:	8b 40 04             	mov    0x4(%rax),%eax
  8039da:	8d 50 01             	lea    0x1(%rax),%edx
  8039dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ed:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039f1:	0f 82 64 ff ff ff    	jb     80395b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039fb:	c9                   	leaveq 
  8039fc:	c3                   	retq   

00000000008039fd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039fd:	55                   	push   %rbp
  8039fe:	48 89 e5             	mov    %rsp,%rbp
  803a01:	48 83 ec 20          	sub    $0x20,%rsp
  803a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a11:	48 89 c7             	mov    %rax,%rdi
  803a14:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
  803a20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a28:	48 be d1 45 80 00 00 	movabs $0x8045d1,%rsi
  803a2f:	00 00 00 
  803a32:	48 89 c7             	mov    %rax,%rdi
  803a35:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a45:	8b 50 04             	mov    0x4(%rax),%edx
  803a48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4c:	8b 00                	mov    (%rax),%eax
  803a4e:	29 c2                	sub    %eax,%edx
  803a50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a54:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a5e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a65:	00 00 00 
	stat->st_dev = &devpipe;
  803a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a73:	00 00 00 
  803a76:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a82:	c9                   	leaveq 
  803a83:	c3                   	retq   

0000000000803a84 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a84:	55                   	push   %rbp
  803a85:	48 89 e5             	mov    %rsp,%rbp
  803a88:	48 83 ec 10          	sub    $0x10,%rsp
  803a8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a94:	48 89 c6             	mov    %rax,%rsi
  803a97:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9c:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803aa3:	00 00 00 
  803aa6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aac:	48 89 c7             	mov    %rax,%rdi
  803aaf:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803ab6:	00 00 00 
  803ab9:	ff d0                	callq  *%rax
  803abb:	48 89 c6             	mov    %rax,%rsi
  803abe:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac3:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803aca:	00 00 00 
  803acd:	ff d0                	callq  *%rax
}
  803acf:	c9                   	leaveq 
  803ad0:	c3                   	retq   

0000000000803ad1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ad1:	55                   	push   %rbp
  803ad2:	48 89 e5             	mov    %rsp,%rbp
  803ad5:	48 83 ec 20          	sub    $0x20,%rsp
  803ad9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803adc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803adf:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ae2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ae6:	be 01 00 00 00       	mov    $0x1,%esi
  803aeb:	48 89 c7             	mov    %rax,%rdi
  803aee:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
}
  803afa:	c9                   	leaveq 
  803afb:	c3                   	retq   

0000000000803afc <getchar>:

int
getchar(void)
{
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b04:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b08:	ba 01 00 00 00       	mov    $0x1,%edx
  803b0d:	48 89 c6             	mov    %rax,%rsi
  803b10:	bf 00 00 00 00       	mov    $0x0,%edi
  803b15:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b28:	79 05                	jns    803b2f <getchar+0x33>
		return r;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	eb 14                	jmp    803b43 <getchar+0x47>
	if (r < 1)
  803b2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b33:	7f 07                	jg     803b3c <getchar+0x40>
		return -E_EOF;
  803b35:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b3a:	eb 07                	jmp    803b43 <getchar+0x47>
	return c;
  803b3c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b40:	0f b6 c0             	movzbl %al,%eax
}
  803b43:	c9                   	leaveq 
  803b44:	c3                   	retq   

0000000000803b45 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b45:	55                   	push   %rbp
  803b46:	48 89 e5             	mov    %rsp,%rbp
  803b49:	48 83 ec 20          	sub    $0x20,%rsp
  803b4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b50:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b57:	48 89 d6             	mov    %rdx,%rsi
  803b5a:	89 c7                	mov    %eax,%edi
  803b5c:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  803b63:	00 00 00 
  803b66:	ff d0                	callq  *%rax
  803b68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6f:	79 05                	jns    803b76 <iscons+0x31>
		return r;
  803b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b74:	eb 1a                	jmp    803b90 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	8b 10                	mov    (%rax),%edx
  803b7c:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b83:	00 00 00 
  803b86:	8b 00                	mov    (%rax),%eax
  803b88:	39 c2                	cmp    %eax,%edx
  803b8a:	0f 94 c0             	sete   %al
  803b8d:	0f b6 c0             	movzbl %al,%eax
}
  803b90:	c9                   	leaveq 
  803b91:	c3                   	retq   

0000000000803b92 <opencons>:

int
opencons(void)
{
  803b92:	55                   	push   %rbp
  803b93:	48 89 e5             	mov    %rsp,%rbp
  803b96:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b9a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b9e:	48 89 c7             	mov    %rax,%rdi
  803ba1:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb4:	79 05                	jns    803bbb <opencons+0x29>
		return r;
  803bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb9:	eb 5b                	jmp    803c16 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbf:	ba 07 04 00 00       	mov    $0x407,%edx
  803bc4:	48 89 c6             	mov    %rax,%rsi
  803bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bcc:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax
  803bd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bdf:	79 05                	jns    803be6 <opencons+0x54>
		return r;
  803be1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be4:	eb 30                	jmp    803c16 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803be6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bea:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803bf1:	00 00 00 
  803bf4:	8b 12                	mov    (%rdx),%edx
  803bf6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c07:	48 89 c7             	mov    %rax,%rdi
  803c0a:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
}
  803c16:	c9                   	leaveq 
  803c17:	c3                   	retq   

0000000000803c18 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c18:	55                   	push   %rbp
  803c19:	48 89 e5             	mov    %rsp,%rbp
  803c1c:	48 83 ec 30          	sub    $0x30,%rsp
  803c20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c2c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c31:	75 07                	jne    803c3a <devcons_read+0x22>
		return 0;
  803c33:	b8 00 00 00 00       	mov    $0x0,%eax
  803c38:	eb 4b                	jmp    803c85 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c3a:	eb 0c                	jmp    803c48 <devcons_read+0x30>
		sys_yield();
  803c3c:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c48:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  803c4f:	00 00 00 
  803c52:	ff d0                	callq  *%rax
  803c54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5b:	74 df                	je     803c3c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c61:	79 05                	jns    803c68 <devcons_read+0x50>
		return c;
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	eb 1d                	jmp    803c85 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c68:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c6c:	75 07                	jne    803c75 <devcons_read+0x5d>
		return 0;
  803c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c73:	eb 10                	jmp    803c85 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	89 c2                	mov    %eax,%edx
  803c7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c7e:	88 10                	mov    %dl,(%rax)
	return 1;
  803c80:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c85:	c9                   	leaveq 
  803c86:	c3                   	retq   

0000000000803c87 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c87:	55                   	push   %rbp
  803c88:	48 89 e5             	mov    %rsp,%rbp
  803c8b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c92:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c99:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ca0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cae:	eb 76                	jmp    803d26 <devcons_write+0x9f>
		m = n - tot;
  803cb0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cb7:	89 c2                	mov    %eax,%edx
  803cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbc:	29 c2                	sub    %eax,%edx
  803cbe:	89 d0                	mov    %edx,%eax
  803cc0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cc6:	83 f8 7f             	cmp    $0x7f,%eax
  803cc9:	76 07                	jbe    803cd2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ccb:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803cd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd5:	48 63 d0             	movslq %eax,%rdx
  803cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdb:	48 63 c8             	movslq %eax,%rcx
  803cde:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ce5:	48 01 c1             	add    %rax,%rcx
  803ce8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cef:	48 89 ce             	mov    %rcx,%rsi
  803cf2:	48 89 c7             	mov    %rax,%rdi
  803cf5:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  803cfc:	00 00 00 
  803cff:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d04:	48 63 d0             	movslq %eax,%rdx
  803d07:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d0e:	48 89 d6             	mov    %rdx,%rsi
  803d11:	48 89 c7             	mov    %rax,%rdi
  803d14:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803d1b:	00 00 00 
  803d1e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d23:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d29:	48 98                	cltq   
  803d2b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d32:	0f 82 78 ff ff ff    	jb     803cb0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d3b:	c9                   	leaveq 
  803d3c:	c3                   	retq   

0000000000803d3d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d3d:	55                   	push   %rbp
  803d3e:	48 89 e5             	mov    %rsp,%rbp
  803d41:	48 83 ec 08          	sub    $0x8,%rsp
  803d45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d4e:	c9                   	leaveq 
  803d4f:	c3                   	retq   

0000000000803d50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d50:	55                   	push   %rbp
  803d51:	48 89 e5             	mov    %rsp,%rbp
  803d54:	48 83 ec 10          	sub    $0x10,%rsp
  803d58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d64:	48 be dd 45 80 00 00 	movabs $0x8045dd,%rsi
  803d6b:	00 00 00 
  803d6e:	48 89 c7             	mov    %rax,%rdi
  803d71:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
	return 0;
  803d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	53                   	push   %rbx
  803d89:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d90:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803d97:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803d9d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803da4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803dab:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803db2:	84 c0                	test   %al,%al
  803db4:	74 23                	je     803dd9 <_panic+0x55>
  803db6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803dbd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803dc1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803dc5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803dc9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803dcd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803dd1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803dd5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803dd9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803de0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803de7:	00 00 00 
  803dea:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803df1:	00 00 00 
  803df4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803df8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803dff:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e06:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e0d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803e14:	00 00 00 
  803e17:	48 8b 18             	mov    (%rax),%rbx
  803e1a:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  803e21:	00 00 00 
  803e24:	ff d0                	callq  *%rax
  803e26:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e2c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e33:	41 89 c8             	mov    %ecx,%r8d
  803e36:	48 89 d1             	mov    %rdx,%rcx
  803e39:	48 89 da             	mov    %rbx,%rdx
  803e3c:	89 c6                	mov    %eax,%esi
  803e3e:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  803e45:	00 00 00 
  803e48:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4d:	49 b9 f1 02 80 00 00 	movabs $0x8002f1,%r9
  803e54:	00 00 00 
  803e57:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803e5a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803e61:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e68:	48 89 d6             	mov    %rdx,%rsi
  803e6b:	48 89 c7             	mov    %rax,%rdi
  803e6e:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  803e75:	00 00 00 
  803e78:	ff d0                	callq  *%rax
	cprintf("\n");
  803e7a:	48 bf 0b 46 80 00 00 	movabs $0x80460b,%rdi
  803e81:	00 00 00 
  803e84:	b8 00 00 00 00       	mov    $0x0,%eax
  803e89:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  803e90:	00 00 00 
  803e93:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803e95:	cc                   	int3   
  803e96:	eb fd                	jmp    803e95 <_panic+0x111>

0000000000803e98 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e98:	55                   	push   %rbp
  803e99:	48 89 e5             	mov    %rsp,%rbp
  803e9c:	48 83 ec 18          	sub    $0x18,%rsp
  803ea0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea8:	48 c1 e8 15          	shr    $0x15,%rax
  803eac:	48 89 c2             	mov    %rax,%rdx
  803eaf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eb6:	01 00 00 
  803eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ebd:	83 e0 01             	and    $0x1,%eax
  803ec0:	48 85 c0             	test   %rax,%rax
  803ec3:	75 07                	jne    803ecc <pageref+0x34>
		return 0;
  803ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eca:	eb 53                	jmp    803f1f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ed0:	48 c1 e8 0c          	shr    $0xc,%rax
  803ed4:	48 89 c2             	mov    %rax,%rdx
  803ed7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ede:	01 00 00 
  803ee1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ee5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ee9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eed:	83 e0 01             	and    $0x1,%eax
  803ef0:	48 85 c0             	test   %rax,%rax
  803ef3:	75 07                	jne    803efc <pageref+0x64>
		return 0;
  803ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  803efa:	eb 23                	jmp    803f1f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f00:	48 c1 e8 0c          	shr    $0xc,%rax
  803f04:	48 89 c2             	mov    %rax,%rdx
  803f07:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f0e:	00 00 00 
  803f11:	48 c1 e2 04          	shl    $0x4,%rdx
  803f15:	48 01 d0             	add    %rdx,%rax
  803f18:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f1c:	0f b7 c0             	movzwl %ax,%eax
}
  803f1f:	c9                   	leaveq 
  803f20:	c3                   	retq   
