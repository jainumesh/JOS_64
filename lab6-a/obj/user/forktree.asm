
obj/user/forktree.debug:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 60 47 80 00 00 	movabs $0x804760,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 a0 0d 80 00 00 	movabs $0x800da0,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 65 47 80 00 00 	movabs $0x804765,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf 76 47 80 00 00 	movabs $0x804776,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800174:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	25 ff 03 00 00       	and    $0x3ff,%eax
  800185:	48 63 d0             	movslq %eax,%rdx
  800188:	48 89 d0             	mov    %rdx,%rax
  80018b:	48 c1 e0 03          	shl    $0x3,%rax
  80018f:	48 01 d0             	add    %rdx,%rax
  800192:	48 c1 e0 05          	shl    $0x5,%rax
  800196:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80019d:	00 00 00 
  8001a0:	48 01 c2             	add    %rax,%rdx
  8001a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001aa:	00 00 00 
  8001ad:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b4:	7e 14                	jle    8001ca <libmain+0x65>
		binaryname = argv[0];
  8001b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ba:	48 8b 10             	mov    (%rax),%rdx
  8001bd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c4:	00 00 00 
  8001c7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d1:	48 89 d6             	mov    %rdx,%rsi
  8001d4:	89 c7                	mov    %eax,%edi
  8001d6:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001e2:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
}
  8001ee:	c9                   	leaveq 
  8001ef:	c3                   	retq   

00000000008001f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f4:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800200:	bf 00 00 00 00       	mov    $0x0,%edi
  800205:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax

}
  800211:	5d                   	pop    %rbp
  800212:	c3                   	retq   

0000000000800213 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 83 ec 10          	sub    $0x10,%rsp
  80021b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80021e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800226:	8b 00                	mov    (%rax),%eax
  800228:	8d 48 01             	lea    0x1(%rax),%ecx
  80022b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022f:	89 0a                	mov    %ecx,(%rdx)
  800231:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800234:	89 d1                	mov    %edx,%ecx
  800236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023a:	48 98                	cltq   
  80023c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	8b 00                	mov    (%rax),%eax
  800246:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024b:	75 2c                	jne    800279 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80024d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800251:	8b 00                	mov    (%rax),%eax
  800253:	48 98                	cltq   
  800255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800259:	48 83 c2 08          	add    $0x8,%rdx
  80025d:	48 89 c6             	mov    %rax,%rsi
  800260:	48 89 d7             	mov    %rdx,%rdi
  800263:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
        b->idx = 0;
  80026f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800273:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027d:	8b 40 04             	mov    0x4(%rax),%eax
  800280:	8d 50 01             	lea    0x1(%rax),%edx
  800283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800287:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028a:	c9                   	leaveq 
  80028b:	c3                   	retq   

000000000080028c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800297:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80029e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002a5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002ac:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b3:	48 8b 0a             	mov    (%rdx),%rcx
  8002b6:	48 89 08             	mov    %rcx,(%rax)
  8002b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d0:	00 00 00 
    b.cnt = 0;
  8002d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002da:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002dd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002eb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f2:	48 89 c6             	mov    %rax,%rsi
  8002f5:	48 bf 13 02 80 00 00 	movabs $0x800213,%rdi
  8002fc:	00 00 00 
  8002ff:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80030b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800311:	48 98                	cltq   
  800313:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031a:	48 83 c2 08          	add    $0x8,%rdx
  80031e:	48 89 c6             	mov    %rax,%rsi
  800321:	48 89 d7             	mov    %rdx,%rdi
  800324:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800330:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800343:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80034a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800351:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800358:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80035f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800366:	84 c0                	test   %al,%al
  800368:	74 20                	je     80038a <cprintf+0x52>
  80036a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80036e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800372:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800376:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80037a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80037e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800382:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800386:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80038a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800391:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800398:	00 00 00 
  80039b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a2:	00 00 00 
  8003a5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003b7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003be:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003c5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003cc:	48 8b 0a             	mov    (%rdx),%rcx
  8003cf:	48 89 08             	mov    %rcx,(%rax)
  8003d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003de:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003e2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f0:	48 89 d6             	mov    %rdx,%rsi
  8003f3:	48 89 c7             	mov    %rax,%rdi
  8003f6:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  8003fd:	00 00 00 
  800400:	ff d0                	callq  *%rax
  800402:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800408:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80040e:	c9                   	leaveq 
  80040f:	c3                   	retq   

0000000000800410 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	53                   	push   %rbx
  800415:	48 83 ec 38          	sub    $0x38,%rsp
  800419:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80041d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800421:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800425:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800428:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80042c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800433:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800437:	77 3b                	ja     800474 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800439:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80043c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800440:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	48 f7 f3             	div    %rbx
  80044f:	48 89 c2             	mov    %rax,%rdx
  800452:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800455:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800458:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80045c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800460:	41 89 f9             	mov    %edi,%r9d
  800463:	48 89 c7             	mov    %rax,%rdi
  800466:	48 b8 10 04 80 00 00 	movabs $0x800410,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
  800472:	eb 1e                	jmp    800492 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800474:	eb 12                	jmp    800488 <printnum+0x78>
			putch(padc, putdat);
  800476:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80047a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	48 89 ce             	mov    %rcx,%rsi
  800484:	89 d7                	mov    %edx,%edi
  800486:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800488:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80048c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800490:	7f e4                	jg     800476 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800492:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	48 f7 f1             	div    %rcx
  8004a1:	48 89 d0             	mov    %rdx,%rax
  8004a4:	48 ba 90 49 80 00 00 	movabs $0x804990,%rdx
  8004ab:	00 00 00 
  8004ae:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b2:	0f be d0             	movsbl %al,%edx
  8004b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	48 89 ce             	mov    %rcx,%rsi
  8004c0:	89 d7                	mov    %edx,%edi
  8004c2:	ff d0                	callq  *%rax
}
  8004c4:	48 83 c4 38          	add    $0x38,%rsp
  8004c8:	5b                   	pop    %rbx
  8004c9:	5d                   	pop    %rbp
  8004ca:	c3                   	retq   

00000000008004cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cb:	55                   	push   %rbp
  8004cc:	48 89 e5             	mov    %rsp,%rbp
  8004cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004de:	7e 52                	jle    800532 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e4:	8b 00                	mov    (%rax),%eax
  8004e6:	83 f8 30             	cmp    $0x30,%eax
  8004e9:	73 24                	jae    80050f <getuint+0x44>
  8004eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	8b 00                	mov    (%rax),%eax
  8004f9:	89 c0                	mov    %eax,%eax
  8004fb:	48 01 d0             	add    %rdx,%rax
  8004fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800502:	8b 12                	mov    (%rdx),%edx
  800504:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050b:	89 0a                	mov    %ecx,(%rdx)
  80050d:	eb 17                	jmp    800526 <getuint+0x5b>
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800517:	48 89 d0             	mov    %rdx,%rax
  80051a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800522:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800526:	48 8b 00             	mov    (%rax),%rax
  800529:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052d:	e9 a3 00 00 00       	jmpq   8005d5 <getuint+0x10a>
	else if (lflag)
  800532:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800536:	74 4f                	je     800587 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	8b 00                	mov    (%rax),%eax
  80053e:	83 f8 30             	cmp    $0x30,%eax
  800541:	73 24                	jae    800567 <getuint+0x9c>
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	89 c0                	mov    %eax,%eax
  800553:	48 01 d0             	add    %rdx,%rax
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	8b 12                	mov    (%rdx),%edx
  80055c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	89 0a                	mov    %ecx,(%rdx)
  800565:	eb 17                	jmp    80057e <getuint+0xb3>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80056f:	48 89 d0             	mov    %rdx,%rax
  800572:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800576:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057e:	48 8b 00             	mov    (%rax),%rax
  800581:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800585:	eb 4e                	jmp    8005d5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	83 f8 30             	cmp    $0x30,%eax
  800590:	73 24                	jae    8005b6 <getuint+0xeb>
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	8b 00                	mov    (%rax),%eax
  8005a0:	89 c0                	mov    %eax,%eax
  8005a2:	48 01 d0             	add    %rdx,%rax
  8005a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a9:	8b 12                	mov    (%rdx),%edx
  8005ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	89 0a                	mov    %ecx,(%rdx)
  8005b4:	eb 17                	jmp    8005cd <getuint+0x102>
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005be:	48 89 d0             	mov    %rdx,%rax
  8005c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cd:	8b 00                	mov    (%rax),%eax
  8005cf:	89 c0                	mov    %eax,%eax
  8005d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d9:	c9                   	leaveq 
  8005da:	c3                   	retq   

00000000008005db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005db:	55                   	push   %rbp
  8005dc:	48 89 e5             	mov    %rsp,%rbp
  8005df:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005ea:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ee:	7e 52                	jle    800642 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	8b 00                	mov    (%rax),%eax
  8005f6:	83 f8 30             	cmp    $0x30,%eax
  8005f9:	73 24                	jae    80061f <getint+0x44>
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800607:	8b 00                	mov    (%rax),%eax
  800609:	89 c0                	mov    %eax,%eax
  80060b:	48 01 d0             	add    %rdx,%rax
  80060e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800612:	8b 12                	mov    (%rdx),%edx
  800614:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061b:	89 0a                	mov    %ecx,(%rdx)
  80061d:	eb 17                	jmp    800636 <getint+0x5b>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800627:	48 89 d0             	mov    %rdx,%rax
  80062a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800636:	48 8b 00             	mov    (%rax),%rax
  800639:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063d:	e9 a3 00 00 00       	jmpq   8006e5 <getint+0x10a>
	else if (lflag)
  800642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800646:	74 4f                	je     800697 <getint+0xbc>
		x=va_arg(*ap, long);
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	83 f8 30             	cmp    $0x30,%eax
  800651:	73 24                	jae    800677 <getint+0x9c>
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	89 c0                	mov    %eax,%eax
  800663:	48 01 d0             	add    %rdx,%rax
  800666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066a:	8b 12                	mov    (%rdx),%edx
  80066c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	89 0a                	mov    %ecx,(%rdx)
  800675:	eb 17                	jmp    80068e <getint+0xb3>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067f:	48 89 d0             	mov    %rdx,%rax
  800682:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068e:	48 8b 00             	mov    (%rax),%rax
  800691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800695:	eb 4e                	jmp    8006e5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	83 f8 30             	cmp    $0x30,%eax
  8006a0:	73 24                	jae    8006c6 <getint+0xeb>
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ae:	8b 00                	mov    (%rax),%eax
  8006b0:	89 c0                	mov    %eax,%eax
  8006b2:	48 01 d0             	add    %rdx,%rax
  8006b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b9:	8b 12                	mov    (%rdx),%edx
  8006bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	89 0a                	mov    %ecx,(%rdx)
  8006c4:	eb 17                	jmp    8006dd <getint+0x102>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ce:	48 89 d0             	mov    %rdx,%rax
  8006d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006dd:	8b 00                	mov    (%rax),%eax
  8006df:	48 98                	cltq   
  8006e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e9:	c9                   	leaveq 
  8006ea:	c3                   	retq   

00000000008006eb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006eb:	55                   	push   %rbp
  8006ec:	48 89 e5             	mov    %rsp,%rbp
  8006ef:	41 54                	push   %r12
  8006f1:	53                   	push   %rbx
  8006f2:	48 83 ec 60          	sub    $0x60,%rsp
  8006f6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006fa:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800702:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800706:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80070a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80070e:	48 8b 0a             	mov    (%rdx),%rcx
  800711:	48 89 08             	mov    %rcx,(%rax)
  800714:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800718:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800720:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800724:	eb 17                	jmp    80073d <vprintfmt+0x52>
			if (ch == '\0')
  800726:	85 db                	test   %ebx,%ebx
  800728:	0f 84 cc 04 00 00    	je     800bfa <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80072e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800732:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800736:	48 89 d6             	mov    %rdx,%rsi
  800739:	89 df                	mov    %ebx,%edi
  80073b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800741:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800745:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800749:	0f b6 00             	movzbl (%rax),%eax
  80074c:	0f b6 d8             	movzbl %al,%ebx
  80074f:	83 fb 25             	cmp    $0x25,%ebx
  800752:	75 d2                	jne    800726 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800754:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800758:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80075f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800766:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80076d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800774:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800778:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80077c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800780:	0f b6 00             	movzbl (%rax),%eax
  800783:	0f b6 d8             	movzbl %al,%ebx
  800786:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800789:	83 f8 55             	cmp    $0x55,%eax
  80078c:	0f 87 34 04 00 00    	ja     800bc6 <vprintfmt+0x4db>
  800792:	89 c0                	mov    %eax,%eax
  800794:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80079b:	00 
  80079c:	48 b8 b8 49 80 00 00 	movabs $0x8049b8,%rax
  8007a3:	00 00 00 
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	48 8b 00             	mov    (%rax),%rax
  8007ac:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007ae:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007b2:	eb c0                	jmp    800774 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007b8:	eb ba                	jmp    800774 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007c1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	c1 e0 02             	shl    $0x2,%eax
  8007c9:	01 d0                	add    %edx,%eax
  8007cb:	01 c0                	add    %eax,%eax
  8007cd:	01 d8                	add    %ebx,%eax
  8007cf:	83 e8 30             	sub    $0x30,%eax
  8007d2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d9:	0f b6 00             	movzbl (%rax),%eax
  8007dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007df:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e2:	7e 0c                	jle    8007f0 <vprintfmt+0x105>
  8007e4:	83 fb 39             	cmp    $0x39,%ebx
  8007e7:	7f 07                	jg     8007f0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ee:	eb d1                	jmp    8007c1 <vprintfmt+0xd6>
			goto process_precision;
  8007f0:	eb 58                	jmp    80084a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f5:	83 f8 30             	cmp    $0x30,%eax
  8007f8:	73 17                	jae    800811 <vprintfmt+0x126>
  8007fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800809:	83 c2 08             	add    $0x8,%edx
  80080c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080f:	eb 0f                	jmp    800820 <vprintfmt+0x135>
  800811:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 83 c2 08          	add    $0x8,%rdx
  80081c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800820:	8b 00                	mov    (%rax),%eax
  800822:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800825:	eb 23                	jmp    80084a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800827:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80082b:	79 0c                	jns    800839 <vprintfmt+0x14e>
				width = 0;
  80082d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800834:	e9 3b ff ff ff       	jmpq   800774 <vprintfmt+0x89>
  800839:	e9 36 ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80083e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800845:	e9 2a ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80084a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80084e:	79 12                	jns    800862 <vprintfmt+0x177>
				width = precision, precision = -1;
  800850:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800853:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800856:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80085d:	e9 12 ff ff ff       	jmpq   800774 <vprintfmt+0x89>
  800862:	e9 0d ff ff ff       	jmpq   800774 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800867:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80086b:	e9 04 ff ff ff       	jmpq   800774 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800870:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800873:	83 f8 30             	cmp    $0x30,%eax
  800876:	73 17                	jae    80088f <vprintfmt+0x1a4>
  800878:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80087c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800887:	83 c2 08             	add    $0x8,%edx
  80088a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088d:	eb 0f                	jmp    80089e <vprintfmt+0x1b3>
  80088f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800893:	48 89 d0             	mov    %rdx,%rax
  800896:	48 83 c2 08          	add    $0x8,%rdx
  80089a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089e:	8b 10                	mov    (%rax),%edx
  8008a0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a8:	48 89 ce             	mov    %rcx,%rsi
  8008ab:	89 d7                	mov    %edx,%edi
  8008ad:	ff d0                	callq  *%rax
			break;
  8008af:	e9 40 03 00 00       	jmpq   800bf4 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	83 f8 30             	cmp    $0x30,%eax
  8008ba:	73 17                	jae    8008d3 <vprintfmt+0x1e8>
  8008bc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c3:	89 c0                	mov    %eax,%eax
  8008c5:	48 01 d0             	add    %rdx,%rax
  8008c8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008cb:	83 c2 08             	add    $0x8,%edx
  8008ce:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d1:	eb 0f                	jmp    8008e2 <vprintfmt+0x1f7>
  8008d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d7:	48 89 d0             	mov    %rdx,%rax
  8008da:	48 83 c2 08          	add    $0x8,%rdx
  8008de:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008e4:	85 db                	test   %ebx,%ebx
  8008e6:	79 02                	jns    8008ea <vprintfmt+0x1ff>
				err = -err;
  8008e8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ea:	83 fb 15             	cmp    $0x15,%ebx
  8008ed:	7f 16                	jg     800905 <vprintfmt+0x21a>
  8008ef:	48 b8 e0 48 80 00 00 	movabs $0x8048e0,%rax
  8008f6:	00 00 00 
  8008f9:	48 63 d3             	movslq %ebx,%rdx
  8008fc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800900:	4d 85 e4             	test   %r12,%r12
  800903:	75 2e                	jne    800933 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800905:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800909:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090d:	89 d9                	mov    %ebx,%ecx
  80090f:	48 ba a1 49 80 00 00 	movabs $0x8049a1,%rdx
  800916:	00 00 00 
  800919:	48 89 c7             	mov    %rax,%rdi
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	49 b8 03 0c 80 00 00 	movabs $0x800c03,%r8
  800928:	00 00 00 
  80092b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092e:	e9 c1 02 00 00       	jmpq   800bf4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800933:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800937:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093b:	4c 89 e1             	mov    %r12,%rcx
  80093e:	48 ba aa 49 80 00 00 	movabs $0x8049aa,%rdx
  800945:	00 00 00 
  800948:	48 89 c7             	mov    %rax,%rdi
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	49 b8 03 0c 80 00 00 	movabs $0x800c03,%r8
  800957:	00 00 00 
  80095a:	41 ff d0             	callq  *%r8
			break;
  80095d:	e9 92 02 00 00       	jmpq   800bf4 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	83 f8 30             	cmp    $0x30,%eax
  800968:	73 17                	jae    800981 <vprintfmt+0x296>
  80096a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80096e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800971:	89 c0                	mov    %eax,%eax
  800973:	48 01 d0             	add    %rdx,%rax
  800976:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800979:	83 c2 08             	add    $0x8,%edx
  80097c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80097f:	eb 0f                	jmp    800990 <vprintfmt+0x2a5>
  800981:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800985:	48 89 d0             	mov    %rdx,%rax
  800988:	48 83 c2 08          	add    $0x8,%rdx
  80098c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800990:	4c 8b 20             	mov    (%rax),%r12
  800993:	4d 85 e4             	test   %r12,%r12
  800996:	75 0a                	jne    8009a2 <vprintfmt+0x2b7>
				p = "(null)";
  800998:	49 bc ad 49 80 00 00 	movabs $0x8049ad,%r12
  80099f:	00 00 00 
			if (width > 0 && padc != '-')
  8009a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a6:	7e 3f                	jle    8009e7 <vprintfmt+0x2fc>
  8009a8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009ac:	74 39                	je     8009e7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b1:	48 98                	cltq   
  8009b3:	48 89 c6             	mov    %rax,%rsi
  8009b6:	4c 89 e7             	mov    %r12,%rdi
  8009b9:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  8009c0:	00 00 00 
  8009c3:	ff d0                	callq  *%rax
  8009c5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009c8:	eb 17                	jmp    8009e1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ca:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009ce:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d6:	48 89 ce             	mov    %rcx,%rsi
  8009d9:	89 d7                	mov    %edx,%edi
  8009db:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e5:	7f e3                	jg     8009ca <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e7:	eb 37                	jmp    800a20 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ed:	74 1e                	je     800a0d <vprintfmt+0x322>
  8009ef:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f2:	7e 05                	jle    8009f9 <vprintfmt+0x30e>
  8009f4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f7:	7e 14                	jle    800a0d <vprintfmt+0x322>
					putch('?', putdat);
  8009f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a01:	48 89 d6             	mov    %rdx,%rsi
  800a04:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a09:	ff d0                	callq  *%rax
  800a0b:	eb 0f                	jmp    800a1c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a15:	48 89 d6             	mov    %rdx,%rsi
  800a18:	89 df                	mov    %ebx,%edi
  800a1a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a20:	4c 89 e0             	mov    %r12,%rax
  800a23:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a27:	0f b6 00             	movzbl (%rax),%eax
  800a2a:	0f be d8             	movsbl %al,%ebx
  800a2d:	85 db                	test   %ebx,%ebx
  800a2f:	74 10                	je     800a41 <vprintfmt+0x356>
  800a31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a35:	78 b2                	js     8009e9 <vprintfmt+0x2fe>
  800a37:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3f:	79 a8                	jns    8009e9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a41:	eb 16                	jmp    800a59 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4b:	48 89 d6             	mov    %rdx,%rsi
  800a4e:	bf 20 00 00 00       	mov    $0x20,%edi
  800a53:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5d:	7f e4                	jg     800a43 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a5f:	e9 90 01 00 00       	jmpq   800bf4 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a68:	be 03 00 00 00       	mov    $0x3,%esi
  800a6d:	48 89 c7             	mov    %rax,%rdi
  800a70:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800a77:	00 00 00 
  800a7a:	ff d0                	callq  *%rax
  800a7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 85 c0             	test   %rax,%rax
  800a87:	79 1d                	jns    800aa6 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a91:	48 89 d6             	mov    %rdx,%rsi
  800a94:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a99:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9f:	48 f7 d8             	neg    %rax
  800aa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aa6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800aad:	e9 d5 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ab2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab6:	be 03 00 00 00       	mov    $0x3,%esi
  800abb:	48 89 c7             	mov    %rax,%rdi
  800abe:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ace:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ad5:	e9 ad 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ada:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800add:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae1:	89 d6                	mov    %edx,%esi
  800ae3:	48 89 c7             	mov    %rax,%rdi
  800ae6:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800aed:	00 00 00 
  800af0:	ff d0                	callq  *%rax
  800af2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800af6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800afd:	e9 85 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0a:	48 89 d6             	mov    %rdx,%rsi
  800b0d:	bf 30 00 00 00       	mov    $0x30,%edi
  800b12:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1c:	48 89 d6             	mov    %rdx,%rsi
  800b1f:	bf 78 00 00 00       	mov    $0x78,%edi
  800b24:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b29:	83 f8 30             	cmp    $0x30,%eax
  800b2c:	73 17                	jae    800b45 <vprintfmt+0x45a>
  800b2e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b35:	89 c0                	mov    %eax,%eax
  800b37:	48 01 d0             	add    %rdx,%rax
  800b3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b3d:	83 c2 08             	add    $0x8,%edx
  800b40:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b43:	eb 0f                	jmp    800b54 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b49:	48 89 d0             	mov    %rdx,%rax
  800b4c:	48 83 c2 08          	add    $0x8,%rdx
  800b50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b54:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b62:	eb 23                	jmp    800b87 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b68:	be 03 00 00 00       	mov    $0x3,%esi
  800b6d:	48 89 c7             	mov    %rax,%rdi
  800b70:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800b77:	00 00 00 
  800b7a:	ff d0                	callq  *%rax
  800b7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b87:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b8c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b8f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	45 89 c1             	mov    %r8d,%r9d
  800ba1:	41 89 f8             	mov    %edi,%r8d
  800ba4:	48 89 c7             	mov    %rax,%rdi
  800ba7:	48 b8 10 04 80 00 00 	movabs $0x800410,%rax
  800bae:	00 00 00 
  800bb1:	ff d0                	callq  *%rax
			break;
  800bb3:	eb 3f                	jmp    800bf4 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbd:	48 89 d6             	mov    %rdx,%rsi
  800bc0:	89 df                	mov    %ebx,%edi
  800bc2:	ff d0                	callq  *%rax
			break;
  800bc4:	eb 2e                	jmp    800bf4 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 d6             	mov    %rdx,%rsi
  800bd1:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bdd:	eb 05                	jmp    800be4 <vprintfmt+0x4f9>
  800bdf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be8:	48 83 e8 01          	sub    $0x1,%rax
  800bec:	0f b6 00             	movzbl (%rax),%eax
  800bef:	3c 25                	cmp    $0x25,%al
  800bf1:	75 ec                	jne    800bdf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bf3:	90                   	nop
		}
	}
  800bf4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf5:	e9 43 fb ff ff       	jmpq   80073d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bfa:	48 83 c4 60          	add    $0x60,%rsp
  800bfe:	5b                   	pop    %rbx
  800bff:	41 5c                	pop    %r12
  800c01:	5d                   	pop    %rbp
  800c02:	c3                   	retq   

