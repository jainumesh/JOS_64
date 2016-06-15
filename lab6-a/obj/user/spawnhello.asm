
obj/user/spawnhello.debug:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 5e 4a 80 00 00 	movabs $0x804a5e,%rsi
  80008e:	00 00 00 
  800091:	48 bf 64 4a 80 00 00 	movabs $0x804a64,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 4a 2f 80 00 00 	movabs $0x802f4a,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 87 4a 80 00 00 	movabs $0x804a87,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	25 ff 03 00 00       	and    $0x3ff,%eax
  800107:	48 63 d0             	movslq %eax,%rdx
  80010a:	48 89 d0             	mov    %rdx,%rax
  80010d:	48 c1 e0 03          	shl    $0x3,%rax
  800111:	48 01 d0             	add    %rdx,%rax
  800114:	48 c1 e0 05          	shl    $0x5,%rax
  800118:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80011f:	00 00 00 
  800122:	48 01 c2             	add    %rax,%rdx
  800125:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80012c:	00 00 00 
  80012f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800136:	7e 14                	jle    80014c <libmain+0x65>
		binaryname = argv[0];
  800138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013c:	48 8b 10             	mov    (%rax),%rdx
  80013f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800146:	00 00 00 
  800149:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80014c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	48 89 d6             	mov    %rdx,%rsi
  800156:	89 c7                	mov    %eax,%edi
  800158:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80015f:	00 00 00 
  800162:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800164:	48 b8 72 01 80 00 00 	movabs $0x800172,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
}
  800170:	c9                   	leaveq 
  800171:	c3                   	retq   

0000000000800172 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800172:	55                   	push   %rbp
  800173:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800176:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800182:	bf 00 00 00 00       	mov    $0x0,%edi
  800187:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80018e:	00 00 00 
  800191:	ff d0                	callq  *%rax

}
  800193:	5d                   	pop    %rbp
  800194:	c3                   	retq   

0000000000800195 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800195:	55                   	push   %rbp
  800196:	48 89 e5             	mov    %rsp,%rbp
  800199:	53                   	push   %rbx
  80019a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001a1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001a8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001ae:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001b5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001bc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c3:	84 c0                	test   %al,%al
  8001c5:	74 23                	je     8001ea <_panic+0x55>
  8001c7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001ce:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001d6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001da:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001de:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001e6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001ea:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001f1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001f8:	00 00 00 
  8001fb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800202:	00 00 00 
  800205:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800209:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800210:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800217:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80021e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800225:	00 00 00 
  800228:	48 8b 18             	mov    (%rax),%rbx
  80022b:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
  800237:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80023d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800244:	41 89 c8             	mov    %ecx,%r8d
  800247:	48 89 d1             	mov    %rdx,%rcx
  80024a:	48 89 da             	mov    %rbx,%rdx
  80024d:	89 c6                	mov    %eax,%esi
  80024f:	48 bf a8 4a 80 00 00 	movabs $0x804aa8,%rdi
  800256:	00 00 00 
  800259:	b8 00 00 00 00       	mov    $0x0,%eax
  80025e:	49 b9 ce 03 80 00 00 	movabs $0x8003ce,%r9
  800265:	00 00 00 
  800268:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800272:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800279:	48 89 d6             	mov    %rdx,%rsi
  80027c:	48 89 c7             	mov    %rax,%rdi
  80027f:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
	cprintf("\n");
  80028b:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  800292:	00 00 00 
  800295:	b8 00 00 00 00       	mov    $0x0,%eax
  80029a:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  8002a1:	00 00 00 
  8002a4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a6:	cc                   	int3   
  8002a7:	eb fd                	jmp    8002a6 <_panic+0x111>

00000000008002a9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a9:	55                   	push   %rbp
  8002aa:	48 89 e5             	mov    %rsp,%rbp
  8002ad:	48 83 ec 10          	sub    $0x10,%rsp
  8002b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bc:	8b 00                	mov    (%rax),%eax
  8002be:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c5:	89 0a                	mov    %ecx,(%rdx)
  8002c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002ca:	89 d1                	mov    %edx,%ecx
  8002cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d0:	48 98                	cltq   
  8002d2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002da:	8b 00                	mov    (%rax),%eax
  8002dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e1:	75 2c                	jne    80030f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e7:	8b 00                	mov    (%rax),%eax
  8002e9:	48 98                	cltq   
  8002eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ef:	48 83 c2 08          	add    $0x8,%rdx
  8002f3:	48 89 c6             	mov    %rax,%rsi
  8002f6:	48 89 d7             	mov    %rdx,%rdi
  8002f9:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
        b->idx = 0;
  800305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800309:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80030f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800313:	8b 40 04             	mov    0x4(%rax),%eax
  800316:	8d 50 01             	lea    0x1(%rax),%edx
  800319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800320:	c9                   	leaveq 
  800321:	c3                   	retq   

0000000000800322 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80032d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800334:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80033b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800342:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800349:	48 8b 0a             	mov    (%rdx),%rcx
  80034c:	48 89 08             	mov    %rcx,(%rax)
  80034f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800353:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800357:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80035f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800366:	00 00 00 
    b.cnt = 0;
  800369:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800370:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800373:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800381:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800388:	48 89 c6             	mov    %rax,%rsi
  80038b:	48 bf a9 02 80 00 00 	movabs $0x8002a9,%rdi
  800392:	00 00 00 
  800395:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a7:	48 98                	cltq   
  8003a9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b0:	48 83 c2 08          	add    $0x8,%rdx
  8003b4:	48 89 c6             	mov    %rax,%rsi
  8003b7:	48 89 d7             	mov    %rdx,%rdi
  8003ba:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003fc:	84 c0                	test   %al,%al
  8003fe:	74 20                	je     800420 <cprintf+0x52>
  800400:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800404:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800408:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800410:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800414:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800418:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800420:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800427:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042e:	00 00 00 
  800431:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800438:	00 00 00 
  80043b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800446:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80044d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800454:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80045b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800462:	48 8b 0a             	mov    (%rdx),%rcx
  800465:	48 89 08             	mov    %rcx,(%rax)
  800468:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800470:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800474:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800478:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80047f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800486:	48 89 d6             	mov    %rdx,%rsi
  800489:	48 89 c7             	mov    %rax,%rdi
  80048c:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800493:	00 00 00 
  800496:	ff d0                	callq  *%rax
  800498:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a4:	c9                   	leaveq 
  8004a5:	c3                   	retq   

00000000008004a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a6:	55                   	push   %rbp
  8004a7:	48 89 e5             	mov    %rsp,%rbp
  8004aa:	53                   	push   %rbx
  8004ab:	48 83 ec 38          	sub    $0x38,%rsp
  8004af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004bb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004be:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c2:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004cd:	77 3b                	ja     80050a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cf:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d2:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d6:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	48 f7 f3             	div    %rbx
  8004e5:	48 89 c2             	mov    %rax,%rdx
  8004e8:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004eb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ee:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f6:	41 89 f9             	mov    %edi,%r9d
  8004f9:	48 89 c7             	mov    %rax,%rdi
  8004fc:	48 b8 a6 04 80 00 00 	movabs $0x8004a6,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
  800508:	eb 1e                	jmp    800528 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050a:	eb 12                	jmp    80051e <printnum+0x78>
			putch(padc, putdat);
  80050c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800510:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800517:	48 89 ce             	mov    %rcx,%rsi
  80051a:	89 d7                	mov    %edx,%edi
  80051c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800522:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800526:	7f e4                	jg     80050c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800528:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80052b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
  800534:	48 f7 f1             	div    %rcx
  800537:	48 89 d0             	mov    %rdx,%rax
  80053a:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  800541:	00 00 00 
  800544:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800548:	0f be d0             	movsbl %al,%edx
  80054b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 89 ce             	mov    %rcx,%rsi
  800556:	89 d7                	mov    %edx,%edi
  800558:	ff d0                	callq  *%rax
}
  80055a:	48 83 c4 38          	add    $0x38,%rsp
  80055e:	5b                   	pop    %rbx
  80055f:	5d                   	pop    %rbp
  800560:	c3                   	retq   

0000000000800561 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800561:	55                   	push   %rbp
  800562:	48 89 e5             	mov    %rsp,%rbp
  800565:	48 83 ec 1c          	sub    $0x1c,%rsp
  800569:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800570:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800574:	7e 52                	jle    8005c8 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057a:	8b 00                	mov    (%rax),%eax
  80057c:	83 f8 30             	cmp    $0x30,%eax
  80057f:	73 24                	jae    8005a5 <getuint+0x44>
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058d:	8b 00                	mov    (%rax),%eax
  80058f:	89 c0                	mov    %eax,%eax
  800591:	48 01 d0             	add    %rdx,%rax
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	8b 12                	mov    (%rdx),%edx
  80059a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	89 0a                	mov    %ecx,(%rdx)
  8005a3:	eb 17                	jmp    8005bc <getuint+0x5b>
  8005a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ad:	48 89 d0             	mov    %rdx,%rax
  8005b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bc:	48 8b 00             	mov    (%rax),%rax
  8005bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c3:	e9 a3 00 00 00       	jmpq   80066b <getuint+0x10a>
	else if (lflag)
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005cc:	74 4f                	je     80061d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	83 f8 30             	cmp    $0x30,%eax
  8005d7:	73 24                	jae    8005fd <getuint+0x9c>
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	8b 00                	mov    (%rax),%eax
  8005e7:	89 c0                	mov    %eax,%eax
  8005e9:	48 01 d0             	add    %rdx,%rax
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	8b 12                	mov    (%rdx),%edx
  8005f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	89 0a                	mov    %ecx,(%rdx)
  8005fb:	eb 17                	jmp    800614 <getuint+0xb3>
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800605:	48 89 d0             	mov    %rdx,%rax
  800608:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800614:	48 8b 00             	mov    (%rax),%rax
  800617:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061b:	eb 4e                	jmp    80066b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	8b 00                	mov    (%rax),%eax
  800623:	83 f8 30             	cmp    $0x30,%eax
  800626:	73 24                	jae    80064c <getuint+0xeb>
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	89 c0                	mov    %eax,%eax
  800638:	48 01 d0             	add    %rdx,%rax
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	8b 12                	mov    (%rdx),%edx
  800641:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	89 0a                	mov    %ecx,(%rdx)
  80064a:	eb 17                	jmp    800663 <getuint+0x102>
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800654:	48 89 d0             	mov    %rdx,%rax
  800657:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800663:	8b 00                	mov    (%rax),%eax
  800665:	89 c0                	mov    %eax,%eax
  800667:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80066b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80066f:	c9                   	leaveq 
  800670:	c3                   	retq   

0000000000800671 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800671:	55                   	push   %rbp
  800672:	48 89 e5             	mov    %rsp,%rbp
  800675:	48 83 ec 1c          	sub    $0x1c,%rsp
  800679:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800680:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800684:	7e 52                	jle    8006d8 <getint+0x67>
		x=va_arg(*ap, long long);
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	8b 00                	mov    (%rax),%eax
  80068c:	83 f8 30             	cmp    $0x30,%eax
  80068f:	73 24                	jae    8006b5 <getint+0x44>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	8b 00                	mov    (%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a8:	8b 12                	mov    (%rdx),%edx
  8006aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	89 0a                	mov    %ecx,(%rdx)
  8006b3:	eb 17                	jmp    8006cc <getint+0x5b>
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bd:	48 89 d0             	mov    %rdx,%rax
  8006c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cc:	48 8b 00             	mov    (%rax),%rax
  8006cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d3:	e9 a3 00 00 00       	jmpq   80077b <getint+0x10a>
	else if (lflag)
  8006d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006dc:	74 4f                	je     80072d <getint+0xbc>
		x=va_arg(*ap, long);
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	83 f8 30             	cmp    $0x30,%eax
  8006e7:	73 24                	jae    80070d <getint+0x9c>
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	89 c0                	mov    %eax,%eax
  8006f9:	48 01 d0             	add    %rdx,%rax
  8006fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800700:	8b 12                	mov    (%rdx),%edx
  800702:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	89 0a                	mov    %ecx,(%rdx)
  80070b:	eb 17                	jmp    800724 <getint+0xb3>
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800715:	48 89 d0             	mov    %rdx,%rax
  800718:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800724:	48 8b 00             	mov    (%rax),%rax
  800727:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072b:	eb 4e                	jmp    80077b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80072d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800731:	8b 00                	mov    (%rax),%eax
  800733:	83 f8 30             	cmp    $0x30,%eax
  800736:	73 24                	jae    80075c <getint+0xeb>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	89 c0                	mov    %eax,%eax
  800748:	48 01 d0             	add    %rdx,%rax
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	8b 12                	mov    (%rdx),%edx
  800751:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	89 0a                	mov    %ecx,(%rdx)
  80075a:	eb 17                	jmp    800773 <getint+0x102>
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800764:	48 89 d0             	mov    %rdx,%rax
  800767:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800773:	8b 00                	mov    (%rax),%eax
  800775:	48 98                	cltq   
  800777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077f:	c9                   	leaveq 
  800780:	c3                   	retq   

0000000000800781 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800781:	55                   	push   %rbp
  800782:	48 89 e5             	mov    %rsp,%rbp
  800785:	41 54                	push   %r12
  800787:	53                   	push   %rbx
  800788:	48 83 ec 60          	sub    $0x60,%rsp
  80078c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800790:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800794:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800798:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80079c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a4:	48 8b 0a             	mov    (%rdx),%rcx
  8007a7:	48 89 08             	mov    %rcx,(%rax)
  8007aa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ba:	eb 17                	jmp    8007d3 <vprintfmt+0x52>
			if (ch == '\0')
  8007bc:	85 db                	test   %ebx,%ebx
  8007be:	0f 84 cc 04 00 00    	je     800c90 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	89 df                	mov    %ebx,%edi
  8007d1:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007db:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007df:	0f b6 00             	movzbl (%rax),%eax
  8007e2:	0f b6 d8             	movzbl %al,%ebx
  8007e5:	83 fb 25             	cmp    $0x25,%ebx
  8007e8:	75 d2                	jne    8007bc <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ea:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007ee:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800803:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80080e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800812:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800816:	0f b6 00             	movzbl (%rax),%eax
  800819:	0f b6 d8             	movzbl %al,%ebx
  80081c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80081f:	83 f8 55             	cmp    $0x55,%eax
  800822:	0f 87 34 04 00 00    	ja     800c5c <vprintfmt+0x4db>
  800828:	89 c0                	mov    %eax,%eax
  80082a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800831:	00 
  800832:	48 b8 f8 4c 80 00 00 	movabs $0x804cf8,%rax
  800839:	00 00 00 
  80083c:	48 01 d0             	add    %rdx,%rax
  80083f:	48 8b 00             	mov    (%rax),%rax
  800842:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800844:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800848:	eb c0                	jmp    80080a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80084e:	eb ba                	jmp    80080a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800850:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800857:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80085a:	89 d0                	mov    %edx,%eax
  80085c:	c1 e0 02             	shl    $0x2,%eax
  80085f:	01 d0                	add    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d8                	add    %ebx,%eax
  800865:	83 e8 30             	sub    $0x30,%eax
  800868:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80086b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086f:	0f b6 00             	movzbl (%rax),%eax
  800872:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800875:	83 fb 2f             	cmp    $0x2f,%ebx
  800878:	7e 0c                	jle    800886 <vprintfmt+0x105>
  80087a:	83 fb 39             	cmp    $0x39,%ebx
  80087d:	7f 07                	jg     800886 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800884:	eb d1                	jmp    800857 <vprintfmt+0xd6>
			goto process_precision;
  800886:	eb 58                	jmp    8008e0 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800888:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088b:	83 f8 30             	cmp    $0x30,%eax
  80088e:	73 17                	jae    8008a7 <vprintfmt+0x126>
  800890:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800894:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800897:	89 c0                	mov    %eax,%eax
  800899:	48 01 d0             	add    %rdx,%rax
  80089c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089f:	83 c2 08             	add    $0x8,%edx
  8008a2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a5:	eb 0f                	jmp    8008b6 <vprintfmt+0x135>
  8008a7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ab:	48 89 d0             	mov    %rdx,%rax
  8008ae:	48 83 c2 08          	add    $0x8,%rdx
  8008b2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008bb:	eb 23                	jmp    8008e0 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c1:	79 0c                	jns    8008cf <vprintfmt+0x14e>
				width = 0;
  8008c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008ca:	e9 3b ff ff ff       	jmpq   80080a <vprintfmt+0x89>
  8008cf:	e9 36 ff ff ff       	jmpq   80080a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008db:	e9 2a ff ff ff       	jmpq   80080a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e4:	79 12                	jns    8008f8 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f3:	e9 12 ff ff ff       	jmpq   80080a <vprintfmt+0x89>
  8008f8:	e9 0d ff ff ff       	jmpq   80080a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800901:	e9 04 ff ff ff       	jmpq   80080a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800906:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800909:	83 f8 30             	cmp    $0x30,%eax
  80090c:	73 17                	jae    800925 <vprintfmt+0x1a4>
  80090e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800912:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800915:	89 c0                	mov    %eax,%eax
  800917:	48 01 d0             	add    %rdx,%rax
  80091a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091d:	83 c2 08             	add    $0x8,%edx
  800920:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x1b3>
  800925:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800929:	48 89 d0             	mov    %rdx,%rax
  80092c:	48 83 c2 08          	add    $0x8,%rdx
  800930:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800934:	8b 10                	mov    (%rax),%edx
  800936:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80093a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093e:	48 89 ce             	mov    %rcx,%rsi
  800941:	89 d7                	mov    %edx,%edi
  800943:	ff d0                	callq  *%rax
			break;
  800945:	e9 40 03 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 17                	jae    800969 <vprintfmt+0x1e8>
  800952:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800961:	83 c2 08             	add    $0x8,%edx
  800964:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800967:	eb 0f                	jmp    800978 <vprintfmt+0x1f7>
  800969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096d:	48 89 d0             	mov    %rdx,%rax
  800970:	48 83 c2 08          	add    $0x8,%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	79 02                	jns    800980 <vprintfmt+0x1ff>
				err = -err;
  80097e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800980:	83 fb 15             	cmp    $0x15,%ebx
  800983:	7f 16                	jg     80099b <vprintfmt+0x21a>
  800985:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  80098c:	00 00 00 
  80098f:	48 63 d3             	movslq %ebx,%rdx
  800992:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800996:	4d 85 e4             	test   %r12,%r12
  800999:	75 2e                	jne    8009c9 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80099b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	89 d9                	mov    %ebx,%ecx
  8009a5:	48 ba e1 4c 80 00 00 	movabs $0x804ce1,%rdx
  8009ac:	00 00 00 
  8009af:	48 89 c7             	mov    %rax,%rdi
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	49 b8 99 0c 80 00 00 	movabs $0x800c99,%r8
  8009be:	00 00 00 
  8009c1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c4:	e9 c1 02 00 00       	jmpq   800c8a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d1:	4c 89 e1             	mov    %r12,%rcx
  8009d4:	48 ba ea 4c 80 00 00 	movabs $0x804cea,%rdx
  8009db:	00 00 00 
  8009de:	48 89 c7             	mov    %rax,%rdi
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e6:	49 b8 99 0c 80 00 00 	movabs $0x800c99,%r8
  8009ed:	00 00 00 
  8009f0:	41 ff d0             	callq  *%r8
			break;
  8009f3:	e9 92 02 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fb:	83 f8 30             	cmp    $0x30,%eax
  8009fe:	73 17                	jae    800a17 <vprintfmt+0x296>
  800a00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a07:	89 c0                	mov    %eax,%eax
  800a09:	48 01 d0             	add    %rdx,%rax
  800a0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0f:	83 c2 08             	add    $0x8,%edx
  800a12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a15:	eb 0f                	jmp    800a26 <vprintfmt+0x2a5>
  800a17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1b:	48 89 d0             	mov    %rdx,%rax
  800a1e:	48 83 c2 08          	add    $0x8,%rdx
  800a22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a26:	4c 8b 20             	mov    (%rax),%r12
  800a29:	4d 85 e4             	test   %r12,%r12
  800a2c:	75 0a                	jne    800a38 <vprintfmt+0x2b7>
				p = "(null)";
  800a2e:	49 bc ed 4c 80 00 00 	movabs $0x804ced,%r12
  800a35:	00 00 00 
			if (width > 0 && padc != '-')
  800a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3c:	7e 3f                	jle    800a7d <vprintfmt+0x2fc>
  800a3e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a42:	74 39                	je     800a7d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a44:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a47:	48 98                	cltq   
  800a49:	48 89 c6             	mov    %rax,%rsi
  800a4c:	4c 89 e7             	mov    %r12,%rdi
  800a4f:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  800a56:	00 00 00 
  800a59:	ff d0                	callq  *%rax
  800a5b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a5e:	eb 17                	jmp    800a77 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a60:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a64:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6c:	48 89 ce             	mov    %rcx,%rsi
  800a6f:	89 d7                	mov    %edx,%edi
  800a71:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7b:	7f e3                	jg     800a60 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7d:	eb 37                	jmp    800ab6 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a83:	74 1e                	je     800aa3 <vprintfmt+0x322>
  800a85:	83 fb 1f             	cmp    $0x1f,%ebx
  800a88:	7e 05                	jle    800a8f <vprintfmt+0x30e>
  800a8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8d:	7e 14                	jle    800aa3 <vprintfmt+0x322>
					putch('?', putdat);
  800a8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	48 89 d6             	mov    %rdx,%rsi
  800a9a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a9f:	ff d0                	callq  *%rax
  800aa1:	eb 0f                	jmp    800ab2 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aab:	48 89 d6             	mov    %rdx,%rsi
  800aae:	89 df                	mov    %ebx,%edi
  800ab0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab6:	4c 89 e0             	mov    %r12,%rax
  800ab9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800abd:	0f b6 00             	movzbl (%rax),%eax
  800ac0:	0f be d8             	movsbl %al,%ebx
  800ac3:	85 db                	test   %ebx,%ebx
  800ac5:	74 10                	je     800ad7 <vprintfmt+0x356>
  800ac7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acb:	78 b2                	js     800a7f <vprintfmt+0x2fe>
  800acd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad5:	79 a8                	jns    800a7f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad7:	eb 16                	jmp    800aef <vprintfmt+0x36e>
				putch(' ', putdat);
  800ad9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae1:	48 89 d6             	mov    %rdx,%rsi
  800ae4:	bf 20 00 00 00       	mov    $0x20,%edi
  800ae9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aeb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af3:	7f e4                	jg     800ad9 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af5:	e9 90 01 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800afa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afe:	be 03 00 00 00       	mov    $0x3,%esi
  800b03:	48 89 c7             	mov    %rax,%rdi
  800b06:	48 b8 71 06 80 00 00 	movabs $0x800671,%rax
  800b0d:	00 00 00 
  800b10:	ff d0                	callq  *%rax
  800b12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1a:	48 85 c0             	test   %rax,%rax
  800b1d:	79 1d                	jns    800b3c <vprintfmt+0x3bb>
				putch('-', putdat);
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b2f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	48 f7 d8             	neg    %rax
  800b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b3c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b43:	e9 d5 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4c:	be 03 00 00 00       	mov    $0x3,%esi
  800b51:	48 89 c7             	mov    %rax,%rdi
  800b54:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
  800b60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b64:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b6b:	e9 ad 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b70:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b77:	89 d6                	mov    %edx,%esi
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	48 b8 71 06 80 00 00 	movabs $0x800671,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	callq  *%rax
  800b88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b8c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b93:	e9 85 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	48 89 d6             	mov    %rdx,%rsi
  800ba3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800baa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb2:	48 89 d6             	mov    %rdx,%rsi
  800bb5:	bf 78 00 00 00       	mov    $0x78,%edi
  800bba:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbf:	83 f8 30             	cmp    $0x30,%eax
  800bc2:	73 17                	jae    800bdb <vprintfmt+0x45a>
  800bc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcb:	89 c0                	mov    %eax,%eax
  800bcd:	48 01 d0             	add    %rdx,%rax
  800bd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd3:	83 c2 08             	add    $0x8,%edx
  800bd6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd9:	eb 0f                	jmp    800bea <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bdb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdf:	48 89 d0             	mov    %rdx,%rax
  800be2:	48 83 c2 08          	add    $0x8,%rdx
  800be6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bea:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf8:	eb 23                	jmp    800c1d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfe:	be 03 00 00 00       	mov    $0x3,%esi
  800c03:	48 89 c7             	mov    %rax,%rdi
  800c06:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  800c0d:	00 00 00 
  800c10:	ff d0                	callq  *%rax
  800c12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c16:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c22:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c25:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c34:	45 89 c1             	mov    %r8d,%r9d
  800c37:	41 89 f8             	mov    %edi,%r8d
  800c3a:	48 89 c7             	mov    %rax,%rdi
  800c3d:	48 b8 a6 04 80 00 00 	movabs $0x8004a6,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
			break;
  800c49:	eb 3f                	jmp    800c8a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c53:	48 89 d6             	mov    %rdx,%rsi
  800c56:	89 df                	mov    %ebx,%edi
  800c58:	ff d0                	callq  *%rax
			break;
  800c5a:	eb 2e                	jmp    800c8a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 25 00 00 00       	mov    $0x25,%edi
  800c6c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c73:	eb 05                	jmp    800c7a <vprintfmt+0x4f9>
  800c75:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7e:	48 83 e8 01          	sub    $0x1,%rax
  800c82:	0f b6 00             	movzbl (%rax),%eax
  800c85:	3c 25                	cmp    $0x25,%al
  800c87:	75 ec                	jne    800c75 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c89:	90                   	nop
		}
	}
  800c8a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8b:	e9 43 fb ff ff       	jmpq   8007d3 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c90:	48 83 c4 60          	add    $0x60,%rsp
  800c94:	5b                   	pop    %rbx
  800c95:	41 5c                	pop    %r12
  800c97:	5d                   	pop    %rbp
  800c98:	c3                   	retq   

