
obj/user/testfdsharing.debug:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf c0 49 80 00 00 	movabs $0x8049c0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba c5 49 80 00 00 	movabs $0x8049c5,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 0f 2c 80 00 00 	movabs $0x802c0f,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 82 80 00 00 	movabs $0x808220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 28 22 80 00 00 	movabs $0x802228,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba f2 49 80 00 00 	movabs $0x8049f2,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 0f 2c 80 00 00 	movabs $0x802c0f,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 00 4a 80 00 00 	movabs $0x804a00,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 48 4a 80 00 00 	movabs $0x804a48,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 82 80 00 00 	movabs $0x808220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 78 4a 80 00 00 	movabs $0x804a78,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf ae 4a 80 00 00 	movabs $0x804aae,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 0f 2c 80 00 00 	movabs $0x802c0f,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 b2 42 80 00 00 	movabs $0x8042b2,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 80 80 00 00 	movabs $0x808020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba c8 4a 80 00 00 	movabs $0x804ac8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf d3 49 80 00 00 	movabs $0x8049d3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf eb 4a 80 00 00 	movabs $0x804aeb,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80034a:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035b:	48 63 d0             	movslq %eax,%rdx
  80035e:	48 89 d0             	mov    %rdx,%rax
  800361:	48 c1 e0 03          	shl    $0x3,%rax
  800365:	48 01 d0             	add    %rdx,%rax
  800368:	48 c1 e0 05          	shl    $0x5,%rax
  80036c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800373:	00 00 00 
  800376:	48 01 c2             	add    %rax,%rdx
  800379:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  800380:	00 00 00 
  800383:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80038a:	7e 14                	jle    8003a0 <libmain+0x65>
		binaryname = argv[0];
  80038c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800390:	48 8b 10             	mov    (%rax),%rdx
  800393:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80039a:	00 00 00 
  80039d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a7:	48 89 d6             	mov    %rdx,%rsi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003b8:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  8003bf:	00 00 00 
  8003c2:	ff d0                	callq  *%rax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ca:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003db:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax

}
  8003e7:	5d                   	pop    %rbp
  8003e8:	c3                   	retq   

00000000008003e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	53                   	push   %rbx
  8003ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800402:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800409:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800410:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800417:	84 c0                	test   %al,%al
  800419:	74 23                	je     80043e <_panic+0x55>
  80041b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800422:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800426:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80042a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80042e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800432:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800436:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80043a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80043e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800445:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80044c:	00 00 00 
  80044f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800456:	00 00 00 
  800459:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80045d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800464:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80046b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800472:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800479:	00 00 00 
  80047c:	48 8b 18             	mov    (%rax),%rbx
  80047f:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800491:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800498:	41 89 c8             	mov    %ecx,%r8d
  80049b:	48 89 d1             	mov    %rdx,%rcx
  80049e:	48 89 da             	mov    %rbx,%rdx
  8004a1:	89 c6                	mov    %eax,%esi
  8004a3:	48 bf 10 4b 80 00 00 	movabs $0x804b10,%rdi
  8004aa:	00 00 00 
  8004ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b2:	49 b9 22 06 80 00 00 	movabs $0x800622,%r9
  8004b9:	00 00 00 
  8004bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004cd:	48 89 d6             	mov    %rdx,%rsi
  8004d0:	48 89 c7             	mov    %rax,%rdi
  8004d3:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004df:	48 bf 33 4b 80 00 00 	movabs $0x804b33,%rdi
  8004e6:	00 00 00 
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  8004f5:	00 00 00 
  8004f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004fa:	cc                   	int3   
  8004fb:	eb fd                	jmp    8004fa <_panic+0x111>

00000000008004fd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004fd:	55                   	push   %rbp
  8004fe:	48 89 e5             	mov    %rsp,%rbp
  800501:	48 83 ec 10          	sub    $0x10,%rsp
  800505:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800508:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80050c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800510:	8b 00                	mov    (%rax),%eax
  800512:	8d 48 01             	lea    0x1(%rax),%ecx
  800515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800519:	89 0a                	mov    %ecx,(%rdx)
  80051b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80051e:	89 d1                	mov    %edx,%ecx
  800520:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800524:	48 98                	cltq   
  800526:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80052a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052e:	8b 00                	mov    (%rax),%eax
  800530:	3d ff 00 00 00       	cmp    $0xff,%eax
  800535:	75 2c                	jne    800563 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	48 98                	cltq   
  80053f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800543:	48 83 c2 08          	add    $0x8,%rdx
  800547:	48 89 c6             	mov    %rax,%rsi
  80054a:	48 89 d7             	mov    %rdx,%rdi
  80054d:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  800554:	00 00 00 
  800557:	ff d0                	callq  *%rax
        b->idx = 0;
  800559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800567:	8b 40 04             	mov    0x4(%rax),%eax
  80056a:	8d 50 01             	lea    0x1(%rax),%edx
  80056d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800571:	89 50 04             	mov    %edx,0x4(%rax)
}
  800574:	c9                   	leaveq 
  800575:	c3                   	retq   

0000000000800576 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800576:	55                   	push   %rbp
  800577:	48 89 e5             	mov    %rsp,%rbp
  80057a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800581:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800588:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80058f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800596:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80059d:	48 8b 0a             	mov    (%rdx),%rcx
  8005a0:	48 89 08             	mov    %rcx,(%rax)
  8005a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005af:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005ba:	00 00 00 
    b.cnt = 0;
  8005bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005c4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005c7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ce:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005d5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005dc:	48 89 c6             	mov    %rax,%rsi
  8005df:	48 bf fd 04 80 00 00 	movabs $0x8004fd,%rdi
  8005e6:	00 00 00 
  8005e9:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005f5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005fb:	48 98                	cltq   
  8005fd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800604:	48 83 c2 08          	add    $0x8,%rdx
  800608:	48 89 c6             	mov    %rax,%rsi
  80060b:	48 89 d7             	mov    %rdx,%rdi
  80060e:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800620:	c9                   	leaveq 
  800621:	c3                   	retq   

0000000000800622 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800622:	55                   	push   %rbp
  800623:	48 89 e5             	mov    %rsp,%rbp
  800626:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80062d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800634:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80063b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800642:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800649:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800650:	84 c0                	test   %al,%al
  800652:	74 20                	je     800674 <cprintf+0x52>
  800654:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800658:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80065c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800660:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800664:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800668:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80066c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800670:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800674:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80067b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800682:	00 00 00 
  800685:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80068c:	00 00 00 
  80068f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800693:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80069a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006a8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006af:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006b6:	48 8b 0a             	mov    (%rdx),%rcx
  8006b9:	48 89 08             	mov    %rcx,(%rax)
  8006bc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006cc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006d3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006da:	48 89 d6             	mov    %rdx,%rsi
  8006dd:	48 89 c7             	mov    %rax,%rdi
  8006e0:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  8006e7:	00 00 00 
  8006ea:	ff d0                	callq  *%rax
  8006ec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006f2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006f8:	c9                   	leaveq 
  8006f9:	c3                   	retq   

00000000008006fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fa:	55                   	push   %rbp
  8006fb:	48 89 e5             	mov    %rsp,%rbp
  8006fe:	53                   	push   %rbx
  8006ff:	48 83 ec 38          	sub    $0x38,%rsp
  800703:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800707:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80070b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80070f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800712:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800716:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80071d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800721:	77 3b                	ja     80075e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800723:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800726:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80072a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80072d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	48 f7 f3             	div    %rbx
  800739:	48 89 c2             	mov    %rax,%rdx
  80073c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80073f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800742:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	41 89 f9             	mov    %edi,%r9d
  80074d:	48 89 c7             	mov    %rax,%rdi
  800750:	48 b8 fa 06 80 00 00 	movabs $0x8006fa,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
  80075c:	eb 1e                	jmp    80077c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80075e:	eb 12                	jmp    800772 <printnum+0x78>
			putch(padc, putdat);
  800760:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800764:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	48 89 ce             	mov    %rcx,%rsi
  80076e:	89 d7                	mov    %edx,%edi
  800770:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800772:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800776:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80077a:	7f e4                	jg     800760 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80077f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	48 f7 f1             	div    %rcx
  80078b:	48 89 d0             	mov    %rdx,%rax
  80078e:	48 ba 30 4d 80 00 00 	movabs $0x804d30,%rdx
  800795:	00 00 00 
  800798:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80079c:	0f be d0             	movsbl %al,%edx
  80079f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	48 89 ce             	mov    %rcx,%rsi
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	ff d0                	callq  *%rax
}
  8007ae:	48 83 c4 38          	add    $0x38,%rsp
  8007b2:	5b                   	pop    %rbx
  8007b3:	5d                   	pop    %rbp
  8007b4:	c3                   	retq   

00000000008007b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b5:	55                   	push   %rbp
  8007b6:	48 89 e5             	mov    %rsp,%rbp
  8007b9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007c4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c8:	7e 52                	jle    80081c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 24                	jae    8007f9 <getuint+0x44>
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	8b 12                	mov    (%rdx),%edx
  8007ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	89 0a                	mov    %ecx,(%rdx)
  8007f7:	eb 17                	jmp    800810 <getuint+0x5b>
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800801:	48 89 d0             	mov    %rdx,%rax
  800804:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800810:	48 8b 00             	mov    (%rax),%rax
  800813:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800817:	e9 a3 00 00 00       	jmpq   8008bf <getuint+0x10a>
	else if (lflag)
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800820:	74 4f                	je     800871 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	8b 00                	mov    (%rax),%eax
  800828:	83 f8 30             	cmp    $0x30,%eax
  80082b:	73 24                	jae    800851 <getuint+0x9c>
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	89 c0                	mov    %eax,%eax
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	8b 12                	mov    (%rdx),%edx
  800846:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	89 0a                	mov    %ecx,(%rdx)
  80084f:	eb 17                	jmp    800868 <getuint+0xb3>
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800860:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800864:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800868:	48 8b 00             	mov    (%rax),%rax
  80086b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086f:	eb 4e                	jmp    8008bf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	83 f8 30             	cmp    $0x30,%eax
  80087a:	73 24                	jae    8008a0 <getuint+0xeb>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	8b 00                	mov    (%rax),%eax
  80088a:	89 c0                	mov    %eax,%eax
  80088c:	48 01 d0             	add    %rdx,%rax
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	8b 12                	mov    (%rdx),%edx
  800895:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089c:	89 0a                	mov    %ecx,(%rdx)
  80089e:	eb 17                	jmp    8008b7 <getuint+0x102>
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a8:	48 89 d0             	mov    %rdx,%rax
  8008ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c3:	c9                   	leaveq 
  8008c4:	c3                   	retq   

00000000008008c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c5:	55                   	push   %rbp
  8008c6:	48 89 e5             	mov    %rsp,%rbp
  8008c9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008d4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d8:	7e 52                	jle    80092c <getint+0x67>
		x=va_arg(*ap, long long);
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	83 f8 30             	cmp    $0x30,%eax
  8008e3:	73 24                	jae    800909 <getint+0x44>
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f1:	8b 00                	mov    (%rax),%eax
  8008f3:	89 c0                	mov    %eax,%eax
  8008f5:	48 01 d0             	add    %rdx,%rax
  8008f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fc:	8b 12                	mov    (%rdx),%edx
  8008fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800901:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800905:	89 0a                	mov    %ecx,(%rdx)
  800907:	eb 17                	jmp    800920 <getint+0x5b>
  800909:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800911:	48 89 d0             	mov    %rdx,%rax
  800914:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800920:	48 8b 00             	mov    (%rax),%rax
  800923:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800927:	e9 a3 00 00 00       	jmpq   8009cf <getint+0x10a>
	else if (lflag)
  80092c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800930:	74 4f                	je     800981 <getint+0xbc>
		x=va_arg(*ap, long);
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	8b 00                	mov    (%rax),%eax
  800938:	83 f8 30             	cmp    $0x30,%eax
  80093b:	73 24                	jae    800961 <getint+0x9c>
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	89 c0                	mov    %eax,%eax
  80094d:	48 01 d0             	add    %rdx,%rax
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	8b 12                	mov    (%rdx),%edx
  800956:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	89 0a                	mov    %ecx,(%rdx)
  80095f:	eb 17                	jmp    800978 <getint+0xb3>
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800978:	48 8b 00             	mov    (%rax),%rax
  80097b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097f:	eb 4e                	jmp    8009cf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	83 f8 30             	cmp    $0x30,%eax
  80098a:	73 24                	jae    8009b0 <getint+0xeb>
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	8b 00                	mov    (%rax),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	8b 12                	mov    (%rdx),%edx
  8009a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	89 0a                	mov    %ecx,(%rdx)
  8009ae:	eb 17                	jmp    8009c7 <getint+0x102>
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b8:	48 89 d0             	mov    %rdx,%rax
  8009bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	48 98                	cltq   
  8009cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d3:	c9                   	leaveq 
  8009d4:	c3                   	retq   

