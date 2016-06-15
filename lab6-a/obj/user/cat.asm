
obj/user/cat.debug:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 af 23 80 00 00 	movabs $0x8023af,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 86 43 80 00 00 	movabs $0x804386,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 bb 9b 43 80 00 00 	movabs $0x80439b,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be 9f 43 80 00 00 	movabs $0x80439f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf a7 43 80 00 00 	movabs $0x8043a7,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 9f 2f 80 00 00 	movabs $0x802f9f,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800258:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	25 ff 03 00 00       	and    $0x3ff,%eax
  800269:	48 63 d0             	movslq %eax,%rdx
  80026c:	48 89 d0             	mov    %rdx,%rax
  80026f:	48 c1 e0 03          	shl    $0x3,%rax
  800273:	48 01 d0             	add    %rdx,%rax
  800276:	48 c1 e0 05          	shl    $0x5,%rax
  80027a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800281:	00 00 00 
  800284:	48 01 c2             	add    %rax,%rdx
  800287:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80028e:	00 00 00 
  800291:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800298:	7e 14                	jle    8002ae <libmain+0x65>
		binaryname = argv[0];
  80029a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029e:	48 8b 10             	mov    (%rax),%rdx
  8002a1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002a8:	00 00 00 
  8002ab:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b5:	48 89 d6             	mov    %rdx,%rsi
  8002b8:	89 c7                	mov    %eax,%edi
  8002ba:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002c1:	00 00 00 
  8002c4:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002c6:	48 b8 d4 02 80 00 00 	movabs $0x8002d4,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
}
  8002d2:	c9                   	leaveq 
  8002d3:	c3                   	retq   

00000000008002d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d4:	55                   	push   %rbp
  8002d5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002d8:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e9:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax

}
  8002f5:	5d                   	pop    %rbp
  8002f6:	c3                   	retq   

00000000008002f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	53                   	push   %rbx
  8002fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800303:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800310:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800317:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80031e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800325:	84 c0                	test   %al,%al
  800327:	74 23                	je     80034c <_panic+0x55>
  800329:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800330:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800334:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800338:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80033c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800340:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800344:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800348:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80034c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800353:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035a:	00 00 00 
  80035d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800364:	00 00 00 
  800367:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800372:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800379:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800380:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800387:	00 00 00 
  80038a:	48 8b 18             	mov    (%rax),%rbx
  80038d:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
  800399:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80039f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003a6:	41 89 c8             	mov    %ecx,%r8d
  8003a9:	48 89 d1             	mov    %rdx,%rcx
  8003ac:	48 89 da             	mov    %rbx,%rdx
  8003af:	89 c6                	mov    %eax,%esi
  8003b1:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b9 30 05 80 00 00 	movabs $0x800530,%r9
  8003c7:	00 00 00 
  8003ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003db:	48 89 d6             	mov    %rdx,%rsi
  8003de:	48 89 c7             	mov    %rax,%rdi
  8003e1:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8003ed:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  800403:	00 00 00 
  800406:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800408:	cc                   	int3   
  800409:	eb fd                	jmp    800408 <_panic+0x111>

000000000080040b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	48 83 ec 10          	sub    $0x10,%rsp
  800413:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800416:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80041a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041e:	8b 00                	mov    (%rax),%eax
  800420:	8d 48 01             	lea    0x1(%rax),%ecx
  800423:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800427:	89 0a                	mov    %ecx,(%rdx)
  800429:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042c:	89 d1                	mov    %edx,%ecx
  80042e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800432:	48 98                	cltq   
  800434:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043c:	8b 00                	mov    (%rax),%eax
  80043e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800443:	75 2c                	jne    800471 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800449:	8b 00                	mov    (%rax),%eax
  80044b:	48 98                	cltq   
  80044d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800451:	48 83 c2 08          	add    $0x8,%rdx
  800455:	48 89 c6             	mov    %rax,%rsi
  800458:	48 89 d7             	mov    %rdx,%rdi
  80045b:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
        b->idx = 0;
  800467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	8b 40 04             	mov    0x4(%rax),%eax
  800478:	8d 50 01             	lea    0x1(%rax),%edx
  80047b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800482:	c9                   	leaveq 
  800483:	c3                   	retq   

0000000000800484 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800484:	55                   	push   %rbp
  800485:	48 89 e5             	mov    %rsp,%rbp
  800488:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80048f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800496:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80049d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004ab:	48 8b 0a             	mov    (%rdx),%rcx
  8004ae:	48 89 08             	mov    %rcx,(%rax)
  8004b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004c8:	00 00 00 
    b.cnt = 0;
  8004cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ea:	48 89 c6             	mov    %rax,%rsi
  8004ed:	48 bf 0b 04 80 00 00 	movabs $0x80040b,%rdi
  8004f4:	00 00 00 
  8004f7:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800503:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800509:	48 98                	cltq   
  80050b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800512:	48 83 c2 08          	add    $0x8,%rdx
  800516:	48 89 c6             	mov    %rax,%rsi
  800519:	48 89 d7             	mov    %rdx,%rdi
  80051c:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800523:	00 00 00 
  800526:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800528:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80052e:	c9                   	leaveq 
  80052f:	c3                   	retq   

0000000000800530 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800530:	55                   	push   %rbp
  800531:	48 89 e5             	mov    %rsp,%rbp
  800534:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80053b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800542:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800549:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800550:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800557:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80055e:	84 c0                	test   %al,%al
  800560:	74 20                	je     800582 <cprintf+0x52>
  800562:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800566:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80056e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800572:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800576:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80057e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800582:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800589:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800590:	00 00 00 
  800593:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059a:	00 00 00 
  80059d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c4:	48 8b 0a             	mov    (%rdx),%rcx
  8005c7:	48 89 08             	mov    %rcx,(%rax)
  8005ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e8:	48 89 d6             	mov    %rdx,%rsi
  8005eb:	48 89 c7             	mov    %rax,%rdi
  8005ee:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
  8005fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800600:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800606:	c9                   	leaveq 
  800607:	c3                   	retq   

0000000000800608 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800608:	55                   	push   %rbp
  800609:	48 89 e5             	mov    %rsp,%rbp
  80060c:	53                   	push   %rbx
  80060d:	48 83 ec 38          	sub    $0x38,%rsp
  800611:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800615:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800619:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80061d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800620:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800624:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800628:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80062b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80062f:	77 3b                	ja     80066c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800631:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800634:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800638:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80063b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	48 f7 f3             	div    %rbx
  800647:	48 89 c2             	mov    %rax,%rdx
  80064a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80064d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800650:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	41 89 f9             	mov    %edi,%r9d
  80065b:	48 89 c7             	mov    %rax,%rdi
  80065e:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800665:	00 00 00 
  800668:	ff d0                	callq  *%rax
  80066a:	eb 1e                	jmp    80068a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066c:	eb 12                	jmp    800680 <printnum+0x78>
			putch(padc, putdat);
  80066e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800672:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	48 89 ce             	mov    %rcx,%rsi
  80067c:	89 d7                	mov    %edx,%edi
  80067e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800680:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800684:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800688:	7f e4                	jg     80066e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80068d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	48 f7 f1             	div    %rcx
  800699:	48 89 d0             	mov    %rdx,%rax
  80069c:	48 ba f0 45 80 00 00 	movabs $0x8045f0,%rdx
  8006a3:	00 00 00 
  8006a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006aa:	0f be d0             	movsbl %al,%edx
  8006ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 89 ce             	mov    %rcx,%rsi
  8006b8:	89 d7                	mov    %edx,%edi
  8006ba:	ff d0                	callq  *%rax
}
  8006bc:	48 83 c4 38          	add    $0x38,%rsp
  8006c0:	5b                   	pop    %rbx
  8006c1:	5d                   	pop    %rbp
  8006c2:	c3                   	retq   

00000000008006c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c3:	55                   	push   %rbp
  8006c4:	48 89 e5             	mov    %rsp,%rbp
  8006c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d6:	7e 52                	jle    80072a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dc:	8b 00                	mov    (%rax),%eax
  8006de:	83 f8 30             	cmp    $0x30,%eax
  8006e1:	73 24                	jae    800707 <getuint+0x44>
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	89 c0                	mov    %eax,%eax
  8006f3:	48 01 d0             	add    %rdx,%rax
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	8b 12                	mov    (%rdx),%edx
  8006fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	89 0a                	mov    %ecx,(%rdx)
  800705:	eb 17                	jmp    80071e <getuint+0x5b>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070f:	48 89 d0             	mov    %rdx,%rax
  800712:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071e:	48 8b 00             	mov    (%rax),%rax
  800721:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800725:	e9 a3 00 00 00       	jmpq   8007cd <getuint+0x10a>
	else if (lflag)
  80072a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80072e:	74 4f                	je     80077f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	8b 00                	mov    (%rax),%eax
  800736:	83 f8 30             	cmp    $0x30,%eax
  800739:	73 24                	jae    80075f <getuint+0x9c>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800747:	8b 00                	mov    (%rax),%eax
  800749:	89 c0                	mov    %eax,%eax
  80074b:	48 01 d0             	add    %rdx,%rax
  80074e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800752:	8b 12                	mov    (%rdx),%edx
  800754:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	89 0a                	mov    %ecx,(%rdx)
  80075d:	eb 17                	jmp    800776 <getuint+0xb3>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800767:	48 89 d0             	mov    %rdx,%rax
  80076a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800772:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800776:	48 8b 00             	mov    (%rax),%rax
  800779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077d:	eb 4e                	jmp    8007cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	8b 00                	mov    (%rax),%eax
  800785:	83 f8 30             	cmp    $0x30,%eax
  800788:	73 24                	jae    8007ae <getuint+0xeb>
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	8b 00                	mov    (%rax),%eax
  800798:	89 c0                	mov    %eax,%eax
  80079a:	48 01 d0             	add    %rdx,%rax
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	8b 12                	mov    (%rdx),%edx
  8007a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007aa:	89 0a                	mov    %ecx,(%rdx)
  8007ac:	eb 17                	jmp    8007c5 <getuint+0x102>
  8007ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	89 c0                	mov    %eax,%eax
  8007c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d1:	c9                   	leaveq 
  8007d2:	c3                   	retq   

00000000008007d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e6:	7e 52                	jle    80083a <getint+0x67>
		x=va_arg(*ap, long long);
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	83 f8 30             	cmp    $0x30,%eax
  8007f1:	73 24                	jae    800817 <getint+0x44>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080a:	8b 12                	mov    (%rdx),%edx
  80080c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	89 0a                	mov    %ecx,(%rdx)
  800815:	eb 17                	jmp    80082e <getint+0x5b>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081f:	48 89 d0             	mov    %rdx,%rax
  800822:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082e:	48 8b 00             	mov    (%rax),%rax
  800831:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800835:	e9 a3 00 00 00       	jmpq   8008dd <getint+0x10a>
	else if (lflag)
  80083a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083e:	74 4f                	je     80088f <getint+0xbc>
		x=va_arg(*ap, long);
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	8b 00                	mov    (%rax),%eax
  800846:	83 f8 30             	cmp    $0x30,%eax
  800849:	73 24                	jae    80086f <getint+0x9c>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800857:	8b 00                	mov    (%rax),%eax
  800859:	89 c0                	mov    %eax,%eax
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800862:	8b 12                	mov    (%rdx),%edx
  800864:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	89 0a                	mov    %ecx,(%rdx)
  80086d:	eb 17                	jmp    800886 <getint+0xb3>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800877:	48 89 d0             	mov    %rdx,%rax
  80087a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800882:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800886:	48 8b 00             	mov    (%rax),%rax
  800889:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088d:	eb 4e                	jmp    8008dd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	8b 00                	mov    (%rax),%eax
  800895:	83 f8 30             	cmp    $0x30,%eax
  800898:	73 24                	jae    8008be <getint+0xeb>
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a6:	8b 00                	mov    (%rax),%eax
  8008a8:	89 c0                	mov    %eax,%eax
  8008aa:	48 01 d0             	add    %rdx,%rax
  8008ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b1:	8b 12                	mov    (%rdx),%edx
  8008b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ba:	89 0a                	mov    %ecx,(%rdx)
  8008bc:	eb 17                	jmp    8008d5 <getint+0x102>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c6:	48 89 d0             	mov    %rdx,%rax
  8008c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d5:	8b 00                	mov    (%rax),%eax
  8008d7:	48 98                	cltq   
  8008d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e1:	c9                   	leaveq 
  8008e2:	c3                   	retq   

