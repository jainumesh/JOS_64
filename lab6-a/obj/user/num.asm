
obj/user/num.debug:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf e0 43 80 00 00 	movabs $0x8043e0,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 2e 30 80 00 00 	movabs $0x80302e,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 3e 24 80 00 00 	movabs $0x80243e,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba e5 43 80 00 00 	movabs $0x8043e5,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 0b 44 80 00 00 	movabs $0x80440b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 20 44 80 00 00 	movabs $0x804420,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 24 44 80 00 00 	movabs $0x804424,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba 2c 44 80 00 00 	movabs $0x80442c,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e7:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f8:	48 63 d0             	movslq %eax,%rdx
  8002fb:	48 89 d0             	mov    %rdx,%rax
  8002fe:	48 c1 e0 03          	shl    $0x3,%rax
  800302:	48 01 d0             	add    %rdx,%rax
  800305:	48 c1 e0 05          	shl    $0x5,%rax
  800309:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800310:	00 00 00 
  800313:	48 01 c2             	add    %rax,%rdx
  800316:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80031d:	00 00 00 
  800320:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800323:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800327:	7e 14                	jle    80033d <libmain+0x65>
		binaryname = argv[0];
  800329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032d:	48 8b 10             	mov    (%rax),%rdx
  800330:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800337:	00 00 00 
  80033a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80033d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800344:	48 89 d6             	mov    %rdx,%rsi
  800347:	89 c7                	mov    %eax,%edi
  800349:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800350:	00 00 00 
  800353:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800355:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  80035c:	00 00 00 
  80035f:	ff d0                	callq  *%rax
}
  800361:	c9                   	leaveq 
  800362:	c3                   	retq   

0000000000800363 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800367:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  80036e:	00 00 00 
  800371:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

}
  800384:	5d                   	pop    %rbp
  800385:	c3                   	retq   

0000000000800386 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800386:	55                   	push   %rbp
  800387:	48 89 e5             	mov    %rsp,%rbp
  80038a:	53                   	push   %rbx
  80038b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800392:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800399:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80039f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003a6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003ad:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b4:	84 c0                	test   %al,%al
  8003b6:	74 23                	je     8003db <_panic+0x55>
  8003b8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003bf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003c7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003cb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003cf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003d7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003db:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003e9:	00 00 00 
  8003ec:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f3:	00 00 00 
  8003f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003fa:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800401:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800408:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80040f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800416:	00 00 00 
  800419:	48 8b 18             	mov    (%rax),%rbx
  80041c:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
  800428:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80042e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800435:	41 89 c8             	mov    %ecx,%r8d
  800438:	48 89 d1             	mov    %rdx,%rcx
  80043b:	48 89 da             	mov    %rbx,%rdx
  80043e:	89 c6                	mov    %eax,%esi
  800440:	48 bf 48 44 80 00 00 	movabs $0x804448,%rdi
  800447:	00 00 00 
  80044a:	b8 00 00 00 00       	mov    $0x0,%eax
  80044f:	49 b9 bf 05 80 00 00 	movabs $0x8005bf,%r9
  800456:	00 00 00 
  800459:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80045c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800463:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046a:	48 89 d6             	mov    %rdx,%rsi
  80046d:	48 89 c7             	mov    %rax,%rdi
  800470:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  800477:	00 00 00 
  80047a:	ff d0                	callq  *%rax
	cprintf("\n");
  80047c:	48 bf 6b 44 80 00 00 	movabs $0x80446b,%rdi
  800483:	00 00 00 
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  800492:	00 00 00 
  800495:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800497:	cc                   	int3   
  800498:	eb fd                	jmp    800497 <_panic+0x111>

000000000080049a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80049a:	55                   	push   %rbp
  80049b:	48 89 e5             	mov    %rsp,%rbp
  80049e:	48 83 ec 10          	sub    $0x10,%rsp
  8004a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ad:	8b 00                	mov    (%rax),%eax
  8004af:	8d 48 01             	lea    0x1(%rax),%ecx
  8004b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b6:	89 0a                	mov    %ecx,(%rdx)
  8004b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004bb:	89 d1                	mov    %edx,%ecx
  8004bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c1:	48 98                	cltq   
  8004c3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d2:	75 2c                	jne    800500 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d8:	8b 00                	mov    (%rax),%eax
  8004da:	48 98                	cltq   
  8004dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e0:	48 83 c2 08          	add    $0x8,%rdx
  8004e4:	48 89 c6             	mov    %rax,%rsi
  8004e7:	48 89 d7             	mov    %rdx,%rdi
  8004ea:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8004f1:	00 00 00 
  8004f4:	ff d0                	callq  *%rax
        b->idx = 0;
  8004f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800504:	8b 40 04             	mov    0x4(%rax),%eax
  800507:	8d 50 01             	lea    0x1(%rax),%edx
  80050a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800511:	c9                   	leaveq 
  800512:	c3                   	retq   

0000000000800513 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80051e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800525:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80052c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800533:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80053a:	48 8b 0a             	mov    (%rdx),%rcx
  80053d:	48 89 08             	mov    %rcx,(%rax)
  800540:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800544:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800548:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80054c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800550:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800557:	00 00 00 
    b.cnt = 0;
  80055a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800561:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800564:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80056b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800572:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800579:	48 89 c6             	mov    %rax,%rsi
  80057c:	48 bf 9a 04 80 00 00 	movabs $0x80049a,%rdi
  800583:	00 00 00 
  800586:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  80058d:	00 00 00 
  800590:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800592:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800598:	48 98                	cltq   
  80059a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a1:	48 83 c2 08          	add    $0x8,%rdx
  8005a5:	48 89 c6             	mov    %rax,%rsi
  8005a8:	48 89 d7             	mov    %rdx,%rdi
  8005ab:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8005b2:	00 00 00 
  8005b5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005bd:	c9                   	leaveq 
  8005be:	c3                   	retq   

00000000008005bf <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005bf:	55                   	push   %rbp
  8005c0:	48 89 e5             	mov    %rsp,%rbp
  8005c3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005ca:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005df:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005e6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005ed:	84 c0                	test   %al,%al
  8005ef:	74 20                	je     800611 <cprintf+0x52>
  8005f1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005f5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005fd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800601:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800605:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800609:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80060d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800611:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800618:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80061f:	00 00 00 
  800622:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800629:	00 00 00 
  80062c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800630:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800637:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80063e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800645:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80064c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800653:	48 8b 0a             	mov    (%rdx),%rcx
  800656:	48 89 08             	mov    %rcx,(%rax)
  800659:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80065d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800661:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800665:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800669:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800670:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800677:	48 89 d6             	mov    %rdx,%rsi
  80067a:	48 89 c7             	mov    %rax,%rdi
  80067d:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
  800689:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80068f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800695:	c9                   	leaveq 
  800696:	c3                   	retq   

0000000000800697 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800697:	55                   	push   %rbp
  800698:	48 89 e5             	mov    %rsp,%rbp
  80069b:	53                   	push   %rbx
  80069c:	48 83 ec 38          	sub    $0x38,%rsp
  8006a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ac:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006af:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006b3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006ba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006be:	77 3b                	ja     8006fb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006c3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006c7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	48 f7 f3             	div    %rbx
  8006d6:	48 89 c2             	mov    %rax,%rdx
  8006d9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006dc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006df:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	41 89 f9             	mov    %edi,%r9d
  8006ea:	48 89 c7             	mov    %rax,%rdi
  8006ed:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  8006f4:	00 00 00 
  8006f7:	ff d0                	callq  *%rax
  8006f9:	eb 1e                	jmp    800719 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006fb:	eb 12                	jmp    80070f <printnum+0x78>
			putch(padc, putdat);
  8006fd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800701:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 89 ce             	mov    %rcx,%rsi
  80070b:	89 d7                	mov    %edx,%edi
  80070d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80070f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800713:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800717:	7f e4                	jg     8006fd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800719:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80071c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800720:	ba 00 00 00 00       	mov    $0x0,%edx
  800725:	48 f7 f1             	div    %rcx
  800728:	48 89 d0             	mov    %rdx,%rax
  80072b:	48 ba 70 46 80 00 00 	movabs $0x804670,%rdx
  800732:	00 00 00 
  800735:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800739:	0f be d0             	movsbl %al,%edx
  80073c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 89 ce             	mov    %rcx,%rsi
  800747:	89 d7                	mov    %edx,%edi
  800749:	ff d0                	callq  *%rax
}
  80074b:	48 83 c4 38          	add    $0x38,%rsp
  80074f:	5b                   	pop    %rbx
  800750:	5d                   	pop    %rbp
  800751:	c3                   	retq   

0000000000800752 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800761:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800765:	7e 52                	jle    8007b9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	83 f8 30             	cmp    $0x30,%eax
  800770:	73 24                	jae    800796 <getuint+0x44>
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	8b 00                	mov    (%rax),%eax
  800780:	89 c0                	mov    %eax,%eax
  800782:	48 01 d0             	add    %rdx,%rax
  800785:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800789:	8b 12                	mov    (%rdx),%edx
  80078b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800792:	89 0a                	mov    %ecx,(%rdx)
  800794:	eb 17                	jmp    8007ad <getuint+0x5b>
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079e:	48 89 d0             	mov    %rdx,%rax
  8007a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ad:	48 8b 00             	mov    (%rax),%rax
  8007b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b4:	e9 a3 00 00 00       	jmpq   80085c <getuint+0x10a>
	else if (lflag)
  8007b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bd:	74 4f                	je     80080e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getuint+0x9c>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 17                	jmp    800805 <getuint+0xb3>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f6:	48 89 d0             	mov    %rdx,%rax
  8007f9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	eb 4e                	jmp    80085c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 24                	jae    80083d <getuint+0xeb>
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	89 c0                	mov    %eax,%eax
  800829:	48 01 d0             	add    %rdx,%rax
  80082c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800830:	8b 12                	mov    (%rdx),%edx
  800832:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	89 0a                	mov    %ecx,(%rdx)
  80083b:	eb 17                	jmp    800854 <getuint+0x102>
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800845:	48 89 d0             	mov    %rdx,%rax
  800848:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800850:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	48 83 ec 1c          	sub    $0x1c,%rsp
  80086a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80086e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800871:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800875:	7e 52                	jle    8008c9 <getint+0x67>
		x=va_arg(*ap, long long);
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	83 f8 30             	cmp    $0x30,%eax
  800880:	73 24                	jae    8008a6 <getint+0x44>
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	8b 00                	mov    (%rax),%eax
  800890:	89 c0                	mov    %eax,%eax
  800892:	48 01 d0             	add    %rdx,%rax
  800895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800899:	8b 12                	mov    (%rdx),%edx
  80089b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a2:	89 0a                	mov    %ecx,(%rdx)
  8008a4:	eb 17                	jmp    8008bd <getint+0x5b>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ae:	48 89 d0             	mov    %rdx,%rax
  8008b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bd:	48 8b 00             	mov    (%rax),%rax
  8008c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c4:	e9 a3 00 00 00       	jmpq   80096c <getint+0x10a>
	else if (lflag)
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008cd:	74 4f                	je     80091e <getint+0xbc>
		x=va_arg(*ap, long);
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	83 f8 30             	cmp    $0x30,%eax
  8008d8:	73 24                	jae    8008fe <getint+0x9c>
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	89 c0                	mov    %eax,%eax
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	8b 12                	mov    (%rdx),%edx
  8008f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fa:	89 0a                	mov    %ecx,(%rdx)
  8008fc:	eb 17                	jmp    800915 <getint+0xb3>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800906:	48 89 d0             	mov    %rdx,%rax
  800909:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800915:	48 8b 00             	mov    (%rax),%rax
  800918:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091c:	eb 4e                	jmp    80096c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	8b 00                	mov    (%rax),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 24                	jae    80094d <getint+0xeb>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	89 c0                	mov    %eax,%eax
  800939:	48 01 d0             	add    %rdx,%rax
  80093c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800940:	8b 12                	mov    (%rdx),%edx
  800942:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	89 0a                	mov    %ecx,(%rdx)
  80094b:	eb 17                	jmp    800964 <getint+0x102>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800955:	48 89 d0             	mov    %rdx,%rax
  800958:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800960:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800964:	8b 00                	mov    (%rax),%eax
  800966:	48 98                	cltq   
  800968:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80096c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800970:	c9                   	leaveq 
  800971:	c3                   	retq   

