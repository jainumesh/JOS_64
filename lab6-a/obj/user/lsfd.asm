
obj/user/lsfd.debug:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf c0 45 80 00 00 	movabs $0x8045c0,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 d9 26 80 00 00 	movabs $0x8026d9,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be d8 45 80 00 00 	movabs $0x8045d8,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba 2c 30 80 00 00 	movabs $0x80302c,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf d8 45 80 00 00 	movabs $0x8045d8,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 90 03 80 00 00 	movabs $0x800390,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001dd:	48 63 d0             	movslq %eax,%rdx
  8001e0:	48 89 d0             	mov    %rdx,%rax
  8001e3:	48 c1 e0 03          	shl    $0x3,%rax
  8001e7:	48 01 d0             	add    %rdx,%rax
  8001ea:	48 c1 e0 05          	shl    $0x5,%rax
  8001ee:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001f5:	00 00 00 
  8001f8:	48 01 c2             	add    %rax,%rdx
  8001fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800202:	00 00 00 
  800205:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800208:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020c:	7e 14                	jle    800222 <libmain+0x65>
		binaryname = argv[0];
  80020e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800212:	48 8b 10             	mov    (%rax),%rdx
  800215:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021c:	00 00 00 
  80021f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800222:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800229:	48 89 d6             	mov    %rdx,%rsi
  80022c:	89 c7                	mov    %eax,%edi
  80022e:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80023a:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax
}
  800246:	c9                   	leaveq 
  800247:	c3                   	retq   

0000000000800248 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80024c:	48 b8 d3 21 80 00 00 	movabs $0x8021d3,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax

}
  800269:	5d                   	pop    %rbp
  80026a:	c3                   	retq   

000000000080026b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80026b:	55                   	push   %rbp
  80026c:	48 89 e5             	mov    %rsp,%rbp
  80026f:	48 83 ec 10          	sub    $0x10,%rsp
  800273:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800276:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80027a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027e:	8b 00                	mov    (%rax),%eax
  800280:	8d 48 01             	lea    0x1(%rax),%ecx
  800283:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800287:	89 0a                	mov    %ecx,(%rdx)
  800289:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80028c:	89 d1                	mov    %edx,%ecx
  80028e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800292:	48 98                	cltq   
  800294:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029c:	8b 00                	mov    (%rax),%eax
  80029e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a3:	75 2c                	jne    8002d1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a9:	8b 00                	mov    (%rax),%eax
  8002ab:	48 98                	cltq   
  8002ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b1:	48 83 c2 08          	add    $0x8,%rdx
  8002b5:	48 89 c6             	mov    %rax,%rsi
  8002b8:	48 89 d7             	mov    %rdx,%rdi
  8002bb:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	callq  *%rax
        b->idx = 0;
  8002c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d5:	8b 40 04             	mov    0x4(%rax),%eax
  8002d8:	8d 50 01             	lea    0x1(%rax),%edx
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e2:	c9                   	leaveq 
  8002e3:	c3                   	retq   

00000000008002e4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002e4:	55                   	push   %rbp
  8002e5:	48 89 e5             	mov    %rsp,%rbp
  8002e8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002ef:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002f6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002fd:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800304:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80030b:	48 8b 0a             	mov    (%rdx),%rcx
  80030e:	48 89 08             	mov    %rcx,(%rax)
  800311:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800315:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800319:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800321:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800328:	00 00 00 
    b.cnt = 0;
  80032b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800332:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800335:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80033c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800343:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80034a:	48 89 c6             	mov    %rax,%rsi
  80034d:	48 bf 6b 02 80 00 00 	movabs $0x80026b,%rdi
  800354:	00 00 00 
  800357:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  80035e:	00 00 00 
  800361:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800363:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800369:	48 98                	cltq   
  80036b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800372:	48 83 c2 08          	add    $0x8,%rdx
  800376:	48 89 c6             	mov    %rax,%rsi
  800379:	48 89 d7             	mov    %rdx,%rdi
  80037c:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  800383:	00 00 00 
  800386:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80038e:	c9                   	leaveq 
  80038f:	c3                   	retq   

0000000000800390 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800390:	55                   	push   %rbp
  800391:	48 89 e5             	mov    %rsp,%rbp
  800394:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80039b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003a2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003a9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003b7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003be:	84 c0                	test   %al,%al
  8003c0:	74 20                	je     8003e2 <cprintf+0x52>
  8003c2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003c6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003ca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003ce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003d2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003d6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003da:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003de:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003e2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003e9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f0:	00 00 00 
  8003f3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003fa:	00 00 00 
  8003fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800401:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800408:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80040f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800416:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80041d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800424:	48 8b 0a             	mov    (%rdx),%rcx
  800427:	48 89 08             	mov    %rcx,(%rax)
  80042a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800432:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800436:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80043a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800441:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800448:	48 89 d6             	mov    %rdx,%rsi
  80044b:	48 89 c7             	mov    %rax,%rdi
  80044e:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
  80045a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800460:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800466:	c9                   	leaveq 
  800467:	c3                   	retq   

0000000000800468 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	53                   	push   %rbx
  80046d:	48 83 ec 38          	sub    $0x38,%rsp
  800471:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800475:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800479:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80047d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800480:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800484:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800488:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80048b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80048f:	77 3b                	ja     8004cc <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800491:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800494:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800498:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80049b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	48 f7 f3             	div    %rbx
  8004a7:	48 89 c2             	mov    %rax,%rdx
  8004aa:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004ad:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004b0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b8:	41 89 f9             	mov    %edi,%r9d
  8004bb:	48 89 c7             	mov    %rax,%rdi
  8004be:	48 b8 68 04 80 00 00 	movabs $0x800468,%rax
  8004c5:	00 00 00 
  8004c8:	ff d0                	callq  *%rax
  8004ca:	eb 1e                	jmp    8004ea <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004cc:	eb 12                	jmp    8004e0 <printnum+0x78>
			putch(padc, putdat);
  8004ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004d2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	48 89 ce             	mov    %rcx,%rsi
  8004dc:	89 d7                	mov    %edx,%edi
  8004de:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e0:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004e8:	7f e4                	jg     8004ce <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ea:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f6:	48 f7 f1             	div    %rcx
  8004f9:	48 89 d0             	mov    %rdx,%rax
  8004fc:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  800503:	00 00 00 
  800506:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80050a:	0f be d0             	movsbl %al,%edx
  80050d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	48 89 ce             	mov    %rcx,%rsi
  800518:	89 d7                	mov    %edx,%edi
  80051a:	ff d0                	callq  *%rax
}
  80051c:	48 83 c4 38          	add    $0x38,%rsp
  800520:	5b                   	pop    %rbx
  800521:	5d                   	pop    %rbp
  800522:	c3                   	retq   

0000000000800523 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800523:	55                   	push   %rbp
  800524:	48 89 e5             	mov    %rsp,%rbp
  800527:	48 83 ec 1c          	sub    $0x1c,%rsp
  80052b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80052f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800532:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800536:	7e 52                	jle    80058a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	8b 00                	mov    (%rax),%eax
  80053e:	83 f8 30             	cmp    $0x30,%eax
  800541:	73 24                	jae    800567 <getuint+0x44>
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
  800565:	eb 17                	jmp    80057e <getuint+0x5b>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80056f:	48 89 d0             	mov    %rdx,%rax
  800572:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800576:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057e:	48 8b 00             	mov    (%rax),%rax
  800581:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800585:	e9 a3 00 00 00       	jmpq   80062d <getuint+0x10a>
	else if (lflag)
  80058a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80058e:	74 4f                	je     8005df <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	8b 00                	mov    (%rax),%eax
  800596:	83 f8 30             	cmp    $0x30,%eax
  800599:	73 24                	jae    8005bf <getuint+0x9c>
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	89 c0                	mov    %eax,%eax
  8005ab:	48 01 d0             	add    %rdx,%rax
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	8b 12                	mov    (%rdx),%edx
  8005b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bb:	89 0a                	mov    %ecx,(%rdx)
  8005bd:	eb 17                	jmp    8005d6 <getuint+0xb3>
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c7:	48 89 d0             	mov    %rdx,%rax
  8005ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d6:	48 8b 00             	mov    (%rax),%rax
  8005d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005dd:	eb 4e                	jmp    80062d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	8b 00                	mov    (%rax),%eax
  8005e5:	83 f8 30             	cmp    $0x30,%eax
  8005e8:	73 24                	jae    80060e <getuint+0xeb>
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	89 c0                	mov    %eax,%eax
  8005fa:	48 01 d0             	add    %rdx,%rax
  8005fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800601:	8b 12                	mov    (%rdx),%edx
  800603:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060a:	89 0a                	mov    %ecx,(%rdx)
  80060c:	eb 17                	jmp    800625 <getuint+0x102>
  80060e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800612:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800616:	48 89 d0             	mov    %rdx,%rax
  800619:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800621:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800625:	8b 00                	mov    (%rax),%eax
  800627:	89 c0                	mov    %eax,%eax
  800629:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80062d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800631:	c9                   	leaveq 
  800632:	c3                   	retq   

0000000000800633 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	48 83 ec 1c          	sub    $0x1c,%rsp
  80063b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800642:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800646:	7e 52                	jle    80069a <getint+0x67>
		x=va_arg(*ap, long long);
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	83 f8 30             	cmp    $0x30,%eax
  800651:	73 24                	jae    800677 <getint+0x44>
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
  800675:	eb 17                	jmp    80068e <getint+0x5b>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067f:	48 89 d0             	mov    %rdx,%rax
  800682:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068e:	48 8b 00             	mov    (%rax),%rax
  800691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800695:	e9 a3 00 00 00       	jmpq   80073d <getint+0x10a>
	else if (lflag)
  80069a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069e:	74 4f                	je     8006ef <getint+0xbc>
		x=va_arg(*ap, long);
  8006a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a4:	8b 00                	mov    (%rax),%eax
  8006a6:	83 f8 30             	cmp    $0x30,%eax
  8006a9:	73 24                	jae    8006cf <getint+0x9c>
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	8b 00                	mov    (%rax),%eax
  8006b9:	89 c0                	mov    %eax,%eax
  8006bb:	48 01 d0             	add    %rdx,%rax
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	8b 12                	mov    (%rdx),%edx
  8006c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cb:	89 0a                	mov    %ecx,(%rdx)
  8006cd:	eb 17                	jmp    8006e6 <getint+0xb3>
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d7:	48 89 d0             	mov    %rdx,%rax
  8006da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e6:	48 8b 00             	mov    (%rax),%rax
  8006e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ed:	eb 4e                	jmp    80073d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	8b 00                	mov    (%rax),%eax
  8006f5:	83 f8 30             	cmp    $0x30,%eax
  8006f8:	73 24                	jae    80071e <getint+0xeb>
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800706:	8b 00                	mov    (%rax),%eax
  800708:	89 c0                	mov    %eax,%eax
  80070a:	48 01 d0             	add    %rdx,%rax
  80070d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800711:	8b 12                	mov    (%rdx),%edx
  800713:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071a:	89 0a                	mov    %ecx,(%rdx)
  80071c:	eb 17                	jmp    800735 <getint+0x102>
  80071e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800722:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800726:	48 89 d0             	mov    %rdx,%rax
  800729:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800731:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800735:	8b 00                	mov    (%rax),%eax
  800737:	48 98                	cltq   
  800739:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800741:	c9                   	leaveq 
  800742:	c3                   	retq   

0000000000800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %rbp
  800744:	48 89 e5             	mov    %rsp,%rbp
  800747:	41 54                	push   %r12
  800749:	53                   	push   %rbx
  80074a:	48 83 ec 60          	sub    $0x60,%rsp
  80074e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800752:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800756:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80075a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80075e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800762:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800766:	48 8b 0a             	mov    (%rdx),%rcx
  800769:	48 89 08             	mov    %rcx,(%rax)
  80076c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800770:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800774:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800778:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077c:	eb 17                	jmp    800795 <vprintfmt+0x52>
			if (ch == '\0')
  80077e:	85 db                	test   %ebx,%ebx
  800780:	0f 84 cc 04 00 00    	je     800c52 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800786:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80078a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80078e:	48 89 d6             	mov    %rdx,%rsi
  800791:	89 df                	mov    %ebx,%edi
  800793:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800795:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800799:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80079d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a1:	0f b6 00             	movzbl (%rax),%eax
  8007a4:	0f b6 d8             	movzbl %al,%ebx
  8007a7:	83 fb 25             	cmp    $0x25,%ebx
  8007aa:	75 d2                	jne    80077e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ac:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007b0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d8:	0f b6 00             	movzbl (%rax),%eax
  8007db:	0f b6 d8             	movzbl %al,%ebx
  8007de:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007e1:	83 f8 55             	cmp    $0x55,%eax
  8007e4:	0f 87 34 04 00 00    	ja     800c1e <vprintfmt+0x4db>
  8007ea:	89 c0                	mov    %eax,%eax
  8007ec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007f3:	00 
  8007f4:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  8007fb:	00 00 00 
  8007fe:	48 01 d0             	add    %rdx,%rax
  800801:	48 8b 00             	mov    (%rax),%rax
  800804:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800806:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80080a:	eb c0                	jmp    8007cc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800810:	eb ba                	jmp    8007cc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800812:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800819:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80081c:	89 d0                	mov    %edx,%eax
  80081e:	c1 e0 02             	shl    $0x2,%eax
  800821:	01 d0                	add    %edx,%eax
  800823:	01 c0                	add    %eax,%eax
  800825:	01 d8                	add    %ebx,%eax
  800827:	83 e8 30             	sub    $0x30,%eax
  80082a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80082d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800831:	0f b6 00             	movzbl (%rax),%eax
  800834:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800837:	83 fb 2f             	cmp    $0x2f,%ebx
  80083a:	7e 0c                	jle    800848 <vprintfmt+0x105>
  80083c:	83 fb 39             	cmp    $0x39,%ebx
  80083f:	7f 07                	jg     800848 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800841:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800846:	eb d1                	jmp    800819 <vprintfmt+0xd6>
			goto process_precision;
  800848:	eb 58                	jmp    8008a2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80084a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084d:	83 f8 30             	cmp    $0x30,%eax
  800850:	73 17                	jae    800869 <vprintfmt+0x126>
  800852:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800856:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800859:	89 c0                	mov    %eax,%eax
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800861:	83 c2 08             	add    $0x8,%edx
  800864:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800867:	eb 0f                	jmp    800878 <vprintfmt+0x135>
  800869:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086d:	48 89 d0             	mov    %rdx,%rax
  800870:	48 83 c2 08          	add    $0x8,%rdx
  800874:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800878:	8b 00                	mov    (%rax),%eax
  80087a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80087d:	eb 23                	jmp    8008a2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80087f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800883:	79 0c                	jns    800891 <vprintfmt+0x14e>
				width = 0;
  800885:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80088c:	e9 3b ff ff ff       	jmpq   8007cc <vprintfmt+0x89>
  800891:	e9 36 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800896:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80089d:	e9 2a ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a6:	79 12                	jns    8008ba <vprintfmt+0x177>
				width = precision, precision = -1;
  8008a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ab:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008b5:	e9 12 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>
  8008ba:	e9 0d ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008bf:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008c3:	e9 04 ff ff ff       	jmpq   8007cc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cb:	83 f8 30             	cmp    $0x30,%eax
  8008ce:	73 17                	jae    8008e7 <vprintfmt+0x1a4>
  8008d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d7:	89 c0                	mov    %eax,%eax
  8008d9:	48 01 d0             	add    %rdx,%rax
  8008dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008df:	83 c2 08             	add    $0x8,%edx
  8008e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008e5:	eb 0f                	jmp    8008f6 <vprintfmt+0x1b3>
  8008e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008eb:	48 89 d0             	mov    %rdx,%rax
  8008ee:	48 83 c2 08          	add    $0x8,%rdx
  8008f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008f6:	8b 10                	mov    (%rax),%edx
  8008f8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800900:	48 89 ce             	mov    %rcx,%rsi
  800903:	89 d7                	mov    %edx,%edi
  800905:	ff d0                	callq  *%rax
			break;
  800907:	e9 40 03 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80090c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090f:	83 f8 30             	cmp    $0x30,%eax
  800912:	73 17                	jae    80092b <vprintfmt+0x1e8>
  800914:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091b:	89 c0                	mov    %eax,%eax
  80091d:	48 01 d0             	add    %rdx,%rax
  800920:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800923:	83 c2 08             	add    $0x8,%edx
  800926:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x1f7>
  80092b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092f:	48 89 d0             	mov    %rdx,%rax
  800932:	48 83 c2 08          	add    $0x8,%rdx
  800936:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x1ff>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 15             	cmp    $0x15,%ebx
  800945:	7f 16                	jg     80095d <vprintfmt+0x21a>
  800947:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  80094e:	00 00 00 
  800951:	48 63 d3             	movslq %ebx,%rdx
  800954:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800958:	4d 85 e4             	test   %r12,%r12
  80095b:	75 2e                	jne    80098b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80095d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800961:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800965:	89 d9                	mov    %ebx,%ecx
  800967:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  80096e:	00 00 00 
  800971:	48 89 c7             	mov    %rax,%rdi
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
  800979:	49 b8 5b 0c 80 00 00 	movabs $0x800c5b,%r8
  800980:	00 00 00 
  800983:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800986:	e9 c1 02 00 00       	jmpq   800c4c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80098f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800993:	4c 89 e1             	mov    %r12,%rcx
  800996:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  80099d:	00 00 00 
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a8:	49 b8 5b 0c 80 00 00 	movabs $0x800c5b,%r8
  8009af:	00 00 00 
  8009b2:	41 ff d0             	callq  *%r8
			break;
  8009b5:	e9 92 02 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bd:	83 f8 30             	cmp    $0x30,%eax
  8009c0:	73 17                	jae    8009d9 <vprintfmt+0x296>
  8009c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c9:	89 c0                	mov    %eax,%eax
  8009cb:	48 01 d0             	add    %rdx,%rax
  8009ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d1:	83 c2 08             	add    $0x8,%edx
  8009d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d7:	eb 0f                	jmp    8009e8 <vprintfmt+0x2a5>
  8009d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dd:	48 89 d0             	mov    %rdx,%rax
  8009e0:	48 83 c2 08          	add    $0x8,%rdx
  8009e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e8:	4c 8b 20             	mov    (%rax),%r12
  8009eb:	4d 85 e4             	test   %r12,%r12
  8009ee:	75 0a                	jne    8009fa <vprintfmt+0x2b7>
				p = "(null)";
  8009f0:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  8009f7:	00 00 00 
			if (width > 0 && padc != '-')
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	7e 3f                	jle    800a3f <vprintfmt+0x2fc>
  800a00:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a04:	74 39                	je     800a3f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a06:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a09:	48 98                	cltq   
  800a0b:	48 89 c6             	mov    %rax,%rsi
  800a0e:	4c 89 e7             	mov    %r12,%rdi
  800a11:	48 b8 07 0f 80 00 00 	movabs $0x800f07,%rax
  800a18:	00 00 00 
  800a1b:	ff d0                	callq  *%rax
  800a1d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a20:	eb 17                	jmp    800a39 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a22:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a26:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2e:	48 89 ce             	mov    %rcx,%rsi
  800a31:	89 d7                	mov    %edx,%edi
  800a33:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3d:	7f e3                	jg     800a22 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3f:	eb 37                	jmp    800a78 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a45:	74 1e                	je     800a65 <vprintfmt+0x322>
  800a47:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4a:	7e 05                	jle    800a51 <vprintfmt+0x30e>
  800a4c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a4f:	7e 14                	jle    800a65 <vprintfmt+0x322>
					putch('?', putdat);
  800a51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a59:	48 89 d6             	mov    %rdx,%rsi
  800a5c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a61:	ff d0                	callq  *%rax
  800a63:	eb 0f                	jmp    800a74 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6d:	48 89 d6             	mov    %rdx,%rsi
  800a70:	89 df                	mov    %ebx,%edi
  800a72:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a74:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a78:	4c 89 e0             	mov    %r12,%rax
  800a7b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a7f:	0f b6 00             	movzbl (%rax),%eax
  800a82:	0f be d8             	movsbl %al,%ebx
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	74 10                	je     800a99 <vprintfmt+0x356>
  800a89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a8d:	78 b2                	js     800a41 <vprintfmt+0x2fe>
  800a8f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a93:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a97:	79 a8                	jns    800a41 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a99:	eb 16                	jmp    800ab1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa3:	48 89 d6             	mov    %rdx,%rsi
  800aa6:	bf 20 00 00 00       	mov    $0x20,%edi
  800aab:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab5:	7f e4                	jg     800a9b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ab7:	e9 90 01 00 00       	jmpq   800c4c <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800abc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac0:	be 03 00 00 00       	mov    $0x3,%esi
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	48 85 c0             	test   %rax,%rax
  800adf:	79 1d                	jns    800afe <vprintfmt+0x3bb>
				putch('-', putdat);
  800ae1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae9:	48 89 d6             	mov    %rdx,%rsi
  800aec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800af1:	ff d0                	callq  *%rax
				num = -(long long) num;
  800af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af7:	48 f7 d8             	neg    %rax
  800afa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800afe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b05:	e9 d5 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0e:	be 03 00 00 00       	mov    $0x3,%esi
  800b13:	48 89 c7             	mov    %rax,%rdi
  800b16:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800b1d:	00 00 00 
  800b20:	ff d0                	callq  *%rax
  800b22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b2d:	e9 ad 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b32:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b35:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	48 89 c7             	mov    %rax,%rdi
  800b3e:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800b45:	00 00 00 
  800b48:	ff d0                	callq  *%rax
  800b4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b4e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b55:	e9 85 00 00 00       	jmpq   800bdf <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b62:	48 89 d6             	mov    %rdx,%rsi
  800b65:	bf 30 00 00 00       	mov    $0x30,%edi
  800b6a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b74:	48 89 d6             	mov    %rdx,%rsi
  800b77:	bf 78 00 00 00       	mov    $0x78,%edi
  800b7c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b81:	83 f8 30             	cmp    $0x30,%eax
  800b84:	73 17                	jae    800b9d <vprintfmt+0x45a>
  800b86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8d:	89 c0                	mov    %eax,%eax
  800b8f:	48 01 d0             	add    %rdx,%rax
  800b92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b95:	83 c2 08             	add    $0x8,%edx
  800b98:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b9b:	eb 0f                	jmp    800bac <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba1:	48 89 d0             	mov    %rdx,%rax
  800ba4:	48 83 c2 08          	add    $0x8,%rdx
  800ba8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bac:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bba:	eb 23                	jmp    800bdf <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc0:	be 03 00 00 00       	mov    $0x3,%esi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
  800bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800be4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800be7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf6:	45 89 c1             	mov    %r8d,%r9d
  800bf9:	41 89 f8             	mov    %edi,%r8d
  800bfc:	48 89 c7             	mov    %rax,%rdi
  800bff:	48 b8 68 04 80 00 00 	movabs $0x800468,%rax
  800c06:	00 00 00 
  800c09:	ff d0                	callq  *%rax
			break;
  800c0b:	eb 3f                	jmp    800c4c <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c15:	48 89 d6             	mov    %rdx,%rsi
  800c18:	89 df                	mov    %ebx,%edi
  800c1a:	ff d0                	callq  *%rax
			break;
  800c1c:	eb 2e                	jmp    800c4c <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	bf 25 00 00 00       	mov    $0x25,%edi
  800c2e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c30:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c35:	eb 05                	jmp    800c3c <vprintfmt+0x4f9>
  800c37:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c40:	48 83 e8 01          	sub    $0x1,%rax
  800c44:	0f b6 00             	movzbl (%rax),%eax
  800c47:	3c 25                	cmp    $0x25,%al
  800c49:	75 ec                	jne    800c37 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c4b:	90                   	nop
		}
	}
  800c4c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4d:	e9 43 fb ff ff       	jmpq   800795 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c52:	48 83 c4 60          	add    $0x60,%rsp
  800c56:	5b                   	pop    %rbx
  800c57:	41 5c                	pop    %r12
  800c59:	5d                   	pop    %rbp
  800c5a:	c3                   	retq   