00000000008008e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e3:	55                   	push   %rbp
  8008e4:	48 89 e5             	mov    %rsp,%rbp
  8008e7:	41 54                	push   %r12
  8008e9:	53                   	push   %rbx
  8008ea:	48 83 ec 60          	sub    $0x60,%rsp
  8008ee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800902:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800906:	48 8b 0a             	mov    (%rdx),%rcx
  800909:	48 89 08             	mov    %rcx,(%rax)
  80090c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800910:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800914:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800918:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091c:	eb 17                	jmp    800935 <vprintfmt+0x52>
			if (ch == '\0')
  80091e:	85 db                	test   %ebx,%ebx
  800920:	0f 84 cc 04 00 00    	je     800df2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800926:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092e:	48 89 d6             	mov    %rdx,%rsi
  800931:	89 df                	mov    %ebx,%edi
  800933:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800935:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800939:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80093d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800941:	0f b6 00             	movzbl (%rax),%eax
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	83 fb 25             	cmp    $0x25,%ebx
  80094a:	75 d2                	jne    80091e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800950:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800957:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80095e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800965:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800970:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800974:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800978:	0f b6 00             	movzbl (%rax),%eax
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800981:	83 f8 55             	cmp    $0x55,%eax
  800984:	0f 87 34 04 00 00    	ja     800dbe <vprintfmt+0x4db>
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800993:	00 
  800994:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  80099b:	00 00 00 
  80099e:	48 01 d0             	add    %rdx,%rax
  8009a1:	48 8b 00             	mov    (%rax),%rax
  8009a4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009aa:	eb c0                	jmp    80096c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b0:	eb ba                	jmp    80096c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009bc:	89 d0                	mov    %edx,%eax
  8009be:	c1 e0 02             	shl    $0x2,%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d8                	add    %ebx,%eax
  8009c7:	83 e8 30             	sub    $0x30,%eax
  8009ca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009cd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d1:	0f b6 00             	movzbl (%rax),%eax
  8009d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009da:	7e 0c                	jle    8009e8 <vprintfmt+0x105>
  8009dc:	83 fb 39             	cmp    $0x39,%ebx
  8009df:	7f 07                	jg     8009e8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e6:	eb d1                	jmp    8009b9 <vprintfmt+0xd6>
			goto process_precision;
  8009e8:	eb 58                	jmp    800a42 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ed:	83 f8 30             	cmp    $0x30,%eax
  8009f0:	73 17                	jae    800a09 <vprintfmt+0x126>
  8009f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 01 d0             	add    %rdx,%rax
  8009fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a01:	83 c2 08             	add    $0x8,%edx
  800a04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a07:	eb 0f                	jmp    800a18 <vprintfmt+0x135>
  800a09:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0d:	48 89 d0             	mov    %rdx,%rax
  800a10:	48 83 c2 08          	add    $0x8,%rdx
  800a14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a18:	8b 00                	mov    (%rax),%eax
  800a1a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a1d:	eb 23                	jmp    800a42 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a23:	79 0c                	jns    800a31 <vprintfmt+0x14e>
				width = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a2c:	e9 3b ff ff ff       	jmpq   80096c <vprintfmt+0x89>
  800a31:	e9 36 ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a36:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a3d:	e9 2a ff ff ff       	jmpq   80096c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a46:	79 12                	jns    800a5a <vprintfmt+0x177>
				width = precision, precision = -1;
  800a48:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a4b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a55:	e9 12 ff ff ff       	jmpq   80096c <vprintfmt+0x89>
  800a5a:	e9 0d ff ff ff       	jmpq   80096c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a63:	e9 04 ff ff ff       	jmpq   80096c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6b:	83 f8 30             	cmp    $0x30,%eax
  800a6e:	73 17                	jae    800a87 <vprintfmt+0x1a4>
  800a70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a77:	89 c0                	mov    %eax,%eax
  800a79:	48 01 d0             	add    %rdx,%rax
  800a7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7f:	83 c2 08             	add    $0x8,%edx
  800a82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a85:	eb 0f                	jmp    800a96 <vprintfmt+0x1b3>
  800a87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8b:	48 89 d0             	mov    %rdx,%rax
  800a8e:	48 83 c2 08          	add    $0x8,%rdx
  800a92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a96:	8b 10                	mov    (%rax),%edx
  800a98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	48 89 ce             	mov    %rcx,%rsi
  800aa3:	89 d7                	mov    %edx,%edi
  800aa5:	ff d0                	callq  *%rax
			break;
  800aa7:	e9 40 03 00 00       	jmpq   800dec <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aaf:	83 f8 30             	cmp    $0x30,%eax
  800ab2:	73 17                	jae    800acb <vprintfmt+0x1e8>
  800ab4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abb:	89 c0                	mov    %eax,%eax
  800abd:	48 01 d0             	add    %rdx,%rax
  800ac0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac3:	83 c2 08             	add    $0x8,%edx
  800ac6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac9:	eb 0f                	jmp    800ada <vprintfmt+0x1f7>
  800acb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acf:	48 89 d0             	mov    %rdx,%rax
  800ad2:	48 83 c2 08          	add    $0x8,%rdx
  800ad6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ada:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	79 02                	jns    800ae2 <vprintfmt+0x1ff>
				err = -err;
  800ae0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae2:	83 fb 15             	cmp    $0x15,%ebx
  800ae5:	7f 16                	jg     800afd <vprintfmt+0x21a>
  800ae7:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  800aee:	00 00 00 
  800af1:	48 63 d3             	movslq %ebx,%rdx
  800af4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800af8:	4d 85 e4             	test   %r12,%r12
  800afb:	75 2e                	jne    800b2b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800afd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	89 d9                	mov    %ebx,%ecx
  800b07:	48 ba 01 46 80 00 00 	movabs $0x804601,%rdx
  800b0e:	00 00 00 
  800b11:	48 89 c7             	mov    %rax,%rdi
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800b20:	00 00 00 
  800b23:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b26:	e9 c1 02 00 00       	jmpq   800dec <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b33:	4c 89 e1             	mov    %r12,%rcx
  800b36:	48 ba 0a 46 80 00 00 	movabs $0x80460a,%rdx
  800b3d:	00 00 00 
  800b40:	48 89 c7             	mov    %rax,%rdi
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800b4f:	00 00 00 
  800b52:	41 ff d0             	callq  *%r8
			break;
  800b55:	e9 92 02 00 00       	jmpq   800dec <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 17                	jae    800b79 <vprintfmt+0x296>
  800b62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b69:	89 c0                	mov    %eax,%eax
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b71:	83 c2 08             	add    $0x8,%edx
  800b74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b77:	eb 0f                	jmp    800b88 <vprintfmt+0x2a5>
  800b79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7d:	48 89 d0             	mov    %rdx,%rax
  800b80:	48 83 c2 08          	add    $0x8,%rdx
  800b84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b88:	4c 8b 20             	mov    (%rax),%r12
  800b8b:	4d 85 e4             	test   %r12,%r12
  800b8e:	75 0a                	jne    800b9a <vprintfmt+0x2b7>
				p = "(null)";
  800b90:	49 bc 0d 46 80 00 00 	movabs $0x80460d,%r12
  800b97:	00 00 00 
			if (width > 0 && padc != '-')
  800b9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9e:	7e 3f                	jle    800bdf <vprintfmt+0x2fc>
  800ba0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba4:	74 39                	je     800bdf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba9:	48 98                	cltq   
  800bab:	48 89 c6             	mov    %rax,%rsi
  800bae:	4c 89 e7             	mov    %r12,%rdi
  800bb1:	48 b8 a7 10 80 00 00 	movabs $0x8010a7,%rax
  800bb8:	00 00 00 
  800bbb:	ff d0                	callq  *%rax
  800bbd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc0:	eb 17                	jmp    800bd9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bc2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 ce             	mov    %rcx,%rsi
  800bd1:	89 d7                	mov    %edx,%edi
  800bd3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdd:	7f e3                	jg     800bc2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bdf:	eb 37                	jmp    800c18 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800be1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800be5:	74 1e                	je     800c05 <vprintfmt+0x322>
  800be7:	83 fb 1f             	cmp    $0x1f,%ebx
  800bea:	7e 05                	jle    800bf1 <vprintfmt+0x30e>
  800bec:	83 fb 7e             	cmp    $0x7e,%ebx
  800bef:	7e 14                	jle    800c05 <vprintfmt+0x322>
					putch('?', putdat);
  800bf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf9:	48 89 d6             	mov    %rdx,%rsi
  800bfc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c01:	ff d0                	callq  *%rax
  800c03:	eb 0f                	jmp    800c14 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 df                	mov    %ebx,%edi
  800c12:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c18:	4c 89 e0             	mov    %r12,%rax
  800c1b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c1f:	0f b6 00             	movzbl (%rax),%eax
  800c22:	0f be d8             	movsbl %al,%ebx
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	74 10                	je     800c39 <vprintfmt+0x356>
  800c29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2d:	78 b2                	js     800be1 <vprintfmt+0x2fe>
  800c2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c37:	79 a8                	jns    800be1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c39:	eb 16                	jmp    800c51 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c43:	48 89 d6             	mov    %rdx,%rsi
  800c46:	bf 20 00 00 00       	mov    $0x20,%edi
  800c4b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c55:	7f e4                	jg     800c3b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c57:	e9 90 01 00 00       	jmpq   800dec <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c60:	be 03 00 00 00       	mov    $0x3,%esi
  800c65:	48 89 c7             	mov    %rax,%rdi
  800c68:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800c6f:	00 00 00 
  800c72:	ff d0                	callq  *%rax
  800c74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7c:	48 85 c0             	test   %rax,%rax
  800c7f:	79 1d                	jns    800c9e <vprintfmt+0x3bb>
				putch('-', putdat);
  800c81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c89:	48 89 d6             	mov    %rdx,%rsi
  800c8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c91:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c97:	48 f7 d8             	neg    %rax
  800c9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca5:	e9 d5 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800caa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cae:	be 03 00 00 00       	mov    $0x3,%esi
  800cb3:	48 89 c7             	mov    %rax,%rdi
  800cb6:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	callq  *%rax
  800cc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cc6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ccd:	e9 ad 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cd2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800cd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	48 89 c7             	mov    %rax,%rdi
  800cde:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800ce5:	00 00 00 
  800ce8:	ff d0                	callq  *%rax
  800cea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cee:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cf5:	e9 85 00 00 00       	jmpq   800d7f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cfa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 d6             	mov    %rdx,%rsi
  800d05:	bf 30 00 00 00       	mov    $0x30,%edi
  800d0a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d14:	48 89 d6             	mov    %rdx,%rsi
  800d17:	bf 78 00 00 00       	mov    $0x78,%edi
  800d1c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d21:	83 f8 30             	cmp    $0x30,%eax
  800d24:	73 17                	jae    800d3d <vprintfmt+0x45a>
  800d26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	89 c0                	mov    %eax,%eax
  800d2f:	48 01 d0             	add    %rdx,%rax
  800d32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d35:	83 c2 08             	add    $0x8,%edx
  800d38:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d3b:	eb 0f                	jmp    800d4c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d41:	48 89 d0             	mov    %rdx,%rax
  800d44:	48 83 c2 08          	add    $0x8,%rdx
  800d48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d53:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d5a:	eb 23                	jmp    800d7f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d60:	be 03 00 00 00       	mov    $0x3,%esi
  800d65:	48 89 c7             	mov    %rax,%rdi
  800d68:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800d6f:	00 00 00 
  800d72:	ff d0                	callq  *%rax
  800d74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d78:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d7f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d84:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d87:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d96:	45 89 c1             	mov    %r8d,%r9d
  800d99:	41 89 f8             	mov    %edi,%r8d
  800d9c:	48 89 c7             	mov    %rax,%rdi
  800d9f:	48 b8 08 06 80 00 00 	movabs $0x800608,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	callq  *%rax
			break;
  800dab:	eb 3f                	jmp    800dec <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db5:	48 89 d6             	mov    %rdx,%rsi
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	ff d0                	callq  *%rax
			break;
  800dbc:	eb 2e                	jmp    800dec <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	48 89 d6             	mov    %rdx,%rsi
  800dc9:	bf 25 00 00 00       	mov    $0x25,%edi
  800dce:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd5:	eb 05                	jmp    800ddc <vprintfmt+0x4f9>
  800dd7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ddc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800de0:	48 83 e8 01          	sub    $0x1,%rax
  800de4:	0f b6 00             	movzbl (%rax),%eax
  800de7:	3c 25                	cmp    $0x25,%al
  800de9:	75 ec                	jne    800dd7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800deb:	90                   	nop
		}
	}
  800dec:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ded:	e9 43 fb ff ff       	jmpq   800935 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800df2:	48 83 c4 60          	add    $0x60,%rsp
  800df6:	5b                   	pop    %rbx
  800df7:	41 5c                	pop    %r12
  800df9:	5d                   	pop    %rbp
  800dfa:	c3                   	retq   

0000000000800dfb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e0d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 20                	je     800e4d <printfmt+0x52>
  800e2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e4d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e54:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e5b:	00 00 00 
  800e5e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e65:	00 00 00 
  800e68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e81:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e88:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e8f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e96:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e9d:	48 89 c7             	mov    %rax,%rdi
  800ea0:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800ea7:	00 00 00 
  800eaa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eac:	c9                   	leaveq 
  800ead:	c3                   	retq   

0000000000800eae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eae:	55                   	push   %rbp
  800eaf:	48 89 e5             	mov    %rsp,%rbp
  800eb2:	48 83 ec 10          	sub    $0x10,%rsp
  800eb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	8b 40 10             	mov    0x10(%rax),%eax
  800ec4:	8d 50 01             	lea    0x1(%rax),%edx
  800ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed2:	48 8b 10             	mov    (%rax),%rdx
  800ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800edd:	48 39 c2             	cmp    %rax,%rdx
  800ee0:	73 17                	jae    800ef9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee6:	48 8b 00             	mov    (%rax),%rax
  800ee9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ef1:	48 89 0a             	mov    %rcx,(%rdx)
  800ef4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef7:	88 10                	mov    %dl,(%rax)
}
  800ef9:	c9                   	leaveq 
  800efa:	c3                   	retq   

0000000000800efb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800efb:	55                   	push   %rbp
  800efc:	48 89 e5             	mov    %rsp,%rbp
  800eff:	48 83 ec 50          	sub    $0x50,%rsp
  800f03:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f07:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f0a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f0e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f12:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f16:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f1a:	48 8b 0a             	mov    (%rdx),%rcx
  800f1d:	48 89 08             	mov    %rcx,(%rax)
  800f20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f34:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f38:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f3b:	48 98                	cltq   
  800f3d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f45:	48 01 d0             	add    %rdx,%rax
  800f48:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f58:	74 06                	je     800f60 <vsnprintf+0x65>
  800f5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f5e:	7f 07                	jg     800f67 <vsnprintf+0x6c>
		return -E_INVAL;
  800f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f65:	eb 2f                	jmp    800f96 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f67:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f6b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f73:	48 89 c6             	mov    %rax,%rsi
  800f76:	48 bf ae 0e 80 00 00 	movabs $0x800eae,%rdi
  800f7d:	00 00 00 
  800f80:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  800f87:	00 00 00 
  800f8a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f90:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f93:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800faa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fb0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fbe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 20                	je     800fe9 <snprintf+0x51>
  800fc9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fcd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fdd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ff0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff7:	00 00 00 
  800ffa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801001:	00 00 00 
  801004:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801008:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80100f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801016:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80101d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801024:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80102b:	48 8b 0a             	mov    (%rdx),%rcx
  80102e:	48 89 08             	mov    %rcx,(%rax)
  801031:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801035:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801039:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801041:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801048:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80104f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801055:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80105c:	48 89 c7             	mov    %rax,%rdi
  80105f:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  801066:	00 00 00 
  801069:	ff d0                	callq  *%rax
  80106b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801071:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 18          	sub    $0x18,%rsp
  801081:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80108c:	eb 09                	jmp    801097 <strlen+0x1e>
		n++;
  80108e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801092:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109b:	0f b6 00             	movzbl (%rax),%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	75 ec                	jne    80108e <strlen+0x15>
		n++;
	return n;
  8010a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 20          	sub    $0x20,%rsp
  8010af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010be:	eb 0e                	jmp    8010ce <strnlen+0x27>
		n++;
  8010c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010ce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d3:	74 0b                	je     8010e0 <strnlen+0x39>
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	84 c0                	test   %al,%al
  8010de:	75 e0                	jne    8010c0 <strnlen+0x19>
		n++;
	return n;
  8010e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010fd:	90                   	nop
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801106:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80110e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801112:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801116:	0f b6 12             	movzbl (%rdx),%edx
  801119:	88 10                	mov    %dl,(%rax)
  80111b:	0f b6 00             	movzbl (%rax),%eax
  80111e:	84 c0                	test   %al,%al
  801120:	75 dc                	jne    8010fe <strcpy+0x19>
		/* do nothing */;
	return ret;
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801126:	c9                   	leaveq 
  801127:	c3                   	retq   

0000000000801128 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	48 83 ec 20          	sub    $0x20,%rsp
  801130:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 89 c7             	mov    %rax,%rdi
  80113f:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  801146:	00 00 00 
  801149:	ff d0                	callq  *%rax
  80114b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80114e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801151:	48 63 d0             	movslq %eax,%rdx
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	48 01 c2             	add    %rax,%rdx
  80115b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115f:	48 89 c6             	mov    %rax,%rsi
  801162:	48 89 d7             	mov    %rdx,%rdi
  801165:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax
	return dst;
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 28          	sub    $0x28,%rsp
  80117f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801187:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801193:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80119a:	00 
  80119b:	eb 2a                	jmp    8011c7 <strncpy+0x50>
		*dst++ = *src;
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ad:	0f b6 12             	movzbl (%rdx),%edx
  8011b0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	84 c0                	test   %al,%al
  8011bb:	74 05                	je     8011c2 <strncpy+0x4b>
			src++;
  8011bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011cf:	72 cc                	jb     80119d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 28          	sub    $0x28,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f8:	74 3d                	je     801237 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011fa:	eb 1d                	jmp    801219 <strlcpy+0x42>
			*dst++ = *src++;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801210:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801214:	0f b6 12             	movzbl (%rdx),%edx
  801217:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801219:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80121e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801223:	74 0b                	je     801230 <strlcpy+0x59>
  801225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801229:	0f b6 00             	movzbl (%rax),%eax
  80122c:	84 c0                	test   %al,%al
  80122e:	75 cc                	jne    8011fc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801237:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	48 29 c2             	sub    %rax,%rdx
  801242:	48 89 d0             	mov    %rdx,%rax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 10          	sub    $0x10,%rsp
  80124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801253:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801257:	eb 0a                	jmp    801263 <strcmp+0x1c>
		p++, q++;
  801259:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 00             	movzbl (%rax),%eax
  80126a:	84 c0                	test   %al,%al
  80126c:	74 12                	je     801280 <strcmp+0x39>
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 10             	movzbl (%rax),%edx
  801275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	38 c2                	cmp    %al,%dl
  80127e:	74 d9                	je     801259 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 d0             	movzbl %al,%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	29 c2                	sub    %eax,%edx
  801296:	89 d0                	mov    %edx,%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 18          	sub    $0x18,%rsp
  8012a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012ae:	eb 0f                	jmp    8012bf <strncmp+0x25>
		n--, p++, q++;
  8012b0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c4:	74 1d                	je     8012e3 <strncmp+0x49>
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 12                	je     8012e3 <strncmp+0x49>
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 10             	movzbl (%rax),%edx
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	38 c2                	cmp    %al,%dl
  8012e1:	74 cd                	je     8012b0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e8:	75 07                	jne    8012f1 <strncmp+0x57>
		return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ef:	eb 18                	jmp    801309 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 d0             	movzbl %al,%edx
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	0f b6 c0             	movzbl %al,%eax
  801305:	29 c2                	sub    %eax,%edx
  801307:	89 d0                	mov    %edx,%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 0c          	sub    $0xc,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	89 f0                	mov    %esi,%eax
  801319:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131c:	eb 17                	jmp    801335 <strchr+0x2a>
		if (*s == c)
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801328:	75 06                	jne    801330 <strchr+0x25>
			return (char *) s;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 15                	jmp    801345 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801330:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	84 c0                	test   %al,%al
  80133e:	75 de                	jne    80131e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 0c          	sub    $0xc,%rsp
  80134f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801353:	89 f0                	mov    %esi,%eax
  801355:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801358:	eb 13                	jmp    80136d <strfind+0x26>
		if (*s == c)
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801364:	75 02                	jne    801368 <strfind+0x21>
			break;
  801366:	eb 10                	jmp    801378 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801368:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	84 c0                	test   %al,%al
  801376:	75 e2                	jne    80135a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 18          	sub    $0x18,%rsp
  801386:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80138d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801391:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801396:	75 06                	jne    80139e <memset+0x20>
		return v;
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	eb 69                	jmp    801407 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80139e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a2:	83 e0 03             	and    $0x3,%eax
  8013a5:	48 85 c0             	test   %rax,%rax
  8013a8:	75 48                	jne    8013f2 <memset+0x74>
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	83 e0 03             	and    $0x3,%eax
  8013b1:	48 85 c0             	test   %rax,%rax
  8013b4:	75 3c                	jne    8013f2 <memset+0x74>
		c &= 0xFF;
  8013b6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c0:	c1 e0 18             	shl    $0x18,%eax
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c8:	c1 e0 10             	shl    $0x10,%eax
  8013cb:	09 c2                	or     %eax,%edx
  8013cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d0:	c1 e0 08             	shl    $0x8,%eax
  8013d3:	09 d0                	or     %edx,%eax
  8013d5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 c1 e8 02          	shr    $0x2,%rax
  8013e0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ea:	48 89 d7             	mov    %rdx,%rdi
  8013ed:	fc                   	cld    
  8013ee:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f0:	eb 11                	jmp    801403 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013fd:	48 89 d7             	mov    %rdx,%rdi
  801400:	fc                   	cld    
  801401:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801429:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801435:	0f 83 88 00 00 00    	jae    8014c3 <memmove+0xba>
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801443:	48 01 d0             	add    %rdx,%rax
  801446:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144a:	76 77                	jbe    8014c3 <memmove+0xba>
		s += n;
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 3b                	jne    8014a3 <memmove+0x9a>
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	83 e0 03             	and    $0x3,%eax
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	75 2f                	jne    8014a3 <memmove+0x9a>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	48 85 c0             	test   %rax,%rax
  80147e:	75 23                	jne    8014a3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	48 83 e8 04          	sub    $0x4,%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 83 ea 04          	sub    $0x4,%rdx
  801490:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801494:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801498:	48 89 c7             	mov    %rax,%rdi
  80149b:	48 89 d6             	mov    %rdx,%rsi
  80149e:	fd                   	std    
  80149f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a1:	eb 1d                	jmp    8014c0 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 89 d7             	mov    %rdx,%rdi
  8014ba:	48 89 c1             	mov    %rax,%rcx
  8014bd:	fd                   	std    
  8014be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c0:	fc                   	cld    
  8014c1:	eb 57                	jmp    80151a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	83 e0 03             	and    $0x3,%eax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 36                	jne    801505 <memmove+0xfc>
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	83 e0 03             	and    $0x3,%eax
  8014d6:	48 85 c0             	test   %rax,%rax
  8014d9:	75 2a                	jne    801505 <memmove+0xfc>
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	83 e0 03             	and    $0x3,%eax
  8014e2:	48 85 c0             	test   %rax,%rax
  8014e5:	75 1e                	jne    801505 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	48 c1 e8 02          	shr    $0x2,%rax
  8014ef:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fa:	48 89 c7             	mov    %rax,%rdi
  8014fd:	48 89 d6             	mov    %rdx,%rsi
  801500:	fc                   	cld    
  801501:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801503:	eb 15                	jmp    80151a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801511:	48 89 c7             	mov    %rax,%rdi
  801514:	48 89 d6             	mov    %rdx,%rsi
  801517:	fc                   	cld    
  801518:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151e:	c9                   	leaveq 
  80151f:	c3                   	retq   

