
obj/user/faultallocbad.debug:     file format elf64-x86-64


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
  80003c:	e8 15 01 00 00       	callq  800156 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba b0 40 80 00 00 	movabs $0x8040b0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf db 40 80 00 00 	movabs $0x8040db,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 04 02 80 00 00 	movabs $0x800204,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba f0 40 80 00 00 	movabs $0x8040f0,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 a5 0e 80 00 00 	movabs $0x800ea5,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <umain>:

void
umain(int argc, char **argv)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800128:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  80012f:	00 00 00 
  800132:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
}
  800154:	c9                   	leaveq 
  800155:	c3                   	retq   

0000000000800156 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	48 83 ec 10          	sub    $0x10,%rsp
  80015e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800165:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
  800171:	25 ff 03 00 00       	and    $0x3ff,%eax
  800176:	48 63 d0             	movslq %eax,%rdx
  800179:	48 89 d0             	mov    %rdx,%rax
  80017c:	48 c1 e0 03          	shl    $0x3,%rax
  800180:	48 01 d0             	add    %rdx,%rax
  800183:	48 c1 e0 05          	shl    $0x5,%rax
  800187:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80018e:	00 00 00 
  800191:	48 01 c2             	add    %rax,%rdx
  800194:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80019b:	00 00 00 
  80019e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a5:	7e 14                	jle    8001bb <libmain+0x65>
		binaryname = argv[0];
  8001a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ab:	48 8b 10             	mov    (%rax),%rdx
  8001ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001b5:	00 00 00 
  8001b8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c2:	48 89 d6             	mov    %rdx,%rsi
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001d3:	48 b8 e1 01 80 00 00 	movabs $0x8001e1,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	callq  *%rax
}
  8001df:	c9                   	leaveq 
  8001e0:	c3                   	retq   

00000000008001e1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e1:	55                   	push   %rbp
  8001e2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e5:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  8001ec:	00 00 00 
  8001ef:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f6:	48 b8 61 18 80 00 00 	movabs $0x801861,%rax
  8001fd:	00 00 00 
  800200:	ff d0                	callq  *%rax

}
  800202:	5d                   	pop    %rbp
  800203:	c3                   	retq   

0000000000800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800204:	55                   	push   %rbp
  800205:	48 89 e5             	mov    %rsp,%rbp
  800208:	53                   	push   %rbx
  800209:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800210:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800217:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80021d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800224:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80022b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800232:	84 c0                	test   %al,%al
  800234:	74 23                	je     800259 <_panic+0x55>
  800236:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80023d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800241:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800245:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800249:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80024d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800251:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800255:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800259:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800260:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800267:	00 00 00 
  80026a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800271:	00 00 00 
  800274:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800278:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80027f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800286:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80028d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800294:	00 00 00 
  800297:	48 8b 18             	mov    (%rax),%rbx
  80029a:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
  8002a6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002ac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002b3:	41 89 c8             	mov    %ecx,%r8d
  8002b6:	48 89 d1             	mov    %rdx,%rcx
  8002b9:	48 89 da             	mov    %rbx,%rdx
  8002bc:	89 c6                	mov    %eax,%esi
  8002be:	48 bf 20 41 80 00 00 	movabs $0x804120,%rdi
  8002c5:	00 00 00 
  8002c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cd:	49 b9 3d 04 80 00 00 	movabs $0x80043d,%r9
  8002d4:	00 00 00 
  8002d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002e8:	48 89 d6             	mov    %rdx,%rsi
  8002eb:	48 89 c7             	mov    %rax,%rdi
  8002ee:	48 b8 91 03 80 00 00 	movabs $0x800391,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8002fa:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  800310:	00 00 00 
  800313:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800315:	cc                   	int3   
  800316:	eb fd                	jmp    800315 <_panic+0x111>

0000000000800318 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800318:	55                   	push   %rbp
  800319:	48 89 e5             	mov    %rsp,%rbp
  80031c:	48 83 ec 10          	sub    $0x10,%rsp
  800320:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800323:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032b:	8b 00                	mov    (%rax),%eax
  80032d:	8d 48 01             	lea    0x1(%rax),%ecx
  800330:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800334:	89 0a                	mov    %ecx,(%rdx)
  800336:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800339:	89 d1                	mov    %edx,%ecx
  80033b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80033f:	48 98                	cltq   
  800341:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800349:	8b 00                	mov    (%rax),%eax
  80034b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800350:	75 2c                	jne    80037e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800356:	8b 00                	mov    (%rax),%eax
  800358:	48 98                	cltq   
  80035a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035e:	48 83 c2 08          	add    $0x8,%rdx
  800362:	48 89 c6             	mov    %rax,%rsi
  800365:	48 89 d7             	mov    %rdx,%rdi
  800368:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80036f:	00 00 00 
  800372:	ff d0                	callq  *%rax
        b->idx = 0;
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80037e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800382:	8b 40 04             	mov    0x4(%rax),%eax
  800385:	8d 50 01             	lea    0x1(%rax),%edx
  800388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80038f:	c9                   	leaveq 
  800390:	c3                   	retq   

0000000000800391 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800391:	55                   	push   %rbp
  800392:	48 89 e5             	mov    %rsp,%rbp
  800395:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80039c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003b8:	48 8b 0a             	mov    (%rdx),%rcx
  8003bb:	48 89 08             	mov    %rcx,(%rax)
  8003be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003d5:	00 00 00 
    b.cnt = 0;
  8003d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003df:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8003e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003f7:	48 89 c6             	mov    %rax,%rsi
  8003fa:	48 bf 18 03 80 00 00 	movabs $0x800318,%rdi
  800401:	00 00 00 
  800404:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  80040b:	00 00 00 
  80040e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800410:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800416:	48 98                	cltq   
  800418:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80041f:	48 83 c2 08          	add    $0x8,%rdx
  800423:	48 89 c6             	mov    %rax,%rsi
  800426:	48 89 d7             	mov    %rdx,%rdi
  800429:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  800430:	00 00 00 
  800433:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800435:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80043b:	c9                   	leaveq 
  80043c:	c3                   	retq   

000000000080043d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80043d:	55                   	push   %rbp
  80043e:	48 89 e5             	mov    %rsp,%rbp
  800441:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800448:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80044f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800456:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80045d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800464:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80046b:	84 c0                	test   %al,%al
  80046d:	74 20                	je     80048f <cprintf+0x52>
  80046f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800473:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800477:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80047b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80047f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800483:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800487:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80048b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80048f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800496:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80049d:	00 00 00 
  8004a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004a7:	00 00 00 
  8004aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004d1:	48 8b 0a             	mov    (%rdx),%rcx
  8004d4:	48 89 08             	mov    %rcx,(%rax)
  8004d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8004e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004f5:	48 89 d6             	mov    %rdx,%rsi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	48 b8 91 03 80 00 00 	movabs $0x800391,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
  800507:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80050d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800513:	c9                   	leaveq 
  800514:	c3                   	retq   

0000000000800515 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800515:	55                   	push   %rbp
  800516:	48 89 e5             	mov    %rsp,%rbp
  800519:	53                   	push   %rbx
  80051a:	48 83 ec 38          	sub    $0x38,%rsp
  80051e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800522:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800526:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80052a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80052d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800531:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800535:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800538:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80053c:	77 3b                	ja     800579 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80053e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800541:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800545:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
  800551:	48 f7 f3             	div    %rbx
  800554:	48 89 c2             	mov    %rax,%rdx
  800557:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80055a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80055d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	41 89 f9             	mov    %edi,%r9d
  800568:	48 89 c7             	mov    %rax,%rdi
  80056b:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
  800577:	eb 1e                	jmp    800597 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800579:	eb 12                	jmp    80058d <printnum+0x78>
			putch(padc, putdat);
  80057b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80057f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 89 ce             	mov    %rcx,%rsi
  800589:	89 d7                	mov    %edx,%edi
  80058b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800591:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800595:	7f e4                	jg     80057b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800597:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	48 f7 f1             	div    %rcx
  8005a6:	48 89 d0             	mov    %rdx,%rax
  8005a9:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  8005b0:	00 00 00 
  8005b3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005b7:	0f be d0             	movsbl %al,%edx
  8005ba:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c2:	48 89 ce             	mov    %rcx,%rsi
  8005c5:	89 d7                	mov    %edx,%edi
  8005c7:	ff d0                	callq  *%rax
}
  8005c9:	48 83 c4 38          	add    $0x38,%rsp
  8005cd:	5b                   	pop    %rbx
  8005ce:	5d                   	pop    %rbp
  8005cf:	c3                   	retq   

00000000008005d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
  8005d4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e3:	7e 52                	jle    800637 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	83 f8 30             	cmp    $0x30,%eax
  8005ee:	73 24                	jae    800614 <getuint+0x44>
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	8b 00                	mov    (%rax),%eax
  8005fe:	89 c0                	mov    %eax,%eax
  800600:	48 01 d0             	add    %rdx,%rax
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	8b 12                	mov    (%rdx),%edx
  800609:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	89 0a                	mov    %ecx,(%rdx)
  800612:	eb 17                	jmp    80062b <getuint+0x5b>
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061c:	48 89 d0             	mov    %rdx,%rax
  80061f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062b:	48 8b 00             	mov    (%rax),%rax
  80062e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800632:	e9 a3 00 00 00       	jmpq   8006da <getuint+0x10a>
	else if (lflag)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80063b:	74 4f                	je     80068c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 30             	cmp    $0x30,%eax
  800646:	73 24                	jae    80066c <getuint+0x9c>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	89 c0                	mov    %eax,%eax
  800658:	48 01 d0             	add    %rdx,%rax
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	8b 12                	mov    (%rdx),%edx
  800661:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	89 0a                	mov    %ecx,(%rdx)
  80066a:	eb 17                	jmp    800683 <getuint+0xb3>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800683:	48 8b 00             	mov    (%rax),%rax
  800686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068a:	eb 4e                	jmp    8006da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	83 f8 30             	cmp    $0x30,%eax
  800695:	73 24                	jae    8006bb <getuint+0xeb>
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	89 c0                	mov    %eax,%eax
  8006a7:	48 01 d0             	add    %rdx,%rax
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	8b 12                	mov    (%rdx),%edx
  8006b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	89 0a                	mov    %ecx,(%rdx)
  8006b9:	eb 17                	jmp    8006d2 <getuint+0x102>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c3:	48 89 d0             	mov    %rdx,%rax
  8006c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f3:	7e 52                	jle    800747 <getint+0x67>
		x=va_arg(*ap, long long);
  8006f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f9:	8b 00                	mov    (%rax),%eax
  8006fb:	83 f8 30             	cmp    $0x30,%eax
  8006fe:	73 24                	jae    800724 <getint+0x44>
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	89 c0                	mov    %eax,%eax
  800710:	48 01 d0             	add    %rdx,%rax
  800713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800717:	8b 12                	mov    (%rdx),%edx
  800719:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	89 0a                	mov    %ecx,(%rdx)
  800722:	eb 17                	jmp    80073b <getint+0x5b>
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072c:	48 89 d0             	mov    %rdx,%rax
  80072f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073b:	48 8b 00             	mov    (%rax),%rax
  80073e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800742:	e9 a3 00 00 00       	jmpq   8007ea <getint+0x10a>
	else if (lflag)
  800747:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80074b:	74 4f                	je     80079c <getint+0xbc>
		x=va_arg(*ap, long);
  80074d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800751:	8b 00                	mov    (%rax),%eax
  800753:	83 f8 30             	cmp    $0x30,%eax
  800756:	73 24                	jae    80077c <getint+0x9c>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	8b 00                	mov    (%rax),%eax
  800766:	89 c0                	mov    %eax,%eax
  800768:	48 01 d0             	add    %rdx,%rax
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	8b 12                	mov    (%rdx),%edx
  800771:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	89 0a                	mov    %ecx,(%rdx)
  80077a:	eb 17                	jmp    800793 <getint+0xb3>
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800784:	48 89 d0             	mov    %rdx,%rax
  800787:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800793:	48 8b 00             	mov    (%rax),%rax
  800796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079a:	eb 4e                	jmp    8007ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	83 f8 30             	cmp    $0x30,%eax
  8007a5:	73 24                	jae    8007cb <getint+0xeb>
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	8b 00                	mov    (%rax),%eax
  8007b5:	89 c0                	mov    %eax,%eax
  8007b7:	48 01 d0             	add    %rdx,%rax
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	8b 12                	mov    (%rdx),%edx
  8007c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	89 0a                	mov    %ecx,(%rdx)
  8007c9:	eb 17                	jmp    8007e2 <getint+0x102>
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d3:	48 89 d0             	mov    %rdx,%rax
  8007d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	48 98                	cltq   
  8007e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ee:	c9                   	leaveq 
  8007ef:	c3                   	retq   