0000000000800972 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800972:	55                   	push   %rbp
  800973:	48 89 e5             	mov    %rsp,%rbp
  800976:	41 54                	push   %r12
  800978:	53                   	push   %rbx
  800979:	48 83 ec 60          	sub    $0x60,%rsp
  80097d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800981:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800985:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800989:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80098d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800991:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800995:	48 8b 0a             	mov    (%rdx),%rcx
  800998:	48 89 08             	mov    %rcx,(%rax)
  80099b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80099f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	eb 17                	jmp    8009c4 <vprintfmt+0x52>
			if (ch == '\0')
  8009ad:	85 db                	test   %ebx,%ebx
  8009af:	0f 84 cc 04 00 00    	je     800e81 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009b5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bd:	48 89 d6             	mov    %rdx,%rsi
  8009c0:	89 df                	mov    %ebx,%edi
  8009c2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009cc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d0:	0f b6 00             	movzbl (%rax),%eax
  8009d3:	0f b6 d8             	movzbl %al,%ebx
  8009d6:	83 fb 25             	cmp    $0x25,%ebx
  8009d9:	75 d2                	jne    8009ad <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009db:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009df:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a03:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a07:	0f b6 00             	movzbl (%rax),%eax
  800a0a:	0f b6 d8             	movzbl %al,%ebx
  800a0d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a10:	83 f8 55             	cmp    $0x55,%eax
  800a13:	0f 87 34 04 00 00    	ja     800e4d <vprintfmt+0x4db>
  800a19:	89 c0                	mov    %eax,%eax
  800a1b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a22:	00 
  800a23:	48 b8 98 46 80 00 00 	movabs $0x804698,%rax
  800a2a:	00 00 00 
  800a2d:	48 01 d0             	add    %rdx,%rax
  800a30:	48 8b 00             	mov    (%rax),%rax
  800a33:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a35:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a39:	eb c0                	jmp    8009fb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a3b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a3f:	eb ba                	jmp    8009fb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a41:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a48:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	c1 e0 02             	shl    $0x2,%eax
  800a50:	01 d0                	add    %edx,%eax
  800a52:	01 c0                	add    %eax,%eax
  800a54:	01 d8                	add    %ebx,%eax
  800a56:	83 e8 30             	sub    $0x30,%eax
  800a59:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a60:	0f b6 00             	movzbl (%rax),%eax
  800a63:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a66:	83 fb 2f             	cmp    $0x2f,%ebx
  800a69:	7e 0c                	jle    800a77 <vprintfmt+0x105>
  800a6b:	83 fb 39             	cmp    $0x39,%ebx
  800a6e:	7f 07                	jg     800a77 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a70:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a75:	eb d1                	jmp    800a48 <vprintfmt+0xd6>
			goto process_precision;
  800a77:	eb 58                	jmp    800ad1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 30             	cmp    $0x30,%eax
  800a7f:	73 17                	jae    800a98 <vprintfmt+0x126>
  800a81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	89 c0                	mov    %eax,%eax
  800a8a:	48 01 d0             	add    %rdx,%rax
  800a8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a90:	83 c2 08             	add    $0x8,%edx
  800a93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a96:	eb 0f                	jmp    800aa7 <vprintfmt+0x135>
  800a98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 83 c2 08          	add    $0x8,%rdx
  800aa3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa7:	8b 00                	mov    (%rax),%eax
  800aa9:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aac:	eb 23                	jmp    800ad1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab2:	79 0c                	jns    800ac0 <vprintfmt+0x14e>
				width = 0;
  800ab4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800abb:	e9 3b ff ff ff       	jmpq   8009fb <vprintfmt+0x89>
  800ac0:	e9 36 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ac5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800acc:	e9 2a ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ad1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad5:	79 12                	jns    800ae9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800ad7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ada:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800add:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ae4:	e9 12 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>
  800ae9:	e9 0d ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aee:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af2:	e9 04 ff ff ff       	jmpq   8009fb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800af7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afa:	83 f8 30             	cmp    $0x30,%eax
  800afd:	73 17                	jae    800b16 <vprintfmt+0x1a4>
  800aff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b06:	89 c0                	mov    %eax,%eax
  800b08:	48 01 d0             	add    %rdx,%rax
  800b0b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0e:	83 c2 08             	add    $0x8,%edx
  800b11:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b14:	eb 0f                	jmp    800b25 <vprintfmt+0x1b3>
  800b16:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1a:	48 89 d0             	mov    %rdx,%rax
  800b1d:	48 83 c2 08          	add    $0x8,%rdx
  800b21:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b25:	8b 10                	mov    (%rax),%edx
  800b27:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2f:	48 89 ce             	mov    %rcx,%rsi
  800b32:	89 d7                	mov    %edx,%edi
  800b34:	ff d0                	callq  *%rax
			break;
  800b36:	e9 40 03 00 00       	jmpq   800e7b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	83 f8 30             	cmp    $0x30,%eax
  800b41:	73 17                	jae    800b5a <vprintfmt+0x1e8>
  800b43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b52:	83 c2 08             	add    $0x8,%edx
  800b55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b58:	eb 0f                	jmp    800b69 <vprintfmt+0x1f7>
  800b5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5e:	48 89 d0             	mov    %rdx,%rax
  800b61:	48 83 c2 08          	add    $0x8,%rdx
  800b65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b69:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b6b:	85 db                	test   %ebx,%ebx
  800b6d:	79 02                	jns    800b71 <vprintfmt+0x1ff>
				err = -err;
  800b6f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b71:	83 fb 15             	cmp    $0x15,%ebx
  800b74:	7f 16                	jg     800b8c <vprintfmt+0x21a>
  800b76:	48 b8 c0 45 80 00 00 	movabs $0x8045c0,%rax
  800b7d:	00 00 00 
  800b80:	48 63 d3             	movslq %ebx,%rdx
  800b83:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b87:	4d 85 e4             	test   %r12,%r12
  800b8a:	75 2e                	jne    800bba <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b8c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b94:	89 d9                	mov    %ebx,%ecx
  800b96:	48 ba 81 46 80 00 00 	movabs $0x804681,%rdx
  800b9d:	00 00 00 
  800ba0:	48 89 c7             	mov    %rax,%rdi
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba8:	49 b8 8a 0e 80 00 00 	movabs $0x800e8a,%r8
  800baf:	00 00 00 
  800bb2:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bb5:	e9 c1 02 00 00       	jmpq   800e7b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc2:	4c 89 e1             	mov    %r12,%rcx
  800bc5:	48 ba 8a 46 80 00 00 	movabs $0x80468a,%rdx
  800bcc:	00 00 00 
  800bcf:	48 89 c7             	mov    %rax,%rdi
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	49 b8 8a 0e 80 00 00 	movabs $0x800e8a,%r8
  800bde:	00 00 00 
  800be1:	41 ff d0             	callq  *%r8
			break;
  800be4:	e9 92 02 00 00       	jmpq   800e7b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800be9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bec:	83 f8 30             	cmp    $0x30,%eax
  800bef:	73 17                	jae    800c08 <vprintfmt+0x296>
  800bf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	89 c0                	mov    %eax,%eax
  800bfa:	48 01 d0             	add    %rdx,%rax
  800bfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c00:	83 c2 08             	add    $0x8,%edx
  800c03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c06:	eb 0f                	jmp    800c17 <vprintfmt+0x2a5>
  800c08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0c:	48 89 d0             	mov    %rdx,%rax
  800c0f:	48 83 c2 08          	add    $0x8,%rdx
  800c13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c17:	4c 8b 20             	mov    (%rax),%r12
  800c1a:	4d 85 e4             	test   %r12,%r12
  800c1d:	75 0a                	jne    800c29 <vprintfmt+0x2b7>
				p = "(null)";
  800c1f:	49 bc 8d 46 80 00 00 	movabs $0x80468d,%r12
  800c26:	00 00 00 
			if (width > 0 && padc != '-')
  800c29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c2d:	7e 3f                	jle    800c6e <vprintfmt+0x2fc>
  800c2f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c33:	74 39                	je     800c6e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c35:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c38:	48 98                	cltq   
  800c3a:	48 89 c6             	mov    %rax,%rsi
  800c3d:	4c 89 e7             	mov    %r12,%rdi
  800c40:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  800c47:	00 00 00 
  800c4a:	ff d0                	callq  *%rax
  800c4c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c4f:	eb 17                	jmp    800c68 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c51:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c55:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5d:	48 89 ce             	mov    %rcx,%rsi
  800c60:	89 d7                	mov    %edx,%edi
  800c62:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6c:	7f e3                	jg     800c51 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c6e:	eb 37                	jmp    800ca7 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c70:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c74:	74 1e                	je     800c94 <vprintfmt+0x322>
  800c76:	83 fb 1f             	cmp    $0x1f,%ebx
  800c79:	7e 05                	jle    800c80 <vprintfmt+0x30e>
  800c7b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c7e:	7e 14                	jle    800c94 <vprintfmt+0x322>
					putch('?', putdat);
  800c80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c88:	48 89 d6             	mov    %rdx,%rsi
  800c8b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c90:	ff d0                	callq  *%rax
  800c92:	eb 0f                	jmp    800ca3 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9c:	48 89 d6             	mov    %rdx,%rsi
  800c9f:	89 df                	mov    %ebx,%edi
  800ca1:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ca7:	4c 89 e0             	mov    %r12,%rax
  800caa:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cae:	0f b6 00             	movzbl (%rax),%eax
  800cb1:	0f be d8             	movsbl %al,%ebx
  800cb4:	85 db                	test   %ebx,%ebx
  800cb6:	74 10                	je     800cc8 <vprintfmt+0x356>
  800cb8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbc:	78 b2                	js     800c70 <vprintfmt+0x2fe>
  800cbe:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cc2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc6:	79 a8                	jns    800c70 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc8:	eb 16                	jmp    800ce0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800cca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	48 89 d6             	mov    %rdx,%rsi
  800cd5:	bf 20 00 00 00       	mov    $0x20,%edi
  800cda:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cdc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce4:	7f e4                	jg     800cca <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ce6:	e9 90 01 00 00       	jmpq   800e7b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ceb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cef:	be 03 00 00 00       	mov    $0x3,%esi
  800cf4:	48 89 c7             	mov    %rax,%rdi
  800cf7:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0b:	48 85 c0             	test   %rax,%rax
  800d0e:	79 1d                	jns    800d2d <vprintfmt+0x3bb>
				putch('-', putdat);
  800d10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d18:	48 89 d6             	mov    %rdx,%rsi
  800d1b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d20:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d26:	48 f7 d8             	neg    %rax
  800d29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d2d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d34:	e9 d5 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d39:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3d:	be 03 00 00 00       	mov    $0x3,%esi
  800d42:	48 89 c7             	mov    %rax,%rdi
  800d45:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800d4c:	00 00 00 
  800d4f:	ff d0                	callq  *%rax
  800d51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d55:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d5c:	e9 ad 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d61:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d68:	89 d6                	mov    %edx,%esi
  800d6a:	48 89 c7             	mov    %rax,%rdi
  800d6d:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800d74:	00 00 00 
  800d77:	ff d0                	callq  *%rax
  800d79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d7d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d84:	e9 85 00 00 00       	jmpq   800e0e <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d91:	48 89 d6             	mov    %rdx,%rsi
  800d94:	bf 30 00 00 00       	mov    $0x30,%edi
  800d99:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da3:	48 89 d6             	mov    %rdx,%rsi
  800da6:	bf 78 00 00 00       	mov    $0x78,%edi
  800dab:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db0:	83 f8 30             	cmp    $0x30,%eax
  800db3:	73 17                	jae    800dcc <vprintfmt+0x45a>
  800db5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbc:	89 c0                	mov    %eax,%eax
  800dbe:	48 01 d0             	add    %rdx,%rax
  800dc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc4:	83 c2 08             	add    $0x8,%edx
  800dc7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dca:	eb 0f                	jmp    800ddb <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800dcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd0:	48 89 d0             	mov    %rdx,%rax
  800dd3:	48 83 c2 08          	add    $0x8,%rdx
  800dd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ddb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800de2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800de9:	eb 23                	jmp    800e0e <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800deb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800def:	be 03 00 00 00       	mov    $0x3,%esi
  800df4:	48 89 c7             	mov    %rax,%rdi
  800df7:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800dfe:	00 00 00 
  800e01:	ff d0                	callq  *%rax
  800e03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e07:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e13:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e16:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	45 89 c1             	mov    %r8d,%r9d
  800e28:	41 89 f8             	mov    %edi,%r8d
  800e2b:	48 89 c7             	mov    %rax,%rdi
  800e2e:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  800e35:	00 00 00 
  800e38:	ff d0                	callq  *%rax
			break;
  800e3a:	eb 3f                	jmp    800e7b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e44:	48 89 d6             	mov    %rdx,%rsi
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	ff d0                	callq  *%rax
			break;
  800e4b:	eb 2e                	jmp    800e7b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e55:	48 89 d6             	mov    %rdx,%rsi
  800e58:	bf 25 00 00 00       	mov    $0x25,%edi
  800e5d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e64:	eb 05                	jmp    800e6b <vprintfmt+0x4f9>
  800e66:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e6f:	48 83 e8 01          	sub    $0x1,%rax
  800e73:	0f b6 00             	movzbl (%rax),%eax
  800e76:	3c 25                	cmp    $0x25,%al
  800e78:	75 ec                	jne    800e66 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e7a:	90                   	nop
		}
	}
  800e7b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e7c:	e9 43 fb ff ff       	jmpq   8009c4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e81:	48 83 c4 60          	add    $0x60,%rsp
  800e85:	5b                   	pop    %rbx
  800e86:	41 5c                	pop    %r12
  800e88:	5d                   	pop    %rbp
  800e89:	c3                   	retq   

0000000000800e8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8a:	55                   	push   %rbp
  800e8b:	48 89 e5             	mov    %rsp,%rbp
  800e8e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e95:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e9c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ea3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eaa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eb8:	84 c0                	test   %al,%al
  800eba:	74 20                	je     800edc <printfmt+0x52>
  800ebc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ec4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ec8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ecc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ed4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ed8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800edc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ee3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eea:	00 00 00 
  800eed:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ef4:	00 00 00 
  800ef7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800efb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f02:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f09:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f10:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f17:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f1e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f25:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f2c:	48 89 c7             	mov    %rax,%rdi
  800f2f:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 10          	sub    $0x10,%rsp
  800f45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f50:	8b 40 10             	mov    0x10(%rax),%eax
  800f53:	8d 50 01             	lea    0x1(%rax),%edx
  800f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f61:	48 8b 10             	mov    (%rax),%rdx
  800f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f68:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f6c:	48 39 c2             	cmp    %rax,%rdx
  800f6f:	73 17                	jae    800f88 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f75:	48 8b 00             	mov    (%rax),%rax
  800f78:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f80:	48 89 0a             	mov    %rcx,(%rdx)
  800f83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f86:	88 10                	mov    %dl,(%rax)
}
  800f88:	c9                   	leaveq 
  800f89:	c3                   	retq   

0000000000800f8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f8a:	55                   	push   %rbp
  800f8b:	48 89 e5             	mov    %rsp,%rbp
  800f8e:	48 83 ec 50          	sub    $0x50,%rsp
  800f92:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f96:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f99:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f9d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fa5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fa9:	48 8b 0a             	mov    (%rdx),%rcx
  800fac:	48 89 08             	mov    %rcx,(%rax)
  800faf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fc7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fca:	48 98                	cltq   
  800fcc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd4:	48 01 d0             	add    %rdx,%rax
  800fd7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fdb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fe7:	74 06                	je     800fef <vsnprintf+0x65>
  800fe9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fed:	7f 07                	jg     800ff6 <vsnprintf+0x6c>
		return -E_INVAL;
  800fef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff4:	eb 2f                	jmp    801025 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ff6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ffa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ffe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801002:	48 89 c6             	mov    %rax,%rsi
  801005:	48 bf 3d 0f 80 00 00 	movabs $0x800f3d,%rdi
  80100c:	00 00 00 
  80100f:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80101b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80101f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801022:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801032:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801039:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80103f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801046:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801054:	84 c0                	test   %al,%al
  801056:	74 20                	je     801078 <snprintf+0x51>
  801058:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801060:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801064:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801068:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801070:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801074:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801078:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80107f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801086:	00 00 00 
  801089:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801090:	00 00 00 
  801093:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801097:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80109e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ac:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010b3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010ba:	48 8b 0a             	mov    (%rdx),%rcx
  8010bd:	48 89 08             	mov    %rcx,(%rax)
  8010c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010d7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010de:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	48 b8 8a 0f 80 00 00 	movabs $0x800f8a,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
  8010fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801100:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 18          	sub    $0x18,%rsp
  801110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111b:	eb 09                	jmp    801126 <strlen+0x1e>
		n++;
  80111d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801121:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	75 ec                	jne    80111d <strlen+0x15>
		n++;
	return n;
  801131:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 20          	sub    $0x20,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80114d:	eb 0e                	jmp    80115d <strnlen+0x27>
		n++;
  80114f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801153:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801158:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80115d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801162:	74 0b                	je     80116f <strnlen+0x39>
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	0f b6 00             	movzbl (%rax),%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	75 e0                	jne    80114f <strnlen+0x19>
		n++;
	return n;
  80116f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801172:	c9                   	leaveq 
  801173:	c3                   	retq   

0000000000801174 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801174:	55                   	push   %rbp
  801175:	48 89 e5             	mov    %rsp,%rbp
  801178:	48 83 ec 20          	sub    $0x20,%rsp
  80117c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801180:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801188:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80118c:	90                   	nop
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801195:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801199:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a5:	0f b6 12             	movzbl (%rdx),%edx
  8011a8:	88 10                	mov    %dl,(%rax)
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 dc                	jne    80118d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b5:	c9                   	leaveq 
  8011b6:	c3                   	retq   

00000000008011b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011b7:	55                   	push   %rbp
  8011b8:	48 89 e5             	mov    %rsp,%rbp
  8011bb:	48 83 ec 20          	sub    $0x20,%rsp
  8011bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	48 89 c7             	mov    %rax,%rdi
  8011ce:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  8011d5:	00 00 00 
  8011d8:	ff d0                	callq  *%rax
  8011da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e0:	48 63 d0             	movslq %eax,%rdx
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 01 c2             	add    %rax,%rdx
  8011ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ee:	48 89 c6             	mov    %rax,%rsi
  8011f1:	48 89 d7             	mov    %rdx,%rdi
  8011f4:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
	return dst;
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 28          	sub    $0x28,%rsp
  80120e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801212:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801216:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801222:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801229:	00 
  80122a:	eb 2a                	jmp    801256 <strncpy+0x50>
		*dst++ = *src;
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801238:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123c:	0f b6 12             	movzbl (%rdx),%edx
  80123f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801241:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801245:	0f b6 00             	movzbl (%rax),%eax
  801248:	84 c0                	test   %al,%al
  80124a:	74 05                	je     801251 <strncpy+0x4b>
			src++;
  80124c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80125e:	72 cc                	jb     80122c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801264:	c9                   	leaveq 
  801265:	c3                   	retq   

0000000000801266 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801266:	55                   	push   %rbp
  801267:	48 89 e5             	mov    %rsp,%rbp
  80126a:	48 83 ec 28          	sub    $0x28,%rsp
  80126e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801272:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801276:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801282:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801287:	74 3d                	je     8012c6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801289:	eb 1d                	jmp    8012a8 <strlcpy+0x42>
			*dst++ = *src++;
  80128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801293:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801297:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80129b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80129f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012a3:	0f b6 12             	movzbl (%rdx),%edx
  8012a6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012a8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012ad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b2:	74 0b                	je     8012bf <strlcpy+0x59>
  8012b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	84 c0                	test   %al,%al
  8012bd:	75 cc                	jne    80128b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	48 29 c2             	sub    %rax,%rdx
  8012d1:	48 89 d0             	mov    %rdx,%rax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 10          	sub    $0x10,%rsp
  8012de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012e6:	eb 0a                	jmp    8012f2 <strcmp+0x1c>
		p++, q++;
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 12                	je     80130f <strcmp+0x39>
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	0f b6 10             	movzbl (%rax),%edx
  801304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801308:	0f b6 00             	movzbl (%rax),%eax
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 d9                	je     8012e8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	0f b6 d0             	movzbl %al,%edx
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	29 c2                	sub    %eax,%edx
  801325:	89 d0                	mov    %edx,%eax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 18          	sub    $0x18,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801339:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80133d:	eb 0f                	jmp    80134e <strncmp+0x25>
		n--, p++, q++;
  80133f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801344:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801349:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80134e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801353:	74 1d                	je     801372 <strncmp+0x49>
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	74 12                	je     801372 <strncmp+0x49>
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	0f b6 10             	movzbl (%rax),%edx
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	38 c2                	cmp    %al,%dl
  801370:	74 cd                	je     80133f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801372:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801377:	75 07                	jne    801380 <strncmp+0x57>
		return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	eb 18                	jmp    801398 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 d0             	movzbl %al,%edx
  80138a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	0f b6 c0             	movzbl %al,%eax
  801394:	29 c2                	sub    %eax,%edx
  801396:	89 d0                	mov    %edx,%eax
}
  801398:	c9                   	leaveq 
  801399:	c3                   	retq   

000000000080139a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a6:	89 f0                	mov    %esi,%eax
  8013a8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ab:	eb 17                	jmp    8013c4 <strchr+0x2a>
		if (*s == c)
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013b7:	75 06                	jne    8013bf <strchr+0x25>
			return (char *) s;
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	eb 15                	jmp    8013d4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 de                	jne    8013ad <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d4:	c9                   	leaveq 
  8013d5:	c3                   	retq   

