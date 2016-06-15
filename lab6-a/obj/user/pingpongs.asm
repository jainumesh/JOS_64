
obj/user/pingpongs.debug:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf fa 47 80 00 00 	movabs $0x8047fa,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 81 22 80 00 00 	movabs $0x802281,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 10 48 80 00 00 	movabs $0x804810,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba ca 03 80 00 00 	movabs $0x8003ca,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001d9:	00 00 00 
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	83 f8 0a             	cmp    $0xa,%eax
  8001e1:	75 02                	jne    8001e5 <umain+0x1a2>
			return;
  8001e3:	eb 05                	jmp    8001ea <umain+0x1a7>
	}
  8001e5:	e9 17 ff ff ff       	jmpq   800101 <umain+0xbe>

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800206:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	25 ff 03 00 00       	and    $0x3ff,%eax
  800217:	48 63 d0             	movslq %eax,%rdx
  80021a:	48 89 d0             	mov    %rdx,%rax
  80021d:	48 c1 e0 03          	shl    $0x3,%rax
  800221:	48 01 d0             	add    %rdx,%rax
  800224:	48 c1 e0 05          	shl    $0x5,%rax
  800228:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80022f:	00 00 00 
  800232:	48 01 c2             	add    %rax,%rdx
  800235:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80023c:	00 00 00 
  80023f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800246:	7e 14                	jle    80025c <libmain+0x65>
		binaryname = argv[0];
  800248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024c:	48 8b 10             	mov    (%rax),%rdx
  80024f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800256:	00 00 00 
  800259:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80025c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800263:	48 89 d6             	mov    %rdx,%rsi
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800274:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	c9                   	leaveq 
  800281:	c3                   	retq   

0000000000800282 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800286:	48 b8 ac 27 80 00 00 	movabs $0x8027ac,%rax
  80028d:	00 00 00 
  800290:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800292:	bf 00 00 00 00       	mov    $0x0,%edi
  800297:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  80029e:	00 00 00 
  8002a1:	ff d0                	callq  *%rax

}
  8002a3:	5d                   	pop    %rbp
  8002a4:	c3                   	retq   

00000000008002a5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a5:	55                   	push   %rbp
  8002a6:	48 89 e5             	mov    %rsp,%rbp
  8002a9:	48 83 ec 10          	sub    $0x10,%rsp
  8002ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b8:	8b 00                	mov    (%rax),%eax
  8002ba:	8d 48 01             	lea    0x1(%rax),%ecx
  8002bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c1:	89 0a                	mov    %ecx,(%rdx)
  8002c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c6:	89 d1                	mov    %edx,%ecx
  8002c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002cc:	48 98                	cltq   
  8002ce:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d6:	8b 00                	mov    (%rax),%eax
  8002d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dd:	75 2c                	jne    80030b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	8b 00                	mov    (%rax),%eax
  8002e5:	48 98                	cltq   
  8002e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002eb:	48 83 c2 08          	add    $0x8,%rdx
  8002ef:	48 89 c6             	mov    %rax,%rsi
  8002f2:	48 89 d7             	mov    %rdx,%rdi
  8002f5:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
        b->idx = 0;
  800301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800305:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80030b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030f:	8b 40 04             	mov    0x4(%rax),%eax
  800312:	8d 50 01             	lea    0x1(%rax),%edx
  800315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800319:	89 50 04             	mov    %edx,0x4(%rax)
}
  80031c:	c9                   	leaveq 
  80031d:	c3                   	retq   

000000000080031e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80031e:	55                   	push   %rbp
  80031f:	48 89 e5             	mov    %rsp,%rbp
  800322:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800329:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800330:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800337:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80033e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800345:	48 8b 0a             	mov    (%rdx),%rcx
  800348:	48 89 08             	mov    %rcx,(%rax)
  80034b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800353:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800357:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80035b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800362:	00 00 00 
    b.cnt = 0;
  800365:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80036c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80036f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800376:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80037d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800384:	48 89 c6             	mov    %rax,%rsi
  800387:	48 bf a5 02 80 00 00 	movabs $0x8002a5,%rdi
  80038e:	00 00 00 
  800391:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80039d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a3:	48 98                	cltq   
  8003a5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003ac:	48 83 c2 08          	add    $0x8,%rdx
  8003b0:	48 89 c6             	mov    %rax,%rsi
  8003b3:	48 89 d7             	mov    %rdx,%rdi
  8003b6:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c8:	c9                   	leaveq 
  8003c9:	c3                   	retq   

00000000008003ca <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ca:	55                   	push   %rbp
  8003cb:	48 89 e5             	mov    %rsp,%rbp
  8003ce:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003dc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ea:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f8:	84 c0                	test   %al,%al
  8003fa:	74 20                	je     80041c <cprintf+0x52>
  8003fc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800400:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800404:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800408:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80040c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800410:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800414:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800418:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80041c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800423:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042a:	00 00 00 
  80042d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800434:	00 00 00 
  800437:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800442:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800449:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800450:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800457:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80045e:	48 8b 0a             	mov    (%rdx),%rcx
  800461:	48 89 08             	mov    %rcx,(%rax)
  800464:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800468:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80046c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800470:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800474:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80047b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800482:	48 89 d6             	mov    %rdx,%rsi
  800485:	48 89 c7             	mov    %rax,%rdi
  800488:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
  800494:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	53                   	push   %rbx
  8004a7:	48 83 ec 38          	sub    $0x38,%rsp
  8004ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004b7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004ba:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004be:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004c9:	77 3b                	ja     800506 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004ce:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004de:	48 f7 f3             	div    %rbx
  8004e1:	48 89 c2             	mov    %rax,%rdx
  8004e4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004e7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ea:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f2:	41 89 f9             	mov    %edi,%r9d
  8004f5:	48 89 c7             	mov    %rax,%rdi
  8004f8:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	callq  *%rax
  800504:	eb 1e                	jmp    800524 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800506:	eb 12                	jmp    80051a <printnum+0x78>
			putch(padc, putdat);
  800508:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80050c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 89 ce             	mov    %rcx,%rsi
  800516:	89 d7                	mov    %edx,%edi
  800518:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80051e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800522:	7f e4                	jg     800508 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800524:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80052b:	ba 00 00 00 00       	mov    $0x0,%edx
  800530:	48 f7 f1             	div    %rcx
  800533:	48 89 d0             	mov    %rdx,%rax
  800536:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  80053d:	00 00 00 
  800540:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800544:	0f be d0             	movsbl %al,%edx
  800547:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	48 89 ce             	mov    %rcx,%rsi
  800552:	89 d7                	mov    %edx,%edi
  800554:	ff d0                	callq  *%rax
}
  800556:	48 83 c4 38          	add    $0x38,%rsp
  80055a:	5b                   	pop    %rbx
  80055b:	5d                   	pop    %rbp
  80055c:	c3                   	retq   

000000000080055d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80055d:	55                   	push   %rbp
  80055e:	48 89 e5             	mov    %rsp,%rbp
  800561:	48 83 ec 1c          	sub    $0x1c,%rsp
  800565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800569:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80056c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800570:	7e 52                	jle    8005c4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800576:	8b 00                	mov    (%rax),%eax
  800578:	83 f8 30             	cmp    $0x30,%eax
  80057b:	73 24                	jae    8005a1 <getuint+0x44>
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	8b 00                	mov    (%rax),%eax
  80058b:	89 c0                	mov    %eax,%eax
  80058d:	48 01 d0             	add    %rdx,%rax
  800590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800594:	8b 12                	mov    (%rdx),%edx
  800596:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800599:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059d:	89 0a                	mov    %ecx,(%rdx)
  80059f:	eb 17                	jmp    8005b8 <getuint+0x5b>
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a9:	48 89 d0             	mov    %rdx,%rax
  8005ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b8:	48 8b 00             	mov    (%rax),%rax
  8005bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005bf:	e9 a3 00 00 00       	jmpq   800667 <getuint+0x10a>
	else if (lflag)
  8005c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c8:	74 4f                	je     800619 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	8b 00                	mov    (%rax),%eax
  8005d0:	83 f8 30             	cmp    $0x30,%eax
  8005d3:	73 24                	jae    8005f9 <getuint+0x9c>
  8005d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	8b 00                	mov    (%rax),%eax
  8005e3:	89 c0                	mov    %eax,%eax
  8005e5:	48 01 d0             	add    %rdx,%rax
  8005e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ec:	8b 12                	mov    (%rdx),%edx
  8005ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	89 0a                	mov    %ecx,(%rdx)
  8005f7:	eb 17                	jmp    800610 <getuint+0xb3>
  8005f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800601:	48 89 d0             	mov    %rdx,%rax
  800604:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800610:	48 8b 00             	mov    (%rax),%rax
  800613:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800617:	eb 4e                	jmp    800667 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	83 f8 30             	cmp    $0x30,%eax
  800622:	73 24                	jae    800648 <getuint+0xeb>
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80062c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800630:	8b 00                	mov    (%rax),%eax
  800632:	89 c0                	mov    %eax,%eax
  800634:	48 01 d0             	add    %rdx,%rax
  800637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063b:	8b 12                	mov    (%rdx),%edx
  80063d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	89 0a                	mov    %ecx,(%rdx)
  800646:	eb 17                	jmp    80065f <getuint+0x102>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800650:	48 89 d0             	mov    %rdx,%rax
  800653:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	89 c0                	mov    %eax,%eax
  800663:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80066b:	c9                   	leaveq 
  80066c:	c3                   	retq   

000000000080066d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80066d:	55                   	push   %rbp
  80066e:	48 89 e5             	mov    %rsp,%rbp
  800671:	48 83 ec 1c          	sub    $0x1c,%rsp
  800675:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800679:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80067c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800680:	7e 52                	jle    8006d4 <getint+0x67>
		x=va_arg(*ap, long long);
  800682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800686:	8b 00                	mov    (%rax),%eax
  800688:	83 f8 30             	cmp    $0x30,%eax
  80068b:	73 24                	jae    8006b1 <getint+0x44>
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	8b 00                	mov    (%rax),%eax
  80069b:	89 c0                	mov    %eax,%eax
  80069d:	48 01 d0             	add    %rdx,%rax
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	8b 12                	mov    (%rdx),%edx
  8006a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ad:	89 0a                	mov    %ecx,(%rdx)
  8006af:	eb 17                	jmp    8006c8 <getint+0x5b>
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b9:	48 89 d0             	mov    %rdx,%rax
  8006bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c8:	48 8b 00             	mov    (%rax),%rax
  8006cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cf:	e9 a3 00 00 00       	jmpq   800777 <getint+0x10a>
	else if (lflag)
  8006d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d8:	74 4f                	je     800729 <getint+0xbc>
		x=va_arg(*ap, long);
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	8b 00                	mov    (%rax),%eax
  8006e0:	83 f8 30             	cmp    $0x30,%eax
  8006e3:	73 24                	jae    800709 <getint+0x9c>
  8006e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	89 c0                	mov    %eax,%eax
  8006f5:	48 01 d0             	add    %rdx,%rax
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	8b 12                	mov    (%rdx),%edx
  8006fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	89 0a                	mov    %ecx,(%rdx)
  800707:	eb 17                	jmp    800720 <getint+0xb3>
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800711:	48 89 d0             	mov    %rdx,%rax
  800714:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800720:	48 8b 00             	mov    (%rax),%rax
  800723:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800727:	eb 4e                	jmp    800777 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	83 f8 30             	cmp    $0x30,%eax
  800732:	73 24                	jae    800758 <getint+0xeb>
  800734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800738:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	89 c0                	mov    %eax,%eax
  800744:	48 01 d0             	add    %rdx,%rax
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	8b 12                	mov    (%rdx),%edx
  80074d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	89 0a                	mov    %ecx,(%rdx)
  800756:	eb 17                	jmp    80076f <getint+0x102>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800760:	48 89 d0             	mov    %rdx,%rax
  800763:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076f:	8b 00                	mov    (%rax),%eax
  800771:	48 98                	cltq   
  800773:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077b:	c9                   	leaveq 
  80077c:	c3                   	retq   