00000000008009d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d5:	55                   	push   %rbp
  8009d6:	48 89 e5             	mov    %rsp,%rbp
  8009d9:	41 54                	push   %r12
  8009db:	53                   	push   %rbx
  8009dc:	48 83 ec 60          	sub    $0x60,%rsp
  8009e0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009e4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009e8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009f8:	48 8b 0a             	mov    (%rdx),%rcx
  8009fb:	48 89 08             	mov    %rcx,(%rax)
  8009fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a02:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a06:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a0a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0e:	eb 17                	jmp    800a27 <vprintfmt+0x52>
			if (ch == '\0')
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	0f 84 cc 04 00 00    	je     800ee4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a20:	48 89 d6             	mov    %rdx,%rsi
  800a23:	89 df                	mov    %ebx,%edi
  800a25:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a27:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a2f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a33:	0f b6 00             	movzbl (%rax),%eax
  800a36:	0f b6 d8             	movzbl %al,%ebx
  800a39:	83 fb 25             	cmp    $0x25,%ebx
  800a3c:	75 d2                	jne    800a10 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a3e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a42:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a49:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a50:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a57:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a5e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a66:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6a:	0f b6 00             	movzbl (%rax),%eax
  800a6d:	0f b6 d8             	movzbl %al,%ebx
  800a70:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a73:	83 f8 55             	cmp    $0x55,%eax
  800a76:	0f 87 34 04 00 00    	ja     800eb0 <vprintfmt+0x4db>
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a85:	00 
  800a86:	48 b8 58 4d 80 00 00 	movabs $0x804d58,%rax
  800a8d:	00 00 00 
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	48 8b 00             	mov    (%rax),%rax
  800a96:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a98:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a9c:	eb c0                	jmp    800a5e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aa2:	eb ba                	jmp    800a5e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aae:	89 d0                	mov    %edx,%eax
  800ab0:	c1 e0 02             	shl    $0x2,%eax
  800ab3:	01 d0                	add    %edx,%eax
  800ab5:	01 c0                	add    %eax,%eax
  800ab7:	01 d8                	add    %ebx,%eax
  800ab9:	83 e8 30             	sub    $0x30,%eax
  800abc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800abf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac3:	0f b6 00             	movzbl (%rax),%eax
  800ac6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac9:	83 fb 2f             	cmp    $0x2f,%ebx
  800acc:	7e 0c                	jle    800ada <vprintfmt+0x105>
  800ace:	83 fb 39             	cmp    $0x39,%ebx
  800ad1:	7f 07                	jg     800ada <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad8:	eb d1                	jmp    800aab <vprintfmt+0xd6>
			goto process_precision;
  800ada:	eb 58                	jmp    800b34 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800adc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adf:	83 f8 30             	cmp    $0x30,%eax
  800ae2:	73 17                	jae    800afb <vprintfmt+0x126>
  800ae4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aeb:	89 c0                	mov    %eax,%eax
  800aed:	48 01 d0             	add    %rdx,%rax
  800af0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af3:	83 c2 08             	add    $0x8,%edx
  800af6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af9:	eb 0f                	jmp    800b0a <vprintfmt+0x135>
  800afb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aff:	48 89 d0             	mov    %rdx,%rax
  800b02:	48 83 c2 08          	add    $0x8,%rdx
  800b06:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0a:	8b 00                	mov    (%rax),%eax
  800b0c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b0f:	eb 23                	jmp    800b34 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b15:	79 0c                	jns    800b23 <vprintfmt+0x14e>
				width = 0;
  800b17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b1e:	e9 3b ff ff ff       	jmpq   800a5e <vprintfmt+0x89>
  800b23:	e9 36 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b28:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b2f:	e9 2a ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b38:	79 12                	jns    800b4c <vprintfmt+0x177>
				width = precision, precision = -1;
  800b3a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b40:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b47:	e9 12 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>
  800b4c:	e9 0d ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b51:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b55:	e9 04 ff ff ff       	jmpq   800a5e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 17                	jae    800b79 <vprintfmt+0x1a4>
  800b62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b69:	89 c0                	mov    %eax,%eax
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b71:	83 c2 08             	add    $0x8,%edx
  800b74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b77:	eb 0f                	jmp    800b88 <vprintfmt+0x1b3>
  800b79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7d:	48 89 d0             	mov    %rdx,%rax
  800b80:	48 83 c2 08          	add    $0x8,%rdx
  800b84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b88:	8b 10                	mov    (%rax),%edx
  800b8a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	48 89 ce             	mov    %rcx,%rsi
  800b95:	89 d7                	mov    %edx,%edi
  800b97:	ff d0                	callq  *%rax
			break;
  800b99:	e9 40 03 00 00       	jmpq   800ede <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba1:	83 f8 30             	cmp    $0x30,%eax
  800ba4:	73 17                	jae    800bbd <vprintfmt+0x1e8>
  800ba6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800baa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bad:	89 c0                	mov    %eax,%eax
  800baf:	48 01 d0             	add    %rdx,%rax
  800bb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb5:	83 c2 08             	add    $0x8,%edx
  800bb8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bbb:	eb 0f                	jmp    800bcc <vprintfmt+0x1f7>
  800bbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc1:	48 89 d0             	mov    %rdx,%rax
  800bc4:	48 83 c2 08          	add    $0x8,%rdx
  800bc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bcc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	79 02                	jns    800bd4 <vprintfmt+0x1ff>
				err = -err;
  800bd2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bd4:	83 fb 15             	cmp    $0x15,%ebx
  800bd7:	7f 16                	jg     800bef <vprintfmt+0x21a>
  800bd9:	48 b8 80 4c 80 00 00 	movabs $0x804c80,%rax
  800be0:	00 00 00 
  800be3:	48 63 d3             	movslq %ebx,%rdx
  800be6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bea:	4d 85 e4             	test   %r12,%r12
  800bed:	75 2e                	jne    800c1d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf7:	89 d9                	mov    %ebx,%ecx
  800bf9:	48 ba 41 4d 80 00 00 	movabs $0x804d41,%rdx
  800c00:	00 00 00 
  800c03:	48 89 c7             	mov    %rax,%rdi
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0b:	49 b8 ed 0e 80 00 00 	movabs $0x800eed,%r8
  800c12:	00 00 00 
  800c15:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c18:	e9 c1 02 00 00       	jmpq   800ede <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c25:	4c 89 e1             	mov    %r12,%rcx
  800c28:	48 ba 4a 4d 80 00 00 	movabs $0x804d4a,%rdx
  800c2f:	00 00 00 
  800c32:	48 89 c7             	mov    %rax,%rdi
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	49 b8 ed 0e 80 00 00 	movabs $0x800eed,%r8
  800c41:	00 00 00 
  800c44:	41 ff d0             	callq  *%r8
			break;
  800c47:	e9 92 02 00 00       	jmpq   800ede <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4f:	83 f8 30             	cmp    $0x30,%eax
  800c52:	73 17                	jae    800c6b <vprintfmt+0x296>
  800c54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5b:	89 c0                	mov    %eax,%eax
  800c5d:	48 01 d0             	add    %rdx,%rax
  800c60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c63:	83 c2 08             	add    $0x8,%edx
  800c66:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c69:	eb 0f                	jmp    800c7a <vprintfmt+0x2a5>
  800c6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6f:	48 89 d0             	mov    %rdx,%rax
  800c72:	48 83 c2 08          	add    $0x8,%rdx
  800c76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c7a:	4c 8b 20             	mov    (%rax),%r12
  800c7d:	4d 85 e4             	test   %r12,%r12
  800c80:	75 0a                	jne    800c8c <vprintfmt+0x2b7>
				p = "(null)";
  800c82:	49 bc 4d 4d 80 00 00 	movabs $0x804d4d,%r12
  800c89:	00 00 00 
			if (width > 0 && padc != '-')
  800c8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c90:	7e 3f                	jle    800cd1 <vprintfmt+0x2fc>
  800c92:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c96:	74 39                	je     800cd1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c98:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c9b:	48 98                	cltq   
  800c9d:	48 89 c6             	mov    %rax,%rsi
  800ca0:	4c 89 e7             	mov    %r12,%rdi
  800ca3:	48 b8 99 11 80 00 00 	movabs $0x801199,%rax
  800caa:	00 00 00 
  800cad:	ff d0                	callq  *%rax
  800caf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cb2:	eb 17                	jmp    800ccb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cb4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cb8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc0:	48 89 ce             	mov    %rcx,%rsi
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ccb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccf:	7f e3                	jg     800cb4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd1:	eb 37                	jmp    800d0a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cd7:	74 1e                	je     800cf7 <vprintfmt+0x322>
  800cd9:	83 fb 1f             	cmp    $0x1f,%ebx
  800cdc:	7e 05                	jle    800ce3 <vprintfmt+0x30e>
  800cde:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce1:	7e 14                	jle    800cf7 <vprintfmt+0x322>
					putch('?', putdat);
  800ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cf3:	ff d0                	callq  *%rax
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cff:	48 89 d6             	mov    %rdx,%rsi
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d06:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0a:	4c 89 e0             	mov    %r12,%rax
  800d0d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d11:	0f b6 00             	movzbl (%rax),%eax
  800d14:	0f be d8             	movsbl %al,%ebx
  800d17:	85 db                	test   %ebx,%ebx
  800d19:	74 10                	je     800d2b <vprintfmt+0x356>
  800d1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1f:	78 b2                	js     800cd3 <vprintfmt+0x2fe>
  800d21:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d25:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d29:	79 a8                	jns    800cd3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d2b:	eb 16                	jmp    800d43 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d35:	48 89 d6             	mov    %rdx,%rsi
  800d38:	bf 20 00 00 00       	mov    $0x20,%edi
  800d3d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d3f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d43:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d47:	7f e4                	jg     800d2d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d49:	e9 90 01 00 00       	jmpq   800ede <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d52:	be 03 00 00 00       	mov    $0x3,%esi
  800d57:	48 89 c7             	mov    %rax,%rdi
  800d5a:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800d61:	00 00 00 
  800d64:	ff d0                	callq  *%rax
  800d66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6e:	48 85 c0             	test   %rax,%rax
  800d71:	79 1d                	jns    800d90 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	48 89 d6             	mov    %rdx,%rsi
  800d7e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d83:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d89:	48 f7 d8             	neg    %rax
  800d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d90:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d97:	e9 d5 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d9c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da0:	be 03 00 00 00       	mov    $0x3,%esi
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	48 b8 b5 07 80 00 00 	movabs $0x8007b5,%rax
  800daf:	00 00 00 
  800db2:	ff d0                	callq  *%rax
  800db4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800db8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbf:	e9 ad 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800dc4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800dc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	48 89 c7             	mov    %rax,%rdi
  800dd0:	48 b8 c5 08 80 00 00 	movabs $0x8008c5,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800de0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800de7:	e9 85 00 00 00       	jmpq   800e71 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800dec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df4:	48 89 d6             	mov    %rdx,%rsi
  800df7:	bf 30 00 00 00       	mov    $0x30,%edi
  800dfc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	bf 78 00 00 00       	mov    $0x78,%edi
  800e0e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e13:	83 f8 30             	cmp    $0x30,%eax
  800e16:	73 17                	jae    800e2f <vprintfmt+0x45a>
  800e18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1f:	89 c0                	mov    %eax,%eax
  800e21:	48 01 d0             	add    %rdx,%rax
  800e24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e27:	83 c2 08             	add    $0x8,%edx
  800e2a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e2d:	eb 0f                	jmp    800e3e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e33:	48 89 d0             	mov    %rdx,%rax
  800e36:	48 83 c2 08          	add    $0x8,%rdx
  800e3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e3e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e45:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e4c:	eb 23                	jmp    800e71 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e52:	be 03 00 00 00       	mov    $0x3,%esi
  800e57:	48 89 c7             	mov    %rax,%rdi
  800e5a:	48 b8 b5 07 80 00 00 	movabs $0x8007b5,%rax
  800e61:	00 00 00 
  800e64:	ff d0                	callq  *%rax
  800e66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e6a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e71:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e76:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e79:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e80:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	45 89 c1             	mov    %r8d,%r9d
  800e8b:	41 89 f8             	mov    %edi,%r8d
  800e8e:	48 89 c7             	mov    %rax,%rdi
  800e91:	48 b8 fa 06 80 00 00 	movabs $0x8006fa,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
			break;
  800e9d:	eb 3f                	jmp    800ede <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea7:	48 89 d6             	mov    %rdx,%rsi
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	ff d0                	callq  *%rax
			break;
  800eae:	eb 2e                	jmp    800ede <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb8:	48 89 d6             	mov    %rdx,%rsi
  800ebb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ec0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ec2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec7:	eb 05                	jmp    800ece <vprintfmt+0x4f9>
  800ec9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ece:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ed2:	48 83 e8 01          	sub    $0x1,%rax
  800ed6:	0f b6 00             	movzbl (%rax),%eax
  800ed9:	3c 25                	cmp    $0x25,%al
  800edb:	75 ec                	jne    800ec9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800edd:	90                   	nop
		}
	}
  800ede:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800edf:	e9 43 fb ff ff       	jmpq   800a27 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ee4:	48 83 c4 60          	add    $0x60,%rsp
  800ee8:	5b                   	pop    %rbx
  800ee9:	41 5c                	pop    %r12
  800eeb:	5d                   	pop    %rbp
  800eec:	c3                   	retq   

0000000000800eed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ef8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eff:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f06:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f0d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f14:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f1b:	84 c0                	test   %al,%al
  800f1d:	74 20                	je     800f3f <printfmt+0x52>
  800f1f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f23:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f27:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f2b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f2f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f33:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f37:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f3b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f3f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f46:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f4d:	00 00 00 
  800f50:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f57:	00 00 00 
  800f5a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f65:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f6c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f73:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f7a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f81:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f88:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f8f:	48 89 c7             	mov    %rax,%rdi
  800f92:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  800f99:	00 00 00 
  800f9c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f9e:	c9                   	leaveq 
  800f9f:	c3                   	retq   

0000000000800fa0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa0:	55                   	push   %rbp
  800fa1:	48 89 e5             	mov    %rsp,%rbp
  800fa4:	48 83 ec 10          	sub    $0x10,%rsp
  800fa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb3:	8b 40 10             	mov    0x10(%rax),%eax
  800fb6:	8d 50 01             	lea    0x1(%rax),%edx
  800fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc4:	48 8b 10             	mov    (%rax),%rdx
  800fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fcf:	48 39 c2             	cmp    %rax,%rdx
  800fd2:	73 17                	jae    800feb <sprintputch+0x4b>
		*b->buf++ = ch;
  800fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd8:	48 8b 00             	mov    (%rax),%rax
  800fdb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fe3:	48 89 0a             	mov    %rcx,(%rdx)
  800fe6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fe9:	88 10                	mov    %dl,(%rax)
}
  800feb:	c9                   	leaveq 
  800fec:	c3                   	retq   

0000000000800fed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fed:	55                   	push   %rbp
  800fee:	48 89 e5             	mov    %rsp,%rbp
  800ff1:	48 83 ec 50          	sub    $0x50,%rsp
  800ff5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ff9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ffc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801000:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801004:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801008:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80100c:	48 8b 0a             	mov    (%rdx),%rcx
  80100f:	48 89 08             	mov    %rcx,(%rax)
  801012:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801016:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80101e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801022:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801026:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80102a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80102d:	48 98                	cltq   
  80102f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801033:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801037:	48 01 d0             	add    %rdx,%rax
  80103a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80103e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801045:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80104a:	74 06                	je     801052 <vsnprintf+0x65>
  80104c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801050:	7f 07                	jg     801059 <vsnprintf+0x6c>
		return -E_INVAL;
  801052:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801057:	eb 2f                	jmp    801088 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801059:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80105d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801061:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801065:	48 89 c6             	mov    %rax,%rsi
  801068:	48 bf a0 0f 80 00 00 	movabs $0x800fa0,%rdi
  80106f:	00 00 00 
  801072:	48 b8 d5 09 80 00 00 	movabs $0x8009d5,%rax
  801079:	00 00 00 
  80107c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80107e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801082:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801085:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801095:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80109c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010b7:	84 c0                	test   %al,%al
  8010b9:	74 20                	je     8010db <snprintf+0x51>
  8010bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010db:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010e2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010e9:	00 00 00 
  8010ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010f3:	00 00 00 
  8010f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801101:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801108:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80110f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801116:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80111d:	48 8b 0a             	mov    (%rdx),%rcx
  801120:	48 89 08             	mov    %rcx,(%rax)
  801123:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801127:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80112b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80112f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801133:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80113a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801141:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801147:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80114e:	48 89 c7             	mov    %rax,%rdi
  801151:	48 b8 ed 0f 80 00 00 	movabs $0x800fed,%rax
  801158:	00 00 00 
  80115b:	ff d0                	callq  *%rax
  80115d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801163:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 18          	sub    $0x18,%rsp
  801173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801177:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80117e:	eb 09                	jmp    801189 <strlen+0x1e>
		n++;
  801180:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801184:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	0f b6 00             	movzbl (%rax),%eax
  801190:	84 c0                	test   %al,%al
  801192:	75 ec                	jne    801180 <strlen+0x15>
		n++;
	return n;
  801194:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801197:	c9                   	leaveq 
  801198:	c3                   	retq   

0000000000801199 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	48 83 ec 20          	sub    $0x20,%rsp
  8011a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b0:	eb 0e                	jmp    8011c0 <strnlen+0x27>
		n++;
  8011b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011c5:	74 0b                	je     8011d2 <strnlen+0x39>
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e0                	jne    8011b2 <strnlen+0x19>
		n++;
	return n;
  8011d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 20          	sub    $0x20,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011ef:	90                   	nop
  8011f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801200:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801204:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801208:	0f b6 12             	movzbl (%rdx),%edx
  80120b:	88 10                	mov    %dl,(%rax)
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	75 dc                	jne    8011f0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 20          	sub    $0x20,%rsp
  801222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801226:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	48 89 c7             	mov    %rax,%rdi
  801231:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  801238:	00 00 00 
  80123b:	ff d0                	callq  *%rax
  80123d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801243:	48 63 d0             	movslq %eax,%rdx
  801246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124a:	48 01 c2             	add    %rax,%rdx
  80124d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801251:	48 89 c6             	mov    %rax,%rsi
  801254:	48 89 d7             	mov    %rdx,%rdi
  801257:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
	return dst;
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801267:	c9                   	leaveq 
  801268:	c3                   	retq   

0000000000801269 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801269:	55                   	push   %rbp
  80126a:	48 89 e5             	mov    %rsp,%rbp
  80126d:	48 83 ec 28          	sub    $0x28,%rsp
  801271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801285:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80128c:	00 
  80128d:	eb 2a                	jmp    8012b9 <strncpy+0x50>
		*dst++ = *src;
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801297:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80129f:	0f b6 12             	movzbl (%rdx),%edx
  8012a2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	84 c0                	test   %al,%al
  8012ad:	74 05                	je     8012b4 <strncpy+0x4b>
			src++;
  8012af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012c1:	72 cc                	jb     80128f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 28          	sub    $0x28,%rsp
  8012d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ea:	74 3d                	je     801329 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012ec:	eb 1d                	jmp    80130b <strlcpy+0x42>
			*dst++ = *src++;
  8012ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012fe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801302:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801306:	0f b6 12             	movzbl (%rdx),%edx
  801309:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80130b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801310:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801315:	74 0b                	je     801322 <strlcpy+0x59>
  801317:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	84 c0                	test   %al,%al
  801320:	75 cc                	jne    8012ee <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801329:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	48 29 c2             	sub    %rax,%rdx
  801334:	48 89 d0             	mov    %rdx,%rax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 10          	sub    $0x10,%rsp
  801341:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801345:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801349:	eb 0a                	jmp    801355 <strcmp+0x1c>
		p++, q++;
  80134b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801350:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	74 12                	je     801372 <strcmp+0x39>
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801364:	0f b6 10             	movzbl (%rax),%edx
  801367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	38 c2                	cmp    %al,%dl
  801370:	74 d9                	je     80134b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	0f b6 d0             	movzbl %al,%edx
  80137c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	0f b6 c0             	movzbl %al,%eax
  801386:	29 c2                	sub    %eax,%edx
  801388:	89 d0                	mov    %edx,%eax
}
  80138a:	c9                   	leaveq 
  80138b:	c3                   	retq   

000000000080138c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80138c:	55                   	push   %rbp
  80138d:	48 89 e5             	mov    %rsp,%rbp
  801390:	48 83 ec 18          	sub    $0x18,%rsp
  801394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80139c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a0:	eb 0f                	jmp    8013b1 <strncmp+0x25>
		n--, p++, q++;
  8013a2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ac:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013b6:	74 1d                	je     8013d5 <strncmp+0x49>
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 12                	je     8013d5 <strncmp+0x49>
  8013c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c7:	0f b6 10             	movzbl (%rax),%edx
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	38 c2                	cmp    %al,%dl
  8013d3:	74 cd                	je     8013a2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013da:	75 07                	jne    8013e3 <strncmp+0x57>
		return 0;
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e1:	eb 18                	jmp    8013fb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	0f b6 d0             	movzbl %al,%edx
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	0f b6 c0             	movzbl %al,%eax
  8013f7:	29 c2                	sub    %eax,%edx
  8013f9:	89 d0                	mov    %edx,%eax
}
  8013fb:	c9                   	leaveq 
  8013fc:	c3                   	retq   

00000000008013fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013fd:	55                   	push   %rbp
  8013fe:	48 89 e5             	mov    %rsp,%rbp
  801401:	48 83 ec 0c          	sub    $0xc,%rsp
  801405:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801409:	89 f0                	mov    %esi,%eax
  80140b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80140e:	eb 17                	jmp    801427 <strchr+0x2a>
		if (*s == c)
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80141a:	75 06                	jne    801422 <strchr+0x25>
			return (char *) s;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	eb 15                	jmp    801437 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801422:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	0f b6 00             	movzbl (%rax),%eax
  80142e:	84 c0                	test   %al,%al
  801430:	75 de                	jne    801410 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801437:	c9                   	leaveq 
  801438:	c3                   	retq   

0000000000801439 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801439:	55                   	push   %rbp
  80143a:	48 89 e5             	mov    %rsp,%rbp
  80143d:	48 83 ec 0c          	sub    $0xc,%rsp
  801441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801445:	89 f0                	mov    %esi,%eax
  801447:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144a:	eb 13                	jmp    80145f <strfind+0x26>
		if (*s == c)
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801456:	75 02                	jne    80145a <strfind+0x21>
			break;
  801458:	eb 10                	jmp    80146a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80145a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	84 c0                	test   %al,%al
  801468:	75 e2                	jne    80144c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80146e:	c9                   	leaveq 
  80146f:	c3                   	retq   

0000000000801470 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	48 83 ec 18          	sub    $0x18,%rsp
  801478:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80147f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801483:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801488:	75 06                	jne    801490 <memset+0x20>
		return v;
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	eb 69                	jmp    8014f9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801494:	83 e0 03             	and    $0x3,%eax
  801497:	48 85 c0             	test   %rax,%rax
  80149a:	75 48                	jne    8014e4 <memset+0x74>
  80149c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a0:	83 e0 03             	and    $0x3,%eax
  8014a3:	48 85 c0             	test   %rax,%rax
  8014a6:	75 3c                	jne    8014e4 <memset+0x74>
		c &= 0xFF;
  8014a8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	c1 e0 18             	shl    $0x18,%eax
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ba:	c1 e0 10             	shl    $0x10,%eax
  8014bd:	09 c2                	or     %eax,%edx
  8014bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c2:	c1 e0 08             	shl    $0x8,%eax
  8014c5:	09 d0                	or     %edx,%eax
  8014c7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ce:	48 c1 e8 02          	shr    $0x2,%rax
  8014d2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dc:	48 89 d7             	mov    %rdx,%rdi
  8014df:	fc                   	cld    
  8014e0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014e2:	eb 11                	jmp    8014f5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014ef:	48 89 d7             	mov    %rdx,%rdi
  8014f2:	fc                   	cld    
  8014f3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 28          	sub    $0x28,%rsp
  801503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801507:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80150f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801513:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80151f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801523:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801527:	0f 83 88 00 00 00    	jae    8015b5 <memmove+0xba>
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801535:	48 01 d0             	add    %rdx,%rax
  801538:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80153c:	76 77                	jbe    8015b5 <memmove+0xba>
		s += n;
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801552:	83 e0 03             	and    $0x3,%eax
  801555:	48 85 c0             	test   %rax,%rax
  801558:	75 3b                	jne    801595 <memmove+0x9a>
  80155a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155e:	83 e0 03             	and    $0x3,%eax
  801561:	48 85 c0             	test   %rax,%rax
  801564:	75 2f                	jne    801595 <memmove+0x9a>
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	83 e0 03             	and    $0x3,%eax
  80156d:	48 85 c0             	test   %rax,%rax
  801570:	75 23                	jne    801595 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801576:	48 83 e8 04          	sub    $0x4,%rax
  80157a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80157e:	48 83 ea 04          	sub    $0x4,%rdx
  801582:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801586:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80158a:	48 89 c7             	mov    %rax,%rdi
  80158d:	48 89 d6             	mov    %rdx,%rsi
  801590:	fd                   	std    
  801591:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801593:	eb 1d                	jmp    8015b2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	48 89 d7             	mov    %rdx,%rdi
  8015ac:	48 89 c1             	mov    %rax,%rcx
  8015af:	fd                   	std    
  8015b0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015b2:	fc                   	cld    
  8015b3:	eb 57                	jmp    80160c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 36                	jne    8015f7 <memmove+0xfc>
  8015c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c5:	83 e0 03             	and    $0x3,%eax
  8015c8:	48 85 c0             	test   %rax,%rax
  8015cb:	75 2a                	jne    8015f7 <memmove+0xfc>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	83 e0 03             	and    $0x3,%eax
  8015d4:	48 85 c0             	test   %rax,%rax
  8015d7:	75 1e                	jne    8015f7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 c1 e8 02          	shr    $0x2,%rax
  8015e1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ec:	48 89 c7             	mov    %rax,%rdi
  8015ef:	48 89 d6             	mov    %rdx,%rsi
  8015f2:	fc                   	cld    
  8015f3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015f5:	eb 15                	jmp    80160c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801603:	48 89 c7             	mov    %rax,%rdi
  801606:	48 89 d6             	mov    %rdx,%rsi
  801609:	fc                   	cld    
  80160a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80160c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801610:	c9                   	leaveq 
  801611:	c3                   	retq   