0000000000800c99 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c99:	55                   	push   %rbp
  800c9a:	48 89 e5             	mov    %rsp,%rbp
  800c9d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cab:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cb2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc7:	84 c0                	test   %al,%al
  800cc9:	74 20                	je     800ceb <printfmt+0x52>
  800ccb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ccf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cd3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cdb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cdf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ce3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ceb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cf2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf9:	00 00 00 
  800cfc:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d03:	00 00 00 
  800d06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d11:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d18:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d26:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d2d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d34:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d3b:	48 89 c7             	mov    %rax,%rdi
  800d3e:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d4a:	c9                   	leaveq 
  800d4b:	c3                   	retq   

0000000000800d4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4c:	55                   	push   %rbp
  800d4d:	48 89 e5             	mov    %rsp,%rbp
  800d50:	48 83 ec 10          	sub    $0x10,%rsp
  800d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5f:	8b 40 10             	mov    0x10(%rax),%eax
  800d62:	8d 50 01             	lea    0x1(%rax),%edx
  800d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d69:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d70:	48 8b 10             	mov    (%rax),%rdx
  800d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d77:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d7b:	48 39 c2             	cmp    %rax,%rdx
  800d7e:	73 17                	jae    800d97 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d84:	48 8b 00             	mov    (%rax),%rax
  800d87:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d8f:	48 89 0a             	mov    %rcx,(%rdx)
  800d92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d95:	88 10                	mov    %dl,(%rax)
}
  800d97:	c9                   	leaveq 
  800d98:	c3                   	retq   

0000000000800d99 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d99:	55                   	push   %rbp
  800d9a:	48 89 e5             	mov    %rsp,%rbp
  800d9d:	48 83 ec 50          	sub    $0x50,%rsp
  800da1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dac:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db8:	48 8b 0a             	mov    (%rdx),%rcx
  800dbb:	48 89 08             	mov    %rcx,(%rax)
  800dbe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dca:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd9:	48 98                	cltq   
  800ddb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ddf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de3:	48 01 d0             	add    %rdx,%rax
  800de6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800df1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df6:	74 06                	je     800dfe <vsnprintf+0x65>
  800df8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dfc:	7f 07                	jg     800e05 <vsnprintf+0x6c>
		return -E_INVAL;
  800dfe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e03:	eb 2f                	jmp    800e34 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e05:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e09:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e11:	48 89 c6             	mov    %rax,%rsi
  800e14:	48 bf 4c 0d 80 00 00 	movabs $0x800d4c,%rdi
  800e1b:	00 00 00 
  800e1e:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  800e25:	00 00 00 
  800e28:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e31:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e34:	c9                   	leaveq 
  800e35:	c3                   	retq   

0000000000800e36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e36:	55                   	push   %rbp
  800e37:	48 89 e5             	mov    %rsp,%rbp
  800e3a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e41:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e48:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e55:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e63:	84 c0                	test   %al,%al
  800e65:	74 20                	je     800e87 <snprintf+0x51>
  800e67:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e73:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e77:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e83:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e87:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e95:	00 00 00 
  800e98:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9f:	00 00 00 
  800ea2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ead:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ebb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ec2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec9:	48 8b 0a             	mov    (%rdx),%rcx
  800ecc:	48 89 08             	mov    %rcx,(%rax)
  800ecf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800edb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800edf:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eed:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ef3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800efa:	48 89 c7             	mov    %rax,%rdi
  800efd:	48 b8 99 0d 80 00 00 	movabs $0x800d99,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
  800f09:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 83 ec 18          	sub    $0x18,%rsp
  800f1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2a:	eb 09                	jmp    800f35 <strlen+0x1e>
		n++;
  800f2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f30:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	0f b6 00             	movzbl (%rax),%eax
  800f3c:	84 c0                	test   %al,%al
  800f3e:	75 ec                	jne    800f2c <strlen+0x15>
		n++;
	return n;
  800f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 20          	sub    $0x20,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f5c:	eb 0e                	jmp    800f6c <strnlen+0x27>
		n++;
  800f5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f62:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f67:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f71:	74 0b                	je     800f7e <strnlen+0x39>
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	84 c0                	test   %al,%al
  800f7c:	75 e0                	jne    800f5e <strnlen+0x19>
		n++;
	return n;
  800f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f81:	c9                   	leaveq 
  800f82:	c3                   	retq   

0000000000800f83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f83:	55                   	push   %rbp
  800f84:	48 89 e5             	mov    %rsp,%rbp
  800f87:	48 83 ec 20          	sub    $0x20,%rsp
  800f8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f9b:	90                   	nop
  800f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb4:	0f b6 12             	movzbl (%rdx),%edx
  800fb7:	88 10                	mov    %dl,(%rax)
  800fb9:	0f b6 00             	movzbl (%rax),%eax
  800fbc:	84 c0                	test   %al,%al
  800fbe:	75 dc                	jne    800f9c <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc4:	c9                   	leaveq 
  800fc5:	c3                   	retq   

0000000000800fc6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 83 ec 20          	sub    $0x20,%rsp
  800fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 89 c7             	mov    %rax,%rdi
  800fdd:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
  800fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fef:	48 63 d0             	movslq %eax,%rdx
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	48 01 c2             	add    %rax,%rdx
  800ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ffd:	48 89 c6             	mov    %rax,%rsi
  801000:	48 89 d7             	mov    %rdx,%rdi
  801003:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	callq  *%rax
	return dst;
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 28          	sub    $0x28,%rsp
  80101d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801025:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801031:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801038:	00 
  801039:	eb 2a                	jmp    801065 <strncpy+0x50>
		*dst++ = *src;
  80103b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801043:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801047:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104b:	0f b6 12             	movzbl (%rdx),%edx
  80104e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801050:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	84 c0                	test   %al,%al
  801059:	74 05                	je     801060 <strncpy+0x4b>
			src++;
  80105b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801060:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801069:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80106d:	72 cc                	jb     80103b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801073:	c9                   	leaveq 
  801074:	c3                   	retq   

0000000000801075 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	48 83 ec 28          	sub    $0x28,%rsp
  80107d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801081:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801085:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801091:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801096:	74 3d                	je     8010d5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801098:	eb 1d                	jmp    8010b7 <strlcpy+0x42>
			*dst++ = *src++;
  80109a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010aa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010ae:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b2:	0f b6 12             	movzbl (%rdx),%edx
  8010b5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010c1:	74 0b                	je     8010ce <strlcpy+0x59>
  8010c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	84 c0                	test   %al,%al
  8010cc:	75 cc                	jne    80109a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	48 29 c2             	sub    %rax,%rdx
  8010e0:	48 89 d0             	mov    %rdx,%rax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 10          	sub    $0x10,%rsp
  8010ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f5:	eb 0a                	jmp    801101 <strcmp+0x1c>
		p++, q++;
  8010f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801105:	0f b6 00             	movzbl (%rax),%eax
  801108:	84 c0                	test   %al,%al
  80110a:	74 12                	je     80111e <strcmp+0x39>
  80110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801110:	0f b6 10             	movzbl (%rax),%edx
  801113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801117:	0f b6 00             	movzbl (%rax),%eax
  80111a:	38 c2                	cmp    %al,%dl
  80111c:	74 d9                	je     8010f7 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112c:	0f b6 00             	movzbl (%rax),%eax
  80112f:	0f b6 c0             	movzbl %al,%eax
  801132:	29 c2                	sub    %eax,%edx
  801134:	89 d0                	mov    %edx,%eax
}
  801136:	c9                   	leaveq 
  801137:	c3                   	retq   

0000000000801138 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801138:	55                   	push   %rbp
  801139:	48 89 e5             	mov    %rsp,%rbp
  80113c:	48 83 ec 18          	sub    $0x18,%rsp
  801140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801148:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80114c:	eb 0f                	jmp    80115d <strncmp+0x25>
		n--, p++, q++;
  80114e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801153:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801158:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80115d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801162:	74 1d                	je     801181 <strncmp+0x49>
  801164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801168:	0f b6 00             	movzbl (%rax),%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	74 12                	je     801181 <strncmp+0x49>
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801173:	0f b6 10             	movzbl (%rax),%edx
  801176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	38 c2                	cmp    %al,%dl
  80117f:	74 cd                	je     80114e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801181:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801186:	75 07                	jne    80118f <strncmp+0x57>
		return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
  80118d:	eb 18                	jmp    8011a7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	0f b6 d0             	movzbl %al,%edx
  801199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119d:	0f b6 00             	movzbl (%rax),%eax
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 83 ec 0c          	sub    $0xc,%rsp
  8011b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b5:	89 f0                	mov    %esi,%eax
  8011b7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011ba:	eb 17                	jmp    8011d3 <strchr+0x2a>
		if (*s == c)
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c6:	75 06                	jne    8011ce <strchr+0x25>
			return (char *) s;
  8011c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cc:	eb 15                	jmp    8011e3 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	84 c0                	test   %al,%al
  8011dc:	75 de                	jne    8011bc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e3:	c9                   	leaveq 
  8011e4:	c3                   	retq   

00000000008011e5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f1:	89 f0                	mov    %esi,%eax
  8011f3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f6:	eb 13                	jmp    80120b <strfind+0x26>
		if (*s == c)
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801202:	75 02                	jne    801206 <strfind+0x21>
			break;
  801204:	eb 10                	jmp    801216 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801206:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 00             	movzbl (%rax),%eax
  801212:	84 c0                	test   %al,%al
  801214:	75 e2                	jne    8011f8 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 18          	sub    $0x18,%rsp
  801224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801228:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80122b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801234:	75 06                	jne    80123c <memset+0x20>
		return v;
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123a:	eb 69                	jmp    8012a5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801240:	83 e0 03             	and    $0x3,%eax
  801243:	48 85 c0             	test   %rax,%rax
  801246:	75 48                	jne    801290 <memset+0x74>
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	83 e0 03             	and    $0x3,%eax
  80124f:	48 85 c0             	test   %rax,%rax
  801252:	75 3c                	jne    801290 <memset+0x74>
		c &= 0xFF;
  801254:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80125b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125e:	c1 e0 18             	shl    $0x18,%eax
  801261:	89 c2                	mov    %eax,%edx
  801263:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801266:	c1 e0 10             	shl    $0x10,%eax
  801269:	09 c2                	or     %eax,%edx
  80126b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126e:	c1 e0 08             	shl    $0x8,%eax
  801271:	09 d0                	or     %edx,%eax
  801273:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127a:	48 c1 e8 02          	shr    $0x2,%rax
  80127e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801281:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801285:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801288:	48 89 d7             	mov    %rdx,%rdi
  80128b:	fc                   	cld    
  80128c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128e:	eb 11                	jmp    8012a1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801290:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801294:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801297:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80129b:	48 89 d7             	mov    %rdx,%rdi
  80129e:	fc                   	cld    
  80129f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a5:	c9                   	leaveq 
  8012a6:	c3                   	retq   

00000000008012a7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	48 83 ec 28          	sub    $0x28,%rsp
  8012af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012d3:	0f 83 88 00 00 00    	jae    801361 <memmove+0xba>
  8012d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e1:	48 01 d0             	add    %rdx,%rax
  8012e4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e8:	76 77                	jbe    801361 <memmove+0xba>
		s += n;
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f6:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 3b                	jne    801341 <memmove+0x9a>
  801306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130a:	83 e0 03             	and    $0x3,%eax
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	75 2f                	jne    801341 <memmove+0x9a>
  801312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801316:	83 e0 03             	and    $0x3,%eax
  801319:	48 85 c0             	test   %rax,%rax
  80131c:	75 23                	jne    801341 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	48 83 e8 04          	sub    $0x4,%rax
  801326:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132a:	48 83 ea 04          	sub    $0x4,%rdx
  80132e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801332:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801336:	48 89 c7             	mov    %rax,%rdi
  801339:	48 89 d6             	mov    %rdx,%rsi
  80133c:	fd                   	std    
  80133d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133f:	eb 1d                	jmp    80135e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801345:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801355:	48 89 d7             	mov    %rdx,%rdi
  801358:	48 89 c1             	mov    %rax,%rcx
  80135b:	fd                   	std    
  80135c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135e:	fc                   	cld    
  80135f:	eb 57                	jmp    8013b8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	83 e0 03             	and    $0x3,%eax
  801368:	48 85 c0             	test   %rax,%rax
  80136b:	75 36                	jne    8013a3 <memmove+0xfc>
  80136d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801371:	83 e0 03             	and    $0x3,%eax
  801374:	48 85 c0             	test   %rax,%rax
  801377:	75 2a                	jne    8013a3 <memmove+0xfc>
  801379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137d:	83 e0 03             	and    $0x3,%eax
  801380:	48 85 c0             	test   %rax,%rax
  801383:	75 1e                	jne    8013a3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 c1 e8 02          	shr    $0x2,%rax
  80138d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801394:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801398:	48 89 c7             	mov    %rax,%rdi
  80139b:	48 89 d6             	mov    %rdx,%rsi
  80139e:	fc                   	cld    
  80139f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013a1:	eb 15                	jmp    8013b8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ab:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013af:	48 89 c7             	mov    %rax,%rdi
  8013b2:	48 89 d6             	mov    %rdx,%rsi
  8013b5:	fc                   	cld    
  8013b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013bc:	c9                   	leaveq 
  8013bd:	c3                   	retq   

00000000008013be <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013be:	55                   	push   %rbp
  8013bf:	48 89 e5             	mov    %rsp,%rbp
  8013c2:	48 83 ec 18          	sub    $0x18,%rsp
  8013c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	48 89 ce             	mov    %rcx,%rsi
  8013e1:	48 89 c7             	mov    %rax,%rdi
  8013e4:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8013eb:	00 00 00 
  8013ee:	ff d0                	callq  *%rax
}
  8013f0:	c9                   	leaveq 
  8013f1:	c3                   	retq   