000000000080077d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80077d:	55                   	push   %rbp
  80077e:	48 89 e5             	mov    %rsp,%rbp
  800781:	41 54                	push   %r12
  800783:	53                   	push   %rbx
  800784:	48 83 ec 60          	sub    $0x60,%rsp
  800788:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80078c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800790:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800794:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800798:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80079c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a0:	48 8b 0a             	mov    (%rdx),%rcx
  8007a3:	48 89 08             	mov    %rcx,(%rax)
  8007a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b6:	eb 17                	jmp    8007cf <vprintfmt+0x52>
			if (ch == '\0')
  8007b8:	85 db                	test   %ebx,%ebx
  8007ba:	0f 84 cc 04 00 00    	je     800c8c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c8:	48 89 d6             	mov    %rdx,%rsi
  8007cb:	89 df                	mov    %ebx,%edi
  8007cd:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007db:	0f b6 00             	movzbl (%rax),%eax
  8007de:	0f b6 d8             	movzbl %al,%ebx
  8007e1:	83 fb 25             	cmp    $0x25,%ebx
  8007e4:	75 d2                	jne    8007b8 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007ea:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800806:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80080a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80080e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800812:	0f b6 00             	movzbl (%rax),%eax
  800815:	0f b6 d8             	movzbl %al,%ebx
  800818:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80081b:	83 f8 55             	cmp    $0x55,%eax
  80081e:	0f 87 34 04 00 00    	ja     800c58 <vprintfmt+0x4db>
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80082d:	00 
  80082e:	48 b8 58 4a 80 00 00 	movabs $0x804a58,%rax
  800835:	00 00 00 
  800838:	48 01 d0             	add    %rdx,%rax
  80083b:	48 8b 00             	mov    (%rax),%rax
  80083e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800840:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800844:	eb c0                	jmp    800806 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800846:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80084a:	eb ba                	jmp    800806 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800853:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800856:	89 d0                	mov    %edx,%eax
  800858:	c1 e0 02             	shl    $0x2,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	01 c0                	add    %eax,%eax
  80085f:	01 d8                	add    %ebx,%eax
  800861:	83 e8 30             	sub    $0x30,%eax
  800864:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800867:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086b:	0f b6 00             	movzbl (%rax),%eax
  80086e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800871:	83 fb 2f             	cmp    $0x2f,%ebx
  800874:	7e 0c                	jle    800882 <vprintfmt+0x105>
  800876:	83 fb 39             	cmp    $0x39,%ebx
  800879:	7f 07                	jg     800882 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800880:	eb d1                	jmp    800853 <vprintfmt+0xd6>
			goto process_precision;
  800882:	eb 58                	jmp    8008dc <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800884:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800887:	83 f8 30             	cmp    $0x30,%eax
  80088a:	73 17                	jae    8008a3 <vprintfmt+0x126>
  80088c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800890:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800893:	89 c0                	mov    %eax,%eax
  800895:	48 01 d0             	add    %rdx,%rax
  800898:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089b:	83 c2 08             	add    $0x8,%edx
  80089e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a1:	eb 0f                	jmp    8008b2 <vprintfmt+0x135>
  8008a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a7:	48 89 d0             	mov    %rdx,%rax
  8008aa:	48 83 c2 08          	add    $0x8,%rdx
  8008ae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008b7:	eb 23                	jmp    8008dc <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008bd:	79 0c                	jns    8008cb <vprintfmt+0x14e>
				width = 0;
  8008bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008c6:	e9 3b ff ff ff       	jmpq   800806 <vprintfmt+0x89>
  8008cb:	e9 36 ff ff ff       	jmpq   800806 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008d7:	e9 2a ff ff ff       	jmpq   800806 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e0:	79 12                	jns    8008f4 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008ef:	e9 12 ff ff ff       	jmpq   800806 <vprintfmt+0x89>
  8008f4:	e9 0d ff ff ff       	jmpq   800806 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008fd:	e9 04 ff ff ff       	jmpq   800806 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800902:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800905:	83 f8 30             	cmp    $0x30,%eax
  800908:	73 17                	jae    800921 <vprintfmt+0x1a4>
  80090a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800911:	89 c0                	mov    %eax,%eax
  800913:	48 01 d0             	add    %rdx,%rax
  800916:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800919:	83 c2 08             	add    $0x8,%edx
  80091c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091f:	eb 0f                	jmp    800930 <vprintfmt+0x1b3>
  800921:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800925:	48 89 d0             	mov    %rdx,%rax
  800928:	48 83 c2 08          	add    $0x8,%rdx
  80092c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800930:	8b 10                	mov    (%rax),%edx
  800932:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800936:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093a:	48 89 ce             	mov    %rcx,%rsi
  80093d:	89 d7                	mov    %edx,%edi
  80093f:	ff d0                	callq  *%rax
			break;
  800941:	e9 40 03 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800946:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 17                	jae    800965 <vprintfmt+0x1e8>
  80094e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800952:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800955:	89 c0                	mov    %eax,%eax
  800957:	48 01 d0             	add    %rdx,%rax
  80095a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095d:	83 c2 08             	add    $0x8,%edx
  800960:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800963:	eb 0f                	jmp    800974 <vprintfmt+0x1f7>
  800965:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 83 c2 08          	add    $0x8,%rdx
  800970:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800974:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800976:	85 db                	test   %ebx,%ebx
  800978:	79 02                	jns    80097c <vprintfmt+0x1ff>
				err = -err;
  80097a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80097c:	83 fb 15             	cmp    $0x15,%ebx
  80097f:	7f 16                	jg     800997 <vprintfmt+0x21a>
  800981:	48 b8 80 49 80 00 00 	movabs $0x804980,%rax
  800988:	00 00 00 
  80098b:	48 63 d3             	movslq %ebx,%rdx
  80098e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800992:	4d 85 e4             	test   %r12,%r12
  800995:	75 2e                	jne    8009c5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800997:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099f:	89 d9                	mov    %ebx,%ecx
  8009a1:	48 ba 41 4a 80 00 00 	movabs $0x804a41,%rdx
  8009a8:	00 00 00 
  8009ab:	48 89 c7             	mov    %rax,%rdi
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	49 b8 95 0c 80 00 00 	movabs $0x800c95,%r8
  8009ba:	00 00 00 
  8009bd:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c0:	e9 c1 02 00 00       	jmpq   800c86 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cd:	4c 89 e1             	mov    %r12,%rcx
  8009d0:	48 ba 4a 4a 80 00 00 	movabs $0x804a4a,%rdx
  8009d7:	00 00 00 
  8009da:	48 89 c7             	mov    %rax,%rdi
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e2:	49 b8 95 0c 80 00 00 	movabs $0x800c95,%r8
  8009e9:	00 00 00 
  8009ec:	41 ff d0             	callq  *%r8
			break;
  8009ef:	e9 92 02 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	83 f8 30             	cmp    $0x30,%eax
  8009fa:	73 17                	jae    800a13 <vprintfmt+0x296>
  8009fc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	89 c0                	mov    %eax,%eax
  800a05:	48 01 d0             	add    %rdx,%rax
  800a08:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0b:	83 c2 08             	add    $0x8,%edx
  800a0e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x2a5>
  800a13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a17:	48 89 d0             	mov    %rdx,%rax
  800a1a:	48 83 c2 08          	add    $0x8,%rdx
  800a1e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a22:	4c 8b 20             	mov    (%rax),%r12
  800a25:	4d 85 e4             	test   %r12,%r12
  800a28:	75 0a                	jne    800a34 <vprintfmt+0x2b7>
				p = "(null)";
  800a2a:	49 bc 4d 4a 80 00 00 	movabs $0x804a4d,%r12
  800a31:	00 00 00 
			if (width > 0 && padc != '-')
  800a34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a38:	7e 3f                	jle    800a79 <vprintfmt+0x2fc>
  800a3a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a3e:	74 39                	je     800a79 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a43:	48 98                	cltq   
  800a45:	48 89 c6             	mov    %rax,%rsi
  800a48:	4c 89 e7             	mov    %r12,%rdi
  800a4b:	48 b8 41 0f 80 00 00 	movabs $0x800f41,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	callq  *%rax
  800a57:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a5a:	eb 17                	jmp    800a73 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a5c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a60:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a68:	48 89 ce             	mov    %rcx,%rsi
  800a6b:	89 d7                	mov    %edx,%edi
  800a6d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a77:	7f e3                	jg     800a5c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	eb 37                	jmp    800ab2 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a7f:	74 1e                	je     800a9f <vprintfmt+0x322>
  800a81:	83 fb 1f             	cmp    $0x1f,%ebx
  800a84:	7e 05                	jle    800a8b <vprintfmt+0x30e>
  800a86:	83 fb 7e             	cmp    $0x7e,%ebx
  800a89:	7e 14                	jle    800a9f <vprintfmt+0x322>
					putch('?', putdat);
  800a8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a93:	48 89 d6             	mov    %rdx,%rsi
  800a96:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a9b:	ff d0                	callq  *%rax
  800a9d:	eb 0f                	jmp    800aae <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa7:	48 89 d6             	mov    %rdx,%rsi
  800aaa:	89 df                	mov    %ebx,%edi
  800aac:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aae:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab2:	4c 89 e0             	mov    %r12,%rax
  800ab5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ab9:	0f b6 00             	movzbl (%rax),%eax
  800abc:	0f be d8             	movsbl %al,%ebx
  800abf:	85 db                	test   %ebx,%ebx
  800ac1:	74 10                	je     800ad3 <vprintfmt+0x356>
  800ac3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ac7:	78 b2                	js     800a7b <vprintfmt+0x2fe>
  800ac9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800acd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad1:	79 a8                	jns    800a7b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad3:	eb 16                	jmp    800aeb <vprintfmt+0x36e>
				putch(' ', putdat);
  800ad5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  800ae5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aeb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aef:	7f e4                	jg     800ad5 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af1:	e9 90 01 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800af6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afa:	be 03 00 00 00       	mov    $0x3,%esi
  800aff:	48 89 c7             	mov    %rax,%rdi
  800b02:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800b09:	00 00 00 
  800b0c:	ff d0                	callq  *%rax
  800b0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	48 85 c0             	test   %rax,%rax
  800b19:	79 1d                	jns    800b38 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	48 89 d6             	mov    %rdx,%rsi
  800b26:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b2b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b31:	48 f7 d8             	neg    %rax
  800b34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b38:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b3f:	e9 d5 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b48:	be 03 00 00 00       	mov    $0x3,%esi
  800b4d:	48 89 c7             	mov    %rax,%rdi
  800b50:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800b57:	00 00 00 
  800b5a:	ff d0                	callq  *%rax
  800b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b60:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b67:	e9 ad 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b6c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b73:	89 d6                	mov    %edx,%esi
  800b75:	48 89 c7             	mov    %rax,%rdi
  800b78:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	callq  *%rax
  800b84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b88:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b8f:	e9 85 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9c:	48 89 d6             	mov    %rdx,%rsi
  800b9f:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ba6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800baa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bae:	48 89 d6             	mov    %rdx,%rsi
  800bb1:	bf 78 00 00 00       	mov    $0x78,%edi
  800bb6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbb:	83 f8 30             	cmp    $0x30,%eax
  800bbe:	73 17                	jae    800bd7 <vprintfmt+0x45a>
  800bc0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc7:	89 c0                	mov    %eax,%eax
  800bc9:	48 01 d0             	add    %rdx,%rax
  800bcc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcf:	83 c2 08             	add    $0x8,%edx
  800bd2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd5:	eb 0f                	jmp    800be6 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bd7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdb:	48 89 d0             	mov    %rdx,%rax
  800bde:	48 83 c2 08          	add    $0x8,%rdx
  800be2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bed:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bf6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfa:	be 03 00 00 00       	mov    $0x3,%esi
  800bff:	48 89 c7             	mov    %rax,%rdi
  800c02:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800c09:	00 00 00 
  800c0c:	ff d0                	callq  *%rax
  800c0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c12:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c19:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c1e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c21:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c30:	45 89 c1             	mov    %r8d,%r9d
  800c33:	41 89 f8             	mov    %edi,%r8d
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
			break;
  800c45:	eb 3f                	jmp    800c86 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4f:	48 89 d6             	mov    %rdx,%rsi
  800c52:	89 df                	mov    %ebx,%edi
  800c54:	ff d0                	callq  *%rax
			break;
  800c56:	eb 2e                	jmp    800c86 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c60:	48 89 d6             	mov    %rdx,%rsi
  800c63:	bf 25 00 00 00       	mov    $0x25,%edi
  800c68:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c6f:	eb 05                	jmp    800c76 <vprintfmt+0x4f9>
  800c71:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7a:	48 83 e8 01          	sub    $0x1,%rax
  800c7e:	0f b6 00             	movzbl (%rax),%eax
  800c81:	3c 25                	cmp    $0x25,%al
  800c83:	75 ec                	jne    800c71 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c85:	90                   	nop
		}
	}
  800c86:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c87:	e9 43 fb ff ff       	jmpq   8007cf <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c8c:	48 83 c4 60          	add    $0x60,%rsp
  800c90:	5b                   	pop    %rbx
  800c91:	41 5c                	pop    %r12
  800c93:	5d                   	pop    %rbp
  800c94:	c3                   	retq   

0000000000800c95 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ca7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cbc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 20                	je     800ce7 <printfmt+0x52>
  800cc7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ccb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cdb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cee:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf5:	00 00 00 
  800cf8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cff:	00 00 00 
  800d02:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d0d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d14:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d22:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d29:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d30:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d37:	48 89 c7             	mov    %rax,%rdi
  800d3a:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800d41:	00 00 00 
  800d44:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d46:	c9                   	leaveq 
  800d47:	c3                   	retq   

0000000000800d48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d48:	55                   	push   %rbp
  800d49:	48 89 e5             	mov    %rsp,%rbp
  800d4c:	48 83 ec 10          	sub    $0x10,%rsp
  800d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5b:	8b 40 10             	mov    0x10(%rax),%eax
  800d5e:	8d 50 01             	lea    0x1(%rax),%edx
  800d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d65:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6c:	48 8b 10             	mov    (%rax),%rdx
  800d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d73:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d77:	48 39 c2             	cmp    %rax,%rdx
  800d7a:	73 17                	jae    800d93 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 00             	mov    (%rax),%rax
  800d83:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d8b:	48 89 0a             	mov    %rcx,(%rdx)
  800d8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d91:	88 10                	mov    %dl,(%rax)
}
  800d93:	c9                   	leaveq 
  800d94:	c3                   	retq   

0000000000800d95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d95:	55                   	push   %rbp
  800d96:	48 89 e5             	mov    %rsp,%rbp
  800d99:	48 83 ec 50          	sub    $0x50,%rsp
  800d9d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800da8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dac:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db4:	48 8b 0a             	mov    (%rdx),%rcx
  800db7:	48 89 08             	mov    %rcx,(%rax)
  800dba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dbe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dce:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd5:	48 98                	cltq   
  800dd7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ddb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddf:	48 01 d0             	add    %rdx,%rax
  800de2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800de6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ded:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df2:	74 06                	je     800dfa <vsnprintf+0x65>
  800df4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800df8:	7f 07                	jg     800e01 <vsnprintf+0x6c>
		return -E_INVAL;
  800dfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dff:	eb 2f                	jmp    800e30 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e01:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e05:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e09:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e0d:	48 89 c6             	mov    %rax,%rsi
  800e10:	48 bf 48 0d 80 00 00 	movabs $0x800d48,%rdi
  800e17:	00 00 00 
  800e1a:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800e21:	00 00 00 
  800e24:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e2d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e30:	c9                   	leaveq 
  800e31:	c3                   	retq   

0000000000800e32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e32:	55                   	push   %rbp
  800e33:	48 89 e5             	mov    %rsp,%rbp
  800e36:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e3d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e44:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e5f:	84 c0                	test   %al,%al
  800e61:	74 20                	je     800e83 <snprintf+0x51>
  800e63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e83:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e91:	00 00 00 
  800e94:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9b:	00 00 00 
  800e9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ea9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800eb7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ebe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec5:	48 8b 0a             	mov    (%rdx),%rcx
  800ec8:	48 89 08             	mov    %rcx,(%rax)
  800ecb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ecf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800edb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ee9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ef6:	48 89 c7             	mov    %rax,%rdi
  800ef9:	48 b8 95 0d 80 00 00 	movabs $0x800d95,%rax
  800f00:	00 00 00 
  800f03:	ff d0                	callq  *%rax
  800f05:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 18          	sub    $0x18,%rsp
  800f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f26:	eb 09                	jmp    800f31 <strlen+0x1e>
		n++;
  800f28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f2c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f35:	0f b6 00             	movzbl (%rax),%eax
  800f38:	84 c0                	test   %al,%al
  800f3a:	75 ec                	jne    800f28 <strlen+0x15>
		n++;
	return n;
  800f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3f:	c9                   	leaveq 
  800f40:	c3                   	retq   

0000000000800f41 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f41:	55                   	push   %rbp
  800f42:	48 89 e5             	mov    %rsp,%rbp
  800f45:	48 83 ec 20          	sub    $0x20,%rsp
  800f49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f58:	eb 0e                	jmp    800f68 <strnlen+0x27>
		n++;
  800f5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f63:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f6d:	74 0b                	je     800f7a <strnlen+0x39>
  800f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f73:	0f b6 00             	movzbl (%rax),%eax
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e0                	jne    800f5a <strnlen+0x19>
		n++;
	return n;
  800f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f7d:	c9                   	leaveq 
  800f7e:	c3                   	retq   

0000000000800f7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f7f:	55                   	push   %rbp
  800f80:	48 89 e5             	mov    %rsp,%rbp
  800f83:	48 83 ec 20          	sub    $0x20,%rsp
  800f87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f97:	90                   	nop
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fac:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb0:	0f b6 12             	movzbl (%rdx),%edx
  800fb3:	88 10                	mov    %dl,(%rax)
  800fb5:	0f b6 00             	movzbl (%rax),%eax
  800fb8:	84 c0                	test   %al,%al
  800fba:	75 dc                	jne    800f98 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 20          	sub    $0x20,%rsp
  800fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd6:	48 89 c7             	mov    %rax,%rdi
  800fd9:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  800fe0:	00 00 00 
  800fe3:	ff d0                	callq  *%rax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800feb:	48 63 d0             	movslq %eax,%rdx
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	48 01 c2             	add    %rax,%rdx
  800ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff9:	48 89 c6             	mov    %rax,%rsi
  800ffc:	48 89 d7             	mov    %rdx,%rdi
  800fff:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  801006:	00 00 00 
  801009:	ff d0                	callq  *%rax
	return dst;
  80100b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80100f:	c9                   	leaveq 
  801010:	c3                   	retq   

0000000000801011 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801011:	55                   	push   %rbp
  801012:	48 89 e5             	mov    %rsp,%rbp
  801015:	48 83 ec 28          	sub    $0x28,%rsp
  801019:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801021:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801029:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80102d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801034:	00 
  801035:	eb 2a                	jmp    801061 <strncpy+0x50>
		*dst++ = *src;
  801037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801043:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801047:	0f b6 12             	movzbl (%rdx),%edx
  80104a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	84 c0                	test   %al,%al
  801055:	74 05                	je     80105c <strncpy+0x4b>
			src++;
  801057:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80105c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801065:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801069:	72 cc                	jb     801037 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 28          	sub    $0x28,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801081:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801089:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80108d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801092:	74 3d                	je     8010d1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801094:	eb 1d                	jmp    8010b3 <strlcpy+0x42>
			*dst++ = *src++;
  801096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010aa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ae:	0f b6 12             	movzbl (%rdx),%edx
  8010b1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010bd:	74 0b                	je     8010ca <strlcpy+0x59>
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 cc                	jne    801096 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ce:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d9:	48 29 c2             	sub    %rax,%rdx
  8010dc:	48 89 d0             	mov    %rdx,%rax
}
  8010df:	c9                   	leaveq 
  8010e0:	c3                   	retq   

00000000008010e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e1:	55                   	push   %rbp
  8010e2:	48 89 e5             	mov    %rsp,%rbp
  8010e5:	48 83 ec 10          	sub    $0x10,%rsp
  8010e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f1:	eb 0a                	jmp    8010fd <strcmp+0x1c>
		p++, q++;
  8010f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801101:	0f b6 00             	movzbl (%rax),%eax
  801104:	84 c0                	test   %al,%al
  801106:	74 12                	je     80111a <strcmp+0x39>
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110c:	0f b6 10             	movzbl (%rax),%edx
  80110f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	38 c2                	cmp    %al,%dl
  801118:	74 d9                	je     8010f3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111e:	0f b6 00             	movzbl (%rax),%eax
  801121:	0f b6 d0             	movzbl %al,%edx
  801124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801128:	0f b6 00             	movzbl (%rax),%eax
  80112b:	0f b6 c0             	movzbl %al,%eax
  80112e:	29 c2                	sub    %eax,%edx
  801130:	89 d0                	mov    %edx,%eax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 18          	sub    $0x18,%rsp
  80113c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801144:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801148:	eb 0f                	jmp    801159 <strncmp+0x25>
		n--, p++, q++;
  80114a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80114f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801154:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801159:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115e:	74 1d                	je     80117d <strncmp+0x49>
  801160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801164:	0f b6 00             	movzbl (%rax),%eax
  801167:	84 c0                	test   %al,%al
  801169:	74 12                	je     80117d <strncmp+0x49>
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	0f b6 10             	movzbl (%rax),%edx
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801176:	0f b6 00             	movzbl (%rax),%eax
  801179:	38 c2                	cmp    %al,%dl
  80117b:	74 cd                	je     80114a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80117d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801182:	75 07                	jne    80118b <strncmp+0x57>
		return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	eb 18                	jmp    8011a3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	0f b6 00             	movzbl (%rax),%eax
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
}
  8011a3:	c9                   	leaveq 
  8011a4:	c3                   	retq   

00000000008011a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a5:	55                   	push   %rbp
  8011a6:	48 89 e5             	mov    %rsp,%rbp
  8011a9:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b6:	eb 17                	jmp    8011cf <strchr+0x2a>
		if (*s == c)
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c2:	75 06                	jne    8011ca <strchr+0x25>
			return (char *) s;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c8:	eb 15                	jmp    8011df <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	75 de                	jne    8011b8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011df:	c9                   	leaveq 
  8011e0:	c3                   	retq   

00000000008011e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e1:	55                   	push   %rbp
  8011e2:	48 89 e5             	mov    %rsp,%rbp
  8011e5:	48 83 ec 0c          	sub    $0xc,%rsp
  8011e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ed:	89 f0                	mov    %esi,%eax
  8011ef:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f2:	eb 13                	jmp    801207 <strfind+0x26>
		if (*s == c)
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	0f b6 00             	movzbl (%rax),%eax
  8011fb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011fe:	75 02                	jne    801202 <strfind+0x21>
			break;
  801200:	eb 10                	jmp    801212 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801202:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	84 c0                	test   %al,%al
  801210:	75 e2                	jne    8011f4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801216:	c9                   	leaveq 
  801217:	c3                   	retq   