00000000008013d6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d6:	55                   	push   %rbp
  8013d7:	48 89 e5             	mov    %rsp,%rbp
  8013da:	48 83 ec 0c          	sub    $0xc,%rsp
  8013de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e2:	89 f0                	mov    %esi,%eax
  8013e4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013e7:	eb 13                	jmp    8013fc <strfind+0x26>
		if (*s == c)
  8013e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f3:	75 02                	jne    8013f7 <strfind+0x21>
			break;
  8013f5:	eb 10                	jmp    801407 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	84 c0                	test   %al,%al
  801405:	75 e2                	jne    8013e9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80140b:	c9                   	leaveq 
  80140c:	c3                   	retq   

000000000080140d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80140d:	55                   	push   %rbp
  80140e:	48 89 e5             	mov    %rsp,%rbp
  801411:	48 83 ec 18          	sub    $0x18,%rsp
  801415:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801419:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80141c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801420:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801425:	75 06                	jne    80142d <memset+0x20>
		return v;
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	eb 69                	jmp    801496 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	83 e0 03             	and    $0x3,%eax
  801434:	48 85 c0             	test   %rax,%rax
  801437:	75 48                	jne    801481 <memset+0x74>
  801439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143d:	83 e0 03             	and    $0x3,%eax
  801440:	48 85 c0             	test   %rax,%rax
  801443:	75 3c                	jne    801481 <memset+0x74>
		c &= 0xFF;
  801445:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80144c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144f:	c1 e0 18             	shl    $0x18,%eax
  801452:	89 c2                	mov    %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801457:	c1 e0 10             	shl    $0x10,%eax
  80145a:	09 c2                	or     %eax,%edx
  80145c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145f:	c1 e0 08             	shl    $0x8,%eax
  801462:	09 d0                	or     %edx,%eax
  801464:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146b:	48 c1 e8 02          	shr    $0x2,%rax
  80146f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801472:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801476:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801479:	48 89 d7             	mov    %rdx,%rdi
  80147c:	fc                   	cld    
  80147d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80147f:	eb 11                	jmp    801492 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801481:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801485:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801488:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80148c:	48 89 d7             	mov    %rdx,%rdi
  80148f:	fc                   	cld    
  801490:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 28          	sub    $0x28,%rsp
  8014a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c4:	0f 83 88 00 00 00    	jae    801552 <memmove+0xba>
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d2:	48 01 d0             	add    %rdx,%rax
  8014d5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014d9:	76 77                	jbe    801552 <memmove+0xba>
		s += n;
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ef:	83 e0 03             	and    $0x3,%eax
  8014f2:	48 85 c0             	test   %rax,%rax
  8014f5:	75 3b                	jne    801532 <memmove+0x9a>
  8014f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fb:	83 e0 03             	and    $0x3,%eax
  8014fe:	48 85 c0             	test   %rax,%rax
  801501:	75 2f                	jne    801532 <memmove+0x9a>
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	83 e0 03             	and    $0x3,%eax
  80150a:	48 85 c0             	test   %rax,%rax
  80150d:	75 23                	jne    801532 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 83 e8 04          	sub    $0x4,%rax
  801517:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151b:	48 83 ea 04          	sub    $0x4,%rdx
  80151f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801523:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801527:	48 89 c7             	mov    %rax,%rdi
  80152a:	48 89 d6             	mov    %rdx,%rsi
  80152d:	fd                   	std    
  80152e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801530:	eb 1d                	jmp    80154f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801536:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 89 d7             	mov    %rdx,%rdi
  801549:	48 89 c1             	mov    %rax,%rcx
  80154c:	fd                   	std    
  80154d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80154f:	fc                   	cld    
  801550:	eb 57                	jmp    8015a9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	48 85 c0             	test   %rax,%rax
  80155c:	75 36                	jne    801594 <memmove+0xfc>
  80155e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801562:	83 e0 03             	and    $0x3,%eax
  801565:	48 85 c0             	test   %rax,%rax
  801568:	75 2a                	jne    801594 <memmove+0xfc>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	83 e0 03             	and    $0x3,%eax
  801571:	48 85 c0             	test   %rax,%rax
  801574:	75 1e                	jne    801594 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	48 c1 e8 02          	shr    $0x2,%rax
  80157e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 89 d6             	mov    %rdx,%rsi
  80158f:	fc                   	cld    
  801590:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801592:	eb 15                	jmp    8015a9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a0:	48 89 c7             	mov    %rax,%rdi
  8015a3:	48 89 d6             	mov    %rdx,%rsi
  8015a6:	fc                   	cld    
  8015a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 18          	sub    $0x18,%rsp
  8015b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cf:	48 89 ce             	mov    %rcx,%rsi
  8015d2:	48 89 c7             	mov    %rax,%rdi
  8015d5:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 28          	sub    $0x28,%rsp
  8015eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801607:	eb 36                	jmp    80163f <memcmp+0x5c>
		if (*s1 != *s2)
  801609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160d:	0f b6 10             	movzbl (%rax),%edx
  801610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801614:	0f b6 00             	movzbl (%rax),%eax
  801617:	38 c2                	cmp    %al,%dl
  801619:	74 1a                	je     801635 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80161b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	0f b6 d0             	movzbl %al,%edx
  801625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801629:	0f b6 00             	movzbl (%rax),%eax
  80162c:	0f b6 c0             	movzbl %al,%eax
  80162f:	29 c2                	sub    %eax,%edx
  801631:	89 d0                	mov    %edx,%eax
  801633:	eb 20                	jmp    801655 <memcmp+0x72>
		s1++, s2++;
  801635:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801647:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80164b:	48 85 c0             	test   %rax,%rax
  80164e:	75 b9                	jne    801609 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801655:	c9                   	leaveq 
  801656:	c3                   	retq   

0000000000801657 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801657:	55                   	push   %rbp
  801658:	48 89 e5             	mov    %rsp,%rbp
  80165b:	48 83 ec 28          	sub    $0x28,%rsp
  80165f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801663:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801666:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80166a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801672:	48 01 d0             	add    %rdx,%rax
  801675:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801679:	eb 15                	jmp    801690 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80167b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167f:	0f b6 10             	movzbl (%rax),%edx
  801682:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801685:	38 c2                	cmp    %al,%dl
  801687:	75 02                	jne    80168b <memfind+0x34>
			break;
  801689:	eb 0f                	jmp    80169a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80168b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801694:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801698:	72 e1                	jb     80167b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80169a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80169e:	c9                   	leaveq 
  80169f:	c3                   	retq   

00000000008016a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a0:	55                   	push   %rbp
  8016a1:	48 89 e5             	mov    %rsp,%rbp
  8016a4:	48 83 ec 34          	sub    $0x34,%rsp
  8016a8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016ba:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c2:	eb 05                	jmp    8016c9 <strtol+0x29>
		s++;
  8016c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 20                	cmp    $0x20,%al
  8016d2:	74 f0                	je     8016c4 <strtol+0x24>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 09                	cmp    $0x9,%al
  8016dd:	74 e5                	je     8016c4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	3c 2b                	cmp    $0x2b,%al
  8016e8:	75 07                	jne    8016f1 <strtol+0x51>
		s++;
  8016ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ef:	eb 17                	jmp    801708 <strtol+0x68>
	else if (*s == '-')
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 2d                	cmp    $0x2d,%al
  8016fa:	75 0c                	jne    801708 <strtol+0x68>
		s++, neg = 1;
  8016fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801701:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801708:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80170c:	74 06                	je     801714 <strtol+0x74>
  80170e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801712:	75 28                	jne    80173c <strtol+0x9c>
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	0f b6 00             	movzbl (%rax),%eax
  80171b:	3c 30                	cmp    $0x30,%al
  80171d:	75 1d                	jne    80173c <strtol+0x9c>
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	48 83 c0 01          	add    $0x1,%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	3c 78                	cmp    $0x78,%al
  80172c:	75 0e                	jne    80173c <strtol+0x9c>
		s += 2, base = 16;
  80172e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801733:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80173a:	eb 2c                	jmp    801768 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80173c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801740:	75 19                	jne    80175b <strtol+0xbb>
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 30                	cmp    $0x30,%al
  80174b:	75 0e                	jne    80175b <strtol+0xbb>
		s++, base = 8;
  80174d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801752:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801759:	eb 0d                	jmp    801768 <strtol+0xc8>
	else if (base == 0)
  80175b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80175f:	75 07                	jne    801768 <strtol+0xc8>
		base = 10;
  801761:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 2f                	cmp    $0x2f,%al
  801771:	7e 1d                	jle    801790 <strtol+0xf0>
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	3c 39                	cmp    $0x39,%al
  80177c:	7f 12                	jg     801790 <strtol+0xf0>
			dig = *s - '0';
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	0f be c0             	movsbl %al,%eax
  801788:	83 e8 30             	sub    $0x30,%eax
  80178b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80178e:	eb 4e                	jmp    8017de <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 60                	cmp    $0x60,%al
  801799:	7e 1d                	jle    8017b8 <strtol+0x118>
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	0f b6 00             	movzbl (%rax),%eax
  8017a2:	3c 7a                	cmp    $0x7a,%al
  8017a4:	7f 12                	jg     8017b8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	0f be c0             	movsbl %al,%eax
  8017b0:	83 e8 57             	sub    $0x57,%eax
  8017b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017b6:	eb 26                	jmp    8017de <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 40                	cmp    $0x40,%al
  8017c1:	7e 48                	jle    80180b <strtol+0x16b>
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3c 5a                	cmp    $0x5a,%al
  8017cc:	7f 3d                	jg     80180b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	0f be c0             	movsbl %al,%eax
  8017d8:	83 e8 37             	sub    $0x37,%eax
  8017db:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017e4:	7c 02                	jl     8017e8 <strtol+0x148>
			break;
  8017e6:	eb 23                	jmp    80180b <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f0:	48 98                	cltq   
  8017f2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017f7:	48 89 c2             	mov    %rax,%rdx
  8017fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fd:	48 98                	cltq   
  8017ff:	48 01 d0             	add    %rdx,%rax
  801802:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801806:	e9 5d ff ff ff       	jmpq   801768 <strtol+0xc8>

	if (endptr)
  80180b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801810:	74 0b                	je     80181d <strtol+0x17d>
		*endptr = (char *) s;
  801812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801816:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80181a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80181d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801821:	74 09                	je     80182c <strtol+0x18c>
  801823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801827:	48 f7 d8             	neg    %rax
  80182a:	eb 04                	jmp    801830 <strtol+0x190>
  80182c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <strstr>:

char * strstr(const char *in, const char *str)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 30          	sub    $0x30,%rsp
  80183a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80183e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801842:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801846:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801854:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801858:	75 06                	jne    801860 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	eb 6b                	jmp    8018cb <strstr+0x99>

	len = strlen(str);
  801860:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801864:	48 89 c7             	mov    %rax,%rdi
  801867:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
  801873:	48 98                	cltq   
  801875:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801881:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80188b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80188f:	75 07                	jne    801898 <strstr+0x66>
				return (char *) 0;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 33                	jmp    8018cb <strstr+0x99>
		} while (sc != c);
  801898:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80189c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80189f:	75 d8                	jne    801879 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	48 89 ce             	mov    %rcx,%rsi
  8018b0:	48 89 c7             	mov    %rax,%rdi
  8018b3:	48 b8 29 13 80 00 00 	movabs $0x801329,%rax
  8018ba:	00 00 00 
  8018bd:	ff d0                	callq  *%rax
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	75 b6                	jne    801879 <strstr+0x47>

	return (char *) (in - 1);
  8018c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c7:	48 83 e8 01          	sub    $0x1,%rax
}
  8018cb:	c9                   	leaveq 
  8018cc:	c3                   	retq   

00000000008018cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018cd:	55                   	push   %rbp
  8018ce:	48 89 e5             	mov    %rsp,%rbp
  8018d1:	53                   	push   %rbx
  8018d2:	48 83 ec 48          	sub    $0x48,%rsp
  8018d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018d9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018e4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018e8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018ef:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018f3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018f7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018fb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018ff:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801903:	4c 89 c3             	mov    %r8,%rbx
  801906:	cd 30                	int    $0x30
  801908:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80190c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801910:	74 3e                	je     801950 <syscall+0x83>
  801912:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801917:	7e 37                	jle    801950 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80191d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801920:	49 89 d0             	mov    %rdx,%r8
  801923:	89 c1                	mov    %eax,%ecx
  801925:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  80192c:	00 00 00 
  80192f:	be 23 00 00 00       	mov    $0x23,%esi
  801934:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  80193b:	00 00 00 
  80193e:	b8 00 00 00 00       	mov    $0x0,%eax
  801943:	49 b9 86 03 80 00 00 	movabs $0x800386,%r9
  80194a:	00 00 00 
  80194d:	41 ff d1             	callq  *%r9

	return ret;
  801950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801954:	48 83 c4 48          	add    $0x48,%rsp
  801958:	5b                   	pop    %rbx
  801959:	5d                   	pop    %rbp
  80195a:	c3                   	retq   

000000000080195b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	48 83 ec 20          	sub    $0x20,%rsp
  801963:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801967:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80196b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801973:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197a:	00 
  80197b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801981:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801987:	48 89 d1             	mov    %rdx,%rcx
  80198a:	48 89 c2             	mov    %rax,%rdx
  80198d:	be 00 00 00 00       	mov    $0x0,%esi
  801992:	bf 00 00 00 00       	mov    $0x0,%edi
  801997:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
}
  8019a3:	c9                   	leaveq 
  8019a4:	c3                   	retq   

00000000008019a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a5:	55                   	push   %rbp
  8019a6:	48 89 e5             	mov    %rsp,%rbp
  8019a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b4:	00 
  8019b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cb:	be 00 00 00 00       	mov    $0x0,%esi
  8019d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  8019dc:	00 00 00 
  8019df:	ff d0                	callq  *%rax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 10          	sub    $0x10,%rsp
  8019eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f1:	48 98                	cltq   
  8019f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fa:	00 
  8019fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0c:	48 89 c2             	mov    %rax,%rdx
  801a0f:	be 01 00 00 00       	mov    $0x1,%esi
  801a14:	bf 03 00 00 00       	mov    $0x3,%edi
  801a19:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a36:	00 
  801a37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a48:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4d:	be 00 00 00 00       	mov    $0x0,%esi
  801a52:	bf 02 00 00 00       	mov    $0x2,%edi
  801a57:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	callq  *%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   

0000000000801a65 <sys_yield>:

void
sys_yield(void)
{
  801a65:	55                   	push   %rbp
  801a66:	48 89 e5             	mov    %rsp,%rbp
  801a69:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a74:	00 
  801a75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a86:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8b:	be 00 00 00 00       	mov    $0x0,%esi
  801a90:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a95:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
}
  801aa1:	c9                   	leaveq 
  801aa2:	c3                   	retq   

0000000000801aa3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 20          	sub    $0x20,%rsp
  801aab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab8:	48 63 c8             	movslq %eax,%rcx
  801abb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac2:	48 98                	cltq   
  801ac4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acb:	00 
  801acc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad2:	49 89 c8             	mov    %rcx,%r8
  801ad5:	48 89 d1             	mov    %rdx,%rcx
  801ad8:	48 89 c2             	mov    %rax,%rdx
  801adb:	be 01 00 00 00       	mov    $0x1,%esi
  801ae0:	bf 04 00 00 00       	mov    $0x4,%edi
  801ae5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	callq  *%rax
}
  801af1:	c9                   	leaveq 
  801af2:	c3                   	retq   

0000000000801af3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af3:	55                   	push   %rbp
  801af4:	48 89 e5             	mov    %rsp,%rbp
  801af7:	48 83 ec 30          	sub    $0x30,%rsp
  801afb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b02:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b05:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b09:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b0d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b10:	48 63 c8             	movslq %eax,%rcx
  801b13:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1a:	48 63 f0             	movslq %eax,%rsi
  801b1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b24:	48 98                	cltq   
  801b26:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b2a:	49 89 f9             	mov    %rdi,%r9
  801b2d:	49 89 f0             	mov    %rsi,%r8
  801b30:	48 89 d1             	mov    %rdx,%rcx
  801b33:	48 89 c2             	mov    %rax,%rdx
  801b36:	be 01 00 00 00       	mov    $0x1,%esi
  801b3b:	bf 05 00 00 00       	mov    $0x5,%edi
  801b40:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 20          	sub    $0x20,%rsp
  801b56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b64:	48 98                	cltq   
  801b66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6d:	00 
  801b6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7a:	48 89 d1             	mov    %rdx,%rcx
  801b7d:	48 89 c2             	mov    %rax,%rdx
  801b80:	be 01 00 00 00       	mov    $0x1,%esi
  801b85:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8a:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 10          	sub    $0x10,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ba6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba9:	48 63 d0             	movslq %eax,%rdx
  801bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801baf:	48 98                	cltq   
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	48 89 d1             	mov    %rdx,%rcx
  801bc8:	48 89 c2             	mov    %rax,%rdx
  801bcb:	be 01 00 00 00       	mov    $0x1,%esi
  801bd0:	bf 08 00 00 00       	mov    $0x8,%edi
  801bd5:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	callq  *%rax
}
  801be1:	c9                   	leaveq 
  801be2:	c3                   	retq   