0000000000800c03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c03:	55                   	push   %rbp
  800c04:	48 89 e5             	mov    %rsp,%rbp
  800c07:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c0e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c15:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c31:	84 c0                	test   %al,%al
  800c33:	74 20                	je     800c55 <printfmt+0x52>
  800c35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c55:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c5c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c63:	00 00 00 
  800c66:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c6d:	00 00 00 
  800c70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c74:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c82:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c89:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c90:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c97:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c9e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ca5:	48 89 c7             	mov    %rax,%rdi
  800ca8:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800caf:	00 00 00 
  800cb2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cb4:	c9                   	leaveq 
  800cb5:	c3                   	retq   

0000000000800cb6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb6:	55                   	push   %rbp
  800cb7:	48 89 e5             	mov    %rsp,%rbp
  800cba:	48 83 ec 10          	sub    $0x10,%rsp
  800cbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	8b 40 10             	mov    0x10(%rax),%eax
  800ccc:	8d 50 01             	lea    0x1(%rax),%edx
  800ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cda:	48 8b 10             	mov    (%rax),%rdx
  800cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ce5:	48 39 c2             	cmp    %rax,%rdx
  800ce8:	73 17                	jae    800d01 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cee:	48 8b 00             	mov    (%rax),%rax
  800cf1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf9:	48 89 0a             	mov    %rcx,(%rdx)
  800cfc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cff:	88 10                	mov    %dl,(%rax)
}
  800d01:	c9                   	leaveq 
  800d02:	c3                   	retq   

0000000000800d03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d03:	55                   	push   %rbp
  800d04:	48 89 e5             	mov    %rsp,%rbp
  800d07:	48 83 ec 50          	sub    $0x50,%rsp
  800d0b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d0f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d12:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d16:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d1a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d1e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d22:	48 8b 0a             	mov    (%rdx),%rcx
  800d25:	48 89 08             	mov    %rcx,(%rax)
  800d28:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d2c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d30:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d34:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d3c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d40:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d43:	48 98                	cltq   
  800d45:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d4d:	48 01 d0             	add    %rdx,%rax
  800d50:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d54:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d5b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d60:	74 06                	je     800d68 <vsnprintf+0x65>
  800d62:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d66:	7f 07                	jg     800d6f <vsnprintf+0x6c>
		return -E_INVAL;
  800d68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d6d:	eb 2f                	jmp    800d9e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d6f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d73:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d77:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d7b:	48 89 c6             	mov    %rax,%rsi
  800d7e:	48 bf b6 0c 80 00 00 	movabs $0x800cb6,%rdi
  800d85:	00 00 00 
  800d88:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800d8f:	00 00 00 
  800d92:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d98:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d9b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d9e:	c9                   	leaveq 
  800d9f:	c3                   	retq   

0000000000800da0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da0:	55                   	push   %rbp
  800da1:	48 89 e5             	mov    %rsp,%rbp
  800da4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800db2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800db8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dcd:	84 c0                	test   %al,%al
  800dcf:	74 20                	je     800df1 <snprintf+0x51>
  800dd1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ddd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800de1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ded:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800df1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800df8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dff:	00 00 00 
  800e02:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e09:	00 00 00 
  800e0c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e10:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e17:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e25:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e2c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e33:	48 8b 0a             	mov    (%rdx),%rcx
  800e36:	48 89 08             	mov    %rcx,(%rax)
  800e39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e49:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e50:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e57:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e5d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e64:	48 89 c7             	mov    %rax,%rdi
  800e67:	48 b8 03 0d 80 00 00 	movabs $0x800d03,%rax
  800e6e:	00 00 00 
  800e71:	ff d0                	callq  *%rax
  800e73:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e79:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e7f:	c9                   	leaveq 
  800e80:	c3                   	retq   

0000000000800e81 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e81:	55                   	push   %rbp
  800e82:	48 89 e5             	mov    %rsp,%rbp
  800e85:	48 83 ec 18          	sub    $0x18,%rsp
  800e89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e94:	eb 09                	jmp    800e9f <strlen+0x1e>
		n++;
  800e96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea3:	0f b6 00             	movzbl (%rax),%eax
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 ec                	jne    800e96 <strlen+0x15>
		n++;
	return n;
  800eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ead:	c9                   	leaveq 
  800eae:	c3                   	retq   

0000000000800eaf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
  800eb3:	48 83 ec 20          	sub    $0x20,%rsp
  800eb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ec6:	eb 0e                	jmp    800ed6 <strnlen+0x27>
		n++;
  800ec8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ed1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ed6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800edb:	74 0b                	je     800ee8 <strnlen+0x39>
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	0f b6 00             	movzbl (%rax),%eax
  800ee4:	84 c0                	test   %al,%al
  800ee6:	75 e0                	jne    800ec8 <strnlen+0x19>
		n++;
	return n;
  800ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 83 ec 20          	sub    $0x20,%rsp
  800ef5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f05:	90                   	nop
  800f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f12:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f16:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f1a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f1e:	0f b6 12             	movzbl (%rdx),%edx
  800f21:	88 10                	mov    %dl,(%rax)
  800f23:	0f b6 00             	movzbl (%rax),%eax
  800f26:	84 c0                	test   %al,%al
  800f28:	75 dc                	jne    800f06 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f2e:	c9                   	leaveq 
  800f2f:	c3                   	retq   

0000000000800f30 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f30:	55                   	push   %rbp
  800f31:	48 89 e5             	mov    %rsp,%rbp
  800f34:	48 83 ec 20          	sub    $0x20,%rsp
  800f38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	48 89 c7             	mov    %rax,%rdi
  800f47:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  800f4e:	00 00 00 
  800f51:	ff d0                	callq  *%rax
  800f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f59:	48 63 d0             	movslq %eax,%rdx
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 01 c2             	add    %rax,%rdx
  800f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f67:	48 89 c6             	mov    %rax,%rsi
  800f6a:	48 89 d7             	mov    %rdx,%rdi
  800f6d:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  800f74:	00 00 00 
  800f77:	ff d0                	callq  *%rax
	return dst;
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f7d:	c9                   	leaveq 
  800f7e:	c3                   	retq   

0000000000800f7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f7f:	55                   	push   %rbp
  800f80:	48 89 e5             	mov    %rsp,%rbp
  800f83:	48 83 ec 28          	sub    $0x28,%rsp
  800f87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fa2:	00 
  800fa3:	eb 2a                	jmp    800fcf <strncpy+0x50>
		*dst++ = *src;
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	0f b6 12             	movzbl (%rdx),%edx
  800fb8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	84 c0                	test   %al,%al
  800fc3:	74 05                	je     800fca <strncpy+0x4b>
			src++;
  800fc5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fd7:	72 cc                	jb     800fa5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 28          	sub    $0x28,%rsp
  800fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ffb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801000:	74 3d                	je     80103f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801002:	eb 1d                	jmp    801021 <strlcpy+0x42>
			*dst++ = *src++;
  801004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801008:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80100c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801010:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801014:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801018:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80101c:	0f b6 12             	movzbl (%rdx),%edx
  80101f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801021:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801026:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80102b:	74 0b                	je     801038 <strlcpy+0x59>
  80102d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801031:	0f b6 00             	movzbl (%rax),%eax
  801034:	84 c0                	test   %al,%al
  801036:	75 cc                	jne    801004 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80103f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801047:	48 29 c2             	sub    %rax,%rdx
  80104a:	48 89 d0             	mov    %rdx,%rax
}
  80104d:	c9                   	leaveq 
  80104e:	c3                   	retq   

000000000080104f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80104f:	55                   	push   %rbp
  801050:	48 89 e5             	mov    %rsp,%rbp
  801053:	48 83 ec 10          	sub    $0x10,%rsp
  801057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80105f:	eb 0a                	jmp    80106b <strcmp+0x1c>
		p++, q++;
  801061:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801066:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80106b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	84 c0                	test   %al,%al
  801074:	74 12                	je     801088 <strcmp+0x39>
  801076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107a:	0f b6 10             	movzbl (%rax),%edx
  80107d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801081:	0f b6 00             	movzbl (%rax),%eax
  801084:	38 c2                	cmp    %al,%dl
  801086:	74 d9                	je     801061 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	0f b6 d0             	movzbl %al,%edx
  801092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	0f b6 c0             	movzbl %al,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 18          	sub    $0x18,%rsp
  8010aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010b6:	eb 0f                	jmp    8010c7 <strncmp+0x25>
		n--, p++, q++;
  8010b8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010cc:	74 1d                	je     8010eb <strncmp+0x49>
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	84 c0                	test   %al,%al
  8010d7:	74 12                	je     8010eb <strncmp+0x49>
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	0f b6 10             	movzbl (%rax),%edx
  8010e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	38 c2                	cmp    %al,%dl
  8010e9:	74 cd                	je     8010b8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f0:	75 07                	jne    8010f9 <strncmp+0x57>
		return 0;
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	eb 18                	jmp    801111 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	0f b6 d0             	movzbl %al,%edx
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	0f b6 c0             	movzbl %al,%eax
  80110d:	29 c2                	sub    %eax,%edx
  80110f:	89 d0                	mov    %edx,%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 0c          	sub    $0xc,%rsp
  80111b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111f:	89 f0                	mov    %esi,%eax
  801121:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801124:	eb 17                	jmp    80113d <strchr+0x2a>
		if (*s == c)
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801130:	75 06                	jne    801138 <strchr+0x25>
			return (char *) s;
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	eb 15                	jmp    80114d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801138:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801141:	0f b6 00             	movzbl (%rax),%eax
  801144:	84 c0                	test   %al,%al
  801146:	75 de                	jne    801126 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114d:	c9                   	leaveq 
  80114e:	c3                   	retq   

000000000080114f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80114f:	55                   	push   %rbp
  801150:	48 89 e5             	mov    %rsp,%rbp
  801153:	48 83 ec 0c          	sub    $0xc,%rsp
  801157:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80115b:	89 f0                	mov    %esi,%eax
  80115d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801160:	eb 13                	jmp    801175 <strfind+0x26>
		if (*s == c)
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801166:	0f b6 00             	movzbl (%rax),%eax
  801169:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80116c:	75 02                	jne    801170 <strfind+0x21>
			break;
  80116e:	eb 10                	jmp    801180 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801170:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	0f b6 00             	movzbl (%rax),%eax
  80117c:	84 c0                	test   %al,%al
  80117e:	75 e2                	jne    801162 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 18          	sub    $0x18,%rsp
  80118e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801192:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801195:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801199:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119e:	75 06                	jne    8011a6 <memset+0x20>
		return v;
  8011a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a4:	eb 69                	jmp    80120f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011aa:	83 e0 03             	and    $0x3,%eax
  8011ad:	48 85 c0             	test   %rax,%rax
  8011b0:	75 48                	jne    8011fa <memset+0x74>
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	83 e0 03             	and    $0x3,%eax
  8011b9:	48 85 c0             	test   %rax,%rax
  8011bc:	75 3c                	jne    8011fa <memset+0x74>
		c &= 0xFF;
  8011be:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c8:	c1 e0 18             	shl    $0x18,%eax
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d0:	c1 e0 10             	shl    $0x10,%eax
  8011d3:	09 c2                	or     %eax,%edx
  8011d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d8:	c1 e0 08             	shl    $0x8,%eax
  8011db:	09 d0                	or     %edx,%eax
  8011dd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 c1 e8 02          	shr    $0x2,%rax
  8011e8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f2:	48 89 d7             	mov    %rdx,%rdi
  8011f5:	fc                   	cld    
  8011f6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011f8:	eb 11                	jmp    80120b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801201:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801205:	48 89 d7             	mov    %rdx,%rdi
  801208:	fc                   	cld    
  801209:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 28          	sub    $0x28,%rsp
  801219:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801221:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801229:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80122d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801231:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80123d:	0f 83 88 00 00 00    	jae    8012cb <memmove+0xba>
  801243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801247:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124b:	48 01 d0             	add    %rdx,%rax
  80124e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801252:	76 77                	jbe    8012cb <memmove+0xba>
		s += n;
  801254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801258:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80125c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801260:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	83 e0 03             	and    $0x3,%eax
  80126b:	48 85 c0             	test   %rax,%rax
  80126e:	75 3b                	jne    8012ab <memmove+0x9a>
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	83 e0 03             	and    $0x3,%eax
  801277:	48 85 c0             	test   %rax,%rax
  80127a:	75 2f                	jne    8012ab <memmove+0x9a>
  80127c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801280:	83 e0 03             	and    $0x3,%eax
  801283:	48 85 c0             	test   %rax,%rax
  801286:	75 23                	jne    8012ab <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128c:	48 83 e8 04          	sub    $0x4,%rax
  801290:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801294:	48 83 ea 04          	sub    $0x4,%rdx
  801298:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80129c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 89 d6             	mov    %rdx,%rsi
  8012a6:	fd                   	std    
  8012a7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a9:	eb 1d                	jmp    8012c8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012af:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bf:	48 89 d7             	mov    %rdx,%rdi
  8012c2:	48 89 c1             	mov    %rax,%rcx
  8012c5:	fd                   	std    
  8012c6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c8:	fc                   	cld    
  8012c9:	eb 57                	jmp    801322 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	83 e0 03             	and    $0x3,%eax
  8012d2:	48 85 c0             	test   %rax,%rax
  8012d5:	75 36                	jne    80130d <memmove+0xfc>
  8012d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012db:	83 e0 03             	and    $0x3,%eax
  8012de:	48 85 c0             	test   %rax,%rax
  8012e1:	75 2a                	jne    80130d <memmove+0xfc>
  8012e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e7:	83 e0 03             	and    $0x3,%eax
  8012ea:	48 85 c0             	test   %rax,%rax
  8012ed:	75 1e                	jne    80130d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f3:	48 c1 e8 02          	shr    $0x2,%rax
  8012f7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 89 d6             	mov    %rdx,%rsi
  801308:	fc                   	cld    
  801309:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80130b:	eb 15                	jmp    801322 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80130d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801311:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801315:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801319:	48 89 c7             	mov    %rax,%rdi
  80131c:	48 89 d6             	mov    %rdx,%rsi
  80131f:	fc                   	cld    
  801320:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801326:	c9                   	leaveq 
  801327:	c3                   	retq   

