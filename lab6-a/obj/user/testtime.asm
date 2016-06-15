
obj/user/testtime.debug:     file format elf64-x86-64


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
  80003c:	e8 6c 01 00 00       	callq  8001ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004e:	48 b8 73 1c 80 00 00 	movabs $0x801c73,%rax
  800055:	00 00 00 
  800058:	ff d0                	callq  *%rax
  80005a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800060:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  800070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	79 38                	jns    8000af <sleep+0x6c>
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007d:	7c 30                	jl     8000af <sleep+0x6c>
		panic("sys_time_msec: %e", (int)now);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba c0 3f 80 00 00 	movabs $0x803fc0,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf d2 3f 80 00 00 	movabs $0x803fd2,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if (end < now)
  8000af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b5:	73 2a                	jae    8000e1 <sleep+0x9e>
		panic("sleep: wrap");
  8000b7:	48 ba e2 3f 80 00 00 	movabs $0x803fe2,%rdx
  8000be:	00 00 00 
  8000c1:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c6:	48 bf d2 3f 80 00 00 	movabs $0x803fd2,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 5b 02 80 00 00 	movabs $0x80025b,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
  8000e1:	eb 0c                	jmp    8000ef <sleep+0xac>
		sys_yield();
  8000e3:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ef:	48 b8 73 1c 80 00 00 	movabs $0x801c73,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fe:	72 e3                	jb     8000e3 <sleep+0xa0>
		sys_yield();
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <umain>:

void
umain(int argc, char **argv)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
  800106:	48 83 ec 20          	sub    $0x20,%rsp
  80010a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800118:	eb 10                	jmp    80012a <umain+0x28>
		sys_yield();
  80011a:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80012a:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012e:	7e ea                	jle    80011a <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  800130:	48 bf ee 3f 80 00 00 	movabs $0x803fee,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  800146:	00 00 00 
  800149:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  80014b:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800152:	eb 35                	jmp    800189 <umain+0x87>
		cprintf("%d ", i);
  800154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800157:	89 c6                	mov    %eax,%esi
  800159:	48 bf 04 40 80 00 00 	movabs $0x804004,%rdi
  800160:	00 00 00 
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  80016f:	00 00 00 
  800172:	ff d2                	callq  *%rdx
		sleep(1);
  800174:	bf 01 00 00 00       	mov    $0x1,%edi
  800179:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800180:	00 00 00 
  800183:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800185:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018d:	79 c5                	jns    800154 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018f:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  8001a5:	00 00 00 
  8001a8:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001aa:	cc                   	int3   
	breakpoint();
}
  8001ab:	c9                   	leaveq 
  8001ac:	c3                   	retq   

00000000008001ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001bc:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cd:	48 63 d0             	movslq %eax,%rdx
  8001d0:	48 89 d0             	mov    %rdx,%rax
  8001d3:	48 c1 e0 03          	shl    $0x3,%rax
  8001d7:	48 01 d0             	add    %rdx,%rax
  8001da:	48 c1 e0 05          	shl    $0x5,%rax
  8001de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e5:	00 00 00 
  8001e8:	48 01 c2             	add    %rax,%rdx
  8001eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001f2:	00 00 00 
  8001f5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001fc:	7e 14                	jle    800212 <libmain+0x65>
		binaryname = argv[0];
  8001fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800202:	48 8b 10             	mov    (%rax),%rdx
  800205:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80020c:	00 00 00 
  80020f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800219:	48 89 d6             	mov    %rdx,%rsi
  80021c:	89 c7                	mov    %eax,%edi
  80021e:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80022a:	48 b8 38 02 80 00 00 	movabs $0x800238,%rax
  800231:	00 00 00 
  800234:	ff d0                	callq  *%rax
}
  800236:	c9                   	leaveq 
  800237:	c3                   	retq   

0000000000800238 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800238:	55                   	push   %rbp
  800239:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80023c:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  800243:	00 00 00 
  800246:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800248:	bf 00 00 00 00       	mov    $0x0,%edi
  80024d:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  800254:	00 00 00 
  800257:	ff d0                	callq  *%rax

}
  800259:	5d                   	pop    %rbp
  80025a:	c3                   	retq   

000000000080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025b:	55                   	push   %rbp
  80025c:	48 89 e5             	mov    %rsp,%rbp
  80025f:	53                   	push   %rbx
  800260:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800267:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80026e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800274:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800282:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800289:	84 c0                	test   %al,%al
  80028b:	74 23                	je     8002b0 <_panic+0x55>
  80028d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800294:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800298:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002be:	00 00 00 
  8002c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c8:	00 00 00 
  8002cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002eb:	00 00 00 
  8002ee:	48 8b 18             	mov    (%rax),%rbx
  8002f1:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
  8002fd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800303:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80030a:	41 89 c8             	mov    %ecx,%r8d
  80030d:	48 89 d1             	mov    %rdx,%rcx
  800310:	48 89 da             	mov    %rbx,%rdx
  800313:	89 c6                	mov    %eax,%esi
  800315:	48 bf 18 40 80 00 00 	movabs $0x804018,%rdi
  80031c:	00 00 00 
  80031f:	b8 00 00 00 00       	mov    $0x0,%eax
  800324:	49 b9 94 04 80 00 00 	movabs $0x800494,%r9
  80032b:	00 00 00 
  80032e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800331:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800338:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80033f:	48 89 d6             	mov    %rdx,%rsi
  800342:	48 89 c7             	mov    %rax,%rdi
  800345:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  80034c:	00 00 00 
  80034f:	ff d0                	callq  *%rax
	cprintf("\n");
  800351:	48 bf 3b 40 80 00 00 	movabs $0x80403b,%rdi
  800358:	00 00 00 
  80035b:	b8 00 00 00 00       	mov    $0x0,%eax
  800360:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  800367:	00 00 00 
  80036a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036c:	cc                   	int3   
  80036d:	eb fd                	jmp    80036c <_panic+0x111>

000000000080036f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80036f:	55                   	push   %rbp
  800370:	48 89 e5             	mov    %rsp,%rbp
  800373:	48 83 ec 10          	sub    $0x10,%rsp
  800377:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80037e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800382:	8b 00                	mov    (%rax),%eax
  800384:	8d 48 01             	lea    0x1(%rax),%ecx
  800387:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038b:	89 0a                	mov    %ecx,(%rdx)
  80038d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800390:	89 d1                	mov    %edx,%ecx
  800392:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800396:	48 98                	cltq   
  800398:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 00                	mov    (%rax),%eax
  8003a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a7:	75 2c                	jne    8003d5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ad:	8b 00                	mov    (%rax),%eax
  8003af:	48 98                	cltq   
  8003b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b5:	48 83 c2 08          	add    $0x8,%rdx
  8003b9:	48 89 c6             	mov    %rax,%rsi
  8003bc:	48 89 d7             	mov    %rdx,%rdi
  8003bf:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
        b->idx = 0;
  8003cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d9:	8b 40 04             	mov    0x4(%rax),%eax
  8003dc:	8d 50 01             	lea    0x1(%rax),%edx
  8003df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800401:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800408:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80040f:	48 8b 0a             	mov    (%rdx),%rcx
  800412:	48 89 08             	mov    %rcx,(%rax)
  800415:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800419:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80041d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800421:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800425:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80042c:	00 00 00 
    b.cnt = 0;
  80042f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800436:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800439:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800440:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800447:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80044e:	48 89 c6             	mov    %rax,%rsi
  800451:	48 bf 6f 03 80 00 00 	movabs $0x80036f,%rdi
  800458:	00 00 00 
  80045b:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800467:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80046d:	48 98                	cltq   
  80046f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800476:	48 83 c2 08          	add    $0x8,%rdx
  80047a:	48 89 c6             	mov    %rax,%rsi
  80047d:	48 89 d7             	mov    %rdx,%rdi
  800480:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  800487:	00 00 00 
  80048a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80048c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800492:	c9                   	leaveq 
  800493:	c3                   	retq   

0000000000800494 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800494:	55                   	push   %rbp
  800495:	48 89 e5             	mov    %rsp,%rbp
  800498:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80049f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c2:	84 c0                	test   %al,%al
  8004c4:	74 20                	je     8004e6 <cprintf+0x52>
  8004c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f4:	00 00 00 
  8004f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004fe:	00 00 00 
  800501:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800505:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80050c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800513:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80051a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800521:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800528:	48 8b 0a             	mov    (%rdx),%rcx
  80052b:	48 89 08             	mov    %rcx,(%rax)
  80052e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800532:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800536:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80053a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80053e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800545:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80054c:	48 89 d6             	mov    %rdx,%rsi
  80054f:	48 89 c7             	mov    %rax,%rdi
  800552:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  800559:	00 00 00 
  80055c:	ff d0                	callq  *%rax
  80055e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800564:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80056a:	c9                   	leaveq 
  80056b:	c3                   	retq   

000000000080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %rbp
  80056d:	48 89 e5             	mov    %rsp,%rbp
  800570:	53                   	push   %rbx
  800571:	48 83 ec 38          	sub    $0x38,%rsp
  800575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80057d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800581:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800584:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800588:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80058f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800593:	77 3b                	ja     8005d0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800595:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800598:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80059c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80059f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	48 f7 f3             	div    %rbx
  8005ab:	48 89 c2             	mov    %rax,%rdx
  8005ae:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005b4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bc:	41 89 f9             	mov    %edi,%r9d
  8005bf:	48 89 c7             	mov    %rax,%rdi
  8005c2:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  8005c9:	00 00 00 
  8005cc:	ff d0                	callq  *%rax
  8005ce:	eb 1e                	jmp    8005ee <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d0:	eb 12                	jmp    8005e4 <printnum+0x78>
			putch(padc, putdat);
  8005d2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005d6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	48 89 ce             	mov    %rcx,%rsi
  8005e0:	89 d7                	mov    %edx,%edi
  8005e2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005ec:	7f e4                	jg     8005d2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	48 f7 f1             	div    %rcx
  8005fd:	48 89 d0             	mov    %rdx,%rax
  800600:	48 ba 30 42 80 00 00 	movabs $0x804230,%rdx
  800607:	00 00 00 
  80060a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80060e:	0f be d0             	movsbl %al,%edx
  800611:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	48 89 ce             	mov    %rcx,%rsi
  80061c:	89 d7                	mov    %edx,%edi
  80061e:	ff d0                	callq  *%rax
}
  800620:	48 83 c4 38          	add    $0x38,%rsp
  800624:	5b                   	pop    %rbx
  800625:	5d                   	pop    %rbp
  800626:	c3                   	retq   

0000000000800627 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80062f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800633:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800636:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063a:	7e 52                	jle    80068e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	83 f8 30             	cmp    $0x30,%eax
  800645:	73 24                	jae    80066b <getuint+0x44>
  800647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	89 c0                	mov    %eax,%eax
  800657:	48 01 d0             	add    %rdx,%rax
  80065a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065e:	8b 12                	mov    (%rdx),%edx
  800660:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800667:	89 0a                	mov    %ecx,(%rdx)
  800669:	eb 17                	jmp    800682 <getuint+0x5b>
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800673:	48 89 d0             	mov    %rdx,%rax
  800676:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800682:	48 8b 00             	mov    (%rax),%rax
  800685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800689:	e9 a3 00 00 00       	jmpq   800731 <getuint+0x10a>
	else if (lflag)
  80068e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800692:	74 4f                	je     8006e3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	8b 00                	mov    (%rax),%eax
  80069a:	83 f8 30             	cmp    $0x30,%eax
  80069d:	73 24                	jae    8006c3 <getuint+0x9c>
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	8b 00                	mov    (%rax),%eax
  8006ad:	89 c0                	mov    %eax,%eax
  8006af:	48 01 d0             	add    %rdx,%rax
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	8b 12                	mov    (%rdx),%edx
  8006b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	89 0a                	mov    %ecx,(%rdx)
  8006c1:	eb 17                	jmp    8006da <getuint+0xb3>
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cb:	48 89 d0             	mov    %rdx,%rax
  8006ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006da:	48 8b 00             	mov    (%rax),%rax
  8006dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e1:	eb 4e                	jmp    800731 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	83 f8 30             	cmp    $0x30,%eax
  8006ec:	73 24                	jae    800712 <getuint+0xeb>
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	89 c0                	mov    %eax,%eax
  8006fe:	48 01 d0             	add    %rdx,%rax
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	8b 12                	mov    (%rdx),%edx
  800707:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	89 0a                	mov    %ecx,(%rdx)
  800710:	eb 17                	jmp    800729 <getuint+0x102>
  800712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800716:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071a:	48 89 d0             	mov    %rdx,%rax
  80071d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	89 c0                	mov    %eax,%eax
  80072d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800735:	c9                   	leaveq 
  800736:	c3                   	retq   

0000000000800737 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800737:	55                   	push   %rbp
  800738:	48 89 e5             	mov    %rsp,%rbp
  80073b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80073f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800743:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800746:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80074a:	7e 52                	jle    80079e <getint+0x67>
		x=va_arg(*ap, long long);
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	8b 00                	mov    (%rax),%eax
  800752:	83 f8 30             	cmp    $0x30,%eax
  800755:	73 24                	jae    80077b <getint+0x44>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	89 c0                	mov    %eax,%eax
  800767:	48 01 d0             	add    %rdx,%rax
  80076a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076e:	8b 12                	mov    (%rdx),%edx
  800770:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	89 0a                	mov    %ecx,(%rdx)
  800779:	eb 17                	jmp    800792 <getint+0x5b>
  80077b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800783:	48 89 d0             	mov    %rdx,%rax
  800786:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800792:	48 8b 00             	mov    (%rax),%rax
  800795:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800799:	e9 a3 00 00 00       	jmpq   800841 <getint+0x10a>
	else if (lflag)
  80079e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007a2:	74 4f                	je     8007f3 <getint+0xbc>
		x=va_arg(*ap, long);
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	8b 00                	mov    (%rax),%eax
  8007aa:	83 f8 30             	cmp    $0x30,%eax
  8007ad:	73 24                	jae    8007d3 <getint+0x9c>
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	89 c0                	mov    %eax,%eax
  8007bf:	48 01 d0             	add    %rdx,%rax
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	8b 12                	mov    (%rdx),%edx
  8007c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	89 0a                	mov    %ecx,(%rdx)
  8007d1:	eb 17                	jmp    8007ea <getint+0xb3>
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007db:	48 89 d0             	mov    %rdx,%rax
  8007de:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ea:	48 8b 00             	mov    (%rax),%rax
  8007ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f1:	eb 4e                	jmp    800841 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	83 f8 30             	cmp    $0x30,%eax
  8007fc:	73 24                	jae    800822 <getint+0xeb>
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	89 c0                	mov    %eax,%eax
  80080e:	48 01 d0             	add    %rdx,%rax
  800811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800815:	8b 12                	mov    (%rdx),%edx
  800817:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	89 0a                	mov    %ecx,(%rdx)
  800820:	eb 17                	jmp    800839 <getint+0x102>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80082a:	48 89 d0             	mov    %rdx,%rax
  80082d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800835:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	48 98                	cltq   
  80083d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800845:	c9                   	leaveq 
  800846:	c3                   	retq   