0000000000801612 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801612:	55                   	push   %rbp
  801613:	48 89 e5             	mov    %rsp,%rbp
  801616:	48 83 ec 18          	sub    $0x18,%rsp
  80161a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801622:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801626:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80162e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801632:	48 89 ce             	mov    %rcx,%rsi
  801635:	48 89 c7             	mov    %rax,%rdi
  801638:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  80163f:	00 00 00 
  801642:	ff d0                	callq  *%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 28          	sub    $0x28,%rsp
  80164e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801652:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801656:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80165a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801666:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80166a:	eb 36                	jmp    8016a2 <memcmp+0x5c>
		if (*s1 != *s2)
  80166c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801670:	0f b6 10             	movzbl (%rax),%edx
  801673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	38 c2                	cmp    %al,%dl
  80167c:	74 1a                	je     801698 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	0f b6 d0             	movzbl %al,%edx
  801688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	0f b6 c0             	movzbl %al,%eax
  801692:	29 c2                	sub    %eax,%edx
  801694:	89 d0                	mov    %edx,%eax
  801696:	eb 20                	jmp    8016b8 <memcmp+0x72>
		s1++, s2++;
  801698:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80169d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ae:	48 85 c0             	test   %rax,%rax
  8016b1:	75 b9                	jne    80166c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 28          	sub    $0x28,%rsp
  8016c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d5:	48 01 d0             	add    %rdx,%rax
  8016d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016dc:	eb 15                	jmp    8016f3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e2:	0f b6 10             	movzbl (%rax),%edx
  8016e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016e8:	38 c2                	cmp    %al,%dl
  8016ea:	75 02                	jne    8016ee <memfind+0x34>
			break;
  8016ec:	eb 0f                	jmp    8016fd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016fb:	72 e1                	jb     8016de <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 34          	sub    $0x34,%rsp
  80170b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801713:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801716:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80171d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801724:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801725:	eb 05                	jmp    80172c <strtol+0x29>
		s++;
  801727:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	3c 20                	cmp    $0x20,%al
  801735:	74 f0                	je     801727 <strtol+0x24>
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	0f b6 00             	movzbl (%rax),%eax
  80173e:	3c 09                	cmp    $0x9,%al
  801740:	74 e5                	je     801727 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 2b                	cmp    $0x2b,%al
  80174b:	75 07                	jne    801754 <strtol+0x51>
		s++;
  80174d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801752:	eb 17                	jmp    80176b <strtol+0x68>
	else if (*s == '-')
  801754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801758:	0f b6 00             	movzbl (%rax),%eax
  80175b:	3c 2d                	cmp    $0x2d,%al
  80175d:	75 0c                	jne    80176b <strtol+0x68>
		s++, neg = 1;
  80175f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801764:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80176b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80176f:	74 06                	je     801777 <strtol+0x74>
  801771:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801775:	75 28                	jne    80179f <strtol+0x9c>
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	3c 30                	cmp    $0x30,%al
  801780:	75 1d                	jne    80179f <strtol+0x9c>
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	48 83 c0 01          	add    $0x1,%rax
  80178a:	0f b6 00             	movzbl (%rax),%eax
  80178d:	3c 78                	cmp    $0x78,%al
  80178f:	75 0e                	jne    80179f <strtol+0x9c>
		s += 2, base = 16;
  801791:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801796:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80179d:	eb 2c                	jmp    8017cb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80179f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a3:	75 19                	jne    8017be <strtol+0xbb>
  8017a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a9:	0f b6 00             	movzbl (%rax),%eax
  8017ac:	3c 30                	cmp    $0x30,%al
  8017ae:	75 0e                	jne    8017be <strtol+0xbb>
		s++, base = 8;
  8017b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017bc:	eb 0d                	jmp    8017cb <strtol+0xc8>
	else if (base == 0)
  8017be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c2:	75 07                	jne    8017cb <strtol+0xc8>
		base = 10;
  8017c4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	3c 2f                	cmp    $0x2f,%al
  8017d4:	7e 1d                	jle    8017f3 <strtol+0xf0>
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	3c 39                	cmp    $0x39,%al
  8017df:	7f 12                	jg     8017f3 <strtol+0xf0>
			dig = *s - '0';
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	0f b6 00             	movzbl (%rax),%eax
  8017e8:	0f be c0             	movsbl %al,%eax
  8017eb:	83 e8 30             	sub    $0x30,%eax
  8017ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f1:	eb 4e                	jmp    801841 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	3c 60                	cmp    $0x60,%al
  8017fc:	7e 1d                	jle    80181b <strtol+0x118>
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	0f b6 00             	movzbl (%rax),%eax
  801805:	3c 7a                	cmp    $0x7a,%al
  801807:	7f 12                	jg     80181b <strtol+0x118>
			dig = *s - 'a' + 10;
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	0f be c0             	movsbl %al,%eax
  801813:	83 e8 57             	sub    $0x57,%eax
  801816:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801819:	eb 26                	jmp    801841 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 48                	jle    80186e <strtol+0x16b>
  801826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182a:	0f b6 00             	movzbl (%rax),%eax
  80182d:	3c 5a                	cmp    $0x5a,%al
  80182f:	7f 3d                	jg     80186e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	0f b6 00             	movzbl (%rax),%eax
  801838:	0f be c0             	movsbl %al,%eax
  80183b:	83 e8 37             	sub    $0x37,%eax
  80183e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801841:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801844:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801847:	7c 02                	jl     80184b <strtol+0x148>
			break;
  801849:	eb 23                	jmp    80186e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80184b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801850:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801853:	48 98                	cltq   
  801855:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80185a:	48 89 c2             	mov    %rax,%rdx
  80185d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801860:	48 98                	cltq   
  801862:	48 01 d0             	add    %rdx,%rax
  801865:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801869:	e9 5d ff ff ff       	jmpq   8017cb <strtol+0xc8>

	if (endptr)
  80186e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801873:	74 0b                	je     801880 <strtol+0x17d>
		*endptr = (char *) s;
  801875:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801879:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80187d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801884:	74 09                	je     80188f <strtol+0x18c>
  801886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188a:	48 f7 d8             	neg    %rax
  80188d:	eb 04                	jmp    801893 <strtol+0x190>
  80188f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <strstr>:

char * strstr(const char *in, const char *str)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 30          	sub    $0x30,%rsp
  80189d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b1:	0f b6 00             	movzbl (%rax),%eax
  8018b4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018b7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018bb:	75 06                	jne    8018c3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	eb 6b                	jmp    80192e <strstr+0x99>

	len = strlen(str);
  8018c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c7:	48 89 c7             	mov    %rax,%rdi
  8018ca:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  8018d1:	00 00 00 
  8018d4:	ff d0                	callq  *%rax
  8018d6:	48 98                	cltq   
  8018d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018e8:	0f b6 00             	movzbl (%rax),%eax
  8018eb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018f2:	75 07                	jne    8018fb <strstr+0x66>
				return (char *) 0;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	eb 33                	jmp    80192e <strstr+0x99>
		} while (sc != c);
  8018fb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018ff:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801902:	75 d8                	jne    8018dc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801904:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801908:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	48 89 ce             	mov    %rcx,%rsi
  801913:	48 89 c7             	mov    %rax,%rdi
  801916:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  80191d:	00 00 00 
  801920:	ff d0                	callq  *%rax
  801922:	85 c0                	test   %eax,%eax
  801924:	75 b6                	jne    8018dc <strstr+0x47>

	return (char *) (in - 1);
  801926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192a:	48 83 e8 01          	sub    $0x1,%rax
}
  80192e:	c9                   	leaveq 
  80192f:	c3                   	retq   

0000000000801930 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	53                   	push   %rbx
  801935:	48 83 ec 48          	sub    $0x48,%rsp
  801939:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80193c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80193f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801943:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801947:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80194b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80194f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801952:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801956:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80195a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80195e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801962:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801966:	4c 89 c3             	mov    %r8,%rbx
  801969:	cd 30                	int    $0x30
  80196b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80196f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801973:	74 3e                	je     8019b3 <syscall+0x83>
  801975:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80197a:	7e 37                	jle    8019b3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80197c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801980:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801983:	49 89 d0             	mov    %rdx,%r8
  801986:	89 c1                	mov    %eax,%ecx
  801988:	48 ba 08 50 80 00 00 	movabs $0x805008,%rdx
  80198f:	00 00 00 
  801992:	be 23 00 00 00       	mov    $0x23,%esi
  801997:	48 bf 25 50 80 00 00 	movabs $0x805025,%rdi
  80199e:	00 00 00 
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a6:	49 b9 e9 03 80 00 00 	movabs $0x8003e9,%r9
  8019ad:	00 00 00 
  8019b0:	41 ff d1             	callq  *%r9

	return ret;
  8019b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019b7:	48 83 c4 48          	add    $0x48,%rsp
  8019bb:	5b                   	pop    %rbx
  8019bc:	5d                   	pop    %rbp
  8019bd:	c3                   	retq   

00000000008019be <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	48 83 ec 20          	sub    $0x20,%rsp
  8019c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dd:	00 
  8019de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ea:	48 89 d1             	mov    %rdx,%rcx
  8019ed:	48 89 c2             	mov    %rax,%rdx
  8019f0:	be 00 00 00 00       	mov    $0x0,%esi
  8019f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019fa:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a17:	00 
  801a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	be 00 00 00 00       	mov    $0x0,%esi
  801a33:	bf 01 00 00 00       	mov    $0x1,%edi
  801a38:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	48 83 ec 10          	sub    $0x10,%rsp
  801a4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a54:	48 98                	cltq   
  801a56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5d:	00 
  801a5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6f:	48 89 c2             	mov    %rax,%rdx
  801a72:	be 01 00 00 00       	mov    $0x1,%esi
  801a77:	bf 03 00 00 00       	mov    $0x3,%edi
  801a7c:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	callq  *%rax
}
  801a88:	c9                   	leaveq 
  801a89:	c3                   	retq   

0000000000801a8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a8a:	55                   	push   %rbp
  801a8b:	48 89 e5             	mov    %rsp,%rbp
  801a8e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a99:	00 
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	be 00 00 00 00       	mov    $0x0,%esi
  801ab5:	bf 02 00 00 00       	mov    $0x2,%edi
  801aba:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <sys_yield>:

void
sys_yield(void)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ad0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad7:	00 
  801ad8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ade:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  801aee:	be 00 00 00 00       	mov    $0x0,%esi
  801af3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801af8:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	callq  *%rax
}
  801b04:	c9                   	leaveq 
  801b05:	c3                   	retq   

0000000000801b06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b06:	55                   	push   %rbp
  801b07:	48 89 e5             	mov    %rsp,%rbp
  801b0a:	48 83 ec 20          	sub    $0x20,%rsp
  801b0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b15:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1b:	48 63 c8             	movslq %eax,%rcx
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	49 89 c8             	mov    %rcx,%r8
  801b38:	48 89 d1             	mov    %rdx,%rcx
  801b3b:	48 89 c2             	mov    %rax,%rdx
  801b3e:	be 01 00 00 00       	mov    $0x1,%esi
  801b43:	bf 04 00 00 00       	mov    $0x4,%edi
  801b48:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
}
  801b54:	c9                   	leaveq 
  801b55:	c3                   	retq   

0000000000801b56 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	48 83 ec 30          	sub    $0x30,%rsp
  801b5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b65:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b68:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b6c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b70:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b73:	48 63 c8             	movslq %eax,%rcx
  801b76:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7d:	48 63 f0             	movslq %eax,%rsi
  801b80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b87:	48 98                	cltq   
  801b89:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b8d:	49 89 f9             	mov    %rdi,%r9
  801b90:	49 89 f0             	mov    %rsi,%r8
  801b93:	48 89 d1             	mov    %rdx,%rcx
  801b96:	48 89 c2             	mov    %rax,%rdx
  801b99:	be 01 00 00 00       	mov    $0x1,%esi
  801b9e:	bf 05 00 00 00       	mov    $0x5,%edi
  801ba3:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
}
  801baf:	c9                   	leaveq 
  801bb0:	c3                   	retq   

0000000000801bb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
  801bb5:	48 83 ec 20          	sub    $0x20,%rsp
  801bb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc7:	48 98                	cltq   
  801bc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd0:	00 
  801bd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdd:	48 89 d1             	mov    %rdx,%rcx
  801be0:	48 89 c2             	mov    %rax,%rdx
  801be3:	be 01 00 00 00       	mov    $0x1,%esi
  801be8:	bf 06 00 00 00       	mov    $0x6,%edi
  801bed:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801bf4:	00 00 00 
  801bf7:	ff d0                	callq  *%rax
}
  801bf9:	c9                   	leaveq 
  801bfa:	c3                   	retq   

0000000000801bfb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	48 83 ec 10          	sub    $0x10,%rsp
  801c03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c06:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c0c:	48 63 d0             	movslq %eax,%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1b:	00 
  801c1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c28:	48 89 d1             	mov    %rdx,%rcx
  801c2b:	48 89 c2             	mov    %rax,%rdx
  801c2e:	be 01 00 00 00       	mov    $0x1,%esi
  801c33:	bf 08 00 00 00       	mov    $0x8,%edi
  801c38:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	48 83 ec 20          	sub    $0x20,%rsp
  801c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5c:	48 98                	cltq   
  801c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c65:	00 
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	48 89 d1             	mov    %rdx,%rcx
  801c75:	48 89 c2             	mov    %rax,%rdx
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c82:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 20          	sub    $0x20,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca6:	48 98                	cltq   
  801ca8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caf:	00 
  801cb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbc:	48 89 d1             	mov    %rdx,%rcx
  801cbf:	48 89 c2             	mov    %rax,%rdx
  801cc2:	be 01 00 00 00       	mov    $0x1,%esi
  801cc7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ccc:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 20          	sub    $0x20,%rsp
  801ce2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ced:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf3:	48 63 f0             	movslq %eax,%rsi
  801cf6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	48 98                	cltq   
  801cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d03:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0a:	00 
  801d0b:	49 89 f1             	mov    %rsi,%r9
  801d0e:	49 89 c8             	mov    %rcx,%r8
  801d11:	48 89 d1             	mov    %rdx,%rcx
  801d14:	48 89 c2             	mov    %rax,%rdx
  801d17:	be 00 00 00 00       	mov    $0x0,%esi
  801d1c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d21:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	48 83 ec 10          	sub    $0x10,%rsp
  801d37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d46:	00 
  801d47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d53:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d58:	48 89 c2             	mov    %rax,%rdx
  801d5b:	be 01 00 00 00       	mov    $0x1,%esi
  801d60:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d65:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
}
  801d71:	c9                   	leaveq 
  801d72:	c3                   	retq   

0000000000801d73 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d73:	55                   	push   %rbp
  801d74:	48 89 e5             	mov    %rsp,%rbp
  801d77:	48 83 ec 20          	sub    $0x20,%rsp
  801d7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d92:	00 
  801d93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9f:	48 89 d1             	mov    %rdx,%rcx
  801da2:	48 89 c2             	mov    %rax,%rdx
  801da5:	be 01 00 00 00       	mov    $0x1,%esi
  801daa:	bf 0f 00 00 00       	mov    $0xf,%edi
  801daf:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801db6:	00 00 00 
  801db9:	ff d0                	callq  *%rax
}
  801dbb:	c9                   	leaveq 
  801dbc:	c3                   	retq   

0000000000801dbd <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801dbd:	55                   	push   %rbp
  801dbe:	48 89 e5             	mov    %rsp,%rbp
  801dc1:	48 83 ec 10          	sub    $0x10,%rsp
  801dc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd4:	00 
  801dd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ddb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de6:	48 89 c2             	mov    %rax,%rdx
  801de9:	be 00 00 00 00       	mov    $0x0,%esi
  801dee:	bf 10 00 00 00       	mov    $0x10,%edi
  801df3:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801dfa:	00 00 00 
  801dfd:	ff d0                	callq  *%rax
}
  801dff:	c9                   	leaveq 
  801e00:	c3                   	retq   

0000000000801e01 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	be 00 00 00 00       	mov    $0x0,%esi
  801e2c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e31:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 30          	sub    $0x30,%rsp
  801e47:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4f:	48 8b 00             	mov    (%rax),%rax
  801e52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e5e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e61:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e64:	83 e0 02             	and    $0x2,%eax
  801e67:	85 c0                	test   %eax,%eax
  801e69:	75 4d                	jne    801eb8 <pgfault+0x79>
  801e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6f:	48 c1 e8 0c          	shr    $0xc,%rax
  801e73:	48 89 c2             	mov    %rax,%rdx
  801e76:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7d:	01 00 00 
  801e80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e84:	25 00 08 00 00       	and    $0x800,%eax
  801e89:	48 85 c0             	test   %rax,%rax
  801e8c:	74 2a                	je     801eb8 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e8e:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  801e95:	00 00 00 
  801e98:	be 23 00 00 00       	mov    $0x23,%esi
  801e9d:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  801ea4:	00 00 00 
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801eb3:	00 00 00 
  801eb6:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801eb8:	ba 07 00 00 00       	mov    $0x7,%edx
  801ebd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ec2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec7:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 85 cd 00 00 00    	jne    801fa8 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801eed:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801ef1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801efa:	48 89 c6             	mov    %rax,%rsi
  801efd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f02:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  801f09:	00 00 00 
  801f0c:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f12:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f18:	48 89 c1             	mov    %rax,%rcx
  801f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f20:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f25:	bf 00 00 00 00       	mov    $0x0,%edi
  801f2a:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  801f31:	00 00 00 
  801f34:	ff d0                	callq  *%rax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	79 2a                	jns    801f64 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f3a:	48 ba 78 50 80 00 00 	movabs $0x805078,%rdx
  801f41:	00 00 00 
  801f44:	be 30 00 00 00       	mov    $0x30,%esi
  801f49:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  801f50:	00 00 00 
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801f5f:	00 00 00 
  801f62:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f64:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f69:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6e:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	79 54                	jns    801fd2 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f7e:	48 ba 98 50 80 00 00 	movabs $0x805098,%rdx
  801f85:	00 00 00 
  801f88:	be 32 00 00 00       	mov    $0x32,%esi
  801f8d:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  801f94:	00 00 00 
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801fa3:	00 00 00 
  801fa6:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801fa8:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801faf:	00 00 00 
  801fb2:	be 34 00 00 00       	mov    $0x34,%esi
  801fb7:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  801fbe:	00 00 00 
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  801fcd:	00 00 00 
  801fd0:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fd2:	c9                   	leaveq 
  801fd3:	c3                   	retq   