0000000000801328 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	48 83 ec 18          	sub    $0x18,%rsp
  801330:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801334:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80133c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801340:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801348:	48 89 ce             	mov    %rcx,%rsi
  80134b:	48 89 c7             	mov    %rax,%rdi
  80134e:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  801355:	00 00 00 
  801358:	ff d0                	callq  *%rax
}
  80135a:	c9                   	leaveq 
  80135b:	c3                   	retq   

000000000080135c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 28          	sub    $0x28,%rsp
  801364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80136c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801374:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801378:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801380:	eb 36                	jmp    8013b8 <memcmp+0x5c>
		if (*s1 != *s2)
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 10             	movzbl (%rax),%edx
  801389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	38 c2                	cmp    %al,%dl
  801392:	74 1a                	je     8013ae <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	0f b6 d0             	movzbl %al,%edx
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	0f b6 00             	movzbl (%rax),%eax
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	29 c2                	sub    %eax,%edx
  8013aa:	89 d0                	mov    %edx,%eax
  8013ac:	eb 20                	jmp    8013ce <memcmp+0x72>
		s1++, s2++;
  8013ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013c4:	48 85 c0             	test   %rax,%rax
  8013c7:	75 b9                	jne    801382 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 83 ec 28          	sub    $0x28,%rsp
  8013d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013eb:	48 01 d0             	add    %rdx,%rax
  8013ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013f2:	eb 15                	jmp    801409 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	0f b6 10             	movzbl (%rax),%edx
  8013fb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013fe:	38 c2                	cmp    %al,%dl
  801400:	75 02                	jne    801404 <memfind+0x34>
			break;
  801402:	eb 0f                	jmp    801413 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801404:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801411:	72 e1                	jb     8013f4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801417:	c9                   	leaveq 
  801418:	c3                   	retq   

0000000000801419 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801419:	55                   	push   %rbp
  80141a:	48 89 e5             	mov    %rsp,%rbp
  80141d:	48 83 ec 34          	sub    $0x34,%rsp
  801421:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801425:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801429:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80142c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801433:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80143a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143b:	eb 05                	jmp    801442 <strtol+0x29>
		s++;
  80143d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	3c 20                	cmp    $0x20,%al
  80144b:	74 f0                	je     80143d <strtol+0x24>
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	3c 09                	cmp    $0x9,%al
  801456:	74 e5                	je     80143d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	0f b6 00             	movzbl (%rax),%eax
  80145f:	3c 2b                	cmp    $0x2b,%al
  801461:	75 07                	jne    80146a <strtol+0x51>
		s++;
  801463:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801468:	eb 17                	jmp    801481 <strtol+0x68>
	else if (*s == '-')
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	3c 2d                	cmp    $0x2d,%al
  801473:	75 0c                	jne    801481 <strtol+0x68>
		s++, neg = 1;
  801475:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801481:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801485:	74 06                	je     80148d <strtol+0x74>
  801487:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80148b:	75 28                	jne    8014b5 <strtol+0x9c>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 30                	cmp    $0x30,%al
  801496:	75 1d                	jne    8014b5 <strtol+0x9c>
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	48 83 c0 01          	add    $0x1,%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3c 78                	cmp    $0x78,%al
  8014a5:	75 0e                	jne    8014b5 <strtol+0x9c>
		s += 2, base = 16;
  8014a7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014ac:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014b3:	eb 2c                	jmp    8014e1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b9:	75 19                	jne    8014d4 <strtol+0xbb>
  8014bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bf:	0f b6 00             	movzbl (%rax),%eax
  8014c2:	3c 30                	cmp    $0x30,%al
  8014c4:	75 0e                	jne    8014d4 <strtol+0xbb>
		s++, base = 8;
  8014c6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014cb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014d2:	eb 0d                	jmp    8014e1 <strtol+0xc8>
	else if (base == 0)
  8014d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d8:	75 07                	jne    8014e1 <strtol+0xc8>
		base = 10;
  8014da:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	3c 2f                	cmp    $0x2f,%al
  8014ea:	7e 1d                	jle    801509 <strtol+0xf0>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 39                	cmp    $0x39,%al
  8014f5:	7f 12                	jg     801509 <strtol+0xf0>
			dig = *s - '0';
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	0f be c0             	movsbl %al,%eax
  801501:	83 e8 30             	sub    $0x30,%eax
  801504:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801507:	eb 4e                	jmp    801557 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 60                	cmp    $0x60,%al
  801512:	7e 1d                	jle    801531 <strtol+0x118>
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 7a                	cmp    $0x7a,%al
  80151d:	7f 12                	jg     801531 <strtol+0x118>
			dig = *s - 'a' + 10;
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	0f be c0             	movsbl %al,%eax
  801529:	83 e8 57             	sub    $0x57,%eax
  80152c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80152f:	eb 26                	jmp    801557 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3c 40                	cmp    $0x40,%al
  80153a:	7e 48                	jle    801584 <strtol+0x16b>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	3c 5a                	cmp    $0x5a,%al
  801545:	7f 3d                	jg     801584 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	0f be c0             	movsbl %al,%eax
  801551:	83 e8 37             	sub    $0x37,%eax
  801554:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801557:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80155d:	7c 02                	jl     801561 <strtol+0x148>
			break;
  80155f:	eb 23                	jmp    801584 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801561:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801566:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801569:	48 98                	cltq   
  80156b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801570:	48 89 c2             	mov    %rax,%rdx
  801573:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801576:	48 98                	cltq   
  801578:	48 01 d0             	add    %rdx,%rax
  80157b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80157f:	e9 5d ff ff ff       	jmpq   8014e1 <strtol+0xc8>

	if (endptr)
  801584:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801589:	74 0b                	je     801596 <strtol+0x17d>
		*endptr = (char *) s;
  80158b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80158f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801593:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801596:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80159a:	74 09                	je     8015a5 <strtol+0x18c>
  80159c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a0:	48 f7 d8             	neg    %rax
  8015a3:	eb 04                	jmp    8015a9 <strtol+0x190>
  8015a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <strstr>:

char * strstr(const char *in, const char *str)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 30          	sub    $0x30,%rsp
  8015b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015cd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015d1:	75 06                	jne    8015d9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	eb 6b                	jmp    801644 <strstr+0x99>

	len = strlen(str);
  8015d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015dd:	48 89 c7             	mov    %rax,%rdi
  8015e0:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	callq  *%rax
  8015ec:	48 98                	cltq   
  8015ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015fe:	0f b6 00             	movzbl (%rax),%eax
  801601:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801604:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801608:	75 07                	jne    801611 <strstr+0x66>
				return (char *) 0;
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
  80160f:	eb 33                	jmp    801644 <strstr+0x99>
		} while (sc != c);
  801611:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801615:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801618:	75 d8                	jne    8015f2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80161a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	48 89 ce             	mov    %rcx,%rsi
  801629:	48 89 c7             	mov    %rax,%rdi
  80162c:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  801633:	00 00 00 
  801636:	ff d0                	callq  *%rax
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 b6                	jne    8015f2 <strstr+0x47>

	return (char *) (in - 1);
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	48 83 e8 01          	sub    $0x1,%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	53                   	push   %rbx
  80164b:	48 83 ec 48          	sub    $0x48,%rsp
  80164f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801652:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801655:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801659:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80165d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801661:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801665:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801668:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80166c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801670:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801674:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801678:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80167c:	4c 89 c3             	mov    %r8,%rbx
  80167f:	cd 30                	int    $0x30
  801681:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801685:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801689:	74 3e                	je     8016c9 <syscall+0x83>
  80168b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801690:	7e 37                	jle    8016c9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801696:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801699:	49 89 d0             	mov    %rdx,%r8
  80169c:	89 c1                	mov    %eax,%ecx
  80169e:	48 ba 68 4c 80 00 00 	movabs $0x804c68,%rdx
  8016a5:	00 00 00 
  8016a8:	be 23 00 00 00       	mov    $0x23,%esi
  8016ad:	48 bf 85 4c 80 00 00 	movabs $0x804c85,%rdi
  8016b4:	00 00 00 
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	49 b9 7b 42 80 00 00 	movabs $0x80427b,%r9
  8016c3:	00 00 00 
  8016c6:	41 ff d1             	callq  *%r9

	return ret;
  8016c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016cd:	48 83 c4 48          	add    $0x48,%rsp
  8016d1:	5b                   	pop    %rbx
  8016d2:	5d                   	pop    %rbp
  8016d3:	c3                   	retq   

00000000008016d4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	48 83 ec 20          	sub    $0x20,%rsp
  8016dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f3:	00 
  8016f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801700:	48 89 d1             	mov    %rdx,%rcx
  801703:	48 89 c2             	mov    %rax,%rdx
  801706:	be 00 00 00 00       	mov    $0x0,%esi
  80170b:	bf 00 00 00 00       	mov    $0x0,%edi
  801710:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801717:	00 00 00 
  80171a:	ff d0                	callq  *%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <sys_cgetc>:

int
sys_cgetc(void)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801726:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172d:	00 
  80172e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173f:	ba 00 00 00 00       	mov    $0x0,%edx
  801744:	be 00 00 00 00       	mov    $0x0,%esi
  801749:	bf 01 00 00 00       	mov    $0x1,%edi
  80174e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 10          	sub    $0x10,%rsp
  801764:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176a:	48 98                	cltq   
  80176c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801773:	00 
  801774:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801780:	b9 00 00 00 00       	mov    $0x0,%ecx
  801785:	48 89 c2             	mov    %rax,%rdx
  801788:	be 01 00 00 00       	mov    $0x1,%esi
  80178d:	bf 03 00 00 00       	mov    $0x3,%edi
  801792:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801799:	00 00 00 
  80179c:	ff d0                	callq  *%rax
}
  80179e:	c9                   	leaveq 
  80179f:	c3                   	retq   

00000000008017a0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017a0:	55                   	push   %rbp
  8017a1:	48 89 e5             	mov    %rsp,%rbp
  8017a4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017af:	00 
  8017b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	be 00 00 00 00       	mov    $0x0,%esi
  8017cb:	bf 02 00 00 00       	mov    $0x2,%edi
  8017d0:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   

00000000008017de <sys_yield>:

void
sys_yield(void)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ed:	00 
  8017ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	be 00 00 00 00       	mov    $0x0,%esi
  801809:	bf 0b 00 00 00       	mov    $0xb,%edi
  80180e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801815:	00 00 00 
  801818:	ff d0                	callq  *%rax
}
  80181a:	c9                   	leaveq 
  80181b:	c3                   	retq   

000000000080181c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	48 83 ec 20          	sub    $0x20,%rsp
  801824:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80182b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80182e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801831:	48 63 c8             	movslq %eax,%rcx
  801834:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80183b:	48 98                	cltq   
  80183d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801844:	00 
  801845:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184b:	49 89 c8             	mov    %rcx,%r8
  80184e:	48 89 d1             	mov    %rdx,%rcx
  801851:	48 89 c2             	mov    %rax,%rdx
  801854:	be 01 00 00 00       	mov    $0x1,%esi
  801859:	bf 04 00 00 00       	mov    $0x4,%edi
  80185e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801865:	00 00 00 
  801868:	ff d0                	callq  *%rax
}
  80186a:	c9                   	leaveq 
  80186b:	c3                   	retq   

000000000080186c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80186c:	55                   	push   %rbp
  80186d:	48 89 e5             	mov    %rsp,%rbp
  801870:	48 83 ec 30          	sub    $0x30,%rsp
  801874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80187b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80187e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801882:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801886:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801889:	48 63 c8             	movslq %eax,%rcx
  80188c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801890:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801893:	48 63 f0             	movslq %eax,%rsi
  801896:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189d:	48 98                	cltq   
  80189f:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018a3:	49 89 f9             	mov    %rdi,%r9
  8018a6:	49 89 f0             	mov    %rsi,%r8
  8018a9:	48 89 d1             	mov    %rdx,%rcx
  8018ac:	48 89 c2             	mov    %rax,%rdx
  8018af:	be 01 00 00 00       	mov    $0x1,%esi
  8018b4:	bf 05 00 00 00       	mov    $0x5,%edi
  8018b9:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 20          	sub    $0x20,%rsp
  8018cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018dd:	48 98                	cltq   
  8018df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e6:	00 
  8018e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f3:	48 89 d1             	mov    %rdx,%rcx
  8018f6:	48 89 c2             	mov    %rax,%rdx
  8018f9:	be 01 00 00 00       	mov    $0x1,%esi
  8018fe:	bf 06 00 00 00       	mov    $0x6,%edi
  801903:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80191c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80191f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801922:	48 63 d0             	movslq %eax,%rdx
  801925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801928:	48 98                	cltq   
  80192a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801931:	00 
  801932:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801938:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193e:	48 89 d1             	mov    %rdx,%rcx
  801941:	48 89 c2             	mov    %rax,%rdx
  801944:	be 01 00 00 00       	mov    $0x1,%esi
  801949:	bf 08 00 00 00       	mov    $0x8,%edi
  80194e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801955:	00 00 00 
  801958:	ff d0                	callq  *%rax
}
  80195a:	c9                   	leaveq 
  80195b:	c3                   	retq   

000000000080195c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	48 83 ec 20          	sub    $0x20,%rsp
  801964:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801967:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80196b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801972:	48 98                	cltq   
  801974:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197b:	00 
  80197c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801982:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801988:	48 89 d1             	mov    %rdx,%rcx
  80198b:	48 89 c2             	mov    %rax,%rdx
  80198e:	be 01 00 00 00       	mov    $0x1,%esi
  801993:	bf 09 00 00 00       	mov    $0x9,%edi
  801998:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 20          	sub    $0x20,%rsp
  8019ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bc:	48 98                	cltq   
  8019be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c5:	00 
  8019c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d2:	48 89 d1             	mov    %rdx,%rcx
  8019d5:	48 89 c2             	mov    %rax,%rdx
  8019d8:	be 01 00 00 00       	mov    $0x1,%esi
  8019dd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019e2:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 20          	sub    $0x20,%rsp
  8019f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a03:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a09:	48 63 f0             	movslq %eax,%rsi
  801a0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a13:	48 98                	cltq   
  801a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a20:	00 
  801a21:	49 89 f1             	mov    %rsi,%r9
  801a24:	49 89 c8             	mov    %rcx,%r8
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 00 00 00 00       	mov    $0x0,%esi
  801a32:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a37:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 10          	sub    $0x10,%rsp
  801a4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5c:	00 
  801a5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6e:	48 89 c2             	mov    %rax,%rdx
  801a71:	be 01 00 00 00       	mov    $0x1,%esi
  801a76:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a7b:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
}
  801a87:	c9                   	leaveq 
  801a88:	c3                   	retq   

0000000000801a89 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a89:	55                   	push   %rbp
  801a8a:	48 89 e5             	mov    %rsp,%rbp
  801a8d:	48 83 ec 20          	sub    $0x20,%rsp
  801a91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa8:	00 
  801aa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab5:	48 89 d1             	mov    %rdx,%rcx
  801ab8:	48 89 c2             	mov    %rax,%rdx
  801abb:	be 01 00 00 00       	mov    $0x1,%esi
  801ac0:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ac5:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
}
  801ad1:	c9                   	leaveq 
  801ad2:	c3                   	retq   

0000000000801ad3 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801ad3:	55                   	push   %rbp
  801ad4:	48 89 e5             	mov    %rsp,%rbp
  801ad7:	48 83 ec 10          	sub    $0x10,%rsp
  801adb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aea:	00 
  801aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 00 00 00 00       	mov    $0x0,%esi
  801b04:	bf 10 00 00 00       	mov    $0x10,%edi
  801b09:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b26:	00 
  801b27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b38:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3d:	be 00 00 00 00       	mov    $0x0,%esi
  801b42:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b47:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801b4e:	00 00 00 
  801b51:	ff d0                	callq  *%rax
}
  801b53:	c9                   	leaveq 
  801b54:	c3                   	retq   

0000000000801b55 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 30          	sub    $0x30,%rsp
  801b5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b65:	48 8b 00             	mov    (%rax),%rax
  801b68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b70:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b74:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b7a:	83 e0 02             	and    $0x2,%eax
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	75 4d                	jne    801bce <pgfault+0x79>
  801b81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b85:	48 c1 e8 0c          	shr    $0xc,%rax
  801b89:	48 89 c2             	mov    %rax,%rdx
  801b8c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b93:	01 00 00 
  801b96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b9a:	25 00 08 00 00       	and    $0x800,%eax
  801b9f:	48 85 c0             	test   %rax,%rax
  801ba2:	74 2a                	je     801bce <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ba4:	48 ba 98 4c 80 00 00 	movabs $0x804c98,%rdx
  801bab:	00 00 00 
  801bae:	be 23 00 00 00       	mov    $0x23,%esi
  801bb3:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801bba:	00 00 00 
  801bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc2:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801bc9:	00 00 00 
  801bcc:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801bce:	ba 07 00 00 00       	mov    $0x7,%edx
  801bd3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdd:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
  801be9:	85 c0                	test   %eax,%eax
  801beb:	0f 85 cd 00 00 00    	jne    801cbe <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c03:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c10:	48 89 c6             	mov    %rax,%rsi
  801c13:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c18:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c28:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c2e:	48 89 c1             	mov    %rax,%rcx
  801c31:	ba 00 00 00 00       	mov    $0x0,%edx
  801c36:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c40:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801c47:	00 00 00 
  801c4a:	ff d0                	callq  *%rax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	79 2a                	jns    801c7a <pgfault+0x125>
				panic("Page map at temp address failed");
  801c50:	48 ba d8 4c 80 00 00 	movabs $0x804cd8,%rdx
  801c57:	00 00 00 
  801c5a:	be 30 00 00 00       	mov    $0x30,%esi
  801c5f:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801c66:	00 00 00 
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801c75:	00 00 00 
  801c78:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c7a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c84:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
  801c90:	85 c0                	test   %eax,%eax
  801c92:	79 54                	jns    801ce8 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c94:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  801c9b:	00 00 00 
  801c9e:	be 32 00 00 00       	mov    $0x32,%esi
  801ca3:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801caa:	00 00 00 
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb2:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801cb9:	00 00 00 
  801cbc:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801cbe:	48 ba 20 4d 80 00 00 	movabs $0x804d20,%rdx
  801cc5:	00 00 00 
  801cc8:	be 34 00 00 00       	mov    $0x34,%esi
  801ccd:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801cd4:	00 00 00 
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdc:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801ce3:	00 00 00 
  801ce6:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801ce8:	c9                   	leaveq 
  801ce9:	c3                   	retq   