0000000000801218 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	48 83 ec 18          	sub    $0x18,%rsp
  801220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801224:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801230:	75 06                	jne    801238 <memset+0x20>
		return v;
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	eb 69                	jmp    8012a1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	83 e0 03             	and    $0x3,%eax
  80123f:	48 85 c0             	test   %rax,%rax
  801242:	75 48                	jne    80128c <memset+0x74>
  801244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801248:	83 e0 03             	and    $0x3,%eax
  80124b:	48 85 c0             	test   %rax,%rax
  80124e:	75 3c                	jne    80128c <memset+0x74>
		c &= 0xFF;
  801250:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801257:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125a:	c1 e0 18             	shl    $0x18,%eax
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801262:	c1 e0 10             	shl    $0x10,%eax
  801265:	09 c2                	or     %eax,%edx
  801267:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126a:	c1 e0 08             	shl    $0x8,%eax
  80126d:	09 d0                	or     %edx,%eax
  80126f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 c1 e8 02          	shr    $0x2,%rax
  80127a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80127d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801281:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801284:	48 89 d7             	mov    %rdx,%rdi
  801287:	fc                   	cld    
  801288:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128a:	eb 11                	jmp    80129d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80128c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801290:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801293:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801297:	48 89 d7             	mov    %rdx,%rdi
  80129a:	fc                   	cld    
  80129b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 28          	sub    $0x28,%rsp
  8012ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012cf:	0f 83 88 00 00 00    	jae    80135d <memmove+0xba>
  8012d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012dd:	48 01 d0             	add    %rdx,%rax
  8012e0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e4:	76 77                	jbe    80135d <memmove+0xba>
		s += n;
  8012e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ea:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fa:	83 e0 03             	and    $0x3,%eax
  8012fd:	48 85 c0             	test   %rax,%rax
  801300:	75 3b                	jne    80133d <memmove+0x9a>
  801302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801306:	83 e0 03             	and    $0x3,%eax
  801309:	48 85 c0             	test   %rax,%rax
  80130c:	75 2f                	jne    80133d <memmove+0x9a>
  80130e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	48 85 c0             	test   %rax,%rax
  801318:	75 23                	jne    80133d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131e:	48 83 e8 04          	sub    $0x4,%rax
  801322:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801326:	48 83 ea 04          	sub    $0x4,%rdx
  80132a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80132e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 89 d6             	mov    %rdx,%rsi
  801338:	fd                   	std    
  801339:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133b:	eb 1d                	jmp    80135a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80133d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801341:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801349:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80134d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801351:	48 89 d7             	mov    %rdx,%rdi
  801354:	48 89 c1             	mov    %rax,%rcx
  801357:	fd                   	std    
  801358:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135a:	fc                   	cld    
  80135b:	eb 57                	jmp    8013b4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801361:	83 e0 03             	and    $0x3,%eax
  801364:	48 85 c0             	test   %rax,%rax
  801367:	75 36                	jne    80139f <memmove+0xfc>
  801369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	48 85 c0             	test   %rax,%rax
  801373:	75 2a                	jne    80139f <memmove+0xfc>
  801375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801379:	83 e0 03             	and    $0x3,%eax
  80137c:	48 85 c0             	test   %rax,%rax
  80137f:	75 1e                	jne    80139f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	48 c1 e8 02          	shr    $0x2,%rax
  801389:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80138c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801390:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801394:	48 89 c7             	mov    %rax,%rdi
  801397:	48 89 d6             	mov    %rdx,%rsi
  80139a:	fc                   	cld    
  80139b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80139d:	eb 15                	jmp    8013b4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80139f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ab:	48 89 c7             	mov    %rax,%rdi
  8013ae:	48 89 d6             	mov    %rdx,%rsi
  8013b1:	fc                   	cld    
  8013b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 18          	sub    $0x18,%rsp
  8013c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	48 89 ce             	mov    %rcx,%rsi
  8013dd:	48 89 c7             	mov    %rax,%rdi
  8013e0:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8013e7:	00 00 00 
  8013ea:	ff d0                	callq  *%rax
}
  8013ec:	c9                   	leaveq 
  8013ed:	c3                   	retq   

00000000008013ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	48 83 ec 28          	sub    $0x28,%rsp
  8013f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801412:	eb 36                	jmp    80144a <memcmp+0x5c>
		if (*s1 != *s2)
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801418:	0f b6 10             	movzbl (%rax),%edx
  80141b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	38 c2                	cmp    %al,%dl
  801424:	74 1a                	je     801440 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	0f b6 d0             	movzbl %al,%edx
  801430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	0f b6 c0             	movzbl %al,%eax
  80143a:	29 c2                	sub    %eax,%edx
  80143c:	89 d0                	mov    %edx,%eax
  80143e:	eb 20                	jmp    801460 <memcmp+0x72>
		s1++, s2++;
  801440:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801445:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801452:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801456:	48 85 c0             	test   %rax,%rax
  801459:	75 b9                	jne    801414 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 83 ec 28          	sub    $0x28,%rsp
  80146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80147d:	48 01 d0             	add    %rdx,%rax
  801480:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801484:	eb 15                	jmp    80149b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	0f b6 10             	movzbl (%rax),%edx
  80148d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801490:	38 c2                	cmp    %al,%dl
  801492:	75 02                	jne    801496 <memfind+0x34>
			break;
  801494:	eb 0f                	jmp    8014a5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801496:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a3:	72 e1                	jb     801486 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 34          	sub    $0x34,%rsp
  8014b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014bb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014cc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014cd:	eb 05                	jmp    8014d4 <strtol+0x29>
		s++;
  8014cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	3c 20                	cmp    $0x20,%al
  8014dd:	74 f0                	je     8014cf <strtol+0x24>
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	3c 09                	cmp    $0x9,%al
  8014e8:	74 e5                	je     8014cf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 2b                	cmp    $0x2b,%al
  8014f3:	75 07                	jne    8014fc <strtol+0x51>
		s++;
  8014f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014fa:	eb 17                	jmp    801513 <strtol+0x68>
	else if (*s == '-')
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	3c 2d                	cmp    $0x2d,%al
  801505:	75 0c                	jne    801513 <strtol+0x68>
		s++, neg = 1;
  801507:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80150c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801513:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801517:	74 06                	je     80151f <strtol+0x74>
  801519:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80151d:	75 28                	jne    801547 <strtol+0x9c>
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	3c 30                	cmp    $0x30,%al
  801528:	75 1d                	jne    801547 <strtol+0x9c>
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	48 83 c0 01          	add    $0x1,%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	3c 78                	cmp    $0x78,%al
  801537:	75 0e                	jne    801547 <strtol+0x9c>
		s += 2, base = 16;
  801539:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80153e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801545:	eb 2c                	jmp    801573 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801547:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154b:	75 19                	jne    801566 <strtol+0xbb>
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 30                	cmp    $0x30,%al
  801556:	75 0e                	jne    801566 <strtol+0xbb>
		s++, base = 8;
  801558:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80155d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801564:	eb 0d                	jmp    801573 <strtol+0xc8>
	else if (base == 0)
  801566:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80156a:	75 07                	jne    801573 <strtol+0xc8>
		base = 10;
  80156c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801577:	0f b6 00             	movzbl (%rax),%eax
  80157a:	3c 2f                	cmp    $0x2f,%al
  80157c:	7e 1d                	jle    80159b <strtol+0xf0>
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3c 39                	cmp    $0x39,%al
  801587:	7f 12                	jg     80159b <strtol+0xf0>
			dig = *s - '0';
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	0f be c0             	movsbl %al,%eax
  801593:	83 e8 30             	sub    $0x30,%eax
  801596:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801599:	eb 4e                	jmp    8015e9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	3c 60                	cmp    $0x60,%al
  8015a4:	7e 1d                	jle    8015c3 <strtol+0x118>
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 7a                	cmp    $0x7a,%al
  8015af:	7f 12                	jg     8015c3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	0f be c0             	movsbl %al,%eax
  8015bb:	83 e8 57             	sub    $0x57,%eax
  8015be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c1:	eb 26                	jmp    8015e9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	3c 40                	cmp    $0x40,%al
  8015cc:	7e 48                	jle    801616 <strtol+0x16b>
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 5a                	cmp    $0x5a,%al
  8015d7:	7f 3d                	jg     801616 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	0f be c0             	movsbl %al,%eax
  8015e3:	83 e8 37             	sub    $0x37,%eax
  8015e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015ec:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ef:	7c 02                	jl     8015f3 <strtol+0x148>
			break;
  8015f1:	eb 23                	jmp    801616 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015fb:	48 98                	cltq   
  8015fd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801602:	48 89 c2             	mov    %rax,%rdx
  801605:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801608:	48 98                	cltq   
  80160a:	48 01 d0             	add    %rdx,%rax
  80160d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801611:	e9 5d ff ff ff       	jmpq   801573 <strtol+0xc8>

	if (endptr)
  801616:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80161b:	74 0b                	je     801628 <strtol+0x17d>
		*endptr = (char *) s;
  80161d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801621:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801625:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801628:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80162c:	74 09                	je     801637 <strtol+0x18c>
  80162e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801632:	48 f7 d8             	neg    %rax
  801635:	eb 04                	jmp    80163b <strtol+0x190>
  801637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163b:	c9                   	leaveq 
  80163c:	c3                   	retq   

000000000080163d <strstr>:

char * strstr(const char *in, const char *str)
{
  80163d:	55                   	push   %rbp
  80163e:	48 89 e5             	mov    %rsp,%rbp
  801641:	48 83 ec 30          	sub    $0x30,%rsp
  801645:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801649:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80164d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801651:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801655:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80165f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801663:	75 06                	jne    80166b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	eb 6b                	jmp    8016d6 <strstr+0x99>

	len = strlen(str);
  80166b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166f:	48 89 c7             	mov    %rax,%rdi
  801672:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  801679:	00 00 00 
  80167c:	ff d0                	callq  *%rax
  80167e:	48 98                	cltq   
  801680:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80168c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801696:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80169a:	75 07                	jne    8016a3 <strstr+0x66>
				return (char *) 0;
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a1:	eb 33                	jmp    8016d6 <strstr+0x99>
		} while (sc != c);
  8016a3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016a7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016aa:	75 d8                	jne    801684 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	48 89 ce             	mov    %rcx,%rsi
  8016bb:	48 89 c7             	mov    %rax,%rdi
  8016be:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8016c5:	00 00 00 
  8016c8:	ff d0                	callq  *%rax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	75 b6                	jne    801684 <strstr+0x47>

	return (char *) (in - 1);
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	48 83 e8 01          	sub    $0x1,%rax
}
  8016d6:	c9                   	leaveq 
  8016d7:	c3                   	retq   

00000000008016d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	53                   	push   %rbx
  8016dd:	48 83 ec 48          	sub    $0x48,%rsp
  8016e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016fa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016fe:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801702:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801706:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80170e:	4c 89 c3             	mov    %r8,%rbx
  801711:	cd 30                	int    $0x30
  801713:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801717:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80171b:	74 3e                	je     80175b <syscall+0x83>
  80171d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801722:	7e 37                	jle    80175b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801724:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801728:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172b:	49 89 d0             	mov    %rdx,%r8
  80172e:	89 c1                	mov    %eax,%ecx
  801730:	48 ba 08 4d 80 00 00 	movabs $0x804d08,%rdx
  801737:	00 00 00 
  80173a:	be 23 00 00 00       	mov    $0x23,%esi
  80173f:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  801746:	00 00 00 
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
  80174e:	49 b9 f7 44 80 00 00 	movabs $0x8044f7,%r9
  801755:	00 00 00 
  801758:	41 ff d1             	callq  *%r9

	return ret;
  80175b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175f:	48 83 c4 48          	add    $0x48,%rsp
  801763:	5b                   	pop    %rbx
  801764:	5d                   	pop    %rbp
  801765:	c3                   	retq   

0000000000801766 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801766:	55                   	push   %rbp
  801767:	48 89 e5             	mov    %rsp,%rbp
  80176a:	48 83 ec 20          	sub    $0x20,%rsp
  80176e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801772:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801785:	00 
  801786:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801792:	48 89 d1             	mov    %rdx,%rcx
  801795:	48 89 c2             	mov    %rax,%rdx
  801798:	be 00 00 00 00       	mov    $0x0,%esi
  80179d:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a2:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
}
  8017ae:	c9                   	leaveq 
  8017af:	c3                   	retq   

00000000008017b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bf:	00 
  8017c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	be 00 00 00 00       	mov    $0x0,%esi
  8017db:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
}
  8017ec:	c9                   	leaveq 
  8017ed:	c3                   	retq   

00000000008017ee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ee:	55                   	push   %rbp
  8017ef:	48 89 e5             	mov    %rsp,%rbp
  8017f2:	48 83 ec 10          	sub    $0x10,%rsp
  8017f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fc:	48 98                	cltq   
  8017fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801805:	00 
  801806:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801812:	b9 00 00 00 00       	mov    $0x0,%ecx
  801817:	48 89 c2             	mov    %rax,%rdx
  80181a:	be 01 00 00 00       	mov    $0x1,%esi
  80181f:	bf 03 00 00 00       	mov    $0x3,%edi
  801824:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80183a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801841:	00 
  801842:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801848:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	be 00 00 00 00       	mov    $0x0,%esi
  80185d:	bf 02 00 00 00       	mov    $0x2,%edi
  801862:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
}
  80186e:	c9                   	leaveq 
  80186f:	c3                   	retq   

0000000000801870 <sys_yield>:

void
sys_yield(void)
{
  801870:	55                   	push   %rbp
  801871:	48 89 e5             	mov    %rsp,%rbp
  801874:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801878:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187f:	00 
  801880:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801886:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	be 00 00 00 00       	mov    $0x0,%esi
  80189b:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c3:	48 63 c8             	movslq %eax,%rcx
  8018c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cd:	48 98                	cltq   
  8018cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d6:	00 
  8018d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dd:	49 89 c8             	mov    %rcx,%r8
  8018e0:	48 89 d1             	mov    %rdx,%rcx
  8018e3:	48 89 c2             	mov    %rax,%rdx
  8018e6:	be 01 00 00 00       	mov    $0x1,%esi
  8018eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018f7:	00 00 00 
  8018fa:	ff d0                	callq  *%rax
}
  8018fc:	c9                   	leaveq 
  8018fd:	c3                   	retq   

00000000008018fe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018fe:	55                   	push   %rbp
  8018ff:	48 89 e5             	mov    %rsp,%rbp
  801902:	48 83 ec 30          	sub    $0x30,%rsp
  801906:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801909:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801910:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801914:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801918:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191b:	48 63 c8             	movslq %eax,%rcx
  80191e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801922:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801925:	48 63 f0             	movslq %eax,%rsi
  801928:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192f:	48 98                	cltq   
  801931:	48 89 0c 24          	mov    %rcx,(%rsp)
  801935:	49 89 f9             	mov    %rdi,%r9
  801938:	49 89 f0             	mov    %rsi,%r8
  80193b:	48 89 d1             	mov    %rdx,%rcx
  80193e:	48 89 c2             	mov    %rax,%rdx
  801941:	be 01 00 00 00       	mov    $0x1,%esi
  801946:	bf 05 00 00 00       	mov    $0x5,%edi
  80194b:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
}
  801957:	c9                   	leaveq 
  801958:	c3                   	retq   

0000000000801959 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801959:	55                   	push   %rbp
  80195a:	48 89 e5             	mov    %rsp,%rbp
  80195d:	48 83 ec 20          	sub    $0x20,%rsp
  801961:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801964:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196f:	48 98                	cltq   
  801971:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801978:	00 
  801979:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801985:	48 89 d1             	mov    %rdx,%rcx
  801988:	48 89 c2             	mov    %rax,%rdx
  80198b:	be 01 00 00 00       	mov    $0x1,%esi
  801990:	bf 06 00 00 00       	mov    $0x6,%edi
  801995:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  80199c:	00 00 00 
  80199f:	ff d0                	callq  *%rax
}
  8019a1:	c9                   	leaveq 
  8019a2:	c3                   	retq   

00000000008019a3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	48 83 ec 10          	sub    $0x10,%rsp
  8019ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b4:	48 63 d0             	movslq %eax,%rdx
  8019b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ba:	48 98                	cltq   
  8019bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c3:	00 
  8019c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d0:	48 89 d1             	mov    %rdx,%rcx
  8019d3:	48 89 c2             	mov    %rax,%rdx
  8019d6:	be 01 00 00 00       	mov    $0x1,%esi
  8019db:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8019e7:	00 00 00 
  8019ea:	ff d0                	callq  *%rax
}
  8019ec:	c9                   	leaveq 
  8019ed:	c3                   	retq   

00000000008019ee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019ee:	55                   	push   %rbp
  8019ef:	48 89 e5             	mov    %rsp,%rbp
  8019f2:	48 83 ec 20          	sub    $0x20,%rsp
  8019f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a04:	48 98                	cltq   
  801a06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0d:	00 
  801a0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1a:	48 89 d1             	mov    %rdx,%rcx
  801a1d:	48 89 c2             	mov    %rax,%rdx
  801a20:	be 01 00 00 00       	mov    $0x1,%esi
  801a25:	bf 09 00 00 00       	mov    $0x9,%edi
  801a2a:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4e:	48 98                	cltq   
  801a50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a57:	00 
  801a58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a64:	48 89 d1             	mov    %rdx,%rcx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a74:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 20          	sub    $0x20,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a95:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9b:	48 63 f0             	movslq %eax,%rsi
  801a9e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa5:	48 98                	cltq   
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab2:	00 
  801ab3:	49 89 f1             	mov    %rsi,%r9
  801ab6:	49 89 c8             	mov    %rcx,%r8
  801ab9:	48 89 d1             	mov    %rdx,%rcx
  801abc:	48 89 c2             	mov    %rax,%rdx
  801abf:	be 00 00 00 00       	mov    $0x0,%esi
  801ac4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ac9:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	callq  *%rax
}
  801ad5:	c9                   	leaveq 
  801ad6:	c3                   	retq   

0000000000801ad7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	48 83 ec 10          	sub    $0x10,%rsp
  801adf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aee:	00 
  801aef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b00:	48 89 c2             	mov    %rax,%rdx
  801b03:	be 01 00 00 00       	mov    $0x1,%esi
  801b08:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b0d:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 20          	sub    $0x20,%rsp
  801b23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b47:	48 89 d1             	mov    %rdx,%rcx
  801b4a:	48 89 c2             	mov    %rax,%rdx
  801b4d:	be 01 00 00 00       	mov    $0x1,%esi
  801b52:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b57:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 10          	sub    $0x10,%rsp
  801b6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7c:	00 
  801b7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8e:	48 89 c2             	mov    %rax,%rdx
  801b91:	be 00 00 00 00       	mov    $0x0,%esi
  801b96:	bf 10 00 00 00       	mov    $0x10,%edi
  801b9b:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bca:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcf:	be 00 00 00 00       	mov    $0x0,%esi
  801bd4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bd9:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801be0:	00 00 00 
  801be3:	ff d0                	callq  *%rax
}
  801be5:	c9                   	leaveq 
  801be6:	c3                   	retq   

0000000000801be7 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801be7:	55                   	push   %rbp
  801be8:	48 89 e5             	mov    %rsp,%rbp
  801beb:	48 83 ec 30          	sub    $0x30,%rsp
  801bef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf7:	48 8b 00             	mov    (%rax),%rax
  801bfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c02:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c06:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c09:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c0c:	83 e0 02             	and    $0x2,%eax
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	75 4d                	jne    801c60 <pgfault+0x79>
  801c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c17:	48 c1 e8 0c          	shr    $0xc,%rax
  801c1b:	48 89 c2             	mov    %rax,%rdx
  801c1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c25:	01 00 00 
  801c28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2c:	25 00 08 00 00       	and    $0x800,%eax
  801c31:	48 85 c0             	test   %rax,%rax
  801c34:	74 2a                	je     801c60 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801c36:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801c3d:	00 00 00 
  801c40:	be 23 00 00 00       	mov    $0x23,%esi
  801c45:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801c4c:	00 00 00 
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c54:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801c5b:	00 00 00 
  801c5e:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801c60:	ba 07 00 00 00       	mov    $0x7,%edx
  801c65:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6f:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  801c76:	00 00 00 
  801c79:	ff d0                	callq  *%rax
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	0f 85 cd 00 00 00    	jne    801d50 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c95:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ca2:	48 89 c6             	mov    %rax,%rsi
  801ca5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801caa:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cba:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cc0:	48 89 c1             	mov    %rax,%rcx
  801cc3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd2:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	79 2a                	jns    801d0c <pgfault+0x125>
				panic("Page map at temp address failed");
  801ce2:	48 ba 78 4d 80 00 00 	movabs $0x804d78,%rdx
  801ce9:	00 00 00 
  801cec:	be 30 00 00 00       	mov    $0x30,%esi
  801cf1:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801cf8:	00 00 00 
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801d07:	00 00 00 
  801d0a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d0c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d11:	bf 00 00 00 00       	mov    $0x0,%edi
  801d16:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	callq  *%rax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	79 54                	jns    801d7a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d26:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  801d2d:	00 00 00 
  801d30:	be 32 00 00 00       	mov    $0x32,%esi
  801d35:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d3c:	00 00 00 
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801d4b:	00 00 00 
  801d4e:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801d50:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  801d57:	00 00 00 
  801d5a:	be 34 00 00 00       	mov    $0x34,%esi
  801d5f:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d66:	00 00 00 
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801d75:	00 00 00 
  801d78:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801d7a:	c9                   	leaveq 
  801d7b:	c3                   	retq   