0000000000801be3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801be3:	55                   	push   %rbp
  801be4:	48 89 e5             	mov    %rsp,%rbp
  801be7:	48 83 ec 20          	sub    $0x20,%rsp
  801beb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 98                	cltq   
  801bfb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c02:	00 
  801c03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0f:	48 89 d1             	mov    %rdx,%rcx
  801c12:	48 89 c2             	mov    %rax,%rdx
  801c15:	be 01 00 00 00       	mov    $0x1,%esi
  801c1a:	bf 09 00 00 00       	mov    $0x9,%edi
  801c1f:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
}
  801c2b:	c9                   	leaveq 
  801c2c:	c3                   	retq   

0000000000801c2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c2d:	55                   	push   %rbp
  801c2e:	48 89 e5             	mov    %rsp,%rbp
  801c31:	48 83 ec 20          	sub    $0x20,%rsp
  801c35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c43:	48 98                	cltq   
  801c45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4c:	00 
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	48 89 d1             	mov    %rdx,%rcx
  801c5c:	48 89 c2             	mov    %rax,%rdx
  801c5f:	be 01 00 00 00       	mov    $0x1,%esi
  801c64:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c69:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	callq  *%rax
}
  801c75:	c9                   	leaveq 
  801c76:	c3                   	retq   

0000000000801c77 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 83 ec 20          	sub    $0x20,%rsp
  801c7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c86:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c8a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c90:	48 63 f0             	movslq %eax,%rsi
  801c93:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9a:	48 98                	cltq   
  801c9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	49 89 f1             	mov    %rsi,%r9
  801cab:	49 89 c8             	mov    %rcx,%r8
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cbe:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 10          	sub    $0x10,%rsp
  801cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce3:	00 
  801ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf5:	48 89 c2             	mov    %rax,%rdx
  801cf8:	be 01 00 00 00       	mov    $0x1,%esi
  801cfd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d02:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	callq  *%rax
}
  801d0e:	c9                   	leaveq 
  801d0f:	c3                   	retq   

0000000000801d10 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d10:	55                   	push   %rbp
  801d11:	48 89 e5             	mov    %rsp,%rbp
  801d14:	48 83 ec 20          	sub    $0x20,%rsp
  801d18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2f:	00 
  801d30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3c:	48 89 d1             	mov    %rdx,%rcx
  801d3f:	48 89 c2             	mov    %rax,%rdx
  801d42:	be 01 00 00 00       	mov    $0x1,%esi
  801d47:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d4c:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
}
  801d58:	c9                   	leaveq 
  801d59:	c3                   	retq   

0000000000801d5a <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
  801d5e:	48 83 ec 10          	sub    $0x10,%rsp
  801d62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d71:	00 
  801d72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d83:	48 89 c2             	mov    %rax,%rdx
  801d86:	be 00 00 00 00       	mov    $0x0,%esi
  801d8b:	bf 10 00 00 00       	mov    $0x10,%edi
  801d90:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	callq  *%rax
}
  801d9c:	c9                   	leaveq 
  801d9d:	c3                   	retq   

0000000000801d9e <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d9e:	55                   	push   %rbp
  801d9f:	48 89 e5             	mov    %rsp,%rbp
  801da2:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801da6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dad:	00 
  801dae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc4:	be 00 00 00 00       	mov    $0x0,%esi
  801dc9:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dce:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	callq  *%rax
}
  801dda:	c9                   	leaveq 
  801ddb:	c3                   	retq   

0000000000801ddc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ddc:	55                   	push   %rbp
  801ddd:	48 89 e5             	mov    %rsp,%rbp
  801de0:	48 83 ec 08          	sub    $0x8,%rsp
  801de4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801de8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dec:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801df3:	ff ff ff 
  801df6:	48 01 d0             	add    %rdx,%rax
  801df9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dfd:	c9                   	leaveq 
  801dfe:	c3                   	retq   

0000000000801dff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	48 83 ec 08          	sub    $0x8,%rsp
  801e07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0f:	48 89 c7             	mov    %rax,%rdi
  801e12:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e24:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e28:	c9                   	leaveq 
  801e29:	c3                   	retq   

0000000000801e2a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e2a:	55                   	push   %rbp
  801e2b:	48 89 e5             	mov    %rsp,%rbp
  801e2e:	48 83 ec 18          	sub    $0x18,%rsp
  801e32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e3d:	eb 6b                	jmp    801eaa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e42:	48 98                	cltq   
  801e44:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e4a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e56:	48 c1 e8 15          	shr    $0x15,%rax
  801e5a:	48 89 c2             	mov    %rax,%rdx
  801e5d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e64:	01 00 00 
  801e67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6b:	83 e0 01             	and    $0x1,%eax
  801e6e:	48 85 c0             	test   %rax,%rax
  801e71:	74 21                	je     801e94 <fd_alloc+0x6a>
  801e73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e77:	48 c1 e8 0c          	shr    $0xc,%rax
  801e7b:	48 89 c2             	mov    %rax,%rdx
  801e7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e85:	01 00 00 
  801e88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8c:	83 e0 01             	and    $0x1,%eax
  801e8f:	48 85 c0             	test   %rax,%rax
  801e92:	75 12                	jne    801ea6 <fd_alloc+0x7c>
			*fd_store = fd;
  801e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	eb 1a                	jmp    801ec0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ea6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eaa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eae:	7e 8f                	jle    801e3f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ebb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   

0000000000801ec2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	48 83 ec 20          	sub    $0x20,%rsp
  801eca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ecd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ed1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ed5:	78 06                	js     801edd <fd_lookup+0x1b>
  801ed7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801edb:	7e 07                	jle    801ee4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801edd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee2:	eb 6c                	jmp    801f50 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ee4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ee7:	48 98                	cltq   
  801ee9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eef:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efb:	48 c1 e8 15          	shr    $0x15,%rax
  801eff:	48 89 c2             	mov    %rax,%rdx
  801f02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f09:	01 00 00 
  801f0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f10:	83 e0 01             	and    $0x1,%eax
  801f13:	48 85 c0             	test   %rax,%rax
  801f16:	74 21                	je     801f39 <fd_lookup+0x77>
  801f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f20:	48 89 c2             	mov    %rax,%rdx
  801f23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2a:	01 00 00 
  801f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f31:	83 e0 01             	and    $0x1,%eax
  801f34:	48 85 c0             	test   %rax,%rax
  801f37:	75 07                	jne    801f40 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3e:	eb 10                	jmp    801f50 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f48:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f50:	c9                   	leaveq 
  801f51:	c3                   	retq   

0000000000801f52 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
  801f56:	48 83 ec 30          	sub    $0x30,%rsp
  801f5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f5e:	89 f0                	mov    %esi,%eax
  801f60:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f67:	48 89 c7             	mov    %rax,%rdi
  801f6a:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	callq  *%rax
  801f76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f7a:	48 89 d6             	mov    %rdx,%rsi
  801f7d:	89 c7                	mov    %eax,%edi
  801f7f:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
  801f8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f92:	78 0a                	js     801f9e <fd_close+0x4c>
	    || fd != fd2)
  801f94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f98:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f9c:	74 12                	je     801fb0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f9e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fa2:	74 05                	je     801fa9 <fd_close+0x57>
  801fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa7:	eb 05                	jmp    801fae <fd_close+0x5c>
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	eb 69                	jmp    802019 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb4:	8b 00                	mov    (%rax),%eax
  801fb6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fba:	48 89 d6             	mov    %rdx,%rsi
  801fbd:	89 c7                	mov    %eax,%edi
  801fbf:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd2:	78 2a                	js     801ffe <fd_close+0xac>
		if (dev->dev_close)
  801fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fdc:	48 85 c0             	test   %rax,%rax
  801fdf:	74 16                	je     801ff7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fe9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fed:	48 89 d7             	mov    %rdx,%rdi
  801ff0:	ff d0                	callq  *%rax
  801ff2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff5:	eb 07                	jmp    801ffe <fd_close+0xac>
		else
			r = 0;
  801ff7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802002:	48 89 c6             	mov    %rax,%rsi
  802005:	bf 00 00 00 00       	mov    $0x0,%edi
  80200a:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax
	return r;
  802016:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802019:	c9                   	leaveq 
  80201a:	c3                   	retq   

000000000080201b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80201b:	55                   	push   %rbp
  80201c:	48 89 e5             	mov    %rsp,%rbp
  80201f:	48 83 ec 20          	sub    $0x20,%rsp
  802023:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802026:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80202a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802031:	eb 41                	jmp    802074 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802033:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80203a:	00 00 00 
  80203d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802040:	48 63 d2             	movslq %edx,%rdx
  802043:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802047:	8b 00                	mov    (%rax),%eax
  802049:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80204c:	75 22                	jne    802070 <dev_lookup+0x55>
			*dev = devtab[i];
  80204e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802055:	00 00 00 
  802058:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80205b:	48 63 d2             	movslq %edx,%rdx
  80205e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802066:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	eb 60                	jmp    8020d0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802070:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802074:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80207b:	00 00 00 
  80207e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802081:	48 63 d2             	movslq %edx,%rdx
  802084:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802088:	48 85 c0             	test   %rax,%rax
  80208b:	75 a6                	jne    802033 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80208d:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802094:	00 00 00 
  802097:	48 8b 00             	mov    (%rax),%rax
  80209a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020a0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020a3:	89 c6                	mov    %eax,%esi
  8020a5:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  8020ac:	00 00 00 
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8020bb:	00 00 00 
  8020be:	ff d1                	callq  *%rcx
	*dev = 0;
  8020c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020c4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020d0:	c9                   	leaveq 
  8020d1:	c3                   	retq   

00000000008020d2 <close>:

int
close(int fdnum)
{
  8020d2:	55                   	push   %rbp
  8020d3:	48 89 e5             	mov    %rsp,%rbp
  8020d6:	48 83 ec 20          	sub    $0x20,%rsp
  8020da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020e4:	48 89 d6             	mov    %rdx,%rsi
  8020e7:	89 c7                	mov    %eax,%edi
  8020e9:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	callq  *%rax
  8020f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fc:	79 05                	jns    802103 <close+0x31>
		return r;
  8020fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802101:	eb 18                	jmp    80211b <close+0x49>
	else
		return fd_close(fd, 1);
  802103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802107:	be 01 00 00 00       	mov    $0x1,%esi
  80210c:	48 89 c7             	mov    %rax,%rdi
  80210f:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <close_all>:

void
close_all(void)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212c:	eb 15                	jmp    802143 <close_all+0x26>
		close(i);
  80212e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802131:	89 c7                	mov    %eax,%edi
  802133:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80213f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802143:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802147:	7e e5                	jle    80212e <close_all+0x11>
		close(i);
}
  802149:	c9                   	leaveq 
  80214a:	c3                   	retq   

000000000080214b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80214b:	55                   	push   %rbp
  80214c:	48 89 e5             	mov    %rsp,%rbp
  80214f:	48 83 ec 40          	sub    $0x40,%rsp
  802153:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802156:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802159:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80215d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802160:	48 89 d6             	mov    %rdx,%rsi
  802163:	89 c7                	mov    %eax,%edi
  802165:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
  802171:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802174:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802178:	79 08                	jns    802182 <dup+0x37>
		return r;
  80217a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217d:	e9 70 01 00 00       	jmpq   8022f2 <dup+0x1a7>
	close(newfdnum);
  802182:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802185:	89 c7                	mov    %eax,%edi
  802187:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802193:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802196:	48 98                	cltq   
  802198:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80219e:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021aa:	48 89 c7             	mov    %rax,%rdi
  8021ad:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
  8021b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c1:	48 89 c7             	mov    %rax,%rdi
  8021c4:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  8021cb:	00 00 00 
  8021ce:	ff d0                	callq  *%rax
  8021d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 c1 e8 15          	shr    $0x15,%rax
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021e6:	01 00 00 
  8021e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ed:	83 e0 01             	and    $0x1,%eax
  8021f0:	48 85 c0             	test   %rax,%rax
  8021f3:	74 73                	je     802268 <dup+0x11d>
  8021f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8021fd:	48 89 c2             	mov    %rax,%rdx
  802200:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802207:	01 00 00 
  80220a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220e:	83 e0 01             	and    $0x1,%eax
  802211:	48 85 c0             	test   %rax,%rax
  802214:	74 52                	je     802268 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221a:	48 c1 e8 0c          	shr    $0xc,%rax
  80221e:	48 89 c2             	mov    %rax,%rdx
  802221:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802228:	01 00 00 
  80222b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222f:	25 07 0e 00 00       	and    $0xe07,%eax
  802234:	89 c1                	mov    %eax,%ecx
  802236:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	41 89 c8             	mov    %ecx,%r8d
  802241:	48 89 d1             	mov    %rdx,%rcx
  802244:	ba 00 00 00 00       	mov    $0x0,%edx
  802249:	48 89 c6             	mov    %rax,%rsi
  80224c:	bf 00 00 00 00       	mov    $0x0,%edi
  802251:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802264:	79 02                	jns    802268 <dup+0x11d>
			goto err;
  802266:	eb 57                	jmp    8022bf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802268:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226c:	48 c1 e8 0c          	shr    $0xc,%rax
  802270:	48 89 c2             	mov    %rax,%rdx
  802273:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227a:	01 00 00 
  80227d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802281:	25 07 0e 00 00       	and    $0xe07,%eax
  802286:	89 c1                	mov    %eax,%ecx
  802288:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802290:	41 89 c8             	mov    %ecx,%r8d
  802293:	48 89 d1             	mov    %rdx,%rcx
  802296:	ba 00 00 00 00       	mov    $0x0,%edx
  80229b:	48 89 c6             	mov    %rax,%rsi
  80229e:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a3:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	callq  *%rax
  8022af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b6:	79 02                	jns    8022ba <dup+0x16f>
		goto err;
  8022b8:	eb 05                	jmp    8022bf <dup+0x174>

	return newfdnum;
  8022ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022bd:	eb 33                	jmp    8022f2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c3:	48 89 c6             	mov    %rax,%rsi
  8022c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cb:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022db:	48 89 c6             	mov    %rax,%rsi
  8022de:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e3:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	callq  *%rax
	return r;
  8022ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f2:	c9                   	leaveq 
  8022f3:	c3                   	retq   

00000000008022f4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022f4:	55                   	push   %rbp
  8022f5:	48 89 e5             	mov    %rsp,%rbp
  8022f8:	48 83 ec 40          	sub    $0x40,%rsp
  8022fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802303:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802307:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80230b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80230e:	48 89 d6             	mov    %rdx,%rsi
  802311:	89 c7                	mov    %eax,%edi
  802313:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
  80231f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802322:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802326:	78 24                	js     80234c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232c:	8b 00                	mov    (%rax),%eax
  80232e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802332:	48 89 d6             	mov    %rdx,%rsi
  802335:	89 c7                	mov    %eax,%edi
  802337:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  80233e:	00 00 00 
  802341:	ff d0                	callq  *%rax
  802343:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234a:	79 05                	jns    802351 <read+0x5d>
		return r;
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	eb 76                	jmp    8023c7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802355:	8b 40 08             	mov    0x8(%rax),%eax
  802358:	83 e0 03             	and    $0x3,%eax
  80235b:	83 f8 01             	cmp    $0x1,%eax
  80235e:	75 3a                	jne    80239a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802360:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802367:	00 00 00 
  80236a:	48 8b 00             	mov    (%rax),%rax
  80236d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802373:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802376:	89 c6                	mov    %eax,%esi
  802378:	48 bf 97 49 80 00 00 	movabs $0x804997,%rdi
  80237f:	00 00 00 
  802382:	b8 00 00 00 00       	mov    $0x0,%eax
  802387:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  80238e:	00 00 00 
  802391:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802398:	eb 2d                	jmp    8023c7 <read+0xd3>
	}
	if (!dev->dev_read)
  80239a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239e:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a2:	48 85 c0             	test   %rax,%rax
  8023a5:	75 07                	jne    8023ae <read+0xba>
		return -E_NOT_SUPP;
  8023a7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023ac:	eb 19                	jmp    8023c7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023b6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023be:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023c2:	48 89 cf             	mov    %rcx,%rdi
  8023c5:	ff d0                	callq  *%rax
}
  8023c7:	c9                   	leaveq 
  8023c8:	c3                   	retq   

00000000008023c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	48 83 ec 30          	sub    $0x30,%rsp
  8023d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e3:	eb 49                	jmp    80242e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e8:	48 98                	cltq   
  8023ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023ee:	48 29 c2             	sub    %rax,%rdx
  8023f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f4:	48 63 c8             	movslq %eax,%rcx
  8023f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023fb:	48 01 c1             	add    %rax,%rcx
  8023fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802401:	48 89 ce             	mov    %rcx,%rsi
  802404:	89 c7                	mov    %eax,%edi
  802406:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  80240d:	00 00 00 
  802410:	ff d0                	callq  *%rax
  802412:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802415:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802419:	79 05                	jns    802420 <readn+0x57>
			return m;
  80241b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80241e:	eb 1c                	jmp    80243c <readn+0x73>
		if (m == 0)
  802420:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802424:	75 02                	jne    802428 <readn+0x5f>
			break;
  802426:	eb 11                	jmp    802439 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802428:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80242e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802431:	48 98                	cltq   
  802433:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802437:	72 ac                	jb     8023e5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802439:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80243c:	c9                   	leaveq 
  80243d:	c3                   	retq   