0000000000801520 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801520:	55                   	push   %rbp
  801521:	48 89 e5             	mov    %rsp,%rbp
  801524:	48 83 ec 18          	sub    $0x18,%rsp
  801528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801530:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801538:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80153c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801540:	48 89 ce             	mov    %rcx,%rsi
  801543:	48 89 c7             	mov    %rax,%rdi
  801546:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  80154d:	00 00 00 
  801550:	ff d0                	callq  *%rax
}
  801552:	c9                   	leaveq 
  801553:	c3                   	retq   

0000000000801554 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801554:	55                   	push   %rbp
  801555:	48 89 e5             	mov    %rsp,%rbp
  801558:	48 83 ec 28          	sub    $0x28,%rsp
  80155c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801564:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801570:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801574:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801578:	eb 36                	jmp    8015b0 <memcmp+0x5c>
		if (*s1 != *s2)
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 1a                	je     8015a6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 d0             	movzbl %al,%edx
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f b6 c0             	movzbl %al,%eax
  8015a0:	29 c2                	sub    %eax,%edx
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	eb 20                	jmp    8015c6 <memcmp+0x72>
		s1++, s2++;
  8015a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 b9                	jne    80157a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	c9                   	leaveq 
  8015c7:	c3                   	retq   

00000000008015c8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 28          	sub    $0x28,%rsp
  8015d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e3:	48 01 d0             	add    %rdx,%rax
  8015e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ea:	eb 15                	jmp    801601 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f0:	0f b6 10             	movzbl (%rax),%edx
  8015f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f6:	38 c2                	cmp    %al,%dl
  8015f8:	75 02                	jne    8015fc <memfind+0x34>
			break;
  8015fa:	eb 0f                	jmp    80160b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801609:	72 e1                	jb     8015ec <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80160b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160f:	c9                   	leaveq 
  801610:	c3                   	retq   

0000000000801611 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 34          	sub    $0x34,%rsp
  801619:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80161d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801621:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80162b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801632:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801633:	eb 05                	jmp    80163a <strtol+0x29>
		s++;
  801635:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3c 20                	cmp    $0x20,%al
  801643:	74 f0                	je     801635 <strtol+0x24>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 09                	cmp    $0x9,%al
  80164e:	74 e5                	je     801635 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 2b                	cmp    $0x2b,%al
  801659:	75 07                	jne    801662 <strtol+0x51>
		s++;
  80165b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801660:	eb 17                	jmp    801679 <strtol+0x68>
	else if (*s == '-')
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	3c 2d                	cmp    $0x2d,%al
  80166b:	75 0c                	jne    801679 <strtol+0x68>
		s++, neg = 1;
  80166d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167d:	74 06                	je     801685 <strtol+0x74>
  80167f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801683:	75 28                	jne    8016ad <strtol+0x9c>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 30                	cmp    $0x30,%al
  80168e:	75 1d                	jne    8016ad <strtol+0x9c>
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	48 83 c0 01          	add    $0x1,%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 78                	cmp    $0x78,%al
  80169d:	75 0e                	jne    8016ad <strtol+0x9c>
		s += 2, base = 16;
  80169f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016ab:	eb 2c                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b1:	75 19                	jne    8016cc <strtol+0xbb>
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 30                	cmp    $0x30,%al
  8016bc:	75 0e                	jne    8016cc <strtol+0xbb>
		s++, base = 8;
  8016be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ca:	eb 0d                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0)
  8016cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d0:	75 07                	jne    8016d9 <strtol+0xc8>
		base = 10;
  8016d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	3c 2f                	cmp    $0x2f,%al
  8016e2:	7e 1d                	jle    801701 <strtol+0xf0>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 39                	cmp    $0x39,%al
  8016ed:	7f 12                	jg     801701 <strtol+0xf0>
			dig = *s - '0';
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	0f be c0             	movsbl %al,%eax
  8016f9:	83 e8 30             	sub    $0x30,%eax
  8016fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ff:	eb 4e                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801705:	0f b6 00             	movzbl (%rax),%eax
  801708:	3c 60                	cmp    $0x60,%al
  80170a:	7e 1d                	jle    801729 <strtol+0x118>
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 7a                	cmp    $0x7a,%al
  801715:	7f 12                	jg     801729 <strtol+0x118>
			dig = *s - 'a' + 10;
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	0f be c0             	movsbl %al,%eax
  801721:	83 e8 57             	sub    $0x57,%eax
  801724:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801727:	eb 26                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	3c 40                	cmp    $0x40,%al
  801732:	7e 48                	jle    80177c <strtol+0x16b>
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 5a                	cmp    $0x5a,%al
  80173d:	7f 3d                	jg     80177c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	0f be c0             	movsbl %al,%eax
  801749:	83 e8 37             	sub    $0x37,%eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80174f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801752:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801755:	7c 02                	jl     801759 <strtol+0x148>
			break;
  801757:	eb 23                	jmp    80177c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801759:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801761:	48 98                	cltq   
  801763:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801768:	48 89 c2             	mov    %rax,%rdx
  80176b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176e:	48 98                	cltq   
  801770:	48 01 d0             	add    %rdx,%rax
  801773:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801777:	e9 5d ff ff ff       	jmpq   8016d9 <strtol+0xc8>

	if (endptr)
  80177c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801781:	74 0b                	je     80178e <strtol+0x17d>
		*endptr = (char *) s;
  801783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801787:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80178b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80178e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801792:	74 09                	je     80179d <strtol+0x18c>
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	48 f7 d8             	neg    %rax
  80179b:	eb 04                	jmp    8017a1 <strtol+0x190>
  80179d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017a1:	c9                   	leaveq 
  8017a2:	c3                   	retq   

00000000008017a3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	48 83 ec 30          	sub    $0x30,%rsp
  8017ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017bb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017c5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c9:	75 06                	jne    8017d1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	eb 6b                	jmp    80183c <strstr+0x99>

	len = strlen(str);
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017fc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801800:	75 07                	jne    801809 <strstr+0x66>
				return (char *) 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb 33                	jmp    80183c <strstr+0x99>
		} while (sc != c);
  801809:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80180d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801810:	75 d8                	jne    8017ea <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801812:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801816:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	48 89 ce             	mov    %rcx,%rsi
  801821:	48 89 c7             	mov    %rax,%rdi
  801824:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
  801830:	85 c0                	test   %eax,%eax
  801832:	75 b6                	jne    8017ea <strstr+0x47>

	return (char *) (in - 1);
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	48 83 e8 01          	sub    $0x1,%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	53                   	push   %rbx
  801843:	48 83 ec 48          	sub    $0x48,%rsp
  801847:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80184a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80184d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801851:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801855:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801859:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801860:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801864:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801868:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80186c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801870:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801874:	4c 89 c3             	mov    %r8,%rbx
  801877:	cd 30                	int    $0x30
  801879:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80187d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801881:	74 3e                	je     8018c1 <syscall+0x83>
  801883:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801888:	7e 37                	jle    8018c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801891:	49 89 d0             	mov    %rdx,%r8
  801894:	89 c1                	mov    %eax,%ecx
  801896:	48 ba c8 48 80 00 00 	movabs $0x8048c8,%rdx
  80189d:	00 00 00 
  8018a0:	be 23 00 00 00       	mov    $0x23,%esi
  8018a5:	48 bf e5 48 80 00 00 	movabs $0x8048e5,%rdi
  8018ac:	00 00 00 
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  8018bb:	00 00 00 
  8018be:	41 ff d1             	callq  *%r9

	return ret;
  8018c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c5:	48 83 c4 48          	add    $0x48,%rsp
  8018c9:	5b                   	pop    %rbx
  8018ca:	5d                   	pop    %rbp
  8018cb:	c3                   	retq   

00000000008018cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 20          	sub    $0x20,%rsp
  8018d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	48 89 d1             	mov    %rdx,%rcx
  8018fb:	48 89 c2             	mov    %rax,%rdx
  8018fe:	be 00 00 00 00       	mov    $0x0,%esi
  801903:	bf 00 00 00 00       	mov    $0x0,%edi
  801908:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_cgetc>:

int
sys_cgetc(void)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80191e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801925:	00 
  801926:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801932:	b9 00 00 00 00       	mov    $0x0,%ecx
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	be 00 00 00 00       	mov    $0x0,%esi
  801941:	bf 01 00 00 00       	mov    $0x1,%edi
  801946:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 10          	sub    $0x10,%rsp
  80195c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196b:	00 
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 01 00 00 00       	mov    $0x1,%esi
  801985:	bf 03 00 00 00       	mov    $0x3,%edi
  80198a:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	be 00 00 00 00       	mov    $0x0,%esi
  8019c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c8:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
}
  8019d4:	c9                   	leaveq 
  8019d5:	c3                   	retq   

00000000008019d6 <sys_yield>:

void
sys_yield(void)
{
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
  8019da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e5:	00 
  8019e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a06:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
}
  801a12:	c9                   	leaveq 
  801a13:	c3                   	retq   

0000000000801a14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a14:	55                   	push   %rbp
  801a15:	48 89 e5             	mov    %rsp,%rbp
  801a18:	48 83 ec 20          	sub    $0x20,%rsp
  801a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a29:	48 63 c8             	movslq %eax,%rcx
  801a2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3c:	00 
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	49 89 c8             	mov    %rcx,%r8
  801a46:	48 89 d1             	mov    %rdx,%rcx
  801a49:	48 89 c2             	mov    %rax,%rdx
  801a4c:	be 01 00 00 00       	mov    $0x1,%esi
  801a51:	bf 04 00 00 00       	mov    $0x4,%edi
  801a56:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a5d:	00 00 00 
  801a60:	ff d0                	callq  *%rax
}
  801a62:	c9                   	leaveq 
  801a63:	c3                   	retq   

0000000000801a64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a64:	55                   	push   %rbp
  801a65:	48 89 e5             	mov    %rsp,%rbp
  801a68:	48 83 ec 30          	sub    $0x30,%rsp
  801a6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a73:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a76:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a7a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a81:	48 63 c8             	movslq %eax,%rcx
  801a84:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8b:	48 63 f0             	movslq %eax,%rsi
  801a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 98                	cltq   
  801a97:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a9b:	49 89 f9             	mov    %rdi,%r9
  801a9e:	49 89 f0             	mov    %rsi,%r8
  801aa1:	48 89 d1             	mov    %rdx,%rcx
  801aa4:	48 89 c2             	mov    %rax,%rdx
  801aa7:	be 01 00 00 00       	mov    $0x1,%esi
  801aac:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab1:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 20          	sub    $0x20,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ace:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ade:	00 
  801adf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aeb:	48 89 d1             	mov    %rdx,%rcx
  801aee:	48 89 c2             	mov    %rax,%rdx
  801af1:	be 01 00 00 00       	mov    $0x1,%esi
  801af6:	bf 06 00 00 00       	mov    $0x6,%edi
  801afb:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b14:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1a:	48 63 d0             	movslq %eax,%rdx
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b20:	48 98                	cltq   
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 08 00 00 00       	mov    $0x8,%edi
  801b46:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
}
  801b52:	c9                   	leaveq 
  801b53:	c3                   	retq   

0000000000801b54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b54:	55                   	push   %rbp
  801b55:	48 89 e5             	mov    %rsp,%rbp
  801b58:	48 83 ec 20          	sub    $0x20,%rsp
  801b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6a:	48 98                	cltq   
  801b6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b73:	00 
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	48 89 d1             	mov    %rdx,%rcx
  801b83:	48 89 c2             	mov    %rax,%rdx
  801b86:	be 01 00 00 00       	mov    $0x1,%esi
  801b8b:	bf 09 00 00 00       	mov    $0x9,%edi
  801b90:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
}
  801b9c:	c9                   	leaveq 
  801b9d:	c3                   	retq   

0000000000801b9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 20          	sub    $0x20,%rsp
  801ba6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb4:	48 98                	cltq   
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bda:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 20          	sub    $0x20,%rsp
  801bf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bfb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c01:	48 63 f0             	movslq %eax,%rsi
  801c04:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c18:	00 
  801c19:	49 89 f1             	mov    %rsi,%r9
  801c1c:	49 89 c8             	mov    %rcx,%r8
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 00 00 00 00       	mov    $0x0,%esi
  801c2a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c2f:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c54:	00 
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	48 89 c2             	mov    %rax,%rdx
  801c69:	be 01 00 00 00       	mov    $0x1,%esi
  801c6e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c73:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 20          	sub    $0x20,%rsp
  801c89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca0:	00 
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 01 00 00 00       	mov    $0x1,%esi
  801cb8:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cbd:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 10          	sub    $0x10,%rsp
  801cd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801cd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce2:	00 
  801ce3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cef:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf4:	48 89 c2             	mov    %rax,%rdx
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 10 00 00 00       	mov    $0x10,%edi
  801d01:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1e:	00 
  801d1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d30:	ba 00 00 00 00       	mov    $0x0,%edx
  801d35:	be 00 00 00 00       	mov    $0x0,%esi
  801d3a:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d3f:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
}
  801d4b:	c9                   	leaveq 
  801d4c:	c3                   	retq   