0000000000801cea <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801cea:	55                   	push   %rbp
  801ceb:	48 89 e5             	mov    %rsp,%rbp
  801cee:	48 83 ec 20          	sub    $0x20,%rsp
  801cf2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cf5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cf8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cff:	01 00 00 
  801d02:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d09:	25 07 0e 00 00       	and    $0xe07,%eax
  801d0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d11:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d14:	48 c1 e0 0c          	shl    $0xc,%rax
  801d18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	25 00 04 00 00       	and    $0x400,%eax
  801d24:	85 c0                	test   %eax,%eax
  801d26:	74 57                	je     801d7f <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d28:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d2b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d2f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d36:	41 89 f0             	mov    %esi,%r8d
  801d39:	48 89 c6             	mov    %rax,%rsi
  801d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d41:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	0f 8e 52 01 00 00    	jle    801ea7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d55:	48 ba 52 4d 80 00 00 	movabs $0x804d52,%rdx
  801d5c:	00 00 00 
  801d5f:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d64:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801d6b:	00 00 00 
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d73:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801d7a:	00 00 00 
  801d7d:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d82:	83 e0 02             	and    $0x2,%eax
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 10                	jne    801d99 <duppage+0xaf>
  801d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8c:	25 00 08 00 00       	and    $0x800,%eax
  801d91:	85 c0                	test   %eax,%eax
  801d93:	0f 84 bb 00 00 00    	je     801e54 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9c:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801da1:	80 cc 08             	or     $0x8,%ah
  801da4:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801da7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801daa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801db1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db5:	41 89 f0             	mov    %esi,%r8d
  801db8:	48 89 c6             	mov    %rax,%rsi
  801dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc0:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	7e 2a                	jle    801dfa <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801dd0:	48 ba 52 4d 80 00 00 	movabs $0x804d52,%rdx
  801dd7:	00 00 00 
  801dda:	be 55 00 00 00       	mov    $0x55,%esi
  801ddf:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801de6:	00 00 00 
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801df5:	00 00 00 
  801df8:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801dfa:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801dfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e05:	41 89 c8             	mov    %ecx,%r8d
  801e08:	48 89 d1             	mov    %rdx,%rcx
  801e0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e10:	48 89 c6             	mov    %rax,%rsi
  801e13:	bf 00 00 00 00       	mov    $0x0,%edi
  801e18:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	callq  *%rax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	7e 2a                	jle    801e52 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e28:	48 ba 52 4d 80 00 00 	movabs $0x804d52,%rdx
  801e2f:	00 00 00 
  801e32:	be 57 00 00 00       	mov    $0x57,%esi
  801e37:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801e3e:	00 00 00 
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
  801e46:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801e4d:	00 00 00 
  801e50:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e52:	eb 53                	jmp    801ea7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e54:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e57:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e5b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e62:	41 89 f0             	mov    %esi,%r8d
  801e65:	48 89 c6             	mov    %rax,%rsi
  801e68:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6d:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	7e 2a                	jle    801ea7 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e7d:	48 ba 52 4d 80 00 00 	movabs $0x804d52,%rdx
  801e84:	00 00 00 
  801e87:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e8c:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801e93:	00 00 00 
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  801ea2:	00 00 00 
  801ea5:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eac:	c9                   	leaveq 
  801ead:	c3                   	retq   

0000000000801eae <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801eae:	55                   	push   %rbp
  801eaf:	48 89 e5             	mov    %rsp,%rbp
  801eb2:	48 83 ec 18          	sub    $0x18,%rsp
  801eb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec6:	48 c1 e8 27          	shr    $0x27,%rax
  801eca:	48 89 c2             	mov    %rax,%rdx
  801ecd:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ed4:	01 00 00 
  801ed7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801edb:	83 e0 01             	and    $0x1,%eax
  801ede:	48 85 c0             	test   %rax,%rax
  801ee1:	74 51                	je     801f34 <pt_is_mapped+0x86>
  801ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee7:	48 c1 e0 0c          	shl    $0xc,%rax
  801eeb:	48 c1 e8 1e          	shr    $0x1e,%rax
  801eef:	48 89 c2             	mov    %rax,%rdx
  801ef2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ef9:	01 00 00 
  801efc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f00:	83 e0 01             	and    $0x1,%eax
  801f03:	48 85 c0             	test   %rax,%rax
  801f06:	74 2c                	je     801f34 <pt_is_mapped+0x86>
  801f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0c:	48 c1 e0 0c          	shl    $0xc,%rax
  801f10:	48 c1 e8 15          	shr    $0x15,%rax
  801f14:	48 89 c2             	mov    %rax,%rdx
  801f17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f1e:	01 00 00 
  801f21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f25:	83 e0 01             	and    $0x1,%eax
  801f28:	48 85 c0             	test   %rax,%rax
  801f2b:	74 07                	je     801f34 <pt_is_mapped+0x86>
  801f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f32:	eb 05                	jmp    801f39 <pt_is_mapped+0x8b>
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	83 e0 01             	and    $0x1,%eax
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <fork>:

envid_t
fork(void)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f46:	48 bf 55 1b 80 00 00 	movabs $0x801b55,%rdi
  801f4d:	00 00 00 
  801f50:	48 b8 8f 43 80 00 00 	movabs $0x80438f,%rax
  801f57:	00 00 00 
  801f5a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f61:	cd 30                	int    $0x30
  801f63:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f66:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f69:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f70:	79 30                	jns    801fa2 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f72:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f75:	89 c1                	mov    %eax,%ecx
  801f77:	48 ba 70 4d 80 00 00 	movabs $0x804d70,%rdx
  801f7e:	00 00 00 
  801f81:	be 86 00 00 00       	mov    $0x86,%esi
  801f86:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  801f8d:	00 00 00 
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	49 b8 7b 42 80 00 00 	movabs $0x80427b,%r8
  801f9c:	00 00 00 
  801f9f:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fa6:	75 46                	jne    801fee <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801fa8:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	callq  *%rax
  801fb4:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fb9:	48 63 d0             	movslq %eax,%rdx
  801fbc:	48 89 d0             	mov    %rdx,%rax
  801fbf:	48 c1 e0 03          	shl    $0x3,%rax
  801fc3:	48 01 d0             	add    %rdx,%rax
  801fc6:	48 c1 e0 05          	shl    $0x5,%rax
  801fca:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fd1:	00 00 00 
  801fd4:	48 01 c2             	add    %rax,%rdx
  801fd7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fde:	00 00 00 
  801fe1:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	e9 d1 01 00 00       	jmpq   8021bf <fork+0x281>
	}
	uint64_t ad = 0;
  801fee:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801ff5:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801ff6:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801ffb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fff:	e9 df 00 00 00       	jmpq   8020e3 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802008:	48 c1 e8 27          	shr    $0x27,%rax
  80200c:	48 89 c2             	mov    %rax,%rdx
  80200f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802016:	01 00 00 
  802019:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201d:	83 e0 01             	and    $0x1,%eax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	0f 84 9e 00 00 00    	je     8020c7 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802031:	48 89 c2             	mov    %rax,%rdx
  802034:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80203b:	01 00 00 
  80203e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802042:	83 e0 01             	and    $0x1,%eax
  802045:	48 85 c0             	test   %rax,%rax
  802048:	74 73                	je     8020bd <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204e:	48 c1 e8 15          	shr    $0x15,%rax
  802052:	48 89 c2             	mov    %rax,%rdx
  802055:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205c:	01 00 00 
  80205f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802063:	83 e0 01             	and    $0x1,%eax
  802066:	48 85 c0             	test   %rax,%rax
  802069:	74 48                	je     8020b3 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80206b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206f:	48 c1 e8 0c          	shr    $0xc,%rax
  802073:	48 89 c2             	mov    %rax,%rdx
  802076:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207d:	01 00 00 
  802080:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802084:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208c:	83 e0 01             	and    $0x1,%eax
  80208f:	48 85 c0             	test   %rax,%rax
  802092:	74 47                	je     8020db <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802098:	48 c1 e8 0c          	shr    $0xc,%rax
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020a1:	89 d6                	mov    %edx,%esi
  8020a3:	89 c7                	mov    %eax,%edi
  8020a5:	48 b8 ea 1c 80 00 00 	movabs $0x801cea,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	eb 28                	jmp    8020db <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8020b3:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020ba:	00 
  8020bb:	eb 1e                	jmp    8020db <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020bd:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020c4:	40 
  8020c5:	eb 14                	jmp    8020db <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cb:	48 c1 e8 27          	shr    $0x27,%rax
  8020cf:	48 83 c0 01          	add    $0x1,%rax
  8020d3:	48 c1 e0 27          	shl    $0x27,%rax
  8020d7:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020db:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020e2:	00 
  8020e3:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020ea:	00 
  8020eb:	0f 87 13 ff ff ff    	ja     802004 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f4:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020fe:	89 c7                	mov    %eax,%edi
  802100:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802107:	00 00 00 
  80210a:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80210c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210f:	ba 07 00 00 00       	mov    $0x7,%edx
  802114:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802119:	89 c7                	mov    %eax,%edi
  80211b:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802127:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80212a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802130:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802135:	ba 00 00 00 00       	mov    $0x0,%edx
  80213a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213f:	89 c7                	mov    %eax,%edi
  802141:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  802148:	00 00 00 
  80214b:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80214d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802152:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802157:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80215c:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802168:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80216d:	bf 00 00 00 00       	mov    $0x0,%edi
  802172:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802179:	00 00 00 
  80217c:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80217e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802185:	00 00 00 
  802188:	48 8b 00             	mov    (%rax),%rax
  80218b:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802192:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802195:	48 89 d6             	mov    %rdx,%rsi
  802198:	89 c7                	mov    %eax,%edi
  80219a:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a9:	be 02 00 00 00       	mov    $0x2,%esi
  8021ae:	89 c7                	mov    %eax,%edi
  8021b0:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax

	return envid;
  8021bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021bf:	c9                   	leaveq 
  8021c0:	c3                   	retq   

00000000008021c1 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021c1:	55                   	push   %rbp
  8021c2:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021c5:	48 ba 88 4d 80 00 00 	movabs $0x804d88,%rdx
  8021cc:	00 00 00 
  8021cf:	be bf 00 00 00       	mov    $0xbf,%esi
  8021d4:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  8021db:	00 00 00 
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e3:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  8021ea:	00 00 00 
  8021ed:	ff d1                	callq  *%rcx

00000000008021ef <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
  8021f3:	48 83 ec 08          	sub    $0x8,%rsp
  8021f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021ff:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802206:	ff ff ff 
  802209:	48 01 d0             	add    %rdx,%rax
  80220c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802210:	c9                   	leaveq 
  802211:	c3                   	retq   

0000000000802212 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802212:	55                   	push   %rbp
  802213:	48 89 e5             	mov    %rsp,%rbp
  802216:	48 83 ec 08          	sub    $0x8,%rsp
  80221a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80221e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802222:	48 89 c7             	mov    %rax,%rdi
  802225:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	callq  *%rax
  802231:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802237:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80223b:	c9                   	leaveq 
  80223c:	c3                   	retq   

000000000080223d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	48 83 ec 18          	sub    $0x18,%rsp
  802245:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802249:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802250:	eb 6b                	jmp    8022bd <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802255:	48 98                	cltq   
  802257:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80225d:	48 c1 e0 0c          	shl    $0xc,%rax
  802261:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802269:	48 c1 e8 15          	shr    $0x15,%rax
  80226d:	48 89 c2             	mov    %rax,%rdx
  802270:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802277:	01 00 00 
  80227a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227e:	83 e0 01             	and    $0x1,%eax
  802281:	48 85 c0             	test   %rax,%rax
  802284:	74 21                	je     8022a7 <fd_alloc+0x6a>
  802286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228a:	48 c1 e8 0c          	shr    $0xc,%rax
  80228e:	48 89 c2             	mov    %rax,%rdx
  802291:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802298:	01 00 00 
  80229b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229f:	83 e0 01             	and    $0x1,%eax
  8022a2:	48 85 c0             	test   %rax,%rax
  8022a5:	75 12                	jne    8022b9 <fd_alloc+0x7c>
			*fd_store = fd;
  8022a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022af:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	eb 1a                	jmp    8022d3 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022bd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022c1:	7e 8f                	jle    802252 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022ce:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022d3:	c9                   	leaveq 
  8022d4:	c3                   	retq   

00000000008022d5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	48 83 ec 20          	sub    $0x20,%rsp
  8022dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022e8:	78 06                	js     8022f0 <fd_lookup+0x1b>
  8022ea:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022ee:	7e 07                	jle    8022f7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f5:	eb 6c                	jmp    802363 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022fa:	48 98                	cltq   
  8022fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802302:	48 c1 e0 0c          	shl    $0xc,%rax
  802306:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80230a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230e:	48 c1 e8 15          	shr    $0x15,%rax
  802312:	48 89 c2             	mov    %rax,%rdx
  802315:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80231c:	01 00 00 
  80231f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802323:	83 e0 01             	and    $0x1,%eax
  802326:	48 85 c0             	test   %rax,%rax
  802329:	74 21                	je     80234c <fd_lookup+0x77>
  80232b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232f:	48 c1 e8 0c          	shr    $0xc,%rax
  802333:	48 89 c2             	mov    %rax,%rdx
  802336:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80233d:	01 00 00 
  802340:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802344:	83 e0 01             	and    $0x1,%eax
  802347:	48 85 c0             	test   %rax,%rax
  80234a:	75 07                	jne    802353 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80234c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802351:	eb 10                	jmp    802363 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802357:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80235b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802363:	c9                   	leaveq 
  802364:	c3                   	retq   

0000000000802365 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802365:	55                   	push   %rbp
  802366:	48 89 e5             	mov    %rsp,%rbp
  802369:	48 83 ec 30          	sub    $0x30,%rsp
  80236d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802371:	89 f0                	mov    %esi,%eax
  802373:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80237a:	48 89 c7             	mov    %rax,%rdi
  80237d:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80238d:	48 89 d6             	mov    %rdx,%rsi
  802390:	89 c7                	mov    %eax,%edi
  802392:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802399:	00 00 00 
  80239c:	ff d0                	callq  *%rax
  80239e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a5:	78 0a                	js     8023b1 <fd_close+0x4c>
	    || fd != fd2)
  8023a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ab:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023af:	74 12                	je     8023c3 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023b1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023b5:	74 05                	je     8023bc <fd_close+0x57>
  8023b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ba:	eb 05                	jmp    8023c1 <fd_close+0x5c>
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c1:	eb 69                	jmp    80242c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c7:	8b 00                	mov    (%rax),%eax
  8023c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023cd:	48 89 d6             	mov    %rdx,%rsi
  8023d0:	89 c7                	mov    %eax,%edi
  8023d2:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e5:	78 2a                	js     802411 <fd_close+0xac>
		if (dev->dev_close)
  8023e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023ef:	48 85 c0             	test   %rax,%rax
  8023f2:	74 16                	je     80240a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802400:	48 89 d7             	mov    %rdx,%rdi
  802403:	ff d0                	callq  *%rax
  802405:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802408:	eb 07                	jmp    802411 <fd_close+0xac>
		else
			r = 0;
  80240a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802415:	48 89 c6             	mov    %rax,%rsi
  802418:	bf 00 00 00 00       	mov    $0x0,%edi
  80241d:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802424:	00 00 00 
  802427:	ff d0                	callq  *%rax
	return r;
  802429:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 20          	sub    $0x20,%rsp
  802436:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802439:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80243d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802444:	eb 41                	jmp    802487 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802446:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80244d:	00 00 00 
  802450:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802453:	48 63 d2             	movslq %edx,%rdx
  802456:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245a:	8b 00                	mov    (%rax),%eax
  80245c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80245f:	75 22                	jne    802483 <dev_lookup+0x55>
			*dev = devtab[i];
  802461:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802468:	00 00 00 
  80246b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80246e:	48 63 d2             	movslq %edx,%rdx
  802471:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802475:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802479:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	eb 60                	jmp    8024e3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802483:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802487:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80248e:	00 00 00 
  802491:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802494:	48 63 d2             	movslq %edx,%rdx
  802497:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249b:	48 85 c0             	test   %rax,%rax
  80249e:	75 a6                	jne    802446 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024a7:	00 00 00 
  8024aa:	48 8b 00             	mov    (%rax),%rax
  8024ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024b6:	89 c6                	mov    %eax,%esi
  8024b8:	48 bf a0 4d 80 00 00 	movabs $0x804da0,%rdi
  8024bf:	00 00 00 
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c7:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8024ce:	00 00 00 
  8024d1:	ff d1                	callq  *%rcx
	*dev = 0;
  8024d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024e3:	c9                   	leaveq 
  8024e4:	c3                   	retq   

00000000008024e5 <close>:

int
close(int fdnum)
{
  8024e5:	55                   	push   %rbp
  8024e6:	48 89 e5             	mov    %rsp,%rbp
  8024e9:	48 83 ec 20          	sub    $0x20,%rsp
  8024ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	79 05                	jns    802516 <close+0x31>
		return r;
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	eb 18                	jmp    80252e <close+0x49>
	else
		return fd_close(fd, 1);
  802516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251a:	be 01 00 00 00       	mov    $0x1,%esi
  80251f:	48 89 c7             	mov    %rax,%rdi
  802522:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
}
  80252e:	c9                   	leaveq 
  80252f:	c3                   	retq   