0000000000800c5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5b:	55                   	push   %rbp
  800c5c:	48 89 e5             	mov    %rsp,%rbp
  800c5f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c66:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c6d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c74:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c7b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c82:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c89:	84 c0                	test   %al,%al
  800c8b:	74 20                	je     800cad <printfmt+0x52>
  800c8d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c91:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c95:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c99:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c9d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ca1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ca5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ca9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cad:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cb4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cbb:	00 00 00 
  800cbe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cc5:	00 00 00 
  800cc8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ccc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cd3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cda:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ce8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cef:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cf6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cfd:	48 89 c7             	mov    %rax,%rdi
  800d00:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d0c:	c9                   	leaveq 
  800d0d:	c3                   	retq   

0000000000800d0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d0e:	55                   	push   %rbp
  800d0f:	48 89 e5             	mov    %rsp,%rbp
  800d12:	48 83 ec 10          	sub    $0x10,%rsp
  800d16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d21:	8b 40 10             	mov    0x10(%rax),%eax
  800d24:	8d 50 01             	lea    0x1(%rax),%edx
  800d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d32:	48 8b 10             	mov    (%rax),%rdx
  800d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d39:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d3d:	48 39 c2             	cmp    %rax,%rdx
  800d40:	73 17                	jae    800d59 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d46:	48 8b 00             	mov    (%rax),%rax
  800d49:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d51:	48 89 0a             	mov    %rcx,(%rdx)
  800d54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d57:	88 10                	mov    %dl,(%rax)
}
  800d59:	c9                   	leaveq 
  800d5a:	c3                   	retq   

0000000000800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %rbp
  800d5c:	48 89 e5             	mov    %rsp,%rbp
  800d5f:	48 83 ec 50          	sub    $0x50,%rsp
  800d63:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d67:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d6a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d6e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d72:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d76:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d7a:	48 8b 0a             	mov    (%rdx),%rcx
  800d7d:	48 89 08             	mov    %rcx,(%rax)
  800d80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d94:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d98:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d9b:	48 98                	cltq   
  800d9d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800da1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800da5:	48 01 d0             	add    %rdx,%rax
  800da8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800db3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800db8:	74 06                	je     800dc0 <vsnprintf+0x65>
  800dba:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dbe:	7f 07                	jg     800dc7 <vsnprintf+0x6c>
		return -E_INVAL;
  800dc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc5:	eb 2f                	jmp    800df6 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dc7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dcb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dcf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dd3:	48 89 c6             	mov    %rax,%rsi
  800dd6:	48 bf 0e 0d 80 00 00 	movabs $0x800d0e,%rdi
  800ddd:	00 00 00 
  800de0:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800df0:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800df3:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800df6:	c9                   	leaveq 
  800df7:	c3                   	retq   

0000000000800df8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e03:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e0a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e25:	84 c0                	test   %al,%al
  800e27:	74 20                	je     800e49 <snprintf+0x51>
  800e29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e49:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e50:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e57:	00 00 00 
  800e5a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e61:	00 00 00 
  800e64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e68:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e76:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e7d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e84:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e8b:	48 8b 0a             	mov    (%rdx),%rcx
  800e8e:	48 89 08             	mov    %rcx,(%rax)
  800e91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e95:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e99:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e9d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ea1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ea8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eaf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eb5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ebc:	48 89 c7             	mov    %rax,%rdi
  800ebf:	48 b8 5b 0d 80 00 00 	movabs $0x800d5b,%rax
  800ec6:	00 00 00 
  800ec9:	ff d0                	callq  *%rax
  800ecb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ed1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ed7:	c9                   	leaveq 
  800ed8:	c3                   	retq   

0000000000800ed9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed9:	55                   	push   %rbp
  800eda:	48 89 e5             	mov    %rsp,%rbp
  800edd:	48 83 ec 18          	sub    $0x18,%rsp
  800ee1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eec:	eb 09                	jmp    800ef7 <strlen+0x1e>
		n++;
  800eee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efb:	0f b6 00             	movzbl (%rax),%eax
  800efe:	84 c0                	test   %al,%al
  800f00:	75 ec                	jne    800eee <strlen+0x15>
		n++;
	return n;
  800f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f05:	c9                   	leaveq 
  800f06:	c3                   	retq   

0000000000800f07 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f07:	55                   	push   %rbp
  800f08:	48 89 e5             	mov    %rsp,%rbp
  800f0b:	48 83 ec 20          	sub    $0x20,%rsp
  800f0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f1e:	eb 0e                	jmp    800f2e <strnlen+0x27>
		n++;
  800f20:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f24:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f29:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f2e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f33:	74 0b                	je     800f40 <strnlen+0x39>
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	0f b6 00             	movzbl (%rax),%eax
  800f3c:	84 c0                	test   %al,%al
  800f3e:	75 e0                	jne    800f20 <strnlen+0x19>
		n++;
	return n;
  800f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 20          	sub    $0x20,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f5d:	90                   	nop
  800f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f72:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f76:	0f b6 12             	movzbl (%rdx),%edx
  800f79:	88 10                	mov    %dl,(%rax)
  800f7b:	0f b6 00             	movzbl (%rax),%eax
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 dc                	jne    800f5e <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 20          	sub    $0x20,%rsp
  800f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 89 c7             	mov    %rax,%rdi
  800f9f:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	callq  *%rax
  800fab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fb1:	48 63 d0             	movslq %eax,%rdx
  800fb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb8:	48 01 c2             	add    %rax,%rdx
  800fbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fbf:	48 89 c6             	mov    %rax,%rsi
  800fc2:	48 89 d7             	mov    %rdx,%rdi
  800fc5:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  800fcc:	00 00 00 
  800fcf:	ff d0                	callq  *%rax
	return dst;
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fd5:	c9                   	leaveq 
  800fd6:	c3                   	retq   

0000000000800fd7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fd7:	55                   	push   %rbp
  800fd8:	48 89 e5             	mov    %rsp,%rbp
  800fdb:	48 83 ec 28          	sub    $0x28,%rsp
  800fdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fe7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ff3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ffa:	00 
  800ffb:	eb 2a                	jmp    801027 <strncpy+0x50>
		*dst++ = *src;
  800ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801001:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801005:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801009:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80100d:	0f b6 12             	movzbl (%rdx),%edx
  801010:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	84 c0                	test   %al,%al
  80101b:	74 05                	je     801022 <strncpy+0x4b>
			src++;
  80101d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801022:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80102f:	72 cc                	jb     800ffd <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801035:	c9                   	leaveq 
  801036:	c3                   	retq   

0000000000801037 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801037:	55                   	push   %rbp
  801038:	48 89 e5             	mov    %rsp,%rbp
  80103b:	48 83 ec 28          	sub    $0x28,%rsp
  80103f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801043:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801047:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801053:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801058:	74 3d                	je     801097 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80105a:	eb 1d                	jmp    801079 <strlcpy+0x42>
			*dst++ = *src++;
  80105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801060:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801064:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801068:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80106c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801070:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801074:	0f b6 12             	movzbl (%rdx),%edx
  801077:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801079:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80107e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801083:	74 0b                	je     801090 <strlcpy+0x59>
  801085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801089:	0f b6 00             	movzbl (%rax),%eax
  80108c:	84 c0                	test   %al,%al
  80108e:	75 cc                	jne    80105c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801097:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109f:	48 29 c2             	sub    %rax,%rdx
  8010a2:	48 89 d0             	mov    %rdx,%rax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 10          	sub    $0x10,%rsp
  8010af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010b7:	eb 0a                	jmp    8010c3 <strcmp+0x1c>
		p++, q++;
  8010b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	84 c0                	test   %al,%al
  8010cc:	74 12                	je     8010e0 <strcmp+0x39>
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	0f b6 10             	movzbl (%rax),%edx
  8010d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	38 c2                	cmp    %al,%dl
  8010de:	74 d9                	je     8010b9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	0f b6 d0             	movzbl %al,%edx
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	0f b6 c0             	movzbl %al,%eax
  8010f4:	29 c2                	sub    %eax,%edx
  8010f6:	89 d0                	mov    %edx,%eax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 18          	sub    $0x18,%rsp
  801102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80110a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80110e:	eb 0f                	jmp    80111f <strncmp+0x25>
		n--, p++, q++;
  801110:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801115:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80111f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801124:	74 1d                	je     801143 <strncmp+0x49>
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	74 12                	je     801143 <strncmp+0x49>
  801131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801135:	0f b6 10             	movzbl (%rax),%edx
  801138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113c:	0f b6 00             	movzbl (%rax),%eax
  80113f:	38 c2                	cmp    %al,%dl
  801141:	74 cd                	je     801110 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801143:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801148:	75 07                	jne    801151 <strncmp+0x57>
		return 0;
  80114a:	b8 00 00 00 00       	mov    $0x0,%eax
  80114f:	eb 18                	jmp    801169 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801155:	0f b6 00             	movzbl (%rax),%eax
  801158:	0f b6 d0             	movzbl %al,%edx
  80115b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115f:	0f b6 00             	movzbl (%rax),%eax
  801162:	0f b6 c0             	movzbl %al,%eax
  801165:	29 c2                	sub    %eax,%edx
  801167:	89 d0                	mov    %edx,%eax
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 0c          	sub    $0xc,%rsp
  801173:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801177:	89 f0                	mov    %esi,%eax
  801179:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80117c:	eb 17                	jmp    801195 <strchr+0x2a>
		if (*s == c)
  80117e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801182:	0f b6 00             	movzbl (%rax),%eax
  801185:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801188:	75 06                	jne    801190 <strchr+0x25>
			return (char *) s;
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	eb 15                	jmp    8011a5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801190:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	84 c0                	test   %al,%al
  80119e:	75 de                	jne    80117e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 0c          	sub    $0xc,%rsp
  8011af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b8:	eb 13                	jmp    8011cd <strfind+0x26>
		if (*s == c)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c4:	75 02                	jne    8011c8 <strfind+0x21>
			break;
  8011c6:	eb 10                	jmp    8011d8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d1:	0f b6 00             	movzbl (%rax),%eax
  8011d4:	84 c0                	test   %al,%al
  8011d6:	75 e2                	jne    8011ba <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011dc:	c9                   	leaveq 
  8011dd:	c3                   	retq   

00000000008011de <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	48 83 ec 18          	sub    $0x18,%rsp
  8011e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f6:	75 06                	jne    8011fe <memset+0x20>
		return v;
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	eb 69                	jmp    801267 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	83 e0 03             	and    $0x3,%eax
  801205:	48 85 c0             	test   %rax,%rax
  801208:	75 48                	jne    801252 <memset+0x74>
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	83 e0 03             	and    $0x3,%eax
  801211:	48 85 c0             	test   %rax,%rax
  801214:	75 3c                	jne    801252 <memset+0x74>
		c &= 0xFF;
  801216:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80121d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801220:	c1 e0 18             	shl    $0x18,%eax
  801223:	89 c2                	mov    %eax,%edx
  801225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801228:	c1 e0 10             	shl    $0x10,%eax
  80122b:	09 c2                	or     %eax,%edx
  80122d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801230:	c1 e0 08             	shl    $0x8,%eax
  801233:	09 d0                	or     %edx,%eax
  801235:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123c:	48 c1 e8 02          	shr    $0x2,%rax
  801240:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801243:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801247:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80124a:	48 89 d7             	mov    %rdx,%rdi
  80124d:	fc                   	cld    
  80124e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801250:	eb 11                	jmp    801263 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801252:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801256:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801259:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80125d:	48 89 d7             	mov    %rdx,%rdi
  801260:	fc                   	cld    
  801261:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801267:	c9                   	leaveq 
  801268:	c3                   	retq   