000000000080243e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80243e:	55                   	push   %rbp
  80243f:	48 89 e5             	mov    %rsp,%rbp
  802442:	48 83 ec 40          	sub    $0x40,%rsp
  802446:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802449:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80244d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802451:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802455:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802458:	48 89 d6             	mov    %rdx,%rsi
  80245b:	89 c7                	mov    %eax,%edi
  80245d:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
  802469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802470:	78 24                	js     802496 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802476:	8b 00                	mov    (%rax),%eax
  802478:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80247c:	48 89 d6             	mov    %rdx,%rsi
  80247f:	89 c7                	mov    %eax,%edi
  802481:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  802488:	00 00 00 
  80248b:	ff d0                	callq  *%rax
  80248d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802490:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802494:	79 05                	jns    80249b <write+0x5d>
		return r;
  802496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802499:	eb 75                	jmp    802510 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80249b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249f:	8b 40 08             	mov    0x8(%rax),%eax
  8024a2:	83 e0 03             	and    $0x3,%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	75 3a                	jne    8024e3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024a9:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8024b0:	00 00 00 
  8024b3:	48 8b 00             	mov    (%rax),%rax
  8024b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	48 bf b3 49 80 00 00 	movabs $0x8049b3,%rdi
  8024c8:	00 00 00 
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8024d7:	00 00 00 
  8024da:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e1:	eb 2d                	jmp    802510 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8024e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024eb:	48 85 c0             	test   %rax,%rax
  8024ee:	75 07                	jne    8024f7 <write+0xb9>
		return -E_NOT_SUPP;
  8024f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024f5:	eb 19                	jmp    802510 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802503:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802507:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80250b:	48 89 cf             	mov    %rcx,%rdi
  80250e:	ff d0                	callq  *%rax
}
  802510:	c9                   	leaveq 
  802511:	c3                   	retq   

0000000000802512 <seek>:

int
seek(int fdnum, off_t offset)
{
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	48 83 ec 18          	sub    $0x18,%rsp
  80251a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80251d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802520:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802524:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802527:	48 89 d6             	mov    %rdx,%rsi
  80252a:	89 c7                	mov    %eax,%edi
  80252c:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
  802538:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253f:	79 05                	jns    802546 <seek+0x34>
		return r;
  802541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802544:	eb 0f                	jmp    802555 <seek+0x43>
	fd->fd_offset = offset;
  802546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80254d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802555:	c9                   	leaveq 
  802556:	c3                   	retq   

0000000000802557 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802557:	55                   	push   %rbp
  802558:	48 89 e5             	mov    %rsp,%rbp
  80255b:	48 83 ec 30          	sub    $0x30,%rsp
  80255f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802562:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802565:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802569:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	78 24                	js     8025aa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258a:	8b 00                	mov    (%rax),%eax
  80258c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802590:	48 89 d6             	mov    %rdx,%rsi
  802593:	89 c7                	mov    %eax,%edi
  802595:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a8:	79 05                	jns    8025af <ftruncate+0x58>
		return r;
  8025aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ad:	eb 72                	jmp    802621 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b3:	8b 40 08             	mov    0x8(%rax),%eax
  8025b6:	83 e0 03             	and    $0x3,%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 3a                	jne    8025f7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025bd:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8025c4:	00 00 00 
  8025c7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d3:	89 c6                	mov    %eax,%esi
  8025d5:	48 bf d0 49 80 00 00 	movabs $0x8049d0,%rdi
  8025dc:	00 00 00 
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	48 b9 bf 05 80 00 00 	movabs $0x8005bf,%rcx
  8025eb:	00 00 00 
  8025ee:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f5:	eb 2a                	jmp    802621 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025ff:	48 85 c0             	test   %rax,%rax
  802602:	75 07                	jne    80260b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802604:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802609:	eb 16                	jmp    802621 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80260b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802617:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80261a:	89 ce                	mov    %ecx,%esi
  80261c:	48 89 d7             	mov    %rdx,%rdi
  80261f:	ff d0                	callq  *%rax
}
  802621:	c9                   	leaveq 
  802622:	c3                   	retq   

0000000000802623 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802623:	55                   	push   %rbp
  802624:	48 89 e5             	mov    %rsp,%rbp
  802627:	48 83 ec 30          	sub    $0x30,%rsp
  80262b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80262e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802632:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802636:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802639:	48 89 d6             	mov    %rdx,%rsi
  80263c:	89 c7                	mov    %eax,%edi
  80263e:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  802645:	00 00 00 
  802648:	ff d0                	callq  *%rax
  80264a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802651:	78 24                	js     802677 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802657:	8b 00                	mov    (%rax),%eax
  802659:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265d:	48 89 d6             	mov    %rdx,%rsi
  802660:	89 c7                	mov    %eax,%edi
  802662:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
  80266e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802675:	79 05                	jns    80267c <fstat+0x59>
		return r;
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	eb 5e                	jmp    8026da <fstat+0xb7>
	if (!dev->dev_stat)
  80267c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802680:	48 8b 40 28          	mov    0x28(%rax),%rax
  802684:	48 85 c0             	test   %rax,%rax
  802687:	75 07                	jne    802690 <fstat+0x6d>
		return -E_NOT_SUPP;
  802689:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80268e:	eb 4a                	jmp    8026da <fstat+0xb7>
	stat->st_name[0] = 0;
  802690:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802694:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802697:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026a2:	00 00 00 
	stat->st_isdir = 0;
  8026a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026b0:	00 00 00 
	stat->st_dev = dev;
  8026b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026bb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026d2:	48 89 ce             	mov    %rcx,%rsi
  8026d5:	48 89 d7             	mov    %rdx,%rdi
  8026d8:	ff d0                	callq  *%rax
}
  8026da:	c9                   	leaveq 
  8026db:	c3                   	retq   

00000000008026dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026dc:	55                   	push   %rbp
  8026dd:	48 89 e5             	mov    %rsp,%rbp
  8026e0:	48 83 ec 20          	sub    $0x20,%rsp
  8026e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f0:	be 00 00 00 00       	mov    $0x0,%esi
  8026f5:	48 89 c7             	mov    %rax,%rdi
  8026f8:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	callq  *%rax
  802704:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270b:	79 05                	jns    802712 <stat+0x36>
		return fd;
  80270d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802710:	eb 2f                	jmp    802741 <stat+0x65>
	r = fstat(fd, stat);
  802712:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802719:	48 89 d6             	mov    %rdx,%rsi
  80271c:	89 c7                	mov    %eax,%edi
  80271e:	48 b8 23 26 80 00 00 	movabs $0x802623,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
  80272a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80272d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
	return r;
  80273e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802741:	c9                   	leaveq 
  802742:	c3                   	retq   

0000000000802743 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
  802747:	48 83 ec 10          	sub    $0x10,%rsp
  80274b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80274e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802752:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802759:	00 00 00 
  80275c:	8b 00                	mov    (%rax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	75 1d                	jne    80277f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802762:	bf 01 00 00 00       	mov    $0x1,%edi
  802767:	48 b8 d4 42 80 00 00 	movabs $0x8042d4,%rax
  80276e:	00 00 00 
  802771:	ff d0                	callq  *%rax
  802773:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80277a:	00 00 00 
  80277d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80277f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802786:	00 00 00 
  802789:	8b 00                	mov    (%rax),%eax
  80278b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80278e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802793:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80279a:	00 00 00 
  80279d:	89 c7                	mov    %eax,%edi
  80279f:	48 b8 72 42 80 00 00 	movabs $0x804272,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027af:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b4:	48 89 c6             	mov    %rax,%rsi
  8027b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027bc:	48 b8 6c 41 80 00 00 	movabs $0x80416c,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	callq  *%rax
}
  8027c8:	c9                   	leaveq 
  8027c9:	c3                   	retq   

00000000008027ca <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027ca:	55                   	push   %rbp
  8027cb:	48 89 e5             	mov    %rsp,%rbp
  8027ce:	48 83 ec 30          	sub    $0x30,%rsp
  8027d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027d6:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8027d9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8027e0:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027f3:	75 08                	jne    8027fd <open+0x33>
	{
		return r;
  8027f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f8:	e9 f2 00 00 00       	jmpq   8028ef <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802801:	48 89 c7             	mov    %rax,%rdi
  802804:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
  802810:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802813:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80281a:	7e 0a                	jle    802826 <open+0x5c>
	{
		return -E_BAD_PATH;
  80281c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802821:	e9 c9 00 00 00       	jmpq   8028ef <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802826:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80282d:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80282e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802832:	48 89 c7             	mov    %rax,%rdi
  802835:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax
  802841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802848:	78 09                	js     802853 <open+0x89>
  80284a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284e:	48 85 c0             	test   %rax,%rax
  802851:	75 08                	jne    80285b <open+0x91>
		{
			return r;
  802853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802856:	e9 94 00 00 00       	jmpq   8028ef <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80285b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285f:	ba 00 04 00 00       	mov    $0x400,%edx
  802864:	48 89 c6             	mov    %rax,%rsi
  802867:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80286e:	00 00 00 
  802871:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80287d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802884:	00 00 00 
  802887:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80288a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802894:	48 89 c6             	mov    %rax,%rsi
  802897:	bf 01 00 00 00       	mov    $0x1,%edi
  80289c:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  8028a3:	00 00 00 
  8028a6:	ff d0                	callq  *%rax
  8028a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028af:	79 2b                	jns    8028dc <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8028b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b5:	be 00 00 00 00       	mov    $0x0,%esi
  8028ba:	48 89 c7             	mov    %rax,%rdi
  8028bd:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  8028c4:	00 00 00 
  8028c7:	ff d0                	callq  *%rax
  8028c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8028cc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028d0:	79 05                	jns    8028d7 <open+0x10d>
			{
				return d;
  8028d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028d5:	eb 18                	jmp    8028ef <open+0x125>
			}
			return r;
  8028d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028da:	eb 13                	jmp    8028ef <open+0x125>
		}	
		return fd2num(fd_store);
  8028dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e0:	48 89 c7             	mov    %rax,%rdi
  8028e3:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 10          	sub    $0x10,%rsp
  8028f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802901:	8b 50 0c             	mov    0xc(%rax),%edx
  802904:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290b:	00 00 00 
  80290e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802910:	be 00 00 00 00       	mov    $0x0,%esi
  802915:	bf 06 00 00 00       	mov    $0x6,%edi
  80291a:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802921:	00 00 00 
  802924:	ff d0                	callq  *%rax
}
  802926:	c9                   	leaveq 
  802927:	c3                   	retq   

0000000000802928 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 83 ec 30          	sub    $0x30,%rsp
  802930:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802934:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802938:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80293c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802943:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802948:	74 07                	je     802951 <devfile_read+0x29>
  80294a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80294f:	75 07                	jne    802958 <devfile_read+0x30>
		return -E_INVAL;
  802951:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802956:	eb 77                	jmp    8029cf <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295c:	8b 50 0c             	mov    0xc(%rax),%edx
  80295f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802966:	00 00 00 
  802969:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80296b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802972:	00 00 00 
  802975:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802979:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80297d:	be 00 00 00 00       	mov    $0x0,%esi
  802982:	bf 03 00 00 00       	mov    $0x3,%edi
  802987:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  80298e:	00 00 00 
  802991:	ff d0                	callq  *%rax
  802993:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802996:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299a:	7f 05                	jg     8029a1 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80299c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299f:	eb 2e                	jmp    8029cf <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8029a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a4:	48 63 d0             	movslq %eax,%rdx
  8029a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ab:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029b2:	00 00 00 
  8029b5:	48 89 c7             	mov    %rax,%rdi
  8029b8:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8029c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	48 83 ec 30          	sub    $0x30,%rsp
  8029d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029e5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029f1:	74 07                	je     8029fa <devfile_write+0x29>
  8029f3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029f8:	75 08                	jne    802a02 <devfile_write+0x31>
		return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	e9 9a 00 00 00       	jmpq   802a9c <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a06:	8b 50 0c             	mov    0xc(%rax),%edx
  802a09:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a10:	00 00 00 
  802a13:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a15:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a1c:	00 
  802a1d:	76 08                	jbe    802a27 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a1f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a26:	00 
	}
	fsipcbuf.write.req_n = n;
  802a27:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2e:	00 00 00 
  802a31:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a35:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a41:	48 89 c6             	mov    %rax,%rsi
  802a44:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a4b:	00 00 00 
  802a4e:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a5a:	be 00 00 00 00       	mov    $0x0,%esi
  802a5f:	bf 04 00 00 00       	mov    $0x4,%edi
  802a64:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
  802a70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a77:	7f 20                	jg     802a99 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a79:	48 bf f6 49 80 00 00 	movabs $0x8049f6,%rdi
  802a80:	00 00 00 
  802a83:	b8 00 00 00 00       	mov    $0x0,%eax
  802a88:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802a8f:	00 00 00 
  802a92:	ff d2                	callq  *%rdx
		return r;
  802a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a97:	eb 03                	jmp    802a9c <devfile_write+0xcb>
	}
	return r;
  802a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a9c:	c9                   	leaveq 
  802a9d:	c3                   	retq   

0000000000802a9e <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a9e:	55                   	push   %rbp
  802a9f:	48 89 e5             	mov    %rsp,%rbp
  802aa2:	48 83 ec 20          	sub    $0x20,%rsp
  802aa6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802abc:	00 00 00 
  802abf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ac1:	be 00 00 00 00       	mov    $0x0,%esi
  802ac6:	bf 05 00 00 00       	mov    $0x5,%edi
  802acb:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	79 05                	jns    802ae5 <devfile_stat+0x47>
		return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	eb 56                	jmp    802b3b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802af0:	00 00 00 
  802af3:	48 89 c7             	mov    %rax,%rdi
  802af6:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b09:	00 00 00 
  802b0c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b16:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b23:	00 00 00 
  802b26:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b30:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3b:	c9                   	leaveq 
  802b3c:	c3                   	retq   

0000000000802b3d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b3d:	55                   	push   %rbp
  802b3e:	48 89 e5             	mov    %rsp,%rbp
  802b41:	48 83 ec 10          	sub    $0x10,%rsp
  802b45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b49:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b50:	8b 50 0c             	mov    0xc(%rax),%edx
  802b53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b5a:	00 00 00 
  802b5d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b66:	00 00 00 
  802b69:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b6c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b6f:	be 00 00 00 00       	mov    $0x0,%esi
  802b74:	bf 02 00 00 00       	mov    $0x2,%edi
  802b79:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 10          	sub    $0x10,%rsp
  802b8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b97:	48 89 c7             	mov    %rax,%rdi
  802b9a:	48 b8 08 11 80 00 00 	movabs $0x801108,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
  802ba6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bab:	7e 07                	jle    802bb4 <remove+0x2d>
		return -E_BAD_PATH;
  802bad:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bb2:	eb 33                	jmp    802be7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb8:	48 89 c6             	mov    %rax,%rsi
  802bbb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bc2:	00 00 00 
  802bc5:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bd1:	be 00 00 00 00       	mov    $0x0,%esi
  802bd6:	bf 07 00 00 00       	mov    $0x7,%edi
  802bdb:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
}
  802be7:	c9                   	leaveq 
  802be8:	c3                   	retq   

0000000000802be9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802be9:	55                   	push   %rbp
  802bea:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bed:	be 00 00 00 00       	mov    $0x0,%esi
  802bf2:	bf 08 00 00 00       	mov    $0x8,%edi
  802bf7:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
}
  802c03:	5d                   	pop    %rbp
  802c04:	c3                   	retq   