0000000000800847 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800847:	55                   	push   %rbp
  800848:	48 89 e5             	mov    %rsp,%rbp
  80084b:	41 54                	push   %r12
  80084d:	53                   	push   %rbx
  80084e:	48 83 ec 60          	sub    $0x60,%rsp
  800852:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800856:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800862:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800866:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086a:	48 8b 0a             	mov    (%rdx),%rcx
  80086d:	48 89 08             	mov    %rcx,(%rax)
  800870:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800874:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800878:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800880:	eb 17                	jmp    800899 <vprintfmt+0x52>
			if (ch == '\0')
  800882:	85 db                	test   %ebx,%ebx
  800884:	0f 84 cc 04 00 00    	je     800d56 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80088a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80088e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800892:	48 89 d6             	mov    %rdx,%rsi
  800895:	89 df                	mov    %ebx,%edi
  800897:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a5:	0f b6 00             	movzbl (%rax),%eax
  8008a8:	0f b6 d8             	movzbl %al,%ebx
  8008ab:	83 fb 25             	cmp    $0x25,%ebx
  8008ae:	75 d2                	jne    800882 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dc:	0f b6 00             	movzbl (%rax),%eax
  8008df:	0f b6 d8             	movzbl %al,%ebx
  8008e2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008e5:	83 f8 55             	cmp    $0x55,%eax
  8008e8:	0f 87 34 04 00 00    	ja     800d22 <vprintfmt+0x4db>
  8008ee:	89 c0                	mov    %eax,%eax
  8008f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008f7:	00 
  8008f8:	48 b8 58 42 80 00 00 	movabs $0x804258,%rax
  8008ff:	00 00 00 
  800902:	48 01 d0             	add    %rdx,%rax
  800905:	48 8b 00             	mov    (%rax),%rax
  800908:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80090a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80090e:	eb c0                	jmp    8008d0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800910:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800914:	eb ba                	jmp    8008d0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800916:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80091d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800920:	89 d0                	mov    %edx,%eax
  800922:	c1 e0 02             	shl    $0x2,%eax
  800925:	01 d0                	add    %edx,%eax
  800927:	01 c0                	add    %eax,%eax
  800929:	01 d8                	add    %ebx,%eax
  80092b:	83 e8 30             	sub    $0x30,%eax
  80092e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800931:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093b:	83 fb 2f             	cmp    $0x2f,%ebx
  80093e:	7e 0c                	jle    80094c <vprintfmt+0x105>
  800940:	83 fb 39             	cmp    $0x39,%ebx
  800943:	7f 07                	jg     80094c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800945:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094a:	eb d1                	jmp    80091d <vprintfmt+0xd6>
			goto process_precision;
  80094c:	eb 58                	jmp    8009a6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80094e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800951:	83 f8 30             	cmp    $0x30,%eax
  800954:	73 17                	jae    80096d <vprintfmt+0x126>
  800956:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095d:	89 c0                	mov    %eax,%eax
  80095f:	48 01 d0             	add    %rdx,%rax
  800962:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800965:	83 c2 08             	add    $0x8,%edx
  800968:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096b:	eb 0f                	jmp    80097c <vprintfmt+0x135>
  80096d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800971:	48 89 d0             	mov    %rdx,%rax
  800974:	48 83 c2 08          	add    $0x8,%rdx
  800978:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097c:	8b 00                	mov    (%rax),%eax
  80097e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800981:	eb 23                	jmp    8009a6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800983:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800987:	79 0c                	jns    800995 <vprintfmt+0x14e>
				width = 0;
  800989:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800990:	e9 3b ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>
  800995:	e9 36 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80099a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a1:	e9 2a ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009aa:	79 12                	jns    8009be <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009af:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b9:	e9 12 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>
  8009be:	e9 0d ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c7:	e9 04 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cf:	83 f8 30             	cmp    $0x30,%eax
  8009d2:	73 17                	jae    8009eb <vprintfmt+0x1a4>
  8009d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 01 d0             	add    %rdx,%rax
  8009e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e3:	83 c2 08             	add    $0x8,%edx
  8009e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e9:	eb 0f                	jmp    8009fa <vprintfmt+0x1b3>
  8009eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ef:	48 89 d0             	mov    %rdx,%rax
  8009f2:	48 83 c2 08          	add    $0x8,%rdx
  8009f6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fa:	8b 10                	mov    (%rax),%edx
  8009fc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a04:	48 89 ce             	mov    %rcx,%rsi
  800a07:	89 d7                	mov    %edx,%edi
  800a09:	ff d0                	callq  *%rax
			break;
  800a0b:	e9 40 03 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 17                	jae    800a2f <vprintfmt+0x1e8>
  800a18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	89 c0                	mov    %eax,%eax
  800a21:	48 01 d0             	add    %rdx,%rax
  800a24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a27:	83 c2 08             	add    $0x8,%edx
  800a2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a2d:	eb 0f                	jmp    800a3e <vprintfmt+0x1f7>
  800a2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a33:	48 89 d0             	mov    %rdx,%rax
  800a36:	48 83 c2 08          	add    $0x8,%rdx
  800a3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a40:	85 db                	test   %ebx,%ebx
  800a42:	79 02                	jns    800a46 <vprintfmt+0x1ff>
				err = -err;
  800a44:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a46:	83 fb 15             	cmp    $0x15,%ebx
  800a49:	7f 16                	jg     800a61 <vprintfmt+0x21a>
  800a4b:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  800a52:	00 00 00 
  800a55:	48 63 d3             	movslq %ebx,%rdx
  800a58:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a5c:	4d 85 e4             	test   %r12,%r12
  800a5f:	75 2e                	jne    800a8f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a69:	89 d9                	mov    %ebx,%ecx
  800a6b:	48 ba 41 42 80 00 00 	movabs $0x804241,%rdx
  800a72:	00 00 00 
  800a75:	48 89 c7             	mov    %rax,%rdi
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	49 b8 5f 0d 80 00 00 	movabs $0x800d5f,%r8
  800a84:	00 00 00 
  800a87:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8a:	e9 c1 02 00 00       	jmpq   800d50 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	4c 89 e1             	mov    %r12,%rcx
  800a9a:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  800aa1:	00 00 00 
  800aa4:	48 89 c7             	mov    %rax,%rdi
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	49 b8 5f 0d 80 00 00 	movabs $0x800d5f,%r8
  800ab3:	00 00 00 
  800ab6:	41 ff d0             	callq  *%r8
			break;
  800ab9:	e9 92 02 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800abe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac1:	83 f8 30             	cmp    $0x30,%eax
  800ac4:	73 17                	jae    800add <vprintfmt+0x296>
  800ac6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acd:	89 c0                	mov    %eax,%eax
  800acf:	48 01 d0             	add    %rdx,%rax
  800ad2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad5:	83 c2 08             	add    $0x8,%edx
  800ad8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800adb:	eb 0f                	jmp    800aec <vprintfmt+0x2a5>
  800add:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae1:	48 89 d0             	mov    %rdx,%rax
  800ae4:	48 83 c2 08          	add    $0x8,%rdx
  800ae8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aec:	4c 8b 20             	mov    (%rax),%r12
  800aef:	4d 85 e4             	test   %r12,%r12
  800af2:	75 0a                	jne    800afe <vprintfmt+0x2b7>
				p = "(null)";
  800af4:	49 bc 4d 42 80 00 00 	movabs $0x80424d,%r12
  800afb:	00 00 00 
			if (width > 0 && padc != '-')
  800afe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b02:	7e 3f                	jle    800b43 <vprintfmt+0x2fc>
  800b04:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b08:	74 39                	je     800b43 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b0d:	48 98                	cltq   
  800b0f:	48 89 c6             	mov    %rax,%rsi
  800b12:	4c 89 e7             	mov    %r12,%rdi
  800b15:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	callq  *%rax
  800b21:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b24:	eb 17                	jmp    800b3d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b26:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b2a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b32:	48 89 ce             	mov    %rcx,%rsi
  800b35:	89 d7                	mov    %edx,%edi
  800b37:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b39:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b41:	7f e3                	jg     800b26 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b43:	eb 37                	jmp    800b7c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b49:	74 1e                	je     800b69 <vprintfmt+0x322>
  800b4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4e:	7e 05                	jle    800b55 <vprintfmt+0x30e>
  800b50:	83 fb 7e             	cmp    $0x7e,%ebx
  800b53:	7e 14                	jle    800b69 <vprintfmt+0x322>
					putch('?', putdat);
  800b55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5d:	48 89 d6             	mov    %rdx,%rsi
  800b60:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b65:	ff d0                	callq  *%rax
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b71:	48 89 d6             	mov    %rdx,%rsi
  800b74:	89 df                	mov    %ebx,%edi
  800b76:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b78:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7c:	4c 89 e0             	mov    %r12,%rax
  800b7f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b83:	0f b6 00             	movzbl (%rax),%eax
  800b86:	0f be d8             	movsbl %al,%ebx
  800b89:	85 db                	test   %ebx,%ebx
  800b8b:	74 10                	je     800b9d <vprintfmt+0x356>
  800b8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b91:	78 b2                	js     800b45 <vprintfmt+0x2fe>
  800b93:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b97:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9b:	79 a8                	jns    800b45 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba7:	48 89 d6             	mov    %rdx,%rsi
  800baa:	bf 20 00 00 00       	mov    $0x20,%edi
  800baf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bbb:	e9 90 01 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc4:	be 03 00 00 00       	mov    $0x3,%esi
  800bc9:	48 89 c7             	mov    %rax,%rdi
  800bcc:	48 b8 37 07 80 00 00 	movabs $0x800737,%rax
  800bd3:	00 00 00 
  800bd6:	ff d0                	callq  *%rax
  800bd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be0:	48 85 c0             	test   %rax,%rax
  800be3:	79 1d                	jns    800c02 <vprintfmt+0x3bb>
				putch('-', putdat);
  800be5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bed:	48 89 d6             	mov    %rdx,%rsi
  800bf0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfb:	48 f7 d8             	neg    %rax
  800bfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c09:	e9 d5 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c0e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c12:	be 03 00 00 00       	mov    $0x3,%esi
  800c17:	48 89 c7             	mov    %rax,%rdi
  800c1a:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
  800c26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c31:	e9 ad 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c36:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c39:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	48 b8 37 07 80 00 00 	movabs $0x800737,%rax
  800c49:	00 00 00 
  800c4c:	ff d0                	callq  *%rax
  800c4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c52:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c59:	e9 85 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	48 89 d6             	mov    %rdx,%rsi
  800c69:	bf 30 00 00 00       	mov    $0x30,%edi
  800c6e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c78:	48 89 d6             	mov    %rdx,%rsi
  800c7b:	bf 78 00 00 00       	mov    $0x78,%edi
  800c80:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c85:	83 f8 30             	cmp    $0x30,%eax
  800c88:	73 17                	jae    800ca1 <vprintfmt+0x45a>
  800c8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	89 c0                	mov    %eax,%eax
  800c93:	48 01 d0             	add    %rdx,%rax
  800c96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c99:	83 c2 08             	add    $0x8,%edx
  800c9c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9f:	eb 0f                	jmp    800cb0 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ca1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca5:	48 89 d0             	mov    %rdx,%rax
  800ca8:	48 83 c2 08          	add    $0x8,%rdx
  800cac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb0:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cb7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc4:	be 03 00 00 00       	mov    $0x3,%esi
  800cc9:	48 89 c7             	mov    %rax,%rdi
  800ccc:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800cd3:	00 00 00 
  800cd6:	ff d0                	callq  *%rax
  800cd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cdc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ce8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ceb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	45 89 c1             	mov    %r8d,%r9d
  800cfd:	41 89 f8             	mov    %edi,%r8d
  800d00:	48 89 c7             	mov    %rax,%rdi
  800d03:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	callq  *%rax
			break;
  800d0f:	eb 3f                	jmp    800d50 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	48 89 d6             	mov    %rdx,%rsi
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	ff d0                	callq  *%rax
			break;
  800d20:	eb 2e                	jmp    800d50 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	48 89 d6             	mov    %rdx,%rsi
  800d2d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d32:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d34:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d39:	eb 05                	jmp    800d40 <vprintfmt+0x4f9>
  800d3b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d40:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d44:	48 83 e8 01          	sub    $0x1,%rax
  800d48:	0f b6 00             	movzbl (%rax),%eax
  800d4b:	3c 25                	cmp    $0x25,%al
  800d4d:	75 ec                	jne    800d3b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d4f:	90                   	nop
		}
	}
  800d50:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d51:	e9 43 fb ff ff       	jmpq   800899 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d56:	48 83 c4 60          	add    $0x60,%rsp
  800d5a:	5b                   	pop    %rbx
  800d5b:	41 5c                	pop    %r12
  800d5d:	5d                   	pop    %rbp
  800d5e:	c3                   	retq   

0000000000800d5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5f:	55                   	push   %rbp
  800d60:	48 89 e5             	mov    %rsp,%rbp
  800d63:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d6a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d71:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8d:	84 c0                	test   %al,%al
  800d8f:	74 20                	je     800db1 <printfmt+0x52>
  800d91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800db8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dbf:	00 00 00 
  800dc2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dc9:	00 00 00 
  800dcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dd7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dde:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800de5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800df3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dfa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e01:	48 89 c7             	mov    %rax,%rdi
  800e04:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e10:	c9                   	leaveq 
  800e11:	c3                   	retq   

0000000000800e12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e12:	55                   	push   %rbp
  800e13:	48 89 e5             	mov    %rsp,%rbp
  800e16:	48 83 ec 10          	sub    $0x10,%rsp
  800e1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e25:	8b 40 10             	mov    0x10(%rax),%eax
  800e28:	8d 50 01             	lea    0x1(%rax),%edx
  800e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e36:	48 8b 10             	mov    (%rax),%rdx
  800e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e41:	48 39 c2             	cmp    %rax,%rdx
  800e44:	73 17                	jae    800e5d <sprintputch+0x4b>
		*b->buf++ = ch;
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	48 8b 00             	mov    (%rax),%rax
  800e4d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e55:	48 89 0a             	mov    %rcx,(%rdx)
  800e58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e5b:	88 10                	mov    %dl,(%rax)
}
  800e5d:	c9                   	leaveq 
  800e5e:	c3                   	retq   

0000000000800e5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e5f:	55                   	push   %rbp
  800e60:	48 89 e5             	mov    %rsp,%rbp
  800e63:	48 83 ec 50          	sub    $0x50,%rsp
  800e67:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e6b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e6e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e72:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e76:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e7a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e7e:	48 8b 0a             	mov    (%rdx),%rcx
  800e81:	48 89 08             	mov    %rcx,(%rax)
  800e84:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e88:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e8c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e90:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e98:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e9c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e9f:	48 98                	cltq   
  800ea1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ea5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea9:	48 01 d0             	add    %rdx,%rax
  800eac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eb0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eb7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ebc:	74 06                	je     800ec4 <vsnprintf+0x65>
  800ebe:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ec2:	7f 07                	jg     800ecb <vsnprintf+0x6c>
		return -E_INVAL;
  800ec4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec9:	eb 2f                	jmp    800efa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ecb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ecf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ed3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ed7:	48 89 c6             	mov    %rax,%rsi
  800eda:	48 bf 12 0e 80 00 00 	movabs $0x800e12,%rdi
  800ee1:	00 00 00 
  800ee4:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800eeb:	00 00 00 
  800eee:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ef0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ef7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800efa:	c9                   	leaveq 
  800efb:	c3                   	retq   

0000000000800efc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800efc:	55                   	push   %rbp
  800efd:	48 89 e5             	mov    %rsp,%rbp
  800f00:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f07:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f0e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f29:	84 c0                	test   %al,%al
  800f2b:	74 20                	je     800f4d <snprintf+0x51>
  800f2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f4d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f54:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f5b:	00 00 00 
  800f5e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f65:	00 00 00 
  800f68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f6c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f7a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f81:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f88:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f8f:	48 8b 0a             	mov    (%rdx),%rcx
  800f92:	48 89 08             	mov    %rcx,(%rax)
  800f95:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f99:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f9d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fa5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fac:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fb3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fb9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fc0:	48 89 c7             	mov    %rax,%rdi
  800fc3:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
  800fcf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fd5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 18          	sub    $0x18,%rsp
  800fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff0:	eb 09                	jmp    800ffb <strlen+0x1e>
		n++;
  800ff2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fff:	0f b6 00             	movzbl (%rax),%eax
  801002:	84 c0                	test   %al,%al
  801004:	75 ec                	jne    800ff2 <strlen+0x15>
		n++;
	return n;
  801006:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 20          	sub    $0x20,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801022:	eb 0e                	jmp    801032 <strnlen+0x27>
		n++;
  801024:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801028:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801032:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801037:	74 0b                	je     801044 <strnlen+0x39>
  801039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103d:	0f b6 00             	movzbl (%rax),%eax
  801040:	84 c0                	test   %al,%al
  801042:	75 e0                	jne    801024 <strnlen+0x19>
		n++;
	return n;
  801044:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801047:	c9                   	leaveq 
  801048:	c3                   	retq   

0000000000801049 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801049:	55                   	push   %rbp
  80104a:	48 89 e5             	mov    %rsp,%rbp
  80104d:	48 83 ec 20          	sub    $0x20,%rsp
  801051:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801055:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801061:	90                   	nop
  801062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801066:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80106a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80106e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801072:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801076:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80107a:	0f b6 12             	movzbl (%rdx),%edx
  80107d:	88 10                	mov    %dl,(%rax)
  80107f:	0f b6 00             	movzbl (%rax),%eax
  801082:	84 c0                	test   %al,%al
  801084:	75 dc                	jne    801062 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80108a:	c9                   	leaveq 
  80108b:	c3                   	retq   

000000000080108c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80108c:	55                   	push   %rbp
  80108d:	48 89 e5             	mov    %rsp,%rbp
  801090:	48 83 ec 20          	sub    $0x20,%rsp
  801094:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801098:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	48 89 c7             	mov    %rax,%rdi
  8010a3:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  8010aa:	00 00 00 
  8010ad:	ff d0                	callq  *%rax
  8010af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b5:	48 63 d0             	movslq %eax,%rdx
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	48 01 c2             	add    %rax,%rdx
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	48 89 c6             	mov    %rax,%rsi
  8010c6:	48 89 d7             	mov    %rdx,%rdi
  8010c9:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
	return dst;
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010d9:	c9                   	leaveq 
  8010da:	c3                   	retq   

