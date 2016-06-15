
obj/user/stresssched.debug:     file format elf64-x86-64


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
  80003c:	e8 74 01 00 00       	callq  8001b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 02                	jne    80007c <umain+0x39>
			break;
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800084:	7e e4                	jle    80006a <umain+0x27>
		if (fork() == 0)
			break;
	if (i == 20) {
  800086:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008a:	75 11                	jne    80009d <umain+0x5a>
		sys_yield();
  80008c:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		return;
  800098:	e9 16 01 00 00       	jmpq   8001b3 <umain+0x170>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80009d:	eb 02                	jmp    8000a1 <umain+0x5e>
		asm volatile("pause");
  80009f:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b0:	00 00 00 
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 01 c8             	add    %rcx,%rax
  8000c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000cd:	8b 40 04             	mov    0x4(%rax),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 cb                	jne    80009f <umain+0x5c>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000db:	eb 41                	jmp    80011e <umain+0xdb>
		sys_yield();
  8000dd:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800108:	00 00 00 
  80010b:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800111:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800118:	7e d8                	jle    8000f2 <umain+0xaf>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800122:	7e b9                	jle    8000dd <umain+0x9a>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800124:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf c8 47 80 00 00 	movabs $0x8047c8,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf db 47 80 00 00 	movabs $0x8047db,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  8001ae:	00 00 00 
  8001b1:	ff d1                	callq  *%rcx

}
  8001b3:	c9                   	leaveq 
  8001b4:	c3                   	retq   

00000000008001b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	48 83 ec 10          	sub    $0x10,%rsp
  8001bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001c4:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d5:	48 63 d0             	movslq %eax,%rdx
  8001d8:	48 89 d0             	mov    %rdx,%rax
  8001db:	48 c1 e0 03          	shl    $0x3,%rax
  8001df:	48 01 d0             	add    %rdx,%rax
  8001e2:	48 c1 e0 05          	shl    $0x5,%rax
  8001e6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001ed:	00 00 00 
  8001f0:	48 01 c2             	add    %rax,%rdx
  8001f3:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x65>
		binaryname = argv[0];
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800221:	48 89 d6             	mov    %rdx,%rsi
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800232:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800244:	48 b8 94 26 80 00 00 	movabs $0x802694,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800250:	bf 00 00 00 00       	mov    $0x0,%edi
  800255:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax

}
  800261:	5d                   	pop    %rbp
  800262:	c3                   	retq   

0000000000800263 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	53                   	push   %rbx
  800268:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80026f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800276:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80027c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800283:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800291:	84 c0                	test   %al,%al
  800293:	74 23                	je     8002b8 <_panic+0x55>
  800295:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80029c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ac:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002bf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c6:	00 00 00 
  8002c9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d0:	00 00 00 
  8002d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002de:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ec:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f3:	00 00 00 
  8002f6:	48 8b 18             	mov    (%rax),%rbx
  8002f9:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
  800305:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80030b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800312:	41 89 c8             	mov    %ecx,%r8d
  800315:	48 89 d1             	mov    %rdx,%rcx
  800318:	48 89 da             	mov    %rbx,%rdx
  80031b:	89 c6                	mov    %eax,%esi
  80031d:	48 bf 08 48 80 00 00 	movabs $0x804808,%rdi
  800324:	00 00 00 
  800327:	b8 00 00 00 00       	mov    $0x0,%eax
  80032c:	49 b9 9c 04 80 00 00 	movabs $0x80049c,%r9
  800333:	00 00 00 
  800336:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800339:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800340:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800347:	48 89 d6             	mov    %rdx,%rsi
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
	cprintf("\n");
  800359:	48 bf 2b 48 80 00 00 	movabs $0x80482b,%rdi
  800360:	00 00 00 
  800363:	b8 00 00 00 00       	mov    $0x0,%eax
  800368:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  80036f:	00 00 00 
  800372:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800374:	cc                   	int3   
  800375:	eb fd                	jmp    800374 <_panic+0x111>

0000000000800377 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038a:	8b 00                	mov    (%rax),%eax
  80038c:	8d 48 01             	lea    0x1(%rax),%ecx
  80038f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800393:	89 0a                	mov    %ecx,(%rdx)
  800395:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800398:	89 d1                	mov    %edx,%ecx
  80039a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039e:	48 98                	cltq   
  8003a0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	8b 00                	mov    (%rax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	8b 00                	mov    (%rax),%eax
  8003b7:	48 98                	cltq   
  8003b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bd:	48 83 c2 08          	add    $0x8,%rdx
  8003c1:	48 89 c6             	mov    %rax,%rsi
  8003c4:	48 89 d7             	mov    %rdx,%rdi
  8003c7:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e1:	8b 40 04             	mov    0x4(%rax),%eax
  8003e4:	8d 50 01             	lea    0x1(%rax),%edx
  8003e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003eb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003fb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800402:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800409:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800410:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800417:	48 8b 0a             	mov    (%rdx),%rcx
  80041a:	48 89 08             	mov    %rcx,(%rax)
  80041d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800421:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800425:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800429:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80042d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800434:	00 00 00 
    b.cnt = 0;
  800437:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80043e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800441:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800448:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80044f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800456:	48 89 c6             	mov    %rax,%rsi
  800459:	48 bf 77 03 80 00 00 	movabs $0x800377,%rdi
  800460:	00 00 00 
  800463:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  80046a:	00 00 00 
  80046d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80046f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800475:	48 98                	cltq   
  800477:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80047e:	48 83 c2 08          	add    $0x8,%rdx
  800482:	48 89 c6             	mov    %rax,%rsi
  800485:	48 89 d7             	mov    %rdx,%rdi
  800488:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800494:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049a:	c9                   	leaveq 
  80049b:	c3                   	retq   

000000000080049c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp
  8004a0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ae:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ca:	84 c0                	test   %al,%al
  8004cc:	74 20                	je     8004ee <cprintf+0x52>
  8004ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ee:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004f5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004fc:	00 00 00 
  8004ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800506:	00 00 00 
  800509:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800514:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80051b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800522:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800529:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800530:	48 8b 0a             	mov    (%rdx),%rcx
  800533:	48 89 08             	mov    %rcx,(%rax)
  800536:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800542:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800546:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80054d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800554:	48 89 d6             	mov    %rdx,%rsi
  800557:	48 89 c7             	mov    %rax,%rdi
  80055a:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
  800566:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80056c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800572:	c9                   	leaveq 
  800573:	c3                   	retq   

0000000000800574 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800574:	55                   	push   %rbp
  800575:	48 89 e5             	mov    %rsp,%rbp
  800578:	53                   	push   %rbx
  800579:	48 83 ec 38          	sub    $0x38,%rsp
  80057d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800581:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800585:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800589:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80058c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800590:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800594:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800597:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80059b:	77 3b                	ja     8005d8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b0:	48 f7 f3             	div    %rbx
  8005b3:	48 89 c2             	mov    %rax,%rdx
  8005b6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005bc:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	41 89 f9             	mov    %edi,%r9d
  8005c7:	48 89 c7             	mov    %rax,%rdi
  8005ca:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8005d1:	00 00 00 
  8005d4:	ff d0                	callq  *%rax
  8005d6:	eb 1e                	jmp    8005f6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d8:	eb 12                	jmp    8005ec <printnum+0x78>
			putch(padc, putdat);
  8005da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005de:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	48 89 ce             	mov    %rcx,%rsi
  8005e8:	89 d7                	mov    %edx,%edi
  8005ea:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ec:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f4:	7f e4                	jg     8005da <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800602:	48 f7 f1             	div    %rcx
  800605:	48 89 d0             	mov    %rdx,%rax
  800608:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  80060f:	00 00 00 
  800612:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800616:	0f be d0             	movsbl %al,%edx
  800619:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	48 89 ce             	mov    %rcx,%rsi
  800624:	89 d7                	mov    %edx,%edi
  800626:	ff d0                	callq  *%rax
}
  800628:	48 83 c4 38          	add    $0x38,%rsp
  80062c:	5b                   	pop    %rbx
  80062d:	5d                   	pop    %rbp
  80062e:	c3                   	retq   

000000000080062f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062f:	55                   	push   %rbp
  800630:	48 89 e5             	mov    %rsp,%rbp
  800633:	48 83 ec 1c          	sub    $0x1c,%rsp
  800637:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80063e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800642:	7e 52                	jle    800696 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	83 f8 30             	cmp    $0x30,%eax
  80064d:	73 24                	jae    800673 <getuint+0x44>
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	89 c0                	mov    %eax,%eax
  80065f:	48 01 d0             	add    %rdx,%rax
  800662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800666:	8b 12                	mov    (%rdx),%edx
  800668:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	89 0a                	mov    %ecx,(%rdx)
  800671:	eb 17                	jmp    80068a <getuint+0x5b>
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067b:	48 89 d0             	mov    %rdx,%rax
  80067e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800686:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068a:	48 8b 00             	mov    (%rax),%rax
  80068d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800691:	e9 a3 00 00 00       	jmpq   800739 <getuint+0x10a>
	else if (lflag)
  800696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069a:	74 4f                	je     8006eb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	83 f8 30             	cmp    $0x30,%eax
  8006a5:	73 24                	jae    8006cb <getuint+0x9c>
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 01 d0             	add    %rdx,%rax
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	8b 12                	mov    (%rdx),%edx
  8006c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	89 0a                	mov    %ecx,(%rdx)
  8006c9:	eb 17                	jmp    8006e2 <getuint+0xb3>
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d3:	48 89 d0             	mov    %rdx,%rax
  8006d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e2:	48 8b 00             	mov    (%rax),%rax
  8006e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e9:	eb 4e                	jmp    800739 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	83 f8 30             	cmp    $0x30,%eax
  8006f4:	73 24                	jae    80071a <getuint+0xeb>
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	8b 00                	mov    (%rax),%eax
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 01 d0             	add    %rdx,%rax
  800709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070d:	8b 12                	mov    (%rdx),%edx
  80070f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	89 0a                	mov    %ecx,(%rdx)
  800718:	eb 17                	jmp    800731 <getuint+0x102>
  80071a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800722:	48 89 d0             	mov    %rdx,%rax
  800725:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800731:	8b 00                	mov    (%rax),%eax
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073d:	c9                   	leaveq 
  80073e:	c3                   	retq   

000000000080073f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %rbp
  800740:	48 89 e5             	mov    %rsp,%rbp
  800743:	48 83 ec 1c          	sub    $0x1c,%rsp
  800747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80074e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800752:	7e 52                	jle    8007a6 <getint+0x67>
		x=va_arg(*ap, long long);
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	83 f8 30             	cmp    $0x30,%eax
  80075d:	73 24                	jae    800783 <getint+0x44>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	89 c0                	mov    %eax,%eax
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800776:	8b 12                	mov    (%rdx),%edx
  800778:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077f:	89 0a                	mov    %ecx,(%rdx)
  800781:	eb 17                	jmp    80079a <getint+0x5b>
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078b:	48 89 d0             	mov    %rdx,%rax
  80078e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800792:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800796:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079a:	48 8b 00             	mov    (%rax),%rax
  80079d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a1:	e9 a3 00 00 00       	jmpq   800849 <getint+0x10a>
	else if (lflag)
  8007a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007aa:	74 4f                	je     8007fb <getint+0xbc>
		x=va_arg(*ap, long);
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	83 f8 30             	cmp    $0x30,%eax
  8007b5:	73 24                	jae    8007db <getint+0x9c>
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	89 c0                	mov    %eax,%eax
  8007c7:	48 01 d0             	add    %rdx,%rax
  8007ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ce:	8b 12                	mov    (%rdx),%edx
  8007d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	89 0a                	mov    %ecx,(%rdx)
  8007d9:	eb 17                	jmp    8007f2 <getint+0xb3>
  8007db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e3:	48 89 d0             	mov    %rdx,%rax
  8007e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f2:	48 8b 00             	mov    (%rax),%rax
  8007f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f9:	eb 4e                	jmp    800849 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	83 f8 30             	cmp    $0x30,%eax
  800804:	73 24                	jae    80082a <getint+0xeb>
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	89 c0                	mov    %eax,%eax
  800816:	48 01 d0             	add    %rdx,%rax
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	8b 12                	mov    (%rdx),%edx
  80081f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	89 0a                	mov    %ecx,(%rdx)
  800828:	eb 17                	jmp    800841 <getint+0x102>
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800832:	48 89 d0             	mov    %rdx,%rax
  800835:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800841:	8b 00                	mov    (%rax),%eax
  800843:	48 98                	cltq   
  800845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084d:	c9                   	leaveq 
  80084e:	c3                   	retq   