00000000008013f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013f2:	55                   	push   %rbp
  8013f3:	48 89 e5             	mov    %rsp,%rbp
  8013f6:	48 83 ec 28          	sub    $0x28,%rsp
  8013fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801402:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801412:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801416:	eb 36                	jmp    80144e <memcmp+0x5c>
		if (*s1 != *s2)
  801418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141c:	0f b6 10             	movzbl (%rax),%edx
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	38 c2                	cmp    %al,%dl
  801428:	74 1a                	je     801444 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 d0             	movzbl %al,%edx
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	0f b6 c0             	movzbl %al,%eax
  80143e:	29 c2                	sub    %eax,%edx
  801440:	89 d0                	mov    %edx,%eax
  801442:	eb 20                	jmp    801464 <memcmp+0x72>
		s1++, s2++;
  801444:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801449:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801456:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80145a:	48 85 c0             	test   %rax,%rax
  80145d:	75 b9                	jne    801418 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leaveq 
  801465:	c3                   	retq   

0000000000801466 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 83 ec 28          	sub    $0x28,%rsp
  80146e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801472:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801475:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801481:	48 01 d0             	add    %rdx,%rax
  801484:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801488:	eb 15                	jmp    80149f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	0f b6 10             	movzbl (%rax),%edx
  801491:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801494:	38 c2                	cmp    %al,%dl
  801496:	75 02                	jne    80149a <memfind+0x34>
			break;
  801498:	eb 0f                	jmp    8014a9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80149a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a7:	72 e1                	jb     80148a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ad:	c9                   	leaveq 
  8014ae:	c3                   	retq   

00000000008014af <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014af:	55                   	push   %rbp
  8014b0:	48 89 e5             	mov    %rsp,%rbp
  8014b3:	48 83 ec 34          	sub    $0x34,%rsp
  8014b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014bf:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d1:	eb 05                	jmp    8014d8 <strtol+0x29>
		s++;
  8014d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	3c 20                	cmp    $0x20,%al
  8014e1:	74 f0                	je     8014d3 <strtol+0x24>
  8014e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	3c 09                	cmp    $0x9,%al
  8014ec:	74 e5                	je     8014d3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	3c 2b                	cmp    $0x2b,%al
  8014f7:	75 07                	jne    801500 <strtol+0x51>
		s++;
  8014f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014fe:	eb 17                	jmp    801517 <strtol+0x68>
	else if (*s == '-')
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	3c 2d                	cmp    $0x2d,%al
  801509:	75 0c                	jne    801517 <strtol+0x68>
		s++, neg = 1;
  80150b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801510:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801517:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80151b:	74 06                	je     801523 <strtol+0x74>
  80151d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801521:	75 28                	jne    80154b <strtol+0x9c>
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	3c 30                	cmp    $0x30,%al
  80152c:	75 1d                	jne    80154b <strtol+0x9c>
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 83 c0 01          	add    $0x1,%rax
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	3c 78                	cmp    $0x78,%al
  80153b:	75 0e                	jne    80154b <strtol+0x9c>
		s += 2, base = 16;
  80153d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801542:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801549:	eb 2c                	jmp    801577 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80154b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154f:	75 19                	jne    80156a <strtol+0xbb>
  801551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	3c 30                	cmp    $0x30,%al
  80155a:	75 0e                	jne    80156a <strtol+0xbb>
		s++, base = 8;
  80155c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801561:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801568:	eb 0d                	jmp    801577 <strtol+0xc8>
	else if (base == 0)
  80156a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80156e:	75 07                	jne    801577 <strtol+0xc8>
		base = 10;
  801570:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	3c 2f                	cmp    $0x2f,%al
  801580:	7e 1d                	jle    80159f <strtol+0xf0>
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	3c 39                	cmp    $0x39,%al
  80158b:	7f 12                	jg     80159f <strtol+0xf0>
			dig = *s - '0';
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	0f b6 00             	movzbl (%rax),%eax
  801594:	0f be c0             	movsbl %al,%eax
  801597:	83 e8 30             	sub    $0x30,%eax
  80159a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80159d:	eb 4e                	jmp    8015ed <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 60                	cmp    $0x60,%al
  8015a8:	7e 1d                	jle    8015c7 <strtol+0x118>
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	3c 7a                	cmp    $0x7a,%al
  8015b3:	7f 12                	jg     8015c7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	0f b6 00             	movzbl (%rax),%eax
  8015bc:	0f be c0             	movsbl %al,%eax
  8015bf:	83 e8 57             	sub    $0x57,%eax
  8015c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c5:	eb 26                	jmp    8015ed <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3c 40                	cmp    $0x40,%al
  8015d0:	7e 48                	jle    80161a <strtol+0x16b>
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	3c 5a                	cmp    $0x5a,%al
  8015db:	7f 3d                	jg     80161a <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	0f be c0             	movsbl %al,%eax
  8015e7:	83 e8 37             	sub    $0x37,%eax
  8015ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f0:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015f3:	7c 02                	jl     8015f7 <strtol+0x148>
			break;
  8015f5:	eb 23                	jmp    80161a <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015ff:	48 98                	cltq   
  801601:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801606:	48 89 c2             	mov    %rax,%rdx
  801609:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80160c:	48 98                	cltq   
  80160e:	48 01 d0             	add    %rdx,%rax
  801611:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801615:	e9 5d ff ff ff       	jmpq   801577 <strtol+0xc8>

	if (endptr)
  80161a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80161f:	74 0b                	je     80162c <strtol+0x17d>
		*endptr = (char *) s;
  801621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801625:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801629:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80162c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801630:	74 09                	je     80163b <strtol+0x18c>
  801632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801636:	48 f7 d8             	neg    %rax
  801639:	eb 04                	jmp    80163f <strtol+0x190>
  80163b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <strstr>:

char * strstr(const char *in, const char *str)
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	48 83 ec 30          	sub    $0x30,%rsp
  801649:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801651:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801655:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801659:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801663:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801667:	75 06                	jne    80166f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	eb 6b                	jmp    8016da <strstr+0x99>

	len = strlen(str);
  80166f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801673:	48 89 c7             	mov    %rax,%rdi
  801676:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80167d:	00 00 00 
  801680:	ff d0                	callq  *%rax
  801682:	48 98                	cltq   
  801684:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801690:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80169a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80169e:	75 07                	jne    8016a7 <strstr+0x66>
				return (char *) 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 33                	jmp    8016da <strstr+0x99>
		} while (sc != c);
  8016a7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016ab:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016ae:	75 d8                	jne    801688 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	48 89 ce             	mov    %rcx,%rsi
  8016bf:	48 89 c7             	mov    %rax,%rdi
  8016c2:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  8016c9:	00 00 00 
  8016cc:	ff d0                	callq  *%rax
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	75 b6                	jne    801688 <strstr+0x47>

	return (char *) (in - 1);
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 83 e8 01          	sub    $0x1,%rax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	53                   	push   %rbx
  8016e1:	48 83 ec 48          	sub    $0x48,%rsp
  8016e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016eb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016ef:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016f3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016fe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801702:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801706:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80170a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801712:	4c 89 c3             	mov    %r8,%rbx
  801715:	cd 30                	int    $0x30
  801717:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80171b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80171f:	74 3e                	je     80175f <syscall+0x83>
  801721:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801726:	7e 37                	jle    80175f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172f:	49 89 d0             	mov    %rdx,%r8
  801732:	89 c1                	mov    %eax,%ecx
  801734:	48 ba a8 4f 80 00 00 	movabs $0x804fa8,%rdx
  80173b:	00 00 00 
  80173e:	be 23 00 00 00       	mov    $0x23,%esi
  801743:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80174a:	00 00 00 
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	49 b9 95 01 80 00 00 	movabs $0x800195,%r9
  801759:	00 00 00 
  80175c:	41 ff d1             	callq  *%r9

	return ret;
  80175f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801763:	48 83 c4 48          	add    $0x48,%rsp
  801767:	5b                   	pop    %rbx
  801768:	5d                   	pop    %rbp
  801769:	c3                   	retq   

000000000080176a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80176a:	55                   	push   %rbp
  80176b:	48 89 e5             	mov    %rsp,%rbp
  80176e:	48 83 ec 20          	sub    $0x20,%rsp
  801772:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801776:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80177a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801782:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801789:	00 
  80178a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801790:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801796:	48 89 d1             	mov    %rdx,%rcx
  801799:	48 89 c2             	mov    %rax,%rdx
  80179c:	be 00 00 00 00       	mov    $0x0,%esi
  8017a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a6:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c3:	00 
  8017c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8017eb:	00 00 00 
  8017ee:	ff d0                	callq  *%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 10          	sub    $0x10,%rsp
  8017fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801800:	48 98                	cltq   
  801802:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801809:	00 
  80180a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801810:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801816:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181b:	48 89 c2             	mov    %rax,%rdx
  80181e:	be 01 00 00 00       	mov    $0x1,%esi
  801823:	bf 03 00 00 00       	mov    $0x3,%edi
  801828:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80183e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801845:	00 
  801846:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801852:	b9 00 00 00 00       	mov    $0x0,%ecx
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	bf 02 00 00 00       	mov    $0x2,%edi
  801866:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
}
  801872:	c9                   	leaveq 
  801873:	c3                   	retq   

0000000000801874 <sys_yield>:

void
sys_yield(void)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80187c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801883:	00 
  801884:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801890:	b9 00 00 00 00       	mov    $0x0,%ecx
  801895:	ba 00 00 00 00       	mov    $0x0,%edx
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 20          	sub    $0x20,%rsp
  8018ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c7:	48 63 c8             	movslq %eax,%rcx
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d1:	48 98                	cltq   
  8018d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018da:	00 
  8018db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e1:	49 89 c8             	mov    %rcx,%r8
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 01 00 00 00       	mov    $0x1,%esi
  8018ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
}
  801900:	c9                   	leaveq 
  801901:	c3                   	retq   

0000000000801902 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801902:	55                   	push   %rbp
  801903:	48 89 e5             	mov    %rsp,%rbp
  801906:	48 83 ec 30          	sub    $0x30,%rsp
  80190a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801911:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801914:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801918:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80191c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191f:	48 63 c8             	movslq %eax,%rcx
  801922:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801926:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801929:	48 63 f0             	movslq %eax,%rsi
  80192c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801933:	48 98                	cltq   
  801935:	48 89 0c 24          	mov    %rcx,(%rsp)
  801939:	49 89 f9             	mov    %rdi,%r9
  80193c:	49 89 f0             	mov    %rsi,%r8
  80193f:	48 89 d1             	mov    %rdx,%rcx
  801942:	48 89 c2             	mov    %rax,%rdx
  801945:	be 01 00 00 00       	mov    $0x1,%esi
  80194a:	bf 05 00 00 00       	mov    $0x5,%edi
  80194f:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 20          	sub    $0x20,%rsp
  801965:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801968:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80196c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801973:	48 98                	cltq   
  801975:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197c:	00 
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	48 89 d1             	mov    %rdx,%rcx
  80198c:	48 89 c2             	mov    %rax,%rdx
  80198f:	be 01 00 00 00       	mov    $0x1,%esi
  801994:	bf 06 00 00 00       	mov    $0x6,%edi
  801999:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8019a0:	00 00 00 
  8019a3:	ff d0                	callq  *%rax
}
  8019a5:	c9                   	leaveq 
  8019a6:	c3                   	retq   

00000000008019a7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a7:	55                   	push   %rbp
  8019a8:	48 89 e5             	mov    %rsp,%rbp
  8019ab:	48 83 ec 10          	sub    $0x10,%rsp
  8019af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b8:	48 63 d0             	movslq %eax,%rdx
  8019bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019be:	48 98                	cltq   
  8019c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c7:	00 
  8019c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d4:	48 89 d1             	mov    %rdx,%rcx
  8019d7:	48 89 c2             	mov    %rax,%rdx
  8019da:	be 01 00 00 00       	mov    $0x1,%esi
  8019df:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	callq  *%rax
}
  8019f0:	c9                   	leaveq 
  8019f1:	c3                   	retq   

00000000008019f2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
  8019f6:	48 83 ec 20          	sub    $0x20,%rsp
  8019fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a08:	48 98                	cltq   
  801a0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a11:	00 
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 09 00 00 00       	mov    $0x9,%edi
  801a2e:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 20          	sub    $0x20,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5b:	00 
  801a5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a68:	48 89 d1             	mov    %rdx,%rcx
  801a6b:	48 89 c2             	mov    %rax,%rdx
  801a6e:	be 01 00 00 00       	mov    $0x1,%esi
  801a73:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a78:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
}
  801a84:	c9                   	leaveq 
  801a85:	c3                   	retq   

0000000000801a86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	48 83 ec 20          	sub    $0x20,%rsp
  801a8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a99:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9f:	48 63 f0             	movslq %eax,%rsi
  801aa2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab6:	00 
  801ab7:	49 89 f1             	mov    %rsi,%r9
  801aba:	49 89 c8             	mov    %rcx,%r8
  801abd:	48 89 d1             	mov    %rdx,%rcx
  801ac0:	48 89 c2             	mov    %rax,%rdx
  801ac3:	be 00 00 00 00       	mov    $0x0,%esi
  801ac8:	bf 0c 00 00 00       	mov    $0xc,%edi
  801acd:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	callq  *%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 10          	sub    $0x10,%rsp
  801ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af2:	00 
  801af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b04:	48 89 c2             	mov    %rax,%rdx
  801b07:	be 01 00 00 00       	mov    $0x1,%esi
  801b0c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b11:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 20          	sub    $0x20,%rsp
  801b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3e:	00 
  801b3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4b:	48 89 d1             	mov    %rdx,%rcx
  801b4e:	48 89 c2             	mov    %rax,%rdx
  801b51:	be 01 00 00 00       	mov    $0x1,%esi
  801b56:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b5b:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	callq  *%rax
}
  801b67:	c9                   	leaveq 
  801b68:	c3                   	retq   

0000000000801b69 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	48 83 ec 10          	sub    $0x10,%rsp
  801b71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801b75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b92:	48 89 c2             	mov    %rax,%rdx
  801b95:	be 00 00 00 00       	mov    $0x0,%esi
  801b9a:	bf 10 00 00 00       	mov    $0x10,%edi
  801b9f:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbc:	00 
  801bbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bce:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd3:	be 00 00 00 00       	mov    $0x0,%esi
  801bd8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bdd:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
}
  801be9:	c9                   	leaveq 
  801bea:	c3                   	retq   

0000000000801beb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801beb:	55                   	push   %rbp
  801bec:	48 89 e5             	mov    %rsp,%rbp
  801bef:	48 83 ec 08          	sub    $0x8,%rsp
  801bf3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bf7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bfb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c02:	ff ff ff 
  801c05:	48 01 d0             	add    %rdx,%rax
  801c08:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c0c:	c9                   	leaveq 
  801c0d:	c3                   	retq   

0000000000801c0e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c0e:	55                   	push   %rbp
  801c0f:	48 89 e5             	mov    %rsp,%rbp
  801c12:	48 83 ec 08          	sub    $0x8,%rsp
  801c16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1e:	48 89 c7             	mov    %rax,%rdi
  801c21:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
  801c2d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c33:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c37:	c9                   	leaveq 
  801c38:	c3                   	retq   

0000000000801c39 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c39:	55                   	push   %rbp
  801c3a:	48 89 e5             	mov    %rsp,%rbp
  801c3d:	48 83 ec 18          	sub    $0x18,%rsp
  801c41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c4c:	eb 6b                	jmp    801cb9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c51:	48 98                	cltq   
  801c53:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c59:	48 c1 e0 0c          	shl    $0xc,%rax
  801c5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c65:	48 c1 e8 15          	shr    $0x15,%rax
  801c69:	48 89 c2             	mov    %rax,%rdx
  801c6c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c73:	01 00 00 
  801c76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c7a:	83 e0 01             	and    $0x1,%eax
  801c7d:	48 85 c0             	test   %rax,%rax
  801c80:	74 21                	je     801ca3 <fd_alloc+0x6a>
  801c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c86:	48 c1 e8 0c          	shr    $0xc,%rax
  801c8a:	48 89 c2             	mov    %rax,%rdx
  801c8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c94:	01 00 00 
  801c97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c9b:	83 e0 01             	and    $0x1,%eax
  801c9e:	48 85 c0             	test   %rax,%rax
  801ca1:	75 12                	jne    801cb5 <fd_alloc+0x7c>
			*fd_store = fd;
  801ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cab:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	eb 1a                	jmp    801ccf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cb5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cb9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cbd:	7e 8f                	jle    801c4e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cca:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ccf:	c9                   	leaveq 
  801cd0:	c3                   	retq   

0000000000801cd1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 83 ec 20          	sub    $0x20,%rsp
  801cd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cdc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ce0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ce4:	78 06                	js     801cec <fd_lookup+0x1b>
  801ce6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801cea:	7e 07                	jle    801cf3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cf1:	eb 6c                	jmp    801d5f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801cf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cf6:	48 98                	cltq   
  801cf8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cfe:	48 c1 e0 0c          	shl    $0xc,%rax
  801d02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0a:	48 c1 e8 15          	shr    $0x15,%rax
  801d0e:	48 89 c2             	mov    %rax,%rdx
  801d11:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d18:	01 00 00 
  801d1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d1f:	83 e0 01             	and    $0x1,%eax
  801d22:	48 85 c0             	test   %rax,%rax
  801d25:	74 21                	je     801d48 <fd_lookup+0x77>
  801d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2b:	48 c1 e8 0c          	shr    $0xc,%rax
  801d2f:	48 89 c2             	mov    %rax,%rdx
  801d32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d39:	01 00 00 
  801d3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d40:	83 e0 01             	and    $0x1,%eax
  801d43:	48 85 c0             	test   %rax,%rax
  801d46:	75 07                	jne    801d4f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d4d:	eb 10                	jmp    801d5f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d53:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d57:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	c9                   	leaveq 
  801d60:	c3                   	retq   

0000000000801d61 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d61:	55                   	push   %rbp
  801d62:	48 89 e5             	mov    %rsp,%rbp
  801d65:	48 83 ec 30          	sub    $0x30,%rsp
  801d69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d6d:	89 f0                	mov    %esi,%eax
  801d6f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d76:	48 89 c7             	mov    %rax,%rdi
  801d79:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  801d80:	00 00 00 
  801d83:	ff d0                	callq  *%rax
  801d85:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d89:	48 89 d6             	mov    %rdx,%rsi
  801d8c:	89 c7                	mov    %eax,%edi
  801d8e:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
  801d9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801da1:	78 0a                	js     801dad <fd_close+0x4c>
	    || fd != fd2)
  801da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da7:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dab:	74 12                	je     801dbf <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dad:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801db1:	74 05                	je     801db8 <fd_close+0x57>
  801db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db6:	eb 05                	jmp    801dbd <fd_close+0x5c>
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbd:	eb 69                	jmp    801e28 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc3:	8b 00                	mov    (%rax),%eax
  801dc5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dc9:	48 89 d6             	mov    %rdx,%rsi
  801dcc:	89 c7                	mov    %eax,%edi
  801dce:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	callq  *%rax
  801dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de1:	78 2a                	js     801e0d <fd_close+0xac>
		if (dev->dev_close)
  801de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801deb:	48 85 c0             	test   %rax,%rax
  801dee:	74 16                	je     801e06 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801df0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801df8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dfc:	48 89 d7             	mov    %rdx,%rdi
  801dff:	ff d0                	callq  *%rax
  801e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e04:	eb 07                	jmp    801e0d <fd_close+0xac>
		else
			r = 0;
  801e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e11:	48 89 c6             	mov    %rax,%rsi
  801e14:	bf 00 00 00 00       	mov    $0x0,%edi
  801e19:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
	return r;
  801e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e28:	c9                   	leaveq 
  801e29:	c3                   	retq   