0000000000802530 <close_all>:

void
close_all(void)
{
  802530:	55                   	push   %rbp
  802531:	48 89 e5             	mov    %rsp,%rbp
  802534:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802538:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80253f:	eb 15                	jmp    802556 <close_all+0x26>
		close(i);
  802541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802544:	89 c7                	mov    %eax,%edi
  802546:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802552:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802556:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80255a:	7e e5                	jle    802541 <close_all+0x11>
		close(i);
}
  80255c:	c9                   	leaveq 
  80255d:	c3                   	retq   

000000000080255e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80255e:	55                   	push   %rbp
  80255f:	48 89 e5             	mov    %rsp,%rbp
  802562:	48 83 ec 40          	sub    $0x40,%rsp
  802566:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802569:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80256c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802570:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802573:	48 89 d6             	mov    %rdx,%rsi
  802576:	89 c7                	mov    %eax,%edi
  802578:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	79 08                	jns    802595 <dup+0x37>
		return r;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	e9 70 01 00 00       	jmpq   802705 <dup+0x1a7>
	close(newfdnum);
  802595:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802598:	89 c7                	mov    %eax,%edi
  80259a:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8025a1:	00 00 00 
  8025a4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025a9:	48 98                	cltq   
  8025ab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025b1:	48 c1 e0 0c          	shl    $0xc,%rax
  8025b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bd:	48 89 c7             	mov    %rax,%rdi
  8025c0:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  8025c7:	00 00 00 
  8025ca:	ff d0                	callq  *%rax
  8025cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d4:	48 89 c7             	mov    %rax,%rdi
  8025d7:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  8025de:	00 00 00 
  8025e1:	ff d0                	callq  *%rax
  8025e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	48 c1 e8 15          	shr    $0x15,%rax
  8025ef:	48 89 c2             	mov    %rax,%rdx
  8025f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f9:	01 00 00 
  8025fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802600:	83 e0 01             	and    $0x1,%eax
  802603:	48 85 c0             	test   %rax,%rax
  802606:	74 73                	je     80267b <dup+0x11d>
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	48 c1 e8 0c          	shr    $0xc,%rax
  802610:	48 89 c2             	mov    %rax,%rdx
  802613:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261a:	01 00 00 
  80261d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802621:	83 e0 01             	and    $0x1,%eax
  802624:	48 85 c0             	test   %rax,%rax
  802627:	74 52                	je     80267b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262d:	48 c1 e8 0c          	shr    $0xc,%rax
  802631:	48 89 c2             	mov    %rax,%rdx
  802634:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80263b:	01 00 00 
  80263e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802642:	25 07 0e 00 00       	and    $0xe07,%eax
  802647:	89 c1                	mov    %eax,%ecx
  802649:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80264d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802651:	41 89 c8             	mov    %ecx,%r8d
  802654:	48 89 d1             	mov    %rdx,%rcx
  802657:	ba 00 00 00 00       	mov    $0x0,%edx
  80265c:	48 89 c6             	mov    %rax,%rsi
  80265f:	bf 00 00 00 00       	mov    $0x0,%edi
  802664:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
  802670:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802677:	79 02                	jns    80267b <dup+0x11d>
			goto err;
  802679:	eb 57                	jmp    8026d2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80267b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80267f:	48 c1 e8 0c          	shr    $0xc,%rax
  802683:	48 89 c2             	mov    %rax,%rdx
  802686:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80268d:	01 00 00 
  802690:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802694:	25 07 0e 00 00       	and    $0xe07,%eax
  802699:	89 c1                	mov    %eax,%ecx
  80269b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80269f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a3:	41 89 c8             	mov    %ecx,%r8d
  8026a6:	48 89 d1             	mov    %rdx,%rcx
  8026a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ae:	48 89 c6             	mov    %rax,%rsi
  8026b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b6:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c9:	79 02                	jns    8026cd <dup+0x16f>
		goto err;
  8026cb:	eb 05                	jmp    8026d2 <dup+0x174>

	return newfdnum;
  8026cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d0:	eb 33                	jmp    802705 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d6:	48 89 c6             	mov    %rax,%rsi
  8026d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026de:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ee:	48 89 c6             	mov    %rax,%rsi
  8026f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f6:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
	return r;
  802702:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   

0000000000802707 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	48 83 ec 40          	sub    $0x40,%rsp
  80270f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802712:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802716:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80271a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80271e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802721:	48 89 d6             	mov    %rdx,%rsi
  802724:	89 c7                	mov    %eax,%edi
  802726:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  80272d:	00 00 00 
  802730:	ff d0                	callq  *%rax
  802732:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802735:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802739:	78 24                	js     80275f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80273b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273f:	8b 00                	mov    (%rax),%eax
  802741:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802745:	48 89 d6             	mov    %rdx,%rsi
  802748:	89 c7                	mov    %eax,%edi
  80274a:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802759:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275d:	79 05                	jns    802764 <read+0x5d>
		return r;
  80275f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802762:	eb 76                	jmp    8027da <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802768:	8b 40 08             	mov    0x8(%rax),%eax
  80276b:	83 e0 03             	and    $0x3,%eax
  80276e:	83 f8 01             	cmp    $0x1,%eax
  802771:	75 3a                	jne    8027ad <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802773:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80277a:	00 00 00 
  80277d:	48 8b 00             	mov    (%rax),%rax
  802780:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802786:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802789:	89 c6                	mov    %eax,%esi
  80278b:	48 bf bf 4d 80 00 00 	movabs $0x804dbf,%rdi
  802792:	00 00 00 
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8027a1:	00 00 00 
  8027a4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ab:	eb 2d                	jmp    8027da <read+0xd3>
	}
	if (!dev->dev_read)
  8027ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027b5:	48 85 c0             	test   %rax,%rax
  8027b8:	75 07                	jne    8027c1 <read+0xba>
		return -E_NOT_SUPP;
  8027ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027bf:	eb 19                	jmp    8027da <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027c9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027cd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027d1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027d5:	48 89 cf             	mov    %rcx,%rdi
  8027d8:	ff d0                	callq  *%rax
}
  8027da:	c9                   	leaveq 
  8027db:	c3                   	retq   

00000000008027dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027dc:	55                   	push   %rbp
  8027dd:	48 89 e5             	mov    %rsp,%rbp
  8027e0:	48 83 ec 30          	sub    $0x30,%rsp
  8027e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f6:	eb 49                	jmp    802841 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fb:	48 98                	cltq   
  8027fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802801:	48 29 c2             	sub    %rax,%rdx
  802804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802807:	48 63 c8             	movslq %eax,%rcx
  80280a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280e:	48 01 c1             	add    %rax,%rcx
  802811:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802814:	48 89 ce             	mov    %rcx,%rsi
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802828:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80282c:	79 05                	jns    802833 <readn+0x57>
			return m;
  80282e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802831:	eb 1c                	jmp    80284f <readn+0x73>
		if (m == 0)
  802833:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802837:	75 02                	jne    80283b <readn+0x5f>
			break;
  802839:	eb 11                	jmp    80284c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80283b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80283e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	48 98                	cltq   
  802846:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80284a:	72 ac                	jb     8027f8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80284c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80284f:	c9                   	leaveq 
  802850:	c3                   	retq   

0000000000802851 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802851:	55                   	push   %rbp
  802852:	48 89 e5             	mov    %rsp,%rbp
  802855:	48 83 ec 40          	sub    $0x40,%rsp
  802859:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80285c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802860:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802864:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802868:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80286b:	48 89 d6             	mov    %rdx,%rsi
  80286e:	89 c7                	mov    %eax,%edi
  802870:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax
  80287c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802883:	78 24                	js     8028a9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802889:	8b 00                	mov    (%rax),%eax
  80288b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80288f:	48 89 d6             	mov    %rdx,%rsi
  802892:	89 c7                	mov    %eax,%edi
  802894:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  80289b:	00 00 00 
  80289e:	ff d0                	callq  *%rax
  8028a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a7:	79 05                	jns    8028ae <write+0x5d>
		return r;
  8028a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ac:	eb 75                	jmp    802923 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b2:	8b 40 08             	mov    0x8(%rax),%eax
  8028b5:	83 e0 03             	and    $0x3,%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	75 3a                	jne    8028f6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028c3:	00 00 00 
  8028c6:	48 8b 00             	mov    (%rax),%rax
  8028c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028d2:	89 c6                	mov    %eax,%esi
  8028d4:	48 bf db 4d 80 00 00 	movabs $0x804ddb,%rdi
  8028db:	00 00 00 
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e3:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8028ea:	00 00 00 
  8028ed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f4:	eb 2d                	jmp    802923 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8028f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fa:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028fe:	48 85 c0             	test   %rax,%rax
  802901:	75 07                	jne    80290a <write+0xb9>
		return -E_NOT_SUPP;
  802903:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802908:	eb 19                	jmp    802923 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80290a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802912:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802916:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80291a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80291e:	48 89 cf             	mov    %rcx,%rdi
  802921:	ff d0                	callq  *%rax
}
  802923:	c9                   	leaveq 
  802924:	c3                   	retq   

0000000000802925 <seek>:

int
seek(int fdnum, off_t offset)
{
  802925:	55                   	push   %rbp
  802926:	48 89 e5             	mov    %rsp,%rbp
  802929:	48 83 ec 18          	sub    $0x18,%rsp
  80292d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802930:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802933:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802937:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80293a:	48 89 d6             	mov    %rdx,%rsi
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
  80294b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802952:	79 05                	jns    802959 <seek+0x34>
		return r;
  802954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802957:	eb 0f                	jmp    802968 <seek+0x43>
	fd->fd_offset = offset;
  802959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802960:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802968:	c9                   	leaveq 
  802969:	c3                   	retq   

000000000080296a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80296a:	55                   	push   %rbp
  80296b:	48 89 e5             	mov    %rsp,%rbp
  80296e:	48 83 ec 30          	sub    $0x30,%rsp
  802972:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802975:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802978:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297f:	48 89 d6             	mov    %rdx,%rsi
  802982:	89 c7                	mov    %eax,%edi
  802984:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	callq  *%rax
  802990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802997:	78 24                	js     8029bd <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299d:	8b 00                	mov    (%rax),%eax
  80299f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a3:	48 89 d6             	mov    %rdx,%rsi
  8029a6:	89 c7                	mov    %eax,%edi
  8029a8:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bb:	79 05                	jns    8029c2 <ftruncate+0x58>
		return r;
  8029bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c0:	eb 72                	jmp    802a34 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c6:	8b 40 08             	mov    0x8(%rax),%eax
  8029c9:	83 e0 03             	and    $0x3,%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	75 3a                	jne    802a0a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029d7:	00 00 00 
  8029da:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029dd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	48 bf f8 4d 80 00 00 	movabs $0x804df8,%rdi
  8029ef:	00 00 00 
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f7:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8029fe:	00 00 00 
  802a01:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a08:	eb 2a                	jmp    802a34 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a12:	48 85 c0             	test   %rax,%rax
  802a15:	75 07                	jne    802a1e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1c:	eb 16                	jmp    802a34 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a2a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a2d:	89 ce                	mov    %ecx,%esi
  802a2f:	48 89 d7             	mov    %rdx,%rdi
  802a32:	ff d0                	callq  *%rax
}
  802a34:	c9                   	leaveq 
  802a35:	c3                   	retq   

0000000000802a36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 83 ec 30          	sub    $0x30,%rsp
  802a3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a41:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a4c:	48 89 d6             	mov    %rdx,%rsi
  802a4f:	89 c7                	mov    %eax,%edi
  802a51:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	callq  *%rax
  802a5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a64:	78 24                	js     802a8a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6a:	8b 00                	mov    (%rax),%eax
  802a6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a70:	48 89 d6             	mov    %rdx,%rsi
  802a73:	89 c7                	mov    %eax,%edi
  802a75:	48 b8 2e 24 80 00 00 	movabs $0x80242e,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a88:	79 05                	jns    802a8f <fstat+0x59>
		return r;
  802a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8d:	eb 5e                	jmp    802aed <fstat+0xb7>
	if (!dev->dev_stat)
  802a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a93:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a97:	48 85 c0             	test   %rax,%rax
  802a9a:	75 07                	jne    802aa3 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a9c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aa1:	eb 4a                	jmp    802aed <fstat+0xb7>
	stat->st_name[0] = 0;
  802aa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802aaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aae:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ab5:	00 00 00 
	stat->st_isdir = 0;
  802ab8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802abc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ac3:	00 00 00 
	stat->st_dev = dev;
  802ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ace:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad9:	48 8b 40 28          	mov    0x28(%rax),%rax
  802add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ae5:	48 89 ce             	mov    %rcx,%rsi
  802ae8:	48 89 d7             	mov    %rdx,%rdi
  802aeb:	ff d0                	callq  *%rax
}
  802aed:	c9                   	leaveq 
  802aee:	c3                   	retq   

0000000000802aef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802aef:	55                   	push   %rbp
  802af0:	48 89 e5             	mov    %rsp,%rbp
  802af3:	48 83 ec 20          	sub    $0x20,%rsp
  802af7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802afb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b03:	be 00 00 00 00       	mov    $0x0,%esi
  802b08:	48 89 c7             	mov    %rax,%rdi
  802b0b:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1e:	79 05                	jns    802b25 <stat+0x36>
		return fd;
  802b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b23:	eb 2f                	jmp    802b54 <stat+0x65>
	r = fstat(fd, stat);
  802b25:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2c:	48 89 d6             	mov    %rdx,%rsi
  802b2f:	89 c7                	mov    %eax,%edi
  802b31:	48 b8 36 2a 80 00 00 	movabs $0x802a36,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b43:	89 c7                	mov    %eax,%edi
  802b45:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
	return r;
  802b51:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b54:	c9                   	leaveq 
  802b55:	c3                   	retq   

0000000000802b56 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b56:	55                   	push   %rbp
  802b57:	48 89 e5             	mov    %rsp,%rbp
  802b5a:	48 83 ec 10          	sub    $0x10,%rsp
  802b5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b65:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b6c:	00 00 00 
  802b6f:	8b 00                	mov    (%rax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	75 1d                	jne    802b92 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b75:	bf 01 00 00 00       	mov    $0x1,%edi
  802b7a:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  802b81:	00 00 00 
  802b84:	ff d0                	callq  *%rax
  802b86:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b8d:	00 00 00 
  802b90:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b92:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b99:	00 00 00 
  802b9c:	8b 00                	mov    (%rax),%eax
  802b9e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ba1:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ba6:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bad:	00 00 00 
  802bb0:	89 c7                	mov    %eax,%edi
  802bb2:	48 b8 d5 45 80 00 00 	movabs $0x8045d5,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc7:	48 89 c6             	mov    %rax,%rsi
  802bca:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcf:	48 b8 cf 44 80 00 00 	movabs $0x8044cf,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 30          	sub    $0x30,%rsp
  802be5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802be9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bec:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bf3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802c01:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c06:	75 08                	jne    802c10 <open+0x33>
	{
		return r;
  802c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0b:	e9 f2 00 00 00       	jmpq   802d02 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802c10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c14:	48 89 c7             	mov    %rax,%rdi
  802c17:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c26:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c2d:	7e 0a                	jle    802c39 <open+0x5c>
	{
		return -E_BAD_PATH;
  802c2f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c34:	e9 c9 00 00 00       	jmpq   802d02 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c39:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c40:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c41:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c45:	48 89 c7             	mov    %rax,%rdi
  802c48:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
  802c54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5b:	78 09                	js     802c66 <open+0x89>
  802c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c61:	48 85 c0             	test   %rax,%rax
  802c64:	75 08                	jne    802c6e <open+0x91>
		{
			return r;
  802c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c69:	e9 94 00 00 00       	jmpq   802d02 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c72:	ba 00 04 00 00       	mov    $0x400,%edx
  802c77:	48 89 c6             	mov    %rax,%rsi
  802c7a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c81:	00 00 00 
  802c84:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c90:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c97:	00 00 00 
  802c9a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c9d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca7:	48 89 c6             	mov    %rax,%rsi
  802caa:	bf 01 00 00 00       	mov    $0x1,%edi
  802caf:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
  802cbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc2:	79 2b                	jns    802cef <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc8:	be 00 00 00 00       	mov    $0x0,%esi
  802ccd:	48 89 c7             	mov    %rax,%rdi
  802cd0:	48 b8 65 23 80 00 00 	movabs $0x802365,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802cdf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ce3:	79 05                	jns    802cea <open+0x10d>
			{
				return d;
  802ce5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce8:	eb 18                	jmp    802d02 <open+0x125>
			}
			return r;
  802cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ced:	eb 13                	jmp    802d02 <open+0x125>
		}	
		return fd2num(fd_store);
  802cef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf3:	48 89 c7             	mov    %rax,%rdi
  802cf6:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802d02:	c9                   	leaveq 
  802d03:	c3                   	retq   

0000000000802d04 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d04:	55                   	push   %rbp
  802d05:	48 89 e5             	mov    %rsp,%rbp
  802d08:	48 83 ec 10          	sub    $0x10,%rsp
  802d0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d14:	8b 50 0c             	mov    0xc(%rax),%edx
  802d17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1e:	00 00 00 
  802d21:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d23:	be 00 00 00 00       	mov    $0x0,%esi
  802d28:	bf 06 00 00 00       	mov    $0x6,%edi
  802d2d:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
}
  802d39:	c9                   	leaveq 
  802d3a:	c3                   	retq   

0000000000802d3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d3b:	55                   	push   %rbp
  802d3c:	48 89 e5             	mov    %rsp,%rbp
  802d3f:	48 83 ec 30          	sub    $0x30,%rsp
  802d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d56:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d5b:	74 07                	je     802d64 <devfile_read+0x29>
  802d5d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d62:	75 07                	jne    802d6b <devfile_read+0x30>
		return -E_INVAL;
  802d64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d69:	eb 77                	jmp    802de2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6f:	8b 50 0c             	mov    0xc(%rax),%edx
  802d72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d79:	00 00 00 
  802d7c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d85:	00 00 00 
  802d88:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d8c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d90:	be 00 00 00 00       	mov    $0x0,%esi
  802d95:	bf 03 00 00 00       	mov    $0x3,%edi
  802d9a:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	7f 05                	jg     802db4 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	eb 2e                	jmp    802de2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db7:	48 63 d0             	movslq %eax,%rdx
  802dba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dbe:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dc5:	00 00 00 
  802dc8:	48 89 c7             	mov    %rax,%rdi
  802dcb:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802dd2:	00 00 00 
  802dd5:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802dd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ddb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802de2:	c9                   	leaveq 
  802de3:	c3                   	retq   

0000000000802de4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802de4:	55                   	push   %rbp
  802de5:	48 89 e5             	mov    %rsp,%rbp
  802de8:	48 83 ec 30          	sub    $0x30,%rsp
  802dec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802df4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802df8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802dff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e04:	74 07                	je     802e0d <devfile_write+0x29>
  802e06:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e0b:	75 08                	jne    802e15 <devfile_write+0x31>
		return r;
  802e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e10:	e9 9a 00 00 00       	jmpq   802eaf <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e19:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e23:	00 00 00 
  802e26:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802e28:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e2f:	00 
  802e30:	76 08                	jbe    802e3a <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e32:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e39:	00 
	}
	fsipcbuf.write.req_n = n;
  802e3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e41:	00 00 00 
  802e44:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e48:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e4c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e54:	48 89 c6             	mov    %rax,%rsi
  802e57:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e5e:	00 00 00 
  802e61:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e6d:	be 00 00 00 00       	mov    $0x0,%esi
  802e72:	bf 04 00 00 00       	mov    $0x4,%edi
  802e77:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
  802e83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8a:	7f 20                	jg     802eac <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e8c:	48 bf 1e 4e 80 00 00 	movabs $0x804e1e,%rdi
  802e93:	00 00 00 
  802e96:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9b:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  802ea2:	00 00 00 
  802ea5:	ff d2                	callq  *%rdx
		return r;
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	eb 03                	jmp    802eaf <devfile_write+0xcb>
	}
	return r;
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802eaf:	c9                   	leaveq 
  802eb0:	c3                   	retq   