00000000008010db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	48 83 ec 28          	sub    $0x28,%rsp
  8010e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010fe:	00 
  8010ff:	eb 2a                	jmp    80112b <strncpy+0x50>
		*dst++ = *src;
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801109:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801111:	0f b6 12             	movzbl (%rdx),%edx
  801114:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	74 05                	je     801126 <strncpy+0x4b>
			src++;
  801121:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801126:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801133:	72 cc                	jb     801101 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 28          	sub    $0x28,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80114f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801153:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801157:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115c:	74 3d                	je     80119b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80115e:	eb 1d                	jmp    80117d <strlcpy+0x42>
			*dst++ = *src++;
  801160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801164:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801168:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801170:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801174:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801178:	0f b6 12             	movzbl (%rdx),%edx
  80117b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80117d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801182:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801187:	74 0b                	je     801194 <strlcpy+0x59>
  801189:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118d:	0f b6 00             	movzbl (%rax),%eax
  801190:	84 c0                	test   %al,%al
  801192:	75 cc                	jne    801160 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80119b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	48 29 c2             	sub    %rax,%rdx
  8011a6:	48 89 d0             	mov    %rdx,%rax
}
  8011a9:	c9                   	leaveq 
  8011aa:	c3                   	retq   

00000000008011ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011ab:	55                   	push   %rbp
  8011ac:	48 89 e5             	mov    %rsp,%rbp
  8011af:	48 83 ec 10          	sub    $0x10,%rsp
  8011b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011bb:	eb 0a                	jmp    8011c7 <strcmp+0x1c>
		p++, q++;
  8011bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	84 c0                	test   %al,%al
  8011d0:	74 12                	je     8011e4 <strcmp+0x39>
  8011d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d6:	0f b6 10             	movzbl (%rax),%edx
  8011d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	38 c2                	cmp    %al,%dl
  8011e2:	74 d9                	je     8011bd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	0f b6 d0             	movzbl %al,%edx
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	0f b6 00             	movzbl (%rax),%eax
  8011f5:	0f b6 c0             	movzbl %al,%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 18          	sub    $0x18,%rsp
  801206:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80120e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801212:	eb 0f                	jmp    801223 <strncmp+0x25>
		n--, p++, q++;
  801214:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801223:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801228:	74 1d                	je     801247 <strncmp+0x49>
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	74 12                	je     801247 <strncmp+0x49>
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	0f b6 10             	movzbl (%rax),%edx
  80123c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	38 c2                	cmp    %al,%dl
  801245:	74 cd                	je     801214 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801247:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124c:	75 07                	jne    801255 <strncmp+0x57>
		return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 18                	jmp    80126d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	0f b6 d0             	movzbl %al,%edx
  80125f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801263:	0f b6 00             	movzbl (%rax),%eax
  801266:	0f b6 c0             	movzbl %al,%eax
  801269:	29 c2                	sub    %eax,%edx
  80126b:	89 d0                	mov    %edx,%eax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 0c          	sub    $0xc,%rsp
  801277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127b:	89 f0                	mov    %esi,%eax
  80127d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801280:	eb 17                	jmp    801299 <strchr+0x2a>
		if (*s == c)
  801282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801286:	0f b6 00             	movzbl (%rax),%eax
  801289:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80128c:	75 06                	jne    801294 <strchr+0x25>
			return (char *) s;
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	eb 15                	jmp    8012a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801294:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	84 c0                	test   %al,%al
  8012a2:	75 de                	jne    801282 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b7:	89 f0                	mov    %esi,%eax
  8012b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012bc:	eb 13                	jmp    8012d1 <strfind+0x26>
		if (*s == c)
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c8:	75 02                	jne    8012cc <strfind+0x21>
			break;
  8012ca:	eb 10                	jmp    8012dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 e2                	jne    8012be <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 18          	sub    $0x18,%rsp
  8012ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fa:	75 06                	jne    801302 <memset+0x20>
		return v;
  8012fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801300:	eb 69                	jmp    80136b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	83 e0 03             	and    $0x3,%eax
  801309:	48 85 c0             	test   %rax,%rax
  80130c:	75 48                	jne    801356 <memset+0x74>
  80130e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	48 85 c0             	test   %rax,%rax
  801318:	75 3c                	jne    801356 <memset+0x74>
		c &= 0xFF;
  80131a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801321:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801324:	c1 e0 18             	shl    $0x18,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 10             	shl    $0x10,%eax
  80132f:	09 c2                	or     %eax,%edx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	c1 e0 08             	shl    $0x8,%eax
  801337:	09 d0                	or     %edx,%eax
  801339:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	48 c1 e8 02          	shr    $0x2,%rax
  801344:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134e:	48 89 d7             	mov    %rdx,%rdi
  801351:	fc                   	cld    
  801352:	f3 ab                	rep stos %eax,%es:(%rdi)
  801354:	eb 11                	jmp    801367 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801356:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801361:	48 89 d7             	mov    %rdx,%rdi
  801364:	fc                   	cld    
  801365:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 28          	sub    $0x28,%rsp
  801375:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801379:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801385:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801399:	0f 83 88 00 00 00    	jae    801427 <memmove+0xba>
  80139f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a7:	48 01 d0             	add    %rdx,%rax
  8013aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ae:	76 77                	jbe    801427 <memmove+0xba>
		s += n;
  8013b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c4:	83 e0 03             	and    $0x3,%eax
  8013c7:	48 85 c0             	test   %rax,%rax
  8013ca:	75 3b                	jne    801407 <memmove+0x9a>
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	83 e0 03             	and    $0x3,%eax
  8013d3:	48 85 c0             	test   %rax,%rax
  8013d6:	75 2f                	jne    801407 <memmove+0x9a>
  8013d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dc:	83 e0 03             	and    $0x3,%eax
  8013df:	48 85 c0             	test   %rax,%rax
  8013e2:	75 23                	jne    801407 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e8:	48 83 e8 04          	sub    $0x4,%rax
  8013ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f0:	48 83 ea 04          	sub    $0x4,%rdx
  8013f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013fc:	48 89 c7             	mov    %rax,%rdi
  8013ff:	48 89 d6             	mov    %rdx,%rsi
  801402:	fd                   	std    
  801403:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801405:	eb 1d                	jmp    801424 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80140f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801413:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	48 89 d7             	mov    %rdx,%rdi
  80141e:	48 89 c1             	mov    %rax,%rcx
  801421:	fd                   	std    
  801422:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801424:	fc                   	cld    
  801425:	eb 57                	jmp    80147e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	83 e0 03             	and    $0x3,%eax
  80142e:	48 85 c0             	test   %rax,%rax
  801431:	75 36                	jne    801469 <memmove+0xfc>
  801433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801437:	83 e0 03             	and    $0x3,%eax
  80143a:	48 85 c0             	test   %rax,%rax
  80143d:	75 2a                	jne    801469 <memmove+0xfc>
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	83 e0 03             	and    $0x3,%eax
  801446:	48 85 c0             	test   %rax,%rax
  801449:	75 1e                	jne    801469 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	48 c1 e8 02          	shr    $0x2,%rax
  801453:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145e:	48 89 c7             	mov    %rax,%rdi
  801461:	48 89 d6             	mov    %rdx,%rsi
  801464:	fc                   	cld    
  801465:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801467:	eb 15                	jmp    80147e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801471:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801475:	48 89 c7             	mov    %rax,%rdi
  801478:	48 89 d6             	mov    %rdx,%rsi
  80147b:	fc                   	cld    
  80147c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80147e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801482:	c9                   	leaveq 
  801483:	c3                   	retq   

0000000000801484 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801484:	55                   	push   %rbp
  801485:	48 89 e5             	mov    %rsp,%rbp
  801488:	48 83 ec 18          	sub    $0x18,%rsp
  80148c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801494:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801498:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80149c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a4:	48 89 ce             	mov    %rcx,%rsi
  8014a7:	48 89 c7             	mov    %rax,%rdi
  8014aa:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8014b1:	00 00 00 
  8014b4:	ff d0                	callq  *%rax
}
  8014b6:	c9                   	leaveq 
  8014b7:	c3                   	retq   

00000000008014b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014b8:	55                   	push   %rbp
  8014b9:	48 89 e5             	mov    %rsp,%rbp
  8014bc:	48 83 ec 28          	sub    $0x28,%rsp
  8014c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014dc:	eb 36                	jmp    801514 <memcmp+0x5c>
		if (*s1 != *s2)
  8014de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e2:	0f b6 10             	movzbl (%rax),%edx
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	38 c2                	cmp    %al,%dl
  8014ee:	74 1a                	je     80150a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	0f b6 d0             	movzbl %al,%edx
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	0f b6 c0             	movzbl %al,%eax
  801504:	29 c2                	sub    %eax,%edx
  801506:	89 d0                	mov    %edx,%eax
  801508:	eb 20                	jmp    80152a <memcmp+0x72>
		s1++, s2++;
  80150a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80151c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801520:	48 85 c0             	test   %rax,%rax
  801523:	75 b9                	jne    8014de <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 28          	sub    $0x28,%rsp
  801534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801538:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80153b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801547:	48 01 d0             	add    %rdx,%rax
  80154a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80154e:	eb 15                	jmp    801565 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	0f b6 10             	movzbl (%rax),%edx
  801557:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80155a:	38 c2                	cmp    %al,%dl
  80155c:	75 02                	jne    801560 <memfind+0x34>
			break;
  80155e:	eb 0f                	jmp    80156f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801560:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801569:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80156d:	72 e1                	jb     801550 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80156f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801573:	c9                   	leaveq 
  801574:	c3                   	retq   

0000000000801575 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801575:	55                   	push   %rbp
  801576:	48 89 e5             	mov    %rsp,%rbp
  801579:	48 83 ec 34          	sub    $0x34,%rsp
  80157d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801581:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801585:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801588:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80158f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801596:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801597:	eb 05                	jmp    80159e <strtol+0x29>
		s++;
  801599:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a2:	0f b6 00             	movzbl (%rax),%eax
  8015a5:	3c 20                	cmp    $0x20,%al
  8015a7:	74 f0                	je     801599 <strtol+0x24>
  8015a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ad:	0f b6 00             	movzbl (%rax),%eax
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 e5                	je     801599 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	3c 2b                	cmp    $0x2b,%al
  8015bd:	75 07                	jne    8015c6 <strtol+0x51>
		s++;
  8015bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c4:	eb 17                	jmp    8015dd <strtol+0x68>
	else if (*s == '-')
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	3c 2d                	cmp    $0x2d,%al
  8015cf:	75 0c                	jne    8015dd <strtol+0x68>
		s++, neg = 1;
  8015d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e1:	74 06                	je     8015e9 <strtol+0x74>
  8015e3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e7:	75 28                	jne    801611 <strtol+0x9c>
  8015e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	3c 30                	cmp    $0x30,%al
  8015f2:	75 1d                	jne    801611 <strtol+0x9c>
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 83 c0 01          	add    $0x1,%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3c 78                	cmp    $0x78,%al
  801601:	75 0e                	jne    801611 <strtol+0x9c>
		s += 2, base = 16;
  801603:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801608:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80160f:	eb 2c                	jmp    80163d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801611:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801615:	75 19                	jne    801630 <strtol+0xbb>
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	3c 30                	cmp    $0x30,%al
  801620:	75 0e                	jne    801630 <strtol+0xbb>
		s++, base = 8;
  801622:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801627:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80162e:	eb 0d                	jmp    80163d <strtol+0xc8>
	else if (base == 0)
  801630:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801634:	75 07                	jne    80163d <strtol+0xc8>
		base = 10;
  801636:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 2f                	cmp    $0x2f,%al
  801646:	7e 1d                	jle    801665 <strtol+0xf0>
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 39                	cmp    $0x39,%al
  801651:	7f 12                	jg     801665 <strtol+0xf0>
			dig = *s - '0';
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 e8 30             	sub    $0x30,%eax
  801660:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801663:	eb 4e                	jmp    8016b3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	3c 60                	cmp    $0x60,%al
  80166e:	7e 1d                	jle    80168d <strtol+0x118>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 7a                	cmp    $0x7a,%al
  801679:	7f 12                	jg     80168d <strtol+0x118>
			dig = *s - 'a' + 10;
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	0f be c0             	movsbl %al,%eax
  801685:	83 e8 57             	sub    $0x57,%eax
  801688:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168b:	eb 26                	jmp    8016b3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 40                	cmp    $0x40,%al
  801696:	7e 48                	jle    8016e0 <strtol+0x16b>
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 5a                	cmp    $0x5a,%al
  8016a1:	7f 3d                	jg     8016e0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f be c0             	movsbl %al,%eax
  8016ad:	83 e8 37             	sub    $0x37,%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b9:	7c 02                	jl     8016bd <strtol+0x148>
			break;
  8016bb:	eb 23                	jmp    8016e0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016c5:	48 98                	cltq   
  8016c7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016cc:	48 89 c2             	mov    %rax,%rdx
  8016cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d2:	48 98                	cltq   
  8016d4:	48 01 d0             	add    %rdx,%rax
  8016d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016db:	e9 5d ff ff ff       	jmpq   80163d <strtol+0xc8>

	if (endptr)
  8016e0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016e5:	74 0b                	je     8016f2 <strtol+0x17d>
		*endptr = (char *) s;
  8016e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ef:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f6:	74 09                	je     801701 <strtol+0x18c>
  8016f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fc:	48 f7 d8             	neg    %rax
  8016ff:	eb 04                	jmp    801705 <strtol+0x190>
  801701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801705:	c9                   	leaveq 
  801706:	c3                   	retq   

0000000000801707 <strstr>:

char * strstr(const char *in, const char *str)
{
  801707:	55                   	push   %rbp
  801708:	48 89 e5             	mov    %rsp,%rbp
  80170b:	48 83 ec 30          	sub    $0x30,%rsp
  80170f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801713:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801717:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80171f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801723:	0f b6 00             	movzbl (%rax),%eax
  801726:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801729:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80172d:	75 06                	jne    801735 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80172f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801733:	eb 6b                	jmp    8017a0 <strstr+0x99>

	len = strlen(str);
  801735:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801739:	48 89 c7             	mov    %rax,%rdi
  80173c:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  801743:	00 00 00 
  801746:	ff d0                	callq  *%rax
  801748:	48 98                	cltq   
  80174a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801760:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801764:	75 07                	jne    80176d <strstr+0x66>
				return (char *) 0;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 33                	jmp    8017a0 <strstr+0x99>
		} while (sc != c);
  80176d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801771:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801774:	75 d8                	jne    80174e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801776:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	48 89 ce             	mov    %rcx,%rsi
  801785:	48 89 c7             	mov    %rax,%rdi
  801788:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  80178f:	00 00 00 
  801792:	ff d0                	callq  *%rax
  801794:	85 c0                	test   %eax,%eax
  801796:	75 b6                	jne    80174e <strstr+0x47>

	return (char *) (in - 1);
  801798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179c:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a0:	c9                   	leaveq 
  8017a1:	c3                   	retq   

00000000008017a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017a2:	55                   	push   %rbp
  8017a3:	48 89 e5             	mov    %rsp,%rbp
  8017a6:	53                   	push   %rbx
  8017a7:	48 83 ec 48          	sub    $0x48,%rsp
  8017ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017bd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017c4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017cc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017d4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d8:	4c 89 c3             	mov    %r8,%rbx
  8017db:	cd 30                	int    $0x30
  8017dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017e5:	74 3e                	je     801825 <syscall+0x83>
  8017e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ec:	7e 37                	jle    801825 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f5:	49 89 d0             	mov    %rdx,%r8
  8017f8:	89 c1                	mov    %eax,%ecx
  8017fa:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  801801:	00 00 00 
  801804:	be 23 00 00 00       	mov    $0x23,%esi
  801809:	48 bf 25 45 80 00 00 	movabs $0x804525,%rdi
  801810:	00 00 00 
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	49 b9 5b 02 80 00 00 	movabs $0x80025b,%r9
  80181f:	00 00 00 
  801822:	41 ff d1             	callq  *%r9

	return ret;
  801825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801829:	48 83 c4 48          	add    $0x48,%rsp
  80182d:	5b                   	pop    %rbx
  80182e:	5d                   	pop    %rbp
  80182f:	c3                   	retq   

0000000000801830 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 20          	sub    $0x20,%rsp
  801838:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80183c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801848:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184f:	00 
  801850:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801856:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185c:	48 89 d1             	mov    %rdx,%rcx
  80185f:	48 89 c2             	mov    %rax,%rdx
  801862:	be 00 00 00 00       	mov    $0x0,%esi
  801867:	bf 00 00 00 00       	mov    $0x0,%edi
  80186c:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
}
  801878:	c9                   	leaveq 
  801879:	c3                   	retq   

000000000080187a <sys_cgetc>:

int
sys_cgetc(void)
{
  80187a:	55                   	push   %rbp
  80187b:	48 89 e5             	mov    %rsp,%rbp
  80187e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801882:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801889:	00 
  80188a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801890:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801896:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	be 00 00 00 00       	mov    $0x0,%esi
  8018a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8018aa:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
}
  8018b6:	c9                   	leaveq 
  8018b7:	c3                   	retq   

00000000008018b8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 10          	sub    $0x10,%rsp
  8018c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c6:	48 98                	cltq   
  8018c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cf:	00 
  8018d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e1:	48 89 c2             	mov    %rax,%rdx
  8018e4:	be 01 00 00 00       	mov    $0x1,%esi
  8018e9:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ee:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	callq  *%rax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801904:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190b:	00 
  80190c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801912:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	be 00 00 00 00       	mov    $0x0,%esi
  801927:	bf 02 00 00 00       	mov    $0x2,%edi
  80192c:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
}
  801938:	c9                   	leaveq 
  801939:	c3                   	retq   

000000000080193a <sys_yield>:

void
sys_yield(void)
{
  80193a:	55                   	push   %rbp
  80193b:	48 89 e5             	mov    %rsp,%rbp
  80193e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801956:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	be 00 00 00 00       	mov    $0x0,%esi
  801965:	bf 0b 00 00 00       	mov    $0xb,%edi
  80196a:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801987:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80198a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80198d:	48 63 c8             	movslq %eax,%rcx
  801990:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801997:	48 98                	cltq   
  801999:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a0:	00 
  8019a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a7:	49 89 c8             	mov    %rcx,%r8
  8019aa:	48 89 d1             	mov    %rdx,%rcx
  8019ad:	48 89 c2             	mov    %rax,%rdx
  8019b0:	be 01 00 00 00       	mov    $0x1,%esi
  8019b5:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ba:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8019c1:	00 00 00 
  8019c4:	ff d0                	callq  *%rax
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 30          	sub    $0x30,%rsp
  8019d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019da:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019de:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019e2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e5:	48 63 c8             	movslq %eax,%rcx
  8019e8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ef:	48 63 f0             	movslq %eax,%rsi
  8019f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f9:	48 98                	cltq   
  8019fb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019ff:	49 89 f9             	mov    %rdi,%r9
  801a02:	49 89 f0             	mov    %rsi,%r8
  801a05:	48 89 d1             	mov    %rdx,%rcx
  801a08:	48 89 c2             	mov    %rax,%rdx
  801a0b:	be 01 00 00 00       	mov    $0x1,%esi
  801a10:	bf 05 00 00 00       	mov    $0x5,%edi
  801a15:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
}
  801a21:	c9                   	leaveq 
  801a22:	c3                   	retq   

0000000000801a23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a23:	55                   	push   %rbp
  801a24:	48 89 e5             	mov    %rsp,%rbp
  801a27:	48 83 ec 20          	sub    $0x20,%rsp
  801a2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a39:	48 98                	cltq   
  801a3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a42:	00 
  801a43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4f:	48 89 d1             	mov    %rdx,%rcx
  801a52:	48 89 c2             	mov    %rax,%rdx
  801a55:	be 01 00 00 00       	mov    $0x1,%esi
  801a5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a5f:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801a66:	00 00 00 
  801a69:	ff d0                	callq  *%rax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 10          	sub    $0x10,%rsp
  801a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7e:	48 63 d0             	movslq %eax,%rdx
  801a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	48 89 d1             	mov    %rdx,%rcx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 01 00 00 00       	mov    $0x1,%esi
  801aa5:	bf 08 00 00 00       	mov    $0x8,%edi
  801aaa:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ac7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ace:	48 98                	cltq   
  801ad0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad7:	00 
  801ad8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ade:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae4:	48 89 d1             	mov    %rdx,%rcx
  801ae7:	48 89 c2             	mov    %rax,%rdx
  801aea:	be 01 00 00 00       	mov    $0x1,%esi
  801aef:	bf 09 00 00 00       	mov    $0x9,%edi
  801af4:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	callq  *%rax
}
  801b00:	c9                   	leaveq 
  801b01:	c3                   	retq   

0000000000801b02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	48 83 ec 20          	sub    $0x20,%rsp
  801b0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b21:	00 
  801b22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 01 00 00 00       	mov    $0x1,%esi
  801b39:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b3e:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b5f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b65:	48 63 f0             	movslq %eax,%rsi
  801b68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6f:	48 98                	cltq   
  801b71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7c:	00 
  801b7d:	49 89 f1             	mov    %rsi,%r9
  801b80:	49 89 c8             	mov    %rcx,%r8
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 00 00 00 00       	mov    $0x0,%esi
  801b8e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b93:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
  801ba9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bca:	48 89 c2             	mov    %rax,%rdx
  801bcd:	be 01 00 00 00       	mov    $0x1,%esi
  801bd2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bd7:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 20          	sub    $0x20,%rsp
  801bed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c04:	00 
  801c05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c11:	48 89 d1             	mov    %rdx,%rcx
  801c14:	48 89 c2             	mov    %rax,%rdx
  801c17:	be 01 00 00 00       	mov    $0x1,%esi
  801c1c:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c21:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 10          	sub    $0x10,%rsp
  801c37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c46:	00 
  801c47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c58:	48 89 c2             	mov    %rax,%rdx
  801c5b:	be 00 00 00 00       	mov    $0x0,%esi
  801c60:	bf 10 00 00 00       	mov    $0x10,%edi
  801c65:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	callq  *%rax
}
  801c71:	c9                   	leaveq 
  801c72:	c3                   	retq   

0000000000801c73 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c73:	55                   	push   %rbp
  801c74:	48 89 e5             	mov    %rsp,%rbp
  801c77:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c82:	00 
  801c83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
  801c99:	be 00 00 00 00       	mov    $0x0,%esi
  801c9e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ca3:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
}
  801caf:	c9                   	leaveq 
  801cb0:	c3                   	retq   

0000000000801cb1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cb1:	55                   	push   %rbp
  801cb2:	48 89 e5             	mov    %rsp,%rbp
  801cb5:	48 83 ec 08          	sub    $0x8,%rsp
  801cb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cbd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cc1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cc8:	ff ff ff 
  801ccb:	48 01 d0             	add    %rdx,%rax
  801cce:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 08          	sub    $0x8,%rsp
  801cdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ce0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce4:	48 89 c7             	mov    %rax,%rdi
  801ce7:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  801cee:	00 00 00 
  801cf1:	ff d0                	callq  *%rax
  801cf3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cf9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cfd:	c9                   	leaveq 
  801cfe:	c3                   	retq   

0000000000801cff <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	48 83 ec 18          	sub    $0x18,%rsp
  801d07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d12:	eb 6b                	jmp    801d7f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d17:	48 98                	cltq   
  801d19:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d1f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d23:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2b:	48 c1 e8 15          	shr    $0x15,%rax
  801d2f:	48 89 c2             	mov    %rax,%rdx
  801d32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d39:	01 00 00 
  801d3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d40:	83 e0 01             	and    $0x1,%eax
  801d43:	48 85 c0             	test   %rax,%rax
  801d46:	74 21                	je     801d69 <fd_alloc+0x6a>
  801d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d50:	48 89 c2             	mov    %rax,%rdx
  801d53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5a:	01 00 00 
  801d5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d61:	83 e0 01             	and    $0x1,%eax
  801d64:	48 85 c0             	test   %rax,%rax
  801d67:	75 12                	jne    801d7b <fd_alloc+0x7c>
			*fd_store = fd;
  801d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d71:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
  801d79:	eb 1a                	jmp    801d95 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d7b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d7f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d83:	7e 8f                	jle    801d14 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d89:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d90:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d95:	c9                   	leaveq 
  801d96:	c3                   	retq   

0000000000801d97 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
  801d9b:	48 83 ec 20          	sub    $0x20,%rsp
  801d9f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801da6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801daa:	78 06                	js     801db2 <fd_lookup+0x1b>
  801dac:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801db0:	7e 07                	jle    801db9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801db2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db7:	eb 6c                	jmp    801e25 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801db9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dbc:	48 98                	cltq   
  801dbe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dc4:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd0:	48 c1 e8 15          	shr    $0x15,%rax
  801dd4:	48 89 c2             	mov    %rax,%rdx
  801dd7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dde:	01 00 00 
  801de1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de5:	83 e0 01             	and    $0x1,%eax
  801de8:	48 85 c0             	test   %rax,%rax
  801deb:	74 21                	je     801e0e <fd_lookup+0x77>
  801ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df1:	48 c1 e8 0c          	shr    $0xc,%rax
  801df5:	48 89 c2             	mov    %rax,%rdx
  801df8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dff:	01 00 00 
  801e02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e06:	83 e0 01             	and    $0x1,%eax
  801e09:	48 85 c0             	test   %rax,%rax
  801e0c:	75 07                	jne    801e15 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e13:	eb 10                	jmp    801e25 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e25:	c9                   	leaveq 
  801e26:	c3                   	retq   

0000000000801e27 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
  801e2b:	48 83 ec 30          	sub    $0x30,%rsp
  801e2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3c:	48 89 c7             	mov    %rax,%rdi
  801e3f:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	callq  *%rax
  801e4b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e4f:	48 89 d6             	mov    %rdx,%rsi
  801e52:	89 c7                	mov    %eax,%edi
  801e54:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  801e5b:	00 00 00 
  801e5e:	ff d0                	callq  *%rax
  801e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e67:	78 0a                	js     801e73 <fd_close+0x4c>
	    || fd != fd2)
  801e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e71:	74 12                	je     801e85 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e73:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e77:	74 05                	je     801e7e <fd_close+0x57>
  801e79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7c:	eb 05                	jmp    801e83 <fd_close+0x5c>
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e83:	eb 69                	jmp    801eee <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e89:	8b 00                	mov    (%rax),%eax
  801e8b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e8f:	48 89 d6             	mov    %rdx,%rsi
  801e92:	89 c7                	mov    %eax,%edi
  801e94:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	callq  *%rax
  801ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea7:	78 2a                	js     801ed3 <fd_close+0xac>
		if (dev->dev_close)
  801ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ead:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eb1:	48 85 c0             	test   %rax,%rax
  801eb4:	74 16                	je     801ecc <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eba:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ebe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ec2:	48 89 d7             	mov    %rdx,%rdi
  801ec5:	ff d0                	callq  *%rax
  801ec7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eca:	eb 07                	jmp    801ed3 <fd_close+0xac>
		else
			r = 0;
  801ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ed3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed7:	48 89 c6             	mov    %rax,%rsi
  801eda:	bf 00 00 00 00       	mov    $0x0,%edi
  801edf:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	callq  *%rax
	return r;
  801eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801eee:	c9                   	leaveq 
  801eef:	c3                   	retq   

0000000000801ef0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ef0:	55                   	push   %rbp
  801ef1:	48 89 e5             	mov    %rsp,%rbp
  801ef4:	48 83 ec 20          	sub    $0x20,%rsp
  801ef8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801efb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f06:	eb 41                	jmp    801f49 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f08:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f0f:	00 00 00 
  801f12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f15:	48 63 d2             	movslq %edx,%rdx
  801f18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1c:	8b 00                	mov    (%rax),%eax
  801f1e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f21:	75 22                	jne    801f45 <dev_lookup+0x55>
			*dev = devtab[i];
  801f23:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f2a:	00 00 00 
  801f2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f30:	48 63 d2             	movslq %edx,%rdx
  801f33:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	eb 60                	jmp    801fa5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f49:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f50:	00 00 00 
  801f53:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f56:	48 63 d2             	movslq %edx,%rdx
  801f59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5d:	48 85 c0             	test   %rax,%rax
  801f60:	75 a6                	jne    801f08 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f62:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f69:	00 00 00 
  801f6c:	48 8b 00             	mov    (%rax),%rax
  801f6f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f75:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f78:	89 c6                	mov    %eax,%esi
  801f7a:	48 bf 38 45 80 00 00 	movabs $0x804538,%rdi
  801f81:	00 00 00 
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  801f90:	00 00 00 
  801f93:	ff d1                	callq  *%rcx
	*dev = 0;
  801f95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f99:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fa0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <close>:

int
close(int fdnum)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 20          	sub    $0x20,%rsp
  801faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb9:	48 89 d6             	mov    %rdx,%rsi
  801fbc:	89 c7                	mov    %eax,%edi
  801fbe:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	callq  *%rax
  801fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd1:	79 05                	jns    801fd8 <close+0x31>
		return r;
  801fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd6:	eb 18                	jmp    801ff0 <close+0x49>
	else
		return fd_close(fd, 1);
  801fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdc:	be 01 00 00 00       	mov    $0x1,%esi
  801fe1:	48 89 c7             	mov    %rax,%rdi
  801fe4:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
}
  801ff0:	c9                   	leaveq 
  801ff1:	c3                   	retq   

0000000000801ff2 <close_all>:

void
close_all(void)
{
  801ff2:	55                   	push   %rbp
  801ff3:	48 89 e5             	mov    %rsp,%rbp
  801ff6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802001:	eb 15                	jmp    802018 <close_all+0x26>
		close(i);
  802003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802006:	89 c7                	mov    %eax,%edi
  802008:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802014:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802018:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80201c:	7e e5                	jle    802003 <close_all+0x11>
		close(i);
}
  80201e:	c9                   	leaveq 
  80201f:	c3                   	retq   

0000000000802020 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802020:	55                   	push   %rbp
  802021:	48 89 e5             	mov    %rsp,%rbp
  802024:	48 83 ec 40          	sub    $0x40,%rsp
  802028:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80202b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80202e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802032:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802035:	48 89 d6             	mov    %rdx,%rsi
  802038:	89 c7                	mov    %eax,%edi
  80203a:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204d:	79 08                	jns    802057 <dup+0x37>
		return r;
  80204f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802052:	e9 70 01 00 00       	jmpq   8021c7 <dup+0x1a7>
	close(newfdnum);
  802057:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80205a:	89 c7                	mov    %eax,%edi
  80205c:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802068:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80206b:	48 98                	cltq   
  80206d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802073:	48 c1 e0 0c          	shl    $0xc,%rax
  802077:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80207b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207f:	48 89 c7             	mov    %rax,%rdi
  802082:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802096:	48 89 c7             	mov    %rax,%rdi
  802099:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax
  8020a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ad:	48 c1 e8 15          	shr    $0x15,%rax
  8020b1:	48 89 c2             	mov    %rax,%rdx
  8020b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020bb:	01 00 00 
  8020be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c2:	83 e0 01             	and    $0x1,%eax
  8020c5:	48 85 c0             	test   %rax,%rax
  8020c8:	74 73                	je     80213d <dup+0x11d>
  8020ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d2:	48 89 c2             	mov    %rax,%rdx
  8020d5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020dc:	01 00 00 
  8020df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e3:	83 e0 01             	and    $0x1,%eax
  8020e6:	48 85 c0             	test   %rax,%rax
  8020e9:	74 52                	je     80213d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8020f3:	48 89 c2             	mov    %rax,%rdx
  8020f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020fd:	01 00 00 
  802100:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802104:	25 07 0e 00 00       	and    $0xe07,%eax
  802109:	89 c1                	mov    %eax,%ecx
  80210b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	41 89 c8             	mov    %ecx,%r8d
  802116:	48 89 d1             	mov    %rdx,%rcx
  802119:	ba 00 00 00 00       	mov    $0x0,%edx
  80211e:	48 89 c6             	mov    %rax,%rsi
  802121:	bf 00 00 00 00       	mov    $0x0,%edi
  802126:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  80212d:	00 00 00 
  802130:	ff d0                	callq  *%rax
  802132:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802135:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802139:	79 02                	jns    80213d <dup+0x11d>
			goto err;
  80213b:	eb 57                	jmp    802194 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80213d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802141:	48 c1 e8 0c          	shr    $0xc,%rax
  802145:	48 89 c2             	mov    %rax,%rdx
  802148:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80214f:	01 00 00 
  802152:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802156:	25 07 0e 00 00       	and    $0xe07,%eax
  80215b:	89 c1                	mov    %eax,%ecx
  80215d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802161:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802165:	41 89 c8             	mov    %ecx,%r8d
  802168:	48 89 d1             	mov    %rdx,%rcx
  80216b:	ba 00 00 00 00       	mov    $0x0,%edx
  802170:	48 89 c6             	mov    %rax,%rsi
  802173:	bf 00 00 00 00       	mov    $0x0,%edi
  802178:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  80217f:	00 00 00 
  802182:	ff d0                	callq  *%rax
  802184:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218b:	79 02                	jns    80218f <dup+0x16f>
		goto err;
  80218d:	eb 05                	jmp    802194 <dup+0x174>

	return newfdnum;
  80218f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802192:	eb 33                	jmp    8021c7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802198:	48 89 c6             	mov    %rax,%rsi
  80219b:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a0:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8021a7:	00 00 00 
  8021aa:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b0:	48 89 c6             	mov    %rax,%rsi
  8021b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b8:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8021bf:	00 00 00 
  8021c2:	ff d0                	callq  *%rax
	return r;
  8021c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c7:	c9                   	leaveq 
  8021c8:	c3                   	retq   