00000000008007f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f0:	55                   	push   %rbp
  8007f1:	48 89 e5             	mov    %rsp,%rbp
  8007f4:	41 54                	push   %r12
  8007f6:	53                   	push   %rbx
  8007f7:	48 83 ec 60          	sub    $0x60,%rsp
  8007fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800803:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800807:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80080b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80080f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800813:	48 8b 0a             	mov    (%rdx),%rcx
  800816:	48 89 08             	mov    %rcx,(%rax)
  800819:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80081d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800821:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800825:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800829:	eb 17                	jmp    800842 <vprintfmt+0x52>
			if (ch == '\0')
  80082b:	85 db                	test   %ebx,%ebx
  80082d:	0f 84 cc 04 00 00    	je     800cff <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800833:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800837:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083b:	48 89 d6             	mov    %rdx,%rsi
  80083e:	89 df                	mov    %ebx,%edi
  800840:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800842:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800846:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80084a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80084e:	0f b6 00             	movzbl (%rax),%eax
  800851:	0f b6 d8             	movzbl %al,%ebx
  800854:	83 fb 25             	cmp    $0x25,%ebx
  800857:	75 d2                	jne    80082b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800859:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80085d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800864:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80086b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800872:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800879:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80087d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800881:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800885:	0f b6 00             	movzbl (%rax),%eax
  800888:	0f b6 d8             	movzbl %al,%ebx
  80088b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80088e:	83 f8 55             	cmp    $0x55,%eax
  800891:	0f 87 34 04 00 00    	ja     800ccb <vprintfmt+0x4db>
  800897:	89 c0                	mov    %eax,%eax
  800899:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008a0:	00 
  8008a1:	48 b8 78 43 80 00 00 	movabs $0x804378,%rax
  8008a8:	00 00 00 
  8008ab:	48 01 d0             	add    %rdx,%rax
  8008ae:	48 8b 00             	mov    (%rax),%rax
  8008b1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008b3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008b7:	eb c0                	jmp    800879 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008bd:	eb ba                	jmp    800879 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008c6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008c9:	89 d0                	mov    %edx,%eax
  8008cb:	c1 e0 02             	shl    $0x2,%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	01 c0                	add    %eax,%eax
  8008d2:	01 d8                	add    %ebx,%eax
  8008d4:	83 e8 30             	sub    $0x30,%eax
  8008d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008de:	0f b6 00             	movzbl (%rax),%eax
  8008e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008e7:	7e 0c                	jle    8008f5 <vprintfmt+0x105>
  8008e9:	83 fb 39             	cmp    $0x39,%ebx
  8008ec:	7f 07                	jg     8008f5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ee:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f3:	eb d1                	jmp    8008c6 <vprintfmt+0xd6>
			goto process_precision;
  8008f5:	eb 58                	jmp    80094f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8008f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 17                	jae    800916 <vprintfmt+0x126>
  8008ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 01 d0             	add    %rdx,%rax
  80090b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80090e:	83 c2 08             	add    $0x8,%edx
  800911:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800914:	eb 0f                	jmp    800925 <vprintfmt+0x135>
  800916:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091a:	48 89 d0             	mov    %rdx,%rax
  80091d:	48 83 c2 08          	add    $0x8,%rdx
  800921:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800925:	8b 00                	mov    (%rax),%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80092a:	eb 23                	jmp    80094f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80092c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800930:	79 0c                	jns    80093e <vprintfmt+0x14e>
				width = 0;
  800932:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800939:	e9 3b ff ff ff       	jmpq   800879 <vprintfmt+0x89>
  80093e:	e9 36 ff ff ff       	jmpq   800879 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800943:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80094a:	e9 2a ff ff ff       	jmpq   800879 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80094f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800953:	79 12                	jns    800967 <vprintfmt+0x177>
				width = precision, precision = -1;
  800955:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800958:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80095b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800962:	e9 12 ff ff ff       	jmpq   800879 <vprintfmt+0x89>
  800967:	e9 0d ff ff ff       	jmpq   800879 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80096c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800970:	e9 04 ff ff ff       	jmpq   800879 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 30             	cmp    $0x30,%eax
  80097b:	73 17                	jae    800994 <vprintfmt+0x1a4>
  80097d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800981:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800984:	89 c0                	mov    %eax,%eax
  800986:	48 01 d0             	add    %rdx,%rax
  800989:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098c:	83 c2 08             	add    $0x8,%edx
  80098f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800992:	eb 0f                	jmp    8009a3 <vprintfmt+0x1b3>
  800994:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800998:	48 89 d0             	mov    %rdx,%rax
  80099b:	48 83 c2 08          	add    $0x8,%rdx
  80099f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a3:	8b 10                	mov    (%rax),%edx
  8009a5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ad:	48 89 ce             	mov    %rcx,%rsi
  8009b0:	89 d7                	mov    %edx,%edi
  8009b2:	ff d0                	callq  *%rax
			break;
  8009b4:	e9 40 03 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bc:	83 f8 30             	cmp    $0x30,%eax
  8009bf:	73 17                	jae    8009d8 <vprintfmt+0x1e8>
  8009c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	89 c0                	mov    %eax,%eax
  8009ca:	48 01 d0             	add    %rdx,%rax
  8009cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d0:	83 c2 08             	add    $0x8,%edx
  8009d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d6:	eb 0f                	jmp    8009e7 <vprintfmt+0x1f7>
  8009d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dc:	48 89 d0             	mov    %rdx,%rax
  8009df:	48 83 c2 08          	add    $0x8,%rdx
  8009e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009e9:	85 db                	test   %ebx,%ebx
  8009eb:	79 02                	jns    8009ef <vprintfmt+0x1ff>
				err = -err;
  8009ed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009ef:	83 fb 15             	cmp    $0x15,%ebx
  8009f2:	7f 16                	jg     800a0a <vprintfmt+0x21a>
  8009f4:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  8009fb:	00 00 00 
  8009fe:	48 63 d3             	movslq %ebx,%rdx
  800a01:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a05:	4d 85 e4             	test   %r12,%r12
  800a08:	75 2e                	jne    800a38 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a0a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a12:	89 d9                	mov    %ebx,%ecx
  800a14:	48 ba 61 43 80 00 00 	movabs $0x804361,%rdx
  800a1b:	00 00 00 
  800a1e:	48 89 c7             	mov    %rax,%rdi
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
  800a26:	49 b8 08 0d 80 00 00 	movabs $0x800d08,%r8
  800a2d:	00 00 00 
  800a30:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a33:	e9 c1 02 00 00       	jmpq   800cf9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a40:	4c 89 e1             	mov    %r12,%rcx
  800a43:	48 ba 6a 43 80 00 00 	movabs $0x80436a,%rdx
  800a4a:	00 00 00 
  800a4d:	48 89 c7             	mov    %rax,%rdi
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	49 b8 08 0d 80 00 00 	movabs $0x800d08,%r8
  800a5c:	00 00 00 
  800a5f:	41 ff d0             	callq  *%r8
			break;
  800a62:	e9 92 02 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6a:	83 f8 30             	cmp    $0x30,%eax
  800a6d:	73 17                	jae    800a86 <vprintfmt+0x296>
  800a6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a76:	89 c0                	mov    %eax,%eax
  800a78:	48 01 d0             	add    %rdx,%rax
  800a7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7e:	83 c2 08             	add    $0x8,%edx
  800a81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a84:	eb 0f                	jmp    800a95 <vprintfmt+0x2a5>
  800a86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8a:	48 89 d0             	mov    %rdx,%rax
  800a8d:	48 83 c2 08          	add    $0x8,%rdx
  800a91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a95:	4c 8b 20             	mov    (%rax),%r12
  800a98:	4d 85 e4             	test   %r12,%r12
  800a9b:	75 0a                	jne    800aa7 <vprintfmt+0x2b7>
				p = "(null)";
  800a9d:	49 bc 6d 43 80 00 00 	movabs $0x80436d,%r12
  800aa4:	00 00 00 
			if (width > 0 && padc != '-')
  800aa7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aab:	7e 3f                	jle    800aec <vprintfmt+0x2fc>
  800aad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab1:	74 39                	je     800aec <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab6:	48 98                	cltq   
  800ab8:	48 89 c6             	mov    %rax,%rsi
  800abb:	4c 89 e7             	mov    %r12,%rdi
  800abe:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800acd:	eb 17                	jmp    800ae6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800acf:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	48 89 ce             	mov    %rcx,%rsi
  800ade:	89 d7                	mov    %edx,%edi
  800ae0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aea:	7f e3                	jg     800acf <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aec:	eb 37                	jmp    800b25 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800aee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af2:	74 1e                	je     800b12 <vprintfmt+0x322>
  800af4:	83 fb 1f             	cmp    $0x1f,%ebx
  800af7:	7e 05                	jle    800afe <vprintfmt+0x30e>
  800af9:	83 fb 7e             	cmp    $0x7e,%ebx
  800afc:	7e 14                	jle    800b12 <vprintfmt+0x322>
					putch('?', putdat);
  800afe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	48 89 d6             	mov    %rdx,%rsi
  800b09:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b0e:	ff d0                	callq  *%rax
  800b10:	eb 0f                	jmp    800b21 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1a:	48 89 d6             	mov    %rdx,%rsi
  800b1d:	89 df                	mov    %ebx,%edi
  800b1f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b21:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b25:	4c 89 e0             	mov    %r12,%rax
  800b28:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b2c:	0f b6 00             	movzbl (%rax),%eax
  800b2f:	0f be d8             	movsbl %al,%ebx
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	74 10                	je     800b46 <vprintfmt+0x356>
  800b36:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b3a:	78 b2                	js     800aee <vprintfmt+0x2fe>
  800b3c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b44:	79 a8                	jns    800aee <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b46:	eb 16                	jmp    800b5e <vprintfmt+0x36e>
				putch(' ', putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	bf 20 00 00 00       	mov    $0x20,%edi
  800b58:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b62:	7f e4                	jg     800b48 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b64:	e9 90 01 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6d:	be 03 00 00 00       	mov    $0x3,%esi
  800b72:	48 89 c7             	mov    %rax,%rdi
  800b75:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800b7c:	00 00 00 
  800b7f:	ff d0                	callq  *%rax
  800b81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b89:	48 85 c0             	test   %rax,%rax
  800b8c:	79 1d                	jns    800bab <vprintfmt+0x3bb>
				putch('-', putdat);
  800b8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b96:	48 89 d6             	mov    %rdx,%rsi
  800b99:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b9e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba4:	48 f7 d8             	neg    %rax
  800ba7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb2:	e9 d5 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bb7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bbb:	be 03 00 00 00       	mov    $0x3,%esi
  800bc0:	48 89 c7             	mov    %rax,%rdi
  800bc3:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800bca:	00 00 00 
  800bcd:	ff d0                	callq  *%rax
  800bcf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bda:	e9 ad 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800bdf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800be2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	48 89 c7             	mov    %rax,%rdi
  800beb:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800bf2:	00 00 00 
  800bf5:	ff d0                	callq  *%rax
  800bf7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800bfb:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c02:	e9 85 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0f:	48 89 d6             	mov    %rdx,%rsi
  800c12:	bf 30 00 00 00       	mov    $0x30,%edi
  800c17:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c21:	48 89 d6             	mov    %rdx,%rsi
  800c24:	bf 78 00 00 00       	mov    $0x78,%edi
  800c29:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2e:	83 f8 30             	cmp    $0x30,%eax
  800c31:	73 17                	jae    800c4a <vprintfmt+0x45a>
  800c33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3a:	89 c0                	mov    %eax,%eax
  800c3c:	48 01 d0             	add    %rdx,%rax
  800c3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c42:	83 c2 08             	add    $0x8,%edx
  800c45:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	eb 0f                	jmp    800c59 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c4e:	48 89 d0             	mov    %rdx,%rax
  800c51:	48 83 c2 08          	add    $0x8,%rdx
  800c55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c59:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c60:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c67:	eb 23                	jmp    800c8c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6d:	be 03 00 00 00       	mov    $0x3,%esi
  800c72:	48 89 c7             	mov    %rax,%rdi
  800c75:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800c7c:	00 00 00 
  800c7f:	ff d0                	callq  *%rax
  800c81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c91:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c94:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c9b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca3:	45 89 c1             	mov    %r8d,%r9d
  800ca6:	41 89 f8             	mov    %edi,%r8d
  800ca9:	48 89 c7             	mov    %rax,%rdi
  800cac:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
			break;
  800cb8:	eb 3f                	jmp    800cf9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc2:	48 89 d6             	mov    %rdx,%rsi
  800cc5:	89 df                	mov    %ebx,%edi
  800cc7:	ff d0                	callq  *%rax
			break;
  800cc9:	eb 2e                	jmp    800cf9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ccb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd3:	48 89 d6             	mov    %rdx,%rsi
  800cd6:	bf 25 00 00 00       	mov    $0x25,%edi
  800cdb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cdd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce2:	eb 05                	jmp    800ce9 <vprintfmt+0x4f9>
  800ce4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ced:	48 83 e8 01          	sub    $0x1,%rax
  800cf1:	0f b6 00             	movzbl (%rax),%eax
  800cf4:	3c 25                	cmp    $0x25,%al
  800cf6:	75 ec                	jne    800ce4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800cf8:	90                   	nop
		}
	}
  800cf9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cfa:	e9 43 fb ff ff       	jmpq   800842 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cff:	48 83 c4 60          	add    $0x60,%rsp
  800d03:	5b                   	pop    %rbx
  800d04:	41 5c                	pop    %r12
  800d06:	5d                   	pop    %rbp
  800d07:	c3                   	retq   

0000000000800d08 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d08:	55                   	push   %rbp
  800d09:	48 89 e5             	mov    %rsp,%rbp
  800d0c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d13:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d1a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d36:	84 c0                	test   %al,%al
  800d38:	74 20                	je     800d5a <printfmt+0x52>
  800d3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d5a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d61:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d68:	00 00 00 
  800d6b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d72:	00 00 00 
  800d75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d87:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d8e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d95:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d9c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800da3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800daa:	48 89 c7             	mov    %rax,%rdi
  800dad:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  800db4:	00 00 00 
  800db7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800db9:	c9                   	leaveq 
  800dba:	c3                   	retq   

0000000000800dbb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	48 83 ec 10          	sub    $0x10,%rsp
  800dc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dce:	8b 40 10             	mov    0x10(%rax),%eax
  800dd1:	8d 50 01             	lea    0x1(%rax),%edx
  800dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dd8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddf:	48 8b 10             	mov    (%rax),%rdx
  800de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dea:	48 39 c2             	cmp    %rax,%rdx
  800ded:	73 17                	jae    800e06 <sprintputch+0x4b>
		*b->buf++ = ch;
  800def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df3:	48 8b 00             	mov    (%rax),%rax
  800df6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800dfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dfe:	48 89 0a             	mov    %rcx,(%rdx)
  800e01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e04:	88 10                	mov    %dl,(%rax)
}
  800e06:	c9                   	leaveq 
  800e07:	c3                   	retq   

0000000000800e08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 50          	sub    $0x50,%rsp
  800e10:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e14:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e17:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e1b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e1f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e23:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e27:	48 8b 0a             	mov    (%rdx),%rcx
  800e2a:	48 89 08             	mov    %rcx,(%rax)
  800e2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e41:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e45:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e48:	48 98                	cltq   
  800e4a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e52:	48 01 d0             	add    %rdx,%rax
  800e55:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e60:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e65:	74 06                	je     800e6d <vsnprintf+0x65>
  800e67:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e6b:	7f 07                	jg     800e74 <vsnprintf+0x6c>
		return -E_INVAL;
  800e6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e72:	eb 2f                	jmp    800ea3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e74:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e78:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e7c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e80:	48 89 c6             	mov    %rax,%rsi
  800e83:	48 bf bb 0d 80 00 00 	movabs $0x800dbb,%rdi
  800e8a:	00 00 00 
  800e8d:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e9d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ea0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ea3:	c9                   	leaveq 
  800ea4:	c3                   	retq   

0000000000800ea5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ea5:	55                   	push   %rbp
  800ea6:	48 89 e5             	mov    %rsp,%rbp
  800ea9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eb0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eb7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ebd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ecb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed2:	84 c0                	test   %al,%al
  800ed4:	74 20                	je     800ef6 <snprintf+0x51>
  800ed6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ede:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ee6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ef6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800efd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f04:	00 00 00 
  800f07:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f0e:	00 00 00 
  800f11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f15:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f23:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f2a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f31:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f38:	48 8b 0a             	mov    (%rdx),%rcx
  800f3b:	48 89 08             	mov    %rcx,(%rax)
  800f3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f4e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f55:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f5c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f62:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f69:	48 89 c7             	mov    %rax,%rdi
  800f6c:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  800f73:	00 00 00 
  800f76:	ff d0                	callq  *%rax
  800f78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f7e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f84:	c9                   	leaveq 
  800f85:	c3                   	retq   

0000000000800f86 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f86:	55                   	push   %rbp
  800f87:	48 89 e5             	mov    %rsp,%rbp
  800f8a:	48 83 ec 18          	sub    $0x18,%rsp
  800f8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f99:	eb 09                	jmp    800fa4 <strlen+0x1e>
		n++;
  800f9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa8:	0f b6 00             	movzbl (%rax),%eax
  800fab:	84 c0                	test   %al,%al
  800fad:	75 ec                	jne    800f9b <strlen+0x15>
		n++;
	return n;
  800faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fb2:	c9                   	leaveq 
  800fb3:	c3                   	retq   

0000000000800fb4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fb4:	55                   	push   %rbp
  800fb5:	48 89 e5             	mov    %rsp,%rbp
  800fb8:	48 83 ec 20          	sub    $0x20,%rsp
  800fbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fcb:	eb 0e                	jmp    800fdb <strnlen+0x27>
		n++;
  800fcd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fdb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fe0:	74 0b                	je     800fed <strnlen+0x39>
  800fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe6:	0f b6 00             	movzbl (%rax),%eax
  800fe9:	84 c0                	test   %al,%al
  800feb:	75 e0                	jne    800fcd <strnlen+0x19>
		n++;
	return n;
  800fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 20          	sub    $0x20,%rsp
  800ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801006:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80100a:	90                   	nop
  80100b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801013:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801017:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80101b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80101f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801023:	0f b6 12             	movzbl (%rdx),%edx
  801026:	88 10                	mov    %dl,(%rax)
  801028:	0f b6 00             	movzbl (%rax),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	75 dc                	jne    80100b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 20          	sub    $0x20,%rsp
  80103d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801041:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	48 89 c7             	mov    %rax,%rdi
  80104c:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  801053:	00 00 00 
  801056:	ff d0                	callq  *%rax
  801058:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80105b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80105e:	48 63 d0             	movslq %eax,%rdx
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 01 c2             	add    %rax,%rdx
  801068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106c:	48 89 c6             	mov    %rax,%rsi
  80106f:	48 89 d7             	mov    %rdx,%rdi
  801072:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  801079:	00 00 00 
  80107c:	ff d0                	callq  *%rax
	return dst;
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 28          	sub    $0x28,%rsp
  80108c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801090:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801094:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010a0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010a7:	00 
  8010a8:	eb 2a                	jmp    8010d4 <strncpy+0x50>
		*dst++ = *src;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ba:	0f b6 12             	movzbl (%rdx),%edx
  8010bd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 05                	je     8010cf <strncpy+0x4b>
			src++;
  8010ca:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010dc:	72 cc                	jb     8010aa <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010e2:	c9                   	leaveq 
  8010e3:	c3                   	retq   