0000000000801d7c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	48 83 ec 20          	sub    $0x20,%rsp
  801d84:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d87:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801d8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d91:	01 00 00 
  801d94:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9b:	25 07 0e 00 00       	and    $0xe07,%eax
  801da0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801da3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801da6:	48 c1 e0 0c          	shl    $0xc,%rax
  801daa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db1:	25 00 04 00 00       	and    $0x400,%eax
  801db6:	85 c0                	test   %eax,%eax
  801db8:	74 57                	je     801e11 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801dba:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801dbd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dc1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc8:	41 89 f0             	mov    %esi,%r8d
  801dcb:	48 89 c6             	mov    %rax,%rsi
  801dce:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd3:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801dda:	00 00 00 
  801ddd:	ff d0                	callq  *%rax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	0f 8e 52 01 00 00    	jle    801f39 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801de7:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801dee:	00 00 00 
  801df1:	be 4e 00 00 00       	mov    $0x4e,%esi
  801df6:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801dfd:	00 00 00 
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
  801e05:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801e0c:	00 00 00 
  801e0f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801e11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e14:	83 e0 02             	and    $0x2,%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	75 10                	jne    801e2b <duppage+0xaf>
  801e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1e:	25 00 08 00 00       	and    $0x800,%eax
  801e23:	85 c0                	test   %eax,%eax
  801e25:	0f 84 bb 00 00 00    	je     801ee6 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2e:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e33:	80 cc 08             	or     $0x8,%ah
  801e36:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e39:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e3c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e47:	41 89 f0             	mov    %esi,%r8d
  801e4a:	48 89 c6             	mov    %rax,%rsi
  801e4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e52:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801e59:	00 00 00 
  801e5c:	ff d0                	callq  *%rax
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	7e 2a                	jle    801e8c <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801e62:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801e69:	00 00 00 
  801e6c:	be 55 00 00 00       	mov    $0x55,%esi
  801e71:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e78:	00 00 00 
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801e87:	00 00 00 
  801e8a:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e8c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e97:	41 89 c8             	mov    %ecx,%r8d
  801e9a:	48 89 d1             	mov    %rdx,%rcx
  801e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea2:	48 89 c6             	mov    %rax,%rsi
  801ea5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eaa:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801eb1:	00 00 00 
  801eb4:	ff d0                	callq  *%rax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	7e 2a                	jle    801ee4 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801eba:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801ec1:	00 00 00 
  801ec4:	be 57 00 00 00       	mov    $0x57,%esi
  801ec9:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ed0:	00 00 00 
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801edf:	00 00 00 
  801ee2:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ee4:	eb 53                	jmp    801f39 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ee6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ee9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef4:	41 89 f0             	mov    %esi,%r8d
  801ef7:	48 89 c6             	mov    %rax,%rsi
  801efa:	bf 00 00 00 00       	mov    $0x0,%edi
  801eff:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	7e 2a                	jle    801f39 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f0f:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f16:	00 00 00 
  801f19:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f1e:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801f25:	00 00 00 
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2d:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  801f34:	00 00 00 
  801f37:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3e:	c9                   	leaveq 
  801f3f:	c3                   	retq   

0000000000801f40 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801f40:	55                   	push   %rbp
  801f41:	48 89 e5             	mov    %rsp,%rbp
  801f44:	48 83 ec 18          	sub    $0x18,%rsp
  801f48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f58:	48 c1 e8 27          	shr    $0x27,%rax
  801f5c:	48 89 c2             	mov    %rax,%rdx
  801f5f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f66:	01 00 00 
  801f69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6d:	83 e0 01             	and    $0x1,%eax
  801f70:	48 85 c0             	test   %rax,%rax
  801f73:	74 51                	je     801fc6 <pt_is_mapped+0x86>
  801f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f79:	48 c1 e0 0c          	shl    $0xc,%rax
  801f7d:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f81:	48 89 c2             	mov    %rax,%rdx
  801f84:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f8b:	01 00 00 
  801f8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f92:	83 e0 01             	and    $0x1,%eax
  801f95:	48 85 c0             	test   %rax,%rax
  801f98:	74 2c                	je     801fc6 <pt_is_mapped+0x86>
  801f9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9e:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa2:	48 c1 e8 15          	shr    $0x15,%rax
  801fa6:	48 89 c2             	mov    %rax,%rdx
  801fa9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fb0:	01 00 00 
  801fb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb7:	83 e0 01             	and    $0x1,%eax
  801fba:	48 85 c0             	test   %rax,%rax
  801fbd:	74 07                	je     801fc6 <pt_is_mapped+0x86>
  801fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc4:	eb 05                	jmp    801fcb <pt_is_mapped+0x8b>
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	83 e0 01             	and    $0x1,%eax
}
  801fce:	c9                   	leaveq 
  801fcf:	c3                   	retq   

0000000000801fd0 <fork>:

envid_t
fork(void)
{
  801fd0:	55                   	push   %rbp
  801fd1:	48 89 e5             	mov    %rsp,%rbp
  801fd4:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801fd8:	48 bf e7 1b 80 00 00 	movabs $0x801be7,%rdi
  801fdf:	00 00 00 
  801fe2:	48 b8 0b 46 80 00 00 	movabs $0x80460b,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fee:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff3:	cd 30                	int    $0x30
  801ff5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ff8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801ffb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802002:	79 30                	jns    802034 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802004:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802007:	89 c1                	mov    %eax,%ecx
  802009:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  802010:	00 00 00 
  802013:	be 86 00 00 00       	mov    $0x86,%esi
  802018:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80201f:	00 00 00 
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	49 b8 f7 44 80 00 00 	movabs $0x8044f7,%r8
  80202e:	00 00 00 
  802031:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802034:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802038:	75 46                	jne    802080 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80203a:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	25 ff 03 00 00       	and    $0x3ff,%eax
  80204b:	48 63 d0             	movslq %eax,%rdx
  80204e:	48 89 d0             	mov    %rdx,%rax
  802051:	48 c1 e0 03          	shl    $0x3,%rax
  802055:	48 01 d0             	add    %rdx,%rax
  802058:	48 c1 e0 05          	shl    $0x5,%rax
  80205c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802063:	00 00 00 
  802066:	48 01 c2             	add    %rax,%rdx
  802069:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802070:	00 00 00 
  802073:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	e9 d1 01 00 00       	jmpq   802251 <fork+0x281>
	}
	uint64_t ad = 0;
  802080:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802087:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802088:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80208d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802091:	e9 df 00 00 00       	jmpq   802175 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802096:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80209a:	48 c1 e8 27          	shr    $0x27,%rax
  80209e:	48 89 c2             	mov    %rax,%rdx
  8020a1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020a8:	01 00 00 
  8020ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020af:	83 e0 01             	and    $0x1,%eax
  8020b2:	48 85 c0             	test   %rax,%rax
  8020b5:	0f 84 9e 00 00 00    	je     802159 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8020bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020bf:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020c3:	48 89 c2             	mov    %rax,%rdx
  8020c6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020cd:	01 00 00 
  8020d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d4:	83 e0 01             	and    $0x1,%eax
  8020d7:	48 85 c0             	test   %rax,%rax
  8020da:	74 73                	je     80214f <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8020dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e0:	48 c1 e8 15          	shr    $0x15,%rax
  8020e4:	48 89 c2             	mov    %rax,%rdx
  8020e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020ee:	01 00 00 
  8020f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f5:	83 e0 01             	and    $0x1,%eax
  8020f8:	48 85 c0             	test   %rax,%rax
  8020fb:	74 48                	je     802145 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8020fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802101:	48 c1 e8 0c          	shr    $0xc,%rax
  802105:	48 89 c2             	mov    %rax,%rdx
  802108:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210f:	01 00 00 
  802112:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802116:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80211a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	48 85 c0             	test   %rax,%rax
  802124:	74 47                	je     80216d <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212a:	48 c1 e8 0c          	shr    $0xc,%rax
  80212e:	89 c2                	mov    %eax,%edx
  802130:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802133:	89 d6                	mov    %edx,%esi
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	eb 28                	jmp    80216d <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802145:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80214c:	00 
  80214d:	eb 1e                	jmp    80216d <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80214f:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802156:	40 
  802157:	eb 14                	jmp    80216d <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80215d:	48 c1 e8 27          	shr    $0x27,%rax
  802161:	48 83 c0 01          	add    $0x1,%rax
  802165:	48 c1 e0 27          	shl    $0x27,%rax
  802169:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80216d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802174:	00 
  802175:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80217c:	00 
  80217d:	0f 87 13 ff ff ff    	ja     802096 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802186:	ba 07 00 00 00       	mov    $0x7,%edx
  80218b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802190:	89 c7                	mov    %eax,%edi
  802192:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80219e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a1:	ba 07 00 00 00       	mov    $0x7,%edx
  8021a6:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021ab:	89 c7                	mov    %eax,%edi
  8021ad:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8021b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021bc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021c2:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8021c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cc:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021d1:	89 c7                	mov    %eax,%edi
  8021d3:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8021df:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021e4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021e9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021ee:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8021fa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802204:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802210:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802217:	00 00 00 
  80221a:	48 8b 00             	mov    (%rax),%rax
  80221d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802224:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802227:	48 89 d6             	mov    %rdx,%rsi
  80222a:	89 c7                	mov    %eax,%edi
  80222c:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802233:	00 00 00 
  802236:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802238:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80223b:	be 02 00 00 00       	mov    $0x2,%esi
  802240:	89 c7                	mov    %eax,%edi
  802242:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  802249:	00 00 00 
  80224c:	ff d0                	callq  *%rax

	return envid;
  80224e:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802251:	c9                   	leaveq 
  802252:	c3                   	retq   

0000000000802253 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802253:	55                   	push   %rbp
  802254:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802257:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  80225e:	00 00 00 
  802261:	be bf 00 00 00       	mov    $0xbf,%esi
  802266:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80226d:	00 00 00 
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  80227c:	00 00 00 
  80227f:	ff d1                	callq  *%rcx

0000000000802281 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802281:	55                   	push   %rbp
  802282:	48 89 e5             	mov    %rsp,%rbp
  802285:	48 83 ec 30          	sub    $0x30,%rsp
  802289:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80228d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802291:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802295:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80229c:	00 00 00 
  80229f:	48 8b 00             	mov    (%rax),%rax
  8022a2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	75 3c                	jne    8022e8 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022ac:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022bd:	48 63 d0             	movslq %eax,%rdx
  8022c0:	48 89 d0             	mov    %rdx,%rax
  8022c3:	48 c1 e0 03          	shl    $0x3,%rax
  8022c7:	48 01 d0             	add    %rdx,%rax
  8022ca:	48 c1 e0 05          	shl    $0x5,%rax
  8022ce:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022d5:	00 00 00 
  8022d8:	48 01 c2             	add    %rax,%rdx
  8022db:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8022e2:	00 00 00 
  8022e5:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8022e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022ed:	75 0e                	jne    8022fd <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8022ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022f6:	00 00 00 
  8022f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8022fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802301:	48 89 c7             	mov    %rax,%rdi
  802304:	48 b8 d7 1a 80 00 00 	movabs $0x801ad7,%rax
  80230b:	00 00 00 
  80230e:	ff d0                	callq  *%rax
  802310:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802313:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802317:	79 19                	jns    802332 <ipc_recv+0xb1>
		*from_env_store = 0;
  802319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802327:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80232d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802330:	eb 53                	jmp    802385 <ipc_recv+0x104>
	}
	if(from_env_store)
  802332:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802337:	74 19                	je     802352 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802339:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802340:	00 00 00 
  802343:	48 8b 00             	mov    (%rax),%rax
  802346:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80234c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802350:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802352:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802357:	74 19                	je     802372 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802359:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802360:	00 00 00 
  802363:	48 8b 00             	mov    (%rax),%rax
  802366:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80236c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802370:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802372:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802379:	00 00 00 
  80237c:	48 8b 00             	mov    (%rax),%rax
  80237f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 30          	sub    $0x30,%rsp
  80238f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802392:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802395:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802399:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80239c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023a1:	75 0e                	jne    8023b1 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8023a3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023aa:	00 00 00 
  8023ad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8023b1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023b4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8023b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023be:	89 c7                	mov    %eax,%edi
  8023c0:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
  8023cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8023cf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023d3:	75 0c                	jne    8023e1 <ipc_send+0x5a>
			sys_yield();
  8023d5:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8023e1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023e5:	74 ca                	je     8023b1 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8023e7:	c9                   	leaveq 
  8023e8:	c3                   	retq   

00000000008023e9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	48 83 ec 14          	sub    $0x14,%rsp
  8023f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8023f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023fb:	eb 5e                	jmp    80245b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8023fd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802404:	00 00 00 
  802407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240a:	48 63 d0             	movslq %eax,%rdx
  80240d:	48 89 d0             	mov    %rdx,%rax
  802410:	48 c1 e0 03          	shl    $0x3,%rax
  802414:	48 01 d0             	add    %rdx,%rax
  802417:	48 c1 e0 05          	shl    $0x5,%rax
  80241b:	48 01 c8             	add    %rcx,%rax
  80241e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802424:	8b 00                	mov    (%rax),%eax
  802426:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802429:	75 2c                	jne    802457 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80242b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802432:	00 00 00 
  802435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802438:	48 63 d0             	movslq %eax,%rdx
  80243b:	48 89 d0             	mov    %rdx,%rax
  80243e:	48 c1 e0 03          	shl    $0x3,%rax
  802442:	48 01 d0             	add    %rdx,%rax
  802445:	48 c1 e0 05          	shl    $0x5,%rax
  802449:	48 01 c8             	add    %rcx,%rax
  80244c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802452:	8b 40 08             	mov    0x8(%rax),%eax
  802455:	eb 12                	jmp    802469 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802457:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80245b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802462:	7e 99                	jle    8023fd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802469:	c9                   	leaveq 
  80246a:	c3                   	retq   

000000000080246b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80246b:	55                   	push   %rbp
  80246c:	48 89 e5             	mov    %rsp,%rbp
  80246f:	48 83 ec 08          	sub    $0x8,%rsp
  802473:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802482:	ff ff ff 
  802485:	48 01 d0             	add    %rdx,%rax
  802488:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80248c:	c9                   	leaveq 
  80248d:	c3                   	retq   

000000000080248e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80248e:	55                   	push   %rbp
  80248f:	48 89 e5             	mov    %rsp,%rbp
  802492:	48 83 ec 08          	sub    $0x8,%rsp
  802496:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80249a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024b3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024b7:	c9                   	leaveq 
  8024b8:	c3                   	retq   

00000000008024b9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024b9:	55                   	push   %rbp
  8024ba:	48 89 e5             	mov    %rsp,%rbp
  8024bd:	48 83 ec 18          	sub    $0x18,%rsp
  8024c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024cc:	eb 6b                	jmp    802539 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d1:	48 98                	cltq   
  8024d3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024d9:	48 c1 e0 0c          	shl    $0xc,%rax
  8024dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e5:	48 c1 e8 15          	shr    $0x15,%rax
  8024e9:	48 89 c2             	mov    %rax,%rdx
  8024ec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f3:	01 00 00 
  8024f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fa:	83 e0 01             	and    $0x1,%eax
  8024fd:	48 85 c0             	test   %rax,%rax
  802500:	74 21                	je     802523 <fd_alloc+0x6a>
  802502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802506:	48 c1 e8 0c          	shr    $0xc,%rax
  80250a:	48 89 c2             	mov    %rax,%rdx
  80250d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802514:	01 00 00 
  802517:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251b:	83 e0 01             	and    $0x1,%eax
  80251e:	48 85 c0             	test   %rax,%rax
  802521:	75 12                	jne    802535 <fd_alloc+0x7c>
			*fd_store = fd;
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80252b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	eb 1a                	jmp    80254f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802535:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802539:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80253d:	7e 8f                	jle    8024ce <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80253f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802543:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80254a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 20          	sub    $0x20,%rsp
  802559:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802560:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802564:	78 06                	js     80256c <fd_lookup+0x1b>
  802566:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80256a:	7e 07                	jle    802573 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80256c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802571:	eb 6c                	jmp    8025df <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802573:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802576:	48 98                	cltq   
  802578:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80257e:	48 c1 e0 0c          	shl    $0xc,%rax
  802582:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258a:	48 c1 e8 15          	shr    $0x15,%rax
  80258e:	48 89 c2             	mov    %rax,%rdx
  802591:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802598:	01 00 00 
  80259b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259f:	83 e0 01             	and    $0x1,%eax
  8025a2:	48 85 c0             	test   %rax,%rax
  8025a5:	74 21                	je     8025c8 <fd_lookup+0x77>
  8025a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8025af:	48 89 c2             	mov    %rax,%rdx
  8025b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b9:	01 00 00 
  8025bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c0:	83 e0 01             	and    $0x1,%eax
  8025c3:	48 85 c0             	test   %rax,%rax
  8025c6:	75 07                	jne    8025cf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cd:	eb 10                	jmp    8025df <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 30          	sub    $0x30,%rsp
  8025e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025ed:	89 f0                	mov    %esi,%eax
  8025ef:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f6:	48 89 c7             	mov    %rax,%rdi
  8025f9:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802609:	48 89 d6             	mov    %rdx,%rsi
  80260c:	89 c7                	mov    %eax,%edi
  80260e:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802621:	78 0a                	js     80262d <fd_close+0x4c>
	    || fd != fd2)
  802623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802627:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80262b:	74 12                	je     80263f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80262d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802631:	74 05                	je     802638 <fd_close+0x57>
  802633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802636:	eb 05                	jmp    80263d <fd_close+0x5c>
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
  80263d:	eb 69                	jmp    8026a8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80263f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802643:	8b 00                	mov    (%rax),%eax
  802645:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802649:	48 89 d6             	mov    %rdx,%rsi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
  80265a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802661:	78 2a                	js     80268d <fd_close+0xac>
		if (dev->dev_close)
  802663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802667:	48 8b 40 20          	mov    0x20(%rax),%rax
  80266b:	48 85 c0             	test   %rax,%rax
  80266e:	74 16                	je     802686 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802674:	48 8b 40 20          	mov    0x20(%rax),%rax
  802678:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80267c:	48 89 d7             	mov    %rdx,%rdi
  80267f:	ff d0                	callq  *%rax
  802681:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802684:	eb 07                	jmp    80268d <fd_close+0xac>
		else
			r = 0;
  802686:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80268d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802691:	48 89 c6             	mov    %rax,%rsi
  802694:	bf 00 00 00 00       	mov    $0x0,%edi
  802699:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8026a0:	00 00 00 
  8026a3:	ff d0                	callq  *%rax
	return r;
  8026a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 20          	sub    $0x20,%rsp
  8026b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026c0:	eb 41                	jmp    802703 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026c2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026c9:	00 00 00 
  8026cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026cf:	48 63 d2             	movslq %edx,%rdx
  8026d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d6:	8b 00                	mov    (%rax),%eax
  8026d8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026db:	75 22                	jne    8026ff <dev_lookup+0x55>
			*dev = devtab[i];
  8026dd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026e4:	00 00 00 
  8026e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ea:	48 63 d2             	movslq %edx,%rdx
  8026ed:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fd:	eb 60                	jmp    80275f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026ff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802703:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80270a:	00 00 00 
  80270d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802710:	48 63 d2             	movslq %edx,%rdx
  802713:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802717:	48 85 c0             	test   %rax,%rax
  80271a:	75 a6                	jne    8026c2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80271c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802723:	00 00 00 
  802726:	48 8b 00             	mov    (%rax),%rax
  802729:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80272f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802732:	89 c6                	mov    %eax,%esi
  802734:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  80273b:	00 00 00 
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80274a:	00 00 00 
  80274d:	ff d1                	callq  *%rcx
	*dev = 0;
  80274f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802753:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80275a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80275f:	c9                   	leaveq 
  802760:	c3                   	retq   

