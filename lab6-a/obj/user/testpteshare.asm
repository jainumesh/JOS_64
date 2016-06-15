
obj/user/testpteshare.debug:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 9e 54 80 00 00 	movabs $0x80549e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba c5 54 80 00 00 	movabs $0x8054c5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 73 4d 80 00 00 	movabs $0x804d73,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 d4 54 80 00 00 	movabs $0x8054d4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf da 54 80 00 00 	movabs $0x8054da,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba f5 54 80 00 00 	movabs $0x8054f5,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be f9 54 80 00 00 	movabs $0x8054f9,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 06 55 80 00 00 	movabs $0x805506,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 a5 37 80 00 00 	movabs $0x8037a5,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 18 55 80 00 00 	movabs $0x805518,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 73 4d 80 00 00 	movabs $0x804d73,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 d4 54 80 00 00 	movabs $0x8054d4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 22 55 80 00 00 	movabs $0x805522,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002b7:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c8:	48 63 d0             	movslq %eax,%rdx
  8002cb:	48 89 d0             	mov    %rdx,%rax
  8002ce:	48 c1 e0 03          	shl    $0x3,%rax
  8002d2:	48 01 d0             	add    %rdx,%rax
  8002d5:	48 c1 e0 05          	shl    $0x5,%rax
  8002d9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002e0:	00 00 00 
  8002e3:	48 01 c2             	add    %rax,%rdx
  8002e6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ed:	00 00 00 
  8002f0:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f7:	7e 14                	jle    80030d <libmain+0x65>
		binaryname = argv[0];
  8002f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fd:	48 8b 10             	mov    (%rax),%rdx
  800300:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800307:	00 00 00 
  80030a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 89 d6             	mov    %rdx,%rsi
  800317:	89 c7                	mov    %eax,%edi
  800319:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800320:	00 00 00 
  800323:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800325:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
}
  800331:	c9                   	leaveq 
  800332:	c3                   	retq   

0000000000800333 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800333:	55                   	push   %rbp
  800334:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800337:	48 b8 87 27 80 00 00 	movabs $0x802787,%rax
  80033e:	00 00 00 
  800341:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800343:	bf 00 00 00 00       	mov    $0x0,%edi
  800348:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax

}
  800354:	5d                   	pop    %rbp
  800355:	c3                   	retq   

0000000000800356 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	53                   	push   %rbx
  80035b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800362:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800369:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80036f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800376:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80037d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800384:	84 c0                	test   %al,%al
  800386:	74 23                	je     8003ab <_panic+0x55>
  800388:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80038f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800393:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800397:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80039b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80039f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003a7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003ab:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b9:	00 00 00 
  8003bc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c3:	00 00 00 
  8003c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ca:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003df:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003e6:	00 00 00 
  8003e9:	48 8b 18             	mov    (%rax),%rbx
  8003ec:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
  8003f8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003fe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800405:	41 89 c8             	mov    %ecx,%r8d
  800408:	48 89 d1             	mov    %rdx,%rcx
  80040b:	48 89 da             	mov    %rbx,%rdx
  80040e:	89 c6                	mov    %eax,%esi
  800410:	48 bf 48 55 80 00 00 	movabs $0x805548,%rdi
  800417:	00 00 00 
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
  80041f:	49 b9 8f 05 80 00 00 	movabs $0x80058f,%r9
  800426:	00 00 00 
  800429:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80042c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800433:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80043a:	48 89 d6             	mov    %rdx,%rsi
  80043d:	48 89 c7             	mov    %rax,%rdi
  800440:	48 b8 e3 04 80 00 00 	movabs $0x8004e3,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
	cprintf("\n");
  80044c:	48 bf 6b 55 80 00 00 	movabs $0x80556b,%rdi
  800453:	00 00 00 
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  800462:	00 00 00 
  800465:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800467:	cc                   	int3   
  800468:	eb fd                	jmp    800467 <_panic+0x111>

000000000080046a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 10          	sub    $0x10,%rsp
  800472:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800475:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047d:	8b 00                	mov    (%rax),%eax
  80047f:	8d 48 01             	lea    0x1(%rax),%ecx
  800482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800486:	89 0a                	mov    %ecx,(%rdx)
  800488:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80048b:	89 d1                	mov    %edx,%ecx
  80048d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800491:	48 98                	cltq   
  800493:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049b:	8b 00                	mov    (%rax),%eax
  80049d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a2:	75 2c                	jne    8004d0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a8:	8b 00                	mov    (%rax),%eax
  8004aa:	48 98                	cltq   
  8004ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b0:	48 83 c2 08          	add    $0x8,%rdx
  8004b4:	48 89 c6             	mov    %rax,%rsi
  8004b7:	48 89 d7             	mov    %rdx,%rdi
  8004ba:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
        b->idx = 0;
  8004c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d4:	8b 40 04             	mov    0x4(%rax),%eax
  8004d7:	8d 50 01             	lea    0x1(%rax),%edx
  8004da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004de:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e1:	c9                   	leaveq 
  8004e2:	c3                   	retq   

00000000008004e3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004e3:	55                   	push   %rbp
  8004e4:	48 89 e5             	mov    %rsp,%rbp
  8004e7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004ee:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004f5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004fc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800503:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80050a:	48 8b 0a             	mov    (%rdx),%rcx
  80050d:	48 89 08             	mov    %rcx,(%rax)
  800510:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800514:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800518:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80051c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800527:	00 00 00 
    b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800531:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800534:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80053b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800542:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800549:	48 89 c6             	mov    %rax,%rsi
  80054c:	48 bf 6a 04 80 00 00 	movabs $0x80046a,%rdi
  800553:	00 00 00 
  800556:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800562:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800568:	48 98                	cltq   
  80056a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800571:	48 83 c2 08          	add    $0x8,%rdx
  800575:	48 89 c6             	mov    %rax,%rsi
  800578:	48 89 d7             	mov    %rdx,%rdi
  80057b:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  800582:	00 00 00 
  800585:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800587:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80058d:	c9                   	leaveq 
  80058e:	c3                   	retq   

000000000080058f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80058f:	55                   	push   %rbp
  800590:	48 89 e5             	mov    %rsp,%rbp
  800593:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80059a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005bd:	84 c0                	test   %al,%al
  8005bf:	74 20                	je     8005e1 <cprintf+0x52>
  8005c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005ef:	00 00 00 
  8005f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f9:	00 00 00 
  8005fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800600:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800607:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80060e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800615:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80061c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800623:	48 8b 0a             	mov    (%rdx),%rcx
  800626:	48 89 08             	mov    %rcx,(%rax)
  800629:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800631:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800635:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800639:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800640:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800647:	48 89 d6             	mov    %rdx,%rsi
  80064a:	48 89 c7             	mov    %rax,%rdi
  80064d:	48 b8 e3 04 80 00 00 	movabs $0x8004e3,%rax
  800654:	00 00 00 
  800657:	ff d0                	callq  *%rax
  800659:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80065f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800665:	c9                   	leaveq 
  800666:	c3                   	retq   

0000000000800667 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800667:	55                   	push   %rbp
  800668:	48 89 e5             	mov    %rsp,%rbp
  80066b:	53                   	push   %rbx
  80066c:	48 83 ec 38          	sub    $0x38,%rsp
  800670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80067c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80067f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800683:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800687:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80068a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80068e:	77 3b                	ja     8006cb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800690:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800693:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800697:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80069a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a3:	48 f7 f3             	div    %rbx
  8006a6:	48 89 c2             	mov    %rax,%rdx
  8006a9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006ac:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006af:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	41 89 f9             	mov    %edi,%r9d
  8006ba:	48 89 c7             	mov    %rax,%rdi
  8006bd:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	callq  *%rax
  8006c9:	eb 1e                	jmp    8006e9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cb:	eb 12                	jmp    8006df <printnum+0x78>
			putch(padc, putdat);
  8006cd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 89 ce             	mov    %rcx,%rsi
  8006db:	89 d7                	mov    %edx,%edi
  8006dd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006df:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006e7:	7f e4                	jg     8006cd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	48 f7 f1             	div    %rcx
  8006f8:	48 89 d0             	mov    %rdx,%rax
  8006fb:	48 ba 70 57 80 00 00 	movabs $0x805770,%rdx
  800702:	00 00 00 
  800705:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800709:	0f be d0             	movsbl %al,%edx
  80070c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	48 89 ce             	mov    %rcx,%rsi
  800717:	89 d7                	mov    %edx,%edi
  800719:	ff d0                	callq  *%rax
}
  80071b:	48 83 c4 38          	add    $0x38,%rsp
  80071f:	5b                   	pop    %rbx
  800720:	5d                   	pop    %rbp
  800721:	c3                   	retq   

0000000000800722 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800731:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800735:	7e 52                	jle    800789 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	83 f8 30             	cmp    $0x30,%eax
  800740:	73 24                	jae    800766 <getuint+0x44>
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 01 d0             	add    %rdx,%rax
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	8b 12                	mov    (%rdx),%edx
  80075b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	89 0a                	mov    %ecx,(%rdx)
  800764:	eb 17                	jmp    80077d <getuint+0x5b>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076e:	48 89 d0             	mov    %rdx,%rax
  800771:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800784:	e9 a3 00 00 00       	jmpq   80082c <getuint+0x10a>
	else if (lflag)
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078d:	74 4f                	je     8007de <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	83 f8 30             	cmp    $0x30,%eax
  800798:	73 24                	jae    8007be <getuint+0x9c>
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	8b 00                	mov    (%rax),%eax
  8007a8:	89 c0                	mov    %eax,%eax
  8007aa:	48 01 d0             	add    %rdx,%rax
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	8b 12                	mov    (%rdx),%edx
  8007b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	89 0a                	mov    %ecx,(%rdx)
  8007bc:	eb 17                	jmp    8007d5 <getuint+0xb3>
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c6:	48 89 d0             	mov    %rdx,%rax
  8007c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dc:	eb 4e                	jmp    80082c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getuint+0xeb>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	8b 12                	mov    (%rdx),%edx
  800802:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	89 0a                	mov    %ecx,(%rdx)
  80080b:	eb 17                	jmp    800824 <getuint+0x102>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800824:	8b 00                	mov    (%rax),%eax
  800826:	89 c0                	mov    %eax,%eax
  800828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80082c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800830:	c9                   	leaveq 
  800831:	c3                   	retq   

0000000000800832 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800832:	55                   	push   %rbp
  800833:	48 89 e5             	mov    %rsp,%rbp
  800836:	48 83 ec 1c          	sub    $0x1c,%rsp
  80083a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80083e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800841:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800845:	7e 52                	jle    800899 <getint+0x67>
		x=va_arg(*ap, long long);
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	8b 00                	mov    (%rax),%eax
  80084d:	83 f8 30             	cmp    $0x30,%eax
  800850:	73 24                	jae    800876 <getint+0x44>
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085e:	8b 00                	mov    (%rax),%eax
  800860:	89 c0                	mov    %eax,%eax
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	8b 12                	mov    (%rdx),%edx
  80086b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800872:	89 0a                	mov    %ecx,(%rdx)
  800874:	eb 17                	jmp    80088d <getint+0x5b>
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087e:	48 89 d0             	mov    %rdx,%rax
  800881:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088d:	48 8b 00             	mov    (%rax),%rax
  800890:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800894:	e9 a3 00 00 00       	jmpq   80093c <getint+0x10a>
	else if (lflag)
  800899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80089d:	74 4f                	je     8008ee <getint+0xbc>
		x=va_arg(*ap, long);
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	83 f8 30             	cmp    $0x30,%eax
  8008a8:	73 24                	jae    8008ce <getint+0x9c>
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	89 c0                	mov    %eax,%eax
  8008ba:	48 01 d0             	add    %rdx,%rax
  8008bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c1:	8b 12                	mov    (%rdx),%edx
  8008c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	89 0a                	mov    %ecx,(%rdx)
  8008cc:	eb 17                	jmp    8008e5 <getint+0xb3>
  8008ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d6:	48 89 d0             	mov    %rdx,%rax
  8008d9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e5:	48 8b 00             	mov    (%rax),%rax
  8008e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ec:	eb 4e                	jmp    80093c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f2:	8b 00                	mov    (%rax),%eax
  8008f4:	83 f8 30             	cmp    $0x30,%eax
  8008f7:	73 24                	jae    80091d <getint+0xeb>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	89 c0                	mov    %eax,%eax
  800909:	48 01 d0             	add    %rdx,%rax
  80090c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800910:	8b 12                	mov    (%rdx),%edx
  800912:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800919:	89 0a                	mov    %ecx,(%rdx)
  80091b:	eb 17                	jmp    800934 <getint+0x102>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800925:	48 89 d0             	mov    %rdx,%rax
  800928:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800930:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800934:	8b 00                	mov    (%rax),%eax
  800936:	48 98                	cltq   
  800938:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80093c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800940:	c9                   	leaveq 
  800941:	c3                   	retq   

0000000000800942 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800942:	55                   	push   %rbp
  800943:	48 89 e5             	mov    %rsp,%rbp
  800946:	41 54                	push   %r12
  800948:	53                   	push   %rbx
  800949:	48 83 ec 60          	sub    $0x60,%rsp
  80094d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800951:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800955:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800959:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80095d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800961:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800965:	48 8b 0a             	mov    (%rdx),%rcx
  800968:	48 89 08             	mov    %rcx,(%rax)
  80096b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80096f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800973:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800977:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097b:	eb 17                	jmp    800994 <vprintfmt+0x52>
			if (ch == '\0')
  80097d:	85 db                	test   %ebx,%ebx
  80097f:	0f 84 cc 04 00 00    	je     800e51 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	89 df                	mov    %ebx,%edi
  800992:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800994:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800998:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80099c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009a0:	0f b6 00             	movzbl (%rax),%eax
  8009a3:	0f b6 d8             	movzbl %al,%ebx
  8009a6:	83 fb 25             	cmp    $0x25,%ebx
  8009a9:	75 d2                	jne    80097d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009af:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d7:	0f b6 00             	movzbl (%rax),%eax
  8009da:	0f b6 d8             	movzbl %al,%ebx
  8009dd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009e0:	83 f8 55             	cmp    $0x55,%eax
  8009e3:	0f 87 34 04 00 00    	ja     800e1d <vprintfmt+0x4db>
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009f2:	00 
  8009f3:	48 b8 98 57 80 00 00 	movabs $0x805798,%rax
  8009fa:	00 00 00 
  8009fd:	48 01 d0             	add    %rdx,%rax
  800a00:	48 8b 00             	mov    (%rax),%rax
  800a03:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a05:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a09:	eb c0                	jmp    8009cb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a0b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a0f:	eb ba                	jmp    8009cb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a11:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a18:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	c1 e0 02             	shl    $0x2,%eax
  800a20:	01 d0                	add    %edx,%eax
  800a22:	01 c0                	add    %eax,%eax
  800a24:	01 d8                	add    %ebx,%eax
  800a26:	83 e8 30             	sub    $0x30,%eax
  800a29:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a2c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a30:	0f b6 00             	movzbl (%rax),%eax
  800a33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a36:	83 fb 2f             	cmp    $0x2f,%ebx
  800a39:	7e 0c                	jle    800a47 <vprintfmt+0x105>
  800a3b:	83 fb 39             	cmp    $0x39,%ebx
  800a3e:	7f 07                	jg     800a47 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a40:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a45:	eb d1                	jmp    800a18 <vprintfmt+0xd6>
			goto process_precision;
  800a47:	eb 58                	jmp    800aa1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4c:	83 f8 30             	cmp    $0x30,%eax
  800a4f:	73 17                	jae    800a68 <vprintfmt+0x126>
  800a51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a58:	89 c0                	mov    %eax,%eax
  800a5a:	48 01 d0             	add    %rdx,%rax
  800a5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a60:	83 c2 08             	add    $0x8,%edx
  800a63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a66:	eb 0f                	jmp    800a77 <vprintfmt+0x135>
  800a68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6c:	48 89 d0             	mov    %rdx,%rax
  800a6f:	48 83 c2 08          	add    $0x8,%rdx
  800a73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a7c:	eb 23                	jmp    800aa1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a82:	79 0c                	jns    800a90 <vprintfmt+0x14e>
				width = 0;
  800a84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a8b:	e9 3b ff ff ff       	jmpq   8009cb <vprintfmt+0x89>
  800a90:	e9 36 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a95:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a9c:	e9 2a ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800aa1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aa5:	79 12                	jns    800ab9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800aa7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aaa:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800aad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ab4:	e9 12 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>
  800ab9:	e9 0d ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800abe:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ac2:	e9 04 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 30             	cmp    $0x30,%eax
  800acd:	73 17                	jae    800ae6 <vprintfmt+0x1a4>
  800acf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 01 d0             	add    %rdx,%rax
  800adb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ade:	83 c2 08             	add    $0x8,%edx
  800ae1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae4:	eb 0f                	jmp    800af5 <vprintfmt+0x1b3>
  800ae6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aea:	48 89 d0             	mov    %rdx,%rax
  800aed:	48 83 c2 08          	add    $0x8,%rdx
  800af1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af5:	8b 10                	mov    (%rax),%edx
  800af7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 ce             	mov    %rcx,%rsi
  800b02:	89 d7                	mov    %edx,%edi
  800b04:	ff d0                	callq  *%rax
			break;
  800b06:	e9 40 03 00 00       	jmpq   800e4b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0e:	83 f8 30             	cmp    $0x30,%eax
  800b11:	73 17                	jae    800b2a <vprintfmt+0x1e8>
  800b13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b28:	eb 0f                	jmp    800b39 <vprintfmt+0x1f7>
  800b2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2e:	48 89 d0             	mov    %rdx,%rax
  800b31:	48 83 c2 08          	add    $0x8,%rdx
  800b35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b39:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b3b:	85 db                	test   %ebx,%ebx
  800b3d:	79 02                	jns    800b41 <vprintfmt+0x1ff>
				err = -err;
  800b3f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b41:	83 fb 15             	cmp    $0x15,%ebx
  800b44:	7f 16                	jg     800b5c <vprintfmt+0x21a>
  800b46:	48 b8 c0 56 80 00 00 	movabs $0x8056c0,%rax
  800b4d:	00 00 00 
  800b50:	48 63 d3             	movslq %ebx,%rdx
  800b53:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b57:	4d 85 e4             	test   %r12,%r12
  800b5a:	75 2e                	jne    800b8a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	89 d9                	mov    %ebx,%ecx
  800b66:	48 ba 81 57 80 00 00 	movabs $0x805781,%rdx
  800b6d:	00 00 00 
  800b70:	48 89 c7             	mov    %rax,%rdi
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800b7f:	00 00 00 
  800b82:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b85:	e9 c1 02 00 00       	jmpq   800e4b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	4c 89 e1             	mov    %r12,%rcx
  800b95:	48 ba 8a 57 80 00 00 	movabs $0x80578a,%rdx
  800b9c:	00 00 00 
  800b9f:	48 89 c7             	mov    %rax,%rdi
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba7:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800bae:	00 00 00 
  800bb1:	41 ff d0             	callq  *%r8
			break;
  800bb4:	e9 92 02 00 00       	jmpq   800e4b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbc:	83 f8 30             	cmp    $0x30,%eax
  800bbf:	73 17                	jae    800bd8 <vprintfmt+0x296>
  800bc1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	89 c0                	mov    %eax,%eax
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd0:	83 c2 08             	add    $0x8,%edx
  800bd3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd6:	eb 0f                	jmp    800be7 <vprintfmt+0x2a5>
  800bd8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdc:	48 89 d0             	mov    %rdx,%rax
  800bdf:	48 83 c2 08          	add    $0x8,%rdx
  800be3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be7:	4c 8b 20             	mov    (%rax),%r12
  800bea:	4d 85 e4             	test   %r12,%r12
  800bed:	75 0a                	jne    800bf9 <vprintfmt+0x2b7>
				p = "(null)";
  800bef:	49 bc 8d 57 80 00 00 	movabs $0x80578d,%r12
  800bf6:	00 00 00 
			if (width > 0 && padc != '-')
  800bf9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfd:	7e 3f                	jle    800c3e <vprintfmt+0x2fc>
  800bff:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c03:	74 39                	je     800c3e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c05:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c08:	48 98                	cltq   
  800c0a:	48 89 c6             	mov    %rax,%rsi
  800c0d:	4c 89 e7             	mov    %r12,%rdi
  800c10:	48 b8 06 11 80 00 00 	movabs $0x801106,%rax
  800c17:	00 00 00 
  800c1a:	ff d0                	callq  *%rax
  800c1c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c1f:	eb 17                	jmp    800c38 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c21:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c25:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2d:	48 89 ce             	mov    %rcx,%rsi
  800c30:	89 d7                	mov    %edx,%edi
  800c32:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3c:	7f e3                	jg     800c21 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3e:	eb 37                	jmp    800c77 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c44:	74 1e                	je     800c64 <vprintfmt+0x322>
  800c46:	83 fb 1f             	cmp    $0x1f,%ebx
  800c49:	7e 05                	jle    800c50 <vprintfmt+0x30e>
  800c4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c4e:	7e 14                	jle    800c64 <vprintfmt+0x322>
					putch('?', putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c60:	ff d0                	callq  *%rax
  800c62:	eb 0f                	jmp    800c73 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6c:	48 89 d6             	mov    %rdx,%rsi
  800c6f:	89 df                	mov    %ebx,%edi
  800c71:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c77:	4c 89 e0             	mov    %r12,%rax
  800c7a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c7e:	0f b6 00             	movzbl (%rax),%eax
  800c81:	0f be d8             	movsbl %al,%ebx
  800c84:	85 db                	test   %ebx,%ebx
  800c86:	74 10                	je     800c98 <vprintfmt+0x356>
  800c88:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c8c:	78 b2                	js     800c40 <vprintfmt+0x2fe>
  800c8e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c92:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c96:	79 a8                	jns    800c40 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c98:	eb 16                	jmp    800cb0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca2:	48 89 d6             	mov    %rdx,%rsi
  800ca5:	bf 20 00 00 00       	mov    $0x20,%edi
  800caa:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb4:	7f e4                	jg     800c9a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cb6:	e9 90 01 00 00       	jmpq   800e4b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbf:	be 03 00 00 00       	mov    $0x3,%esi
  800cc4:	48 89 c7             	mov    %rax,%rdi
  800cc7:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800cce:	00 00 00 
  800cd1:	ff d0                	callq  *%rax
  800cd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdb:	48 85 c0             	test   %rax,%rax
  800cde:	79 1d                	jns    800cfd <vprintfmt+0x3bb>
				putch('-', putdat);
  800ce0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce8:	48 89 d6             	mov    %rdx,%rsi
  800ceb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf6:	48 f7 d8             	neg    %rax
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cfd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d04:	e9 d5 00 00 00       	jmpq   800dde <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0d:	be 03 00 00 00       	mov    $0x3,%esi
  800d12:	48 89 c7             	mov    %rax,%rdi
  800d15:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800d1c:	00 00 00 
  800d1f:	ff d0                	callq  *%rax
  800d21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d25:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2c:	e9 ad 00 00 00       	jmpq   800dde <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d31:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d38:	89 d6                	mov    %edx,%esi
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
  800d49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d4d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d54:	e9 85 00 00 00       	jmpq   800dde <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d61:	48 89 d6             	mov    %rdx,%rsi
  800d64:	bf 30 00 00 00       	mov    $0x30,%edi
  800d69:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d73:	48 89 d6             	mov    %rdx,%rsi
  800d76:	bf 78 00 00 00       	mov    $0x78,%edi
  800d7b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	83 f8 30             	cmp    $0x30,%eax
  800d83:	73 17                	jae    800d9c <vprintfmt+0x45a>
  800d85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8c:	89 c0                	mov    %eax,%eax
  800d8e:	48 01 d0             	add    %rdx,%rax
  800d91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d94:	83 c2 08             	add    $0x8,%edx
  800d97:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d9a:	eb 0f                	jmp    800dab <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da0:	48 89 d0             	mov    %rdx,%rax
  800da3:	48 83 c2 08          	add    $0x8,%rdx
  800da7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dab:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800db2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db9:	eb 23                	jmp    800dde <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbf:	be 03 00 00 00       	mov    $0x3,%esi
  800dc4:	48 89 c7             	mov    %rax,%rdi
  800dc7:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
  800dd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dd7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dde:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800de3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800de6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ded:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df5:	45 89 c1             	mov    %r8d,%r9d
  800df8:	41 89 f8             	mov    %edi,%r8d
  800dfb:	48 89 c7             	mov    %rax,%rdi
  800dfe:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	callq  *%rax
			break;
  800e0a:	eb 3f                	jmp    800e4b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	48 89 d6             	mov    %rdx,%rsi
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	ff d0                	callq  *%rax
			break;
  800e1b:	eb 2e                	jmp    800e4b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	48 89 d6             	mov    %rdx,%rsi
  800e28:	bf 25 00 00 00       	mov    $0x25,%edi
  800e2d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e2f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e34:	eb 05                	jmp    800e3b <vprintfmt+0x4f9>
  800e36:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e3b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e3f:	48 83 e8 01          	sub    $0x1,%rax
  800e43:	0f b6 00             	movzbl (%rax),%eax
  800e46:	3c 25                	cmp    $0x25,%al
  800e48:	75 ec                	jne    800e36 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e4a:	90                   	nop
		}
	}
  800e4b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4c:	e9 43 fb ff ff       	jmpq   800994 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e51:	48 83 c4 60          	add    $0x60,%rsp
  800e55:	5b                   	pop    %rbx
  800e56:	41 5c                	pop    %r12
  800e58:	5d                   	pop    %rbp
  800e59:	c3                   	retq   