0000000000801d4d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d4d:	55                   	push   %rbp
  801d4e:	48 89 e5             	mov    %rsp,%rbp
  801d51:	48 83 ec 08          	sub    $0x8,%rsp
  801d55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d5d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d64:	ff ff ff 
  801d67:	48 01 d0             	add    %rdx,%rax
  801d6a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 08          	sub    $0x8,%rsp
  801d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d80:	48 89 c7             	mov    %rax,%rdi
  801d83:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d95:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 18          	sub    $0x18,%rsp
  801da3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801da7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dae:	eb 6b                	jmp    801e1b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db3:	48 98                	cltq   
  801db5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dbb:	48 c1 e0 0c          	shl    $0xc,%rax
  801dbf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc7:	48 c1 e8 15          	shr    $0x15,%rax
  801dcb:	48 89 c2             	mov    %rax,%rdx
  801dce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dd5:	01 00 00 
  801dd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ddc:	83 e0 01             	and    $0x1,%eax
  801ddf:	48 85 c0             	test   %rax,%rax
  801de2:	74 21                	je     801e05 <fd_alloc+0x6a>
  801de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de8:	48 c1 e8 0c          	shr    $0xc,%rax
  801dec:	48 89 c2             	mov    %rax,%rdx
  801def:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801df6:	01 00 00 
  801df9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dfd:	83 e0 01             	and    $0x1,%eax
  801e00:	48 85 c0             	test   %rax,%rax
  801e03:	75 12                	jne    801e17 <fd_alloc+0x7c>
			*fd_store = fd;
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	eb 1a                	jmp    801e31 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e17:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e1b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e1f:	7e 8f                	jle    801db0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e25:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e2c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 20          	sub    $0x20,%rsp
  801e3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e46:	78 06                	js     801e4e <fd_lookup+0x1b>
  801e48:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e4c:	7e 07                	jle    801e55 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e53:	eb 6c                	jmp    801ec1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e58:	48 98                	cltq   
  801e5a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e60:	48 c1 e0 0c          	shl    $0xc,%rax
  801e64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6c:	48 c1 e8 15          	shr    $0x15,%rax
  801e70:	48 89 c2             	mov    %rax,%rdx
  801e73:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e7a:	01 00 00 
  801e7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e81:	83 e0 01             	and    $0x1,%eax
  801e84:	48 85 c0             	test   %rax,%rax
  801e87:	74 21                	je     801eaa <fd_lookup+0x77>
  801e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e8d:	48 c1 e8 0c          	shr    $0xc,%rax
  801e91:	48 89 c2             	mov    %rax,%rdx
  801e94:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e9b:	01 00 00 
  801e9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea2:	83 e0 01             	and    $0x1,%eax
  801ea5:	48 85 c0             	test   %rax,%rax
  801ea8:	75 07                	jne    801eb1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eaf:	eb 10                	jmp    801ec1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec1:	c9                   	leaveq 
  801ec2:	c3                   	retq   

0000000000801ec3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ec3:	55                   	push   %rbp
  801ec4:	48 89 e5             	mov    %rsp,%rbp
  801ec7:	48 83 ec 30          	sub    $0x30,%rsp
  801ecb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ecf:	89 f0                	mov    %esi,%eax
  801ed1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ed4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed8:	48 89 c7             	mov    %rax,%rdi
  801edb:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eeb:	48 89 d6             	mov    %rdx,%rsi
  801eee:	89 c7                	mov    %eax,%edi
  801ef0:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
  801efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f03:	78 0a                	js     801f0f <fd_close+0x4c>
	    || fd != fd2)
  801f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f09:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f0d:	74 12                	je     801f21 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f0f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f13:	74 05                	je     801f1a <fd_close+0x57>
  801f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f18:	eb 05                	jmp    801f1f <fd_close+0x5c>
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	eb 69                	jmp    801f8a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	8b 00                	mov    (%rax),%eax
  801f27:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f2b:	48 89 d6             	mov    %rdx,%rsi
  801f2e:	89 c7                	mov    %eax,%edi
  801f30:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax
  801f3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f43:	78 2a                	js     801f6f <fd_close+0xac>
		if (dev->dev_close)
  801f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f49:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f4d:	48 85 c0             	test   %rax,%rax
  801f50:	74 16                	je     801f68 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f56:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f5a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f5e:	48 89 d7             	mov    %rdx,%rdi
  801f61:	ff d0                	callq  *%rax
  801f63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f66:	eb 07                	jmp    801f6f <fd_close+0xac>
		else
			r = 0;
  801f68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f73:	48 89 c6             	mov    %rax,%rsi
  801f76:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7b:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
	return r;
  801f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f8a:	c9                   	leaveq 
  801f8b:	c3                   	retq   

0000000000801f8c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f8c:	55                   	push   %rbp
  801f8d:	48 89 e5             	mov    %rsp,%rbp
  801f90:	48 83 ec 20          	sub    $0x20,%rsp
  801f94:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa2:	eb 41                	jmp    801fe5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fa4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fab:	00 00 00 
  801fae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb1:	48 63 d2             	movslq %edx,%rdx
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	8b 00                	mov    (%rax),%eax
  801fba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fbd:	75 22                	jne    801fe1 <dev_lookup+0x55>
			*dev = devtab[i];
  801fbf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc6:	00 00 00 
  801fc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcc:	48 63 d2             	movslq %edx,%rdx
  801fcf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 60                	jmp    802041 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fe1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fec:	00 00 00 
  801fef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff2:	48 63 d2             	movslq %edx,%rdx
  801ff5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff9:	48 85 c0             	test   %rax,%rax
  801ffc:	75 a6                	jne    801fa4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ffe:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802005:	00 00 00 
  802008:	48 8b 00             	mov    (%rax),%rax
  80200b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802011:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802014:	89 c6                	mov    %eax,%esi
  802016:	48 bf f8 48 80 00 00 	movabs $0x8048f8,%rdi
  80201d:	00 00 00 
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  80202c:	00 00 00 
  80202f:	ff d1                	callq  *%rcx
	*dev = 0;
  802031:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802035:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80203c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802041:	c9                   	leaveq 
  802042:	c3                   	retq   

0000000000802043 <close>:

int
close(int fdnum)
{
  802043:	55                   	push   %rbp
  802044:	48 89 e5             	mov    %rsp,%rbp
  802047:	48 83 ec 20          	sub    $0x20,%rsp
  80204b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802052:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802055:	48 89 d6             	mov    %rdx,%rsi
  802058:	89 c7                	mov    %eax,%edi
  80205a:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
  802066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802069:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206d:	79 05                	jns    802074 <close+0x31>
		return r;
  80206f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802072:	eb 18                	jmp    80208c <close+0x49>
	else
		return fd_close(fd, 1);
  802074:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802078:	be 01 00 00 00       	mov    $0x1,%esi
  80207d:	48 89 c7             	mov    %rax,%rdi
  802080:	48 b8 c3 1e 80 00 00 	movabs $0x801ec3,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax
}
  80208c:	c9                   	leaveq 
  80208d:	c3                   	retq   

000000000080208e <close_all>:

void
close_all(void)
{
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80209d:	eb 15                	jmp    8020b4 <close_all+0x26>
		close(i);
  80209f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a2:	89 c7                	mov    %eax,%edi
  8020a4:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020b8:	7e e5                	jle    80209f <close_all+0x11>
		close(i);
}
  8020ba:	c9                   	leaveq 
  8020bb:	c3                   	retq   

00000000008020bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020bc:	55                   	push   %rbp
  8020bd:	48 89 e5             	mov    %rsp,%rbp
  8020c0:	48 83 ec 40          	sub    $0x40,%rsp
  8020c4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020c7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020ca:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020d1:	48 89 d6             	mov    %rdx,%rsi
  8020d4:	89 c7                	mov    %eax,%edi
  8020d6:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e9:	79 08                	jns    8020f3 <dup+0x37>
		return r;
  8020eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ee:	e9 70 01 00 00       	jmpq   802263 <dup+0x1a7>
	close(newfdnum);
  8020f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020f6:	89 c7                	mov    %eax,%edi
  8020f8:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  8020ff:	00 00 00 
  802102:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802104:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802107:	48 98                	cltq   
  802109:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80210f:	48 c1 e0 0c          	shl    $0xc,%rax
  802113:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802117:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211b:	48 89 c7             	mov    %rax,%rdi
  80211e:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  802125:	00 00 00 
  802128:	ff d0                	callq  *%rax
  80212a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80212e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802132:	48 89 c7             	mov    %rax,%rdi
  802135:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	callq  *%rax
  802141:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802149:	48 c1 e8 15          	shr    $0x15,%rax
  80214d:	48 89 c2             	mov    %rax,%rdx
  802150:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802157:	01 00 00 
  80215a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215e:	83 e0 01             	and    $0x1,%eax
  802161:	48 85 c0             	test   %rax,%rax
  802164:	74 73                	je     8021d9 <dup+0x11d>
  802166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216a:	48 c1 e8 0c          	shr    $0xc,%rax
  80216e:	48 89 c2             	mov    %rax,%rdx
  802171:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802178:	01 00 00 
  80217b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217f:	83 e0 01             	and    $0x1,%eax
  802182:	48 85 c0             	test   %rax,%rax
  802185:	74 52                	je     8021d9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	48 c1 e8 0c          	shr    $0xc,%rax
  80218f:	48 89 c2             	mov    %rax,%rdx
  802192:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802199:	01 00 00 
  80219c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a5:	89 c1                	mov    %eax,%ecx
  8021a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021af:	41 89 c8             	mov    %ecx,%r8d
  8021b2:	48 89 d1             	mov    %rdx,%rcx
  8021b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ba:	48 89 c6             	mov    %rax,%rsi
  8021bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c2:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  8021c9:	00 00 00 
  8021cc:	ff d0                	callq  *%rax
  8021ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d5:	79 02                	jns    8021d9 <dup+0x11d>
			goto err;
  8021d7:	eb 57                	jmp    802230 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e1:	48 89 c2             	mov    %rax,%rdx
  8021e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021eb:	01 00 00 
  8021ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8021f7:	89 c1                	mov    %eax,%ecx
  8021f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802201:	41 89 c8             	mov    %ecx,%r8d
  802204:	48 89 d1             	mov    %rdx,%rcx
  802207:	ba 00 00 00 00       	mov    $0x0,%edx
  80220c:	48 89 c6             	mov    %rax,%rsi
  80220f:	bf 00 00 00 00       	mov    $0x0,%edi
  802214:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
  802220:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802223:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802227:	79 02                	jns    80222b <dup+0x16f>
		goto err;
  802229:	eb 05                	jmp    802230 <dup+0x174>

	return newfdnum;
  80222b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80222e:	eb 33                	jmp    802263 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802234:	48 89 c6             	mov    %rax,%rsi
  802237:	bf 00 00 00 00       	mov    $0x0,%edi
  80223c:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802248:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224c:	48 89 c6             	mov    %rax,%rsi
  80224f:	bf 00 00 00 00       	mov    $0x0,%edi
  802254:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	callq  *%rax
	return r;
  802260:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802263:	c9                   	leaveq 
  802264:	c3                   	retq   

0000000000802265 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802265:	55                   	push   %rbp
  802266:	48 89 e5             	mov    %rsp,%rbp
  802269:	48 83 ec 40          	sub    $0x40,%rsp
  80226d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802270:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802274:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802278:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80227c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80227f:	48 89 d6             	mov    %rdx,%rsi
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
  802290:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802297:	78 24                	js     8022bd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	8b 00                	mov    (%rax),%eax
  80229f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a3:	48 89 d6             	mov    %rdx,%rsi
  8022a6:	89 c7                	mov    %eax,%edi
  8022a8:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	callq  *%rax
  8022b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bb:	79 05                	jns    8022c2 <read+0x5d>
		return r;
  8022bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c0:	eb 76                	jmp    802338 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	8b 40 08             	mov    0x8(%rax),%eax
  8022c9:	83 e0 03             	and    $0x3,%eax
  8022cc:	83 f8 01             	cmp    $0x1,%eax
  8022cf:	75 3a                	jne    80230b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022d1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8022d8:	00 00 00 
  8022db:	48 8b 00             	mov    (%rax),%rax
  8022de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	48 bf 17 49 80 00 00 	movabs $0x804917,%rdi
  8022f0:	00 00 00 
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  8022ff:	00 00 00 
  802302:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802304:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802309:	eb 2d                	jmp    802338 <read+0xd3>
	}
	if (!dev->dev_read)
  80230b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802313:	48 85 c0             	test   %rax,%rax
  802316:	75 07                	jne    80231f <read+0xba>
		return -E_NOT_SUPP;
  802318:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80231d:	eb 19                	jmp    802338 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80231f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802323:	48 8b 40 10          	mov    0x10(%rax),%rax
  802327:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80232b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80232f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802333:	48 89 cf             	mov    %rcx,%rdi
  802336:	ff d0                	callq  *%rax
}
  802338:	c9                   	leaveq 
  802339:	c3                   	retq   

000000000080233a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80233a:	55                   	push   %rbp
  80233b:	48 89 e5             	mov    %rsp,%rbp
  80233e:	48 83 ec 30          	sub    $0x30,%rsp
  802342:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802349:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80234d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802354:	eb 49                	jmp    80239f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802359:	48 98                	cltq   
  80235b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80235f:	48 29 c2             	sub    %rax,%rdx
  802362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802365:	48 63 c8             	movslq %eax,%rcx
  802368:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80236c:	48 01 c1             	add    %rax,%rcx
  80236f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802372:	48 89 ce             	mov    %rcx,%rsi
  802375:	89 c7                	mov    %eax,%edi
  802377:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax
  802383:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802386:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238a:	79 05                	jns    802391 <readn+0x57>
			return m;
  80238c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80238f:	eb 1c                	jmp    8023ad <readn+0x73>
		if (m == 0)
  802391:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802395:	75 02                	jne    802399 <readn+0x5f>
			break;
  802397:	eb 11                	jmp    8023aa <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80239f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a2:	48 98                	cltq   
  8023a4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023a8:	72 ac                	jb     802356 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ad:	c9                   	leaveq 
  8023ae:	c3                   	retq   

00000000008023af <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023af:	55                   	push   %rbp
  8023b0:	48 89 e5             	mov    %rsp,%rbp
  8023b3:	48 83 ec 40          	sub    $0x40,%rsp
  8023b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023be:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c9:	48 89 d6             	mov    %rdx,%rsi
  8023cc:	89 c7                	mov    %eax,%edi
  8023ce:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
  8023da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e1:	78 24                	js     802407 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e7:	8b 00                	mov    (%rax),%eax
  8023e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ed:	48 89 d6             	mov    %rdx,%rsi
  8023f0:	89 c7                	mov    %eax,%edi
  8023f2:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
  8023fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802401:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802405:	79 05                	jns    80240c <write+0x5d>
		return r;
  802407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240a:	eb 75                	jmp    802481 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80240c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802410:	8b 40 08             	mov    0x8(%rax),%eax
  802413:	83 e0 03             	and    $0x3,%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	75 3a                	jne    802454 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80241a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802421:	00 00 00 
  802424:	48 8b 00             	mov    (%rax),%rax
  802427:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80242d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802430:	89 c6                	mov    %eax,%esi
  802432:	48 bf 33 49 80 00 00 	movabs $0x804933,%rdi
  802439:	00 00 00 
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  802448:	00 00 00 
  80244b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80244d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802452:	eb 2d                	jmp    802481 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802458:	48 8b 40 18          	mov    0x18(%rax),%rax
  80245c:	48 85 c0             	test   %rax,%rax
  80245f:	75 07                	jne    802468 <write+0xb9>
		return -E_NOT_SUPP;
  802461:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802466:	eb 19                	jmp    802481 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802470:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802474:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802478:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80247c:	48 89 cf             	mov    %rcx,%rdi
  80247f:	ff d0                	callq  *%rax
}
  802481:	c9                   	leaveq 
  802482:	c3                   	retq   

0000000000802483 <seek>:

int
seek(int fdnum, off_t offset)
{
  802483:	55                   	push   %rbp
  802484:	48 89 e5             	mov    %rsp,%rbp
  802487:	48 83 ec 18          	sub    $0x18,%rsp
  80248b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80248e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802491:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802495:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802498:	48 89 d6             	mov    %rdx,%rsi
  80249b:	89 c7                	mov    %eax,%edi
  80249d:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8024a4:	00 00 00 
  8024a7:	ff d0                	callq  *%rax
  8024a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b0:	79 05                	jns    8024b7 <seek+0x34>
		return r;
  8024b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b5:	eb 0f                	jmp    8024c6 <seek+0x43>
	fd->fd_offset = offset;
  8024b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024be:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c6:	c9                   	leaveq 
  8024c7:	c3                   	retq   

00000000008024c8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	48 83 ec 30          	sub    $0x30,%rsp
  8024d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024dd:	48 89 d6             	mov    %rdx,%rsi
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	78 24                	js     80251b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fb:	8b 00                	mov    (%rax),%eax
  8024fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802501:	48 89 d6             	mov    %rdx,%rsi
  802504:	89 c7                	mov    %eax,%edi
  802506:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  80250d:	00 00 00 
  802510:	ff d0                	callq  *%rax
  802512:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802519:	79 05                	jns    802520 <ftruncate+0x58>
		return r;
  80251b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251e:	eb 72                	jmp    802592 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802524:	8b 40 08             	mov    0x8(%rax),%eax
  802527:	83 e0 03             	and    $0x3,%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	75 3a                	jne    802568 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80252e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802535:	00 00 00 
  802538:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80253b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802541:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802544:	89 c6                	mov    %eax,%esi
  802546:	48 bf 50 49 80 00 00 	movabs $0x804950,%rdi
  80254d:	00 00 00 
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	48 b9 30 05 80 00 00 	movabs $0x800530,%rcx
  80255c:	00 00 00 
  80255f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802561:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802566:	eb 2a                	jmp    802592 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802570:	48 85 c0             	test   %rax,%rax
  802573:	75 07                	jne    80257c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802575:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80257a:	eb 16                	jmp    802592 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	48 8b 40 30          	mov    0x30(%rax),%rax
  802584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802588:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80258b:	89 ce                	mov    %ecx,%esi
  80258d:	48 89 d7             	mov    %rdx,%rdi
  802590:	ff d0                	callq  *%rax
}
  802592:	c9                   	leaveq 
  802593:	c3                   	retq   

0000000000802594 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802594:	55                   	push   %rbp
  802595:	48 89 e5             	mov    %rsp,%rbp
  802598:	48 83 ec 30          	sub    $0x30,%rsp
  80259c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80259f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025aa:	48 89 d6             	mov    %rdx,%rsi
  8025ad:	89 c7                	mov    %eax,%edi
  8025af:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	callq  *%rax
  8025bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c2:	78 24                	js     8025e8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c8:	8b 00                	mov    (%rax),%eax
  8025ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ce:	48 89 d6             	mov    %rdx,%rsi
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	48 b8 8c 1f 80 00 00 	movabs $0x801f8c,%rax
  8025da:	00 00 00 
  8025dd:	ff d0                	callq  *%rax
  8025df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e6:	79 05                	jns    8025ed <fstat+0x59>
		return r;
  8025e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025eb:	eb 5e                	jmp    80264b <fstat+0xb7>
	if (!dev->dev_stat)
  8025ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f5:	48 85 c0             	test   %rax,%rax
  8025f8:	75 07                	jne    802601 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ff:	eb 4a                	jmp    80264b <fstat+0xb7>
	stat->st_name[0] = 0;
  802601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802605:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802608:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802613:	00 00 00 
	stat->st_isdir = 0;
  802616:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80261a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802621:	00 00 00 
	stat->st_dev = dev;
  802624:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802628:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802637:	48 8b 40 28          	mov    0x28(%rax),%rax
  80263b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80263f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802643:	48 89 ce             	mov    %rcx,%rsi
  802646:	48 89 d7             	mov    %rdx,%rdi
  802649:	ff d0                	callq  *%rax
}
  80264b:	c9                   	leaveq 
  80264c:	c3                   	retq   

000000000080264d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80264d:	55                   	push   %rbp
  80264e:	48 89 e5             	mov    %rsp,%rbp
  802651:	48 83 ec 20          	sub    $0x20,%rsp
  802655:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802659:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80265d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802661:	be 00 00 00 00       	mov    $0x0,%esi
  802666:	48 89 c7             	mov    %rax,%rdi
  802669:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  802670:	00 00 00 
  802673:	ff d0                	callq  *%rax
  802675:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267c:	79 05                	jns    802683 <stat+0x36>
		return fd;
  80267e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802681:	eb 2f                	jmp    8026b2 <stat+0x65>
	r = fstat(fd, stat);
  802683:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802687:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268a:	48 89 d6             	mov    %rdx,%rsi
  80268d:	89 c7                	mov    %eax,%edi
  80268f:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
  80269b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	89 c7                	mov    %eax,%edi
  8026a3:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
	return r;
  8026af:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026b2:	c9                   	leaveq 
  8026b3:	c3                   	retq   

00000000008026b4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	48 83 ec 10          	sub    $0x10,%rsp
  8026bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026c3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ca:	00 00 00 
  8026cd:	8b 00                	mov    (%rax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	75 1d                	jne    8026f0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8026d8:	48 b8 45 42 80 00 00 	movabs $0x804245,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
  8026e4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026eb:	00 00 00 
  8026ee:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f7:	00 00 00 
  8026fa:	8b 00                	mov    (%rax),%eax
  8026fc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026ff:	b9 07 00 00 00       	mov    $0x7,%ecx
  802704:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80270b:	00 00 00 
  80270e:	89 c7                	mov    %eax,%edi
  802710:	48 b8 e3 41 80 00 00 	movabs $0x8041e3,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	ba 00 00 00 00       	mov    $0x0,%edx
  802725:	48 89 c6             	mov    %rax,%rsi
  802728:	bf 00 00 00 00       	mov    $0x0,%edi
  80272d:	48 b8 dd 40 80 00 00 	movabs $0x8040dd,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
}
  802739:	c9                   	leaveq 
  80273a:	c3                   	retq   

000000000080273b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80273b:	55                   	push   %rbp
  80273c:	48 89 e5             	mov    %rsp,%rbp
  80273f:	48 83 ec 30          	sub    $0x30,%rsp
  802743:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802747:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80274a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802751:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80275f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802764:	75 08                	jne    80276e <open+0x33>
	{
		return r;
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	e9 f2 00 00 00       	jmpq   802860 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80276e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802772:	48 89 c7             	mov    %rax,%rdi
  802775:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802784:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80278b:	7e 0a                	jle    802797 <open+0x5c>
	{
		return -E_BAD_PATH;
  80278d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802792:	e9 c9 00 00 00       	jmpq   802860 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802797:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80279e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80279f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8027a3:	48 89 c7             	mov    %rax,%rdi
  8027a6:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
  8027b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b9:	78 09                	js     8027c4 <open+0x89>
  8027bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bf:	48 85 c0             	test   %rax,%rax
  8027c2:	75 08                	jne    8027cc <open+0x91>
		{
			return r;
  8027c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c7:	e9 94 00 00 00       	jmpq   802860 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d0:	ba 00 04 00 00       	mov    $0x400,%edx
  8027d5:	48 89 c6             	mov    %rax,%rsi
  8027d8:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8027df:	00 00 00 
  8027e2:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8027f5:	00 00 00 
  8027f8:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027fb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802805:	48 89 c6             	mov    %rax,%rsi
  802808:	bf 01 00 00 00       	mov    $0x1,%edi
  80280d:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802814:	00 00 00 
  802817:	ff d0                	callq  *%rax
  802819:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802820:	79 2b                	jns    80284d <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802826:	be 00 00 00 00       	mov    $0x0,%esi
  80282b:	48 89 c7             	mov    %rax,%rdi
  80282e:	48 b8 c3 1e 80 00 00 	movabs $0x801ec3,%rax
  802835:	00 00 00 
  802838:	ff d0                	callq  *%rax
  80283a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80283d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802841:	79 05                	jns    802848 <open+0x10d>
			{
				return d;
  802843:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802846:	eb 18                	jmp    802860 <open+0x125>
			}
			return r;
  802848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284b:	eb 13                	jmp    802860 <open+0x125>
		}	
		return fd2num(fd_store);
  80284d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802851:	48 89 c7             	mov    %rax,%rdi
  802854:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802860:	c9                   	leaveq 
  802861:	c3                   	retq   

0000000000802862 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802862:	55                   	push   %rbp
  802863:	48 89 e5             	mov    %rsp,%rbp
  802866:	48 83 ec 10          	sub    $0x10,%rsp
  80286a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80286e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802872:	8b 50 0c             	mov    0xc(%rax),%edx
  802875:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80287c:	00 00 00 
  80287f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802881:	be 00 00 00 00       	mov    $0x0,%esi
  802886:	bf 06 00 00 00       	mov    $0x6,%edi
  80288b:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
}
  802897:	c9                   	leaveq 
  802898:	c3                   	retq   

0000000000802899 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802899:	55                   	push   %rbp
  80289a:	48 89 e5             	mov    %rsp,%rbp
  80289d:	48 83 ec 30          	sub    $0x30,%rsp
  8028a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028b9:	74 07                	je     8028c2 <devfile_read+0x29>
  8028bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028c0:	75 07                	jne    8028c9 <devfile_read+0x30>
		return -E_INVAL;
  8028c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c7:	eb 77                	jmp    802940 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cd:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028d7:	00 00 00 
  8028da:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028e3:	00 00 00 
  8028e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ea:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028ee:	be 00 00 00 00       	mov    $0x0,%esi
  8028f3:	bf 03 00 00 00       	mov    $0x3,%edi
  8028f8:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290b:	7f 05                	jg     802912 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80290d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802910:	eb 2e                	jmp    802940 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802912:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802915:	48 63 d0             	movslq %eax,%rdx
  802918:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80291c:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802923:	00 00 00 
  802926:	48 89 c7             	mov    %rax,%rdi
  802929:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  802930:	00 00 00 
  802933:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802935:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802939:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80293d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802940:	c9                   	leaveq 
  802941:	c3                   	retq   

0000000000802942 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	48 83 ec 30          	sub    $0x30,%rsp
  80294a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80294e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802952:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802956:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80295d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802962:	74 07                	je     80296b <devfile_write+0x29>
  802964:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802969:	75 08                	jne    802973 <devfile_write+0x31>
		return r;
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	e9 9a 00 00 00       	jmpq   802a0d <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802977:	8b 50 0c             	mov    0xc(%rax),%edx
  80297a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802981:	00 00 00 
  802984:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802986:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80298d:	00 
  80298e:	76 08                	jbe    802998 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802990:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802997:	00 
	}
	fsipcbuf.write.req_n = n;
  802998:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80299f:	00 00 00 
  8029a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b2:	48 89 c6             	mov    %rax,%rsi
  8029b5:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  8029bc:	00 00 00 
  8029bf:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029cb:	be 00 00 00 00       	mov    $0x0,%esi
  8029d0:	bf 04 00 00 00       	mov    $0x4,%edi
  8029d5:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
  8029e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e8:	7f 20                	jg     802a0a <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029ea:	48 bf 76 49 80 00 00 	movabs $0x804976,%rdi
  8029f1:	00 00 00 
  8029f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f9:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802a00:	00 00 00 
  802a03:	ff d2                	callq  *%rdx
		return r;
  802a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a08:	eb 03                	jmp    802a0d <devfile_write+0xcb>
	}
	return r;
  802a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a0d:	c9                   	leaveq 
  802a0e:	c3                   	retq   

0000000000802a0f <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a0f:	55                   	push   %rbp
  802a10:	48 89 e5             	mov    %rsp,%rbp
  802a13:	48 83 ec 20          	sub    $0x20,%rsp
  802a17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a23:	8b 50 0c             	mov    0xc(%rax),%edx
  802a26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a2d:	00 00 00 
  802a30:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a32:	be 00 00 00 00       	mov    $0x0,%esi
  802a37:	bf 05 00 00 00       	mov    $0x5,%edi
  802a3c:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4f:	79 05                	jns    802a56 <devfile_stat+0x47>
		return r;
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a54:	eb 56                	jmp    802aac <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802a61:	00 00 00 
  802a64:	48 89 c7             	mov    %rax,%rdi
  802a67:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a73:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a7a:	00 00 00 
  802a7d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a87:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a8d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a94:	00 00 00 
  802a97:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aac:	c9                   	leaveq 
  802aad:	c3                   	retq   

0000000000802aae <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802aae:	55                   	push   %rbp
  802aaf:	48 89 e5             	mov    %rsp,%rbp
  802ab2:	48 83 ec 10          	sub    $0x10,%rsp
  802ab6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aba:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802abd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ac4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802acb:	00 00 00 
  802ace:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ad0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ad7:	00 00 00 
  802ada:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802add:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ae0:	be 00 00 00 00       	mov    $0x0,%esi
  802ae5:	bf 02 00 00 00       	mov    $0x2,%edi
  802aea:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
}
  802af6:	c9                   	leaveq 
  802af7:	c3                   	retq   

0000000000802af8 <remove>:

// Delete a file
int
remove(const char *path)
{
  802af8:	55                   	push   %rbp
  802af9:	48 89 e5             	mov    %rsp,%rbp
  802afc:	48 83 ec 10          	sub    $0x10,%rsp
  802b00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b08:	48 89 c7             	mov    %rax,%rdi
  802b0b:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
  802b17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b1c:	7e 07                	jle    802b25 <remove+0x2d>
		return -E_BAD_PATH;
  802b1e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b23:	eb 33                	jmp    802b58 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b29:	48 89 c6             	mov    %rax,%rsi
  802b2c:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802b33:	00 00 00 
  802b36:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802b3d:	00 00 00 
  802b40:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b42:	be 00 00 00 00       	mov    $0x0,%esi
  802b47:	bf 07 00 00 00       	mov    $0x7,%edi
  802b4c:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
}
  802b58:	c9                   	leaveq 
  802b59:	c3                   	retq   

0000000000802b5a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b5a:	55                   	push   %rbp
  802b5b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b5e:	be 00 00 00 00       	mov    $0x0,%esi
  802b63:	bf 08 00 00 00       	mov    $0x8,%edi
  802b68:	48 b8 b4 26 80 00 00 	movabs $0x8026b4,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
}
  802b74:	5d                   	pop    %rbp
  802b75:	c3                   	retq   

0000000000802b76 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b76:	55                   	push   %rbp
  802b77:	48 89 e5             	mov    %rsp,%rbp
  802b7a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b81:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b88:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b8f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b96:	be 00 00 00 00       	mov    $0x0,%esi
  802b9b:	48 89 c7             	mov    %rax,%rdi
  802b9e:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
  802baa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb1:	79 28                	jns    802bdb <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb6:	89 c6                	mov    %eax,%esi
  802bb8:	48 bf 92 49 80 00 00 	movabs $0x804992,%rdi
  802bbf:	00 00 00 
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802bce:	00 00 00 
  802bd1:	ff d2                	callq  *%rdx
		return fd_src;
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd6:	e9 74 01 00 00       	jmpq   802d4f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bdb:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802be2:	be 01 01 00 00       	mov    $0x101,%esi
  802be7:	48 89 c7             	mov    %rax,%rdi
  802bea:	48 b8 3b 27 80 00 00 	movabs $0x80273b,%rax
  802bf1:	00 00 00 
  802bf4:	ff d0                	callq  *%rax
  802bf6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bf9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bfd:	79 39                	jns    802c38 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c02:	89 c6                	mov    %eax,%esi
  802c04:	48 bf a8 49 80 00 00 	movabs $0x8049a8,%rdi
  802c0b:	00 00 00 
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c13:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802c1a:	00 00 00 
  802c1d:	ff d2                	callq  *%rdx
		close(fd_src);
  802c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c22:	89 c7                	mov    %eax,%edi
  802c24:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
		return fd_dest;
  802c30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c33:	e9 17 01 00 00       	jmpq   802d4f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c38:	eb 74                	jmp    802cae <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c3d:	48 63 d0             	movslq %eax,%rdx
  802c40:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4a:	48 89 ce             	mov    %rcx,%rsi
  802c4d:	89 c7                	mov    %eax,%edi
  802c4f:	48 b8 af 23 80 00 00 	movabs $0x8023af,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
  802c5b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c62:	79 4a                	jns    802cae <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c64:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c67:	89 c6                	mov    %eax,%esi
  802c69:	48 bf c2 49 80 00 00 	movabs $0x8049c2,%rdi
  802c70:	00 00 00 
  802c73:	b8 00 00 00 00       	mov    $0x0,%eax
  802c78:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802c7f:	00 00 00 
  802c82:	ff d2                	callq  *%rdx
			close(fd_src);
  802c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c87:	89 c7                	mov    %eax,%edi
  802c89:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
			close(fd_dest);
  802c95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c98:	89 c7                	mov    %eax,%edi
  802c9a:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
			return write_size;
  802ca6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ca9:	e9 a1 00 00 00       	jmpq   802d4f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cae:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb8:	ba 00 02 00 00       	mov    $0x200,%edx
  802cbd:	48 89 ce             	mov    %rcx,%rsi
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
  802cce:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cd5:	0f 8f 5f ff ff ff    	jg     802c3a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cdf:	79 47                	jns    802d28 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802ce1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce4:	89 c6                	mov    %eax,%esi
  802ce6:	48 bf d5 49 80 00 00 	movabs $0x8049d5,%rdi
  802ced:	00 00 00 
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	48 ba 30 05 80 00 00 	movabs $0x800530,%rdx
  802cfc:	00 00 00 
  802cff:	ff d2                	callq  *%rdx
		close(fd_src);
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	89 c7                	mov    %eax,%edi
  802d06:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax
		close(fd_dest);
  802d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
		return read_size;
  802d23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d26:	eb 27                	jmp    802d4f <copy+0x1d9>
	}
	close(fd_src);
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	89 c7                	mov    %eax,%edi
  802d2d:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
	close(fd_dest);
  802d39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3c:	89 c7                	mov    %eax,%edi
  802d3e:	48 b8 43 20 80 00 00 	movabs $0x802043,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	return 0;
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d4f:	c9                   	leaveq 
  802d50:	c3                   	retq   