0000000000801fd4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fd4:	55                   	push   %rbp
  801fd5:	48 89 e5             	mov    %rsp,%rbp
  801fd8:	48 83 ec 20          	sub    $0x20,%rsp
  801fdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fdf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801fe2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe9:	01 00 00 
  801fec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff3:	25 07 0e 00 00       	and    $0xe07,%eax
  801ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801ffb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ffe:	48 c1 e0 0c          	shl    $0xc,%rax
  802002:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802009:	25 00 04 00 00       	and    $0x400,%eax
  80200e:	85 c0                	test   %eax,%eax
  802010:	74 57                	je     802069 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802012:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802015:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802019:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80201c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802020:	41 89 f0             	mov    %esi,%r8d
  802023:	48 89 c6             	mov    %rax,%rsi
  802026:	bf 00 00 00 00       	mov    $0x0,%edi
  80202b:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
  802037:	85 c0                	test   %eax,%eax
  802039:	0f 8e 52 01 00 00    	jle    802191 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80203f:	48 ba f2 50 80 00 00 	movabs $0x8050f2,%rdx
  802046:	00 00 00 
  802049:	be 4e 00 00 00       	mov    $0x4e,%esi
  80204e:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  802055:	00 00 00 
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
  80205d:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  802064:	00 00 00 
  802067:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206c:	83 e0 02             	and    $0x2,%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	75 10                	jne    802083 <duppage+0xaf>
  802073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802076:	25 00 08 00 00       	and    $0x800,%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	0f 84 bb 00 00 00    	je     80213e <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802086:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80208b:	80 cc 08             	or     $0x8,%ah
  80208e:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802091:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802094:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802098:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80209b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209f:	41 89 f0             	mov    %esi,%r8d
  8020a2:	48 89 c6             	mov    %rax,%rsi
  8020a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020aa:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8020b1:	00 00 00 
  8020b4:	ff d0                	callq  *%rax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	7e 2a                	jle    8020e4 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020ba:	48 ba f2 50 80 00 00 	movabs $0x8050f2,%rdx
  8020c1:	00 00 00 
  8020c4:	be 55 00 00 00       	mov    $0x55,%esi
  8020c9:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  8020d0:	00 00 00 
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d8:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  8020df:	00 00 00 
  8020e2:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020e4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ef:	41 89 c8             	mov    %ecx,%r8d
  8020f2:	48 89 d1             	mov    %rdx,%rcx
  8020f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fa:	48 89 c6             	mov    %rax,%rsi
  8020fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802102:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802109:	00 00 00 
  80210c:	ff d0                	callq  *%rax
  80210e:	85 c0                	test   %eax,%eax
  802110:	7e 2a                	jle    80213c <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802112:	48 ba f2 50 80 00 00 	movabs $0x8050f2,%rdx
  802119:	00 00 00 
  80211c:	be 57 00 00 00       	mov    $0x57,%esi
  802121:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  802128:	00 00 00 
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  802137:	00 00 00 
  80213a:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80213c:	eb 53                	jmp    802191 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80213e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802141:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802145:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802148:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214c:	41 89 f0             	mov    %esi,%r8d
  80214f:	48 89 c6             	mov    %rax,%rsi
  802152:	bf 00 00 00 00       	mov    $0x0,%edi
  802157:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  80215e:	00 00 00 
  802161:	ff d0                	callq  *%rax
  802163:	85 c0                	test   %eax,%eax
  802165:	7e 2a                	jle    802191 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802167:	48 ba f2 50 80 00 00 	movabs $0x8050f2,%rdx
  80216e:	00 00 00 
  802171:	be 5b 00 00 00       	mov    $0x5b,%esi
  802176:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  80217d:	00 00 00 
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  80218c:	00 00 00 
  80218f:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802196:	c9                   	leaveq 
  802197:	c3                   	retq   

0000000000802198 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802198:	55                   	push   %rbp
  802199:	48 89 e5             	mov    %rsp,%rbp
  80219c:	48 83 ec 18          	sub    $0x18,%rsp
  8021a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b0:	48 c1 e8 27          	shr    $0x27,%rax
  8021b4:	48 89 c2             	mov    %rax,%rdx
  8021b7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021be:	01 00 00 
  8021c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c5:	83 e0 01             	and    $0x1,%eax
  8021c8:	48 85 c0             	test   %rax,%rax
  8021cb:	74 51                	je     80221e <pt_is_mapped+0x86>
  8021cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8021d5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021d9:	48 89 c2             	mov    %rax,%rdx
  8021dc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021e3:	01 00 00 
  8021e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ea:	83 e0 01             	and    $0x1,%eax
  8021ed:	48 85 c0             	test   %rax,%rax
  8021f0:	74 2c                	je     80221e <pt_is_mapped+0x86>
  8021f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8021fa:	48 c1 e8 15          	shr    $0x15,%rax
  8021fe:	48 89 c2             	mov    %rax,%rdx
  802201:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802208:	01 00 00 
  80220b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220f:	83 e0 01             	and    $0x1,%eax
  802212:	48 85 c0             	test   %rax,%rax
  802215:	74 07                	je     80221e <pt_is_mapped+0x86>
  802217:	b8 01 00 00 00       	mov    $0x1,%eax
  80221c:	eb 05                	jmp    802223 <pt_is_mapped+0x8b>
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	83 e0 01             	and    $0x1,%eax
}
  802226:	c9                   	leaveq 
  802227:	c3                   	retq   

0000000000802228 <fork>:

envid_t
fork(void)
{
  802228:	55                   	push   %rbp
  802229:	48 89 e5             	mov    %rsp,%rbp
  80222c:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802230:	48 bf 3f 1e 80 00 00 	movabs $0x801e3f,%rdi
  802237:	00 00 00 
  80223a:	48 b8 02 46 80 00 00 	movabs $0x804602,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802246:	b8 07 00 00 00       	mov    $0x7,%eax
  80224b:	cd 30                	int    $0x30
  80224d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802250:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802253:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80225a:	79 30                	jns    80228c <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80225c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80225f:	89 c1                	mov    %eax,%ecx
  802261:	48 ba 10 51 80 00 00 	movabs $0x805110,%rdx
  802268:	00 00 00 
  80226b:	be 86 00 00 00       	mov    $0x86,%esi
  802270:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  802277:	00 00 00 
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  802286:	00 00 00 
  802289:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802290:	75 46                	jne    8022d8 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802292:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
  80229e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022a3:	48 63 d0             	movslq %eax,%rdx
  8022a6:	48 89 d0             	mov    %rdx,%rax
  8022a9:	48 c1 e0 03          	shl    $0x3,%rax
  8022ad:	48 01 d0             	add    %rdx,%rax
  8022b0:	48 c1 e0 05          	shl    $0x5,%rax
  8022b4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022bb:	00 00 00 
  8022be:	48 01 c2             	add    %rax,%rdx
  8022c1:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8022c8:	00 00 00 
  8022cb:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	e9 d1 01 00 00       	jmpq   8024a9 <fork+0x281>
	}
	uint64_t ad = 0;
  8022d8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022df:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022e0:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022e9:	e9 df 00 00 00       	jmpq   8023cd <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f2:	48 c1 e8 27          	shr    $0x27,%rax
  8022f6:	48 89 c2             	mov    %rax,%rdx
  8022f9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802300:	01 00 00 
  802303:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802307:	83 e0 01             	and    $0x1,%eax
  80230a:	48 85 c0             	test   %rax,%rax
  80230d:	0f 84 9e 00 00 00    	je     8023b1 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802317:	48 c1 e8 1e          	shr    $0x1e,%rax
  80231b:	48 89 c2             	mov    %rax,%rdx
  80231e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802325:	01 00 00 
  802328:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80232c:	83 e0 01             	and    $0x1,%eax
  80232f:	48 85 c0             	test   %rax,%rax
  802332:	74 73                	je     8023a7 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802338:	48 c1 e8 15          	shr    $0x15,%rax
  80233c:	48 89 c2             	mov    %rax,%rdx
  80233f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802346:	01 00 00 
  802349:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234d:	83 e0 01             	and    $0x1,%eax
  802350:	48 85 c0             	test   %rax,%rax
  802353:	74 48                	je     80239d <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802359:	48 c1 e8 0c          	shr    $0xc,%rax
  80235d:	48 89 c2             	mov    %rax,%rdx
  802360:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802367:	01 00 00 
  80236a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80236e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	83 e0 01             	and    $0x1,%eax
  802379:	48 85 c0             	test   %rax,%rax
  80237c:	74 47                	je     8023c5 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80237e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802382:	48 c1 e8 0c          	shr    $0xc,%rax
  802386:	89 c2                	mov    %eax,%edx
  802388:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80238b:	89 d6                	mov    %edx,%esi
  80238d:	89 c7                	mov    %eax,%edi
  80238f:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
  80239b:	eb 28                	jmp    8023c5 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80239d:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023a4:	00 
  8023a5:	eb 1e                	jmp    8023c5 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023a7:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8023ae:	40 
  8023af:	eb 14                	jmp    8023c5 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8023b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b5:	48 c1 e8 27          	shr    $0x27,%rax
  8023b9:	48 83 c0 01          	add    $0x1,%rax
  8023bd:	48 c1 e0 27          	shl    $0x27,%rax
  8023c1:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023c5:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023cc:	00 
  8023cd:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023d4:	00 
  8023d5:	0f 87 13 ff ff ff    	ja     8022ee <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023de:	ba 07 00 00 00       	mov    $0x7,%edx
  8023e3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023e8:	89 c7                	mov    %eax,%edi
  8023ea:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8023fe:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802403:	89 c7                	mov    %eax,%edi
  802405:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  80240c:	00 00 00 
  80240f:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802411:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802414:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80241a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80241f:	ba 00 00 00 00       	mov    $0x0,%edx
  802424:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802429:	89 c7                	mov    %eax,%edi
  80242b:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802432:	00 00 00 
  802435:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802437:	ba 00 10 00 00       	mov    $0x1000,%edx
  80243c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802441:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802446:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802452:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802457:	bf 00 00 00 00       	mov    $0x0,%edi
  80245c:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802468:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80246f:	00 00 00 
  802472:	48 8b 00             	mov    (%rax),%rax
  802475:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80247c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80247f:	48 89 d6             	mov    %rdx,%rsi
  802482:	89 c7                	mov    %eax,%edi
  802484:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802490:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802493:	be 02 00 00 00       	mov    $0x2,%esi
  802498:	89 c7                	mov    %eax,%edi
  80249a:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax

	return envid;
  8024a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024a9:	c9                   	leaveq 
  8024aa:	c3                   	retq   

00000000008024ab <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024ab:	55                   	push   %rbp
  8024ac:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024af:	48 ba 28 51 80 00 00 	movabs $0x805128,%rdx
  8024b6:	00 00 00 
  8024b9:	be bf 00 00 00       	mov    $0xbf,%esi
  8024be:	48 bf 6d 50 80 00 00 	movabs $0x80506d,%rdi
  8024c5:	00 00 00 
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  8024d4:	00 00 00 
  8024d7:	ff d1                	callq  *%rcx

00000000008024d9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024d9:	55                   	push   %rbp
  8024da:	48 89 e5             	mov    %rsp,%rbp
  8024dd:	48 83 ec 08          	sub    $0x8,%rsp
  8024e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024e9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024f0:	ff ff ff 
  8024f3:	48 01 d0             	add    %rdx,%rax
  8024f6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024fa:	c9                   	leaveq 
  8024fb:	c3                   	retq   

00000000008024fc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024fc:	55                   	push   %rbp
  8024fd:	48 89 e5             	mov    %rsp,%rbp
  802500:	48 83 ec 08          	sub    $0x8,%rsp
  802504:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80250c:	48 89 c7             	mov    %rax,%rdi
  80250f:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  802516:	00 00 00 
  802519:	ff d0                	callq  *%rax
  80251b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802521:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802525:	c9                   	leaveq 
  802526:	c3                   	retq   

0000000000802527 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802527:	55                   	push   %rbp
  802528:	48 89 e5             	mov    %rsp,%rbp
  80252b:	48 83 ec 18          	sub    $0x18,%rsp
  80252f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802533:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80253a:	eb 6b                	jmp    8025a7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80253c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253f:	48 98                	cltq   
  802541:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802547:	48 c1 e0 0c          	shl    $0xc,%rax
  80254b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80254f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802553:	48 c1 e8 15          	shr    $0x15,%rax
  802557:	48 89 c2             	mov    %rax,%rdx
  80255a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802561:	01 00 00 
  802564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802568:	83 e0 01             	and    $0x1,%eax
  80256b:	48 85 c0             	test   %rax,%rax
  80256e:	74 21                	je     802591 <fd_alloc+0x6a>
  802570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802574:	48 c1 e8 0c          	shr    $0xc,%rax
  802578:	48 89 c2             	mov    %rax,%rdx
  80257b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802582:	01 00 00 
  802585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802589:	83 e0 01             	and    $0x1,%eax
  80258c:	48 85 c0             	test   %rax,%rax
  80258f:	75 12                	jne    8025a3 <fd_alloc+0x7c>
			*fd_store = fd;
  802591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802595:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802599:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	eb 1a                	jmp    8025bd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025a7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025ab:	7e 8f                	jle    80253c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025b8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025bd:	c9                   	leaveq 
  8025be:	c3                   	retq   

00000000008025bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025bf:	55                   	push   %rbp
  8025c0:	48 89 e5             	mov    %rsp,%rbp
  8025c3:	48 83 ec 20          	sub    $0x20,%rsp
  8025c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025d2:	78 06                	js     8025da <fd_lookup+0x1b>
  8025d4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025d8:	7e 07                	jle    8025e1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025df:	eb 6c                	jmp    80264d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025e4:	48 98                	cltq   
  8025e6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025ec:	48 c1 e0 0c          	shl    $0xc,%rax
  8025f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f8:	48 c1 e8 15          	shr    $0x15,%rax
  8025fc:	48 89 c2             	mov    %rax,%rdx
  8025ff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802606:	01 00 00 
  802609:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260d:	83 e0 01             	and    $0x1,%eax
  802610:	48 85 c0             	test   %rax,%rax
  802613:	74 21                	je     802636 <fd_lookup+0x77>
  802615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802619:	48 c1 e8 0c          	shr    $0xc,%rax
  80261d:	48 89 c2             	mov    %rax,%rdx
  802620:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802627:	01 00 00 
  80262a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80262e:	83 e0 01             	and    $0x1,%eax
  802631:	48 85 c0             	test   %rax,%rax
  802634:	75 07                	jne    80263d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802636:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80263b:	eb 10                	jmp    80264d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80263d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802641:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802645:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leaveq 
  80264e:	c3                   	retq   

000000000080264f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80264f:	55                   	push   %rbp
  802650:	48 89 e5             	mov    %rsp,%rbp
  802653:	48 83 ec 30          	sub    $0x30,%rsp
  802657:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80265b:	89 f0                	mov    %esi,%eax
  80265d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802664:	48 89 c7             	mov    %rax,%rdi
  802667:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
  802673:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802677:	48 89 d6             	mov    %rdx,%rsi
  80267a:	89 c7                	mov    %eax,%edi
  80267c:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
  802688:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268f:	78 0a                	js     80269b <fd_close+0x4c>
	    || fd != fd2)
  802691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802695:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802699:	74 12                	je     8026ad <fd_close+0x5e>
		return (must_exist ? r : 0);
  80269b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80269f:	74 05                	je     8026a6 <fd_close+0x57>
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	eb 05                	jmp    8026ab <fd_close+0x5c>
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	eb 69                	jmp    802716 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b1:	8b 00                	mov    (%rax),%eax
  8026b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026b7:	48 89 d6             	mov    %rdx,%rsi
  8026ba:	89 c7                	mov    %eax,%edi
  8026bc:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cf:	78 2a                	js     8026fb <fd_close+0xac>
		if (dev->dev_close)
  8026d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026d9:	48 85 c0             	test   %rax,%rax
  8026dc:	74 16                	je     8026f4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ea:	48 89 d7             	mov    %rdx,%rdi
  8026ed:	ff d0                	callq  *%rax
  8026ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f2:	eb 07                	jmp    8026fb <fd_close+0xac>
		else
			r = 0;
  8026f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ff:	48 89 c6             	mov    %rax,%rsi
  802702:	bf 00 00 00 00       	mov    $0x0,%edi
  802707:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
	return r;
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802716:	c9                   	leaveq 
  802717:	c3                   	retq   

0000000000802718 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802718:	55                   	push   %rbp
  802719:	48 89 e5             	mov    %rsp,%rbp
  80271c:	48 83 ec 20          	sub    $0x20,%rsp
  802720:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802723:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802727:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80272e:	eb 41                	jmp    802771 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802730:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802737:	00 00 00 
  80273a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80273d:	48 63 d2             	movslq %edx,%rdx
  802740:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802744:	8b 00                	mov    (%rax),%eax
  802746:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802749:	75 22                	jne    80276d <dev_lookup+0x55>
			*dev = devtab[i];
  80274b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802752:	00 00 00 
  802755:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802758:	48 63 d2             	movslq %edx,%rdx
  80275b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80275f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802763:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	eb 60                	jmp    8027cd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80276d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802771:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802778:	00 00 00 
  80277b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80277e:	48 63 d2             	movslq %edx,%rdx
  802781:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802785:	48 85 c0             	test   %rax,%rax
  802788:	75 a6                	jne    802730 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80278a:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802791:	00 00 00 
  802794:	48 8b 00             	mov    (%rax),%rax
  802797:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80279d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027a0:	89 c6                	mov    %eax,%esi
  8027a2:	48 bf 40 51 80 00 00 	movabs $0x805140,%rdi
  8027a9:	00 00 00 
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b1:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  8027b8:	00 00 00 
  8027bb:	ff d1                	callq  *%rcx
	*dev = 0;
  8027bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027cd:	c9                   	leaveq 
  8027ce:	c3                   	retq   

00000000008027cf <close>:

int
close(int fdnum)
{
  8027cf:	55                   	push   %rbp
  8027d0:	48 89 e5             	mov    %rsp,%rbp
  8027d3:	48 83 ec 20          	sub    $0x20,%rsp
  8027d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e1:	48 89 d6             	mov    %rdx,%rsi
  8027e4:	89 c7                	mov    %eax,%edi
  8027e6:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  8027ed:	00 00 00 
  8027f0:	ff d0                	callq  *%rax
  8027f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f9:	79 05                	jns    802800 <close+0x31>
		return r;
  8027fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fe:	eb 18                	jmp    802818 <close+0x49>
	else
		return fd_close(fd, 1);
  802800:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802804:	be 01 00 00 00       	mov    $0x1,%esi
  802809:	48 89 c7             	mov    %rax,%rdi
  80280c:	48 b8 4f 26 80 00 00 	movabs $0x80264f,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <close_all>:

void
close_all(void)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802829:	eb 15                	jmp    802840 <close_all+0x26>
		close(i);
  80282b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282e:	89 c7                	mov    %eax,%edi
  802830:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80283c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802840:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802844:	7e e5                	jle    80282b <close_all+0x11>
		close(i);
}
  802846:	c9                   	leaveq 
  802847:	c3                   	retq   