0000000000800e5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e5a:	55                   	push   %rbp
  800e5b:	48 89 e5             	mov    %rsp,%rbp
  800e5e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e65:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e6c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e73:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e7a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e81:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e88:	84 c0                	test   %al,%al
  800e8a:	74 20                	je     800eac <printfmt+0x52>
  800e8c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e90:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e94:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e98:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e9c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ea0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ea4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eac:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eb3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eba:	00 00 00 
  800ebd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ec4:	00 00 00 
  800ec7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ecb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ed2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ee0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ee7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eee:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ef5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800efc:	48 89 c7             	mov    %rax,%rdi
  800eff:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f0b:	c9                   	leaveq 
  800f0c:	c3                   	retq   

0000000000800f0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f0d:	55                   	push   %rbp
  800f0e:	48 89 e5             	mov    %rsp,%rbp
  800f11:	48 83 ec 10          	sub    $0x10,%rsp
  800f15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f20:	8b 40 10             	mov    0x10(%rax),%eax
  800f23:	8d 50 01             	lea    0x1(%rax),%edx
  800f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f31:	48 8b 10             	mov    (%rax),%rdx
  800f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f38:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f3c:	48 39 c2             	cmp    %rax,%rdx
  800f3f:	73 17                	jae    800f58 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f45:	48 8b 00             	mov    (%rax),%rax
  800f48:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f50:	48 89 0a             	mov    %rcx,(%rdx)
  800f53:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f56:	88 10                	mov    %dl,(%rax)
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 50          	sub    $0x50,%rsp
  800f62:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f66:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f69:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f6d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f71:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f75:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f79:	48 8b 0a             	mov    (%rdx),%rcx
  800f7c:	48 89 08             	mov    %rcx,(%rax)
  800f7f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f83:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f87:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f8b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f93:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f97:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f9a:	48 98                	cltq   
  800f9c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa4:	48 01 d0             	add    %rdx,%rax
  800fa7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fb2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fb7:	74 06                	je     800fbf <vsnprintf+0x65>
  800fb9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fbd:	7f 07                	jg     800fc6 <vsnprintf+0x6c>
		return -E_INVAL;
  800fbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc4:	eb 2f                	jmp    800ff5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fc6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fca:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fce:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fd2:	48 89 c6             	mov    %rax,%rsi
  800fd5:	48 bf 0d 0f 80 00 00 	movabs $0x800f0d,%rdi
  800fdc:	00 00 00 
  800fdf:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  800fe6:	00 00 00 
  800fe9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800feb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fef:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ff2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ff5:	c9                   	leaveq 
  800ff6:	c3                   	retq   

0000000000800ff7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801002:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801009:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80100f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801016:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801024:	84 c0                	test   %al,%al
  801026:	74 20                	je     801048 <snprintf+0x51>
  801028:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80102c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801030:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801034:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801038:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80103c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801040:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801044:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801048:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80104f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801056:	00 00 00 
  801059:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801060:	00 00 00 
  801063:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801067:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80106e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801075:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80107c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801083:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80108a:	48 8b 0a             	mov    (%rdx),%rcx
  80108d:	48 89 08             	mov    %rcx,(%rax)
  801090:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801094:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801098:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80109c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010a0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010a7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010ae:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010b4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010bb:	48 89 c7             	mov    %rax,%rdi
  8010be:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	callq  *%rax
  8010ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010d6:	c9                   	leaveq 
  8010d7:	c3                   	retq   

00000000008010d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d8:	55                   	push   %rbp
  8010d9:	48 89 e5             	mov    %rsp,%rbp
  8010dc:	48 83 ec 18          	sub    $0x18,%rsp
  8010e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010eb:	eb 09                	jmp    8010f6 <strlen+0x1e>
		n++;
  8010ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	75 ec                	jne    8010ed <strlen+0x15>
		n++;
	return n;
  801101:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801104:	c9                   	leaveq 
  801105:	c3                   	retq   

0000000000801106 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 83 ec 20          	sub    $0x20,%rsp
  80110e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111d:	eb 0e                	jmp    80112d <strnlen+0x27>
		n++;
  80111f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801123:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801128:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80112d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801132:	74 0b                	je     80113f <strnlen+0x39>
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	0f b6 00             	movzbl (%rax),%eax
  80113b:	84 c0                	test   %al,%al
  80113d:	75 e0                	jne    80111f <strnlen+0x19>
		n++;
	return n;
  80113f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801142:	c9                   	leaveq 
  801143:	c3                   	retq   

0000000000801144 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	48 83 ec 20          	sub    $0x20,%rsp
  80114c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801150:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80115c:	90                   	nop
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801165:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801169:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801171:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801175:	0f b6 12             	movzbl (%rdx),%edx
  801178:	88 10                	mov    %dl,(%rax)
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	84 c0                	test   %al,%al
  80117f:	75 dc                	jne    80115d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801185:	c9                   	leaveq 
  801186:	c3                   	retq   

0000000000801187 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801187:	55                   	push   %rbp
  801188:	48 89 e5             	mov    %rsp,%rbp
  80118b:	48 83 ec 20          	sub    $0x20,%rsp
  80118f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801193:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119b:	48 89 c7             	mov    %rax,%rdi
  80119e:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
  8011aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b0:	48 63 d0             	movslq %eax,%rdx
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 01 c2             	add    %rax,%rdx
  8011ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011be:	48 89 c6             	mov    %rax,%rsi
  8011c1:	48 89 d7             	mov    %rdx,%rdi
  8011c4:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  8011cb:	00 00 00 
  8011ce:	ff d0                	callq  *%rax
	return dst;
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 28          	sub    $0x28,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011f9:	00 
  8011fa:	eb 2a                	jmp    801226 <strncpy+0x50>
		*dst++ = *src;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120c:	0f b6 12             	movzbl (%rdx),%edx
  80120f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801211:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801215:	0f b6 00             	movzbl (%rax),%eax
  801218:	84 c0                	test   %al,%al
  80121a:	74 05                	je     801221 <strncpy+0x4b>
			src++;
  80121c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801221:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80122e:	72 cc                	jb     8011fc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801234:	c9                   	leaveq 
  801235:	c3                   	retq   

0000000000801236 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	48 83 ec 28          	sub    $0x28,%rsp
  80123e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801242:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801246:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801252:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801257:	74 3d                	je     801296 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801259:	eb 1d                	jmp    801278 <strlcpy+0x42>
			*dst++ = *src++;
  80125b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801267:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80126f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801273:	0f b6 12             	movzbl (%rdx),%edx
  801276:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801278:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80127d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801282:	74 0b                	je     80128f <strlcpy+0x59>
  801284:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	84 c0                	test   %al,%al
  80128d:	75 cc                	jne    80125b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801296:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	48 29 c2             	sub    %rax,%rdx
  8012a1:	48 89 d0             	mov    %rdx,%rax
}
  8012a4:	c9                   	leaveq 
  8012a5:	c3                   	retq   

00000000008012a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012a6:	55                   	push   %rbp
  8012a7:	48 89 e5             	mov    %rsp,%rbp
  8012aa:	48 83 ec 10          	sub    $0x10,%rsp
  8012ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012b6:	eb 0a                	jmp    8012c2 <strcmp+0x1c>
		p++, q++;
  8012b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	0f b6 00             	movzbl (%rax),%eax
  8012c9:	84 c0                	test   %al,%al
  8012cb:	74 12                	je     8012df <strcmp+0x39>
  8012cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d1:	0f b6 10             	movzbl (%rax),%edx
  8012d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d8:	0f b6 00             	movzbl (%rax),%eax
  8012db:	38 c2                	cmp    %al,%dl
  8012dd:	74 d9                	je     8012b8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	0f b6 c0             	movzbl %al,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
}
  8012f7:	c9                   	leaveq 
  8012f8:	c3                   	retq   

00000000008012f9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012f9:	55                   	push   %rbp
  8012fa:	48 89 e5             	mov    %rsp,%rbp
  8012fd:	48 83 ec 18          	sub    $0x18,%rsp
  801301:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801305:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80130d:	eb 0f                	jmp    80131e <strncmp+0x25>
		n--, p++, q++;
  80130f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801314:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801319:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80131e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801323:	74 1d                	je     801342 <strncmp+0x49>
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801329:	0f b6 00             	movzbl (%rax),%eax
  80132c:	84 c0                	test   %al,%al
  80132e:	74 12                	je     801342 <strncmp+0x49>
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	0f b6 10             	movzbl (%rax),%edx
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	38 c2                	cmp    %al,%dl
  801340:	74 cd                	je     80130f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801342:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801347:	75 07                	jne    801350 <strncmp+0x57>
		return 0;
  801349:	b8 00 00 00 00       	mov    $0x0,%eax
  80134e:	eb 18                	jmp    801368 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	0f b6 c0             	movzbl %al,%eax
  801364:	29 c2                	sub    %eax,%edx
  801366:	89 d0                	mov    %edx,%eax
}
  801368:	c9                   	leaveq 
  801369:	c3                   	retq   

000000000080136a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136a:	55                   	push   %rbp
  80136b:	48 89 e5             	mov    %rsp,%rbp
  80136e:	48 83 ec 0c          	sub    $0xc,%rsp
  801372:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801376:	89 f0                	mov    %esi,%eax
  801378:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80137b:	eb 17                	jmp    801394 <strchr+0x2a>
		if (*s == c)
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801387:	75 06                	jne    80138f <strchr+0x25>
			return (char *) s;
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	eb 15                	jmp    8013a4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	84 c0                	test   %al,%al
  80139d:	75 de                	jne    80137d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 0c          	sub    $0xc,%rsp
  8013ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b2:	89 f0                	mov    %esi,%eax
  8013b4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b7:	eb 13                	jmp    8013cc <strfind+0x26>
		if (*s == c)
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c3:	75 02                	jne    8013c7 <strfind+0x21>
			break;
  8013c5:	eb 10                	jmp    8013d7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d0:	0f b6 00             	movzbl (%rax),%eax
  8013d3:	84 c0                	test   %al,%al
  8013d5:	75 e2                	jne    8013b9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 18          	sub    $0x18,%rsp
  8013e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f5:	75 06                	jne    8013fd <memset+0x20>
		return v;
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	eb 69                	jmp    801466 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	83 e0 03             	and    $0x3,%eax
  801404:	48 85 c0             	test   %rax,%rax
  801407:	75 48                	jne    801451 <memset+0x74>
  801409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140d:	83 e0 03             	and    $0x3,%eax
  801410:	48 85 c0             	test   %rax,%rax
  801413:	75 3c                	jne    801451 <memset+0x74>
		c &= 0xFF;
  801415:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80141c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141f:	c1 e0 18             	shl    $0x18,%eax
  801422:	89 c2                	mov    %eax,%edx
  801424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801427:	c1 e0 10             	shl    $0x10,%eax
  80142a:	09 c2                	or     %eax,%edx
  80142c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142f:	c1 e0 08             	shl    $0x8,%eax
  801432:	09 d0                	or     %edx,%eax
  801434:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143b:	48 c1 e8 02          	shr    $0x2,%rax
  80143f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801442:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801446:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801449:	48 89 d7             	mov    %rdx,%rdi
  80144c:	fc                   	cld    
  80144d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80144f:	eb 11                	jmp    801462 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801451:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801455:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801458:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80145c:	48 89 d7             	mov    %rdx,%rdi
  80145f:	fc                   	cld    
  801460:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 28          	sub    $0x28,%rsp
  801470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801478:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80147c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801480:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801488:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801494:	0f 83 88 00 00 00    	jae    801522 <memmove+0xba>
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a2:	48 01 d0             	add    %rdx,%rax
  8014a5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014a9:	76 77                	jbe    801522 <memmove+0xba>
		s += n;
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	83 e0 03             	and    $0x3,%eax
  8014c2:	48 85 c0             	test   %rax,%rax
  8014c5:	75 3b                	jne    801502 <memmove+0x9a>
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	83 e0 03             	and    $0x3,%eax
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 2f                	jne    801502 <memmove+0x9a>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	83 e0 03             	and    $0x3,%eax
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 23                	jne    801502 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e3:	48 83 e8 04          	sub    $0x4,%rax
  8014e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014eb:	48 83 ea 04          	sub    $0x4,%rdx
  8014ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014f7:	48 89 c7             	mov    %rax,%rdi
  8014fa:	48 89 d6             	mov    %rdx,%rsi
  8014fd:	fd                   	std    
  8014fe:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801500:	eb 1d                	jmp    80151f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801516:	48 89 d7             	mov    %rdx,%rdi
  801519:	48 89 c1             	mov    %rax,%rcx
  80151c:	fd                   	std    
  80151d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80151f:	fc                   	cld    
  801520:	eb 57                	jmp    801579 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	83 e0 03             	and    $0x3,%eax
  801529:	48 85 c0             	test   %rax,%rax
  80152c:	75 36                	jne    801564 <memmove+0xfc>
  80152e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801532:	83 e0 03             	and    $0x3,%eax
  801535:	48 85 c0             	test   %rax,%rax
  801538:	75 2a                	jne    801564 <memmove+0xfc>
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	83 e0 03             	and    $0x3,%eax
  801541:	48 85 c0             	test   %rax,%rax
  801544:	75 1e                	jne    801564 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 c1 e8 02          	shr    $0x2,%rax
  80154e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801555:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801559:	48 89 c7             	mov    %rax,%rdi
  80155c:	48 89 d6             	mov    %rdx,%rsi
  80155f:	fc                   	cld    
  801560:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801562:	eb 15                	jmp    801579 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801568:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801570:	48 89 c7             	mov    %rax,%rdi
  801573:	48 89 d6             	mov    %rdx,%rsi
  801576:	fc                   	cld    
  801577:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157d:	c9                   	leaveq 
  80157e:	c3                   	retq   

000000000080157f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80157f:	55                   	push   %rbp
  801580:	48 89 e5             	mov    %rsp,%rbp
  801583:	48 83 ec 18          	sub    $0x18,%rsp
  801587:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80158f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801597:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	48 89 ce             	mov    %rcx,%rsi
  8015a2:	48 89 c7             	mov    %rax,%rdi
  8015a5:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	callq  *%rax
}
  8015b1:	c9                   	leaveq 
  8015b2:	c3                   	retq   

00000000008015b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015b3:	55                   	push   %rbp
  8015b4:	48 89 e5             	mov    %rsp,%rbp
  8015b7:	48 83 ec 28          	sub    $0x28,%rsp
  8015bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015d7:	eb 36                	jmp    80160f <memcmp+0x5c>
		if (*s1 != *s2)
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	0f b6 10             	movzbl (%rax),%edx
  8015e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e4:	0f b6 00             	movzbl (%rax),%eax
  8015e7:	38 c2                	cmp    %al,%dl
  8015e9:	74 1a                	je     801605 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	0f b6 d0             	movzbl %al,%edx
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	0f b6 c0             	movzbl %al,%eax
  8015ff:	29 c2                	sub    %eax,%edx
  801601:	89 d0                	mov    %edx,%eax
  801603:	eb 20                	jmp    801625 <memcmp+0x72>
		s1++, s2++;
  801605:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801617:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80161b:	48 85 c0             	test   %rax,%rax
  80161e:	75 b9                	jne    8015d9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	c9                   	leaveq 
  801626:	c3                   	retq   

0000000000801627 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 28          	sub    $0x28,%rsp
  80162f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801633:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801636:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801642:	48 01 d0             	add    %rdx,%rax
  801645:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801649:	eb 15                	jmp    801660 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80164b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164f:	0f b6 10             	movzbl (%rax),%edx
  801652:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801655:	38 c2                	cmp    %al,%dl
  801657:	75 02                	jne    80165b <memfind+0x34>
			break;
  801659:	eb 0f                	jmp    80166a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80165b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801664:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801668:	72 e1                	jb     80164b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80166e:	c9                   	leaveq 
  80166f:	c3                   	retq   

0000000000801670 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801670:	55                   	push   %rbp
  801671:	48 89 e5             	mov    %rsp,%rbp
  801674:	48 83 ec 34          	sub    $0x34,%rsp
  801678:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80167c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801680:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801683:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80168a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801691:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801692:	eb 05                	jmp    801699 <strtol+0x29>
		s++;
  801694:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	3c 20                	cmp    $0x20,%al
  8016a2:	74 f0                	je     801694 <strtol+0x24>
  8016a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a8:	0f b6 00             	movzbl (%rax),%eax
  8016ab:	3c 09                	cmp    $0x9,%al
  8016ad:	74 e5                	je     801694 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	3c 2b                	cmp    $0x2b,%al
  8016b8:	75 07                	jne    8016c1 <strtol+0x51>
		s++;
  8016ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bf:	eb 17                	jmp    8016d8 <strtol+0x68>
	else if (*s == '-')
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	3c 2d                	cmp    $0x2d,%al
  8016ca:	75 0c                	jne    8016d8 <strtol+0x68>
		s++, neg = 1;
  8016cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016dc:	74 06                	je     8016e4 <strtol+0x74>
  8016de:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016e2:	75 28                	jne    80170c <strtol+0x9c>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 30                	cmp    $0x30,%al
  8016ed:	75 1d                	jne    80170c <strtol+0x9c>
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	48 83 c0 01          	add    $0x1,%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 78                	cmp    $0x78,%al
  8016fc:	75 0e                	jne    80170c <strtol+0x9c>
		s += 2, base = 16;
  8016fe:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801703:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80170a:	eb 2c                	jmp    801738 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80170c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801710:	75 19                	jne    80172b <strtol+0xbb>
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	3c 30                	cmp    $0x30,%al
  80171b:	75 0e                	jne    80172b <strtol+0xbb>
		s++, base = 8;
  80171d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801722:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801729:	eb 0d                	jmp    801738 <strtol+0xc8>
	else if (base == 0)
  80172b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80172f:	75 07                	jne    801738 <strtol+0xc8>
		base = 10;
  801731:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	3c 2f                	cmp    $0x2f,%al
  801741:	7e 1d                	jle    801760 <strtol+0xf0>
  801743:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801747:	0f b6 00             	movzbl (%rax),%eax
  80174a:	3c 39                	cmp    $0x39,%al
  80174c:	7f 12                	jg     801760 <strtol+0xf0>
			dig = *s - '0';
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	0f be c0             	movsbl %al,%eax
  801758:	83 e8 30             	sub    $0x30,%eax
  80175b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80175e:	eb 4e                	jmp    8017ae <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 60                	cmp    $0x60,%al
  801769:	7e 1d                	jle    801788 <strtol+0x118>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 7a                	cmp    $0x7a,%al
  801774:	7f 12                	jg     801788 <strtol+0x118>
			dig = *s - 'a' + 10;
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	0f be c0             	movsbl %al,%eax
  801780:	83 e8 57             	sub    $0x57,%eax
  801783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801786:	eb 26                	jmp    8017ae <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 40                	cmp    $0x40,%al
  801791:	7e 48                	jle    8017db <strtol+0x16b>
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	3c 5a                	cmp    $0x5a,%al
  80179c:	7f 3d                	jg     8017db <strtol+0x16b>
			dig = *s - 'A' + 10;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	0f be c0             	movsbl %al,%eax
  8017a8:	83 e8 37             	sub    $0x37,%eax
  8017ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017b4:	7c 02                	jl     8017b8 <strtol+0x148>
			break;
  8017b6:	eb 23                	jmp    8017db <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017c0:	48 98                	cltq   
  8017c2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017c7:	48 89 c2             	mov    %rax,%rdx
  8017ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017cd:	48 98                	cltq   
  8017cf:	48 01 d0             	add    %rdx,%rax
  8017d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017d6:	e9 5d ff ff ff       	jmpq   801738 <strtol+0xc8>

	if (endptr)
  8017db:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017e0:	74 0b                	je     8017ed <strtol+0x17d>
		*endptr = (char *) s;
  8017e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ea:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017f1:	74 09                	je     8017fc <strtol+0x18c>
  8017f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f7:	48 f7 d8             	neg    %rax
  8017fa:	eb 04                	jmp    801800 <strtol+0x190>
  8017fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801800:	c9                   	leaveq 
  801801:	c3                   	retq   