0000000000801269 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801269:	55                   	push   %rbp
  80126a:	48 89 e5             	mov    %rsp,%rbp
  80126d:	48 83 ec 28          	sub    $0x28,%rsp
  801271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80127d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801281:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801295:	0f 83 88 00 00 00    	jae    801323 <memmove+0xba>
  80129b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a3:	48 01 d0             	add    %rdx,%rax
  8012a6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012aa:	76 77                	jbe    801323 <memmove+0xba>
		s += n;
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	83 e0 03             	and    $0x3,%eax
  8012c3:	48 85 c0             	test   %rax,%rax
  8012c6:	75 3b                	jne    801303 <memmove+0x9a>
  8012c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cc:	83 e0 03             	and    $0x3,%eax
  8012cf:	48 85 c0             	test   %rax,%rax
  8012d2:	75 2f                	jne    801303 <memmove+0x9a>
  8012d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d8:	83 e0 03             	and    $0x3,%eax
  8012db:	48 85 c0             	test   %rax,%rax
  8012de:	75 23                	jne    801303 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e4:	48 83 e8 04          	sub    $0x4,%rax
  8012e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ec:	48 83 ea 04          	sub    $0x4,%rdx
  8012f0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012f4:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012f8:	48 89 c7             	mov    %rax,%rdi
  8012fb:	48 89 d6             	mov    %rdx,%rsi
  8012fe:	fd                   	std    
  8012ff:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801301:	eb 1d                	jmp    801320 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801307:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801313:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801317:	48 89 d7             	mov    %rdx,%rdi
  80131a:	48 89 c1             	mov    %rax,%rcx
  80131d:	fd                   	std    
  80131e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801320:	fc                   	cld    
  801321:	eb 57                	jmp    80137a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 36                	jne    801365 <memmove+0xfc>
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 2a                	jne    801365 <memmove+0xfc>
  80133b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133f:	83 e0 03             	and    $0x3,%eax
  801342:	48 85 c0             	test   %rax,%rax
  801345:	75 1e                	jne    801365 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134b:	48 c1 e8 02          	shr    $0x2,%rax
  80134f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135a:	48 89 c7             	mov    %rax,%rdi
  80135d:	48 89 d6             	mov    %rdx,%rsi
  801360:	fc                   	cld    
  801361:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801363:	eb 15                	jmp    80137a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801369:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801371:	48 89 c7             	mov    %rax,%rdi
  801374:	48 89 d6             	mov    %rdx,%rsi
  801377:	fc                   	cld    
  801378:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80137a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80137e:	c9                   	leaveq 
  80137f:	c3                   	retq   

0000000000801380 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	48 83 ec 18          	sub    $0x18,%rsp
  801388:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801390:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801394:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801398:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	48 89 ce             	mov    %rcx,%rsi
  8013a3:	48 89 c7             	mov    %rax,%rdi
  8013a6:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8013ad:	00 00 00 
  8013b0:	ff d0                	callq  *%rax
}
  8013b2:	c9                   	leaveq 
  8013b3:	c3                   	retq   

00000000008013b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	48 83 ec 28          	sub    $0x28,%rsp
  8013bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013d8:	eb 36                	jmp    801410 <memcmp+0x5c>
		if (*s1 != *s2)
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	0f b6 10             	movzbl (%rax),%edx
  8013e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	38 c2                	cmp    %al,%dl
  8013ea:	74 1a                	je     801406 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	0f b6 d0             	movzbl %al,%edx
  8013f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 c0             	movzbl %al,%eax
  801400:	29 c2                	sub    %eax,%edx
  801402:	89 d0                	mov    %edx,%eax
  801404:	eb 20                	jmp    801426 <memcmp+0x72>
		s1++, s2++;
  801406:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80140b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801418:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 b9                	jne    8013da <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801426:	c9                   	leaveq 
  801427:	c3                   	retq   

0000000000801428 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801428:	55                   	push   %rbp
  801429:	48 89 e5             	mov    %rsp,%rbp
  80142c:	48 83 ec 28          	sub    $0x28,%rsp
  801430:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801434:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801437:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801443:	48 01 d0             	add    %rdx,%rax
  801446:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80144a:	eb 15                	jmp    801461 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801450:	0f b6 10             	movzbl (%rax),%edx
  801453:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801456:	38 c2                	cmp    %al,%dl
  801458:	75 02                	jne    80145c <memfind+0x34>
			break;
  80145a:	eb 0f                	jmp    80146b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80145c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801465:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801469:	72 e1                	jb     80144c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80146b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146f:	c9                   	leaveq 
  801470:	c3                   	retq   

0000000000801471 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801471:	55                   	push   %rbp
  801472:	48 89 e5             	mov    %rsp,%rbp
  801475:	48 83 ec 34          	sub    $0x34,%rsp
  801479:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80147d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801481:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80148b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801492:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801493:	eb 05                	jmp    80149a <strtol+0x29>
		s++;
  801495:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 20                	cmp    $0x20,%al
  8014a3:	74 f0                	je     801495 <strtol+0x24>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	3c 09                	cmp    $0x9,%al
  8014ae:	74 e5                	je     801495 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	3c 2b                	cmp    $0x2b,%al
  8014b9:	75 07                	jne    8014c2 <strtol+0x51>
		s++;
  8014bb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c0:	eb 17                	jmp    8014d9 <strtol+0x68>
	else if (*s == '-')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 2d                	cmp    $0x2d,%al
  8014cb:	75 0c                	jne    8014d9 <strtol+0x68>
		s++, neg = 1;
  8014cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014dd:	74 06                	je     8014e5 <strtol+0x74>
  8014df:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014e3:	75 28                	jne    80150d <strtol+0x9c>
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	3c 30                	cmp    $0x30,%al
  8014ee:	75 1d                	jne    80150d <strtol+0x9c>
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	48 83 c0 01          	add    $0x1,%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	3c 78                	cmp    $0x78,%al
  8014fd:	75 0e                	jne    80150d <strtol+0x9c>
		s += 2, base = 16;
  8014ff:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801504:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80150b:	eb 2c                	jmp    801539 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80150d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801511:	75 19                	jne    80152c <strtol+0xbb>
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	3c 30                	cmp    $0x30,%al
  80151c:	75 0e                	jne    80152c <strtol+0xbb>
		s++, base = 8;
  80151e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801523:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80152a:	eb 0d                	jmp    801539 <strtol+0xc8>
	else if (base == 0)
  80152c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801530:	75 07                	jne    801539 <strtol+0xc8>
		base = 10;
  801532:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	3c 2f                	cmp    $0x2f,%al
  801542:	7e 1d                	jle    801561 <strtol+0xf0>
  801544:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801548:	0f b6 00             	movzbl (%rax),%eax
  80154b:	3c 39                	cmp    $0x39,%al
  80154d:	7f 12                	jg     801561 <strtol+0xf0>
			dig = *s - '0';
  80154f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	0f be c0             	movsbl %al,%eax
  801559:	83 e8 30             	sub    $0x30,%eax
  80155c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80155f:	eb 4e                	jmp    8015af <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	3c 60                	cmp    $0x60,%al
  80156a:	7e 1d                	jle    801589 <strtol+0x118>
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	0f b6 00             	movzbl (%rax),%eax
  801573:	3c 7a                	cmp    $0x7a,%al
  801575:	7f 12                	jg     801589 <strtol+0x118>
			dig = *s - 'a' + 10;
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	0f be c0             	movsbl %al,%eax
  801581:	83 e8 57             	sub    $0x57,%eax
  801584:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801587:	eb 26                	jmp    8015af <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 40                	cmp    $0x40,%al
  801592:	7e 48                	jle    8015dc <strtol+0x16b>
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 5a                	cmp    $0x5a,%al
  80159d:	7f 3d                	jg     8015dc <strtol+0x16b>
			dig = *s - 'A' + 10;
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	0f be c0             	movsbl %al,%eax
  8015a9:	83 e8 37             	sub    $0x37,%eax
  8015ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015b2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015b5:	7c 02                	jl     8015b9 <strtol+0x148>
			break;
  8015b7:	eb 23                	jmp    8015dc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015be:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015c1:	48 98                	cltq   
  8015c3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015c8:	48 89 c2             	mov    %rax,%rdx
  8015cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015ce:	48 98                	cltq   
  8015d0:	48 01 d0             	add    %rdx,%rax
  8015d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015d7:	e9 5d ff ff ff       	jmpq   801539 <strtol+0xc8>

	if (endptr)
  8015dc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015e1:	74 0b                	je     8015ee <strtol+0x17d>
		*endptr = (char *) s;
  8015e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015eb:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015f2:	74 09                	je     8015fd <strtol+0x18c>
  8015f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f8:	48 f7 d8             	neg    %rax
  8015fb:	eb 04                	jmp    801601 <strtol+0x190>
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801601:	c9                   	leaveq 
  801602:	c3                   	retq   

0000000000801603 <strstr>:

char * strstr(const char *in, const char *str)
{
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	48 83 ec 30          	sub    $0x30,%rsp
  80160b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80160f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801613:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801617:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80161b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801625:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801629:	75 06                	jne    801631 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	eb 6b                	jmp    80169c <strstr+0x99>

	len = strlen(str);
  801631:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801635:	48 89 c7             	mov    %rax,%rdi
  801638:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  80163f:	00 00 00 
  801642:	ff d0                	callq  *%rax
  801644:	48 98                	cltq   
  801646:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801652:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80165c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801660:	75 07                	jne    801669 <strstr+0x66>
				return (char *) 0;
  801662:	b8 00 00 00 00       	mov    $0x0,%eax
  801667:	eb 33                	jmp    80169c <strstr+0x99>
		} while (sc != c);
  801669:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80166d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801670:	75 d8                	jne    80164a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801672:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801676:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	48 89 ce             	mov    %rcx,%rsi
  801681:	48 89 c7             	mov    %rax,%rdi
  801684:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
  801690:	85 c0                	test   %eax,%eax
  801692:	75 b6                	jne    80164a <strstr+0x47>

	return (char *) (in - 1);
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	48 83 e8 01          	sub    $0x1,%rax
}
  80169c:	c9                   	leaveq 
  80169d:	c3                   	retq   

000000000080169e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80169e:	55                   	push   %rbp
  80169f:	48 89 e5             	mov    %rsp,%rbp
  8016a2:	53                   	push   %rbx
  8016a3:	48 83 ec 48          	sub    $0x48,%rsp
  8016a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016aa:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016b1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016b5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016b9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016c4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016c8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016cc:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016d0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016d4:	4c 89 c3             	mov    %r8,%rbx
  8016d7:	cd 30                	int    $0x30
  8016d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016e1:	74 3e                	je     801721 <syscall+0x83>
  8016e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016e8:	7e 37                	jle    801721 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f1:	49 89 d0             	mov    %rdx,%r8
  8016f4:	89 c1                	mov    %eax,%ecx
  8016f6:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  8016fd:	00 00 00 
  801700:	be 23 00 00 00       	mov    $0x23,%esi
  801705:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  80170c:	00 00 00 
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	49 b9 22 42 80 00 00 	movabs $0x804222,%r9
  80171b:	00 00 00 
  80171e:	41 ff d1             	callq  *%r9

	return ret;
  801721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801725:	48 83 c4 48          	add    $0x48,%rsp
  801729:	5b                   	pop    %rbx
  80172a:	5d                   	pop    %rbp
  80172b:	c3                   	retq   

000000000080172c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 20          	sub    $0x20,%rsp
  801734:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801738:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80173c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801740:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801744:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80174b:	00 
  80174c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801752:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801758:	48 89 d1             	mov    %rdx,%rcx
  80175b:	48 89 c2             	mov    %rax,%rdx
  80175e:	be 00 00 00 00       	mov    $0x0,%esi
  801763:	bf 00 00 00 00       	mov    $0x0,%edi
  801768:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
}
  801774:	c9                   	leaveq 
  801775:	c3                   	retq   

0000000000801776 <sys_cgetc>:

int
sys_cgetc(void)
{
  801776:	55                   	push   %rbp
  801777:	48 89 e5             	mov    %rsp,%rbp
  80177a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80177e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801785:	00 
  801786:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801792:	b9 00 00 00 00       	mov    $0x0,%ecx
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	be 00 00 00 00       	mov    $0x0,%esi
  8017a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8017a6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
  8017bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c2:	48 98                	cltq   
  8017c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cb:	00 
  8017cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017dd:	48 89 c2             	mov    %rax,%rdx
  8017e0:	be 01 00 00 00       	mov    $0x1,%esi
  8017e5:	bf 03 00 00 00       	mov    $0x3,%edi
  8017ea:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8017f1:	00 00 00 
  8017f4:	ff d0                	callq  *%rax
}
  8017f6:	c9                   	leaveq 
  8017f7:	c3                   	retq   

00000000008017f8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017f8:	55                   	push   %rbp
  8017f9:	48 89 e5             	mov    %rsp,%rbp
  8017fc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801800:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801807:	00 
  801808:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801814:	b9 00 00 00 00       	mov    $0x0,%ecx
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	be 00 00 00 00       	mov    $0x0,%esi
  801823:	bf 02 00 00 00       	mov    $0x2,%edi
  801828:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_yield>:

void
sys_yield(void)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80183e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801845:	00 
  801846:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801852:	b9 00 00 00 00       	mov    $0x0,%ecx
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	bf 0b 00 00 00       	mov    $0xb,%edi
  801866:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
}
  801872:	c9                   	leaveq 
  801873:	c3                   	retq   

0000000000801874 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 20          	sub    $0x20,%rsp
  80187c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801883:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801886:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801889:	48 63 c8             	movslq %eax,%rcx
  80188c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801893:	48 98                	cltq   
  801895:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189c:	00 
  80189d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a3:	49 89 c8             	mov    %rcx,%r8
  8018a6:	48 89 d1             	mov    %rdx,%rcx
  8018a9:	48 89 c2             	mov    %rax,%rdx
  8018ac:	be 01 00 00 00       	mov    $0x1,%esi
  8018b1:	bf 04 00 00 00       	mov    $0x4,%edi
  8018b6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
}
  8018c2:	c9                   	leaveq 
  8018c3:	c3                   	retq   

00000000008018c4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 30          	sub    $0x30,%rsp
  8018cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018da:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e1:	48 63 c8             	movslq %eax,%rcx
  8018e4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018eb:	48 63 f0             	movslq %eax,%rsi
  8018ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f5:	48 98                	cltq   
  8018f7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018fb:	49 89 f9             	mov    %rdi,%r9
  8018fe:	49 89 f0             	mov    %rsi,%r8
  801901:	48 89 d1             	mov    %rdx,%rcx
  801904:	48 89 c2             	mov    %rax,%rdx
  801907:	be 01 00 00 00       	mov    $0x1,%esi
  80190c:	bf 05 00 00 00       	mov    $0x5,%edi
  801911:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801918:	00 00 00 
  80191b:	ff d0                	callq  *%rax
}
  80191d:	c9                   	leaveq 
  80191e:	c3                   	retq   

000000000080191f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80191f:	55                   	push   %rbp
  801920:	48 89 e5             	mov    %rsp,%rbp
  801923:	48 83 ec 20          	sub    $0x20,%rsp
  801927:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80192e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 98                	cltq   
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	48 89 d1             	mov    %rdx,%rcx
  80194e:	48 89 c2             	mov    %rax,%rdx
  801951:	be 01 00 00 00       	mov    $0x1,%esi
  801956:	bf 06 00 00 00       	mov    $0x6,%edi
  80195b:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	48 83 ec 10          	sub    $0x10,%rsp
  801971:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801974:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801977:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80197a:	48 63 d0             	movslq %eax,%rdx
  80197d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801980:	48 98                	cltq   
  801982:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801989:	00 
  80198a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801990:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801996:	48 89 d1             	mov    %rdx,%rcx
  801999:	48 89 c2             	mov    %rax,%rdx
  80199c:	be 01 00 00 00       	mov    $0x1,%esi
  8019a1:	bf 08 00 00 00       	mov    $0x8,%edi
  8019a6:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	callq  *%rax
}
  8019b2:	c9                   	leaveq 
  8019b3:	c3                   	retq   

00000000008019b4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 20          	sub    $0x20,%rsp
  8019bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ca:	48 98                	cltq   
  8019cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d3:	00 
  8019d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e0:	48 89 d1             	mov    %rdx,%rcx
  8019e3:	48 89 c2             	mov    %rax,%rdx
  8019e6:	be 01 00 00 00       	mov    $0x1,%esi
  8019eb:	bf 09 00 00 00       	mov    $0x9,%edi
  8019f0:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
}
  8019fc:	c9                   	leaveq 
  8019fd:	c3                   	retq   

00000000008019fe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019fe:	55                   	push   %rbp
  8019ff:	48 89 e5             	mov    %rsp,%rbp
  801a02:	48 83 ec 20          	sub    $0x20,%rsp
  801a06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a14:	48 98                	cltq   
  801a16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1d:	00 
  801a1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2a:	48 89 d1             	mov    %rdx,%rcx
  801a2d:	48 89 c2             	mov    %rax,%rdx
  801a30:	be 01 00 00 00       	mov    $0x1,%esi
  801a35:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a3a:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801a41:	00 00 00 
  801a44:	ff d0                	callq  *%rax
}
  801a46:	c9                   	leaveq 
  801a47:	c3                   	retq   

0000000000801a48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a48:	55                   	push   %rbp
  801a49:	48 89 e5             	mov    %rsp,%rbp
  801a4c:	48 83 ec 20          	sub    $0x20,%rsp
  801a50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a57:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a5b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a61:	48 63 f0             	movslq %eax,%rsi
  801a64:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	48 98                	cltq   
  801a6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a78:	00 
  801a79:	49 89 f1             	mov    %rsi,%r9
  801a7c:	49 89 c8             	mov    %rcx,%r8
  801a7f:	48 89 d1             	mov    %rdx,%rcx
  801a82:	48 89 c2             	mov    %rax,%rdx
  801a85:	be 00 00 00 00       	mov    $0x0,%esi
  801a8a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a8f:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
  801aa5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab4:	00 
  801ab5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 01 00 00 00       	mov    $0x1,%esi
  801ace:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ad3:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 20          	sub    $0x20,%rsp
  801ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b00:	00 
  801b01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0d:	48 89 d1             	mov    %rdx,%rcx
  801b10:	48 89 c2             	mov    %rax,%rdx
  801b13:	be 01 00 00 00       	mov    $0x1,%esi
  801b18:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b1d:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	callq  *%rax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   

0000000000801b2b <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801b2b:	55                   	push   %rbp
  801b2c:	48 89 e5             	mov    %rsp,%rbp
  801b2f:	48 83 ec 10          	sub    $0x10,%rsp
  801b33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b54:	48 89 c2             	mov    %rax,%rdx
  801b57:	be 00 00 00 00       	mov    $0x0,%esi
  801b5c:	bf 10 00 00 00       	mov    $0x10,%edi
  801b61:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	callq  *%rax
}
  801b6d:	c9                   	leaveq 
  801b6e:	c3                   	retq   