0000000000802d51 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d51:	55                   	push   %rbp
  802d52:	48 89 e5             	mov    %rsp,%rbp
  802d55:	48 83 ec 20          	sub    $0x20,%rsp
  802d59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d61:	8b 40 0c             	mov    0xc(%rax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	7e 67                	jle    802dcf <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6c:	8b 40 04             	mov    0x4(%rax),%eax
  802d6f:	48 63 d0             	movslq %eax,%rdx
  802d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d76:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7e:	8b 00                	mov    (%rax),%eax
  802d80:	48 89 ce             	mov    %rcx,%rsi
  802d83:	89 c7                	mov    %eax,%edi
  802d85:	48 b8 af 23 80 00 00 	movabs $0x8023af,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d98:	7e 13                	jle    802dad <writebuf+0x5c>
			b->result += result;
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	8b 50 08             	mov    0x8(%rax),%edx
  802da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da4:	01 c2                	add    %eax,%edx
  802da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daa:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db1:	8b 40 04             	mov    0x4(%rax),%eax
  802db4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802db7:	74 16                	je     802dcf <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc2:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcc:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802dcf:	c9                   	leaveq 
  802dd0:	c3                   	retq   

0000000000802dd1 <putch>:

static void
putch(int ch, void *thunk)
{
  802dd1:	55                   	push   %rbp
  802dd2:	48 89 e5             	mov    %rsp,%rbp
  802dd5:	48 83 ec 20          	sub    $0x20,%rsp
  802dd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ddc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802de0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dec:	8b 40 04             	mov    0x4(%rax),%eax
  802def:	8d 48 01             	lea    0x1(%rax),%ecx
  802df2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802df6:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802df9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dfc:	89 d1                	mov    %edx,%ecx
  802dfe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e02:	48 98                	cltq   
  802e04:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0c:	8b 40 04             	mov    0x4(%rax),%eax
  802e0f:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e14:	75 1e                	jne    802e34 <putch+0x63>
		writebuf(b);
  802e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1a:	48 89 c7             	mov    %rax,%rdi
  802e1d:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
		b->idx = 0;
  802e29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e34:	c9                   	leaveq 
  802e35:	c3                   	retq   

0000000000802e36 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e41:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e47:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e4e:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e55:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e5b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e61:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e68:	00 00 00 
	b.result = 0;
  802e6b:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e72:	00 00 00 
	b.error = 1;
  802e75:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e7c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e7f:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e86:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e8d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e94:	48 89 c6             	mov    %rax,%rsi
  802e97:	48 bf d1 2d 80 00 00 	movabs $0x802dd1,%rdi
  802e9e:	00 00 00 
  802ea1:	48 b8 e3 08 80 00 00 	movabs $0x8008e3,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ead:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	7e 16                	jle    802ecd <vfprintf+0x97>
		writebuf(&b);
  802eb7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ebe:	48 89 c7             	mov    %rax,%rdi
  802ec1:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802ecd:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 08                	je     802edf <vfprintf+0xa9>
  802ed7:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802edd:	eb 06                	jmp    802ee5 <vfprintf+0xaf>
  802edf:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ee5:	c9                   	leaveq 
  802ee6:	c3                   	retq   

0000000000802ee7 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ee7:	55                   	push   %rbp
  802ee8:	48 89 e5             	mov    %rsp,%rbp
  802eeb:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ef2:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ef8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802eff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f14:	84 c0                	test   %al,%al
  802f16:	74 20                	je     802f38 <fprintf+0x51>
  802f18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f38:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f3f:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f46:	00 00 00 
  802f49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f50:	00 00 00 
  802f53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f6c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f73:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f7a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f80:	48 89 ce             	mov    %rcx,%rsi
  802f83:	89 c7                	mov    %eax,%edi
  802f85:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  802f8c:	00 00 00 
  802f8f:	ff d0                	callq  *%rax
  802f91:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f9d:	c9                   	leaveq 
  802f9e:	c3                   	retq   

0000000000802f9f <printf>:

int
printf(const char *fmt, ...)
{
  802f9f:	55                   	push   %rbp
  802fa0:	48 89 e5             	mov    %rsp,%rbp
  802fa3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802faa:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fb1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fb8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fbf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fc6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fcd:	84 c0                	test   %al,%al
  802fcf:	74 20                	je     802ff1 <printf+0x52>
  802fd1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fd5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fd9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fdd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fe1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fe5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fe9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fed:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ff1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ff8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802fff:	00 00 00 
  803002:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803009:	00 00 00 
  80300c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803010:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803017:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80301e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803025:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80302c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803033:	48 89 c6             	mov    %rax,%rsi
  803036:	bf 01 00 00 00       	mov    $0x1,%edi
  80303b:	48 b8 36 2e 80 00 00 	movabs $0x802e36,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80304d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803053:	c9                   	leaveq 
  803054:	c3                   	retq   

0000000000803055 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803055:	55                   	push   %rbp
  803056:	48 89 e5             	mov    %rsp,%rbp
  803059:	48 83 ec 20          	sub    $0x20,%rsp
  80305d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803060:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803064:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803067:	48 89 d6             	mov    %rdx,%rsi
  80306a:	89 c7                	mov    %eax,%edi
  80306c:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
  803078:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307f:	79 05                	jns    803086 <fd2sockid+0x31>
		return r;
  803081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803084:	eb 24                	jmp    8030aa <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308a:	8b 10                	mov    (%rax),%edx
  80308c:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803093:	00 00 00 
  803096:	8b 00                	mov    (%rax),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	74 07                	je     8030a3 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80309c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030a1:	eb 07                	jmp    8030aa <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8030a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a7:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8030aa:	c9                   	leaveq 
  8030ab:	c3                   	retq   

00000000008030ac <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8030ac:	55                   	push   %rbp
  8030ad:	48 89 e5             	mov    %rsp,%rbp
  8030b0:	48 83 ec 20          	sub    $0x20,%rsp
  8030b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030b7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030bb:	48 89 c7             	mov    %rax,%rdi
  8030be:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
  8030ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d1:	78 26                	js     8030f9 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8030d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8030dc:	48 89 c6             	mov    %rax,%rsi
  8030df:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e4:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  8030eb:	00 00 00 
  8030ee:	ff d0                	callq  *%rax
  8030f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f7:	79 16                	jns    80310f <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8030f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 b9 35 80 00 00 	movabs $0x8035b9,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
		return r;
  80310a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310d:	eb 3a                	jmp    803149 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80311a:	00 00 00 
  80311d:	8b 12                	mov    (%rdx),%edx
  80311f:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803125:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80312c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803130:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803133:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
}
  803149:	c9                   	leaveq 
  80314a:	c3                   	retq   

000000000080314b <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80314b:	55                   	push   %rbp
  80314c:	48 89 e5             	mov    %rsp,%rbp
  80314f:	48 83 ec 30          	sub    $0x30,%rsp
  803153:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803156:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80315a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80315e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803161:	89 c7                	mov    %eax,%edi
  803163:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
  80316f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803176:	79 05                	jns    80317d <accept+0x32>
		return r;
  803178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317b:	eb 3b                	jmp    8031b8 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80317d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803181:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803188:	48 89 ce             	mov    %rcx,%rsi
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 96 34 80 00 00 	movabs $0x803496,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a0:	79 05                	jns    8031a7 <accept+0x5c>
		return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a5:	eb 11                	jmp    8031b8 <accept+0x6d>
	return alloc_sockfd(r);
  8031a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031aa:	89 c7                	mov    %eax,%edi
  8031ac:	48 b8 ac 30 80 00 00 	movabs $0x8030ac,%rax
  8031b3:	00 00 00 
  8031b6:	ff d0                	callq  *%rax
}
  8031b8:	c9                   	leaveq 
  8031b9:	c3                   	retq   

00000000008031ba <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031ba:	55                   	push   %rbp
  8031bb:	48 89 e5             	mov    %rsp,%rbp
  8031be:	48 83 ec 20          	sub    $0x20,%rsp
  8031c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031c9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031cf:	89 c7                	mov    %eax,%edi
  8031d1:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
  8031dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e4:	79 05                	jns    8031eb <bind+0x31>
		return r;
  8031e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e9:	eb 1b                	jmp    803206 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8031eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f5:	48 89 ce             	mov    %rcx,%rsi
  8031f8:	89 c7                	mov    %eax,%edi
  8031fa:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <shutdown>:

int
shutdown(int s, int how)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 20          	sub    $0x20,%rsp
  803210:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803213:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803216:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
  803227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322e:	79 05                	jns    803235 <shutdown+0x2d>
		return r;
  803230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803233:	eb 16                	jmp    80324b <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803235:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323b:	89 d6                	mov    %edx,%esi
  80323d:	89 c7                	mov    %eax,%edi
  80323f:	48 b8 79 35 80 00 00 	movabs $0x803579,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
}
  80324b:	c9                   	leaveq 
  80324c:	c3                   	retq   

000000000080324d <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80324d:	55                   	push   %rbp
  80324e:	48 89 e5             	mov    %rsp,%rbp
  803251:	48 83 ec 10          	sub    $0x10,%rsp
  803255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80325d:	48 89 c7             	mov    %rax,%rdi
  803260:	48 b8 c7 42 80 00 00 	movabs $0x8042c7,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	83 f8 01             	cmp    $0x1,%eax
  80326f:	75 17                	jne    803288 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803275:	8b 40 0c             	mov    0xc(%rax),%eax
  803278:	89 c7                	mov    %eax,%edi
  80327a:	48 b8 b9 35 80 00 00 	movabs $0x8035b9,%rax
  803281:	00 00 00 
  803284:	ff d0                	callq  *%rax
  803286:	eb 05                	jmp    80328d <devsock_close+0x40>
	else
		return 0;
  803288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80328d:	c9                   	leaveq 
  80328e:	c3                   	retq   

000000000080328f <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80328f:	55                   	push   %rbp
  803290:	48 89 e5             	mov    %rsp,%rbp
  803293:	48 83 ec 20          	sub    $0x20,%rsp
  803297:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80329a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80329e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a4:	89 c7                	mov    %eax,%edi
  8032a6:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
  8032b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b9:	79 05                	jns    8032c0 <connect+0x31>
		return r;
  8032bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032be:	eb 1b                	jmp    8032db <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8032c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ca:	48 89 ce             	mov    %rcx,%rsi
  8032cd:	89 c7                	mov    %eax,%edi
  8032cf:	48 b8 e6 35 80 00 00 	movabs $0x8035e6,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
}
  8032db:	c9                   	leaveq 
  8032dc:	c3                   	retq   

00000000008032dd <listen>:

int
listen(int s, int backlog)
{
  8032dd:	55                   	push   %rbp
  8032de:	48 89 e5             	mov    %rsp,%rbp
  8032e1:	48 83 ec 20          	sub    $0x20,%rsp
  8032e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ee:	89 c7                	mov    %eax,%edi
  8032f0:	48 b8 55 30 80 00 00 	movabs $0x803055,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
  8032fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803303:	79 05                	jns    80330a <listen+0x2d>
		return r;
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	eb 16                	jmp    803320 <listen+0x43>
	return nsipc_listen(r, backlog);
  80330a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80330d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803310:	89 d6                	mov    %edx,%esi
  803312:	89 c7                	mov    %eax,%edi
  803314:	48 b8 4a 36 80 00 00 	movabs $0x80364a,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
}
  803320:	c9                   	leaveq 
  803321:	c3                   	retq   

0000000000803322 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803322:	55                   	push   %rbp
  803323:	48 89 e5             	mov    %rsp,%rbp
  803326:	48 83 ec 20          	sub    $0x20,%rsp
  80332a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80332e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333a:	89 c2                	mov    %eax,%edx
  80333c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803340:	8b 40 0c             	mov    0xc(%rax),%eax
  803343:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803347:	b9 00 00 00 00       	mov    $0x0,%ecx
  80334c:	89 c7                	mov    %eax,%edi
  80334e:	48 b8 8a 36 80 00 00 	movabs $0x80368a,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
}
  80335a:	c9                   	leaveq 
  80335b:	c3                   	retq   

000000000080335c <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80335c:	55                   	push   %rbp
  80335d:	48 89 e5             	mov    %rsp,%rbp
  803360:	48 83 ec 20          	sub    $0x20,%rsp
  803364:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80336c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803374:	89 c2                	mov    %eax,%edx
  803376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337a:	8b 40 0c             	mov    0xc(%rax),%eax
  80337d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803381:	b9 00 00 00 00       	mov    $0x0,%ecx
  803386:	89 c7                	mov    %eax,%edi
  803388:	48 b8 56 37 80 00 00 	movabs $0x803756,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
}
  803394:	c9                   	leaveq 
  803395:	c3                   	retq   

0000000000803396 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803396:	55                   	push   %rbp
  803397:	48 89 e5             	mov    %rsp,%rbp
  80339a:	48 83 ec 10          	sub    $0x10,%rsp
  80339e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8033a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033aa:	48 be f0 49 80 00 00 	movabs $0x8049f0,%rsi
  8033b1:	00 00 00 
  8033b4:	48 89 c7             	mov    %rax,%rdi
  8033b7:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  8033be:	00 00 00 
  8033c1:	ff d0                	callq  *%rax
	return 0;
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033c8:	c9                   	leaveq 
  8033c9:	c3                   	retq   

00000000008033ca <socket>:

int
socket(int domain, int type, int protocol)
{
  8033ca:	55                   	push   %rbp
  8033cb:	48 89 e5             	mov    %rsp,%rbp
  8033ce:	48 83 ec 20          	sub    $0x20,%rsp
  8033d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033d5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033d8:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033db:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033de:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e4:	89 ce                	mov    %ecx,%esi
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 0e 38 80 00 00 	movabs $0x80380e,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fb:	79 05                	jns    803402 <socket+0x38>
		return r;
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	eb 11                	jmp    803413 <socket+0x49>
	return alloc_sockfd(r);
  803402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803405:	89 c7                	mov    %eax,%edi
  803407:	48 b8 ac 30 80 00 00 	movabs $0x8030ac,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
}
  803413:	c9                   	leaveq 
  803414:	c3                   	retq   

0000000000803415 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803415:	55                   	push   %rbp
  803416:	48 89 e5             	mov    %rsp,%rbp
  803419:	48 83 ec 10          	sub    $0x10,%rsp
  80341d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803420:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803427:	00 00 00 
  80342a:	8b 00                	mov    (%rax),%eax
  80342c:	85 c0                	test   %eax,%eax
  80342e:	75 1d                	jne    80344d <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803430:	bf 02 00 00 00       	mov    $0x2,%edi
  803435:	48 b8 45 42 80 00 00 	movabs $0x804245,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
  803441:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803448:	00 00 00 
  80344b:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80344d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803454:	00 00 00 
  803457:	8b 00                	mov    (%rax),%eax
  803459:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80345c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803461:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  803468:	00 00 00 
  80346b:	89 c7                	mov    %eax,%edi
  80346d:	48 b8 e3 41 80 00 00 	movabs $0x8041e3,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803479:	ba 00 00 00 00       	mov    $0x0,%edx
  80347e:	be 00 00 00 00       	mov    $0x0,%esi
  803483:	bf 00 00 00 00       	mov    $0x0,%edi
  803488:	48 b8 dd 40 80 00 00 	movabs $0x8040dd,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
}
  803494:	c9                   	leaveq 
  803495:	c3                   	retq   