00000000008021c9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021c9:	55                   	push   %rbp
  8021ca:	48 89 e5             	mov    %rsp,%rbp
  8021cd:	48 83 ec 40          	sub    $0x40,%rsp
  8021d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021e3:	48 89 d6             	mov    %rdx,%rsi
  8021e6:	89 c7                	mov    %eax,%edi
  8021e8:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
  8021f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fb:	78 24                	js     802221 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802201:	8b 00                	mov    (%rax),%eax
  802203:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802207:	48 89 d6             	mov    %rdx,%rsi
  80220a:	89 c7                	mov    %eax,%edi
  80220c:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  802213:	00 00 00 
  802216:	ff d0                	callq  *%rax
  802218:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221f:	79 05                	jns    802226 <read+0x5d>
		return r;
  802221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802224:	eb 76                	jmp    80229c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222a:	8b 40 08             	mov    0x8(%rax),%eax
  80222d:	83 e0 03             	and    $0x3,%eax
  802230:	83 f8 01             	cmp    $0x1,%eax
  802233:	75 3a                	jne    80226f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802235:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80223c:	00 00 00 
  80223f:	48 8b 00             	mov    (%rax),%rax
  802242:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802248:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80224b:	89 c6                	mov    %eax,%esi
  80224d:	48 bf 57 45 80 00 00 	movabs $0x804557,%rdi
  802254:	00 00 00 
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  802263:	00 00 00 
  802266:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226d:	eb 2d                	jmp    80229c <read+0xd3>
	}
	if (!dev->dev_read)
  80226f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802273:	48 8b 40 10          	mov    0x10(%rax),%rax
  802277:	48 85 c0             	test   %rax,%rax
  80227a:	75 07                	jne    802283 <read+0xba>
		return -E_NOT_SUPP;
  80227c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802281:	eb 19                	jmp    80229c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802287:	48 8b 40 10          	mov    0x10(%rax),%rax
  80228b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80228f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802293:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802297:	48 89 cf             	mov    %rcx,%rdi
  80229a:	ff d0                	callq  *%rax
}
  80229c:	c9                   	leaveq 
  80229d:	c3                   	retq   

000000000080229e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80229e:	55                   	push   %rbp
  80229f:	48 89 e5             	mov    %rsp,%rbp
  8022a2:	48 83 ec 30          	sub    $0x30,%rsp
  8022a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b8:	eb 49                	jmp    802303 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bd:	48 98                	cltq   
  8022bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c3:	48 29 c2             	sub    %rax,%rdx
  8022c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c9:	48 63 c8             	movslq %eax,%rcx
  8022cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d0:	48 01 c1             	add    %rax,%rcx
  8022d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d6:	48 89 ce             	mov    %rcx,%rsi
  8022d9:	89 c7                	mov    %eax,%edi
  8022db:	48 b8 c9 21 80 00 00 	movabs $0x8021c9,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	callq  *%rax
  8022e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022ea:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022ee:	79 05                	jns    8022f5 <readn+0x57>
			return m;
  8022f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022f3:	eb 1c                	jmp    802311 <readn+0x73>
		if (m == 0)
  8022f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022f9:	75 02                	jne    8022fd <readn+0x5f>
			break;
  8022fb:	eb 11                	jmp    80230e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802300:	01 45 fc             	add    %eax,-0x4(%rbp)
  802303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802306:	48 98                	cltq   
  802308:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80230c:	72 ac                	jb     8022ba <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80230e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802311:	c9                   	leaveq 
  802312:	c3                   	retq   

0000000000802313 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802313:	55                   	push   %rbp
  802314:	48 89 e5             	mov    %rsp,%rbp
  802317:	48 83 ec 40          	sub    $0x40,%rsp
  80231b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80231e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802322:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802326:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80232a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80232d:	48 89 d6             	mov    %rdx,%rsi
  802330:	89 c7                	mov    %eax,%edi
  802332:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  802339:	00 00 00 
  80233c:	ff d0                	callq  *%rax
  80233e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802341:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802345:	78 24                	js     80236b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	8b 00                	mov    (%rax),%eax
  80234d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802351:	48 89 d6             	mov    %rdx,%rsi
  802354:	89 c7                	mov    %eax,%edi
  802356:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  80235d:	00 00 00 
  802360:	ff d0                	callq  *%rax
  802362:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802369:	79 05                	jns    802370 <write+0x5d>
		return r;
  80236b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236e:	eb 75                	jmp    8023e5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802374:	8b 40 08             	mov    0x8(%rax),%eax
  802377:	83 e0 03             	and    $0x3,%eax
  80237a:	85 c0                	test   %eax,%eax
  80237c:	75 3a                	jne    8023b8 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80237e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802385:	00 00 00 
  802388:	48 8b 00             	mov    (%rax),%rax
  80238b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802391:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802394:	89 c6                	mov    %eax,%esi
  802396:	48 bf 73 45 80 00 00 	movabs $0x804573,%rdi
  80239d:	00 00 00 
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  8023ac:	00 00 00 
  8023af:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b6:	eb 2d                	jmp    8023e5 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8023b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023bc:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023c0:	48 85 c0             	test   %rax,%rax
  8023c3:	75 07                	jne    8023cc <write+0xb9>
		return -E_NOT_SUPP;
  8023c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023ca:	eb 19                	jmp    8023e5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023d8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023dc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e0:	48 89 cf             	mov    %rcx,%rdi
  8023e3:	ff d0                	callq  *%rax
}
  8023e5:	c9                   	leaveq 
  8023e6:	c3                   	retq   

00000000008023e7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023e7:	55                   	push   %rbp
  8023e8:	48 89 e5             	mov    %rsp,%rbp
  8023eb:	48 83 ec 18          	sub    $0x18,%rsp
  8023ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023fc:	48 89 d6             	mov    %rdx,%rsi
  8023ff:	89 c7                	mov    %eax,%edi
  802401:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  802408:	00 00 00 
  80240b:	ff d0                	callq  *%rax
  80240d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802410:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802414:	79 05                	jns    80241b <seek+0x34>
		return r;
  802416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802419:	eb 0f                	jmp    80242a <seek+0x43>
	fd->fd_offset = offset;
  80241b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802422:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242a:	c9                   	leaveq 
  80242b:	c3                   	retq   

000000000080242c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80242c:	55                   	push   %rbp
  80242d:	48 89 e5             	mov    %rsp,%rbp
  802430:	48 83 ec 30          	sub    $0x30,%rsp
  802434:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802437:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80243e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802441:	48 89 d6             	mov    %rdx,%rsi
  802444:	89 c7                	mov    %eax,%edi
  802446:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax
  802452:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802455:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802459:	78 24                	js     80247f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245f:	8b 00                	mov    (%rax),%eax
  802461:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802465:	48 89 d6             	mov    %rdx,%rsi
  802468:	89 c7                	mov    %eax,%edi
  80246a:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  802471:	00 00 00 
  802474:	ff d0                	callq  *%rax
  802476:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247d:	79 05                	jns    802484 <ftruncate+0x58>
		return r;
  80247f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802482:	eb 72                	jmp    8024f6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802488:	8b 40 08             	mov    0x8(%rax),%eax
  80248b:	83 e0 03             	and    $0x3,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	75 3a                	jne    8024cc <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802492:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802499:	00 00 00 
  80249c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80249f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a8:	89 c6                	mov    %eax,%esi
  8024aa:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  8024b1:	00 00 00 
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b9:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  8024c0:	00 00 00 
  8024c3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ca:	eb 2a                	jmp    8024f6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d4:	48 85 c0             	test   %rax,%rax
  8024d7:	75 07                	jne    8024e0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024de:	eb 16                	jmp    8024f6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ec:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024ef:	89 ce                	mov    %ecx,%esi
  8024f1:	48 89 d7             	mov    %rdx,%rdi
  8024f4:	ff d0                	callq  *%rax
}
  8024f6:	c9                   	leaveq 
  8024f7:	c3                   	retq   

00000000008024f8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024f8:	55                   	push   %rbp
  8024f9:	48 89 e5             	mov    %rsp,%rbp
  8024fc:	48 83 ec 30          	sub    $0x30,%rsp
  802500:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802503:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802507:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80250b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250e:	48 89 d6             	mov    %rdx,%rsi
  802511:	89 c7                	mov    %eax,%edi
  802513:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	callq  *%rax
  80251f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802522:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802526:	78 24                	js     80254c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252c:	8b 00                	mov    (%rax),%eax
  80252e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802532:	48 89 d6             	mov    %rdx,%rsi
  802535:	89 c7                	mov    %eax,%edi
  802537:	48 b8 f0 1e 80 00 00 	movabs $0x801ef0,%rax
  80253e:	00 00 00 
  802541:	ff d0                	callq  *%rax
  802543:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254a:	79 05                	jns    802551 <fstat+0x59>
		return r;
  80254c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254f:	eb 5e                	jmp    8025af <fstat+0xb7>
	if (!dev->dev_stat)
  802551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802555:	48 8b 40 28          	mov    0x28(%rax),%rax
  802559:	48 85 c0             	test   %rax,%rax
  80255c:	75 07                	jne    802565 <fstat+0x6d>
		return -E_NOT_SUPP;
  80255e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802563:	eb 4a                	jmp    8025af <fstat+0xb7>
	stat->st_name[0] = 0;
  802565:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802569:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80256c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802570:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802577:	00 00 00 
	stat->st_isdir = 0;
  80257a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802585:	00 00 00 
	stat->st_dev = dev;
  802588:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802590:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80259f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025a7:	48 89 ce             	mov    %rcx,%rsi
  8025aa:	48 89 d7             	mov    %rdx,%rdi
  8025ad:	ff d0                	callq  *%rax
}
  8025af:	c9                   	leaveq 
  8025b0:	c3                   	retq   

00000000008025b1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025b1:	55                   	push   %rbp
  8025b2:	48 89 e5             	mov    %rsp,%rbp
  8025b5:	48 83 ec 20          	sub    $0x20,%rsp
  8025b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c5:	be 00 00 00 00       	mov    $0x0,%esi
  8025ca:	48 89 c7             	mov    %rax,%rdi
  8025cd:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e0:	79 05                	jns    8025e7 <stat+0x36>
		return fd;
  8025e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e5:	eb 2f                	jmp    802616 <stat+0x65>
	r = fstat(fd, stat);
  8025e7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	48 89 d6             	mov    %rdx,%rsi
  8025f1:	89 c7                	mov    %eax,%edi
  8025f3:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  8025fa:	00 00 00 
  8025fd:	ff d0                	callq  *%rax
  8025ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802605:	89 c7                	mov    %eax,%edi
  802607:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax
	return r;
  802613:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802616:	c9                   	leaveq 
  802617:	c3                   	retq   

0000000000802618 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802618:	55                   	push   %rbp
  802619:	48 89 e5             	mov    %rsp,%rbp
  80261c:	48 83 ec 10          	sub    $0x10,%rsp
  802620:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802623:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802627:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80262e:	00 00 00 
  802631:	8b 00                	mov    (%rax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	75 1d                	jne    802654 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802637:	bf 01 00 00 00       	mov    $0x1,%edi
  80263c:	48 b8 a5 3e 80 00 00 	movabs $0x803ea5,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80264f:	00 00 00 
  802652:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802654:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80265b:	00 00 00 
  80265e:	8b 00                	mov    (%rax),%eax
  802660:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802663:	b9 07 00 00 00       	mov    $0x7,%ecx
  802668:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80266f:	00 00 00 
  802672:	89 c7                	mov    %eax,%edi
  802674:	48 b8 43 3e 80 00 00 	movabs $0x803e43,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	ba 00 00 00 00       	mov    $0x0,%edx
  802689:	48 89 c6             	mov    %rax,%rsi
  80268c:	bf 00 00 00 00       	mov    $0x0,%edi
  802691:	48 b8 3d 3d 80 00 00 	movabs $0x803d3d,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 30          	sub    $0x30,%rsp
  8026a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026ab:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026ae:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026b5:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8026bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8026c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026c8:	75 08                	jne    8026d2 <open+0x33>
	{
		return r;
  8026ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cd:	e9 f2 00 00 00       	jmpq   8027c4 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8026d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d6:	48 89 c7             	mov    %rax,%rdi
  8026d9:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026e8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8026ef:	7e 0a                	jle    8026fb <open+0x5c>
	{
		return -E_BAD_PATH;
  8026f1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026f6:	e9 c9 00 00 00       	jmpq   8027c4 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8026fb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802702:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802703:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802707:	48 89 c7             	mov    %rax,%rdi
  80270a:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271d:	78 09                	js     802728 <open+0x89>
  80271f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802723:	48 85 c0             	test   %rax,%rax
  802726:	75 08                	jne    802730 <open+0x91>
		{
			return r;
  802728:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272b:	e9 94 00 00 00       	jmpq   8027c4 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802734:	ba 00 04 00 00       	mov    $0x400,%edx
  802739:	48 89 c6             	mov    %rax,%rsi
  80273c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802743:	00 00 00 
  802746:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  80274d:	00 00 00 
  802750:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802752:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802759:	00 00 00 
  80275c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80275f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802769:	48 89 c6             	mov    %rax,%rsi
  80276c:	bf 01 00 00 00       	mov    $0x1,%edi
  802771:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
  80277d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802780:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802784:	79 2b                	jns    8027b1 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278a:	be 00 00 00 00       	mov    $0x0,%esi
  80278f:	48 89 c7             	mov    %rax,%rdi
  802792:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  802799:	00 00 00 
  80279c:	ff d0                	callq  *%rax
  80279e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027a5:	79 05                	jns    8027ac <open+0x10d>
			{
				return d;
  8027a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027aa:	eb 18                	jmp    8027c4 <open+0x125>
			}
			return r;
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	eb 13                	jmp    8027c4 <open+0x125>
		}	
		return fd2num(fd_store);
  8027b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b5:	48 89 c7             	mov    %rax,%rdi
  8027b8:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8027c4:	c9                   	leaveq 
  8027c5:	c3                   	retq   

00000000008027c6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027c6:	55                   	push   %rbp
  8027c7:	48 89 e5             	mov    %rsp,%rbp
  8027ca:	48 83 ec 10          	sub    $0x10,%rsp
  8027ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d6:	8b 50 0c             	mov    0xc(%rax),%edx
  8027d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027e0:	00 00 00 
  8027e3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027e5:	be 00 00 00 00       	mov    $0x0,%esi
  8027ea:	bf 06 00 00 00       	mov    $0x6,%edi
  8027ef:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
}
  8027fb:	c9                   	leaveq 
  8027fc:	c3                   	retq   

00000000008027fd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027fd:	55                   	push   %rbp
  8027fe:	48 89 e5             	mov    %rsp,%rbp
  802801:	48 83 ec 30          	sub    $0x30,%rsp
  802805:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802809:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80280d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80281d:	74 07                	je     802826 <devfile_read+0x29>
  80281f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802824:	75 07                	jne    80282d <devfile_read+0x30>
		return -E_INVAL;
  802826:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80282b:	eb 77                	jmp    8028a4 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80282d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802831:	8b 50 0c             	mov    0xc(%rax),%edx
  802834:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283b:	00 00 00 
  80283e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802840:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802847:	00 00 00 
  80284a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802852:	be 00 00 00 00       	mov    $0x0,%esi
  802857:	bf 03 00 00 00       	mov    $0x3,%edi
  80285c:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
  802868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286f:	7f 05                	jg     802876 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802874:	eb 2e                	jmp    8028a4 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802879:	48 63 d0             	movslq %eax,%rdx
  80287c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802880:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802887:	00 00 00 
  80288a:	48 89 c7             	mov    %rax,%rdi
  80288d:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  802894:	00 00 00 
  802897:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802899:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028a4:	c9                   	leaveq 
  8028a5:	c3                   	retq   

00000000008028a6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028a6:	55                   	push   %rbp
  8028a7:	48 89 e5             	mov    %rsp,%rbp
  8028aa:	48 83 ec 30          	sub    $0x30,%rsp
  8028ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8028ba:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8028c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028c6:	74 07                	je     8028cf <devfile_write+0x29>
  8028c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028cd:	75 08                	jne    8028d7 <devfile_write+0x31>
		return r;
  8028cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d2:	e9 9a 00 00 00       	jmpq   802971 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028db:	8b 50 0c             	mov    0xc(%rax),%edx
  8028de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e5:	00 00 00 
  8028e8:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8028ea:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028f1:	00 
  8028f2:	76 08                	jbe    8028fc <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8028f4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028fb:	00 
	}
	fsipcbuf.write.req_n = n;
  8028fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802903:	00 00 00 
  802906:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80290a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80290e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802912:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802916:	48 89 c6             	mov    %rax,%rsi
  802919:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802920:	00 00 00 
  802923:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80292f:	be 00 00 00 00       	mov    $0x0,%esi
  802934:	bf 04 00 00 00       	mov    $0x4,%edi
  802939:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802940:	00 00 00 
  802943:	ff d0                	callq  *%rax
  802945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294c:	7f 20                	jg     80296e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80294e:	48 bf b6 45 80 00 00 	movabs $0x8045b6,%rdi
  802955:	00 00 00 
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802964:	00 00 00 
  802967:	ff d2                	callq  *%rdx
		return r;
  802969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296c:	eb 03                	jmp    802971 <devfile_write+0xcb>
	}
	return r;
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 20          	sub    $0x20,%rsp
  80297b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80297f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802987:	8b 50 0c             	mov    0xc(%rax),%edx
  80298a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802991:	00 00 00 
  802994:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802996:	be 00 00 00 00       	mov    $0x0,%esi
  80299b:	bf 05 00 00 00       	mov    $0x5,%edi
  8029a0:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	79 05                	jns    8029ba <devfile_stat+0x47>
		return r;
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b8:	eb 56                	jmp    802a10 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029be:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029c5:	00 00 00 
  8029c8:	48 89 c7             	mov    %rax,%rdi
  8029cb:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8029d2:	00 00 00 
  8029d5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029de:	00 00 00 
  8029e1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029eb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f8:	00 00 00 
  8029fb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a05:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 10          	sub    $0x10,%rsp
  802a1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a1e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a25:	8b 50 0c             	mov    0xc(%rax),%edx
  802a28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2f:	00 00 00 
  802a32:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a34:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3b:	00 00 00 
  802a3e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a41:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a44:	be 00 00 00 00       	mov    $0x0,%esi
  802a49:	bf 02 00 00 00       	mov    $0x2,%edi
  802a4e:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
}
  802a5a:	c9                   	leaveq 
  802a5b:	c3                   	retq   