0000000000801b6f <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b6f:	55                   	push   %rbp
  801b70:	48 89 e5             	mov    %rsp,%rbp
  801b73:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7e:	00 
  801b7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b90:	ba 00 00 00 00       	mov    $0x0,%edx
  801b95:	be 00 00 00 00       	mov    $0x0,%esi
  801b9a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b9f:	48 b8 9e 16 80 00 00 	movabs $0x80169e,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 18          	sub    $0x18,%rsp
  801bb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bbd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bc9:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdc:	8b 00                	mov    (%rax),%eax
  801bde:	83 f8 01             	cmp    $0x1,%eax
  801be1:	7e 13                	jle    801bf6 <argstart+0x49>
  801be3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801be8:	74 0c                	je     801bf6 <argstart+0x49>
  801bea:	48 b8 13 4b 80 00 00 	movabs $0x804b13,%rax
  801bf1:	00 00 00 
  801bf4:	eb 05                	jmp    801bfb <argstart+0x4e>
  801bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bff:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c07:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c0e:	00 
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <argnext>:

int
argnext(struct Argstate *args)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 20          	sub    $0x20,%rsp
  801c19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c21:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c28:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2d:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c31:	48 85 c0             	test   %rax,%rax
  801c34:	75 0a                	jne    801c40 <argnext+0x2f>
		return -1;
  801c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c3b:	e9 25 01 00 00       	jmpq   801d65 <argnext+0x154>

	if (!*args->curarg) {
  801c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c44:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c48:	0f b6 00             	movzbl (%rax),%eax
  801c4b:	84 c0                	test   %al,%al
  801c4d:	0f 85 d7 00 00 00    	jne    801d2a <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c57:	48 8b 00             	mov    (%rax),%rax
  801c5a:	8b 00                	mov    (%rax),%eax
  801c5c:	83 f8 01             	cmp    $0x1,%eax
  801c5f:	0f 84 ef 00 00 00    	je     801d54 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801c65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c69:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c6d:	48 83 c0 08          	add    $0x8,%rax
  801c71:	48 8b 00             	mov    (%rax),%rax
  801c74:	0f b6 00             	movzbl (%rax),%eax
  801c77:	3c 2d                	cmp    $0x2d,%al
  801c79:	0f 85 d5 00 00 00    	jne    801d54 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801c7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c83:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c87:	48 83 c0 08          	add    $0x8,%rax
  801c8b:	48 8b 00             	mov    (%rax),%rax
  801c8e:	48 83 c0 01          	add    $0x1,%rax
  801c92:	0f b6 00             	movzbl (%rax),%eax
  801c95:	84 c0                	test   %al,%al
  801c97:	0f 84 b7 00 00 00    	je     801d54 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca1:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ca5:	48 83 c0 08          	add    $0x8,%rax
  801ca9:	48 8b 00             	mov    (%rax),%rax
  801cac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb4:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cbc:	48 8b 00             	mov    (%rax),%rax
  801cbf:	8b 00                	mov    (%rax),%eax
  801cc1:	83 e8 01             	sub    $0x1,%eax
  801cc4:	48 98                	cltq   
  801cc6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801ccd:	00 
  801cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cd6:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cde:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ce2:	48 83 c0 08          	add    $0x8,%rax
  801ce6:	48 89 ce             	mov    %rcx,%rsi
  801ce9:	48 89 c7             	mov    %rax,%rdi
  801cec:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax
		(*args->argc)--;
  801cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfc:	48 8b 00             	mov    (%rax),%rax
  801cff:	8b 10                	mov    (%rax),%edx
  801d01:	83 ea 01             	sub    $0x1,%edx
  801d04:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d0e:	0f b6 00             	movzbl (%rax),%eax
  801d11:	3c 2d                	cmp    $0x2d,%al
  801d13:	75 15                	jne    801d2a <argnext+0x119>
  801d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d19:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d1d:	48 83 c0 01          	add    $0x1,%rax
  801d21:	0f b6 00             	movzbl (%rax),%eax
  801d24:	84 c0                	test   %al,%al
  801d26:	75 02                	jne    801d2a <argnext+0x119>
			goto endofargs;
  801d28:	eb 2a                	jmp    801d54 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d32:	0f b6 00             	movzbl (%rax),%eax
  801d35:	0f b6 c0             	movzbl %al,%eax
  801d38:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d52:	eb 11                	jmp    801d65 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d58:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801d5f:	00 
	return -1;
  801d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801d65:	c9                   	leaveq 
  801d66:	c3                   	retq   

0000000000801d67 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801d67:	55                   	push   %rbp
  801d68:	48 89 e5             	mov    %rsp,%rbp
  801d6b:	48 83 ec 10          	sub    $0x10,%rsp
  801d6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d7b:	48 85 c0             	test   %rax,%rax
  801d7e:	74 0a                	je     801d8a <argvalue+0x23>
  801d80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d84:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d88:	eb 13                	jmp    801d9d <argvalue+0x36>
  801d8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8e:	48 89 c7             	mov    %rax,%rdi
  801d91:	48 b8 9f 1d 80 00 00 	movabs $0x801d9f,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
}
  801d9d:	c9                   	leaveq 
  801d9e:	c3                   	retq   

0000000000801d9f <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801d9f:	55                   	push   %rbp
  801da0:	48 89 e5             	mov    %rsp,%rbp
  801da3:	53                   	push   %rbx
  801da4:	48 83 ec 18          	sub    $0x18,%rsp
  801da8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db0:	48 8b 40 10          	mov    0x10(%rax),%rax
  801db4:	48 85 c0             	test   %rax,%rax
  801db7:	75 0a                	jne    801dc3 <argnextvalue+0x24>
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	e9 c8 00 00 00       	jmpq   801e8b <argnextvalue+0xec>
	if (*args->curarg) {
  801dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc7:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dcb:	0f b6 00             	movzbl (%rax),%eax
  801dce:	84 c0                	test   %al,%al
  801dd0:	74 27                	je     801df9 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801dda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dde:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de6:	48 bb 13 4b 80 00 00 	movabs $0x804b13,%rbx
  801ded:	00 00 00 
  801df0:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801df4:	e9 8a 00 00 00       	jmpq   801e83 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801df9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfd:	48 8b 00             	mov    (%rax),%rax
  801e00:	8b 00                	mov    (%rax),%eax
  801e02:	83 f8 01             	cmp    $0x1,%eax
  801e05:	7e 64                	jle    801e6b <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e17:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1f:	48 8b 00             	mov    (%rax),%rax
  801e22:	8b 00                	mov    (%rax),%eax
  801e24:	83 e8 01             	sub    $0x1,%eax
  801e27:	48 98                	cltq   
  801e29:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e30:	00 
  801e31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e35:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e39:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e41:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e45:	48 83 c0 08          	add    $0x8,%rax
  801e49:	48 89 ce             	mov    %rcx,%rsi
  801e4c:	48 89 c7             	mov    %rax,%rdi
  801e4f:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5f:	48 8b 00             	mov    (%rax),%rax
  801e62:	8b 10                	mov    (%rax),%edx
  801e64:	83 ea 01             	sub    $0x1,%edx
  801e67:	89 10                	mov    %edx,(%rax)
  801e69:	eb 18                	jmp    801e83 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6f:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801e76:	00 
		args->curarg = 0;
  801e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e7b:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e82:	00 
	}
	return (char*) args->argvalue;
  801e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e87:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801e8b:	48 83 c4 18          	add    $0x18,%rsp
  801e8f:	5b                   	pop    %rbx
  801e90:	5d                   	pop    %rbp
  801e91:	c3                   	retq   

0000000000801e92 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e92:	55                   	push   %rbp
  801e93:	48 89 e5             	mov    %rsp,%rbp
  801e96:	48 83 ec 08          	sub    $0x8,%rsp
  801e9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ea2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ea9:	ff ff ff 
  801eac:	48 01 d0             	add    %rdx,%rax
  801eaf:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801eb3:	c9                   	leaveq 
  801eb4:	c3                   	retq   

0000000000801eb5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801eb5:	55                   	push   %rbp
  801eb6:	48 89 e5             	mov    %rsp,%rbp
  801eb9:	48 83 ec 08          	sub    $0x8,%rsp
  801ebd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec5:	48 89 c7             	mov    %rax,%rdi
  801ec8:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
  801ed4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801eda:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ede:	c9                   	leaveq 
  801edf:	c3                   	retq   

0000000000801ee0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ee0:	55                   	push   %rbp
  801ee1:	48 89 e5             	mov    %rsp,%rbp
  801ee4:	48 83 ec 18          	sub    $0x18,%rsp
  801ee8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ef3:	eb 6b                	jmp    801f60 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef8:	48 98                	cltq   
  801efa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f00:	48 c1 e0 0c          	shl    $0xc,%rax
  801f04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0c:	48 c1 e8 15          	shr    $0x15,%rax
  801f10:	48 89 c2             	mov    %rax,%rdx
  801f13:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f1a:	01 00 00 
  801f1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f21:	83 e0 01             	and    $0x1,%eax
  801f24:	48 85 c0             	test   %rax,%rax
  801f27:	74 21                	je     801f4a <fd_alloc+0x6a>
  801f29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f31:	48 89 c2             	mov    %rax,%rdx
  801f34:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f3b:	01 00 00 
  801f3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f42:	83 e0 01             	and    $0x1,%eax
  801f45:	48 85 c0             	test   %rax,%rax
  801f48:	75 12                	jne    801f5c <fd_alloc+0x7c>
			*fd_store = fd;
  801f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f52:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb 1a                	jmp    801f76 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f5c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f60:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f64:	7e 8f                	jle    801ef5 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f71:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f76:	c9                   	leaveq 
  801f77:	c3                   	retq   

0000000000801f78 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	48 83 ec 20          	sub    $0x20,%rsp
  801f80:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f8b:	78 06                	js     801f93 <fd_lookup+0x1b>
  801f8d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f91:	7e 07                	jle    801f9a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f98:	eb 6c                	jmp    802006 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f9d:	48 98                	cltq   
  801f9f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fa5:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb1:	48 c1 e8 15          	shr    $0x15,%rax
  801fb5:	48 89 c2             	mov    %rax,%rdx
  801fb8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fbf:	01 00 00 
  801fc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc6:	83 e0 01             	and    $0x1,%eax
  801fc9:	48 85 c0             	test   %rax,%rax
  801fcc:	74 21                	je     801fef <fd_lookup+0x77>
  801fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd2:	48 c1 e8 0c          	shr    $0xc,%rax
  801fd6:	48 89 c2             	mov    %rax,%rdx
  801fd9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe0:	01 00 00 
  801fe3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe7:	83 e0 01             	and    $0x1,%eax
  801fea:	48 85 c0             	test   %rax,%rax
  801fed:	75 07                	jne    801ff6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ff4:	eb 10                	jmp    802006 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ffa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ffe:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	c9                   	leaveq 
  802007:	c3                   	retq   

0000000000802008 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802008:	55                   	push   %rbp
  802009:	48 89 e5             	mov    %rsp,%rbp
  80200c:	48 83 ec 30          	sub    $0x30,%rsp
  802010:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802014:	89 f0                	mov    %esi,%eax
  802016:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802019:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201d:	48 89 c7             	mov    %rax,%rdi
  802020:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  802027:	00 00 00 
  80202a:	ff d0                	callq  *%rax
  80202c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802030:	48 89 d6             	mov    %rdx,%rsi
  802033:	89 c7                	mov    %eax,%edi
  802035:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	callq  *%rax
  802041:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802044:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802048:	78 0a                	js     802054 <fd_close+0x4c>
	    || fd != fd2)
  80204a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802052:	74 12                	je     802066 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802054:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802058:	74 05                	je     80205f <fd_close+0x57>
  80205a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205d:	eb 05                	jmp    802064 <fd_close+0x5c>
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	eb 69                	jmp    8020cf <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802066:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206a:	8b 00                	mov    (%rax),%eax
  80206c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802070:	48 89 d6             	mov    %rdx,%rsi
  802073:	89 c7                	mov    %eax,%edi
  802075:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802088:	78 2a                	js     8020b4 <fd_close+0xac>
		if (dev->dev_close)
  80208a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802092:	48 85 c0             	test   %rax,%rax
  802095:	74 16                	je     8020ad <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80209f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020a3:	48 89 d7             	mov    %rdx,%rdi
  8020a6:	ff d0                	callq  *%rax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ab:	eb 07                	jmp    8020b4 <fd_close+0xac>
		else
			r = 0;
  8020ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b8:	48 89 c6             	mov    %rax,%rsi
  8020bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c0:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	callq  *%rax
	return r;
  8020cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020cf:	c9                   	leaveq 
  8020d0:	c3                   	retq   

00000000008020d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020d1:	55                   	push   %rbp
  8020d2:	48 89 e5             	mov    %rsp,%rbp
  8020d5:	48 83 ec 20          	sub    $0x20,%rsp
  8020d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e7:	eb 41                	jmp    80212a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f0:	00 00 00 
  8020f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f6:	48 63 d2             	movslq %edx,%rdx
  8020f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fd:	8b 00                	mov    (%rax),%eax
  8020ff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802102:	75 22                	jne    802126 <dev_lookup+0x55>
			*dev = devtab[i];
  802104:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80210b:	00 00 00 
  80210e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802111:	48 63 d2             	movslq %edx,%rdx
  802114:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802118:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80211c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	eb 60                	jmp    802186 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80212a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802131:	00 00 00 
  802134:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802137:	48 63 d2             	movslq %edx,%rdx
  80213a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213e:	48 85 c0             	test   %rax,%rax
  802141:	75 a6                	jne    8020e9 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802143:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80214a:	00 00 00 
  80214d:	48 8b 00             	mov    (%rax),%rax
  802150:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802156:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802159:	89 c6                	mov    %eax,%esi
  80215b:	48 bf 18 4b 80 00 00 	movabs $0x804b18,%rdi
  802162:	00 00 00 
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
  80216a:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  802171:	00 00 00 
  802174:	ff d1                	callq  *%rcx
	*dev = 0;
  802176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802181:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <close>:

int
close(int fdnum)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
  80218c:	48 83 ec 20          	sub    $0x20,%rsp
  802190:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802193:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802197:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80219a:	48 89 d6             	mov    %rdx,%rsi
  80219d:	89 c7                	mov    %eax,%edi
  80219f:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	callq  *%rax
  8021ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b2:	79 05                	jns    8021b9 <close+0x31>
		return r;
  8021b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b7:	eb 18                	jmp    8021d1 <close+0x49>
	else
		return fd_close(fd, 1);
  8021b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021bd:	be 01 00 00 00       	mov    $0x1,%esi
  8021c2:	48 89 c7             	mov    %rax,%rdi
  8021c5:	48 b8 08 20 80 00 00 	movabs $0x802008,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
}
  8021d1:	c9                   	leaveq 
  8021d2:	c3                   	retq   

00000000008021d3 <close_all>:

void
close_all(void)
{
  8021d3:	55                   	push   %rbp
  8021d4:	48 89 e5             	mov    %rsp,%rbp
  8021d7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021e2:	eb 15                	jmp    8021f9 <close_all+0x26>
		close(i);
  8021e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e7:	89 c7                	mov    %eax,%edi
  8021e9:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021f9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021fd:	7e e5                	jle    8021e4 <close_all+0x11>
		close(i);
}
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 40          	sub    $0x40,%rsp
  802209:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80220c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80220f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802213:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802216:	48 89 d6             	mov    %rdx,%rsi
  802219:	89 c7                	mov    %eax,%edi
  80221b:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax
  802227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222e:	79 08                	jns    802238 <dup+0x37>
		return r;
  802230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802233:	e9 70 01 00 00       	jmpq   8023a8 <dup+0x1a7>
	close(newfdnum);
  802238:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80223b:	89 c7                	mov    %eax,%edi
  80223d:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802244:	00 00 00 
  802247:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802249:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80224c:	48 98                	cltq   
  80224e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802254:	48 c1 e0 0c          	shl    $0xc,%rax
  802258:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80225c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802260:	48 89 c7             	mov    %rax,%rdi
  802263:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802277:	48 89 c7             	mov    %rax,%rdi
  80227a:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
  802286:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80228a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228e:	48 c1 e8 15          	shr    $0x15,%rax
  802292:	48 89 c2             	mov    %rax,%rdx
  802295:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80229c:	01 00 00 
  80229f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a3:	83 e0 01             	and    $0x1,%eax
  8022a6:	48 85 c0             	test   %rax,%rax
  8022a9:	74 73                	je     80231e <dup+0x11d>
  8022ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022af:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b3:	48 89 c2             	mov    %rax,%rdx
  8022b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022bd:	01 00 00 
  8022c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c4:	83 e0 01             	and    $0x1,%eax
  8022c7:	48 85 c0             	test   %rax,%rax
  8022ca:	74 52                	je     80231e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8022d4:	48 89 c2             	mov    %rax,%rdx
  8022d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022de:	01 00 00 
  8022e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8022ea:	89 c1                	mov    %eax,%ecx
  8022ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f4:	41 89 c8             	mov    %ecx,%r8d
  8022f7:	48 89 d1             	mov    %rdx,%rcx
  8022fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ff:	48 89 c6             	mov    %rax,%rsi
  802302:	bf 00 00 00 00       	mov    $0x0,%edi
  802307:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231a:	79 02                	jns    80231e <dup+0x11d>
			goto err;
  80231c:	eb 57                	jmp    802375 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80231e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802322:	48 c1 e8 0c          	shr    $0xc,%rax
  802326:	48 89 c2             	mov    %rax,%rdx
  802329:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802330:	01 00 00 
  802333:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802337:	25 07 0e 00 00       	and    $0xe07,%eax
  80233c:	89 c1                	mov    %eax,%ecx
  80233e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802346:	41 89 c8             	mov    %ecx,%r8d
  802349:	48 89 d1             	mov    %rdx,%rcx
  80234c:	ba 00 00 00 00       	mov    $0x0,%edx
  802351:	48 89 c6             	mov    %rax,%rsi
  802354:	bf 00 00 00 00       	mov    $0x0,%edi
  802359:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax
  802365:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236c:	79 02                	jns    802370 <dup+0x16f>
		goto err;
  80236e:	eb 05                	jmp    802375 <dup+0x174>

	return newfdnum;
  802370:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802373:	eb 33                	jmp    8023a8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802379:	48 89 c6             	mov    %rax,%rsi
  80237c:	bf 00 00 00 00       	mov    $0x0,%edi
  802381:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80238d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802391:	48 89 c6             	mov    %rax,%rsi
  802394:	bf 00 00 00 00       	mov    $0x0,%edi
  802399:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	callq  *%rax
	return r;
  8023a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a8:	c9                   	leaveq 
  8023a9:	c3                   	retq   