0000000000803496 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803496:	55                   	push   %rbp
  803497:	48 89 e5             	mov    %rsp,%rbp
  80349a:	48 83 ec 30          	sub    $0x30,%rsp
  80349e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8034a9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034b0:	00 00 00 
  8034b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034b6:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034b8:	bf 01 00 00 00       	mov    $0x1,%edi
  8034bd:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  8034c4:	00 00 00 
  8034c7:	ff d0                	callq  *%rax
  8034c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d0:	78 3e                	js     803510 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8034d2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034d9:	00 00 00 
  8034dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e4:	8b 40 10             	mov    0x10(%rax),%eax
  8034e7:	89 c2                	mov    %eax,%edx
  8034e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f1:	48 89 ce             	mov    %rcx,%rsi
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803507:	8b 50 10             	mov    0x10(%rax),%edx
  80350a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803510:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 10          	sub    $0x10,%rsp
  80351d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803520:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803524:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803527:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80352e:	00 00 00 
  803531:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803534:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803536:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353d:	48 89 c6             	mov    %rax,%rsi
  803540:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803547:	00 00 00 
  80354a:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803556:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80355d:	00 00 00 
  803560:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803563:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803566:	bf 02 00 00 00       	mov    $0x2,%edi
  80356b:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
}
  803577:	c9                   	leaveq 
  803578:	c3                   	retq   

0000000000803579 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803579:	55                   	push   %rbp
  80357a:	48 89 e5             	mov    %rsp,%rbp
  80357d:	48 83 ec 10          	sub    $0x10,%rsp
  803581:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803584:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803587:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80358e:	00 00 00 
  803591:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803594:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803596:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80359d:	00 00 00 
  8035a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035a3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8035a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8035ab:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
}
  8035b7:	c9                   	leaveq 
  8035b8:	c3                   	retq   

00000000008035b9 <nsipc_close>:

int
nsipc_close(int s)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 10          	sub    $0x10,%rsp
  8035c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8035c4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8035cb:	00 00 00 
  8035ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035d1:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8035d3:	bf 04 00 00 00       	mov    $0x4,%edi
  8035d8:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  8035df:	00 00 00 
  8035e2:	ff d0                	callq  *%rax
}
  8035e4:	c9                   	leaveq 
  8035e5:	c3                   	retq   

00000000008035e6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035e6:	55                   	push   %rbp
  8035e7:	48 89 e5             	mov    %rsp,%rbp
  8035ea:	48 83 ec 10          	sub    $0x10,%rsp
  8035ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035f5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8035f8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8035ff:	00 00 00 
  803602:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803605:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803607:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80360a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360e:	48 89 c6             	mov    %rax,%rsi
  803611:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803618:	00 00 00 
  80361b:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803627:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80362e:	00 00 00 
  803631:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803634:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803637:	bf 05 00 00 00       	mov    $0x5,%edi
  80363c:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
}
  803648:	c9                   	leaveq 
  803649:	c3                   	retq   

000000000080364a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80364a:	55                   	push   %rbp
  80364b:	48 89 e5             	mov    %rsp,%rbp
  80364e:	48 83 ec 10          	sub    $0x10,%rsp
  803652:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803655:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803658:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80365f:	00 00 00 
  803662:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803665:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803667:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80366e:	00 00 00 
  803671:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803674:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803677:	bf 06 00 00 00       	mov    $0x6,%edi
  80367c:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
}
  803688:	c9                   	leaveq 
  803689:	c3                   	retq   

000000000080368a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80368a:	55                   	push   %rbp
  80368b:	48 89 e5             	mov    %rsp,%rbp
  80368e:	48 83 ec 30          	sub    $0x30,%rsp
  803692:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803695:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803699:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80369c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80369f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036a6:	00 00 00 
  8036a9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8036ae:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036b5:	00 00 00 
  8036b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8036be:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8036c5:	00 00 00 
  8036c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036cb:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8036ce:	bf 07 00 00 00       	mov    $0x7,%edi
  8036d3:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e6:	78 69                	js     803751 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8036e8:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8036ef:	7f 08                	jg     8036f9 <nsipc_recv+0x6f>
  8036f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f4:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8036f7:	7e 35                	jle    80372e <nsipc_recv+0xa4>
  8036f9:	48 b9 f7 49 80 00 00 	movabs $0x8049f7,%rcx
  803700:	00 00 00 
  803703:	48 ba 0c 4a 80 00 00 	movabs $0x804a0c,%rdx
  80370a:	00 00 00 
  80370d:	be 61 00 00 00       	mov    $0x61,%esi
  803712:	48 bf 21 4a 80 00 00 	movabs $0x804a21,%rdi
  803719:	00 00 00 
  80371c:	b8 00 00 00 00       	mov    $0x0,%eax
  803721:	49 b8 f7 02 80 00 00 	movabs $0x8002f7,%r8
  803728:	00 00 00 
  80372b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80372e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803731:	48 63 d0             	movslq %eax,%rdx
  803734:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803738:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  80373f:	00 00 00 
  803742:	48 89 c7             	mov    %rax,%rdi
  803745:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
	}

	return r;
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803754:	c9                   	leaveq 
  803755:	c3                   	retq   

0000000000803756 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803756:	55                   	push   %rbp
  803757:	48 89 e5             	mov    %rsp,%rbp
  80375a:	48 83 ec 20          	sub    $0x20,%rsp
  80375e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803761:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803765:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803768:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80376b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803772:	00 00 00 
  803775:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803778:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80377a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803781:	7e 35                	jle    8037b8 <nsipc_send+0x62>
  803783:	48 b9 2d 4a 80 00 00 	movabs $0x804a2d,%rcx
  80378a:	00 00 00 
  80378d:	48 ba 0c 4a 80 00 00 	movabs $0x804a0c,%rdx
  803794:	00 00 00 
  803797:	be 6c 00 00 00       	mov    $0x6c,%esi
  80379c:	48 bf 21 4a 80 00 00 	movabs $0x804a21,%rdi
  8037a3:	00 00 00 
  8037a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ab:	49 b8 f7 02 80 00 00 	movabs $0x8002f7,%r8
  8037b2:	00 00 00 
  8037b5:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037bb:	48 63 d0             	movslq %eax,%rdx
  8037be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c2:	48 89 c6             	mov    %rax,%rsi
  8037c5:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8037cc:	00 00 00 
  8037cf:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8037db:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8037e2:	00 00 00 
  8037e5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037e8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8037eb:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8037f2:	00 00 00 
  8037f5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037f8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8037fb:	bf 08 00 00 00       	mov    $0x8,%edi
  803800:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
}
  80380c:	c9                   	leaveq 
  80380d:	c3                   	retq   

000000000080380e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80380e:	55                   	push   %rbp
  80380f:	48 89 e5             	mov    %rsp,%rbp
  803812:	48 83 ec 10          	sub    $0x10,%rsp
  803816:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803819:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80381c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80381f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803826:	00 00 00 
  803829:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80382c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80382e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803835:	00 00 00 
  803838:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80383b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80383e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803845:	00 00 00 
  803848:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80384b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80384e:	bf 09 00 00 00       	mov    $0x9,%edi
  803853:	48 b8 15 34 80 00 00 	movabs $0x803415,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
}
  80385f:	c9                   	leaveq 
  803860:	c3                   	retq   

0000000000803861 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803861:	55                   	push   %rbp
  803862:	48 89 e5             	mov    %rsp,%rbp
  803865:	53                   	push   %rbx
  803866:	48 83 ec 38          	sub    $0x38,%rsp
  80386a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80386e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803872:	48 89 c7             	mov    %rax,%rdi
  803875:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803884:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803888:	0f 88 bf 01 00 00    	js     803a4d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80388e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803892:	ba 07 04 00 00       	mov    $0x407,%edx
  803897:	48 89 c6             	mov    %rax,%rsi
  80389a:	bf 00 00 00 00       	mov    $0x0,%edi
  80389f:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038b2:	0f 88 95 01 00 00    	js     803a4d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038b8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038bc:	48 89 c7             	mov    %rax,%rdi
  8038bf:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
  8038cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038d2:	0f 88 5d 01 00 00    	js     803a35 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8038e1:	48 89 c6             	mov    %rax,%rsi
  8038e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e9:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038fc:	0f 88 33 01 00 00    	js     803a35 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803906:	48 89 c7             	mov    %rax,%rdi
  803909:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803919:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391d:	ba 07 04 00 00       	mov    $0x407,%edx
  803922:	48 89 c6             	mov    %rax,%rsi
  803925:	bf 00 00 00 00       	mov    $0x0,%edi
  80392a:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
  803936:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803939:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80393d:	79 05                	jns    803944 <pipe+0xe3>
		goto err2;
  80393f:	e9 d9 00 00 00       	jmpq   803a1d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803944:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803948:	48 89 c7             	mov    %rax,%rdi
  80394b:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
  803957:	48 89 c2             	mov    %rax,%rdx
  80395a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80395e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803964:	48 89 d1             	mov    %rdx,%rcx
  803967:	ba 00 00 00 00       	mov    $0x0,%edx
  80396c:	48 89 c6             	mov    %rax,%rsi
  80396f:	bf 00 00 00 00       	mov    $0x0,%edi
  803974:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  80397b:	00 00 00 
  80397e:	ff d0                	callq  *%rax
  803980:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803983:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803987:	79 1b                	jns    8039a4 <pipe+0x143>
		goto err3;
  803989:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80398a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80398e:	48 89 c6             	mov    %rax,%rsi
  803991:	bf 00 00 00 00       	mov    $0x0,%edi
  803996:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	eb 79                	jmp    803a1d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039af:	00 00 00 
  8039b2:	8b 12                	mov    (%rdx),%edx
  8039b4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039cc:	00 00 00 
  8039cf:	8b 12                	mov    (%rdx),%edx
  8039d1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e2:	48 89 c7             	mov    %rax,%rdi
  8039e5:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
  8039f1:	89 c2                	mov    %eax,%edx
  8039f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039f7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039f9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039fd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
  803a14:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a16:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1b:	eb 33                	jmp    803a50 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a21:	48 89 c6             	mov    %rax,%rsi
  803a24:	bf 00 00 00 00       	mov    $0x0,%edi
  803a29:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a39:	48 89 c6             	mov    %rax,%rsi
  803a3c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a41:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
err:
	return r;
  803a4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a50:	48 83 c4 38          	add    $0x38,%rsp
  803a54:	5b                   	pop    %rbx
  803a55:	5d                   	pop    %rbp
  803a56:	c3                   	retq   

0000000000803a57 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a57:	55                   	push   %rbp
  803a58:	48 89 e5             	mov    %rsp,%rbp
  803a5b:	53                   	push   %rbx
  803a5c:	48 83 ec 28          	sub    $0x28,%rsp
  803a60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a68:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803a6f:	00 00 00 
  803a72:	48 8b 00             	mov    (%rax),%rax
  803a75:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a82:	48 89 c7             	mov    %rax,%rdi
  803a85:	48 b8 c7 42 80 00 00 	movabs $0x8042c7,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 c3                	mov    %eax,%ebx
  803a93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a97:	48 89 c7             	mov    %rax,%rdi
  803a9a:	48 b8 c7 42 80 00 00 	movabs $0x8042c7,%rax
  803aa1:	00 00 00 
  803aa4:	ff d0                	callq  *%rax
  803aa6:	39 c3                	cmp    %eax,%ebx
  803aa8:	0f 94 c0             	sete   %al
  803aab:	0f b6 c0             	movzbl %al,%eax
  803aae:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ab1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803ab8:	00 00 00 
  803abb:	48 8b 00             	mov    (%rax),%rax
  803abe:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ac4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ac7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aca:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803acd:	75 05                	jne    803ad4 <_pipeisclosed+0x7d>
			return ret;
  803acf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ad2:	eb 4f                	jmp    803b23 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803ad4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ada:	74 42                	je     803b1e <_pipeisclosed+0xc7>
  803adc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ae0:	75 3c                	jne    803b1e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ae2:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803ae9:	00 00 00 
  803aec:	48 8b 00             	mov    (%rax),%rax
  803aef:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803af5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803af8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803afb:	89 c6                	mov    %eax,%esi
  803afd:	48 bf 3e 4a 80 00 00 	movabs $0x804a3e,%rdi
  803b04:	00 00 00 
  803b07:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0c:	49 b8 30 05 80 00 00 	movabs $0x800530,%r8
  803b13:	00 00 00 
  803b16:	41 ff d0             	callq  *%r8
	}
  803b19:	e9 4a ff ff ff       	jmpq   803a68 <_pipeisclosed+0x11>
  803b1e:	e9 45 ff ff ff       	jmpq   803a68 <_pipeisclosed+0x11>
}
  803b23:	48 83 c4 28          	add    $0x28,%rsp
  803b27:	5b                   	pop    %rbx
  803b28:	5d                   	pop    %rbp
  803b29:	c3                   	retq   

0000000000803b2a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b2a:	55                   	push   %rbp
  803b2b:	48 89 e5             	mov    %rsp,%rbp
  803b2e:	48 83 ec 30          	sub    $0x30,%rsp
  803b32:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b35:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b39:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b3c:	48 89 d6             	mov    %rdx,%rsi
  803b3f:	89 c7                	mov    %eax,%edi
  803b41:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  803b48:	00 00 00 
  803b4b:	ff d0                	callq  *%rax
  803b4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b54:	79 05                	jns    803b5b <pipeisclosed+0x31>
		return r;
  803b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b59:	eb 31                	jmp    803b8c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b5f:	48 89 c7             	mov    %rax,%rdi
  803b62:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803b69:	00 00 00 
  803b6c:	ff d0                	callq  *%rax
  803b6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b7a:	48 89 d6             	mov    %rdx,%rsi
  803b7d:	48 89 c7             	mov    %rax,%rdi
  803b80:	48 b8 57 3a 80 00 00 	movabs $0x803a57,%rax
  803b87:	00 00 00 
  803b8a:	ff d0                	callq  *%rax
}
  803b8c:	c9                   	leaveq 
  803b8d:	c3                   	retq   

0000000000803b8e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b8e:	55                   	push   %rbp
  803b8f:	48 89 e5             	mov    %rsp,%rbp
  803b92:	48 83 ec 40          	sub    $0x40,%rsp
  803b96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b9a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b9e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ba2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba6:	48 89 c7             	mov    %rax,%rdi
  803ba9:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803bb0:	00 00 00 
  803bb3:	ff d0                	callq  *%rax
  803bb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bc1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bc8:	00 
  803bc9:	e9 92 00 00 00       	jmpq   803c60 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803bce:	eb 41                	jmp    803c11 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803bd0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bd5:	74 09                	je     803be0 <devpipe_read+0x52>
				return i;
  803bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bdb:	e9 92 00 00 00       	jmpq   803c72 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803be0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803be4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be8:	48 89 d6             	mov    %rdx,%rsi
  803beb:	48 89 c7             	mov    %rax,%rdi
  803bee:	48 b8 57 3a 80 00 00 	movabs $0x803a57,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
  803bfa:	85 c0                	test   %eax,%eax
  803bfc:	74 07                	je     803c05 <devpipe_read+0x77>
				return 0;
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803c03:	eb 6d                	jmp    803c72 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c05:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c15:	8b 10                	mov    (%rax),%edx
  803c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1b:	8b 40 04             	mov    0x4(%rax),%eax
  803c1e:	39 c2                	cmp    %eax,%edx
  803c20:	74 ae                	je     803bd0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c2a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c32:	8b 00                	mov    (%rax),%eax
  803c34:	99                   	cltd   
  803c35:	c1 ea 1b             	shr    $0x1b,%edx
  803c38:	01 d0                	add    %edx,%eax
  803c3a:	83 e0 1f             	and    $0x1f,%eax
  803c3d:	29 d0                	sub    %edx,%eax
  803c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c43:	48 98                	cltq   
  803c45:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c4a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c50:	8b 00                	mov    (%rax),%eax
  803c52:	8d 50 01             	lea    0x1(%rax),%edx
  803c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c59:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c5b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c64:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c68:	0f 82 60 ff ff ff    	jb     803bce <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c72:	c9                   	leaveq 
  803c73:	c3                   	retq   

0000000000803c74 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c74:	55                   	push   %rbp
  803c75:	48 89 e5             	mov    %rsp,%rbp
  803c78:	48 83 ec 40          	sub    $0x40,%rsp
  803c7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c84:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8c:	48 89 c7             	mov    %rax,%rdi
  803c8f:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
  803c9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ca7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cae:	00 
  803caf:	e9 8e 00 00 00       	jmpq   803d42 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803cb4:	eb 31                	jmp    803ce7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803cb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cbe:	48 89 d6             	mov    %rdx,%rsi
  803cc1:	48 89 c7             	mov    %rax,%rdi
  803cc4:	48 b8 57 3a 80 00 00 	movabs $0x803a57,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	85 c0                	test   %eax,%eax
  803cd2:	74 07                	je     803cdb <devpipe_write+0x67>
				return 0;
  803cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd9:	eb 79                	jmp    803d54 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cdb:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ceb:	8b 40 04             	mov    0x4(%rax),%eax
  803cee:	48 63 d0             	movslq %eax,%rdx
  803cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf5:	8b 00                	mov    (%rax),%eax
  803cf7:	48 98                	cltq   
  803cf9:	48 83 c0 20          	add    $0x20,%rax
  803cfd:	48 39 c2             	cmp    %rax,%rdx
  803d00:	73 b4                	jae    803cb6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d06:	8b 40 04             	mov    0x4(%rax),%eax
  803d09:	99                   	cltd   
  803d0a:	c1 ea 1b             	shr    $0x1b,%edx
  803d0d:	01 d0                	add    %edx,%eax
  803d0f:	83 e0 1f             	and    $0x1f,%eax
  803d12:	29 d0                	sub    %edx,%eax
  803d14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d18:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d1c:	48 01 ca             	add    %rcx,%rdx
  803d1f:	0f b6 0a             	movzbl (%rdx),%ecx
  803d22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d26:	48 98                	cltq   
  803d28:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d30:	8b 40 04             	mov    0x4(%rax),%eax
  803d33:	8d 50 01             	lea    0x1(%rax),%edx
  803d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d3d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d46:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d4a:	0f 82 64 ff ff ff    	jb     803cb4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d54:	c9                   	leaveq 
  803d55:	c3                   	retq   