0000000000801e2a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e2a:	55                   	push   %rbp
  801e2b:	48 89 e5             	mov    %rsp,%rbp
  801e2e:	48 83 ec 20          	sub    $0x20,%rsp
  801e32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e40:	eb 41                	jmp    801e83 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e42:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e49:	00 00 00 
  801e4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e4f:	48 63 d2             	movslq %edx,%rdx
  801e52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e56:	8b 00                	mov    (%rax),%eax
  801e58:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e5b:	75 22                	jne    801e7f <dev_lookup+0x55>
			*dev = devtab[i];
  801e5d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e64:	00 00 00 
  801e67:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e6a:	48 63 d2             	movslq %edx,%rdx
  801e6d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e75:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	eb 60                	jmp    801edf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e7f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e83:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e8a:	00 00 00 
  801e8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e90:	48 63 d2             	movslq %edx,%rdx
  801e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e97:	48 85 c0             	test   %rax,%rax
  801e9a:	75 a6                	jne    801e42 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e9c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801ea3:	00 00 00 
  801ea6:	48 8b 00             	mov    (%rax),%rax
  801ea9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801eaf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eb2:	89 c6                	mov    %eax,%esi
  801eb4:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  801ebb:	00 00 00 
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  801eca:	00 00 00 
  801ecd:	ff d1                	callq  *%rcx
	*dev = 0;
  801ecf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801eda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801edf:	c9                   	leaveq 
  801ee0:	c3                   	retq   

0000000000801ee1 <close>:

int
close(int fdnum)
{
  801ee1:	55                   	push   %rbp
  801ee2:	48 89 e5             	mov    %rsp,%rbp
  801ee5:	48 83 ec 20          	sub    $0x20,%rsp
  801ee9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ef0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ef3:	48 89 d6             	mov    %rdx,%rsi
  801ef6:	89 c7                	mov    %eax,%edi
  801ef8:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  801eff:	00 00 00 
  801f02:	ff d0                	callq  *%rax
  801f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f0b:	79 05                	jns    801f12 <close+0x31>
		return r;
  801f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f10:	eb 18                	jmp    801f2a <close+0x49>
	else
		return fd_close(fd, 1);
  801f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f16:	be 01 00 00 00       	mov    $0x1,%esi
  801f1b:	48 89 c7             	mov    %rax,%rdi
  801f1e:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
}
  801f2a:	c9                   	leaveq 
  801f2b:	c3                   	retq   

0000000000801f2c <close_all>:

void
close_all(void)
{
  801f2c:	55                   	push   %rbp
  801f2d:	48 89 e5             	mov    %rsp,%rbp
  801f30:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f3b:	eb 15                	jmp    801f52 <close_all+0x26>
		close(i);
  801f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f40:	89 c7                	mov    %eax,%edi
  801f42:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  801f49:	00 00 00 
  801f4c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f4e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f52:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f56:	7e e5                	jle    801f3d <close_all+0x11>
		close(i);
}
  801f58:	c9                   	leaveq 
  801f59:	c3                   	retq   

0000000000801f5a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f5a:	55                   	push   %rbp
  801f5b:	48 89 e5             	mov    %rsp,%rbp
  801f5e:	48 83 ec 40          	sub    $0x40,%rsp
  801f62:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f65:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f68:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f6c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f6f:	48 89 d6             	mov    %rdx,%rsi
  801f72:	89 c7                	mov    %eax,%edi
  801f74:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  801f7b:	00 00 00 
  801f7e:	ff d0                	callq  *%rax
  801f80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f87:	79 08                	jns    801f91 <dup+0x37>
		return r;
  801f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8c:	e9 70 01 00 00       	jmpq   802101 <dup+0x1a7>
	close(newfdnum);
  801f91:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f94:	89 c7                	mov    %eax,%edi
  801f96:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fa2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fa5:	48 98                	cltq   
  801fa7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fad:	48 c1 e0 0c          	shl    $0xc,%rax
  801fb1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb9:	48 89 c7             	mov    %rax,%rdi
  801fbc:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd0:	48 89 c7             	mov    %rax,%rdi
  801fd3:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  801fda:	00 00 00 
  801fdd:	ff d0                	callq  *%rax
  801fdf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe7:	48 c1 e8 15          	shr    $0x15,%rax
  801feb:	48 89 c2             	mov    %rax,%rdx
  801fee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ff5:	01 00 00 
  801ff8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffc:	83 e0 01             	and    $0x1,%eax
  801fff:	48 85 c0             	test   %rax,%rax
  802002:	74 73                	je     802077 <dup+0x11d>
  802004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802008:	48 c1 e8 0c          	shr    $0xc,%rax
  80200c:	48 89 c2             	mov    %rax,%rdx
  80200f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802016:	01 00 00 
  802019:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201d:	83 e0 01             	and    $0x1,%eax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	74 52                	je     802077 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802029:	48 c1 e8 0c          	shr    $0xc,%rax
  80202d:	48 89 c2             	mov    %rax,%rdx
  802030:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802037:	01 00 00 
  80203a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203e:	25 07 0e 00 00       	and    $0xe07,%eax
  802043:	89 c1                	mov    %eax,%ecx
  802045:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802049:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204d:	41 89 c8             	mov    %ecx,%r8d
  802050:	48 89 d1             	mov    %rdx,%rcx
  802053:	ba 00 00 00 00       	mov    $0x0,%edx
  802058:	48 89 c6             	mov    %rax,%rsi
  80205b:	bf 00 00 00 00       	mov    $0x0,%edi
  802060:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802073:	79 02                	jns    802077 <dup+0x11d>
			goto err;
  802075:	eb 57                	jmp    8020ce <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802077:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207b:	48 c1 e8 0c          	shr    $0xc,%rax
  80207f:	48 89 c2             	mov    %rax,%rdx
  802082:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802089:	01 00 00 
  80208c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802090:	25 07 0e 00 00       	and    $0xe07,%eax
  802095:	89 c1                	mov    %eax,%ecx
  802097:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80209f:	41 89 c8             	mov    %ecx,%r8d
  8020a2:	48 89 d1             	mov    %rdx,%rcx
  8020a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020aa:	48 89 c6             	mov    %rax,%rsi
  8020ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b2:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	callq  *%rax
  8020be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c5:	79 02                	jns    8020c9 <dup+0x16f>
		goto err;
  8020c7:	eb 05                	jmp    8020ce <dup+0x174>

	return newfdnum;
  8020c9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020cc:	eb 33                	jmp    802101 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8020ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d2:	48 89 c6             	mov    %rax,%rsi
  8020d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020da:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8020e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ea:	48 89 c6             	mov    %rax,%rsi
  8020ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f2:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
	return r;
  8020fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 40          	sub    $0x40,%rsp
  80210b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80210e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802112:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802116:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80211a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80211d:	48 89 d6             	mov    %rdx,%rsi
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
  80212e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802135:	78 24                	js     80215b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213b:	8b 00                	mov    (%rax),%eax
  80213d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802141:	48 89 d6             	mov    %rdx,%rsi
  802144:	89 c7                	mov    %eax,%edi
  802146:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  80214d:	00 00 00 
  802150:	ff d0                	callq  *%rax
  802152:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802155:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802159:	79 05                	jns    802160 <read+0x5d>
		return r;
  80215b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215e:	eb 76                	jmp    8021d6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	8b 40 08             	mov    0x8(%rax),%eax
  802167:	83 e0 03             	and    $0x3,%eax
  80216a:	83 f8 01             	cmp    $0x1,%eax
  80216d:	75 3a                	jne    8021a9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80216f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802176:	00 00 00 
  802179:	48 8b 00             	mov    (%rax),%rax
  80217c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802182:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802185:	89 c6                	mov    %eax,%esi
  802187:	48 bf f7 4f 80 00 00 	movabs $0x804ff7,%rdi
  80218e:	00 00 00 
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  80219d:	00 00 00 
  8021a0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021a7:	eb 2d                	jmp    8021d6 <read+0xd3>
	}
	if (!dev->dev_read)
  8021a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ad:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021b1:	48 85 c0             	test   %rax,%rax
  8021b4:	75 07                	jne    8021bd <read+0xba>
		return -E_NOT_SUPP;
  8021b6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021bb:	eb 19                	jmp    8021d6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021c5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021cd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021d1:	48 89 cf             	mov    %rcx,%rdi
  8021d4:	ff d0                	callq  *%rax
}
  8021d6:	c9                   	leaveq 
  8021d7:	c3                   	retq   

00000000008021d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021d8:	55                   	push   %rbp
  8021d9:	48 89 e5             	mov    %rsp,%rbp
  8021dc:	48 83 ec 30          	sub    $0x30,%rsp
  8021e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f2:	eb 49                	jmp    80223d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f7:	48 98                	cltq   
  8021f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021fd:	48 29 c2             	sub    %rax,%rdx
  802200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802203:	48 63 c8             	movslq %eax,%rcx
  802206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220a:	48 01 c1             	add    %rax,%rcx
  80220d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802210:	48 89 ce             	mov    %rcx,%rsi
  802213:	89 c7                	mov    %eax,%edi
  802215:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	callq  *%rax
  802221:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802224:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802228:	79 05                	jns    80222f <readn+0x57>
			return m;
  80222a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80222d:	eb 1c                	jmp    80224b <readn+0x73>
		if (m == 0)
  80222f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802233:	75 02                	jne    802237 <readn+0x5f>
			break;
  802235:	eb 11                	jmp    802248 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802237:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80223a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80223d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802240:	48 98                	cltq   
  802242:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802246:	72 ac                	jb     8021f4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802248:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80224b:	c9                   	leaveq 
  80224c:	c3                   	retq   

000000000080224d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80224d:	55                   	push   %rbp
  80224e:	48 89 e5             	mov    %rsp,%rbp
  802251:	48 83 ec 40          	sub    $0x40,%rsp
  802255:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802258:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80225c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802260:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802264:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802267:	48 89 d6             	mov    %rdx,%rsi
  80226a:	89 c7                	mov    %eax,%edi
  80226c:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  802273:	00 00 00 
  802276:	ff d0                	callq  *%rax
  802278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227f:	78 24                	js     8022a5 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802285:	8b 00                	mov    (%rax),%eax
  802287:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80228b:	48 89 d6             	mov    %rdx,%rsi
  80228e:	89 c7                	mov    %eax,%edi
  802290:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a3:	79 05                	jns    8022aa <write+0x5d>
		return r;
  8022a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a8:	eb 75                	jmp    80231f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ae:	8b 40 08             	mov    0x8(%rax),%eax
  8022b1:	83 e0 03             	and    $0x3,%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	75 3a                	jne    8022f2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022b8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022bf:	00 00 00 
  8022c2:	48 8b 00             	mov    (%rax),%rax
  8022c5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022cb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022ce:	89 c6                	mov    %eax,%esi
  8022d0:	48 bf 13 50 80 00 00 	movabs $0x805013,%rdi
  8022d7:	00 00 00 
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  8022e6:	00 00 00 
  8022e9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f0:	eb 2d                	jmp    80231f <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8022f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022fa:	48 85 c0             	test   %rax,%rax
  8022fd:	75 07                	jne    802306 <write+0xb9>
		return -E_NOT_SUPP;
  8022ff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802304:	eb 19                	jmp    80231f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80230e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802312:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802316:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80231a:	48 89 cf             	mov    %rcx,%rdi
  80231d:	ff d0                	callq  *%rax
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <seek>:

int
seek(int fdnum, off_t offset)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 83 ec 18          	sub    $0x18,%rsp
  802329:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80232c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802333:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802336:	48 89 d6             	mov    %rdx,%rsi
  802339:	89 c7                	mov    %eax,%edi
  80233b:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  802342:	00 00 00 
  802345:	ff d0                	callq  *%rax
  802347:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234e:	79 05                	jns    802355 <seek+0x34>
		return r;
  802350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802353:	eb 0f                	jmp    802364 <seek+0x43>
	fd->fd_offset = offset;
  802355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802359:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80235c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802364:	c9                   	leaveq 
  802365:	c3                   	retq   

0000000000802366 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802366:	55                   	push   %rbp
  802367:	48 89 e5             	mov    %rsp,%rbp
  80236a:	48 83 ec 30          	sub    $0x30,%rsp
  80236e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802371:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802374:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802378:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80237b:	48 89 d6             	mov    %rdx,%rsi
  80237e:	89 c7                	mov    %eax,%edi
  802380:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
  80238c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802393:	78 24                	js     8023b9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802399:	8b 00                	mov    (%rax),%eax
  80239b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80239f:	48 89 d6             	mov    %rdx,%rsi
  8023a2:	89 c7                	mov    %eax,%edi
  8023a4:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	callq  *%rax
  8023b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b7:	79 05                	jns    8023be <ftruncate+0x58>
		return r;
  8023b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bc:	eb 72                	jmp    802430 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c2:	8b 40 08             	mov    0x8(%rax),%eax
  8023c5:	83 e0 03             	and    $0x3,%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 3a                	jne    802406 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023cc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023d3:	00 00 00 
  8023d6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023d9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023df:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023e2:	89 c6                	mov    %eax,%esi
  8023e4:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  8023eb:	00 00 00 
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f3:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  8023fa:	00 00 00 
  8023fd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8023ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802404:	eb 2a                	jmp    802430 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80240e:	48 85 c0             	test   %rax,%rax
  802411:	75 07                	jne    80241a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802413:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802418:	eb 16                	jmp    802430 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80241a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802422:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802426:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802429:	89 ce                	mov    %ecx,%esi
  80242b:	48 89 d7             	mov    %rdx,%rdi
  80242e:	ff d0                	callq  *%rax
}
  802430:	c9                   	leaveq 
  802431:	c3                   	retq   

0000000000802432 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802432:	55                   	push   %rbp
  802433:	48 89 e5             	mov    %rsp,%rbp
  802436:	48 83 ec 30          	sub    $0x30,%rsp
  80243a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80243d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802441:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802445:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802448:	48 89 d6             	mov    %rdx,%rsi
  80244b:	89 c7                	mov    %eax,%edi
  80244d:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802460:	78 24                	js     802486 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802466:	8b 00                	mov    (%rax),%eax
  802468:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246c:	48 89 d6             	mov    %rdx,%rsi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802484:	79 05                	jns    80248b <fstat+0x59>
		return r;
  802486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802489:	eb 5e                	jmp    8024e9 <fstat+0xb7>
	if (!dev->dev_stat)
  80248b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802493:	48 85 c0             	test   %rax,%rax
  802496:	75 07                	jne    80249f <fstat+0x6d>
		return -E_NOT_SUPP;
  802498:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80249d:	eb 4a                	jmp    8024e9 <fstat+0xb7>
	stat->st_name[0] = 0;
  80249f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a3:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024aa:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024b1:	00 00 00 
	stat->st_isdir = 0;
  8024b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024b8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024bf:	00 00 00 
	stat->st_dev = dev;
  8024c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ca:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024dd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024e1:	48 89 ce             	mov    %rcx,%rsi
  8024e4:	48 89 d7             	mov    %rdx,%rdi
  8024e7:	ff d0                	callq  *%rax
}
  8024e9:	c9                   	leaveq 
  8024ea:	c3                   	retq   

00000000008024eb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
  8024ef:	48 83 ec 20          	sub    $0x20,%rsp
  8024f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ff:	be 00 00 00 00       	mov    $0x0,%esi
  802504:	48 89 c7             	mov    %rax,%rdi
  802507:	48 b8 d9 25 80 00 00 	movabs $0x8025d9,%rax
  80250e:	00 00 00 
  802511:	ff d0                	callq  *%rax
  802513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251a:	79 05                	jns    802521 <stat+0x36>
		return fd;
  80251c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251f:	eb 2f                	jmp    802550 <stat+0x65>
	r = fstat(fd, stat);
  802521:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	89 c7                	mov    %eax,%edi
  80252d:	48 b8 32 24 80 00 00 	movabs $0x802432,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80253c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253f:	89 c7                	mov    %eax,%edi
  802541:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802548:	00 00 00 
  80254b:	ff d0                	callq  *%rax
	return r;
  80254d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 10          	sub    $0x10,%rsp
  80255a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80255d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802561:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802568:	00 00 00 
  80256b:	8b 00                	mov    (%rax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	75 1d                	jne    80258e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802571:	bf 01 00 00 00       	mov    $0x1,%edi
  802576:	48 b8 33 49 80 00 00 	movabs $0x804933,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802589:	00 00 00 
  80258c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80258e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802595:	00 00 00 
  802598:	8b 00                	mov    (%rax),%eax
  80259a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80259d:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025a2:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8025a9:	00 00 00 
  8025ac:	89 c7                	mov    %eax,%edi
  8025ae:	48 b8 d1 48 80 00 00 	movabs $0x8048d1,%rax
  8025b5:	00 00 00 
  8025b8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025be:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c3:	48 89 c6             	mov    %rax,%rsi
  8025c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cb:	48 b8 cb 47 80 00 00 	movabs $0x8047cb,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   

00000000008025d9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025d9:	55                   	push   %rbp
  8025da:	48 89 e5             	mov    %rsp,%rbp
  8025dd:	48 83 ec 30          	sub    $0x30,%rsp
  8025e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025e5:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8025e8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8025ef:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8025f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8025fd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802602:	75 08                	jne    80260c <open+0x33>
	{
		return r;
  802604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802607:	e9 f2 00 00 00       	jmpq   8026fe <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80260c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802610:	48 89 c7             	mov    %rax,%rdi
  802613:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80261a:	00 00 00 
  80261d:	ff d0                	callq  *%rax
  80261f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802622:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802629:	7e 0a                	jle    802635 <open+0x5c>
	{
		return -E_BAD_PATH;
  80262b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802630:	e9 c9 00 00 00       	jmpq   8026fe <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802635:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80263c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80263d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802641:	48 89 c7             	mov    %rax,%rdi
  802644:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
  802650:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802653:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802657:	78 09                	js     802662 <open+0x89>
  802659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265d:	48 85 c0             	test   %rax,%rax
  802660:	75 08                	jne    80266a <open+0x91>
		{
			return r;
  802662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802665:	e9 94 00 00 00       	jmpq   8026fe <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80266a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266e:	ba 00 04 00 00       	mov    $0x400,%edx
  802673:	48 89 c6             	mov    %rax,%rsi
  802676:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80267d:	00 00 00 
  802680:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  802687:	00 00 00 
  80268a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80268c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802693:	00 00 00 
  802696:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802699:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80269f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a3:	48 89 c6             	mov    %rax,%rsi
  8026a6:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ab:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026be:	79 2b                	jns    8026eb <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8026c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c4:	be 00 00 00 00       	mov    $0x0,%esi
  8026c9:	48 89 c7             	mov    %rax,%rdi
  8026cc:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
  8026d8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026df:	79 05                	jns    8026e6 <open+0x10d>
			{
				return d;
  8026e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026e4:	eb 18                	jmp    8026fe <open+0x125>
			}
			return r;
  8026e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e9:	eb 13                	jmp    8026fe <open+0x125>
		}	
		return fd2num(fd_store);
  8026eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ef:	48 89 c7             	mov    %rax,%rdi
  8026f2:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8026fe:	c9                   	leaveq 
  8026ff:	c3                   	retq   

0000000000802700 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802700:	55                   	push   %rbp
  802701:	48 89 e5             	mov    %rsp,%rbp
  802704:	48 83 ec 10          	sub    $0x10,%rsp
  802708:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80270c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802710:	8b 50 0c             	mov    0xc(%rax),%edx
  802713:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80271a:	00 00 00 
  80271d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80271f:	be 00 00 00 00       	mov    $0x0,%esi
  802724:	bf 06 00 00 00       	mov    $0x6,%edi
  802729:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802730:	00 00 00 
  802733:	ff d0                	callq  *%rax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 30          	sub    $0x30,%rsp
  80273f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802743:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80274b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802752:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802757:	74 07                	je     802760 <devfile_read+0x29>
  802759:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80275e:	75 07                	jne    802767 <devfile_read+0x30>
		return -E_INVAL;
  802760:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802765:	eb 77                	jmp    8027de <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276b:	8b 50 0c             	mov    0xc(%rax),%edx
  80276e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802775:	00 00 00 
  802778:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80277a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802781:	00 00 00 
  802784:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802788:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80278c:	be 00 00 00 00       	mov    $0x0,%esi
  802791:	bf 03 00 00 00       	mov    $0x3,%edi
  802796:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a9:	7f 05                	jg     8027b0 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8027ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ae:	eb 2e                	jmp    8027de <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8027b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b3:	48 63 d0             	movslq %eax,%rdx
  8027b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ba:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8027c1:	00 00 00 
  8027c4:	48 89 c7             	mov    %rax,%rdi
  8027c7:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8027ce:	00 00 00 
  8027d1:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8027d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8027db:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8027de:	c9                   	leaveq 
  8027df:	c3                   	retq   

00000000008027e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027e0:	55                   	push   %rbp
  8027e1:	48 89 e5             	mov    %rsp,%rbp
  8027e4:	48 83 ec 30          	sub    $0x30,%rsp
  8027e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8027f4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8027fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802800:	74 07                	je     802809 <devfile_write+0x29>
  802802:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802807:	75 08                	jne    802811 <devfile_write+0x31>
		return r;
  802809:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280c:	e9 9a 00 00 00       	jmpq   8028ab <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802815:	8b 50 0c             	mov    0xc(%rax),%edx
  802818:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80281f:	00 00 00 
  802822:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802824:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80282b:	00 
  80282c:	76 08                	jbe    802836 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80282e:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802835:	00 
	}
	fsipcbuf.write.req_n = n;
  802836:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80283d:	00 00 00 
  802840:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802844:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802848:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802850:	48 89 c6             	mov    %rax,%rsi
  802853:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80285a:	00 00 00 
  80285d:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802869:	be 00 00 00 00       	mov    $0x0,%esi
  80286e:	bf 04 00 00 00       	mov    $0x4,%edi
  802873:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
  80287f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802886:	7f 20                	jg     8028a8 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802888:	48 bf 56 50 80 00 00 	movabs $0x805056,%rdi
  80288f:	00 00 00 
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  80289e:	00 00 00 
  8028a1:	ff d2                	callq  *%rdx
		return r;
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a6:	eb 03                	jmp    8028ab <devfile_write+0xcb>
	}
	return r;
  8028a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8028ab:	c9                   	leaveq 
  8028ac:	c3                   	retq   

00000000008028ad <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028ad:	55                   	push   %rbp
  8028ae:	48 89 e5             	mov    %rsp,%rbp
  8028b1:	48 83 ec 20          	sub    $0x20,%rsp
  8028b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028cb:	00 00 00 
  8028ce:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028d0:	be 00 00 00 00       	mov    $0x0,%esi
  8028d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8028da:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ed:	79 05                	jns    8028f4 <devfile_stat+0x47>
		return r;
  8028ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f2:	eb 56                	jmp    80294a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f8:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8028ff:	00 00 00 
  802902:	48 89 c7             	mov    %rax,%rdi
  802905:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802911:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802918:	00 00 00 
  80291b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802921:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802925:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80292b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802932:	00 00 00 
  802935:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80293b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294a:	c9                   	leaveq 
  80294b:	c3                   	retq   

000000000080294c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80294c:	55                   	push   %rbp
  80294d:	48 89 e5             	mov    %rsp,%rbp
  802950:	48 83 ec 10          	sub    $0x10,%rsp
  802954:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802958:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80295b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80295f:	8b 50 0c             	mov    0xc(%rax),%edx
  802962:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802969:	00 00 00 
  80296c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80296e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802975:	00 00 00 
  802978:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80297e:	be 00 00 00 00       	mov    $0x0,%esi
  802983:	bf 02 00 00 00       	mov    $0x2,%edi
  802988:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax
}
  802994:	c9                   	leaveq 
  802995:	c3                   	retq   