0000000000802761 <close>:

int
close(int fdnum)
{
  802761:	55                   	push   %rbp
  802762:	48 89 e5             	mov    %rsp,%rbp
  802765:	48 83 ec 20          	sub    $0x20,%rsp
  802769:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802770:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802773:	48 89 d6             	mov    %rdx,%rsi
  802776:	89 c7                	mov    %eax,%edi
  802778:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
  802784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278b:	79 05                	jns    802792 <close+0x31>
		return r;
  80278d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802790:	eb 18                	jmp    8027aa <close+0x49>
	else
		return fd_close(fd, 1);
  802792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802796:	be 01 00 00 00       	mov    $0x1,%esi
  80279b:	48 89 c7             	mov    %rax,%rdi
  80279e:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	callq  *%rax
}
  8027aa:	c9                   	leaveq 
  8027ab:	c3                   	retq   

00000000008027ac <close_all>:

void
close_all(void)
{
  8027ac:	55                   	push   %rbp
  8027ad:	48 89 e5             	mov    %rsp,%rbp
  8027b0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027bb:	eb 15                	jmp    8027d2 <close_all+0x26>
		close(i);
  8027bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c0:	89 c7                	mov    %eax,%edi
  8027c2:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  8027c9:	00 00 00 
  8027cc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027d6:	7e e5                	jle    8027bd <close_all+0x11>
		close(i);
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 40          	sub    $0x40,%rsp
  8027e2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027e5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027e8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027ec:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ef:	48 89 d6             	mov    %rdx,%rsi
  8027f2:	89 c7                	mov    %eax,%edi
  8027f4:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
  802800:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802803:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802807:	79 08                	jns    802811 <dup+0x37>
		return r;
  802809:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280c:	e9 70 01 00 00       	jmpq   802981 <dup+0x1a7>
	close(newfdnum);
  802811:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802814:	89 c7                	mov    %eax,%edi
  802816:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  80281d:	00 00 00 
  802820:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802822:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802825:	48 98                	cltq   
  802827:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80282d:	48 c1 e0 0c          	shl    $0xc,%rax
  802831:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802839:	48 89 c7             	mov    %rax,%rdi
  80283c:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
  802848:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80284c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802850:	48 89 c7             	mov    %rax,%rdi
  802853:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
  80285f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802867:	48 c1 e8 15          	shr    $0x15,%rax
  80286b:	48 89 c2             	mov    %rax,%rdx
  80286e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802875:	01 00 00 
  802878:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287c:	83 e0 01             	and    $0x1,%eax
  80287f:	48 85 c0             	test   %rax,%rax
  802882:	74 73                	je     8028f7 <dup+0x11d>
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	48 c1 e8 0c          	shr    $0xc,%rax
  80288c:	48 89 c2             	mov    %rax,%rdx
  80288f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802896:	01 00 00 
  802899:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289d:	83 e0 01             	and    $0x1,%eax
  8028a0:	48 85 c0             	test   %rax,%rax
  8028a3:	74 52                	je     8028f7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ad:	48 89 c2             	mov    %rax,%rdx
  8028b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028b7:	01 00 00 
  8028ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028be:	25 07 0e 00 00       	and    $0xe07,%eax
  8028c3:	89 c1                	mov    %eax,%ecx
  8028c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cd:	41 89 c8             	mov    %ecx,%r8d
  8028d0:	48 89 d1             	mov    %rdx,%rcx
  8028d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d8:	48 89 c6             	mov    %rax,%rsi
  8028db:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e0:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  8028e7:	00 00 00 
  8028ea:	ff d0                	callq  *%rax
  8028ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f3:	79 02                	jns    8028f7 <dup+0x11d>
			goto err;
  8028f5:	eb 57                	jmp    80294e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ff:	48 89 c2             	mov    %rax,%rdx
  802902:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802909:	01 00 00 
  80290c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802910:	25 07 0e 00 00       	and    $0xe07,%eax
  802915:	89 c1                	mov    %eax,%ecx
  802917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80291f:	41 89 c8             	mov    %ecx,%r8d
  802922:	48 89 d1             	mov    %rdx,%rcx
  802925:	ba 00 00 00 00       	mov    $0x0,%edx
  80292a:	48 89 c6             	mov    %rax,%rsi
  80292d:	bf 00 00 00 00       	mov    $0x0,%edi
  802932:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  802939:	00 00 00 
  80293c:	ff d0                	callq  *%rax
  80293e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802941:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802945:	79 02                	jns    802949 <dup+0x16f>
		goto err;
  802947:	eb 05                	jmp    80294e <dup+0x174>

	return newfdnum;
  802949:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80294c:	eb 33                	jmp    802981 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80294e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802952:	48 89 c6             	mov    %rax,%rsi
  802955:	bf 00 00 00 00       	mov    $0x0,%edi
  80295a:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802966:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296a:	48 89 c6             	mov    %rax,%rsi
  80296d:	bf 00 00 00 00       	mov    $0x0,%edi
  802972:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802979:	00 00 00 
  80297c:	ff d0                	callq  *%rax
	return r;
  80297e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 40          	sub    $0x40,%rsp
  80298b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802992:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802996:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299d:	48 89 d6             	mov    %rdx,%rsi
  8029a0:	89 c7                	mov    %eax,%edi
  8029a2:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	callq  *%rax
  8029ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b5:	78 24                	js     8029db <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bb:	8b 00                	mov    (%rax),%eax
  8029bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c1:	48 89 d6             	mov    %rdx,%rsi
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d9:	79 05                	jns    8029e0 <read+0x5d>
		return r;
  8029db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029de:	eb 76                	jmp    802a56 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e4:	8b 40 08             	mov    0x8(%rax),%eax
  8029e7:	83 e0 03             	and    $0x3,%eax
  8029ea:	83 f8 01             	cmp    $0x1,%eax
  8029ed:	75 3a                	jne    802a29 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ef:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8029f6:	00 00 00 
  8029f9:	48 8b 00             	mov    (%rax),%rax
  8029fc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a02:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a05:	89 c6                	mov    %eax,%esi
  802a07:	48 bf 5f 4e 80 00 00 	movabs $0x804e5f,%rdi
  802a0e:	00 00 00 
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802a1d:	00 00 00 
  802a20:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a27:	eb 2d                	jmp    802a56 <read+0xd3>
	}
	if (!dev->dev_read)
  802a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a31:	48 85 c0             	test   %rax,%rax
  802a34:	75 07                	jne    802a3d <read+0xba>
		return -E_NOT_SUPP;
  802a36:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a3b:	eb 19                	jmp    802a56 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a41:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a45:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a4d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a51:	48 89 cf             	mov    %rcx,%rdi
  802a54:	ff d0                	callq  *%rax
}
  802a56:	c9                   	leaveq 
  802a57:	c3                   	retq   

0000000000802a58 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a58:	55                   	push   %rbp
  802a59:	48 89 e5             	mov    %rsp,%rbp
  802a5c:	48 83 ec 30          	sub    $0x30,%rsp
  802a60:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a72:	eb 49                	jmp    802abd <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a77:	48 98                	cltq   
  802a79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a7d:	48 29 c2             	sub    %rax,%rdx
  802a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a83:	48 63 c8             	movslq %eax,%rcx
  802a86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8a:	48 01 c1             	add    %rax,%rcx
  802a8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a90:	48 89 ce             	mov    %rcx,%rsi
  802a93:	89 c7                	mov    %eax,%edi
  802a95:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
  802aa1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802aa4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aa8:	79 05                	jns    802aaf <readn+0x57>
			return m;
  802aaa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aad:	eb 1c                	jmp    802acb <readn+0x73>
		if (m == 0)
  802aaf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ab3:	75 02                	jne    802ab7 <readn+0x5f>
			break;
  802ab5:	eb 11                	jmp    802ac8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ab7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aba:	01 45 fc             	add    %eax,-0x4(%rbp)
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac0:	48 98                	cltq   
  802ac2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ac6:	72 ac                	jb     802a74 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802acb:	c9                   	leaveq 
  802acc:	c3                   	retq   

0000000000802acd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802acd:	55                   	push   %rbp
  802ace:	48 89 e5             	mov    %rsp,%rbp
  802ad1:	48 83 ec 40          	sub    $0x40,%rsp
  802ad5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802adc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ae0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae7:	48 89 d6             	mov    %rdx,%rsi
  802aea:	89 c7                	mov    %eax,%edi
  802aec:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
  802af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aff:	78 24                	js     802b25 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b05:	8b 00                	mov    (%rax),%eax
  802b07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0b:	48 89 d6             	mov    %rdx,%rsi
  802b0e:	89 c7                	mov    %eax,%edi
  802b10:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b23:	79 05                	jns    802b2a <write+0x5d>
		return r;
  802b25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b28:	eb 75                	jmp    802b9f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2e:	8b 40 08             	mov    0x8(%rax),%eax
  802b31:	83 e0 03             	and    $0x3,%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	75 3a                	jne    802b72 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b38:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802b3f:	00 00 00 
  802b42:	48 8b 00             	mov    (%rax),%rax
  802b45:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b4b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4e:	89 c6                	mov    %eax,%esi
  802b50:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
  802b57:	00 00 00 
  802b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5f:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802b66:	00 00 00 
  802b69:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b70:	eb 2d                	jmp    802b9f <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b76:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b7a:	48 85 c0             	test   %rax,%rax
  802b7d:	75 07                	jne    802b86 <write+0xb9>
		return -E_NOT_SUPP;
  802b7f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b84:	eb 19                	jmp    802b9f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b8e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b96:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b9a:	48 89 cf             	mov    %rcx,%rdi
  802b9d:	ff d0                	callq  *%rax
}
  802b9f:	c9                   	leaveq 
  802ba0:	c3                   	retq   

0000000000802ba1 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ba1:	55                   	push   %rbp
  802ba2:	48 89 e5             	mov    %rsp,%rbp
  802ba5:	48 83 ec 18          	sub    $0x18,%rsp
  802ba9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bac:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802baf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb6:	48 89 d6             	mov    %rdx,%rsi
  802bb9:	89 c7                	mov    %eax,%edi
  802bbb:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bce:	79 05                	jns    802bd5 <seek+0x34>
		return r;
  802bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd3:	eb 0f                	jmp    802be4 <seek+0x43>
	fd->fd_offset = offset;
  802bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
  802bea:	48 83 ec 30          	sub    $0x30,%rsp
  802bee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bfb:	48 89 d6             	mov    %rdx,%rsi
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
  802c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c13:	78 24                	js     802c39 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c19:	8b 00                	mov    (%rax),%eax
  802c1b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c1f:	48 89 d6             	mov    %rdx,%rsi
  802c22:	89 c7                	mov    %eax,%edi
  802c24:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
  802c30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c37:	79 05                	jns    802c3e <ftruncate+0x58>
		return r;
  802c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3c:	eb 72                	jmp    802cb0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c42:	8b 40 08             	mov    0x8(%rax),%eax
  802c45:	83 e0 03             	and    $0x3,%eax
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	75 3a                	jne    802c86 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c4c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802c53:	00 00 00 
  802c56:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c59:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c5f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c62:	89 c6                	mov    %eax,%esi
  802c64:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  802c6b:	00 00 00 
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c73:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802c7a:	00 00 00 
  802c7d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c84:	eb 2a                	jmp    802cb0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c8e:	48 85 c0             	test   %rax,%rax
  802c91:	75 07                	jne    802c9a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c93:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c98:	eb 16                	jmp    802cb0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ca2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ca9:	89 ce                	mov    %ecx,%esi
  802cab:	48 89 d7             	mov    %rdx,%rdi
  802cae:	ff d0                	callq  *%rax
}
  802cb0:	c9                   	leaveq 
  802cb1:	c3                   	retq   

0000000000802cb2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cb2:	55                   	push   %rbp
  802cb3:	48 89 e5             	mov    %rsp,%rbp
  802cb6:	48 83 ec 30          	sub    $0x30,%rsp
  802cba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc8:	48 89 d6             	mov    %rdx,%rsi
  802ccb:	89 c7                	mov    %eax,%edi
  802ccd:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce0:	78 24                	js     802d06 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce6:	8b 00                	mov    (%rax),%eax
  802ce8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cec:	48 89 d6             	mov    %rdx,%rsi
  802cef:	89 c7                	mov    %eax,%edi
  802cf1:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	79 05                	jns    802d0b <fstat+0x59>
		return r;
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	eb 5e                	jmp    802d69 <fstat+0xb7>
	if (!dev->dev_stat)
  802d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d13:	48 85 c0             	test   %rax,%rax
  802d16:	75 07                	jne    802d1f <fstat+0x6d>
		return -E_NOT_SUPP;
  802d18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d1d:	eb 4a                	jmp    802d69 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d23:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d31:	00 00 00 
	stat->st_isdir = 0;
  802d34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d38:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d3f:	00 00 00 
	stat->st_dev = dev;
  802d42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d4a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d55:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d5d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d61:	48 89 ce             	mov    %rcx,%rsi
  802d64:	48 89 d7             	mov    %rdx,%rdi
  802d67:	ff d0                	callq  *%rax
}
  802d69:	c9                   	leaveq 
  802d6a:	c3                   	retq   

0000000000802d6b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d6b:	55                   	push   %rbp
  802d6c:	48 89 e5             	mov    %rsp,%rbp
  802d6f:	48 83 ec 20          	sub    $0x20,%rsp
  802d73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7f:	be 00 00 00 00       	mov    $0x0,%esi
  802d84:	48 89 c7             	mov    %rax,%rdi
  802d87:	48 b8 59 2e 80 00 00 	movabs $0x802e59,%rax
  802d8e:	00 00 00 
  802d91:	ff d0                	callq  *%rax
  802d93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9a:	79 05                	jns    802da1 <stat+0x36>
		return fd;
  802d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9f:	eb 2f                	jmp    802dd0 <stat+0x65>
	r = fstat(fd, stat);
  802da1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	48 89 d6             	mov    %rdx,%rsi
  802dab:	89 c7                	mov    %eax,%edi
  802dad:	48 b8 b2 2c 80 00 00 	movabs $0x802cb2,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
  802db9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbf:	89 c7                	mov    %eax,%edi
  802dc1:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
	return r;
  802dcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
  802dda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802de1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802de8:	00 00 00 
  802deb:	8b 00                	mov    (%rax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	75 1d                	jne    802e0e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802df1:	bf 01 00 00 00       	mov    $0x1,%edi
  802df6:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
  802e02:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e09:	00 00 00 
  802e0c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e0e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e15:	00 00 00 
  802e18:	8b 00                	mov    (%rax),%eax
  802e1a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e1d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e22:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e29:	00 00 00 
  802e2c:	89 c7                	mov    %eax,%edi
  802e2e:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  802e35:	00 00 00 
  802e38:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e43:	48 89 c6             	mov    %rax,%rsi
  802e46:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4b:	48 b8 81 22 80 00 00 	movabs $0x802281,%rax
  802e52:	00 00 00 
  802e55:	ff d0                	callq  *%rax
}
  802e57:	c9                   	leaveq 
  802e58:	c3                   	retq   