0000000000801802 <strstr>:

char * strstr(const char *in, const char *str)
{
  801802:	55                   	push   %rbp
  801803:	48 89 e5             	mov    %rsp,%rbp
  801806:	48 83 ec 30          	sub    $0x30,%rsp
  80180a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80180e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801816:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80181a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801824:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801828:	75 06                	jne    801830 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	eb 6b                	jmp    80189b <strstr+0x99>

	len = strlen(str);
  801830:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801834:	48 89 c7             	mov    %rax,%rdi
  801837:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  80183e:	00 00 00 
  801841:	ff d0                	callq  *%rax
  801843:	48 98                	cltq   
  801845:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801851:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801855:	0f b6 00             	movzbl (%rax),%eax
  801858:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80185b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80185f:	75 07                	jne    801868 <strstr+0x66>
				return (char *) 0;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
  801866:	eb 33                	jmp    80189b <strstr+0x99>
		} while (sc != c);
  801868:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80186c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80186f:	75 d8                	jne    801849 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801871:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801875:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	48 89 ce             	mov    %rcx,%rsi
  801880:	48 89 c7             	mov    %rax,%rdi
  801883:	48 b8 f9 12 80 00 00 	movabs $0x8012f9,%rax
  80188a:	00 00 00 
  80188d:	ff d0                	callq  *%rax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 b6                	jne    801849 <strstr+0x47>

	return (char *) (in - 1);
  801893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801897:	48 83 e8 01          	sub    $0x1,%rax
}
  80189b:	c9                   	leaveq 
  80189c:	c3                   	retq   

000000000080189d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	53                   	push   %rbx
  8018a2:	48 83 ec 48          	sub    $0x48,%rsp
  8018a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018ac:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018b4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018b8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018bf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018c3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018c7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018cb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018cf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018d3:	4c 89 c3             	mov    %r8,%rbx
  8018d6:	cd 30                	int    $0x30
  8018d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018e0:	74 3e                	je     801920 <syscall+0x83>
  8018e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018e7:	7e 37                	jle    801920 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f0:	49 89 d0             	mov    %rdx,%r8
  8018f3:	89 c1                	mov    %eax,%ecx
  8018f5:	48 ba 48 5a 80 00 00 	movabs $0x805a48,%rdx
  8018fc:	00 00 00 
  8018ff:	be 23 00 00 00       	mov    $0x23,%esi
  801904:	48 bf 65 5a 80 00 00 	movabs $0x805a65,%rdi
  80190b:	00 00 00 
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	49 b9 56 03 80 00 00 	movabs $0x800356,%r9
  80191a:	00 00 00 
  80191d:	41 ff d1             	callq  *%r9

	return ret;
  801920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801924:	48 83 c4 48          	add    $0x48,%rsp
  801928:	5b                   	pop    %rbx
  801929:	5d                   	pop    %rbp
  80192a:	c3                   	retq   

000000000080192b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80192b:	55                   	push   %rbp
  80192c:	48 89 e5             	mov    %rsp,%rbp
  80192f:	48 83 ec 20          	sub    $0x20,%rsp
  801933:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801937:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80193b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801943:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194a:	00 
  80194b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801951:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801957:	48 89 d1             	mov    %rdx,%rcx
  80195a:	48 89 c2             	mov    %rax,%rdx
  80195d:	be 00 00 00 00       	mov    $0x0,%esi
  801962:	bf 00 00 00 00       	mov    $0x0,%edi
  801967:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  80196e:	00 00 00 
  801971:	ff d0                	callq  *%rax
}
  801973:	c9                   	leaveq 
  801974:	c3                   	retq   

0000000000801975 <sys_cgetc>:

int
sys_cgetc(void)
{
  801975:	55                   	push   %rbp
  801976:	48 89 e5             	mov    %rsp,%rbp
  801979:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80197d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801984:	00 
  801985:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801991:	b9 00 00 00 00       	mov    $0x0,%ecx
  801996:	ba 00 00 00 00       	mov    $0x0,%edx
  80199b:	be 00 00 00 00       	mov    $0x0,%esi
  8019a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019a5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  8019ac:	00 00 00 
  8019af:	ff d0                	callq  *%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 10          	sub    $0x10,%rsp
  8019bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c1:	48 98                	cltq   
  8019c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ca:	00 
  8019cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dc:	48 89 c2             	mov    %rax,%rdx
  8019df:	be 01 00 00 00       	mov    $0x1,%esi
  8019e4:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e9:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	callq  *%rax
}
  8019f5:	c9                   	leaveq 
  8019f6:	c3                   	retq   

00000000008019f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a06:	00 
  801a07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a18:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1d:	be 00 00 00 00       	mov    $0x0,%esi
  801a22:	bf 02 00 00 00       	mov    $0x2,%edi
  801a27:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801a2e:	00 00 00 
  801a31:	ff d0                	callq  *%rax
}
  801a33:	c9                   	leaveq 
  801a34:	c3                   	retq   

0000000000801a35 <sys_yield>:

void
sys_yield(void)
{
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a44:	00 
  801a45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a51:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	be 00 00 00 00       	mov    $0x0,%esi
  801a60:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a65:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	callq  *%rax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 20          	sub    $0x20,%rsp
  801a7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a82:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a88:	48 63 c8             	movslq %eax,%rcx
  801a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a92:	48 98                	cltq   
  801a94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9b:	00 
  801a9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa2:	49 89 c8             	mov    %rcx,%r8
  801aa5:	48 89 d1             	mov    %rdx,%rcx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 01 00 00 00       	mov    $0x1,%esi
  801ab0:	bf 04 00 00 00       	mov    $0x4,%edi
  801ab5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 30          	sub    $0x30,%rsp
  801acb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ace:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ad2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ad5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801add:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ae0:	48 63 c8             	movslq %eax,%rcx
  801ae3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ae7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aea:	48 63 f0             	movslq %eax,%rsi
  801aed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af4:	48 98                	cltq   
  801af6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801afa:	49 89 f9             	mov    %rdi,%r9
  801afd:	49 89 f0             	mov    %rsi,%r8
  801b00:	48 89 d1             	mov    %rdx,%rcx
  801b03:	48 89 c2             	mov    %rax,%rdx
  801b06:	be 01 00 00 00       	mov    $0x1,%esi
  801b0b:	bf 05 00 00 00       	mov    $0x5,%edi
  801b10:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801b17:	00 00 00 
  801b1a:	ff d0                	callq  *%rax
}
  801b1c:	c9                   	leaveq 
  801b1d:	c3                   	retq   

0000000000801b1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b1e:	55                   	push   %rbp
  801b1f:	48 89 e5             	mov    %rsp,%rbp
  801b22:	48 83 ec 20          	sub    $0x20,%rsp
  801b26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b34:	48 98                	cltq   
  801b36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3d:	00 
  801b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4a:	48 89 d1             	mov    %rdx,%rcx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 06 00 00 00       	mov    $0x6,%edi
  801b5a:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 10          	sub    $0x10,%rsp
  801b70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b73:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b79:	48 63 d0             	movslq %eax,%rdx
  801b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7f:	48 98                	cltq   
  801b81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b88:	00 
  801b89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b95:	48 89 d1             	mov    %rdx,%rcx
  801b98:	48 89 c2             	mov    %rax,%rdx
  801b9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ba0:	bf 08 00 00 00       	mov    $0x8,%edi
  801ba5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	callq  *%rax
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 20          	sub    $0x20,%rsp
  801bbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	48 98                	cltq   
  801bcb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd2:	00 
  801bd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdf:	48 89 d1             	mov    %rdx,%rcx
  801be2:	48 89 c2             	mov    %rax,%rdx
  801be5:	be 01 00 00 00       	mov    $0x1,%esi
  801bea:	bf 09 00 00 00       	mov    $0x9,%edi
  801bef:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	callq  *%rax
}
  801bfb:	c9                   	leaveq 
  801bfc:	c3                   	retq   

0000000000801bfd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bfd:	55                   	push   %rbp
  801bfe:	48 89 e5             	mov    %rsp,%rbp
  801c01:	48 83 ec 20          	sub    $0x20,%rsp
  801c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c13:	48 98                	cltq   
  801c15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1c:	00 
  801c1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c29:	48 89 d1             	mov    %rdx,%rcx
  801c2c:	48 89 c2             	mov    %rax,%rdx
  801c2f:	be 01 00 00 00       	mov    $0x1,%esi
  801c34:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c39:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	callq  *%rax
}
  801c45:	c9                   	leaveq 
  801c46:	c3                   	retq   

0000000000801c47 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c47:	55                   	push   %rbp
  801c48:	48 89 e5             	mov    %rsp,%rbp
  801c4b:	48 83 ec 20          	sub    $0x20,%rsp
  801c4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c56:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c5a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c60:	48 63 f0             	movslq %eax,%rsi
  801c63:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6a:	48 98                	cltq   
  801c6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c77:	00 
  801c78:	49 89 f1             	mov    %rsi,%r9
  801c7b:	49 89 c8             	mov    %rcx,%r8
  801c7e:	48 89 d1             	mov    %rdx,%rcx
  801c81:	48 89 c2             	mov    %rax,%rdx
  801c84:	be 00 00 00 00       	mov    $0x0,%esi
  801c89:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c8e:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 10          	sub    $0x10,%rsp
  801ca4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb3:	00 
  801cb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc5:	48 89 c2             	mov    %rax,%rdx
  801cc8:	be 01 00 00 00       	mov    $0x1,%esi
  801ccd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cd2:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 20          	sub    $0x20,%rsp
  801ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cff:	00 
  801d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0c:	48 89 d1             	mov    %rdx,%rcx
  801d0f:	48 89 c2             	mov    %rax,%rdx
  801d12:	be 01 00 00 00       	mov    $0x1,%esi
  801d17:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d1c:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
}
  801d28:	c9                   	leaveq 
  801d29:	c3                   	retq   

0000000000801d2a <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801d2a:	55                   	push   %rbp
  801d2b:	48 89 e5             	mov    %rsp,%rbp
  801d2e:	48 83 ec 10          	sub    $0x10,%rsp
  801d32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d41:	00 
  801d42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d53:	48 89 c2             	mov    %rax,%rdx
  801d56:	be 00 00 00 00       	mov    $0x0,%esi
  801d5b:	bf 10 00 00 00       	mov    $0x10,%edi
  801d60:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
}
  801d6c:	c9                   	leaveq 
  801d6d:	c3                   	retq   

0000000000801d6e <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d6e:	55                   	push   %rbp
  801d6f:	48 89 e5             	mov    %rsp,%rbp
  801d72:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7d:	00 
  801d7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d94:	be 00 00 00 00       	mov    $0x0,%esi
  801d99:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d9e:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	callq  *%rax
}
  801daa:	c9                   	leaveq 
  801dab:	c3                   	retq   

0000000000801dac <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
  801db0:	48 83 ec 30          	sub    $0x30,%rsp
  801db4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dbc:	48 8b 00             	mov    (%rax),%rax
  801dbf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dcb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801dce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dd1:	83 e0 02             	and    $0x2,%eax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	75 4d                	jne    801e25 <pgfault+0x79>
  801dd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddc:	48 c1 e8 0c          	shr    $0xc,%rax
  801de0:	48 89 c2             	mov    %rax,%rdx
  801de3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dea:	01 00 00 
  801ded:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df1:	25 00 08 00 00       	and    $0x800,%eax
  801df6:	48 85 c0             	test   %rax,%rax
  801df9:	74 2a                	je     801e25 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801dfb:	48 ba 78 5a 80 00 00 	movabs $0x805a78,%rdx
  801e02:	00 00 00 
  801e05:	be 23 00 00 00       	mov    $0x23,%esi
  801e0a:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801e11:	00 00 00 
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801e20:	00 00 00 
  801e23:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801e25:	ba 07 00 00 00       	mov    $0x7,%edx
  801e2a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e34:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	85 c0                	test   %eax,%eax
  801e42:	0f 85 cd 00 00 00    	jne    801f15 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e54:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e5a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e62:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e67:	48 89 c6             	mov    %rax,%rsi
  801e6a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e6f:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e85:	48 89 c1             	mov    %rax,%rcx
  801e88:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e92:	bf 00 00 00 00       	mov    $0x0,%edi
  801e97:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	79 2a                	jns    801ed1 <pgfault+0x125>
				panic("Page map at temp address failed");
  801ea7:	48 ba b8 5a 80 00 00 	movabs $0x805ab8,%rdx
  801eae:	00 00 00 
  801eb1:	be 30 00 00 00       	mov    $0x30,%esi
  801eb6:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801ebd:	00 00 00 
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801ecc:	00 00 00 
  801ecf:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ed1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ed6:	bf 00 00 00 00       	mov    $0x0,%edi
  801edb:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	79 54                	jns    801f3f <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801eeb:	48 ba d8 5a 80 00 00 	movabs $0x805ad8,%rdx
  801ef2:	00 00 00 
  801ef5:	be 32 00 00 00       	mov    $0x32,%esi
  801efa:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801f01:	00 00 00 
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f10:	00 00 00 
  801f13:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f15:	48 ba 00 5b 80 00 00 	movabs $0x805b00,%rdx
  801f1c:	00 00 00 
  801f1f:	be 34 00 00 00       	mov    $0x34,%esi
  801f24:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801f2b:	00 00 00 
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f3a:	00 00 00 
  801f3d:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 20          	sub    $0x20,%rsp
  801f49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f4c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f56:	01 00 00 
  801f59:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f60:	25 07 0e 00 00       	and    $0xe07,%eax
  801f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f68:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f6b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f6f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f76:	25 00 04 00 00       	and    $0x400,%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	74 57                	je     801fd6 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f7f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f82:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f86:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8d:	41 89 f0             	mov    %esi,%r8d
  801f90:	48 89 c6             	mov    %rax,%rsi
  801f93:	bf 00 00 00 00       	mov    $0x0,%edi
  801f98:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	callq  *%rax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	0f 8e 52 01 00 00    	jle    8020fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fac:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  801fb3:	00 00 00 
  801fb6:	be 4e 00 00 00       	mov    $0x4e,%esi
  801fbb:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801fc2:	00 00 00 
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801fd1:	00 00 00 
  801fd4:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd9:	83 e0 02             	and    $0x2,%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	75 10                	jne    801ff0 <duppage+0xaf>
  801fe0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe3:	25 00 08 00 00       	and    $0x800,%eax
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	0f 84 bb 00 00 00    	je     8020ab <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801ff8:	80 cc 08             	or     $0x8,%ah
  801ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ffe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802001:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802005:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200c:	41 89 f0             	mov    %esi,%r8d
  80200f:	48 89 c6             	mov    %rax,%rsi
  802012:	bf 00 00 00 00       	mov    $0x0,%edi
  802017:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	85 c0                	test   %eax,%eax
  802025:	7e 2a                	jle    802051 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802027:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  80202e:	00 00 00 
  802031:	be 55 00 00 00       	mov    $0x55,%esi
  802036:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  80203d:	00 00 00 
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  80204c:	00 00 00 
  80204f:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802051:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802054:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205c:	41 89 c8             	mov    %ecx,%r8d
  80205f:	48 89 d1             	mov    %rdx,%rcx
  802062:	ba 00 00 00 00       	mov    $0x0,%edx
  802067:	48 89 c6             	mov    %rax,%rsi
  80206a:	bf 00 00 00 00       	mov    $0x0,%edi
  80206f:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802076:	00 00 00 
  802079:	ff d0                	callq  *%rax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	7e 2a                	jle    8020a9 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80207f:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  802086:	00 00 00 
  802089:	be 57 00 00 00       	mov    $0x57,%esi
  80208e:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  802095:	00 00 00 
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  8020a4:	00 00 00 
  8020a7:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020a9:	eb 53                	jmp    8020fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020ab:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020b2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b9:	41 89 f0             	mov    %esi,%r8d
  8020bc:	48 89 c6             	mov    %rax,%rsi
  8020bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c4:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	7e 2a                	jle    8020fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020d4:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  8020db:	00 00 00 
  8020de:	be 5b 00 00 00       	mov    $0x5b,%esi
  8020e3:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  8020ea:	00 00 00 
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f2:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  8020f9:	00 00 00 
  8020fc:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802103:	c9                   	leaveq 
  802104:	c3                   	retq   

0000000000802105 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802105:	55                   	push   %rbp
  802106:	48 89 e5             	mov    %rsp,%rbp
  802109:	48 83 ec 18          	sub    $0x18,%rsp
  80210d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211d:	48 c1 e8 27          	shr    $0x27,%rax
  802121:	48 89 c2             	mov    %rax,%rdx
  802124:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80212b:	01 00 00 
  80212e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802132:	83 e0 01             	and    $0x1,%eax
  802135:	48 85 c0             	test   %rax,%rax
  802138:	74 51                	je     80218b <pt_is_mapped+0x86>
  80213a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213e:	48 c1 e0 0c          	shl    $0xc,%rax
  802142:	48 c1 e8 1e          	shr    $0x1e,%rax
  802146:	48 89 c2             	mov    %rax,%rdx
  802149:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802150:	01 00 00 
  802153:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802157:	83 e0 01             	and    $0x1,%eax
  80215a:	48 85 c0             	test   %rax,%rax
  80215d:	74 2c                	je     80218b <pt_is_mapped+0x86>
  80215f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802163:	48 c1 e0 0c          	shl    $0xc,%rax
  802167:	48 c1 e8 15          	shr    $0x15,%rax
  80216b:	48 89 c2             	mov    %rax,%rdx
  80216e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802175:	01 00 00 
  802178:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217c:	83 e0 01             	and    $0x1,%eax
  80217f:	48 85 c0             	test   %rax,%rax
  802182:	74 07                	je     80218b <pt_is_mapped+0x86>
  802184:	b8 01 00 00 00       	mov    $0x1,%eax
  802189:	eb 05                	jmp    802190 <pt_is_mapped+0x8b>
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	83 e0 01             	and    $0x1,%eax
}
  802193:	c9                   	leaveq 
  802194:	c3                   	retq   

0000000000802195 <fork>:

envid_t
fork(void)
{
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80219d:	48 bf ac 1d 80 00 00 	movabs $0x801dac,%rdi
  8021a4:	00 00 00 
  8021a7:	48 b8 c3 50 80 00 00 	movabs $0x8050c3,%rax
  8021ae:	00 00 00 
  8021b1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8021b8:	cd 30                	int    $0x30
  8021ba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021c0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021c7:	79 30                	jns    8021f9 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021cc:	89 c1                	mov    %eax,%ecx
  8021ce:	48 ba 50 5b 80 00 00 	movabs $0x805b50,%rdx
  8021d5:	00 00 00 
  8021d8:	be 86 00 00 00       	mov    $0x86,%esi
  8021dd:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  8021e4:	00 00 00 
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8021f3:	00 00 00 
  8021f6:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8021f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021fd:	75 46                	jne    802245 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8021ff:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
  80220b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802210:	48 63 d0             	movslq %eax,%rdx
  802213:	48 89 d0             	mov    %rdx,%rax
  802216:	48 c1 e0 03          	shl    $0x3,%rax
  80221a:	48 01 d0             	add    %rdx,%rax
  80221d:	48 c1 e0 05          	shl    $0x5,%rax
  802221:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802228:	00 00 00 
  80222b:	48 01 c2             	add    %rax,%rdx
  80222e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802235:	00 00 00 
  802238:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
  802240:	e9 d1 01 00 00       	jmpq   802416 <fork+0x281>
	}
	uint64_t ad = 0;
  802245:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80224c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80224d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802256:	e9 df 00 00 00       	jmpq   80233a <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80225b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225f:	48 c1 e8 27          	shr    $0x27,%rax
  802263:	48 89 c2             	mov    %rax,%rdx
  802266:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80226d:	01 00 00 
  802270:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802274:	83 e0 01             	and    $0x1,%eax
  802277:	48 85 c0             	test   %rax,%rax
  80227a:	0f 84 9e 00 00 00    	je     80231e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802284:	48 c1 e8 1e          	shr    $0x1e,%rax
  802288:	48 89 c2             	mov    %rax,%rdx
  80228b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802292:	01 00 00 
  802295:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802299:	83 e0 01             	and    $0x1,%eax
  80229c:	48 85 c0             	test   %rax,%rax
  80229f:	74 73                	je     802314 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8022a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a5:	48 c1 e8 15          	shr    $0x15,%rax
  8022a9:	48 89 c2             	mov    %rax,%rdx
  8022ac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b3:	01 00 00 
  8022b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ba:	83 e0 01             	and    $0x1,%eax
  8022bd:	48 85 c0             	test   %rax,%rax
  8022c0:	74 48                	je     80230a <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ca:	48 89 c2             	mov    %rax,%rdx
  8022cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d4:	01 00 00 
  8022d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e3:	83 e0 01             	and    $0x1,%eax
  8022e6:	48 85 c0             	test   %rax,%rax
  8022e9:	74 47                	je     802332 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8022eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f3:	89 c2                	mov    %eax,%edx
  8022f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f8:	89 d6                	mov    %edx,%esi
  8022fa:	89 c7                	mov    %eax,%edi
  8022fc:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
  802308:	eb 28                	jmp    802332 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80230a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802311:	00 
  802312:	eb 1e                	jmp    802332 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802314:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80231b:	40 
  80231c:	eb 14                	jmp    802332 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80231e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802322:	48 c1 e8 27          	shr    $0x27,%rax
  802326:	48 83 c0 01          	add    $0x1,%rax
  80232a:	48 c1 e0 27          	shl    $0x27,%rax
  80232e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802332:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802339:	00 
  80233a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802341:	00 
  802342:	0f 87 13 ff ff ff    	ja     80225b <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802348:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80234b:	ba 07 00 00 00       	mov    $0x7,%edx
  802350:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802355:	89 c7                	mov    %eax,%edi
  802357:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802366:	ba 07 00 00 00       	mov    $0x7,%edx
  80236b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802370:	89 c7                	mov    %eax,%edi
  802372:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80237e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802381:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802387:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80238c:	ba 00 00 00 00       	mov    $0x0,%edx
  802391:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023a9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023ae:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023b3:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023bf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c9:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8023d0:	00 00 00 
  8023d3:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8023d5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023dc:	00 00 00 
  8023df:	48 8b 00             	mov    (%rax),%rax
  8023e2:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023ec:	48 89 d6             	mov    %rdx,%rsi
  8023ef:	89 c7                	mov    %eax,%edi
  8023f1:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8023fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802400:	be 02 00 00 00       	mov    $0x2,%esi
  802405:	89 c7                	mov    %eax,%edi
  802407:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  80240e:	00 00 00 
  802411:	ff d0                	callq  *%rax

	return envid;
  802413:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802416:	c9                   	leaveq 
  802417:	c3                   	retq   