0000000000802996 <remove>:

// Delete a file
int
remove(const char *path)
{
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
  80299a:	48 83 ec 10          	sub    $0x10,%rsp
  80299e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a6:	48 89 c7             	mov    %rax,%rdi
  8029a9:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
  8029b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029ba:	7e 07                	jle    8029c3 <remove+0x2d>
		return -E_BAD_PATH;
  8029bc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029c1:	eb 33                	jmp    8029f6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c7:	48 89 c6             	mov    %rax,%rsi
  8029ca:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8029d1:	00 00 00 
  8029d4:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8029db:	00 00 00 
  8029de:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029e0:	be 00 00 00 00       	mov    $0x0,%esi
  8029e5:	bf 07 00 00 00       	mov    $0x7,%edi
  8029ea:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029fc:	be 00 00 00 00       	mov    $0x0,%esi
  802a01:	bf 08 00 00 00       	mov    $0x8,%edi
  802a06:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802a0d:	00 00 00 
  802a10:	ff d0                	callq  *%rax
}
  802a12:	5d                   	pop    %rbp
  802a13:	c3                   	retq   

0000000000802a14 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a14:	55                   	push   %rbp
  802a15:	48 89 e5             	mov    %rsp,%rbp
  802a18:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a1f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a26:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a2d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a34:	be 00 00 00 00       	mov    $0x0,%esi
  802a39:	48 89 c7             	mov    %rax,%rdi
  802a3c:	48 b8 d9 25 80 00 00 	movabs $0x8025d9,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4f:	79 28                	jns    802a79 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a54:	89 c6                	mov    %eax,%esi
  802a56:	48 bf 72 50 80 00 00 	movabs $0x805072,%rdi
  802a5d:	00 00 00 
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
  802a65:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802a6c:	00 00 00 
  802a6f:	ff d2                	callq  *%rdx
		return fd_src;
  802a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a74:	e9 74 01 00 00       	jmpq   802bed <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a79:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a80:	be 01 01 00 00       	mov    $0x101,%esi
  802a85:	48 89 c7             	mov    %rax,%rdi
  802a88:	48 b8 d9 25 80 00 00 	movabs $0x8025d9,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
  802a94:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a97:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a9b:	79 39                	jns    802ad6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa0:	89 c6                	mov    %eax,%esi
  802aa2:	48 bf 88 50 80 00 00 	movabs $0x805088,%rdi
  802aa9:	00 00 00 
  802aac:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab1:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802ab8:	00 00 00 
  802abb:	ff d2                	callq  *%rdx
		close(fd_src);
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac0:	89 c7                	mov    %eax,%edi
  802ac2:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
		return fd_dest;
  802ace:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad1:	e9 17 01 00 00       	jmpq   802bed <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ad6:	eb 74                	jmp    802b4c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ad8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802adb:	48 63 d0             	movslq %eax,%rdx
  802ade:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae8:	48 89 ce             	mov    %rcx,%rsi
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802afc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b00:	79 4a                	jns    802b4c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b02:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b05:	89 c6                	mov    %eax,%esi
  802b07:	48 bf a2 50 80 00 00 	movabs $0x8050a2,%rdi
  802b0e:	00 00 00 
  802b11:	b8 00 00 00 00       	mov    $0x0,%eax
  802b16:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802b1d:	00 00 00 
  802b20:	ff d2                	callq  *%rdx
			close(fd_src);
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	89 c7                	mov    %eax,%edi
  802b27:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802b2e:	00 00 00 
  802b31:	ff d0                	callq  *%rax
			close(fd_dest);
  802b33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b36:	89 c7                	mov    %eax,%edi
  802b38:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
			return write_size;
  802b44:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b47:	e9 a1 00 00 00       	jmpq   802bed <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b4c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b56:	ba 00 02 00 00       	mov    $0x200,%edx
  802b5b:	48 89 ce             	mov    %rcx,%rsi
  802b5e:	89 c7                	mov    %eax,%edi
  802b60:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
  802b6c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b73:	0f 8f 5f ff ff ff    	jg     802ad8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b7d:	79 47                	jns    802bc6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b82:	89 c6                	mov    %eax,%esi
  802b84:	48 bf b5 50 80 00 00 	movabs $0x8050b5,%rdi
  802b8b:	00 00 00 
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b93:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802b9a:	00 00 00 
  802b9d:	ff d2                	callq  *%rdx
		close(fd_src);
  802b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba2:	89 c7                	mov    %eax,%edi
  802ba4:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
		close(fd_dest);
  802bb0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb3:	89 c7                	mov    %eax,%edi
  802bb5:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
		return read_size;
  802bc1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bc4:	eb 27                	jmp    802bed <copy+0x1d9>
	}
	close(fd_src);
  802bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc9:	89 c7                	mov    %eax,%edi
  802bcb:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
	close(fd_dest);
  802bd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bda:	89 c7                	mov    %eax,%edi
  802bdc:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
	return 0;
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802bed:	c9                   	leaveq 
  802bee:	c3                   	retq   

0000000000802bef <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
  802bf3:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802bfa:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802c01:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802c08:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802c0f:	be 00 00 00 00       	mov    $0x0,%esi
  802c14:	48 89 c7             	mov    %rax,%rdi
  802c17:	48 b8 d9 25 80 00 00 	movabs $0x8025d9,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c26:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c2a:	79 08                	jns    802c34 <spawn+0x45>
		return r;
  802c2c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c2f:	e9 14 03 00 00       	jmpq   802f48 <spawn+0x359>
	fd = r;
  802c34:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c37:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802c3a:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802c41:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802c45:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802c4c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c4f:	ba 00 02 00 00       	mov    $0x200,%edx
  802c54:	48 89 ce             	mov    %rcx,%rsi
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 d8 21 80 00 00 	movabs $0x8021d8,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	3d 00 02 00 00       	cmp    $0x200,%eax
  802c6a:	75 0d                	jne    802c79 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c70:	8b 00                	mov    (%rax),%eax
  802c72:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c77:	74 43                	je     802cbc <spawn+0xcd>
		close(fd);
  802c79:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8e:	8b 00                	mov    (%rax),%eax
  802c90:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c95:	89 c6                	mov    %eax,%esi
  802c97:	48 bf d0 50 80 00 00 	movabs $0x8050d0,%rdi
  802c9e:	00 00 00 
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  802cad:	00 00 00 
  802cb0:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802cb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cb7:	e9 8c 02 00 00       	jmpq   802f48 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802cbc:	b8 07 00 00 00       	mov    $0x7,%eax
  802cc1:	cd 30                	int    $0x30
  802cc3:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802cc6:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802cc9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cd0:	79 08                	jns    802cda <spawn+0xeb>
		return r;
  802cd2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd5:	e9 6e 02 00 00       	jmpq   802f48 <spawn+0x359>
	child = r;
  802cda:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cdd:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ce0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ce3:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ce8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802cef:	00 00 00 
  802cf2:	48 63 d0             	movslq %eax,%rdx
  802cf5:	48 89 d0             	mov    %rdx,%rax
  802cf8:	48 c1 e0 03          	shl    $0x3,%rax
  802cfc:	48 01 d0             	add    %rdx,%rax
  802cff:	48 c1 e0 05          	shl    $0x5,%rax
  802d03:	48 01 c8             	add    %rcx,%rax
  802d06:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d0d:	48 89 c6             	mov    %rax,%rsi
  802d10:	b8 18 00 00 00       	mov    $0x18,%eax
  802d15:	48 89 d7             	mov    %rdx,%rdi
  802d18:	48 89 c1             	mov    %rax,%rcx
  802d1b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802d1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d22:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d26:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802d2d:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802d34:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802d3b:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802d42:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d45:	48 89 ce             	mov    %rcx,%rsi
  802d48:	89 c7                	mov    %eax,%edi
  802d4a:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
  802d56:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d59:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d5d:	79 08                	jns    802d67 <spawn+0x178>
		return r;
  802d5f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d62:	e9 e1 01 00 00       	jmpq   802f48 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6b:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d6f:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d76:	48 01 d0             	add    %rdx,%rax
  802d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d84:	e9 a3 00 00 00       	jmpq   802e2c <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8d:	8b 00                	mov    (%rax),%eax
  802d8f:	83 f8 01             	cmp    $0x1,%eax
  802d92:	74 05                	je     802d99 <spawn+0x1aa>
			continue;
  802d94:	e9 8a 00 00 00       	jmpq   802e23 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802d99:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da4:	8b 40 04             	mov    0x4(%rax),%eax
  802da7:	83 e0 02             	and    $0x2,%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 04                	je     802db2 <spawn+0x1c3>
			perm |= PTE_W;
  802dae:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db6:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802dba:	41 89 c1             	mov    %eax,%r9d
  802dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc1:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc9:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd1:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802dd5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802dd8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ddb:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802dde:	89 3c 24             	mov    %edi,(%rsp)
  802de1:	89 c7                	mov    %eax,%edi
  802de3:	48 b8 5b 34 80 00 00 	movabs $0x80345b,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802df2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802df6:	79 2b                	jns    802e23 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802df8:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802df9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
	close(fd);
  802e0a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
	return r;
  802e1b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e1e:	e9 25 01 00 00       	jmpq   802f48 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e23:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e27:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802e2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e30:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802e34:	0f b7 c0             	movzwl %ax,%eax
  802e37:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e3a:	0f 8f 49 ff ff ff    	jg     802d89 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802e40:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e43:	89 c7                	mov    %eax,%edi
  802e45:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
	fd = -1;
  802e51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802e58:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e5b:	89 c7                	mov    %eax,%edi
  802e5d:	48 b8 47 36 80 00 00 	movabs $0x803647,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e70:	79 30                	jns    802ea2 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802e72:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e75:	89 c1                	mov    %eax,%ecx
  802e77:	48 ba ea 50 80 00 00 	movabs $0x8050ea,%rdx
  802e7e:	00 00 00 
  802e81:	be 82 00 00 00       	mov    $0x82,%esi
  802e86:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802e8d:	00 00 00 
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
  802e95:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802e9c:	00 00 00 
  802e9f:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ea2:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802ea9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eac:	48 89 d6             	mov    %rdx,%rsi
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
  802ebd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ec0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ec4:	79 30                	jns    802ef6 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802ec6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ec9:	89 c1                	mov    %eax,%ecx
  802ecb:	48 ba 0c 51 80 00 00 	movabs $0x80510c,%rdx
  802ed2:	00 00 00 
  802ed5:	be 85 00 00 00       	mov    $0x85,%esi
  802eda:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802ee1:	00 00 00 
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802ef0:	00 00 00 
  802ef3:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802ef6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ef9:	be 02 00 00 00       	mov    $0x2,%esi
  802efe:	89 c7                	mov    %eax,%edi
  802f00:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f13:	79 30                	jns    802f45 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802f15:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f18:	89 c1                	mov    %eax,%ecx
  802f1a:	48 ba 26 51 80 00 00 	movabs $0x805126,%rdx
  802f21:	00 00 00 
  802f24:	be 88 00 00 00       	mov    $0x88,%esi
  802f29:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802f30:	00 00 00 
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
  802f38:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802f3f:	00 00 00 
  802f42:	41 ff d0             	callq  *%r8

	return child;
  802f45:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802f48:	c9                   	leaveq 
  802f49:	c3                   	retq   

0000000000802f4a <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f4a:	55                   	push   %rbp
  802f4b:	48 89 e5             	mov    %rsp,%rbp
  802f4e:	41 55                	push   %r13
  802f50:	41 54                	push   %r12
  802f52:	53                   	push   %rbx
  802f53:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f5a:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802f61:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802f68:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f6f:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f76:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f7d:	84 c0                	test   %al,%al
  802f7f:	74 26                	je     802fa7 <spawnl+0x5d>
  802f81:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f88:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f8f:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f93:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f97:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f9b:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802f9f:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802fa3:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802fa7:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802fae:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802fb5:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802fb8:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802fbf:	00 00 00 
  802fc2:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fc9:	00 00 00 
  802fcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fd0:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fd7:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fde:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802fe5:	eb 07                	jmp    802fee <spawnl+0xa4>
		argc++;
  802fe7:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802fee:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ff4:	83 f8 30             	cmp    $0x30,%eax
  802ff7:	73 23                	jae    80301c <spawnl+0xd2>
  802ff9:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803000:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803006:	89 c0                	mov    %eax,%eax
  803008:	48 01 d0             	add    %rdx,%rax
  80300b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803011:	83 c2 08             	add    $0x8,%edx
  803014:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80301a:	eb 15                	jmp    803031 <spawnl+0xe7>
  80301c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803023:	48 89 d0             	mov    %rdx,%rax
  803026:	48 83 c2 08          	add    $0x8,%rdx
  80302a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803031:	48 8b 00             	mov    (%rax),%rax
  803034:	48 85 c0             	test   %rax,%rax
  803037:	75 ae                	jne    802fe7 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803039:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80303f:	83 c0 02             	add    $0x2,%eax
  803042:	48 89 e2             	mov    %rsp,%rdx
  803045:	48 89 d3             	mov    %rdx,%rbx
  803048:	48 63 d0             	movslq %eax,%rdx
  80304b:	48 83 ea 01          	sub    $0x1,%rdx
  80304f:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803056:	48 63 d0             	movslq %eax,%rdx
  803059:	49 89 d4             	mov    %rdx,%r12
  80305c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803062:	48 63 d0             	movslq %eax,%rdx
  803065:	49 89 d2             	mov    %rdx,%r10
  803068:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80306e:	48 98                	cltq   
  803070:	48 c1 e0 03          	shl    $0x3,%rax
  803074:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803078:	b8 10 00 00 00       	mov    $0x10,%eax
  80307d:	48 83 e8 01          	sub    $0x1,%rax
  803081:	48 01 d0             	add    %rdx,%rax
  803084:	bf 10 00 00 00       	mov    $0x10,%edi
  803089:	ba 00 00 00 00       	mov    $0x0,%edx
  80308e:	48 f7 f7             	div    %rdi
  803091:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803095:	48 29 c4             	sub    %rax,%rsp
  803098:	48 89 e0             	mov    %rsp,%rax
  80309b:	48 83 c0 07          	add    $0x7,%rax
  80309f:	48 c1 e8 03          	shr    $0x3,%rax
  8030a3:	48 c1 e0 03          	shl    $0x3,%rax
  8030a7:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8030ae:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030b5:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8030bc:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8030bf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c5:	8d 50 01             	lea    0x1(%rax),%edx
  8030c8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030cf:	48 63 d2             	movslq %edx,%rdx
  8030d2:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8030d9:	00 

	va_start(vl, arg0);
  8030da:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030e1:	00 00 00 
  8030e4:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030eb:	00 00 00 
  8030ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030f2:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030f9:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803100:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803107:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80310e:	00 00 00 
  803111:	eb 63                	jmp    803176 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803113:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803119:	8d 70 01             	lea    0x1(%rax),%esi
  80311c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803122:	83 f8 30             	cmp    $0x30,%eax
  803125:	73 23                	jae    80314a <spawnl+0x200>
  803127:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80312e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803134:	89 c0                	mov    %eax,%eax
  803136:	48 01 d0             	add    %rdx,%rax
  803139:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80313f:	83 c2 08             	add    $0x8,%edx
  803142:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803148:	eb 15                	jmp    80315f <spawnl+0x215>
  80314a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803151:	48 89 d0             	mov    %rdx,%rax
  803154:	48 83 c2 08          	add    $0x8,%rdx
  803158:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80315f:	48 8b 08             	mov    (%rax),%rcx
  803162:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803169:	89 f2                	mov    %esi,%edx
  80316b:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80316f:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803176:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80317c:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803182:	77 8f                	ja     803113 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803184:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80318b:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803192:	48 89 d6             	mov    %rdx,%rsi
  803195:	48 89 c7             	mov    %rax,%rdi
  803198:	48 b8 ef 2b 80 00 00 	movabs $0x802bef,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
  8031a4:	48 89 dc             	mov    %rbx,%rsp
}
  8031a7:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8031ab:	5b                   	pop    %rbx
  8031ac:	41 5c                	pop    %r12
  8031ae:	41 5d                	pop    %r13
  8031b0:	5d                   	pop    %rbp
  8031b1:	c3                   	retq   