00000000008023aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023aa:	55                   	push   %rbp
  8023ab:	48 89 e5             	mov    %rsp,%rbp
  8023ae:	48 83 ec 40          	sub    $0x40,%rsp
  8023b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c4:	48 89 d6             	mov    %rdx,%rsi
  8023c7:	89 c7                	mov    %eax,%edi
  8023c9:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8023d0:	00 00 00 
  8023d3:	ff d0                	callq  *%rax
  8023d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023dc:	78 24                	js     802402 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e2:	8b 00                	mov    (%rax),%eax
  8023e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e8:	48 89 d6             	mov    %rdx,%rsi
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802400:	79 05                	jns    802407 <read+0x5d>
		return r;
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	eb 76                	jmp    80247d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240b:	8b 40 08             	mov    0x8(%rax),%eax
  80240e:	83 e0 03             	and    $0x3,%eax
  802411:	83 f8 01             	cmp    $0x1,%eax
  802414:	75 3a                	jne    802450 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802416:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80241d:	00 00 00 
  802420:	48 8b 00             	mov    (%rax),%rax
  802423:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802429:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80242c:	89 c6                	mov    %eax,%esi
  80242e:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  802435:	00 00 00 
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
  80243d:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  802444:	00 00 00 
  802447:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244e:	eb 2d                	jmp    80247d <read+0xd3>
	}
	if (!dev->dev_read)
  802450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802454:	48 8b 40 10          	mov    0x10(%rax),%rax
  802458:	48 85 c0             	test   %rax,%rax
  80245b:	75 07                	jne    802464 <read+0xba>
		return -E_NOT_SUPP;
  80245d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802462:	eb 19                	jmp    80247d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802468:	48 8b 40 10          	mov    0x10(%rax),%rax
  80246c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802470:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802474:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802478:	48 89 cf             	mov    %rcx,%rdi
  80247b:	ff d0                	callq  *%rax
}
  80247d:	c9                   	leaveq 
  80247e:	c3                   	retq   

000000000080247f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80247f:	55                   	push   %rbp
  802480:	48 89 e5             	mov    %rsp,%rbp
  802483:	48 83 ec 30          	sub    $0x30,%rsp
  802487:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80248a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80248e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802499:	eb 49                	jmp    8024e4 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80249b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249e:	48 98                	cltq   
  8024a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024a4:	48 29 c2             	sub    %rax,%rdx
  8024a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024aa:	48 63 c8             	movslq %eax,%rcx
  8024ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b1:	48 01 c1             	add    %rax,%rcx
  8024b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b7:	48 89 ce             	mov    %rcx,%rsi
  8024ba:	89 c7                	mov    %eax,%edi
  8024bc:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  8024c3:	00 00 00 
  8024c6:	ff d0                	callq  *%rax
  8024c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024cf:	79 05                	jns    8024d6 <readn+0x57>
			return m;
  8024d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024d4:	eb 1c                	jmp    8024f2 <readn+0x73>
		if (m == 0)
  8024d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024da:	75 02                	jne    8024de <readn+0x5f>
			break;
  8024dc:	eb 11                	jmp    8024ef <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e7:	48 98                	cltq   
  8024e9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024ed:	72 ac                	jb     80249b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024f2:	c9                   	leaveq 
  8024f3:	c3                   	retq   

00000000008024f4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024f4:	55                   	push   %rbp
  8024f5:	48 89 e5             	mov    %rsp,%rbp
  8024f8:	48 83 ec 40          	sub    $0x40,%rsp
  8024fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802503:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802507:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80250b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250e:	48 89 d6             	mov    %rdx,%rsi
  802511:	89 c7                	mov    %eax,%edi
  802513:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	callq  *%rax
  80251f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802522:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802526:	78 24                	js     80254c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252c:	8b 00                	mov    (%rax),%eax
  80252e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802532:	48 89 d6             	mov    %rdx,%rsi
  802535:	89 c7                	mov    %eax,%edi
  802537:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  80253e:	00 00 00 
  802541:	ff d0                	callq  *%rax
  802543:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254a:	79 05                	jns    802551 <write+0x5d>
		return r;
  80254c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254f:	eb 75                	jmp    8025c6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802555:	8b 40 08             	mov    0x8(%rax),%eax
  802558:	83 e0 03             	and    $0x3,%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	75 3a                	jne    802599 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80255f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802566:	00 00 00 
  802569:	48 8b 00             	mov    (%rax),%rax
  80256c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802572:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802575:	89 c6                	mov    %eax,%esi
  802577:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  80257e:	00 00 00 
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  80258d:	00 00 00 
  802590:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802592:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802597:	eb 2d                	jmp    8025c6 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259d:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025a1:	48 85 c0             	test   %rax,%rax
  8025a4:	75 07                	jne    8025ad <write+0xb9>
		return -E_NOT_SUPP;
  8025a6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ab:	eb 19                	jmp    8025c6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8025ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025b5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025bd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025c1:	48 89 cf             	mov    %rcx,%rdi
  8025c4:	ff d0                	callq  *%rax
}
  8025c6:	c9                   	leaveq 
  8025c7:	c3                   	retq   

00000000008025c8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025c8:	55                   	push   %rbp
  8025c9:	48 89 e5             	mov    %rsp,%rbp
  8025cc:	48 83 ec 18          	sub    $0x18,%rsp
  8025d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025dd:	48 89 d6             	mov    %rdx,%rsi
  8025e0:	89 c7                	mov    %eax,%edi
  8025e2:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8025e9:	00 00 00 
  8025ec:	ff d0                	callq  *%rax
  8025ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f5:	79 05                	jns    8025fc <seek+0x34>
		return r;
  8025f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fa:	eb 0f                	jmp    80260b <seek+0x43>
	fd->fd_offset = offset;
  8025fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802600:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802603:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260b:	c9                   	leaveq 
  80260c:	c3                   	retq   

000000000080260d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80260d:	55                   	push   %rbp
  80260e:	48 89 e5             	mov    %rsp,%rbp
  802611:	48 83 ec 30          	sub    $0x30,%rsp
  802615:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802618:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80261f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802622:	48 89 d6             	mov    %rdx,%rsi
  802625:	89 c7                	mov    %eax,%edi
  802627:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
  802633:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263a:	78 24                	js     802660 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802640:	8b 00                	mov    (%rax),%eax
  802642:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802646:	48 89 d6             	mov    %rdx,%rsi
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	79 05                	jns    802665 <ftruncate+0x58>
		return r;
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	eb 72                	jmp    8026d7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802669:	8b 40 08             	mov    0x8(%rax),%eax
  80266c:	83 e0 03             	and    $0x3,%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 3a                	jne    8026ad <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802673:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80267a:	00 00 00 
  80267d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802680:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802686:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802689:	89 c6                	mov    %eax,%esi
  80268b:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  802692:	00 00 00 
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	48 b9 90 03 80 00 00 	movabs $0x800390,%rcx
  8026a1:	00 00 00 
  8026a4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ab:	eb 2a                	jmp    8026d7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b5:	48 85 c0             	test   %rax,%rax
  8026b8:	75 07                	jne    8026c1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026bf:	eb 16                	jmp    8026d7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026cd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026d0:	89 ce                	mov    %ecx,%esi
  8026d2:	48 89 d7             	mov    %rdx,%rdi
  8026d5:	ff d0                	callq  *%rax
}
  8026d7:	c9                   	leaveq 
  8026d8:	c3                   	retq   

00000000008026d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026d9:	55                   	push   %rbp
  8026da:	48 89 e5             	mov    %rsp,%rbp
  8026dd:	48 83 ec 30          	sub    $0x30,%rsp
  8026e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026ef:	48 89 d6             	mov    %rdx,%rsi
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802707:	78 24                	js     80272d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270d:	8b 00                	mov    (%rax),%eax
  80270f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	89 c7                	mov    %eax,%edi
  802718:	48 b8 d1 20 80 00 00 	movabs $0x8020d1,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
  802724:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272b:	79 05                	jns    802732 <fstat+0x59>
		return r;
  80272d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802730:	eb 5e                	jmp    802790 <fstat+0xb7>
	if (!dev->dev_stat)
  802732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802736:	48 8b 40 28          	mov    0x28(%rax),%rax
  80273a:	48 85 c0             	test   %rax,%rax
  80273d:	75 07                	jne    802746 <fstat+0x6d>
		return -E_NOT_SUPP;
  80273f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802744:	eb 4a                	jmp    802790 <fstat+0xb7>
	stat->st_name[0] = 0;
  802746:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80274a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80274d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802751:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802758:	00 00 00 
	stat->st_isdir = 0;
  80275b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802766:	00 00 00 
	stat->st_dev = dev;
  802769:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80276d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802771:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802780:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802784:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802788:	48 89 ce             	mov    %rcx,%rsi
  80278b:	48 89 d7             	mov    %rdx,%rdi
  80278e:	ff d0                	callq  *%rax
}
  802790:	c9                   	leaveq 
  802791:	c3                   	retq   

0000000000802792 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802792:	55                   	push   %rbp
  802793:	48 89 e5             	mov    %rsp,%rbp
  802796:	48 83 ec 20          	sub    $0x20,%rsp
  80279a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80279e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a6:	be 00 00 00 00       	mov    $0x0,%esi
  8027ab:	48 89 c7             	mov    %rax,%rdi
  8027ae:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  8027b5:	00 00 00 
  8027b8:	ff d0                	callq  *%rax
  8027ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c1:	79 05                	jns    8027c8 <stat+0x36>
		return fd;
  8027c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c6:	eb 2f                	jmp    8027f7 <stat+0x65>
	r = fstat(fd, stat);
  8027c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cf:	48 89 d6             	mov    %rdx,%rsi
  8027d2:	89 c7                	mov    %eax,%edi
  8027d4:	48 b8 d9 26 80 00 00 	movabs $0x8026d9,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e6:	89 c7                	mov    %eax,%edi
  8027e8:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
	return r;
  8027f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027f7:	c9                   	leaveq 
  8027f8:	c3                   	retq   

00000000008027f9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027f9:	55                   	push   %rbp
  8027fa:	48 89 e5             	mov    %rsp,%rbp
  8027fd:	48 83 ec 10          	sub    $0x10,%rsp
  802801:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802804:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802808:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80280f:	00 00 00 
  802812:	8b 00                	mov    (%rax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	75 1d                	jne    802835 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802818:	bf 01 00 00 00       	mov    $0x1,%edi
  80281d:	48 b8 9e 44 80 00 00 	movabs $0x80449e,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
  802829:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802830:	00 00 00 
  802833:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802835:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283c:	00 00 00 
  80283f:	8b 00                	mov    (%rax),%eax
  802841:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802844:	b9 07 00 00 00       	mov    $0x7,%ecx
  802849:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802850:	00 00 00 
  802853:	89 c7                	mov    %eax,%edi
  802855:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802865:	ba 00 00 00 00       	mov    $0x0,%edx
  80286a:	48 89 c6             	mov    %rax,%rsi
  80286d:	bf 00 00 00 00       	mov    $0x0,%edi
  802872:	48 b8 36 43 80 00 00 	movabs $0x804336,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
}
  80287e:	c9                   	leaveq 
  80287f:	c3                   	retq   

0000000000802880 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802880:	55                   	push   %rbp
  802881:	48 89 e5             	mov    %rsp,%rbp
  802884:	48 83 ec 30          	sub    $0x30,%rsp
  802888:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80288c:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80288f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802896:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80289d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8028a4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028a9:	75 08                	jne    8028b3 <open+0x33>
	{
		return r;
  8028ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ae:	e9 f2 00 00 00       	jmpq   8029a5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8028b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b7:	48 89 c7             	mov    %rax,%rdi
  8028ba:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  8028c1:	00 00 00 
  8028c4:	ff d0                	callq  *%rax
  8028c6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028c9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028d0:	7e 0a                	jle    8028dc <open+0x5c>
	{
		return -E_BAD_PATH;
  8028d2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028d7:	e9 c9 00 00 00       	jmpq   8029a5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028dc:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028e3:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028e4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028e8:	48 89 c7             	mov    %rax,%rdi
  8028eb:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  8028f2:	00 00 00 
  8028f5:	ff d0                	callq  *%rax
  8028f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fe:	78 09                	js     802909 <open+0x89>
  802900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802904:	48 85 c0             	test   %rax,%rax
  802907:	75 08                	jne    802911 <open+0x91>
		{
			return r;
  802909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290c:	e9 94 00 00 00       	jmpq   8029a5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802915:	ba 00 04 00 00       	mov    $0x400,%edx
  80291a:	48 89 c6             	mov    %rax,%rsi
  80291d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802924:	00 00 00 
  802927:	48 b8 d7 0f 80 00 00 	movabs $0x800fd7,%rax
  80292e:	00 00 00 
  802931:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802933:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80293a:	00 00 00 
  80293d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802940:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294a:	48 89 c6             	mov    %rax,%rsi
  80294d:	bf 01 00 00 00       	mov    $0x1,%edi
  802952:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802959:	00 00 00 
  80295c:	ff d0                	callq  *%rax
  80295e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802961:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802965:	79 2b                	jns    802992 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296b:	be 00 00 00 00       	mov    $0x0,%esi
  802970:	48 89 c7             	mov    %rax,%rdi
  802973:	48 b8 08 20 80 00 00 	movabs $0x802008,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
  80297f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802982:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802986:	79 05                	jns    80298d <open+0x10d>
			{
				return d;
  802988:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80298b:	eb 18                	jmp    8029a5 <open+0x125>
			}
			return r;
  80298d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802990:	eb 13                	jmp    8029a5 <open+0x125>
		}	
		return fd2num(fd_store);
  802992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802996:	48 89 c7             	mov    %rax,%rdi
  802999:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8029a5:	c9                   	leaveq 
  8029a6:	c3                   	retq   

00000000008029a7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029a7:	55                   	push   %rbp
  8029a8:	48 89 e5             	mov    %rsp,%rbp
  8029ab:	48 83 ec 10          	sub    $0x10,%rsp
  8029af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c1:	00 00 00 
  8029c4:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029c6:	be 00 00 00 00       	mov    $0x0,%esi
  8029cb:	bf 06 00 00 00       	mov    $0x6,%edi
  8029d0:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
}
  8029dc:	c9                   	leaveq 
  8029dd:	c3                   	retq   

00000000008029de <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029de:	55                   	push   %rbp
  8029df:	48 89 e5             	mov    %rsp,%rbp
  8029e2:	48 83 ec 30          	sub    $0x30,%rsp
  8029e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029fe:	74 07                	je     802a07 <devfile_read+0x29>
  802a00:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a05:	75 07                	jne    802a0e <devfile_read+0x30>
		return -E_INVAL;
  802a07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a0c:	eb 77                	jmp    802a85 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a12:	8b 50 0c             	mov    0xc(%rax),%edx
  802a15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1c:	00 00 00 
  802a1f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a21:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a28:	00 00 00 
  802a2b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a2f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a33:	be 00 00 00 00       	mov    $0x0,%esi
  802a38:	bf 03 00 00 00       	mov    $0x3,%edi
  802a3d:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
  802a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a50:	7f 05                	jg     802a57 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a55:	eb 2e                	jmp    802a85 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5a:	48 63 d0             	movslq %eax,%rdx
  802a5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a61:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a68:	00 00 00 
  802a6b:	48 89 c7             	mov    %rax,%rdi
  802a6e:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802a75:	00 00 00 
  802a78:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a85:	c9                   	leaveq 
  802a86:	c3                   	retq   

0000000000802a87 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a87:	55                   	push   %rbp
  802a88:	48 89 e5             	mov    %rsp,%rbp
  802a8b:	48 83 ec 30          	sub    $0x30,%rsp
  802a8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a97:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a9b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802aa2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802aa7:	74 07                	je     802ab0 <devfile_write+0x29>
  802aa9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802aae:	75 08                	jne    802ab8 <devfile_write+0x31>
		return r;
  802ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab3:	e9 9a 00 00 00       	jmpq   802b52 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abc:	8b 50 0c             	mov    0xc(%rax),%edx
  802abf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac6:	00 00 00 
  802ac9:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802acb:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ad2:	00 
  802ad3:	76 08                	jbe    802add <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ad5:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802adc:	00 
	}
	fsipcbuf.write.req_n = n;
  802add:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae4:	00 00 00 
  802ae7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aeb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802aef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af7:	48 89 c6             	mov    %rax,%rsi
  802afa:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802b01:	00 00 00 
  802b04:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802b10:	be 00 00 00 00       	mov    $0x0,%esi
  802b15:	bf 04 00 00 00       	mov    $0x4,%edi
  802b1a:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
  802b26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2d:	7f 20                	jg     802b4f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b2f:	48 bf 96 4b 80 00 00 	movabs $0x804b96,%rdi
  802b36:	00 00 00 
  802b39:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3e:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802b45:	00 00 00 
  802b48:	ff d2                	callq  *%rdx
		return r;
  802b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4d:	eb 03                	jmp    802b52 <devfile_write+0xcb>
	}
	return r;
  802b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b52:	c9                   	leaveq 
  802b53:	c3                   	retq   

0000000000802b54 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b54:	55                   	push   %rbp
  802b55:	48 89 e5             	mov    %rsp,%rbp
  802b58:	48 83 ec 20          	sub    $0x20,%rsp
  802b5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b68:	8b 50 0c             	mov    0xc(%rax),%edx
  802b6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b72:	00 00 00 
  802b75:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b77:	be 00 00 00 00       	mov    $0x0,%esi
  802b7c:	bf 05 00 00 00       	mov    $0x5,%edi
  802b81:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
  802b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b94:	79 05                	jns    802b9b <devfile_stat+0x47>
		return r;
  802b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b99:	eb 56                	jmp    802bf1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ba6:	00 00 00 
  802ba9:	48 89 c7             	mov    %rax,%rdi
  802bac:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bb8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbf:	00 00 00 
  802bc2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bd2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd9:	00 00 00 
  802bdc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802be2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf1:	c9                   	leaveq 
  802bf2:	c3                   	retq   

0000000000802bf3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bf3:	55                   	push   %rbp
  802bf4:	48 89 e5             	mov    %rsp,%rbp
  802bf7:	48 83 ec 10          	sub    $0x10,%rsp
  802bfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c06:	8b 50 0c             	mov    0xc(%rax),%edx
  802c09:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c10:	00 00 00 
  802c13:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c1c:	00 00 00 
  802c1f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c22:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c25:	be 00 00 00 00       	mov    $0x0,%esi
  802c2a:	bf 02 00 00 00       	mov    $0x2,%edi
  802c2f:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
}
  802c3b:	c9                   	leaveq 
  802c3c:	c3                   	retq   