0000000000802e59 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e59:	55                   	push   %rbp
  802e5a:	48 89 e5             	mov    %rsp,%rbp
  802e5d:	48 83 ec 30          	sub    $0x30,%rsp
  802e61:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e65:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e68:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e6f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e7d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e82:	75 08                	jne    802e8c <open+0x33>
	{
		return r;
  802e84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e87:	e9 f2 00 00 00       	jmpq   802f7e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e90:	48 89 c7             	mov    %rax,%rdi
  802e93:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802e9a:	00 00 00 
  802e9d:	ff d0                	callq  *%rax
  802e9f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ea2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ea9:	7e 0a                	jle    802eb5 <open+0x5c>
	{
		return -E_BAD_PATH;
  802eab:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802eb0:	e9 c9 00 00 00       	jmpq   802f7e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802eb5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802ebc:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802ebd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ec1:	48 89 c7             	mov    %rax,%rdi
  802ec4:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
  802ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed7:	78 09                	js     802ee2 <open+0x89>
  802ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edd:	48 85 c0             	test   %rax,%rax
  802ee0:	75 08                	jne    802eea <open+0x91>
		{
			return r;
  802ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee5:	e9 94 00 00 00       	jmpq   802f7e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eee:	ba 00 04 00 00       	mov    $0x400,%edx
  802ef3:	48 89 c6             	mov    %rax,%rsi
  802ef6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802efd:	00 00 00 
  802f00:	48 b8 11 10 80 00 00 	movabs $0x801011,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f13:	00 00 00 
  802f16:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f19:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f23:	48 89 c6             	mov    %rax,%rsi
  802f26:	bf 01 00 00 00       	mov    $0x1,%edi
  802f2b:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
  802f37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3e:	79 2b                	jns    802f6b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f44:	be 00 00 00 00       	mov    $0x0,%esi
  802f49:	48 89 c7             	mov    %rax,%rdi
  802f4c:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
  802f58:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f5b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f5f:	79 05                	jns    802f66 <open+0x10d>
			{
				return d;
  802f61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f64:	eb 18                	jmp    802f7e <open+0x125>
			}
			return r;
  802f66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f69:	eb 13                	jmp    802f7e <open+0x125>
		}	
		return fd2num(fd_store);
  802f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6f:	48 89 c7             	mov    %rax,%rdi
  802f72:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f7e:	c9                   	leaveq 
  802f7f:	c3                   	retq   

0000000000802f80 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f80:	55                   	push   %rbp
  802f81:	48 89 e5             	mov    %rsp,%rbp
  802f84:	48 83 ec 10          	sub    $0x10,%rsp
  802f88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f90:	8b 50 0c             	mov    0xc(%rax),%edx
  802f93:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9a:	00 00 00 
  802f9d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f9f:	be 00 00 00 00       	mov    $0x0,%esi
  802fa4:	bf 06 00 00 00       	mov    $0x6,%edi
  802fa9:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
}
  802fb5:	c9                   	leaveq 
  802fb6:	c3                   	retq   

0000000000802fb7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fb7:	55                   	push   %rbp
  802fb8:	48 89 e5             	mov    %rsp,%rbp
  802fbb:	48 83 ec 30          	sub    $0x30,%rsp
  802fbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802fcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802fd2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fd7:	74 07                	je     802fe0 <devfile_read+0x29>
  802fd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fde:	75 07                	jne    802fe7 <devfile_read+0x30>
		return -E_INVAL;
  802fe0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fe5:	eb 77                	jmp    80305e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802feb:	8b 50 0c             	mov    0xc(%rax),%edx
  802fee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff5:	00 00 00 
  802ff8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ffa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803001:	00 00 00 
  803004:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803008:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80300c:	be 00 00 00 00       	mov    $0x0,%esi
  803011:	bf 03 00 00 00       	mov    $0x3,%edi
  803016:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
  803022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803029:	7f 05                	jg     803030 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302e:	eb 2e                	jmp    80305e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803030:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803033:	48 63 d0             	movslq %eax,%rdx
  803036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803041:	00 00 00 
  803044:	48 89 c7             	mov    %rax,%rdi
  803047:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803053:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803057:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80305b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 30          	sub    $0x30,%rsp
  803068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80306c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803070:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803074:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80307b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803080:	74 07                	je     803089 <devfile_write+0x29>
  803082:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803087:	75 08                	jne    803091 <devfile_write+0x31>
		return r;
  803089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308c:	e9 9a 00 00 00       	jmpq   80312b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803095:	8b 50 0c             	mov    0xc(%rax),%edx
  803098:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80309f:	00 00 00 
  8030a2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8030a4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030ab:	00 
  8030ac:	76 08                	jbe    8030b6 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8030ae:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030b5:	00 
	}
	fsipcbuf.write.req_n = n;
  8030b6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bd:	00 00 00 
  8030c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030c4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d0:	48 89 c6             	mov    %rax,%rsi
  8030d3:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030da:	00 00 00 
  8030dd:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030e9:	be 00 00 00 00       	mov    $0x0,%esi
  8030ee:	bf 04 00 00 00       	mov    $0x4,%edi
  8030f3:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803106:	7f 20                	jg     803128 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803108:	48 bf be 4e 80 00 00 	movabs $0x804ebe,%rdi
  80310f:	00 00 00 
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
  803117:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80311e:	00 00 00 
  803121:	ff d2                	callq  *%rdx
		return r;
  803123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803126:	eb 03                	jmp    80312b <devfile_write+0xcb>
	}
	return r;
  803128:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80312b:	c9                   	leaveq 
  80312c:	c3                   	retq   

000000000080312d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80312d:	55                   	push   %rbp
  80312e:	48 89 e5             	mov    %rsp,%rbp
  803131:	48 83 ec 20          	sub    $0x20,%rsp
  803135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80313d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803141:	8b 50 0c             	mov    0xc(%rax),%edx
  803144:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80314b:	00 00 00 
  80314e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803150:	be 00 00 00 00       	mov    $0x0,%esi
  803155:	bf 05 00 00 00       	mov    $0x5,%edi
  80315a:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316d:	79 05                	jns    803174 <devfile_stat+0x47>
		return r;
  80316f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803172:	eb 56                	jmp    8031ca <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803178:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80317f:	00 00 00 
  803182:	48 89 c7             	mov    %rax,%rdi
  803185:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803191:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803198:	00 00 00 
  80319b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b2:	00 00 00 
  8031b5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031bf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ca:	c9                   	leaveq 
  8031cb:	c3                   	retq   

00000000008031cc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031cc:	55                   	push   %rbp
  8031cd:	48 89 e5             	mov    %rsp,%rbp
  8031d0:	48 83 ec 10          	sub    $0x10,%rsp
  8031d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031d8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031df:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e9:	00 00 00 
  8031ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031ee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f5:	00 00 00 
  8031f8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031fb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031fe:	be 00 00 00 00       	mov    $0x0,%esi
  803203:	bf 02 00 00 00       	mov    $0x2,%edi
  803208:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
}
  803214:	c9                   	leaveq 
  803215:	c3                   	retq   

0000000000803216 <remove>:

// Delete a file
int
remove(const char *path)
{
  803216:	55                   	push   %rbp
  803217:	48 89 e5             	mov    %rsp,%rbp
  80321a:	48 83 ec 10          	sub    $0x10,%rsp
  80321e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803226:	48 89 c7             	mov    %rax,%rdi
  803229:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80323a:	7e 07                	jle    803243 <remove+0x2d>
		return -E_BAD_PATH;
  80323c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803241:	eb 33                	jmp    803276 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803247:	48 89 c6             	mov    %rax,%rsi
  80324a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803251:	00 00 00 
  803254:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803260:	be 00 00 00 00       	mov    $0x0,%esi
  803265:	bf 07 00 00 00       	mov    $0x7,%edi
  80326a:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
}
  803276:	c9                   	leaveq 
  803277:	c3                   	retq   

0000000000803278 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803278:	55                   	push   %rbp
  803279:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80327c:	be 00 00 00 00       	mov    $0x0,%esi
  803281:	bf 08 00 00 00       	mov    $0x8,%edi
  803286:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
}
  803292:	5d                   	pop    %rbp
  803293:	c3                   	retq   

0000000000803294 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803294:	55                   	push   %rbp
  803295:	48 89 e5             	mov    %rsp,%rbp
  803298:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80329f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032a6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032ad:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032b4:	be 00 00 00 00       	mov    $0x0,%esi
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 59 2e 80 00 00 	movabs $0x802e59,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
  8032c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cf:	79 28                	jns    8032f9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d4:	89 c6                	mov    %eax,%esi
  8032d6:	48 bf da 4e 80 00 00 	movabs $0x804eda,%rdi
  8032dd:	00 00 00 
  8032e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e5:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  8032ec:	00 00 00 
  8032ef:	ff d2                	callq  *%rdx
		return fd_src;
  8032f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f4:	e9 74 01 00 00       	jmpq   80346d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032f9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803300:	be 01 01 00 00       	mov    $0x101,%esi
  803305:	48 89 c7             	mov    %rax,%rdi
  803308:	48 b8 59 2e 80 00 00 	movabs $0x802e59,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
  803314:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803317:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80331b:	79 39                	jns    803356 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80331d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803320:	89 c6                	mov    %eax,%esi
  803322:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  803329:	00 00 00 
  80332c:	b8 00 00 00 00       	mov    $0x0,%eax
  803331:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  803338:	00 00 00 
  80333b:	ff d2                	callq  *%rdx
		close(fd_src);
  80333d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803340:	89 c7                	mov    %eax,%edi
  803342:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
		return fd_dest;
  80334e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803351:	e9 17 01 00 00       	jmpq   80346d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803356:	eb 74                	jmp    8033cc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803358:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80335b:	48 63 d0             	movslq %eax,%rdx
  80335e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803365:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803368:	48 89 ce             	mov    %rcx,%rsi
  80336b:	89 c7                	mov    %eax,%edi
  80336d:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80337c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803380:	79 4a                	jns    8033cc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803382:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803385:	89 c6                	mov    %eax,%esi
  803387:	48 bf 0a 4f 80 00 00 	movabs $0x804f0a,%rdi
  80338e:	00 00 00 
  803391:	b8 00 00 00 00       	mov    $0x0,%eax
  803396:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80339d:	00 00 00 
  8033a0:	ff d2                	callq  *%rdx
			close(fd_src);
  8033a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a5:	89 c7                	mov    %eax,%edi
  8033a7:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
			close(fd_dest);
  8033b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b6:	89 c7                	mov    %eax,%edi
  8033b8:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
			return write_size;
  8033c4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033c7:	e9 a1 00 00 00       	jmpq   80346d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033cc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	ba 00 02 00 00       	mov    $0x200,%edx
  8033db:	48 89 ce             	mov    %rcx,%rsi
  8033de:	89 c7                	mov    %eax,%edi
  8033e0:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033f3:	0f 8f 5f ff ff ff    	jg     803358 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033fd:	79 47                	jns    803446 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803402:	89 c6                	mov    %eax,%esi
  803404:	48 bf 1d 4f 80 00 00 	movabs $0x804f1d,%rdi
  80340b:	00 00 00 
  80340e:	b8 00 00 00 00       	mov    $0x0,%eax
  803413:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80341a:	00 00 00 
  80341d:	ff d2                	callq  *%rdx
		close(fd_src);
  80341f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803422:	89 c7                	mov    %eax,%edi
  803424:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	callq  *%rax
		close(fd_dest);
  803430:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803433:	89 c7                	mov    %eax,%edi
  803435:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
		return read_size;
  803441:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803444:	eb 27                	jmp    80346d <copy+0x1d9>
	}
	close(fd_src);
  803446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803449:	89 c7                	mov    %eax,%edi
  80344b:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
	close(fd_dest);
  803457:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80345a:	89 c7                	mov    %eax,%edi
  80345c:	48 b8 61 27 80 00 00 	movabs $0x802761,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
	return 0;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80346d:	c9                   	leaveq 
  80346e:	c3                   	retq   

000000000080346f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80346f:	55                   	push   %rbp
  803470:	48 89 e5             	mov    %rsp,%rbp
  803473:	48 83 ec 20          	sub    $0x20,%rsp
  803477:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80347a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80347e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803481:	48 89 d6             	mov    %rdx,%rsi
  803484:	89 c7                	mov    %eax,%edi
  803486:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
  803492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803499:	79 05                	jns    8034a0 <fd2sockid+0x31>
		return r;
  80349b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349e:	eb 24                	jmp    8034c4 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a4:	8b 10                	mov    (%rax),%edx
  8034a6:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8034ad:	00 00 00 
  8034b0:	8b 00                	mov    (%rax),%eax
  8034b2:	39 c2                	cmp    %eax,%edx
  8034b4:	74 07                	je     8034bd <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034b6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034bb:	eb 07                	jmp    8034c4 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c1:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034c4:	c9                   	leaveq 
  8034c5:	c3                   	retq   

00000000008034c6 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034c6:	55                   	push   %rbp
  8034c7:	48 89 e5             	mov    %rsp,%rbp
  8034ca:	48 83 ec 20          	sub    $0x20,%rsp
  8034ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034d1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034d5:	48 89 c7             	mov    %rax,%rdi
  8034d8:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  8034df:	00 00 00 
  8034e2:	ff d0                	callq  *%rax
  8034e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034eb:	78 26                	js     803513 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8034f6:	48 89 c6             	mov    %rax,%rsi
  8034f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034fe:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803505:	00 00 00 
  803508:	ff d0                	callq  *%rax
  80350a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803511:	79 16                	jns    803529 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803513:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 d3 39 80 00 00 	movabs $0x8039d3,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
		return r;
  803524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803527:	eb 3a                	jmp    803563 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803534:	00 00 00 
  803537:	8b 12                	mov    (%rdx),%edx
  803539:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80353b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80354d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803550:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803554:	48 89 c7             	mov    %rax,%rdi
  803557:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  80355e:	00 00 00 
  803561:	ff d0                	callq  *%rax
}
  803563:	c9                   	leaveq 
  803564:	c3                   	retq   

0000000000803565 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803565:	55                   	push   %rbp
  803566:	48 89 e5             	mov    %rsp,%rbp
  803569:	48 83 ec 30          	sub    $0x30,%rsp
  80356d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803570:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803574:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803578:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357b:	89 c7                	mov    %eax,%edi
  80357d:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803590:	79 05                	jns    803597 <accept+0x32>
		return r;
  803592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803595:	eb 3b                	jmp    8035d2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803597:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80359b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a2:	48 89 ce             	mov    %rcx,%rsi
  8035a5:	89 c7                	mov    %eax,%edi
  8035a7:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ba:	79 05                	jns    8035c1 <accept+0x5c>
		return r;
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bf:	eb 11                	jmp    8035d2 <accept+0x6d>
	return alloc_sockfd(r);
  8035c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c4:	89 c7                	mov    %eax,%edi
  8035c6:	48 b8 c6 34 80 00 00 	movabs $0x8034c6,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 20          	sub    $0x20,%rsp
  8035dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e9:	89 c7                	mov    %eax,%edi
  8035eb:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
  8035f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fe:	79 05                	jns    803605 <bind+0x31>
		return r;
  803600:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803603:	eb 1b                	jmp    803620 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803605:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803608:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80360c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360f:	48 89 ce             	mov    %rcx,%rsi
  803612:	89 c7                	mov    %eax,%edi
  803614:	48 b8 2f 39 80 00 00 	movabs $0x80392f,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
}
  803620:	c9                   	leaveq 
  803621:	c3                   	retq   

0000000000803622 <shutdown>:

int
shutdown(int s, int how)
{
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	48 83 ec 20          	sub    $0x20,%rsp
  80362a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80362d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803630:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803633:	89 c7                	mov    %eax,%edi
  803635:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
  803641:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803644:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803648:	79 05                	jns    80364f <shutdown+0x2d>
		return r;
  80364a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364d:	eb 16                	jmp    803665 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80364f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803655:	89 d6                	mov    %edx,%esi
  803657:	89 c7                	mov    %eax,%edi
  803659:	48 b8 93 39 80 00 00 	movabs $0x803993,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
}
  803665:	c9                   	leaveq 
  803666:	c3                   	retq   

0000000000803667 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803667:	55                   	push   %rbp
  803668:	48 89 e5             	mov    %rsp,%rbp
  80366b:	48 83 ec 10          	sub    $0x10,%rsp
  80366f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803677:	48 89 c7             	mov    %rax,%rdi
  80367a:	48 b8 4b 47 80 00 00 	movabs $0x80474b,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
  803686:	83 f8 01             	cmp    $0x1,%eax
  803689:	75 17                	jne    8036a2 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80368b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368f:	8b 40 0c             	mov    0xc(%rax),%eax
  803692:	89 c7                	mov    %eax,%edi
  803694:	48 b8 d3 39 80 00 00 	movabs $0x8039d3,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
  8036a0:	eb 05                	jmp    8036a7 <devsock_close+0x40>
	else
		return 0;
  8036a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
  8036ad:	48 83 ec 20          	sub    $0x20,%rsp
  8036b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036b8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036be:	89 c7                	mov    %eax,%edi
  8036c0:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
  8036cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d3:	79 05                	jns    8036da <connect+0x31>
		return r;
  8036d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d8:	eb 1b                	jmp    8036f5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036dd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e4:	48 89 ce             	mov    %rcx,%rsi
  8036e7:	89 c7                	mov    %eax,%edi
  8036e9:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
}
  8036f5:	c9                   	leaveq 
  8036f6:	c3                   	retq   

00000000008036f7 <listen>:

int
listen(int s, int backlog)
{
  8036f7:	55                   	push   %rbp
  8036f8:	48 89 e5             	mov    %rsp,%rbp
  8036fb:	48 83 ec 20          	sub    $0x20,%rsp
  8036ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803702:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803705:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803708:	89 c7                	mov    %eax,%edi
  80370a:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
  803716:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371d:	79 05                	jns    803724 <listen+0x2d>
		return r;
  80371f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803722:	eb 16                	jmp    80373a <listen+0x43>
	return nsipc_listen(r, backlog);
  803724:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372a:	89 d6                	mov    %edx,%esi
  80372c:	89 c7                	mov    %eax,%edi
  80372e:	48 b8 64 3a 80 00 00 	movabs $0x803a64,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
}
  80373a:	c9                   	leaveq 
  80373b:	c3                   	retq   

000000000080373c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80373c:	55                   	push   %rbp
  80373d:	48 89 e5             	mov    %rsp,%rbp
  803740:	48 83 ec 20          	sub    $0x20,%rsp
  803744:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803748:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80374c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803754:	89 c2                	mov    %eax,%edx
  803756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375a:	8b 40 0c             	mov    0xc(%rax),%eax
  80375d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803761:	b9 00 00 00 00       	mov    $0x0,%ecx
  803766:	89 c7                	mov    %eax,%edi
  803768:	48 b8 a4 3a 80 00 00 	movabs $0x803aa4,%rax
  80376f:	00 00 00 
  803772:	ff d0                	callq  *%rax
}
  803774:	c9                   	leaveq 
  803775:	c3                   	retq   

0000000000803776 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 20          	sub    $0x20,%rsp
  80377e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803782:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803786:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80378a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378e:	89 c2                	mov    %eax,%edx
  803790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803794:	8b 40 0c             	mov    0xc(%rax),%eax
  803797:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80379b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037a0:	89 c7                	mov    %eax,%edi
  8037a2:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
}
  8037ae:	c9                   	leaveq 
  8037af:	c3                   	retq   