0000000000802c05 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c05:	55                   	push   %rbp
  802c06:	48 89 e5             	mov    %rsp,%rbp
  802c09:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c10:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c17:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c1e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c25:	be 00 00 00 00       	mov    $0x0,%esi
  802c2a:	48 89 c7             	mov    %rax,%rdi
  802c2d:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
  802c39:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c40:	79 28                	jns    802c6a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c45:	89 c6                	mov    %eax,%esi
  802c47:	48 bf 12 4a 80 00 00 	movabs $0x804a12,%rdi
  802c4e:	00 00 00 
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
  802c56:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802c5d:	00 00 00 
  802c60:	ff d2                	callq  *%rdx
		return fd_src;
  802c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c65:	e9 74 01 00 00       	jmpq   802dde <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c6a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c71:	be 01 01 00 00       	mov    $0x101,%esi
  802c76:	48 89 c7             	mov    %rax,%rdi
  802c79:	48 b8 ca 27 80 00 00 	movabs $0x8027ca,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c88:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c8c:	79 39                	jns    802cc7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c91:	89 c6                	mov    %eax,%esi
  802c93:	48 bf 28 4a 80 00 00 	movabs $0x804a28,%rdi
  802c9a:	00 00 00 
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca2:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802ca9:	00 00 00 
  802cac:	ff d2                	callq  *%rdx
		close(fd_src);
  802cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
		return fd_dest;
  802cbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc2:	e9 17 01 00 00       	jmpq   802dde <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc7:	eb 74                	jmp    802d3d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cc9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ccc:	48 63 d0             	movslq %eax,%rdx
  802ccf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd9:	48 89 ce             	mov    %rcx,%rsi
  802cdc:	89 c7                	mov    %eax,%edi
  802cde:	48 b8 3e 24 80 00 00 	movabs $0x80243e,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ced:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cf1:	79 4a                	jns    802d3d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802cf3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf6:	89 c6                	mov    %eax,%esi
  802cf8:	48 bf 42 4a 80 00 00 	movabs $0x804a42,%rdi
  802cff:	00 00 00 
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
  802d07:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802d0e:	00 00 00 
  802d11:	ff d2                	callq  *%rdx
			close(fd_src);
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d16:	89 c7                	mov    %eax,%edi
  802d18:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	callq  *%rax
			close(fd_dest);
  802d24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
			return write_size;
  802d35:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d38:	e9 a1 00 00 00       	jmpq   802dde <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d3d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d47:	ba 00 02 00 00       	mov    $0x200,%edx
  802d4c:	48 89 ce             	mov    %rcx,%rsi
  802d4f:	89 c7                	mov    %eax,%edi
  802d51:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
  802d5d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d64:	0f 8f 5f ff ff ff    	jg     802cc9 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d6e:	79 47                	jns    802db7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d73:	89 c6                	mov    %eax,%esi
  802d75:	48 bf 55 4a 80 00 00 	movabs $0x804a55,%rdi
  802d7c:	00 00 00 
  802d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d84:	48 ba bf 05 80 00 00 	movabs $0x8005bf,%rdx
  802d8b:	00 00 00 
  802d8e:	ff d2                	callq  *%rdx
		close(fd_src);
  802d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d93:	89 c7                	mov    %eax,%edi
  802d95:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
		close(fd_dest);
  802da1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da4:	89 c7                	mov    %eax,%edi
  802da6:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
		return read_size;
  802db2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802db5:	eb 27                	jmp    802dde <copy+0x1d9>
	}
	close(fd_src);
  802db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dba:	89 c7                	mov    %eax,%edi
  802dbc:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	callq  *%rax
	close(fd_dest);
  802dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dcb:	89 c7                	mov    %eax,%edi
  802dcd:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
	return 0;
  802dd9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802dde:	c9                   	leaveq 
  802ddf:	c3                   	retq   

0000000000802de0 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802de0:	55                   	push   %rbp
  802de1:	48 89 e5             	mov    %rsp,%rbp
  802de4:	48 83 ec 20          	sub    $0x20,%rsp
  802de8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df0:	8b 40 0c             	mov    0xc(%rax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	7e 67                	jle    802e5e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfb:	8b 40 04             	mov    0x4(%rax),%eax
  802dfe:	48 63 d0             	movslq %eax,%rdx
  802e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e05:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0d:	8b 00                	mov    (%rax),%eax
  802e0f:	48 89 ce             	mov    %rcx,%rsi
  802e12:	89 c7                	mov    %eax,%edi
  802e14:	48 b8 3e 24 80 00 00 	movabs $0x80243e,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e27:	7e 13                	jle    802e3c <writebuf+0x5c>
			b->result += result;
  802e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2d:	8b 50 08             	mov    0x8(%rax),%edx
  802e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e33:	01 c2                	add    %eax,%edx
  802e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e39:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e40:	8b 40 04             	mov    0x4(%rax),%eax
  802e43:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e46:	74 16                	je     802e5e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e48:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e51:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802e55:	89 c2                	mov    %eax,%edx
  802e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802e5e:	c9                   	leaveq 
  802e5f:	c3                   	retq   

0000000000802e60 <putch>:

static void
putch(int ch, void *thunk)
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
  802e64:	48 83 ec 20          	sub    $0x20,%rsp
  802e68:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e73:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7b:	8b 40 04             	mov    0x4(%rax),%eax
  802e7e:	8d 48 01             	lea    0x1(%rax),%ecx
  802e81:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e85:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802e88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e8b:	89 d1                	mov    %edx,%ecx
  802e8d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e91:	48 98                	cltq   
  802e93:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9b:	8b 40 04             	mov    0x4(%rax),%eax
  802e9e:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ea3:	75 1e                	jne    802ec3 <putch+0x63>
		writebuf(b);
  802ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea9:	48 89 c7             	mov    %rax,%rdi
  802eac:	48 b8 e0 2d 80 00 00 	movabs $0x802de0,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
		b->idx = 0;
  802eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802ec3:	c9                   	leaveq 
  802ec4:	c3                   	retq   

0000000000802ec5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802ec5:	55                   	push   %rbp
  802ec6:	48 89 e5             	mov    %rsp,%rbp
  802ec9:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802ed0:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ed6:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802edd:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802ee4:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802eea:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802ef0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802ef7:	00 00 00 
	b.result = 0;
  802efa:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f01:	00 00 00 
	b.error = 1;
  802f04:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f0b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f0e:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f15:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f1c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f23:	48 89 c6             	mov    %rax,%rsi
  802f26:	48 bf 60 2e 80 00 00 	movabs $0x802e60,%rdi
  802f2d:	00 00 00 
  802f30:	48 b8 72 09 80 00 00 	movabs $0x800972,%rax
  802f37:	00 00 00 
  802f3a:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f3c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	7e 16                	jle    802f5c <vfprintf+0x97>
		writebuf(&b);
  802f46:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f4d:	48 89 c7             	mov    %rax,%rdi
  802f50:	48 b8 e0 2d 80 00 00 	movabs $0x802de0,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802f5c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 08                	je     802f6e <vfprintf+0xa9>
  802f66:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802f6c:	eb 06                	jmp    802f74 <vfprintf+0xaf>
  802f6e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f81:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802f87:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f8e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f95:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f9c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fa3:	84 c0                	test   %al,%al
  802fa5:	74 20                	je     802fc7 <fprintf+0x51>
  802fa7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fab:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802faf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fb3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fb7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fbb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fbf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fc3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fc7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fce:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802fd5:	00 00 00 
  802fd8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802fdf:	00 00 00 
  802fe2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fe6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802fed:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ff4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802ffb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803002:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803009:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80300f:	48 89 ce             	mov    %rcx,%rsi
  803012:	89 c7                	mov    %eax,%edi
  803014:	48 b8 c5 2e 80 00 00 	movabs $0x802ec5,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
  803020:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803026:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80302c:	c9                   	leaveq 
  80302d:	c3                   	retq   

000000000080302e <printf>:

int
printf(const char *fmt, ...)
{
  80302e:	55                   	push   %rbp
  80302f:	48 89 e5             	mov    %rsp,%rbp
  803032:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803039:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803040:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803047:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80304e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803055:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80305c:	84 c0                	test   %al,%al
  80305e:	74 20                	je     803080 <printf+0x52>
  803060:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803064:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803068:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80306c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803070:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803074:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803078:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80307c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803080:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803087:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80308e:	00 00 00 
  803091:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803098:	00 00 00 
  80309b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030a6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030bb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8030c2:	48 89 c6             	mov    %rax,%rsi
  8030c5:	bf 01 00 00 00       	mov    $0x1,%edi
  8030ca:	48 b8 c5 2e 80 00 00 	movabs $0x802ec5,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8030dc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8030e2:	c9                   	leaveq 
  8030e3:	c3                   	retq   

00000000008030e4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8030e4:	55                   	push   %rbp
  8030e5:	48 89 e5             	mov    %rsp,%rbp
  8030e8:	48 83 ec 20          	sub    $0x20,%rsp
  8030ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030ef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f6:	48 89 d6             	mov    %rdx,%rsi
  8030f9:	89 c7                	mov    %eax,%edi
  8030fb:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
  803107:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310e:	79 05                	jns    803115 <fd2sockid+0x31>
		return r;
  803110:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803113:	eb 24                	jmp    803139 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803119:	8b 10                	mov    (%rax),%edx
  80311b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803122:	00 00 00 
  803125:	8b 00                	mov    (%rax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	74 07                	je     803132 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80312b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803130:	eb 07                	jmp    803139 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803136:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   

000000000080313b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80313b:	55                   	push   %rbp
  80313c:	48 89 e5             	mov    %rsp,%rbp
  80313f:	48 83 ec 20          	sub    $0x20,%rsp
  803143:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803146:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80314a:	48 89 c7             	mov    %rax,%rdi
  80314d:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
  803159:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803160:	78 26                	js     803188 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803166:	ba 07 04 00 00       	mov    $0x407,%edx
  80316b:	48 89 c6             	mov    %rax,%rsi
  80316e:	bf 00 00 00 00       	mov    $0x0,%edi
  803173:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  80317a:	00 00 00 
  80317d:	ff d0                	callq  *%rax
  80317f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803186:	79 16                	jns    80319e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 48 36 80 00 00 	movabs $0x803648,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
		return r;
  803199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319c:	eb 3a                	jmp    8031d8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80319e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8031a9:	00 00 00 
  8031ac:	8b 12                	mov    (%rdx),%edx
  8031ae:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8031b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8031bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031c2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8031c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c9:	48 89 c7             	mov    %rax,%rdi
  8031cc:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 30          	sub    $0x30,%rsp
  8031e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f0:	89 c7                	mov    %eax,%edi
  8031f2:	48 b8 e4 30 80 00 00 	movabs $0x8030e4,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803201:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803205:	79 05                	jns    80320c <accept+0x32>
		return r;
  803207:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320a:	eb 3b                	jmp    803247 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80320c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803210:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803214:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803217:	48 89 ce             	mov    %rcx,%rsi
  80321a:	89 c7                	mov    %eax,%edi
  80321c:	48 b8 25 35 80 00 00 	movabs $0x803525,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322f:	79 05                	jns    803236 <accept+0x5c>
		return r;
  803231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803234:	eb 11                	jmp    803247 <accept+0x6d>
	return alloc_sockfd(r);
  803236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803239:	89 c7                	mov    %eax,%edi
  80323b:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
}
  803247:	c9                   	leaveq 
  803248:	c3                   	retq   

0000000000803249 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803249:	55                   	push   %rbp
  80324a:	48 89 e5             	mov    %rsp,%rbp
  80324d:	48 83 ec 20          	sub    $0x20,%rsp
  803251:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803258:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80325b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80325e:	89 c7                	mov    %eax,%edi
  803260:	48 b8 e4 30 80 00 00 	movabs $0x8030e4,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803273:	79 05                	jns    80327a <bind+0x31>
		return r;
  803275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803278:	eb 1b                	jmp    803295 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80327a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80327d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803284:	48 89 ce             	mov    %rcx,%rsi
  803287:	89 c7                	mov    %eax,%edi
  803289:	48 b8 a4 35 80 00 00 	movabs $0x8035a4,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <shutdown>:

int
shutdown(int s, int how)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 20          	sub    $0x20,%rsp
  80329f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a8:	89 c7                	mov    %eax,%edi
  8032aa:	48 b8 e4 30 80 00 00 	movabs $0x8030e4,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
  8032b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bd:	79 05                	jns    8032c4 <shutdown+0x2d>
		return r;
  8032bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c2:	eb 16                	jmp    8032da <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8032c4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ca:	89 d6                	mov    %edx,%esi
  8032cc:	89 c7                	mov    %eax,%edi
  8032ce:	48 b8 08 36 80 00 00 	movabs $0x803608,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
}
  8032da:	c9                   	leaveq 
  8032db:	c3                   	retq   

00000000008032dc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8032dc:	55                   	push   %rbp
  8032dd:	48 89 e5             	mov    %rsp,%rbp
  8032e0:	48 83 ec 10          	sub    $0x10,%rsp
  8032e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8032e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ec:	48 89 c7             	mov    %rax,%rdi
  8032ef:	48 b8 56 43 80 00 00 	movabs $0x804356,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
  8032fb:	83 f8 01             	cmp    $0x1,%eax
  8032fe:	75 17                	jne    803317 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803304:	8b 40 0c             	mov    0xc(%rax),%eax
  803307:	89 c7                	mov    %eax,%edi
  803309:	48 b8 48 36 80 00 00 	movabs $0x803648,%rax
  803310:	00 00 00 
  803313:	ff d0                	callq  *%rax
  803315:	eb 05                	jmp    80331c <devsock_close+0x40>
	else
		return 0;
  803317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331c:	c9                   	leaveq 
  80331d:	c3                   	retq   

000000000080331e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80331e:	55                   	push   %rbp
  80331f:	48 89 e5             	mov    %rsp,%rbp
  803322:	48 83 ec 20          	sub    $0x20,%rsp
  803326:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803329:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80332d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803330:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803333:	89 c7                	mov    %eax,%edi
  803335:	48 b8 e4 30 80 00 00 	movabs $0x8030e4,%rax
  80333c:	00 00 00 
  80333f:	ff d0                	callq  *%rax
  803341:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803348:	79 05                	jns    80334f <connect+0x31>
		return r;
  80334a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334d:	eb 1b                	jmp    80336a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80334f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803352:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803359:	48 89 ce             	mov    %rcx,%rsi
  80335c:	89 c7                	mov    %eax,%edi
  80335e:	48 b8 75 36 80 00 00 	movabs $0x803675,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
}
  80336a:	c9                   	leaveq 
  80336b:	c3                   	retq   

000000000080336c <listen>:

int
listen(int s, int backlog)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	48 83 ec 20          	sub    $0x20,%rsp
  803374:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803377:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80337a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 e4 30 80 00 00 	movabs $0x8030e4,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
  80338b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803392:	79 05                	jns    803399 <listen+0x2d>
		return r;
  803394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803397:	eb 16                	jmp    8033af <listen+0x43>
	return nsipc_listen(r, backlog);
  803399:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80339c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339f:	89 d6                	mov    %edx,%esi
  8033a1:	89 c7                	mov    %eax,%edi
  8033a3:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
}
  8033af:	c9                   	leaveq 
  8033b0:	c3                   	retq   

00000000008033b1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033b1:	55                   	push   %rbp
  8033b2:	48 89 e5             	mov    %rsp,%rbp
  8033b5:	48 83 ec 20          	sub    $0x20,%rsp
  8033b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c9:	89 c2                	mov    %eax,%edx
  8033cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cf:	8b 40 0c             	mov    0xc(%rax),%eax
  8033d2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033db:	89 c7                	mov    %eax,%edi
  8033dd:	48 b8 19 37 80 00 00 	movabs $0x803719,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 20          	sub    $0x20,%rsp
  8033f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803403:	89 c2                	mov    %eax,%edx
  803405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803409:	8b 40 0c             	mov    0xc(%rax),%eax
  80340c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803410:	b9 00 00 00 00       	mov    $0x0,%ecx
  803415:	89 c7                	mov    %eax,%edi
  803417:	48 b8 e5 37 80 00 00 	movabs $0x8037e5,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
}
  803423:	c9                   	leaveq 
  803424:	c3                   	retq   

0000000000803425 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803425:	55                   	push   %rbp
  803426:	48 89 e5             	mov    %rsp,%rbp
  803429:	48 83 ec 10          	sub    $0x10,%rsp
  80342d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803431:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	48 be 70 4a 80 00 00 	movabs $0x804a70,%rsi
  803440:	00 00 00 
  803443:	48 89 c7             	mov    %rax,%rdi
  803446:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  80344d:	00 00 00 
  803450:	ff d0                	callq  *%rax
	return 0;
  803452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <socket>:

int
socket(int domain, int type, int protocol)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 20          	sub    $0x20,%rsp
  803461:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803464:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803467:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80346a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80346d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803470:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803473:	89 ce                	mov    %ecx,%esi
  803475:	89 c7                	mov    %eax,%edi
  803477:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
  803483:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348a:	79 05                	jns    803491 <socket+0x38>
		return r;
  80348c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348f:	eb 11                	jmp    8034a2 <socket+0x49>
	return alloc_sockfd(r);
  803491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803494:	89 c7                	mov    %eax,%edi
  803496:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
}
  8034a2:	c9                   	leaveq 
  8034a3:	c3                   	retq   

00000000008034a4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8034a4:	55                   	push   %rbp
  8034a5:	48 89 e5             	mov    %rsp,%rbp
  8034a8:	48 83 ec 10          	sub    $0x10,%rsp
  8034ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8034af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034b6:	00 00 00 
  8034b9:	8b 00                	mov    (%rax),%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	75 1d                	jne    8034dc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8034bf:	bf 02 00 00 00       	mov    $0x2,%edi
  8034c4:	48 b8 d4 42 80 00 00 	movabs $0x8042d4,%rax
  8034cb:	00 00 00 
  8034ce:	ff d0                	callq  *%rax
  8034d0:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  8034d7:	00 00 00 
  8034da:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034e3:	00 00 00 
  8034e6:	8b 00                	mov    (%rax),%eax
  8034e8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034eb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034f0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8034f7:	00 00 00 
  8034fa:	89 c7                	mov    %eax,%edi
  8034fc:	48 b8 72 42 80 00 00 	movabs $0x804272,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803508:	ba 00 00 00 00       	mov    $0x0,%edx
  80350d:	be 00 00 00 00       	mov    $0x0,%esi
  803512:	bf 00 00 00 00       	mov    $0x0,%edi
  803517:	48 b8 6c 41 80 00 00 	movabs $0x80416c,%rax
  80351e:	00 00 00 
  803521:	ff d0                	callq  *%rax
}
  803523:	c9                   	leaveq 
  803524:	c3                   	retq   