0000000000802c3d <remove>:

// Delete a file
int
remove(const char *path)
{
  802c3d:	55                   	push   %rbp
  802c3e:	48 89 e5             	mov    %rsp,%rbp
  802c41:	48 83 ec 10          	sub    $0x10,%rsp
  802c45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c4d:	48 89 c7             	mov    %rax,%rdi
  802c50:	48 b8 d9 0e 80 00 00 	movabs $0x800ed9,%rax
  802c57:	00 00 00 
  802c5a:	ff d0                	callq  *%rax
  802c5c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c61:	7e 07                	jle    802c6a <remove+0x2d>
		return -E_BAD_PATH;
  802c63:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c68:	eb 33                	jmp    802c9d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c6e:	48 89 c6             	mov    %rax,%rsi
  802c71:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c78:	00 00 00 
  802c7b:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c87:	be 00 00 00 00       	mov    $0x0,%esi
  802c8c:	bf 07 00 00 00       	mov    $0x7,%edi
  802c91:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
}
  802c9d:	c9                   	leaveq 
  802c9e:	c3                   	retq   

0000000000802c9f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ca3:	be 00 00 00 00       	mov    $0x0,%esi
  802ca8:	bf 08 00 00 00       	mov    $0x8,%edi
  802cad:	48 b8 f9 27 80 00 00 	movabs $0x8027f9,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
}
  802cb9:	5d                   	pop    %rbp
  802cba:	c3                   	retq   

0000000000802cbb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cbb:	55                   	push   %rbp
  802cbc:	48 89 e5             	mov    %rsp,%rbp
  802cbf:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cc6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ccd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cd4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cdb:	be 00 00 00 00       	mov    $0x0,%esi
  802ce0:	48 89 c7             	mov    %rax,%rdi
  802ce3:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf6:	79 28                	jns    802d20 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfb:	89 c6                	mov    %eax,%esi
  802cfd:	48 bf b2 4b 80 00 00 	movabs $0x804bb2,%rdi
  802d04:	00 00 00 
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0c:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802d13:	00 00 00 
  802d16:	ff d2                	callq  *%rdx
		return fd_src;
  802d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1b:	e9 74 01 00 00       	jmpq   802e94 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d20:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d27:	be 01 01 00 00       	mov    $0x101,%esi
  802d2c:	48 89 c7             	mov    %rax,%rdi
  802d2f:	48 b8 80 28 80 00 00 	movabs $0x802880,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
  802d3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d42:	79 39                	jns    802d7d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d47:	89 c6                	mov    %eax,%esi
  802d49:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  802d50:	00 00 00 
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802d5f:	00 00 00 
  802d62:	ff d2                	callq  *%rdx
		close(fd_src);
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
		return fd_dest;
  802d75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d78:	e9 17 01 00 00       	jmpq   802e94 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d7d:	eb 74                	jmp    802df3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d82:	48 63 d0             	movslq %eax,%rdx
  802d85:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8f:	48 89 ce             	mov    %rcx,%rsi
  802d92:	89 c7                	mov    %eax,%edi
  802d94:	48 b8 f4 24 80 00 00 	movabs $0x8024f4,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
  802da0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802da7:	79 4a                	jns    802df3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802da9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dac:	89 c6                	mov    %eax,%esi
  802dae:	48 bf e2 4b 80 00 00 	movabs $0x804be2,%rdi
  802db5:	00 00 00 
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbd:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802dc4:	00 00 00 
  802dc7:	ff d2                	callq  *%rdx
			close(fd_src);
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802dd5:	00 00 00 
  802dd8:	ff d0                	callq  *%rax
			close(fd_dest);
  802dda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddd:	89 c7                	mov    %eax,%edi
  802ddf:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax
			return write_size;
  802deb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dee:	e9 a1 00 00 00       	jmpq   802e94 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802df3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	ba 00 02 00 00       	mov    $0x200,%edx
  802e02:	48 89 ce             	mov    %rcx,%rsi
  802e05:	89 c7                	mov    %eax,%edi
  802e07:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
  802e13:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e1a:	0f 8f 5f ff ff ff    	jg     802d7f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e24:	79 47                	jns    802e6d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e26:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e29:	89 c6                	mov    %eax,%esi
  802e2b:	48 bf f5 4b 80 00 00 	movabs $0x804bf5,%rdi
  802e32:	00 00 00 
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  802e41:	00 00 00 
  802e44:	ff d2                	callq  *%rdx
		close(fd_src);
  802e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e49:	89 c7                	mov    %eax,%edi
  802e4b:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802e52:	00 00 00 
  802e55:	ff d0                	callq  *%rax
		close(fd_dest);
  802e57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
		return read_size;
  802e68:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e6b:	eb 27                	jmp    802e94 <copy+0x1d9>
	}
	close(fd_src);
  802e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e70:	89 c7                	mov    %eax,%edi
  802e72:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802e79:	00 00 00 
  802e7c:	ff d0                	callq  *%rax
	close(fd_dest);
  802e7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e81:	89 c7                	mov    %eax,%edi
  802e83:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	callq  *%rax
	return 0;
  802e8f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e94:	c9                   	leaveq 
  802e95:	c3                   	retq   

0000000000802e96 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e96:	55                   	push   %rbp
  802e97:	48 89 e5             	mov    %rsp,%rbp
  802e9a:	48 83 ec 20          	sub    $0x20,%rsp
  802e9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea6:	8b 40 0c             	mov    0xc(%rax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	7e 67                	jle    802f14 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb1:	8b 40 04             	mov    0x4(%rax),%eax
  802eb4:	48 63 d0             	movslq %eax,%rdx
  802eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebb:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	8b 00                	mov    (%rax),%eax
  802ec5:	48 89 ce             	mov    %rcx,%rsi
  802ec8:	89 c7                	mov    %eax,%edi
  802eca:	48 b8 f4 24 80 00 00 	movabs $0x8024f4,%rax
  802ed1:	00 00 00 
  802ed4:	ff d0                	callq  *%rax
  802ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edd:	7e 13                	jle    802ef2 <writebuf+0x5c>
			b->result += result;
  802edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee3:	8b 50 08             	mov    0x8(%rax),%edx
  802ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee9:	01 c2                	add    %eax,%edx
  802eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eef:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef6:	8b 40 04             	mov    0x4(%rax),%eax
  802ef9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802efc:	74 16                	je     802f14 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802efe:	b8 00 00 00 00       	mov    $0x0,%eax
  802f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f07:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f0b:	89 c2                	mov    %eax,%edx
  802f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f11:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f14:	c9                   	leaveq 
  802f15:	c3                   	retq   

0000000000802f16 <putch>:

static void
putch(int ch, void *thunk)
{
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	48 83 ec 20          	sub    $0x20,%rsp
  802f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f31:	8b 40 04             	mov    0x4(%rax),%eax
  802f34:	8d 48 01             	lea    0x1(%rax),%ecx
  802f37:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f3b:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f41:	89 d1                	mov    %edx,%ecx
  802f43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f47:	48 98                	cltq   
  802f49:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f51:	8b 40 04             	mov    0x4(%rax),%eax
  802f54:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f59:	75 1e                	jne    802f79 <putch+0x63>
		writebuf(b);
  802f5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5f:	48 89 c7             	mov    %rax,%rdi
  802f62:	48 b8 96 2e 80 00 00 	movabs $0x802e96,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
		b->idx = 0;
  802f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f79:	c9                   	leaveq 
  802f7a:	c3                   	retq   

0000000000802f7b <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f7b:	55                   	push   %rbp
  802f7c:	48 89 e5             	mov    %rsp,%rbp
  802f7f:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f86:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f8c:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f93:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f9a:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802fa0:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fa6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fad:	00 00 00 
	b.result = 0;
  802fb0:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802fb7:	00 00 00 
	b.error = 1;
  802fba:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802fc1:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fc4:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fcb:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802fd2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802fd9:	48 89 c6             	mov    %rax,%rsi
  802fdc:	48 bf 16 2f 80 00 00 	movabs $0x802f16,%rdi
  802fe3:	00 00 00 
  802fe6:	48 b8 43 07 80 00 00 	movabs $0x800743,%rax
  802fed:	00 00 00 
  802ff0:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ff2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	7e 16                	jle    803012 <vfprintf+0x97>
		writebuf(&b);
  802ffc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803003:	48 89 c7             	mov    %rax,%rdi
  803006:	48 b8 96 2e 80 00 00 	movabs $0x802e96,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803012:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 08                	je     803024 <vfprintf+0xa9>
  80301c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803022:	eb 06                	jmp    80302a <vfprintf+0xaf>
  803024:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80302a:	c9                   	leaveq 
  80302b:	c3                   	retq   

000000000080302c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
  803030:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803037:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80303d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803044:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80304b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803052:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803059:	84 c0                	test   %al,%al
  80305b:	74 20                	je     80307d <fprintf+0x51>
  80305d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803061:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803065:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803069:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80306d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803071:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803075:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803079:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80307d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803084:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80308b:	00 00 00 
  80308e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803095:	00 00 00 
  803098:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030b1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030b8:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030bf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c5:	48 89 ce             	mov    %rcx,%rsi
  8030c8:	89 c7                	mov    %eax,%edi
  8030ca:	48 b8 7b 2f 80 00 00 	movabs $0x802f7b,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030dc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030e2:	c9                   	leaveq 
  8030e3:	c3                   	retq   

00000000008030e4 <printf>:

int
printf(const char *fmt, ...)
{
  8030e4:	55                   	push   %rbp
  8030e5:	48 89 e5             	mov    %rsp,%rbp
  8030e8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8030ef:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8030f6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8030fd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803104:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80310b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803112:	84 c0                	test   %al,%al
  803114:	74 20                	je     803136 <printf+0x52>
  803116:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80311a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80311e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803122:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803126:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80312a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80312e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803132:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803136:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80313d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803144:	00 00 00 
  803147:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80314e:	00 00 00 
  803151:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803155:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80315c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803163:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80316a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803171:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803178:	48 89 c6             	mov    %rax,%rsi
  80317b:	bf 01 00 00 00       	mov    $0x1,%edi
  803180:	48 b8 7b 2f 80 00 00 	movabs $0x802f7b,%rax
  803187:	00 00 00 
  80318a:	ff d0                	callq  *%rax
  80318c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803192:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803198:	c9                   	leaveq 
  803199:	c3                   	retq   

000000000080319a <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80319a:	55                   	push   %rbp
  80319b:	48 89 e5             	mov    %rsp,%rbp
  80319e:	48 83 ec 20          	sub    $0x20,%rsp
  8031a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ac:	48 89 d6             	mov    %rdx,%rsi
  8031af:	89 c7                	mov    %eax,%edi
  8031b1:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
  8031bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c4:	79 05                	jns    8031cb <fd2sockid+0x31>
		return r;
  8031c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c9:	eb 24                	jmp    8031ef <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8031cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031cf:	8b 10                	mov    (%rax),%edx
  8031d1:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8031d8:	00 00 00 
  8031db:	8b 00                	mov    (%rax),%eax
  8031dd:	39 c2                	cmp    %eax,%edx
  8031df:	74 07                	je     8031e8 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8031e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031e6:	eb 07                	jmp    8031ef <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8031e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ec:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
  8031f5:	48 83 ec 20          	sub    $0x20,%rsp
  8031f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8031fc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803200:	48 89 c7             	mov    %rax,%rdi
  803203:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
  80320f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803216:	78 26                	js     80323e <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321c:	ba 07 04 00 00       	mov    $0x407,%edx
  803221:	48 89 c6             	mov    %rax,%rsi
  803224:	bf 00 00 00 00       	mov    $0x0,%edi
  803229:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
  803235:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803238:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323c:	79 16                	jns    803254 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80323e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803241:	89 c7                	mov    %eax,%edi
  803243:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
		return r;
  80324f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803252:	eb 3a                	jmp    80328e <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803258:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80325f:	00 00 00 
  803262:	8b 12                	mov    (%rdx),%edx
  803264:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803278:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80327b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327f:	48 89 c7             	mov    %rax,%rdi
  803282:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
}
  80328e:	c9                   	leaveq 
  80328f:	c3                   	retq   

0000000000803290 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803290:	55                   	push   %rbp
  803291:	48 89 e5             	mov    %rsp,%rbp
  803294:	48 83 ec 30          	sub    $0x30,%rsp
  803298:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80329b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80329f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a6:	89 c7                	mov    %eax,%edi
  8032a8:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bb:	79 05                	jns    8032c2 <accept+0x32>
		return r;
  8032bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c0:	eb 3b                	jmp    8032fd <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cd:	48 89 ce             	mov    %rcx,%rsi
  8032d0:	89 c7                	mov    %eax,%edi
  8032d2:	48 b8 db 35 80 00 00 	movabs $0x8035db,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
  8032de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e5:	79 05                	jns    8032ec <accept+0x5c>
		return r;
  8032e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ea:	eb 11                	jmp    8032fd <accept+0x6d>
	return alloc_sockfd(r);
  8032ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ef:	89 c7                	mov    %eax,%edi
  8032f1:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
}
  8032fd:	c9                   	leaveq 
  8032fe:	c3                   	retq   

00000000008032ff <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032ff:	55                   	push   %rbp
  803300:	48 89 e5             	mov    %rsp,%rbp
  803303:	48 83 ec 20          	sub    $0x20,%rsp
  803307:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80330a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803311:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803314:	89 c7                	mov    %eax,%edi
  803316:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803329:	79 05                	jns    803330 <bind+0x31>
		return r;
  80332b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332e:	eb 1b                	jmp    80334b <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803330:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803333:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333a:	48 89 ce             	mov    %rcx,%rsi
  80333d:	89 c7                	mov    %eax,%edi
  80333f:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
}
  80334b:	c9                   	leaveq 
  80334c:	c3                   	retq   

000000000080334d <shutdown>:

int
shutdown(int s, int how)
{
  80334d:	55                   	push   %rbp
  80334e:	48 89 e5             	mov    %rsp,%rbp
  803351:	48 83 ec 20          	sub    $0x20,%rsp
  803355:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803358:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80335b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335e:	89 c7                	mov    %eax,%edi
  803360:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80336f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803373:	79 05                	jns    80337a <shutdown+0x2d>
		return r;
  803375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803378:	eb 16                	jmp    803390 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80337a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803380:	89 d6                	mov    %edx,%esi
  803382:	89 c7                	mov    %eax,%edi
  803384:	48 b8 be 36 80 00 00 	movabs $0x8036be,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
}
  803390:	c9                   	leaveq 
  803391:	c3                   	retq   

0000000000803392 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	48 83 ec 10          	sub    $0x10,%rsp
  80339a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80339e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a2:	48 89 c7             	mov    %rax,%rdi
  8033a5:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
  8033b1:	83 f8 01             	cmp    $0x1,%eax
  8033b4:	75 17                	jne    8033cd <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ba:	8b 40 0c             	mov    0xc(%rax),%eax
  8033bd:	89 c7                	mov    %eax,%edi
  8033bf:	48 b8 fe 36 80 00 00 	movabs $0x8036fe,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
  8033cb:	eb 05                	jmp    8033d2 <devsock_close+0x40>
	else
		return 0;
  8033cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d2:	c9                   	leaveq 
  8033d3:	c3                   	retq   

00000000008033d4 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033d4:	55                   	push   %rbp
  8033d5:	48 89 e5             	mov    %rsp,%rbp
  8033d8:	48 83 ec 20          	sub    $0x20,%rsp
  8033dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e9:	89 c7                	mov    %eax,%edi
  8033eb:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fe:	79 05                	jns    803405 <connect+0x31>
		return r;
  803400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803403:	eb 1b                	jmp    803420 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803405:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803408:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80340c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340f:	48 89 ce             	mov    %rcx,%rsi
  803412:	89 c7                	mov    %eax,%edi
  803414:	48 b8 2b 37 80 00 00 	movabs $0x80372b,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <listen>:

int
listen(int s, int backlog)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 20          	sub    $0x20,%rsp
  80342a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80342d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803430:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803433:	89 c7                	mov    %eax,%edi
  803435:	48 b8 9a 31 80 00 00 	movabs $0x80319a,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
  803441:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803444:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803448:	79 05                	jns    80344f <listen+0x2d>
		return r;
  80344a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344d:	eb 16                	jmp    803465 <listen+0x43>
	return nsipc_listen(r, backlog);
  80344f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803455:	89 d6                	mov    %edx,%esi
  803457:	89 c7                	mov    %eax,%edi
  803459:	48 b8 8f 37 80 00 00 	movabs $0x80378f,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
}
  803465:	c9                   	leaveq 
  803466:	c3                   	retq   

0000000000803467 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803467:	55                   	push   %rbp
  803468:	48 89 e5             	mov    %rsp,%rbp
  80346b:	48 83 ec 20          	sub    $0x20,%rsp
  80346f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803473:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803477:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80347b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347f:	89 c2                	mov    %eax,%edx
  803481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803485:	8b 40 0c             	mov    0xc(%rax),%eax
  803488:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80348c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803491:	89 c7                	mov    %eax,%edi
  803493:	48 b8 cf 37 80 00 00 	movabs $0x8037cf,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 20          	sub    $0x20,%rsp
  8034a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b9:	89 c2                	mov    %eax,%edx
  8034bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bf:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 9b 38 80 00 00 	movabs $0x80389b,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 10          	sub    $0x10,%rsp
  8034e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8034eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ef:	48 be 10 4c 80 00 00 	movabs $0x804c10,%rsi
  8034f6:	00 00 00 
  8034f9:	48 89 c7             	mov    %rax,%rdi
  8034fc:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
	return 0;
  803508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80350d:	c9                   	leaveq 
  80350e:	c3                   	retq   

000000000080350f <socket>:

int
socket(int domain, int type, int protocol)
{
  80350f:	55                   	push   %rbp
  803510:	48 89 e5             	mov    %rsp,%rbp
  803513:	48 83 ec 20          	sub    $0x20,%rsp
  803517:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80351a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80351d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803520:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803523:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803526:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803529:	89 ce                	mov    %ecx,%esi
  80352b:	89 c7                	mov    %eax,%edi
  80352d:	48 b8 53 39 80 00 00 	movabs $0x803953,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803540:	79 05                	jns    803547 <socket+0x38>
		return r;
  803542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803545:	eb 11                	jmp    803558 <socket+0x49>
	return alloc_sockfd(r);
  803547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354a:	89 c7                	mov    %eax,%edi
  80354c:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
}
  803558:	c9                   	leaveq 
  803559:	c3                   	retq   