0000000000802a5c <remove>:

// Delete a file
int
remove(const char *path)
{
  802a5c:	55                   	push   %rbp
  802a5d:	48 89 e5             	mov    %rsp,%rbp
  802a60:	48 83 ec 10          	sub    $0x10,%rsp
  802a64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6c:	48 89 c7             	mov    %rax,%rdi
  802a6f:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
  802a7b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a80:	7e 07                	jle    802a89 <remove+0x2d>
		return -E_BAD_PATH;
  802a82:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a87:	eb 33                	jmp    802abc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a8d:	48 89 c6             	mov    %rax,%rsi
  802a90:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a97:	00 00 00 
  802a9a:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  802aa1:	00 00 00 
  802aa4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aa6:	be 00 00 00 00       	mov    $0x0,%esi
  802aab:	bf 07 00 00 00       	mov    $0x7,%edi
  802ab0:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
}
  802abc:	c9                   	leaveq 
  802abd:	c3                   	retq   

0000000000802abe <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802abe:	55                   	push   %rbp
  802abf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ac2:	be 00 00 00 00       	mov    $0x0,%esi
  802ac7:	bf 08 00 00 00       	mov    $0x8,%edi
  802acc:	48 b8 18 26 80 00 00 	movabs $0x802618,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
}
  802ad8:	5d                   	pop    %rbp
  802ad9:	c3                   	retq   

0000000000802ada <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ada:	55                   	push   %rbp
  802adb:	48 89 e5             	mov    %rsp,%rbp
  802ade:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ae5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802aec:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802af3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802afa:	be 00 00 00 00       	mov    $0x0,%esi
  802aff:	48 89 c7             	mov    %rax,%rdi
  802b02:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
  802b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b15:	79 28                	jns    802b3f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	89 c6                	mov    %eax,%esi
  802b1c:	48 bf d2 45 80 00 00 	movabs $0x8045d2,%rdi
  802b23:	00 00 00 
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2b:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802b32:	00 00 00 
  802b35:	ff d2                	callq  *%rdx
		return fd_src;
  802b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3a:	e9 74 01 00 00       	jmpq   802cb3 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b3f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b46:	be 01 01 00 00       	mov    $0x101,%esi
  802b4b:	48 89 c7             	mov    %rax,%rdi
  802b4e:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b5d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b61:	79 39                	jns    802b9c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b66:	89 c6                	mov    %eax,%esi
  802b68:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  802b6f:	00 00 00 
  802b72:	b8 00 00 00 00       	mov    $0x0,%eax
  802b77:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802b7e:	00 00 00 
  802b81:	ff d2                	callq  *%rdx
		close(fd_src);
  802b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b86:	89 c7                	mov    %eax,%edi
  802b88:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
		return fd_dest;
  802b94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b97:	e9 17 01 00 00       	jmpq   802cb3 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b9c:	eb 74                	jmp    802c12 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ba1:	48 63 d0             	movslq %eax,%rdx
  802ba4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bae:	48 89 ce             	mov    %rcx,%rsi
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
  802bbf:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bc6:	79 4a                	jns    802c12 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bc8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bcb:	89 c6                	mov    %eax,%esi
  802bcd:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  802bd4:	00 00 00 
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802be3:	00 00 00 
  802be6:	ff d2                	callq  *%rdx
			close(fd_src);
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	89 c7                	mov    %eax,%edi
  802bed:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
			close(fd_dest);
  802bf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
			return write_size;
  802c0a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c0d:	e9 a1 00 00 00       	jmpq   802cb3 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c12:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1c:	ba 00 02 00 00       	mov    $0x200,%edx
  802c21:	48 89 ce             	mov    %rcx,%rsi
  802c24:	89 c7                	mov    %eax,%edi
  802c26:	48 b8 c9 21 80 00 00 	movabs $0x8021c9,%rax
  802c2d:	00 00 00 
  802c30:	ff d0                	callq  *%rax
  802c32:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c39:	0f 8f 5f ff ff ff    	jg     802b9e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c43:	79 47                	jns    802c8c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c45:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c48:	89 c6                	mov    %eax,%esi
  802c4a:	48 bf 15 46 80 00 00 	movabs $0x804615,%rdi
  802c51:	00 00 00 
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
  802c59:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802c60:	00 00 00 
  802c63:	ff d2                	callq  *%rdx
		close(fd_src);
  802c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c68:	89 c7                	mov    %eax,%edi
  802c6a:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802c71:	00 00 00 
  802c74:	ff d0                	callq  *%rax
		close(fd_dest);
  802c76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c79:	89 c7                	mov    %eax,%edi
  802c7b:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
		return read_size;
  802c87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c8a:	eb 27                	jmp    802cb3 <copy+0x1d9>
	}
	close(fd_src);
  802c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8f:	89 c7                	mov    %eax,%edi
  802c91:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
	close(fd_dest);
  802c9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca0:	89 c7                	mov    %eax,%edi
  802ca2:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
	return 0;
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cb3:	c9                   	leaveq 
  802cb4:	c3                   	retq   

0000000000802cb5 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802cb5:	55                   	push   %rbp
  802cb6:	48 89 e5             	mov    %rsp,%rbp
  802cb9:	48 83 ec 20          	sub    $0x20,%rsp
  802cbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802cc0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc7:	48 89 d6             	mov    %rdx,%rsi
  802cca:	89 c7                	mov    %eax,%edi
  802ccc:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdf:	79 05                	jns    802ce6 <fd2sockid+0x31>
		return r;
  802ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce4:	eb 24                	jmp    802d0a <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cea:	8b 10                	mov    (%rax),%edx
  802cec:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802cf3:	00 00 00 
  802cf6:	8b 00                	mov    (%rax),%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	74 07                	je     802d03 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802cfc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d01:	eb 07                	jmp    802d0a <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d07:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d0a:	c9                   	leaveq 
  802d0b:	c3                   	retq   

0000000000802d0c <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d0c:	55                   	push   %rbp
  802d0d:	48 89 e5             	mov    %rsp,%rbp
  802d10:	48 83 ec 20          	sub    $0x20,%rsp
  802d14:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d17:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d1b:	48 89 c7             	mov    %rax,%rdi
  802d1e:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802d25:	00 00 00 
  802d28:	ff d0                	callq  *%rax
  802d2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d31:	78 26                	js     802d59 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d37:	ba 07 04 00 00       	mov    $0x407,%edx
  802d3c:	48 89 c6             	mov    %rax,%rsi
  802d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802d44:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
  802d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d57:	79 16                	jns    802d6f <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d5c:	89 c7                	mov    %eax,%edi
  802d5e:	48 b8 19 32 80 00 00 	movabs $0x803219,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	callq  *%rax
		return r;
  802d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6d:	eb 3a                	jmp    802da9 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d73:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802d7a:	00 00 00 
  802d7d:	8b 12                	mov    (%rdx),%edx
  802d7f:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d85:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d90:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d93:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9a:	48 89 c7             	mov    %rax,%rdi
  802d9d:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   

0000000000802dab <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 30          	sub    $0x30,%rsp
  802db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
  802dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd6:	79 05                	jns    802ddd <accept+0x32>
		return r;
  802dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddb:	eb 3b                	jmp    802e18 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ddd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802de1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de8:	48 89 ce             	mov    %rcx,%rsi
  802deb:	89 c7                	mov    %eax,%edi
  802ded:	48 b8 f6 30 80 00 00 	movabs $0x8030f6,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
  802df9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e00:	79 05                	jns    802e07 <accept+0x5c>
		return r;
  802e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e05:	eb 11                	jmp    802e18 <accept+0x6d>
	return alloc_sockfd(r);
  802e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0a:	89 c7                	mov    %eax,%edi
  802e0c:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
}
  802e18:	c9                   	leaveq 
  802e19:	c3                   	retq   

0000000000802e1a <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e1a:	55                   	push   %rbp
  802e1b:	48 89 e5             	mov    %rsp,%rbp
  802e1e:	48 83 ec 20          	sub    $0x20,%rsp
  802e22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e29:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
  802e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e44:	79 05                	jns    802e4b <bind+0x31>
		return r;
  802e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e49:	eb 1b                	jmp    802e66 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e4b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e4e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	48 89 ce             	mov    %rcx,%rsi
  802e58:	89 c7                	mov    %eax,%edi
  802e5a:	48 b8 75 31 80 00 00 	movabs $0x803175,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
}
  802e66:	c9                   	leaveq 
  802e67:	c3                   	retq   

0000000000802e68 <shutdown>:

int
shutdown(int s, int how)
{
  802e68:	55                   	push   %rbp
  802e69:	48 89 e5             	mov    %rsp,%rbp
  802e6c:	48 83 ec 20          	sub    $0x20,%rsp
  802e70:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e73:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e79:	89 c7                	mov    %eax,%edi
  802e7b:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	callq  *%rax
  802e87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8e:	79 05                	jns    802e95 <shutdown+0x2d>
		return r;
  802e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e93:	eb 16                	jmp    802eab <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802e95:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9b:	89 d6                	mov    %edx,%esi
  802e9d:	89 c7                	mov    %eax,%edi
  802e9f:	48 b8 d9 31 80 00 00 	movabs $0x8031d9,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
}
  802eab:	c9                   	leaveq 
  802eac:	c3                   	retq   

0000000000802ead <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ead:	55                   	push   %rbp
  802eae:	48 89 e5             	mov    %rsp,%rbp
  802eb1:	48 83 ec 10          	sub    $0x10,%rsp
  802eb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebd:	48 89 c7             	mov    %rax,%rdi
  802ec0:	48 b8 27 3f 80 00 00 	movabs $0x803f27,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	83 f8 01             	cmp    $0x1,%eax
  802ecf:	75 17                	jne    802ee8 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802ed1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed5:	8b 40 0c             	mov    0xc(%rax),%eax
  802ed8:	89 c7                	mov    %eax,%edi
  802eda:	48 b8 19 32 80 00 00 	movabs $0x803219,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	eb 05                	jmp    802eed <devsock_close+0x40>
	else
		return 0;
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eed:	c9                   	leaveq 
  802eee:	c3                   	retq   

0000000000802eef <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802eef:	55                   	push   %rbp
  802ef0:	48 89 e5             	mov    %rsp,%rbp
  802ef3:	48 83 ec 20          	sub    $0x20,%rsp
  802ef7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802efa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802efe:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f04:	89 c7                	mov    %eax,%edi
  802f06:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f19:	79 05                	jns    802f20 <connect+0x31>
		return r;
  802f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1e:	eb 1b                	jmp    802f3b <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f20:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f23:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2a:	48 89 ce             	mov    %rcx,%rsi
  802f2d:	89 c7                	mov    %eax,%edi
  802f2f:	48 b8 46 32 80 00 00 	movabs $0x803246,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
}
  802f3b:	c9                   	leaveq 
  802f3c:	c3                   	retq   

0000000000802f3d <listen>:

int
listen(int s, int backlog)
{
  802f3d:	55                   	push   %rbp
  802f3e:	48 89 e5             	mov    %rsp,%rbp
  802f41:	48 83 ec 20          	sub    $0x20,%rsp
  802f45:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f48:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f4e:	89 c7                	mov    %eax,%edi
  802f50:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f63:	79 05                	jns    802f6a <listen+0x2d>
		return r;
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	eb 16                	jmp    802f80 <listen+0x43>
	return nsipc_listen(r, backlog);
  802f6a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f70:	89 d6                	mov    %edx,%esi
  802f72:	89 c7                	mov    %eax,%edi
  802f74:	48 b8 aa 32 80 00 00 	movabs $0x8032aa,%rax
  802f7b:	00 00 00 
  802f7e:	ff d0                	callq  *%rax
}
  802f80:	c9                   	leaveq 
  802f81:	c3                   	retq   

0000000000802f82 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802f82:	55                   	push   %rbp
  802f83:	48 89 e5             	mov    %rsp,%rbp
  802f86:	48 83 ec 20          	sub    $0x20,%rsp
  802f8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f92:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9a:	89 c2                	mov    %eax,%edx
  802f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa0:	8b 40 0c             	mov    0xc(%rax),%eax
  802fa3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fac:	89 c7                	mov    %eax,%edi
  802fae:	48 b8 ea 32 80 00 00 	movabs $0x8032ea,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
}
  802fba:	c9                   	leaveq 
  802fbb:	c3                   	retq   

0000000000802fbc <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802fbc:	55                   	push   %rbp
  802fbd:	48 89 e5             	mov    %rsp,%rbp
  802fc0:	48 83 ec 20          	sub    $0x20,%rsp
  802fc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fcc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd4:	89 c2                	mov    %eax,%edx
  802fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fda:	8b 40 0c             	mov    0xc(%rax),%eax
  802fdd:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fe1:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fe6:	89 c7                	mov    %eax,%edi
  802fe8:	48 b8 b6 33 80 00 00 	movabs $0x8033b6,%rax
  802fef:	00 00 00 
  802ff2:	ff d0                	callq  *%rax
}
  802ff4:	c9                   	leaveq 
  802ff5:	c3                   	retq   

0000000000802ff6 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802ff6:	55                   	push   %rbp
  802ff7:	48 89 e5             	mov    %rsp,%rbp
  802ffa:	48 83 ec 10          	sub    $0x10,%rsp
  802ffe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803002:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300a:	48 be 30 46 80 00 00 	movabs $0x804630,%rsi
  803011:	00 00 00 
  803014:	48 89 c7             	mov    %rax,%rdi
  803017:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
	return 0;
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803028:	c9                   	leaveq 
  803029:	c3                   	retq   

000000000080302a <socket>:

int
socket(int domain, int type, int protocol)
{
  80302a:	55                   	push   %rbp
  80302b:	48 89 e5             	mov    %rsp,%rbp
  80302e:	48 83 ec 20          	sub    $0x20,%rsp
  803032:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803035:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803038:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80303b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80303e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803041:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803044:	89 ce                	mov    %ecx,%esi
  803046:	89 c7                	mov    %eax,%edi
  803048:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  80304f:	00 00 00 
  803052:	ff d0                	callq  *%rax
  803054:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803057:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305b:	79 05                	jns    803062 <socket+0x38>
		return r;
  80305d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803060:	eb 11                	jmp    803073 <socket+0x49>
	return alloc_sockfd(r);
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	89 c7                	mov    %eax,%edi
  803067:	48 b8 0c 2d 80 00 00 	movabs $0x802d0c,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
}
  803073:	c9                   	leaveq 
  803074:	c3                   	retq   