0000000000802848 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802848:	55                   	push   %rbp
  802849:	48 89 e5             	mov    %rsp,%rbp
  80284c:	48 83 ec 40          	sub    $0x40,%rsp
  802850:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802853:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802856:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80285a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80285d:	48 89 d6             	mov    %rdx,%rsi
  802860:	89 c7                	mov    %eax,%edi
  802862:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802871:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802875:	79 08                	jns    80287f <dup+0x37>
		return r;
  802877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287a:	e9 70 01 00 00       	jmpq   8029ef <dup+0x1a7>
	close(newfdnum);
  80287f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802882:	89 c7                	mov    %eax,%edi
  802884:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  80288b:	00 00 00 
  80288e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802890:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802893:	48 98                	cltq   
  802895:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80289b:	48 c1 e0 0c          	shl    $0xc,%rax
  80289f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a7:	48 89 c7             	mov    %rax,%rdi
  8028aa:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
  8028b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028be:	48 89 c7             	mov    %rax,%rdi
  8028c1:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	callq  *%rax
  8028cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d5:	48 c1 e8 15          	shr    $0x15,%rax
  8028d9:	48 89 c2             	mov    %rax,%rdx
  8028dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028e3:	01 00 00 
  8028e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ea:	83 e0 01             	and    $0x1,%eax
  8028ed:	48 85 c0             	test   %rax,%rax
  8028f0:	74 73                	je     802965 <dup+0x11d>
  8028f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8028fa:	48 89 c2             	mov    %rax,%rdx
  8028fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802904:	01 00 00 
  802907:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290b:	83 e0 01             	and    $0x1,%eax
  80290e:	48 85 c0             	test   %rax,%rax
  802911:	74 52                	je     802965 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 c1 e8 0c          	shr    $0xc,%rax
  80291b:	48 89 c2             	mov    %rax,%rdx
  80291e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802925:	01 00 00 
  802928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292c:	25 07 0e 00 00       	and    $0xe07,%eax
  802931:	89 c1                	mov    %eax,%ecx
  802933:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293b:	41 89 c8             	mov    %ecx,%r8d
  80293e:	48 89 d1             	mov    %rdx,%rcx
  802941:	ba 00 00 00 00       	mov    $0x0,%edx
  802946:	48 89 c6             	mov    %rax,%rsi
  802949:	bf 00 00 00 00       	mov    $0x0,%edi
  80294e:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  802955:	00 00 00 
  802958:	ff d0                	callq  *%rax
  80295a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802961:	79 02                	jns    802965 <dup+0x11d>
			goto err;
  802963:	eb 57                	jmp    8029bc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802969:	48 c1 e8 0c          	shr    $0xc,%rax
  80296d:	48 89 c2             	mov    %rax,%rdx
  802970:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802977:	01 00 00 
  80297a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80297e:	25 07 0e 00 00       	and    $0xe07,%eax
  802983:	89 c1                	mov    %eax,%ecx
  802985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802989:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80298d:	41 89 c8             	mov    %ecx,%r8d
  802990:	48 89 d1             	mov    %rdx,%rcx
  802993:	ba 00 00 00 00       	mov    $0x0,%edx
  802998:	48 89 c6             	mov    %rax,%rsi
  80299b:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a0:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	79 02                	jns    8029b7 <dup+0x16f>
		goto err;
  8029b5:	eb 05                	jmp    8029bc <dup+0x174>

	return newfdnum;
  8029b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029ba:	eb 33                	jmp    8029ef <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c0:	48 89 c6             	mov    %rax,%rsi
  8029c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c8:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d8:	48 89 c6             	mov    %rax,%rsi
  8029db:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e0:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
	return r;
  8029ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029ef:	c9                   	leaveq 
  8029f0:	c3                   	retq   

00000000008029f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029f1:	55                   	push   %rbp
  8029f2:	48 89 e5             	mov    %rsp,%rbp
  8029f5:	48 83 ec 40          	sub    $0x40,%rsp
  8029f9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a00:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a04:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a08:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a0b:	48 89 d6             	mov    %rdx,%rsi
  802a0e:	89 c7                	mov    %eax,%edi
  802a10:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
  802a1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a23:	78 24                	js     802a49 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a29:	8b 00                	mov    (%rax),%eax
  802a2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a2f:	48 89 d6             	mov    %rdx,%rsi
  802a32:	89 c7                	mov    %eax,%edi
  802a34:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
  802a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a47:	79 05                	jns    802a4e <read+0x5d>
		return r;
  802a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4c:	eb 76                	jmp    802ac4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a52:	8b 40 08             	mov    0x8(%rax),%eax
  802a55:	83 e0 03             	and    $0x3,%eax
  802a58:	83 f8 01             	cmp    $0x1,%eax
  802a5b:	75 3a                	jne    802a97 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a5d:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802a64:	00 00 00 
  802a67:	48 8b 00             	mov    (%rax),%rax
  802a6a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a70:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a73:	89 c6                	mov    %eax,%esi
  802a75:	48 bf 5f 51 80 00 00 	movabs $0x80515f,%rdi
  802a7c:	00 00 00 
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  802a8b:	00 00 00 
  802a8e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a95:	eb 2d                	jmp    802ac4 <read+0xd3>
	}
	if (!dev->dev_read)
  802a97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a9f:	48 85 c0             	test   %rax,%rax
  802aa2:	75 07                	jne    802aab <read+0xba>
		return -E_NOT_SUPP;
  802aa4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aa9:	eb 19                	jmp    802ac4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802aab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaf:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ab3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ab7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802abb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802abf:	48 89 cf             	mov    %rcx,%rdi
  802ac2:	ff d0                	callq  *%rax
}
  802ac4:	c9                   	leaveq 
  802ac5:	c3                   	retq   

0000000000802ac6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
  802aca:	48 83 ec 30          	sub    $0x30,%rsp
  802ace:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ad1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ad5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ad9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae0:	eb 49                	jmp    802b2b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae5:	48 98                	cltq   
  802ae7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aeb:	48 29 c2             	sub    %rax,%rdx
  802aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af1:	48 63 c8             	movslq %eax,%rcx
  802af4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af8:	48 01 c1             	add    %rax,%rcx
  802afb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802afe:	48 89 ce             	mov    %rcx,%rsi
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	48 b8 f1 29 80 00 00 	movabs $0x8029f1,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
  802b0f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b12:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b16:	79 05                	jns    802b1d <readn+0x57>
			return m;
  802b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b1b:	eb 1c                	jmp    802b39 <readn+0x73>
		if (m == 0)
  802b1d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b21:	75 02                	jne    802b25 <readn+0x5f>
			break;
  802b23:	eb 11                	jmp    802b36 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b28:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2e:	48 98                	cltq   
  802b30:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b34:	72 ac                	jb     802ae2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b39:	c9                   	leaveq 
  802b3a:	c3                   	retq   

0000000000802b3b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
  802b3f:	48 83 ec 40          	sub    $0x40,%rsp
  802b43:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b46:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b4a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b4e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b52:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b55:	48 89 d6             	mov    %rdx,%rsi
  802b58:	89 c7                	mov    %eax,%edi
  802b5a:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
  802b66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6d:	78 24                	js     802b93 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b73:	8b 00                	mov    (%rax),%eax
  802b75:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b79:	48 89 d6             	mov    %rdx,%rsi
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
  802b8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b91:	79 05                	jns    802b98 <write+0x5d>
		return r;
  802b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b96:	eb 75                	jmp    802c0d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9c:	8b 40 08             	mov    0x8(%rax),%eax
  802b9f:	83 e0 03             	and    $0x3,%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	75 3a                	jne    802be0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ba6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802bad:	00 00 00 
  802bb0:	48 8b 00             	mov    (%rax),%rax
  802bb3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bb9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bbc:	89 c6                	mov    %eax,%esi
  802bbe:	48 bf 7b 51 80 00 00 	movabs $0x80517b,%rdi
  802bc5:	00 00 00 
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  802bd4:	00 00 00 
  802bd7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bde:	eb 2d                	jmp    802c0d <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802be8:	48 85 c0             	test   %rax,%rax
  802beb:	75 07                	jne    802bf4 <write+0xb9>
		return -E_NOT_SUPP;
  802bed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bf2:	eb 19                	jmp    802c0d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bfc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c04:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c08:	48 89 cf             	mov    %rcx,%rdi
  802c0b:	ff d0                	callq  *%rax
}
  802c0d:	c9                   	leaveq 
  802c0e:	c3                   	retq   

0000000000802c0f <seek>:

int
seek(int fdnum, off_t offset)
{
  802c0f:	55                   	push   %rbp
  802c10:	48 89 e5             	mov    %rsp,%rbp
  802c13:	48 83 ec 18          	sub    $0x18,%rsp
  802c17:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c1a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c24:	48 89 d6             	mov    %rdx,%rsi
  802c27:	89 c7                	mov    %eax,%edi
  802c29:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3c:	79 05                	jns    802c43 <seek+0x34>
		return r;
  802c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c41:	eb 0f                	jmp    802c52 <seek+0x43>
	fd->fd_offset = offset;
  802c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c47:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c4a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c52:	c9                   	leaveq 
  802c53:	c3                   	retq   

0000000000802c54 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c54:	55                   	push   %rbp
  802c55:	48 89 e5             	mov    %rsp,%rbp
  802c58:	48 83 ec 30          	sub    $0x30,%rsp
  802c5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c5f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c62:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c66:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c69:	48 89 d6             	mov    %rdx,%rsi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802c75:	00 00 00 
  802c78:	ff d0                	callq  *%rax
  802c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c81:	78 24                	js     802ca7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c87:	8b 00                	mov    (%rax),%eax
  802c89:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c8d:	48 89 d6             	mov    %rdx,%rsi
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	79 05                	jns    802cac <ftruncate+0x58>
		return r;
  802ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caa:	eb 72                	jmp    802d1e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb0:	8b 40 08             	mov    0x8(%rax),%eax
  802cb3:	83 e0 03             	and    $0x3,%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	75 3a                	jne    802cf4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cba:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802cc1:	00 00 00 
  802cc4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cc7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ccd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cd0:	89 c6                	mov    %eax,%esi
  802cd2:	48 bf 98 51 80 00 00 	movabs $0x805198,%rdi
  802cd9:	00 00 00 
  802cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce1:	48 b9 22 06 80 00 00 	movabs $0x800622,%rcx
  802ce8:	00 00 00 
  802ceb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ced:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cf2:	eb 2a                	jmp    802d1e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cfc:	48 85 c0             	test   %rax,%rax
  802cff:	75 07                	jne    802d08 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d01:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d06:	eb 16                	jmp    802d1e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d14:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d17:	89 ce                	mov    %ecx,%esi
  802d19:	48 89 d7             	mov    %rdx,%rdi
  802d1c:	ff d0                	callq  *%rax
}
  802d1e:	c9                   	leaveq 
  802d1f:	c3                   	retq   

0000000000802d20 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d20:	55                   	push   %rbp
  802d21:	48 89 e5             	mov    %rsp,%rbp
  802d24:	48 83 ec 30          	sub    $0x30,%rsp
  802d28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d2f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d33:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d36:	48 89 d6             	mov    %rdx,%rsi
  802d39:	89 c7                	mov    %eax,%edi
  802d3b:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
  802d47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4e:	78 24                	js     802d74 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d54:	8b 00                	mov    (%rax),%eax
  802d56:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d5a:	48 89 d6             	mov    %rdx,%rsi
  802d5d:	89 c7                	mov    %eax,%edi
  802d5f:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
  802d6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d72:	79 05                	jns    802d79 <fstat+0x59>
		return r;
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d77:	eb 5e                	jmp    802dd7 <fstat+0xb7>
	if (!dev->dev_stat)
  802d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d81:	48 85 c0             	test   %rax,%rax
  802d84:	75 07                	jne    802d8d <fstat+0x6d>
		return -E_NOT_SUPP;
  802d86:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d8b:	eb 4a                	jmp    802dd7 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d91:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d98:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d9f:	00 00 00 
	stat->st_isdir = 0;
  802da2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dad:	00 00 00 
	stat->st_dev = dev;
  802db0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802db4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dcb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dcf:	48 89 ce             	mov    %rcx,%rsi
  802dd2:	48 89 d7             	mov    %rdx,%rdi
  802dd5:	ff d0                	callq  *%rax
}
  802dd7:	c9                   	leaveq 
  802dd8:	c3                   	retq   

0000000000802dd9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dd9:	55                   	push   %rbp
  802dda:	48 89 e5             	mov    %rsp,%rbp
  802ddd:	48 83 ec 20          	sub    $0x20,%rsp
  802de1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802de5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ded:	be 00 00 00 00       	mov    $0x0,%esi
  802df2:	48 89 c7             	mov    %rax,%rdi
  802df5:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e08:	79 05                	jns    802e0f <stat+0x36>
		return fd;
  802e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0d:	eb 2f                	jmp    802e3e <stat+0x65>
	r = fstat(fd, stat);
  802e0f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e16:	48 89 d6             	mov    %rdx,%rsi
  802e19:	89 c7                	mov    %eax,%edi
  802e1b:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
  802e27:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2d:	89 c7                	mov    %eax,%edi
  802e2f:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
	return r;
  802e3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e3e:	c9                   	leaveq 
  802e3f:	c3                   	retq   

0000000000802e40 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e40:	55                   	push   %rbp
  802e41:	48 89 e5             	mov    %rsp,%rbp
  802e44:	48 83 ec 10          	sub    $0x10,%rsp
  802e48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e4f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e56:	00 00 00 
  802e59:	8b 00                	mov    (%rax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	75 1d                	jne    802e7c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e5f:	bf 01 00 00 00       	mov    $0x1,%edi
  802e64:	48 b8 aa 48 80 00 00 	movabs $0x8048aa,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	callq  *%rax
  802e70:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e77:	00 00 00 
  802e7a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e7c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e83:	00 00 00 
  802e86:	8b 00                	mov    (%rax),%eax
  802e88:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e8b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e90:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e97:	00 00 00 
  802e9a:	89 c7                	mov    %eax,%edi
  802e9c:	48 b8 48 48 80 00 00 	movabs $0x804848,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eac:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb1:	48 89 c6             	mov    %rax,%rsi
  802eb4:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb9:	48 b8 42 47 80 00 00 	movabs $0x804742,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
}
  802ec5:	c9                   	leaveq 
  802ec6:	c3                   	retq   

0000000000802ec7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ec7:	55                   	push   %rbp
  802ec8:	48 89 e5             	mov    %rsp,%rbp
  802ecb:	48 83 ec 30          	sub    $0x30,%rsp
  802ecf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ed3:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ed6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802edd:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802eeb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ef0:	75 08                	jne    802efa <open+0x33>
	{
		return r;
  802ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef5:	e9 f2 00 00 00       	jmpq   802fec <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802efa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802efe:	48 89 c7             	mov    %rax,%rdi
  802f01:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax
  802f0d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f10:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f17:	7e 0a                	jle    802f23 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f19:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f1e:	e9 c9 00 00 00       	jmpq   802fec <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f23:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f2a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f2b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f2f:	48 89 c7             	mov    %rax,%rdi
  802f32:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f45:	78 09                	js     802f50 <open+0x89>
  802f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4b:	48 85 c0             	test   %rax,%rax
  802f4e:	75 08                	jne    802f58 <open+0x91>
		{
			return r;
  802f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f53:	e9 94 00 00 00       	jmpq   802fec <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5c:	ba 00 04 00 00       	mov    $0x400,%edx
  802f61:	48 89 c6             	mov    %rax,%rsi
  802f64:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f6b:	00 00 00 
  802f6e:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f7a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f81:	00 00 00 
  802f84:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f87:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f91:	48 89 c6             	mov    %rax,%rsi
  802f94:	bf 01 00 00 00       	mov    $0x1,%edi
  802f99:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
  802fa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fac:	79 2b                	jns    802fd9 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb2:	be 00 00 00 00       	mov    $0x0,%esi
  802fb7:	48 89 c7             	mov    %rax,%rdi
  802fba:	48 b8 4f 26 80 00 00 	movabs $0x80264f,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802fc9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fcd:	79 05                	jns    802fd4 <open+0x10d>
			{
				return d;
  802fcf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd2:	eb 18                	jmp    802fec <open+0x125>
			}
			return r;
  802fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd7:	eb 13                	jmp    802fec <open+0x125>
		}	
		return fd2num(fd_store);
  802fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdd:	48 89 c7             	mov    %rax,%rdi
  802fe0:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802fec:	c9                   	leaveq 
  802fed:	c3                   	retq   

0000000000802fee <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fee:	55                   	push   %rbp
  802fef:	48 89 e5             	mov    %rsp,%rbp
  802ff2:	48 83 ec 10          	sub    $0x10,%rsp
  802ff6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffe:	8b 50 0c             	mov    0xc(%rax),%edx
  803001:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803008:	00 00 00 
  80300b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80300d:	be 00 00 00 00       	mov    $0x0,%esi
  803012:	bf 06 00 00 00       	mov    $0x6,%edi
  803017:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
}
  803023:	c9                   	leaveq 
  803024:	c3                   	retq   

0000000000803025 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803025:	55                   	push   %rbp
  803026:	48 89 e5             	mov    %rsp,%rbp
  803029:	48 83 ec 30          	sub    $0x30,%rsp
  80302d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803031:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803035:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803040:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803045:	74 07                	je     80304e <devfile_read+0x29>
  803047:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80304c:	75 07                	jne    803055 <devfile_read+0x30>
		return -E_INVAL;
  80304e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803053:	eb 77                	jmp    8030cc <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803059:	8b 50 0c             	mov    0xc(%rax),%edx
  80305c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803063:	00 00 00 
  803066:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803068:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80306f:	00 00 00 
  803072:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803076:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80307a:	be 00 00 00 00       	mov    $0x0,%esi
  80307f:	bf 03 00 00 00       	mov    $0x3,%edi
  803084:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  80308b:	00 00 00 
  80308e:	ff d0                	callq  *%rax
  803090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803097:	7f 05                	jg     80309e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803099:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309c:	eb 2e                	jmp    8030cc <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80309e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a1:	48 63 d0             	movslq %eax,%rdx
  8030a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a8:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030af:	00 00 00 
  8030b2:	48 89 c7             	mov    %rax,%rdi
  8030b5:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8030c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8030c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030cc:	c9                   	leaveq 
  8030cd:	c3                   	retq   