000000000080084f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80084f:	55                   	push   %rbp
  800850:	48 89 e5             	mov    %rsp,%rbp
  800853:	41 54                	push   %r12
  800855:	53                   	push   %rbx
  800856:	48 83 ec 60          	sub    $0x60,%rsp
  80085a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80085e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800862:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800866:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80086e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800872:	48 8b 0a             	mov    (%rdx),%rcx
  800875:	48 89 08             	mov    %rcx,(%rax)
  800878:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80087c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800880:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800884:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	eb 17                	jmp    8008a1 <vprintfmt+0x52>
			if (ch == '\0')
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	0f 84 cc 04 00 00    	je     800d5e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800892:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800896:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 df                	mov    %ebx,%edi
  80089f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ad:	0f b6 00             	movzbl (%rax),%eax
  8008b0:	0f b6 d8             	movzbl %al,%ebx
  8008b3:	83 fb 25             	cmp    $0x25,%ebx
  8008b6:	75 d2                	jne    80088a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008bc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e4:	0f b6 00             	movzbl (%rax),%eax
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ed:	83 f8 55             	cmp    $0x55,%eax
  8008f0:	0f 87 34 04 00 00    	ja     800d2a <vprintfmt+0x4db>
  8008f6:	89 c0                	mov    %eax,%eax
  8008f8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ff:	00 
  800900:	48 b8 58 4a 80 00 00 	movabs $0x804a58,%rax
  800907:	00 00 00 
  80090a:	48 01 d0             	add    %rdx,%rax
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800912:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800916:	eb c0                	jmp    8008d8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800918:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091c:	eb ba                	jmp    8008d8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800925:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800928:	89 d0                	mov    %edx,%eax
  80092a:	c1 e0 02             	shl    $0x2,%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	01 c0                	add    %eax,%eax
  800931:	01 d8                	add    %ebx,%eax
  800933:	83 e8 30             	sub    $0x30,%eax
  800936:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800939:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093d:	0f b6 00             	movzbl (%rax),%eax
  800940:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800943:	83 fb 2f             	cmp    $0x2f,%ebx
  800946:	7e 0c                	jle    800954 <vprintfmt+0x105>
  800948:	83 fb 39             	cmp    $0x39,%ebx
  80094b:	7f 07                	jg     800954 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800952:	eb d1                	jmp    800925 <vprintfmt+0xd6>
			goto process_precision;
  800954:	eb 58                	jmp    8009ae <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	83 f8 30             	cmp    $0x30,%eax
  80095c:	73 17                	jae    800975 <vprintfmt+0x126>
  80095e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 01 d0             	add    %rdx,%rax
  80096a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096d:	83 c2 08             	add    $0x8,%edx
  800970:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800973:	eb 0f                	jmp    800984 <vprintfmt+0x135>
  800975:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800979:	48 89 d0             	mov    %rdx,%rax
  80097c:	48 83 c2 08          	add    $0x8,%rdx
  800980:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800984:	8b 00                	mov    (%rax),%eax
  800986:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800989:	eb 23                	jmp    8009ae <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098f:	79 0c                	jns    80099d <vprintfmt+0x14e>
				width = 0;
  800991:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800998:	e9 3b ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  80099d:	e9 36 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a9:	e9 2a ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b2:	79 12                	jns    8009c6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c1:	e9 12 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  8009c6:	e9 0d ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009cf:	e9 04 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d7:	83 f8 30             	cmp    $0x30,%eax
  8009da:	73 17                	jae    8009f3 <vprintfmt+0x1a4>
  8009dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	89 c0                	mov    %eax,%eax
  8009e5:	48 01 d0             	add    %rdx,%rax
  8009e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009eb:	83 c2 08             	add    $0x8,%edx
  8009ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f1:	eb 0f                	jmp    800a02 <vprintfmt+0x1b3>
  8009f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f7:	48 89 d0             	mov    %rdx,%rax
  8009fa:	48 83 c2 08          	add    $0x8,%rdx
  8009fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a02:	8b 10                	mov    (%rax),%edx
  800a04:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0c:	48 89 ce             	mov    %rcx,%rsi
  800a0f:	89 d7                	mov    %edx,%edi
  800a11:	ff d0                	callq  *%rax
			break;
  800a13:	e9 40 03 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	83 f8 30             	cmp    $0x30,%eax
  800a1e:	73 17                	jae    800a37 <vprintfmt+0x1e8>
  800a20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a27:	89 c0                	mov    %eax,%eax
  800a29:	48 01 d0             	add    %rdx,%rax
  800a2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2f:	83 c2 08             	add    $0x8,%edx
  800a32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a35:	eb 0f                	jmp    800a46 <vprintfmt+0x1f7>
  800a37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3b:	48 89 d0             	mov    %rdx,%rax
  800a3e:	48 83 c2 08          	add    $0x8,%rdx
  800a42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a46:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a48:	85 db                	test   %ebx,%ebx
  800a4a:	79 02                	jns    800a4e <vprintfmt+0x1ff>
				err = -err;
  800a4c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4e:	83 fb 15             	cmp    $0x15,%ebx
  800a51:	7f 16                	jg     800a69 <vprintfmt+0x21a>
  800a53:	48 b8 80 49 80 00 00 	movabs $0x804980,%rax
  800a5a:	00 00 00 
  800a5d:	48 63 d3             	movslq %ebx,%rdx
  800a60:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a64:	4d 85 e4             	test   %r12,%r12
  800a67:	75 2e                	jne    800a97 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	89 d9                	mov    %ebx,%ecx
  800a73:	48 ba 41 4a 80 00 00 	movabs $0x804a41,%rdx
  800a7a:	00 00 00 
  800a7d:	48 89 c7             	mov    %rax,%rdi
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800a8c:	00 00 00 
  800a8f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a92:	e9 c1 02 00 00       	jmpq   800d58 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9f:	4c 89 e1             	mov    %r12,%rcx
  800aa2:	48 ba 4a 4a 80 00 00 	movabs $0x804a4a,%rdx
  800aa9:	00 00 00 
  800aac:	48 89 c7             	mov    %rax,%rdi
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800abb:	00 00 00 
  800abe:	41 ff d0             	callq  *%r8
			break;
  800ac1:	e9 92 02 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 17                	jae    800ae5 <vprintfmt+0x296>
  800ace:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	89 c0                	mov    %eax,%eax
  800ad7:	48 01 d0             	add    %rdx,%rax
  800ada:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800add:	83 c2 08             	add    $0x8,%edx
  800ae0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae3:	eb 0f                	jmp    800af4 <vprintfmt+0x2a5>
  800ae5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 83 c2 08          	add    $0x8,%rdx
  800af0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af4:	4c 8b 20             	mov    (%rax),%r12
  800af7:	4d 85 e4             	test   %r12,%r12
  800afa:	75 0a                	jne    800b06 <vprintfmt+0x2b7>
				p = "(null)";
  800afc:	49 bc 4d 4a 80 00 00 	movabs $0x804a4d,%r12
  800b03:	00 00 00 
			if (width > 0 && padc != '-')
  800b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0a:	7e 3f                	jle    800b4b <vprintfmt+0x2fc>
  800b0c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b10:	74 39                	je     800b4b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b15:	48 98                	cltq   
  800b17:	48 89 c6             	mov    %rax,%rsi
  800b1a:	4c 89 e7             	mov    %r12,%rdi
  800b1d:	48 b8 13 10 80 00 00 	movabs $0x801013,%rax
  800b24:	00 00 00 
  800b27:	ff d0                	callq  *%rax
  800b29:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b2c:	eb 17                	jmp    800b45 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b2e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b32:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3a:	48 89 ce             	mov    %rcx,%rsi
  800b3d:	89 d7                	mov    %edx,%edi
  800b3f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b49:	7f e3                	jg     800b2e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	eb 37                	jmp    800b84 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b51:	74 1e                	je     800b71 <vprintfmt+0x322>
  800b53:	83 fb 1f             	cmp    $0x1f,%ebx
  800b56:	7e 05                	jle    800b5d <vprintfmt+0x30e>
  800b58:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5b:	7e 14                	jle    800b71 <vprintfmt+0x322>
					putch('?', putdat);
  800b5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b65:	48 89 d6             	mov    %rdx,%rsi
  800b68:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6d:	ff d0                	callq  *%rax
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b79:	48 89 d6             	mov    %rdx,%rsi
  800b7c:	89 df                	mov    %ebx,%edi
  800b7e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b84:	4c 89 e0             	mov    %r12,%rax
  800b87:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b8b:	0f b6 00             	movzbl (%rax),%eax
  800b8e:	0f be d8             	movsbl %al,%ebx
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	74 10                	je     800ba5 <vprintfmt+0x356>
  800b95:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b99:	78 b2                	js     800b4d <vprintfmt+0x2fe>
  800b9b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba3:	79 a8                	jns    800b4d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba5:	eb 16                	jmp    800bbd <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc1:	7f e4                	jg     800ba7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc3:	e9 90 01 00 00       	jmpq   800d58 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	be 03 00 00 00       	mov    $0x3,%esi
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 3f 07 80 00 00 	movabs $0x80073f,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
  800be0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be8:	48 85 c0             	test   %rax,%rax
  800beb:	79 1d                	jns    800c0a <vprintfmt+0x3bb>
				putch('-', putdat);
  800bed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf5:	48 89 d6             	mov    %rdx,%rsi
  800bf8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bfd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c03:	48 f7 d8             	neg    %rax
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c11:	e9 d5 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c16:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1a:	be 03 00 00 00       	mov    $0x3,%esi
  800c1f:	48 89 c7             	mov    %rax,%rdi
  800c22:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c39:	e9 ad 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c3e:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c45:	89 d6                	mov    %edx,%esi
  800c47:	48 89 c7             	mov    %rax,%rdi
  800c4a:	48 b8 3f 07 80 00 00 	movabs $0x80073f,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
  800c56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c5a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c61:	e9 85 00 00 00       	jmpq   800ceb <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	bf 30 00 00 00       	mov    $0x30,%edi
  800c76:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 78 00 00 00       	mov    $0x78,%edi
  800c88:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x45a>
  800c92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	89 c0                	mov    %eax,%eax
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	eb 0f                	jmp    800cb8 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 89 d0             	mov    %rdx,%rax
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cbf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cc6:	eb 23                	jmp    800ceb <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccc:	be 03 00 00 00       	mov    $0x3,%esi
  800cd1:	48 89 c7             	mov    %rax,%rdi
  800cd4:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
  800ce0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ceb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cf3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	45 89 c1             	mov    %r8d,%r9d
  800d05:	41 89 f8             	mov    %edi,%r8d
  800d08:	48 89 c7             	mov    %rax,%rdi
  800d0b:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800d12:	00 00 00 
  800d15:	ff d0                	callq  *%rax
			break;
  800d17:	eb 3f                	jmp    800d58 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	eb 2e                	jmp    800d58 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d41:	eb 05                	jmp    800d48 <vprintfmt+0x4f9>
  800d43:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d4c:	48 83 e8 01          	sub    $0x1,%rax
  800d50:	0f b6 00             	movzbl (%rax),%eax
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 ec                	jne    800d43 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d59:	e9 43 fb ff ff       	jmpq   8008a1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d5e:	48 83 c4 60          	add    $0x60,%rsp
  800d62:	5b                   	pop    %rbx
  800d63:	41 5c                	pop    %r12
  800d65:	5d                   	pop    %rbp
  800d66:	c3                   	retq   

0000000000800d67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d72:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d79:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d95:	84 c0                	test   %al,%al
  800d97:	74 20                	je     800db9 <printfmt+0x52>
  800d99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800da5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800db5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dc7:	00 00 00 
  800dca:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd1:	00 00 00 
  800dd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ddf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800de6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ded:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800df4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dfb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e02:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e09:	48 89 c7             	mov    %rax,%rdi
  800e0c:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e18:	c9                   	leaveq 
  800e19:	c3                   	retq   

0000000000800e1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1a:	55                   	push   %rbp
  800e1b:	48 89 e5             	mov    %rsp,%rbp
  800e1e:	48 83 ec 10          	sub    $0x10,%rsp
  800e22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	8b 40 10             	mov    0x10(%rax),%eax
  800e30:	8d 50 01             	lea    0x1(%rax),%edx
  800e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e37:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	48 8b 10             	mov    (%rax),%rdx
  800e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e45:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e49:	48 39 c2             	cmp    %rax,%rdx
  800e4c:	73 17                	jae    800e65 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 00             	mov    (%rax),%rax
  800e55:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5d:	48 89 0a             	mov    %rcx,(%rdx)
  800e60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e63:	88 10                	mov    %dl,(%rax)
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	48 83 ec 50          	sub    $0x50,%rsp
  800e6f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e73:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e7a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e82:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e86:	48 8b 0a             	mov    (%rdx),%rcx
  800e89:	48 89 08             	mov    %rcx,(%rax)
  800e8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ea4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ea7:	48 98                	cltq   
  800ea9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ead:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb1:	48 01 d0             	add    %rdx,%rax
  800eb4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ebf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ec4:	74 06                	je     800ecc <vsnprintf+0x65>
  800ec6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eca:	7f 07                	jg     800ed3 <vsnprintf+0x6c>
		return -E_INVAL;
  800ecc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed1:	eb 2f                	jmp    800f02 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ed3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ed7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800edb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800edf:	48 89 c6             	mov    %rax,%rsi
  800ee2:	48 bf 1a 0e 80 00 00 	movabs $0x800e1a,%rdi
  800ee9:	00 00 00 
  800eec:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ef8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800efc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eff:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f0f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f16:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f31:	84 c0                	test   %al,%al
  800f33:	74 20                	je     800f55 <snprintf+0x51>
  800f35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f55:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f5c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f63:	00 00 00 
  800f66:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f6d:	00 00 00 
  800f70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f89:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f90:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f97:	48 8b 0a             	mov    (%rdx),%rcx
  800f9a:	48 89 08             	mov    %rcx,(%rax)
  800f9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fad:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fb4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fbb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 67 0e 80 00 00 	movabs $0x800e67,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
  800fd7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fdd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fe3:	c9                   	leaveq 
  800fe4:	c3                   	retq   

0000000000800fe5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fe5:	55                   	push   %rbp
  800fe6:	48 89 e5             	mov    %rsp,%rbp
  800fe9:	48 83 ec 18          	sub    $0x18,%rsp
  800fed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff8:	eb 09                	jmp    801003 <strlen+0x1e>
		n++;
  800ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801007:	0f b6 00             	movzbl (%rax),%eax
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ec                	jne    800ffa <strlen+0x15>
		n++;
	return n;
  80100e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801011:	c9                   	leaveq 
  801012:	c3                   	retq   

0000000000801013 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801013:	55                   	push   %rbp
  801014:	48 89 e5             	mov    %rsp,%rbp
  801017:	48 83 ec 20          	sub    $0x20,%rsp
  80101b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102a:	eb 0e                	jmp    80103a <strnlen+0x27>
		n++;
  80102c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801030:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801035:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80103a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80103f:	74 0b                	je     80104c <strnlen+0x39>
  801041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	84 c0                	test   %al,%al
  80104a:	75 e0                	jne    80102c <strnlen+0x19>
		n++;
	return n;
  80104c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104f:	c9                   	leaveq 
  801050:	c3                   	retq   

0000000000801051 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
  801055:	48 83 ec 20          	sub    $0x20,%rsp
  801059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801069:	90                   	nop
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801072:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801076:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80107a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80107e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801082:	0f b6 12             	movzbl (%rdx),%edx
  801085:	88 10                	mov    %dl,(%rax)
  801087:	0f b6 00             	movzbl (%rax),%eax
  80108a:	84 c0                	test   %al,%al
  80108c:	75 dc                	jne    80106a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 20          	sub    $0x20,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	48 89 c7             	mov    %rax,%rdi
  8010ab:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  8010b2:	00 00 00 
  8010b5:	ff d0                	callq  *%rax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bd:	48 63 d0             	movslq %eax,%rdx
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	48 01 c2             	add    %rax,%rdx
  8010c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010cb:	48 89 c6             	mov    %rax,%rsi
  8010ce:	48 89 d7             	mov    %rdx,%rdi
  8010d1:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
	return dst;
  8010dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 28          	sub    $0x28,%rsp
  8010eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801106:	00 
  801107:	eb 2a                	jmp    801133 <strncpy+0x50>
		*dst++ = *src;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801115:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801119:	0f b6 12             	movzbl (%rdx),%edx
  80111c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80111e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	74 05                	je     80112e <strncpy+0x4b>
			src++;
  801129:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80112e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80113b:	72 cc                	jb     801109 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801141:	c9                   	leaveq 
  801142:	c3                   	retq   

0000000000801143 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801143:	55                   	push   %rbp
  801144:	48 89 e5             	mov    %rsp,%rbp
  801147:	48 83 ec 28          	sub    $0x28,%rsp
  80114b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801153:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80115f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801164:	74 3d                	je     8011a3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801166:	eb 1d                	jmp    801185 <strlcpy+0x42>
			*dst++ = *src++;
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801170:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801174:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801178:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80117c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801180:	0f b6 12             	movzbl (%rdx),%edx
  801183:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801185:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80118a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118f:	74 0b                	je     80119c <strlcpy+0x59>
  801191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	84 c0                	test   %al,%al
  80119a:	75 cc                	jne    801168 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	48 29 c2             	sub    %rax,%rdx
  8011ae:	48 89 d0             	mov    %rdx,%rax
}
  8011b1:	c9                   	leaveq 
  8011b2:	c3                   	retq   

00000000008011b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	48 83 ec 10          	sub    $0x10,%rsp
  8011bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011c3:	eb 0a                	jmp    8011cf <strcmp+0x1c>
		p++, q++;
  8011c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 12                	je     8011ec <strcmp+0x39>
  8011da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011de:	0f b6 10             	movzbl (%rax),%edx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	0f b6 00             	movzbl (%rax),%eax
  8011e8:	38 c2                	cmp    %al,%dl
  8011ea:	74 d9                	je     8011c5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	0f b6 d0             	movzbl %al,%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 18          	sub    $0x18,%rsp
  80120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801216:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80121a:	eb 0f                	jmp    80122b <strncmp+0x25>
		n--, p++, q++;
  80121c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801221:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801226:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80122b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801230:	74 1d                	je     80124f <strncmp+0x49>
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	84 c0                	test   %al,%al
  80123b:	74 12                	je     80124f <strncmp+0x49>
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 10             	movzbl (%rax),%edx
  801244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	38 c2                	cmp    %al,%dl
  80124d:	74 cd                	je     80121c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80124f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801254:	75 07                	jne    80125d <strncmp+0x57>
		return 0;
  801256:	b8 00 00 00 00       	mov    $0x0,%eax
  80125b:	eb 18                	jmp    801275 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80125d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	0f b6 d0             	movzbl %al,%edx
  801267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	0f b6 c0             	movzbl %al,%eax
  801271:	29 c2                	sub    %eax,%edx
  801273:	89 d0                	mov    %edx,%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 0c          	sub    $0xc,%rsp
  80127f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801288:	eb 17                	jmp    8012a1 <strchr+0x2a>
		if (*s == c)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801294:	75 06                	jne    80129c <strchr+0x25>
			return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	eb 15                	jmp    8012b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 de                	jne    80128a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 0c          	sub    $0xc,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c4:	eb 13                	jmp    8012d9 <strfind+0x26>
		if (*s == c)
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d0:	75 02                	jne    8012d4 <strfind+0x21>
			break;
  8012d2:	eb 10                	jmp    8012e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	84 c0                	test   %al,%al
  8012e2:	75 e2                	jne    8012c6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 18          	sub    $0x18,%rsp
  8012f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801302:	75 06                	jne    80130a <memset+0x20>
		return v;
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	eb 69                	jmp    801373 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	83 e0 03             	and    $0x3,%eax
  801311:	48 85 c0             	test   %rax,%rax
  801314:	75 48                	jne    80135e <memset+0x74>
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	83 e0 03             	and    $0x3,%eax
  80131d:	48 85 c0             	test   %rax,%rax
  801320:	75 3c                	jne    80135e <memset+0x74>
		c &= 0xFF;
  801322:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 18             	shl    $0x18,%eax
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	c1 e0 10             	shl    $0x10,%eax
  801337:	09 c2                	or     %eax,%edx
  801339:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133c:	c1 e0 08             	shl    $0x8,%eax
  80133f:	09 d0                	or     %edx,%eax
  801341:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	48 c1 e8 02          	shr    $0x2,%rax
  80134c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80134f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801353:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801356:	48 89 d7             	mov    %rdx,%rdi
  801359:	fc                   	cld    
  80135a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80135c:	eb 11                	jmp    80136f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80135e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801365:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801369:	48 89 d7             	mov    %rdx,%rdi
  80136c:	fc                   	cld    
  80136d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 28          	sub    $0x28,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801395:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a1:	0f 83 88 00 00 00    	jae    80142f <memmove+0xba>
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013af:	48 01 d0             	add    %rdx,%rax
  8013b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b6:	76 77                	jbe    80142f <memmove+0xba>
		s += n;
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cc:	83 e0 03             	and    $0x3,%eax
  8013cf:	48 85 c0             	test   %rax,%rax
  8013d2:	75 3b                	jne    80140f <memmove+0x9a>
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	83 e0 03             	and    $0x3,%eax
  8013db:	48 85 c0             	test   %rax,%rax
  8013de:	75 2f                	jne    80140f <memmove+0x9a>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	83 e0 03             	and    $0x3,%eax
  8013e7:	48 85 c0             	test   %rax,%rax
  8013ea:	75 23                	jne    80140f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f0:	48 83 e8 04          	sub    $0x4,%rax
  8013f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f8:	48 83 ea 04          	sub    $0x4,%rdx
  8013fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801400:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801404:	48 89 c7             	mov    %rax,%rdi
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	fd                   	std    
  80140b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80140d:	eb 1d                	jmp    80142c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	48 89 d7             	mov    %rdx,%rdi
  801426:	48 89 c1             	mov    %rax,%rcx
  801429:	fd                   	std    
  80142a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80142c:	fc                   	cld    
  80142d:	eb 57                	jmp    801486 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 36                	jne    801471 <memmove+0xfc>
  80143b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 2a                	jne    801471 <memmove+0xfc>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 1e                	jne    801471 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	48 c1 e8 02          	shr    $0x2,%rax
  80145b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801466:	48 89 c7             	mov    %rax,%rdi
  801469:	48 89 d6             	mov    %rdx,%rsi
  80146c:	fc                   	cld    
  80146d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146f:	eb 15                	jmp    801486 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801479:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 89 d6             	mov    %rdx,%rsi
  801483:	fc                   	cld    
  801484:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148a:	c9                   	leaveq 
  80148b:	c3                   	retq   