00000000008010e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010e4:	55                   	push   %rbp
  8010e5:	48 89 e5             	mov    %rsp,%rbp
  8010e8:	48 83 ec 28          	sub    $0x28,%rsp
  8010ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801100:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801105:	74 3d                	je     801144 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801107:	eb 1d                	jmp    801126 <strlcpy+0x42>
			*dst++ = *src++;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801115:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801119:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80111d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801121:	0f b6 12             	movzbl (%rdx),%edx
  801124:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801126:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80112b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801130:	74 0b                	je     80113d <strlcpy+0x59>
  801132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	84 c0                	test   %al,%al
  80113b:	75 cc                	jne    801109 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801144:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114c:	48 29 c2             	sub    %rax,%rdx
  80114f:	48 89 d0             	mov    %rdx,%rax
}
  801152:	c9                   	leaveq 
  801153:	c3                   	retq   

0000000000801154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	48 83 ec 10          	sub    $0x10,%rsp
  80115c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801160:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801164:	eb 0a                	jmp    801170 <strcmp+0x1c>
		p++, q++;
  801166:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80116b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	84 c0                	test   %al,%al
  801179:	74 12                	je     80118d <strcmp+0x39>
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	0f b6 10             	movzbl (%rax),%edx
  801182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801186:	0f b6 00             	movzbl (%rax),%eax
  801189:	38 c2                	cmp    %al,%dl
  80118b:	74 d9                	je     801166 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	0f b6 d0             	movzbl %al,%edx
  801197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119b:	0f b6 00             	movzbl (%rax),%eax
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	29 c2                	sub    %eax,%edx
  8011a3:	89 d0                	mov    %edx,%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 18          	sub    $0x18,%rsp
  8011af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011bb:	eb 0f                	jmp    8011cc <strncmp+0x25>
		n--, p++, q++;
  8011bd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011d1:	74 1d                	je     8011f0 <strncmp+0x49>
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	84 c0                	test   %al,%al
  8011dc:	74 12                	je     8011f0 <strncmp+0x49>
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	0f b6 10             	movzbl (%rax),%edx
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	0f b6 00             	movzbl (%rax),%eax
  8011ec:	38 c2                	cmp    %al,%dl
  8011ee:	74 cd                	je     8011bd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f5:	75 07                	jne    8011fe <strncmp+0x57>
		return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fc:	eb 18                	jmp    801216 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	0f b6 d0             	movzbl %al,%edx
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	0f b6 c0             	movzbl %al,%eax
  801212:	29 c2                	sub    %eax,%edx
  801214:	89 d0                	mov    %edx,%eax
}
  801216:	c9                   	leaveq 
  801217:	c3                   	retq   

0000000000801218 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	48 83 ec 0c          	sub    $0xc,%rsp
  801220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801224:	89 f0                	mov    %esi,%eax
  801226:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801229:	eb 17                	jmp    801242 <strchr+0x2a>
		if (*s == c)
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801235:	75 06                	jne    80123d <strchr+0x25>
			return (char *) s;
  801237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123b:	eb 15                	jmp    801252 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801246:	0f b6 00             	movzbl (%rax),%eax
  801249:	84 c0                	test   %al,%al
  80124b:	75 de                	jne    80122b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801252:	c9                   	leaveq 
  801253:	c3                   	retq   

0000000000801254 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801254:	55                   	push   %rbp
  801255:	48 89 e5             	mov    %rsp,%rbp
  801258:	48 83 ec 0c          	sub    $0xc,%rsp
  80125c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801260:	89 f0                	mov    %esi,%eax
  801262:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801265:	eb 13                	jmp    80127a <strfind+0x26>
		if (*s == c)
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801271:	75 02                	jne    801275 <strfind+0x21>
			break;
  801273:	eb 10                	jmp    801285 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801275:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	75 e2                	jne    801267 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 18          	sub    $0x18,%rsp
  801293:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801297:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80129a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80129e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a3:	75 06                	jne    8012ab <memset+0x20>
		return v;
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	eb 69                	jmp    801314 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	83 e0 03             	and    $0x3,%eax
  8012b2:	48 85 c0             	test   %rax,%rax
  8012b5:	75 48                	jne    8012ff <memset+0x74>
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	83 e0 03             	and    $0x3,%eax
  8012be:	48 85 c0             	test   %rax,%rax
  8012c1:	75 3c                	jne    8012ff <memset+0x74>
		c &= 0xFF;
  8012c3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012cd:	c1 e0 18             	shl    $0x18,%eax
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d5:	c1 e0 10             	shl    $0x10,%eax
  8012d8:	09 c2                	or     %eax,%edx
  8012da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012dd:	c1 e0 08             	shl    $0x8,%eax
  8012e0:	09 d0                	or     %edx,%eax
  8012e2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e9:	48 c1 e8 02          	shr    $0x2,%rax
  8012ed:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f7:	48 89 d7             	mov    %rdx,%rdi
  8012fa:	fc                   	cld    
  8012fb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012fd:	eb 11                	jmp    801310 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801306:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80130a:	48 89 d7             	mov    %rdx,%rdi
  80130d:	fc                   	cld    
  80130e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801314:	c9                   	leaveq 
  801315:	c3                   	retq   

0000000000801316 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	48 83 ec 28          	sub    $0x28,%rsp
  80131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80132a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801342:	0f 83 88 00 00 00    	jae    8013d0 <memmove+0xba>
  801348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801350:	48 01 d0             	add    %rdx,%rax
  801353:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801357:	76 77                	jbe    8013d0 <memmove+0xba>
		s += n;
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801365:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	48 85 c0             	test   %rax,%rax
  801373:	75 3b                	jne    8013b0 <memmove+0x9a>
  801375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801379:	83 e0 03             	and    $0x3,%eax
  80137c:	48 85 c0             	test   %rax,%rax
  80137f:	75 2f                	jne    8013b0 <memmove+0x9a>
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	83 e0 03             	and    $0x3,%eax
  801388:	48 85 c0             	test   %rax,%rax
  80138b:	75 23                	jne    8013b0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80138d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801391:	48 83 e8 04          	sub    $0x4,%rax
  801395:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801399:	48 83 ea 04          	sub    $0x4,%rdx
  80139d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013a1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013a5:	48 89 c7             	mov    %rax,%rdi
  8013a8:	48 89 d6             	mov    %rdx,%rsi
  8013ab:	fd                   	std    
  8013ac:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013ae:	eb 1d                	jmp    8013cd <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 89 d7             	mov    %rdx,%rdi
  8013c7:	48 89 c1             	mov    %rax,%rcx
  8013ca:	fd                   	std    
  8013cb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013cd:	fc                   	cld    
  8013ce:	eb 57                	jmp    801427 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	83 e0 03             	and    $0x3,%eax
  8013d7:	48 85 c0             	test   %rax,%rax
  8013da:	75 36                	jne    801412 <memmove+0xfc>
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	83 e0 03             	and    $0x3,%eax
  8013e3:	48 85 c0             	test   %rax,%rax
  8013e6:	75 2a                	jne    801412 <memmove+0xfc>
  8013e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ec:	83 e0 03             	and    $0x3,%eax
  8013ef:	48 85 c0             	test   %rax,%rax
  8013f2:	75 1e                	jne    801412 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	48 c1 e8 02          	shr    $0x2,%rax
  8013fc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801403:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801407:	48 89 c7             	mov    %rax,%rdi
  80140a:	48 89 d6             	mov    %rdx,%rsi
  80140d:	fc                   	cld    
  80140e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801410:	eb 15                	jmp    801427 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801416:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80141e:	48 89 c7             	mov    %rax,%rdi
  801421:	48 89 d6             	mov    %rdx,%rsi
  801424:	fc                   	cld    
  801425:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80142b:	c9                   	leaveq 
  80142c:	c3                   	retq   

000000000080142d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80142d:	55                   	push   %rbp
  80142e:	48 89 e5             	mov    %rsp,%rbp
  801431:	48 83 ec 18          	sub    $0x18,%rsp
  801435:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801439:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80143d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801445:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	48 89 ce             	mov    %rcx,%rsi
  801450:	48 89 c7             	mov    %rax,%rdi
  801453:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80145a:	00 00 00 
  80145d:	ff d0                	callq  *%rax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80147d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801485:	eb 36                	jmp    8014bd <memcmp+0x5c>
		if (*s1 != *s2)
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	0f b6 10             	movzbl (%rax),%edx
  80148e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 1a                	je     8014b3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	0f b6 d0             	movzbl %al,%edx
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	0f b6 c0             	movzbl %al,%eax
  8014ad:	29 c2                	sub    %eax,%edx
  8014af:	89 d0                	mov    %edx,%eax
  8014b1:	eb 20                	jmp    8014d3 <memcmp+0x72>
		s1++, s2++;
  8014b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014c9:	48 85 c0             	test   %rax,%rax
  8014cc:	75 b9                	jne    801487 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 28          	sub    $0x28,%rsp
  8014dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f0:	48 01 d0             	add    %rdx,%rax
  8014f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014f7:	eb 15                	jmp    80150e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fd:	0f b6 10             	movzbl (%rax),%edx
  801500:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801503:	38 c2                	cmp    %al,%dl
  801505:	75 02                	jne    801509 <memfind+0x34>
			break;
  801507:	eb 0f                	jmp    801518 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801509:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801512:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801516:	72 e1                	jb     8014f9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 34          	sub    $0x34,%rsp
  801526:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80152e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801538:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80153f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801540:	eb 05                	jmp    801547 <strtol+0x29>
		s++;
  801542:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	3c 20                	cmp    $0x20,%al
  801550:	74 f0                	je     801542 <strtol+0x24>
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3c 09                	cmp    $0x9,%al
  80155b:	74 e5                	je     801542 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80155d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801561:	0f b6 00             	movzbl (%rax),%eax
  801564:	3c 2b                	cmp    $0x2b,%al
  801566:	75 07                	jne    80156f <strtol+0x51>
		s++;
  801568:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80156d:	eb 17                	jmp    801586 <strtol+0x68>
	else if (*s == '-')
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	3c 2d                	cmp    $0x2d,%al
  801578:	75 0c                	jne    801586 <strtol+0x68>
		s++, neg = 1;
  80157a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801586:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80158a:	74 06                	je     801592 <strtol+0x74>
  80158c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801590:	75 28                	jne    8015ba <strtol+0x9c>
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	3c 30                	cmp    $0x30,%al
  80159b:	75 1d                	jne    8015ba <strtol+0x9c>
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	48 83 c0 01          	add    $0x1,%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	3c 78                	cmp    $0x78,%al
  8015aa:	75 0e                	jne    8015ba <strtol+0x9c>
		s += 2, base = 16;
  8015ac:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015b1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015b8:	eb 2c                	jmp    8015e6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015be:	75 19                	jne    8015d9 <strtol+0xbb>
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	3c 30                	cmp    $0x30,%al
  8015c9:	75 0e                	jne    8015d9 <strtol+0xbb>
		s++, base = 8;
  8015cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015d7:	eb 0d                	jmp    8015e6 <strtol+0xc8>
	else if (base == 0)
  8015d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015dd:	75 07                	jne    8015e6 <strtol+0xc8>
		base = 10;
  8015df:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	3c 2f                	cmp    $0x2f,%al
  8015ef:	7e 1d                	jle    80160e <strtol+0xf0>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 39                	cmp    $0x39,%al
  8015fa:	7f 12                	jg     80160e <strtol+0xf0>
			dig = *s - '0';
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	0f be c0             	movsbl %al,%eax
  801606:	83 e8 30             	sub    $0x30,%eax
  801609:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80160c:	eb 4e                	jmp    80165c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80160e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801612:	0f b6 00             	movzbl (%rax),%eax
  801615:	3c 60                	cmp    $0x60,%al
  801617:	7e 1d                	jle    801636 <strtol+0x118>
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 7a                	cmp    $0x7a,%al
  801622:	7f 12                	jg     801636 <strtol+0x118>
			dig = *s - 'a' + 10;
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	0f be c0             	movsbl %al,%eax
  80162e:	83 e8 57             	sub    $0x57,%eax
  801631:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801634:	eb 26                	jmp    80165c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	3c 40                	cmp    $0x40,%al
  80163f:	7e 48                	jle    801689 <strtol+0x16b>
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	3c 5a                	cmp    $0x5a,%al
  80164a:	7f 3d                	jg     801689 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	0f be c0             	movsbl %al,%eax
  801656:	83 e8 37             	sub    $0x37,%eax
  801659:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80165c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80165f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801662:	7c 02                	jl     801666 <strtol+0x148>
			break;
  801664:	eb 23                	jmp    801689 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801666:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80166e:	48 98                	cltq   
  801670:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801675:	48 89 c2             	mov    %rax,%rdx
  801678:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80167b:	48 98                	cltq   
  80167d:	48 01 d0             	add    %rdx,%rax
  801680:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801684:	e9 5d ff ff ff       	jmpq   8015e6 <strtol+0xc8>

	if (endptr)
  801689:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80168e:	74 0b                	je     80169b <strtol+0x17d>
		*endptr = (char *) s;
  801690:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801694:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801698:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80169b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80169f:	74 09                	je     8016aa <strtol+0x18c>
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	48 f7 d8             	neg    %rax
  8016a8:	eb 04                	jmp    8016ae <strtol+0x190>
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 30          	sub    $0x30,%rsp
  8016b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016c8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016d2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016d6:	75 06                	jne    8016de <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	eb 6b                	jmp    801749 <strstr+0x99>

	len = strlen(str);
  8016de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e2:	48 89 c7             	mov    %rax,%rdi
  8016e5:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8016ec:	00 00 00 
  8016ef:	ff d0                	callq  *%rax
  8016f1:	48 98                	cltq   
  8016f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801703:	0f b6 00             	movzbl (%rax),%eax
  801706:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801709:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80170d:	75 07                	jne    801716 <strstr+0x66>
				return (char *) 0;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	eb 33                	jmp    801749 <strstr+0x99>
		} while (sc != c);
  801716:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80171a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80171d:	75 d8                	jne    8016f7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80171f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801723:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	48 89 ce             	mov    %rcx,%rsi
  80172e:	48 89 c7             	mov    %rax,%rdi
  801731:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
  80173d:	85 c0                	test   %eax,%eax
  80173f:	75 b6                	jne    8016f7 <strstr+0x47>

	return (char *) (in - 1);
  801741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801745:	48 83 e8 01          	sub    $0x1,%rax
}
  801749:	c9                   	leaveq 
  80174a:	c3                   	retq   

000000000080174b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80174b:	55                   	push   %rbp
  80174c:	48 89 e5             	mov    %rsp,%rbp
  80174f:	53                   	push   %rbx
  801750:	48 83 ec 48          	sub    $0x48,%rsp
  801754:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801757:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80175a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80175e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801762:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801766:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80176d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801771:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801775:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801779:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80177d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801781:	4c 89 c3             	mov    %r8,%rbx
  801784:	cd 30                	int    $0x30
  801786:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80178a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80178e:	74 3e                	je     8017ce <syscall+0x83>
  801790:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801795:	7e 37                	jle    8017ce <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179e:	49 89 d0             	mov    %rdx,%r8
  8017a1:	89 c1                	mov    %eax,%ecx
  8017a3:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  8017aa:	00 00 00 
  8017ad:	be 23 00 00 00       	mov    $0x23,%esi
  8017b2:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  8017b9:	00 00 00 
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	49 b9 04 02 80 00 00 	movabs $0x800204,%r9
  8017c8:	00 00 00 
  8017cb:	41 ff d1             	callq  *%r9

	return ret;
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017d2:	48 83 c4 48          	add    $0x48,%rsp
  8017d6:	5b                   	pop    %rbx
  8017d7:	5d                   	pop    %rbp
  8017d8:	c3                   	retq   

00000000008017d9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 20          	sub    $0x20,%rsp
  8017e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f8:	00 
  8017f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801805:	48 89 d1             	mov    %rdx,%rcx
  801808:	48 89 c2             	mov    %rax,%rdx
  80180b:	be 00 00 00 00       	mov    $0x0,%esi
  801810:	bf 00 00 00 00       	mov    $0x0,%edi
  801815:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80181c:	00 00 00 
  80181f:	ff d0                	callq  *%rax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <sys_cgetc>:

int
sys_cgetc(void)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80182b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801832:	00 
  801833:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801839:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801844:	ba 00 00 00 00       	mov    $0x0,%edx
  801849:	be 00 00 00 00       	mov    $0x0,%esi
  80184e:	bf 01 00 00 00       	mov    $0x1,%edi
  801853:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80185a:	00 00 00 
  80185d:	ff d0                	callq  *%rax
}
  80185f:	c9                   	leaveq 
  801860:	c3                   	retq   

0000000000801861 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801861:	55                   	push   %rbp
  801862:	48 89 e5             	mov    %rsp,%rbp
  801865:	48 83 ec 10          	sub    $0x10,%rsp
  801869:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801878:	00 
  801879:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801885:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188a:	48 89 c2             	mov    %rax,%rdx
  80188d:	be 01 00 00 00       	mov    $0x1,%esi
  801892:	bf 03 00 00 00       	mov    $0x3,%edi
  801897:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b4:	00 
  8018b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	be 00 00 00 00       	mov    $0x0,%esi
  8018d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8018d5:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	callq  *%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <sys_yield>:

void
sys_yield(void)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f2:	00 
  8018f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801904:	ba 00 00 00 00       	mov    $0x0,%edx
  801909:	be 00 00 00 00       	mov    $0x0,%esi
  80190e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801913:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
}
  80191f:	c9                   	leaveq 
  801920:	c3                   	retq   

0000000000801921 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801921:	55                   	push   %rbp
  801922:	48 89 e5             	mov    %rsp,%rbp
  801925:	48 83 ec 20          	sub    $0x20,%rsp
  801929:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801930:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801936:	48 63 c8             	movslq %eax,%rcx
  801939:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801940:	48 98                	cltq   
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	49 89 c8             	mov    %rcx,%r8
  801953:	48 89 d1             	mov    %rdx,%rcx
  801956:	48 89 c2             	mov    %rax,%rdx
  801959:	be 01 00 00 00       	mov    $0x1,%esi
  80195e:	bf 04 00 00 00       	mov    $0x4,%edi
  801963:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80196a:	00 00 00 
  80196d:	ff d0                	callq  *%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	48 83 ec 30          	sub    $0x30,%rsp
  801979:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801980:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801983:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801987:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80198b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80198e:	48 63 c8             	movslq %eax,%rcx
  801991:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801995:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801998:	48 63 f0             	movslq %eax,%rsi
  80199b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a2:	48 98                	cltq   
  8019a4:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019a8:	49 89 f9             	mov    %rdi,%r9
  8019ab:	49 89 f0             	mov    %rsi,%r8
  8019ae:	48 89 d1             	mov    %rdx,%rcx
  8019b1:	48 89 c2             	mov    %rax,%rdx
  8019b4:	be 01 00 00 00       	mov    $0x1,%esi
  8019b9:	bf 05 00 00 00       	mov    $0x5,%edi
  8019be:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 20          	sub    $0x20,%rsp
  8019d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e2:	48 98                	cltq   
  8019e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019eb:	00 
  8019ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f8:	48 89 d1             	mov    %rdx,%rcx
  8019fb:	48 89 c2             	mov    %rax,%rdx
  8019fe:	be 01 00 00 00       	mov    $0x1,%esi
  801a03:	bf 06 00 00 00       	mov    $0x6,%edi
  801a08:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 10          	sub    $0x10,%rsp
  801a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a21:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a27:	48 63 d0             	movslq %eax,%rdx
  801a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2d:	48 98                	cltq   
  801a2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a36:	00 
  801a37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a43:	48 89 d1             	mov    %rdx,%rcx
  801a46:	48 89 c2             	mov    %rax,%rdx
  801a49:	be 01 00 00 00       	mov    $0x1,%esi
  801a4e:	bf 08 00 00 00       	mov    $0x8,%edi
  801a53:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 20          	sub    $0x20,%rsp
  801a69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a80:	00 
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	48 89 d1             	mov    %rdx,%rcx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 09 00 00 00       	mov    $0x9,%edi
  801a9d:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 20          	sub    $0x20,%rsp
  801ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ae7:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b08:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0e:	48 63 f0             	movslq %eax,%rsi
  801b11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b25:	00 
  801b26:	49 89 f1             	mov    %rsi,%r9
  801b29:	49 89 c8             	mov    %rcx,%r8
  801b2c:	48 89 d1             	mov    %rdx,%rcx
  801b2f:	48 89 c2             	mov    %rax,%rdx
  801b32:	be 00 00 00 00       	mov    $0x0,%esi
  801b37:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b3c:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 10          	sub    $0x10,%rsp
  801b52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b80:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 20          	sub    $0x20,%rsp
  801b96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bad:	00 
  801bae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bba:	48 89 d1             	mov    %rdx,%rcx
  801bbd:	48 89 c2             	mov    %rax,%rdx
  801bc0:	be 01 00 00 00       	mov    $0x1,%esi
  801bc5:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bca:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801bd1:	00 00 00 
  801bd4:	ff d0                	callq  *%rax
}
  801bd6:	c9                   	leaveq 
  801bd7:	c3                   	retq   

0000000000801bd8 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
  801bdc:	48 83 ec 10          	sub    $0x10,%rsp
  801be0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bef:	00 
  801bf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c01:	48 89 c2             	mov    %rax,%rdx
  801c04:	be 00 00 00 00       	mov    $0x0,%esi
  801c09:	bf 10 00 00 00       	mov    $0x10,%edi
  801c0e:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	callq  *%rax
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2b:	00 
  801c2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c42:	be 00 00 00 00       	mov    $0x0,%esi
  801c47:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c4c:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	callq  *%rax
}
  801c58:	c9                   	leaveq 
  801c59:	c3                   	retq   

0000000000801c5a <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801c5a:	55                   	push   %rbp
  801c5b:	48 89 e5             	mov    %rsp,%rbp
  801c5e:	48 83 ec 10          	sub    $0x10,%rsp
  801c62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801c66:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801c6d:	00 00 00 
  801c70:	48 8b 00             	mov    (%rax),%rax
  801c73:	48 85 c0             	test   %rax,%rax
  801c76:	0f 85 84 00 00 00    	jne    801d00 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801c7c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801c83:	00 00 00 
  801c86:	48 8b 00             	mov    (%rax),%rax
  801c89:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c8f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c94:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801c99:	89 c7                	mov    %eax,%edi
  801c9b:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	79 2a                	jns    801cd5 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801cab:	48 ba 58 46 80 00 00 	movabs $0x804658,%rdx
  801cb2:	00 00 00 
  801cb5:	be 23 00 00 00       	mov    $0x23,%esi
  801cba:	48 bf 7f 46 80 00 00 	movabs $0x80467f,%rdi
  801cc1:	00 00 00 
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc9:	48 b9 04 02 80 00 00 	movabs $0x800204,%rcx
  801cd0:	00 00 00 
  801cd3:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801cd5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801cdc:	00 00 00 
  801cdf:	48 8b 00             	mov    (%rax),%rax
  801ce2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ce8:	48 be 13 1d 80 00 00 	movabs $0x801d13,%rsi
  801cef:	00 00 00 
  801cf2:	89 c7                	mov    %eax,%edi
  801cf4:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801d00:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801d07:	00 00 00 
  801d0a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d0e:	48 89 10             	mov    %rdx,(%rax)
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801d13:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801d16:	48 a1 10 70 80 00 00 	movabs 0x807010,%rax
  801d1d:	00 00 00 
call *%rax
  801d20:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  801d22:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801d29:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801d2a:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801d31:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801d32:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801d36:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801d39:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801d40:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801d41:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801d45:	4c 8b 3c 24          	mov    (%rsp),%r15
  801d49:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801d4e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801d53:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801d58:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801d5d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801d62:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801d67:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801d6c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801d71:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801d76:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801d7b:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801d80:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801d85:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801d8a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801d8f:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801d93:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801d97:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801d98:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801d99:	c3                   	retq   

0000000000801d9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 08          	sub    $0x8,%rsp
  801da2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801daa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801db1:	ff ff ff 
  801db4:	48 01 d0             	add    %rdx,%rax
  801db7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dbb:	c9                   	leaveq 
  801dbc:	c3                   	retq   

0000000000801dbd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dbd:	55                   	push   %rbp
  801dbe:	48 89 e5             	mov    %rsp,%rbp
  801dc1:	48 83 ec 08          	sub    $0x8,%rsp
  801dc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcd:	48 89 c7             	mov    %rax,%rdi
  801dd0:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
  801ddc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801de2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 18          	sub    $0x18,%rsp
  801df0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801df4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dfb:	eb 6b                	jmp    801e68 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e00:	48 98                	cltq   
  801e02:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e08:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e14:	48 c1 e8 15          	shr    $0x15,%rax
  801e18:	48 89 c2             	mov    %rax,%rdx
  801e1b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e22:	01 00 00 
  801e25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e29:	83 e0 01             	and    $0x1,%eax
  801e2c:	48 85 c0             	test   %rax,%rax
  801e2f:	74 21                	je     801e52 <fd_alloc+0x6a>
  801e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e35:	48 c1 e8 0c          	shr    $0xc,%rax
  801e39:	48 89 c2             	mov    %rax,%rdx
  801e3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e43:	01 00 00 
  801e46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4a:	83 e0 01             	and    $0x1,%eax
  801e4d:	48 85 c0             	test   %rax,%rax
  801e50:	75 12                	jne    801e64 <fd_alloc+0x7c>
			*fd_store = fd;
  801e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	eb 1a                	jmp    801e7e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e68:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e6c:	7e 8f                	jle    801dfd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e72:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e79:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e7e:	c9                   	leaveq 
  801e7f:	c3                   	retq   

0000000000801e80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e80:	55                   	push   %rbp
  801e81:	48 89 e5             	mov    %rsp,%rbp
  801e84:	48 83 ec 20          	sub    $0x20,%rsp
  801e88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e93:	78 06                	js     801e9b <fd_lookup+0x1b>
  801e95:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e99:	7e 07                	jle    801ea2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea0:	eb 6c                	jmp    801f0e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ea2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea5:	48 98                	cltq   
  801ea7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ead:	48 c1 e0 0c          	shl    $0xc,%rax
  801eb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb9:	48 c1 e8 15          	shr    $0x15,%rax
  801ebd:	48 89 c2             	mov    %rax,%rdx
  801ec0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ec7:	01 00 00 
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	83 e0 01             	and    $0x1,%eax
  801ed1:	48 85 c0             	test   %rax,%rax
  801ed4:	74 21                	je     801ef7 <fd_lookup+0x77>
  801ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eda:	48 c1 e8 0c          	shr    $0xc,%rax
  801ede:	48 89 c2             	mov    %rax,%rdx
  801ee1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee8:	01 00 00 
  801eeb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eef:	83 e0 01             	and    $0x1,%eax
  801ef2:	48 85 c0             	test   %rax,%rax
  801ef5:	75 07                	jne    801efe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ef7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801efc:	eb 10                	jmp    801f0e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f06:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0e:	c9                   	leaveq 
  801f0f:	c3                   	retq   

0000000000801f10 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f10:	55                   	push   %rbp
  801f11:	48 89 e5             	mov    %rsp,%rbp
  801f14:	48 83 ec 30          	sub    $0x30,%rsp
  801f18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f1c:	89 f0                	mov    %esi,%eax
  801f1e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	48 89 c7             	mov    %rax,%rdi
  801f28:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	callq  *%rax
  801f34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f38:	48 89 d6             	mov    %rdx,%rsi
  801f3b:	89 c7                	mov    %eax,%edi
  801f3d:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
  801f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f50:	78 0a                	js     801f5c <fd_close+0x4c>
	    || fd != fd2)
  801f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f56:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f5a:	74 12                	je     801f6e <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f5c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f60:	74 05                	je     801f67 <fd_close+0x57>
  801f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f65:	eb 05                	jmp    801f6c <fd_close+0x5c>
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	eb 69                	jmp    801fd7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f72:	8b 00                	mov    (%rax),%eax
  801f74:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f78:	48 89 d6             	mov    %rdx,%rsi
  801f7b:	89 c7                	mov    %eax,%edi
  801f7d:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
  801f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f90:	78 2a                	js     801fbc <fd_close+0xac>
		if (dev->dev_close)
  801f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f96:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f9a:	48 85 c0             	test   %rax,%rax
  801f9d:	74 16                	je     801fb5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fa7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fab:	48 89 d7             	mov    %rdx,%rdi
  801fae:	ff d0                	callq  *%rax
  801fb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb3:	eb 07                	jmp    801fbc <fd_close+0xac>
		else
			r = 0;
  801fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc0:	48 89 c6             	mov    %rax,%rsi
  801fc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc8:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	callq  *%rax
	return r;
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fd7:	c9                   	leaveq 
  801fd8:	c3                   	retq   

0000000000801fd9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 20          	sub    $0x20,%rsp
  801fe1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fe4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fe8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fef:	eb 41                	jmp    802032 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ff1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ff8:	00 00 00 
  801ffb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ffe:	48 63 d2             	movslq %edx,%rdx
  802001:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802005:	8b 00                	mov    (%rax),%eax
  802007:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80200a:	75 22                	jne    80202e <dev_lookup+0x55>
			*dev = devtab[i];
  80200c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802013:	00 00 00 
  802016:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802019:	48 63 d2             	movslq %edx,%rdx
  80201c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802024:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	eb 60                	jmp    80208e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80202e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802032:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802039:	00 00 00 
  80203c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203f:	48 63 d2             	movslq %edx,%rdx
  802042:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802046:	48 85 c0             	test   %rax,%rax
  802049:	75 a6                	jne    801ff1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80204b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802052:	00 00 00 
  802055:	48 8b 00             	mov    (%rax),%rax
  802058:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80205e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802061:	89 c6                	mov    %eax,%esi
  802063:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  80206a:	00 00 00 
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  802079:	00 00 00 
  80207c:	ff d1                	callq  *%rcx
	*dev = 0;
  80207e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802082:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <close>:

int
close(int fdnum)
{
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 83 ec 20          	sub    $0x20,%rsp
  802098:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80209f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a2:	48 89 d6             	mov    %rdx,%rsi
  8020a5:	89 c7                	mov    %eax,%edi
  8020a7:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
  8020b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ba:	79 05                	jns    8020c1 <close+0x31>
		return r;
  8020bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bf:	eb 18                	jmp    8020d9 <close+0x49>
	else
		return fd_close(fd, 1);
  8020c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c5:	be 01 00 00 00       	mov    $0x1,%esi
  8020ca:	48 89 c7             	mov    %rax,%rdi
  8020cd:	48 b8 10 1f 80 00 00 	movabs $0x801f10,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	callq  *%rax
}
  8020d9:	c9                   	leaveq 
  8020da:	c3                   	retq   

00000000008020db <close_all>:

void
close_all(void)
{
  8020db:	55                   	push   %rbp
  8020dc:	48 89 e5             	mov    %rsp,%rbp
  8020df:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ea:	eb 15                	jmp    802101 <close_all+0x26>
		close(i);
  8020ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802101:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802105:	7e e5                	jle    8020ec <close_all+0x11>
		close(i);
}
  802107:	c9                   	leaveq 
  802108:	c3                   	retq   