00000000008030ce <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030ce:	55                   	push   %rbp
  8030cf:	48 89 e5             	mov    %rsp,%rbp
  8030d2:	48 83 ec 30          	sub    $0x30,%rsp
  8030d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8030e2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030ee:	74 07                	je     8030f7 <devfile_write+0x29>
  8030f0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030f5:	75 08                	jne    8030ff <devfile_write+0x31>
		return r;
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fa:	e9 9a 00 00 00       	jmpq   803199 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803103:	8b 50 0c             	mov    0xc(%rax),%edx
  803106:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80310d:	00 00 00 
  803110:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803112:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803119:	00 
  80311a:	76 08                	jbe    803124 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80311c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803123:	00 
	}
	fsipcbuf.write.req_n = n;
  803124:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80312b:	00 00 00 
  80312e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803132:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803136:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80313a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80313e:	48 89 c6             	mov    %rax,%rsi
  803141:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803148:	00 00 00 
  80314b:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803157:	be 00 00 00 00       	mov    $0x0,%esi
  80315c:	bf 04 00 00 00       	mov    $0x4,%edi
  803161:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
  80316d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803174:	7f 20                	jg     803196 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803176:	48 bf be 51 80 00 00 	movabs $0x8051be,%rdi
  80317d:	00 00 00 
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  80318c:	00 00 00 
  80318f:	ff d2                	callq  *%rdx
		return r;
  803191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803194:	eb 03                	jmp    803199 <devfile_write+0xcb>
	}
	return r;
  803196:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803199:	c9                   	leaveq 
  80319a:	c3                   	retq   

000000000080319b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80319b:	55                   	push   %rbp
  80319c:	48 89 e5             	mov    %rsp,%rbp
  80319f:	48 83 ec 20          	sub    $0x20,%rsp
  8031a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031af:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031b9:	00 00 00 
  8031bc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031be:	be 00 00 00 00       	mov    $0x0,%esi
  8031c3:	bf 05 00 00 00       	mov    $0x5,%edi
  8031c8:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  8031cf:	00 00 00 
  8031d2:	ff d0                	callq  *%rax
  8031d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031db:	79 05                	jns    8031e2 <devfile_stat+0x47>
		return r;
  8031dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e0:	eb 56                	jmp    803238 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031ed:	00 00 00 
  8031f0:	48 89 c7             	mov    %rax,%rdi
  8031f3:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8031fa:	00 00 00 
  8031fd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ff:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803206:	00 00 00 
  803209:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80320f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803213:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803219:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803220:	00 00 00 
  803223:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803238:	c9                   	leaveq 
  803239:	c3                   	retq   

000000000080323a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80323a:	55                   	push   %rbp
  80323b:	48 89 e5             	mov    %rsp,%rbp
  80323e:	48 83 ec 10          	sub    $0x10,%rsp
  803242:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803246:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324d:	8b 50 0c             	mov    0xc(%rax),%edx
  803250:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803257:	00 00 00 
  80325a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80325c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803263:	00 00 00 
  803266:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803269:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80326c:	be 00 00 00 00       	mov    $0x0,%esi
  803271:	bf 02 00 00 00       	mov    $0x2,%edi
  803276:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
}
  803282:	c9                   	leaveq 
  803283:	c3                   	retq   

0000000000803284 <remove>:

// Delete a file
int
remove(const char *path)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 10          	sub    $0x10,%rsp
  80328c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803294:	48 89 c7             	mov    %rax,%rdi
  803297:	48 b8 6b 11 80 00 00 	movabs $0x80116b,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
  8032a3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032a8:	7e 07                	jle    8032b1 <remove+0x2d>
		return -E_BAD_PATH;
  8032aa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032af:	eb 33                	jmp    8032e4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032b5:	48 89 c6             	mov    %rax,%rsi
  8032b8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032bf:	00 00 00 
  8032c2:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032ce:	be 00 00 00 00       	mov    $0x0,%esi
  8032d3:	bf 07 00 00 00       	mov    $0x7,%edi
  8032d8:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  8032df:	00 00 00 
  8032e2:	ff d0                	callq  *%rax
}
  8032e4:	c9                   	leaveq 
  8032e5:	c3                   	retq   

00000000008032e6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032e6:	55                   	push   %rbp
  8032e7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032ea:	be 00 00 00 00       	mov    $0x0,%esi
  8032ef:	bf 08 00 00 00       	mov    $0x8,%edi
  8032f4:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
}
  803300:	5d                   	pop    %rbp
  803301:	c3                   	retq   

0000000000803302 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803302:	55                   	push   %rbp
  803303:	48 89 e5             	mov    %rsp,%rbp
  803306:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80330d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803314:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80331b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803322:	be 00 00 00 00       	mov    $0x0,%esi
  803327:	48 89 c7             	mov    %rax,%rdi
  80332a:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  803331:	00 00 00 
  803334:	ff d0                	callq  *%rax
  803336:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803339:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333d:	79 28                	jns    803367 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80333f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803342:	89 c6                	mov    %eax,%esi
  803344:	48 bf da 51 80 00 00 	movabs $0x8051da,%rdi
  80334b:	00 00 00 
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
  803353:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  80335a:	00 00 00 
  80335d:	ff d2                	callq  *%rdx
		return fd_src;
  80335f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803362:	e9 74 01 00 00       	jmpq   8034db <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803367:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80336e:	be 01 01 00 00       	mov    $0x101,%esi
  803373:	48 89 c7             	mov    %rax,%rdi
  803376:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803385:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803389:	79 39                	jns    8033c4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80338b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80338e:	89 c6                	mov    %eax,%esi
  803390:	48 bf f0 51 80 00 00 	movabs $0x8051f0,%rdi
  803397:	00 00 00 
  80339a:	b8 00 00 00 00       	mov    $0x0,%eax
  80339f:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  8033a6:	00 00 00 
  8033a9:	ff d2                	callq  *%rdx
		close(fd_src);
  8033ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ae:	89 c7                	mov    %eax,%edi
  8033b0:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
		return fd_dest;
  8033bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033bf:	e9 17 01 00 00       	jmpq   8034db <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033c4:	eb 74                	jmp    80343a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8033c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033c9:	48 63 d0             	movslq %eax,%rdx
  8033cc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d6:	48 89 ce             	mov    %rcx,%rsi
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 3b 2b 80 00 00 	movabs $0x802b3b,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033ee:	79 4a                	jns    80343a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033f0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033f3:	89 c6                	mov    %eax,%esi
  8033f5:	48 bf 0a 52 80 00 00 	movabs $0x80520a,%rdi
  8033fc:	00 00 00 
  8033ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803404:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  80340b:	00 00 00 
  80340e:	ff d2                	callq  *%rdx
			close(fd_src);
  803410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803413:	89 c7                	mov    %eax,%edi
  803415:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
			close(fd_dest);
  803421:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803424:	89 c7                	mov    %eax,%edi
  803426:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  80342d:	00 00 00 
  803430:	ff d0                	callq  *%rax
			return write_size;
  803432:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803435:	e9 a1 00 00 00       	jmpq   8034db <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80343a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803441:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803444:	ba 00 02 00 00       	mov    $0x200,%edx
  803449:	48 89 ce             	mov    %rcx,%rsi
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 f1 29 80 00 00 	movabs $0x8029f1,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80345d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803461:	0f 8f 5f ff ff ff    	jg     8033c6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803467:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80346b:	79 47                	jns    8034b4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80346d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803470:	89 c6                	mov    %eax,%esi
  803472:	48 bf 1d 52 80 00 00 	movabs $0x80521d,%rdi
  803479:	00 00 00 
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	48 ba 22 06 80 00 00 	movabs $0x800622,%rdx
  803488:	00 00 00 
  80348b:	ff d2                	callq  *%rdx
		close(fd_src);
  80348d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803490:	89 c7                	mov    %eax,%edi
  803492:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
		close(fd_dest);
  80349e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a1:	89 c7                	mov    %eax,%edi
  8034a3:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
		return read_size;
  8034af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034b2:	eb 27                	jmp    8034db <copy+0x1d9>
	}
	close(fd_src);
  8034b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b7:	89 c7                	mov    %eax,%edi
  8034b9:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
	close(fd_dest);
  8034c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c8:	89 c7                	mov    %eax,%edi
  8034ca:	48 b8 cf 27 80 00 00 	movabs $0x8027cf,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
	return 0;
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034db:	c9                   	leaveq 
  8034dc:	c3                   	retq   

00000000008034dd <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034dd:	55                   	push   %rbp
  8034de:	48 89 e5             	mov    %rsp,%rbp
  8034e1:	48 83 ec 20          	sub    $0x20,%rsp
  8034e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ef:	48 89 d6             	mov    %rdx,%rsi
  8034f2:	89 c7                	mov    %eax,%edi
  8034f4:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <fd2sockid+0x31>
		return r;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 24                	jmp    803532 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80350e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803512:	8b 10                	mov    (%rax),%edx
  803514:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80351b:	00 00 00 
  80351e:	8b 00                	mov    (%rax),%eax
  803520:	39 c2                	cmp    %eax,%edx
  803522:	74 07                	je     80352b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803524:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803529:	eb 07                	jmp    803532 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80352b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 83 ec 20          	sub    $0x20,%rsp
  80353c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80353f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803543:	48 89 c7             	mov    %rax,%rdi
  803546:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
  803552:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803555:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803559:	78 26                	js     803581 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80355b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355f:	ba 07 04 00 00       	mov    $0x407,%edx
  803564:	48 89 c6             	mov    %rax,%rsi
  803567:	bf 00 00 00 00       	mov    $0x0,%edi
  80356c:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
  803578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357f:	79 16                	jns    803597 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803581:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 41 3a 80 00 00 	movabs $0x803a41,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
		return r;
  803592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803595:	eb 3a                	jmp    8035d1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359b:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8035a2:	00 00 00 
  8035a5:	8b 12                	mov    (%rdx),%edx
  8035a7:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ad:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035bb:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8035be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c2:	48 89 c7             	mov    %rax,%rdi
  8035c5:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
}
  8035d1:	c9                   	leaveq 
  8035d2:	c3                   	retq   

00000000008035d3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035d3:	55                   	push   %rbp
  8035d4:	48 89 e5             	mov    %rsp,%rbp
  8035d7:	48 83 ec 30          	sub    $0x30,%rsp
  8035db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e9:	89 c7                	mov    %eax,%edi
  8035eb:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
  8035f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fe:	79 05                	jns    803605 <accept+0x32>
		return r;
  803600:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803603:	eb 3b                	jmp    803640 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803605:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803609:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80360d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803610:	48 89 ce             	mov    %rcx,%rsi
  803613:	89 c7                	mov    %eax,%edi
  803615:	48 b8 1e 39 80 00 00 	movabs $0x80391e,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
  803621:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803624:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803628:	79 05                	jns    80362f <accept+0x5c>
		return r;
  80362a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362d:	eb 11                	jmp    803640 <accept+0x6d>
	return alloc_sockfd(r);
  80362f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803632:	89 c7                	mov    %eax,%edi
  803634:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  80363b:	00 00 00 
  80363e:	ff d0                	callq  *%rax
}
  803640:	c9                   	leaveq 
  803641:	c3                   	retq   

0000000000803642 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803642:	55                   	push   %rbp
  803643:	48 89 e5             	mov    %rsp,%rbp
  803646:	48 83 ec 20          	sub    $0x20,%rsp
  80364a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80364d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803651:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803654:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803657:	89 c7                	mov    %eax,%edi
  803659:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
  803665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803668:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366c:	79 05                	jns    803673 <bind+0x31>
		return r;
  80366e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803671:	eb 1b                	jmp    80368e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803673:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803676:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80367a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367d:	48 89 ce             	mov    %rcx,%rsi
  803680:	89 c7                	mov    %eax,%edi
  803682:	48 b8 9d 39 80 00 00 	movabs $0x80399d,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
}
  80368e:	c9                   	leaveq 
  80368f:	c3                   	retq   

0000000000803690 <shutdown>:

int
shutdown(int s, int how)
{
  803690:	55                   	push   %rbp
  803691:	48 89 e5             	mov    %rsp,%rbp
  803694:	48 83 ec 20          	sub    $0x20,%rsp
  803698:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80369b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80369e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a1:	89 c7                	mov    %eax,%edi
  8036a3:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
  8036af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b6:	79 05                	jns    8036bd <shutdown+0x2d>
		return r;
  8036b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bb:	eb 16                	jmp    8036d3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c3:	89 d6                	mov    %edx,%esi
  8036c5:	89 c7                	mov    %eax,%edi
  8036c7:	48 b8 01 3a 80 00 00 	movabs $0x803a01,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
}
  8036d3:	c9                   	leaveq 
  8036d4:	c3                   	retq   

00000000008036d5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8036d5:	55                   	push   %rbp
  8036d6:	48 89 e5             	mov    %rsp,%rbp
  8036d9:	48 83 ec 10          	sub    $0x10,%rsp
  8036dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e5:	48 89 c7             	mov    %rax,%rdi
  8036e8:	48 b8 2c 49 80 00 00 	movabs $0x80492c,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
  8036f4:	83 f8 01             	cmp    $0x1,%eax
  8036f7:	75 17                	jne    803710 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036fd:	8b 40 0c             	mov    0xc(%rax),%eax
  803700:	89 c7                	mov    %eax,%edi
  803702:	48 b8 41 3a 80 00 00 	movabs $0x803a41,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
  80370e:	eb 05                	jmp    803715 <devsock_close+0x40>
	else
		return 0;
  803710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 20          	sub    $0x20,%rsp
  80371f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803722:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803726:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803729:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372c:	89 c7                	mov    %eax,%edi
  80372e:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  803735:	00 00 00 
  803738:	ff d0                	callq  *%rax
  80373a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803741:	79 05                	jns    803748 <connect+0x31>
		return r;
  803743:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803746:	eb 1b                	jmp    803763 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803748:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80374b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80374f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803752:	48 89 ce             	mov    %rcx,%rsi
  803755:	89 c7                	mov    %eax,%edi
  803757:	48 b8 6e 3a 80 00 00 	movabs $0x803a6e,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
}
  803763:	c9                   	leaveq 
  803764:	c3                   	retq   

0000000000803765 <listen>:

int
listen(int s, int backlog)
{
  803765:	55                   	push   %rbp
  803766:	48 89 e5             	mov    %rsp,%rbp
  803769:	48 83 ec 20          	sub    $0x20,%rsp
  80376d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803770:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803773:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803776:	89 c7                	mov    %eax,%edi
  803778:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378b:	79 05                	jns    803792 <listen+0x2d>
		return r;
  80378d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803790:	eb 16                	jmp    8037a8 <listen+0x43>
	return nsipc_listen(r, backlog);
  803792:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803798:	89 d6                	mov    %edx,%esi
  80379a:	89 c7                	mov    %eax,%edi
  80379c:	48 b8 d2 3a 80 00 00 	movabs $0x803ad2,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
}
  8037a8:	c9                   	leaveq 
  8037a9:	c3                   	retq   

00000000008037aa <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037aa:	55                   	push   %rbp
  8037ab:	48 89 e5             	mov    %rsp,%rbp
  8037ae:	48 83 ec 20          	sub    $0x20,%rsp
  8037b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c2:	89 c2                	mov    %eax,%edx
  8037c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c8:	8b 40 0c             	mov    0xc(%rax),%eax
  8037cb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037d4:	89 c7                	mov    %eax,%edi
  8037d6:	48 b8 12 3b 80 00 00 	movabs $0x803b12,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
}
  8037e2:	c9                   	leaveq 
  8037e3:	c3                   	retq   

00000000008037e4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037e4:	55                   	push   %rbp
  8037e5:	48 89 e5             	mov    %rsp,%rbp
  8037e8:	48 83 ec 20          	sub    $0x20,%rsp
  8037ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037fc:	89 c2                	mov    %eax,%edx
  8037fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803802:	8b 40 0c             	mov    0xc(%rax),%eax
  803805:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803809:	b9 00 00 00 00       	mov    $0x0,%ecx
  80380e:	89 c7                	mov    %eax,%edi
  803810:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
}
  80381c:	c9                   	leaveq 
  80381d:	c3                   	retq   

000000000080381e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80381e:	55                   	push   %rbp
  80381f:	48 89 e5             	mov    %rsp,%rbp
  803822:	48 83 ec 10          	sub    $0x10,%rsp
  803826:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80382a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80382e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803832:	48 be 38 52 80 00 00 	movabs $0x805238,%rsi
  803839:	00 00 00 
  80383c:	48 89 c7             	mov    %rax,%rdi
  80383f:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  803846:	00 00 00 
  803849:	ff d0                	callq  *%rax
	return 0;
  80384b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803850:	c9                   	leaveq 
  803851:	c3                   	retq   

0000000000803852 <socket>:

int
socket(int domain, int type, int protocol)
{
  803852:	55                   	push   %rbp
  803853:	48 89 e5             	mov    %rsp,%rbp
  803856:	48 83 ec 20          	sub    $0x20,%rsp
  80385a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80385d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803860:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803863:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803866:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803869:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80386c:	89 ce                	mov    %ecx,%esi
  80386e:	89 c7                	mov    %eax,%edi
  803870:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
  80387c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803883:	79 05                	jns    80388a <socket+0x38>
		return r;
  803885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803888:	eb 11                	jmp    80389b <socket+0x49>
	return alloc_sockfd(r);
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388d:	89 c7                	mov    %eax,%edi
  80388f:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
}
  80389b:	c9                   	leaveq 
  80389c:	c3                   	retq   

000000000080389d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80389d:	55                   	push   %rbp
  80389e:	48 89 e5             	mov    %rsp,%rbp
  8038a1:	48 83 ec 10          	sub    $0x10,%rsp
  8038a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038a8:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038af:	00 00 00 
  8038b2:	8b 00                	mov    (%rax),%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	75 1d                	jne    8038d5 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038b8:	bf 02 00 00 00       	mov    $0x2,%edi
  8038bd:	48 b8 aa 48 80 00 00 	movabs $0x8048aa,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
  8038c9:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8038d0:	00 00 00 
  8038d3:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8038d5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038dc:	00 00 00 
  8038df:	8b 00                	mov    (%rax),%eax
  8038e1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038e4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038e9:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8038f0:	00 00 00 
  8038f3:	89 c7                	mov    %eax,%edi
  8038f5:	48 b8 48 48 80 00 00 	movabs $0x804848,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803901:	ba 00 00 00 00       	mov    $0x0,%edx
  803906:	be 00 00 00 00       	mov    $0x0,%esi
  80390b:	bf 00 00 00 00       	mov    $0x0,%edi
  803910:	48 b8 42 47 80 00 00 	movabs $0x804742,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
}
  80391c:	c9                   	leaveq 
  80391d:	c3                   	retq   

000000000080391e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80391e:	55                   	push   %rbp
  80391f:	48 89 e5             	mov    %rsp,%rbp
  803922:	48 83 ec 30          	sub    $0x30,%rsp
  803926:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803929:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80392d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803931:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803938:	00 00 00 
  80393b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80393e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803940:	bf 01 00 00 00       	mov    $0x1,%edi
  803945:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
  803951:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803954:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803958:	78 3e                	js     803998 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80395a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803961:	00 00 00 
  803964:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396c:	8b 40 10             	mov    0x10(%rax),%eax
  80396f:	89 c2                	mov    %eax,%edx
  803971:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803975:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803979:	48 89 ce             	mov    %rcx,%rsi
  80397c:	48 89 c7             	mov    %rax,%rdi
  80397f:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803986:	00 00 00 
  803989:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80398b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398f:	8b 50 10             	mov    0x10(%rax),%edx
  803992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803996:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803998:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80399b:	c9                   	leaveq 
  80399c:	c3                   	retq   