000000000080148c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	48 83 ec 18          	sub    $0x18,%rsp
  801494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80149c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ac:	48 89 ce             	mov    %rcx,%rsi
  8014af:	48 89 c7             	mov    %rax,%rdi
  8014b2:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	callq  *%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 28          	sub    $0x28,%rsp
  8014c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014e4:	eb 36                	jmp    80151c <memcmp+0x5c>
		if (*s1 != *s2)
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	0f b6 10             	movzbl (%rax),%edx
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	38 c2                	cmp    %al,%dl
  8014f6:	74 1a                	je     801512 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	0f b6 d0             	movzbl %al,%edx
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
  801510:	eb 20                	jmp    801532 <memcmp+0x72>
		s1++, s2++;
  801512:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801517:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801524:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801528:	48 85 c0             	test   %rax,%rax
  80152b:	75 b9                	jne    8014e6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801532:	c9                   	leaveq 
  801533:	c3                   	retq   

0000000000801534 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801534:	55                   	push   %rbp
  801535:	48 89 e5             	mov    %rsp,%rbp
  801538:	48 83 ec 28          	sub    $0x28,%rsp
  80153c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801540:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801543:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80154f:	48 01 d0             	add    %rdx,%rax
  801552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801556:	eb 15                	jmp    80156d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	0f b6 10             	movzbl (%rax),%edx
  80155f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801562:	38 c2                	cmp    %al,%dl
  801564:	75 02                	jne    801568 <memfind+0x34>
			break;
  801566:	eb 0f                	jmp    801577 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801568:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801575:	72 e1                	jb     801558 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 34          	sub    $0x34,%rsp
  801585:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801589:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80158d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801597:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80159e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159f:	eb 05                	jmp    8015a6 <strtol+0x29>
		s++;
  8015a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 20                	cmp    $0x20,%al
  8015af:	74 f0                	je     8015a1 <strtol+0x24>
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 09                	cmp    $0x9,%al
  8015ba:	74 e5                	je     8015a1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 2b                	cmp    $0x2b,%al
  8015c5:	75 07                	jne    8015ce <strtol+0x51>
		s++;
  8015c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015cc:	eb 17                	jmp    8015e5 <strtol+0x68>
	else if (*s == '-')
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 2d                	cmp    $0x2d,%al
  8015d7:	75 0c                	jne    8015e5 <strtol+0x68>
		s++, neg = 1;
  8015d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e9:	74 06                	je     8015f1 <strtol+0x74>
  8015eb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015ef:	75 28                	jne    801619 <strtol+0x9c>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 30                	cmp    $0x30,%al
  8015fa:	75 1d                	jne    801619 <strtol+0x9c>
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	48 83 c0 01          	add    $0x1,%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	3c 78                	cmp    $0x78,%al
  801609:	75 0e                	jne    801619 <strtol+0x9c>
		s += 2, base = 16;
  80160b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801610:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801617:	eb 2c                	jmp    801645 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801619:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161d:	75 19                	jne    801638 <strtol+0xbb>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 30                	cmp    $0x30,%al
  801628:	75 0e                	jne    801638 <strtol+0xbb>
		s++, base = 8;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801636:	eb 0d                	jmp    801645 <strtol+0xc8>
	else if (base == 0)
  801638:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163c:	75 07                	jne    801645 <strtol+0xc8>
		base = 10;
  80163e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 2f                	cmp    $0x2f,%al
  80164e:	7e 1d                	jle    80166d <strtol+0xf0>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 39                	cmp    $0x39,%al
  801659:	7f 12                	jg     80166d <strtol+0xf0>
			dig = *s - '0';
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 30             	sub    $0x30,%eax
  801668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166b:	eb 4e                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 60                	cmp    $0x60,%al
  801676:	7e 1d                	jle    801695 <strtol+0x118>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 7a                	cmp    $0x7a,%al
  801681:	7f 12                	jg     801695 <strtol+0x118>
			dig = *s - 'a' + 10;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 57             	sub    $0x57,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801693:	eb 26                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 40                	cmp    $0x40,%al
  80169e:	7e 48                	jle    8016e8 <strtol+0x16b>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 5a                	cmp    $0x5a,%al
  8016a9:	7f 3d                	jg     8016e8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	0f be c0             	movsbl %al,%eax
  8016b5:	83 e8 37             	sub    $0x37,%eax
  8016b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016be:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c1:	7c 02                	jl     8016c5 <strtol+0x148>
			break;
  8016c3:	eb 23                	jmp    8016e8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ca:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016cd:	48 98                	cltq   
  8016cf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016d4:	48 89 c2             	mov    %rax,%rdx
  8016d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016da:	48 98                	cltq   
  8016dc:	48 01 d0             	add    %rdx,%rax
  8016df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016e3:	e9 5d ff ff ff       	jmpq   801645 <strtol+0xc8>

	if (endptr)
  8016e8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016ed:	74 0b                	je     8016fa <strtol+0x17d>
		*endptr = (char *) s;
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016f7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016fe:	74 09                	je     801709 <strtol+0x18c>
  801700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801704:	48 f7 d8             	neg    %rax
  801707:	eb 04                	jmp    80170d <strtol+0x190>
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <strstr>:

char * strstr(const char *in, const char *str)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 30          	sub    $0x30,%rsp
  801717:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80171b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80171f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801727:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801731:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801735:	75 06                	jne    80173d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	eb 6b                	jmp    8017a8 <strstr+0x99>

	len = strlen(str);
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 89 c7             	mov    %rax,%rdi
  801744:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
  801750:	48 98                	cltq   
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80175e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801762:	0f b6 00             	movzbl (%rax),%eax
  801765:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801768:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80176c:	75 07                	jne    801775 <strstr+0x66>
				return (char *) 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	eb 33                	jmp    8017a8 <strstr+0x99>
		} while (sc != c);
  801775:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801779:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80177c:	75 d8                	jne    801756 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80177e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801782:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	48 89 ce             	mov    %rcx,%rsi
  80178d:	48 89 c7             	mov    %rax,%rdi
  801790:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 b6                	jne    801756 <strstr+0x47>

	return (char *) (in - 1);
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a8:	c9                   	leaveq 
  8017a9:	c3                   	retq   

00000000008017aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017aa:	55                   	push   %rbp
  8017ab:	48 89 e5             	mov    %rsp,%rbp
  8017ae:	53                   	push   %rbx
  8017af:	48 83 ec 48          	sub    $0x48,%rsp
  8017b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017c1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017c5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017d4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017dc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e0:	4c 89 c3             	mov    %r8,%rbx
  8017e3:	cd 30                	int    $0x30
  8017e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017ed:	74 3e                	je     80182d <syscall+0x83>
  8017ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f4:	7e 37                	jle    80182d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fd:	49 89 d0             	mov    %rdx,%r8
  801800:	89 c1                	mov    %eax,%ecx
  801802:	48 ba 08 4d 80 00 00 	movabs $0x804d08,%rdx
  801809:	00 00 00 
  80180c:	be 23 00 00 00       	mov    $0x23,%esi
  801811:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  801818:	00 00 00 
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	49 b9 63 02 80 00 00 	movabs $0x800263,%r9
  801827:	00 00 00 
  80182a:	41 ff d1             	callq  *%r9

	return ret;
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801831:	48 83 c4 48          	add    $0x48,%rsp
  801835:	5b                   	pop    %rbx
  801836:	5d                   	pop    %rbp
  801837:	c3                   	retq   

0000000000801838 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 20          	sub    $0x20,%rsp
  801840:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801844:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801850:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801857:	00 
  801858:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801864:	48 89 d1             	mov    %rdx,%rcx
  801867:	48 89 c2             	mov    %rax,%rdx
  80186a:	be 00 00 00 00       	mov    $0x0,%esi
  80186f:	bf 00 00 00 00       	mov    $0x0,%edi
  801874:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
}
  801880:	c9                   	leaveq 
  801881:	c3                   	retq   

0000000000801882 <sys_cgetc>:

int
sys_cgetc(void)
{
  801882:	55                   	push   %rbp
  801883:	48 89 e5             	mov    %rsp,%rbp
  801886:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80188a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801891:	00 
  801892:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801898:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	be 00 00 00 00       	mov    $0x0,%esi
  8018ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018b9:	00 00 00 
  8018bc:	ff d0                	callq  *%rax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 10          	sub    $0x10,%rsp
  8018c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ce:	48 98                	cltq   
  8018d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d7:	00 
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e9:	48 89 c2             	mov    %rax,%rdx
  8018ec:	be 01 00 00 00       	mov    $0x1,%esi
  8018f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018f6:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	b9 00 00 00 00       	mov    $0x0,%ecx
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 02 00 00 00       	mov    $0x2,%edi
  801934:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_yield>:

void
sys_yield(void)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80194a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801951:	00 
  801952:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801958:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
  801968:	be 00 00 00 00       	mov    $0x0,%esi
  80196d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801972:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801979:	00 00 00 
  80197c:	ff d0                	callq  *%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	48 83 ec 20          	sub    $0x20,%rsp
  801988:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80198b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801992:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801995:	48 63 c8             	movslq %eax,%rcx
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199f:	48 98                	cltq   
  8019a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a8:	00 
  8019a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019af:	49 89 c8             	mov    %rcx,%r8
  8019b2:	48 89 d1             	mov    %rdx,%rcx
  8019b5:	48 89 c2             	mov    %rax,%rdx
  8019b8:	be 01 00 00 00       	mov    $0x1,%esi
  8019bd:	bf 04 00 00 00       	mov    $0x4,%edi
  8019c2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	callq  *%rax
}
  8019ce:	c9                   	leaveq 
  8019cf:	c3                   	retq   

00000000008019d0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019d0:	55                   	push   %rbp
  8019d1:	48 89 e5             	mov    %rsp,%rbp
  8019d4:	48 83 ec 30          	sub    $0x30,%rsp
  8019d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019df:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019e2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019e6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019ed:	48 63 c8             	movslq %eax,%rcx
  8019f0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f7:	48 63 f0             	movslq %eax,%rsi
  8019fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a01:	48 98                	cltq   
  801a03:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a07:	49 89 f9             	mov    %rdi,%r9
  801a0a:	49 89 f0             	mov    %rsi,%r8
  801a0d:	48 89 d1             	mov    %rdx,%rcx
  801a10:	48 89 c2             	mov    %rax,%rdx
  801a13:	be 01 00 00 00       	mov    $0x1,%esi
  801a18:	bf 05 00 00 00       	mov    $0x5,%edi
  801a1d:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801a24:	00 00 00 
  801a27:	ff d0                	callq  *%rax
}
  801a29:	c9                   	leaveq 
  801a2a:	c3                   	retq   

0000000000801a2b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a2b:	55                   	push   %rbp
  801a2c:	48 89 e5             	mov    %rsp,%rbp
  801a2f:	48 83 ec 20          	sub    $0x20,%rsp
  801a33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a41:	48 98                	cltq   
  801a43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4a:	00 
  801a4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a57:	48 89 d1             	mov    %rdx,%rcx
  801a5a:	48 89 c2             	mov    %rax,%rdx
  801a5d:	be 01 00 00 00       	mov    $0x1,%esi
  801a62:	bf 06 00 00 00       	mov    $0x6,%edi
  801a67:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 10          	sub    $0x10,%rsp
  801a7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a80:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a86:	48 63 d0             	movslq %eax,%rdx
  801a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8c:	48 98                	cltq   
  801a8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a95:	00 
  801a96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa2:	48 89 d1             	mov    %rdx,%rcx
  801aa5:	48 89 c2             	mov    %rax,%rdx
  801aa8:	be 01 00 00 00       	mov    $0x1,%esi
  801aad:	bf 08 00 00 00       	mov    $0x8,%edi
  801ab2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
}
  801abe:	c9                   	leaveq 
  801abf:	c3                   	retq   

0000000000801ac0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ac0:	55                   	push   %rbp
  801ac1:	48 89 e5             	mov    %rsp,%rbp
  801ac4:	48 83 ec 20          	sub    $0x20,%rsp
  801ac8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801acf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad6:	48 98                	cltq   
  801ad8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adf:	00 
  801ae0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aec:	48 89 d1             	mov    %rdx,%rcx
  801aef:	48 89 c2             	mov    %rax,%rdx
  801af2:	be 01 00 00 00       	mov    $0x1,%esi
  801af7:	bf 09 00 00 00       	mov    $0x9,%edi
  801afc:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax
}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 20          	sub    $0x20,%rsp
  801b12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b20:	48 98                	cltq   
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b46:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
}
  801b52:	c9                   	leaveq 
  801b53:	c3                   	retq   

0000000000801b54 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b54:	55                   	push   %rbp
  801b55:	48 89 e5             	mov    %rsp,%rbp
  801b58:	48 83 ec 20          	sub    $0x20,%rsp
  801b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b67:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6d:	48 63 f0             	movslq %eax,%rsi
  801b70:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b77:	48 98                	cltq   
  801b79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b84:	00 
  801b85:	49 89 f1             	mov    %rsi,%r9
  801b88:	49 89 c8             	mov    %rcx,%r8
  801b8b:	48 89 d1             	mov    %rdx,%rcx
  801b8e:	48 89 c2             	mov    %rax,%rdx
  801b91:	be 00 00 00 00       	mov    $0x0,%esi
  801b96:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b9b:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 10          	sub    $0x10,%rsp
  801bb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc0:	00 
  801bc1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bdf:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 20          	sub    $0x20,%rsp
  801bf5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0c:	00 
  801c0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c19:	48 89 d1             	mov    %rdx,%rcx
  801c1c:	48 89 c2             	mov    %rax,%rdx
  801c1f:	be 01 00 00 00       	mov    $0x1,%esi
  801c24:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c29:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	callq  *%rax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 10          	sub    $0x10,%rsp
  801c3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4e:	00 
  801c4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c60:	48 89 c2             	mov    %rax,%rdx
  801c63:	be 00 00 00 00       	mov    $0x0,%esi
  801c68:	bf 10 00 00 00       	mov    $0x10,%edi
  801c6d:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801c74:	00 00 00 
  801c77:	ff d0                	callq  *%rax
}
  801c79:	c9                   	leaveq 
  801c7a:	c3                   	retq   

0000000000801c7b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c83:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8a:	00 
  801c8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca1:	be 00 00 00 00       	mov    $0x0,%esi
  801ca6:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cab:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  801cb2:	00 00 00 
  801cb5:	ff d0                	callq  *%rax
}
  801cb7:	c9                   	leaveq 
  801cb8:	c3                   	retq   

0000000000801cb9 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801cb9:	55                   	push   %rbp
  801cba:	48 89 e5             	mov    %rsp,%rbp
  801cbd:	48 83 ec 30          	sub    $0x30,%rsp
  801cc1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc9:	48 8b 00             	mov    (%rax),%rax
  801ccc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd4:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cd8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801cdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cde:	83 e0 02             	and    $0x2,%eax
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	75 4d                	jne    801d32 <pgfault+0x79>
  801ce5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce9:	48 c1 e8 0c          	shr    $0xc,%rax
  801ced:	48 89 c2             	mov    %rax,%rdx
  801cf0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cf7:	01 00 00 
  801cfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cfe:	25 00 08 00 00       	and    $0x800,%eax
  801d03:	48 85 c0             	test   %rax,%rax
  801d06:	74 2a                	je     801d32 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801d08:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801d0f:	00 00 00 
  801d12:	be 23 00 00 00       	mov    $0x23,%esi
  801d17:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d1e:	00 00 00 
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
  801d26:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801d2d:	00 00 00 
  801d30:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d32:	ba 07 00 00 00       	mov    $0x7,%edx
  801d37:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d41:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	0f 85 cd 00 00 00    	jne    801e22 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d61:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d74:	48 89 c6             	mov    %rax,%rsi
  801d77:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d7c:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  801d83:	00 00 00 
  801d86:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801d88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d8c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d92:	48 89 c1             	mov    %rax,%rcx
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801da4:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	79 2a                	jns    801dde <pgfault+0x125>
				panic("Page map at temp address failed");
  801db4:	48 ba 78 4d 80 00 00 	movabs $0x804d78,%rdx
  801dbb:	00 00 00 
  801dbe:	be 30 00 00 00       	mov    $0x30,%esi
  801dc3:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801dca:	00 00 00 
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801dd9:	00 00 00 
  801ddc:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801dde:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801de3:	bf 00 00 00 00       	mov    $0x0,%edi
  801de8:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	85 c0                	test   %eax,%eax
  801df6:	79 54                	jns    801e4c <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801df8:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  801dff:	00 00 00 
  801e02:	be 32 00 00 00       	mov    $0x32,%esi
  801e07:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e0e:	00 00 00 
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
  801e16:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e1d:	00 00 00 
  801e20:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801e22:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  801e29:	00 00 00 
  801e2c:	be 34 00 00 00       	mov    $0x34,%esi
  801e31:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e38:	00 00 00 
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e40:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801e47:	00 00 00 
  801e4a:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 20          	sub    $0x20,%rsp
  801e56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e59:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e63:	01 00 00 
  801e66:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e72:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e75:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e78:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e83:	25 00 04 00 00       	and    $0x400,%eax
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	74 57                	je     801ee3 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e8c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e8f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e93:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9a:	41 89 f0             	mov    %esi,%r8d
  801e9d:	48 89 c6             	mov    %rax,%rsi
  801ea0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea5:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801eac:	00 00 00 
  801eaf:	ff d0                	callq  *%rax
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	0f 8e 52 01 00 00    	jle    80200b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801eb9:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801ec0:	00 00 00 
  801ec3:	be 4e 00 00 00       	mov    $0x4e,%esi
  801ec8:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ecf:	00 00 00 
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed7:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801ede:	00 00 00 
  801ee1:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee6:	83 e0 02             	and    $0x2,%eax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	75 10                	jne    801efd <duppage+0xaf>
  801eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef0:	25 00 08 00 00       	and    $0x800,%eax
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	0f 84 bb 00 00 00    	je     801fb8 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f00:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801f05:	80 cc 08             	or     $0x8,%ah
  801f08:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f0b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f0e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f12:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f19:	41 89 f0             	mov    %esi,%r8d
  801f1c:	48 89 c6             	mov    %rax,%rsi
  801f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f24:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
  801f30:	85 c0                	test   %eax,%eax
  801f32:	7e 2a                	jle    801f5e <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f34:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f3b:	00 00 00 
  801f3e:	be 55 00 00 00       	mov    $0x55,%esi
  801f43:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801f4a:	00 00 00 
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801f59:	00 00 00 
  801f5c:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f5e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f69:	41 89 c8             	mov    %ecx,%r8d
  801f6c:	48 89 d1             	mov    %rdx,%rcx
  801f6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f74:	48 89 c6             	mov    %rax,%rsi
  801f77:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7c:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	7e 2a                	jle    801fb6 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801f8c:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f93:	00 00 00 
  801f96:	be 57 00 00 00       	mov    $0x57,%esi
  801f9b:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801fa2:	00 00 00 
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801fb1:	00 00 00 
  801fb4:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801fb6:	eb 53                	jmp    80200b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fb8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fbb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fbf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc6:	41 89 f0             	mov    %esi,%r8d
  801fc9:	48 89 c6             	mov    %rax,%rsi
  801fcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd1:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	7e 2a                	jle    80200b <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fe1:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801fe8:	00 00 00 
  801feb:	be 5b 00 00 00       	mov    $0x5b,%esi
  801ff0:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ff7:	00 00 00 
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  801fff:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  802006:	00 00 00 
  802009:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	c9                   	leaveq 
  802011:	c3                   	retq   