0000000000802418 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802418:	55                   	push   %rbp
  802419:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80241c:	48 ba 68 5b 80 00 00 	movabs $0x805b68,%rdx
  802423:	00 00 00 
  802426:	be bf 00 00 00       	mov    $0xbf,%esi
  80242b:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  802432:	00 00 00 
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  802441:	00 00 00 
  802444:	ff d1                	callq  *%rcx

0000000000802446 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802446:	55                   	push   %rbp
  802447:	48 89 e5             	mov    %rsp,%rbp
  80244a:	48 83 ec 08          	sub    $0x8,%rsp
  80244e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802452:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802456:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80245d:	ff ff ff 
  802460:	48 01 d0             	add    %rdx,%rax
  802463:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 08          	sub    $0x8,%rsp
  802471:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802479:	48 89 c7             	mov    %rax,%rdi
  80247c:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  802483:	00 00 00 
  802486:	ff d0                	callq  *%rax
  802488:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80248e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802492:	c9                   	leaveq 
  802493:	c3                   	retq   

0000000000802494 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802494:	55                   	push   %rbp
  802495:	48 89 e5             	mov    %rsp,%rbp
  802498:	48 83 ec 18          	sub    $0x18,%rsp
  80249c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a7:	eb 6b                	jmp    802514 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ac:	48 98                	cltq   
  8024ae:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024b4:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c0:	48 c1 e8 15          	shr    $0x15,%rax
  8024c4:	48 89 c2             	mov    %rax,%rdx
  8024c7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024ce:	01 00 00 
  8024d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d5:	83 e0 01             	and    $0x1,%eax
  8024d8:	48 85 c0             	test   %rax,%rax
  8024db:	74 21                	je     8024fe <fd_alloc+0x6a>
  8024dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e1:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e5:	48 89 c2             	mov    %rax,%rdx
  8024e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ef:	01 00 00 
  8024f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f6:	83 e0 01             	and    $0x1,%eax
  8024f9:	48 85 c0             	test   %rax,%rax
  8024fc:	75 12                	jne    802510 <fd_alloc+0x7c>
			*fd_store = fd;
  8024fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802502:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802506:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	eb 1a                	jmp    80252a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802510:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802514:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802518:	7e 8f                	jle    8024a9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80251a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802525:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80252c:	55                   	push   %rbp
  80252d:	48 89 e5             	mov    %rsp,%rbp
  802530:	48 83 ec 20          	sub    $0x20,%rsp
  802534:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802537:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80253b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80253f:	78 06                	js     802547 <fd_lookup+0x1b>
  802541:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802545:	7e 07                	jle    80254e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802547:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80254c:	eb 6c                	jmp    8025ba <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80254e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802551:	48 98                	cltq   
  802553:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802559:	48 c1 e0 0c          	shl    $0xc,%rax
  80255d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802565:	48 c1 e8 15          	shr    $0x15,%rax
  802569:	48 89 c2             	mov    %rax,%rdx
  80256c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802573:	01 00 00 
  802576:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257a:	83 e0 01             	and    $0x1,%eax
  80257d:	48 85 c0             	test   %rax,%rax
  802580:	74 21                	je     8025a3 <fd_lookup+0x77>
  802582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802586:	48 c1 e8 0c          	shr    $0xc,%rax
  80258a:	48 89 c2             	mov    %rax,%rdx
  80258d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802594:	01 00 00 
  802597:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259b:	83 e0 01             	and    $0x1,%eax
  80259e:	48 85 c0             	test   %rax,%rax
  8025a1:	75 07                	jne    8025aa <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a8:	eb 10                	jmp    8025ba <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025b2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ba:	c9                   	leaveq 
  8025bb:	c3                   	retq   

00000000008025bc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025bc:	55                   	push   %rbp
  8025bd:	48 89 e5             	mov    %rsp,%rbp
  8025c0:	48 83 ec 30          	sub    $0x30,%rsp
  8025c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025c8:	89 f0                	mov    %esi,%eax
  8025ca:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d1:	48 89 c7             	mov    %rax,%rdi
  8025d4:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	callq  *%rax
  8025e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e4:	48 89 d6             	mov    %rdx,%rsi
  8025e7:	89 c7                	mov    %eax,%edi
  8025e9:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  8025f0:	00 00 00 
  8025f3:	ff d0                	callq  *%rax
  8025f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fc:	78 0a                	js     802608 <fd_close+0x4c>
	    || fd != fd2)
  8025fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802602:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802606:	74 12                	je     80261a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802608:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80260c:	74 05                	je     802613 <fd_close+0x57>
  80260e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802611:	eb 05                	jmp    802618 <fd_close+0x5c>
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	eb 69                	jmp    802683 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80261a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261e:	8b 00                	mov    (%rax),%eax
  802620:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802624:	48 89 d6             	mov    %rdx,%rsi
  802627:	89 c7                	mov    %eax,%edi
  802629:	48 b8 85 26 80 00 00 	movabs $0x802685,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
  802635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263c:	78 2a                	js     802668 <fd_close+0xac>
		if (dev->dev_close)
  80263e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802642:	48 8b 40 20          	mov    0x20(%rax),%rax
  802646:	48 85 c0             	test   %rax,%rax
  802649:	74 16                	je     802661 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802653:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802657:	48 89 d7             	mov    %rdx,%rdi
  80265a:	ff d0                	callq  *%rax
  80265c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265f:	eb 07                	jmp    802668 <fd_close+0xac>
		else
			r = 0;
  802661:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266c:	48 89 c6             	mov    %rax,%rsi
  80266f:	bf 00 00 00 00       	mov    $0x0,%edi
  802674:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
	return r;
  802680:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802683:	c9                   	leaveq 
  802684:	c3                   	retq   

0000000000802685 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802685:	55                   	push   %rbp
  802686:	48 89 e5             	mov    %rsp,%rbp
  802689:	48 83 ec 20          	sub    $0x20,%rsp
  80268d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802690:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80269b:	eb 41                	jmp    8026de <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80269d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026a4:	00 00 00 
  8026a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026aa:	48 63 d2             	movslq %edx,%rdx
  8026ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b1:	8b 00                	mov    (%rax),%eax
  8026b3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026b6:	75 22                	jne    8026da <dev_lookup+0x55>
			*dev = devtab[i];
  8026b8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026bf:	00 00 00 
  8026c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026c5:	48 63 d2             	movslq %edx,%rdx
  8026c8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	eb 60                	jmp    80273a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026de:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026e5:	00 00 00 
  8026e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026eb:	48 63 d2             	movslq %edx,%rdx
  8026ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f2:	48 85 c0             	test   %rax,%rax
  8026f5:	75 a6                	jne    80269d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026f7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026fe:	00 00 00 
  802701:	48 8b 00             	mov    (%rax),%rax
  802704:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80270a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80270d:	89 c6                	mov    %eax,%esi
  80270f:	48 bf 80 5b 80 00 00 	movabs $0x805b80,%rdi
  802716:	00 00 00 
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802725:	00 00 00 
  802728:	ff d1                	callq  *%rcx
	*dev = 0;
  80272a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80273a:	c9                   	leaveq 
  80273b:	c3                   	retq   

000000000080273c <close>:

int
close(int fdnum)
{
  80273c:	55                   	push   %rbp
  80273d:	48 89 e5             	mov    %rsp,%rbp
  802740:	48 83 ec 20          	sub    $0x20,%rsp
  802744:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802747:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	89 c7                	mov    %eax,%edi
  802753:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802766:	79 05                	jns    80276d <close+0x31>
		return r;
  802768:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80276b:	eb 18                	jmp    802785 <close+0x49>
	else
		return fd_close(fd, 1);
  80276d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802771:	be 01 00 00 00       	mov    $0x1,%esi
  802776:	48 89 c7             	mov    %rax,%rdi
  802779:	48 b8 bc 25 80 00 00 	movabs $0x8025bc,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
}
  802785:	c9                   	leaveq 
  802786:	c3                   	retq   

0000000000802787 <close_all>:

void
close_all(void)
{
  802787:	55                   	push   %rbp
  802788:	48 89 e5             	mov    %rsp,%rbp
  80278b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80278f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802796:	eb 15                	jmp    8027ad <close_all+0x26>
		close(i);
  802798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279b:	89 c7                	mov    %eax,%edi
  80279d:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  8027a4:	00 00 00 
  8027a7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027ad:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027b1:	7e e5                	jle    802798 <close_all+0x11>
		close(i);
}
  8027b3:	c9                   	leaveq 
  8027b4:	c3                   	retq   

00000000008027b5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027b5:	55                   	push   %rbp
  8027b6:	48 89 e5             	mov    %rsp,%rbp
  8027b9:	48 83 ec 40          	sub    $0x40,%rsp
  8027bd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027c0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027c3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027c7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ca:	48 89 d6             	mov    %rdx,%rsi
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
  8027db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e2:	79 08                	jns    8027ec <dup+0x37>
		return r;
  8027e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e7:	e9 70 01 00 00       	jmpq   80295c <dup+0x1a7>
	close(newfdnum);
  8027ec:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ef:	89 c7                	mov    %eax,%edi
  8027f1:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027fd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802800:	48 98                	cltq   
  802802:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802808:	48 c1 e0 0c          	shl    $0xc,%rax
  80280c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802814:	48 89 c7             	mov    %rax,%rdi
  802817:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	48 89 c7             	mov    %rax,%rdi
  80282e:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  802835:	00 00 00 
  802838:	ff d0                	callq  *%rax
  80283a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80283e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802842:	48 c1 e8 15          	shr    $0x15,%rax
  802846:	48 89 c2             	mov    %rax,%rdx
  802849:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802850:	01 00 00 
  802853:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802857:	83 e0 01             	and    $0x1,%eax
  80285a:	48 85 c0             	test   %rax,%rax
  80285d:	74 73                	je     8028d2 <dup+0x11d>
  80285f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802863:	48 c1 e8 0c          	shr    $0xc,%rax
  802867:	48 89 c2             	mov    %rax,%rdx
  80286a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802871:	01 00 00 
  802874:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802878:	83 e0 01             	and    $0x1,%eax
  80287b:	48 85 c0             	test   %rax,%rax
  80287e:	74 52                	je     8028d2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802884:	48 c1 e8 0c          	shr    $0xc,%rax
  802888:	48 89 c2             	mov    %rax,%rdx
  80288b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802892:	01 00 00 
  802895:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802899:	25 07 0e 00 00       	and    $0xe07,%eax
  80289e:	89 c1                	mov    %eax,%ecx
  8028a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a8:	41 89 c8             	mov    %ecx,%r8d
  8028ab:	48 89 d1             	mov    %rdx,%rcx
  8028ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b3:	48 89 c6             	mov    %rax,%rsi
  8028b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bb:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
  8028c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ce:	79 02                	jns    8028d2 <dup+0x11d>
			goto err;
  8028d0:	eb 57                	jmp    802929 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8028da:	48 89 c2             	mov    %rax,%rdx
  8028dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028e4:	01 00 00 
  8028e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8028f0:	89 c1                	mov    %eax,%ecx
  8028f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028fa:	41 89 c8             	mov    %ecx,%r8d
  8028fd:	48 89 d1             	mov    %rdx,%rcx
  802900:	ba 00 00 00 00       	mov    $0x0,%edx
  802905:	48 89 c6             	mov    %rax,%rsi
  802908:	bf 00 00 00 00       	mov    $0x0,%edi
  80290d:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802914:	00 00 00 
  802917:	ff d0                	callq  *%rax
  802919:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802920:	79 02                	jns    802924 <dup+0x16f>
		goto err;
  802922:	eb 05                	jmp    802929 <dup+0x174>

	return newfdnum;
  802924:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802927:	eb 33                	jmp    80295c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292d:	48 89 c6             	mov    %rax,%rsi
  802930:	bf 00 00 00 00       	mov    $0x0,%edi
  802935:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802941:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802945:	48 89 c6             	mov    %rax,%rsi
  802948:	bf 00 00 00 00       	mov    $0x0,%edi
  80294d:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
	return r;
  802959:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80295c:	c9                   	leaveq 
  80295d:	c3                   	retq   

000000000080295e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80295e:	55                   	push   %rbp
  80295f:	48 89 e5             	mov    %rsp,%rbp
  802962:	48 83 ec 40          	sub    $0x40,%rsp
  802966:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802969:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80296d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802971:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802975:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802978:	48 89 d6             	mov    %rdx,%rsi
  80297b:	89 c7                	mov    %eax,%edi
  80297d:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  802984:	00 00 00 
  802987:	ff d0                	callq  *%rax
  802989:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802990:	78 24                	js     8029b6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802996:	8b 00                	mov    (%rax),%eax
  802998:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80299c:	48 89 d6             	mov    %rdx,%rsi
  80299f:	89 c7                	mov    %eax,%edi
  8029a1:	48 b8 85 26 80 00 00 	movabs $0x802685,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b4:	79 05                	jns    8029bb <read+0x5d>
		return r;
  8029b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b9:	eb 76                	jmp    802a31 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	8b 40 08             	mov    0x8(%rax),%eax
  8029c2:	83 e0 03             	and    $0x3,%eax
  8029c5:	83 f8 01             	cmp    $0x1,%eax
  8029c8:	75 3a                	jne    802a04 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ca:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029d1:	00 00 00 
  8029d4:	48 8b 00             	mov    (%rax),%rax
  8029d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029dd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e0:	89 c6                	mov    %eax,%esi
  8029e2:	48 bf 9f 5b 80 00 00 	movabs $0x805b9f,%rdi
  8029e9:	00 00 00 
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  8029f8:	00 00 00 
  8029fb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a02:	eb 2d                	jmp    802a31 <read+0xd3>
	}
	if (!dev->dev_read)
  802a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a08:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a0c:	48 85 c0             	test   %rax,%rax
  802a0f:	75 07                	jne    802a18 <read+0xba>
		return -E_NOT_SUPP;
  802a11:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a16:	eb 19                	jmp    802a31 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a20:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a28:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a2c:	48 89 cf             	mov    %rcx,%rdi
  802a2f:	ff d0                	callq  *%rax
}
  802a31:	c9                   	leaveq 
  802a32:	c3                   	retq   

0000000000802a33 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a33:	55                   	push   %rbp
  802a34:	48 89 e5             	mov    %rsp,%rbp
  802a37:	48 83 ec 30          	sub    $0x30,%rsp
  802a3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a42:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a4d:	eb 49                	jmp    802a98 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a52:	48 98                	cltq   
  802a54:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a58:	48 29 c2             	sub    %rax,%rdx
  802a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5e:	48 63 c8             	movslq %eax,%rcx
  802a61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a65:	48 01 c1             	add    %rax,%rcx
  802a68:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a6b:	48 89 ce             	mov    %rcx,%rsi
  802a6e:	89 c7                	mov    %eax,%edi
  802a70:	48 b8 5e 29 80 00 00 	movabs $0x80295e,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a7f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a83:	79 05                	jns    802a8a <readn+0x57>
			return m;
  802a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a88:	eb 1c                	jmp    802aa6 <readn+0x73>
		if (m == 0)
  802a8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a8e:	75 02                	jne    802a92 <readn+0x5f>
			break;
  802a90:	eb 11                	jmp    802aa3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a95:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9b:	48 98                	cltq   
  802a9d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802aa1:	72 ac                	jb     802a4f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aa6:	c9                   	leaveq 
  802aa7:	c3                   	retq   

0000000000802aa8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802aa8:	55                   	push   %rbp
  802aa9:	48 89 e5             	mov    %rsp,%rbp
  802aac:	48 83 ec 40          	sub    $0x40,%rsp
  802ab0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ab3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ab7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802abb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802abf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac2:	48 89 d6             	mov    %rdx,%rsi
  802ac5:	89 c7                	mov    %eax,%edi
  802ac7:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
  802ad3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ada:	78 24                	js     802b00 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae0:	8b 00                	mov    (%rax),%eax
  802ae2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae6:	48 89 d6             	mov    %rdx,%rsi
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 85 26 80 00 00 	movabs $0x802685,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	79 05                	jns    802b05 <write+0x5d>
		return r;
  802b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b03:	eb 75                	jmp    802b7a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b09:	8b 40 08             	mov    0x8(%rax),%eax
  802b0c:	83 e0 03             	and    $0x3,%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	75 3a                	jne    802b4d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b13:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b1a:	00 00 00 
  802b1d:	48 8b 00             	mov    (%rax),%rax
  802b20:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b26:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b29:	89 c6                	mov    %eax,%esi
  802b2b:	48 bf bb 5b 80 00 00 	movabs $0x805bbb,%rdi
  802b32:	00 00 00 
  802b35:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3a:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802b41:	00 00 00 
  802b44:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b4b:	eb 2d                	jmp    802b7a <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802b4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b51:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b55:	48 85 c0             	test   %rax,%rax
  802b58:	75 07                	jne    802b61 <write+0xb9>
		return -E_NOT_SUPP;
  802b5a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b5f:	eb 19                	jmp    802b7a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b65:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b69:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b71:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b75:	48 89 cf             	mov    %rcx,%rdi
  802b78:	ff d0                	callq  *%rax
}
  802b7a:	c9                   	leaveq 
  802b7b:	c3                   	retq   

0000000000802b7c <seek>:

int
seek(int fdnum, off_t offset)
{
  802b7c:	55                   	push   %rbp
  802b7d:	48 89 e5             	mov    %rsp,%rbp
  802b80:	48 83 ec 18          	sub    $0x18,%rsp
  802b84:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b87:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b91:	48 89 d6             	mov    %rdx,%rsi
  802b94:	89 c7                	mov    %eax,%edi
  802b96:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
  802ba2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba9:	79 05                	jns    802bb0 <seek+0x34>
		return r;
  802bab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bae:	eb 0f                	jmp    802bbf <seek+0x43>
	fd->fd_offset = offset;
  802bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bb7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbf:	c9                   	leaveq 
  802bc0:	c3                   	retq   

0000000000802bc1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bc1:	55                   	push   %rbp
  802bc2:	48 89 e5             	mov    %rsp,%rbp
  802bc5:	48 83 ec 30          	sub    $0x30,%rsp
  802bc9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bcc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bcf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bd6:	48 89 d6             	mov    %rdx,%rsi
  802bd9:	89 c7                	mov    %eax,%edi
  802bdb:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bee:	78 24                	js     802c14 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf4:	8b 00                	mov    (%rax),%eax
  802bf6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bfa:	48 89 d6             	mov    %rdx,%rsi
  802bfd:	89 c7                	mov    %eax,%edi
  802bff:	48 b8 85 26 80 00 00 	movabs $0x802685,%rax
  802c06:	00 00 00 
  802c09:	ff d0                	callq  *%rax
  802c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c12:	79 05                	jns    802c19 <ftruncate+0x58>
		return r;
  802c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c17:	eb 72                	jmp    802c8b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1d:	8b 40 08             	mov    0x8(%rax),%eax
  802c20:	83 e0 03             	and    $0x3,%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	75 3a                	jne    802c61 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c27:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c2e:	00 00 00 
  802c31:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c34:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c3a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c3d:	89 c6                	mov    %eax,%esi
  802c3f:	48 bf d8 5b 80 00 00 	movabs $0x805bd8,%rdi
  802c46:	00 00 00 
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802c55:	00 00 00 
  802c58:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c5f:	eb 2a                	jmp    802c8b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c65:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c69:	48 85 c0             	test   %rax,%rax
  802c6c:	75 07                	jne    802c75 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c6e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c73:	eb 16                	jmp    802c8b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c79:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c81:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c84:	89 ce                	mov    %ecx,%esi
  802c86:	48 89 d7             	mov    %rdx,%rdi
  802c89:	ff d0                	callq  *%rax
}
  802c8b:	c9                   	leaveq 
  802c8c:	c3                   	retq   

0000000000802c8d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c8d:	55                   	push   %rbp
  802c8e:	48 89 e5             	mov    %rsp,%rbp
  802c91:	48 83 ec 30          	sub    $0x30,%rsp
  802c95:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c98:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c9c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca3:	48 89 d6             	mov    %rdx,%rsi
  802ca6:	89 c7                	mov    %eax,%edi
  802ca8:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
  802cb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbb:	78 24                	js     802ce1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc1:	8b 00                	mov    (%rax),%eax
  802cc3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc7:	48 89 d6             	mov    %rdx,%rsi
  802cca:	89 c7                	mov    %eax,%edi
  802ccc:	48 b8 85 26 80 00 00 	movabs $0x802685,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdf:	79 05                	jns    802ce6 <fstat+0x59>
		return r;
  802ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce4:	eb 5e                	jmp    802d44 <fstat+0xb7>
	if (!dev->dev_stat)
  802ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cea:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cee:	48 85 c0             	test   %rax,%rax
  802cf1:	75 07                	jne    802cfa <fstat+0x6d>
		return -E_NOT_SUPP;
  802cf3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf8:	eb 4a                	jmp    802d44 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cfa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfe:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d05:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d0c:	00 00 00 
	stat->st_isdir = 0;
  802d0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d13:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d1a:	00 00 00 
	stat->st_dev = dev;
  802d1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d25:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d30:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d38:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d3c:	48 89 ce             	mov    %rcx,%rsi
  802d3f:	48 89 d7             	mov    %rdx,%rdi
  802d42:	ff d0                	callq  *%rax
}
  802d44:	c9                   	leaveq 
  802d45:	c3                   	retq   

0000000000802d46 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d46:	55                   	push   %rbp
  802d47:	48 89 e5             	mov    %rsp,%rbp
  802d4a:	48 83 ec 20          	sub    $0x20,%rsp
  802d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5a:	be 00 00 00 00       	mov    $0x0,%esi
  802d5f:	48 89 c7             	mov    %rax,%rdi
  802d62:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
  802d6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d75:	79 05                	jns    802d7c <stat+0x36>
		return fd;
  802d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7a:	eb 2f                	jmp    802dab <stat+0x65>
	r = fstat(fd, stat);
  802d7c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d83:	48 89 d6             	mov    %rdx,%rsi
  802d86:	89 c7                	mov    %eax,%edi
  802d88:	48 b8 8d 2c 80 00 00 	movabs $0x802c8d,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	callq  *%rax
  802d94:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9a:	89 c7                	mov    %eax,%edi
  802d9c:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  802da3:	00 00 00 
  802da6:	ff d0                	callq  *%rax
	return r;
  802da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dab:	c9                   	leaveq 
  802dac:	c3                   	retq   