00000000008031b2 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 50          	sub    $0x50,%rsp
  8031ba:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031bd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031c1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8031c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031cc:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8031cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8031d4:	eb 33                	jmp    803209 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8031d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d9:	48 98                	cltq   
  8031db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031e2:	00 
  8031e3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031e7:	48 01 d0             	add    %rdx,%rax
  8031ea:	48 8b 00             	mov    (%rax),%rax
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	83 c0 01             	add    $0x1,%eax
  8031ff:	48 98                	cltq   
  803201:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803205:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803209:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80320c:	48 98                	cltq   
  80320e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803215:	00 
  803216:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80321a:	48 01 d0             	add    %rdx,%rax
  80321d:	48 8b 00             	mov    (%rax),%rax
  803220:	48 85 c0             	test   %rax,%rax
  803223:	75 b1                	jne    8031d6 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803229:	48 f7 d8             	neg    %rax
  80322c:	48 05 00 10 40 00    	add    $0x401000,%rax
  803232:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80323e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803242:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803246:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803249:	83 c2 01             	add    $0x1,%edx
  80324c:	c1 e2 03             	shl    $0x3,%edx
  80324f:	48 63 d2             	movslq %edx,%rdx
  803252:	48 f7 da             	neg    %rdx
  803255:	48 01 d0             	add    %rdx,%rax
  803258:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80325c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803260:	48 83 e8 10          	sub    $0x10,%rax
  803264:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80326a:	77 0a                	ja     803276 <init_stack+0xc4>
		return -E_NO_MEM;
  80326c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803271:	e9 e3 01 00 00       	jmpq   803459 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803276:	ba 07 00 00 00       	mov    $0x7,%edx
  80327b:	be 00 00 40 00       	mov    $0x400000,%esi
  803280:	bf 00 00 00 00       	mov    $0x0,%edi
  803285:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803294:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803298:	79 08                	jns    8032a2 <init_stack+0xf0>
		return r;
  80329a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329d:	e9 b7 01 00 00       	jmpq   803459 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8032a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8032a9:	e9 8a 00 00 00       	jmpq   803338 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8032ae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032b1:	48 98                	cltq   
  8032b3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032ba:	00 
  8032bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032bf:	48 01 c2             	add    %rax,%rdx
  8032c2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032cb:	48 01 c8             	add    %rcx,%rax
  8032ce:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8032d4:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8032d7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032da:	48 98                	cltq   
  8032dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032e3:	00 
  8032e4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032e8:	48 01 d0             	add    %rdx,%rax
  8032eb:	48 8b 10             	mov    (%rax),%rdx
  8032ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f2:	48 89 d6             	mov    %rdx,%rsi
  8032f5:	48 89 c7             	mov    %rax,%rdi
  8032f8:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803304:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803307:	48 98                	cltq   
  803309:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803310:	00 
  803311:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803315:	48 01 d0             	add    %rdx,%rax
  803318:	48 8b 00             	mov    (%rax),%rax
  80331b:	48 89 c7             	mov    %rax,%rdi
  80331e:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
  80332a:	48 98                	cltq   
  80332c:	48 83 c0 01          	add    $0x1,%rax
  803330:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803334:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803338:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80333b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80333e:	0f 8c 6a ff ff ff    	jl     8032ae <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803347:	48 98                	cltq   
  803349:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803350:	00 
  803351:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803355:	48 01 d0             	add    %rdx,%rax
  803358:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80335f:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803366:	00 
  803367:	74 35                	je     80339e <init_stack+0x1ec>
  803369:	48 b9 40 51 80 00 00 	movabs $0x805140,%rcx
  803370:	00 00 00 
  803373:	48 ba 66 51 80 00 00 	movabs $0x805166,%rdx
  80337a:	00 00 00 
  80337d:	be f1 00 00 00       	mov    $0xf1,%esi
  803382:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  803389:	00 00 00 
  80338c:	b8 00 00 00 00       	mov    $0x0,%eax
  803391:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803398:	00 00 00 
  80339b:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80339e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a2:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8033a6:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033af:	48 01 c8             	add    %rcx,%rax
  8033b2:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033b8:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8033bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bf:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8033c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033c6:	48 98                	cltq   
  8033c8:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8033cb:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8033d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d4:	48 01 d0             	add    %rdx,%rax
  8033d7:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033dd:	48 89 c2             	mov    %rax,%rdx
  8033e0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8033e4:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8033e7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033ea:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033f0:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033f5:	89 c2                	mov    %eax,%edx
  8033f7:	be 00 00 40 00       	mov    $0x400000,%esi
  8033fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803401:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
  80340d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803410:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803414:	79 02                	jns    803418 <init_stack+0x266>
		goto error;
  803416:	eb 28                	jmp    803440 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803418:	be 00 00 40 00       	mov    $0x400000,%esi
  80341d:	bf 00 00 00 00       	mov    $0x0,%edi
  803422:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
  80342e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803431:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803435:	79 02                	jns    803439 <init_stack+0x287>
		goto error;
  803437:	eb 07                	jmp    803440 <init_stack+0x28e>

	return 0;
  803439:	b8 00 00 00 00       	mov    $0x0,%eax
  80343e:	eb 19                	jmp    803459 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803440:	be 00 00 40 00       	mov    $0x400000,%esi
  803445:	bf 00 00 00 00       	mov    $0x0,%edi
  80344a:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
	return r;
  803456:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803459:	c9                   	leaveq 
  80345a:	c3                   	retq   

000000000080345b <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  80345b:	55                   	push   %rbp
  80345c:	48 89 e5             	mov    %rsp,%rbp
  80345f:	48 83 ec 50          	sub    $0x50,%rsp
  803463:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803466:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80346a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80346e:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803471:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803475:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803479:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347d:	25 ff 0f 00 00       	and    $0xfff,%eax
  803482:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803485:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803489:	74 21                	je     8034ac <map_segment+0x51>
		va -= i;
  80348b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348e:	48 98                	cltq   
  803490:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803494:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803497:	48 98                	cltq   
  803499:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80349d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a0:	48 98                	cltq   
  8034a2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a9:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034b3:	e9 79 01 00 00       	jmpq   803631 <map_segment+0x1d6>
		if (i >= filesz) {
  8034b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bb:	48 98                	cltq   
  8034bd:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8034c1:	72 3c                	jb     8034ff <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8034c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c6:	48 63 d0             	movslq %eax,%rdx
  8034c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034cd:	48 01 d0             	add    %rdx,%rax
  8034d0:	48 89 c1             	mov    %rax,%rcx
  8034d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034d6:	8b 55 10             	mov    0x10(%rbp),%edx
  8034d9:	48 89 ce             	mov    %rcx,%rsi
  8034dc:	89 c7                	mov    %eax,%edi
  8034de:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8034e5:	00 00 00 
  8034e8:	ff d0                	callq  *%rax
  8034ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034ed:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034f1:	0f 89 33 01 00 00    	jns    80362a <map_segment+0x1cf>
				return r;
  8034f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fa:	e9 46 01 00 00       	jmpq   803645 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8034ff:	ba 07 00 00 00       	mov    $0x7,%edx
  803504:	be 00 00 40 00       	mov    $0x400000,%esi
  803509:	bf 00 00 00 00       	mov    $0x0,%edi
  80350e:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
  80351a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80351d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803521:	79 08                	jns    80352b <map_segment+0xd0>
				return r;
  803523:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803526:	e9 1a 01 00 00       	jmpq   803645 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80352b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352e:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803531:	01 c2                	add    %eax,%edx
  803533:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803536:	89 d6                	mov    %edx,%esi
  803538:	89 c7                	mov    %eax,%edi
  80353a:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803549:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80354d:	79 08                	jns    803557 <map_segment+0xfc>
				return r;
  80354f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803552:	e9 ee 00 00 00       	jmpq   803645 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803557:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80355e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803561:	48 98                	cltq   
  803563:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803567:	48 29 c2             	sub    %rax,%rdx
  80356a:	48 89 d0             	mov    %rdx,%rax
  80356d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803571:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803574:	48 63 d0             	movslq %eax,%rdx
  803577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357b:	48 39 c2             	cmp    %rax,%rdx
  80357e:	48 0f 47 d0          	cmova  %rax,%rdx
  803582:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803585:	be 00 00 40 00       	mov    $0x400000,%esi
  80358a:	89 c7                	mov    %eax,%edi
  80358c:	48 b8 d8 21 80 00 00 	movabs $0x8021d8,%rax
  803593:	00 00 00 
  803596:	ff d0                	callq  *%rax
  803598:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80359b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359f:	79 08                	jns    8035a9 <map_segment+0x14e>
				return r;
  8035a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a4:	e9 9c 00 00 00       	jmpq   803645 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8035a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ac:	48 63 d0             	movslq %eax,%rdx
  8035af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b3:	48 01 d0             	add    %rdx,%rax
  8035b6:	48 89 c2             	mov    %rax,%rdx
  8035b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035bc:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8035c0:	48 89 d1             	mov    %rdx,%rcx
  8035c3:	89 c2                	mov    %eax,%edx
  8035c5:	be 00 00 40 00       	mov    $0x400000,%esi
  8035ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cf:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
  8035db:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035e2:	79 30                	jns    803614 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8035e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e7:	89 c1                	mov    %eax,%ecx
  8035e9:	48 ba 7b 51 80 00 00 	movabs $0x80517b,%rdx
  8035f0:	00 00 00 
  8035f3:	be 24 01 00 00       	mov    $0x124,%esi
  8035f8:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  8035ff:	00 00 00 
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
  803607:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  80360e:	00 00 00 
  803611:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803614:	be 00 00 40 00       	mov    $0x400000,%esi
  803619:	bf 00 00 00 00       	mov    $0x0,%edi
  80361e:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803625:	00 00 00 
  803628:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80362a:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	48 98                	cltq   
  803636:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80363a:	0f 82 78 fe ff ff    	jb     8034b8 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803640:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803645:	c9                   	leaveq 
  803646:	c3                   	retq   

0000000000803647 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803647:	55                   	push   %rbp
  803648:	48 89 e5             	mov    %rsp,%rbp
  80364b:	48 83 ec 20          	sub    $0x20,%rsp
  80364f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803652:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803659:	00 
  80365a:	e9 c9 00 00 00       	jmpq   803728 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  80365f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803663:	48 c1 e8 27          	shr    $0x27,%rax
  803667:	48 89 c2             	mov    %rax,%rdx
  80366a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803671:	01 00 00 
  803674:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803678:	48 85 c0             	test   %rax,%rax
  80367b:	74 3c                	je     8036b9 <copy_shared_pages+0x72>
  80367d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803681:	48 c1 e8 1e          	shr    $0x1e,%rax
  803685:	48 89 c2             	mov    %rax,%rdx
  803688:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80368f:	01 00 00 
  803692:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803696:	48 85 c0             	test   %rax,%rax
  803699:	74 1e                	je     8036b9 <copy_shared_pages+0x72>
  80369b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369f:	48 c1 e8 15          	shr    $0x15,%rax
  8036a3:	48 89 c2             	mov    %rax,%rdx
  8036a6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036ad:	01 00 00 
  8036b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036b4:	48 85 c0             	test   %rax,%rax
  8036b7:	75 02                	jne    8036bb <copy_shared_pages+0x74>
                continue;
  8036b9:	eb 65                	jmp    803720 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8036bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8036c3:	48 89 c2             	mov    %rax,%rdx
  8036c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036cd:	01 00 00 
  8036d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036d4:	25 00 04 00 00       	and    $0x400,%eax
  8036d9:	48 85 c0             	test   %rax,%rax
  8036dc:	74 42                	je     803720 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8036de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8036e6:	48 89 c2             	mov    %rax,%rdx
  8036e9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036f0:	01 00 00 
  8036f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8036fc:	89 c6                	mov    %eax,%esi
  8036fe:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803706:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803709:	41 89 f0             	mov    %esi,%r8d
  80370c:	48 89 c6             	mov    %rax,%rsi
  80370f:	bf 00 00 00 00       	mov    $0x0,%edi
  803714:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803720:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803727:	00 
  803728:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80372f:	00 00 00 
  803732:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803736:	0f 86 23 ff ff ff    	jbe    80365f <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  80373c:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803741:	c9                   	leaveq 
  803742:	c3                   	retq   

0000000000803743 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803743:	55                   	push   %rbp
  803744:	48 89 e5             	mov    %rsp,%rbp
  803747:	48 83 ec 20          	sub    $0x20,%rsp
  80374b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80374e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803752:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803755:	48 89 d6             	mov    %rdx,%rsi
  803758:	89 c7                	mov    %eax,%edi
  80375a:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  803761:	00 00 00 
  803764:	ff d0                	callq  *%rax
  803766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376d:	79 05                	jns    803774 <fd2sockid+0x31>
		return r;
  80376f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803772:	eb 24                	jmp    803798 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803774:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803778:	8b 10                	mov    (%rax),%edx
  80377a:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803781:	00 00 00 
  803784:	8b 00                	mov    (%rax),%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	74 07                	je     803791 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80378a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80378f:	eb 07                	jmp    803798 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803791:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803795:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803798:	c9                   	leaveq 
  803799:	c3                   	retq   

000000000080379a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80379a:	55                   	push   %rbp
  80379b:	48 89 e5             	mov    %rsp,%rbp
  80379e:	48 83 ec 20          	sub    $0x20,%rsp
  8037a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8037a5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037a9:	48 89 c7             	mov    %rax,%rdi
  8037ac:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
  8037b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bf:	78 26                	js     8037e7 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8037c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c5:	ba 07 04 00 00       	mov    $0x407,%edx
  8037ca:	48 89 c6             	mov    %rax,%rsi
  8037cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d2:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
  8037de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e5:	79 16                	jns    8037fd <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8037e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ea:	89 c7                	mov    %eax,%edi
  8037ec:	48 b8 a7 3c 80 00 00 	movabs $0x803ca7,%rax
  8037f3:	00 00 00 
  8037f6:	ff d0                	callq  *%rax
		return r;
  8037f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fb:	eb 3a                	jmp    803837 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803801:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803808:	00 00 00 
  80380b:	8b 12                	mov    (%rdx),%edx
  80380d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80380f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803813:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80381a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803821:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803828:	48 89 c7             	mov    %rax,%rdi
  80382b:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
}
  803837:	c9                   	leaveq 
  803838:	c3                   	retq   

0000000000803839 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803839:	55                   	push   %rbp
  80383a:	48 89 e5             	mov    %rsp,%rbp
  80383d:	48 83 ec 30          	sub    $0x30,%rsp
  803841:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803844:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803848:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384f:	89 c7                	mov    %eax,%edi
  803851:	48 b8 43 37 80 00 00 	movabs $0x803743,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
  80385d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803864:	79 05                	jns    80386b <accept+0x32>
		return r;
  803866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803869:	eb 3b                	jmp    8038a6 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80386b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80386f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	48 89 ce             	mov    %rcx,%rsi
  803879:	89 c7                	mov    %eax,%edi
  80387b:	48 b8 84 3b 80 00 00 	movabs $0x803b84,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
  803887:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388e:	79 05                	jns    803895 <accept+0x5c>
		return r;
  803890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803893:	eb 11                	jmp    8038a6 <accept+0x6d>
	return alloc_sockfd(r);
  803895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803898:	89 c7                	mov    %eax,%edi
  80389a:	48 b8 9a 37 80 00 00 	movabs $0x80379a,%rax
  8038a1:	00 00 00 
  8038a4:	ff d0                	callq  *%rax
}
  8038a6:	c9                   	leaveq 
  8038a7:	c3                   	retq   

00000000008038a8 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038a8:	55                   	push   %rbp
  8038a9:	48 89 e5             	mov    %rsp,%rbp
  8038ac:	48 83 ec 20          	sub    $0x20,%rsp
  8038b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038b7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038bd:	89 c7                	mov    %eax,%edi
  8038bf:	48 b8 43 37 80 00 00 	movabs $0x803743,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
  8038cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d2:	79 05                	jns    8038d9 <bind+0x31>
		return r;
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	eb 1b                	jmp    8038f4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8038d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038dc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e3:	48 89 ce             	mov    %rcx,%rsi
  8038e6:	89 c7                	mov    %eax,%edi
  8038e8:	48 b8 03 3c 80 00 00 	movabs $0x803c03,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
}
  8038f4:	c9                   	leaveq 
  8038f5:	c3                   	retq   

00000000008038f6 <shutdown>:

int
shutdown(int s, int how)
{
  8038f6:	55                   	push   %rbp
  8038f7:	48 89 e5             	mov    %rsp,%rbp
  8038fa:	48 83 ec 20          	sub    $0x20,%rsp
  8038fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803901:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803904:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803907:	89 c7                	mov    %eax,%edi
  803909:	48 b8 43 37 80 00 00 	movabs $0x803743,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391c:	79 05                	jns    803923 <shutdown+0x2d>
		return r;
  80391e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803921:	eb 16                	jmp    803939 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803923:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	89 d6                	mov    %edx,%esi
  80392b:	89 c7                	mov    %eax,%edi
  80392d:	48 b8 67 3c 80 00 00 	movabs $0x803c67,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
}
  803939:	c9                   	leaveq 
  80393a:	c3                   	retq   

000000000080393b <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80393b:	55                   	push   %rbp
  80393c:	48 89 e5             	mov    %rsp,%rbp
  80393f:	48 83 ec 10          	sub    $0x10,%rsp
  803943:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803947:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394b:	48 89 c7             	mov    %rax,%rdi
  80394e:	48 b8 b5 49 80 00 00 	movabs $0x8049b5,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
  80395a:	83 f8 01             	cmp    $0x1,%eax
  80395d:	75 17                	jne    803976 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80395f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803963:	8b 40 0c             	mov    0xc(%rax),%eax
  803966:	89 c7                	mov    %eax,%edi
  803968:	48 b8 a7 3c 80 00 00 	movabs $0x803ca7,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
  803974:	eb 05                	jmp    80397b <devsock_close+0x40>
	else
		return 0;
  803976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397b:	c9                   	leaveq 
  80397c:	c3                   	retq   

000000000080397d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 20          	sub    $0x20,%rsp
  803985:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803988:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80398c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80398f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803992:	89 c7                	mov    %eax,%edi
  803994:	48 b8 43 37 80 00 00 	movabs $0x803743,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a7:	79 05                	jns    8039ae <connect+0x31>
		return r;
  8039a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ac:	eb 1b                	jmp    8039c9 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8039ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039b1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b8:	48 89 ce             	mov    %rcx,%rsi
  8039bb:	89 c7                	mov    %eax,%edi
  8039bd:	48 b8 d4 3c 80 00 00 	movabs $0x803cd4,%rax
  8039c4:	00 00 00 
  8039c7:	ff d0                	callq  *%rax
}
  8039c9:	c9                   	leaveq 
  8039ca:	c3                   	retq   

00000000008039cb <listen>:

int
listen(int s, int backlog)
{
  8039cb:	55                   	push   %rbp
  8039cc:	48 89 e5             	mov    %rsp,%rbp
  8039cf:	48 83 ec 20          	sub    $0x20,%rsp
  8039d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039dc:	89 c7                	mov    %eax,%edi
  8039de:	48 b8 43 37 80 00 00 	movabs $0x803743,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
  8039ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f1:	79 05                	jns    8039f8 <listen+0x2d>
		return r;
  8039f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f6:	eb 16                	jmp    803a0e <listen+0x43>
	return nsipc_listen(r, backlog);
  8039f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fe:	89 d6                	mov    %edx,%esi
  803a00:	89 c7                	mov    %eax,%edi
  803a02:	48 b8 38 3d 80 00 00 	movabs $0x803d38,%rax
  803a09:	00 00 00 
  803a0c:	ff d0                	callq  *%rax
}
  803a0e:	c9                   	leaveq 
  803a0f:	c3                   	retq   