0000000000802eb1 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802eb1:	55                   	push   %rbp
  802eb2:	48 89 e5             	mov    %rsp,%rbp
  802eb5:	48 83 ec 20          	sub    $0x20,%rsp
  802eb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ebd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ec1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec5:	8b 50 0c             	mov    0xc(%rax),%edx
  802ec8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ecf:	00 00 00 
  802ed2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ed4:	be 00 00 00 00       	mov    $0x0,%esi
  802ed9:	bf 05 00 00 00       	mov    $0x5,%edi
  802ede:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
  802eea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef1:	79 05                	jns    802ef8 <devfile_stat+0x47>
		return r;
  802ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef6:	eb 56                	jmp    802f4e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ef8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802efc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f03:	00 00 00 
  802f06:	48 89 c7             	mov    %rax,%rdi
  802f09:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802f10:	00 00 00 
  802f13:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f1c:	00 00 00 
  802f1f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f29:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f2f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f36:	00 00 00 
  802f39:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f43:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4e:	c9                   	leaveq 
  802f4f:	c3                   	retq   

0000000000802f50 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f50:	55                   	push   %rbp
  802f51:	48 89 e5             	mov    %rsp,%rbp
  802f54:	48 83 ec 10          	sub    $0x10,%rsp
  802f58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f5c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f63:	8b 50 0c             	mov    0xc(%rax),%edx
  802f66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f6d:	00 00 00 
  802f70:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f79:	00 00 00 
  802f7c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f7f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f82:	be 00 00 00 00       	mov    $0x0,%esi
  802f87:	bf 02 00 00 00       	mov    $0x2,%edi
  802f8c:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
}
  802f98:	c9                   	leaveq 
  802f99:	c3                   	retq   

0000000000802f9a <remove>:

// Delete a file
int
remove(const char *path)
{
  802f9a:	55                   	push   %rbp
  802f9b:	48 89 e5             	mov    %rsp,%rbp
  802f9e:	48 83 ec 10          	sub    $0x10,%rsp
  802fa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802faa:	48 89 c7             	mov    %rax,%rdi
  802fad:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
  802fb9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fbe:	7e 07                	jle    802fc7 <remove+0x2d>
		return -E_BAD_PATH;
  802fc0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fc5:	eb 33                	jmp    802ffa <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fcb:	48 89 c6             	mov    %rax,%rsi
  802fce:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fd5:	00 00 00 
  802fd8:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802fdf:	00 00 00 
  802fe2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fe4:	be 00 00 00 00       	mov    $0x0,%esi
  802fe9:	bf 07 00 00 00       	mov    $0x7,%edi
  802fee:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
}
  802ffa:	c9                   	leaveq 
  802ffb:	c3                   	retq   

0000000000802ffc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ffc:	55                   	push   %rbp
  802ffd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803000:	be 00 00 00 00       	mov    $0x0,%esi
  803005:	bf 08 00 00 00       	mov    $0x8,%edi
  80300a:	48 b8 56 2b 80 00 00 	movabs $0x802b56,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
}
  803016:	5d                   	pop    %rbp
  803017:	c3                   	retq   

0000000000803018 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803018:	55                   	push   %rbp
  803019:	48 89 e5             	mov    %rsp,%rbp
  80301c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803023:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80302a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803031:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803038:	be 00 00 00 00       	mov    $0x0,%esi
  80303d:	48 89 c7             	mov    %rax,%rdi
  803040:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
  80304c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80304f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803053:	79 28                	jns    80307d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803058:	89 c6                	mov    %eax,%esi
  80305a:	48 bf 3a 4e 80 00 00 	movabs $0x804e3a,%rdi
  803061:	00 00 00 
  803064:	b8 00 00 00 00       	mov    $0x0,%eax
  803069:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  803070:	00 00 00 
  803073:	ff d2                	callq  *%rdx
		return fd_src;
  803075:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803078:	e9 74 01 00 00       	jmpq   8031f1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80307d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803084:	be 01 01 00 00       	mov    $0x101,%esi
  803089:	48 89 c7             	mov    %rax,%rdi
  80308c:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
  803098:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80309b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80309f:	79 39                	jns    8030da <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a4:	89 c6                	mov    %eax,%esi
  8030a6:	48 bf 50 4e 80 00 00 	movabs $0x804e50,%rdi
  8030ad:	00 00 00 
  8030b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b5:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  8030bc:	00 00 00 
  8030bf:	ff d2                	callq  *%rdx
		close(fd_src);
  8030c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c4:	89 c7                	mov    %eax,%edi
  8030c6:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
		return fd_dest;
  8030d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d5:	e9 17 01 00 00       	jmpq   8031f1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030da:	eb 74                	jmp    803150 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030df:	48 63 d0             	movslq %eax,%rdx
  8030e2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ec:	48 89 ce             	mov    %rcx,%rsi
  8030ef:	89 c7                	mov    %eax,%edi
  8030f1:	48 b8 51 28 80 00 00 	movabs $0x802851,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803100:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803104:	79 4a                	jns    803150 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803106:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803109:	89 c6                	mov    %eax,%esi
  80310b:	48 bf 6a 4e 80 00 00 	movabs $0x804e6a,%rdi
  803112:	00 00 00 
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  803121:	00 00 00 
  803124:	ff d2                	callq  *%rdx
			close(fd_src);
  803126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803129:	89 c7                	mov    %eax,%edi
  80312b:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
			close(fd_dest);
  803137:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313a:	89 c7                	mov    %eax,%edi
  80313c:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
			return write_size;
  803148:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80314b:	e9 a1 00 00 00       	jmpq   8031f1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803150:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315a:	ba 00 02 00 00       	mov    $0x200,%edx
  80315f:	48 89 ce             	mov    %rcx,%rsi
  803162:	89 c7                	mov    %eax,%edi
  803164:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  80316b:	00 00 00 
  80316e:	ff d0                	callq  *%rax
  803170:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803173:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803177:	0f 8f 5f ff ff ff    	jg     8030dc <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80317d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803181:	79 47                	jns    8031ca <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803186:	89 c6                	mov    %eax,%esi
  803188:	48 bf 7d 4e 80 00 00 	movabs $0x804e7d,%rdi
  80318f:	00 00 00 
  803192:	b8 00 00 00 00       	mov    $0x0,%eax
  803197:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  80319e:	00 00 00 
  8031a1:	ff d2                	callq  *%rdx
		close(fd_src);
  8031a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a6:	89 c7                	mov    %eax,%edi
  8031a8:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
		close(fd_dest);
  8031b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b7:	89 c7                	mov    %eax,%edi
  8031b9:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
		return read_size;
  8031c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031c8:	eb 27                	jmp    8031f1 <copy+0x1d9>
	}
	close(fd_src);
  8031ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cd:	89 c7                	mov    %eax,%edi
  8031cf:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
	close(fd_dest);
  8031db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031de:	89 c7                	mov    %eax,%edi
  8031e0:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
	return 0;
  8031ec:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031f1:	c9                   	leaveq 
  8031f2:	c3                   	retq   

00000000008031f3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031f3:	55                   	push   %rbp
  8031f4:	48 89 e5             	mov    %rsp,%rbp
  8031f7:	48 83 ec 20          	sub    $0x20,%rsp
  8031fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803202:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803205:	48 89 d6             	mov    %rdx,%rsi
  803208:	89 c7                	mov    %eax,%edi
  80320a:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
  803216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321d:	79 05                	jns    803224 <fd2sockid+0x31>
		return r;
  80321f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803222:	eb 24                	jmp    803248 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803228:	8b 10                	mov    (%rax),%edx
  80322a:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803231:	00 00 00 
  803234:	8b 00                	mov    (%rax),%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	74 07                	je     803241 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80323a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80323f:	eb 07                	jmp    803248 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803245:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803248:	c9                   	leaveq 
  803249:	c3                   	retq   

000000000080324a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80324a:	55                   	push   %rbp
  80324b:	48 89 e5             	mov    %rsp,%rbp
  80324e:	48 83 ec 20          	sub    $0x20,%rsp
  803252:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803255:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803259:	48 89 c7             	mov    %rax,%rdi
  80325c:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
  803268:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326f:	78 26                	js     803297 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	ba 07 04 00 00       	mov    $0x407,%edx
  80327a:	48 89 c6             	mov    %rax,%rsi
  80327d:	bf 00 00 00 00       	mov    $0x0,%edi
  803282:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
  80328e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803295:	79 16                	jns    8032ad <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803297:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329a:	89 c7                	mov    %eax,%edi
  80329c:	48 b8 57 37 80 00 00 	movabs $0x803757,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
		return r;
  8032a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ab:	eb 3a                	jmp    8032e7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032b8:	00 00 00 
  8032bb:	8b 12                	mov    (%rdx),%edx
  8032bd:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ce:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032d1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d8:	48 89 c7             	mov    %rax,%rdi
  8032db:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
}
  8032e7:	c9                   	leaveq 
  8032e8:	c3                   	retq   

00000000008032e9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032e9:	55                   	push   %rbp
  8032ea:	48 89 e5             	mov    %rsp,%rbp
  8032ed:	48 83 ec 30          	sub    $0x30,%rsp
  8032f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 f3 31 80 00 00 	movabs $0x8031f3,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803310:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803314:	79 05                	jns    80331b <accept+0x32>
		return r;
  803316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803319:	eb 3b                	jmp    803356 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80331b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80331f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	48 89 ce             	mov    %rcx,%rsi
  803329:	89 c7                	mov    %eax,%edi
  80332b:	48 b8 34 36 80 00 00 	movabs $0x803634,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
  803337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333e:	79 05                	jns    803345 <accept+0x5c>
		return r;
  803340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803343:	eb 11                	jmp    803356 <accept+0x6d>
	return alloc_sockfd(r);
  803345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803348:	89 c7                	mov    %eax,%edi
  80334a:	48 b8 4a 32 80 00 00 	movabs $0x80324a,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
}
  803356:	c9                   	leaveq 
  803357:	c3                   	retq   

0000000000803358 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803358:	55                   	push   %rbp
  803359:	48 89 e5             	mov    %rsp,%rbp
  80335c:	48 83 ec 20          	sub    $0x20,%rsp
  803360:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803363:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803367:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80336a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336d:	89 c7                	mov    %eax,%edi
  80336f:	48 b8 f3 31 80 00 00 	movabs $0x8031f3,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
  80337b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803382:	79 05                	jns    803389 <bind+0x31>
		return r;
  803384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803387:	eb 1b                	jmp    8033a4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803389:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80338c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803393:	48 89 ce             	mov    %rcx,%rsi
  803396:	89 c7                	mov    %eax,%edi
  803398:	48 b8 b3 36 80 00 00 	movabs $0x8036b3,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
}
  8033a4:	c9                   	leaveq 
  8033a5:	c3                   	retq   

00000000008033a6 <shutdown>:

int
shutdown(int s, int how)
{
  8033a6:	55                   	push   %rbp
  8033a7:	48 89 e5             	mov    %rsp,%rbp
  8033aa:	48 83 ec 20          	sub    $0x20,%rsp
  8033ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b7:	89 c7                	mov    %eax,%edi
  8033b9:	48 b8 f3 31 80 00 00 	movabs $0x8031f3,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
  8033c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cc:	79 05                	jns    8033d3 <shutdown+0x2d>
		return r;
  8033ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d1:	eb 16                	jmp    8033e9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d9:	89 d6                	mov    %edx,%esi
  8033db:	89 c7                	mov    %eax,%edi
  8033dd:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 10          	sub    $0x10,%rsp
  8033f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033fb:	48 89 c7             	mov    %rax,%rdi
  8033fe:	48 b8 b9 46 80 00 00 	movabs $0x8046b9,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	83 f8 01             	cmp    $0x1,%eax
  80340d:	75 17                	jne    803426 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80340f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803413:	8b 40 0c             	mov    0xc(%rax),%eax
  803416:	89 c7                	mov    %eax,%edi
  803418:	48 b8 57 37 80 00 00 	movabs $0x803757,%rax
  80341f:	00 00 00 
  803422:	ff d0                	callq  *%rax
  803424:	eb 05                	jmp    80342b <devsock_close+0x40>
	else
		return 0;
  803426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342b:	c9                   	leaveq 
  80342c:	c3                   	retq   

000000000080342d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80342d:	55                   	push   %rbp
  80342e:	48 89 e5             	mov    %rsp,%rbp
  803431:	48 83 ec 20          	sub    $0x20,%rsp
  803435:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803438:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80343c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80343f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803442:	89 c7                	mov    %eax,%edi
  803444:	48 b8 f3 31 80 00 00 	movabs $0x8031f3,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803457:	79 05                	jns    80345e <connect+0x31>
		return r;
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345c:	eb 1b                	jmp    803479 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80345e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803461:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803468:	48 89 ce             	mov    %rcx,%rsi
  80346b:	89 c7                	mov    %eax,%edi
  80346d:	48 b8 84 37 80 00 00 	movabs $0x803784,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
}
  803479:	c9                   	leaveq 
  80347a:	c3                   	retq   

000000000080347b <listen>:

int
listen(int s, int backlog)
{
  80347b:	55                   	push   %rbp
  80347c:	48 89 e5             	mov    %rsp,%rbp
  80347f:	48 83 ec 20          	sub    $0x20,%rsp
  803483:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803486:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803489:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348c:	89 c7                	mov    %eax,%edi
  80348e:	48 b8 f3 31 80 00 00 	movabs $0x8031f3,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
  80349a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a1:	79 05                	jns    8034a8 <listen+0x2d>
		return r;
  8034a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a6:	eb 16                	jmp    8034be <listen+0x43>
	return nsipc_listen(r, backlog);
  8034a8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ae:	89 d6                	mov    %edx,%esi
  8034b0:	89 c7                	mov    %eax,%edi
  8034b2:	48 b8 e8 37 80 00 00 	movabs $0x8037e8,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
}
  8034be:	c9                   	leaveq 
  8034bf:	c3                   	retq   

00000000008034c0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034c0:	55                   	push   %rbp
  8034c1:	48 89 e5             	mov    %rsp,%rbp
  8034c4:	48 83 ec 20          	sub    $0x20,%rsp
  8034c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d8:	89 c2                	mov    %eax,%edx
  8034da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034de:	8b 40 0c             	mov    0xc(%rax),%eax
  8034e1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034ea:	89 c7                	mov    %eax,%edi
  8034ec:	48 b8 28 38 80 00 00 	movabs $0x803828,%rax
  8034f3:	00 00 00 
  8034f6:	ff d0                	callq  *%rax
}
  8034f8:	c9                   	leaveq 
  8034f9:	c3                   	retq   

00000000008034fa <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034fa:	55                   	push   %rbp
  8034fb:	48 89 e5             	mov    %rsp,%rbp
  8034fe:	48 83 ec 20          	sub    $0x20,%rsp
  803502:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803506:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80350a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80350e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803512:	89 c2                	mov    %eax,%edx
  803514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803518:	8b 40 0c             	mov    0xc(%rax),%eax
  80351b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80351f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803524:	89 c7                	mov    %eax,%edi
  803526:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 83 ec 10          	sub    $0x10,%rsp
  80353c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803540:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	48 be 98 4e 80 00 00 	movabs $0x804e98,%rsi
  80354f:	00 00 00 
  803552:	48 89 c7             	mov    %rax,%rdi
  803555:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
	return 0;
  803561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803566:	c9                   	leaveq 
  803567:	c3                   	retq   

0000000000803568 <socket>:

int
socket(int domain, int type, int protocol)
{
  803568:	55                   	push   %rbp
  803569:	48 89 e5             	mov    %rsp,%rbp
  80356c:	48 83 ec 20          	sub    $0x20,%rsp
  803570:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803573:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803576:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803579:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80357c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80357f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803582:	89 ce                	mov    %ecx,%esi
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 ac 39 80 00 00 	movabs $0x8039ac,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803595:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803599:	79 05                	jns    8035a0 <socket+0x38>
		return r;
  80359b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359e:	eb 11                	jmp    8035b1 <socket+0x49>
	return alloc_sockfd(r);
  8035a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a3:	89 c7                	mov    %eax,%edi
  8035a5:	48 b8 4a 32 80 00 00 	movabs $0x80324a,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
}
  8035b1:	c9                   	leaveq 
  8035b2:	c3                   	retq   

00000000008035b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035b3:	55                   	push   %rbp
  8035b4:	48 89 e5             	mov    %rsp,%rbp
  8035b7:	48 83 ec 10          	sub    $0x10,%rsp
  8035bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035be:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035c5:	00 00 00 
  8035c8:	8b 00                	mov    (%rax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	75 1d                	jne    8035eb <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035ce:	bf 02 00 00 00       	mov    $0x2,%edi
  8035d3:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
  8035df:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8035e6:	00 00 00 
  8035e9:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035eb:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035f2:	00 00 00 
  8035f5:	8b 00                	mov    (%rax),%eax
  8035f7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035fa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035ff:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803606:	00 00 00 
  803609:	89 c7                	mov    %eax,%edi
  80360b:	48 b8 d5 45 80 00 00 	movabs $0x8045d5,%rax
  803612:	00 00 00 
  803615:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803617:	ba 00 00 00 00       	mov    $0x0,%edx
  80361c:	be 00 00 00 00       	mov    $0x0,%esi
  803621:	bf 00 00 00 00       	mov    $0x0,%edi
  803626:	48 b8 cf 44 80 00 00 	movabs $0x8044cf,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
}
  803632:	c9                   	leaveq 
  803633:	c3                   	retq   