0000000000802109 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802109:	55                   	push   %rbp
  80210a:	48 89 e5             	mov    %rsp,%rbp
  80210d:	48 83 ec 40          	sub    $0x40,%rsp
  802111:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802114:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802117:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80211b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80211e:	48 89 d6             	mov    %rdx,%rsi
  802121:	89 c7                	mov    %eax,%edi
  802123:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax
  80212f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802132:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802136:	79 08                	jns    802140 <dup+0x37>
		return r;
  802138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213b:	e9 70 01 00 00       	jmpq   8022b0 <dup+0x1a7>
	close(newfdnum);
  802140:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802143:	89 c7                	mov    %eax,%edi
  802145:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802151:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802154:	48 98                	cltq   
  802156:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80215c:	48 c1 e0 0c          	shl    $0xc,%rax
  802160:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802168:	48 89 c7             	mov    %rax,%rdi
  80216b:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
  802177:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80217b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217f:	48 89 c7             	mov    %rax,%rdi
  802182:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 c1 e8 15          	shr    $0x15,%rax
  80219a:	48 89 c2             	mov    %rax,%rdx
  80219d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021a4:	01 00 00 
  8021a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ab:	83 e0 01             	and    $0x1,%eax
  8021ae:	48 85 c0             	test   %rax,%rax
  8021b1:	74 73                	je     802226 <dup+0x11d>
  8021b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8021bb:	48 89 c2             	mov    %rax,%rdx
  8021be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c5:	01 00 00 
  8021c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cc:	83 e0 01             	and    $0x1,%eax
  8021cf:	48 85 c0             	test   %rax,%rax
  8021d2:	74 52                	je     802226 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e6:	01 00 00 
  8021e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fc:	41 89 c8             	mov    %ecx,%r8d
  8021ff:	48 89 d1             	mov    %rdx,%rcx
  802202:	ba 00 00 00 00       	mov    $0x0,%edx
  802207:	48 89 c6             	mov    %rax,%rsi
  80220a:	bf 00 00 00 00       	mov    $0x0,%edi
  80220f:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  802216:	00 00 00 
  802219:	ff d0                	callq  *%rax
  80221b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802222:	79 02                	jns    802226 <dup+0x11d>
			goto err;
  802224:	eb 57                	jmp    80227d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222a:	48 c1 e8 0c          	shr    $0xc,%rax
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802238:	01 00 00 
  80223b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223f:	25 07 0e 00 00       	and    $0xe07,%eax
  802244:	89 c1                	mov    %eax,%ecx
  802246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224e:	41 89 c8             	mov    %ecx,%r8d
  802251:	48 89 d1             	mov    %rdx,%rcx
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
  802259:	48 89 c6             	mov    %rax,%rsi
  80225c:	bf 00 00 00 00       	mov    $0x0,%edi
  802261:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802274:	79 02                	jns    802278 <dup+0x16f>
		goto err;
  802276:	eb 05                	jmp    80227d <dup+0x174>

	return newfdnum;
  802278:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80227b:	eb 33                	jmp    8022b0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80227d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802281:	48 89 c6             	mov    %rax,%rsi
  802284:	bf 00 00 00 00       	mov    $0x0,%edi
  802289:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802295:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802299:	48 89 c6             	mov    %rax,%rsi
  80229c:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a1:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
	return r;
  8022ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 40          	sub    $0x40,%rsp
  8022ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022cc:	48 89 d6             	mov    %rdx,%rsi
  8022cf:	89 c7                	mov    %eax,%edi
  8022d1:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	78 24                	js     80230a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ea:	8b 00                	mov    (%rax),%eax
  8022ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f0:	48 89 d6             	mov    %rdx,%rsi
  8022f3:	89 c7                	mov    %eax,%edi
  8022f5:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802304:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802308:	79 05                	jns    80230f <read+0x5d>
		return r;
  80230a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230d:	eb 76                	jmp    802385 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80230f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802313:	8b 40 08             	mov    0x8(%rax),%eax
  802316:	83 e0 03             	and    $0x3,%eax
  802319:	83 f8 01             	cmp    $0x1,%eax
  80231c:	75 3a                	jne    802358 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80231e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802325:	00 00 00 
  802328:	48 8b 00             	mov    (%rax),%rax
  80232b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802331:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802334:	89 c6                	mov    %eax,%esi
  802336:	48 bf af 46 80 00 00 	movabs $0x8046af,%rdi
  80233d:	00 00 00 
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  80234c:	00 00 00 
  80234f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802356:	eb 2d                	jmp    802385 <read+0xd3>
	}
	if (!dev->dev_read)
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802360:	48 85 c0             	test   %rax,%rax
  802363:	75 07                	jne    80236c <read+0xba>
		return -E_NOT_SUPP;
  802365:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80236a:	eb 19                	jmp    802385 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80236c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802370:	48 8b 40 10          	mov    0x10(%rax),%rax
  802374:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802378:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80237c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802380:	48 89 cf             	mov    %rcx,%rdi
  802383:	ff d0                	callq  *%rax
}
  802385:	c9                   	leaveq 
  802386:	c3                   	retq   

0000000000802387 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802387:	55                   	push   %rbp
  802388:	48 89 e5             	mov    %rsp,%rbp
  80238b:	48 83 ec 30          	sub    $0x30,%rsp
  80238f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802392:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802396:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80239a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023a1:	eb 49                	jmp    8023ec <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a6:	48 98                	cltq   
  8023a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023ac:	48 29 c2             	sub    %rax,%rdx
  8023af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b2:	48 63 c8             	movslq %eax,%rcx
  8023b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b9:	48 01 c1             	add    %rax,%rcx
  8023bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023bf:	48 89 ce             	mov    %rcx,%rsi
  8023c2:	89 c7                	mov    %eax,%edi
  8023c4:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  8023cb:	00 00 00 
  8023ce:	ff d0                	callq  *%rax
  8023d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d7:	79 05                	jns    8023de <readn+0x57>
			return m;
  8023d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023dc:	eb 1c                	jmp    8023fa <readn+0x73>
		if (m == 0)
  8023de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023e2:	75 02                	jne    8023e6 <readn+0x5f>
			break;
  8023e4:	eb 11                	jmp    8023f7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ef:	48 98                	cltq   
  8023f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023f5:	72 ac                	jb     8023a3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 40          	sub    $0x40,%rsp
  802404:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802407:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80240b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802413:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802416:	48 89 d6             	mov    %rdx,%rsi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	78 24                	js     802454 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802434:	8b 00                	mov    (%rax),%eax
  802436:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	79 05                	jns    802459 <write+0x5d>
		return r;
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	eb 75                	jmp    8024ce <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	8b 40 08             	mov    0x8(%rax),%eax
  802460:	83 e0 03             	and    $0x3,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	75 3a                	jne    8024a1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802467:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80246e:	00 00 00 
  802471:	48 8b 00             	mov    (%rax),%rax
  802474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  802486:	00 00 00 
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
  80248e:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  802495:	00 00 00 
  802498:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80249a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249f:	eb 2d                	jmp    8024ce <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a9:	48 85 c0             	test   %rax,%rax
  8024ac:	75 07                	jne    8024b5 <write+0xb9>
		return -E_NOT_SUPP;
  8024ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b3:	eb 19                	jmp    8024ce <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024c9:	48 89 cf             	mov    %rcx,%rdi
  8024cc:	ff d0                	callq  *%rax
}
  8024ce:	c9                   	leaveq 
  8024cf:	c3                   	retq   

00000000008024d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024d0:	55                   	push   %rbp
  8024d1:	48 89 e5             	mov    %rsp,%rbp
  8024d4:	48 83 ec 18          	sub    $0x18,%rsp
  8024d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e5:	48 89 d6             	mov    %rdx,%rsi
  8024e8:	89 c7                	mov    %eax,%edi
  8024ea:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax
  8024f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fd:	79 05                	jns    802504 <seek+0x34>
		return r;
  8024ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802502:	eb 0f                	jmp    802513 <seek+0x43>
	fd->fd_offset = offset;
  802504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802508:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80250b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 30          	sub    $0x30,%rsp
  80251d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802520:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802523:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802527:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80252a:	48 89 d6             	mov    %rdx,%rsi
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax
  80253b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802542:	78 24                	js     802568 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802548:	8b 00                	mov    (%rax),%eax
  80254a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254e:	48 89 d6             	mov    %rdx,%rsi
  802551:	89 c7                	mov    %eax,%edi
  802553:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  80255a:	00 00 00 
  80255d:	ff d0                	callq  *%rax
  80255f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802566:	79 05                	jns    80256d <ftruncate+0x58>
		return r;
  802568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256b:	eb 72                	jmp    8025df <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802571:	8b 40 08             	mov    0x8(%rax),%eax
  802574:	83 e0 03             	and    $0x3,%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	75 3a                	jne    8025b5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80257b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802582:	00 00 00 
  802585:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802588:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80258e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802591:	89 c6                	mov    %eax,%esi
  802593:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  80259a:	00 00 00 
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  8025a9:	00 00 00 
  8025ac:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b3:	eb 2a                	jmp    8025df <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025bd:	48 85 c0             	test   %rax,%rax
  8025c0:	75 07                	jne    8025c9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c7:	eb 16                	jmp    8025df <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025d5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025d8:	89 ce                	mov    %ecx,%esi
  8025da:	48 89 d7             	mov    %rdx,%rdi
  8025dd:	ff d0                	callq  *%rax
}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 30          	sub    $0x30,%rsp
  8025e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f7:	48 89 d6             	mov    %rdx,%rsi
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260f:	78 24                	js     802635 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802615:	8b 00                	mov    (%rax),%eax
  802617:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802633:	79 05                	jns    80263a <fstat+0x59>
		return r;
  802635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802638:	eb 5e                	jmp    802698 <fstat+0xb7>
	if (!dev->dev_stat)
  80263a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802642:	48 85 c0             	test   %rax,%rax
  802645:	75 07                	jne    80264e <fstat+0x6d>
		return -E_NOT_SUPP;
  802647:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80264c:	eb 4a                	jmp    802698 <fstat+0xb7>
	stat->st_name[0] = 0;
  80264e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802652:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802659:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802660:	00 00 00 
	stat->st_isdir = 0;
  802663:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802667:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80266e:	00 00 00 
	stat->st_dev = dev;
  802671:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802675:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802679:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	48 8b 40 28          	mov    0x28(%rax),%rax
  802688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80268c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802690:	48 89 ce             	mov    %rcx,%rsi
  802693:	48 89 d7             	mov    %rdx,%rdi
  802696:	ff d0                	callq  *%rax
}
  802698:	c9                   	leaveq 
  802699:	c3                   	retq   

000000000080269a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
  80269e:	48 83 ec 20          	sub    $0x20,%rsp
  8026a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ae:	be 00 00 00 00       	mov    $0x0,%esi
  8026b3:	48 89 c7             	mov    %rax,%rdi
  8026b6:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c9:	79 05                	jns    8026d0 <stat+0x36>
		return fd;
  8026cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ce:	eb 2f                	jmp    8026ff <stat+0x65>
	r = fstat(fd, stat);
  8026d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d7:	48 89 d6             	mov    %rdx,%rsi
  8026da:	89 c7                	mov    %eax,%edi
  8026dc:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ee:	89 c7                	mov    %eax,%edi
  8026f0:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
	return r;
  8026fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ff:	c9                   	leaveq 
  802700:	c3                   	retq   

0000000000802701 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
  802705:	48 83 ec 10          	sub    $0x10,%rsp
  802709:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80270c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802710:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802717:	00 00 00 
  80271a:	8b 00                	mov    (%rax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 1d                	jne    80273d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802720:	bf 01 00 00 00       	mov    $0x1,%edi
  802725:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax
  802731:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802738:	00 00 00 
  80273b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80273d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802744:	00 00 00 
  802747:	8b 00                	mov    (%rax),%eax
  802749:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80274c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802751:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802758:	00 00 00 
  80275b:	89 c7                	mov    %eax,%edi
  80275d:	48 b8 2c 3f 80 00 00 	movabs $0x803f2c,%rax
  802764:	00 00 00 
  802767:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276d:	ba 00 00 00 00       	mov    $0x0,%edx
  802772:	48 89 c6             	mov    %rax,%rsi
  802775:	bf 00 00 00 00       	mov    $0x0,%edi
  80277a:	48 b8 26 3e 80 00 00 	movabs $0x803e26,%rax
  802781:	00 00 00 
  802784:	ff d0                	callq  *%rax
}
  802786:	c9                   	leaveq 
  802787:	c3                   	retq   

0000000000802788 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802788:	55                   	push   %rbp
  802789:	48 89 e5             	mov    %rsp,%rbp
  80278c:	48 83 ec 30          	sub    $0x30,%rsp
  802790:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802794:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802797:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80279e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027b1:	75 08                	jne    8027bb <open+0x33>
	{
		return r;
  8027b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b6:	e9 f2 00 00 00       	jmpq   8028ad <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bf:	48 89 c7             	mov    %rax,%rdi
  8027c2:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8027c9:	00 00 00 
  8027cc:	ff d0                	callq  *%rax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8027d1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8027d8:	7e 0a                	jle    8027e4 <open+0x5c>
	{
		return -E_BAD_PATH;
  8027da:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027df:	e9 c9 00 00 00       	jmpq   8028ad <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8027e4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027eb:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8027ec:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8027f0:	48 89 c7             	mov    %rax,%rdi
  8027f3:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	callq  *%rax
  8027ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802806:	78 09                	js     802811 <open+0x89>
  802808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280c:	48 85 c0             	test   %rax,%rax
  80280f:	75 08                	jne    802819 <open+0x91>
		{
			return r;
  802811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802814:	e9 94 00 00 00       	jmpq   8028ad <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281d:	ba 00 04 00 00       	mov    $0x400,%edx
  802822:	48 89 c6             	mov    %rax,%rsi
  802825:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80282c:	00 00 00 
  80282f:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80283b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802842:	00 00 00 
  802845:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802848:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80284e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802852:	48 89 c6             	mov    %rax,%rsi
  802855:	bf 01 00 00 00       	mov    $0x1,%edi
  80285a:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286d:	79 2b                	jns    80289a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80286f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802873:	be 00 00 00 00       	mov    $0x0,%esi
  802878:	48 89 c7             	mov    %rax,%rdi
  80287b:	48 b8 10 1f 80 00 00 	movabs $0x801f10,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80288a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80288e:	79 05                	jns    802895 <open+0x10d>
			{
				return d;
  802890:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802893:	eb 18                	jmp    8028ad <open+0x125>
			}
			return r;
  802895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802898:	eb 13                	jmp    8028ad <open+0x125>
		}	
		return fd2num(fd_store);
  80289a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289e:	48 89 c7             	mov    %rax,%rdi
  8028a1:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028ad:	c9                   	leaveq 
  8028ae:	c3                   	retq   

00000000008028af <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028af:	55                   	push   %rbp
  8028b0:	48 89 e5             	mov    %rsp,%rbp
  8028b3:	48 83 ec 10          	sub    $0x10,%rsp
  8028b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c9:	00 00 00 
  8028cc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028ce:	be 00 00 00 00       	mov    $0x0,%esi
  8028d3:	bf 06 00 00 00       	mov    $0x6,%edi
  8028d8:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  8028df:	00 00 00 
  8028e2:	ff d0                	callq  *%rax
}
  8028e4:	c9                   	leaveq 
  8028e5:	c3                   	retq   

00000000008028e6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028e6:	55                   	push   %rbp
  8028e7:	48 89 e5             	mov    %rsp,%rbp
  8028ea:	48 83 ec 30          	sub    $0x30,%rsp
  8028ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802901:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802906:	74 07                	je     80290f <devfile_read+0x29>
  802908:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80290d:	75 07                	jne    802916 <devfile_read+0x30>
		return -E_INVAL;
  80290f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802914:	eb 77                	jmp    80298d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291a:	8b 50 0c             	mov    0xc(%rax),%edx
  80291d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802924:	00 00 00 
  802927:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802929:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802930:	00 00 00 
  802933:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802937:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80293b:	be 00 00 00 00       	mov    $0x0,%esi
  802940:	bf 03 00 00 00       	mov    $0x3,%edi
  802945:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax
  802951:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802954:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802958:	7f 05                	jg     80295f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	eb 2e                	jmp    80298d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80295f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802962:	48 63 d0             	movslq %eax,%rdx
  802965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802969:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802970:	00 00 00 
  802973:	48 89 c7             	mov    %rax,%rdi
  802976:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802982:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802986:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80298a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80298d:	c9                   	leaveq 
  80298e:	c3                   	retq   

000000000080298f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80298f:	55                   	push   %rbp
  802990:	48 89 e5             	mov    %rsp,%rbp
  802993:	48 83 ec 30          	sub    $0x30,%rsp
  802997:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80299b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029a3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029af:	74 07                	je     8029b8 <devfile_write+0x29>
  8029b1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029b6:	75 08                	jne    8029c0 <devfile_write+0x31>
		return r;
  8029b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bb:	e9 9a 00 00 00       	jmpq   802a5a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ce:	00 00 00 
  8029d1:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8029d3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029da:	00 
  8029db:	76 08                	jbe    8029e5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8029dd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029e4:	00 
	}
	fsipcbuf.write.req_n = n;
  8029e5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ec:	00 00 00 
  8029ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ff:	48 89 c6             	mov    %rax,%rsi
  802a02:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a09:	00 00 00 
  802a0c:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a18:	be 00 00 00 00       	mov    $0x0,%esi
  802a1d:	bf 04 00 00 00       	mov    $0x4,%edi
  802a22:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	7f 20                	jg     802a57 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a37:	48 bf 0e 47 80 00 00 	movabs $0x80470e,%rdi
  802a3e:	00 00 00 
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
  802a46:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802a4d:	00 00 00 
  802a50:	ff d2                	callq  *%rdx
		return r;
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a55:	eb 03                	jmp    802a5a <devfile_write+0xcb>
	}
	return r;
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a5a:	c9                   	leaveq 
  802a5b:	c3                   	retq   