0000000000802012 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802012:	55                   	push   %rbp
  802013:	48 89 e5             	mov    %rsp,%rbp
  802016:	48 83 ec 18          	sub    $0x18,%rsp
  80201a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80201e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802022:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202a:	48 c1 e8 27          	shr    $0x27,%rax
  80202e:	48 89 c2             	mov    %rax,%rdx
  802031:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802038:	01 00 00 
  80203b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203f:	83 e0 01             	and    $0x1,%eax
  802042:	48 85 c0             	test   %rax,%rax
  802045:	74 51                	je     802098 <pt_is_mapped+0x86>
  802047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204b:	48 c1 e0 0c          	shl    $0xc,%rax
  80204f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802053:	48 89 c2             	mov    %rax,%rdx
  802056:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80205d:	01 00 00 
  802060:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802064:	83 e0 01             	and    $0x1,%eax
  802067:	48 85 c0             	test   %rax,%rax
  80206a:	74 2c                	je     802098 <pt_is_mapped+0x86>
  80206c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802070:	48 c1 e0 0c          	shl    $0xc,%rax
  802074:	48 c1 e8 15          	shr    $0x15,%rax
  802078:	48 89 c2             	mov    %rax,%rdx
  80207b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802082:	01 00 00 
  802085:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802089:	83 e0 01             	and    $0x1,%eax
  80208c:	48 85 c0             	test   %rax,%rax
  80208f:	74 07                	je     802098 <pt_is_mapped+0x86>
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	eb 05                	jmp    80209d <pt_is_mapped+0x8b>
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	83 e0 01             	and    $0x1,%eax
}
  8020a0:	c9                   	leaveq 
  8020a1:	c3                   	retq   

00000000008020a2 <fork>:

envid_t
fork(void)
{
  8020a2:	55                   	push   %rbp
  8020a3:	48 89 e5             	mov    %rsp,%rbp
  8020a6:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8020aa:	48 bf b9 1c 80 00 00 	movabs $0x801cb9,%rdi
  8020b1:	00 00 00 
  8020b4:	48 b8 df 43 80 00 00 	movabs $0x8043df,%rax
  8020bb:	00 00 00 
  8020be:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020c0:	b8 07 00 00 00       	mov    $0x7,%eax
  8020c5:	cd 30                	int    $0x30
  8020c7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020cd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020d4:	79 30                	jns    802106 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d9:	89 c1                	mov    %eax,%ecx
  8020db:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  8020e2:	00 00 00 
  8020e5:	be 86 00 00 00       	mov    $0x86,%esi
  8020ea:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  8020f1:	00 00 00 
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  802100:	00 00 00 
  802103:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802106:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80210a:	75 46                	jne    802152 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80210c:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  802113:	00 00 00 
  802116:	ff d0                	callq  *%rax
  802118:	25 ff 03 00 00       	and    $0x3ff,%eax
  80211d:	48 63 d0             	movslq %eax,%rdx
  802120:	48 89 d0             	mov    %rdx,%rax
  802123:	48 c1 e0 03          	shl    $0x3,%rax
  802127:	48 01 d0             	add    %rdx,%rax
  80212a:	48 c1 e0 05          	shl    $0x5,%rax
  80212e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802135:	00 00 00 
  802138:	48 01 c2             	add    %rax,%rdx
  80213b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802142:	00 00 00 
  802145:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
  80214d:	e9 d1 01 00 00       	jmpq   802323 <fork+0x281>
	}
	uint64_t ad = 0;
  802152:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802159:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80215a:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80215f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802163:	e9 df 00 00 00       	jmpq   802247 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216c:	48 c1 e8 27          	shr    $0x27,%rax
  802170:	48 89 c2             	mov    %rax,%rdx
  802173:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80217a:	01 00 00 
  80217d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802181:	83 e0 01             	and    $0x1,%eax
  802184:	48 85 c0             	test   %rax,%rax
  802187:	0f 84 9e 00 00 00    	je     80222b <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80218d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802191:	48 c1 e8 1e          	shr    $0x1e,%rax
  802195:	48 89 c2             	mov    %rax,%rdx
  802198:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80219f:	01 00 00 
  8021a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a6:	83 e0 01             	and    $0x1,%eax
  8021a9:	48 85 c0             	test   %rax,%rax
  8021ac:	74 73                	je     802221 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8021ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b2:	48 c1 e8 15          	shr    $0x15,%rax
  8021b6:	48 89 c2             	mov    %rax,%rdx
  8021b9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021c0:	01 00 00 
  8021c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c7:	83 e0 01             	and    $0x1,%eax
  8021ca:	48 85 c0             	test   %rax,%rax
  8021cd:	74 48                	je     802217 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d7:	48 89 c2             	mov    %rax,%rdx
  8021da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e1:	01 00 00 
  8021e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f0:	83 e0 01             	and    $0x1,%eax
  8021f3:	48 85 c0             	test   %rax,%rax
  8021f6:	74 47                	je     80223f <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8021f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802200:	89 c2                	mov    %eax,%edx
  802202:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802205:	89 d6                	mov    %edx,%esi
  802207:	89 c7                	mov    %eax,%edi
  802209:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	eb 28                	jmp    80223f <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802217:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80221e:	00 
  80221f:	eb 1e                	jmp    80223f <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802221:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802228:	40 
  802229:	eb 14                	jmp    80223f <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80222b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222f:	48 c1 e8 27          	shr    $0x27,%rax
  802233:	48 83 c0 01          	add    $0x1,%rax
  802237:	48 c1 e0 27          	shl    $0x27,%rax
  80223b:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80223f:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802246:	00 
  802247:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80224e:	00 
  80224f:	0f 87 13 ff ff ff    	ja     802168 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802255:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802258:	ba 07 00 00 00       	mov    $0x7,%edx
  80225d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802262:	89 c7                	mov    %eax,%edi
  802264:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802270:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802273:	ba 07 00 00 00       	mov    $0x7,%edx
  802278:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80227d:	89 c7                	mov    %eax,%edi
  80227f:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  802286:	00 00 00 
  802289:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80228b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80228e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802294:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802299:	ba 00 00 00 00       	mov    $0x0,%edx
  80229e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022b1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b6:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022bb:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022c0:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022cc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d6:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8022e2:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8022e9:	00 00 00 
  8022ec:	48 8b 00             	mov    (%rax),%rax
  8022ef:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f9:	48 89 d6             	mov    %rdx,%rsi
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80230a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80230d:	be 02 00 00 00       	mov    $0x2,%esi
  802312:	89 c7                	mov    %eax,%edi
  802314:	48 b8 75 1a 80 00 00 	movabs $0x801a75,%rax
  80231b:	00 00 00 
  80231e:	ff d0                	callq  *%rax

	return envid;
  802320:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802323:	c9                   	leaveq 
  802324:	c3                   	retq   

0000000000802325 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802329:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  802330:	00 00 00 
  802333:	be bf 00 00 00       	mov    $0xbf,%esi
  802338:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80233f:	00 00 00 
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
  802347:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  80234e:	00 00 00 
  802351:	ff d1                	callq  *%rcx

0000000000802353 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802353:	55                   	push   %rbp
  802354:	48 89 e5             	mov    %rsp,%rbp
  802357:	48 83 ec 08          	sub    $0x8,%rsp
  80235b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80235f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802363:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80236a:	ff ff ff 
  80236d:	48 01 d0             	add    %rdx,%rax
  802370:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802374:	c9                   	leaveq 
  802375:	c3                   	retq   

0000000000802376 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802376:	55                   	push   %rbp
  802377:	48 89 e5             	mov    %rsp,%rbp
  80237a:	48 83 ec 08          	sub    $0x8,%rsp
  80237e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802386:	48 89 c7             	mov    %rax,%rdi
  802389:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802390:	00 00 00 
  802393:	ff d0                	callq  *%rax
  802395:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80239b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80239f:	c9                   	leaveq 
  8023a0:	c3                   	retq   

00000000008023a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
  8023a5:	48 83 ec 18          	sub    $0x18,%rsp
  8023a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023b4:	eb 6b                	jmp    802421 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b9:	48 98                	cltq   
  8023bb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023c1:	48 c1 e0 0c          	shl    $0xc,%rax
  8023c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023cd:	48 c1 e8 15          	shr    $0x15,%rax
  8023d1:	48 89 c2             	mov    %rax,%rdx
  8023d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023db:	01 00 00 
  8023de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e2:	83 e0 01             	and    $0x1,%eax
  8023e5:	48 85 c0             	test   %rax,%rax
  8023e8:	74 21                	je     80240b <fd_alloc+0x6a>
  8023ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8023f2:	48 89 c2             	mov    %rax,%rdx
  8023f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023fc:	01 00 00 
  8023ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802403:	83 e0 01             	and    $0x1,%eax
  802406:	48 85 c0             	test   %rax,%rax
  802409:	75 12                	jne    80241d <fd_alloc+0x7c>
			*fd_store = fd;
  80240b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802413:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	eb 1a                	jmp    802437 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80241d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802421:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802425:	7e 8f                	jle    8023b6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802432:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802437:	c9                   	leaveq 
  802438:	c3                   	retq   

0000000000802439 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802439:	55                   	push   %rbp
  80243a:	48 89 e5             	mov    %rsp,%rbp
  80243d:	48 83 ec 20          	sub    $0x20,%rsp
  802441:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802444:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802448:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80244c:	78 06                	js     802454 <fd_lookup+0x1b>
  80244e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802452:	7e 07                	jle    80245b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802454:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802459:	eb 6c                	jmp    8024c7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80245b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80245e:	48 98                	cltq   
  802460:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802466:	48 c1 e0 0c          	shl    $0xc,%rax
  80246a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80246e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802472:	48 c1 e8 15          	shr    $0x15,%rax
  802476:	48 89 c2             	mov    %rax,%rdx
  802479:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802480:	01 00 00 
  802483:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802487:	83 e0 01             	and    $0x1,%eax
  80248a:	48 85 c0             	test   %rax,%rax
  80248d:	74 21                	je     8024b0 <fd_lookup+0x77>
  80248f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802493:	48 c1 e8 0c          	shr    $0xc,%rax
  802497:	48 89 c2             	mov    %rax,%rdx
  80249a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a1:	01 00 00 
  8024a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a8:	83 e0 01             	and    $0x1,%eax
  8024ab:	48 85 c0             	test   %rax,%rax
  8024ae:	75 07                	jne    8024b7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b5:	eb 10                	jmp    8024c7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024bf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c7:	c9                   	leaveq 
  8024c8:	c3                   	retq   

00000000008024c9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024c9:	55                   	push   %rbp
  8024ca:	48 89 e5             	mov    %rsp,%rbp
  8024cd:	48 83 ec 30          	sub    $0x30,%rsp
  8024d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024de:	48 89 c7             	mov    %rax,%rdi
  8024e1:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	callq  *%rax
  8024ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f1:	48 89 d6             	mov    %rdx,%rsi
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802505:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802509:	78 0a                	js     802515 <fd_close+0x4c>
	    || fd != fd2)
  80250b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802513:	74 12                	je     802527 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802515:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802519:	74 05                	je     802520 <fd_close+0x57>
  80251b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251e:	eb 05                	jmp    802525 <fd_close+0x5c>
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
  802525:	eb 69                	jmp    802590 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252b:	8b 00                	mov    (%rax),%eax
  80252d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802531:	48 89 d6             	mov    %rdx,%rsi
  802534:	89 c7                	mov    %eax,%edi
  802536:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  80253d:	00 00 00 
  802540:	ff d0                	callq  *%rax
  802542:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802545:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802549:	78 2a                	js     802575 <fd_close+0xac>
		if (dev->dev_close)
  80254b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802553:	48 85 c0             	test   %rax,%rax
  802556:	74 16                	je     80256e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802560:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802564:	48 89 d7             	mov    %rdx,%rdi
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	eb 07                	jmp    802575 <fd_close+0xac>
		else
			r = 0;
  80256e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802579:	48 89 c6             	mov    %rax,%rsi
  80257c:	bf 00 00 00 00       	mov    $0x0,%edi
  802581:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
	return r;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802590:	c9                   	leaveq 
  802591:	c3                   	retq   

0000000000802592 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802592:	55                   	push   %rbp
  802593:	48 89 e5             	mov    %rsp,%rbp
  802596:	48 83 ec 20          	sub    $0x20,%rsp
  80259a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80259d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a8:	eb 41                	jmp    8025eb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025aa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025b1:	00 00 00 
  8025b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b7:	48 63 d2             	movslq %edx,%rdx
  8025ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025be:	8b 00                	mov    (%rax),%eax
  8025c0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025c3:	75 22                	jne    8025e7 <dev_lookup+0x55>
			*dev = devtab[i];
  8025c5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025cc:	00 00 00 
  8025cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025d2:	48 63 d2             	movslq %edx,%rdx
  8025d5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025dd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e5:	eb 60                	jmp    802647 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025eb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025f2:	00 00 00 
  8025f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f8:	48 63 d2             	movslq %edx,%rdx
  8025fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ff:	48 85 c0             	test   %rax,%rax
  802602:	75 a6                	jne    8025aa <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802604:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80260b:	00 00 00 
  80260e:	48 8b 00             	mov    (%rax),%rax
  802611:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802617:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80261a:	89 c6                	mov    %eax,%esi
  80261c:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  802623:	00 00 00 
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802632:	00 00 00 
  802635:	ff d1                	callq  *%rcx
	*dev = 0;
  802637:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802642:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802647:	c9                   	leaveq 
  802648:	c3                   	retq   

0000000000802649 <close>:

int
close(int fdnum)
{
  802649:	55                   	push   %rbp
  80264a:	48 89 e5             	mov    %rsp,%rbp
  80264d:	48 83 ec 20          	sub    $0x20,%rsp
  802651:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802654:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802658:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80265b:	48 89 d6             	mov    %rdx,%rsi
  80265e:	89 c7                	mov    %eax,%edi
  802660:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802667:	00 00 00 
  80266a:	ff d0                	callq  *%rax
  80266c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802673:	79 05                	jns    80267a <close+0x31>
		return r;
  802675:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802678:	eb 18                	jmp    802692 <close+0x49>
	else
		return fd_close(fd, 1);
  80267a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80267e:	be 01 00 00 00       	mov    $0x1,%esi
  802683:	48 89 c7             	mov    %rax,%rdi
  802686:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
}
  802692:	c9                   	leaveq 
  802693:	c3                   	retq   

0000000000802694 <close_all>:

void
close_all(void)
{
  802694:	55                   	push   %rbp
  802695:	48 89 e5             	mov    %rsp,%rbp
  802698:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80269c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026a3:	eb 15                	jmp    8026ba <close_all+0x26>
		close(i);
  8026a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a8:	89 c7                	mov    %eax,%edi
  8026aa:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026be:	7e e5                	jle    8026a5 <close_all+0x11>
		close(i);
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 40          	sub    $0x40,%rsp
  8026ca:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026cd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026d0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026d4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026d7:	48 89 d6             	mov    %rdx,%rsi
  8026da:	89 c7                	mov    %eax,%edi
  8026dc:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ef:	79 08                	jns    8026f9 <dup+0x37>
		return r;
  8026f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f4:	e9 70 01 00 00       	jmpq   802869 <dup+0x1a7>
	close(newfdnum);
  8026f9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026fc:	89 c7                	mov    %eax,%edi
  8026fe:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  802705:	00 00 00 
  802708:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80270a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80270d:	48 98                	cltq   
  80270f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802715:	48 c1 e0 0c          	shl    $0xc,%rax
  802719:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80271d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802721:	48 89 c7             	mov    %rax,%rdi
  802724:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  80272b:	00 00 00 
  80272e:	ff d0                	callq  *%rax
  802730:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802738:	48 89 c7             	mov    %rax,%rdi
  80273b:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
  802747:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80274b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274f:	48 c1 e8 15          	shr    $0x15,%rax
  802753:	48 89 c2             	mov    %rax,%rdx
  802756:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80275d:	01 00 00 
  802760:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802764:	83 e0 01             	and    $0x1,%eax
  802767:	48 85 c0             	test   %rax,%rax
  80276a:	74 73                	je     8027df <dup+0x11d>
  80276c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802770:	48 c1 e8 0c          	shr    $0xc,%rax
  802774:	48 89 c2             	mov    %rax,%rdx
  802777:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80277e:	01 00 00 
  802781:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802785:	83 e0 01             	and    $0x1,%eax
  802788:	48 85 c0             	test   %rax,%rax
  80278b:	74 52                	je     8027df <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80278d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802791:	48 c1 e8 0c          	shr    $0xc,%rax
  802795:	48 89 c2             	mov    %rax,%rdx
  802798:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80279f:	01 00 00 
  8027a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8027ab:	89 c1                	mov    %eax,%ecx
  8027ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b5:	41 89 c8             	mov    %ecx,%r8d
  8027b8:	48 89 d1             	mov    %rdx,%rcx
  8027bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c0:	48 89 c6             	mov    %rax,%rsi
  8027c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c8:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 02                	jns    8027df <dup+0x11d>
			goto err;
  8027dd:	eb 57                	jmp    802836 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e7:	48 89 c2             	mov    %rax,%rdx
  8027ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027f1:	01 00 00 
  8027f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f8:	25 07 0e 00 00       	and    $0xe07,%eax
  8027fd:	89 c1                	mov    %eax,%ecx
  8027ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802803:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802807:	41 89 c8             	mov    %ecx,%r8d
  80280a:	48 89 d1             	mov    %rdx,%rcx
  80280d:	ba 00 00 00 00       	mov    $0x0,%edx
  802812:	48 89 c6             	mov    %rax,%rsi
  802815:	bf 00 00 00 00       	mov    $0x0,%edi
  80281a:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
  802826:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282d:	79 02                	jns    802831 <dup+0x16f>
		goto err;
  80282f:	eb 05                	jmp    802836 <dup+0x174>

	return newfdnum;
  802831:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802834:	eb 33                	jmp    802869 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802836:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283a:	48 89 c6             	mov    %rax,%rsi
  80283d:	bf 00 00 00 00       	mov    $0x0,%edi
  802842:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80284e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802852:	48 89 c6             	mov    %rax,%rsi
  802855:	bf 00 00 00 00       	mov    $0x0,%edi
  80285a:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
	return r;
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802869:	c9                   	leaveq 
  80286a:	c3                   	retq   

000000000080286b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80286b:	55                   	push   %rbp
  80286c:	48 89 e5             	mov    %rsp,%rbp
  80286f:	48 83 ec 40          	sub    $0x40,%rsp
  802873:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802876:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80287a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80287e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802882:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802885:	48 89 d6             	mov    %rdx,%rsi
  802888:	89 c7                	mov    %eax,%edi
  80288a:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
  802896:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802899:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289d:	78 24                	js     8028c3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80289f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a3:	8b 00                	mov    (%rax),%eax
  8028a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a9:	48 89 d6             	mov    %rdx,%rsi
  8028ac:	89 c7                	mov    %eax,%edi
  8028ae:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
  8028ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c1:	79 05                	jns    8028c8 <read+0x5d>
		return r;
  8028c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c6:	eb 76                	jmp    80293e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cc:	8b 40 08             	mov    0x8(%rax),%eax
  8028cf:	83 e0 03             	and    $0x3,%eax
  8028d2:	83 f8 01             	cmp    $0x1,%eax
  8028d5:	75 3a                	jne    802911 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028d7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8028de:	00 00 00 
  8028e1:	48 8b 00             	mov    (%rax),%rax
  8028e4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028ed:	89 c6                	mov    %eax,%esi
  8028ef:	48 bf 5f 4e 80 00 00 	movabs $0x804e5f,%rdi
  8028f6:	00 00 00 
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802905:	00 00 00 
  802908:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80290a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80290f:	eb 2d                	jmp    80293e <read+0xd3>
	}
	if (!dev->dev_read)
  802911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802915:	48 8b 40 10          	mov    0x10(%rax),%rax
  802919:	48 85 c0             	test   %rax,%rax
  80291c:	75 07                	jne    802925 <read+0xba>
		return -E_NOT_SUPP;
  80291e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802923:	eb 19                	jmp    80293e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802925:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802929:	48 8b 40 10          	mov    0x10(%rax),%rax
  80292d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802931:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802935:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802939:	48 89 cf             	mov    %rcx,%rdi
  80293c:	ff d0                	callq  *%rax
}
  80293e:	c9                   	leaveq 
  80293f:	c3                   	retq   

0000000000802940 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802940:	55                   	push   %rbp
  802941:	48 89 e5             	mov    %rsp,%rbp
  802944:	48 83 ec 30          	sub    $0x30,%rsp
  802948:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80294b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80294f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80295a:	eb 49                	jmp    8029a5 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	48 98                	cltq   
  802961:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802965:	48 29 c2             	sub    %rax,%rdx
  802968:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296b:	48 63 c8             	movslq %eax,%rcx
  80296e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802972:	48 01 c1             	add    %rax,%rcx
  802975:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802978:	48 89 ce             	mov    %rcx,%rsi
  80297b:	89 c7                	mov    %eax,%edi
  80297d:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  802984:	00 00 00 
  802987:	ff d0                	callq  *%rax
  802989:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80298c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802990:	79 05                	jns    802997 <readn+0x57>
			return m;
  802992:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802995:	eb 1c                	jmp    8029b3 <readn+0x73>
		if (m == 0)
  802997:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80299b:	75 02                	jne    80299f <readn+0x5f>
			break;
  80299d:	eb 11                	jmp    8029b0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80299f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029a2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a8:	48 98                	cltq   
  8029aa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029ae:	72 ac                	jb     80295c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029b3:	c9                   	leaveq 
  8029b4:	c3                   	retq   

00000000008029b5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029b5:	55                   	push   %rbp
  8029b6:	48 89 e5             	mov    %rsp,%rbp
  8029b9:	48 83 ec 40          	sub    $0x40,%rsp
  8029bd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cf:	48 89 d6             	mov    %rdx,%rsi
  8029d2:	89 c7                	mov    %eax,%edi
  8029d4:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8029db:	00 00 00 
  8029de:	ff d0                	callq  *%rax
  8029e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e7:	78 24                	js     802a0d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ed:	8b 00                	mov    (%rax),%eax
  8029ef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f3:	48 89 d6             	mov    %rdx,%rsi
  8029f6:	89 c7                	mov    %eax,%edi
  8029f8:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  8029ff:	00 00 00 
  802a02:	ff d0                	callq  *%rax
  802a04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0b:	79 05                	jns    802a12 <write+0x5d>
		return r;
  802a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a10:	eb 75                	jmp    802a87 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a16:	8b 40 08             	mov    0x8(%rax),%eax
  802a19:	83 e0 03             	and    $0x3,%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	75 3a                	jne    802a5a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a20:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802a27:	00 00 00 
  802a2a:	48 8b 00             	mov    (%rax),%rax
  802a2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a36:	89 c6                	mov    %eax,%esi
  802a38:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
  802a3f:	00 00 00 
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
  802a47:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802a4e:	00 00 00 
  802a51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a58:	eb 2d                	jmp    802a87 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a62:	48 85 c0             	test   %rax,%rax
  802a65:	75 07                	jne    802a6e <write+0xb9>
		return -E_NOT_SUPP;
  802a67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a6c:	eb 19                	jmp    802a87 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a72:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a82:	48 89 cf             	mov    %rcx,%rdi
  802a85:	ff d0                	callq  *%rax
}
  802a87:	c9                   	leaveq 
  802a88:	c3                   	retq   

0000000000802a89 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a89:	55                   	push   %rbp
  802a8a:	48 89 e5             	mov    %rsp,%rbp
  802a8d:	48 83 ec 18          	sub    $0x18,%rsp
  802a91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a94:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a9e:	48 89 d6             	mov    %rdx,%rsi
  802aa1:	89 c7                	mov    %eax,%edi
  802aa3:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802aaa:	00 00 00 
  802aad:	ff d0                	callq  *%rax
  802aaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab6:	79 05                	jns    802abd <seek+0x34>
		return r;
  802ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abb:	eb 0f                	jmp    802acc <seek+0x43>
	fd->fd_offset = offset;
  802abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acc:	c9                   	leaveq 
  802acd:	c3                   	retq   

0000000000802ace <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ace:	55                   	push   %rbp
  802acf:	48 89 e5             	mov    %rsp,%rbp
  802ad2:	48 83 ec 30          	sub    $0x30,%rsp
  802ad6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802adc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae3:	48 89 d6             	mov    %rdx,%rsi
  802ae6:	89 c7                	mov    %eax,%edi
  802ae8:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afb:	78 24                	js     802b21 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	8b 00                	mov    (%rax),%eax
  802b03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b07:	48 89 d6             	mov    %rdx,%rsi
  802b0a:	89 c7                	mov    %eax,%edi
  802b0c:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	callq  *%rax
  802b18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1f:	79 05                	jns    802b26 <ftruncate+0x58>
		return r;
  802b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b24:	eb 72                	jmp    802b98 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2a:	8b 40 08             	mov    0x8(%rax),%eax
  802b2d:	83 e0 03             	and    $0x3,%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	75 3a                	jne    802b6e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b34:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802b3b:	00 00 00 
  802b3e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b41:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b47:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4a:	89 c6                	mov    %eax,%esi
  802b4c:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  802b53:	00 00 00 
  802b56:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5b:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  802b62:	00 00 00 
  802b65:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6c:	eb 2a                	jmp    802b98 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b72:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b76:	48 85 c0             	test   %rax,%rax
  802b79:	75 07                	jne    802b82 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b7b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b80:	eb 16                	jmp    802b98 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b86:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b91:	89 ce                	mov    %ecx,%esi
  802b93:	48 89 d7             	mov    %rdx,%rdi
  802b96:	ff d0                	callq  *%rax
}
  802b98:	c9                   	leaveq 
  802b99:	c3                   	retq   

0000000000802b9a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b9a:	55                   	push   %rbp
  802b9b:	48 89 e5             	mov    %rsp,%rbp
  802b9e:	48 83 ec 30          	sub    $0x30,%rsp
  802ba2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bb0:	48 89 d6             	mov    %rdx,%rsi
  802bb3:	89 c7                	mov    %eax,%edi
  802bb5:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc8:	78 24                	js     802bee <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bce:	8b 00                	mov    (%rax),%eax
  802bd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd4:	48 89 d6             	mov    %rdx,%rsi
  802bd7:	89 c7                	mov    %eax,%edi
  802bd9:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bec:	79 05                	jns    802bf3 <fstat+0x59>
		return r;
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	eb 5e                	jmp    802c51 <fstat+0xb7>
	if (!dev->dev_stat)
  802bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bfb:	48 85 c0             	test   %rax,%rax
  802bfe:	75 07                	jne    802c07 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c00:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c05:	eb 4a                	jmp    802c51 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c0b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c12:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c19:	00 00 00 
	stat->st_isdir = 0;
  802c1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c20:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c27:	00 00 00 
	stat->st_dev = dev;
  802c2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c32:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c45:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c49:	48 89 ce             	mov    %rcx,%rsi
  802c4c:	48 89 d7             	mov    %rdx,%rdi
  802c4f:	ff d0                	callq  *%rax
}
  802c51:	c9                   	leaveq 
  802c52:	c3                   	retq   

0000000000802c53 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c53:	55                   	push   %rbp
  802c54:	48 89 e5             	mov    %rsp,%rbp
  802c57:	48 83 ec 20          	sub    $0x20,%rsp
  802c5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c67:	be 00 00 00 00       	mov    $0x0,%esi
  802c6c:	48 89 c7             	mov    %rax,%rdi
  802c6f:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
  802c7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c82:	79 05                	jns    802c89 <stat+0x36>
		return fd;
  802c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c87:	eb 2f                	jmp    802cb8 <stat+0x65>
	r = fstat(fd, stat);
  802c89:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c90:	48 89 d6             	mov    %rdx,%rsi
  802c93:	89 c7                	mov    %eax,%edi
  802c95:	48 b8 9a 2b 80 00 00 	movabs $0x802b9a,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
  802ca1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
	return r;
  802cb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cb8:	c9                   	leaveq 
  802cb9:	c3                   	retq   

0000000000802cba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cba:	55                   	push   %rbp
  802cbb:	48 89 e5             	mov    %rsp,%rbp
  802cbe:	48 83 ec 10          	sub    $0x10,%rsp
  802cc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cc9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cd0:	00 00 00 
  802cd3:	8b 00                	mov    (%rax),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	75 1d                	jne    802cf6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802cd9:	bf 01 00 00 00       	mov    $0x1,%edi
  802cde:	48 b8 87 46 80 00 00 	movabs $0x804687,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802cf1:	00 00 00 
  802cf4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cf6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cfd:	00 00 00 
  802d00:	8b 00                	mov    (%rax),%eax
  802d02:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d05:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d0a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d11:	00 00 00 
  802d14:	89 c7                	mov    %eax,%edi
  802d16:	48 b8 25 46 80 00 00 	movabs $0x804625,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d26:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2b:	48 89 c6             	mov    %rax,%rsi
  802d2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d33:	48 b8 1f 45 80 00 00 	movabs $0x80451f,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
}
  802d3f:	c9                   	leaveq 
  802d40:	c3                   	retq   

0000000000802d41 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d41:	55                   	push   %rbp
  802d42:	48 89 e5             	mov    %rsp,%rbp
  802d45:	48 83 ec 30          	sub    $0x30,%rsp
  802d49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d4d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802d50:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802d57:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d65:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d6a:	75 08                	jne    802d74 <open+0x33>
	{
		return r;
  802d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6f:	e9 f2 00 00 00       	jmpq   802e66 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d78:	48 89 c7             	mov    %rax,%rdi
  802d7b:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d8a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d91:	7e 0a                	jle    802d9d <open+0x5c>
	{
		return -E_BAD_PATH;
  802d93:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d98:	e9 c9 00 00 00       	jmpq   802e66 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d9d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802da4:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802da5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802da9:	48 89 c7             	mov    %rax,%rdi
  802dac:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
  802db8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbf:	78 09                	js     802dca <open+0x89>
  802dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc5:	48 85 c0             	test   %rax,%rax
  802dc8:	75 08                	jne    802dd2 <open+0x91>
		{
			return r;
  802dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcd:	e9 94 00 00 00       	jmpq   802e66 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802dd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd6:	ba 00 04 00 00       	mov    $0x400,%edx
  802ddb:	48 89 c6             	mov    %rax,%rsi
  802dde:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802de5:	00 00 00 
  802de8:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802df4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dfb:	00 00 00 
  802dfe:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802e01:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0b:	48 89 c6             	mov    %rax,%rsi
  802e0e:	bf 01 00 00 00       	mov    $0x1,%edi
  802e13:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
  802e1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e26:	79 2b                	jns    802e53 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2c:	be 00 00 00 00       	mov    $0x0,%esi
  802e31:	48 89 c7             	mov    %rax,%rdi
  802e34:	48 b8 c9 24 80 00 00 	movabs $0x8024c9,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802e43:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e47:	79 05                	jns    802e4e <open+0x10d>
			{
				return d;
  802e49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e4c:	eb 18                	jmp    802e66 <open+0x125>
			}
			return r;
  802e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e51:	eb 13                	jmp    802e66 <open+0x125>
		}	
		return fd2num(fd_store);
  802e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e57:	48 89 c7             	mov    %rax,%rdi
  802e5a:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e66:	c9                   	leaveq 
  802e67:	c3                   	retq   

0000000000802e68 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e68:	55                   	push   %rbp
  802e69:	48 89 e5             	mov    %rsp,%rbp
  802e6c:	48 83 ec 10          	sub    $0x10,%rsp
  802e70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e78:	8b 50 0c             	mov    0xc(%rax),%edx
  802e7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e82:	00 00 00 
  802e85:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e87:	be 00 00 00 00       	mov    $0x0,%esi
  802e8c:	bf 06 00 00 00       	mov    $0x6,%edi
  802e91:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
}
  802e9d:	c9                   	leaveq 
  802e9e:	c3                   	retq   

0000000000802e9f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e9f:	55                   	push   %rbp
  802ea0:	48 89 e5             	mov    %rsp,%rbp
  802ea3:	48 83 ec 30          	sub    $0x30,%rsp
  802ea7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eaf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802eb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802eba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ebf:	74 07                	je     802ec8 <devfile_read+0x29>
  802ec1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ec6:	75 07                	jne    802ecf <devfile_read+0x30>
		return -E_INVAL;
  802ec8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ecd:	eb 77                	jmp    802f46 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802edd:	00 00 00 
  802ee0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ee2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee9:	00 00 00 
  802eec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ef0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ef4:	be 00 00 00 00       	mov    $0x0,%esi
  802ef9:	bf 03 00 00 00       	mov    $0x3,%edi
  802efe:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
  802f0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f11:	7f 05                	jg     802f18 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f16:	eb 2e                	jmp    802f46 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1b:	48 63 d0             	movslq %eax,%rdx
  802f1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f22:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f29:	00 00 00 
  802f2c:	48 89 c7             	mov    %rax,%rdi
  802f2f:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802f3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 30          	sub    $0x30,%rsp
  802f50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802f5c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802f63:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f68:	74 07                	je     802f71 <devfile_write+0x29>
  802f6a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f6f:	75 08                	jne    802f79 <devfile_write+0x31>
		return r;
  802f71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f74:	e9 9a 00 00 00       	jmpq   803013 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f87:	00 00 00 
  802f8a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f8c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f93:	00 
  802f94:	76 08                	jbe    802f9e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f96:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f9d:	00 
	}
	fsipcbuf.write.req_n = n;
  802f9e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa5:	00 00 00 
  802fa8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fac:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802fb0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb8:	48 89 c6             	mov    %rax,%rsi
  802fbb:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fc2:	00 00 00 
  802fc5:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802fd1:	be 00 00 00 00       	mov    $0x0,%esi
  802fd6:	bf 04 00 00 00       	mov    $0x4,%edi
  802fdb:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fee:	7f 20                	jg     803010 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802ff0:	48 bf be 4e 80 00 00 	movabs $0x804ebe,%rdi
  802ff7:	00 00 00 
  802ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  802fff:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803006:	00 00 00 
  803009:	ff d2                	callq  *%rdx
		return r;
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	eb 03                	jmp    803013 <devfile_write+0xcb>
	}
	return r;
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 20          	sub    $0x20,%rsp
  80301d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803029:	8b 50 0c             	mov    0xc(%rax),%edx
  80302c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803033:	00 00 00 
  803036:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803038:	be 00 00 00 00       	mov    $0x0,%esi
  80303d:	bf 05 00 00 00       	mov    $0x5,%edi
  803042:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
  80304e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803051:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803055:	79 05                	jns    80305c <devfile_stat+0x47>
		return r;
  803057:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305a:	eb 56                	jmp    8030b2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80305c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803060:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803067:	00 00 00 
  80306a:	48 89 c7             	mov    %rax,%rdi
  80306d:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803074:	00 00 00 
  803077:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803079:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803080:	00 00 00 
  803083:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803089:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803093:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80309a:	00 00 00 
  80309d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b2:	c9                   	leaveq 
  8030b3:	c3                   	retq   