000000000080399d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80399d:	55                   	push   %rbp
  80399e:	48 89 e5             	mov    %rsp,%rbp
  8039a1:	48 83 ec 10          	sub    $0x10,%rsp
  8039a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8039af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039b6:	00 00 00 
  8039b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039bc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8039be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c5:	48 89 c6             	mov    %rax,%rsi
  8039c8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8039cf:	00 00 00 
  8039d2:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8039de:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e5:	00 00 00 
  8039e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039eb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039ee:	bf 02 00 00 00       	mov    $0x2,%edi
  8039f3:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  8039fa:	00 00 00 
  8039fd:	ff d0                	callq  *%rax
}
  8039ff:	c9                   	leaveq 
  803a00:	c3                   	retq   

0000000000803a01 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a01:	55                   	push   %rbp
  803a02:	48 89 e5             	mov    %rsp,%rbp
  803a05:	48 83 ec 10          	sub    $0x10,%rsp
  803a09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a16:	00 00 00 
  803a19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a1e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a25:	00 00 00 
  803a28:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a2e:	bf 03 00 00 00       	mov    $0x3,%edi
  803a33:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
}
  803a3f:	c9                   	leaveq 
  803a40:	c3                   	retq   

0000000000803a41 <nsipc_close>:

int
nsipc_close(int s)
{
  803a41:	55                   	push   %rbp
  803a42:	48 89 e5             	mov    %rsp,%rbp
  803a45:	48 83 ec 10          	sub    $0x10,%rsp
  803a49:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a4c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a53:	00 00 00 
  803a56:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a59:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a5b:	bf 04 00 00 00       	mov    $0x4,%edi
  803a60:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803a67:	00 00 00 
  803a6a:	ff d0                	callq  *%rax
}
  803a6c:	c9                   	leaveq 
  803a6d:	c3                   	retq   

0000000000803a6e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a6e:	55                   	push   %rbp
  803a6f:	48 89 e5             	mov    %rsp,%rbp
  803a72:	48 83 ec 10          	sub    $0x10,%rsp
  803a76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a7d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a80:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a87:	00 00 00 
  803a8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a8d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a8f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a96:	48 89 c6             	mov    %rax,%rsi
  803a99:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803aa0:	00 00 00 
  803aa3:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803aaf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ab6:	00 00 00 
  803ab9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803abc:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803abf:	bf 05 00 00 00       	mov    $0x5,%edi
  803ac4:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
}
  803ad0:	c9                   	leaveq 
  803ad1:	c3                   	retq   

0000000000803ad2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ad2:	55                   	push   %rbp
  803ad3:	48 89 e5             	mov    %rsp,%rbp
  803ad6:	48 83 ec 10          	sub    $0x10,%rsp
  803ada:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803add:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ae0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae7:	00 00 00 
  803aea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aed:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803aef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af6:	00 00 00 
  803af9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803afc:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803aff:	bf 06 00 00 00       	mov    $0x6,%edi
  803b04:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
}
  803b10:	c9                   	leaveq 
  803b11:	c3                   	retq   

0000000000803b12 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b12:	55                   	push   %rbp
  803b13:	48 89 e5             	mov    %rsp,%rbp
  803b16:	48 83 ec 30          	sub    $0x30,%rsp
  803b1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b21:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b24:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b27:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2e:	00 00 00 
  803b31:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b34:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b36:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b3d:	00 00 00 
  803b40:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b43:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b46:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b4d:	00 00 00 
  803b50:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b53:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b56:	bf 07 00 00 00       	mov    $0x7,%edi
  803b5b:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
  803b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6e:	78 69                	js     803bd9 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b70:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b77:	7f 08                	jg     803b81 <nsipc_recv+0x6f>
  803b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b7f:	7e 35                	jle    803bb6 <nsipc_recv+0xa4>
  803b81:	48 b9 3f 52 80 00 00 	movabs $0x80523f,%rcx
  803b88:	00 00 00 
  803b8b:	48 ba 54 52 80 00 00 	movabs $0x805254,%rdx
  803b92:	00 00 00 
  803b95:	be 61 00 00 00       	mov    $0x61,%esi
  803b9a:	48 bf 69 52 80 00 00 	movabs $0x805269,%rdi
  803ba1:	00 00 00 
  803ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba9:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  803bb0:	00 00 00 
  803bb3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb9:	48 63 d0             	movslq %eax,%rdx
  803bbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc0:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803bc7:	00 00 00 
  803bca:	48 89 c7             	mov    %rax,%rdi
  803bcd:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
	}

	return r;
  803bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	48 83 ec 20          	sub    $0x20,%rsp
  803be6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803be9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bed:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803bf0:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bf3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bfa:	00 00 00 
  803bfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c00:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c02:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c09:	7e 35                	jle    803c40 <nsipc_send+0x62>
  803c0b:	48 b9 75 52 80 00 00 	movabs $0x805275,%rcx
  803c12:	00 00 00 
  803c15:	48 ba 54 52 80 00 00 	movabs $0x805254,%rdx
  803c1c:	00 00 00 
  803c1f:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c24:	48 bf 69 52 80 00 00 	movabs $0x805269,%rdi
  803c2b:	00 00 00 
  803c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c33:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  803c3a:	00 00 00 
  803c3d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c43:	48 63 d0             	movslq %eax,%rdx
  803c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4a:	48 89 c6             	mov    %rax,%rsi
  803c4d:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c54:	00 00 00 
  803c57:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c63:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6a:	00 00 00 
  803c6d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c70:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7a:	00 00 00 
  803c7d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c80:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c83:	bf 08 00 00 00       	mov    $0x8,%edi
  803c88:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
}
  803c94:	c9                   	leaveq 
  803c95:	c3                   	retq   

0000000000803c96 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	48 83 ec 10          	sub    $0x10,%rsp
  803c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ca4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ca7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cae:	00 00 00 
  803cb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cb4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803cb6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cbd:	00 00 00 
  803cc0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cc3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803cc6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ccd:	00 00 00 
  803cd0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803cd3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803cd6:	bf 09 00 00 00       	mov    $0x9,%edi
  803cdb:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
}
  803ce7:	c9                   	leaveq 
  803ce8:	c3                   	retq   

0000000000803ce9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ce9:	55                   	push   %rbp
  803cea:	48 89 e5             	mov    %rsp,%rbp
  803ced:	53                   	push   %rbx
  803cee:	48 83 ec 38          	sub    $0x38,%rsp
  803cf2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803cf6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cfa:	48 89 c7             	mov    %rax,%rdi
  803cfd:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  803d04:	00 00 00 
  803d07:	ff d0                	callq  *%rax
  803d09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d10:	0f 88 bf 01 00 00    	js     803ed5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d1a:	ba 07 04 00 00       	mov    $0x407,%edx
  803d1f:	48 89 c6             	mov    %rax,%rsi
  803d22:	bf 00 00 00 00       	mov    $0x0,%edi
  803d27:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803d2e:	00 00 00 
  803d31:	ff d0                	callq  *%rax
  803d33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d36:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d3a:	0f 88 95 01 00 00    	js     803ed5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d40:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d44:	48 89 c7             	mov    %rax,%rdi
  803d47:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d56:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d5a:	0f 88 5d 01 00 00    	js     803ebd <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d64:	ba 07 04 00 00       	mov    $0x407,%edx
  803d69:	48 89 c6             	mov    %rax,%rsi
  803d6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d71:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803d78:	00 00 00 
  803d7b:	ff d0                	callq  *%rax
  803d7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d80:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d84:	0f 88 33 01 00 00    	js     803ebd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d8e:	48 89 c7             	mov    %rax,%rdi
  803d91:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  803d98:	00 00 00 
  803d9b:	ff d0                	callq  *%rax
  803d9d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da5:	ba 07 04 00 00       	mov    $0x407,%edx
  803daa:	48 89 c6             	mov    %rax,%rsi
  803dad:	bf 00 00 00 00       	mov    $0x0,%edi
  803db2:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
  803dbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc5:	79 05                	jns    803dcc <pipe+0xe3>
		goto err2;
  803dc7:	e9 d9 00 00 00       	jmpq   803ea5 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dcc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd0:	48 89 c7             	mov    %rax,%rdi
  803dd3:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
  803ddf:	48 89 c2             	mov    %rax,%rdx
  803de2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de6:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803dec:	48 89 d1             	mov    %rdx,%rcx
  803def:	ba 00 00 00 00       	mov    $0x0,%edx
  803df4:	48 89 c6             	mov    %rax,%rsi
  803df7:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfc:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  803e03:	00 00 00 
  803e06:	ff d0                	callq  *%rax
  803e08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e0f:	79 1b                	jns    803e2c <pipe+0x143>
		goto err3;
  803e11:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e16:	48 89 c6             	mov    %rax,%rsi
  803e19:	bf 00 00 00 00       	mov    $0x0,%edi
  803e1e:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
  803e2a:	eb 79                	jmp    803ea5 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e30:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e37:	00 00 00 
  803e3a:	8b 12                	mov    (%rdx),%edx
  803e3c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e54:	00 00 00 
  803e57:	8b 12                	mov    (%rdx),%edx
  803e59:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e5f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e6a:	48 89 c7             	mov    %rax,%rdi
  803e6d:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  803e74:	00 00 00 
  803e77:	ff d0                	callq  *%rax
  803e79:	89 c2                	mov    %eax,%edx
  803e7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e7f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e81:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e85:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e8d:	48 89 c7             	mov    %rax,%rdi
  803e90:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  803e97:	00 00 00 
  803e9a:	ff d0                	callq  *%rax
  803e9c:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea3:	eb 33                	jmp    803ed8 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ea5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea9:	48 89 c6             	mov    %rax,%rsi
  803eac:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb1:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803eb8:	00 00 00 
  803ebb:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803ebd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec1:	48 89 c6             	mov    %rax,%rsi
  803ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec9:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  803ed0:	00 00 00 
  803ed3:	ff d0                	callq  *%rax
err:
	return r;
  803ed5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ed8:	48 83 c4 38          	add    $0x38,%rsp
  803edc:	5b                   	pop    %rbx
  803edd:	5d                   	pop    %rbp
  803ede:	c3                   	retq   

0000000000803edf <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803edf:	55                   	push   %rbp
  803ee0:	48 89 e5             	mov    %rsp,%rbp
  803ee3:	53                   	push   %rbx
  803ee4:	48 83 ec 28          	sub    $0x28,%rsp
  803ee8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ef0:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803ef7:	00 00 00 
  803efa:	48 8b 00             	mov    (%rax),%rax
  803efd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f03:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f0a:	48 89 c7             	mov    %rax,%rdi
  803f0d:	48 b8 2c 49 80 00 00 	movabs $0x80492c,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
  803f19:	89 c3                	mov    %eax,%ebx
  803f1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f1f:	48 89 c7             	mov    %rax,%rdi
  803f22:	48 b8 2c 49 80 00 00 	movabs $0x80492c,%rax
  803f29:	00 00 00 
  803f2c:	ff d0                	callq  *%rax
  803f2e:	39 c3                	cmp    %eax,%ebx
  803f30:	0f 94 c0             	sete   %al
  803f33:	0f b6 c0             	movzbl %al,%eax
  803f36:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f39:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803f40:	00 00 00 
  803f43:	48 8b 00             	mov    (%rax),%rax
  803f46:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f4c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f52:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f55:	75 05                	jne    803f5c <_pipeisclosed+0x7d>
			return ret;
  803f57:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f5a:	eb 4f                	jmp    803fab <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f5f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f62:	74 42                	je     803fa6 <_pipeisclosed+0xc7>
  803f64:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f68:	75 3c                	jne    803fa6 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f6a:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  803f71:	00 00 00 
  803f74:	48 8b 00             	mov    (%rax),%rax
  803f77:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f7d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f83:	89 c6                	mov    %eax,%esi
  803f85:	48 bf 86 52 80 00 00 	movabs $0x805286,%rdi
  803f8c:	00 00 00 
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f94:	49 b8 22 06 80 00 00 	movabs $0x800622,%r8
  803f9b:	00 00 00 
  803f9e:	41 ff d0             	callq  *%r8
	}
  803fa1:	e9 4a ff ff ff       	jmpq   803ef0 <_pipeisclosed+0x11>
  803fa6:	e9 45 ff ff ff       	jmpq   803ef0 <_pipeisclosed+0x11>
}
  803fab:	48 83 c4 28          	add    $0x28,%rsp
  803faf:	5b                   	pop    %rbx
  803fb0:	5d                   	pop    %rbp
  803fb1:	c3                   	retq   

0000000000803fb2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fb2:	55                   	push   %rbp
  803fb3:	48 89 e5             	mov    %rsp,%rbp
  803fb6:	48 83 ec 30          	sub    $0x30,%rsp
  803fba:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fbd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fc1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fc4:	48 89 d6             	mov    %rdx,%rsi
  803fc7:	89 c7                	mov    %eax,%edi
  803fc9:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  803fd0:	00 00 00 
  803fd3:	ff d0                	callq  *%rax
  803fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fdc:	79 05                	jns    803fe3 <pipeisclosed+0x31>
		return r;
  803fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe1:	eb 31                	jmp    804014 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fe7:	48 89 c7             	mov    %rax,%rdi
  803fea:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  803ff1:	00 00 00 
  803ff4:	ff d0                	callq  *%rax
  803ff6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ffe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804002:	48 89 d6             	mov    %rdx,%rsi
  804005:	48 89 c7             	mov    %rax,%rdi
  804008:	48 b8 df 3e 80 00 00 	movabs $0x803edf,%rax
  80400f:	00 00 00 
  804012:	ff d0                	callq  *%rax
}
  804014:	c9                   	leaveq 
  804015:	c3                   	retq   

0000000000804016 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804016:	55                   	push   %rbp
  804017:	48 89 e5             	mov    %rsp,%rbp
  80401a:	48 83 ec 40          	sub    $0x40,%rsp
  80401e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804022:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804026:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80402a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402e:	48 89 c7             	mov    %rax,%rdi
  804031:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
  80403d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804041:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804045:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804049:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804050:	00 
  804051:	e9 92 00 00 00       	jmpq   8040e8 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804056:	eb 41                	jmp    804099 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804058:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80405d:	74 09                	je     804068 <devpipe_read+0x52>
				return i;
  80405f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804063:	e9 92 00 00 00       	jmpq   8040fa <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804068:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80406c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804070:	48 89 d6             	mov    %rdx,%rsi
  804073:	48 89 c7             	mov    %rax,%rdi
  804076:	48 b8 df 3e 80 00 00 	movabs $0x803edf,%rax
  80407d:	00 00 00 
  804080:	ff d0                	callq  *%rax
  804082:	85 c0                	test   %eax,%eax
  804084:	74 07                	je     80408d <devpipe_read+0x77>
				return 0;
  804086:	b8 00 00 00 00       	mov    $0x0,%eax
  80408b:	eb 6d                	jmp    8040fa <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80408d:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  804094:	00 00 00 
  804097:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80409d:	8b 10                	mov    (%rax),%edx
  80409f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a3:	8b 40 04             	mov    0x4(%rax),%eax
  8040a6:	39 c2                	cmp    %eax,%edx
  8040a8:	74 ae                	je     804058 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040b2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ba:	8b 00                	mov    (%rax),%eax
  8040bc:	99                   	cltd   
  8040bd:	c1 ea 1b             	shr    $0x1b,%edx
  8040c0:	01 d0                	add    %edx,%eax
  8040c2:	83 e0 1f             	and    $0x1f,%eax
  8040c5:	29 d0                	sub    %edx,%eax
  8040c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040cb:	48 98                	cltq   
  8040cd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040d2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d8:	8b 00                	mov    (%rax),%eax
  8040da:	8d 50 01             	lea    0x1(%rax),%edx
  8040dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ec:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040f0:	0f 82 60 ff ff ff    	jb     804056 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040fa:	c9                   	leaveq 
  8040fb:	c3                   	retq   

00000000008040fc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040fc:	55                   	push   %rbp
  8040fd:	48 89 e5             	mov    %rsp,%rbp
  804100:	48 83 ec 40          	sub    $0x40,%rsp
  804104:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804108:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80410c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804110:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804114:	48 89 c7             	mov    %rax,%rdi
  804117:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
  804123:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804127:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80412b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80412f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804136:	00 
  804137:	e9 8e 00 00 00       	jmpq   8041ca <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80413c:	eb 31                	jmp    80416f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80413e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804146:	48 89 d6             	mov    %rdx,%rsi
  804149:	48 89 c7             	mov    %rax,%rdi
  80414c:	48 b8 df 3e 80 00 00 	movabs $0x803edf,%rax
  804153:	00 00 00 
  804156:	ff d0                	callq  *%rax
  804158:	85 c0                	test   %eax,%eax
  80415a:	74 07                	je     804163 <devpipe_write+0x67>
				return 0;
  80415c:	b8 00 00 00 00       	mov    $0x0,%eax
  804161:	eb 79                	jmp    8041dc <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804163:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  80416a:	00 00 00 
  80416d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80416f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804173:	8b 40 04             	mov    0x4(%rax),%eax
  804176:	48 63 d0             	movslq %eax,%rdx
  804179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417d:	8b 00                	mov    (%rax),%eax
  80417f:	48 98                	cltq   
  804181:	48 83 c0 20          	add    $0x20,%rax
  804185:	48 39 c2             	cmp    %rax,%rdx
  804188:	73 b4                	jae    80413e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80418a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80418e:	8b 40 04             	mov    0x4(%rax),%eax
  804191:	99                   	cltd   
  804192:	c1 ea 1b             	shr    $0x1b,%edx
  804195:	01 d0                	add    %edx,%eax
  804197:	83 e0 1f             	and    $0x1f,%eax
  80419a:	29 d0                	sub    %edx,%eax
  80419c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041a4:	48 01 ca             	add    %rcx,%rdx
  8041a7:	0f b6 0a             	movzbl (%rdx),%ecx
  8041aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041ae:	48 98                	cltq   
  8041b0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b8:	8b 40 04             	mov    0x4(%rax),%eax
  8041bb:	8d 50 01             	lea    0x1(%rax),%edx
  8041be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041d2:	0f 82 64 ff ff ff    	jb     80413c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041dc:	c9                   	leaveq 
  8041dd:	c3                   	retq   

00000000008041de <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041de:	55                   	push   %rbp
  8041df:	48 89 e5             	mov    %rsp,%rbp
  8041e2:	48 83 ec 20          	sub    $0x20,%rsp
  8041e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f2:	48 89 c7             	mov    %rax,%rdi
  8041f5:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  8041fc:	00 00 00 
  8041ff:	ff d0                	callq  *%rax
  804201:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804209:	48 be 99 52 80 00 00 	movabs $0x805299,%rsi
  804210:	00 00 00 
  804213:	48 89 c7             	mov    %rax,%rdi
  804216:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  80421d:	00 00 00 
  804220:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804226:	8b 50 04             	mov    0x4(%rax),%edx
  804229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422d:	8b 00                	mov    (%rax),%eax
  80422f:	29 c2                	sub    %eax,%edx
  804231:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804235:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80423b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80423f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804246:	00 00 00 
	stat->st_dev = &devpipe;
  804249:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80424d:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804254:	00 00 00 
  804257:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80425e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804263:	c9                   	leaveq 
  804264:	c3                   	retq   