0000000000802dad <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dad:	55                   	push   %rbp
  802dae:	48 89 e5             	mov    %rsp,%rbp
  802db1:	48 83 ec 10          	sub    $0x10,%rsp
  802db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802db8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dbc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc3:	00 00 00 
  802dc6:	8b 00                	mov    (%rax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	75 1d                	jne    802de9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802dcc:	bf 01 00 00 00       	mov    $0x1,%edi
  802dd1:	48 b8 6b 53 80 00 00 	movabs $0x80536b,%rax
  802dd8:	00 00 00 
  802ddb:	ff d0                	callq  *%rax
  802ddd:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802de4:	00 00 00 
  802de7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802de9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df0:	00 00 00 
  802df3:	8b 00                	mov    (%rax),%eax
  802df5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802df8:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dfd:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e04:	00 00 00 
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 09 53 80 00 00 	movabs $0x805309,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e19:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1e:	48 89 c6             	mov    %rax,%rsi
  802e21:	bf 00 00 00 00       	mov    $0x0,%edi
  802e26:	48 b8 03 52 80 00 00 	movabs $0x805203,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
}
  802e32:	c9                   	leaveq 
  802e33:	c3                   	retq   

0000000000802e34 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e34:	55                   	push   %rbp
  802e35:	48 89 e5             	mov    %rsp,%rbp
  802e38:	48 83 ec 30          	sub    $0x30,%rsp
  802e3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e40:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e43:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e4a:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e58:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e5d:	75 08                	jne    802e67 <open+0x33>
	{
		return r;
  802e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e62:	e9 f2 00 00 00       	jmpq   802f59 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6b:	48 89 c7             	mov    %rax,%rdi
  802e6e:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e7d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e84:	7e 0a                	jle    802e90 <open+0x5c>
	{
		return -E_BAD_PATH;
  802e86:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e8b:	e9 c9 00 00 00       	jmpq   802f59 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e90:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e97:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e98:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e9c:	48 89 c7             	mov    %rax,%rdi
  802e9f:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
  802eab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb2:	78 09                	js     802ebd <open+0x89>
  802eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb8:	48 85 c0             	test   %rax,%rax
  802ebb:	75 08                	jne    802ec5 <open+0x91>
		{
			return r;
  802ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec0:	e9 94 00 00 00       	jmpq   802f59 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec9:	ba 00 04 00 00       	mov    $0x400,%edx
  802ece:	48 89 c6             	mov    %rax,%rsi
  802ed1:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ed8:	00 00 00 
  802edb:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ee7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802eee:	00 00 00 
  802ef1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ef4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802efa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efe:	48 89 c6             	mov    %rax,%rsi
  802f01:	bf 01 00 00 00       	mov    $0x1,%edi
  802f06:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f19:	79 2b                	jns    802f46 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1f:	be 00 00 00 00       	mov    $0x0,%esi
  802f24:	48 89 c7             	mov    %rax,%rdi
  802f27:	48 b8 bc 25 80 00 00 	movabs $0x8025bc,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f36:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f3a:	79 05                	jns    802f41 <open+0x10d>
			{
				return d;
  802f3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f3f:	eb 18                	jmp    802f59 <open+0x125>
			}
			return r;
  802f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f44:	eb 13                	jmp    802f59 <open+0x125>
		}	
		return fd2num(fd_store);
  802f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4a:	48 89 c7             	mov    %rax,%rdi
  802f4d:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f59:	c9                   	leaveq 
  802f5a:	c3                   	retq   

0000000000802f5b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f5b:	55                   	push   %rbp
  802f5c:	48 89 e5             	mov    %rsp,%rbp
  802f5f:	48 83 ec 10          	sub    $0x10,%rsp
  802f63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f75:	00 00 00 
  802f78:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f7a:	be 00 00 00 00       	mov    $0x0,%esi
  802f7f:	bf 06 00 00 00       	mov    $0x6,%edi
  802f84:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
}
  802f90:	c9                   	leaveq 
  802f91:	c3                   	retq   

0000000000802f92 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f92:	55                   	push   %rbp
  802f93:	48 89 e5             	mov    %rsp,%rbp
  802f96:	48 83 ec 30          	sub    $0x30,%rsp
  802f9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802fad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fb2:	74 07                	je     802fbb <devfile_read+0x29>
  802fb4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fb9:	75 07                	jne    802fc2 <devfile_read+0x30>
		return -E_INVAL;
  802fbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fc0:	eb 77                	jmp    803039 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc6:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fd0:	00 00 00 
  802fd3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fd5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fdc:	00 00 00 
  802fdf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fe3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802fe7:	be 00 00 00 00       	mov    $0x0,%esi
  802fec:	bf 03 00 00 00       	mov    $0x3,%edi
  802ff1:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
  802ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803004:	7f 05                	jg     80300b <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803009:	eb 2e                	jmp    803039 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	48 63 d0             	movslq %eax,%rdx
  803011:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803015:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80301c:	00 00 00 
  80301f:	48 89 c7             	mov    %rax,%rdi
  803022:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80302e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803032:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 30          	sub    $0x30,%rsp
  803043:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803047:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80304b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80304f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803056:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80305b:	74 07                	je     803064 <devfile_write+0x29>
  80305d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803062:	75 08                	jne    80306c <devfile_write+0x31>
		return r;
  803064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803067:	e9 9a 00 00 00       	jmpq   803106 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80306c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803070:	8b 50 0c             	mov    0xc(%rax),%edx
  803073:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80307a:	00 00 00 
  80307d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80307f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803086:	00 
  803087:	76 08                	jbe    803091 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803089:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803090:	00 
	}
	fsipcbuf.write.req_n = n;
  803091:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803098:	00 00 00 
  80309b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80309f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ab:	48 89 c6             	mov    %rax,%rsi
  8030ae:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8030b5:	00 00 00 
  8030b8:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030c4:	be 00 00 00 00       	mov    $0x0,%esi
  8030c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8030ce:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  8030d5:	00 00 00 
  8030d8:	ff d0                	callq  *%rax
  8030da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e1:	7f 20                	jg     803103 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030e3:	48 bf fe 5b 80 00 00 	movabs $0x805bfe,%rdi
  8030ea:	00 00 00 
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8030f9:	00 00 00 
  8030fc:	ff d2                	callq  *%rdx
		return r;
  8030fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803101:	eb 03                	jmp    803106 <devfile_write+0xcb>
	}
	return r;
  803103:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 83 ec 20          	sub    $0x20,%rsp
  803110:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803114:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311c:	8b 50 0c             	mov    0xc(%rax),%edx
  80311f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803126:	00 00 00 
  803129:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80312b:	be 00 00 00 00       	mov    $0x0,%esi
  803130:	bf 05 00 00 00       	mov    $0x5,%edi
  803135:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  80313c:	00 00 00 
  80313f:	ff d0                	callq  *%rax
  803141:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803144:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803148:	79 05                	jns    80314f <devfile_stat+0x47>
		return r;
  80314a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314d:	eb 56                	jmp    8031a5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80314f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803153:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80315a:	00 00 00 
  80315d:	48 89 c7             	mov    %rax,%rdi
  803160:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80316c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803173:	00 00 00 
  803176:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80317c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803180:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803186:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80318d:	00 00 00 
  803190:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a5:	c9                   	leaveq 
  8031a6:	c3                   	retq   

00000000008031a7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031a7:	55                   	push   %rbp
  8031a8:	48 89 e5             	mov    %rsp,%rbp
  8031ab:	48 83 ec 10          	sub    $0x10,%rsp
  8031af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8031bd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031c4:	00 00 00 
  8031c7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031c9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031d0:	00 00 00 
  8031d3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031d6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031d9:	be 00 00 00 00       	mov    $0x0,%esi
  8031de:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e3:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
  8031f5:	48 83 ec 10          	sub    $0x10,%rsp
  8031f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803201:	48 89 c7             	mov    %rax,%rdi
  803204:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803215:	7e 07                	jle    80321e <remove+0x2d>
		return -E_BAD_PATH;
  803217:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80321c:	eb 33                	jmp    803251 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80321e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803222:	48 89 c6             	mov    %rax,%rsi
  803225:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80322c:	00 00 00 
  80322f:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80323b:	be 00 00 00 00       	mov    $0x0,%esi
  803240:	bf 07 00 00 00       	mov    $0x7,%edi
  803245:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
}
  803251:	c9                   	leaveq 
  803252:	c3                   	retq   

0000000000803253 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803253:	55                   	push   %rbp
  803254:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803257:	be 00 00 00 00       	mov    $0x0,%esi
  80325c:	bf 08 00 00 00       	mov    $0x8,%edi
  803261:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
}
  80326d:	5d                   	pop    %rbp
  80326e:	c3                   	retq   

000000000080326f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80327a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803281:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803288:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80328f:	be 00 00 00 00       	mov    $0x0,%esi
  803294:	48 89 c7             	mov    %rax,%rdi
  803297:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
  8032a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032aa:	79 28                	jns    8032d4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032af:	89 c6                	mov    %eax,%esi
  8032b1:	48 bf 1a 5c 80 00 00 	movabs $0x805c1a,%rdi
  8032b8:	00 00 00 
  8032bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c0:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8032c7:	00 00 00 
  8032ca:	ff d2                	callq  *%rdx
		return fd_src;
  8032cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cf:	e9 74 01 00 00       	jmpq   803448 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032d4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032db:	be 01 01 00 00       	mov    $0x101,%esi
  8032e0:	48 89 c7             	mov    %rax,%rdi
  8032e3:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
  8032ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032f2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032f6:	79 39                	jns    803331 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032fb:	89 c6                	mov    %eax,%esi
  8032fd:	48 bf 30 5c 80 00 00 	movabs $0x805c30,%rdi
  803304:	00 00 00 
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
  80330c:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  803313:	00 00 00 
  803316:	ff d2                	callq  *%rdx
		close(fd_src);
  803318:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331b:	89 c7                	mov    %eax,%edi
  80331d:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
		return fd_dest;
  803329:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80332c:	e9 17 01 00 00       	jmpq   803448 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803331:	eb 74                	jmp    8033a7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803333:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803336:	48 63 d0             	movslq %eax,%rdx
  803339:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803340:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803343:	48 89 ce             	mov    %rcx,%rsi
  803346:	89 c7                	mov    %eax,%edi
  803348:	48 b8 a8 2a 80 00 00 	movabs $0x802aa8,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
  803354:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803357:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80335b:	79 4a                	jns    8033a7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80335d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803360:	89 c6                	mov    %eax,%esi
  803362:	48 bf 4a 5c 80 00 00 	movabs $0x805c4a,%rdi
  803369:	00 00 00 
  80336c:	b8 00 00 00 00       	mov    $0x0,%eax
  803371:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  803378:	00 00 00 
  80337b:	ff d2                	callq  *%rdx
			close(fd_src);
  80337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803380:	89 c7                	mov    %eax,%edi
  803382:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
			close(fd_dest);
  80338e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803391:	89 c7                	mov    %eax,%edi
  803393:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
			return write_size;
  80339f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a2:	e9 a1 00 00 00       	jmpq   803448 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033a7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b1:	ba 00 02 00 00       	mov    $0x200,%edx
  8033b6:	48 89 ce             	mov    %rcx,%rsi
  8033b9:	89 c7                	mov    %eax,%edi
  8033bb:	48 b8 5e 29 80 00 00 	movabs $0x80295e,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033ce:	0f 8f 5f ff ff ff    	jg     803333 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033d8:	79 47                	jns    803421 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033dd:	89 c6                	mov    %eax,%esi
  8033df:	48 bf 5d 5c 80 00 00 	movabs $0x805c5d,%rdi
  8033e6:	00 00 00 
  8033e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ee:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8033f5:	00 00 00 
  8033f8:	ff d2                	callq  *%rdx
		close(fd_src);
  8033fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fd:	89 c7                	mov    %eax,%edi
  8033ff:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
		close(fd_dest);
  80340b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340e:	89 c7                	mov    %eax,%edi
  803410:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
		return read_size;
  80341c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80341f:	eb 27                	jmp    803448 <copy+0x1d9>
	}
	close(fd_src);
  803421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803424:	89 c7                	mov    %eax,%edi
  803426:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  80342d:	00 00 00 
  803430:	ff d0                	callq  *%rax
	close(fd_dest);
  803432:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803435:	89 c7                	mov    %eax,%edi
  803437:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
	return 0;
  803443:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803448:	c9                   	leaveq 
  803449:	c3                   	retq   

000000000080344a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803455:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80345c:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803463:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80346a:	be 00 00 00 00       	mov    $0x0,%esi
  80346f:	48 89 c7             	mov    %rax,%rdi
  803472:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  803479:	00 00 00 
  80347c:	ff d0                	callq  *%rax
  80347e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803481:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803485:	79 08                	jns    80348f <spawn+0x45>
		return r;
  803487:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80348a:	e9 14 03 00 00       	jmpq   8037a3 <spawn+0x359>
	fd = r;
  80348f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803492:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803495:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80349c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8034a0:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8034a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034aa:	ba 00 02 00 00       	mov    $0x200,%edx
  8034af:	48 89 ce             	mov    %rcx,%rsi
  8034b2:	89 c7                	mov    %eax,%edi
  8034b4:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
  8034c0:	3d 00 02 00 00       	cmp    $0x200,%eax
  8034c5:	75 0d                	jne    8034d4 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8034c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034cb:	8b 00                	mov    (%rax),%eax
  8034cd:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8034d2:	74 43                	je     803517 <spawn+0xcd>
		close(fd);
  8034d4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034d7:	89 c7                	mov    %eax,%edi
  8034d9:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8034e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e9:	8b 00                	mov    (%rax),%eax
  8034eb:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8034f0:	89 c6                	mov    %eax,%esi
  8034f2:	48 bf 78 5c 80 00 00 	movabs $0x805c78,%rdi
  8034f9:	00 00 00 
  8034fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803501:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  803508:	00 00 00 
  80350b:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80350d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803512:	e9 8c 02 00 00       	jmpq   8037a3 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803517:	b8 07 00 00 00       	mov    $0x7,%eax
  80351c:	cd 30                	int    $0x30
  80351e:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803521:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803524:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803527:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80352b:	79 08                	jns    803535 <spawn+0xeb>
		return r;
  80352d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803530:	e9 6e 02 00 00       	jmpq   8037a3 <spawn+0x359>
	child = r;
  803535:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803538:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80353b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80353e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803543:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80354a:	00 00 00 
  80354d:	48 63 d0             	movslq %eax,%rdx
  803550:	48 89 d0             	mov    %rdx,%rax
  803553:	48 c1 e0 03          	shl    $0x3,%rax
  803557:	48 01 d0             	add    %rdx,%rax
  80355a:	48 c1 e0 05          	shl    $0x5,%rax
  80355e:	48 01 c8             	add    %rcx,%rax
  803561:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803568:	48 89 c6             	mov    %rax,%rsi
  80356b:	b8 18 00 00 00       	mov    $0x18,%eax
  803570:	48 89 d7             	mov    %rdx,%rdi
  803573:	48 89 c1             	mov    %rax,%rcx
  803576:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80357d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803581:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803588:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80358f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803596:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80359d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035a0:	48 89 ce             	mov    %rcx,%rsi
  8035a3:	89 c7                	mov    %eax,%edi
  8035a5:	48 b8 0d 3a 80 00 00 	movabs $0x803a0d,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
  8035b1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035b8:	79 08                	jns    8035c2 <spawn+0x178>
		return r;
  8035ba:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035bd:	e9 e1 01 00 00       	jmpq   8037a3 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8035c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8035ca:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8035d1:	48 01 d0             	add    %rdx,%rax
  8035d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8035d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035df:	e9 a3 00 00 00       	jmpq   803687 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8035e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e8:	8b 00                	mov    (%rax),%eax
  8035ea:	83 f8 01             	cmp    $0x1,%eax
  8035ed:	74 05                	je     8035f4 <spawn+0x1aa>
			continue;
  8035ef:	e9 8a 00 00 00       	jmpq   80367e <spawn+0x234>
		perm = PTE_P | PTE_U;
  8035f4:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8035fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ff:	8b 40 04             	mov    0x4(%rax),%eax
  803602:	83 e0 02             	and    $0x2,%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	74 04                	je     80360d <spawn+0x1c3>
			perm |= PTE_W;
  803609:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803611:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803615:	41 89 c1             	mov    %eax,%r9d
  803618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361c:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803624:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362c:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803630:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803633:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803636:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803639:	89 3c 24             	mov    %edi,(%rsp)
  80363c:	89 c7                	mov    %eax,%edi
  80363e:	48 b8 b6 3c 80 00 00 	movabs $0x803cb6,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80364d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803651:	79 2b                	jns    80367e <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803653:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803654:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803657:	89 c7                	mov    %eax,%edi
  803659:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
	close(fd);
  803665:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803668:	89 c7                	mov    %eax,%edi
  80366a:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  803671:	00 00 00 
  803674:	ff d0                	callq  *%rax
	return r;
  803676:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803679:	e9 25 01 00 00       	jmpq   8037a3 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80367e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803682:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803687:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368b:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80368f:	0f b7 c0             	movzwl %ax,%eax
  803692:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803695:	0f 8f 49 ff ff ff    	jg     8035e4 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80369b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80369e:	89 c7                	mov    %eax,%edi
  8036a0:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  8036a7:	00 00 00 
  8036aa:	ff d0                	callq  *%rax
	fd = -1;
  8036ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8036b3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 a2 3e 80 00 00 	movabs $0x803ea2,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
  8036c4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8036c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8036cb:	79 30                	jns    8036fd <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8036cd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036d0:	89 c1                	mov    %eax,%ecx
  8036d2:	48 ba 92 5c 80 00 00 	movabs $0x805c92,%rdx
  8036d9:	00 00 00 
  8036dc:	be 82 00 00 00       	mov    $0x82,%esi
  8036e1:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  8036e8:	00 00 00 
  8036eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f0:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8036f7:	00 00 00 
  8036fa:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8036fd:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803704:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803707:	48 89 d6             	mov    %rdx,%rsi
  80370a:	89 c7                	mov    %eax,%edi
  80370c:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  803713:	00 00 00 
  803716:	ff d0                	callq  *%rax
  803718:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80371b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80371f:	79 30                	jns    803751 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803721:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803724:	89 c1                	mov    %eax,%ecx
  803726:	48 ba b4 5c 80 00 00 	movabs $0x805cb4,%rdx
  80372d:	00 00 00 
  803730:	be 85 00 00 00       	mov    $0x85,%esi
  803735:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  80373c:	00 00 00 
  80373f:	b8 00 00 00 00       	mov    $0x0,%eax
  803744:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  80374b:	00 00 00 
  80374e:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803751:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803754:	be 02 00 00 00       	mov    $0x2,%esi
  803759:	89 c7                	mov    %eax,%edi
  80375b:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
  803767:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80376a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80376e:	79 30                	jns    8037a0 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803770:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803773:	89 c1                	mov    %eax,%ecx
  803775:	48 ba ce 5c 80 00 00 	movabs $0x805cce,%rdx
  80377c:	00 00 00 
  80377f:	be 88 00 00 00       	mov    $0x88,%esi
  803784:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  80378b:	00 00 00 
  80378e:	b8 00 00 00 00       	mov    $0x0,%eax
  803793:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  80379a:	00 00 00 
  80379d:	41 ff d0             	callq  *%r8

	return child;
  8037a0:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8037a3:	c9                   	leaveq 
  8037a4:	c3                   	retq   

00000000008037a5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	41 55                	push   %r13
  8037ab:	41 54                	push   %r12
  8037ad:	53                   	push   %rbx
  8037ae:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037b5:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8037bc:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8037c3:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8037ca:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8037d1:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8037d8:	84 c0                	test   %al,%al
  8037da:	74 26                	je     803802 <spawnl+0x5d>
  8037dc:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8037e3:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8037ea:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8037ee:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8037f2:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8037f6:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8037fa:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8037fe:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803802:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803809:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803810:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803813:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80381a:	00 00 00 
  80381d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803824:	00 00 00 
  803827:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80382b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803832:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803839:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803840:	eb 07                	jmp    803849 <spawnl+0xa4>
		argc++;
  803842:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803849:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80384f:	83 f8 30             	cmp    $0x30,%eax
  803852:	73 23                	jae    803877 <spawnl+0xd2>
  803854:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80385b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803861:	89 c0                	mov    %eax,%eax
  803863:	48 01 d0             	add    %rdx,%rax
  803866:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80386c:	83 c2 08             	add    $0x8,%edx
  80386f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803875:	eb 15                	jmp    80388c <spawnl+0xe7>
  803877:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80387e:	48 89 d0             	mov    %rdx,%rax
  803881:	48 83 c2 08          	add    $0x8,%rdx
  803885:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80388c:	48 8b 00             	mov    (%rax),%rax
  80388f:	48 85 c0             	test   %rax,%rax
  803892:	75 ae                	jne    803842 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803894:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80389a:	83 c0 02             	add    $0x2,%eax
  80389d:	48 89 e2             	mov    %rsp,%rdx
  8038a0:	48 89 d3             	mov    %rdx,%rbx
  8038a3:	48 63 d0             	movslq %eax,%rdx
  8038a6:	48 83 ea 01          	sub    $0x1,%rdx
  8038aa:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8038b1:	48 63 d0             	movslq %eax,%rdx
  8038b4:	49 89 d4             	mov    %rdx,%r12
  8038b7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8038bd:	48 63 d0             	movslq %eax,%rdx
  8038c0:	49 89 d2             	mov    %rdx,%r10
  8038c3:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8038c9:	48 98                	cltq   
  8038cb:	48 c1 e0 03          	shl    $0x3,%rax
  8038cf:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8038d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8038d8:	48 83 e8 01          	sub    $0x1,%rax
  8038dc:	48 01 d0             	add    %rdx,%rax
  8038df:	bf 10 00 00 00       	mov    $0x10,%edi
  8038e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8038e9:	48 f7 f7             	div    %rdi
  8038ec:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8038f0:	48 29 c4             	sub    %rax,%rsp
  8038f3:	48 89 e0             	mov    %rsp,%rax
  8038f6:	48 83 c0 07          	add    $0x7,%rax
  8038fa:	48 c1 e8 03          	shr    $0x3,%rax
  8038fe:	48 c1 e0 03          	shl    $0x3,%rax
  803902:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803909:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803910:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803917:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80391a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803920:	8d 50 01             	lea    0x1(%rax),%edx
  803923:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80392a:	48 63 d2             	movslq %edx,%rdx
  80392d:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803934:	00 

	va_start(vl, arg0);
  803935:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80393c:	00 00 00 
  80393f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803946:	00 00 00 
  803949:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80394d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803954:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80395b:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803962:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803969:	00 00 00 
  80396c:	eb 63                	jmp    8039d1 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80396e:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803974:	8d 70 01             	lea    0x1(%rax),%esi
  803977:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80397d:	83 f8 30             	cmp    $0x30,%eax
  803980:	73 23                	jae    8039a5 <spawnl+0x200>
  803982:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803989:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80398f:	89 c0                	mov    %eax,%eax
  803991:	48 01 d0             	add    %rdx,%rax
  803994:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80399a:	83 c2 08             	add    $0x8,%edx
  80399d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8039a3:	eb 15                	jmp    8039ba <spawnl+0x215>
  8039a5:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8039ac:	48 89 d0             	mov    %rdx,%rax
  8039af:	48 83 c2 08          	add    $0x8,%rdx
  8039b3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8039ba:	48 8b 08             	mov    (%rax),%rcx
  8039bd:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039c4:	89 f2                	mov    %esi,%edx
  8039c6:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8039ca:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8039d1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8039d7:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8039dd:	77 8f                	ja     80396e <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8039df:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039e6:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8039ed:	48 89 d6             	mov    %rdx,%rsi
  8039f0:	48 89 c7             	mov    %rax,%rdi
  8039f3:	48 b8 4a 34 80 00 00 	movabs $0x80344a,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
  8039ff:	48 89 dc             	mov    %rbx,%rsp
}
  803a02:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803a06:	5b                   	pop    %rbx
  803a07:	41 5c                	pop    %r12
  803a09:	41 5d                	pop    %r13
  803a0b:	5d                   	pop    %rbp
  803a0c:	c3                   	retq   