0000000000802a5c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a5c:	55                   	push   %rbp
  802a5d:	48 89 e5             	mov    %rsp,%rbp
  802a60:	48 83 ec 20          	sub    $0x20,%rsp
  802a64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a70:	8b 50 0c             	mov    0xc(%rax),%edx
  802a73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a7a:	00 00 00 
  802a7d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a7f:	be 00 00 00 00       	mov    $0x0,%esi
  802a84:	bf 05 00 00 00       	mov    $0x5,%edi
  802a89:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9c:	79 05                	jns    802aa3 <devfile_stat+0x47>
		return r;
  802a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa1:	eb 56                	jmp    802af9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802aa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802aae:	00 00 00 
  802ab1:	48 89 c7             	mov    %rax,%rdi
  802ab4:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ac0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac7:	00 00 00 
  802aca:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ad0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ada:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae1:	00 00 00 
  802ae4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802aea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aee:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af9:	c9                   	leaveq 
  802afa:	c3                   	retq   

0000000000802afb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802afb:	55                   	push   %rbp
  802afc:	48 89 e5             	mov    %rsp,%rbp
  802aff:	48 83 ec 10          	sub    $0x10,%rsp
  802b03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b07:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0e:	8b 50 0c             	mov    0xc(%rax),%edx
  802b11:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b18:	00 00 00 
  802b1b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b1d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b24:	00 00 00 
  802b27:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b2a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b2d:	be 00 00 00 00       	mov    $0x0,%esi
  802b32:	bf 02 00 00 00       	mov    $0x2,%edi
  802b37:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
}
  802b43:	c9                   	leaveq 
  802b44:	c3                   	retq   

0000000000802b45 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b45:	55                   	push   %rbp
  802b46:	48 89 e5             	mov    %rsp,%rbp
  802b49:	48 83 ec 10          	sub    $0x10,%rsp
  802b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b55:	48 89 c7             	mov    %rax,%rdi
  802b58:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b69:	7e 07                	jle    802b72 <remove+0x2d>
		return -E_BAD_PATH;
  802b6b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b70:	eb 33                	jmp    802ba5 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b76:	48 89 c6             	mov    %rax,%rsi
  802b79:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b80:	00 00 00 
  802b83:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  802b8a:	00 00 00 
  802b8d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b8f:	be 00 00 00 00       	mov    $0x0,%esi
  802b94:	bf 07 00 00 00       	mov    $0x7,%edi
  802b99:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bab:	be 00 00 00 00       	mov    $0x0,%esi
  802bb0:	bf 08 00 00 00       	mov    $0x8,%edi
  802bb5:	48 b8 01 27 80 00 00 	movabs $0x802701,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
}
  802bc1:	5d                   	pop    %rbp
  802bc2:	c3                   	retq   

0000000000802bc3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802bc3:	55                   	push   %rbp
  802bc4:	48 89 e5             	mov    %rsp,%rbp
  802bc7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802bce:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bd5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bdc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802be3:	be 00 00 00 00       	mov    $0x0,%esi
  802be8:	48 89 c7             	mov    %rax,%rdi
  802beb:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
  802bf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfe:	79 28                	jns    802c28 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c03:	89 c6                	mov    %eax,%esi
  802c05:	48 bf 2a 47 80 00 00 	movabs $0x80472a,%rdi
  802c0c:	00 00 00 
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802c1b:	00 00 00 
  802c1e:	ff d2                	callq  *%rdx
		return fd_src;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	e9 74 01 00 00       	jmpq   802d9c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c28:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c2f:	be 01 01 00 00       	mov    $0x101,%esi
  802c34:	48 89 c7             	mov    %rax,%rdi
  802c37:	48 b8 88 27 80 00 00 	movabs $0x802788,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
  802c43:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c46:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c4a:	79 39                	jns    802c85 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4f:	89 c6                	mov    %eax,%esi
  802c51:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  802c58:	00 00 00 
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802c67:	00 00 00 
  802c6a:	ff d2                	callq  *%rdx
		close(fd_src);
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	89 c7                	mov    %eax,%edi
  802c71:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802c78:	00 00 00 
  802c7b:	ff d0                	callq  *%rax
		return fd_dest;
  802c7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c80:	e9 17 01 00 00       	jmpq   802d9c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c85:	eb 74                	jmp    802cfb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c8a:	48 63 d0             	movslq %eax,%rdx
  802c8d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c97:	48 89 ce             	mov    %rcx,%rsi
  802c9a:	89 c7                	mov    %eax,%edi
  802c9c:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
  802ca8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802caf:	79 4a                	jns    802cfb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802cb1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cb4:	89 c6                	mov    %eax,%esi
  802cb6:	48 bf 5a 47 80 00 00 	movabs $0x80475a,%rdi
  802cbd:	00 00 00 
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802ccc:	00 00 00 
  802ccf:	ff d2                	callq  *%rdx
			close(fd_src);
  802cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd4:	89 c7                	mov    %eax,%edi
  802cd6:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
			close(fd_dest);
  802ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce5:	89 c7                	mov    %eax,%edi
  802ce7:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
			return write_size;
  802cf3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf6:	e9 a1 00 00 00       	jmpq   802d9c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cfb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d05:	ba 00 02 00 00       	mov    $0x200,%edx
  802d0a:	48 89 ce             	mov    %rcx,%rsi
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
  802d1b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d22:	0f 8f 5f ff ff ff    	jg     802c87 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d2c:	79 47                	jns    802d75 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d31:	89 c6                	mov    %eax,%esi
  802d33:	48 bf 6d 47 80 00 00 	movabs $0x80476d,%rdi
  802d3a:	00 00 00 
  802d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d42:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802d49:	00 00 00 
  802d4c:	ff d2                	callq  *%rdx
		close(fd_src);
  802d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802d5a:	00 00 00 
  802d5d:	ff d0                	callq  *%rax
		close(fd_dest);
  802d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
		return read_size;
  802d70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d73:	eb 27                	jmp    802d9c <copy+0x1d9>
	}
	close(fd_src);
  802d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d78:	89 c7                	mov    %eax,%edi
  802d7a:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
	close(fd_dest);
  802d86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d89:	89 c7                	mov    %eax,%edi
  802d8b:	48 b8 90 20 80 00 00 	movabs $0x802090,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	return 0;
  802d97:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d9c:	c9                   	leaveq 
  802d9d:	c3                   	retq   

0000000000802d9e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d9e:	55                   	push   %rbp
  802d9f:	48 89 e5             	mov    %rsp,%rbp
  802da2:	48 83 ec 20          	sub    $0x20,%rsp
  802da6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802da9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802db0:	48 89 d6             	mov    %rdx,%rsi
  802db3:	89 c7                	mov    %eax,%edi
  802db5:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
  802dc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc8:	79 05                	jns    802dcf <fd2sockid+0x31>
		return r;
  802dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcd:	eb 24                	jmp    802df3 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd3:	8b 10                	mov    (%rax),%edx
  802dd5:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ddc:	00 00 00 
  802ddf:	8b 00                	mov    (%rax),%eax
  802de1:	39 c2                	cmp    %eax,%edx
  802de3:	74 07                	je     802dec <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802de5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dea:	eb 07                	jmp    802df3 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df0:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 20          	sub    $0x20,%rsp
  802dfd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e00:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e04:	48 89 c7             	mov    %rax,%rdi
  802e07:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
  802e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1a:	78 26                	js     802e42 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e20:	ba 07 04 00 00       	mov    $0x407,%edx
  802e25:	48 89 c6             	mov    %rax,%rsi
  802e28:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2d:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
  802e39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e40:	79 16                	jns    802e58 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e45:	89 c7                	mov    %eax,%edi
  802e47:	48 b8 02 33 80 00 00 	movabs $0x803302,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
		return r;
  802e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e56:	eb 3a                	jmp    802e92 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5c:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e63:	00 00 00 
  802e66:	8b 12                	mov    (%rdx),%edx
  802e68:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e79:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e7c:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e83:	48 89 c7             	mov    %rax,%rdi
  802e86:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
}
  802e92:	c9                   	leaveq 
  802e93:	c3                   	retq   

0000000000802e94 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e94:	55                   	push   %rbp
  802e95:	48 89 e5             	mov    %rsp,%rbp
  802e98:	48 83 ec 30          	sub    $0x30,%rsp
  802e9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ea7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eaa:	89 c7                	mov    %eax,%edi
  802eac:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
  802eb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebf:	79 05                	jns    802ec6 <accept+0x32>
		return r;
  802ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec4:	eb 3b                	jmp    802f01 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ec6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed1:	48 89 ce             	mov    %rcx,%rsi
  802ed4:	89 c7                	mov    %eax,%edi
  802ed6:	48 b8 df 31 80 00 00 	movabs $0x8031df,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	callq  *%rax
  802ee2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee9:	79 05                	jns    802ef0 <accept+0x5c>
		return r;
  802eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eee:	eb 11                	jmp    802f01 <accept+0x6d>
	return alloc_sockfd(r);
  802ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef3:	89 c7                	mov    %eax,%edi
  802ef5:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  802efc:	00 00 00 
  802eff:	ff d0                	callq  *%rax
}
  802f01:	c9                   	leaveq 
  802f02:	c3                   	retq   

0000000000802f03 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f03:	55                   	push   %rbp
  802f04:	48 89 e5             	mov    %rsp,%rbp
  802f07:	48 83 ec 20          	sub    $0x20,%rsp
  802f0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f12:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f18:	89 c7                	mov    %eax,%edi
  802f1a:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
  802f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2d:	79 05                	jns    802f34 <bind+0x31>
		return r;
  802f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f32:	eb 1b                	jmp    802f4f <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f34:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f37:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3e:	48 89 ce             	mov    %rcx,%rsi
  802f41:	89 c7                	mov    %eax,%edi
  802f43:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
}
  802f4f:	c9                   	leaveq 
  802f50:	c3                   	retq   

0000000000802f51 <shutdown>:

int
shutdown(int s, int how)
{
  802f51:	55                   	push   %rbp
  802f52:	48 89 e5             	mov    %rsp,%rbp
  802f55:	48 83 ec 20          	sub    $0x20,%rsp
  802f59:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f5c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f62:	89 c7                	mov    %eax,%edi
  802f64:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	callq  *%rax
  802f70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f77:	79 05                	jns    802f7e <shutdown+0x2d>
		return r;
  802f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7c:	eb 16                	jmp    802f94 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f84:	89 d6                	mov    %edx,%esi
  802f86:	89 c7                	mov    %eax,%edi
  802f88:	48 b8 c2 32 80 00 00 	movabs $0x8032c2,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
}
  802f94:	c9                   	leaveq 
  802f95:	c3                   	retq   

0000000000802f96 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f96:	55                   	push   %rbp
  802f97:	48 89 e5             	mov    %rsp,%rbp
  802f9a:	48 83 ec 10          	sub    $0x10,%rsp
  802f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa6:	48 89 c7             	mov    %rax,%rdi
  802fa9:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	83 f8 01             	cmp    $0x1,%eax
  802fb8:	75 17                	jne    802fd1 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbe:	8b 40 0c             	mov    0xc(%rax),%eax
  802fc1:	89 c7                	mov    %eax,%edi
  802fc3:	48 b8 02 33 80 00 00 	movabs $0x803302,%rax
  802fca:	00 00 00 
  802fcd:	ff d0                	callq  *%rax
  802fcf:	eb 05                	jmp    802fd6 <devsock_close+0x40>
	else
		return 0;
  802fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fd6:	c9                   	leaveq 
  802fd7:	c3                   	retq   

0000000000802fd8 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fd8:	55                   	push   %rbp
  802fd9:	48 89 e5             	mov    %rsp,%rbp
  802fdc:	48 83 ec 20          	sub    $0x20,%rsp
  802fe0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fed:	89 c7                	mov    %eax,%edi
  802fef:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
  802ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803002:	79 05                	jns    803009 <connect+0x31>
		return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	eb 1b                	jmp    803024 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803009:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80300c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803013:	48 89 ce             	mov    %rcx,%rsi
  803016:	89 c7                	mov    %eax,%edi
  803018:	48 b8 2f 33 80 00 00 	movabs $0x80332f,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
}
  803024:	c9                   	leaveq 
  803025:	c3                   	retq   

0000000000803026 <listen>:

int
listen(int s, int backlog)
{
  803026:	55                   	push   %rbp
  803027:	48 89 e5             	mov    %rsp,%rbp
  80302a:	48 83 ec 20          	sub    $0x20,%rsp
  80302e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803031:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803034:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803037:	89 c7                	mov    %eax,%edi
  803039:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803048:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304c:	79 05                	jns    803053 <listen+0x2d>
		return r;
  80304e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803051:	eb 16                	jmp    803069 <listen+0x43>
	return nsipc_listen(r, backlog);
  803053:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803059:	89 d6                	mov    %edx,%esi
  80305b:	89 c7                	mov    %eax,%edi
  80305d:	48 b8 93 33 80 00 00 	movabs $0x803393,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
}
  803069:	c9                   	leaveq 
  80306a:	c3                   	retq   

000000000080306b <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80306b:	55                   	push   %rbp
  80306c:	48 89 e5             	mov    %rsp,%rbp
  80306f:	48 83 ec 20          	sub    $0x20,%rsp
  803073:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803077:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80307b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80307f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803083:	89 c2                	mov    %eax,%edx
  803085:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803089:	8b 40 0c             	mov    0xc(%rax),%eax
  80308c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803090:	b9 00 00 00 00       	mov    $0x0,%ecx
  803095:	89 c7                	mov    %eax,%edi
  803097:	48 b8 d3 33 80 00 00 	movabs $0x8033d3,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
}
  8030a3:	c9                   	leaveq 
  8030a4:	c3                   	retq   

00000000008030a5 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030a5:	55                   	push   %rbp
  8030a6:	48 89 e5             	mov    %rsp,%rbp
  8030a9:	48 83 ec 20          	sub    $0x20,%rsp
  8030ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bd:	89 c2                	mov    %eax,%edx
  8030bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8030c6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030cf:	89 c7                	mov    %eax,%edi
  8030d1:	48 b8 9f 34 80 00 00 	movabs $0x80349f,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	48 83 ec 10          	sub    $0x10,%rsp
  8030e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f3:	48 be 88 47 80 00 00 	movabs $0x804788,%rsi
  8030fa:	00 00 00 
  8030fd:	48 89 c7             	mov    %rax,%rdi
  803100:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
	return 0;
  80310c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803111:	c9                   	leaveq 
  803112:	c3                   	retq   

0000000000803113 <socket>:

int
socket(int domain, int type, int protocol)
{
  803113:	55                   	push   %rbp
  803114:	48 89 e5             	mov    %rsp,%rbp
  803117:	48 83 ec 20          	sub    $0x20,%rsp
  80311b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80311e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803121:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803124:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803127:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80312a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80312d:	89 ce                	mov    %ecx,%esi
  80312f:	89 c7                	mov    %eax,%edi
  803131:	48 b8 57 35 80 00 00 	movabs $0x803557,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803144:	79 05                	jns    80314b <socket+0x38>
		return r;
  803146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803149:	eb 11                	jmp    80315c <socket+0x49>
	return alloc_sockfd(r);
  80314b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314e:	89 c7                	mov    %eax,%edi
  803150:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
  803162:	48 83 ec 10          	sub    $0x10,%rsp
  803166:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803169:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803170:	00 00 00 
  803173:	8b 00                	mov    (%rax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	75 1d                	jne    803196 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803179:	bf 02 00 00 00       	mov    $0x2,%edi
  80317e:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
  80318a:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803191:	00 00 00 
  803194:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803196:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80319d:	00 00 00 
  8031a0:	8b 00                	mov    (%rax),%eax
  8031a2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031a5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031aa:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8031b1:	00 00 00 
  8031b4:	89 c7                	mov    %eax,%edi
  8031b6:	48 b8 2c 3f 80 00 00 	movabs $0x803f2c,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8031c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c7:	be 00 00 00 00       	mov    $0x0,%esi
  8031cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d1:	48 b8 26 3e 80 00 00 	movabs $0x803e26,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
}
  8031dd:	c9                   	leaveq 
  8031de:	c3                   	retq   

00000000008031df <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031df:	55                   	push   %rbp
  8031e0:	48 89 e5             	mov    %rsp,%rbp
  8031e3:	48 83 ec 30          	sub    $0x30,%rsp
  8031e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031f9:	00 00 00 
  8031fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031ff:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803201:	bf 01 00 00 00       	mov    $0x1,%edi
  803206:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803215:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803219:	78 3e                	js     803259 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80321b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803222:	00 00 00 
  803225:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322d:	8b 40 10             	mov    0x10(%rax),%eax
  803230:	89 c2                	mov    %eax,%edx
  803232:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323a:	48 89 ce             	mov    %rcx,%rsi
  80323d:	48 89 c7             	mov    %rax,%rdi
  803240:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80324c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803250:	8b 50 10             	mov    0x10(%rax),%edx
  803253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803257:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803259:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80325c:	c9                   	leaveq 
  80325d:	c3                   	retq   

000000000080325e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80325e:	55                   	push   %rbp
  80325f:	48 89 e5             	mov    %rsp,%rbp
  803262:	48 83 ec 10          	sub    $0x10,%rsp
  803266:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803269:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80326d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803270:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803277:	00 00 00 
  80327a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80327d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80327f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803286:	48 89 c6             	mov    %rax,%rsi
  803289:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803290:	00 00 00 
  803293:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80329f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a6:	00 00 00 
  8032a9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ac:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8032af:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b4:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
}
  8032c0:	c9                   	leaveq 
  8032c1:	c3                   	retq   

00000000008032c2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8032c2:	55                   	push   %rbp
  8032c3:	48 89 e5             	mov    %rsp,%rbp
  8032c6:	48 83 ec 10          	sub    $0x10,%rsp
  8032ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032cd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d7:	00 00 00 
  8032da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032dd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e6:	00 00 00 
  8032e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ec:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8032f4:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
}
  803300:	c9                   	leaveq 
  803301:	c3                   	retq   

0000000000803302 <nsipc_close>:

int
nsipc_close(int s)
{
  803302:	55                   	push   %rbp
  803303:	48 89 e5             	mov    %rsp,%rbp
  803306:	48 83 ec 10          	sub    $0x10,%rsp
  80330a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80330d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803314:	00 00 00 
  803317:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80331a:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80331c:	bf 04 00 00 00       	mov    $0x4,%edi
  803321:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
}
  80332d:	c9                   	leaveq 
  80332e:	c3                   	retq   

000000000080332f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80332f:	55                   	push   %rbp
  803330:	48 89 e5             	mov    %rsp,%rbp
  803333:	48 83 ec 10          	sub    $0x10,%rsp
  803337:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80333a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80333e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803341:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803348:	00 00 00 
  80334b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80334e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803350:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803357:	48 89 c6             	mov    %rax,%rsi
  80335a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803361:	00 00 00 
  803364:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803370:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803377:	00 00 00 
  80337a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80337d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803380:	bf 05 00 00 00       	mov    $0x5,%edi
  803385:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
}
  803391:	c9                   	leaveq 
  803392:	c3                   	retq   

0000000000803393 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
  803397:	48 83 ec 10          	sub    $0x10,%rsp
  80339b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80339e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8033a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a8:	00 00 00 
  8033ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033ae:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8033b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b7:	00 00 00 
  8033ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8033c0:	bf 06 00 00 00       	mov    $0x6,%edi
  8033c5:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
}
  8033d1:	c9                   	leaveq 
  8033d2:	c3                   	retq   

00000000008033d3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033d3:	55                   	push   %rbp
  8033d4:	48 89 e5             	mov    %rsp,%rbp
  8033d7:	48 83 ec 30          	sub    $0x30,%rsp
  8033db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e2:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ef:	00 00 00 
  8033f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033f5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033fe:	00 00 00 
  803401:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803407:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340e:	00 00 00 
  803411:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803414:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803417:	bf 07 00 00 00       	mov    $0x7,%edi
  80341c:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342f:	78 69                	js     80349a <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803431:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803438:	7f 08                	jg     803442 <nsipc_recv+0x6f>
  80343a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343d:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803440:	7e 35                	jle    803477 <nsipc_recv+0xa4>
  803442:	48 b9 8f 47 80 00 00 	movabs $0x80478f,%rcx
  803449:	00 00 00 
  80344c:	48 ba a4 47 80 00 00 	movabs $0x8047a4,%rdx
  803453:	00 00 00 
  803456:	be 61 00 00 00       	mov    $0x61,%esi
  80345b:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  803462:	00 00 00 
  803465:	b8 00 00 00 00       	mov    $0x0,%eax
  80346a:	49 b8 04 02 80 00 00 	movabs $0x800204,%r8
  803471:	00 00 00 
  803474:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347a:	48 63 d0             	movslq %eax,%rdx
  80347d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803481:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803488:	00 00 00 
  80348b:	48 89 c7             	mov    %rax,%rdi
  80348e:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
	}

	return r;
  80349a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 20          	sub    $0x20,%rsp
  8034a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ae:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8034b1:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8034b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034bb:	00 00 00 
  8034be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034c1:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8034c3:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034ca:	7e 35                	jle    803501 <nsipc_send+0x62>
  8034cc:	48 b9 c5 47 80 00 00 	movabs $0x8047c5,%rcx
  8034d3:	00 00 00 
  8034d6:	48 ba a4 47 80 00 00 	movabs $0x8047a4,%rdx
  8034dd:	00 00 00 
  8034e0:	be 6c 00 00 00       	mov    $0x6c,%esi
  8034e5:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  8034ec:	00 00 00 
  8034ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f4:	49 b8 04 02 80 00 00 	movabs $0x800204,%r8
  8034fb:	00 00 00 
  8034fe:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803501:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803504:	48 63 d0             	movslq %eax,%rdx
  803507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350b:	48 89 c6             	mov    %rax,%rsi
  80350e:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803515:	00 00 00 
  803518:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803524:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80352b:	00 00 00 
  80352e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803534:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80353b:	00 00 00 
  80353e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803541:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803544:	bf 08 00 00 00       	mov    $0x8,%edi
  803549:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
}
  803555:	c9                   	leaveq 
  803556:	c3                   	retq   

0000000000803557 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803557:	55                   	push   %rbp
  803558:	48 89 e5             	mov    %rsp,%rbp
  80355b:	48 83 ec 10          	sub    $0x10,%rsp
  80355f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803562:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803565:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803568:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356f:	00 00 00 
  803572:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803575:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803577:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80357e:	00 00 00 
  803581:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803584:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803587:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80358e:	00 00 00 
  803591:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803594:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803597:	bf 09 00 00 00       	mov    $0x9,%edi
  80359c:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  8035a3:	00 00 00 
  8035a6:	ff d0                	callq  *%rax
}
  8035a8:	c9                   	leaveq 
  8035a9:	c3                   	retq   

00000000008035aa <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035aa:	55                   	push   %rbp
  8035ab:	48 89 e5             	mov    %rsp,%rbp
  8035ae:	53                   	push   %rbx
  8035af:	48 83 ec 38          	sub    $0x38,%rsp
  8035b3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035b7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035bb:	48 89 c7             	mov    %rax,%rdi
  8035be:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8035c5:	00 00 00 
  8035c8:	ff d0                	callq  *%rax
  8035ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d1:	0f 88 bf 01 00 00    	js     803796 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035db:	ba 07 04 00 00       	mov    $0x407,%edx
  8035e0:	48 89 c6             	mov    %rax,%rsi
  8035e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e8:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  8035ef:	00 00 00 
  8035f2:	ff d0                	callq  *%rax
  8035f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035fb:	0f 88 95 01 00 00    	js     803796 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803601:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803605:	48 89 c7             	mov    %rax,%rdi
  803608:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
  803614:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803617:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80361b:	0f 88 5d 01 00 00    	js     80377e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803625:	ba 07 04 00 00       	mov    $0x407,%edx
  80362a:	48 89 c6             	mov    %rax,%rsi
  80362d:	bf 00 00 00 00       	mov    $0x0,%edi
  803632:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
  80363e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803641:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803645:	0f 88 33 01 00 00    	js     80377e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80364b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364f:	48 89 c7             	mov    %rax,%rdi
  803652:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
  80365e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803666:	ba 07 04 00 00       	mov    $0x407,%edx
  80366b:	48 89 c6             	mov    %rax,%rsi
  80366e:	bf 00 00 00 00       	mov    $0x0,%edi
  803673:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
  80367f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803682:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803686:	79 05                	jns    80368d <pipe+0xe3>
		goto err2;
  803688:	e9 d9 00 00 00       	jmpq   803766 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80368d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803691:	48 89 c7             	mov    %rax,%rdi
  803694:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
  8036a0:	48 89 c2             	mov    %rax,%rdx
  8036a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036ad:	48 89 d1             	mov    %rdx,%rcx
  8036b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8036b5:	48 89 c6             	mov    %rax,%rsi
  8036b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bd:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d0:	79 1b                	jns    8036ed <pipe+0x143>
		goto err3;
  8036d2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d7:	48 89 c6             	mov    %rax,%rsi
  8036da:	bf 00 00 00 00       	mov    $0x0,%edi
  8036df:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8036e6:	00 00 00 
  8036e9:	ff d0                	callq  *%rax
  8036eb:	eb 79                	jmp    803766 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036f8:	00 00 00 
  8036fb:	8b 12                	mov    (%rdx),%edx
  8036fd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803703:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80370a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803715:	00 00 00 
  803718:	8b 12                	mov    (%rdx),%edx
  80371a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80371c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803720:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372b:	48 89 c7             	mov    %rax,%rdi
  80372e:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
  80373a:	89 c2                	mov    %eax,%edx
  80373c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803740:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803742:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803746:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80374a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374e:	48 89 c7             	mov    %rax,%rdi
  803751:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
  80375d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80375f:	b8 00 00 00 00       	mov    $0x0,%eax
  803764:	eb 33                	jmp    803799 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376a:	48 89 c6             	mov    %rax,%rsi
  80376d:	bf 00 00 00 00       	mov    $0x0,%edi
  803772:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80377e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803782:	48 89 c6             	mov    %rax,%rsi
  803785:	bf 00 00 00 00       	mov    $0x0,%edi
  80378a:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
err:
	return r;
  803796:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803799:	48 83 c4 38          	add    $0x38,%rsp
  80379d:	5b                   	pop    %rbx
  80379e:	5d                   	pop    %rbp
  80379f:	c3                   	retq   

00000000008037a0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037a0:	55                   	push   %rbp
  8037a1:	48 89 e5             	mov    %rsp,%rbp
  8037a4:	53                   	push   %rbx
  8037a5:	48 83 ec 28          	sub    $0x28,%rsp
  8037a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037b8:	00 00 00 
  8037bb:	48 8b 00             	mov    (%rax),%rax
  8037be:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037cb:	48 89 c7             	mov    %rax,%rdi
  8037ce:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8037d5:	00 00 00 
  8037d8:	ff d0                	callq  *%rax
  8037da:	89 c3                	mov    %eax,%ebx
  8037dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e0:	48 89 c7             	mov    %rax,%rdi
  8037e3:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8037ea:	00 00 00 
  8037ed:	ff d0                	callq  *%rax
  8037ef:	39 c3                	cmp    %eax,%ebx
  8037f1:	0f 94 c0             	sete   %al
  8037f4:	0f b6 c0             	movzbl %al,%eax
  8037f7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803801:	00 00 00 
  803804:	48 8b 00             	mov    (%rax),%rax
  803807:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80380d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803810:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803813:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803816:	75 05                	jne    80381d <_pipeisclosed+0x7d>
			return ret;
  803818:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80381b:	eb 4f                	jmp    80386c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80381d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803820:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803823:	74 42                	je     803867 <_pipeisclosed+0xc7>
  803825:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803829:	75 3c                	jne    803867 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80382b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803832:	00 00 00 
  803835:	48 8b 00             	mov    (%rax),%rax
  803838:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80383e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803841:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803844:	89 c6                	mov    %eax,%esi
  803846:	48 bf d6 47 80 00 00 	movabs $0x8047d6,%rdi
  80384d:	00 00 00 
  803850:	b8 00 00 00 00       	mov    $0x0,%eax
  803855:	49 b8 3d 04 80 00 00 	movabs $0x80043d,%r8
  80385c:	00 00 00 
  80385f:	41 ff d0             	callq  *%r8
	}
  803862:	e9 4a ff ff ff       	jmpq   8037b1 <_pipeisclosed+0x11>
  803867:	e9 45 ff ff ff       	jmpq   8037b1 <_pipeisclosed+0x11>
}
  80386c:	48 83 c4 28          	add    $0x28,%rsp
  803870:	5b                   	pop    %rbx
  803871:	5d                   	pop    %rbp
  803872:	c3                   	retq   

0000000000803873 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803873:	55                   	push   %rbp
  803874:	48 89 e5             	mov    %rsp,%rbp
  803877:	48 83 ec 30          	sub    $0x30,%rsp
  80387b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80387e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803882:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803885:	48 89 d6             	mov    %rdx,%rsi
  803888:	89 c7                	mov    %eax,%edi
  80388a:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
  803896:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803899:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389d:	79 05                	jns    8038a4 <pipeisclosed+0x31>
		return r;
  80389f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a2:	eb 31                	jmp    8038d5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a8:	48 89 c7             	mov    %rax,%rdi
  8038ab:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
  8038b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038c3:	48 89 d6             	mov    %rdx,%rsi
  8038c6:	48 89 c7             	mov    %rax,%rdi
  8038c9:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 40          	sub    $0x40,%rsp
  8038df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ef:	48 89 c7             	mov    %rax,%rdi
  8038f2:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  8038f9:	00 00 00 
  8038fc:	ff d0                	callq  *%rax
  8038fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803906:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80390a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803911:	00 
  803912:	e9 92 00 00 00       	jmpq   8039a9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803917:	eb 41                	jmp    80395a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803919:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80391e:	74 09                	je     803929 <devpipe_read+0x52>
				return i;
  803920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803924:	e9 92 00 00 00       	jmpq   8039bb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80392d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803931:	48 89 d6             	mov    %rdx,%rsi
  803934:	48 89 c7             	mov    %rax,%rdi
  803937:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 07                	je     80394e <devpipe_read+0x77>
				return 0;
  803947:	b8 00 00 00 00       	mov    $0x0,%eax
  80394c:	eb 6d                	jmp    8039bb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80394e:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80395a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395e:	8b 10                	mov    (%rax),%edx
  803960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803964:	8b 40 04             	mov    0x4(%rax),%eax
  803967:	39 c2                	cmp    %eax,%edx
  803969:	74 ae                	je     803919 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80396b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80396f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803973:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397b:	8b 00                	mov    (%rax),%eax
  80397d:	99                   	cltd   
  80397e:	c1 ea 1b             	shr    $0x1b,%edx
  803981:	01 d0                	add    %edx,%eax
  803983:	83 e0 1f             	and    $0x1f,%eax
  803986:	29 d0                	sub    %edx,%eax
  803988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398c:	48 98                	cltq   
  80398e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803993:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803995:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803999:	8b 00                	mov    (%rax),%eax
  80399b:	8d 50 01             	lea    0x1(%rax),%edx
  80399e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039b1:	0f 82 60 ff ff ff    	jb     803917 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039bb:	c9                   	leaveq 
  8039bc:	c3                   	retq   