0000000000804265 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804265:	55                   	push   %rbp
  804266:	48 89 e5             	mov    %rsp,%rbp
  804269:	48 83 ec 10          	sub    $0x10,%rsp
  80426d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804275:	48 89 c6             	mov    %rax,%rsi
  804278:	bf 00 00 00 00       	mov    $0x0,%edi
  80427d:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  804284:	00 00 00 
  804287:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428d:	48 89 c7             	mov    %rax,%rdi
  804290:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  804297:	00 00 00 
  80429a:	ff d0                	callq  *%rax
  80429c:	48 89 c6             	mov    %rax,%rsi
  80429f:	bf 00 00 00 00       	mov    $0x0,%edi
  8042a4:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8042ab:	00 00 00 
  8042ae:	ff d0                	callq  *%rax
}
  8042b0:	c9                   	leaveq 
  8042b1:	c3                   	retq   

00000000008042b2 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8042b2:	55                   	push   %rbp
  8042b3:	48 89 e5             	mov    %rsp,%rbp
  8042b6:	48 83 ec 20          	sub    $0x20,%rsp
  8042ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8042bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042c1:	75 35                	jne    8042f8 <wait+0x46>
  8042c3:	48 b9 a0 52 80 00 00 	movabs $0x8052a0,%rcx
  8042ca:	00 00 00 
  8042cd:	48 ba ab 52 80 00 00 	movabs $0x8052ab,%rdx
  8042d4:	00 00 00 
  8042d7:	be 09 00 00 00       	mov    $0x9,%esi
  8042dc:	48 bf c0 52 80 00 00 	movabs $0x8052c0,%rdi
  8042e3:	00 00 00 
  8042e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042eb:	49 b8 e9 03 80 00 00 	movabs $0x8003e9,%r8
  8042f2:	00 00 00 
  8042f5:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8042f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  804300:	48 63 d0             	movslq %eax,%rdx
  804303:	48 89 d0             	mov    %rdx,%rax
  804306:	48 c1 e0 03          	shl    $0x3,%rax
  80430a:	48 01 d0             	add    %rdx,%rax
  80430d:	48 c1 e0 05          	shl    $0x5,%rax
  804311:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804318:	00 00 00 
  80431b:	48 01 d0             	add    %rdx,%rax
  80431e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804322:	eb 0c                	jmp    804330 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804324:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  80432b:	00 00 00 
  80432e:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804334:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80433a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80433d:	75 0e                	jne    80434d <wait+0x9b>
  80433f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804343:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804349:	85 c0                	test   %eax,%eax
  80434b:	75 d7                	jne    804324 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80434d:	c9                   	leaveq 
  80434e:	c3                   	retq   

000000000080434f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80434f:	55                   	push   %rbp
  804350:	48 89 e5             	mov    %rsp,%rbp
  804353:	48 83 ec 20          	sub    $0x20,%rsp
  804357:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80435a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80435d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804360:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804364:	be 01 00 00 00       	mov    $0x1,%esi
  804369:	48 89 c7             	mov    %rax,%rdi
  80436c:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  804373:	00 00 00 
  804376:	ff d0                	callq  *%rax
}
  804378:	c9                   	leaveq 
  804379:	c3                   	retq   

000000000080437a <getchar>:

int
getchar(void)
{
  80437a:	55                   	push   %rbp
  80437b:	48 89 e5             	mov    %rsp,%rbp
  80437e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804382:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804386:	ba 01 00 00 00       	mov    $0x1,%edx
  80438b:	48 89 c6             	mov    %rax,%rsi
  80438e:	bf 00 00 00 00       	mov    $0x0,%edi
  804393:	48 b8 f1 29 80 00 00 	movabs $0x8029f1,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
  80439f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a6:	79 05                	jns    8043ad <getchar+0x33>
		return r;
  8043a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ab:	eb 14                	jmp    8043c1 <getchar+0x47>
	if (r < 1)
  8043ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b1:	7f 07                	jg     8043ba <getchar+0x40>
		return -E_EOF;
  8043b3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8043b8:	eb 07                	jmp    8043c1 <getchar+0x47>
	return c;
  8043ba:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8043be:	0f b6 c0             	movzbl %al,%eax
}
  8043c1:	c9                   	leaveq 
  8043c2:	c3                   	retq   

00000000008043c3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8043c3:	55                   	push   %rbp
  8043c4:	48 89 e5             	mov    %rsp,%rbp
  8043c7:	48 83 ec 20          	sub    $0x20,%rsp
  8043cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8043ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8043d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043d5:	48 89 d6             	mov    %rdx,%rsi
  8043d8:	89 c7                	mov    %eax,%edi
  8043da:	48 b8 bf 25 80 00 00 	movabs $0x8025bf,%rax
  8043e1:	00 00 00 
  8043e4:	ff d0                	callq  *%rax
  8043e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ed:	79 05                	jns    8043f4 <iscons+0x31>
		return r;
  8043ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f2:	eb 1a                	jmp    80440e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8043f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f8:	8b 10                	mov    (%rax),%edx
  8043fa:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804401:	00 00 00 
  804404:	8b 00                	mov    (%rax),%eax
  804406:	39 c2                	cmp    %eax,%edx
  804408:	0f 94 c0             	sete   %al
  80440b:	0f b6 c0             	movzbl %al,%eax
}
  80440e:	c9                   	leaveq 
  80440f:	c3                   	retq   

0000000000804410 <opencons>:

int
opencons(void)
{
  804410:	55                   	push   %rbp
  804411:	48 89 e5             	mov    %rsp,%rbp
  804414:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804418:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80441c:	48 89 c7             	mov    %rax,%rdi
  80441f:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  804426:	00 00 00 
  804429:	ff d0                	callq  *%rax
  80442b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80442e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804432:	79 05                	jns    804439 <opencons+0x29>
		return r;
  804434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804437:	eb 5b                	jmp    804494 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443d:	ba 07 04 00 00       	mov    $0x407,%edx
  804442:	48 89 c6             	mov    %rax,%rsi
  804445:	bf 00 00 00 00       	mov    $0x0,%edi
  80444a:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  804451:	00 00 00 
  804454:	ff d0                	callq  *%rax
  804456:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804459:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80445d:	79 05                	jns    804464 <opencons+0x54>
		return r;
  80445f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804462:	eb 30                	jmp    804494 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804468:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  80446f:	00 00 00 
  804472:	8b 12                	mov    (%rdx),%edx
  804474:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804485:	48 89 c7             	mov    %rax,%rdi
  804488:	48 b8 d9 24 80 00 00 	movabs $0x8024d9,%rax
  80448f:	00 00 00 
  804492:	ff d0                	callq  *%rax
}
  804494:	c9                   	leaveq 
  804495:	c3                   	retq   

0000000000804496 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804496:	55                   	push   %rbp
  804497:	48 89 e5             	mov    %rsp,%rbp
  80449a:	48 83 ec 30          	sub    $0x30,%rsp
  80449e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044af:	75 07                	jne    8044b8 <devcons_read+0x22>
		return 0;
  8044b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b6:	eb 4b                	jmp    804503 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8044b8:	eb 0c                	jmp    8044c6 <devcons_read+0x30>
		sys_yield();
  8044ba:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  8044c1:	00 00 00 
  8044c4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8044c6:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  8044cd:	00 00 00 
  8044d0:	ff d0                	callq  *%rax
  8044d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044d9:	74 df                	je     8044ba <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8044db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044df:	79 05                	jns    8044e6 <devcons_read+0x50>
		return c;
  8044e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e4:	eb 1d                	jmp    804503 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8044e6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8044ea:	75 07                	jne    8044f3 <devcons_read+0x5d>
		return 0;
  8044ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f1:	eb 10                	jmp    804503 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8044f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f6:	89 c2                	mov    %eax,%edx
  8044f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044fc:	88 10                	mov    %dl,(%rax)
	return 1;
  8044fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804503:	c9                   	leaveq 
  804504:	c3                   	retq   

0000000000804505 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804505:	55                   	push   %rbp
  804506:	48 89 e5             	mov    %rsp,%rbp
  804509:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804510:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804517:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80451e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804525:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80452c:	eb 76                	jmp    8045a4 <devcons_write+0x9f>
		m = n - tot;
  80452e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804535:	89 c2                	mov    %eax,%edx
  804537:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80453a:	29 c2                	sub    %eax,%edx
  80453c:	89 d0                	mov    %edx,%eax
  80453e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804541:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804544:	83 f8 7f             	cmp    $0x7f,%eax
  804547:	76 07                	jbe    804550 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804549:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804550:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804553:	48 63 d0             	movslq %eax,%rdx
  804556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804559:	48 63 c8             	movslq %eax,%rcx
  80455c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804563:	48 01 c1             	add    %rax,%rcx
  804566:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80456d:	48 89 ce             	mov    %rcx,%rsi
  804570:	48 89 c7             	mov    %rax,%rdi
  804573:	48 b8 fb 14 80 00 00 	movabs $0x8014fb,%rax
  80457a:	00 00 00 
  80457d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80457f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804582:	48 63 d0             	movslq %eax,%rdx
  804585:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80458c:	48 89 d6             	mov    %rdx,%rsi
  80458f:	48 89 c7             	mov    %rax,%rdi
  804592:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  804599:	00 00 00 
  80459c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80459e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045a1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a7:	48 98                	cltq   
  8045a9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045b0:	0f 82 78 ff ff ff    	jb     80452e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8045b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045b9:	c9                   	leaveq 
  8045ba:	c3                   	retq   

00000000008045bb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8045bb:	55                   	push   %rbp
  8045bc:	48 89 e5             	mov    %rsp,%rbp
  8045bf:	48 83 ec 08          	sub    $0x8,%rsp
  8045c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8045c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045cc:	c9                   	leaveq 
  8045cd:	c3                   	retq   

00000000008045ce <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8045ce:	55                   	push   %rbp
  8045cf:	48 89 e5             	mov    %rsp,%rbp
  8045d2:	48 83 ec 10          	sub    $0x10,%rsp
  8045d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8045de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e2:	48 be d0 52 80 00 00 	movabs $0x8052d0,%rsi
  8045e9:	00 00 00 
  8045ec:	48 89 c7             	mov    %rax,%rdi
  8045ef:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  8045f6:	00 00 00 
  8045f9:	ff d0                	callq  *%rax
	return 0;
  8045fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804600:	c9                   	leaveq 
  804601:	c3                   	retq   

0000000000804602 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804602:	55                   	push   %rbp
  804603:	48 89 e5             	mov    %rsp,%rbp
  804606:	48 83 ec 10          	sub    $0x10,%rsp
  80460a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80460e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804615:	00 00 00 
  804618:	48 8b 00             	mov    (%rax),%rax
  80461b:	48 85 c0             	test   %rax,%rax
  80461e:	0f 85 84 00 00 00    	jne    8046a8 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804624:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80462b:	00 00 00 
  80462e:	48 8b 00             	mov    (%rax),%rax
  804631:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804637:	ba 07 00 00 00       	mov    $0x7,%edx
  80463c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804641:	89 c7                	mov    %eax,%edi
  804643:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  80464a:	00 00 00 
  80464d:	ff d0                	callq  *%rax
  80464f:	85 c0                	test   %eax,%eax
  804651:	79 2a                	jns    80467d <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804653:	48 ba d8 52 80 00 00 	movabs $0x8052d8,%rdx
  80465a:	00 00 00 
  80465d:	be 23 00 00 00       	mov    $0x23,%esi
  804662:	48 bf ff 52 80 00 00 	movabs $0x8052ff,%rdi
  804669:	00 00 00 
  80466c:	b8 00 00 00 00       	mov    $0x0,%eax
  804671:	48 b9 e9 03 80 00 00 	movabs $0x8003e9,%rcx
  804678:	00 00 00 
  80467b:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80467d:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804684:	00 00 00 
  804687:	48 8b 00             	mov    (%rax),%rax
  80468a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804690:	48 be bb 46 80 00 00 	movabs $0x8046bb,%rsi
  804697:	00 00 00 
  80469a:	89 c7                	mov    %eax,%edi
  80469c:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  8046a3:	00 00 00 
  8046a6:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046a8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046af:	00 00 00 
  8046b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046b6:	48 89 10             	mov    %rdx,(%rax)
}
  8046b9:	c9                   	leaveq 
  8046ba:	c3                   	retq   

00000000008046bb <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046bb:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046be:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8046c5:	00 00 00 
call *%rax
  8046c8:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8046ca:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8046d1:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8046d2:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8046d9:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8046da:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8046de:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8046e1:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8046e8:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8046e9:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8046ed:	4c 8b 3c 24          	mov    (%rsp),%r15
  8046f1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8046f6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8046fb:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804700:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804705:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80470a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80470f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804714:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804719:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80471e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804723:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804728:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80472d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804732:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804737:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  80473b:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80473f:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804740:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804741:	c3                   	retq   

0000000000804742 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804742:	55                   	push   %rbp
  804743:	48 89 e5             	mov    %rsp,%rbp
  804746:	48 83 ec 30          	sub    $0x30,%rsp
  80474a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80474e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804752:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804756:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80475d:	00 00 00 
  804760:	48 8b 00             	mov    (%rax),%rax
  804763:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804769:	85 c0                	test   %eax,%eax
  80476b:	75 3c                	jne    8047a9 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80476d:	48 b8 8a 1a 80 00 00 	movabs $0x801a8a,%rax
  804774:	00 00 00 
  804777:	ff d0                	callq  *%rax
  804779:	25 ff 03 00 00       	and    $0x3ff,%eax
  80477e:	48 63 d0             	movslq %eax,%rdx
  804781:	48 89 d0             	mov    %rdx,%rax
  804784:	48 c1 e0 03          	shl    $0x3,%rax
  804788:	48 01 d0             	add    %rdx,%rax
  80478b:	48 c1 e0 05          	shl    $0x5,%rax
  80478f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804796:	00 00 00 
  804799:	48 01 c2             	add    %rax,%rdx
  80479c:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8047a3:	00 00 00 
  8047a6:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8047a9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047ae:	75 0e                	jne    8047be <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8047b0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047b7:	00 00 00 
  8047ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8047be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047c2:	48 89 c7             	mov    %rax,%rdi
  8047c5:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  8047cc:	00 00 00 
  8047cf:	ff d0                	callq  *%rax
  8047d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8047d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d8:	79 19                	jns    8047f3 <ipc_recv+0xb1>
		*from_env_store = 0;
  8047da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047de:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8047e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8047ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f1:	eb 53                	jmp    804846 <ipc_recv+0x104>
	}
	if(from_env_store)
  8047f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047f8:	74 19                	je     804813 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8047fa:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804801:	00 00 00 
  804804:	48 8b 00             	mov    (%rax),%rax
  804807:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80480d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804811:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804813:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804818:	74 19                	je     804833 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80481a:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804821:	00 00 00 
  804824:	48 8b 00             	mov    (%rax),%rax
  804827:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80482d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804831:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804833:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80483a:	00 00 00 
  80483d:	48 8b 00             	mov    (%rax),%rax
  804840:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804846:	c9                   	leaveq 
  804847:	c3                   	retq   

0000000000804848 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804848:	55                   	push   %rbp
  804849:	48 89 e5             	mov    %rsp,%rbp
  80484c:	48 83 ec 30          	sub    $0x30,%rsp
  804850:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804853:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804856:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80485a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80485d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804862:	75 0e                	jne    804872 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804864:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80486b:	00 00 00 
  80486e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804872:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804875:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804878:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80487c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80487f:	89 c7                	mov    %eax,%edi
  804881:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  804888:	00 00 00 
  80488b:	ff d0                	callq  *%rax
  80488d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804890:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804894:	75 0c                	jne    8048a2 <ipc_send+0x5a>
			sys_yield();
  804896:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  80489d:	00 00 00 
  8048a0:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8048a2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048a6:	74 ca                	je     804872 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8048a8:	c9                   	leaveq 
  8048a9:	c3                   	retq   

00000000008048aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8048aa:	55                   	push   %rbp
  8048ab:	48 89 e5             	mov    %rsp,%rbp
  8048ae:	48 83 ec 14          	sub    $0x14,%rsp
  8048b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8048b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048bc:	eb 5e                	jmp    80491c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048be:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048c5:	00 00 00 
  8048c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048cb:	48 63 d0             	movslq %eax,%rdx
  8048ce:	48 89 d0             	mov    %rdx,%rax
  8048d1:	48 c1 e0 03          	shl    $0x3,%rax
  8048d5:	48 01 d0             	add    %rdx,%rax
  8048d8:	48 c1 e0 05          	shl    $0x5,%rax
  8048dc:	48 01 c8             	add    %rcx,%rax
  8048df:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048e5:	8b 00                	mov    (%rax),%eax
  8048e7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048ea:	75 2c                	jne    804918 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048ec:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048f3:	00 00 00 
  8048f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f9:	48 63 d0             	movslq %eax,%rdx
  8048fc:	48 89 d0             	mov    %rdx,%rax
  8048ff:	48 c1 e0 03          	shl    $0x3,%rax
  804903:	48 01 d0             	add    %rdx,%rax
  804906:	48 c1 e0 05          	shl    $0x5,%rax
  80490a:	48 01 c8             	add    %rcx,%rax
  80490d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804913:	8b 40 08             	mov    0x8(%rax),%eax
  804916:	eb 12                	jmp    80492a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804918:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80491c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804923:	7e 99                	jle    8048be <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80492a:	c9                   	leaveq 
  80492b:	c3                   	retq   

000000000080492c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80492c:	55                   	push   %rbp
  80492d:	48 89 e5             	mov    %rsp,%rbp
  804930:	48 83 ec 18          	sub    $0x18,%rsp
  804934:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80493c:	48 c1 e8 15          	shr    $0x15,%rax
  804940:	48 89 c2             	mov    %rax,%rdx
  804943:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80494a:	01 00 00 
  80494d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804951:	83 e0 01             	and    $0x1,%eax
  804954:	48 85 c0             	test   %rax,%rax
  804957:	75 07                	jne    804960 <pageref+0x34>
		return 0;
  804959:	b8 00 00 00 00       	mov    $0x0,%eax
  80495e:	eb 53                	jmp    8049b3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804964:	48 c1 e8 0c          	shr    $0xc,%rax
  804968:	48 89 c2             	mov    %rax,%rdx
  80496b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804972:	01 00 00 
  804975:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804979:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80497d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804981:	83 e0 01             	and    $0x1,%eax
  804984:	48 85 c0             	test   %rax,%rax
  804987:	75 07                	jne    804990 <pageref+0x64>
		return 0;
  804989:	b8 00 00 00 00       	mov    $0x0,%eax
  80498e:	eb 23                	jmp    8049b3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804994:	48 c1 e8 0c          	shr    $0xc,%rax
  804998:	48 89 c2             	mov    %rax,%rdx
  80499b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049a2:	00 00 00 
  8049a5:	48 c1 e2 04          	shl    $0x4,%rdx
  8049a9:	48 01 d0             	add    %rdx,%rax
  8049ac:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049b0:	0f b7 c0             	movzwl %ax,%eax
}
  8049b3:	c9                   	leaveq 
  8049b4:	c3                   	retq   