0000000000803d56 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d56:	55                   	push   %rbp
  803d57:	48 89 e5             	mov    %rsp,%rbp
  803d5a:	48 83 ec 20          	sub    $0x20,%rsp
  803d5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d6a:	48 89 c7             	mov    %rax,%rdi
  803d6d:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803d74:	00 00 00 
  803d77:	ff d0                	callq  *%rax
  803d79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d81:	48 be 51 4a 80 00 00 	movabs $0x804a51,%rsi
  803d88:	00 00 00 
  803d8b:	48 89 c7             	mov    %rax,%rdi
  803d8e:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  803d95:	00 00 00 
  803d98:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9e:	8b 50 04             	mov    0x4(%rax),%edx
  803da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da5:	8b 00                	mov    (%rax),%eax
  803da7:	29 c2                	sub    %eax,%edx
  803da9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dad:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803db3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803dbe:	00 00 00 
	stat->st_dev = &devpipe;
  803dc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc5:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803dcc:	00 00 00 
  803dcf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ddb:	c9                   	leaveq 
  803ddc:	c3                   	retq   

0000000000803ddd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ddd:	55                   	push   %rbp
  803dde:	48 89 e5             	mov    %rsp,%rbp
  803de1:	48 83 ec 10          	sub    $0x10,%rsp
  803de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803de9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ded:	48 89 c6             	mov    %rax,%rsi
  803df0:	bf 00 00 00 00       	mov    $0x0,%edi
  803df5:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e05:	48 89 c7             	mov    %rax,%rdi
  803e08:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  803e0f:	00 00 00 
  803e12:	ff d0                	callq  *%rax
  803e14:	48 89 c6             	mov    %rax,%rsi
  803e17:	bf 00 00 00 00       	mov    $0x0,%edi
  803e1c:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803e23:	00 00 00 
  803e26:	ff d0                	callq  *%rax
}
  803e28:	c9                   	leaveq 
  803e29:	c3                   	retq   

0000000000803e2a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e2a:	55                   	push   %rbp
  803e2b:	48 89 e5             	mov    %rsp,%rbp
  803e2e:	48 83 ec 20          	sub    $0x20,%rsp
  803e32:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e38:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e3b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e3f:	be 01 00 00 00       	mov    $0x1,%esi
  803e44:	48 89 c7             	mov    %rax,%rdi
  803e47:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  803e4e:	00 00 00 
  803e51:	ff d0                	callq  *%rax
}
  803e53:	c9                   	leaveq 
  803e54:	c3                   	retq   

0000000000803e55 <getchar>:

int
getchar(void)
{
  803e55:	55                   	push   %rbp
  803e56:	48 89 e5             	mov    %rsp,%rbp
  803e59:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e5d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e61:	ba 01 00 00 00       	mov    $0x1,%edx
  803e66:	48 89 c6             	mov    %rax,%rsi
  803e69:	bf 00 00 00 00       	mov    $0x0,%edi
  803e6e:	48 b8 65 22 80 00 00 	movabs $0x802265,%rax
  803e75:	00 00 00 
  803e78:	ff d0                	callq  *%rax
  803e7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e81:	79 05                	jns    803e88 <getchar+0x33>
		return r;
  803e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e86:	eb 14                	jmp    803e9c <getchar+0x47>
	if (r < 1)
  803e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e8c:	7f 07                	jg     803e95 <getchar+0x40>
		return -E_EOF;
  803e8e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e93:	eb 07                	jmp    803e9c <getchar+0x47>
	return c;
  803e95:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e99:	0f b6 c0             	movzbl %al,%eax
}
  803e9c:	c9                   	leaveq 
  803e9d:	c3                   	retq   

0000000000803e9e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e9e:	55                   	push   %rbp
  803e9f:	48 89 e5             	mov    %rsp,%rbp
  803ea2:	48 83 ec 20          	sub    $0x20,%rsp
  803ea6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ea9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ead:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eb0:	48 89 d6             	mov    %rdx,%rsi
  803eb3:	89 c7                	mov    %eax,%edi
  803eb5:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  803ebc:	00 00 00 
  803ebf:	ff d0                	callq  *%rax
  803ec1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ec4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec8:	79 05                	jns    803ecf <iscons+0x31>
		return r;
  803eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ecd:	eb 1a                	jmp    803ee9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ecf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed3:	8b 10                	mov    (%rax),%edx
  803ed5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803edc:	00 00 00 
  803edf:	8b 00                	mov    (%rax),%eax
  803ee1:	39 c2                	cmp    %eax,%edx
  803ee3:	0f 94 c0             	sete   %al
  803ee6:	0f b6 c0             	movzbl %al,%eax
}
  803ee9:	c9                   	leaveq 
  803eea:	c3                   	retq   

0000000000803eeb <opencons>:

int
opencons(void)
{
  803eeb:	55                   	push   %rbp
  803eec:	48 89 e5             	mov    %rsp,%rbp
  803eef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ef3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ef7:	48 89 c7             	mov    %rax,%rdi
  803efa:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  803f01:	00 00 00 
  803f04:	ff d0                	callq  *%rax
  803f06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0d:	79 05                	jns    803f14 <opencons+0x29>
		return r;
  803f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f12:	eb 5b                	jmp    803f6f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f18:	ba 07 04 00 00       	mov    $0x407,%edx
  803f1d:	48 89 c6             	mov    %rax,%rsi
  803f20:	bf 00 00 00 00       	mov    $0x0,%edi
  803f25:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f38:	79 05                	jns    803f3f <opencons+0x54>
		return r;
  803f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3d:	eb 30                	jmp    803f6f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f43:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f4a:	00 00 00 
  803f4d:	8b 12                	mov    (%rdx),%edx
  803f4f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f55:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f60:	48 89 c7             	mov    %rax,%rdi
  803f63:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  803f6a:	00 00 00 
  803f6d:	ff d0                	callq  *%rax
}
  803f6f:	c9                   	leaveq 
  803f70:	c3                   	retq   

0000000000803f71 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f71:	55                   	push   %rbp
  803f72:	48 89 e5             	mov    %rsp,%rbp
  803f75:	48 83 ec 30          	sub    $0x30,%rsp
  803f79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f85:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f8a:	75 07                	jne    803f93 <devcons_read+0x22>
		return 0;
  803f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f91:	eb 4b                	jmp    803fde <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f93:	eb 0c                	jmp    803fa1 <devcons_read+0x30>
		sys_yield();
  803f95:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803f9c:	00 00 00 
  803f9f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fa1:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  803fa8:	00 00 00 
  803fab:	ff d0                	callq  *%rax
  803fad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb4:	74 df                	je     803f95 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fba:	79 05                	jns    803fc1 <devcons_read+0x50>
		return c;
  803fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fbf:	eb 1d                	jmp    803fde <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fc5:	75 07                	jne    803fce <devcons_read+0x5d>
		return 0;
  803fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcc:	eb 10                	jmp    803fde <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd1:	89 c2                	mov    %eax,%edx
  803fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fd7:	88 10                	mov    %dl,(%rax)
	return 1;
  803fd9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803fde:	c9                   	leaveq 
  803fdf:	c3                   	retq   

0000000000803fe0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fe0:	55                   	push   %rbp
  803fe1:	48 89 e5             	mov    %rsp,%rbp
  803fe4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803feb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ff2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ff9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804000:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804007:	eb 76                	jmp    80407f <devcons_write+0x9f>
		m = n - tot;
  804009:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804010:	89 c2                	mov    %eax,%edx
  804012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804015:	29 c2                	sub    %eax,%edx
  804017:	89 d0                	mov    %edx,%eax
  804019:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80401c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80401f:	83 f8 7f             	cmp    $0x7f,%eax
  804022:	76 07                	jbe    80402b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804024:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80402b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80402e:	48 63 d0             	movslq %eax,%rdx
  804031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804034:	48 63 c8             	movslq %eax,%rcx
  804037:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80403e:	48 01 c1             	add    %rax,%rcx
  804041:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804048:	48 89 ce             	mov    %rcx,%rsi
  80404b:	48 89 c7             	mov    %rax,%rdi
  80404e:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80405a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80405d:	48 63 d0             	movslq %eax,%rdx
  804060:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804067:	48 89 d6             	mov    %rdx,%rsi
  80406a:	48 89 c7             	mov    %rax,%rdi
  80406d:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  804074:	00 00 00 
  804077:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804079:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80407c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80407f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804082:	48 98                	cltq   
  804084:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80408b:	0f 82 78 ff ff ff    	jb     804009 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804091:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804094:	c9                   	leaveq 
  804095:	c3                   	retq   

0000000000804096 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804096:	55                   	push   %rbp
  804097:	48 89 e5             	mov    %rsp,%rbp
  80409a:	48 83 ec 08          	sub    $0x8,%rsp
  80409e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8040a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040a7:	c9                   	leaveq 
  8040a8:	c3                   	retq   

00000000008040a9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040a9:	55                   	push   %rbp
  8040aa:	48 89 e5             	mov    %rsp,%rbp
  8040ad:	48 83 ec 10          	sub    $0x10,%rsp
  8040b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040bd:	48 be 5d 4a 80 00 00 	movabs $0x804a5d,%rsi
  8040c4:	00 00 00 
  8040c7:	48 89 c7             	mov    %rax,%rdi
  8040ca:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  8040d1:	00 00 00 
  8040d4:	ff d0                	callq  *%rax
	return 0;
  8040d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040db:	c9                   	leaveq 
  8040dc:	c3                   	retq   

00000000008040dd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8040dd:	55                   	push   %rbp
  8040de:	48 89 e5             	mov    %rsp,%rbp
  8040e1:	48 83 ec 30          	sub    $0x30,%rsp
  8040e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8040f1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8040f8:	00 00 00 
  8040fb:	48 8b 00             	mov    (%rax),%rax
  8040fe:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804104:	85 c0                	test   %eax,%eax
  804106:	75 3c                	jne    804144 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804108:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
  804114:	25 ff 03 00 00       	and    $0x3ff,%eax
  804119:	48 63 d0             	movslq %eax,%rdx
  80411c:	48 89 d0             	mov    %rdx,%rax
  80411f:	48 c1 e0 03          	shl    $0x3,%rax
  804123:	48 01 d0             	add    %rdx,%rax
  804126:	48 c1 e0 05          	shl    $0x5,%rax
  80412a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804131:	00 00 00 
  804134:	48 01 c2             	add    %rax,%rdx
  804137:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80413e:	00 00 00 
  804141:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804144:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804149:	75 0e                	jne    804159 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80414b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804152:	00 00 00 
  804155:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804159:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80415d:	48 89 c7             	mov    %rax,%rdi
  804160:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  804167:	00 00 00 
  80416a:	ff d0                	callq  *%rax
  80416c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80416f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804173:	79 19                	jns    80418e <ipc_recv+0xb1>
		*from_env_store = 0;
  804175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804179:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80417f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804183:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804189:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418c:	eb 53                	jmp    8041e1 <ipc_recv+0x104>
	}
	if(from_env_store)
  80418e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804193:	74 19                	je     8041ae <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804195:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80419c:	00 00 00 
  80419f:	48 8b 00             	mov    (%rax),%rax
  8041a2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8041a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ac:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8041ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041b3:	74 19                	je     8041ce <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8041b5:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8041bc:	00 00 00 
  8041bf:	48 8b 00             	mov    (%rax),%rax
  8041c2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8041c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cc:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8041ce:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8041d5:	00 00 00 
  8041d8:	48 8b 00             	mov    (%rax),%rax
  8041db:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8041e1:	c9                   	leaveq 
  8041e2:	c3                   	retq   

00000000008041e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8041e3:	55                   	push   %rbp
  8041e4:	48 89 e5             	mov    %rsp,%rbp
  8041e7:	48 83 ec 30          	sub    $0x30,%rsp
  8041eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041ee:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8041f1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8041f5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8041f8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041fd:	75 0e                	jne    80420d <ipc_send+0x2a>
		pg = (void*)UTOP;
  8041ff:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804206:	00 00 00 
  804209:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80420d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804210:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804213:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804217:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80421a:	89 c7                	mov    %eax,%edi
  80421c:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  804223:	00 00 00 
  804226:	ff d0                	callq  *%rax
  804228:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80422b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80422f:	75 0c                	jne    80423d <ipc_send+0x5a>
			sys_yield();
  804231:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  804238:	00 00 00 
  80423b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80423d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804241:	74 ca                	je     80420d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804243:	c9                   	leaveq 
  804244:	c3                   	retq   

0000000000804245 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804245:	55                   	push   %rbp
  804246:	48 89 e5             	mov    %rsp,%rbp
  804249:	48 83 ec 14          	sub    $0x14,%rsp
  80424d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804257:	eb 5e                	jmp    8042b7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804259:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804260:	00 00 00 
  804263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804266:	48 63 d0             	movslq %eax,%rdx
  804269:	48 89 d0             	mov    %rdx,%rax
  80426c:	48 c1 e0 03          	shl    $0x3,%rax
  804270:	48 01 d0             	add    %rdx,%rax
  804273:	48 c1 e0 05          	shl    $0x5,%rax
  804277:	48 01 c8             	add    %rcx,%rax
  80427a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804280:	8b 00                	mov    (%rax),%eax
  804282:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804285:	75 2c                	jne    8042b3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804287:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80428e:	00 00 00 
  804291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804294:	48 63 d0             	movslq %eax,%rdx
  804297:	48 89 d0             	mov    %rdx,%rax
  80429a:	48 c1 e0 03          	shl    $0x3,%rax
  80429e:	48 01 d0             	add    %rdx,%rax
  8042a1:	48 c1 e0 05          	shl    $0x5,%rax
  8042a5:	48 01 c8             	add    %rcx,%rax
  8042a8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8042ae:	8b 40 08             	mov    0x8(%rax),%eax
  8042b1:	eb 12                	jmp    8042c5 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8042b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8042b7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8042be:	7e 99                	jle    804259 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8042c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042c5:	c9                   	leaveq 
  8042c6:	c3                   	retq   

00000000008042c7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8042c7:	55                   	push   %rbp
  8042c8:	48 89 e5             	mov    %rsp,%rbp
  8042cb:	48 83 ec 18          	sub    $0x18,%rsp
  8042cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d7:	48 c1 e8 15          	shr    $0x15,%rax
  8042db:	48 89 c2             	mov    %rax,%rdx
  8042de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042e5:	01 00 00 
  8042e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042ec:	83 e0 01             	and    $0x1,%eax
  8042ef:	48 85 c0             	test   %rax,%rax
  8042f2:	75 07                	jne    8042fb <pageref+0x34>
		return 0;
  8042f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f9:	eb 53                	jmp    80434e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8042fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ff:	48 c1 e8 0c          	shr    $0xc,%rax
  804303:	48 89 c2             	mov    %rax,%rdx
  804306:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80430d:	01 00 00 
  804310:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804314:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80431c:	83 e0 01             	and    $0x1,%eax
  80431f:	48 85 c0             	test   %rax,%rax
  804322:	75 07                	jne    80432b <pageref+0x64>
		return 0;
  804324:	b8 00 00 00 00       	mov    $0x0,%eax
  804329:	eb 23                	jmp    80434e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80432b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432f:	48 c1 e8 0c          	shr    $0xc,%rax
  804333:	48 89 c2             	mov    %rax,%rdx
  804336:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80433d:	00 00 00 
  804340:	48 c1 e2 04          	shl    $0x4,%rdx
  804344:	48 01 d0             	add    %rdx,%rax
  804347:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80434b:	0f b7 c0             	movzwl %ax,%eax
}
  80434e:	c9                   	leaveq 
  80434f:	c3                   	retq   