0000000000803634 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803634:	55                   	push   %rbp
  803635:	48 89 e5             	mov    %rsp,%rbp
  803638:	48 83 ec 30          	sub    $0x30,%rsp
  80363c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80363f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803643:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803647:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364e:	00 00 00 
  803651:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803654:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803656:	bf 01 00 00 00       	mov    $0x1,%edi
  80365b:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
  803667:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366e:	78 3e                	js     8036ae <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803670:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803677:	00 00 00 
  80367a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80367e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803682:	8b 40 10             	mov    0x10(%rax),%eax
  803685:	89 c2                	mov    %eax,%edx
  803687:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80368b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368f:	48 89 ce             	mov    %rcx,%rsi
  803692:	48 89 c7             	mov    %rax,%rdi
  803695:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a5:	8b 50 10             	mov    0x10(%rax),%edx
  8036a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ac:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 10          	sub    $0x10,%rsp
  8036bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036c2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036cc:	00 00 00 
  8036cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036db:	48 89 c6             	mov    %rax,%rsi
  8036de:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036e5:	00 00 00 
  8036e8:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fb:	00 00 00 
  8036fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803701:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803704:	bf 02 00 00 00       	mov    $0x2,%edi
  803709:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 10          	sub    $0x10,%rsp
  80371f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803722:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803725:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372c:	00 00 00 
  80372f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803732:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803734:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373b:	00 00 00 
  80373e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803741:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803744:	bf 03 00 00 00       	mov    $0x3,%edi
  803749:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  803750:	00 00 00 
  803753:	ff d0                	callq  *%rax
}
  803755:	c9                   	leaveq 
  803756:	c3                   	retq   

0000000000803757 <nsipc_close>:

int
nsipc_close(int s)
{
  803757:	55                   	push   %rbp
  803758:	48 89 e5             	mov    %rsp,%rbp
  80375b:	48 83 ec 10          	sub    $0x10,%rsp
  80375f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803762:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803769:	00 00 00 
  80376c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80376f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803771:	bf 04 00 00 00       	mov    $0x4,%edi
  803776:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
}
  803782:	c9                   	leaveq 
  803783:	c3                   	retq   

0000000000803784 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803784:	55                   	push   %rbp
  803785:	48 89 e5             	mov    %rsp,%rbp
  803788:	48 83 ec 10          	sub    $0x10,%rsp
  80378c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80378f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803793:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803796:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379d:	00 00 00 
  8037a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037a5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ac:	48 89 c6             	mov    %rax,%rsi
  8037af:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037b6:	00 00 00 
  8037b9:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037cc:	00 00 00 
  8037cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037d2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8037da:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
}
  8037e6:	c9                   	leaveq 
  8037e7:	c3                   	retq   

00000000008037e8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037e8:	55                   	push   %rbp
  8037e9:	48 89 e5             	mov    %rsp,%rbp
  8037ec:	48 83 ec 10          	sub    $0x10,%rsp
  8037f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fd:	00 00 00 
  803800:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803803:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803805:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380c:	00 00 00 
  80380f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803812:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803815:	bf 06 00 00 00       	mov    $0x6,%edi
  80381a:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
}
  803826:	c9                   	leaveq 
  803827:	c3                   	retq   

0000000000803828 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803828:	55                   	push   %rbp
  803829:	48 89 e5             	mov    %rsp,%rbp
  80382c:	48 83 ec 30          	sub    $0x30,%rsp
  803830:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803833:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803837:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80383a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80383d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803844:	00 00 00 
  803847:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80384a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80384c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803853:	00 00 00 
  803856:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803859:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80385c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803863:	00 00 00 
  803866:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803869:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80386c:	bf 07 00 00 00       	mov    $0x7,%edi
  803871:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803884:	78 69                	js     8038ef <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803886:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80388d:	7f 08                	jg     803897 <nsipc_recv+0x6f>
  80388f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803892:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803895:	7e 35                	jle    8038cc <nsipc_recv+0xa4>
  803897:	48 b9 9f 4e 80 00 00 	movabs $0x804e9f,%rcx
  80389e:	00 00 00 
  8038a1:	48 ba b4 4e 80 00 00 	movabs $0x804eb4,%rdx
  8038a8:	00 00 00 
  8038ab:	be 61 00 00 00       	mov    $0x61,%esi
  8038b0:	48 bf c9 4e 80 00 00 	movabs $0x804ec9,%rdi
  8038b7:	00 00 00 
  8038ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bf:	49 b8 7b 42 80 00 00 	movabs $0x80427b,%r8
  8038c6:	00 00 00 
  8038c9:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cf:	48 63 d0             	movslq %eax,%rdx
  8038d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d6:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038dd:	00 00 00 
  8038e0:	48 89 c7             	mov    %rax,%rdi
  8038e3:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
	}

	return r;
  8038ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038f2:	c9                   	leaveq 
  8038f3:	c3                   	retq   

00000000008038f4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038f4:	55                   	push   %rbp
  8038f5:	48 89 e5             	mov    %rsp,%rbp
  8038f8:	48 83 ec 20          	sub    $0x20,%rsp
  8038fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803903:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803906:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803909:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803910:	00 00 00 
  803913:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803916:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803918:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80391f:	7e 35                	jle    803956 <nsipc_send+0x62>
  803921:	48 b9 d5 4e 80 00 00 	movabs $0x804ed5,%rcx
  803928:	00 00 00 
  80392b:	48 ba b4 4e 80 00 00 	movabs $0x804eb4,%rdx
  803932:	00 00 00 
  803935:	be 6c 00 00 00       	mov    $0x6c,%esi
  80393a:	48 bf c9 4e 80 00 00 	movabs $0x804ec9,%rdi
  803941:	00 00 00 
  803944:	b8 00 00 00 00       	mov    $0x0,%eax
  803949:	49 b8 7b 42 80 00 00 	movabs $0x80427b,%r8
  803950:	00 00 00 
  803953:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803956:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803959:	48 63 d0             	movslq %eax,%rdx
  80395c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803960:	48 89 c6             	mov    %rax,%rsi
  803963:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80396a:	00 00 00 
  80396d:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803979:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803980:	00 00 00 
  803983:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803986:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803989:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803990:	00 00 00 
  803993:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803996:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803999:	bf 08 00 00 00       	mov    $0x8,%edi
  80399e:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
}
  8039aa:	c9                   	leaveq 
  8039ab:	c3                   	retq   

00000000008039ac <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039ac:	55                   	push   %rbp
  8039ad:	48 89 e5             	mov    %rsp,%rbp
  8039b0:	48 83 ec 10          	sub    $0x10,%rsp
  8039b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039ba:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c4:	00 00 00 
  8039c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ca:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d3:	00 00 00 
  8039d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e3:	00 00 00 
  8039e6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039e9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039ec:	bf 09 00 00 00       	mov    $0x9,%edi
  8039f1:	48 b8 b3 35 80 00 00 	movabs $0x8035b3,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
}
  8039fd:	c9                   	leaveq 
  8039fe:	c3                   	retq   

00000000008039ff <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039ff:	55                   	push   %rbp
  803a00:	48 89 e5             	mov    %rsp,%rbp
  803a03:	53                   	push   %rbx
  803a04:	48 83 ec 38          	sub    $0x38,%rsp
  803a08:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a0c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a10:	48 89 c7             	mov    %rax,%rdi
  803a13:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
  803a1f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a22:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a26:	0f 88 bf 01 00 00    	js     803beb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a30:	ba 07 04 00 00       	mov    $0x407,%edx
  803a35:	48 89 c6             	mov    %rax,%rsi
  803a38:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3d:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803a44:	00 00 00 
  803a47:	ff d0                	callq  *%rax
  803a49:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a50:	0f 88 95 01 00 00    	js     803beb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a56:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a5a:	48 89 c7             	mov    %rax,%rdi
  803a5d:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  803a64:	00 00 00 
  803a67:	ff d0                	callq  *%rax
  803a69:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a70:	0f 88 5d 01 00 00    	js     803bd3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7a:	ba 07 04 00 00       	mov    $0x407,%edx
  803a7f:	48 89 c6             	mov    %rax,%rsi
  803a82:	bf 00 00 00 00       	mov    $0x0,%edi
  803a87:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
  803a93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a9a:	0f 88 33 01 00 00    	js     803bd3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa4:	48 89 c7             	mov    %rax,%rdi
  803aa7:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803aae:	00 00 00 
  803ab1:	ff d0                	callq  *%rax
  803ab3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ab7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abb:	ba 07 04 00 00       	mov    $0x407,%edx
  803ac0:	48 89 c6             	mov    %rax,%rsi
  803ac3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac8:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803acf:	00 00 00 
  803ad2:	ff d0                	callq  *%rax
  803ad4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ad7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803adb:	79 05                	jns    803ae2 <pipe+0xe3>
		goto err2;
  803add:	e9 d9 00 00 00       	jmpq   803bbb <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae6:	48 89 c7             	mov    %rax,%rdi
  803ae9:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
  803af5:	48 89 c2             	mov    %rax,%rdx
  803af8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b02:	48 89 d1             	mov    %rdx,%rcx
  803b05:	ba 00 00 00 00       	mov    $0x0,%edx
  803b0a:	48 89 c6             	mov    %rax,%rsi
  803b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b12:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
  803b1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b25:	79 1b                	jns    803b42 <pipe+0x143>
		goto err3;
  803b27:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2c:	48 89 c6             	mov    %rax,%rsi
  803b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b34:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
  803b40:	eb 79                	jmp    803bbb <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b46:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4d:	00 00 00 
  803b50:	8b 12                	mov    (%rdx),%edx
  803b52:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b63:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b6a:	00 00 00 
  803b6d:	8b 12                	mov    (%rdx),%edx
  803b6f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b75:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b80:	48 89 c7             	mov    %rax,%rdi
  803b83:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
  803b8f:	89 c2                	mov    %eax,%edx
  803b91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b95:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b9b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba3:	48 89 c7             	mov    %rax,%rdi
  803ba6:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
  803bb2:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb9:	eb 33                	jmp    803bee <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803bbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbf:	48 89 c6             	mov    %rax,%rsi
  803bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc7:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803bce:	00 00 00 
  803bd1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd7:	48 89 c6             	mov    %rax,%rsi
  803bda:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdf:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
err:
	return r;
  803beb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bee:	48 83 c4 38          	add    $0x38,%rsp
  803bf2:	5b                   	pop    %rbx
  803bf3:	5d                   	pop    %rbp
  803bf4:	c3                   	retq   

0000000000803bf5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bf5:	55                   	push   %rbp
  803bf6:	48 89 e5             	mov    %rsp,%rbp
  803bf9:	53                   	push   %rbx
  803bfa:	48 83 ec 28          	sub    $0x28,%rsp
  803bfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c06:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c0d:	00 00 00 
  803c10:	48 8b 00             	mov    (%rax),%rax
  803c13:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c19:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c20:	48 89 c7             	mov    %rax,%rdi
  803c23:	48 b8 b9 46 80 00 00 	movabs $0x8046b9,%rax
  803c2a:	00 00 00 
  803c2d:	ff d0                	callq  *%rax
  803c2f:	89 c3                	mov    %eax,%ebx
  803c31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c35:	48 89 c7             	mov    %rax,%rdi
  803c38:	48 b8 b9 46 80 00 00 	movabs $0x8046b9,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
  803c44:	39 c3                	cmp    %eax,%ebx
  803c46:	0f 94 c0             	sete   %al
  803c49:	0f b6 c0             	movzbl %al,%eax
  803c4c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c4f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c56:	00 00 00 
  803c59:	48 8b 00             	mov    (%rax),%rax
  803c5c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c62:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c68:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c6b:	75 05                	jne    803c72 <_pipeisclosed+0x7d>
			return ret;
  803c6d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c70:	eb 4f                	jmp    803cc1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c75:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c78:	74 42                	je     803cbc <_pipeisclosed+0xc7>
  803c7a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c7e:	75 3c                	jne    803cbc <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c87:	00 00 00 
  803c8a:	48 8b 00             	mov    (%rax),%rax
  803c8d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c93:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c99:	89 c6                	mov    %eax,%esi
  803c9b:	48 bf e6 4e 80 00 00 	movabs $0x804ee6,%rdi
  803ca2:	00 00 00 
  803ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  803caa:	49 b8 38 03 80 00 00 	movabs $0x800338,%r8
  803cb1:	00 00 00 
  803cb4:	41 ff d0             	callq  *%r8
	}
  803cb7:	e9 4a ff ff ff       	jmpq   803c06 <_pipeisclosed+0x11>
  803cbc:	e9 45 ff ff ff       	jmpq   803c06 <_pipeisclosed+0x11>
}
  803cc1:	48 83 c4 28          	add    $0x28,%rsp
  803cc5:	5b                   	pop    %rbx
  803cc6:	5d                   	pop    %rbp
  803cc7:	c3                   	retq   

0000000000803cc8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803cc8:	55                   	push   %rbp
  803cc9:	48 89 e5             	mov    %rsp,%rbp
  803ccc:	48 83 ec 30          	sub    $0x30,%rsp
  803cd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cd7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cda:	48 89 d6             	mov    %rdx,%rsi
  803cdd:	89 c7                	mov    %eax,%edi
  803cdf:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf2:	79 05                	jns    803cf9 <pipeisclosed+0x31>
		return r;
  803cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf7:	eb 31                	jmp    803d2a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cfd:	48 89 c7             	mov    %rax,%rdi
  803d00:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803d07:	00 00 00 
  803d0a:	ff d0                	callq  *%rax
  803d0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d18:	48 89 d6             	mov    %rdx,%rsi
  803d1b:	48 89 c7             	mov    %rax,%rdi
  803d1e:	48 b8 f5 3b 80 00 00 	movabs $0x803bf5,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
}
  803d2a:	c9                   	leaveq 
  803d2b:	c3                   	retq   

0000000000803d2c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d2c:	55                   	push   %rbp
  803d2d:	48 89 e5             	mov    %rsp,%rbp
  803d30:	48 83 ec 40          	sub    $0x40,%rsp
  803d34:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d3c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d44:	48 89 c7             	mov    %rax,%rdi
  803d47:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d5f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d66:	00 
  803d67:	e9 92 00 00 00       	jmpq   803dfe <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d6c:	eb 41                	jmp    803daf <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d6e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d73:	74 09                	je     803d7e <devpipe_read+0x52>
				return i;
  803d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d79:	e9 92 00 00 00       	jmpq   803e10 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d86:	48 89 d6             	mov    %rdx,%rsi
  803d89:	48 89 c7             	mov    %rax,%rdi
  803d8c:	48 b8 f5 3b 80 00 00 	movabs $0x803bf5,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
  803d98:	85 c0                	test   %eax,%eax
  803d9a:	74 07                	je     803da3 <devpipe_read+0x77>
				return 0;
  803d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803da1:	eb 6d                	jmp    803e10 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803da3:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db3:	8b 10                	mov    (%rax),%edx
  803db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db9:	8b 40 04             	mov    0x4(%rax),%eax
  803dbc:	39 c2                	cmp    %eax,%edx
  803dbe:	74 ae                	je     803d6e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dc8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd0:	8b 00                	mov    (%rax),%eax
  803dd2:	99                   	cltd   
  803dd3:	c1 ea 1b             	shr    $0x1b,%edx
  803dd6:	01 d0                	add    %edx,%eax
  803dd8:	83 e0 1f             	and    $0x1f,%eax
  803ddb:	29 d0                	sub    %edx,%eax
  803ddd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803de1:	48 98                	cltq   
  803de3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803de8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dee:	8b 00                	mov    (%rax),%eax
  803df0:	8d 50 01             	lea    0x1(%rax),%edx
  803df3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803df9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e02:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e06:	0f 82 60 ff ff ff    	jb     803d6c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e10:	c9                   	leaveq 
  803e11:	c3                   	retq   

0000000000803e12 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e12:	55                   	push   %rbp
  803e13:	48 89 e5             	mov    %rsp,%rbp
  803e16:	48 83 ec 40          	sub    $0x40,%rsp
  803e1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e1e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e22:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e2a:	48 89 c7             	mov    %rax,%rdi
  803e2d:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803e34:	00 00 00 
  803e37:	ff d0                	callq  *%rax
  803e39:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e45:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e4c:	00 
  803e4d:	e9 8e 00 00 00       	jmpq   803ee0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e52:	eb 31                	jmp    803e85 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5c:	48 89 d6             	mov    %rdx,%rsi
  803e5f:	48 89 c7             	mov    %rax,%rdi
  803e62:	48 b8 f5 3b 80 00 00 	movabs $0x803bf5,%rax
  803e69:	00 00 00 
  803e6c:	ff d0                	callq  *%rax
  803e6e:	85 c0                	test   %eax,%eax
  803e70:	74 07                	je     803e79 <devpipe_write+0x67>
				return 0;
  803e72:	b8 00 00 00 00       	mov    $0x0,%eax
  803e77:	eb 79                	jmp    803ef2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e79:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e89:	8b 40 04             	mov    0x4(%rax),%eax
  803e8c:	48 63 d0             	movslq %eax,%rdx
  803e8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e93:	8b 00                	mov    (%rax),%eax
  803e95:	48 98                	cltq   
  803e97:	48 83 c0 20          	add    $0x20,%rax
  803e9b:	48 39 c2             	cmp    %rax,%rdx
  803e9e:	73 b4                	jae    803e54 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea4:	8b 40 04             	mov    0x4(%rax),%eax
  803ea7:	99                   	cltd   
  803ea8:	c1 ea 1b             	shr    $0x1b,%edx
  803eab:	01 d0                	add    %edx,%eax
  803ead:	83 e0 1f             	and    $0x1f,%eax
  803eb0:	29 d0                	sub    %edx,%eax
  803eb2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803eb6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803eba:	48 01 ca             	add    %rcx,%rdx
  803ebd:	0f b6 0a             	movzbl (%rdx),%ecx
  803ec0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ec4:	48 98                	cltq   
  803ec6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ece:	8b 40 04             	mov    0x4(%rax),%eax
  803ed1:	8d 50 01             	lea    0x1(%rax),%edx
  803ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803edb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ee8:	0f 82 64 ff ff ff    	jb     803e52 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ef2:	c9                   	leaveq 
  803ef3:	c3                   	retq   