0000000000803a0d <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803a0d:	55                   	push   %rbp
  803a0e:	48 89 e5             	mov    %rsp,%rbp
  803a11:	48 83 ec 50          	sub    $0x50,%rsp
  803a15:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803a18:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803a1c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803a20:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a27:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803a2f:	eb 33                	jmp    803a64 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803a31:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a34:	48 98                	cltq   
  803a36:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a3d:	00 
  803a3e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a42:	48 01 d0             	add    %rdx,%rax
  803a45:	48 8b 00             	mov    (%rax),%rax
  803a48:	48 89 c7             	mov    %rax,%rdi
  803a4b:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  803a52:	00 00 00 
  803a55:	ff d0                	callq  *%rax
  803a57:	83 c0 01             	add    $0x1,%eax
  803a5a:	48 98                	cltq   
  803a5c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803a60:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803a64:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a67:	48 98                	cltq   
  803a69:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a70:	00 
  803a71:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a75:	48 01 d0             	add    %rdx,%rax
  803a78:	48 8b 00             	mov    (%rax),%rax
  803a7b:	48 85 c0             	test   %rax,%rax
  803a7e:	75 b1                	jne    803a31 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a84:	48 f7 d8             	neg    %rax
  803a87:	48 05 00 10 40 00    	add    $0x401000,%rax
  803a8d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803a91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a95:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9d:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803aa1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803aa4:	83 c2 01             	add    $0x1,%edx
  803aa7:	c1 e2 03             	shl    $0x3,%edx
  803aaa:	48 63 d2             	movslq %edx,%rdx
  803aad:	48 f7 da             	neg    %rdx
  803ab0:	48 01 d0             	add    %rdx,%rax
  803ab3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803ab7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803abb:	48 83 e8 10          	sub    $0x10,%rax
  803abf:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803ac5:	77 0a                	ja     803ad1 <init_stack+0xc4>
		return -E_NO_MEM;
  803ac7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803acc:	e9 e3 01 00 00       	jmpq   803cb4 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ad1:	ba 07 00 00 00       	mov    $0x7,%edx
  803ad6:	be 00 00 40 00       	mov    $0x400000,%esi
  803adb:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae0:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803ae7:	00 00 00 
  803aea:	ff d0                	callq  *%rax
  803aec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803af3:	79 08                	jns    803afd <init_stack+0xf0>
		return r;
  803af5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af8:	e9 b7 01 00 00       	jmpq   803cb4 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803afd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803b04:	e9 8a 00 00 00       	jmpq   803b93 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803b09:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b0c:	48 98                	cltq   
  803b0e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b15:	00 
  803b16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1a:	48 01 c2             	add    %rax,%rdx
  803b1d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b26:	48 01 c8             	add    %rcx,%rax
  803b29:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b2f:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803b32:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b35:	48 98                	cltq   
  803b37:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b3e:	00 
  803b3f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b43:	48 01 d0             	add    %rdx,%rax
  803b46:	48 8b 10             	mov    (%rax),%rdx
  803b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4d:	48 89 d6             	mov    %rdx,%rsi
  803b50:	48 89 c7             	mov    %rax,%rdi
  803b53:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803b5f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b62:	48 98                	cltq   
  803b64:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b6b:	00 
  803b6c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b70:	48 01 d0             	add    %rdx,%rax
  803b73:	48 8b 00             	mov    (%rax),%rax
  803b76:	48 89 c7             	mov    %rax,%rdi
  803b79:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	48 98                	cltq   
  803b87:	48 83 c0 01          	add    $0x1,%rax
  803b8b:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803b8f:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803b93:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b96:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803b99:	0f 8c 6a ff ff ff    	jl     803b09 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803b9f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ba2:	48 98                	cltq   
  803ba4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bab:	00 
  803bac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb0:	48 01 d0             	add    %rdx,%rax
  803bb3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803bba:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803bc1:	00 
  803bc2:	74 35                	je     803bf9 <init_stack+0x1ec>
  803bc4:	48 b9 e8 5c 80 00 00 	movabs $0x805ce8,%rcx
  803bcb:	00 00 00 
  803bce:	48 ba 0e 5d 80 00 00 	movabs $0x805d0e,%rdx
  803bd5:	00 00 00 
  803bd8:	be f1 00 00 00       	mov    $0xf1,%esi
  803bdd:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  803be4:	00 00 00 
  803be7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bec:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803bf3:	00 00 00 
  803bf6:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803bf9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bfd:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803c01:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c0a:	48 01 c8             	add    %rcx,%rax
  803c0d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c13:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c1a:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803c1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c21:	48 98                	cltq   
  803c23:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803c26:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803c2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c2f:	48 01 d0             	add    %rdx,%rax
  803c32:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c38:	48 89 c2             	mov    %rax,%rdx
  803c3b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c3f:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803c42:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c45:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803c4b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c50:	89 c2                	mov    %eax,%edx
  803c52:	be 00 00 40 00       	mov    $0x400000,%esi
  803c57:	bf 00 00 00 00       	mov    $0x0,%edi
  803c5c:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803c63:	00 00 00 
  803c66:	ff d0                	callq  *%rax
  803c68:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c6f:	79 02                	jns    803c73 <init_stack+0x266>
		goto error;
  803c71:	eb 28                	jmp    803c9b <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803c73:	be 00 00 40 00       	mov    $0x400000,%esi
  803c78:	bf 00 00 00 00       	mov    $0x0,%edi
  803c7d:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803c84:	00 00 00 
  803c87:	ff d0                	callq  *%rax
  803c89:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c90:	79 02                	jns    803c94 <init_stack+0x287>
		goto error;
  803c92:	eb 07                	jmp    803c9b <init_stack+0x28e>

	return 0;
  803c94:	b8 00 00 00 00       	mov    $0x0,%eax
  803c99:	eb 19                	jmp    803cb4 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803c9b:	be 00 00 40 00       	mov    $0x400000,%esi
  803ca0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca5:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
	return r;
  803cb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803cb4:	c9                   	leaveq 
  803cb5:	c3                   	retq   

0000000000803cb6 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803cb6:	55                   	push   %rbp
  803cb7:	48 89 e5             	mov    %rsp,%rbp
  803cba:	48 83 ec 50          	sub    $0x50,%rsp
  803cbe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cc5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803cc9:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803ccc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803cd0:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803cd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd8:	25 ff 0f 00 00       	and    $0xfff,%eax
  803cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce4:	74 21                	je     803d07 <map_segment+0x51>
		va -= i;
  803ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce9:	48 98                	cltq   
  803ceb:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf2:	48 98                	cltq   
  803cf4:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfb:	48 98                	cltq   
  803cfd:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d04:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803d07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d0e:	e9 79 01 00 00       	jmpq   803e8c <map_segment+0x1d6>
		if (i >= filesz) {
  803d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d16:	48 98                	cltq   
  803d18:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803d1c:	72 3c                	jb     803d5a <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d21:	48 63 d0             	movslq %eax,%rdx
  803d24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d28:	48 01 d0             	add    %rdx,%rax
  803d2b:	48 89 c1             	mov    %rax,%rcx
  803d2e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d31:	8b 55 10             	mov    0x10(%rbp),%edx
  803d34:	48 89 ce             	mov    %rcx,%rsi
  803d37:	89 c7                	mov    %eax,%edi
  803d39:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d40:	00 00 00 
  803d43:	ff d0                	callq  *%rax
  803d45:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d48:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d4c:	0f 89 33 01 00 00    	jns    803e85 <map_segment+0x1cf>
				return r;
  803d52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d55:	e9 46 01 00 00       	jmpq   803ea0 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d5a:	ba 07 00 00 00       	mov    $0x7,%edx
  803d5f:	be 00 00 40 00       	mov    $0x400000,%esi
  803d64:	bf 00 00 00 00       	mov    $0x0,%edi
  803d69:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
  803d75:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d7c:	79 08                	jns    803d86 <map_segment+0xd0>
				return r;
  803d7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d81:	e9 1a 01 00 00       	jmpq   803ea0 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d89:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803d8c:	01 c2                	add    %eax,%edx
  803d8e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803d91:	89 d6                	mov    %edx,%esi
  803d93:	89 c7                	mov    %eax,%edi
  803d95:	48 b8 7c 2b 80 00 00 	movabs $0x802b7c,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	callq  *%rax
  803da1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803da8:	79 08                	jns    803db2 <map_segment+0xfc>
				return r;
  803daa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dad:	e9 ee 00 00 00       	jmpq   803ea0 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803db2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbc:	48 98                	cltq   
  803dbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803dc2:	48 29 c2             	sub    %rax,%rdx
  803dc5:	48 89 d0             	mov    %rdx,%rax
  803dc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803dcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803dcf:	48 63 d0             	movslq %eax,%rdx
  803dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd6:	48 39 c2             	cmp    %rax,%rdx
  803dd9:	48 0f 47 d0          	cmova  %rax,%rdx
  803ddd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803de0:	be 00 00 40 00       	mov    $0x400000,%esi
  803de5:	89 c7                	mov    %eax,%edi
  803de7:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  803dee:	00 00 00 
  803df1:	ff d0                	callq  *%rax
  803df3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803df6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803dfa:	79 08                	jns    803e04 <map_segment+0x14e>
				return r;
  803dfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dff:	e9 9c 00 00 00       	jmpq   803ea0 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e07:	48 63 d0             	movslq %eax,%rdx
  803e0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0e:	48 01 d0             	add    %rdx,%rax
  803e11:	48 89 c2             	mov    %rax,%rdx
  803e14:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e17:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803e1b:	48 89 d1             	mov    %rdx,%rcx
  803e1e:	89 c2                	mov    %eax,%edx
  803e20:	be 00 00 40 00       	mov    $0x400000,%esi
  803e25:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2a:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803e31:	00 00 00 
  803e34:	ff d0                	callq  *%rax
  803e36:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e39:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e3d:	79 30                	jns    803e6f <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e42:	89 c1                	mov    %eax,%ecx
  803e44:	48 ba 23 5d 80 00 00 	movabs $0x805d23,%rdx
  803e4b:	00 00 00 
  803e4e:	be 24 01 00 00       	mov    $0x124,%esi
  803e53:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  803e5a:	00 00 00 
  803e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e62:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803e69:	00 00 00 
  803e6c:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803e6f:	be 00 00 40 00       	mov    $0x400000,%esi
  803e74:	bf 00 00 00 00       	mov    $0x0,%edi
  803e79:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803e85:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8f:	48 98                	cltq   
  803e91:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e95:	0f 82 78 fe ff ff    	jb     803d13 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ea0:	c9                   	leaveq 
  803ea1:	c3                   	retq   

0000000000803ea2 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803ea2:	55                   	push   %rbp
  803ea3:	48 89 e5             	mov    %rsp,%rbp
  803ea6:	48 83 ec 20          	sub    $0x20,%rsp
  803eaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803ead:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803eb4:	00 
  803eb5:	e9 c9 00 00 00       	jmpq   803f83 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ebe:	48 c1 e8 27          	shr    $0x27,%rax
  803ec2:	48 89 c2             	mov    %rax,%rdx
  803ec5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803ecc:	01 00 00 
  803ecf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ed3:	48 85 c0             	test   %rax,%rax
  803ed6:	74 3c                	je     803f14 <copy_shared_pages+0x72>
  803ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803edc:	48 c1 e8 1e          	shr    $0x1e,%rax
  803ee0:	48 89 c2             	mov    %rax,%rdx
  803ee3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803eea:	01 00 00 
  803eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ef1:	48 85 c0             	test   %rax,%rax
  803ef4:	74 1e                	je     803f14 <copy_shared_pages+0x72>
  803ef6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803efa:	48 c1 e8 15          	shr    $0x15,%rax
  803efe:	48 89 c2             	mov    %rax,%rdx
  803f01:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f08:	01 00 00 
  803f0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f0f:	48 85 c0             	test   %rax,%rax
  803f12:	75 02                	jne    803f16 <copy_shared_pages+0x74>
                continue;
  803f14:	eb 65                	jmp    803f7b <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f1e:	48 89 c2             	mov    %rax,%rdx
  803f21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f28:	01 00 00 
  803f2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f2f:	25 00 04 00 00       	and    $0x400,%eax
  803f34:	48 85 c0             	test   %rax,%rax
  803f37:	74 42                	je     803f7b <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803f39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3d:	48 c1 e8 0c          	shr    $0xc,%rax
  803f41:	48 89 c2             	mov    %rax,%rdx
  803f44:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f4b:	01 00 00 
  803f4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f52:	25 07 0e 00 00       	and    $0xe07,%eax
  803f57:	89 c6                	mov    %eax,%esi
  803f59:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f61:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f64:	41 89 f0             	mov    %esi,%r8d
  803f67:	48 89 c6             	mov    %rax,%rsi
  803f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6f:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803f7b:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f82:	00 
  803f83:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803f8a:	00 00 00 
  803f8d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803f91:	0f 86 23 ff ff ff    	jbe    803eba <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803f97:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803f9c:	c9                   	leaveq 
  803f9d:	c3                   	retq   

0000000000803f9e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803f9e:	55                   	push   %rbp
  803f9f:	48 89 e5             	mov    %rsp,%rbp
  803fa2:	48 83 ec 20          	sub    $0x20,%rsp
  803fa6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803fa9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb0:	48 89 d6             	mov    %rdx,%rsi
  803fb3:	89 c7                	mov    %eax,%edi
  803fb5:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  803fbc:	00 00 00 
  803fbf:	ff d0                	callq  *%rax
  803fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc8:	79 05                	jns    803fcf <fd2sockid+0x31>
		return r;
  803fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcd:	eb 24                	jmp    803ff3 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd3:	8b 10                	mov    (%rax),%edx
  803fd5:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803fdc:	00 00 00 
  803fdf:	8b 00                	mov    (%rax),%eax
  803fe1:	39 c2                	cmp    %eax,%edx
  803fe3:	74 07                	je     803fec <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803fe5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803fea:	eb 07                	jmp    803ff3 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff0:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803ff3:	c9                   	leaveq 
  803ff4:	c3                   	retq   

0000000000803ff5 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803ff5:	55                   	push   %rbp
  803ff6:	48 89 e5             	mov    %rsp,%rbp
  803ff9:	48 83 ec 20          	sub    $0x20,%rsp
  803ffd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  804000:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804004:	48 89 c7             	mov    %rax,%rdi
  804007:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  80400e:	00 00 00 
  804011:	ff d0                	callq  *%rax
  804013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401a:	78 26                	js     804042 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80401c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804020:	ba 07 04 00 00       	mov    $0x407,%edx
  804025:	48 89 c6             	mov    %rax,%rsi
  804028:	bf 00 00 00 00       	mov    $0x0,%edi
  80402d:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804034:	00 00 00 
  804037:	ff d0                	callq  *%rax
  804039:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804040:	79 16                	jns    804058 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804042:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804045:	89 c7                	mov    %eax,%edi
  804047:	48 b8 02 45 80 00 00 	movabs $0x804502,%rax
  80404e:	00 00 00 
  804051:	ff d0                	callq  *%rax
		return r;
  804053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804056:	eb 3a                	jmp    804092 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405c:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  804063:	00 00 00 
  804066:	8b 12                	mov    (%rdx),%edx
  804068:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80406a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804079:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80407c:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80407f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804083:	48 89 c7             	mov    %rax,%rdi
  804086:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  80408d:	00 00 00 
  804090:	ff d0                	callq  *%rax
}
  804092:	c9                   	leaveq 
  804093:	c3                   	retq   

0000000000804094 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804094:	55                   	push   %rbp
  804095:	48 89 e5             	mov    %rsp,%rbp
  804098:	48 83 ec 30          	sub    $0x30,%rsp
  80409c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80409f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040aa:	89 c7                	mov    %eax,%edi
  8040ac:	48 b8 9e 3f 80 00 00 	movabs $0x803f9e,%rax
  8040b3:	00 00 00 
  8040b6:	ff d0                	callq  *%rax
  8040b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040bf:	79 05                	jns    8040c6 <accept+0x32>
		return r;
  8040c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c4:	eb 3b                	jmp    804101 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8040c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8040ca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8040ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d1:	48 89 ce             	mov    %rcx,%rsi
  8040d4:	89 c7                	mov    %eax,%edi
  8040d6:	48 b8 df 43 80 00 00 	movabs $0x8043df,%rax
  8040dd:	00 00 00 
  8040e0:	ff d0                	callq  *%rax
  8040e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e9:	79 05                	jns    8040f0 <accept+0x5c>
		return r;
  8040eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ee:	eb 11                	jmp    804101 <accept+0x6d>
	return alloc_sockfd(r);
  8040f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f3:	89 c7                	mov    %eax,%edi
  8040f5:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
}
  804101:	c9                   	leaveq 
  804102:	c3                   	retq   

0000000000804103 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804103:	55                   	push   %rbp
  804104:	48 89 e5             	mov    %rsp,%rbp
  804107:	48 83 ec 20          	sub    $0x20,%rsp
  80410b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80410e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804112:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804118:	89 c7                	mov    %eax,%edi
  80411a:	48 b8 9e 3f 80 00 00 	movabs $0x803f9e,%rax
  804121:	00 00 00 
  804124:	ff d0                	callq  *%rax
  804126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412d:	79 05                	jns    804134 <bind+0x31>
		return r;
  80412f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804132:	eb 1b                	jmp    80414f <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804134:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804137:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80413b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413e:	48 89 ce             	mov    %rcx,%rsi
  804141:	89 c7                	mov    %eax,%edi
  804143:	48 b8 5e 44 80 00 00 	movabs $0x80445e,%rax
  80414a:	00 00 00 
  80414d:	ff d0                	callq  *%rax
}
  80414f:	c9                   	leaveq 
  804150:	c3                   	retq   

0000000000804151 <shutdown>:

int
shutdown(int s, int how)
{
  804151:	55                   	push   %rbp
  804152:	48 89 e5             	mov    %rsp,%rbp
  804155:	48 83 ec 20          	sub    $0x20,%rsp
  804159:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80415c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80415f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804162:	89 c7                	mov    %eax,%edi
  804164:	48 b8 9e 3f 80 00 00 	movabs $0x803f9e,%rax
  80416b:	00 00 00 
  80416e:	ff d0                	callq  *%rax
  804170:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804173:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804177:	79 05                	jns    80417e <shutdown+0x2d>
		return r;
  804179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417c:	eb 16                	jmp    804194 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80417e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804184:	89 d6                	mov    %edx,%esi
  804186:	89 c7                	mov    %eax,%edi
  804188:	48 b8 c2 44 80 00 00 	movabs $0x8044c2,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
}
  804194:	c9                   	leaveq 
  804195:	c3                   	retq   

0000000000804196 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804196:	55                   	push   %rbp
  804197:	48 89 e5             	mov    %rsp,%rbp
  80419a:	48 83 ec 10          	sub    $0x10,%rsp
  80419e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8041a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a6:	48 89 c7             	mov    %rax,%rdi
  8041a9:	48 b8 ed 53 80 00 00 	movabs $0x8053ed,%rax
  8041b0:	00 00 00 
  8041b3:	ff d0                	callq  *%rax
  8041b5:	83 f8 01             	cmp    $0x1,%eax
  8041b8:	75 17                	jne    8041d1 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8041ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041be:	8b 40 0c             	mov    0xc(%rax),%eax
  8041c1:	89 c7                	mov    %eax,%edi
  8041c3:	48 b8 02 45 80 00 00 	movabs $0x804502,%rax
  8041ca:	00 00 00 
  8041cd:	ff d0                	callq  *%rax
  8041cf:	eb 05                	jmp    8041d6 <devsock_close+0x40>
	else
		return 0;
  8041d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041d6:	c9                   	leaveq 
  8041d7:	c3                   	retq   

00000000008041d8 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8041d8:	55                   	push   %rbp
  8041d9:	48 89 e5             	mov    %rsp,%rbp
  8041dc:	48 83 ec 20          	sub    $0x20,%rsp
  8041e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041e7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041ed:	89 c7                	mov    %eax,%edi
  8041ef:	48 b8 9e 3f 80 00 00 	movabs $0x803f9e,%rax
  8041f6:	00 00 00 
  8041f9:	ff d0                	callq  *%rax
  8041fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804202:	79 05                	jns    804209 <connect+0x31>
		return r;
  804204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804207:	eb 1b                	jmp    804224 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804209:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80420c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804210:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804213:	48 89 ce             	mov    %rcx,%rsi
  804216:	89 c7                	mov    %eax,%edi
  804218:	48 b8 2f 45 80 00 00 	movabs $0x80452f,%rax
  80421f:	00 00 00 
  804222:	ff d0                	callq  *%rax
}
  804224:	c9                   	leaveq 
  804225:	c3                   	retq   

0000000000804226 <listen>:

int
listen(int s, int backlog)
{
  804226:	55                   	push   %rbp
  804227:	48 89 e5             	mov    %rsp,%rbp
  80422a:	48 83 ec 20          	sub    $0x20,%rsp
  80422e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804231:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804234:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804237:	89 c7                	mov    %eax,%edi
  804239:	48 b8 9e 3f 80 00 00 	movabs $0x803f9e,%rax
  804240:	00 00 00 
  804243:	ff d0                	callq  *%rax
  804245:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804248:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80424c:	79 05                	jns    804253 <listen+0x2d>
		return r;
  80424e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804251:	eb 16                	jmp    804269 <listen+0x43>
	return nsipc_listen(r, backlog);
  804253:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804256:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804259:	89 d6                	mov    %edx,%esi
  80425b:	89 c7                	mov    %eax,%edi
  80425d:	48 b8 93 45 80 00 00 	movabs $0x804593,%rax
  804264:	00 00 00 
  804267:	ff d0                	callq  *%rax
}
  804269:	c9                   	leaveq 
  80426a:	c3                   	retq   