0000000000803a10 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a10:	55                   	push   %rbp
  803a11:	48 89 e5             	mov    %rsp,%rbp
  803a14:	48 83 ec 20          	sub    $0x20,%rsp
  803a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a20:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a28:	89 c2                	mov    %eax,%edx
  803a2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2e:	8b 40 0c             	mov    0xc(%rax),%eax
  803a31:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a35:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a3a:	89 c7                	mov    %eax,%edi
  803a3c:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  803a43:	00 00 00 
  803a46:	ff d0                	callq  *%rax
}
  803a48:	c9                   	leaveq 
  803a49:	c3                   	retq   

0000000000803a4a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a4a:	55                   	push   %rbp
  803a4b:	48 89 e5             	mov    %rsp,%rbp
  803a4e:	48 83 ec 20          	sub    $0x20,%rsp
  803a52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a5a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a62:	89 c2                	mov    %eax,%edx
  803a64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a68:	8b 40 0c             	mov    0xc(%rax),%eax
  803a6b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a74:	89 c7                	mov    %eax,%edi
  803a76:	48 b8 44 3e 80 00 00 	movabs $0x803e44,%rax
  803a7d:	00 00 00 
  803a80:	ff d0                	callq  *%rax
}
  803a82:	c9                   	leaveq 
  803a83:	c3                   	retq   

0000000000803a84 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a84:	55                   	push   %rbp
  803a85:	48 89 e5             	mov    %rsp,%rbp
  803a88:	48 83 ec 10          	sub    $0x10,%rsp
  803a8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a90:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a98:	48 be 9d 51 80 00 00 	movabs $0x80519d,%rsi
  803a9f:	00 00 00 
  803aa2:	48 89 c7             	mov    %rax,%rdi
  803aa5:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
	return 0;
  803ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab6:	c9                   	leaveq 
  803ab7:	c3                   	retq   

0000000000803ab8 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ab8:	55                   	push   %rbp
  803ab9:	48 89 e5             	mov    %rsp,%rbp
  803abc:	48 83 ec 20          	sub    $0x20,%rsp
  803ac0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ac3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ac6:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803ac9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803acc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803acf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad2:	89 ce                	mov    %ecx,%esi
  803ad4:	89 c7                	mov    %eax,%edi
  803ad6:	48 b8 fc 3e 80 00 00 	movabs $0x803efc,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
  803ae2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae9:	79 05                	jns    803af0 <socket+0x38>
		return r;
  803aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aee:	eb 11                	jmp    803b01 <socket+0x49>
	return alloc_sockfd(r);
  803af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af3:	89 c7                	mov    %eax,%edi
  803af5:	48 b8 9a 37 80 00 00 	movabs $0x80379a,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
}
  803b01:	c9                   	leaveq 
  803b02:	c3                   	retq   

0000000000803b03 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b03:	55                   	push   %rbp
  803b04:	48 89 e5             	mov    %rsp,%rbp
  803b07:	48 83 ec 10          	sub    $0x10,%rsp
  803b0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b0e:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b15:	00 00 00 
  803b18:	8b 00                	mov    (%rax),%eax
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	75 1d                	jne    803b3b <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b1e:	bf 02 00 00 00       	mov    $0x2,%edi
  803b23:	48 b8 33 49 80 00 00 	movabs $0x804933,%rax
  803b2a:	00 00 00 
  803b2d:	ff d0                	callq  *%rax
  803b2f:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803b36:	00 00 00 
  803b39:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b3b:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b42:	00 00 00 
  803b45:	8b 00                	mov    (%rax),%eax
  803b47:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b4a:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b4f:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b56:	00 00 00 
  803b59:	89 c7                	mov    %eax,%edi
  803b5b:	48 b8 d1 48 80 00 00 	movabs $0x8048d1,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b67:	ba 00 00 00 00       	mov    $0x0,%edx
  803b6c:	be 00 00 00 00       	mov    $0x0,%esi
  803b71:	bf 00 00 00 00       	mov    $0x0,%edi
  803b76:	48 b8 cb 47 80 00 00 	movabs $0x8047cb,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
}
  803b82:	c9                   	leaveq 
  803b83:	c3                   	retq   

0000000000803b84 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b84:	55                   	push   %rbp
  803b85:	48 89 e5             	mov    %rsp,%rbp
  803b88:	48 83 ec 30          	sub    $0x30,%rsp
  803b8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b97:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b9e:	00 00 00 
  803ba1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ba4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ba6:	bf 01 00 00 00       	mov    $0x1,%edi
  803bab:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
  803bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbe:	78 3e                	js     803bfe <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803bc0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc7:	00 00 00 
  803bca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd2:	8b 40 10             	mov    0x10(%rax),%eax
  803bd5:	89 c2                	mov    %eax,%edx
  803bd7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bdf:	48 89 ce             	mov    %rcx,%rsi
  803be2:	48 89 c7             	mov    %rax,%rdi
  803be5:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803bec:	00 00 00 
  803bef:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf5:	8b 50 10             	mov    0x10(%rax),%edx
  803bf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfc:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c01:	c9                   	leaveq 
  803c02:	c3                   	retq   

0000000000803c03 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c03:	55                   	push   %rbp
  803c04:	48 89 e5             	mov    %rsp,%rbp
  803c07:	48 83 ec 10          	sub    $0x10,%rsp
  803c0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c12:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1c:	00 00 00 
  803c1f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c22:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c24:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2b:	48 89 c6             	mov    %rax,%rsi
  803c2e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c35:	00 00 00 
  803c38:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803c44:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4b:	00 00 00 
  803c4e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c51:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c54:	bf 02 00 00 00       	mov    $0x2,%edi
  803c59:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
}
  803c65:	c9                   	leaveq 
  803c66:	c3                   	retq   

0000000000803c67 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c67:	55                   	push   %rbp
  803c68:	48 89 e5             	mov    %rsp,%rbp
  803c6b:	48 83 ec 10          	sub    $0x10,%rsp
  803c6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c72:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7c:	00 00 00 
  803c7f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c82:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c84:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c8b:	00 00 00 
  803c8e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c91:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c94:	bf 03 00 00 00       	mov    $0x3,%edi
  803c99:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
}
  803ca5:	c9                   	leaveq 
  803ca6:	c3                   	retq   

0000000000803ca7 <nsipc_close>:

int
nsipc_close(int s)
{
  803ca7:	55                   	push   %rbp
  803ca8:	48 89 e5             	mov    %rsp,%rbp
  803cab:	48 83 ec 10          	sub    $0x10,%rsp
  803caf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803cb2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb9:	00 00 00 
  803cbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cbf:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803cc1:	bf 04 00 00 00       	mov    $0x4,%edi
  803cc6:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	callq  *%rax
}
  803cd2:	c9                   	leaveq 
  803cd3:	c3                   	retq   

0000000000803cd4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803cd4:	55                   	push   %rbp
  803cd5:	48 89 e5             	mov    %rsp,%rbp
  803cd8:	48 83 ec 10          	sub    $0x10,%rsp
  803cdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ce3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ce6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ced:	00 00 00 
  803cf0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cf3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803cf5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfc:	48 89 c6             	mov    %rax,%rsi
  803cff:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d06:	00 00 00 
  803d09:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1c:	00 00 00 
  803d1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d22:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d25:	bf 05 00 00 00       	mov    $0x5,%edi
  803d2a:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
}
  803d36:	c9                   	leaveq 
  803d37:	c3                   	retq   

0000000000803d38 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d38:	55                   	push   %rbp
  803d39:	48 89 e5             	mov    %rsp,%rbp
  803d3c:	48 83 ec 10          	sub    $0x10,%rsp
  803d40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d43:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803d46:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4d:	00 00 00 
  803d50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d53:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d55:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d5c:	00 00 00 
  803d5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d62:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d65:	bf 06 00 00 00       	mov    $0x6,%edi
  803d6a:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803d71:	00 00 00 
  803d74:	ff d0                	callq  *%rax
}
  803d76:	c9                   	leaveq 
  803d77:	c3                   	retq   

0000000000803d78 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d78:	55                   	push   %rbp
  803d79:	48 89 e5             	mov    %rsp,%rbp
  803d7c:	48 83 ec 30          	sub    $0x30,%rsp
  803d80:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d87:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d8a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d8d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d94:	00 00 00 
  803d97:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d9a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d9c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da3:	00 00 00 
  803da6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803da9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803dac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803db3:	00 00 00 
  803db6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803db9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803dbc:	bf 07 00 00 00       	mov    $0x7,%edi
  803dc1:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803dc8:	00 00 00 
  803dcb:	ff d0                	callq  *%rax
  803dcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd4:	78 69                	js     803e3f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803dd6:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ddd:	7f 08                	jg     803de7 <nsipc_recv+0x6f>
  803ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de2:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803de5:	7e 35                	jle    803e1c <nsipc_recv+0xa4>
  803de7:	48 b9 a4 51 80 00 00 	movabs $0x8051a4,%rcx
  803dee:	00 00 00 
  803df1:	48 ba b9 51 80 00 00 	movabs $0x8051b9,%rdx
  803df8:	00 00 00 
  803dfb:	be 61 00 00 00       	mov    $0x61,%esi
  803e00:	48 bf ce 51 80 00 00 	movabs $0x8051ce,%rdi
  803e07:	00 00 00 
  803e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0f:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803e16:	00 00 00 
  803e19:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1f:	48 63 d0             	movslq %eax,%rdx
  803e22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e26:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e2d:	00 00 00 
  803e30:	48 89 c7             	mov    %rax,%rdi
  803e33:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803e3a:	00 00 00 
  803e3d:	ff d0                	callq  *%rax
	}

	return r;
  803e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e42:	c9                   	leaveq 
  803e43:	c3                   	retq   

0000000000803e44 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e44:	55                   	push   %rbp
  803e45:	48 89 e5             	mov    %rsp,%rbp
  803e48:	48 83 ec 20          	sub    $0x20,%rsp
  803e4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e53:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e56:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e60:	00 00 00 
  803e63:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e66:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e68:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e6f:	7e 35                	jle    803ea6 <nsipc_send+0x62>
  803e71:	48 b9 da 51 80 00 00 	movabs $0x8051da,%rcx
  803e78:	00 00 00 
  803e7b:	48 ba b9 51 80 00 00 	movabs $0x8051b9,%rdx
  803e82:	00 00 00 
  803e85:	be 6c 00 00 00       	mov    $0x6c,%esi
  803e8a:	48 bf ce 51 80 00 00 	movabs $0x8051ce,%rdi
  803e91:	00 00 00 
  803e94:	b8 00 00 00 00       	mov    $0x0,%eax
  803e99:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803ea0:	00 00 00 
  803ea3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ea6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea9:	48 63 d0             	movslq %eax,%rdx
  803eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb0:	48 89 c6             	mov    %rax,%rsi
  803eb3:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803eba:	00 00 00 
  803ebd:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ec9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed0:	00 00 00 
  803ed3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ed6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803ed9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ee0:	00 00 00 
  803ee3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ee6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803ee9:	bf 08 00 00 00       	mov    $0x8,%edi
  803eee:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
}
  803efa:	c9                   	leaveq 
  803efb:	c3                   	retq   

0000000000803efc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803efc:	55                   	push   %rbp
  803efd:	48 89 e5             	mov    %rsp,%rbp
  803f00:	48 83 ec 10          	sub    $0x10,%rsp
  803f04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f07:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f0a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f0d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f14:	00 00 00 
  803f17:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f1a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f1c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f23:	00 00 00 
  803f26:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f29:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f33:	00 00 00 
  803f36:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f39:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f3c:	bf 09 00 00 00       	mov    $0x9,%edi
  803f41:	48 b8 03 3b 80 00 00 	movabs $0x803b03,%rax
  803f48:	00 00 00 
  803f4b:	ff d0                	callq  *%rax
}
  803f4d:	c9                   	leaveq 
  803f4e:	c3                   	retq   

0000000000803f4f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f4f:	55                   	push   %rbp
  803f50:	48 89 e5             	mov    %rsp,%rbp
  803f53:	53                   	push   %rbx
  803f54:	48 83 ec 38          	sub    $0x38,%rsp
  803f58:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f5c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f60:	48 89 c7             	mov    %rax,%rdi
  803f63:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  803f6a:	00 00 00 
  803f6d:	ff d0                	callq  *%rax
  803f6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f76:	0f 88 bf 01 00 00    	js     80413b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f80:	ba 07 04 00 00       	mov    $0x407,%edx
  803f85:	48 89 c6             	mov    %rax,%rsi
  803f88:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8d:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803f94:	00 00 00 
  803f97:	ff d0                	callq  *%rax
  803f99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fa0:	0f 88 95 01 00 00    	js     80413b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803fa6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803faa:	48 89 c7             	mov    %rax,%rdi
  803fad:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  803fb4:	00 00 00 
  803fb7:	ff d0                	callq  *%rax
  803fb9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fc0:	0f 88 5d 01 00 00    	js     804123 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fca:	ba 07 04 00 00       	mov    $0x407,%edx
  803fcf:	48 89 c6             	mov    %rax,%rsi
  803fd2:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd7:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fe6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fea:	0f 88 33 01 00 00    	js     804123 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff4:	48 89 c7             	mov    %rax,%rdi
  803ff7:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803ffe:	00 00 00 
  804001:	ff d0                	callq  *%rax
  804003:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804007:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400b:	ba 07 04 00 00       	mov    $0x407,%edx
  804010:	48 89 c6             	mov    %rax,%rsi
  804013:	bf 00 00 00 00       	mov    $0x0,%edi
  804018:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80401f:	00 00 00 
  804022:	ff d0                	callq  *%rax
  804024:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804027:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80402b:	79 05                	jns    804032 <pipe+0xe3>
		goto err2;
  80402d:	e9 d9 00 00 00       	jmpq   80410b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804032:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804036:	48 89 c7             	mov    %rax,%rdi
  804039:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	48 89 c2             	mov    %rax,%rdx
  804048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80404c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804052:	48 89 d1             	mov    %rdx,%rcx
  804055:	ba 00 00 00 00       	mov    $0x0,%edx
  80405a:	48 89 c6             	mov    %rax,%rsi
  80405d:	bf 00 00 00 00       	mov    $0x0,%edi
  804062:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
  80406e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804071:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804075:	79 1b                	jns    804092 <pipe+0x143>
		goto err3;
  804077:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407c:	48 89 c6             	mov    %rax,%rsi
  80407f:	bf 00 00 00 00       	mov    $0x0,%edi
  804084:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80408b:	00 00 00 
  80408e:	ff d0                	callq  *%rax
  804090:	eb 79                	jmp    80410b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804092:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804096:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80409d:	00 00 00 
  8040a0:	8b 12                	mov    (%rdx),%edx
  8040a2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8040a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8040af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040ba:	00 00 00 
  8040bd:	8b 12                	mov    (%rdx),%edx
  8040bf:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8040c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8040cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d0:	48 89 c7             	mov    %rax,%rdi
  8040d3:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  8040da:	00 00 00 
  8040dd:	ff d0                	callq  *%rax
  8040df:	89 c2                	mov    %eax,%edx
  8040e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040e5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8040e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040eb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8040ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040f3:	48 89 c7             	mov    %rax,%rdi
  8040f6:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
  804102:	89 03                	mov    %eax,(%rbx)
	return 0;
  804104:	b8 00 00 00 00       	mov    $0x0,%eax
  804109:	eb 33                	jmp    80413e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80410b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410f:	48 89 c6             	mov    %rax,%rsi
  804112:	bf 00 00 00 00       	mov    $0x0,%edi
  804117:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804123:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804127:	48 89 c6             	mov    %rax,%rsi
  80412a:	bf 00 00 00 00       	mov    $0x0,%edi
  80412f:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  804136:	00 00 00 
  804139:	ff d0                	callq  *%rax
err:
	return r;
  80413b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80413e:	48 83 c4 38          	add    $0x38,%rsp
  804142:	5b                   	pop    %rbx
  804143:	5d                   	pop    %rbp
  804144:	c3                   	retq   

0000000000804145 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804145:	55                   	push   %rbp
  804146:	48 89 e5             	mov    %rsp,%rbp
  804149:	53                   	push   %rbx
  80414a:	48 83 ec 28          	sub    $0x28,%rsp
  80414e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804152:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804156:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80415d:	00 00 00 
  804160:	48 8b 00             	mov    (%rax),%rax
  804163:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804169:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80416c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804170:	48 89 c7             	mov    %rax,%rdi
  804173:	48 b8 b5 49 80 00 00 	movabs $0x8049b5,%rax
  80417a:	00 00 00 
  80417d:	ff d0                	callq  *%rax
  80417f:	89 c3                	mov    %eax,%ebx
  804181:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804185:	48 89 c7             	mov    %rax,%rdi
  804188:	48 b8 b5 49 80 00 00 	movabs $0x8049b5,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
  804194:	39 c3                	cmp    %eax,%ebx
  804196:	0f 94 c0             	sete   %al
  804199:	0f b6 c0             	movzbl %al,%eax
  80419c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80419f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041a6:	00 00 00 
  8041a9:	48 8b 00             	mov    (%rax),%rax
  8041ac:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041b2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8041b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041bb:	75 05                	jne    8041c2 <_pipeisclosed+0x7d>
			return ret;
  8041bd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8041c0:	eb 4f                	jmp    804211 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8041c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041c8:	74 42                	je     80420c <_pipeisclosed+0xc7>
  8041ca:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8041ce:	75 3c                	jne    80420c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8041d0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041d7:	00 00 00 
  8041da:	48 8b 00             	mov    (%rax),%rax
  8041dd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8041e3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8041e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041e9:	89 c6                	mov    %eax,%esi
  8041eb:	48 bf eb 51 80 00 00 	movabs $0x8051eb,%rdi
  8041f2:	00 00 00 
  8041f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041fa:	49 b8 ce 03 80 00 00 	movabs $0x8003ce,%r8
  804201:	00 00 00 
  804204:	41 ff d0             	callq  *%r8
	}
  804207:	e9 4a ff ff ff       	jmpq   804156 <_pipeisclosed+0x11>
  80420c:	e9 45 ff ff ff       	jmpq   804156 <_pipeisclosed+0x11>
}
  804211:	48 83 c4 28          	add    $0x28,%rsp
  804215:	5b                   	pop    %rbx
  804216:	5d                   	pop    %rbp
  804217:	c3                   	retq   

0000000000804218 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804218:	55                   	push   %rbp
  804219:	48 89 e5             	mov    %rsp,%rbp
  80421c:	48 83 ec 30          	sub    $0x30,%rsp
  804220:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804223:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804227:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80422a:	48 89 d6             	mov    %rdx,%rsi
  80422d:	89 c7                	mov    %eax,%edi
  80422f:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  804236:	00 00 00 
  804239:	ff d0                	callq  *%rax
  80423b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80423e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804242:	79 05                	jns    804249 <pipeisclosed+0x31>
		return r;
  804244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804247:	eb 31                	jmp    80427a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424d:	48 89 c7             	mov    %rax,%rdi
  804250:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804257:	00 00 00 
  80425a:	ff d0                	callq  *%rax
  80425c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804264:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804268:	48 89 d6             	mov    %rdx,%rsi
  80426b:	48 89 c7             	mov    %rax,%rdi
  80426e:	48 b8 45 41 80 00 00 	movabs $0x804145,%rax
  804275:	00 00 00 
  804278:	ff d0                	callq  *%rax
}
  80427a:	c9                   	leaveq 
  80427b:	c3                   	retq   