0000000000803525 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803525:	55                   	push   %rbp
  803526:	48 89 e5             	mov    %rsp,%rbp
  803529:	48 83 ec 30          	sub    $0x30,%rsp
  80352d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803530:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803534:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803538:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80353f:	00 00 00 
  803542:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803545:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803547:	bf 01 00 00 00       	mov    $0x1,%edi
  80354c:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
  803558:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355f:	78 3e                	js     80359f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803561:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803568:	00 00 00 
  80356b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80356f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803573:	8b 40 10             	mov    0x10(%rax),%eax
  803576:	89 c2                	mov    %eax,%edx
  803578:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80357c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803580:	48 89 ce             	mov    %rcx,%rsi
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803596:	8b 50 10             	mov    0x10(%rax),%edx
  803599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035a2:	c9                   	leaveq 
  8035a3:	c3                   	retq   

00000000008035a4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035a4:	55                   	push   %rbp
  8035a5:	48 89 e5             	mov    %rsp,%rbp
  8035a8:	48 83 ec 10          	sub    $0x10,%rsp
  8035ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8035b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035bd:	00 00 00 
  8035c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035c3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8035c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cc:	48 89 c6             	mov    %rax,%rsi
  8035cf:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8035d6:	00 00 00 
  8035d9:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8035e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ec:	00 00 00 
  8035ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035f2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8035f5:	bf 02 00 00 00       	mov    $0x2,%edi
  8035fa:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803601:	00 00 00 
  803604:	ff d0                	callq  *%rax
}
  803606:	c9                   	leaveq 
  803607:	c3                   	retq   

0000000000803608 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803608:	55                   	push   %rbp
  803609:	48 89 e5             	mov    %rsp,%rbp
  80360c:	48 83 ec 10          	sub    $0x10,%rsp
  803610:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803613:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803616:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361d:	00 00 00 
  803620:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803623:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803625:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80362c:	00 00 00 
  80362f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803632:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803635:	bf 03 00 00 00       	mov    $0x3,%edi
  80363a:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
}
  803646:	c9                   	leaveq 
  803647:	c3                   	retq   

0000000000803648 <nsipc_close>:

int
nsipc_close(int s)
{
  803648:	55                   	push   %rbp
  803649:	48 89 e5             	mov    %rsp,%rbp
  80364c:	48 83 ec 10          	sub    $0x10,%rsp
  803650:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803653:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80365a:	00 00 00 
  80365d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803660:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803662:	bf 04 00 00 00       	mov    $0x4,%edi
  803667:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
}
  803673:	c9                   	leaveq 
  803674:	c3                   	retq   

0000000000803675 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803675:	55                   	push   %rbp
  803676:	48 89 e5             	mov    %rsp,%rbp
  803679:	48 83 ec 10          	sub    $0x10,%rsp
  80367d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803680:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803684:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803687:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368e:	00 00 00 
  803691:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803694:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803696:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369d:	48 89 c6             	mov    %rax,%rsi
  8036a0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036a7:	00 00 00 
  8036aa:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8036b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bd:	00 00 00 
  8036c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036c3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8036c6:	bf 05 00 00 00       	mov    $0x5,%edi
  8036cb:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
}
  8036d7:	c9                   	leaveq 
  8036d8:	c3                   	retq   

00000000008036d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8036d9:	55                   	push   %rbp
  8036da:	48 89 e5             	mov    %rsp,%rbp
  8036dd:	48 83 ec 10          	sub    $0x10,%rsp
  8036e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8036e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ee:	00 00 00 
  8036f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036f4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8036f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fd:	00 00 00 
  803700:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803703:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803706:	bf 06 00 00 00       	mov    $0x6,%edi
  80370b:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
}
  803717:	c9                   	leaveq 
  803718:	c3                   	retq   

0000000000803719 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803719:	55                   	push   %rbp
  80371a:	48 89 e5             	mov    %rsp,%rbp
  80371d:	48 83 ec 30          	sub    $0x30,%rsp
  803721:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803724:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803728:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80372b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80372e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803735:	00 00 00 
  803738:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80373b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80373d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803744:	00 00 00 
  803747:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80374a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80374d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803754:	00 00 00 
  803757:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80375a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80375d:	bf 07 00 00 00       	mov    $0x7,%edi
  803762:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803769:	00 00 00 
  80376c:	ff d0                	callq  *%rax
  80376e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803775:	78 69                	js     8037e0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803777:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80377e:	7f 08                	jg     803788 <nsipc_recv+0x6f>
  803780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803783:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803786:	7e 35                	jle    8037bd <nsipc_recv+0xa4>
  803788:	48 b9 77 4a 80 00 00 	movabs $0x804a77,%rcx
  80378f:	00 00 00 
  803792:	48 ba 8c 4a 80 00 00 	movabs $0x804a8c,%rdx
  803799:	00 00 00 
  80379c:	be 61 00 00 00       	mov    $0x61,%esi
  8037a1:	48 bf a1 4a 80 00 00 	movabs $0x804aa1,%rdi
  8037a8:	00 00 00 
  8037ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b0:	49 b8 86 03 80 00 00 	movabs $0x800386,%r8
  8037b7:	00 00 00 
  8037ba:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c0:	48 63 d0             	movslq %eax,%rdx
  8037c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8037ce:	00 00 00 
  8037d1:	48 89 c7             	mov    %rax,%rdi
  8037d4:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8037db:	00 00 00 
  8037de:	ff d0                	callq  *%rax
	}

	return r;
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037e3:	c9                   	leaveq 
  8037e4:	c3                   	retq   

00000000008037e5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037e5:	55                   	push   %rbp
  8037e6:	48 89 e5             	mov    %rsp,%rbp
  8037e9:	48 83 ec 20          	sub    $0x20,%rsp
  8037ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037f4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8037f7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8037fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803801:	00 00 00 
  803804:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803807:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803809:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803810:	7e 35                	jle    803847 <nsipc_send+0x62>
  803812:	48 b9 ad 4a 80 00 00 	movabs $0x804aad,%rcx
  803819:	00 00 00 
  80381c:	48 ba 8c 4a 80 00 00 	movabs $0x804a8c,%rdx
  803823:	00 00 00 
  803826:	be 6c 00 00 00       	mov    $0x6c,%esi
  80382b:	48 bf a1 4a 80 00 00 	movabs $0x804aa1,%rdi
  803832:	00 00 00 
  803835:	b8 00 00 00 00       	mov    $0x0,%eax
  80383a:	49 b8 86 03 80 00 00 	movabs $0x800386,%r8
  803841:	00 00 00 
  803844:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803847:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80384a:	48 63 d0             	movslq %eax,%rdx
  80384d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803851:	48 89 c6             	mov    %rax,%rsi
  803854:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80385b:	00 00 00 
  80385e:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80386a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803871:	00 00 00 
  803874:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803877:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80387a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803881:	00 00 00 
  803884:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803887:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80388a:	bf 08 00 00 00       	mov    $0x8,%edi
  80388f:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
}
  80389b:	c9                   	leaveq 
  80389c:	c3                   	retq   

000000000080389d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80389d:	55                   	push   %rbp
  80389e:	48 89 e5             	mov    %rsp,%rbp
  8038a1:	48 83 ec 10          	sub    $0x10,%rsp
  8038a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038a8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8038ab:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8038ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b5:	00 00 00 
  8038b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038bb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8038bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c4:	00 00 00 
  8038c7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8038cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d4:	00 00 00 
  8038d7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038da:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8038dd:	bf 09 00 00 00       	mov    $0x9,%edi
  8038e2:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
}
  8038ee:	c9                   	leaveq 
  8038ef:	c3                   	retq   

00000000008038f0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8038f0:	55                   	push   %rbp
  8038f1:	48 89 e5             	mov    %rsp,%rbp
  8038f4:	53                   	push   %rbx
  8038f5:	48 83 ec 38          	sub    $0x38,%rsp
  8038f9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8038fd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803901:	48 89 c7             	mov    %rax,%rdi
  803904:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
  803910:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803913:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803917:	0f 88 bf 01 00 00    	js     803adc <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80391d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803921:	ba 07 04 00 00       	mov    $0x407,%edx
  803926:	48 89 c6             	mov    %rax,%rsi
  803929:	bf 00 00 00 00       	mov    $0x0,%edi
  80392e:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
  80393a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80393d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803941:	0f 88 95 01 00 00    	js     803adc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803947:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80394b:	48 89 c7             	mov    %rax,%rdi
  80394e:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
  80395a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80395d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803961:	0f 88 5d 01 00 00    	js     803ac4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803967:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80396b:	ba 07 04 00 00       	mov    $0x407,%edx
  803970:	48 89 c6             	mov    %rax,%rsi
  803973:	bf 00 00 00 00       	mov    $0x0,%edi
  803978:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  80397f:	00 00 00 
  803982:	ff d0                	callq  *%rax
  803984:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803987:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80398b:	0f 88 33 01 00 00    	js     803ac4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803995:	48 89 c7             	mov    %rax,%rdi
  803998:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
  8039a4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ac:	ba 07 04 00 00       	mov    $0x407,%edx
  8039b1:	48 89 c6             	mov    %rax,%rsi
  8039b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b9:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
  8039c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039cc:	79 05                	jns    8039d3 <pipe+0xe3>
		goto err2;
  8039ce:	e9 d9 00 00 00       	jmpq   803aac <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d7:	48 89 c7             	mov    %rax,%rdi
  8039da:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
  8039e6:	48 89 c2             	mov    %rax,%rdx
  8039e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ed:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8039f3:	48 89 d1             	mov    %rdx,%rcx
  8039f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8039fb:	48 89 c6             	mov    %rax,%rsi
  8039fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803a03:	48 b8 f3 1a 80 00 00 	movabs $0x801af3,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
  803a0f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a12:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a16:	79 1b                	jns    803a33 <pipe+0x143>
		goto err3;
  803a18:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803a19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1d:	48 89 c6             	mov    %rax,%rsi
  803a20:	bf 00 00 00 00       	mov    $0x0,%edi
  803a25:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
  803a31:	eb 79                	jmp    803aac <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a37:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a3e:	00 00 00 
  803a41:	8b 12                	mov    (%rdx),%edx
  803a43:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a54:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a5b:	00 00 00 
  803a5e:	8b 12                	mov    (%rdx),%edx
  803a60:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a66:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a71:	48 89 c7             	mov    %rax,%rdi
  803a74:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
  803a80:	89 c2                	mov    %eax,%edx
  803a82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a86:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a8c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a94:	48 89 c7             	mov    %rax,%rdi
  803a97:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
  803aa3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  803aaa:	eb 33                	jmp    803adf <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803aac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab0:	48 89 c6             	mov    %rax,%rsi
  803ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab8:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac8:	48 89 c6             	mov    %rax,%rsi
  803acb:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad0:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803ad7:	00 00 00 
  803ada:	ff d0                	callq  *%rax
err:
	return r;
  803adc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803adf:	48 83 c4 38          	add    $0x38,%rsp
  803ae3:	5b                   	pop    %rbx
  803ae4:	5d                   	pop    %rbp
  803ae5:	c3                   	retq   

0000000000803ae6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ae6:	55                   	push   %rbp
  803ae7:	48 89 e5             	mov    %rsp,%rbp
  803aea:	53                   	push   %rbx
  803aeb:	48 83 ec 28          	sub    $0x28,%rsp
  803aef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803af3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803af7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803afe:	00 00 00 
  803b01:	48 8b 00             	mov    (%rax),%rax
  803b04:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b11:	48 89 c7             	mov    %rax,%rdi
  803b14:	48 b8 56 43 80 00 00 	movabs $0x804356,%rax
  803b1b:	00 00 00 
  803b1e:	ff d0                	callq  *%rax
  803b20:	89 c3                	mov    %eax,%ebx
  803b22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b26:	48 89 c7             	mov    %rax,%rdi
  803b29:	48 b8 56 43 80 00 00 	movabs $0x804356,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
  803b35:	39 c3                	cmp    %eax,%ebx
  803b37:	0f 94 c0             	sete   %al
  803b3a:	0f b6 c0             	movzbl %al,%eax
  803b3d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b40:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803b47:	00 00 00 
  803b4a:	48 8b 00             	mov    (%rax),%rax
  803b4d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b53:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b59:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b5c:	75 05                	jne    803b63 <_pipeisclosed+0x7d>
			return ret;
  803b5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b61:	eb 4f                	jmp    803bb2 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803b63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b66:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b69:	74 42                	je     803bad <_pipeisclosed+0xc7>
  803b6b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b6f:	75 3c                	jne    803bad <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b71:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803b78:	00 00 00 
  803b7b:	48 8b 00             	mov    (%rax),%rax
  803b7e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b84:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b8a:	89 c6                	mov    %eax,%esi
  803b8c:	48 bf be 4a 80 00 00 	movabs $0x804abe,%rdi
  803b93:	00 00 00 
  803b96:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9b:	49 b8 bf 05 80 00 00 	movabs $0x8005bf,%r8
  803ba2:	00 00 00 
  803ba5:	41 ff d0             	callq  *%r8
	}
  803ba8:	e9 4a ff ff ff       	jmpq   803af7 <_pipeisclosed+0x11>
  803bad:	e9 45 ff ff ff       	jmpq   803af7 <_pipeisclosed+0x11>
}
  803bb2:	48 83 c4 28          	add    $0x28,%rsp
  803bb6:	5b                   	pop    %rbx
  803bb7:	5d                   	pop    %rbp
  803bb8:	c3                   	retq   

0000000000803bb9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803bb9:	55                   	push   %rbp
  803bba:	48 89 e5             	mov    %rsp,%rbp
  803bbd:	48 83 ec 30          	sub    $0x30,%rsp
  803bc1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bcb:	48 89 d6             	mov    %rdx,%rsi
  803bce:	89 c7                	mov    %eax,%edi
  803bd0:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  803bd7:	00 00 00 
  803bda:	ff d0                	callq  *%rax
  803bdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be3:	79 05                	jns    803bea <pipeisclosed+0x31>
		return r;
  803be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be8:	eb 31                	jmp    803c1b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bee:	48 89 c7             	mov    %rax,%rdi
  803bf1:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	callq  *%rax
  803bfd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c09:	48 89 d6             	mov    %rdx,%rsi
  803c0c:	48 89 c7             	mov    %rax,%rdi
  803c0f:	48 b8 e6 3a 80 00 00 	movabs $0x803ae6,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
}
  803c1b:	c9                   	leaveq 
  803c1c:	c3                   	retq   

0000000000803c1d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c1d:	55                   	push   %rbp
  803c1e:	48 89 e5             	mov    %rsp,%rbp
  803c21:	48 83 ec 40          	sub    $0x40,%rsp
  803c25:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c29:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c2d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c35:	48 89 c7             	mov    %rax,%rdi
  803c38:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
  803c44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c50:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c57:	00 
  803c58:	e9 92 00 00 00       	jmpq   803cef <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803c5d:	eb 41                	jmp    803ca0 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c5f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c64:	74 09                	je     803c6f <devpipe_read+0x52>
				return i;
  803c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c6a:	e9 92 00 00 00       	jmpq   803d01 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c77:	48 89 d6             	mov    %rdx,%rsi
  803c7a:	48 89 c7             	mov    %rax,%rdi
  803c7d:	48 b8 e6 3a 80 00 00 	movabs $0x803ae6,%rax
  803c84:	00 00 00 
  803c87:	ff d0                	callq  *%rax
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	74 07                	je     803c94 <devpipe_read+0x77>
				return 0;
  803c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c92:	eb 6d                	jmp    803d01 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c94:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ca0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca4:	8b 10                	mov    (%rax),%edx
  803ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803caa:	8b 40 04             	mov    0x4(%rax),%eax
  803cad:	39 c2                	cmp    %eax,%edx
  803caf:	74 ae                	je     803c5f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cb9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc1:	8b 00                	mov    (%rax),%eax
  803cc3:	99                   	cltd   
  803cc4:	c1 ea 1b             	shr    $0x1b,%edx
  803cc7:	01 d0                	add    %edx,%eax
  803cc9:	83 e0 1f             	and    $0x1f,%eax
  803ccc:	29 d0                	sub    %edx,%eax
  803cce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd2:	48 98                	cltq   
  803cd4:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803cd9:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdf:	8b 00                	mov    (%rax),%eax
  803ce1:	8d 50 01             	lea    0x1(%rax),%edx
  803ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce8:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cf7:	0f 82 60 ff ff ff    	jb     803c5d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803cfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d01:	c9                   	leaveq 
  803d02:	c3                   	retq   