0000000000803075 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803075:	55                   	push   %rbp
  803076:	48 89 e5             	mov    %rsp,%rbp
  803079:	48 83 ec 10          	sub    $0x10,%rsp
  80307d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803080:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803087:	00 00 00 
  80308a:	8b 00                	mov    (%rax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	75 1d                	jne    8030ad <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803090:	bf 02 00 00 00       	mov    $0x2,%edi
  803095:	48 b8 a5 3e 80 00 00 	movabs $0x803ea5,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
  8030a1:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030a8:	00 00 00 
  8030ab:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030ad:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030b4:	00 00 00 
  8030b7:	8b 00                	mov    (%rax),%eax
  8030b9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030bc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030c1:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8030c8:	00 00 00 
  8030cb:	89 c7                	mov    %eax,%edi
  8030cd:	48 b8 43 3e 80 00 00 	movabs $0x803e43,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8030d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8030de:	be 00 00 00 00       	mov    $0x0,%esi
  8030e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e8:	48 b8 3d 3d 80 00 00 	movabs $0x803d3d,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
}
  8030f4:	c9                   	leaveq 
  8030f5:	c3                   	retq   

00000000008030f6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8030f6:	55                   	push   %rbp
  8030f7:	48 89 e5             	mov    %rsp,%rbp
  8030fa:	48 83 ec 30          	sub    $0x30,%rsp
  8030fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803101:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803105:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803109:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803110:	00 00 00 
  803113:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803116:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803118:	bf 01 00 00 00       	mov    $0x1,%edi
  80311d:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
  803129:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803130:	78 3e                	js     803170 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803132:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803139:	00 00 00 
  80313c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803144:	8b 40 10             	mov    0x10(%rax),%eax
  803147:	89 c2                	mov    %eax,%edx
  803149:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	48 89 ce             	mov    %rcx,%rsi
  803154:	48 89 c7             	mov    %rax,%rdi
  803157:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803167:	8b 50 10             	mov    0x10(%rax),%edx
  80316a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803170:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803173:	c9                   	leaveq 
  803174:	c3                   	retq   

0000000000803175 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803175:	55                   	push   %rbp
  803176:	48 89 e5             	mov    %rsp,%rbp
  803179:	48 83 ec 10          	sub    $0x10,%rsp
  80317d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803180:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803184:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803187:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80318e:	00 00 00 
  803191:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803194:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803196:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319d:	48 89 c6             	mov    %rax,%rsi
  8031a0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031a7:	00 00 00 
  8031aa:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8031b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031c3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8031c6:	bf 02 00 00 00       	mov    $0x2,%edi
  8031cb:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
}
  8031d7:	c9                   	leaveq 
  8031d8:	c3                   	retq   

00000000008031d9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8031d9:	55                   	push   %rbp
  8031da:	48 89 e5             	mov    %rsp,%rbp
  8031dd:	48 83 ec 10          	sub    $0x10,%rsp
  8031e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8031e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ee:	00 00 00 
  8031f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031f4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8031f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031fd:	00 00 00 
  803200:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803203:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803206:	bf 03 00 00 00       	mov    $0x3,%edi
  80320b:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
}
  803217:	c9                   	leaveq 
  803218:	c3                   	retq   

0000000000803219 <nsipc_close>:

int
nsipc_close(int s)
{
  803219:	55                   	push   %rbp
  80321a:	48 89 e5             	mov    %rsp,%rbp
  80321d:	48 83 ec 10          	sub    $0x10,%rsp
  803221:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803224:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80322b:	00 00 00 
  80322e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803231:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803233:	bf 04 00 00 00       	mov    $0x4,%edi
  803238:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 10          	sub    $0x10,%rsp
  80324e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803255:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803258:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325f:	00 00 00 
  803262:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803265:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803267:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80326a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326e:	48 89 c6             	mov    %rax,%rsi
  803271:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803278:	00 00 00 
  80327b:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803287:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328e:	00 00 00 
  803291:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803294:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803297:	bf 05 00 00 00       	mov    $0x5,%edi
  80329c:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
}
  8032a8:	c9                   	leaveq 
  8032a9:	c3                   	retq   

00000000008032aa <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8032aa:	55                   	push   %rbp
  8032ab:	48 89 e5             	mov    %rsp,%rbp
  8032ae:	48 83 ec 10          	sub    $0x10,%rsp
  8032b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032b5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8032b8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bf:	00 00 00 
  8032c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8032c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ce:	00 00 00 
  8032d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d4:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8032d7:	bf 06 00 00 00       	mov    $0x6,%edi
  8032dc:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 30          	sub    $0x30,%rsp
  8032f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032f9:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8032fc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8032ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803306:	00 00 00 
  803309:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80330c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80330e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803315:	00 00 00 
  803318:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80331e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803325:	00 00 00 
  803328:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80332b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80332e:	bf 07 00 00 00       	mov    $0x7,%edi
  803333:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
  80333f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803342:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803346:	78 69                	js     8033b1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803348:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80334f:	7f 08                	jg     803359 <nsipc_recv+0x6f>
  803351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803354:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803357:	7e 35                	jle    80338e <nsipc_recv+0xa4>
  803359:	48 b9 37 46 80 00 00 	movabs $0x804637,%rcx
  803360:	00 00 00 
  803363:	48 ba 4c 46 80 00 00 	movabs $0x80464c,%rdx
  80336a:	00 00 00 
  80336d:	be 61 00 00 00       	mov    $0x61,%esi
  803372:	48 bf 61 46 80 00 00 	movabs $0x804661,%rdi
  803379:	00 00 00 
  80337c:	b8 00 00 00 00       	mov    $0x0,%eax
  803381:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  803388:	00 00 00 
  80338b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80338e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803391:	48 63 d0             	movslq %eax,%rdx
  803394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803398:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80339f:	00 00 00 
  8033a2:	48 89 c7             	mov    %rax,%rdi
  8033a5:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
	}

	return r;
  8033b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b4:	c9                   	leaveq 
  8033b5:	c3                   	retq   

00000000008033b6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033b6:	55                   	push   %rbp
  8033b7:	48 89 e5             	mov    %rsp,%rbp
  8033ba:	48 83 ec 20          	sub    $0x20,%rsp
  8033be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033c5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8033c8:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8033cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d2:	00 00 00 
  8033d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d8:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8033da:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8033e1:	7e 35                	jle    803418 <nsipc_send+0x62>
  8033e3:	48 b9 6d 46 80 00 00 	movabs $0x80466d,%rcx
  8033ea:	00 00 00 
  8033ed:	48 ba 4c 46 80 00 00 	movabs $0x80464c,%rdx
  8033f4:	00 00 00 
  8033f7:	be 6c 00 00 00       	mov    $0x6c,%esi
  8033fc:	48 bf 61 46 80 00 00 	movabs $0x804661,%rdi
  803403:	00 00 00 
  803406:	b8 00 00 00 00       	mov    $0x0,%eax
  80340b:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  803412:	00 00 00 
  803415:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803418:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80341b:	48 63 d0             	movslq %eax,%rdx
  80341e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803422:	48 89 c6             	mov    %rax,%rsi
  803425:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80342c:	00 00 00 
  80342f:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80343b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803442:	00 00 00 
  803445:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803448:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80344b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803452:	00 00 00 
  803455:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803458:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80345b:	bf 08 00 00 00       	mov    $0x8,%edi
  803460:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   

000000000080346e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 10          	sub    $0x10,%rsp
  803476:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803479:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80347c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80347f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803486:	00 00 00 
  803489:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80348c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80348e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803495:	00 00 00 
  803498:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80349e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a5:	00 00 00 
  8034a8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034ab:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8034ae:	bf 09 00 00 00       	mov    $0x9,%edi
  8034b3:	48 b8 75 30 80 00 00 	movabs $0x803075,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
}
  8034bf:	c9                   	leaveq 
  8034c0:	c3                   	retq   

00000000008034c1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034c1:	55                   	push   %rbp
  8034c2:	48 89 e5             	mov    %rsp,%rbp
  8034c5:	53                   	push   %rbx
  8034c6:	48 83 ec 38          	sub    $0x38,%rsp
  8034ca:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034ce:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034d2:	48 89 c7             	mov    %rax,%rdi
  8034d5:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
  8034e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e8:	0f 88 bf 01 00 00    	js     8036ad <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f2:	ba 07 04 00 00       	mov    $0x407,%edx
  8034f7:	48 89 c6             	mov    %rax,%rsi
  8034fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ff:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
  80350b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80350e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803512:	0f 88 95 01 00 00    	js     8036ad <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803518:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80351c:	48 89 c7             	mov    %rax,%rdi
  80351f:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
  80352b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80352e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803532:	0f 88 5d 01 00 00    	js     803695 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803538:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80353c:	ba 07 04 00 00       	mov    $0x407,%edx
  803541:	48 89 c6             	mov    %rax,%rsi
  803544:	bf 00 00 00 00       	mov    $0x0,%edi
  803549:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
  803555:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803558:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80355c:	0f 88 33 01 00 00    	js     803695 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803566:	48 89 c7             	mov    %rax,%rdi
  803569:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  803570:	00 00 00 
  803573:	ff d0                	callq  *%rax
  803575:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357d:	ba 07 04 00 00       	mov    $0x407,%edx
  803582:	48 89 c6             	mov    %rax,%rsi
  803585:	bf 00 00 00 00       	mov    $0x0,%edi
  80358a:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
  803596:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803599:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80359d:	79 05                	jns    8035a4 <pipe+0xe3>
		goto err2;
  80359f:	e9 d9 00 00 00       	jmpq   80367d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a8:	48 89 c7             	mov    %rax,%rdi
  8035ab:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	48 89 c2             	mov    %rax,%rdx
  8035ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035be:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035c4:	48 89 d1             	mov    %rdx,%rcx
  8035c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8035cc:	48 89 c6             	mov    %rax,%rsi
  8035cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d4:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
  8035e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e7:	79 1b                	jns    803604 <pipe+0x143>
		goto err3;
  8035e9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ee:	48 89 c6             	mov    %rax,%rsi
  8035f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f6:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
  803602:	eb 79                	jmp    80367d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803608:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80360f:	00 00 00 
  803612:	8b 12                	mov    (%rdx),%edx
  803614:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803625:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80362c:	00 00 00 
  80362f:	8b 12                	mov    (%rdx),%edx
  803631:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803633:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803637:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80363e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803642:	48 89 c7             	mov    %rax,%rdi
  803645:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 c2                	mov    %eax,%edx
  803653:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803657:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803659:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80365d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803661:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803665:	48 89 c7             	mov    %rax,%rdi
  803668:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  80366f:	00 00 00 
  803672:	ff d0                	callq  *%rax
  803674:	89 03                	mov    %eax,(%rbx)
	return 0;
  803676:	b8 00 00 00 00       	mov    $0x0,%eax
  80367b:	eb 33                	jmp    8036b0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80367d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803681:	48 89 c6             	mov    %rax,%rsi
  803684:	bf 00 00 00 00       	mov    $0x0,%edi
  803689:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803699:	48 89 c6             	mov    %rax,%rsi
  80369c:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a1:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8036a8:	00 00 00 
  8036ab:	ff d0                	callq  *%rax
err:
	return r;
  8036ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036b0:	48 83 c4 38          	add    $0x38,%rsp
  8036b4:	5b                   	pop    %rbx
  8036b5:	5d                   	pop    %rbp
  8036b6:	c3                   	retq   

00000000008036b7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036b7:	55                   	push   %rbp
  8036b8:	48 89 e5             	mov    %rsp,%rbp
  8036bb:	53                   	push   %rbx
  8036bc:	48 83 ec 28          	sub    $0x28,%rsp
  8036c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036c8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036cf:	00 00 00 
  8036d2:	48 8b 00             	mov    (%rax),%rax
  8036d5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036db:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e2:	48 89 c7             	mov    %rax,%rdi
  8036e5:	48 b8 27 3f 80 00 00 	movabs $0x803f27,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 c3                	mov    %eax,%ebx
  8036f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f7:	48 89 c7             	mov    %rax,%rdi
  8036fa:	48 b8 27 3f 80 00 00 	movabs $0x803f27,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	39 c3                	cmp    %eax,%ebx
  803708:	0f 94 c0             	sete   %al
  80370b:	0f b6 c0             	movzbl %al,%eax
  80370e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803711:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803718:	00 00 00 
  80371b:	48 8b 00             	mov    (%rax),%rax
  80371e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803724:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803727:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80372d:	75 05                	jne    803734 <_pipeisclosed+0x7d>
			return ret;
  80372f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803732:	eb 4f                	jmp    803783 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803734:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803737:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80373a:	74 42                	je     80377e <_pipeisclosed+0xc7>
  80373c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803740:	75 3c                	jne    80377e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803742:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803749:	00 00 00 
  80374c:	48 8b 00             	mov    (%rax),%rax
  80374f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803755:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803758:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80375b:	89 c6                	mov    %eax,%esi
  80375d:	48 bf 7e 46 80 00 00 	movabs $0x80467e,%rdi
  803764:	00 00 00 
  803767:	b8 00 00 00 00       	mov    $0x0,%eax
  80376c:	49 b8 94 04 80 00 00 	movabs $0x800494,%r8
  803773:	00 00 00 
  803776:	41 ff d0             	callq  *%r8
	}
  803779:	e9 4a ff ff ff       	jmpq   8036c8 <_pipeisclosed+0x11>
  80377e:	e9 45 ff ff ff       	jmpq   8036c8 <_pipeisclosed+0x11>
}
  803783:	48 83 c4 28          	add    $0x28,%rsp
  803787:	5b                   	pop    %rbx
  803788:	5d                   	pop    %rbp
  803789:	c3                   	retq   

000000000080378a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80378a:	55                   	push   %rbp
  80378b:	48 89 e5             	mov    %rsp,%rbp
  80378e:	48 83 ec 30          	sub    $0x30,%rsp
  803792:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803795:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803799:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80379c:	48 89 d6             	mov    %rdx,%rsi
  80379f:	89 c7                	mov    %eax,%edi
  8037a1:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  8037a8:	00 00 00 
  8037ab:	ff d0                	callq  *%rax
  8037ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b4:	79 05                	jns    8037bb <pipeisclosed+0x31>
		return r;
  8037b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b9:	eb 31                	jmp    8037ec <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bf:	48 89 c7             	mov    %rax,%rdi
  8037c2:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037da:	48 89 d6             	mov    %rdx,%rsi
  8037dd:	48 89 c7             	mov    %rax,%rdi
  8037e0:	48 b8 b7 36 80 00 00 	movabs $0x8036b7,%rax
  8037e7:	00 00 00 
  8037ea:	ff d0                	callq  *%rax
}
  8037ec:	c9                   	leaveq 
  8037ed:	c3                   	retq   

00000000008037ee <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037ee:	55                   	push   %rbp
  8037ef:	48 89 e5             	mov    %rsp,%rbp
  8037f2:	48 83 ec 40          	sub    $0x40,%rsp
  8037f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803806:	48 89 c7             	mov    %rax,%rdi
  803809:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  803810:	00 00 00 
  803813:	ff d0                	callq  *%rax
  803815:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803819:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80381d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803821:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803828:	00 
  803829:	e9 92 00 00 00       	jmpq   8038c0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80382e:	eb 41                	jmp    803871 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803830:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803835:	74 09                	je     803840 <devpipe_read+0x52>
				return i;
  803837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383b:	e9 92 00 00 00       	jmpq   8038d2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803840:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803848:	48 89 d6             	mov    %rdx,%rsi
  80384b:	48 89 c7             	mov    %rax,%rdi
  80384e:	48 b8 b7 36 80 00 00 	movabs $0x8036b7,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
  80385a:	85 c0                	test   %eax,%eax
  80385c:	74 07                	je     803865 <devpipe_read+0x77>
				return 0;
  80385e:	b8 00 00 00 00       	mov    $0x0,%eax
  803863:	eb 6d                	jmp    8038d2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803865:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  80386c:	00 00 00 
  80386f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803875:	8b 10                	mov    (%rax),%edx
  803877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387b:	8b 40 04             	mov    0x4(%rax),%eax
  80387e:	39 c2                	cmp    %eax,%edx
  803880:	74 ae                	je     803830 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803886:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80388a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80388e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803892:	8b 00                	mov    (%rax),%eax
  803894:	99                   	cltd   
  803895:	c1 ea 1b             	shr    $0x1b,%edx
  803898:	01 d0                	add    %edx,%eax
  80389a:	83 e0 1f             	and    $0x1f,%eax
  80389d:	29 d0                	sub    %edx,%eax
  80389f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a3:	48 98                	cltq   
  8038a5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038aa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b0:	8b 00                	mov    (%rax),%eax
  8038b2:	8d 50 01             	lea    0x1(%rax),%edx
  8038b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038c8:	0f 82 60 ff ff ff    	jb     80382e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038d2:	c9                   	leaveq 
  8038d3:	c3                   	retq   