00000000008030b4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030b4:	55                   	push   %rbp
  8030b5:	48 89 e5             	mov    %rsp,%rbp
  8030b8:	48 83 ec 10          	sub    $0x10,%rsp
  8030bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c7:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030d1:	00 00 00 
  8030d4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030dd:	00 00 00 
  8030e0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030e6:	be 00 00 00 00       	mov    $0x0,%esi
  8030eb:	bf 02 00 00 00       	mov    $0x2,%edi
  8030f0:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
}
  8030fc:	c9                   	leaveq 
  8030fd:	c3                   	retq   

00000000008030fe <remove>:

// Delete a file
int
remove(const char *path)
{
  8030fe:	55                   	push   %rbp
  8030ff:	48 89 e5             	mov    %rsp,%rbp
  803102:	48 83 ec 10          	sub    $0x10,%rsp
  803106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80310a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310e:	48 89 c7             	mov    %rax,%rdi
  803111:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax
  80311d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803122:	7e 07                	jle    80312b <remove+0x2d>
		return -E_BAD_PATH;
  803124:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803129:	eb 33                	jmp    80315e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80312b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312f:	48 89 c6             	mov    %rax,%rsi
  803132:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803139:	00 00 00 
  80313c:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803148:	be 00 00 00 00       	mov    $0x0,%esi
  80314d:	bf 07 00 00 00       	mov    $0x7,%edi
  803152:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
}
  80315e:	c9                   	leaveq 
  80315f:	c3                   	retq   

0000000000803160 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803164:	be 00 00 00 00       	mov    $0x0,%esi
  803169:	bf 08 00 00 00       	mov    $0x8,%edi
  80316e:	48 b8 ba 2c 80 00 00 	movabs $0x802cba,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
}
  80317a:	5d                   	pop    %rbp
  80317b:	c3                   	retq   

000000000080317c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80317c:	55                   	push   %rbp
  80317d:	48 89 e5             	mov    %rsp,%rbp
  803180:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803187:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80318e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803195:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80319c:	be 00 00 00 00       	mov    $0x0,%esi
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
  8031b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b7:	79 28                	jns    8031e1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031bc:	89 c6                	mov    %eax,%esi
  8031be:	48 bf da 4e 80 00 00 	movabs $0x804eda,%rdi
  8031c5:	00 00 00 
  8031c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cd:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  8031d4:	00 00 00 
  8031d7:	ff d2                	callq  *%rdx
		return fd_src;
  8031d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031dc:	e9 74 01 00 00       	jmpq   803355 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8031e1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8031e8:	be 01 01 00 00       	mov    $0x101,%esi
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 41 2d 80 00 00 	movabs $0x802d41,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803203:	79 39                	jns    80323e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803205:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803208:	89 c6                	mov    %eax,%esi
  80320a:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  803211:	00 00 00 
  803214:	b8 00 00 00 00       	mov    $0x0,%eax
  803219:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803220:	00 00 00 
  803223:	ff d2                	callq  *%rdx
		close(fd_src);
  803225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803228:	89 c7                	mov    %eax,%edi
  80322a:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803231:	00 00 00 
  803234:	ff d0                	callq  *%rax
		return fd_dest;
  803236:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803239:	e9 17 01 00 00       	jmpq   803355 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80323e:	eb 74                	jmp    8032b4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803240:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803243:	48 63 d0             	movslq %eax,%rdx
  803246:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80324d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803250:	48 89 ce             	mov    %rcx,%rsi
  803253:	89 c7                	mov    %eax,%edi
  803255:	48 b8 b5 29 80 00 00 	movabs $0x8029b5,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803264:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803268:	79 4a                	jns    8032b4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80326a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80326d:	89 c6                	mov    %eax,%esi
  80326f:	48 bf 0a 4f 80 00 00 	movabs $0x804f0a,%rdi
  803276:	00 00 00 
  803279:	b8 00 00 00 00       	mov    $0x0,%eax
  80327e:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803285:	00 00 00 
  803288:	ff d2                	callq  *%rdx
			close(fd_src);
  80328a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328d:	89 c7                	mov    %eax,%edi
  80328f:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
			close(fd_dest);
  80329b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80329e:	89 c7                	mov    %eax,%edi
  8032a0:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
			return write_size;
  8032ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032af:	e9 a1 00 00 00       	jmpq   803355 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032b4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032be:	ba 00 02 00 00       	mov    $0x200,%edx
  8032c3:	48 89 ce             	mov    %rcx,%rsi
  8032c6:	89 c7                	mov    %eax,%edi
  8032c8:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
  8032d4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032db:	0f 8f 5f ff ff ff    	jg     803240 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8032e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032e5:	79 47                	jns    80332e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8032e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032ea:	89 c6                	mov    %eax,%esi
  8032ec:	48 bf 1d 4f 80 00 00 	movabs $0x804f1d,%rdi
  8032f3:	00 00 00 
  8032f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fb:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  803302:	00 00 00 
  803305:	ff d2                	callq  *%rdx
		close(fd_src);
  803307:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330a:	89 c7                	mov    %eax,%edi
  80330c:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
		close(fd_dest);
  803318:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80331b:	89 c7                	mov    %eax,%edi
  80331d:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
		return read_size;
  803329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80332c:	eb 27                	jmp    803355 <copy+0x1d9>
	}
	close(fd_src);
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	89 c7                	mov    %eax,%edi
  803333:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
	close(fd_dest);
  80333f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803342:	89 c7                	mov    %eax,%edi
  803344:	48 b8 49 26 80 00 00 	movabs $0x802649,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
	return 0;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803355:	c9                   	leaveq 
  803356:	c3                   	retq   

0000000000803357 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 20          	sub    $0x20,%rsp
  80335f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803362:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803366:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803369:	48 89 d6             	mov    %rdx,%rsi
  80336c:	89 c7                	mov    %eax,%edi
  80336e:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803381:	79 05                	jns    803388 <fd2sockid+0x31>
		return r;
  803383:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803386:	eb 24                	jmp    8033ac <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338c:	8b 10                	mov    (%rax),%edx
  80338e:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803395:	00 00 00 
  803398:	8b 00                	mov    (%rax),%eax
  80339a:	39 c2                	cmp    %eax,%edx
  80339c:	74 07                	je     8033a5 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80339e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033a3:	eb 07                	jmp    8033ac <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8033a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a9:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8033ac:	c9                   	leaveq 
  8033ad:	c3                   	retq   

00000000008033ae <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8033ae:	55                   	push   %rbp
  8033af:	48 89 e5             	mov    %rsp,%rbp
  8033b2:	48 83 ec 20          	sub    $0x20,%rsp
  8033b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8033b9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033bd:	48 89 c7             	mov    %rax,%rdi
  8033c0:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
  8033cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d3:	78 26                	js     8033fb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8033de:	48 89 c6             	mov    %rax,%rsi
  8033e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e6:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
  8033f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f9:	79 16                	jns    803411 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8033fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 bb 38 80 00 00 	movabs $0x8038bb,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
		return r;
  80340c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340f:	eb 3a                	jmp    80344b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803415:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80341c:	00 00 00 
  80341f:	8b 12                	mov    (%rdx),%edx
  803421:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803427:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80342e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803432:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803435:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343c:	48 89 c7             	mov    %rax,%rdi
  80343f:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  803446:	00 00 00 
  803449:	ff d0                	callq  *%rax
}
  80344b:	c9                   	leaveq 
  80344c:	c3                   	retq   

000000000080344d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	48 83 ec 30          	sub    $0x30,%rsp
  803455:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803458:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80345c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803460:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803478:	79 05                	jns    80347f <accept+0x32>
		return r;
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	eb 3b                	jmp    8034ba <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80347f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803483:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348a:	48 89 ce             	mov    %rcx,%rsi
  80348d:	89 c7                	mov    %eax,%edi
  80348f:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  803496:	00 00 00 
  803499:	ff d0                	callq  *%rax
  80349b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a2:	79 05                	jns    8034a9 <accept+0x5c>
		return r;
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	eb 11                	jmp    8034ba <accept+0x6d>
	return alloc_sockfd(r);
  8034a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ac:	89 c7                	mov    %eax,%edi
  8034ae:	48 b8 ae 33 80 00 00 	movabs $0x8033ae,%rax
  8034b5:	00 00 00 
  8034b8:	ff d0                	callq  *%rax
}
  8034ba:	c9                   	leaveq 
  8034bb:	c3                   	retq   

00000000008034bc <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034bc:	55                   	push   %rbp
  8034bd:	48 89 e5             	mov    %rsp,%rbp
  8034c0:	48 83 ec 20          	sub    $0x20,%rsp
  8034c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034cb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d1:	89 c7                	mov    %eax,%edi
  8034d3:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e6:	79 05                	jns    8034ed <bind+0x31>
		return r;
  8034e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034eb:	eb 1b                	jmp    803508 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034ed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f7:	48 89 ce             	mov    %rcx,%rsi
  8034fa:	89 c7                	mov    %eax,%edi
  8034fc:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
}
  803508:	c9                   	leaveq 
  803509:	c3                   	retq   

000000000080350a <shutdown>:

int
shutdown(int s, int how)
{
  80350a:	55                   	push   %rbp
  80350b:	48 89 e5             	mov    %rsp,%rbp
  80350e:	48 83 ec 20          	sub    $0x20,%rsp
  803512:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803515:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803518:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351b:	89 c7                	mov    %eax,%edi
  80351d:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
  803529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803530:	79 05                	jns    803537 <shutdown+0x2d>
		return r;
  803532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803535:	eb 16                	jmp    80354d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803537:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80353a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353d:	89 d6                	mov    %edx,%esi
  80353f:	89 c7                	mov    %eax,%edi
  803541:	48 b8 7b 38 80 00 00 	movabs $0x80387b,%rax
  803548:	00 00 00 
  80354b:	ff d0                	callq  *%rax
}
  80354d:	c9                   	leaveq 
  80354e:	c3                   	retq   

000000000080354f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80354f:	55                   	push   %rbp
  803550:	48 89 e5             	mov    %rsp,%rbp
  803553:	48 83 ec 10          	sub    $0x10,%rsp
  803557:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80355b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355f:	48 89 c7             	mov    %rax,%rdi
  803562:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
  80356e:	83 f8 01             	cmp    $0x1,%eax
  803571:	75 17                	jne    80358a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803577:	8b 40 0c             	mov    0xc(%rax),%eax
  80357a:	89 c7                	mov    %eax,%edi
  80357c:	48 b8 bb 38 80 00 00 	movabs $0x8038bb,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	eb 05                	jmp    80358f <devsock_close+0x40>
	else
		return 0;
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80358f:	c9                   	leaveq 
  803590:	c3                   	retq   

0000000000803591 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803591:	55                   	push   %rbp
  803592:	48 89 e5             	mov    %rsp,%rbp
  803595:	48 83 ec 20          	sub    $0x20,%rsp
  803599:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035a0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a6:	89 c7                	mov    %eax,%edi
  8035a8:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8035af:	00 00 00 
  8035b2:	ff d0                	callq  *%rax
  8035b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035bb:	79 05                	jns    8035c2 <connect+0x31>
		return r;
  8035bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c0:	eb 1b                	jmp    8035dd <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8035c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cc:	48 89 ce             	mov    %rcx,%rsi
  8035cf:	89 c7                	mov    %eax,%edi
  8035d1:	48 b8 e8 38 80 00 00 	movabs $0x8038e8,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
}
  8035dd:	c9                   	leaveq 
  8035de:	c3                   	retq   

00000000008035df <listen>:

int
listen(int s, int backlog)
{
  8035df:	55                   	push   %rbp
  8035e0:	48 89 e5             	mov    %rsp,%rbp
  8035e3:	48 83 ec 20          	sub    $0x20,%rsp
  8035e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035ea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035f0:	89 c7                	mov    %eax,%edi
  8035f2:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803605:	79 05                	jns    80360c <listen+0x2d>
		return r;
  803607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360a:	eb 16                	jmp    803622 <listen+0x43>
	return nsipc_listen(r, backlog);
  80360c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80360f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803612:	89 d6                	mov    %edx,%esi
  803614:	89 c7                	mov    %eax,%edi
  803616:	48 b8 4c 39 80 00 00 	movabs $0x80394c,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
}
  803622:	c9                   	leaveq 
  803623:	c3                   	retq   

0000000000803624 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803624:	55                   	push   %rbp
  803625:	48 89 e5             	mov    %rsp,%rbp
  803628:	48 83 ec 20          	sub    $0x20,%rsp
  80362c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803630:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803634:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363c:	89 c2                	mov    %eax,%edx
  80363e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803642:	8b 40 0c             	mov    0xc(%rax),%eax
  803645:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80364e:	89 c7                	mov    %eax,%edi
  803650:	48 b8 8c 39 80 00 00 	movabs $0x80398c,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
}
  80365c:	c9                   	leaveq 
  80365d:	c3                   	retq   

000000000080365e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80365e:	55                   	push   %rbp
  80365f:	48 89 e5             	mov    %rsp,%rbp
  803662:	48 83 ec 20          	sub    $0x20,%rsp
  803666:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80366a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80366e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803676:	89 c2                	mov    %eax,%edx
  803678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367c:	8b 40 0c             	mov    0xc(%rax),%eax
  80367f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803683:	b9 00 00 00 00       	mov    $0x0,%ecx
  803688:	89 c7                	mov    %eax,%edi
  80368a:	48 b8 58 3a 80 00 00 	movabs $0x803a58,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
}
  803696:	c9                   	leaveq 
  803697:	c3                   	retq   

0000000000803698 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803698:	55                   	push   %rbp
  803699:	48 89 e5             	mov    %rsp,%rbp
  80369c:	48 83 ec 10          	sub    $0x10,%rsp
  8036a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8036a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ac:	48 be 38 4f 80 00 00 	movabs $0x804f38,%rsi
  8036b3:	00 00 00 
  8036b6:	48 89 c7             	mov    %rax,%rdi
  8036b9:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
	return 0;
  8036c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036ca:	c9                   	leaveq 
  8036cb:	c3                   	retq   

00000000008036cc <socket>:

int
socket(int domain, int type, int protocol)
{
  8036cc:	55                   	push   %rbp
  8036cd:	48 89 e5             	mov    %rsp,%rbp
  8036d0:	48 83 ec 20          	sub    $0x20,%rsp
  8036d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036da:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036e0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e6:	89 ce                	mov    %ecx,%esi
  8036e8:	89 c7                	mov    %eax,%edi
  8036ea:	48 b8 10 3b 80 00 00 	movabs $0x803b10,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
  8036f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fd:	79 05                	jns    803704 <socket+0x38>
		return r;
  8036ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803702:	eb 11                	jmp    803715 <socket+0x49>
	return alloc_sockfd(r);
  803704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803707:	89 c7                	mov    %eax,%edi
  803709:	48 b8 ae 33 80 00 00 	movabs $0x8033ae,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 10          	sub    $0x10,%rsp
  80371f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803722:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803729:	00 00 00 
  80372c:	8b 00                	mov    (%rax),%eax
  80372e:	85 c0                	test   %eax,%eax
  803730:	75 1d                	jne    80374f <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803732:	bf 02 00 00 00       	mov    $0x2,%edi
  803737:	48 b8 87 46 80 00 00 	movabs $0x804687,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
  803743:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80374a:	00 00 00 
  80374d:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80374f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803756:	00 00 00 
  803759:	8b 00                	mov    (%rax),%eax
  80375b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80375e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803763:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80376a:	00 00 00 
  80376d:	89 c7                	mov    %eax,%edi
  80376f:	48 b8 25 46 80 00 00 	movabs $0x804625,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80377b:	ba 00 00 00 00       	mov    $0x0,%edx
  803780:	be 00 00 00 00       	mov    $0x0,%esi
  803785:	bf 00 00 00 00       	mov    $0x0,%edi
  80378a:	48 b8 1f 45 80 00 00 	movabs $0x80451f,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 30          	sub    $0x30,%rsp
  8037a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8037ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b2:	00 00 00 
  8037b5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037b8:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8037bf:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8037c6:	00 00 00 
  8037c9:	ff d0                	callq  *%rax
  8037cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d2:	78 3e                	js     803812 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037db:	00 00 00 
  8037de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e6:	8b 40 10             	mov    0x10(%rax),%eax
  8037e9:	89 c2                	mov    %eax,%edx
  8037eb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8037ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037f3:	48 89 ce             	mov    %rcx,%rsi
  8037f6:	48 89 c7             	mov    %rax,%rdi
  8037f9:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803809:	8b 50 10             	mov    0x10(%rax),%edx
  80380c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803810:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803812:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803815:	c9                   	leaveq 
  803816:	c3                   	retq   

0000000000803817 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803817:	55                   	push   %rbp
  803818:	48 89 e5             	mov    %rsp,%rbp
  80381b:	48 83 ec 10          	sub    $0x10,%rsp
  80381f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803826:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803829:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803830:	00 00 00 
  803833:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803836:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803838:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80383b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383f:	48 89 c6             	mov    %rax,%rsi
  803842:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803849:	00 00 00 
  80384c:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803858:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80385f:	00 00 00 
  803862:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803865:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803868:	bf 02 00 00 00       	mov    $0x2,%edi
  80386d:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
}
  803879:	c9                   	leaveq 
  80387a:	c3                   	retq   