0000000000803d03 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d03:	55                   	push   %rbp
  803d04:	48 89 e5             	mov    %rsp,%rbp
  803d07:	48 83 ec 40          	sub    $0x40,%rsp
  803d0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d0f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d13:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d1b:	48 89 c7             	mov    %rax,%rdi
  803d1e:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
  803d2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d36:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d3d:	00 
  803d3e:	e9 8e 00 00 00       	jmpq   803dd1 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d43:	eb 31                	jmp    803d76 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4d:	48 89 d6             	mov    %rdx,%rsi
  803d50:	48 89 c7             	mov    %rax,%rdi
  803d53:	48 b8 e6 3a 80 00 00 	movabs $0x803ae6,%rax
  803d5a:	00 00 00 
  803d5d:	ff d0                	callq  *%rax
  803d5f:	85 c0                	test   %eax,%eax
  803d61:	74 07                	je     803d6a <devpipe_write+0x67>
				return 0;
  803d63:	b8 00 00 00 00       	mov    $0x0,%eax
  803d68:	eb 79                	jmp    803de3 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d6a:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  803d71:	00 00 00 
  803d74:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7a:	8b 40 04             	mov    0x4(%rax),%eax
  803d7d:	48 63 d0             	movslq %eax,%rdx
  803d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d84:	8b 00                	mov    (%rax),%eax
  803d86:	48 98                	cltq   
  803d88:	48 83 c0 20          	add    $0x20,%rax
  803d8c:	48 39 c2             	cmp    %rax,%rdx
  803d8f:	73 b4                	jae    803d45 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d95:	8b 40 04             	mov    0x4(%rax),%eax
  803d98:	99                   	cltd   
  803d99:	c1 ea 1b             	shr    $0x1b,%edx
  803d9c:	01 d0                	add    %edx,%eax
  803d9e:	83 e0 1f             	and    $0x1f,%eax
  803da1:	29 d0                	sub    %edx,%eax
  803da3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803da7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803dab:	48 01 ca             	add    %rcx,%rdx
  803dae:	0f b6 0a             	movzbl (%rdx),%ecx
  803db1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803db5:	48 98                	cltq   
  803db7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dbf:	8b 40 04             	mov    0x4(%rax),%eax
  803dc2:	8d 50 01             	lea    0x1(%rax),%edx
  803dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc9:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dcc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803dd9:	0f 82 64 ff ff ff    	jb     803d43 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803de3:	c9                   	leaveq 
  803de4:	c3                   	retq   

0000000000803de5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803de5:	55                   	push   %rbp
  803de6:	48 89 e5             	mov    %rsp,%rbp
  803de9:	48 83 ec 20          	sub    $0x20,%rsp
  803ded:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803df1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df9:	48 89 c7             	mov    %rax,%rdi
  803dfc:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  803e03:	00 00 00 
  803e06:	ff d0                	callq  *%rax
  803e08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e10:	48 be d1 4a 80 00 00 	movabs $0x804ad1,%rsi
  803e17:	00 00 00 
  803e1a:	48 89 c7             	mov    %rax,%rdi
  803e1d:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  803e24:	00 00 00 
  803e27:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e2d:	8b 50 04             	mov    0x4(%rax),%edx
  803e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e34:	8b 00                	mov    (%rax),%eax
  803e36:	29 c2                	sub    %eax,%edx
  803e38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e46:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e4d:	00 00 00 
	stat->st_dev = &devpipe;
  803e50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e54:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803e5b:	00 00 00 
  803e5e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e6a:	c9                   	leaveq 
  803e6b:	c3                   	retq   

0000000000803e6c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e6c:	55                   	push   %rbp
  803e6d:	48 89 e5             	mov    %rsp,%rbp
  803e70:	48 83 ec 10          	sub    $0x10,%rsp
  803e74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7c:	48 89 c6             	mov    %rax,%rsi
  803e7f:	bf 00 00 00 00       	mov    $0x0,%edi
  803e84:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803e8b:	00 00 00 
  803e8e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e94:	48 89 c7             	mov    %rax,%rdi
  803e97:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  803e9e:	00 00 00 
  803ea1:	ff d0                	callq  *%rax
  803ea3:	48 89 c6             	mov    %rax,%rsi
  803ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  803eab:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
}
  803eb7:	c9                   	leaveq 
  803eb8:	c3                   	retq   

0000000000803eb9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803eb9:	55                   	push   %rbp
  803eba:	48 89 e5             	mov    %rsp,%rbp
  803ebd:	48 83 ec 20          	sub    $0x20,%rsp
  803ec1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803eca:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ece:	be 01 00 00 00       	mov    $0x1,%esi
  803ed3:	48 89 c7             	mov    %rax,%rdi
  803ed6:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803edd:	00 00 00 
  803ee0:	ff d0                	callq  *%rax
}
  803ee2:	c9                   	leaveq 
  803ee3:	c3                   	retq   

0000000000803ee4 <getchar>:

int
getchar(void)
{
  803ee4:	55                   	push   %rbp
  803ee5:	48 89 e5             	mov    %rsp,%rbp
  803ee8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803eec:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ef0:	ba 01 00 00 00       	mov    $0x1,%edx
  803ef5:	48 89 c6             	mov    %rax,%rsi
  803ef8:	bf 00 00 00 00       	mov    $0x0,%edi
  803efd:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  803f04:	00 00 00 
  803f07:	ff d0                	callq  *%rax
  803f09:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f10:	79 05                	jns    803f17 <getchar+0x33>
		return r;
  803f12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f15:	eb 14                	jmp    803f2b <getchar+0x47>
	if (r < 1)
  803f17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1b:	7f 07                	jg     803f24 <getchar+0x40>
		return -E_EOF;
  803f1d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f22:	eb 07                	jmp    803f2b <getchar+0x47>
	return c;
  803f24:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f28:	0f b6 c0             	movzbl %al,%eax
}
  803f2b:	c9                   	leaveq 
  803f2c:	c3                   	retq   

0000000000803f2d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f2d:	55                   	push   %rbp
  803f2e:	48 89 e5             	mov    %rsp,%rbp
  803f31:	48 83 ec 20          	sub    $0x20,%rsp
  803f35:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3f:	48 89 d6             	mov    %rdx,%rsi
  803f42:	89 c7                	mov    %eax,%edi
  803f44:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f57:	79 05                	jns    803f5e <iscons+0x31>
		return r;
  803f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5c:	eb 1a                	jmp    803f78 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f62:	8b 10                	mov    (%rax),%edx
  803f64:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f6b:	00 00 00 
  803f6e:	8b 00                	mov    (%rax),%eax
  803f70:	39 c2                	cmp    %eax,%edx
  803f72:	0f 94 c0             	sete   %al
  803f75:	0f b6 c0             	movzbl %al,%eax
}
  803f78:	c9                   	leaveq 
  803f79:	c3                   	retq   

0000000000803f7a <opencons>:

int
opencons(void)
{
  803f7a:	55                   	push   %rbp
  803f7b:	48 89 e5             	mov    %rsp,%rbp
  803f7e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f82:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f86:	48 89 c7             	mov    %rax,%rdi
  803f89:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  803f90:	00 00 00 
  803f93:	ff d0                	callq  *%rax
  803f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9c:	79 05                	jns    803fa3 <opencons+0x29>
		return r;
  803f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa1:	eb 5b                	jmp    803ffe <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa7:	ba 07 04 00 00       	mov    $0x407,%edx
  803fac:	48 89 c6             	mov    %rax,%rsi
  803faf:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb4:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
  803fc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc7:	79 05                	jns    803fce <opencons+0x54>
		return r;
  803fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcc:	eb 30                	jmp    803ffe <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd2:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803fd9:	00 00 00 
  803fdc:	8b 12                	mov    (%rdx),%edx
  803fde:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fef:	48 89 c7             	mov    %rax,%rdi
  803ff2:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  803ff9:	00 00 00 
  803ffc:	ff d0                	callq  *%rax
}
  803ffe:	c9                   	leaveq 
  803fff:	c3                   	retq   

0000000000804000 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804000:	55                   	push   %rbp
  804001:	48 89 e5             	mov    %rsp,%rbp
  804004:	48 83 ec 30          	sub    $0x30,%rsp
  804008:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804010:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804014:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804019:	75 07                	jne    804022 <devcons_read+0x22>
		return 0;
  80401b:	b8 00 00 00 00       	mov    $0x0,%eax
  804020:	eb 4b                	jmp    80406d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804022:	eb 0c                	jmp    804030 <devcons_read+0x30>
		sys_yield();
  804024:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  80402b:	00 00 00 
  80402e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804030:	48 b8 a5 19 80 00 00 	movabs $0x8019a5,%rax
  804037:	00 00 00 
  80403a:	ff d0                	callq  *%rax
  80403c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804043:	74 df                	je     804024 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804049:	79 05                	jns    804050 <devcons_read+0x50>
		return c;
  80404b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404e:	eb 1d                	jmp    80406d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804050:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804054:	75 07                	jne    80405d <devcons_read+0x5d>
		return 0;
  804056:	b8 00 00 00 00       	mov    $0x0,%eax
  80405b:	eb 10                	jmp    80406d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80405d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804060:	89 c2                	mov    %eax,%edx
  804062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804066:	88 10                	mov    %dl,(%rax)
	return 1;
  804068:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80406d:	c9                   	leaveq 
  80406e:	c3                   	retq   

000000000080406f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80406f:	55                   	push   %rbp
  804070:	48 89 e5             	mov    %rsp,%rbp
  804073:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80407a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804081:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804088:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80408f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804096:	eb 76                	jmp    80410e <devcons_write+0x9f>
		m = n - tot;
  804098:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80409f:	89 c2                	mov    %eax,%edx
  8040a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a4:	29 c2                	sub    %eax,%edx
  8040a6:	89 d0                	mov    %edx,%eax
  8040a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8040ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ae:	83 f8 7f             	cmp    $0x7f,%eax
  8040b1:	76 07                	jbe    8040ba <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8040b3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8040ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040bd:	48 63 d0             	movslq %eax,%rdx
  8040c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c3:	48 63 c8             	movslq %eax,%rcx
  8040c6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8040cd:	48 01 c1             	add    %rax,%rcx
  8040d0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040d7:	48 89 ce             	mov    %rcx,%rsi
  8040da:	48 89 c7             	mov    %rax,%rdi
  8040dd:	48 b8 98 14 80 00 00 	movabs $0x801498,%rax
  8040e4:	00 00 00 
  8040e7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ec:	48 63 d0             	movslq %eax,%rdx
  8040ef:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040f6:	48 89 d6             	mov    %rdx,%rsi
  8040f9:	48 89 c7             	mov    %rax,%rdi
  8040fc:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  804103:	00 00 00 
  804106:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804108:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80410b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80410e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804111:	48 98                	cltq   
  804113:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80411a:	0f 82 78 ff ff ff    	jb     804098 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804120:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804123:	c9                   	leaveq 
  804124:	c3                   	retq   

0000000000804125 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804125:	55                   	push   %rbp
  804126:	48 89 e5             	mov    %rsp,%rbp
  804129:	48 83 ec 08          	sub    $0x8,%rsp
  80412d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804136:	c9                   	leaveq 
  804137:	c3                   	retq   

0000000000804138 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804138:	55                   	push   %rbp
  804139:	48 89 e5             	mov    %rsp,%rbp
  80413c:	48 83 ec 10          	sub    $0x10,%rsp
  804140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804148:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80414c:	48 be dd 4a 80 00 00 	movabs $0x804add,%rsi
  804153:	00 00 00 
  804156:	48 89 c7             	mov    %rax,%rdi
  804159:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  804160:	00 00 00 
  804163:	ff d0                	callq  *%rax
	return 0;
  804165:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80416a:	c9                   	leaveq 
  80416b:	c3                   	retq   

000000000080416c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80416c:	55                   	push   %rbp
  80416d:	48 89 e5             	mov    %rsp,%rbp
  804170:	48 83 ec 30          	sub    $0x30,%rsp
  804174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80417c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804180:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804187:	00 00 00 
  80418a:	48 8b 00             	mov    (%rax),%rax
  80418d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804193:	85 c0                	test   %eax,%eax
  804195:	75 3c                	jne    8041d3 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804197:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  80419e:	00 00 00 
  8041a1:	ff d0                	callq  *%rax
  8041a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8041a8:	48 63 d0             	movslq %eax,%rdx
  8041ab:	48 89 d0             	mov    %rdx,%rax
  8041ae:	48 c1 e0 03          	shl    $0x3,%rax
  8041b2:	48 01 d0             	add    %rdx,%rax
  8041b5:	48 c1 e0 05          	shl    $0x5,%rax
  8041b9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041c0:	00 00 00 
  8041c3:	48 01 c2             	add    %rax,%rdx
  8041c6:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8041cd:	00 00 00 
  8041d0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8041d3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041d8:	75 0e                	jne    8041e8 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8041da:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041e1:	00 00 00 
  8041e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8041e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ec:	48 89 c7             	mov    %rax,%rdi
  8041ef:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8041f6:	00 00 00 
  8041f9:	ff d0                	callq  *%rax
  8041fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8041fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804202:	79 19                	jns    80421d <ipc_recv+0xb1>
		*from_env_store = 0;
  804204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804208:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80420e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804212:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421b:	eb 53                	jmp    804270 <ipc_recv+0x104>
	}
	if(from_env_store)
  80421d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804222:	74 19                	je     80423d <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804224:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80422b:	00 00 00 
  80422e:	48 8b 00             	mov    (%rax),%rax
  804231:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80423b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80423d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804242:	74 19                	je     80425d <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804244:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80424b:	00 00 00 
  80424e:	48 8b 00             	mov    (%rax),%rax
  804251:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80425b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80425d:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804264:	00 00 00 
  804267:	48 8b 00             	mov    (%rax),%rax
  80426a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804270:	c9                   	leaveq 
  804271:	c3                   	retq   

0000000000804272 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804272:	55                   	push   %rbp
  804273:	48 89 e5             	mov    %rsp,%rbp
  804276:	48 83 ec 30          	sub    $0x30,%rsp
  80427a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80427d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804280:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804284:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804287:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80428c:	75 0e                	jne    80429c <ipc_send+0x2a>
		pg = (void*)UTOP;
  80428e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804295:	00 00 00 
  804298:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80429c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80429f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042a9:	89 c7                	mov    %eax,%edi
  8042ab:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  8042b2:	00 00 00 
  8042b5:	ff d0                	callq  *%rax
  8042b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8042ba:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042be:	75 0c                	jne    8042cc <ipc_send+0x5a>
			sys_yield();
  8042c0:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  8042c7:	00 00 00 
  8042ca:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8042cc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042d0:	74 ca                	je     80429c <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8042d2:	c9                   	leaveq 
  8042d3:	c3                   	retq   

00000000008042d4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8042d4:	55                   	push   %rbp
  8042d5:	48 89 e5             	mov    %rsp,%rbp
  8042d8:	48 83 ec 14          	sub    $0x14,%rsp
  8042dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8042df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042e6:	eb 5e                	jmp    804346 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8042e8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8042ef:	00 00 00 
  8042f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f5:	48 63 d0             	movslq %eax,%rdx
  8042f8:	48 89 d0             	mov    %rdx,%rax
  8042fb:	48 c1 e0 03          	shl    $0x3,%rax
  8042ff:	48 01 d0             	add    %rdx,%rax
  804302:	48 c1 e0 05          	shl    $0x5,%rax
  804306:	48 01 c8             	add    %rcx,%rax
  804309:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80430f:	8b 00                	mov    (%rax),%eax
  804311:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804314:	75 2c                	jne    804342 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804316:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80431d:	00 00 00 
  804320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804323:	48 63 d0             	movslq %eax,%rdx
  804326:	48 89 d0             	mov    %rdx,%rax
  804329:	48 c1 e0 03          	shl    $0x3,%rax
  80432d:	48 01 d0             	add    %rdx,%rax
  804330:	48 c1 e0 05          	shl    $0x5,%rax
  804334:	48 01 c8             	add    %rcx,%rax
  804337:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80433d:	8b 40 08             	mov    0x8(%rax),%eax
  804340:	eb 12                	jmp    804354 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804342:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804346:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80434d:	7e 99                	jle    8042e8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80434f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804354:	c9                   	leaveq 
  804355:	c3                   	retq   

0000000000804356 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804356:	55                   	push   %rbp
  804357:	48 89 e5             	mov    %rsp,%rbp
  80435a:	48 83 ec 18          	sub    $0x18,%rsp
  80435e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804366:	48 c1 e8 15          	shr    $0x15,%rax
  80436a:	48 89 c2             	mov    %rax,%rdx
  80436d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804374:	01 00 00 
  804377:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80437b:	83 e0 01             	and    $0x1,%eax
  80437e:	48 85 c0             	test   %rax,%rax
  804381:	75 07                	jne    80438a <pageref+0x34>
		return 0;
  804383:	b8 00 00 00 00       	mov    $0x0,%eax
  804388:	eb 53                	jmp    8043dd <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80438a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80438e:	48 c1 e8 0c          	shr    $0xc,%rax
  804392:	48 89 c2             	mov    %rax,%rdx
  804395:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80439c:	01 00 00 
  80439f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ab:	83 e0 01             	and    $0x1,%eax
  8043ae:	48 85 c0             	test   %rax,%rax
  8043b1:	75 07                	jne    8043ba <pageref+0x64>
		return 0;
  8043b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b8:	eb 23                	jmp    8043dd <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043be:	48 c1 e8 0c          	shr    $0xc,%rax
  8043c2:	48 89 c2             	mov    %rax,%rdx
  8043c5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8043cc:	00 00 00 
  8043cf:	48 c1 e2 04          	shl    $0x4,%rdx
  8043d3:	48 01 d0             	add    %rdx,%rax
  8043d6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8043da:	0f b7 c0             	movzwl %ax,%eax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   