00000000008038d4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038d4:	55                   	push   %rbp
  8038d5:	48 89 e5             	mov    %rsp,%rbp
  8038d8:	48 83 ec 40          	sub    $0x40,%rsp
  8038dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038e4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ec:	48 89 c7             	mov    %rax,%rdi
  8038ef:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8038f6:	00 00 00 
  8038f9:	ff d0                	callq  *%rax
  8038fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803903:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803907:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80390e:	00 
  80390f:	e9 8e 00 00 00       	jmpq   8039a2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803914:	eb 31                	jmp    803947 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80391a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391e:	48 89 d6             	mov    %rdx,%rsi
  803921:	48 89 c7             	mov    %rax,%rdi
  803924:	48 b8 b7 36 80 00 00 	movabs $0x8036b7,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	85 c0                	test   %eax,%eax
  803932:	74 07                	je     80393b <devpipe_write+0x67>
				return 0;
  803934:	b8 00 00 00 00       	mov    $0x0,%eax
  803939:	eb 79                	jmp    8039b4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80393b:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394b:	8b 40 04             	mov    0x4(%rax),%eax
  80394e:	48 63 d0             	movslq %eax,%rdx
  803951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803955:	8b 00                	mov    (%rax),%eax
  803957:	48 98                	cltq   
  803959:	48 83 c0 20          	add    $0x20,%rax
  80395d:	48 39 c2             	cmp    %rax,%rdx
  803960:	73 b4                	jae    803916 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803966:	8b 40 04             	mov    0x4(%rax),%eax
  803969:	99                   	cltd   
  80396a:	c1 ea 1b             	shr    $0x1b,%edx
  80396d:	01 d0                	add    %edx,%eax
  80396f:	83 e0 1f             	and    $0x1f,%eax
  803972:	29 d0                	sub    %edx,%eax
  803974:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803978:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80397c:	48 01 ca             	add    %rcx,%rdx
  80397f:	0f b6 0a             	movzbl (%rdx),%ecx
  803982:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803986:	48 98                	cltq   
  803988:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80398c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803990:	8b 40 04             	mov    0x4(%rax),%eax
  803993:	8d 50 01             	lea    0x1(%rax),%edx
  803996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80399d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039aa:	0f 82 64 ff ff ff    	jb     803914 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	48 83 ec 20          	sub    $0x20,%rsp
  8039be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ca:	48 89 c7             	mov    %rax,%rdi
  8039cd:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8039d4:	00 00 00 
  8039d7:	ff d0                	callq  *%rax
  8039d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e1:	48 be 91 46 80 00 00 	movabs $0x804691,%rsi
  8039e8:	00 00 00 
  8039eb:	48 89 c7             	mov    %rax,%rdi
  8039ee:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fe:	8b 50 04             	mov    0x4(%rax),%edx
  803a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a05:	8b 00                	mov    (%rax),%eax
  803a07:	29 c2                	sub    %eax,%edx
  803a09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a0d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a17:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a1e:	00 00 00 
	stat->st_dev = &devpipe;
  803a21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a25:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a2c:	00 00 00 
  803a2f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a3b:	c9                   	leaveq 
  803a3c:	c3                   	retq   

0000000000803a3d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a3d:	55                   	push   %rbp
  803a3e:	48 89 e5             	mov    %rsp,%rbp
  803a41:	48 83 ec 10          	sub    $0x10,%rsp
  803a45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4d:	48 89 c6             	mov    %rax,%rsi
  803a50:	bf 00 00 00 00       	mov    $0x0,%edi
  803a55:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  803a5c:	00 00 00 
  803a5f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	48 89 c6             	mov    %rax,%rsi
  803a77:	bf 00 00 00 00       	mov    $0x0,%edi
  803a7c:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  803a83:	00 00 00 
  803a86:	ff d0                	callq  *%rax
}
  803a88:	c9                   	leaveq 
  803a89:	c3                   	retq   

0000000000803a8a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a8a:	55                   	push   %rbp
  803a8b:	48 89 e5             	mov    %rsp,%rbp
  803a8e:	48 83 ec 20          	sub    $0x20,%rsp
  803a92:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a98:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a9b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a9f:	be 01 00 00 00       	mov    $0x1,%esi
  803aa4:	48 89 c7             	mov    %rax,%rdi
  803aa7:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803aae:	00 00 00 
  803ab1:	ff d0                	callq  *%rax
}
  803ab3:	c9                   	leaveq 
  803ab4:	c3                   	retq   

0000000000803ab5 <getchar>:

int
getchar(void)
{
  803ab5:	55                   	push   %rbp
  803ab6:	48 89 e5             	mov    %rsp,%rbp
  803ab9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803abd:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ac1:	ba 01 00 00 00       	mov    $0x1,%edx
  803ac6:	48 89 c6             	mov    %rax,%rsi
  803ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ace:	48 b8 c9 21 80 00 00 	movabs $0x8021c9,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
  803ada:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803add:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae1:	79 05                	jns    803ae8 <getchar+0x33>
		return r;
  803ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae6:	eb 14                	jmp    803afc <getchar+0x47>
	if (r < 1)
  803ae8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aec:	7f 07                	jg     803af5 <getchar+0x40>
		return -E_EOF;
  803aee:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803af3:	eb 07                	jmp    803afc <getchar+0x47>
	return c;
  803af5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803af9:	0f b6 c0             	movzbl %al,%eax
}
  803afc:	c9                   	leaveq 
  803afd:	c3                   	retq   

0000000000803afe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803afe:	55                   	push   %rbp
  803aff:	48 89 e5             	mov    %rsp,%rbp
  803b02:	48 83 ec 20          	sub    $0x20,%rsp
  803b06:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b10:	48 89 d6             	mov    %rdx,%rsi
  803b13:	89 c7                	mov    %eax,%edi
  803b15:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b28:	79 05                	jns    803b2f <iscons+0x31>
		return r;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	eb 1a                	jmp    803b49 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b33:	8b 10                	mov    (%rax),%edx
  803b35:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b3c:	00 00 00 
  803b3f:	8b 00                	mov    (%rax),%eax
  803b41:	39 c2                	cmp    %eax,%edx
  803b43:	0f 94 c0             	sete   %al
  803b46:	0f b6 c0             	movzbl %al,%eax
}
  803b49:	c9                   	leaveq 
  803b4a:	c3                   	retq   

0000000000803b4b <opencons>:

int
opencons(void)
{
  803b4b:	55                   	push   %rbp
  803b4c:	48 89 e5             	mov    %rsp,%rbp
  803b4f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b53:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b57:	48 89 c7             	mov    %rax,%rdi
  803b5a:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
  803b66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6d:	79 05                	jns    803b74 <opencons+0x29>
		return r;
  803b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b72:	eb 5b                	jmp    803bcf <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b78:	ba 07 04 00 00       	mov    $0x407,%edx
  803b7d:	48 89 c6             	mov    %rax,%rsi
  803b80:	bf 00 00 00 00       	mov    $0x0,%edi
  803b85:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803b8c:	00 00 00 
  803b8f:	ff d0                	callq  *%rax
  803b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b98:	79 05                	jns    803b9f <opencons+0x54>
		return r;
  803b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9d:	eb 30                	jmp    803bcf <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba3:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803baa:	00 00 00 
  803bad:	8b 12                	mov    (%rdx),%edx
  803baf:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc0:	48 89 c7             	mov    %rax,%rdi
  803bc3:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  803bca:	00 00 00 
  803bcd:	ff d0                	callq  *%rax
}
  803bcf:	c9                   	leaveq 
  803bd0:	c3                   	retq   

0000000000803bd1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bd1:	55                   	push   %rbp
  803bd2:	48 89 e5             	mov    %rsp,%rbp
  803bd5:	48 83 ec 30          	sub    $0x30,%rsp
  803bd9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803be1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803be5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bea:	75 07                	jne    803bf3 <devcons_read+0x22>
		return 0;
  803bec:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf1:	eb 4b                	jmp    803c3e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bf3:	eb 0c                	jmp    803c01 <devcons_read+0x30>
		sys_yield();
  803bf5:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803bfc:	00 00 00 
  803bff:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c01:	48 b8 7a 18 80 00 00 	movabs $0x80187a,%rax
  803c08:	00 00 00 
  803c0b:	ff d0                	callq  *%rax
  803c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c14:	74 df                	je     803bf5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1a:	79 05                	jns    803c21 <devcons_read+0x50>
		return c;
  803c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1f:	eb 1d                	jmp    803c3e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c21:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c25:	75 07                	jne    803c2e <devcons_read+0x5d>
		return 0;
  803c27:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2c:	eb 10                	jmp    803c3e <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c31:	89 c2                	mov    %eax,%edx
  803c33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c37:	88 10                	mov    %dl,(%rax)
	return 1;
  803c39:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c3e:	c9                   	leaveq 
  803c3f:	c3                   	retq   

0000000000803c40 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c40:	55                   	push   %rbp
  803c41:	48 89 e5             	mov    %rsp,%rbp
  803c44:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c4b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c52:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c59:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c67:	eb 76                	jmp    803cdf <devcons_write+0x9f>
		m = n - tot;
  803c69:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c70:	89 c2                	mov    %eax,%edx
  803c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c75:	29 c2                	sub    %eax,%edx
  803c77:	89 d0                	mov    %edx,%eax
  803c79:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c7f:	83 f8 7f             	cmp    $0x7f,%eax
  803c82:	76 07                	jbe    803c8b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c84:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c8e:	48 63 d0             	movslq %eax,%rdx
  803c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c94:	48 63 c8             	movslq %eax,%rcx
  803c97:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c9e:	48 01 c1             	add    %rax,%rcx
  803ca1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ca8:	48 89 ce             	mov    %rcx,%rsi
  803cab:	48 89 c7             	mov    %rax,%rdi
  803cae:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803cb5:	00 00 00 
  803cb8:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cbd:	48 63 d0             	movslq %eax,%rdx
  803cc0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cc7:	48 89 d6             	mov    %rdx,%rsi
  803cca:	48 89 c7             	mov    %rax,%rdi
  803ccd:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803cd4:	00 00 00 
  803cd7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cdc:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce2:	48 98                	cltq   
  803ce4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ceb:	0f 82 78 ff ff ff    	jb     803c69 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cf4:	c9                   	leaveq 
  803cf5:	c3                   	retq   

0000000000803cf6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cf6:	55                   	push   %rbp
  803cf7:	48 89 e5             	mov    %rsp,%rbp
  803cfa:	48 83 ec 08          	sub    $0x8,%rsp
  803cfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d07:	c9                   	leaveq 
  803d08:	c3                   	retq   

0000000000803d09 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d09:	55                   	push   %rbp
  803d0a:	48 89 e5             	mov    %rsp,%rbp
  803d0d:	48 83 ec 10          	sub    $0x10,%rsp
  803d11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1d:	48 be 9d 46 80 00 00 	movabs $0x80469d,%rsi
  803d24:	00 00 00 
  803d27:	48 89 c7             	mov    %rax,%rdi
  803d2a:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  803d31:	00 00 00 
  803d34:	ff d0                	callq  *%rax
	return 0;
  803d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d3b:	c9                   	leaveq 
  803d3c:	c3                   	retq   

0000000000803d3d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d3d:	55                   	push   %rbp
  803d3e:	48 89 e5             	mov    %rsp,%rbp
  803d41:	48 83 ec 30          	sub    $0x30,%rsp
  803d45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803d51:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d58:	00 00 00 
  803d5b:	48 8b 00             	mov    (%rax),%rax
  803d5e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d64:	85 c0                	test   %eax,%eax
  803d66:	75 3c                	jne    803da4 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d68:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
  803d74:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d79:	48 63 d0             	movslq %eax,%rdx
  803d7c:	48 89 d0             	mov    %rdx,%rax
  803d7f:	48 c1 e0 03          	shl    $0x3,%rax
  803d83:	48 01 d0             	add    %rdx,%rax
  803d86:	48 c1 e0 05          	shl    $0x5,%rax
  803d8a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d91:	00 00 00 
  803d94:	48 01 c2             	add    %rax,%rdx
  803d97:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d9e:	00 00 00 
  803da1:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803da4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803da9:	75 0e                	jne    803db9 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803dab:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803db2:	00 00 00 
  803db5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803db9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbd:	48 89 c7             	mov    %rax,%rdi
  803dc0:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd3:	79 19                	jns    803dee <ipc_recv+0xb1>
		*from_env_store = 0;
  803dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ddf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dec:	eb 53                	jmp    803e41 <ipc_recv+0x104>
	}
	if(from_env_store)
  803dee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803df3:	74 19                	je     803e0e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803df5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dfc:	00 00 00 
  803dff:	48 8b 00             	mov    (%rax),%rax
  803e02:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e0e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e13:	74 19                	je     803e2e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803e15:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e1c:	00 00 00 
  803e1f:	48 8b 00             	mov    (%rax),%rax
  803e22:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e2c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e2e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e35:	00 00 00 
  803e38:	48 8b 00             	mov    (%rax),%rax
  803e3b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e41:	c9                   	leaveq 
  803e42:	c3                   	retq   

0000000000803e43 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e43:	55                   	push   %rbp
  803e44:	48 89 e5             	mov    %rsp,%rbp
  803e47:	48 83 ec 30          	sub    $0x30,%rsp
  803e4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e4e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e51:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e55:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803e58:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e5d:	75 0e                	jne    803e6d <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e5f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e66:	00 00 00 
  803e69:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e6d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e70:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e73:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e7a:	89 c7                	mov    %eax,%edi
  803e7c:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
  803e88:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e8b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e8f:	75 0c                	jne    803e9d <ipc_send+0x5a>
			sys_yield();
  803e91:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803e98:	00 00 00 
  803e9b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e9d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ea1:	74 ca                	je     803e6d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803ea3:	c9                   	leaveq 
  803ea4:	c3                   	retq   

0000000000803ea5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ea5:	55                   	push   %rbp
  803ea6:	48 89 e5             	mov    %rsp,%rbp
  803ea9:	48 83 ec 14          	sub    $0x14,%rsp
  803ead:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803eb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803eb7:	eb 5e                	jmp    803f17 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803eb9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ec0:	00 00 00 
  803ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec6:	48 63 d0             	movslq %eax,%rdx
  803ec9:	48 89 d0             	mov    %rdx,%rax
  803ecc:	48 c1 e0 03          	shl    $0x3,%rax
  803ed0:	48 01 d0             	add    %rdx,%rax
  803ed3:	48 c1 e0 05          	shl    $0x5,%rax
  803ed7:	48 01 c8             	add    %rcx,%rax
  803eda:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ee0:	8b 00                	mov    (%rax),%eax
  803ee2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ee5:	75 2c                	jne    803f13 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ee7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803eee:	00 00 00 
  803ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef4:	48 63 d0             	movslq %eax,%rdx
  803ef7:	48 89 d0             	mov    %rdx,%rax
  803efa:	48 c1 e0 03          	shl    $0x3,%rax
  803efe:	48 01 d0             	add    %rdx,%rax
  803f01:	48 c1 e0 05          	shl    $0x5,%rax
  803f05:	48 01 c8             	add    %rcx,%rax
  803f08:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f0e:	8b 40 08             	mov    0x8(%rax),%eax
  803f11:	eb 12                	jmp    803f25 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f13:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f17:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f1e:	7e 99                	jle    803eb9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f25:	c9                   	leaveq 
  803f26:	c3                   	retq   

0000000000803f27 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f27:	55                   	push   %rbp
  803f28:	48 89 e5             	mov    %rsp,%rbp
  803f2b:	48 83 ec 18          	sub    $0x18,%rsp
  803f2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f37:	48 c1 e8 15          	shr    $0x15,%rax
  803f3b:	48 89 c2             	mov    %rax,%rdx
  803f3e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f45:	01 00 00 
  803f48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f4c:	83 e0 01             	and    $0x1,%eax
  803f4f:	48 85 c0             	test   %rax,%rax
  803f52:	75 07                	jne    803f5b <pageref+0x34>
		return 0;
  803f54:	b8 00 00 00 00       	mov    $0x0,%eax
  803f59:	eb 53                	jmp    803fae <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f5f:	48 c1 e8 0c          	shr    $0xc,%rax
  803f63:	48 89 c2             	mov    %rax,%rdx
  803f66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f6d:	01 00 00 
  803f70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f7c:	83 e0 01             	and    $0x1,%eax
  803f7f:	48 85 c0             	test   %rax,%rax
  803f82:	75 07                	jne    803f8b <pageref+0x64>
		return 0;
  803f84:	b8 00 00 00 00       	mov    $0x0,%eax
  803f89:	eb 23                	jmp    803fae <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8f:	48 c1 e8 0c          	shr    $0xc,%rax
  803f93:	48 89 c2             	mov    %rax,%rdx
  803f96:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f9d:	00 00 00 
  803fa0:	48 c1 e2 04          	shl    $0x4,%rdx
  803fa4:	48 01 d0             	add    %rdx,%rax
  803fa7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fab:	0f b7 c0             	movzwl %ax,%eax
}
  803fae:	c9                   	leaveq 
  803faf:	c3                   	retq   