000000000080387b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80387b:	55                   	push   %rbp
  80387c:	48 89 e5             	mov    %rsp,%rbp
  80387f:	48 83 ec 10          	sub    $0x10,%rsp
  803883:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803886:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803889:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803890:	00 00 00 
  803893:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803896:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803898:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80389f:	00 00 00 
  8038a2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038a5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8038a8:	bf 03 00 00 00       	mov    $0x3,%edi
  8038ad:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
}
  8038b9:	c9                   	leaveq 
  8038ba:	c3                   	retq   

00000000008038bb <nsipc_close>:

int
nsipc_close(int s)
{
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
  8038bf:	48 83 ec 10          	sub    $0x10,%rsp
  8038c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8038c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038cd:	00 00 00 
  8038d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038d3:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038d5:	bf 04 00 00 00       	mov    $0x4,%edi
  8038da:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
}
  8038e6:	c9                   	leaveq 
  8038e7:	c3                   	retq   

00000000008038e8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038e8:	55                   	push   %rbp
  8038e9:	48 89 e5             	mov    %rsp,%rbp
  8038ec:	48 83 ec 10          	sub    $0x10,%rsp
  8038f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8038fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803901:	00 00 00 
  803904:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803907:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803909:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80390c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803910:	48 89 c6             	mov    %rax,%rsi
  803913:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80391a:	00 00 00 
  80391d:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803929:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803930:	00 00 00 
  803933:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803936:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803939:	bf 05 00 00 00       	mov    $0x5,%edi
  80393e:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  803945:	00 00 00 
  803948:	ff d0                	callq  *%rax
}
  80394a:	c9                   	leaveq 
  80394b:	c3                   	retq   

000000000080394c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80394c:	55                   	push   %rbp
  80394d:	48 89 e5             	mov    %rsp,%rbp
  803950:	48 83 ec 10          	sub    $0x10,%rsp
  803954:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803957:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80395a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803961:	00 00 00 
  803964:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803967:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803969:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803970:	00 00 00 
  803973:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803976:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803979:	bf 06 00 00 00       	mov    $0x6,%edi
  80397e:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  803985:	00 00 00 
  803988:	ff d0                	callq  *%rax
}
  80398a:	c9                   	leaveq 
  80398b:	c3                   	retq   

000000000080398c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80398c:	55                   	push   %rbp
  80398d:	48 89 e5             	mov    %rsp,%rbp
  803990:	48 83 ec 30          	sub    $0x30,%rsp
  803994:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80399b:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80399e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8039a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a8:	00 00 00 
  8039ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039ae:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8039b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b7:	00 00 00 
  8039ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039bd:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8039c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c7:	00 00 00 
  8039ca:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039cd:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039d0:	bf 07 00 00 00       	mov    $0x7,%edi
  8039d5:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  8039dc:	00 00 00 
  8039df:	ff d0                	callq  *%rax
  8039e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e8:	78 69                	js     803a53 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039ea:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8039f1:	7f 08                	jg     8039fb <nsipc_recv+0x6f>
  8039f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f6:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8039f9:	7e 35                	jle    803a30 <nsipc_recv+0xa4>
  8039fb:	48 b9 3f 4f 80 00 00 	movabs $0x804f3f,%rcx
  803a02:	00 00 00 
  803a05:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803a0c:	00 00 00 
  803a0f:	be 61 00 00 00       	mov    $0x61,%esi
  803a14:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803a1b:	00 00 00 
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a23:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  803a2a:	00 00 00 
  803a2d:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a33:	48 63 d0             	movslq %eax,%rdx
  803a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a41:	00 00 00 
  803a44:	48 89 c7             	mov    %rax,%rdi
  803a47:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
	}

	return r;
  803a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a56:	c9                   	leaveq 
  803a57:	c3                   	retq   

0000000000803a58 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a58:	55                   	push   %rbp
  803a59:	48 89 e5             	mov    %rsp,%rbp
  803a5c:	48 83 ec 20          	sub    $0x20,%rsp
  803a60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a67:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a6a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a6d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a74:	00 00 00 
  803a77:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7a:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a7c:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a83:	7e 35                	jle    803aba <nsipc_send+0x62>
  803a85:	48 b9 75 4f 80 00 00 	movabs $0x804f75,%rcx
  803a8c:	00 00 00 
  803a8f:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803a96:	00 00 00 
  803a99:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a9e:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803aa5:	00 00 00 
  803aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  803aad:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  803ab4:	00 00 00 
  803ab7:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803aba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abd:	48 63 d0             	movslq %eax,%rdx
  803ac0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac4:	48 89 c6             	mov    %rax,%rsi
  803ac7:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803ace:	00 00 00 
  803ad1:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803add:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ae4:	00 00 00 
  803ae7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aea:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803aed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af4:	00 00 00 
  803af7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803afa:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803afd:	bf 08 00 00 00       	mov    $0x8,%edi
  803b02:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
}
  803b0e:	c9                   	leaveq 
  803b0f:	c3                   	retq   

0000000000803b10 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b10:	55                   	push   %rbp
  803b11:	48 89 e5             	mov    %rsp,%rbp
  803b14:	48 83 ec 10          	sub    $0x10,%rsp
  803b18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b1b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b1e:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b28:	00 00 00 
  803b2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b30:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b37:	00 00 00 
  803b3a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b3d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b40:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b47:	00 00 00 
  803b4a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b4d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b50:	bf 09 00 00 00       	mov    $0x9,%edi
  803b55:	48 b8 17 37 80 00 00 	movabs $0x803717,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
}
  803b61:	c9                   	leaveq 
  803b62:	c3                   	retq   

0000000000803b63 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b63:	55                   	push   %rbp
  803b64:	48 89 e5             	mov    %rsp,%rbp
  803b67:	53                   	push   %rbx
  803b68:	48 83 ec 38          	sub    $0x38,%rsp
  803b6c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b70:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b74:	48 89 c7             	mov    %rax,%rdi
  803b77:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  803b7e:	00 00 00 
  803b81:	ff d0                	callq  *%rax
  803b83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b8a:	0f 88 bf 01 00 00    	js     803d4f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b94:	ba 07 04 00 00       	mov    $0x407,%edx
  803b99:	48 89 c6             	mov    %rax,%rsi
  803b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba1:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bb4:	0f 88 95 01 00 00    	js     803d4f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803bba:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bbe:	48 89 c7             	mov    %rax,%rdi
  803bc1:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  803bc8:	00 00 00 
  803bcb:	ff d0                	callq  *%rax
  803bcd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bd4:	0f 88 5d 01 00 00    	js     803d37 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bde:	ba 07 04 00 00       	mov    $0x407,%edx
  803be3:	48 89 c6             	mov    %rax,%rsi
  803be6:	bf 00 00 00 00       	mov    $0x0,%edi
  803beb:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803bf2:	00 00 00 
  803bf5:	ff d0                	callq  *%rax
  803bf7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bfe:	0f 88 33 01 00 00    	js     803d37 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c08:	48 89 c7             	mov    %rax,%rdi
  803c0b:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
  803c17:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c1f:	ba 07 04 00 00       	mov    $0x407,%edx
  803c24:	48 89 c6             	mov    %rax,%rsi
  803c27:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2c:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
  803c38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c3f:	79 05                	jns    803c46 <pipe+0xe3>
		goto err2;
  803c41:	e9 d9 00 00 00       	jmpq   803d1f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4a:	48 89 c7             	mov    %rax,%rdi
  803c4d:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	48 89 c2             	mov    %rax,%rdx
  803c5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c60:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c66:	48 89 d1             	mov    %rdx,%rcx
  803c69:	ba 00 00 00 00       	mov    $0x0,%edx
  803c6e:	48 89 c6             	mov    %rax,%rsi
  803c71:	bf 00 00 00 00       	mov    $0x0,%edi
  803c76:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803c7d:	00 00 00 
  803c80:	ff d0                	callq  *%rax
  803c82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c89:	79 1b                	jns    803ca6 <pipe+0x143>
		goto err3;
  803c8b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c90:	48 89 c6             	mov    %rax,%rsi
  803c93:	bf 00 00 00 00       	mov    $0x0,%edi
  803c98:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	eb 79                	jmp    803d1f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ca6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803caa:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cb1:	00 00 00 
  803cb4:	8b 12                	mov    (%rdx),%edx
  803cb6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803cb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803cc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cce:	00 00 00 
  803cd1:	8b 12                	mov    (%rdx),%edx
  803cd3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803cd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ce0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce4:	48 89 c7             	mov    %rax,%rdi
  803ce7:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  803cee:	00 00 00 
  803cf1:	ff d0                	callq  *%rax
  803cf3:	89 c2                	mov    %eax,%edx
  803cf5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cf9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cfb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cff:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d07:	48 89 c7             	mov    %rax,%rdi
  803d0a:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d18:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1d:	eb 33                	jmp    803d52 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d23:	48 89 c6             	mov    %rax,%rsi
  803d26:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2b:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803d32:	00 00 00 
  803d35:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3b:	48 89 c6             	mov    %rax,%rsi
  803d3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d43:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
err:
	return r;
  803d4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d52:	48 83 c4 38          	add    $0x38,%rsp
  803d56:	5b                   	pop    %rbx
  803d57:	5d                   	pop    %rbp
  803d58:	c3                   	retq   

0000000000803d59 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d59:	55                   	push   %rbp
  803d5a:	48 89 e5             	mov    %rsp,%rbp
  803d5d:	53                   	push   %rbx
  803d5e:	48 83 ec 28          	sub    $0x28,%rsp
  803d62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d6a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803d71:	00 00 00 
  803d74:	48 8b 00             	mov    (%rax),%rax
  803d77:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d84:	48 89 c7             	mov    %rax,%rdi
  803d87:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  803d8e:	00 00 00 
  803d91:	ff d0                	callq  *%rax
  803d93:	89 c3                	mov    %eax,%ebx
  803d95:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d99:	48 89 c7             	mov    %rax,%rdi
  803d9c:	48 b8 09 47 80 00 00 	movabs $0x804709,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	callq  *%rax
  803da8:	39 c3                	cmp    %eax,%ebx
  803daa:	0f 94 c0             	sete   %al
  803dad:	0f b6 c0             	movzbl %al,%eax
  803db0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803db3:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803dba:	00 00 00 
  803dbd:	48 8b 00             	mov    (%rax),%rax
  803dc0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803dc6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dcc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803dcf:	75 05                	jne    803dd6 <_pipeisclosed+0x7d>
			return ret;
  803dd1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803dd4:	eb 4f                	jmp    803e25 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803dd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ddc:	74 42                	je     803e20 <_pipeisclosed+0xc7>
  803dde:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803de2:	75 3c                	jne    803e20 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803de4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803deb:	00 00 00 
  803dee:	48 8b 00             	mov    (%rax),%rax
  803df1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803df7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803dfa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dfd:	89 c6                	mov    %eax,%esi
  803dff:	48 bf 86 4f 80 00 00 	movabs $0x804f86,%rdi
  803e06:	00 00 00 
  803e09:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0e:	49 b8 9c 04 80 00 00 	movabs $0x80049c,%r8
  803e15:	00 00 00 
  803e18:	41 ff d0             	callq  *%r8
	}
  803e1b:	e9 4a ff ff ff       	jmpq   803d6a <_pipeisclosed+0x11>
  803e20:	e9 45 ff ff ff       	jmpq   803d6a <_pipeisclosed+0x11>
}
  803e25:	48 83 c4 28          	add    $0x28,%rsp
  803e29:	5b                   	pop    %rbx
  803e2a:	5d                   	pop    %rbp
  803e2b:	c3                   	retq   

0000000000803e2c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e2c:	55                   	push   %rbp
  803e2d:	48 89 e5             	mov    %rsp,%rbp
  803e30:	48 83 ec 30          	sub    $0x30,%rsp
  803e34:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e37:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e3b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e3e:	48 89 d6             	mov    %rdx,%rsi
  803e41:	89 c7                	mov    %eax,%edi
  803e43:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  803e4a:	00 00 00 
  803e4d:	ff d0                	callq  *%rax
  803e4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e56:	79 05                	jns    803e5d <pipeisclosed+0x31>
		return r;
  803e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5b:	eb 31                	jmp    803e8e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e61:	48 89 c7             	mov    %rax,%rdi
  803e64:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  803e6b:	00 00 00 
  803e6e:	ff d0                	callq  *%rax
  803e70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e7c:	48 89 d6             	mov    %rdx,%rsi
  803e7f:	48 89 c7             	mov    %rax,%rdi
  803e82:	48 b8 59 3d 80 00 00 	movabs $0x803d59,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
}
  803e8e:	c9                   	leaveq 
  803e8f:	c3                   	retq   

0000000000803e90 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e90:	55                   	push   %rbp
  803e91:	48 89 e5             	mov    %rsp,%rbp
  803e94:	48 83 ec 40          	sub    $0x40,%rsp
  803e98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ea0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea8:	48 89 c7             	mov    %rax,%rdi
  803eab:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
  803eb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ebb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ec3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803eca:	00 
  803ecb:	e9 92 00 00 00       	jmpq   803f62 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ed0:	eb 41                	jmp    803f13 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ed2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ed7:	74 09                	je     803ee2 <devpipe_read+0x52>
				return i;
  803ed9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803edd:	e9 92 00 00 00       	jmpq   803f74 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ee2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ee6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eea:	48 89 d6             	mov    %rdx,%rsi
  803eed:	48 89 c7             	mov    %rax,%rdi
  803ef0:	48 b8 59 3d 80 00 00 	movabs $0x803d59,%rax
  803ef7:	00 00 00 
  803efa:	ff d0                	callq  *%rax
  803efc:	85 c0                	test   %eax,%eax
  803efe:	74 07                	je     803f07 <devpipe_read+0x77>
				return 0;
  803f00:	b8 00 00 00 00       	mov    $0x0,%eax
  803f05:	eb 6d                	jmp    803f74 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f07:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803f0e:	00 00 00 
  803f11:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f17:	8b 10                	mov    (%rax),%edx
  803f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1d:	8b 40 04             	mov    0x4(%rax),%eax
  803f20:	39 c2                	cmp    %eax,%edx
  803f22:	74 ae                	je     803ed2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f2c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f34:	8b 00                	mov    (%rax),%eax
  803f36:	99                   	cltd   
  803f37:	c1 ea 1b             	shr    $0x1b,%edx
  803f3a:	01 d0                	add    %edx,%eax
  803f3c:	83 e0 1f             	and    $0x1f,%eax
  803f3f:	29 d0                	sub    %edx,%eax
  803f41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f45:	48 98                	cltq   
  803f47:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f4c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f52:	8b 00                	mov    (%rax),%eax
  803f54:	8d 50 01             	lea    0x1(%rax),%edx
  803f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f5d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f66:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f6a:	0f 82 60 ff ff ff    	jb     803ed0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f74:	c9                   	leaveq 
  803f75:	c3                   	retq   

0000000000803f76 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f76:	55                   	push   %rbp
  803f77:	48 89 e5             	mov    %rsp,%rbp
  803f7a:	48 83 ec 40          	sub    $0x40,%rsp
  803f7e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f86:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8e:	48 89 c7             	mov    %rax,%rdi
  803f91:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  803f98:	00 00 00 
  803f9b:	ff d0                	callq  *%rax
  803f9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fa9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fb0:	00 
  803fb1:	e9 8e 00 00 00       	jmpq   804044 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fb6:	eb 31                	jmp    803fe9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803fb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc0:	48 89 d6             	mov    %rdx,%rsi
  803fc3:	48 89 c7             	mov    %rax,%rdi
  803fc6:	48 b8 59 3d 80 00 00 	movabs $0x803d59,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
  803fd2:	85 c0                	test   %eax,%eax
  803fd4:	74 07                	je     803fdd <devpipe_write+0x67>
				return 0;
  803fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  803fdb:	eb 79                	jmp    804056 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fdd:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  803fe4:	00 00 00 
  803fe7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fed:	8b 40 04             	mov    0x4(%rax),%eax
  803ff0:	48 63 d0             	movslq %eax,%rdx
  803ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff7:	8b 00                	mov    (%rax),%eax
  803ff9:	48 98                	cltq   
  803ffb:	48 83 c0 20          	add    $0x20,%rax
  803fff:	48 39 c2             	cmp    %rax,%rdx
  804002:	73 b4                	jae    803fb8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804008:	8b 40 04             	mov    0x4(%rax),%eax
  80400b:	99                   	cltd   
  80400c:	c1 ea 1b             	shr    $0x1b,%edx
  80400f:	01 d0                	add    %edx,%eax
  804011:	83 e0 1f             	and    $0x1f,%eax
  804014:	29 d0                	sub    %edx,%eax
  804016:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80401a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80401e:	48 01 ca             	add    %rcx,%rdx
  804021:	0f b6 0a             	movzbl (%rdx),%ecx
  804024:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804028:	48 98                	cltq   
  80402a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80402e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804032:	8b 40 04             	mov    0x4(%rax),%eax
  804035:	8d 50 01             	lea    0x1(%rax),%edx
  804038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80403f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804048:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80404c:	0f 82 64 ff ff ff    	jb     803fb6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804056:	c9                   	leaveq 
  804057:	c3                   	retq   