000000000080355a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80355a:	55                   	push   %rbp
  80355b:	48 89 e5             	mov    %rsp,%rbp
  80355e:	48 83 ec 10          	sub    $0x10,%rsp
  803562:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803565:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80356c:	00 00 00 
  80356f:	8b 00                	mov    (%rax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	75 1d                	jne    803592 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803575:	bf 02 00 00 00       	mov    $0x2,%edi
  80357a:	48 b8 9e 44 80 00 00 	movabs $0x80449e,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80358d:	00 00 00 
  803590:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803592:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803599:	00 00 00 
  80359c:	8b 00                	mov    (%rax),%eax
  80359e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035a1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035a6:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035ad:	00 00 00 
  8035b0:	89 c7                	mov    %eax,%edi
  8035b2:	48 b8 3c 44 80 00 00 	movabs $0x80443c,%rax
  8035b9:	00 00 00 
  8035bc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035be:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c3:	be 00 00 00 00       	mov    $0x0,%esi
  8035c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cd:	48 b8 36 43 80 00 00 	movabs $0x804336,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
}
  8035d9:	c9                   	leaveq 
  8035da:	c3                   	retq   

00000000008035db <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035db:	55                   	push   %rbp
  8035dc:	48 89 e5             	mov    %rsp,%rbp
  8035df:	48 83 ec 30          	sub    $0x30,%rsp
  8035e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8035ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f5:	00 00 00 
  8035f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035fb:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8035fd:	bf 01 00 00 00       	mov    $0x1,%edi
  803602:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  803609:	00 00 00 
  80360c:	ff d0                	callq  *%rax
  80360e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803611:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803615:	78 3e                	js     803655 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803617:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361e:	00 00 00 
  803621:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803629:	8b 40 10             	mov    0x10(%rax),%eax
  80362c:	89 c2                	mov    %eax,%edx
  80362e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803632:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803636:	48 89 ce             	mov    %rcx,%rsi
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364c:	8b 50 10             	mov    0x10(%rax),%edx
  80364f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803653:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803658:	c9                   	leaveq 
  803659:	c3                   	retq   

000000000080365a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80365a:	55                   	push   %rbp
  80365b:	48 89 e5             	mov    %rsp,%rbp
  80365e:	48 83 ec 10          	sub    $0x10,%rsp
  803662:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803669:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80366c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803673:	00 00 00 
  803676:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803679:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80367b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80367e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803682:	48 89 c6             	mov    %rax,%rsi
  803685:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80368c:	00 00 00 
  80368f:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803696:	00 00 00 
  803699:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80369b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036a2:	00 00 00 
  8036a5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036a8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036ab:	bf 02 00 00 00       	mov    $0x2,%edi
  8036b0:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
}
  8036bc:	c9                   	leaveq 
  8036bd:	c3                   	retq   

00000000008036be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036be:	55                   	push   %rbp
  8036bf:	48 89 e5             	mov    %rsp,%rbp
  8036c2:	48 83 ec 10          	sub    $0x10,%rsp
  8036c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036c9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8036cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d3:	00 00 00 
  8036d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8036db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e2:	00 00 00 
  8036e5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e8:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8036eb:	bf 03 00 00 00       	mov    $0x3,%edi
  8036f0:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
}
  8036fc:	c9                   	leaveq 
  8036fd:	c3                   	retq   

00000000008036fe <nsipc_close>:

int
nsipc_close(int s)
{
  8036fe:	55                   	push   %rbp
  8036ff:	48 89 e5             	mov    %rsp,%rbp
  803702:	48 83 ec 10          	sub    $0x10,%rsp
  803706:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803709:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803710:	00 00 00 
  803713:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803716:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803718:	bf 04 00 00 00       	mov    $0x4,%edi
  80371d:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
}
  803729:	c9                   	leaveq 
  80372a:	c3                   	retq   

000000000080372b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80372b:	55                   	push   %rbp
  80372c:	48 89 e5             	mov    %rsp,%rbp
  80372f:	48 83 ec 10          	sub    $0x10,%rsp
  803733:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803736:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80373a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80373d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803744:	00 00 00 
  803747:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80374a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80374c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80374f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803753:	48 89 c6             	mov    %rax,%rsi
  803756:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80375d:	00 00 00 
  803760:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80376c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803773:	00 00 00 
  803776:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803779:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80377c:	bf 05 00 00 00       	mov    $0x5,%edi
  803781:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
}
  80378d:	c9                   	leaveq 
  80378e:	c3                   	retq   

000000000080378f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80378f:	55                   	push   %rbp
  803790:	48 89 e5             	mov    %rsp,%rbp
  803793:	48 83 ec 10          	sub    $0x10,%rsp
  803797:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80379a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80379d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a4:	00 00 00 
  8037a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037aa:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b3:	00 00 00 
  8037b6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037b9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037bc:	bf 06 00 00 00       	mov    $0x6,%edi
  8037c1:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  8037c8:	00 00 00 
  8037cb:	ff d0                	callq  *%rax
}
  8037cd:	c9                   	leaveq 
  8037ce:	c3                   	retq   

00000000008037cf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8037cf:	55                   	push   %rbp
  8037d0:	48 89 e5             	mov    %rsp,%rbp
  8037d3:	48 83 ec 30          	sub    $0x30,%rsp
  8037d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037de:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8037e1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8037e4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037eb:	00 00 00 
  8037ee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037f1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8037f3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fa:	00 00 00 
  8037fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803803:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380a:	00 00 00 
  80380d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803810:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803813:	bf 07 00 00 00       	mov    $0x7,%edi
  803818:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803827:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382b:	78 69                	js     803896 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80382d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803834:	7f 08                	jg     80383e <nsipc_recv+0x6f>
  803836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803839:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80383c:	7e 35                	jle    803873 <nsipc_recv+0xa4>
  80383e:	48 b9 17 4c 80 00 00 	movabs $0x804c17,%rcx
  803845:	00 00 00 
  803848:	48 ba 2c 4c 80 00 00 	movabs $0x804c2c,%rdx
  80384f:	00 00 00 
  803852:	be 61 00 00 00       	mov    $0x61,%esi
  803857:	48 bf 41 4c 80 00 00 	movabs $0x804c41,%rdi
  80385e:	00 00 00 
  803861:	b8 00 00 00 00       	mov    $0x0,%eax
  803866:	49 b8 22 42 80 00 00 	movabs $0x804222,%r8
  80386d:	00 00 00 
  803870:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	48 63 d0             	movslq %eax,%rdx
  803879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80387d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803884:	00 00 00 
  803887:	48 89 c7             	mov    %rax,%rdi
  80388a:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
	}

	return r;
  803896:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803899:	c9                   	leaveq 
  80389a:	c3                   	retq   

000000000080389b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80389b:	55                   	push   %rbp
  80389c:	48 89 e5             	mov    %rsp,%rbp
  80389f:	48 83 ec 20          	sub    $0x20,%rsp
  8038a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038aa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038ad:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b7:	00 00 00 
  8038ba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bd:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038bf:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8038c6:	7e 35                	jle    8038fd <nsipc_send+0x62>
  8038c8:	48 b9 4d 4c 80 00 00 	movabs $0x804c4d,%rcx
  8038cf:	00 00 00 
  8038d2:	48 ba 2c 4c 80 00 00 	movabs $0x804c2c,%rdx
  8038d9:	00 00 00 
  8038dc:	be 6c 00 00 00       	mov    $0x6c,%esi
  8038e1:	48 bf 41 4c 80 00 00 	movabs $0x804c41,%rdi
  8038e8:	00 00 00 
  8038eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f0:	49 b8 22 42 80 00 00 	movabs $0x804222,%r8
  8038f7:	00 00 00 
  8038fa:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803900:	48 63 d0             	movslq %eax,%rdx
  803903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803907:	48 89 c6             	mov    %rax,%rsi
  80390a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803911:	00 00 00 
  803914:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803920:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803927:	00 00 00 
  80392a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803930:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803937:	00 00 00 
  80393a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80393d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803940:	bf 08 00 00 00       	mov    $0x8,%edi
  803945:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
}
  803951:	c9                   	leaveq 
  803952:	c3                   	retq   

0000000000803953 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803953:	55                   	push   %rbp
  803954:	48 89 e5             	mov    %rsp,%rbp
  803957:	48 83 ec 10          	sub    $0x10,%rsp
  80395b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80395e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803961:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803964:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80396b:	00 00 00 
  80396e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803971:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803973:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80397a:	00 00 00 
  80397d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803980:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803983:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80398a:	00 00 00 
  80398d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803990:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803993:	bf 09 00 00 00       	mov    $0x9,%edi
  803998:	48 b8 5a 35 80 00 00 	movabs $0x80355a,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
}
  8039a4:	c9                   	leaveq 
  8039a5:	c3                   	retq   

00000000008039a6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039a6:	55                   	push   %rbp
  8039a7:	48 89 e5             	mov    %rsp,%rbp
  8039aa:	53                   	push   %rbx
  8039ab:	48 83 ec 38          	sub    $0x38,%rsp
  8039af:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039b3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039b7:	48 89 c7             	mov    %rax,%rdi
  8039ba:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
  8039c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039cd:	0f 88 bf 01 00 00    	js     803b92 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8039dc:	48 89 c6             	mov    %rax,%rsi
  8039df:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e4:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
  8039f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f7:	0f 88 95 01 00 00    	js     803b92 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039fd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a01:	48 89 c7             	mov    %rax,%rdi
  803a04:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  803a0b:	00 00 00 
  803a0e:	ff d0                	callq  *%rax
  803a10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a13:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a17:	0f 88 5d 01 00 00    	js     803b7a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a21:	ba 07 04 00 00       	mov    $0x407,%edx
  803a26:	48 89 c6             	mov    %rax,%rsi
  803a29:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2e:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
  803a3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a41:	0f 88 33 01 00 00    	js     803b7a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4b:	48 89 c7             	mov    %rax,%rdi
  803a4e:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803a55:	00 00 00 
  803a58:	ff d0                	callq  *%rax
  803a5a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a62:	ba 07 04 00 00       	mov    $0x407,%edx
  803a67:	48 89 c6             	mov    %rax,%rsi
  803a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6f:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a82:	79 05                	jns    803a89 <pipe+0xe3>
		goto err2;
  803a84:	e9 d9 00 00 00       	jmpq   803b62 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a8d:	48 89 c7             	mov    %rax,%rdi
  803a90:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
  803a9c:	48 89 c2             	mov    %rax,%rdx
  803a9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803aa9:	48 89 d1             	mov    %rdx,%rcx
  803aac:	ba 00 00 00 00       	mov    $0x0,%edx
  803ab1:	48 89 c6             	mov    %rax,%rsi
  803ab4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab9:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  803ac0:	00 00 00 
  803ac3:	ff d0                	callq  *%rax
  803ac5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803acc:	79 1b                	jns    803ae9 <pipe+0x143>
		goto err3;
  803ace:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803acf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad3:	48 89 c6             	mov    %rax,%rsi
  803ad6:	bf 00 00 00 00       	mov    $0x0,%edi
  803adb:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803ae2:	00 00 00 
  803ae5:	ff d0                	callq  *%rax
  803ae7:	eb 79                	jmp    803b62 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aed:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803af4:	00 00 00 
  803af7:	8b 12                	mov    (%rdx),%edx
  803af9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803afb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b0a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b11:	00 00 00 
  803b14:	8b 12                	mov    (%rdx),%edx
  803b16:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b27:	48 89 c7             	mov    %rax,%rdi
  803b2a:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  803b31:	00 00 00 
  803b34:	ff d0                	callq  *%rax
  803b36:	89 c2                	mov    %eax,%edx
  803b38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b3c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b42:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b4a:	48 89 c7             	mov    %rax,%rdi
  803b4d:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
  803b59:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b60:	eb 33                	jmp    803b95 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b66:	48 89 c6             	mov    %rax,%rsi
  803b69:	bf 00 00 00 00       	mov    $0x0,%edi
  803b6e:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b7e:	48 89 c6             	mov    %rax,%rsi
  803b81:	bf 00 00 00 00       	mov    $0x0,%edi
  803b86:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
err:
	return r;
  803b92:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b95:	48 83 c4 38          	add    $0x38,%rsp
  803b99:	5b                   	pop    %rbx
  803b9a:	5d                   	pop    %rbp
  803b9b:	c3                   	retq   

0000000000803b9c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b9c:	55                   	push   %rbp
  803b9d:	48 89 e5             	mov    %rsp,%rbp
  803ba0:	53                   	push   %rbx
  803ba1:	48 83 ec 28          	sub    $0x28,%rsp
  803ba5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ba9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803bad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bb4:	00 00 00 
  803bb7:	48 8b 00             	mov    (%rax),%rax
  803bba:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bc0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc7:	48 89 c7             	mov    %rax,%rdi
  803bca:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
  803bd6:	89 c3                	mov    %eax,%ebx
  803bd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bdc:	48 89 c7             	mov    %rax,%rdi
  803bdf:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	39 c3                	cmp    %eax,%ebx
  803bed:	0f 94 c0             	sete   %al
  803bf0:	0f b6 c0             	movzbl %al,%eax
  803bf3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803bf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bfd:	00 00 00 
  803c00:	48 8b 00             	mov    (%rax),%rax
  803c03:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c09:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c0f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c12:	75 05                	jne    803c19 <_pipeisclosed+0x7d>
			return ret;
  803c14:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c17:	eb 4f                	jmp    803c68 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c1c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c1f:	74 42                	je     803c63 <_pipeisclosed+0xc7>
  803c21:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c25:	75 3c                	jne    803c63 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c27:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c2e:	00 00 00 
  803c31:	48 8b 00             	mov    (%rax),%rax
  803c34:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c3a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c40:	89 c6                	mov    %eax,%esi
  803c42:	48 bf 5e 4c 80 00 00 	movabs $0x804c5e,%rdi
  803c49:	00 00 00 
  803c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c51:	49 b8 90 03 80 00 00 	movabs $0x800390,%r8
  803c58:	00 00 00 
  803c5b:	41 ff d0             	callq  *%r8
	}
  803c5e:	e9 4a ff ff ff       	jmpq   803bad <_pipeisclosed+0x11>
  803c63:	e9 45 ff ff ff       	jmpq   803bad <_pipeisclosed+0x11>
}
  803c68:	48 83 c4 28          	add    $0x28,%rsp
  803c6c:	5b                   	pop    %rbx
  803c6d:	5d                   	pop    %rbp
  803c6e:	c3                   	retq   

0000000000803c6f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c6f:	55                   	push   %rbp
  803c70:	48 89 e5             	mov    %rsp,%rbp
  803c73:	48 83 ec 30          	sub    $0x30,%rsp
  803c77:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c7a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c81:	48 89 d6             	mov    %rdx,%rsi
  803c84:	89 c7                	mov    %eax,%edi
  803c86:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  803c8d:	00 00 00 
  803c90:	ff d0                	callq  *%rax
  803c92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c99:	79 05                	jns    803ca0 <pipeisclosed+0x31>
		return r;
  803c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9e:	eb 31                	jmp    803cd1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca4:	48 89 c7             	mov    %rax,%rdi
  803ca7:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803cae:	00 00 00 
  803cb1:	ff d0                	callq  *%rax
  803cb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cbf:	48 89 d6             	mov    %rdx,%rsi
  803cc2:	48 89 c7             	mov    %rax,%rdi
  803cc5:	48 b8 9c 3b 80 00 00 	movabs $0x803b9c,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
}
  803cd1:	c9                   	leaveq 
  803cd2:	c3                   	retq   

0000000000803cd3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cd3:	55                   	push   %rbp
  803cd4:	48 89 e5             	mov    %rsp,%rbp
  803cd7:	48 83 ec 40          	sub    $0x40,%rsp
  803cdb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cdf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ce3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ce7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ceb:	48 89 c7             	mov    %rax,%rdi
  803cee:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cfe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d06:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d0d:	00 
  803d0e:	e9 92 00 00 00       	jmpq   803da5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d13:	eb 41                	jmp    803d56 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d15:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d1a:	74 09                	je     803d25 <devpipe_read+0x52>
				return i;
  803d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d20:	e9 92 00 00 00       	jmpq   803db7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d2d:	48 89 d6             	mov    %rdx,%rsi
  803d30:	48 89 c7             	mov    %rax,%rdi
  803d33:	48 b8 9c 3b 80 00 00 	movabs $0x803b9c,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
  803d3f:	85 c0                	test   %eax,%eax
  803d41:	74 07                	je     803d4a <devpipe_read+0x77>
				return 0;
  803d43:	b8 00 00 00 00       	mov    $0x0,%eax
  803d48:	eb 6d                	jmp    803db7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d4a:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803d51:	00 00 00 
  803d54:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5a:	8b 10                	mov    (%rax),%edx
  803d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d60:	8b 40 04             	mov    0x4(%rax),%eax
  803d63:	39 c2                	cmp    %eax,%edx
  803d65:	74 ae                	je     803d15 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d6f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d77:	8b 00                	mov    (%rax),%eax
  803d79:	99                   	cltd   
  803d7a:	c1 ea 1b             	shr    $0x1b,%edx
  803d7d:	01 d0                	add    %edx,%eax
  803d7f:	83 e0 1f             	and    $0x1f,%eax
  803d82:	29 d0                	sub    %edx,%eax
  803d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d88:	48 98                	cltq   
  803d8a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d8f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d95:	8b 00                	mov    (%rax),%eax
  803d97:	8d 50 01             	lea    0x1(%rax),%edx
  803d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803da0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dad:	0f 82 60 ff ff ff    	jb     803d13 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803db7:	c9                   	leaveq 
  803db8:	c3                   	retq   