00000000008037b0 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037b0:	55                   	push   %rbp
  8037b1:	48 89 e5             	mov    %rsp,%rbp
  8037b4:	48 83 ec 10          	sub    $0x10,%rsp
  8037b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c4:	48 be 38 4f 80 00 00 	movabs $0x804f38,%rsi
  8037cb:	00 00 00 
  8037ce:	48 89 c7             	mov    %rax,%rdi
  8037d1:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8037d8:	00 00 00 
  8037db:	ff d0                	callq  *%rax
	return 0;
  8037dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e2:	c9                   	leaveq 
  8037e3:	c3                   	retq   

00000000008037e4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8037e4:	55                   	push   %rbp
  8037e5:	48 89 e5             	mov    %rsp,%rbp
  8037e8:	48 83 ec 20          	sub    $0x20,%rsp
  8037ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ef:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037f2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037f5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037f8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fe:	89 ce                	mov    %ecx,%esi
  803800:	89 c7                	mov    %eax,%edi
  803802:	48 b8 28 3c 80 00 00 	movabs $0x803c28,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
  80380e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803815:	79 05                	jns    80381c <socket+0x38>
		return r;
  803817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381a:	eb 11                	jmp    80382d <socket+0x49>
	return alloc_sockfd(r);
  80381c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381f:	89 c7                	mov    %eax,%edi
  803821:	48 b8 c6 34 80 00 00 	movabs $0x8034c6,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
}
  80382d:	c9                   	leaveq 
  80382e:	c3                   	retq   

000000000080382f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80382f:	55                   	push   %rbp
  803830:	48 89 e5             	mov    %rsp,%rbp
  803833:	48 83 ec 10          	sub    $0x10,%rsp
  803837:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80383a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803841:	00 00 00 
  803844:	8b 00                	mov    (%rax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	75 1d                	jne    803867 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80384a:	bf 02 00 00 00       	mov    $0x2,%edi
  80384f:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
  80385b:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803862:	00 00 00 
  803865:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803867:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80386e:	00 00 00 
  803871:	8b 00                	mov    (%rax),%eax
  803873:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803876:	b9 07 00 00 00       	mov    $0x7,%ecx
  80387b:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803882:	00 00 00 
  803885:	89 c7                	mov    %eax,%edi
  803887:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803893:	ba 00 00 00 00       	mov    $0x0,%edx
  803898:	be 00 00 00 00       	mov    $0x0,%esi
  80389d:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a2:	48 b8 81 22 80 00 00 	movabs $0x802281,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
}
  8038ae:	c9                   	leaveq 
  8038af:	c3                   	retq   

00000000008038b0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 30          	sub    $0x30,%rsp
  8038b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038c3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ca:	00 00 00 
  8038cd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038d0:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038d2:	bf 01 00 00 00       	mov    $0x1,%edi
  8038d7:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  8038de:	00 00 00 
  8038e1:	ff d0                	callq  *%rax
  8038e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ea:	78 3e                	js     80392a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8038ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f3:	00 00 00 
  8038f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8038fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fe:	8b 40 10             	mov    0x10(%rax),%eax
  803901:	89 c2                	mov    %eax,%edx
  803903:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803907:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390b:	48 89 ce             	mov    %rcx,%rsi
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80391d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803921:	8b 50 10             	mov    0x10(%rax),%edx
  803924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803928:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80392a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80392d:	c9                   	leaveq 
  80392e:	c3                   	retq   

000000000080392f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80392f:	55                   	push   %rbp
  803930:	48 89 e5             	mov    %rsp,%rbp
  803933:	48 83 ec 10          	sub    $0x10,%rsp
  803937:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80393a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80393e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803941:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803948:	00 00 00 
  80394b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803950:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803957:	48 89 c6             	mov    %rax,%rsi
  80395a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803961:	00 00 00 
  803964:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803970:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803977:	00 00 00 
  80397a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80397d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803980:	bf 02 00 00 00       	mov    $0x2,%edi
  803985:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
}
  803991:	c9                   	leaveq 
  803992:	c3                   	retq   

0000000000803993 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803993:	55                   	push   %rbp
  803994:	48 89 e5             	mov    %rsp,%rbp
  803997:	48 83 ec 10          	sub    $0x10,%rsp
  80399b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80399e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a8:	00 00 00 
  8039ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ae:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b7:	00 00 00 
  8039ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039c0:	bf 03 00 00 00       	mov    $0x3,%edi
  8039c5:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
}
  8039d1:	c9                   	leaveq 
  8039d2:	c3                   	retq   

00000000008039d3 <nsipc_close>:

int
nsipc_close(int s)
{
  8039d3:	55                   	push   %rbp
  8039d4:	48 89 e5             	mov    %rsp,%rbp
  8039d7:	48 83 ec 10          	sub    $0x10,%rsp
  8039db:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8039de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e5:	00 00 00 
  8039e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039eb:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8039ed:	bf 04 00 00 00       	mov    $0x4,%edi
  8039f2:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
}
  8039fe:	c9                   	leaveq 
  8039ff:	c3                   	retq   

0000000000803a00 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a00:	55                   	push   %rbp
  803a01:	48 89 e5             	mov    %rsp,%rbp
  803a04:	48 83 ec 10          	sub    $0x10,%rsp
  803a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a12:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a19:	00 00 00 
  803a1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a21:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a28:	48 89 c6             	mov    %rax,%rsi
  803a2b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a32:	00 00 00 
  803a35:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a41:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a48:	00 00 00 
  803a4b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a4e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a51:	bf 05 00 00 00       	mov    $0x5,%edi
  803a56:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  803a5d:	00 00 00 
  803a60:	ff d0                	callq  *%rax
}
  803a62:	c9                   	leaveq 
  803a63:	c3                   	retq   

0000000000803a64 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a64:	55                   	push   %rbp
  803a65:	48 89 e5             	mov    %rsp,%rbp
  803a68:	48 83 ec 10          	sub    $0x10,%rsp
  803a6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a6f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a72:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a79:	00 00 00 
  803a7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a81:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a88:	00 00 00 
  803a8b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a8e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a91:	bf 06 00 00 00       	mov    $0x6,%edi
  803a96:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
}
  803aa2:	c9                   	leaveq 
  803aa3:	c3                   	retq   

0000000000803aa4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803aa4:	55                   	push   %rbp
  803aa5:	48 89 e5             	mov    %rsp,%rbp
  803aa8:	48 83 ec 30          	sub    $0x30,%rsp
  803aac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aaf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ab3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803ab6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ab9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac0:	00 00 00 
  803ac3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ac6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ac8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803acf:	00 00 00 
  803ad2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ad5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ad8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803adf:	00 00 00 
  803ae2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ae5:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ae8:	bf 07 00 00 00       	mov    $0x7,%edi
  803aed:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
  803af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b00:	78 69                	js     803b6b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b02:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b09:	7f 08                	jg     803b13 <nsipc_recv+0x6f>
  803b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b11:	7e 35                	jle    803b48 <nsipc_recv+0xa4>
  803b13:	48 b9 3f 4f 80 00 00 	movabs $0x804f3f,%rcx
  803b1a:	00 00 00 
  803b1d:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803b24:	00 00 00 
  803b27:	be 61 00 00 00       	mov    $0x61,%esi
  803b2c:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803b33:	00 00 00 
  803b36:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3b:	49 b8 f7 44 80 00 00 	movabs $0x8044f7,%r8
  803b42:	00 00 00 
  803b45:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4b:	48 63 d0             	movslq %eax,%rdx
  803b4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b52:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b59:	00 00 00 
  803b5c:	48 89 c7             	mov    %rax,%rdi
  803b5f:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
	}

	return r;
  803b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b6e:	c9                   	leaveq 
  803b6f:	c3                   	retq   

0000000000803b70 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b70:	55                   	push   %rbp
  803b71:	48 89 e5             	mov    %rsp,%rbp
  803b74:	48 83 ec 20          	sub    $0x20,%rsp
  803b78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b82:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b85:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b8c:	00 00 00 
  803b8f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b92:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b94:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b9b:	7e 35                	jle    803bd2 <nsipc_send+0x62>
  803b9d:	48 b9 75 4f 80 00 00 	movabs $0x804f75,%rcx
  803ba4:	00 00 00 
  803ba7:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803bae:	00 00 00 
  803bb1:	be 6c 00 00 00       	mov    $0x6c,%esi
  803bb6:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803bbd:	00 00 00 
  803bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc5:	49 b8 f7 44 80 00 00 	movabs $0x8044f7,%r8
  803bcc:	00 00 00 
  803bcf:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd5:	48 63 d0             	movslq %eax,%rdx
  803bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdc:	48 89 c6             	mov    %rax,%rsi
  803bdf:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803be6:	00 00 00 
  803be9:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803bf0:	00 00 00 
  803bf3:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803bf5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bfc:	00 00 00 
  803bff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c02:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c05:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c0c:	00 00 00 
  803c0f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c12:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c15:	bf 08 00 00 00       	mov    $0x8,%edi
  803c1a:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 10          	sub    $0x10,%rsp
  803c30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c33:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c36:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c40:	00 00 00 
  803c43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c46:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c48:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c4f:	00 00 00 
  803c52:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c55:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c58:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c5f:	00 00 00 
  803c62:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c65:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c68:	bf 09 00 00 00       	mov    $0x9,%edi
  803c6d:	48 b8 2f 38 80 00 00 	movabs $0x80382f,%rax
  803c74:	00 00 00 
  803c77:	ff d0                	callq  *%rax
}
  803c79:	c9                   	leaveq 
  803c7a:	c3                   	retq   

0000000000803c7b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c7b:	55                   	push   %rbp
  803c7c:	48 89 e5             	mov    %rsp,%rbp
  803c7f:	53                   	push   %rbx
  803c80:	48 83 ec 38          	sub    $0x38,%rsp
  803c84:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c88:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c8c:	48 89 c7             	mov    %rax,%rdi
  803c8f:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
  803c9b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ca2:	0f 88 bf 01 00 00    	js     803e67 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cac:	ba 07 04 00 00       	mov    $0x407,%edx
  803cb1:	48 89 c6             	mov    %rax,%rsi
  803cb4:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb9:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803cc0:	00 00 00 
  803cc3:	ff d0                	callq  *%rax
  803cc5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ccc:	0f 88 95 01 00 00    	js     803e67 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cd2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cd6:	48 89 c7             	mov    %rax,%rdi
  803cd9:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  803ce0:	00 00 00 
  803ce3:	ff d0                	callq  *%rax
  803ce5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ce8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cec:	0f 88 5d 01 00 00    	js     803e4f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf6:	ba 07 04 00 00       	mov    $0x407,%edx
  803cfb:	48 89 c6             	mov    %rax,%rsi
  803cfe:	bf 00 00 00 00       	mov    $0x0,%edi
  803d03:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803d0a:	00 00 00 
  803d0d:	ff d0                	callq  *%rax
  803d0f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d12:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d16:	0f 88 33 01 00 00    	js     803e4f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d20:	48 89 c7             	mov    %rax,%rdi
  803d23:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
  803d2f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d37:	ba 07 04 00 00       	mov    $0x407,%edx
  803d3c:	48 89 c6             	mov    %rax,%rsi
  803d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d44:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803d4b:	00 00 00 
  803d4e:	ff d0                	callq  *%rax
  803d50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d57:	79 05                	jns    803d5e <pipe+0xe3>
		goto err2;
  803d59:	e9 d9 00 00 00       	jmpq   803e37 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d62:	48 89 c7             	mov    %rax,%rdi
  803d65:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  803d6c:	00 00 00 
  803d6f:	ff d0                	callq  *%rax
  803d71:	48 89 c2             	mov    %rax,%rdx
  803d74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d78:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d7e:	48 89 d1             	mov    %rdx,%rcx
  803d81:	ba 00 00 00 00       	mov    $0x0,%edx
  803d86:	48 89 c6             	mov    %rax,%rsi
  803d89:	bf 00 00 00 00       	mov    $0x0,%edi
  803d8e:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  803d95:	00 00 00 
  803d98:	ff d0                	callq  *%rax
  803d9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803da1:	79 1b                	jns    803dbe <pipe+0x143>
		goto err3;
  803da3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803da4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da8:	48 89 c6             	mov    %rax,%rsi
  803dab:	bf 00 00 00 00       	mov    $0x0,%edi
  803db0:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803db7:	00 00 00 
  803dba:	ff d0                	callq  *%rax
  803dbc:	eb 79                	jmp    803e37 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803dc9:	00 00 00 
  803dcc:	8b 12                	mov    (%rdx),%edx
  803dce:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803dd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ddb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ddf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803de6:	00 00 00 
  803de9:	8b 12                	mov    (%rdx),%edx
  803deb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ded:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803df8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfc:	48 89 c7             	mov    %rax,%rdi
  803dff:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  803e06:	00 00 00 
  803e09:	ff d0                	callq  *%rax
  803e0b:	89 c2                	mov    %eax,%edx
  803e0d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e11:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e17:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1f:	48 89 c7             	mov    %rax,%rdi
  803e22:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
  803e2e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e30:	b8 00 00 00 00       	mov    $0x0,%eax
  803e35:	eb 33                	jmp    803e6a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3b:	48 89 c6             	mov    %rax,%rsi
  803e3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e43:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803e4a:	00 00 00 
  803e4d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e53:	48 89 c6             	mov    %rax,%rsi
  803e56:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5b:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
err:
	return r;
  803e67:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e6a:	48 83 c4 38          	add    $0x38,%rsp
  803e6e:	5b                   	pop    %rbx
  803e6f:	5d                   	pop    %rbp
  803e70:	c3                   	retq   

0000000000803e71 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e71:	55                   	push   %rbp
  803e72:	48 89 e5             	mov    %rsp,%rbp
  803e75:	53                   	push   %rbx
  803e76:	48 83 ec 28          	sub    $0x28,%rsp
  803e7a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e7e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e82:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803e89:	00 00 00 
  803e8c:	48 8b 00             	mov    (%rax),%rax
  803e8f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e95:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9c:	48 89 c7             	mov    %rax,%rdi
  803e9f:	48 b8 4b 47 80 00 00 	movabs $0x80474b,%rax
  803ea6:	00 00 00 
  803ea9:	ff d0                	callq  *%rax
  803eab:	89 c3                	mov    %eax,%ebx
  803ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb1:	48 89 c7             	mov    %rax,%rdi
  803eb4:	48 b8 4b 47 80 00 00 	movabs $0x80474b,%rax
  803ebb:	00 00 00 
  803ebe:	ff d0                	callq  *%rax
  803ec0:	39 c3                	cmp    %eax,%ebx
  803ec2:	0f 94 c0             	sete   %al
  803ec5:	0f b6 c0             	movzbl %al,%eax
  803ec8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ecb:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803ed2:	00 00 00 
  803ed5:	48 8b 00             	mov    (%rax),%rax
  803ed8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ede:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ee1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ee4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ee7:	75 05                	jne    803eee <_pipeisclosed+0x7d>
			return ret;
  803ee9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803eec:	eb 4f                	jmp    803f3d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803eee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ef4:	74 42                	je     803f38 <_pipeisclosed+0xc7>
  803ef6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803efa:	75 3c                	jne    803f38 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803efc:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803f03:	00 00 00 
  803f06:	48 8b 00             	mov    (%rax),%rax
  803f09:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f0f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f15:	89 c6                	mov    %eax,%esi
  803f17:	48 bf 86 4f 80 00 00 	movabs $0x804f86,%rdi
  803f1e:	00 00 00 
  803f21:	b8 00 00 00 00       	mov    $0x0,%eax
  803f26:	49 b8 ca 03 80 00 00 	movabs $0x8003ca,%r8
  803f2d:	00 00 00 
  803f30:	41 ff d0             	callq  *%r8
	}
  803f33:	e9 4a ff ff ff       	jmpq   803e82 <_pipeisclosed+0x11>
  803f38:	e9 45 ff ff ff       	jmpq   803e82 <_pipeisclosed+0x11>
}
  803f3d:	48 83 c4 28          	add    $0x28,%rsp
  803f41:	5b                   	pop    %rbx
  803f42:	5d                   	pop    %rbp
  803f43:	c3                   	retq   

0000000000803f44 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f44:	55                   	push   %rbp
  803f45:	48 89 e5             	mov    %rsp,%rbp
  803f48:	48 83 ec 30          	sub    $0x30,%rsp
  803f4c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f4f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f56:	48 89 d6             	mov    %rdx,%rsi
  803f59:	89 c7                	mov    %eax,%edi
  803f5b:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  803f62:	00 00 00 
  803f65:	ff d0                	callq  *%rax
  803f67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6e:	79 05                	jns    803f75 <pipeisclosed+0x31>
		return r;
  803f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f73:	eb 31                	jmp    803fa6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f79:	48 89 c7             	mov    %rax,%rdi
  803f7c:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  803f83:	00 00 00 
  803f86:	ff d0                	callq  *%rax
  803f88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f94:	48 89 d6             	mov    %rdx,%rsi
  803f97:	48 89 c7             	mov    %rax,%rdi
  803f9a:	48 b8 71 3e 80 00 00 	movabs $0x803e71,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
}
  803fa6:	c9                   	leaveq 
  803fa7:	c3                   	retq   

0000000000803fa8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fa8:	55                   	push   %rbp
  803fa9:	48 89 e5             	mov    %rsp,%rbp
  803fac:	48 83 ec 40          	sub    $0x40,%rsp
  803fb0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fb4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fb8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc0:	48 89 c7             	mov    %rax,%rdi
  803fc3:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  803fca:	00 00 00 
  803fcd:	ff d0                	callq  *%rax
  803fcf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fdb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fe2:	00 
  803fe3:	e9 92 00 00 00       	jmpq   80407a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803fe8:	eb 41                	jmp    80402b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803fea:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fef:	74 09                	je     803ffa <devpipe_read+0x52>
				return i;
  803ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff5:	e9 92 00 00 00       	jmpq   80408c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ffa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804002:	48 89 d6             	mov    %rdx,%rsi
  804005:	48 89 c7             	mov    %rax,%rdi
  804008:	48 b8 71 3e 80 00 00 	movabs $0x803e71,%rax
  80400f:	00 00 00 
  804012:	ff d0                	callq  *%rax
  804014:	85 c0                	test   %eax,%eax
  804016:	74 07                	je     80401f <devpipe_read+0x77>
				return 0;
  804018:	b8 00 00 00 00       	mov    $0x0,%eax
  80401d:	eb 6d                	jmp    80408c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80401f:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  804026:	00 00 00 
  804029:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80402b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402f:	8b 10                	mov    (%rax),%edx
  804031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804035:	8b 40 04             	mov    0x4(%rax),%eax
  804038:	39 c2                	cmp    %eax,%edx
  80403a:	74 ae                	je     803fea <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80403c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804040:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804044:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404c:	8b 00                	mov    (%rax),%eax
  80404e:	99                   	cltd   
  80404f:	c1 ea 1b             	shr    $0x1b,%edx
  804052:	01 d0                	add    %edx,%eax
  804054:	83 e0 1f             	and    $0x1f,%eax
  804057:	29 d0                	sub    %edx,%eax
  804059:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405d:	48 98                	cltq   
  80405f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804064:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804066:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406a:	8b 00                	mov    (%rax),%eax
  80406c:	8d 50 01             	lea    0x1(%rax),%edx
  80406f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804073:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804075:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80407a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80407e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804082:	0f 82 60 ff ff ff    	jb     803fe8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80408c:	c9                   	leaveq 
  80408d:	c3                   	retq   