000000000080427c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80427c:	55                   	push   %rbp
  80427d:	48 89 e5             	mov    %rsp,%rbp
  804280:	48 83 ec 40          	sub    $0x40,%rsp
  804284:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804288:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80428c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804294:	48 89 c7             	mov    %rax,%rdi
  804297:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
  8042a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042af:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042b6:	00 
  8042b7:	e9 92 00 00 00       	jmpq   80434e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8042bc:	eb 41                	jmp    8042ff <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8042be:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042c3:	74 09                	je     8042ce <devpipe_read+0x52>
				return i;
  8042c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c9:	e9 92 00 00 00       	jmpq   804360 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8042ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d6:	48 89 d6             	mov    %rdx,%rsi
  8042d9:	48 89 c7             	mov    %rax,%rdi
  8042dc:	48 b8 45 41 80 00 00 	movabs $0x804145,%rax
  8042e3:	00 00 00 
  8042e6:	ff d0                	callq  *%rax
  8042e8:	85 c0                	test   %eax,%eax
  8042ea:	74 07                	je     8042f3 <devpipe_read+0x77>
				return 0;
  8042ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f1:	eb 6d                	jmp    804360 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8042f3:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8042fa:	00 00 00 
  8042fd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8042ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804303:	8b 10                	mov    (%rax),%edx
  804305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804309:	8b 40 04             	mov    0x4(%rax),%eax
  80430c:	39 c2                	cmp    %eax,%edx
  80430e:	74 ae                	je     8042be <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804314:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804318:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80431c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804320:	8b 00                	mov    (%rax),%eax
  804322:	99                   	cltd   
  804323:	c1 ea 1b             	shr    $0x1b,%edx
  804326:	01 d0                	add    %edx,%eax
  804328:	83 e0 1f             	and    $0x1f,%eax
  80432b:	29 d0                	sub    %edx,%eax
  80432d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804331:	48 98                	cltq   
  804333:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804338:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80433a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433e:	8b 00                	mov    (%rax),%eax
  804340:	8d 50 01             	lea    0x1(%rax),%edx
  804343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804347:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80434e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804352:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804356:	0f 82 60 ff ff ff    	jb     8042bc <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80435c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804360:	c9                   	leaveq 
  804361:	c3                   	retq   

0000000000804362 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804362:	55                   	push   %rbp
  804363:	48 89 e5             	mov    %rsp,%rbp
  804366:	48 83 ec 40          	sub    $0x40,%rsp
  80436a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80436e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804372:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80437a:	48 89 c7             	mov    %rax,%rdi
  80437d:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804384:	00 00 00 
  804387:	ff d0                	callq  *%rax
  804389:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80438d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804391:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804395:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80439c:	00 
  80439d:	e9 8e 00 00 00       	jmpq   804430 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043a2:	eb 31                	jmp    8043d5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8043a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ac:	48 89 d6             	mov    %rdx,%rsi
  8043af:	48 89 c7             	mov    %rax,%rdi
  8043b2:	48 b8 45 41 80 00 00 	movabs $0x804145,%rax
  8043b9:	00 00 00 
  8043bc:	ff d0                	callq  *%rax
  8043be:	85 c0                	test   %eax,%eax
  8043c0:	74 07                	je     8043c9 <devpipe_write+0x67>
				return 0;
  8043c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c7:	eb 79                	jmp    804442 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8043c9:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8043d0:	00 00 00 
  8043d3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d9:	8b 40 04             	mov    0x4(%rax),%eax
  8043dc:	48 63 d0             	movslq %eax,%rdx
  8043df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e3:	8b 00                	mov    (%rax),%eax
  8043e5:	48 98                	cltq   
  8043e7:	48 83 c0 20          	add    $0x20,%rax
  8043eb:	48 39 c2             	cmp    %rax,%rdx
  8043ee:	73 b4                	jae    8043a4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8043f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f4:	8b 40 04             	mov    0x4(%rax),%eax
  8043f7:	99                   	cltd   
  8043f8:	c1 ea 1b             	shr    $0x1b,%edx
  8043fb:	01 d0                	add    %edx,%eax
  8043fd:	83 e0 1f             	and    $0x1f,%eax
  804400:	29 d0                	sub    %edx,%eax
  804402:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804406:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80440a:	48 01 ca             	add    %rcx,%rdx
  80440d:	0f b6 0a             	movzbl (%rdx),%ecx
  804410:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804414:	48 98                	cltq   
  804416:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80441a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441e:	8b 40 04             	mov    0x4(%rax),%eax
  804421:	8d 50 01             	lea    0x1(%rax),%edx
  804424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804428:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80442b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804434:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804438:	0f 82 64 ff ff ff    	jb     8043a2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80443e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804442:	c9                   	leaveq 
  804443:	c3                   	retq   

0000000000804444 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804444:	55                   	push   %rbp
  804445:	48 89 e5             	mov    %rsp,%rbp
  804448:	48 83 ec 20          	sub    $0x20,%rsp
  80444c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804450:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804458:	48 89 c7             	mov    %rax,%rdi
  80445b:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
  804467:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80446b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80446f:	48 be fe 51 80 00 00 	movabs $0x8051fe,%rsi
  804476:	00 00 00 
  804479:	48 89 c7             	mov    %rax,%rdi
  80447c:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  804483:	00 00 00 
  804486:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448c:	8b 50 04             	mov    0x4(%rax),%edx
  80448f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804493:	8b 00                	mov    (%rax),%eax
  804495:	29 c2                	sub    %eax,%edx
  804497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80449b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8044a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8044ac:	00 00 00 
	stat->st_dev = &devpipe;
  8044af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b3:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8044ba:	00 00 00 
  8044bd:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8044c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044c9:	c9                   	leaveq 
  8044ca:	c3                   	retq   

00000000008044cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8044cb:	55                   	push   %rbp
  8044cc:	48 89 e5             	mov    %rsp,%rbp
  8044cf:	48 83 ec 10          	sub    $0x10,%rsp
  8044d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8044d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044db:	48 89 c6             	mov    %rax,%rsi
  8044de:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e3:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8044ea:	00 00 00 
  8044ed:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8044ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f3:	48 89 c7             	mov    %rax,%rdi
  8044f6:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  8044fd:	00 00 00 
  804500:	ff d0                	callq  *%rax
  804502:	48 89 c6             	mov    %rax,%rsi
  804505:	bf 00 00 00 00       	mov    $0x0,%edi
  80450a:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  804511:	00 00 00 
  804514:	ff d0                	callq  *%rax
}
  804516:	c9                   	leaveq 
  804517:	c3                   	retq   

0000000000804518 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804518:	55                   	push   %rbp
  804519:	48 89 e5             	mov    %rsp,%rbp
  80451c:	48 83 ec 20          	sub    $0x20,%rsp
  804520:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804523:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804526:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804529:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80452d:	be 01 00 00 00       	mov    $0x1,%esi
  804532:	48 89 c7             	mov    %rax,%rdi
  804535:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  80453c:	00 00 00 
  80453f:	ff d0                	callq  *%rax
}
  804541:	c9                   	leaveq 
  804542:	c3                   	retq   

0000000000804543 <getchar>:

int
getchar(void)
{
  804543:	55                   	push   %rbp
  804544:	48 89 e5             	mov    %rsp,%rbp
  804547:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80454b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80454f:	ba 01 00 00 00       	mov    $0x1,%edx
  804554:	48 89 c6             	mov    %rax,%rsi
  804557:	bf 00 00 00 00       	mov    $0x0,%edi
  80455c:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  804563:	00 00 00 
  804566:	ff d0                	callq  *%rax
  804568:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80456b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456f:	79 05                	jns    804576 <getchar+0x33>
		return r;
  804571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804574:	eb 14                	jmp    80458a <getchar+0x47>
	if (r < 1)
  804576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80457a:	7f 07                	jg     804583 <getchar+0x40>
		return -E_EOF;
  80457c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804581:	eb 07                	jmp    80458a <getchar+0x47>
	return c;
  804583:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804587:	0f b6 c0             	movzbl %al,%eax
}
  80458a:	c9                   	leaveq 
  80458b:	c3                   	retq   

000000000080458c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80458c:	55                   	push   %rbp
  80458d:	48 89 e5             	mov    %rsp,%rbp
  804590:	48 83 ec 20          	sub    $0x20,%rsp
  804594:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804597:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80459b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80459e:	48 89 d6             	mov    %rdx,%rsi
  8045a1:	89 c7                	mov    %eax,%edi
  8045a3:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
  8045af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b6:	79 05                	jns    8045bd <iscons+0x31>
		return r;
  8045b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045bb:	eb 1a                	jmp    8045d7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8045bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c1:	8b 10                	mov    (%rax),%edx
  8045c3:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8045ca:	00 00 00 
  8045cd:	8b 00                	mov    (%rax),%eax
  8045cf:	39 c2                	cmp    %eax,%edx
  8045d1:	0f 94 c0             	sete   %al
  8045d4:	0f b6 c0             	movzbl %al,%eax
}
  8045d7:	c9                   	leaveq 
  8045d8:	c3                   	retq   

00000000008045d9 <opencons>:

int
opencons(void)
{
  8045d9:	55                   	push   %rbp
  8045da:	48 89 e5             	mov    %rsp,%rbp
  8045dd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8045e1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8045e5:	48 89 c7             	mov    %rax,%rdi
  8045e8:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  8045ef:	00 00 00 
  8045f2:	ff d0                	callq  *%rax
  8045f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045fb:	79 05                	jns    804602 <opencons+0x29>
		return r;
  8045fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804600:	eb 5b                	jmp    80465d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804606:	ba 07 04 00 00       	mov    $0x407,%edx
  80460b:	48 89 c6             	mov    %rax,%rsi
  80460e:	bf 00 00 00 00       	mov    $0x0,%edi
  804613:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80461a:	00 00 00 
  80461d:	ff d0                	callq  *%rax
  80461f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804622:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804626:	79 05                	jns    80462d <opencons+0x54>
		return r;
  804628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80462b:	eb 30                	jmp    80465d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80462d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804631:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804638:	00 00 00 
  80463b:	8b 12                	mov    (%rdx),%edx
  80463d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80463f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804643:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80464a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80464e:	48 89 c7             	mov    %rax,%rdi
  804651:	48 b8 eb 1b 80 00 00 	movabs $0x801beb,%rax
  804658:	00 00 00 
  80465b:	ff d0                	callq  *%rax
}
  80465d:	c9                   	leaveq 
  80465e:	c3                   	retq   

000000000080465f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80465f:	55                   	push   %rbp
  804660:	48 89 e5             	mov    %rsp,%rbp
  804663:	48 83 ec 30          	sub    $0x30,%rsp
  804667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80466b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80466f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804673:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804678:	75 07                	jne    804681 <devcons_read+0x22>
		return 0;
  80467a:	b8 00 00 00 00       	mov    $0x0,%eax
  80467f:	eb 4b                	jmp    8046cc <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804681:	eb 0c                	jmp    80468f <devcons_read+0x30>
		sys_yield();
  804683:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80468f:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  804696:	00 00 00 
  804699:	ff d0                	callq  *%rax
  80469b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80469e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a2:	74 df                	je     804683 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8046a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a8:	79 05                	jns    8046af <devcons_read+0x50>
		return c;
  8046aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ad:	eb 1d                	jmp    8046cc <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8046af:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046b3:	75 07                	jne    8046bc <devcons_read+0x5d>
		return 0;
  8046b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ba:	eb 10                	jmp    8046cc <devcons_read+0x6d>
	*(char*)vbuf = c;
  8046bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046bf:	89 c2                	mov    %eax,%edx
  8046c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046c5:	88 10                	mov    %dl,(%rax)
	return 1;
  8046c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8046cc:	c9                   	leaveq 
  8046cd:	c3                   	retq   

00000000008046ce <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046ce:	55                   	push   %rbp
  8046cf:	48 89 e5             	mov    %rsp,%rbp
  8046d2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8046d9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8046e0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8046e7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046f5:	eb 76                	jmp    80476d <devcons_write+0x9f>
		m = n - tot;
  8046f7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8046fe:	89 c2                	mov    %eax,%edx
  804700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804703:	29 c2                	sub    %eax,%edx
  804705:	89 d0                	mov    %edx,%eax
  804707:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80470a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80470d:	83 f8 7f             	cmp    $0x7f,%eax
  804710:	76 07                	jbe    804719 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804712:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804719:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80471c:	48 63 d0             	movslq %eax,%rdx
  80471f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804722:	48 63 c8             	movslq %eax,%rcx
  804725:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80472c:	48 01 c1             	add    %rax,%rcx
  80472f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804736:	48 89 ce             	mov    %rcx,%rsi
  804739:	48 89 c7             	mov    %rax,%rdi
  80473c:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  804743:	00 00 00 
  804746:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804748:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80474b:	48 63 d0             	movslq %eax,%rdx
  80474e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804755:	48 89 d6             	mov    %rdx,%rsi
  804758:	48 89 c7             	mov    %rax,%rdi
  80475b:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  804762:	00 00 00 
  804765:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804767:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80476a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80476d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804770:	48 98                	cltq   
  804772:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804779:	0f 82 78 ff ff ff    	jb     8046f7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80477f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804782:	c9                   	leaveq 
  804783:	c3                   	retq   

0000000000804784 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804784:	55                   	push   %rbp
  804785:	48 89 e5             	mov    %rsp,%rbp
  804788:	48 83 ec 08          	sub    $0x8,%rsp
  80478c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804790:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804795:	c9                   	leaveq 
  804796:	c3                   	retq   

0000000000804797 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804797:	55                   	push   %rbp
  804798:	48 89 e5             	mov    %rsp,%rbp
  80479b:	48 83 ec 10          	sub    $0x10,%rsp
  80479f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ab:	48 be 0a 52 80 00 00 	movabs $0x80520a,%rsi
  8047b2:	00 00 00 
  8047b5:	48 89 c7             	mov    %rax,%rdi
  8047b8:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8047bf:	00 00 00 
  8047c2:	ff d0                	callq  *%rax
	return 0;
  8047c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047c9:	c9                   	leaveq 
  8047ca:	c3                   	retq   

00000000008047cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8047cb:	55                   	push   %rbp
  8047cc:	48 89 e5             	mov    %rsp,%rbp
  8047cf:	48 83 ec 30          	sub    $0x30,%rsp
  8047d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8047df:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8047e6:	00 00 00 
  8047e9:	48 8b 00             	mov    (%rax),%rax
  8047ec:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8047f2:	85 c0                	test   %eax,%eax
  8047f4:	75 3c                	jne    804832 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8047f6:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8047fd:	00 00 00 
  804800:	ff d0                	callq  *%rax
  804802:	25 ff 03 00 00       	and    $0x3ff,%eax
  804807:	48 63 d0             	movslq %eax,%rdx
  80480a:	48 89 d0             	mov    %rdx,%rax
  80480d:	48 c1 e0 03          	shl    $0x3,%rax
  804811:	48 01 d0             	add    %rdx,%rax
  804814:	48 c1 e0 05          	shl    $0x5,%rax
  804818:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80481f:	00 00 00 
  804822:	48 01 c2             	add    %rax,%rdx
  804825:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80482c:	00 00 00 
  80482f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804832:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804837:	75 0e                	jne    804847 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804839:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804840:	00 00 00 
  804843:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804847:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80484b:	48 89 c7             	mov    %rax,%rdi
  80484e:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  804855:	00 00 00 
  804858:	ff d0                	callq  *%rax
  80485a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80485d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804861:	79 19                	jns    80487c <ipc_recv+0xb1>
		*from_env_store = 0;
  804863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804867:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80486d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804871:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80487a:	eb 53                	jmp    8048cf <ipc_recv+0x104>
	}
	if(from_env_store)
  80487c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804881:	74 19                	je     80489c <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804883:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80488a:	00 00 00 
  80488d:	48 8b 00             	mov    (%rax),%rax
  804890:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80489a:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80489c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048a1:	74 19                	je     8048bc <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8048a3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048aa:	00 00 00 
  8048ad:	48 8b 00             	mov    (%rax),%rax
  8048b0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8048b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ba:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8048bc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048c3:	00 00 00 
  8048c6:	48 8b 00             	mov    (%rax),%rax
  8048c9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8048cf:	c9                   	leaveq 
  8048d0:	c3                   	retq   

00000000008048d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8048d1:	55                   	push   %rbp
  8048d2:	48 89 e5             	mov    %rsp,%rbp
  8048d5:	48 83 ec 30          	sub    $0x30,%rsp
  8048d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8048df:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8048e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8048e6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048eb:	75 0e                	jne    8048fb <ipc_send+0x2a>
		pg = (void*)UTOP;
  8048ed:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048f4:	00 00 00 
  8048f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8048fb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048fe:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804901:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804905:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804908:	89 c7                	mov    %eax,%edi
  80490a:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  804911:	00 00 00 
  804914:	ff d0                	callq  *%rax
  804916:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804919:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80491d:	75 0c                	jne    80492b <ipc_send+0x5a>
			sys_yield();
  80491f:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  804926:	00 00 00 
  804929:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80492b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80492f:	74 ca                	je     8048fb <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804931:	c9                   	leaveq 
  804932:	c3                   	retq   

0000000000804933 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804933:	55                   	push   %rbp
  804934:	48 89 e5             	mov    %rsp,%rbp
  804937:	48 83 ec 14          	sub    $0x14,%rsp
  80493b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80493e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804945:	eb 5e                	jmp    8049a5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804947:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80494e:	00 00 00 
  804951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804954:	48 63 d0             	movslq %eax,%rdx
  804957:	48 89 d0             	mov    %rdx,%rax
  80495a:	48 c1 e0 03          	shl    $0x3,%rax
  80495e:	48 01 d0             	add    %rdx,%rax
  804961:	48 c1 e0 05          	shl    $0x5,%rax
  804965:	48 01 c8             	add    %rcx,%rax
  804968:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80496e:	8b 00                	mov    (%rax),%eax
  804970:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804973:	75 2c                	jne    8049a1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804975:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80497c:	00 00 00 
  80497f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804982:	48 63 d0             	movslq %eax,%rdx
  804985:	48 89 d0             	mov    %rdx,%rax
  804988:	48 c1 e0 03          	shl    $0x3,%rax
  80498c:	48 01 d0             	add    %rdx,%rax
  80498f:	48 c1 e0 05          	shl    $0x5,%rax
  804993:	48 01 c8             	add    %rcx,%rax
  804996:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80499c:	8b 40 08             	mov    0x8(%rax),%eax
  80499f:	eb 12                	jmp    8049b3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8049a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049a5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8049ac:	7e 99                	jle    804947 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8049ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049b3:	c9                   	leaveq 
  8049b4:	c3                   	retq   

00000000008049b5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8049b5:	55                   	push   %rbp
  8049b6:	48 89 e5             	mov    %rsp,%rbp
  8049b9:	48 83 ec 18          	sub    $0x18,%rsp
  8049bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8049c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049c5:	48 c1 e8 15          	shr    $0x15,%rax
  8049c9:	48 89 c2             	mov    %rax,%rdx
  8049cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8049d3:	01 00 00 
  8049d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049da:	83 e0 01             	and    $0x1,%eax
  8049dd:	48 85 c0             	test   %rax,%rax
  8049e0:	75 07                	jne    8049e9 <pageref+0x34>
		return 0;
  8049e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8049e7:	eb 53                	jmp    804a3c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8049e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8049f1:	48 89 c2             	mov    %rax,%rdx
  8049f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049fb:	01 00 00 
  8049fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a0a:	83 e0 01             	and    $0x1,%eax
  804a0d:	48 85 c0             	test   %rax,%rax
  804a10:	75 07                	jne    804a19 <pageref+0x64>
		return 0;
  804a12:	b8 00 00 00 00       	mov    $0x0,%eax
  804a17:	eb 23                	jmp    804a3c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a1d:	48 c1 e8 0c          	shr    $0xc,%rax
  804a21:	48 89 c2             	mov    %rax,%rdx
  804a24:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a2b:	00 00 00 
  804a2e:	48 c1 e2 04          	shl    $0x4,%rdx
  804a32:	48 01 d0             	add    %rdx,%rax
  804a35:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804a39:	0f b7 c0             	movzwl %ax,%eax
}
  804a3c:	c9                   	leaveq 
  804a3d:	c3                   	retq   