000000000080426b <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80426b:	55                   	push   %rbp
  80426c:	48 89 e5             	mov    %rsp,%rbp
  80426f:	48 83 ec 20          	sub    $0x20,%rsp
  804273:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804277:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80427b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80427f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804283:	89 c2                	mov    %eax,%edx
  804285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804289:	8b 40 0c             	mov    0xc(%rax),%eax
  80428c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804290:	b9 00 00 00 00       	mov    $0x0,%ecx
  804295:	89 c7                	mov    %eax,%edi
  804297:	48 b8 d3 45 80 00 00 	movabs $0x8045d3,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
}
  8042a3:	c9                   	leaveq 
  8042a4:	c3                   	retq   

00000000008042a5 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8042a5:	55                   	push   %rbp
  8042a6:	48 89 e5             	mov    %rsp,%rbp
  8042a9:	48 83 ec 20          	sub    $0x20,%rsp
  8042ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8042b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042bd:	89 c2                	mov    %eax,%edx
  8042bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8042c6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8042ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8042cf:	89 c7                	mov    %eax,%edi
  8042d1:	48 b8 9f 46 80 00 00 	movabs $0x80469f,%rax
  8042d8:	00 00 00 
  8042db:	ff d0                	callq  *%rax
}
  8042dd:	c9                   	leaveq 
  8042de:	c3                   	retq   

00000000008042df <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8042df:	55                   	push   %rbp
  8042e0:	48 89 e5             	mov    %rsp,%rbp
  8042e3:	48 83 ec 10          	sub    $0x10,%rsp
  8042e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8042ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f3:	48 be 45 5d 80 00 00 	movabs $0x805d45,%rsi
  8042fa:	00 00 00 
  8042fd:	48 89 c7             	mov    %rax,%rdi
  804300:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  804307:	00 00 00 
  80430a:	ff d0                	callq  *%rax
	return 0;
  80430c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804311:	c9                   	leaveq 
  804312:	c3                   	retq   

0000000000804313 <socket>:

int
socket(int domain, int type, int protocol)
{
  804313:	55                   	push   %rbp
  804314:	48 89 e5             	mov    %rsp,%rbp
  804317:	48 83 ec 20          	sub    $0x20,%rsp
  80431b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80431e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804321:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804324:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804327:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80432a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80432d:	89 ce                	mov    %ecx,%esi
  80432f:	89 c7                	mov    %eax,%edi
  804331:	48 b8 57 47 80 00 00 	movabs $0x804757,%rax
  804338:	00 00 00 
  80433b:	ff d0                	callq  *%rax
  80433d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804344:	79 05                	jns    80434b <socket+0x38>
		return r;
  804346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804349:	eb 11                	jmp    80435c <socket+0x49>
	return alloc_sockfd(r);
  80434b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434e:	89 c7                	mov    %eax,%edi
  804350:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
}
  80435c:	c9                   	leaveq 
  80435d:	c3                   	retq   

000000000080435e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80435e:	55                   	push   %rbp
  80435f:	48 89 e5             	mov    %rsp,%rbp
  804362:	48 83 ec 10          	sub    $0x10,%rsp
  804366:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804369:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  804370:	00 00 00 
  804373:	8b 00                	mov    (%rax),%eax
  804375:	85 c0                	test   %eax,%eax
  804377:	75 1d                	jne    804396 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804379:	bf 02 00 00 00       	mov    $0x2,%edi
  80437e:	48 b8 6b 53 80 00 00 	movabs $0x80536b,%rax
  804385:	00 00 00 
  804388:	ff d0                	callq  *%rax
  80438a:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  804391:	00 00 00 
  804394:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804396:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80439d:	00 00 00 
  8043a0:	8b 00                	mov    (%rax),%eax
  8043a2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8043a5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8043aa:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8043b1:	00 00 00 
  8043b4:	89 c7                	mov    %eax,%edi
  8043b6:	48 b8 09 53 80 00 00 	movabs $0x805309,%rax
  8043bd:	00 00 00 
  8043c0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8043c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8043c7:	be 00 00 00 00       	mov    $0x0,%esi
  8043cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d1:	48 b8 03 52 80 00 00 	movabs $0x805203,%rax
  8043d8:	00 00 00 
  8043db:	ff d0                	callq  *%rax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   

00000000008043df <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8043df:	55                   	push   %rbp
  8043e0:	48 89 e5             	mov    %rsp,%rbp
  8043e3:	48 83 ec 30          	sub    $0x30,%rsp
  8043e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8043f2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f9:	00 00 00 
  8043fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043ff:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804401:	bf 01 00 00 00       	mov    $0x1,%edi
  804406:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  80440d:	00 00 00 
  804410:	ff d0                	callq  *%rax
  804412:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804415:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804419:	78 3e                	js     804459 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80441b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804422:	00 00 00 
  804425:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442d:	8b 40 10             	mov    0x10(%rax),%eax
  804430:	89 c2                	mov    %eax,%edx
  804432:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80443a:	48 89 ce             	mov    %rcx,%rsi
  80443d:	48 89 c7             	mov    %rax,%rdi
  804440:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804447:	00 00 00 
  80444a:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80444c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804450:	8b 50 10             	mov    0x10(%rax),%edx
  804453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804457:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80445c:	c9                   	leaveq 
  80445d:	c3                   	retq   

000000000080445e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80445e:	55                   	push   %rbp
  80445f:	48 89 e5             	mov    %rsp,%rbp
  804462:	48 83 ec 10          	sub    $0x10,%rsp
  804466:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80446d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804470:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804477:	00 00 00 
  80447a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80447d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80447f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804486:	48 89 c6             	mov    %rax,%rsi
  804489:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804490:	00 00 00 
  804493:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80449a:	00 00 00 
  80449d:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80449f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044a6:	00 00 00 
  8044a9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044ac:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8044af:	bf 02 00 00 00       	mov    $0x2,%edi
  8044b4:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  8044bb:	00 00 00 
  8044be:	ff d0                	callq  *%rax
}
  8044c0:	c9                   	leaveq 
  8044c1:	c3                   	retq   

00000000008044c2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8044c2:	55                   	push   %rbp
  8044c3:	48 89 e5             	mov    %rsp,%rbp
  8044c6:	48 83 ec 10          	sub    $0x10,%rsp
  8044ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044cd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8044d0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044d7:	00 00 00 
  8044da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044dd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8044df:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044e6:	00 00 00 
  8044e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044ec:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8044ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8044f4:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
}
  804500:	c9                   	leaveq 
  804501:	c3                   	retq   

0000000000804502 <nsipc_close>:

int
nsipc_close(int s)
{
  804502:	55                   	push   %rbp
  804503:	48 89 e5             	mov    %rsp,%rbp
  804506:	48 83 ec 10          	sub    $0x10,%rsp
  80450a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80450d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804514:	00 00 00 
  804517:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80451a:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80451c:	bf 04 00 00 00       	mov    $0x4,%edi
  804521:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  804528:	00 00 00 
  80452b:	ff d0                	callq  *%rax
}
  80452d:	c9                   	leaveq 
  80452e:	c3                   	retq   

000000000080452f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80452f:	55                   	push   %rbp
  804530:	48 89 e5             	mov    %rsp,%rbp
  804533:	48 83 ec 10          	sub    $0x10,%rsp
  804537:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80453a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80453e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804541:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804548:	00 00 00 
  80454b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80454e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804550:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804557:	48 89 c6             	mov    %rax,%rsi
  80455a:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804561:	00 00 00 
  804564:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80456b:	00 00 00 
  80456e:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804570:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804577:	00 00 00 
  80457a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80457d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804580:	bf 05 00 00 00       	mov    $0x5,%edi
  804585:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  80458c:	00 00 00 
  80458f:	ff d0                	callq  *%rax
}
  804591:	c9                   	leaveq 
  804592:	c3                   	retq   

0000000000804593 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804593:	55                   	push   %rbp
  804594:	48 89 e5             	mov    %rsp,%rbp
  804597:	48 83 ec 10          	sub    $0x10,%rsp
  80459b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80459e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8045a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045a8:	00 00 00 
  8045ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045ae:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8045b0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045b7:	00 00 00 
  8045ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045bd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8045c0:	bf 06 00 00 00       	mov    $0x6,%edi
  8045c5:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  8045cc:	00 00 00 
  8045cf:	ff d0                	callq  *%rax
}
  8045d1:	c9                   	leaveq 
  8045d2:	c3                   	retq   

00000000008045d3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8045d3:	55                   	push   %rbp
  8045d4:	48 89 e5             	mov    %rsp,%rbp
  8045d7:	48 83 ec 30          	sub    $0x30,%rsp
  8045db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045e2:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8045e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8045e8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045ef:	00 00 00 
  8045f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045f5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8045f7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045fe:	00 00 00 
  804601:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804604:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804607:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80460e:	00 00 00 
  804611:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804614:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804617:	bf 07 00 00 00       	mov    $0x7,%edi
  80461c:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  804623:	00 00 00 
  804626:	ff d0                	callq  *%rax
  804628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80462b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80462f:	78 69                	js     80469a <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804631:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804638:	7f 08                	jg     804642 <nsipc_recv+0x6f>
  80463a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463d:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804640:	7e 35                	jle    804677 <nsipc_recv+0xa4>
  804642:	48 b9 4c 5d 80 00 00 	movabs $0x805d4c,%rcx
  804649:	00 00 00 
  80464c:	48 ba 61 5d 80 00 00 	movabs $0x805d61,%rdx
  804653:	00 00 00 
  804656:	be 61 00 00 00       	mov    $0x61,%esi
  80465b:	48 bf 76 5d 80 00 00 	movabs $0x805d76,%rdi
  804662:	00 00 00 
  804665:	b8 00 00 00 00       	mov    $0x0,%eax
  80466a:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  804671:	00 00 00 
  804674:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467a:	48 63 d0             	movslq %eax,%rdx
  80467d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804681:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804688:	00 00 00 
  80468b:	48 89 c7             	mov    %rax,%rdi
  80468e:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804695:	00 00 00 
  804698:	ff d0                	callq  *%rax
	}

	return r;
  80469a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80469d:	c9                   	leaveq 
  80469e:	c3                   	retq   

000000000080469f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80469f:	55                   	push   %rbp
  8046a0:	48 89 e5             	mov    %rsp,%rbp
  8046a3:	48 83 ec 20          	sub    $0x20,%rsp
  8046a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8046aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8046ae:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8046b1:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8046b4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046bb:	00 00 00 
  8046be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046c1:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8046c3:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8046ca:	7e 35                	jle    804701 <nsipc_send+0x62>
  8046cc:	48 b9 82 5d 80 00 00 	movabs $0x805d82,%rcx
  8046d3:	00 00 00 
  8046d6:	48 ba 61 5d 80 00 00 	movabs $0x805d61,%rdx
  8046dd:	00 00 00 
  8046e0:	be 6c 00 00 00       	mov    $0x6c,%esi
  8046e5:	48 bf 76 5d 80 00 00 	movabs $0x805d76,%rdi
  8046ec:	00 00 00 
  8046ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f4:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8046fb:	00 00 00 
  8046fe:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804701:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804704:	48 63 d0             	movslq %eax,%rdx
  804707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470b:	48 89 c6             	mov    %rax,%rsi
  80470e:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804715:	00 00 00 
  804718:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80471f:	00 00 00 
  804722:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804724:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80472b:	00 00 00 
  80472e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804731:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804734:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80473b:	00 00 00 
  80473e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804741:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804744:	bf 08 00 00 00       	mov    $0x8,%edi
  804749:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  804750:	00 00 00 
  804753:	ff d0                	callq  *%rax
}
  804755:	c9                   	leaveq 
  804756:	c3                   	retq   

0000000000804757 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804757:	55                   	push   %rbp
  804758:	48 89 e5             	mov    %rsp,%rbp
  80475b:	48 83 ec 10          	sub    $0x10,%rsp
  80475f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804762:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804765:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804768:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80476f:	00 00 00 
  804772:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804775:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804777:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80477e:	00 00 00 
  804781:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804784:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804787:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80478e:	00 00 00 
  804791:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804794:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804797:	bf 09 00 00 00       	mov    $0x9,%edi
  80479c:	48 b8 5e 43 80 00 00 	movabs $0x80435e,%rax
  8047a3:	00 00 00 
  8047a6:	ff d0                	callq  *%rax
}
  8047a8:	c9                   	leaveq 
  8047a9:	c3                   	retq   

00000000008047aa <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8047aa:	55                   	push   %rbp
  8047ab:	48 89 e5             	mov    %rsp,%rbp
  8047ae:	53                   	push   %rbx
  8047af:	48 83 ec 38          	sub    $0x38,%rsp
  8047b3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8047b7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8047bb:	48 89 c7             	mov    %rax,%rdi
  8047be:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  8047c5:	00 00 00 
  8047c8:	ff d0                	callq  *%rax
  8047ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047d1:	0f 88 bf 01 00 00    	js     804996 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047db:	ba 07 04 00 00       	mov    $0x407,%edx
  8047e0:	48 89 c6             	mov    %rax,%rsi
  8047e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e8:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  8047ef:	00 00 00 
  8047f2:	ff d0                	callq  *%rax
  8047f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047fb:	0f 88 95 01 00 00    	js     804996 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804801:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804805:	48 89 c7             	mov    %rax,%rdi
  804808:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  80480f:	00 00 00 
  804812:	ff d0                	callq  *%rax
  804814:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804817:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80481b:	0f 88 5d 01 00 00    	js     80497e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804821:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804825:	ba 07 04 00 00       	mov    $0x407,%edx
  80482a:	48 89 c6             	mov    %rax,%rsi
  80482d:	bf 00 00 00 00       	mov    $0x0,%edi
  804832:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804839:	00 00 00 
  80483c:	ff d0                	callq  *%rax
  80483e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804841:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804845:	0f 88 33 01 00 00    	js     80497e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80484b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80484f:	48 89 c7             	mov    %rax,%rdi
  804852:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804859:	00 00 00 
  80485c:	ff d0                	callq  *%rax
  80485e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804866:	ba 07 04 00 00       	mov    $0x407,%edx
  80486b:	48 89 c6             	mov    %rax,%rsi
  80486e:	bf 00 00 00 00       	mov    $0x0,%edi
  804873:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80487a:	00 00 00 
  80487d:	ff d0                	callq  *%rax
  80487f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804882:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804886:	79 05                	jns    80488d <pipe+0xe3>
		goto err2;
  804888:	e9 d9 00 00 00       	jmpq   804966 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80488d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804891:	48 89 c7             	mov    %rax,%rdi
  804894:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  80489b:	00 00 00 
  80489e:	ff d0                	callq  *%rax
  8048a0:	48 89 c2             	mov    %rax,%rdx
  8048a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8048ad:	48 89 d1             	mov    %rdx,%rcx
  8048b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8048b5:	48 89 c6             	mov    %rax,%rsi
  8048b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8048bd:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8048c4:	00 00 00 
  8048c7:	ff d0                	callq  *%rax
  8048c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048d0:	79 1b                	jns    8048ed <pipe+0x143>
		goto err3;
  8048d2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8048d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d7:	48 89 c6             	mov    %rax,%rsi
  8048da:	bf 00 00 00 00       	mov    $0x0,%edi
  8048df:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8048e6:	00 00 00 
  8048e9:	ff d0                	callq  *%rax
  8048eb:	eb 79                	jmp    804966 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8048ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f1:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8048f8:	00 00 00 
  8048fb:	8b 12                	mov    (%rdx),%edx
  8048fd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8048ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804903:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80490a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80490e:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804915:	00 00 00 
  804918:	8b 12                	mov    (%rdx),%edx
  80491a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80491c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804920:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80492b:	48 89 c7             	mov    %rax,%rdi
  80492e:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  804935:	00 00 00 
  804938:	ff d0                	callq  *%rax
  80493a:	89 c2                	mov    %eax,%edx
  80493c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804940:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804942:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804946:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80494a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80494e:	48 89 c7             	mov    %rax,%rdi
  804951:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  804958:	00 00 00 
  80495b:	ff d0                	callq  *%rax
  80495d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80495f:	b8 00 00 00 00       	mov    $0x0,%eax
  804964:	eb 33                	jmp    804999 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804966:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80496a:	48 89 c6             	mov    %rax,%rsi
  80496d:	bf 00 00 00 00       	mov    $0x0,%edi
  804972:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804979:	00 00 00 
  80497c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80497e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804982:	48 89 c6             	mov    %rax,%rsi
  804985:	bf 00 00 00 00       	mov    $0x0,%edi
  80498a:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804991:	00 00 00 
  804994:	ff d0                	callq  *%rax
err:
	return r;
  804996:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804999:	48 83 c4 38          	add    $0x38,%rsp
  80499d:	5b                   	pop    %rbx
  80499e:	5d                   	pop    %rbp
  80499f:	c3                   	retq   

00000000008049a0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8049a0:	55                   	push   %rbp
  8049a1:	48 89 e5             	mov    %rsp,%rbp
  8049a4:	53                   	push   %rbx
  8049a5:	48 83 ec 28          	sub    $0x28,%rsp
  8049a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8049b1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049b8:	00 00 00 
  8049bb:	48 8b 00             	mov    (%rax),%rax
  8049be:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8049c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8049c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049cb:	48 89 c7             	mov    %rax,%rdi
  8049ce:	48 b8 ed 53 80 00 00 	movabs $0x8053ed,%rax
  8049d5:	00 00 00 
  8049d8:	ff d0                	callq  *%rax
  8049da:	89 c3                	mov    %eax,%ebx
  8049dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049e0:	48 89 c7             	mov    %rax,%rdi
  8049e3:	48 b8 ed 53 80 00 00 	movabs $0x8053ed,%rax
  8049ea:	00 00 00 
  8049ed:	ff d0                	callq  *%rax
  8049ef:	39 c3                	cmp    %eax,%ebx
  8049f1:	0f 94 c0             	sete   %al
  8049f4:	0f b6 c0             	movzbl %al,%eax
  8049f7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8049fa:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a01:	00 00 00 
  804a04:	48 8b 00             	mov    (%rax),%rax
  804a07:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a0d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804a10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a13:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a16:	75 05                	jne    804a1d <_pipeisclosed+0x7d>
			return ret;
  804a18:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a1b:	eb 4f                	jmp    804a6c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804a1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a20:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a23:	74 42                	je     804a67 <_pipeisclosed+0xc7>
  804a25:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804a29:	75 3c                	jne    804a67 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804a2b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a32:	00 00 00 
  804a35:	48 8b 00             	mov    (%rax),%rax
  804a38:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804a3e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a44:	89 c6                	mov    %eax,%esi
  804a46:	48 bf 93 5d 80 00 00 	movabs $0x805d93,%rdi
  804a4d:	00 00 00 
  804a50:	b8 00 00 00 00       	mov    $0x0,%eax
  804a55:	49 b8 8f 05 80 00 00 	movabs $0x80058f,%r8
  804a5c:	00 00 00 
  804a5f:	41 ff d0             	callq  *%r8
	}
  804a62:	e9 4a ff ff ff       	jmpq   8049b1 <_pipeisclosed+0x11>
  804a67:	e9 45 ff ff ff       	jmpq   8049b1 <_pipeisclosed+0x11>
}
  804a6c:	48 83 c4 28          	add    $0x28,%rsp
  804a70:	5b                   	pop    %rbx
  804a71:	5d                   	pop    %rbp
  804a72:	c3                   	retq   

0000000000804a73 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804a73:	55                   	push   %rbp
  804a74:	48 89 e5             	mov    %rsp,%rbp
  804a77:	48 83 ec 30          	sub    $0x30,%rsp
  804a7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a7e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804a82:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804a85:	48 89 d6             	mov    %rdx,%rsi
  804a88:	89 c7                	mov    %eax,%edi
  804a8a:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  804a91:	00 00 00 
  804a94:	ff d0                	callq  *%rax
  804a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a9d:	79 05                	jns    804aa4 <pipeisclosed+0x31>
		return r;
  804a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aa2:	eb 31                	jmp    804ad5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa8:	48 89 c7             	mov    %rax,%rdi
  804aab:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804ab2:	00 00 00 
  804ab5:	ff d0                	callq  *%rax
  804ab7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ac3:	48 89 d6             	mov    %rdx,%rsi
  804ac6:	48 89 c7             	mov    %rax,%rdi
  804ac9:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  804ad0:	00 00 00 
  804ad3:	ff d0                	callq  *%rax
}
  804ad5:	c9                   	leaveq 
  804ad6:	c3                   	retq   

0000000000804ad7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804ad7:	55                   	push   %rbp
  804ad8:	48 89 e5             	mov    %rsp,%rbp
  804adb:	48 83 ec 40          	sub    $0x40,%rsp
  804adf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804ae3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804ae7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804aef:	48 89 c7             	mov    %rax,%rdi
  804af2:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804af9:	00 00 00 
  804afc:	ff d0                	callq  *%rax
  804afe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b0a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b11:	00 
  804b12:	e9 92 00 00 00       	jmpq   804ba9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804b17:	eb 41                	jmp    804b5a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804b19:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b1e:	74 09                	je     804b29 <devpipe_read+0x52>
				return i;
  804b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b24:	e9 92 00 00 00       	jmpq   804bbb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804b29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b31:	48 89 d6             	mov    %rdx,%rsi
  804b34:	48 89 c7             	mov    %rax,%rdi
  804b37:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  804b3e:	00 00 00 
  804b41:	ff d0                	callq  *%rax
  804b43:	85 c0                	test   %eax,%eax
  804b45:	74 07                	je     804b4e <devpipe_read+0x77>
				return 0;
  804b47:	b8 00 00 00 00       	mov    $0x0,%eax
  804b4c:	eb 6d                	jmp    804bbb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804b4e:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b5e:	8b 10                	mov    (%rax),%edx
  804b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b64:	8b 40 04             	mov    0x4(%rax),%eax
  804b67:	39 c2                	cmp    %eax,%edx
  804b69:	74 ae                	je     804b19 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804b6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b73:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b7b:	8b 00                	mov    (%rax),%eax
  804b7d:	99                   	cltd   
  804b7e:	c1 ea 1b             	shr    $0x1b,%edx
  804b81:	01 d0                	add    %edx,%eax
  804b83:	83 e0 1f             	and    $0x1f,%eax
  804b86:	29 d0                	sub    %edx,%eax
  804b88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b8c:	48 98                	cltq   
  804b8e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804b93:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b99:	8b 00                	mov    (%rax),%eax
  804b9b:	8d 50 01             	lea    0x1(%rax),%edx
  804b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ba2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804ba4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804bb1:	0f 82 60 ff ff ff    	jb     804b17 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804bbb:	c9                   	leaveq 
  804bbc:	c3                   	retq   