00000000008039bd <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039bd:	55                   	push   %rbp
  8039be:	48 89 e5             	mov    %rsp,%rbp
  8039c1:	48 83 ec 40          	sub    $0x40,%rsp
  8039c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d5:	48 89 c7             	mov    %rax,%rdi
  8039d8:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
  8039e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039f0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f7:	00 
  8039f8:	e9 8e 00 00 00       	jmpq   803a8b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039fd:	eb 31                	jmp    803a30 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a07:	48 89 d6             	mov    %rdx,%rsi
  803a0a:	48 89 c7             	mov    %rax,%rdi
  803a0d:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
  803a19:	85 c0                	test   %eax,%eax
  803a1b:	74 07                	je     803a24 <devpipe_write+0x67>
				return 0;
  803a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a22:	eb 79                	jmp    803a9d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a24:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a34:	8b 40 04             	mov    0x4(%rax),%eax
  803a37:	48 63 d0             	movslq %eax,%rdx
  803a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3e:	8b 00                	mov    (%rax),%eax
  803a40:	48 98                	cltq   
  803a42:	48 83 c0 20          	add    $0x20,%rax
  803a46:	48 39 c2             	cmp    %rax,%rdx
  803a49:	73 b4                	jae    8039ff <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4f:	8b 40 04             	mov    0x4(%rax),%eax
  803a52:	99                   	cltd   
  803a53:	c1 ea 1b             	shr    $0x1b,%edx
  803a56:	01 d0                	add    %edx,%eax
  803a58:	83 e0 1f             	and    $0x1f,%eax
  803a5b:	29 d0                	sub    %edx,%eax
  803a5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a65:	48 01 ca             	add    %rcx,%rdx
  803a68:	0f b6 0a             	movzbl (%rdx),%ecx
  803a6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6f:	48 98                	cltq   
  803a71:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a79:	8b 40 04             	mov    0x4(%rax),%eax
  803a7c:	8d 50 01             	lea    0x1(%rax),%edx
  803a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a83:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a93:	0f 82 64 ff ff ff    	jb     8039fd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a9d:	c9                   	leaveq 
  803a9e:	c3                   	retq   

0000000000803a9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a9f:	55                   	push   %rbp
  803aa0:	48 89 e5             	mov    %rsp,%rbp
  803aa3:	48 83 ec 20          	sub    $0x20,%rsp
  803aa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ac6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aca:	48 be e9 47 80 00 00 	movabs $0x8047e9,%rsi
  803ad1:	00 00 00 
  803ad4:	48 89 c7             	mov    %rax,%rdi
  803ad7:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803ade:	00 00 00 
  803ae1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae7:	8b 50 04             	mov    0x4(%rax),%edx
  803aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aee:	8b 00                	mov    (%rax),%eax
  803af0:	29 c2                	sub    %eax,%edx
  803af2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b00:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b07:	00 00 00 
	stat->st_dev = &devpipe;
  803b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0e:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b15:	00 00 00 
  803b18:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b24:	c9                   	leaveq 
  803b25:	c3                   	retq   

0000000000803b26 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b26:	55                   	push   %rbp
  803b27:	48 89 e5             	mov    %rsp,%rbp
  803b2a:	48 83 ec 10          	sub    $0x10,%rsp
  803b2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b36:	48 89 c6             	mov    %rax,%rsi
  803b39:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3e:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4e:	48 89 c7             	mov    %rax,%rdi
  803b51:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
  803b5d:	48 89 c6             	mov    %rax,%rsi
  803b60:	bf 00 00 00 00       	mov    $0x0,%edi
  803b65:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803b6c:	00 00 00 
  803b6f:	ff d0                	callq  *%rax
}
  803b71:	c9                   	leaveq 
  803b72:	c3                   	retq   

0000000000803b73 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b73:	55                   	push   %rbp
  803b74:	48 89 e5             	mov    %rsp,%rbp
  803b77:	48 83 ec 20          	sub    $0x20,%rsp
  803b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b81:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b84:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b88:	be 01 00 00 00       	mov    $0x1,%esi
  803b8d:	48 89 c7             	mov    %rax,%rdi
  803b90:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
}
  803b9c:	c9                   	leaveq 
  803b9d:	c3                   	retq   

0000000000803b9e <getchar>:

int
getchar(void)
{
  803b9e:	55                   	push   %rbp
  803b9f:	48 89 e5             	mov    %rsp,%rbp
  803ba2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ba6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803baa:	ba 01 00 00 00       	mov    $0x1,%edx
  803baf:	48 89 c6             	mov    %rax,%rsi
  803bb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb7:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
  803bc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bca:	79 05                	jns    803bd1 <getchar+0x33>
		return r;
  803bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcf:	eb 14                	jmp    803be5 <getchar+0x47>
	if (r < 1)
  803bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd5:	7f 07                	jg     803bde <getchar+0x40>
		return -E_EOF;
  803bd7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bdc:	eb 07                	jmp    803be5 <getchar+0x47>
	return c;
  803bde:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803be2:	0f b6 c0             	movzbl %al,%eax
}
  803be5:	c9                   	leaveq 
  803be6:	c3                   	retq   

0000000000803be7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803be7:	55                   	push   %rbp
  803be8:	48 89 e5             	mov    %rsp,%rbp
  803beb:	48 83 ec 20          	sub    $0x20,%rsp
  803bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bf2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf9:	48 89 d6             	mov    %rdx,%rsi
  803bfc:	89 c7                	mov    %eax,%edi
  803bfe:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  803c05:	00 00 00 
  803c08:	ff d0                	callq  *%rax
  803c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c11:	79 05                	jns    803c18 <iscons+0x31>
		return r;
  803c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c16:	eb 1a                	jmp    803c32 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1c:	8b 10                	mov    (%rax),%edx
  803c1e:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c25:	00 00 00 
  803c28:	8b 00                	mov    (%rax),%eax
  803c2a:	39 c2                	cmp    %eax,%edx
  803c2c:	0f 94 c0             	sete   %al
  803c2f:	0f b6 c0             	movzbl %al,%eax
}
  803c32:	c9                   	leaveq 
  803c33:	c3                   	retq   

0000000000803c34 <opencons>:

int
opencons(void)
{
  803c34:	55                   	push   %rbp
  803c35:	48 89 e5             	mov    %rsp,%rbp
  803c38:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c3c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c40:	48 89 c7             	mov    %rax,%rdi
  803c43:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
  803c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c56:	79 05                	jns    803c5d <opencons+0x29>
		return r;
  803c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c5b:	eb 5b                	jmp    803cb8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c61:	ba 07 04 00 00       	mov    $0x407,%edx
  803c66:	48 89 c6             	mov    %rax,%rsi
  803c69:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6e:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
  803c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c81:	79 05                	jns    803c88 <opencons+0x54>
		return r;
  803c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c86:	eb 30                	jmp    803cb8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8c:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c93:	00 00 00 
  803c96:	8b 12                	mov    (%rdx),%edx
  803c98:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	48 89 c7             	mov    %rax,%rdi
  803cac:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
}
  803cb8:	c9                   	leaveq 
  803cb9:	c3                   	retq   

0000000000803cba <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cba:	55                   	push   %rbp
  803cbb:	48 89 e5             	mov    %rsp,%rbp
  803cbe:	48 83 ec 30          	sub    $0x30,%rsp
  803cc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cd3:	75 07                	jne    803cdc <devcons_read+0x22>
		return 0;
  803cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cda:	eb 4b                	jmp    803d27 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cdc:	eb 0c                	jmp    803cea <devcons_read+0x30>
		sys_yield();
  803cde:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cea:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  803cf1:	00 00 00 
  803cf4:	ff d0                	callq  *%rax
  803cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfd:	74 df                	je     803cde <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d03:	79 05                	jns    803d0a <devcons_read+0x50>
		return c;
  803d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d08:	eb 1d                	jmp    803d27 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d0e:	75 07                	jne    803d17 <devcons_read+0x5d>
		return 0;
  803d10:	b8 00 00 00 00       	mov    $0x0,%eax
  803d15:	eb 10                	jmp    803d27 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1a:	89 c2                	mov    %eax,%edx
  803d1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d20:	88 10                	mov    %dl,(%rax)
	return 1;
  803d22:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d27:	c9                   	leaveq 
  803d28:	c3                   	retq   

0000000000803d29 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d29:	55                   	push   %rbp
  803d2a:	48 89 e5             	mov    %rsp,%rbp
  803d2d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d34:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d3b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d42:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d50:	eb 76                	jmp    803dc8 <devcons_write+0x9f>
		m = n - tot;
  803d52:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d59:	89 c2                	mov    %eax,%edx
  803d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5e:	29 c2                	sub    %eax,%edx
  803d60:	89 d0                	mov    %edx,%eax
  803d62:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d68:	83 f8 7f             	cmp    $0x7f,%eax
  803d6b:	76 07                	jbe    803d74 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d6d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d77:	48 63 d0             	movslq %eax,%rdx
  803d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7d:	48 63 c8             	movslq %eax,%rcx
  803d80:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d87:	48 01 c1             	add    %rax,%rcx
  803d8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d91:	48 89 ce             	mov    %rcx,%rsi
  803d94:	48 89 c7             	mov    %rax,%rdi
  803d97:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803d9e:	00 00 00 
  803da1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803da3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da6:	48 63 d0             	movslq %eax,%rdx
  803da9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803db0:	48 89 d6             	mov    %rdx,%rsi
  803db3:	48 89 c7             	mov    %rax,%rdi
  803db6:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803dbd:	00 00 00 
  803dc0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dc5:	01 45 fc             	add    %eax,-0x4(%rbp)
  803dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcb:	48 98                	cltq   
  803dcd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dd4:	0f 82 78 ff ff ff    	jb     803d52 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ddd:	c9                   	leaveq 
  803dde:	c3                   	retq   

0000000000803ddf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ddf:	55                   	push   %rbp
  803de0:	48 89 e5             	mov    %rsp,%rbp
  803de3:	48 83 ec 08          	sub    $0x8,%rsp
  803de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803df0:	c9                   	leaveq 
  803df1:	c3                   	retq   

0000000000803df2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803df2:	55                   	push   %rbp
  803df3:	48 89 e5             	mov    %rsp,%rbp
  803df6:	48 83 ec 10          	sub    $0x10,%rsp
  803dfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e06:	48 be f5 47 80 00 00 	movabs $0x8047f5,%rsi
  803e0d:	00 00 00 
  803e10:	48 89 c7             	mov    %rax,%rdi
  803e13:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803e1a:	00 00 00 
  803e1d:	ff d0                	callq  *%rax
	return 0;
  803e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e24:	c9                   	leaveq 
  803e25:	c3                   	retq   

0000000000803e26 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e26:	55                   	push   %rbp
  803e27:	48 89 e5             	mov    %rsp,%rbp
  803e2a:	48 83 ec 30          	sub    $0x30,%rsp
  803e2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e3a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e41:	00 00 00 
  803e44:	48 8b 00             	mov    (%rax),%rax
  803e47:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	75 3c                	jne    803e8d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803e51:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  803e58:	00 00 00 
  803e5b:	ff d0                	callq  *%rax
  803e5d:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e62:	48 63 d0             	movslq %eax,%rdx
  803e65:	48 89 d0             	mov    %rdx,%rax
  803e68:	48 c1 e0 03          	shl    $0x3,%rax
  803e6c:	48 01 d0             	add    %rdx,%rax
  803e6f:	48 c1 e0 05          	shl    $0x5,%rax
  803e73:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e7a:	00 00 00 
  803e7d:	48 01 c2             	add    %rax,%rdx
  803e80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e87:	00 00 00 
  803e8a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803e8d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e92:	75 0e                	jne    803ea2 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803e94:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e9b:	00 00 00 
  803e9e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ea2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea6:	48 89 c7             	mov    %rax,%rdi
  803ea9:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  803eb0:	00 00 00 
  803eb3:	ff d0                	callq  *%rax
  803eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803eb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebc:	79 19                	jns    803ed7 <ipc_recv+0xb1>
		*from_env_store = 0;
  803ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ec8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ecc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed5:	eb 53                	jmp    803f2a <ipc_recv+0x104>
	}
	if(from_env_store)
  803ed7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803edc:	74 19                	je     803ef7 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803ede:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ee5:	00 00 00 
  803ee8:	48 8b 00             	mov    (%rax),%rax
  803eeb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef5:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803ef7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803efc:	74 19                	je     803f17 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803efe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f05:	00 00 00 
  803f08:	48 8b 00             	mov    (%rax),%rax
  803f0b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f15:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f17:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f1e:	00 00 00 
  803f21:	48 8b 00             	mov    (%rax),%rax
  803f24:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f2a:	c9                   	leaveq 
  803f2b:	c3                   	retq   

0000000000803f2c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f2c:	55                   	push   %rbp
  803f2d:	48 89 e5             	mov    %rsp,%rbp
  803f30:	48 83 ec 30          	sub    $0x30,%rsp
  803f34:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f37:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f3a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f3e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f41:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f46:	75 0e                	jne    803f56 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f48:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f4f:	00 00 00 
  803f52:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803f56:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f59:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f5c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f63:	89 c7                	mov    %eax,%edi
  803f65:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  803f6c:	00 00 00 
  803f6f:	ff d0                	callq  *%rax
  803f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803f74:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f78:	75 0c                	jne    803f86 <ipc_send+0x5a>
			sys_yield();
  803f7a:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803f81:	00 00 00 
  803f84:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803f86:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f8a:	74 ca                	je     803f56 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803f8c:	c9                   	leaveq 
  803f8d:	c3                   	retq   

0000000000803f8e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f8e:	55                   	push   %rbp
  803f8f:	48 89 e5             	mov    %rsp,%rbp
  803f92:	48 83 ec 14          	sub    $0x14,%rsp
  803f96:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fa0:	eb 5e                	jmp    804000 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803fa2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fa9:	00 00 00 
  803fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803faf:	48 63 d0             	movslq %eax,%rdx
  803fb2:	48 89 d0             	mov    %rdx,%rax
  803fb5:	48 c1 e0 03          	shl    $0x3,%rax
  803fb9:	48 01 d0             	add    %rdx,%rax
  803fbc:	48 c1 e0 05          	shl    $0x5,%rax
  803fc0:	48 01 c8             	add    %rcx,%rax
  803fc3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fc9:	8b 00                	mov    (%rax),%eax
  803fcb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fce:	75 2c                	jne    803ffc <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fd0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fd7:	00 00 00 
  803fda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdd:	48 63 d0             	movslq %eax,%rdx
  803fe0:	48 89 d0             	mov    %rdx,%rax
  803fe3:	48 c1 e0 03          	shl    $0x3,%rax
  803fe7:	48 01 d0             	add    %rdx,%rax
  803fea:	48 c1 e0 05          	shl    $0x5,%rax
  803fee:	48 01 c8             	add    %rcx,%rax
  803ff1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ff7:	8b 40 08             	mov    0x8(%rax),%eax
  803ffa:	eb 12                	jmp    80400e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ffc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804000:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804007:	7e 99                	jle    803fa2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80400e:	c9                   	leaveq 
  80400f:	c3                   	retq   

0000000000804010 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804010:	55                   	push   %rbp
  804011:	48 89 e5             	mov    %rsp,%rbp
  804014:	48 83 ec 18          	sub    $0x18,%rsp
  804018:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80401c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804020:	48 c1 e8 15          	shr    $0x15,%rax
  804024:	48 89 c2             	mov    %rax,%rdx
  804027:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80402e:	01 00 00 
  804031:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804035:	83 e0 01             	and    $0x1,%eax
  804038:	48 85 c0             	test   %rax,%rax
  80403b:	75 07                	jne    804044 <pageref+0x34>
		return 0;
  80403d:	b8 00 00 00 00       	mov    $0x0,%eax
  804042:	eb 53                	jmp    804097 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804048:	48 c1 e8 0c          	shr    $0xc,%rax
  80404c:	48 89 c2             	mov    %rax,%rdx
  80404f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804056:	01 00 00 
  804059:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80405d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804065:	83 e0 01             	and    $0x1,%eax
  804068:	48 85 c0             	test   %rax,%rax
  80406b:	75 07                	jne    804074 <pageref+0x64>
		return 0;
  80406d:	b8 00 00 00 00       	mov    $0x0,%eax
  804072:	eb 23                	jmp    804097 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804078:	48 c1 e8 0c          	shr    $0xc,%rax
  80407c:	48 89 c2             	mov    %rax,%rdx
  80407f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804086:	00 00 00 
  804089:	48 c1 e2 04          	shl    $0x4,%rdx
  80408d:	48 01 d0             	add    %rdx,%rax
  804090:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804094:	0f b7 c0             	movzwl %ax,%eax
}
  804097:	c9                   	leaveq 
  804098:	c3                   	retq   