0000000000803db9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803db9:	55                   	push   %rbp
  803dba:	48 89 e5             	mov    %rsp,%rbp
  803dbd:	48 83 ec 40          	sub    $0x40,%rsp
  803dc1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dc5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dc9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803dcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd1:	48 89 c7             	mov    %rax,%rdi
  803dd4:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
  803de0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803de4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803de8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803df3:	00 
  803df4:	e9 8e 00 00 00       	jmpq   803e87 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803df9:	eb 31                	jmp    803e2c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803dfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e03:	48 89 d6             	mov    %rdx,%rsi
  803e06:	48 89 c7             	mov    %rax,%rdi
  803e09:	48 b8 9c 3b 80 00 00 	movabs $0x803b9c,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	callq  *%rax
  803e15:	85 c0                	test   %eax,%eax
  803e17:	74 07                	je     803e20 <devpipe_write+0x67>
				return 0;
  803e19:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1e:	eb 79                	jmp    803e99 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e20:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803e27:	00 00 00 
  803e2a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e30:	8b 40 04             	mov    0x4(%rax),%eax
  803e33:	48 63 d0             	movslq %eax,%rdx
  803e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3a:	8b 00                	mov    (%rax),%eax
  803e3c:	48 98                	cltq   
  803e3e:	48 83 c0 20          	add    $0x20,%rax
  803e42:	48 39 c2             	cmp    %rax,%rdx
  803e45:	73 b4                	jae    803dfb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4b:	8b 40 04             	mov    0x4(%rax),%eax
  803e4e:	99                   	cltd   
  803e4f:	c1 ea 1b             	shr    $0x1b,%edx
  803e52:	01 d0                	add    %edx,%eax
  803e54:	83 e0 1f             	and    $0x1f,%eax
  803e57:	29 d0                	sub    %edx,%eax
  803e59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e5d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e61:	48 01 ca             	add    %rcx,%rdx
  803e64:	0f b6 0a             	movzbl (%rdx),%ecx
  803e67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e6b:	48 98                	cltq   
  803e6d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e75:	8b 40 04             	mov    0x4(%rax),%eax
  803e78:	8d 50 01             	lea    0x1(%rax),%edx
  803e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e82:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e8f:	0f 82 64 ff ff ff    	jb     803df9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e99:	c9                   	leaveq 
  803e9a:	c3                   	retq   

0000000000803e9b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e9b:	55                   	push   %rbp
  803e9c:	48 89 e5             	mov    %rsp,%rbp
  803e9f:	48 83 ec 20          	sub    $0x20,%rsp
  803ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
  803ebe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ec2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec6:	48 be 71 4c 80 00 00 	movabs $0x804c71,%rsi
  803ecd:	00 00 00 
  803ed0:	48 89 c7             	mov    %rax,%rdi
  803ed3:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  803eda:	00 00 00 
  803edd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee3:	8b 50 04             	mov    0x4(%rax),%edx
  803ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eea:	8b 00                	mov    (%rax),%eax
  803eec:	29 c2                	sub    %eax,%edx
  803eee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ef8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803efc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f03:	00 00 00 
	stat->st_dev = &devpipe;
  803f06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f0a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f11:	00 00 00 
  803f14:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f20:	c9                   	leaveq 
  803f21:	c3                   	retq   

0000000000803f22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f22:	55                   	push   %rbp
  803f23:	48 89 e5             	mov    %rsp,%rbp
  803f26:	48 83 ec 10          	sub    $0x10,%rsp
  803f2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f32:	48 89 c6             	mov    %rax,%rsi
  803f35:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3a:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f4a:	48 89 c7             	mov    %rax,%rdi
  803f4d:	48 b8 b5 1e 80 00 00 	movabs $0x801eb5,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
  803f59:	48 89 c6             	mov    %rax,%rsi
  803f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f61:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
}
  803f6d:	c9                   	leaveq 
  803f6e:	c3                   	retq   

0000000000803f6f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f6f:	55                   	push   %rbp
  803f70:	48 89 e5             	mov    %rsp,%rbp
  803f73:	48 83 ec 20          	sub    $0x20,%rsp
  803f77:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f7d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f80:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f84:	be 01 00 00 00       	mov    $0x1,%esi
  803f89:	48 89 c7             	mov    %rax,%rdi
  803f8c:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  803f93:	00 00 00 
  803f96:	ff d0                	callq  *%rax
}
  803f98:	c9                   	leaveq 
  803f99:	c3                   	retq   

0000000000803f9a <getchar>:

int
getchar(void)
{
  803f9a:	55                   	push   %rbp
  803f9b:	48 89 e5             	mov    %rsp,%rbp
  803f9e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fa2:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fa6:	ba 01 00 00 00       	mov    $0x1,%edx
  803fab:	48 89 c6             	mov    %rax,%rsi
  803fae:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb3:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
  803fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	79 05                	jns    803fcd <getchar+0x33>
		return r;
  803fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcb:	eb 14                	jmp    803fe1 <getchar+0x47>
	if (r < 1)
  803fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd1:	7f 07                	jg     803fda <getchar+0x40>
		return -E_EOF;
  803fd3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803fd8:	eb 07                	jmp    803fe1 <getchar+0x47>
	return c;
  803fda:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803fde:	0f b6 c0             	movzbl %al,%eax
}
  803fe1:	c9                   	leaveq 
  803fe2:	c3                   	retq   

0000000000803fe3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803fe3:	55                   	push   %rbp
  803fe4:	48 89 e5             	mov    %rsp,%rbp
  803fe7:	48 83 ec 20          	sub    $0x20,%rsp
  803feb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ff2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff5:	48 89 d6             	mov    %rdx,%rsi
  803ff8:	89 c7                	mov    %eax,%edi
  803ffa:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
  804006:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400d:	79 05                	jns    804014 <iscons+0x31>
		return r;
  80400f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804012:	eb 1a                	jmp    80402e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804018:	8b 10                	mov    (%rax),%edx
  80401a:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804021:	00 00 00 
  804024:	8b 00                	mov    (%rax),%eax
  804026:	39 c2                	cmp    %eax,%edx
  804028:	0f 94 c0             	sete   %al
  80402b:	0f b6 c0             	movzbl %al,%eax
}
  80402e:	c9                   	leaveq 
  80402f:	c3                   	retq   

0000000000804030 <opencons>:

int
opencons(void)
{
  804030:	55                   	push   %rbp
  804031:	48 89 e5             	mov    %rsp,%rbp
  804034:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804038:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80403c:	48 89 c7             	mov    %rax,%rdi
  80403f:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
  80404b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804052:	79 05                	jns    804059 <opencons+0x29>
		return r;
  804054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804057:	eb 5b                	jmp    8040b4 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405d:	ba 07 04 00 00       	mov    $0x407,%edx
  804062:	48 89 c6             	mov    %rax,%rsi
  804065:	bf 00 00 00 00       	mov    $0x0,%edi
  80406a:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  804071:	00 00 00 
  804074:	ff d0                	callq  *%rax
  804076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80407d:	79 05                	jns    804084 <opencons+0x54>
		return r;
  80407f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804082:	eb 30                	jmp    8040b4 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804088:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80408f:	00 00 00 
  804092:	8b 12                	mov    (%rdx),%edx
  804094:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a5:	48 89 c7             	mov    %rax,%rdi
  8040a8:	48 b8 92 1e 80 00 00 	movabs $0x801e92,%rax
  8040af:	00 00 00 
  8040b2:	ff d0                	callq  *%rax
}
  8040b4:	c9                   	leaveq 
  8040b5:	c3                   	retq   

00000000008040b6 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040b6:	55                   	push   %rbp
  8040b7:	48 89 e5             	mov    %rsp,%rbp
  8040ba:	48 83 ec 30          	sub    $0x30,%rsp
  8040be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8040ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040cf:	75 07                	jne    8040d8 <devcons_read+0x22>
		return 0;
  8040d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d6:	eb 4b                	jmp    804123 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8040d8:	eb 0c                	jmp    8040e6 <devcons_read+0x30>
		sys_yield();
  8040da:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8040e1:	00 00 00 
  8040e4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040e6:	48 b8 76 17 80 00 00 	movabs $0x801776,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f9:	74 df                	je     8040da <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8040fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ff:	79 05                	jns    804106 <devcons_read+0x50>
		return c;
  804101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804104:	eb 1d                	jmp    804123 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804106:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80410a:	75 07                	jne    804113 <devcons_read+0x5d>
		return 0;
  80410c:	b8 00 00 00 00       	mov    $0x0,%eax
  804111:	eb 10                	jmp    804123 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804116:	89 c2                	mov    %eax,%edx
  804118:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80411c:	88 10                	mov    %dl,(%rax)
	return 1;
  80411e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804123:	c9                   	leaveq 
  804124:	c3                   	retq   

0000000000804125 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804125:	55                   	push   %rbp
  804126:	48 89 e5             	mov    %rsp,%rbp
  804129:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804130:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804137:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80413e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80414c:	eb 76                	jmp    8041c4 <devcons_write+0x9f>
		m = n - tot;
  80414e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804155:	89 c2                	mov    %eax,%edx
  804157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415a:	29 c2                	sub    %eax,%edx
  80415c:	89 d0                	mov    %edx,%eax
  80415e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804164:	83 f8 7f             	cmp    $0x7f,%eax
  804167:	76 07                	jbe    804170 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804169:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804170:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804173:	48 63 d0             	movslq %eax,%rdx
  804176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804179:	48 63 c8             	movslq %eax,%rcx
  80417c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804183:	48 01 c1             	add    %rax,%rcx
  804186:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80418d:	48 89 ce             	mov    %rcx,%rsi
  804190:	48 89 c7             	mov    %rax,%rdi
  804193:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  80419a:	00 00 00 
  80419d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80419f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041a2:	48 63 d0             	movslq %eax,%rdx
  8041a5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041ac:	48 89 d6             	mov    %rdx,%rsi
  8041af:	48 89 c7             	mov    %rax,%rdi
  8041b2:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8041b9:	00 00 00 
  8041bc:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041c1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c7:	48 98                	cltq   
  8041c9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8041d0:	0f 82 78 ff ff ff    	jb     80414e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8041d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041d9:	c9                   	leaveq 
  8041da:	c3                   	retq   

00000000008041db <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8041db:	55                   	push   %rbp
  8041dc:	48 89 e5             	mov    %rsp,%rbp
  8041df:	48 83 ec 08          	sub    $0x8,%rsp
  8041e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8041e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041ec:	c9                   	leaveq 
  8041ed:	c3                   	retq   

00000000008041ee <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8041ee:	55                   	push   %rbp
  8041ef:	48 89 e5             	mov    %rsp,%rbp
  8041f2:	48 83 ec 10          	sub    $0x10,%rsp
  8041f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8041fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804202:	48 be 7d 4c 80 00 00 	movabs $0x804c7d,%rsi
  804209:	00 00 00 
  80420c:	48 89 c7             	mov    %rax,%rdi
  80420f:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  804216:	00 00 00 
  804219:	ff d0                	callq  *%rax
	return 0;
  80421b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804220:	c9                   	leaveq 
  804221:	c3                   	retq   

0000000000804222 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804222:	55                   	push   %rbp
  804223:	48 89 e5             	mov    %rsp,%rbp
  804226:	53                   	push   %rbx
  804227:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80422e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  804235:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80423b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804242:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804249:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804250:	84 c0                	test   %al,%al
  804252:	74 23                	je     804277 <_panic+0x55>
  804254:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80425b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80425f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804263:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804267:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80426b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80426f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804273:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804277:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80427e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804285:	00 00 00 
  804288:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80428f:	00 00 00 
  804292:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804296:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80429d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042a4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8042ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8042b2:	00 00 00 
  8042b5:	48 8b 18             	mov    (%rax),%rbx
  8042b8:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
  8042c4:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8042ca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8042d1:	41 89 c8             	mov    %ecx,%r8d
  8042d4:	48 89 d1             	mov    %rdx,%rcx
  8042d7:	48 89 da             	mov    %rbx,%rdx
  8042da:	89 c6                	mov    %eax,%esi
  8042dc:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  8042e3:	00 00 00 
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	49 b9 90 03 80 00 00 	movabs $0x800390,%r9
  8042f2:	00 00 00 
  8042f5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8042f8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8042ff:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804306:	48 89 d6             	mov    %rdx,%rsi
  804309:	48 89 c7             	mov    %rax,%rdi
  80430c:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  804313:	00 00 00 
  804316:	ff d0                	callq  *%rax
	cprintf("\n");
  804318:	48 bf ab 4c 80 00 00 	movabs $0x804cab,%rdi
  80431f:	00 00 00 
  804322:	b8 00 00 00 00       	mov    $0x0,%eax
  804327:	48 ba 90 03 80 00 00 	movabs $0x800390,%rdx
  80432e:	00 00 00 
  804331:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804333:	cc                   	int3   
  804334:	eb fd                	jmp    804333 <_panic+0x111>

0000000000804336 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804336:	55                   	push   %rbp
  804337:	48 89 e5             	mov    %rsp,%rbp
  80433a:	48 83 ec 30          	sub    $0x30,%rsp
  80433e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804342:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804346:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80434a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804351:	00 00 00 
  804354:	48 8b 00             	mov    (%rax),%rax
  804357:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80435d:	85 c0                	test   %eax,%eax
  80435f:	75 3c                	jne    80439d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804361:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  804368:	00 00 00 
  80436b:	ff d0                	callq  *%rax
  80436d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804372:	48 63 d0             	movslq %eax,%rdx
  804375:	48 89 d0             	mov    %rdx,%rax
  804378:	48 c1 e0 03          	shl    $0x3,%rax
  80437c:	48 01 d0             	add    %rdx,%rax
  80437f:	48 c1 e0 05          	shl    $0x5,%rax
  804383:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80438a:	00 00 00 
  80438d:	48 01 c2             	add    %rax,%rdx
  804390:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804397:	00 00 00 
  80439a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80439d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043a2:	75 0e                	jne    8043b2 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8043a4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043ab:	00 00 00 
  8043ae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8043b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b6:	48 89 c7             	mov    %rax,%rdi
  8043b9:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  8043c0:	00 00 00 
  8043c3:	ff d0                	callq  *%rax
  8043c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8043c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043cc:	79 19                	jns    8043e7 <ipc_recv+0xb1>
		*from_env_store = 0;
  8043ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043d2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8043d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043dc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8043e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e5:	eb 53                	jmp    80443a <ipc_recv+0x104>
	}
	if(from_env_store)
  8043e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043ec:	74 19                	je     804407 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8043ee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043f5:	00 00 00 
  8043f8:	48 8b 00             	mov    (%rax),%rax
  8043fb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804405:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804407:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80440c:	74 19                	je     804427 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80440e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804415:	00 00 00 
  804418:	48 8b 00             	mov    (%rax),%rax
  80441b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804421:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804425:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804427:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80442e:	00 00 00 
  804431:	48 8b 00             	mov    (%rax),%rax
  804434:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80443a:	c9                   	leaveq 
  80443b:	c3                   	retq   

000000000080443c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80443c:	55                   	push   %rbp
  80443d:	48 89 e5             	mov    %rsp,%rbp
  804440:	48 83 ec 30          	sub    $0x30,%rsp
  804444:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804447:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80444a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80444e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804451:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804456:	75 0e                	jne    804466 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804458:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80445f:	00 00 00 
  804462:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804466:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804469:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80446c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804470:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804473:	89 c7                	mov    %eax,%edi
  804475:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  80447c:	00 00 00 
  80447f:	ff d0                	callq  *%rax
  804481:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804484:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804488:	75 0c                	jne    804496 <ipc_send+0x5a>
			sys_yield();
  80448a:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  804491:	00 00 00 
  804494:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804496:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80449a:	74 ca                	je     804466 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80449c:	c9                   	leaveq 
  80449d:	c3                   	retq   

000000000080449e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80449e:	55                   	push   %rbp
  80449f:	48 89 e5             	mov    %rsp,%rbp
  8044a2:	48 83 ec 14          	sub    $0x14,%rsp
  8044a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8044a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044b0:	eb 5e                	jmp    804510 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8044b2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8044b9:	00 00 00 
  8044bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bf:	48 63 d0             	movslq %eax,%rdx
  8044c2:	48 89 d0             	mov    %rdx,%rax
  8044c5:	48 c1 e0 03          	shl    $0x3,%rax
  8044c9:	48 01 d0             	add    %rdx,%rax
  8044cc:	48 c1 e0 05          	shl    $0x5,%rax
  8044d0:	48 01 c8             	add    %rcx,%rax
  8044d3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8044d9:	8b 00                	mov    (%rax),%eax
  8044db:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8044de:	75 2c                	jne    80450c <ipc_find_env+0x6e>
			return envs[i].env_id;
  8044e0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8044e7:	00 00 00 
  8044ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ed:	48 63 d0             	movslq %eax,%rdx
  8044f0:	48 89 d0             	mov    %rdx,%rax
  8044f3:	48 c1 e0 03          	shl    $0x3,%rax
  8044f7:	48 01 d0             	add    %rdx,%rax
  8044fa:	48 c1 e0 05          	shl    $0x5,%rax
  8044fe:	48 01 c8             	add    %rcx,%rax
  804501:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804507:	8b 40 08             	mov    0x8(%rax),%eax
  80450a:	eb 12                	jmp    80451e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80450c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804510:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804517:	7e 99                	jle    8044b2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804519:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80451e:	c9                   	leaveq 
  80451f:	c3                   	retq   

0000000000804520 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804520:	55                   	push   %rbp
  804521:	48 89 e5             	mov    %rsp,%rbp
  804524:	48 83 ec 18          	sub    $0x18,%rsp
  804528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80452c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804530:	48 c1 e8 15          	shr    $0x15,%rax
  804534:	48 89 c2             	mov    %rax,%rdx
  804537:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80453e:	01 00 00 
  804541:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804545:	83 e0 01             	and    $0x1,%eax
  804548:	48 85 c0             	test   %rax,%rax
  80454b:	75 07                	jne    804554 <pageref+0x34>
		return 0;
  80454d:	b8 00 00 00 00       	mov    $0x0,%eax
  804552:	eb 53                	jmp    8045a7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804558:	48 c1 e8 0c          	shr    $0xc,%rax
  80455c:	48 89 c2             	mov    %rax,%rdx
  80455f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804566:	01 00 00 
  804569:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80456d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804575:	83 e0 01             	and    $0x1,%eax
  804578:	48 85 c0             	test   %rax,%rax
  80457b:	75 07                	jne    804584 <pageref+0x64>
		return 0;
  80457d:	b8 00 00 00 00       	mov    $0x0,%eax
  804582:	eb 23                	jmp    8045a7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804588:	48 c1 e8 0c          	shr    $0xc,%rax
  80458c:	48 89 c2             	mov    %rax,%rdx
  80458f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804596:	00 00 00 
  804599:	48 c1 e2 04          	shl    $0x4,%rdx
  80459d:	48 01 d0             	add    %rdx,%rax
  8045a0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8045a4:	0f b7 c0             	movzwl %ax,%eax
}
  8045a7:	c9                   	leaveq 
  8045a8:	c3                   	retq   