000000000080408e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80408e:	55                   	push   %rbp
  80408f:	48 89 e5             	mov    %rsp,%rbp
  804092:	48 83 ec 40          	sub    $0x40,%rsp
  804096:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80409a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80409e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a6:	48 89 c7             	mov    %rax,%rdi
  8040a9:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  8040b0:	00 00 00 
  8040b3:	ff d0                	callq  *%rax
  8040b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040c8:	00 
  8040c9:	e9 8e 00 00 00       	jmpq   80415c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040ce:	eb 31                	jmp    804101 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d8:	48 89 d6             	mov    %rdx,%rsi
  8040db:	48 89 c7             	mov    %rax,%rdi
  8040de:	48 b8 71 3e 80 00 00 	movabs $0x803e71,%rax
  8040e5:	00 00 00 
  8040e8:	ff d0                	callq  *%rax
  8040ea:	85 c0                	test   %eax,%eax
  8040ec:	74 07                	je     8040f5 <devpipe_write+0x67>
				return 0;
  8040ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f3:	eb 79                	jmp    80416e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040f5:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804105:	8b 40 04             	mov    0x4(%rax),%eax
  804108:	48 63 d0             	movslq %eax,%rdx
  80410b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410f:	8b 00                	mov    (%rax),%eax
  804111:	48 98                	cltq   
  804113:	48 83 c0 20          	add    $0x20,%rax
  804117:	48 39 c2             	cmp    %rax,%rdx
  80411a:	73 b4                	jae    8040d0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80411c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804120:	8b 40 04             	mov    0x4(%rax),%eax
  804123:	99                   	cltd   
  804124:	c1 ea 1b             	shr    $0x1b,%edx
  804127:	01 d0                	add    %edx,%eax
  804129:	83 e0 1f             	and    $0x1f,%eax
  80412c:	29 d0                	sub    %edx,%eax
  80412e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804132:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804136:	48 01 ca             	add    %rcx,%rdx
  804139:	0f b6 0a             	movzbl (%rdx),%ecx
  80413c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804140:	48 98                	cltq   
  804142:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414a:	8b 40 04             	mov    0x4(%rax),%eax
  80414d:	8d 50 01             	lea    0x1(%rax),%edx
  804150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804154:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804157:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80415c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804160:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804164:	0f 82 64 ff ff ff    	jb     8040ce <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80416a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80416e:	c9                   	leaveq 
  80416f:	c3                   	retq   

0000000000804170 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804170:	55                   	push   %rbp
  804171:	48 89 e5             	mov    %rsp,%rbp
  804174:	48 83 ec 20          	sub    $0x20,%rsp
  804178:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80417c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804184:	48 89 c7             	mov    %rax,%rdi
  804187:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  80418e:	00 00 00 
  804191:	ff d0                	callq  *%rax
  804193:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80419b:	48 be 99 4f 80 00 00 	movabs $0x804f99,%rsi
  8041a2:	00 00 00 
  8041a5:	48 89 c7             	mov    %rax,%rdi
  8041a8:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8041af:	00 00 00 
  8041b2:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b8:	8b 50 04             	mov    0x4(%rax),%edx
  8041bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bf:	8b 00                	mov    (%rax),%eax
  8041c1:	29 c2                	sub    %eax,%edx
  8041c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041d1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041d8:	00 00 00 
	stat->st_dev = &devpipe;
  8041db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041df:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8041e6:	00 00 00 
  8041e9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8041f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041f5:	c9                   	leaveq 
  8041f6:	c3                   	retq   

00000000008041f7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041f7:	55                   	push   %rbp
  8041f8:	48 89 e5             	mov    %rsp,%rbp
  8041fb:	48 83 ec 10          	sub    $0x10,%rsp
  8041ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804207:	48 89 c6             	mov    %rax,%rsi
  80420a:	bf 00 00 00 00       	mov    $0x0,%edi
  80420f:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  804216:	00 00 00 
  804219:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80421b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421f:	48 89 c7             	mov    %rax,%rdi
  804222:	48 b8 8e 24 80 00 00 	movabs $0x80248e,%rax
  804229:	00 00 00 
  80422c:	ff d0                	callq  *%rax
  80422e:	48 89 c6             	mov    %rax,%rsi
  804231:	bf 00 00 00 00       	mov    $0x0,%edi
  804236:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
}
  804242:	c9                   	leaveq 
  804243:	c3                   	retq   

0000000000804244 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804244:	55                   	push   %rbp
  804245:	48 89 e5             	mov    %rsp,%rbp
  804248:	48 83 ec 20          	sub    $0x20,%rsp
  80424c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80424f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804252:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804255:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804259:	be 01 00 00 00       	mov    $0x1,%esi
  80425e:	48 89 c7             	mov    %rax,%rdi
  804261:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  804268:	00 00 00 
  80426b:	ff d0                	callq  *%rax
}
  80426d:	c9                   	leaveq 
  80426e:	c3                   	retq   

000000000080426f <getchar>:

int
getchar(void)
{
  80426f:	55                   	push   %rbp
  804270:	48 89 e5             	mov    %rsp,%rbp
  804273:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804277:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80427b:	ba 01 00 00 00       	mov    $0x1,%edx
  804280:	48 89 c6             	mov    %rax,%rsi
  804283:	bf 00 00 00 00       	mov    $0x0,%edi
  804288:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  80428f:	00 00 00 
  804292:	ff d0                	callq  *%rax
  804294:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80429b:	79 05                	jns    8042a2 <getchar+0x33>
		return r;
  80429d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a0:	eb 14                	jmp    8042b6 <getchar+0x47>
	if (r < 1)
  8042a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a6:	7f 07                	jg     8042af <getchar+0x40>
		return -E_EOF;
  8042a8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042ad:	eb 07                	jmp    8042b6 <getchar+0x47>
	return c;
  8042af:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042b3:	0f b6 c0             	movzbl %al,%eax
}
  8042b6:	c9                   	leaveq 
  8042b7:	c3                   	retq   

00000000008042b8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042b8:	55                   	push   %rbp
  8042b9:	48 89 e5             	mov    %rsp,%rbp
  8042bc:	48 83 ec 20          	sub    $0x20,%rsp
  8042c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ca:	48 89 d6             	mov    %rdx,%rsi
  8042cd:	89 c7                	mov    %eax,%edi
  8042cf:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  8042d6:	00 00 00 
  8042d9:	ff d0                	callq  *%rax
  8042db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e2:	79 05                	jns    8042e9 <iscons+0x31>
		return r;
  8042e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e7:	eb 1a                	jmp    804303 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8042e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ed:	8b 10                	mov    (%rax),%edx
  8042ef:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8042f6:	00 00 00 
  8042f9:	8b 00                	mov    (%rax),%eax
  8042fb:	39 c2                	cmp    %eax,%edx
  8042fd:	0f 94 c0             	sete   %al
  804300:	0f b6 c0             	movzbl %al,%eax
}
  804303:	c9                   	leaveq 
  804304:	c3                   	retq   

0000000000804305 <opencons>:

int
opencons(void)
{
  804305:	55                   	push   %rbp
  804306:	48 89 e5             	mov    %rsp,%rbp
  804309:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80430d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804311:	48 89 c7             	mov    %rax,%rdi
  804314:	48 b8 b9 24 80 00 00 	movabs $0x8024b9,%rax
  80431b:	00 00 00 
  80431e:	ff d0                	callq  *%rax
  804320:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804327:	79 05                	jns    80432e <opencons+0x29>
		return r;
  804329:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432c:	eb 5b                	jmp    804389 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80432e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804332:	ba 07 04 00 00       	mov    $0x407,%edx
  804337:	48 89 c6             	mov    %rax,%rsi
  80433a:	bf 00 00 00 00       	mov    $0x0,%edi
  80433f:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
  80434b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80434e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804352:	79 05                	jns    804359 <opencons+0x54>
		return r;
  804354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804357:	eb 30                	jmp    804389 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80435d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804364:	00 00 00 
  804367:	8b 12                	mov    (%rdx),%edx
  804369:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80436b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437a:	48 89 c7             	mov    %rax,%rdi
  80437d:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  804384:	00 00 00 
  804387:	ff d0                	callq  *%rax
}
  804389:	c9                   	leaveq 
  80438a:	c3                   	retq   

000000000080438b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80438b:	55                   	push   %rbp
  80438c:	48 89 e5             	mov    %rsp,%rbp
  80438f:	48 83 ec 30          	sub    $0x30,%rsp
  804393:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804397:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80439b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80439f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043a4:	75 07                	jne    8043ad <devcons_read+0x22>
		return 0;
  8043a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ab:	eb 4b                	jmp    8043f8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8043ad:	eb 0c                	jmp    8043bb <devcons_read+0x30>
		sys_yield();
  8043af:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8043b6:	00 00 00 
  8043b9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043bb:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
  8043c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ce:	74 df                	je     8043af <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8043d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d4:	79 05                	jns    8043db <devcons_read+0x50>
		return c;
  8043d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d9:	eb 1d                	jmp    8043f8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8043db:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8043df:	75 07                	jne    8043e8 <devcons_read+0x5d>
		return 0;
  8043e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e6:	eb 10                	jmp    8043f8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8043e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043eb:	89 c2                	mov    %eax,%edx
  8043ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f1:	88 10                	mov    %dl,(%rax)
	return 1;
  8043f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043f8:	c9                   	leaveq 
  8043f9:	c3                   	retq   

00000000008043fa <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043fa:	55                   	push   %rbp
  8043fb:	48 89 e5             	mov    %rsp,%rbp
  8043fe:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804405:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80440c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804413:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80441a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804421:	eb 76                	jmp    804499 <devcons_write+0x9f>
		m = n - tot;
  804423:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80442a:	89 c2                	mov    %eax,%edx
  80442c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442f:	29 c2                	sub    %eax,%edx
  804431:	89 d0                	mov    %edx,%eax
  804433:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804436:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804439:	83 f8 7f             	cmp    $0x7f,%eax
  80443c:	76 07                	jbe    804445 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80443e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804448:	48 63 d0             	movslq %eax,%rdx
  80444b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444e:	48 63 c8             	movslq %eax,%rcx
  804451:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804458:	48 01 c1             	add    %rax,%rcx
  80445b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804462:	48 89 ce             	mov    %rcx,%rsi
  804465:	48 89 c7             	mov    %rax,%rdi
  804468:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80446f:	00 00 00 
  804472:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804474:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804477:	48 63 d0             	movslq %eax,%rdx
  80447a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804481:	48 89 d6             	mov    %rdx,%rsi
  804484:	48 89 c7             	mov    %rax,%rdi
  804487:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  80448e:	00 00 00 
  804491:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804493:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804496:	01 45 fc             	add    %eax,-0x4(%rbp)
  804499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449c:	48 98                	cltq   
  80449e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044a5:	0f 82 78 ff ff ff    	jb     804423 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044ae:	c9                   	leaveq 
  8044af:	c3                   	retq   

00000000008044b0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044b0:	55                   	push   %rbp
  8044b1:	48 89 e5             	mov    %rsp,%rbp
  8044b4:	48 83 ec 08          	sub    $0x8,%rsp
  8044b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044c1:	c9                   	leaveq 
  8044c2:	c3                   	retq   

00000000008044c3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044c3:	55                   	push   %rbp
  8044c4:	48 89 e5             	mov    %rsp,%rbp
  8044c7:	48 83 ec 10          	sub    $0x10,%rsp
  8044cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d7:	48 be a5 4f 80 00 00 	movabs $0x804fa5,%rsi
  8044de:	00 00 00 
  8044e1:	48 89 c7             	mov    %rax,%rdi
  8044e4:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8044eb:	00 00 00 
  8044ee:	ff d0                	callq  *%rax
	return 0;
  8044f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f5:	c9                   	leaveq 
  8044f6:	c3                   	retq   

00000000008044f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8044f7:	55                   	push   %rbp
  8044f8:	48 89 e5             	mov    %rsp,%rbp
  8044fb:	53                   	push   %rbx
  8044fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804503:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80450a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804510:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804517:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80451e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804525:	84 c0                	test   %al,%al
  804527:	74 23                	je     80454c <_panic+0x55>
  804529:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804530:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804534:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804538:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80453c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804540:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804544:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804548:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80454c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804553:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80455a:	00 00 00 
  80455d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804564:	00 00 00 
  804567:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80456b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804572:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804579:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804580:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804587:	00 00 00 
  80458a:	48 8b 18             	mov    (%rax),%rbx
  80458d:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  804594:	00 00 00 
  804597:	ff d0                	callq  *%rax
  804599:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80459f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8045a6:	41 89 c8             	mov    %ecx,%r8d
  8045a9:	48 89 d1             	mov    %rdx,%rcx
  8045ac:	48 89 da             	mov    %rbx,%rdx
  8045af:	89 c6                	mov    %eax,%esi
  8045b1:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  8045b8:	00 00 00 
  8045bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c0:	49 b9 ca 03 80 00 00 	movabs $0x8003ca,%r9
  8045c7:	00 00 00 
  8045ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8045cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8045d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8045db:	48 89 d6             	mov    %rdx,%rsi
  8045de:	48 89 c7             	mov    %rax,%rdi
  8045e1:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  8045e8:	00 00 00 
  8045eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8045ed:	48 bf d3 4f 80 00 00 	movabs $0x804fd3,%rdi
  8045f4:	00 00 00 
  8045f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8045fc:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  804603:	00 00 00 
  804606:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804608:	cc                   	int3   
  804609:	eb fd                	jmp    804608 <_panic+0x111>

000000000080460b <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80460b:	55                   	push   %rbp
  80460c:	48 89 e5             	mov    %rsp,%rbp
  80460f:	48 83 ec 10          	sub    $0x10,%rsp
  804613:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804617:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80461e:	00 00 00 
  804621:	48 8b 00             	mov    (%rax),%rax
  804624:	48 85 c0             	test   %rax,%rax
  804627:	0f 85 84 00 00 00    	jne    8046b1 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80462d:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804634:	00 00 00 
  804637:	48 8b 00             	mov    (%rax),%rax
  80463a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804640:	ba 07 00 00 00       	mov    $0x7,%edx
  804645:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80464a:	89 c7                	mov    %eax,%edi
  80464c:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  804653:	00 00 00 
  804656:	ff d0                	callq  *%rax
  804658:	85 c0                	test   %eax,%eax
  80465a:	79 2a                	jns    804686 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80465c:	48 ba d8 4f 80 00 00 	movabs $0x804fd8,%rdx
  804663:	00 00 00 
  804666:	be 23 00 00 00       	mov    $0x23,%esi
  80466b:	48 bf ff 4f 80 00 00 	movabs $0x804fff,%rdi
  804672:	00 00 00 
  804675:	b8 00 00 00 00       	mov    $0x0,%eax
  80467a:	48 b9 f7 44 80 00 00 	movabs $0x8044f7,%rcx
  804681:	00 00 00 
  804684:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804686:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80468d:	00 00 00 
  804690:	48 8b 00             	mov    (%rax),%rax
  804693:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804699:	48 be c4 46 80 00 00 	movabs $0x8046c4,%rsi
  8046a0:	00 00 00 
  8046a3:	89 c7                	mov    %eax,%edi
  8046a5:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  8046ac:	00 00 00 
  8046af:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046b1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046b8:	00 00 00 
  8046bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046bf:	48 89 10             	mov    %rdx,(%rax)
}
  8046c2:	c9                   	leaveq 
  8046c3:	c3                   	retq   

00000000008046c4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046c4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046c7:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8046ce:	00 00 00 
call *%rax
  8046d1:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8046d3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8046da:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8046db:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8046e2:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8046e3:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8046e7:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8046ea:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8046f1:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8046f2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8046f6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8046fa:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8046ff:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804704:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804709:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80470e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804713:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804718:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80471d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804722:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804727:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80472c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804731:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804736:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80473b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804740:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804744:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804748:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804749:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80474a:	c3                   	retq   

000000000080474b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80474b:	55                   	push   %rbp
  80474c:	48 89 e5             	mov    %rsp,%rbp
  80474f:	48 83 ec 18          	sub    $0x18,%rsp
  804753:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80475b:	48 c1 e8 15          	shr    $0x15,%rax
  80475f:	48 89 c2             	mov    %rax,%rdx
  804762:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804769:	01 00 00 
  80476c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804770:	83 e0 01             	and    $0x1,%eax
  804773:	48 85 c0             	test   %rax,%rax
  804776:	75 07                	jne    80477f <pageref+0x34>
		return 0;
  804778:	b8 00 00 00 00       	mov    $0x0,%eax
  80477d:	eb 53                	jmp    8047d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80477f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804783:	48 c1 e8 0c          	shr    $0xc,%rax
  804787:	48 89 c2             	mov    %rax,%rdx
  80478a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804791:	01 00 00 
  804794:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80479c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047a0:	83 e0 01             	and    $0x1,%eax
  8047a3:	48 85 c0             	test   %rax,%rax
  8047a6:	75 07                	jne    8047af <pageref+0x64>
		return 0;
  8047a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ad:	eb 23                	jmp    8047d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8047af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8047b7:	48 89 c2             	mov    %rax,%rdx
  8047ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8047c1:	00 00 00 
  8047c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8047c8:	48 01 d0             	add    %rdx,%rax
  8047cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8047cf:	0f b7 c0             	movzwl %ax,%eax
}
  8047d2:	c9                   	leaveq 
  8047d3:	c3                   	retq   