0000000000804058 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804058:	55                   	push   %rbp
  804059:	48 89 e5             	mov    %rsp,%rbp
  80405c:	48 83 ec 20          	sub    $0x20,%rsp
  804060:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804064:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406c:	48 89 c7             	mov    %rax,%rdi
  80406f:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
  80407b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80407f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804083:	48 be 99 4f 80 00 00 	movabs $0x804f99,%rsi
  80408a:	00 00 00 
  80408d:	48 89 c7             	mov    %rax,%rdi
  804090:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  804097:	00 00 00 
  80409a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80409c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a0:	8b 50 04             	mov    0x4(%rax),%edx
  8040a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a7:	8b 00                	mov    (%rax),%eax
  8040a9:	29 c2                	sub    %eax,%edx
  8040ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040af:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8040b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040c0:	00 00 00 
	stat->st_dev = &devpipe;
  8040c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040c7:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8040ce:	00 00 00 
  8040d1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8040d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040dd:	c9                   	leaveq 
  8040de:	c3                   	retq   

00000000008040df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040df:	55                   	push   %rbp
  8040e0:	48 89 e5             	mov    %rsp,%rbp
  8040e3:	48 83 ec 10          	sub    $0x10,%rsp
  8040e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8040eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ef:	48 89 c6             	mov    %rax,%rsi
  8040f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f7:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8040fe:	00 00 00 
  804101:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	48 89 c6             	mov    %rax,%rsi
  804119:	bf 00 00 00 00       	mov    $0x0,%edi
  80411e:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  804125:	00 00 00 
  804128:	ff d0                	callq  *%rax
}
  80412a:	c9                   	leaveq 
  80412b:	c3                   	retq   

000000000080412c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80412c:	55                   	push   %rbp
  80412d:	48 89 e5             	mov    %rsp,%rbp
  804130:	48 83 ec 20          	sub    $0x20,%rsp
  804134:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804137:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80413d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804141:	be 01 00 00 00       	mov    $0x1,%esi
  804146:	48 89 c7             	mov    %rax,%rdi
  804149:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  804150:	00 00 00 
  804153:	ff d0                	callq  *%rax
}
  804155:	c9                   	leaveq 
  804156:	c3                   	retq   

0000000000804157 <getchar>:

int
getchar(void)
{
  804157:	55                   	push   %rbp
  804158:	48 89 e5             	mov    %rsp,%rbp
  80415b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80415f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804163:	ba 01 00 00 00       	mov    $0x1,%edx
  804168:	48 89 c6             	mov    %rax,%rsi
  80416b:	bf 00 00 00 00       	mov    $0x0,%edi
  804170:	48 b8 6b 28 80 00 00 	movabs $0x80286b,%rax
  804177:	00 00 00 
  80417a:	ff d0                	callq  *%rax
  80417c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80417f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804183:	79 05                	jns    80418a <getchar+0x33>
		return r;
  804185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804188:	eb 14                	jmp    80419e <getchar+0x47>
	if (r < 1)
  80418a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80418e:	7f 07                	jg     804197 <getchar+0x40>
		return -E_EOF;
  804190:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804195:	eb 07                	jmp    80419e <getchar+0x47>
	return c;
  804197:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80419b:	0f b6 c0             	movzbl %al,%eax
}
  80419e:	c9                   	leaveq 
  80419f:	c3                   	retq   

00000000008041a0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8041a0:	55                   	push   %rbp
  8041a1:	48 89 e5             	mov    %rsp,%rbp
  8041a4:	48 83 ec 20          	sub    $0x20,%rsp
  8041a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8041af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b2:	48 89 d6             	mov    %rdx,%rsi
  8041b5:	89 c7                	mov    %eax,%edi
  8041b7:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8041be:	00 00 00 
  8041c1:	ff d0                	callq  *%rax
  8041c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ca:	79 05                	jns    8041d1 <iscons+0x31>
		return r;
  8041cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cf:	eb 1a                	jmp    8041eb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8041d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d5:	8b 10                	mov    (%rax),%edx
  8041d7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8041de:	00 00 00 
  8041e1:	8b 00                	mov    (%rax),%eax
  8041e3:	39 c2                	cmp    %eax,%edx
  8041e5:	0f 94 c0             	sete   %al
  8041e8:	0f b6 c0             	movzbl %al,%eax
}
  8041eb:	c9                   	leaveq 
  8041ec:	c3                   	retq   

00000000008041ed <opencons>:

int
opencons(void)
{
  8041ed:	55                   	push   %rbp
  8041ee:	48 89 e5             	mov    %rsp,%rbp
  8041f1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041f5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041f9:	48 89 c7             	mov    %rax,%rdi
  8041fc:	48 b8 a1 23 80 00 00 	movabs $0x8023a1,%rax
  804203:	00 00 00 
  804206:	ff d0                	callq  *%rax
  804208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80420b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80420f:	79 05                	jns    804216 <opencons+0x29>
		return r;
  804211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804214:	eb 5b                	jmp    804271 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80421a:	ba 07 04 00 00       	mov    $0x407,%edx
  80421f:	48 89 c6             	mov    %rax,%rsi
  804222:	bf 00 00 00 00       	mov    $0x0,%edi
  804227:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  80422e:	00 00 00 
  804231:	ff d0                	callq  *%rax
  804233:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804236:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423a:	79 05                	jns    804241 <opencons+0x54>
		return r;
  80423c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80423f:	eb 30                	jmp    804271 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804245:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80424c:	00 00 00 
  80424f:	8b 12                	mov    (%rdx),%edx
  804251:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804257:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80425e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804262:	48 89 c7             	mov    %rax,%rdi
  804265:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  80426c:	00 00 00 
  80426f:	ff d0                	callq  *%rax
}
  804271:	c9                   	leaveq 
  804272:	c3                   	retq   

0000000000804273 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804273:	55                   	push   %rbp
  804274:	48 89 e5             	mov    %rsp,%rbp
  804277:	48 83 ec 30          	sub    $0x30,%rsp
  80427b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80427f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804283:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804287:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80428c:	75 07                	jne    804295 <devcons_read+0x22>
		return 0;
  80428e:	b8 00 00 00 00       	mov    $0x0,%eax
  804293:	eb 4b                	jmp    8042e0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804295:	eb 0c                	jmp    8042a3 <devcons_read+0x30>
		sys_yield();
  804297:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8042a3:	48 b8 82 18 80 00 00 	movabs $0x801882,%rax
  8042aa:	00 00 00 
  8042ad:	ff d0                	callq  *%rax
  8042af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b6:	74 df                	je     804297 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8042b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042bc:	79 05                	jns    8042c3 <devcons_read+0x50>
		return c;
  8042be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c1:	eb 1d                	jmp    8042e0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8042c3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8042c7:	75 07                	jne    8042d0 <devcons_read+0x5d>
		return 0;
  8042c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ce:	eb 10                	jmp    8042e0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8042d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d3:	89 c2                	mov    %eax,%edx
  8042d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d9:	88 10                	mov    %dl,(%rax)
	return 1;
  8042db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042e0:	c9                   	leaveq 
  8042e1:	c3                   	retq   

00000000008042e2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042e2:	55                   	push   %rbp
  8042e3:	48 89 e5             	mov    %rsp,%rbp
  8042e6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042ed:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042f4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042fb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804302:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804309:	eb 76                	jmp    804381 <devcons_write+0x9f>
		m = n - tot;
  80430b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804312:	89 c2                	mov    %eax,%edx
  804314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804317:	29 c2                	sub    %eax,%edx
  804319:	89 d0                	mov    %edx,%eax
  80431b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80431e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804321:	83 f8 7f             	cmp    $0x7f,%eax
  804324:	76 07                	jbe    80432d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804326:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80432d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804330:	48 63 d0             	movslq %eax,%rdx
  804333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804336:	48 63 c8             	movslq %eax,%rcx
  804339:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804340:	48 01 c1             	add    %rax,%rcx
  804343:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80434a:	48 89 ce             	mov    %rcx,%rsi
  80434d:	48 89 c7             	mov    %rax,%rdi
  804350:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  804357:	00 00 00 
  80435a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80435c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80435f:	48 63 d0             	movslq %eax,%rdx
  804362:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804369:	48 89 d6             	mov    %rdx,%rsi
  80436c:	48 89 c7             	mov    %rax,%rdi
  80436f:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80437b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80437e:	01 45 fc             	add    %eax,-0x4(%rbp)
  804381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804384:	48 98                	cltq   
  804386:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80438d:	0f 82 78 ff ff ff    	jb     80430b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804393:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804396:	c9                   	leaveq 
  804397:	c3                   	retq   

0000000000804398 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804398:	55                   	push   %rbp
  804399:	48 89 e5             	mov    %rsp,%rbp
  80439c:	48 83 ec 08          	sub    $0x8,%rsp
  8043a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8043a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043a9:	c9                   	leaveq 
  8043aa:	c3                   	retq   

00000000008043ab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8043ab:	55                   	push   %rbp
  8043ac:	48 89 e5             	mov    %rsp,%rbp
  8043af:	48 83 ec 10          	sub    $0x10,%rsp
  8043b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8043bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043bf:	48 be a5 4f 80 00 00 	movabs $0x804fa5,%rsi
  8043c6:	00 00 00 
  8043c9:	48 89 c7             	mov    %rax,%rdi
  8043cc:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8043d3:	00 00 00 
  8043d6:	ff d0                	callq  *%rax
	return 0;
  8043d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   

00000000008043df <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8043df:	55                   	push   %rbp
  8043e0:	48 89 e5             	mov    %rsp,%rbp
  8043e3:	48 83 ec 10          	sub    $0x10,%rsp
  8043e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8043eb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f2:	00 00 00 
  8043f5:	48 8b 00             	mov    (%rax),%rax
  8043f8:	48 85 c0             	test   %rax,%rax
  8043fb:	0f 85 84 00 00 00    	jne    804485 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804401:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804408:	00 00 00 
  80440b:	48 8b 00             	mov    (%rax),%rax
  80440e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804414:	ba 07 00 00 00       	mov    $0x7,%edx
  804419:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80441e:	89 c7                	mov    %eax,%edi
  804420:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  804427:	00 00 00 
  80442a:	ff d0                	callq  *%rax
  80442c:	85 c0                	test   %eax,%eax
  80442e:	79 2a                	jns    80445a <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804430:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  804437:	00 00 00 
  80443a:	be 23 00 00 00       	mov    $0x23,%esi
  80443f:	48 bf d7 4f 80 00 00 	movabs $0x804fd7,%rdi
  804446:	00 00 00 
  804449:	b8 00 00 00 00       	mov    $0x0,%eax
  80444e:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  804455:	00 00 00 
  804458:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80445a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804461:	00 00 00 
  804464:	48 8b 00             	mov    (%rax),%rax
  804467:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80446d:	48 be 98 44 80 00 00 	movabs $0x804498,%rsi
  804474:	00 00 00 
  804477:	89 c7                	mov    %eax,%edi
  804479:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804485:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80448c:	00 00 00 
  80448f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804493:	48 89 10             	mov    %rdx,(%rax)
}
  804496:	c9                   	leaveq 
  804497:	c3                   	retq   

0000000000804498 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804498:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80449b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8044a2:	00 00 00 
call *%rax
  8044a5:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8044a7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8044ae:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8044af:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8044b6:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8044b7:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8044bb:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8044be:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8044c5:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8044c6:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8044ca:	4c 8b 3c 24          	mov    (%rsp),%r15
  8044ce:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8044d3:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8044d8:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8044dd:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8044e2:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8044e7:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8044ec:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8044f1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044f6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044fb:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804500:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804505:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80450a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80450f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804514:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804518:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80451c:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80451d:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80451e:	c3                   	retq   

000000000080451f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80451f:	55                   	push   %rbp
  804520:	48 89 e5             	mov    %rsp,%rbp
  804523:	48 83 ec 30          	sub    $0x30,%rsp
  804527:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80452b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80452f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804533:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80453a:	00 00 00 
  80453d:	48 8b 00             	mov    (%rax),%rax
  804540:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804546:	85 c0                	test   %eax,%eax
  804548:	75 3c                	jne    804586 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80454a:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  804551:	00 00 00 
  804554:	ff d0                	callq  *%rax
  804556:	25 ff 03 00 00       	and    $0x3ff,%eax
  80455b:	48 63 d0             	movslq %eax,%rdx
  80455e:	48 89 d0             	mov    %rdx,%rax
  804561:	48 c1 e0 03          	shl    $0x3,%rax
  804565:	48 01 d0             	add    %rdx,%rax
  804568:	48 c1 e0 05          	shl    $0x5,%rax
  80456c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804573:	00 00 00 
  804576:	48 01 c2             	add    %rax,%rdx
  804579:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804580:	00 00 00 
  804583:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804586:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80458b:	75 0e                	jne    80459b <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80458d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804594:	00 00 00 
  804597:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80459b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80459f:	48 89 c7             	mov    %rax,%rdi
  8045a2:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8045a9:	00 00 00 
  8045ac:	ff d0                	callq  *%rax
  8045ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8045b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b5:	79 19                	jns    8045d0 <ipc_recv+0xb1>
		*from_env_store = 0;
  8045b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045bb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8045c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045c5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8045cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ce:	eb 53                	jmp    804623 <ipc_recv+0x104>
	}
	if(from_env_store)
  8045d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8045d5:	74 19                	je     8045f0 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8045d7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8045de:	00 00 00 
  8045e1:	48 8b 00             	mov    (%rax),%rax
  8045e4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8045ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ee:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8045f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045f5:	74 19                	je     804610 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8045f7:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8045fe:	00 00 00 
  804601:	48 8b 00             	mov    (%rax),%rax
  804604:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80460a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804610:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804617:	00 00 00 
  80461a:	48 8b 00             	mov    (%rax),%rax
  80461d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804623:	c9                   	leaveq 
  804624:	c3                   	retq   

0000000000804625 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804625:	55                   	push   %rbp
  804626:	48 89 e5             	mov    %rsp,%rbp
  804629:	48 83 ec 30          	sub    $0x30,%rsp
  80462d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804630:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804633:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804637:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80463a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80463f:	75 0e                	jne    80464f <ipc_send+0x2a>
		pg = (void*)UTOP;
  804641:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804648:	00 00 00 
  80464b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80464f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804652:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804655:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804659:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80465c:	89 c7                	mov    %eax,%edi
  80465e:	48 b8 54 1b 80 00 00 	movabs $0x801b54,%rax
  804665:	00 00 00 
  804668:	ff d0                	callq  *%rax
  80466a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80466d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804671:	75 0c                	jne    80467f <ipc_send+0x5a>
			sys_yield();
  804673:	48 b8 42 19 80 00 00 	movabs $0x801942,%rax
  80467a:	00 00 00 
  80467d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80467f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804683:	74 ca                	je     80464f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804685:	c9                   	leaveq 
  804686:	c3                   	retq   

0000000000804687 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804687:	55                   	push   %rbp
  804688:	48 89 e5             	mov    %rsp,%rbp
  80468b:	48 83 ec 14          	sub    $0x14,%rsp
  80468f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804692:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804699:	eb 5e                	jmp    8046f9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80469b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046a2:	00 00 00 
  8046a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046a8:	48 63 d0             	movslq %eax,%rdx
  8046ab:	48 89 d0             	mov    %rdx,%rax
  8046ae:	48 c1 e0 03          	shl    $0x3,%rax
  8046b2:	48 01 d0             	add    %rdx,%rax
  8046b5:	48 c1 e0 05          	shl    $0x5,%rax
  8046b9:	48 01 c8             	add    %rcx,%rax
  8046bc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8046c2:	8b 00                	mov    (%rax),%eax
  8046c4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046c7:	75 2c                	jne    8046f5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8046c9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8046d0:	00 00 00 
  8046d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d6:	48 63 d0             	movslq %eax,%rdx
  8046d9:	48 89 d0             	mov    %rdx,%rax
  8046dc:	48 c1 e0 03          	shl    $0x3,%rax
  8046e0:	48 01 d0             	add    %rdx,%rax
  8046e3:	48 c1 e0 05          	shl    $0x5,%rax
  8046e7:	48 01 c8             	add    %rcx,%rax
  8046ea:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046f0:	8b 40 08             	mov    0x8(%rax),%eax
  8046f3:	eb 12                	jmp    804707 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046f9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804700:	7e 99                	jle    80469b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804707:	c9                   	leaveq 
  804708:	c3                   	retq   

0000000000804709 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804709:	55                   	push   %rbp
  80470a:	48 89 e5             	mov    %rsp,%rbp
  80470d:	48 83 ec 18          	sub    $0x18,%rsp
  804711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804719:	48 c1 e8 15          	shr    $0x15,%rax
  80471d:	48 89 c2             	mov    %rax,%rdx
  804720:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804727:	01 00 00 
  80472a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80472e:	83 e0 01             	and    $0x1,%eax
  804731:	48 85 c0             	test   %rax,%rax
  804734:	75 07                	jne    80473d <pageref+0x34>
		return 0;
  804736:	b8 00 00 00 00       	mov    $0x0,%eax
  80473b:	eb 53                	jmp    804790 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80473d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804741:	48 c1 e8 0c          	shr    $0xc,%rax
  804745:	48 89 c2             	mov    %rax,%rdx
  804748:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80474f:	01 00 00 
  804752:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80475a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80475e:	83 e0 01             	and    $0x1,%eax
  804761:	48 85 c0             	test   %rax,%rax
  804764:	75 07                	jne    80476d <pageref+0x64>
		return 0;
  804766:	b8 00 00 00 00       	mov    $0x0,%eax
  80476b:	eb 23                	jmp    804790 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80476d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804771:	48 c1 e8 0c          	shr    $0xc,%rax
  804775:	48 89 c2             	mov    %rax,%rdx
  804778:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80477f:	00 00 00 
  804782:	48 c1 e2 04          	shl    $0x4,%rdx
  804786:	48 01 d0             	add    %rdx,%rax
  804789:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80478d:	0f b7 c0             	movzwl %ax,%eax
}
  804790:	c9                   	leaveq 
  804791:	c3                   	retq   