0000000000803ef4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ef4:	55                   	push   %rbp
  803ef5:	48 89 e5             	mov    %rsp,%rbp
  803ef8:	48 83 ec 20          	sub    $0x20,%rsp
  803efc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f08:	48 89 c7             	mov    %rax,%rdi
  803f0b:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803f12:	00 00 00 
  803f15:	ff d0                	callq  *%rax
  803f17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f1f:	48 be f9 4e 80 00 00 	movabs $0x804ef9,%rsi
  803f26:	00 00 00 
  803f29:	48 89 c7             	mov    %rax,%rdi
  803f2c:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3c:	8b 50 04             	mov    0x4(%rax),%edx
  803f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f43:	8b 00                	mov    (%rax),%eax
  803f45:	29 c2                	sub    %eax,%edx
  803f47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f4b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f55:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f5c:	00 00 00 
	stat->st_dev = &devpipe;
  803f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f63:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f6a:	00 00 00 
  803f6d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f79:	c9                   	leaveq 
  803f7a:	c3                   	retq   

0000000000803f7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f7b:	55                   	push   %rbp
  803f7c:	48 89 e5             	mov    %rsp,%rbp
  803f7f:	48 83 ec 10          	sub    $0x10,%rsp
  803f83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8b:	48 89 c6             	mov    %rax,%rsi
  803f8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f93:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803f9a:	00 00 00 
  803f9d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa3:	48 89 c7             	mov    %rax,%rdi
  803fa6:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  803fad:	00 00 00 
  803fb0:	ff d0                	callq  *%rax
  803fb2:	48 89 c6             	mov    %rax,%rsi
  803fb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fba:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
}
  803fc6:	c9                   	leaveq 
  803fc7:	c3                   	retq   

0000000000803fc8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fc8:	55                   	push   %rbp
  803fc9:	48 89 e5             	mov    %rsp,%rbp
  803fcc:	48 83 ec 20          	sub    $0x20,%rsp
  803fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fd6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fd9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803fdd:	be 01 00 00 00       	mov    $0x1,%esi
  803fe2:	48 89 c7             	mov    %rax,%rdi
  803fe5:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <getchar>:

int
getchar(void)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ffb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fff:	ba 01 00 00 00       	mov    $0x1,%edx
  804004:	48 89 c6             	mov    %rax,%rsi
  804007:	bf 00 00 00 00       	mov    $0x0,%edi
  80400c:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80401b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401f:	79 05                	jns    804026 <getchar+0x33>
		return r;
  804021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804024:	eb 14                	jmp    80403a <getchar+0x47>
	if (r < 1)
  804026:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402a:	7f 07                	jg     804033 <getchar+0x40>
		return -E_EOF;
  80402c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804031:	eb 07                	jmp    80403a <getchar+0x47>
	return c;
  804033:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804037:	0f b6 c0             	movzbl %al,%eax
}
  80403a:	c9                   	leaveq 
  80403b:	c3                   	retq   

000000000080403c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 83 ec 20          	sub    $0x20,%rsp
  804044:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804047:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80404b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80404e:	48 89 d6             	mov    %rdx,%rsi
  804051:	89 c7                	mov    %eax,%edi
  804053:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  80405a:	00 00 00 
  80405d:	ff d0                	callq  *%rax
  80405f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804066:	79 05                	jns    80406d <iscons+0x31>
		return r;
  804068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406b:	eb 1a                	jmp    804087 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804071:	8b 10                	mov    (%rax),%edx
  804073:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80407a:	00 00 00 
  80407d:	8b 00                	mov    (%rax),%eax
  80407f:	39 c2                	cmp    %eax,%edx
  804081:	0f 94 c0             	sete   %al
  804084:	0f b6 c0             	movzbl %al,%eax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <opencons>:

int
opencons(void)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804091:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804095:	48 89 c7             	mov    %rax,%rdi
  804098:	48 b8 3d 22 80 00 00 	movabs $0x80223d,%rax
  80409f:	00 00 00 
  8040a2:	ff d0                	callq  *%rax
  8040a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ab:	79 05                	jns    8040b2 <opencons+0x29>
		return r;
  8040ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b0:	eb 5b                	jmp    80410d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8040bb:	48 89 c6             	mov    %rax,%rsi
  8040be:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c3:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d6:	79 05                	jns    8040dd <opencons+0x54>
		return r;
  8040d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040db:	eb 30                	jmp    80410d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040e8:	00 00 00 
  8040eb:	8b 12                	mov    (%rdx),%edx
  8040ed:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fe:	48 89 c7             	mov    %rax,%rdi
  804101:	48 b8 ef 21 80 00 00 	movabs $0x8021ef,%rax
  804108:	00 00 00 
  80410b:	ff d0                	callq  *%rax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 83 ec 30          	sub    $0x30,%rsp
  804117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80411b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804123:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804128:	75 07                	jne    804131 <devcons_read+0x22>
		return 0;
  80412a:	b8 00 00 00 00       	mov    $0x0,%eax
  80412f:	eb 4b                	jmp    80417c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804131:	eb 0c                	jmp    80413f <devcons_read+0x30>
		sys_yield();
  804133:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80413f:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  804146:	00 00 00 
  804149:	ff d0                	callq  *%rax
  80414b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804152:	74 df                	je     804133 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804154:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804158:	79 05                	jns    80415f <devcons_read+0x50>
		return c;
  80415a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415d:	eb 1d                	jmp    80417c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80415f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804163:	75 07                	jne    80416c <devcons_read+0x5d>
		return 0;
  804165:	b8 00 00 00 00       	mov    $0x0,%eax
  80416a:	eb 10                	jmp    80417c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80416c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416f:	89 c2                	mov    %eax,%edx
  804171:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804175:	88 10                	mov    %dl,(%rax)
	return 1;
  804177:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80417c:	c9                   	leaveq 
  80417d:	c3                   	retq   

000000000080417e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80417e:	55                   	push   %rbp
  80417f:	48 89 e5             	mov    %rsp,%rbp
  804182:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804189:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804190:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804197:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80419e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041a5:	eb 76                	jmp    80421d <devcons_write+0x9f>
		m = n - tot;
  8041a7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041ae:	89 c2                	mov    %eax,%edx
  8041b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b3:	29 c2                	sub    %eax,%edx
  8041b5:	89 d0                	mov    %edx,%eax
  8041b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041bd:	83 f8 7f             	cmp    $0x7f,%eax
  8041c0:	76 07                	jbe    8041c9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041c2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041cc:	48 63 d0             	movslq %eax,%rdx
  8041cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d2:	48 63 c8             	movslq %eax,%rcx
  8041d5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041dc:	48 01 c1             	add    %rax,%rcx
  8041df:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041e6:	48 89 ce             	mov    %rcx,%rsi
  8041e9:	48 89 c7             	mov    %rax,%rdi
  8041ec:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041fb:	48 63 d0             	movslq %eax,%rdx
  8041fe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804205:	48 89 d6             	mov    %rdx,%rsi
  804208:	48 89 c7             	mov    %rax,%rdi
  80420b:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804217:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80421a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80421d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804220:	48 98                	cltq   
  804222:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804229:	0f 82 78 ff ff ff    	jb     8041a7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80422f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804232:	c9                   	leaveq 
  804233:	c3                   	retq   

0000000000804234 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804234:	55                   	push   %rbp
  804235:	48 89 e5             	mov    %rsp,%rbp
  804238:	48 83 ec 08          	sub    $0x8,%rsp
  80423c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804245:	c9                   	leaveq 
  804246:	c3                   	retq   

0000000000804247 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804247:	55                   	push   %rbp
  804248:	48 89 e5             	mov    %rsp,%rbp
  80424b:	48 83 ec 10          	sub    $0x10,%rsp
  80424f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804253:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425b:	48 be 05 4f 80 00 00 	movabs $0x804f05,%rsi
  804262:	00 00 00 
  804265:	48 89 c7             	mov    %rax,%rdi
  804268:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80426f:	00 00 00 
  804272:	ff d0                	callq  *%rax
	return 0;
  804274:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804279:	c9                   	leaveq 
  80427a:	c3                   	retq   

000000000080427b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80427b:	55                   	push   %rbp
  80427c:	48 89 e5             	mov    %rsp,%rbp
  80427f:	53                   	push   %rbx
  804280:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804287:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80428e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804294:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80429b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8042a2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8042a9:	84 c0                	test   %al,%al
  8042ab:	74 23                	je     8042d0 <_panic+0x55>
  8042ad:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8042b4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8042b8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8042bc:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8042c0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8042c4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8042c8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8042cc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8042d0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8042d7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8042de:	00 00 00 
  8042e1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8042e8:	00 00 00 
  8042eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8042ef:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8042f6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042fd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804304:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80430b:	00 00 00 
  80430e:	48 8b 18             	mov    (%rax),%rbx
  804311:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  804318:	00 00 00 
  80431b:	ff d0                	callq  *%rax
  80431d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804323:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80432a:	41 89 c8             	mov    %ecx,%r8d
  80432d:	48 89 d1             	mov    %rdx,%rcx
  804330:	48 89 da             	mov    %rbx,%rdx
  804333:	89 c6                	mov    %eax,%esi
  804335:	48 bf 10 4f 80 00 00 	movabs $0x804f10,%rdi
  80433c:	00 00 00 
  80433f:	b8 00 00 00 00       	mov    $0x0,%eax
  804344:	49 b9 38 03 80 00 00 	movabs $0x800338,%r9
  80434b:	00 00 00 
  80434e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804351:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804358:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80435f:	48 89 d6             	mov    %rdx,%rsi
  804362:	48 89 c7             	mov    %rax,%rdi
  804365:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  80436c:	00 00 00 
  80436f:	ff d0                	callq  *%rax
	cprintf("\n");
  804371:	48 bf 33 4f 80 00 00 	movabs $0x804f33,%rdi
  804378:	00 00 00 
  80437b:	b8 00 00 00 00       	mov    $0x0,%eax
  804380:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  804387:	00 00 00 
  80438a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80438c:	cc                   	int3   
  80438d:	eb fd                	jmp    80438c <_panic+0x111>

000000000080438f <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80438f:	55                   	push   %rbp
  804390:	48 89 e5             	mov    %rsp,%rbp
  804393:	48 83 ec 10          	sub    $0x10,%rsp
  804397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80439b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a2:	00 00 00 
  8043a5:	48 8b 00             	mov    (%rax),%rax
  8043a8:	48 85 c0             	test   %rax,%rax
  8043ab:	0f 85 84 00 00 00    	jne    804435 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8043b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043b8:	00 00 00 
  8043bb:	48 8b 00             	mov    (%rax),%rax
  8043be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043c4:	ba 07 00 00 00       	mov    $0x7,%edx
  8043c9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8043ce:	89 c7                	mov    %eax,%edi
  8043d0:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8043d7:	00 00 00 
  8043da:	ff d0                	callq  *%rax
  8043dc:	85 c0                	test   %eax,%eax
  8043de:	79 2a                	jns    80440a <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8043e0:	48 ba 38 4f 80 00 00 	movabs $0x804f38,%rdx
  8043e7:	00 00 00 
  8043ea:	be 23 00 00 00       	mov    $0x23,%esi
  8043ef:	48 bf 5f 4f 80 00 00 	movabs $0x804f5f,%rdi
  8043f6:	00 00 00 
  8043f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fe:	48 b9 7b 42 80 00 00 	movabs $0x80427b,%rcx
  804405:	00 00 00 
  804408:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80440a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804411:	00 00 00 
  804414:	48 8b 00             	mov    (%rax),%rax
  804417:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80441d:	48 be 48 44 80 00 00 	movabs $0x804448,%rsi
  804424:	00 00 00 
  804427:	89 c7                	mov    %eax,%edi
  804429:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  804430:	00 00 00 
  804433:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804435:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80443c:	00 00 00 
  80443f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804443:	48 89 10             	mov    %rdx,(%rax)
}
  804446:	c9                   	leaveq 
  804447:	c3                   	retq   

0000000000804448 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804448:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80444b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804452:	00 00 00 
call *%rax
  804455:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804457:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80445e:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80445f:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804466:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804467:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80446b:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80446e:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804475:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804476:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80447a:	4c 8b 3c 24          	mov    (%rsp),%r15
  80447e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804483:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804488:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80448d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804492:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804497:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80449c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8044a1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044a6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044ab:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8044b0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8044b5:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8044ba:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044bf:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044c4:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8044c8:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8044cc:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8044cd:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8044ce:	c3                   	retq   

00000000008044cf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044cf:	55                   	push   %rbp
  8044d0:	48 89 e5             	mov    %rsp,%rbp
  8044d3:	48 83 ec 30          	sub    $0x30,%rsp
  8044d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8044e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8044ea:	00 00 00 
  8044ed:	48 8b 00             	mov    (%rax),%rax
  8044f0:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8044f6:	85 c0                	test   %eax,%eax
  8044f8:	75 3c                	jne    804536 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8044fa:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  804501:	00 00 00 
  804504:	ff d0                	callq  *%rax
  804506:	25 ff 03 00 00       	and    $0x3ff,%eax
  80450b:	48 63 d0             	movslq %eax,%rdx
  80450e:	48 89 d0             	mov    %rdx,%rax
  804511:	48 c1 e0 03          	shl    $0x3,%rax
  804515:	48 01 d0             	add    %rdx,%rax
  804518:	48 c1 e0 05          	shl    $0x5,%rax
  80451c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804523:	00 00 00 
  804526:	48 01 c2             	add    %rax,%rdx
  804529:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804530:	00 00 00 
  804533:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804536:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80453b:	75 0e                	jne    80454b <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80453d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804544:	00 00 00 
  804547:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80454b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80454f:	48 89 c7             	mov    %rax,%rdi
  804552:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  804559:	00 00 00 
  80455c:	ff d0                	callq  *%rax
  80455e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804565:	79 19                	jns    804580 <ipc_recv+0xb1>
		*from_env_store = 0;
  804567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80456b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804575:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80457b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457e:	eb 53                	jmp    8045d3 <ipc_recv+0x104>
	}
	if(from_env_store)
  804580:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804585:	74 19                	je     8045a0 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804587:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80458e:	00 00 00 
  804591:	48 8b 00             	mov    (%rax),%rax
  804594:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80459a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80459e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8045a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045a5:	74 19                	je     8045c0 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8045a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045ae:	00 00 00 
  8045b1:	48 8b 00             	mov    (%rax),%rax
  8045b4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8045ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045be:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8045c0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045c7:	00 00 00 
  8045ca:	48 8b 00             	mov    (%rax),%rax
  8045cd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8045d3:	c9                   	leaveq 
  8045d4:	c3                   	retq   

00000000008045d5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045d5:	55                   	push   %rbp
  8045d6:	48 89 e5             	mov    %rsp,%rbp
  8045d9:	48 83 ec 30          	sub    $0x30,%rsp
  8045dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045e3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8045ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045ef:	75 0e                	jne    8045ff <ipc_send+0x2a>
		pg = (void*)UTOP;
  8045f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8045f8:	00 00 00 
  8045fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8045ff:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804602:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804605:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804609:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80460c:	89 c7                	mov    %eax,%edi
  80460e:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  804615:	00 00 00 
  804618:	ff d0                	callq  *%rax
  80461a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80461d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804621:	75 0c                	jne    80462f <ipc_send+0x5a>
			sys_yield();
  804623:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  80462a:	00 00 00 
  80462d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80462f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804633:	74 ca                	je     8045ff <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804635:	c9                   	leaveq 
  804636:	c3                   	retq   

0000000000804637 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804637:	55                   	push   %rbp
  804638:	48 89 e5             	mov    %rsp,%rbp
  80463b:	48 83 ec 14          	sub    $0x14,%rsp
  80463f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804642:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804649:	eb 5e                	jmp    8046a9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80464b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804652:	00 00 00 
  804655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804658:	48 63 d0             	movslq %eax,%rdx
  80465b:	48 89 d0             	mov    %rdx,%rax
  80465e:	48 c1 e0 03          	shl    $0x3,%rax
  804662:	48 01 d0             	add    %rdx,%rax
  804665:	48 c1 e0 05          	shl    $0x5,%rax
  804669:	48 01 c8             	add    %rcx,%rax
  80466c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804672:	8b 00                	mov    (%rax),%eax
  804674:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804677:	75 2c                	jne    8046a5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804679:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804680:	00 00 00 
  804683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804686:	48 63 d0             	movslq %eax,%rdx
  804689:	48 89 d0             	mov    %rdx,%rax
  80468c:	48 c1 e0 03          	shl    $0x3,%rax
  804690:	48 01 d0             	add    %rdx,%rax
  804693:	48 c1 e0 05          	shl    $0x5,%rax
  804697:	48 01 c8             	add    %rcx,%rax
  80469a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046a0:	8b 40 08             	mov    0x8(%rax),%eax
  8046a3:	eb 12                	jmp    8046b7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046a9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046b0:	7e 99                	jle    80464b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8046b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046b7:	c9                   	leaveq 
  8046b8:	c3                   	retq   

00000000008046b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046b9:	55                   	push   %rbp
  8046ba:	48 89 e5             	mov    %rsp,%rbp
  8046bd:	48 83 ec 18          	sub    $0x18,%rsp
  8046c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046c9:	48 c1 e8 15          	shr    $0x15,%rax
  8046cd:	48 89 c2             	mov    %rax,%rdx
  8046d0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046d7:	01 00 00 
  8046da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046de:	83 e0 01             	and    $0x1,%eax
  8046e1:	48 85 c0             	test   %rax,%rax
  8046e4:	75 07                	jne    8046ed <pageref+0x34>
		return 0;
  8046e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046eb:	eb 53                	jmp    804740 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8046f5:	48 89 c2             	mov    %rax,%rdx
  8046f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046ff:	01 00 00 
  804702:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80470a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80470e:	83 e0 01             	and    $0x1,%eax
  804711:	48 85 c0             	test   %rax,%rax
  804714:	75 07                	jne    80471d <pageref+0x64>
		return 0;
  804716:	b8 00 00 00 00       	mov    $0x0,%eax
  80471b:	eb 23                	jmp    804740 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80471d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804721:	48 c1 e8 0c          	shr    $0xc,%rax
  804725:	48 89 c2             	mov    %rax,%rdx
  804728:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80472f:	00 00 00 
  804732:	48 c1 e2 04          	shl    $0x4,%rdx
  804736:	48 01 d0             	add    %rdx,%rax
  804739:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80473d:	0f b7 c0             	movzwl %ax,%eax
}
  804740:	c9                   	leaveq 
  804741:	c3                   	retq   