0000000000804bbd <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804bbd:	55                   	push   %rbp
  804bbe:	48 89 e5             	mov    %rsp,%rbp
  804bc1:	48 83 ec 40          	sub    $0x40,%rsp
  804bc5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804bc9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804bcd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bd5:	48 89 c7             	mov    %rax,%rdi
  804bd8:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804bdf:	00 00 00 
  804be2:	ff d0                	callq  *%rax
  804be4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804be8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804bf0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804bf7:	00 
  804bf8:	e9 8e 00 00 00       	jmpq   804c8b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804bfd:	eb 31                	jmp    804c30 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804bff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c07:	48 89 d6             	mov    %rdx,%rsi
  804c0a:	48 89 c7             	mov    %rax,%rdi
  804c0d:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  804c14:	00 00 00 
  804c17:	ff d0                	callq  *%rax
  804c19:	85 c0                	test   %eax,%eax
  804c1b:	74 07                	je     804c24 <devpipe_write+0x67>
				return 0;
  804c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  804c22:	eb 79                	jmp    804c9d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804c24:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804c2b:	00 00 00 
  804c2e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c34:	8b 40 04             	mov    0x4(%rax),%eax
  804c37:	48 63 d0             	movslq %eax,%rdx
  804c3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c3e:	8b 00                	mov    (%rax),%eax
  804c40:	48 98                	cltq   
  804c42:	48 83 c0 20          	add    $0x20,%rax
  804c46:	48 39 c2             	cmp    %rax,%rdx
  804c49:	73 b4                	jae    804bff <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c4f:	8b 40 04             	mov    0x4(%rax),%eax
  804c52:	99                   	cltd   
  804c53:	c1 ea 1b             	shr    $0x1b,%edx
  804c56:	01 d0                	add    %edx,%eax
  804c58:	83 e0 1f             	and    $0x1f,%eax
  804c5b:	29 d0                	sub    %edx,%eax
  804c5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804c65:	48 01 ca             	add    %rcx,%rdx
  804c68:	0f b6 0a             	movzbl (%rdx),%ecx
  804c6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c6f:	48 98                	cltq   
  804c71:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c79:	8b 40 04             	mov    0x4(%rax),%eax
  804c7c:	8d 50 01             	lea    0x1(%rax),%edx
  804c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c83:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c93:	0f 82 64 ff ff ff    	jb     804bfd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804c9d:	c9                   	leaveq 
  804c9e:	c3                   	retq   

0000000000804c9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804c9f:	55                   	push   %rbp
  804ca0:	48 89 e5             	mov    %rsp,%rbp
  804ca3:	48 83 ec 20          	sub    $0x20,%rsp
  804ca7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804cab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cb3:	48 89 c7             	mov    %rax,%rdi
  804cb6:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804cbd:	00 00 00 
  804cc0:	ff d0                	callq  *%rax
  804cc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804cc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cca:	48 be a6 5d 80 00 00 	movabs $0x805da6,%rsi
  804cd1:	00 00 00 
  804cd4:	48 89 c7             	mov    %rax,%rdi
  804cd7:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  804cde:	00 00 00 
  804ce1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804ce3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ce7:	8b 50 04             	mov    0x4(%rax),%edx
  804cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cee:	8b 00                	mov    (%rax),%eax
  804cf0:	29 c2                	sub    %eax,%edx
  804cf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cf6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804cfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d00:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804d07:	00 00 00 
	stat->st_dev = &devpipe;
  804d0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d0e:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804d15:	00 00 00 
  804d18:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d24:	c9                   	leaveq 
  804d25:	c3                   	retq   

0000000000804d26 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804d26:	55                   	push   %rbp
  804d27:	48 89 e5             	mov    %rsp,%rbp
  804d2a:	48 83 ec 10          	sub    $0x10,%rsp
  804d2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d36:	48 89 c6             	mov    %rax,%rsi
  804d39:	bf 00 00 00 00       	mov    $0x0,%edi
  804d3e:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804d45:	00 00 00 
  804d48:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d4e:	48 89 c7             	mov    %rax,%rdi
  804d51:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804d58:	00 00 00 
  804d5b:	ff d0                	callq  *%rax
  804d5d:	48 89 c6             	mov    %rax,%rsi
  804d60:	bf 00 00 00 00       	mov    $0x0,%edi
  804d65:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804d6c:	00 00 00 
  804d6f:	ff d0                	callq  *%rax
}
  804d71:	c9                   	leaveq 
  804d72:	c3                   	retq   

0000000000804d73 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804d73:	55                   	push   %rbp
  804d74:	48 89 e5             	mov    %rsp,%rbp
  804d77:	48 83 ec 20          	sub    $0x20,%rsp
  804d7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804d7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d82:	75 35                	jne    804db9 <wait+0x46>
  804d84:	48 b9 ad 5d 80 00 00 	movabs $0x805dad,%rcx
  804d8b:	00 00 00 
  804d8e:	48 ba b8 5d 80 00 00 	movabs $0x805db8,%rdx
  804d95:	00 00 00 
  804d98:	be 09 00 00 00       	mov    $0x9,%esi
  804d9d:	48 bf cd 5d 80 00 00 	movabs $0x805dcd,%rdi
  804da4:	00 00 00 
  804da7:	b8 00 00 00 00       	mov    $0x0,%eax
  804dac:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  804db3:	00 00 00 
  804db6:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804db9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dbc:	25 ff 03 00 00       	and    $0x3ff,%eax
  804dc1:	48 63 d0             	movslq %eax,%rdx
  804dc4:	48 89 d0             	mov    %rdx,%rax
  804dc7:	48 c1 e0 03          	shl    $0x3,%rax
  804dcb:	48 01 d0             	add    %rdx,%rax
  804dce:	48 c1 e0 05          	shl    $0x5,%rax
  804dd2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804dd9:	00 00 00 
  804ddc:	48 01 d0             	add    %rdx,%rax
  804ddf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804de3:	eb 0c                	jmp    804df1 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804de5:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804dec:	00 00 00 
  804def:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804df5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804dfb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804dfe:	75 0e                	jne    804e0e <wait+0x9b>
  804e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e04:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804e0a:	85 c0                	test   %eax,%eax
  804e0c:	75 d7                	jne    804de5 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804e0e:	c9                   	leaveq 
  804e0f:	c3                   	retq   

0000000000804e10 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804e10:	55                   	push   %rbp
  804e11:	48 89 e5             	mov    %rsp,%rbp
  804e14:	48 83 ec 20          	sub    $0x20,%rsp
  804e18:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804e1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e1e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804e21:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804e25:	be 01 00 00 00       	mov    $0x1,%esi
  804e2a:	48 89 c7             	mov    %rax,%rdi
  804e2d:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  804e34:	00 00 00 
  804e37:	ff d0                	callq  *%rax
}
  804e39:	c9                   	leaveq 
  804e3a:	c3                   	retq   

0000000000804e3b <getchar>:

int
getchar(void)
{
  804e3b:	55                   	push   %rbp
  804e3c:	48 89 e5             	mov    %rsp,%rbp
  804e3f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804e43:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804e47:	ba 01 00 00 00       	mov    $0x1,%edx
  804e4c:	48 89 c6             	mov    %rax,%rsi
  804e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  804e54:	48 b8 5e 29 80 00 00 	movabs $0x80295e,%rax
  804e5b:	00 00 00 
  804e5e:	ff d0                	callq  *%rax
  804e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e67:	79 05                	jns    804e6e <getchar+0x33>
		return r;
  804e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e6c:	eb 14                	jmp    804e82 <getchar+0x47>
	if (r < 1)
  804e6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e72:	7f 07                	jg     804e7b <getchar+0x40>
		return -E_EOF;
  804e74:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804e79:	eb 07                	jmp    804e82 <getchar+0x47>
	return c;
  804e7b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804e7f:	0f b6 c0             	movzbl %al,%eax
}
  804e82:	c9                   	leaveq 
  804e83:	c3                   	retq   

0000000000804e84 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804e84:	55                   	push   %rbp
  804e85:	48 89 e5             	mov    %rsp,%rbp
  804e88:	48 83 ec 20          	sub    $0x20,%rsp
  804e8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804e8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804e93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e96:	48 89 d6             	mov    %rdx,%rsi
  804e99:	89 c7                	mov    %eax,%edi
  804e9b:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  804ea2:	00 00 00 
  804ea5:	ff d0                	callq  *%rax
  804ea7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804eaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804eae:	79 05                	jns    804eb5 <iscons+0x31>
		return r;
  804eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804eb3:	eb 1a                	jmp    804ecf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eb9:	8b 10                	mov    (%rax),%edx
  804ebb:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804ec2:	00 00 00 
  804ec5:	8b 00                	mov    (%rax),%eax
  804ec7:	39 c2                	cmp    %eax,%edx
  804ec9:	0f 94 c0             	sete   %al
  804ecc:	0f b6 c0             	movzbl %al,%eax
}
  804ecf:	c9                   	leaveq 
  804ed0:	c3                   	retq   

0000000000804ed1 <opencons>:

int
opencons(void)
{
  804ed1:	55                   	push   %rbp
  804ed2:	48 89 e5             	mov    %rsp,%rbp
  804ed5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804ed9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804edd:	48 89 c7             	mov    %rax,%rdi
  804ee0:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  804ee7:	00 00 00 
  804eea:	ff d0                	callq  *%rax
  804eec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804eef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ef3:	79 05                	jns    804efa <opencons+0x29>
		return r;
  804ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ef8:	eb 5b                	jmp    804f55 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804efe:	ba 07 04 00 00       	mov    $0x407,%edx
  804f03:	48 89 c6             	mov    %rax,%rsi
  804f06:	bf 00 00 00 00       	mov    $0x0,%edi
  804f0b:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804f12:	00 00 00 
  804f15:	ff d0                	callq  *%rax
  804f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f1e:	79 05                	jns    804f25 <opencons+0x54>
		return r;
  804f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f23:	eb 30                	jmp    804f55 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f29:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804f30:	00 00 00 
  804f33:	8b 12                	mov    (%rdx),%edx
  804f35:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f3b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804f42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f46:	48 89 c7             	mov    %rax,%rdi
  804f49:	48 b8 46 24 80 00 00 	movabs $0x802446,%rax
  804f50:	00 00 00 
  804f53:	ff d0                	callq  *%rax
}
  804f55:	c9                   	leaveq 
  804f56:	c3                   	retq   

0000000000804f57 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804f57:	55                   	push   %rbp
  804f58:	48 89 e5             	mov    %rsp,%rbp
  804f5b:	48 83 ec 30          	sub    $0x30,%rsp
  804f5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804f63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804f67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804f6b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804f70:	75 07                	jne    804f79 <devcons_read+0x22>
		return 0;
  804f72:	b8 00 00 00 00       	mov    $0x0,%eax
  804f77:	eb 4b                	jmp    804fc4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804f79:	eb 0c                	jmp    804f87 <devcons_read+0x30>
		sys_yield();
  804f7b:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804f82:	00 00 00 
  804f85:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804f87:	48 b8 75 19 80 00 00 	movabs $0x801975,%rax
  804f8e:	00 00 00 
  804f91:	ff d0                	callq  *%rax
  804f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f9a:	74 df                	je     804f7b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fa0:	79 05                	jns    804fa7 <devcons_read+0x50>
		return c;
  804fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fa5:	eb 1d                	jmp    804fc4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804fa7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804fab:	75 07                	jne    804fb4 <devcons_read+0x5d>
		return 0;
  804fad:	b8 00 00 00 00       	mov    $0x0,%eax
  804fb2:	eb 10                	jmp    804fc4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb7:	89 c2                	mov    %eax,%edx
  804fb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fbd:	88 10                	mov    %dl,(%rax)
	return 1;
  804fbf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804fc4:	c9                   	leaveq 
  804fc5:	c3                   	retq   

0000000000804fc6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804fc6:	55                   	push   %rbp
  804fc7:	48 89 e5             	mov    %rsp,%rbp
  804fca:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804fd1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804fd8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804fdf:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804fed:	eb 76                	jmp    805065 <devcons_write+0x9f>
		m = n - tot;
  804fef:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804ff6:	89 c2                	mov    %eax,%edx
  804ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ffb:	29 c2                	sub    %eax,%edx
  804ffd:	89 d0                	mov    %edx,%eax
  804fff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  805002:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805005:	83 f8 7f             	cmp    $0x7f,%eax
  805008:	76 07                	jbe    805011 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80500a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  805011:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805014:	48 63 d0             	movslq %eax,%rdx
  805017:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80501a:	48 63 c8             	movslq %eax,%rcx
  80501d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  805024:	48 01 c1             	add    %rax,%rcx
  805027:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80502e:	48 89 ce             	mov    %rcx,%rsi
  805031:	48 89 c7             	mov    %rax,%rdi
  805034:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80503b:	00 00 00 
  80503e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  805040:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805043:	48 63 d0             	movslq %eax,%rdx
  805046:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80504d:	48 89 d6             	mov    %rdx,%rsi
  805050:	48 89 c7             	mov    %rax,%rdi
  805053:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  80505a:	00 00 00 
  80505d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80505f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805062:	01 45 fc             	add    %eax,-0x4(%rbp)
  805065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805068:	48 98                	cltq   
  80506a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  805071:	0f 82 78 ff ff ff    	jb     804fef <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  805077:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80507a:	c9                   	leaveq 
  80507b:	c3                   	retq   

000000000080507c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80507c:	55                   	push   %rbp
  80507d:	48 89 e5             	mov    %rsp,%rbp
  805080:	48 83 ec 08          	sub    $0x8,%rsp
  805084:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  805088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80508d:	c9                   	leaveq 
  80508e:	c3                   	retq   

000000000080508f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80508f:	55                   	push   %rbp
  805090:	48 89 e5             	mov    %rsp,%rbp
  805093:	48 83 ec 10          	sub    $0x10,%rsp
  805097:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80509b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80509f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050a3:	48 be dd 5d 80 00 00 	movabs $0x805ddd,%rsi
  8050aa:	00 00 00 
  8050ad:	48 89 c7             	mov    %rax,%rdi
  8050b0:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  8050b7:	00 00 00 
  8050ba:	ff d0                	callq  *%rax
	return 0;
  8050bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050c1:	c9                   	leaveq 
  8050c2:	c3                   	retq   

00000000008050c3 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8050c3:	55                   	push   %rbp
  8050c4:	48 89 e5             	mov    %rsp,%rbp
  8050c7:	48 83 ec 10          	sub    $0x10,%rsp
  8050cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8050cf:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8050d6:	00 00 00 
  8050d9:	48 8b 00             	mov    (%rax),%rax
  8050dc:	48 85 c0             	test   %rax,%rax
  8050df:	0f 85 84 00 00 00    	jne    805169 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8050e5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8050ec:	00 00 00 
  8050ef:	48 8b 00             	mov    (%rax),%rax
  8050f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8050f8:	ba 07 00 00 00       	mov    $0x7,%edx
  8050fd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805102:	89 c7                	mov    %eax,%edi
  805104:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80510b:	00 00 00 
  80510e:	ff d0                	callq  *%rax
  805110:	85 c0                	test   %eax,%eax
  805112:	79 2a                	jns    80513e <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  805114:	48 ba e8 5d 80 00 00 	movabs $0x805de8,%rdx
  80511b:	00 00 00 
  80511e:	be 23 00 00 00       	mov    $0x23,%esi
  805123:	48 bf 0f 5e 80 00 00 	movabs $0x805e0f,%rdi
  80512a:	00 00 00 
  80512d:	b8 00 00 00 00       	mov    $0x0,%eax
  805132:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  805139:	00 00 00 
  80513c:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80513e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805145:	00 00 00 
  805148:	48 8b 00             	mov    (%rax),%rax
  80514b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805151:	48 be 7c 51 80 00 00 	movabs $0x80517c,%rsi
  805158:	00 00 00 
  80515b:	89 c7                	mov    %eax,%edi
  80515d:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  805164:	00 00 00 
  805167:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805169:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  805170:	00 00 00 
  805173:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805177:	48 89 10             	mov    %rdx,(%rax)
}
  80517a:	c9                   	leaveq 
  80517b:	c3                   	retq   

000000000080517c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80517c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80517f:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  805186:	00 00 00 
call *%rax
  805189:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  80518b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805192:	00 
	movq 152(%rsp), %rcx  //Load RSP
  805193:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80519a:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  80519b:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80519f:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8051a2:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8051a9:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8051aa:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8051ae:	4c 8b 3c 24          	mov    (%rsp),%r15
  8051b2:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8051b7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8051bc:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8051c1:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8051c6:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8051cb:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8051d0:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8051d5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8051da:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8051df:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8051e4:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8051e9:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8051ee:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8051f3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8051f8:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8051fc:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  805200:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  805201:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  805202:	c3                   	retq   

0000000000805203 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805203:	55                   	push   %rbp
  805204:	48 89 e5             	mov    %rsp,%rbp
  805207:	48 83 ec 30          	sub    $0x30,%rsp
  80520b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80520f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805213:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  805217:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80521e:	00 00 00 
  805221:	48 8b 00             	mov    (%rax),%rax
  805224:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80522a:	85 c0                	test   %eax,%eax
  80522c:	75 3c                	jne    80526a <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80522e:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  805235:	00 00 00 
  805238:	ff d0                	callq  *%rax
  80523a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80523f:	48 63 d0             	movslq %eax,%rdx
  805242:	48 89 d0             	mov    %rdx,%rax
  805245:	48 c1 e0 03          	shl    $0x3,%rax
  805249:	48 01 d0             	add    %rdx,%rax
  80524c:	48 c1 e0 05          	shl    $0x5,%rax
  805250:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805257:	00 00 00 
  80525a:	48 01 c2             	add    %rax,%rdx
  80525d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805264:	00 00 00 
  805267:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80526a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80526f:	75 0e                	jne    80527f <ipc_recv+0x7c>
		pg = (void*) UTOP;
  805271:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805278:	00 00 00 
  80527b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80527f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805283:	48 89 c7             	mov    %rax,%rdi
  805286:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80528d:	00 00 00 
  805290:	ff d0                	callq  *%rax
  805292:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805299:	79 19                	jns    8052b4 <ipc_recv+0xb1>
		*from_env_store = 0;
  80529b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80529f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8052a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052a9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8052af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052b2:	eb 53                	jmp    805307 <ipc_recv+0x104>
	}
	if(from_env_store)
  8052b4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8052b9:	74 19                	je     8052d4 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8052bb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052c2:	00 00 00 
  8052c5:	48 8b 00             	mov    (%rax),%rax
  8052c8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8052ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052d2:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8052d4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8052d9:	74 19                	je     8052f4 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8052db:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052e2:	00 00 00 
  8052e5:	48 8b 00             	mov    (%rax),%rax
  8052e8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8052ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052f2:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8052f4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052fb:	00 00 00 
  8052fe:	48 8b 00             	mov    (%rax),%rax
  805301:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  805307:	c9                   	leaveq 
  805308:	c3                   	retq   

0000000000805309 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805309:	55                   	push   %rbp
  80530a:	48 89 e5             	mov    %rsp,%rbp
  80530d:	48 83 ec 30          	sub    $0x30,%rsp
  805311:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805314:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805317:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80531b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80531e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805323:	75 0e                	jne    805333 <ipc_send+0x2a>
		pg = (void*)UTOP;
  805325:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80532c:	00 00 00 
  80532f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  805333:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805336:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805339:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80533d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805340:	89 c7                	mov    %eax,%edi
  805342:	48 b8 47 1c 80 00 00 	movabs $0x801c47,%rax
  805349:	00 00 00 
  80534c:	ff d0                	callq  *%rax
  80534e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  805351:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805355:	75 0c                	jne    805363 <ipc_send+0x5a>
			sys_yield();
  805357:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  80535e:	00 00 00 
  805361:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  805363:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805367:	74 ca                	je     805333 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  805369:	c9                   	leaveq 
  80536a:	c3                   	retq   

000000000080536b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80536b:	55                   	push   %rbp
  80536c:	48 89 e5             	mov    %rsp,%rbp
  80536f:	48 83 ec 14          	sub    $0x14,%rsp
  805373:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80537d:	eb 5e                	jmp    8053dd <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80537f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805386:	00 00 00 
  805389:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80538c:	48 63 d0             	movslq %eax,%rdx
  80538f:	48 89 d0             	mov    %rdx,%rax
  805392:	48 c1 e0 03          	shl    $0x3,%rax
  805396:	48 01 d0             	add    %rdx,%rax
  805399:	48 c1 e0 05          	shl    $0x5,%rax
  80539d:	48 01 c8             	add    %rcx,%rax
  8053a0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8053a6:	8b 00                	mov    (%rax),%eax
  8053a8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053ab:	75 2c                	jne    8053d9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8053ad:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8053b4:	00 00 00 
  8053b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053ba:	48 63 d0             	movslq %eax,%rdx
  8053bd:	48 89 d0             	mov    %rdx,%rax
  8053c0:	48 c1 e0 03          	shl    $0x3,%rax
  8053c4:	48 01 d0             	add    %rdx,%rax
  8053c7:	48 c1 e0 05          	shl    $0x5,%rax
  8053cb:	48 01 c8             	add    %rcx,%rax
  8053ce:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8053d4:	8b 40 08             	mov    0x8(%rax),%eax
  8053d7:	eb 12                	jmp    8053eb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8053d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8053dd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8053e4:	7e 99                	jle    80537f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8053e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053eb:	c9                   	leaveq 
  8053ec:	c3                   	retq   

00000000008053ed <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8053ed:	55                   	push   %rbp
  8053ee:	48 89 e5             	mov    %rsp,%rbp
  8053f1:	48 83 ec 18          	sub    $0x18,%rsp
  8053f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8053f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053fd:	48 c1 e8 15          	shr    $0x15,%rax
  805401:	48 89 c2             	mov    %rax,%rdx
  805404:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80540b:	01 00 00 
  80540e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805412:	83 e0 01             	and    $0x1,%eax
  805415:	48 85 c0             	test   %rax,%rax
  805418:	75 07                	jne    805421 <pageref+0x34>
		return 0;
  80541a:	b8 00 00 00 00       	mov    $0x0,%eax
  80541f:	eb 53                	jmp    805474 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805425:	48 c1 e8 0c          	shr    $0xc,%rax
  805429:	48 89 c2             	mov    %rax,%rdx
  80542c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805433:	01 00 00 
  805436:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80543a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80543e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805442:	83 e0 01             	and    $0x1,%eax
  805445:	48 85 c0             	test   %rax,%rax
  805448:	75 07                	jne    805451 <pageref+0x64>
		return 0;
  80544a:	b8 00 00 00 00       	mov    $0x0,%eax
  80544f:	eb 23                	jmp    805474 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805455:	48 c1 e8 0c          	shr    $0xc,%rax
  805459:	48 89 c2             	mov    %rax,%rdx
  80545c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805463:	00 00 00 
  805466:	48 c1 e2 04          	shl    $0x4,%rdx
  80546a:	48 01 d0             	add    %rdx,%rax
  80546d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805471:	0f b7 c0             	movzwl %ax,%eax
}
  805474:	c9                   	leaveq 
  805475:	c3                   	retq   
