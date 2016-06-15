
obj/user/writemotd.debug:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  800067:	00 00 00 
  80006a:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 89 41 80 00 00 	movabs $0x804189,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf ac 41 80 00 00 	movabs $0x8041ac,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba b2 41 80 00 00 	movabs $0x8041b2,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf c1 41 80 00 00 	movabs $0x8041c1,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 25 04 80 00 00 	movabs $0x800425,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 12 42 80 00 00 	movabs $0x804212,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 b1 25 80 00 00 	movabs $0x8025b1,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 f6 25 80 00 00 	movabs $0x8025f6,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 25 42 80 00 00 	movabs $0x804225,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba 46 42 80 00 00 	movabs $0x804246,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba 56 42 80 00 00 	movabs $0x804256,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 9b 41 80 00 00 	movabs $0x80419b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800386:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	25 ff 03 00 00       	and    $0x3ff,%eax
  800397:	48 63 d0             	movslq %eax,%rdx
  80039a:	48 89 d0             	mov    %rdx,%rax
  80039d:	48 c1 e0 03          	shl    $0x3,%rax
  8003a1:	48 01 d0             	add    %rdx,%rax
  8003a4:	48 c1 e0 05          	shl    $0x5,%rax
  8003a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003af:	00 00 00 
  8003b2:	48 01 c2             	add    %rax,%rdx
  8003b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003bc:	00 00 00 
  8003bf:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003c6:	7e 14                	jle    8003dc <libmain+0x65>
		binaryname = argv[0];
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	48 8b 10             	mov    (%rax),%rdx
  8003cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003d6:	00 00 00 
  8003d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e3:	48 89 d6             	mov    %rdx,%rsi
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003f4:	48 b8 02 04 80 00 00 	movabs $0x800402,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	callq  *%rax
}
  800400:	c9                   	leaveq 
  800401:	c3                   	retq   

0000000000800402 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800402:	55                   	push   %rbp
  800403:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800406:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  80040d:	00 00 00 
  800410:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800412:	bf 00 00 00 00       	mov    $0x0,%edi
  800417:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax

}
  800423:	5d                   	pop    %rbp
  800424:	c3                   	retq   

0000000000800425 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	53                   	push   %rbx
  80042a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800431:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800438:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80043e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800445:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80044c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800453:	84 c0                	test   %al,%al
  800455:	74 23                	je     80047a <_panic+0x55>
  800457:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80045e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800462:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800466:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80046a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80046e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800472:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800476:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80047a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800481:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800488:	00 00 00 
  80048b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800492:	00 00 00 
  800495:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800499:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004b5:	00 00 00 
  8004b8:	48 8b 18             	mov    (%rax),%rbx
  8004bb:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  8004c2:	00 00 00 
  8004c5:	ff d0                	callq  *%rax
  8004c7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004cd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004d4:	41 89 c8             	mov    %ecx,%r8d
  8004d7:	48 89 d1             	mov    %rdx,%rcx
  8004da:	48 89 da             	mov    %rbx,%rdx
  8004dd:	89 c6                	mov    %eax,%esi
  8004df:	48 bf 78 42 80 00 00 	movabs $0x804278,%rdi
  8004e6:	00 00 00 
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	49 b9 5e 06 80 00 00 	movabs $0x80065e,%r9
  8004f5:	00 00 00 
  8004f8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004fb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800502:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800509:	48 89 d6             	mov    %rdx,%rsi
  80050c:	48 89 c7             	mov    %rax,%rdi
  80050f:	48 b8 b2 05 80 00 00 	movabs $0x8005b2,%rax
  800516:	00 00 00 
  800519:	ff d0                	callq  *%rax
	cprintf("\n");
  80051b:	48 bf 9b 42 80 00 00 	movabs $0x80429b,%rdi
  800522:	00 00 00 
  800525:	b8 00 00 00 00       	mov    $0x0,%eax
  80052a:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  800531:	00 00 00 
  800534:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800536:	cc                   	int3   
  800537:	eb fd                	jmp    800536 <_panic+0x111>

0000000000800539 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800539:	55                   	push   %rbp
  80053a:	48 89 e5             	mov    %rsp,%rbp
  80053d:	48 83 ec 10          	sub    $0x10,%rsp
  800541:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800544:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054c:	8b 00                	mov    (%rax),%eax
  80054e:	8d 48 01             	lea    0x1(%rax),%ecx
  800551:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800555:	89 0a                	mov    %ecx,(%rdx)
  800557:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80055a:	89 d1                	mov    %edx,%ecx
  80055c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800560:	48 98                	cltq   
  800562:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056a:	8b 00                	mov    (%rax),%eax
  80056c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800571:	75 2c                	jne    80059f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800577:	8b 00                	mov    (%rax),%eax
  800579:	48 98                	cltq   
  80057b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057f:	48 83 c2 08          	add    $0x8,%rdx
  800583:	48 89 c6             	mov    %rax,%rsi
  800586:	48 89 d7             	mov    %rdx,%rdi
  800589:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800590:	00 00 00 
  800593:	ff d0                	callq  *%rax
        b->idx = 0;
  800595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800599:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80059f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a3:	8b 40 04             	mov    0x4(%rax),%eax
  8005a6:	8d 50 01             	lea    0x1(%rax),%edx
  8005a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ad:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b0:	c9                   	leaveq 
  8005b1:	c3                   	retq   

00000000008005b2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b2:	55                   	push   %rbp
  8005b3:	48 89 e5             	mov    %rsp,%rbp
  8005b6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005bd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005c4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005cb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005d9:	48 8b 0a             	mov    (%rdx),%rcx
  8005dc:	48 89 08             	mov    %rcx,(%rax)
  8005df:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005eb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005f6:	00 00 00 
    b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800600:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800603:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80060a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800611:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800618:	48 89 c6             	mov    %rax,%rsi
  80061b:	48 bf 39 05 80 00 00 	movabs $0x800539,%rdi
  800622:	00 00 00 
  800625:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  80062c:	00 00 00 
  80062f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800631:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800637:	48 98                	cltq   
  800639:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800640:	48 83 c2 08          	add    $0x8,%rdx
  800644:	48 89 c6             	mov    %rax,%rsi
  800647:	48 89 d7             	mov    %rdx,%rdi
  80064a:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  800651:	00 00 00 
  800654:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800656:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80065c:	c9                   	leaveq 
  80065d:	c3                   	retq   

000000000080065e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800669:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800670:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800677:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80067e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800685:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80068c:	84 c0                	test   %al,%al
  80068e:	74 20                	je     8006b0 <cprintf+0x52>
  800690:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800694:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800698:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80069c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006a4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006a8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006ac:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006b7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006be:	00 00 00 
  8006c1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006c8:	00 00 00 
  8006cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006cf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006d6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006dd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006e4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f2:	48 8b 0a             	mov    (%rdx),%rcx
  8006f5:	48 89 08             	mov    %rcx,(%rax)
  8006f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800700:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800704:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800708:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80070f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800716:	48 89 d6             	mov    %rdx,%rsi
  800719:	48 89 c7             	mov    %rax,%rdi
  80071c:	48 b8 b2 05 80 00 00 	movabs $0x8005b2,%rax
  800723:	00 00 00 
  800726:	ff d0                	callq  *%rax
  800728:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80072e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800734:	c9                   	leaveq 
  800735:	c3                   	retq   

0000000000800736 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800736:	55                   	push   %rbp
  800737:	48 89 e5             	mov    %rsp,%rbp
  80073a:	53                   	push   %rbx
  80073b:	48 83 ec 38          	sub    $0x38,%rsp
  80073f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800743:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80074b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80074e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800752:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800756:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800759:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80075d:	77 3b                	ja     80079a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800762:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800766:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	48 f7 f3             	div    %rbx
  800775:	48 89 c2             	mov    %rax,%rdx
  800778:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80077b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80077e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	41 89 f9             	mov    %edi,%r9d
  800789:	48 89 c7             	mov    %rax,%rdi
  80078c:	48 b8 36 07 80 00 00 	movabs $0x800736,%rax
  800793:	00 00 00 
  800796:	ff d0                	callq  *%rax
  800798:	eb 1e                	jmp    8007b8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079a:	eb 12                	jmp    8007ae <printnum+0x78>
			putch(padc, putdat);
  80079c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	48 89 ce             	mov    %rcx,%rsi
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ae:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007b6:	7f e4                	jg     80079c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007b8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	48 f7 f1             	div    %rcx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 ba 90 44 80 00 00 	movabs $0x804490,%rdx
  8007d1:	00 00 00 
  8007d4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007d8:	0f be d0             	movsbl %al,%edx
  8007db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	48 89 ce             	mov    %rcx,%rsi
  8007e6:	89 d7                	mov    %edx,%edi
  8007e8:	ff d0                	callq  *%rax
}
  8007ea:	48 83 c4 38          	add    $0x38,%rsp
  8007ee:	5b                   	pop    %rbx
  8007ef:	5d                   	pop    %rbp
  8007f0:	c3                   	retq   

00000000008007f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f1:	55                   	push   %rbp
  8007f2:	48 89 e5             	mov    %rsp,%rbp
  8007f5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007fd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800800:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800804:	7e 52                	jle    800858 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getuint+0x44>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getuint+0x5b>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	48 8b 00             	mov    (%rax),%rax
  80084f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800853:	e9 a3 00 00 00       	jmpq   8008fb <getuint+0x10a>
	else if (lflag)
  800858:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80085c:	74 4f                	je     8008ad <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80085e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800862:	8b 00                	mov    (%rax),%eax
  800864:	83 f8 30             	cmp    $0x30,%eax
  800867:	73 24                	jae    80088d <getuint+0x9c>
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	8b 00                	mov    (%rax),%eax
  800877:	89 c0                	mov    %eax,%eax
  800879:	48 01 d0             	add    %rdx,%rax
  80087c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800880:	8b 12                	mov    (%rdx),%edx
  800882:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	89 0a                	mov    %ecx,(%rdx)
  80088b:	eb 17                	jmp    8008a4 <getuint+0xb3>
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800895:	48 89 d0             	mov    %rdx,%rax
  800898:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a4:	48 8b 00             	mov    (%rax),%rax
  8008a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ab:	eb 4e                	jmp    8008fb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b1:	8b 00                	mov    (%rax),%eax
  8008b3:	83 f8 30             	cmp    $0x30,%eax
  8008b6:	73 24                	jae    8008dc <getuint+0xeb>
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c4:	8b 00                	mov    (%rax),%eax
  8008c6:	89 c0                	mov    %eax,%eax
  8008c8:	48 01 d0             	add    %rdx,%rax
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	8b 12                	mov    (%rdx),%edx
  8008d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d8:	89 0a                	mov    %ecx,(%rdx)
  8008da:	eb 17                	jmp    8008f3 <getuint+0x102>
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e4:	48 89 d0             	mov    %rdx,%rax
  8008e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	89 c0                	mov    %eax,%eax
  8008f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ff:	c9                   	leaveq 
  800900:	c3                   	retq   

0000000000800901 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800901:	55                   	push   %rbp
  800902:	48 89 e5             	mov    %rsp,%rbp
  800905:	48 83 ec 1c          	sub    $0x1c,%rsp
  800909:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80090d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800910:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800914:	7e 52                	jle    800968 <getint+0x67>
		x=va_arg(*ap, long long);
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 24                	jae    800945 <getint+0x44>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	8b 12                	mov    (%rdx),%edx
  80093a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	89 0a                	mov    %ecx,(%rdx)
  800943:	eb 17                	jmp    80095c <getint+0x5b>
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80094d:	48 89 d0             	mov    %rdx,%rax
  800950:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095c:	48 8b 00             	mov    (%rax),%rax
  80095f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800963:	e9 a3 00 00 00       	jmpq   800a0b <getint+0x10a>
	else if (lflag)
  800968:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80096c:	74 4f                	je     8009bd <getint+0xbc>
		x=va_arg(*ap, long);
  80096e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800972:	8b 00                	mov    (%rax),%eax
  800974:	83 f8 30             	cmp    $0x30,%eax
  800977:	73 24                	jae    80099d <getint+0x9c>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	89 c0                	mov    %eax,%eax
  800989:	48 01 d0             	add    %rdx,%rax
  80098c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800990:	8b 12                	mov    (%rdx),%edx
  800992:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	89 0a                	mov    %ecx,(%rdx)
  80099b:	eb 17                	jmp    8009b4 <getint+0xb3>
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a5:	48 89 d0             	mov    %rdx,%rax
  8009a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b4:	48 8b 00             	mov    (%rax),%rax
  8009b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009bb:	eb 4e                	jmp    800a0b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	8b 00                	mov    (%rax),%eax
  8009c3:	83 f8 30             	cmp    $0x30,%eax
  8009c6:	73 24                	jae    8009ec <getint+0xeb>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d4:	8b 00                	mov    (%rax),%eax
  8009d6:	89 c0                	mov    %eax,%eax
  8009d8:	48 01 d0             	add    %rdx,%rax
  8009db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009df:	8b 12                	mov    (%rdx),%edx
  8009e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	89 0a                	mov    %ecx,(%rdx)
  8009ea:	eb 17                	jmp    800a03 <getint+0x102>
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f4:	48 89 d0             	mov    %rdx,%rax
  8009f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a03:	8b 00                	mov    (%rax),%eax
  800a05:	48 98                	cltq   
  800a07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a0f:	c9                   	leaveq 
  800a10:	c3                   	retq   

0000000000800a11 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a11:	55                   	push   %rbp
  800a12:	48 89 e5             	mov    %rsp,%rbp
  800a15:	41 54                	push   %r12
  800a17:	53                   	push   %rbx
  800a18:	48 83 ec 60          	sub    $0x60,%rsp
  800a1c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a20:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a24:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a28:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a30:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a34:	48 8b 0a             	mov    (%rdx),%rcx
  800a37:	48 89 08             	mov    %rcx,(%rax)
  800a3a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a3e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a42:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a46:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4a:	eb 17                	jmp    800a63 <vprintfmt+0x52>
			if (ch == '\0')
  800a4c:	85 db                	test   %ebx,%ebx
  800a4e:	0f 84 cc 04 00 00    	je     800f20 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5c:	48 89 d6             	mov    %rdx,%rsi
  800a5f:	89 df                	mov    %ebx,%edi
  800a61:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6f:	0f b6 00             	movzbl (%rax),%eax
  800a72:	0f b6 d8             	movzbl %al,%ebx
  800a75:	83 fb 25             	cmp    $0x25,%ebx
  800a78:	75 d2                	jne    800a4c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a7e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a85:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a93:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a9e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aa6:	0f b6 00             	movzbl (%rax),%eax
  800aa9:	0f b6 d8             	movzbl %al,%ebx
  800aac:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800aaf:	83 f8 55             	cmp    $0x55,%eax
  800ab2:	0f 87 34 04 00 00    	ja     800eec <vprintfmt+0x4db>
  800ab8:	89 c0                	mov    %eax,%eax
  800aba:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac1:	00 
  800ac2:	48 b8 b8 44 80 00 00 	movabs $0x8044b8,%rax
  800ac9:	00 00 00 
  800acc:	48 01 d0             	add    %rdx,%rax
  800acf:	48 8b 00             	mov    (%rax),%rax
  800ad2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ad4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ad8:	eb c0                	jmp    800a9a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ada:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ade:	eb ba                	jmp    800a9a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ae7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aea:	89 d0                	mov    %edx,%eax
  800aec:	c1 e0 02             	shl    $0x2,%eax
  800aef:	01 d0                	add    %edx,%eax
  800af1:	01 c0                	add    %eax,%eax
  800af3:	01 d8                	add    %ebx,%eax
  800af5:	83 e8 30             	sub    $0x30,%eax
  800af8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800afb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aff:	0f b6 00             	movzbl (%rax),%eax
  800b02:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b05:	83 fb 2f             	cmp    $0x2f,%ebx
  800b08:	7e 0c                	jle    800b16 <vprintfmt+0x105>
  800b0a:	83 fb 39             	cmp    $0x39,%ebx
  800b0d:	7f 07                	jg     800b16 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b14:	eb d1                	jmp    800ae7 <vprintfmt+0xd6>
			goto process_precision;
  800b16:	eb 58                	jmp    800b70 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1b:	83 f8 30             	cmp    $0x30,%eax
  800b1e:	73 17                	jae    800b37 <vprintfmt+0x126>
  800b20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b27:	89 c0                	mov    %eax,%eax
  800b29:	48 01 d0             	add    %rdx,%rax
  800b2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2f:	83 c2 08             	add    $0x8,%edx
  800b32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b35:	eb 0f                	jmp    800b46 <vprintfmt+0x135>
  800b37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3b:	48 89 d0             	mov    %rdx,%rax
  800b3e:	48 83 c2 08          	add    $0x8,%rdx
  800b42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b46:	8b 00                	mov    (%rax),%eax
  800b48:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b51:	79 0c                	jns    800b5f <vprintfmt+0x14e>
				width = 0;
  800b53:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b5a:	e9 3b ff ff ff       	jmpq   800a9a <vprintfmt+0x89>
  800b5f:	e9 36 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b6b:	e9 2a ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b70:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b74:	79 12                	jns    800b88 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b76:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b79:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b7c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b83:	e9 12 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>
  800b88:	e9 0d ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b8d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b91:	e9 04 ff ff ff       	jmpq   800a9a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b99:	83 f8 30             	cmp    $0x30,%eax
  800b9c:	73 17                	jae    800bb5 <vprintfmt+0x1a4>
  800b9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba5:	89 c0                	mov    %eax,%eax
  800ba7:	48 01 d0             	add    %rdx,%rax
  800baa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bad:	83 c2 08             	add    $0x8,%edx
  800bb0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb3:	eb 0f                	jmp    800bc4 <vprintfmt+0x1b3>
  800bb5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb9:	48 89 d0             	mov    %rdx,%rax
  800bbc:	48 83 c2 08          	add    $0x8,%rdx
  800bc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc4:	8b 10                	mov    (%rax),%edx
  800bc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 ce             	mov    %rcx,%rsi
  800bd1:	89 d7                	mov    %edx,%edi
  800bd3:	ff d0                	callq  *%rax
			break;
  800bd5:	e9 40 03 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdd:	83 f8 30             	cmp    $0x30,%eax
  800be0:	73 17                	jae    800bf9 <vprintfmt+0x1e8>
  800be2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800be6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be9:	89 c0                	mov    %eax,%eax
  800beb:	48 01 d0             	add    %rdx,%rax
  800bee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf1:	83 c2 08             	add    $0x8,%edx
  800bf4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bf7:	eb 0f                	jmp    800c08 <vprintfmt+0x1f7>
  800bf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfd:	48 89 d0             	mov    %rdx,%rax
  800c00:	48 83 c2 08          	add    $0x8,%rdx
  800c04:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c08:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c0a:	85 db                	test   %ebx,%ebx
  800c0c:	79 02                	jns    800c10 <vprintfmt+0x1ff>
				err = -err;
  800c0e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c10:	83 fb 15             	cmp    $0x15,%ebx
  800c13:	7f 16                	jg     800c2b <vprintfmt+0x21a>
  800c15:	48 b8 e0 43 80 00 00 	movabs $0x8043e0,%rax
  800c1c:	00 00 00 
  800c1f:	48 63 d3             	movslq %ebx,%rdx
  800c22:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c26:	4d 85 e4             	test   %r12,%r12
  800c29:	75 2e                	jne    800c59 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c33:	89 d9                	mov    %ebx,%ecx
  800c35:	48 ba a1 44 80 00 00 	movabs $0x8044a1,%rdx
  800c3c:	00 00 00 
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
  800c47:	49 b8 29 0f 80 00 00 	movabs $0x800f29,%r8
  800c4e:	00 00 00 
  800c51:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c54:	e9 c1 02 00 00       	jmpq   800f1a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c61:	4c 89 e1             	mov    %r12,%rcx
  800c64:	48 ba aa 44 80 00 00 	movabs $0x8044aa,%rdx
  800c6b:	00 00 00 
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	49 b8 29 0f 80 00 00 	movabs $0x800f29,%r8
  800c7d:	00 00 00 
  800c80:	41 ff d0             	callq  *%r8
			break;
  800c83:	e9 92 02 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8b:	83 f8 30             	cmp    $0x30,%eax
  800c8e:	73 17                	jae    800ca7 <vprintfmt+0x296>
  800c90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c97:	89 c0                	mov    %eax,%eax
  800c99:	48 01 d0             	add    %rdx,%rax
  800c9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c9f:	83 c2 08             	add    $0x8,%edx
  800ca2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca5:	eb 0f                	jmp    800cb6 <vprintfmt+0x2a5>
  800ca7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cab:	48 89 d0             	mov    %rdx,%rax
  800cae:	48 83 c2 08          	add    $0x8,%rdx
  800cb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb6:	4c 8b 20             	mov    (%rax),%r12
  800cb9:	4d 85 e4             	test   %r12,%r12
  800cbc:	75 0a                	jne    800cc8 <vprintfmt+0x2b7>
				p = "(null)";
  800cbe:	49 bc ad 44 80 00 00 	movabs $0x8044ad,%r12
  800cc5:	00 00 00 
			if (width > 0 && padc != '-')
  800cc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccc:	7e 3f                	jle    800d0d <vprintfmt+0x2fc>
  800cce:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd2:	74 39                	je     800d0d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cd7:	48 98                	cltq   
  800cd9:	48 89 c6             	mov    %rax,%rsi
  800cdc:	4c 89 e7             	mov    %r12,%rdi
  800cdf:	48 b8 d5 11 80 00 00 	movabs $0x8011d5,%rax
  800ce6:	00 00 00 
  800ce9:	ff d0                	callq  *%rax
  800ceb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cee:	eb 17                	jmp    800d07 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cf4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfc:	48 89 ce             	mov    %rcx,%rsi
  800cff:	89 d7                	mov    %edx,%edi
  800d01:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d0b:	7f e3                	jg     800cf0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0d:	eb 37                	jmp    800d46 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d0f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d13:	74 1e                	je     800d33 <vprintfmt+0x322>
  800d15:	83 fb 1f             	cmp    $0x1f,%ebx
  800d18:	7e 05                	jle    800d1f <vprintfmt+0x30e>
  800d1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800d1d:	7e 14                	jle    800d33 <vprintfmt+0x322>
					putch('?', putdat);
  800d1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d27:	48 89 d6             	mov    %rdx,%rsi
  800d2a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d2f:	ff d0                	callq  *%rax
  800d31:	eb 0f                	jmp    800d42 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	89 df                	mov    %ebx,%edi
  800d40:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d46:	4c 89 e0             	mov    %r12,%rax
  800d49:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d4d:	0f b6 00             	movzbl (%rax),%eax
  800d50:	0f be d8             	movsbl %al,%ebx
  800d53:	85 db                	test   %ebx,%ebx
  800d55:	74 10                	je     800d67 <vprintfmt+0x356>
  800d57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d5b:	78 b2                	js     800d0f <vprintfmt+0x2fe>
  800d5d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d65:	79 a8                	jns    800d0f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	eb 16                	jmp    800d7f <vprintfmt+0x36e>
				putch(' ', putdat);
  800d69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	48 89 d6             	mov    %rdx,%rsi
  800d74:	bf 20 00 00 00       	mov    $0x20,%edi
  800d79:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d83:	7f e4                	jg     800d69 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d85:	e9 90 01 00 00       	jmpq   800f1a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d8e:	be 03 00 00 00       	mov    $0x3,%esi
  800d93:	48 89 c7             	mov    %rax,%rdi
  800d96:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800d9d:	00 00 00 
  800da0:	ff d0                	callq  *%rax
  800da2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daa:	48 85 c0             	test   %rax,%rax
  800dad:	79 1d                	jns    800dcc <vprintfmt+0x3bb>
				putch('-', putdat);
  800daf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db7:	48 89 d6             	mov    %rdx,%rsi
  800dba:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dbf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc5:	48 f7 d8             	neg    %rax
  800dc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dcc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd3:	e9 d5 00 00 00       	jmpq   800ead <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ddc:	be 03 00 00 00       	mov    $0x3,%esi
  800de1:	48 89 c7             	mov    %rax,%rdi
  800de4:	48 b8 f1 07 80 00 00 	movabs $0x8007f1,%rax
  800deb:	00 00 00 
  800dee:	ff d0                	callq  *%rax
  800df0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800df4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dfb:	e9 ad 00 00 00       	jmpq   800ead <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e00:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e07:	89 d6                	mov    %edx,%esi
  800e09:	48 89 c7             	mov    %rax,%rdi
  800e0c:	48 b8 01 09 80 00 00 	movabs $0x800901,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e1c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e23:	e9 85 00 00 00       	jmpq   800ead <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e30:	48 89 d6             	mov    %rdx,%rsi
  800e33:	bf 30 00 00 00       	mov    $0x30,%edi
  800e38:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e42:	48 89 d6             	mov    %rdx,%rsi
  800e45:	bf 78 00 00 00       	mov    $0x78,%edi
  800e4a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4f:	83 f8 30             	cmp    $0x30,%eax
  800e52:	73 17                	jae    800e6b <vprintfmt+0x45a>
  800e54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5b:	89 c0                	mov    %eax,%eax
  800e5d:	48 01 d0             	add    %rdx,%rax
  800e60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e63:	83 c2 08             	add    $0x8,%edx
  800e66:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e69:	eb 0f                	jmp    800e7a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6f:	48 89 d0             	mov    %rdx,%rax
  800e72:	48 83 c2 08          	add    $0x8,%rdx
  800e76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e81:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e88:	eb 23                	jmp    800ead <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8e:	be 03 00 00 00       	mov    $0x3,%esi
  800e93:	48 89 c7             	mov    %rax,%rdi
  800e96:	48 b8 f1 07 80 00 00 	movabs $0x8007f1,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
  800ea2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ead:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec4:	45 89 c1             	mov    %r8d,%r9d
  800ec7:	41 89 f8             	mov    %edi,%r8d
  800eca:	48 89 c7             	mov    %rax,%rdi
  800ecd:	48 b8 36 07 80 00 00 	movabs $0x800736,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
			break;
  800ed9:	eb 3f                	jmp    800f1a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800edb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee3:	48 89 d6             	mov    %rdx,%rsi
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	ff d0                	callq  *%rax
			break;
  800eea:	eb 2e                	jmp    800f1a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef4:	48 89 d6             	mov    %rdx,%rsi
  800ef7:	bf 25 00 00 00       	mov    $0x25,%edi
  800efc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f03:	eb 05                	jmp    800f0a <vprintfmt+0x4f9>
  800f05:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f0a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0e:	48 83 e8 01          	sub    $0x1,%rax
  800f12:	0f b6 00             	movzbl (%rax),%eax
  800f15:	3c 25                	cmp    $0x25,%al
  800f17:	75 ec                	jne    800f05 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f19:	90                   	nop
		}
	}
  800f1a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1b:	e9 43 fb ff ff       	jmpq   800a63 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f20:	48 83 c4 60          	add    $0x60,%rsp
  800f24:	5b                   	pop    %rbx
  800f25:	41 5c                	pop    %r12
  800f27:	5d                   	pop    %rbp
  800f28:	c3                   	retq   

0000000000800f29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f29:	55                   	push   %rbp
  800f2a:	48 89 e5             	mov    %rsp,%rbp
  800f2d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f34:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f3b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f42:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f49:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f50:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	74 20                	je     800f7b <printfmt+0x52>
  800f5b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f63:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f67:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f73:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f77:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f82:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f89:	00 00 00 
  800f8c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f93:	00 00 00 
  800f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800faf:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fcb:	48 89 c7             	mov    %rax,%rdi
  800fce:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  800fd5:	00 00 00 
  800fd8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 10          	sub    $0x10,%rsp
  800fe4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fef:	8b 40 10             	mov    0x10(%rax),%eax
  800ff2:	8d 50 01             	lea    0x1(%rax),%edx
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801000:	48 8b 10             	mov    (%rax),%rdx
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	48 8b 40 08          	mov    0x8(%rax),%rax
  80100b:	48 39 c2             	cmp    %rax,%rdx
  80100e:	73 17                	jae    801027 <sprintputch+0x4b>
		*b->buf++ = ch;
  801010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801014:	48 8b 00             	mov    (%rax),%rax
  801017:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80101b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80101f:	48 89 0a             	mov    %rcx,(%rdx)
  801022:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801025:	88 10                	mov    %dl,(%rax)
}
  801027:	c9                   	leaveq 
  801028:	c3                   	retq   

0000000000801029 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	48 83 ec 50          	sub    $0x50,%rsp
  801031:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801035:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801038:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801040:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801044:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801048:	48 8b 0a             	mov    (%rdx),%rcx
  80104b:	48 89 08             	mov    %rcx,(%rax)
  80104e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801052:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801056:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801062:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801066:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801069:	48 98                	cltq   
  80106b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80106f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801073:	48 01 d0             	add    %rdx,%rax
  801076:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80107a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801081:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801086:	74 06                	je     80108e <vsnprintf+0x65>
  801088:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80108c:	7f 07                	jg     801095 <vsnprintf+0x6c>
		return -E_INVAL;
  80108e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801093:	eb 2f                	jmp    8010c4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801095:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801099:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a1:	48 89 c6             	mov    %rax,%rsi
  8010a4:	48 bf dc 0f 80 00 00 	movabs $0x800fdc,%rdi
  8010ab:	00 00 00 
  8010ae:	48 b8 11 0a 80 00 00 	movabs $0x800a11,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010be:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 20                	je     801117 <snprintf+0x51>
  8010f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801103:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801107:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801113:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801117:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801125:	00 00 00 
  801128:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112f:	00 00 00 
  801132:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801136:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801144:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80114b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801152:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801159:	48 8b 0a             	mov    (%rdx),%rcx
  80115c:	48 89 08             	mov    %rcx,(%rax)
  80115f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801163:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801167:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80116b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801176:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801183:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80118a:	48 89 c7             	mov    %rax,%rdi
  80118d:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  801194:	00 00 00 
  801197:	ff d0                	callq  *%rax
  801199:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 18          	sub    $0x18,%rsp
  8011af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ba:	eb 09                	jmp    8011c5 <strlen+0x1e>
		n++;
  8011bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 ec                	jne    8011bc <strlen+0x15>
		n++;
	return n;
  8011d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d3:	c9                   	leaveq 
  8011d4:	c3                   	retq   

00000000008011d5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 20          	sub    $0x20,%rsp
  8011dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ec:	eb 0e                	jmp    8011fc <strnlen+0x27>
		n++;
  8011ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801201:	74 0b                	je     80120e <strnlen+0x39>
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	75 e0                	jne    8011ee <strnlen+0x19>
		n++;
	return n;
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 20          	sub    $0x20,%rsp
  80121b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801227:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80122b:	90                   	nop
  80122c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801230:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801238:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801240:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801244:	0f b6 12             	movzbl (%rdx),%edx
  801247:	88 10                	mov    %dl,(%rax)
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	84 c0                	test   %al,%al
  80124e:	75 dc                	jne    80122c <strcpy+0x19>
		/* do nothing */;
	return ret;
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801254:	c9                   	leaveq 
  801255:	c3                   	retq   

0000000000801256 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	48 83 ec 20          	sub    $0x20,%rsp
  80125e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801262:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126a:	48 89 c7             	mov    %rax,%rdi
  80126d:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  801274:	00 00 00 
  801277:	ff d0                	callq  *%rax
  801279:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80127c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127f:	48 63 d0             	movslq %eax,%rdx
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 01 c2             	add    %rax,%rdx
  801289:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128d:	48 89 c6             	mov    %rax,%rsi
  801290:	48 89 d7             	mov    %rdx,%rdi
  801293:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  80129a:	00 00 00 
  80129d:	ff d0                	callq  *%rax
	return dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 28          	sub    $0x28,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c8:	00 
  8012c9:	eb 2a                	jmp    8012f5 <strncpy+0x50>
		*dst++ = *src;
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012db:	0f b6 12             	movzbl (%rdx),%edx
  8012de:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e4:	0f b6 00             	movzbl (%rax),%eax
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 05                	je     8012f0 <strncpy+0x4b>
			src++;
  8012eb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fd:	72 cc                	jb     8012cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801303:	c9                   	leaveq 
  801304:	c3                   	retq   

0000000000801305 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801305:	55                   	push   %rbp
  801306:	48 89 e5             	mov    %rsp,%rbp
  801309:	48 83 ec 28          	sub    $0x28,%rsp
  80130d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801311:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801315:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801321:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801326:	74 3d                	je     801365 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801328:	eb 1d                	jmp    801347 <strlcpy+0x42>
			*dst++ = *src++;
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801342:	0f b6 12             	movzbl (%rdx),%edx
  801345:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801347:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80134c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801351:	74 0b                	je     80135e <strlcpy+0x59>
  801353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	84 c0                	test   %al,%al
  80135c:	75 cc                	jne    80132a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801365:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	48 29 c2             	sub    %rax,%rdx
  801370:	48 89 d0             	mov    %rdx,%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 10          	sub    $0x10,%rsp
  80137d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801381:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801385:	eb 0a                	jmp    801391 <strcmp+0x1c>
		p++, q++;
  801387:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	0f b6 00             	movzbl (%rax),%eax
  801398:	84 c0                	test   %al,%al
  80139a:	74 12                	je     8013ae <strcmp+0x39>
  80139c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a0:	0f b6 10             	movzbl (%rax),%edx
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	38 c2                	cmp    %al,%dl
  8013ac:	74 d9                	je     801387 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	0f b6 d0             	movzbl %al,%edx
  8013b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	0f b6 c0             	movzbl %al,%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leaveq 
  8013c7:	c3                   	retq   

00000000008013c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c8:	55                   	push   %rbp
  8013c9:	48 89 e5             	mov    %rsp,%rbp
  8013cc:	48 83 ec 18          	sub    $0x18,%rsp
  8013d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013dc:	eb 0f                	jmp    8013ed <strncmp+0x25>
		n--, p++, q++;
  8013de:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f2:	74 1d                	je     801411 <strncmp+0x49>
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	0f b6 00             	movzbl (%rax),%eax
  8013fb:	84 c0                	test   %al,%al
  8013fd:	74 12                	je     801411 <strncmp+0x49>
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801403:	0f b6 10             	movzbl (%rax),%edx
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	38 c2                	cmp    %al,%dl
  80140f:	74 cd                	je     8013de <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801411:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801416:	75 07                	jne    80141f <strncmp+0x57>
		return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
  80141d:	eb 18                	jmp    801437 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	0f b6 d0             	movzbl %al,%edx
  801429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	0f b6 c0             	movzbl %al,%eax
  801433:	29 c2                	sub    %eax,%edx
  801435:	89 d0                	mov    %edx,%eax
}
  801437:	c9                   	leaveq 
  801438:	c3                   	retq   

0000000000801439 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801439:	55                   	push   %rbp
  80143a:	48 89 e5             	mov    %rsp,%rbp
  80143d:	48 83 ec 0c          	sub    $0xc,%rsp
  801441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801445:	89 f0                	mov    %esi,%eax
  801447:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144a:	eb 17                	jmp    801463 <strchr+0x2a>
		if (*s == c)
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801456:	75 06                	jne    80145e <strchr+0x25>
			return (char *) s;
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	eb 15                	jmp    801473 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801467:	0f b6 00             	movzbl (%rax),%eax
  80146a:	84 c0                	test   %al,%al
  80146c:	75 de                	jne    80144c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801473:	c9                   	leaveq 
  801474:	c3                   	retq   

0000000000801475 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801475:	55                   	push   %rbp
  801476:	48 89 e5             	mov    %rsp,%rbp
  801479:	48 83 ec 0c          	sub    $0xc,%rsp
  80147d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801481:	89 f0                	mov    %esi,%eax
  801483:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801486:	eb 13                	jmp    80149b <strfind+0x26>
		if (*s == c)
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801492:	75 02                	jne    801496 <strfind+0x21>
			break;
  801494:	eb 10                	jmp    8014a6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	84 c0                	test   %al,%al
  8014a4:	75 e2                	jne    801488 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014aa:	c9                   	leaveq 
  8014ab:	c3                   	retq   

00000000008014ac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ac:	55                   	push   %rbp
  8014ad:	48 89 e5             	mov    %rsp,%rbp
  8014b0:	48 83 ec 18          	sub    $0x18,%rsp
  8014b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c4:	75 06                	jne    8014cc <memset+0x20>
		return v;
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	eb 69                	jmp    801535 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	48 85 c0             	test   %rax,%rax
  8014d6:	75 48                	jne    801520 <memset+0x74>
  8014d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dc:	83 e0 03             	and    $0x3,%eax
  8014df:	48 85 c0             	test   %rax,%rax
  8014e2:	75 3c                	jne    801520 <memset+0x74>
		c &= 0xFF;
  8014e4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ee:	c1 e0 18             	shl    $0x18,%eax
  8014f1:	89 c2                	mov    %eax,%edx
  8014f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f6:	c1 e0 10             	shl    $0x10,%eax
  8014f9:	09 c2                	or     %eax,%edx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	c1 e0 08             	shl    $0x8,%eax
  801501:	09 d0                	or     %edx,%eax
  801503:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	48 c1 e8 02          	shr    $0x2,%rax
  80150e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801511:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801515:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801518:	48 89 d7             	mov    %rdx,%rdi
  80151b:	fc                   	cld    
  80151c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151e:	eb 11                	jmp    801531 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801520:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801524:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801527:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152b:	48 89 d7             	mov    %rdx,%rdi
  80152e:	fc                   	cld    
  80152f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 28          	sub    $0x28,%rsp
  80153f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801543:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801547:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80154b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801557:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801563:	0f 83 88 00 00 00    	jae    8015f1 <memmove+0xba>
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801571:	48 01 d0             	add    %rdx,%rax
  801574:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801578:	76 77                	jbe    8015f1 <memmove+0xba>
		s += n;
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	83 e0 03             	and    $0x3,%eax
  801591:	48 85 c0             	test   %rax,%rax
  801594:	75 3b                	jne    8015d1 <memmove+0x9a>
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	83 e0 03             	and    $0x3,%eax
  80159d:	48 85 c0             	test   %rax,%rax
  8015a0:	75 2f                	jne    8015d1 <memmove+0x9a>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	83 e0 03             	and    $0x3,%eax
  8015a9:	48 85 c0             	test   %rax,%rax
  8015ac:	75 23                	jne    8015d1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b2:	48 83 e8 04          	sub    $0x4,%rax
  8015b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ba:	48 83 ea 04          	sub    $0x4,%rdx
  8015be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c6:	48 89 c7             	mov    %rax,%rdi
  8015c9:	48 89 d6             	mov    %rdx,%rsi
  8015cc:	fd                   	std    
  8015cd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015cf:	eb 1d                	jmp    8015ee <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	48 89 d7             	mov    %rdx,%rdi
  8015e8:	48 89 c1             	mov    %rax,%rcx
  8015eb:	fd                   	std    
  8015ec:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015ee:	fc                   	cld    
  8015ef:	eb 57                	jmp    801648 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f5:	83 e0 03             	and    $0x3,%eax
  8015f8:	48 85 c0             	test   %rax,%rax
  8015fb:	75 36                	jne    801633 <memmove+0xfc>
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801601:	83 e0 03             	and    $0x3,%eax
  801604:	48 85 c0             	test   %rax,%rax
  801607:	75 2a                	jne    801633 <memmove+0xfc>
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	83 e0 03             	and    $0x3,%eax
  801610:	48 85 c0             	test   %rax,%rax
  801613:	75 1e                	jne    801633 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	48 c1 e8 02          	shr    $0x2,%rax
  80161d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801624:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801628:	48 89 c7             	mov    %rax,%rdi
  80162b:	48 89 d6             	mov    %rdx,%rsi
  80162e:	fc                   	cld    
  80162f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801631:	eb 15                	jmp    801648 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163f:	48 89 c7             	mov    %rax,%rdi
  801642:	48 89 d6             	mov    %rdx,%rsi
  801645:	fc                   	cld    
  801646:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164c:	c9                   	leaveq 
  80164d:	c3                   	retq   

000000000080164e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164e:	55                   	push   %rbp
  80164f:	48 89 e5             	mov    %rsp,%rbp
  801652:	48 83 ec 18          	sub    $0x18,%rsp
  801656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801666:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80166a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166e:	48 89 ce             	mov    %rcx,%rsi
  801671:	48 89 c7             	mov    %rax,%rdi
  801674:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	callq  *%rax
}
  801680:	c9                   	leaveq 
  801681:	c3                   	retq   

0000000000801682 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801682:	55                   	push   %rbp
  801683:	48 89 e5             	mov    %rsp,%rbp
  801686:	48 83 ec 28          	sub    $0x28,%rsp
  80168a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801692:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a6:	eb 36                	jmp    8016de <memcmp+0x5c>
		if (*s1 != *s2)
  8016a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ac:	0f b6 10             	movzbl (%rax),%edx
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	38 c2                	cmp    %al,%dl
  8016b8:	74 1a                	je     8016d4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	0f b6 d0             	movzbl %al,%edx
  8016c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	0f b6 c0             	movzbl %al,%eax
  8016ce:	29 c2                	sub    %eax,%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	eb 20                	jmp    8016f4 <memcmp+0x72>
		s1++, s2++;
  8016d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ea:	48 85 c0             	test   %rax,%rax
  8016ed:	75 b9                	jne    8016a8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f4:	c9                   	leaveq 
  8016f5:	c3                   	retq   

00000000008016f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f6:	55                   	push   %rbp
  8016f7:	48 89 e5             	mov    %rsp,%rbp
  8016fa:	48 83 ec 28          	sub    $0x28,%rsp
  8016fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801702:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801705:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801711:	48 01 d0             	add    %rdx,%rax
  801714:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801718:	eb 15                	jmp    80172f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171e:	0f b6 10             	movzbl (%rax),%edx
  801721:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801724:	38 c2                	cmp    %al,%dl
  801726:	75 02                	jne    80172a <memfind+0x34>
			break;
  801728:	eb 0f                	jmp    801739 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801733:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801737:	72 e1                	jb     80171a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 34          	sub    $0x34,%rsp
  801747:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80174f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801759:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801760:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801761:	eb 05                	jmp    801768 <strtol+0x29>
		s++;
  801763:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 20                	cmp    $0x20,%al
  801771:	74 f0                	je     801763 <strtol+0x24>
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	3c 09                	cmp    $0x9,%al
  80177c:	74 e5                	je     801763 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3c 2b                	cmp    $0x2b,%al
  801787:	75 07                	jne    801790 <strtol+0x51>
		s++;
  801789:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178e:	eb 17                	jmp    8017a7 <strtol+0x68>
	else if (*s == '-')
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 2d                	cmp    $0x2d,%al
  801799:	75 0c                	jne    8017a7 <strtol+0x68>
		s++, neg = 1;
  80179b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ab:	74 06                	je     8017b3 <strtol+0x74>
  8017ad:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b1:	75 28                	jne    8017db <strtol+0x9c>
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	3c 30                	cmp    $0x30,%al
  8017bc:	75 1d                	jne    8017db <strtol+0x9c>
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 83 c0 01          	add    $0x1,%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	3c 78                	cmp    $0x78,%al
  8017cb:	75 0e                	jne    8017db <strtol+0x9c>
		s += 2, base = 16;
  8017cd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d9:	eb 2c                	jmp    801807 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017db:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017df:	75 19                	jne    8017fa <strtol+0xbb>
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	0f b6 00             	movzbl (%rax),%eax
  8017e8:	3c 30                	cmp    $0x30,%al
  8017ea:	75 0e                	jne    8017fa <strtol+0xbb>
		s++, base = 8;
  8017ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f8:	eb 0d                	jmp    801807 <strtol+0xc8>
	else if (base == 0)
  8017fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fe:	75 07                	jne    801807 <strtol+0xc8>
		base = 10;
  801800:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	3c 2f                	cmp    $0x2f,%al
  801810:	7e 1d                	jle    80182f <strtol+0xf0>
  801812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	3c 39                	cmp    $0x39,%al
  80181b:	7f 12                	jg     80182f <strtol+0xf0>
			dig = *s - '0';
  80181d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 30             	sub    $0x30,%eax
  80182a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182d:	eb 4e                	jmp    80187d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	0f b6 00             	movzbl (%rax),%eax
  801836:	3c 60                	cmp    $0x60,%al
  801838:	7e 1d                	jle    801857 <strtol+0x118>
  80183a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	3c 7a                	cmp    $0x7a,%al
  801843:	7f 12                	jg     801857 <strtol+0x118>
			dig = *s - 'a' + 10;
  801845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801849:	0f b6 00             	movzbl (%rax),%eax
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801855:	eb 26                	jmp    80187d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	3c 40                	cmp    $0x40,%al
  801860:	7e 48                	jle    8018aa <strtol+0x16b>
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	3c 5a                	cmp    $0x5a,%al
  80186b:	7f 3d                	jg     8018aa <strtol+0x16b>
			dig = *s - 'A' + 10;
  80186d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f be c0             	movsbl %al,%eax
  801877:	83 e8 37             	sub    $0x37,%eax
  80187a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801880:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801883:	7c 02                	jl     801887 <strtol+0x148>
			break;
  801885:	eb 23                	jmp    8018aa <strtol+0x16b>
		s++, val = (val * base) + dig;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188f:	48 98                	cltq   
  801891:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801896:	48 89 c2             	mov    %rax,%rdx
  801899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189c:	48 98                	cltq   
  80189e:	48 01 d0             	add    %rdx,%rax
  8018a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a5:	e9 5d ff ff ff       	jmpq   801807 <strtol+0xc8>

	if (endptr)
  8018aa:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018af:	74 0b                	je     8018bc <strtol+0x17d>
		*endptr = (char *) s;
  8018b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c0:	74 09                	je     8018cb <strtol+0x18c>
  8018c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c6:	48 f7 d8             	neg    %rax
  8018c9:	eb 04                	jmp    8018cf <strtol+0x190>
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 30          	sub    $0x30,%rsp
  8018d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ed:	0f b6 00             	movzbl (%rax),%eax
  8018f0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f7:	75 06                	jne    8018ff <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	eb 6b                	jmp    80196a <strstr+0x99>

	len = strlen(str);
  8018ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801903:	48 89 c7             	mov    %rax,%rdi
  801906:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  80190d:	00 00 00 
  801910:	ff d0                	callq  *%rax
  801912:	48 98                	cltq   
  801914:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801920:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801924:	0f b6 00             	movzbl (%rax),%eax
  801927:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80192a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80192e:	75 07                	jne    801937 <strstr+0x66>
				return (char *) 0;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	eb 33                	jmp    80196a <strstr+0x99>
		} while (sc != c);
  801937:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80193b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80193e:	75 d8                	jne    801918 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801940:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801944:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	48 89 ce             	mov    %rcx,%rsi
  80194f:	48 89 c7             	mov    %rax,%rdi
  801952:	48 b8 c8 13 80 00 00 	movabs $0x8013c8,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
  80195e:	85 c0                	test   %eax,%eax
  801960:	75 b6                	jne    801918 <strstr+0x47>

	return (char *) (in - 1);
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	48 83 e8 01          	sub    $0x1,%rax
}
  80196a:	c9                   	leaveq 
  80196b:	c3                   	retq   

000000000080196c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80196c:	55                   	push   %rbp
  80196d:	48 89 e5             	mov    %rsp,%rbp
  801970:	53                   	push   %rbx
  801971:	48 83 ec 48          	sub    $0x48,%rsp
  801975:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801978:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80197b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80197f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801983:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801987:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801992:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801996:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80199a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a2:	4c 89 c3             	mov    %r8,%rbx
  8019a5:	cd 30                	int    $0x30
  8019a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019af:	74 3e                	je     8019ef <syscall+0x83>
  8019b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019b6:	7e 37                	jle    8019ef <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019bf:	49 89 d0             	mov    %rdx,%r8
  8019c2:	89 c1                	mov    %eax,%ecx
  8019c4:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8019cb:	00 00 00 
  8019ce:	be 23 00 00 00       	mov    $0x23,%esi
  8019d3:	48 bf 85 47 80 00 00 	movabs $0x804785,%rdi
  8019da:	00 00 00 
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e2:	49 b9 25 04 80 00 00 	movabs $0x800425,%r9
  8019e9:	00 00 00 
  8019ec:	41 ff d1             	callq  *%r9

	return ret;
  8019ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f3:	48 83 c4 48          	add    $0x48,%rsp
  8019f7:	5b                   	pop    %rbx
  8019f8:	5d                   	pop    %rbp
  8019f9:	c3                   	retq   

00000000008019fa <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 20          	sub    $0x20,%rsp
  801a02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a19:	00 
  801a1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a26:	48 89 d1             	mov    %rdx,%rcx
  801a29:	48 89 c2             	mov    %rax,%rdx
  801a2c:	be 00 00 00 00       	mov    $0x0,%esi
  801a31:	bf 00 00 00 00       	mov    $0x0,%edi
  801a36:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	callq  *%rax
}
  801a42:	c9                   	leaveq 
  801a43:	c3                   	retq   

0000000000801a44 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a44:	55                   	push   %rbp
  801a45:	48 89 e5             	mov    %rsp,%rbp
  801a48:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a53:	00 
  801a54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a60:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6a:	be 00 00 00 00       	mov    $0x0,%esi
  801a6f:	bf 01 00 00 00       	mov    $0x1,%edi
  801a74:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a90:	48 98                	cltq   
  801a92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a99:	00 
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 01 00 00 00       	mov    $0x1,%esi
  801ab3:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab8:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ace:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad5:	00 
  801ad6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	be 00 00 00 00       	mov    $0x0,%esi
  801af1:	bf 02 00 00 00       	mov    $0x2,%edi
  801af6:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
}
  801b02:	c9                   	leaveq 
  801b03:	c3                   	retq   

0000000000801b04 <sys_yield>:

void
sys_yield(void)
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b13:	00 
  801b14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b25:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2a:	be 00 00 00 00       	mov    $0x0,%esi
  801b2f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b34:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
}
  801b40:	c9                   	leaveq 
  801b41:	c3                   	retq   

0000000000801b42 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 20          	sub    $0x20,%rsp
  801b4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b51:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b57:	48 63 c8             	movslq %eax,%rcx
  801b5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b61:	48 98                	cltq   
  801b63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6a:	00 
  801b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b71:	49 89 c8             	mov    %rcx,%r8
  801b74:	48 89 d1             	mov    %rdx,%rcx
  801b77:	48 89 c2             	mov    %rax,%rdx
  801b7a:	be 01 00 00 00       	mov    $0x1,%esi
  801b7f:	bf 04 00 00 00       	mov    $0x4,%edi
  801b84:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
}
  801b90:	c9                   	leaveq 
  801b91:	c3                   	retq   

0000000000801b92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b92:	55                   	push   %rbp
  801b93:	48 89 e5             	mov    %rsp,%rbp
  801b96:	48 83 ec 30          	sub    $0x30,%rsp
  801b9a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801baf:	48 63 c8             	movslq %eax,%rcx
  801bb2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb9:	48 63 f0             	movslq %eax,%rsi
  801bbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc3:	48 98                	cltq   
  801bc5:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bc9:	49 89 f9             	mov    %rdi,%r9
  801bcc:	49 89 f0             	mov    %rsi,%r8
  801bcf:	48 89 d1             	mov    %rdx,%rcx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 05 00 00 00       	mov    $0x5,%edi
  801bdf:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 20          	sub    $0x20,%rsp
  801bf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 98                	cltq   
  801c05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0c:	00 
  801c0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c19:	48 89 d1             	mov    %rdx,%rcx
  801c1c:	48 89 c2             	mov    %rax,%rdx
  801c1f:	be 01 00 00 00       	mov    $0x1,%esi
  801c24:	bf 06 00 00 00       	mov    $0x6,%edi
  801c29:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	callq  *%rax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 10          	sub    $0x10,%rsp
  801c3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c42:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c48:	48 63 d0             	movslq %eax,%rdx
  801c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4e:	48 98                	cltq   
  801c50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c57:	00 
  801c58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c64:	48 89 d1             	mov    %rdx,%rcx
  801c67:	48 89 c2             	mov    %rax,%rdx
  801c6a:	be 01 00 00 00       	mov    $0x1,%esi
  801c6f:	bf 08 00 00 00       	mov    $0x8,%edi
  801c74:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	48 98                	cltq   
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 01 00 00 00       	mov    $0x1,%esi
  801cb9:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbe:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 20          	sub    $0x20,%rsp
  801cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce2:	48 98                	cltq   
  801ce4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ceb:	00 
  801cec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf8:	48 89 d1             	mov    %rdx,%rcx
  801cfb:	48 89 c2             	mov    %rax,%rdx
  801cfe:	be 01 00 00 00       	mov    $0x1,%esi
  801d03:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d08:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d29:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d2f:	48 63 f0             	movslq %eax,%rsi
  801d32:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d39:	48 98                	cltq   
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d46:	00 
  801d47:	49 89 f1             	mov    %rsi,%r9
  801d4a:	49 89 c8             	mov    %rcx,%r8
  801d4d:	48 89 d1             	mov    %rdx,%rcx
  801d50:	48 89 c2             	mov    %rax,%rdx
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d5d:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 10          	sub    $0x10,%rsp
  801d73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d82:	00 
  801d83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d94:	48 89 c2             	mov    %rax,%rdx
  801d97:	be 01 00 00 00       	mov    $0x1,%esi
  801d9c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da1:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
}
  801dad:	c9                   	leaveq 
  801dae:	c3                   	retq   

0000000000801daf <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801daf:	55                   	push   %rbp
  801db0:	48 89 e5             	mov    %rsp,%rbp
  801db3:	48 83 ec 20          	sub    $0x20,%rsp
  801db7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dce:	00 
  801dcf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddb:	48 89 d1             	mov    %rdx,%rcx
  801dde:	48 89 c2             	mov    %rax,%rdx
  801de1:	be 01 00 00 00       	mov    $0x1,%esi
  801de6:	bf 0f 00 00 00       	mov    $0xf,%edi
  801deb:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
}
  801df7:	c9                   	leaveq 
  801df8:	c3                   	retq   

0000000000801df9 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
  801dfd:	48 83 ec 10          	sub    $0x10,%rsp
  801e01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e22:	48 89 c2             	mov    %rax,%rdx
  801e25:	be 00 00 00 00       	mov    $0x0,%esi
  801e2a:	bf 10 00 00 00       	mov    $0x10,%edi
  801e2f:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	callq  *%rax
}
  801e3b:	c9                   	leaveq 
  801e3c:	c3                   	retq   

0000000000801e3d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e3d:	55                   	push   %rbp
  801e3e:	48 89 e5             	mov    %rsp,%rbp
  801e41:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4c:	00 
  801e4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
  801e68:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e6d:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
}
  801e79:	c9                   	leaveq 
  801e7a:	c3                   	retq   

0000000000801e7b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 08          	sub    $0x8,%rsp
  801e83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e8b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e92:	ff ff ff 
  801e95:	48 01 d0             	add    %rdx,%rax
  801e98:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e9c:	c9                   	leaveq 
  801e9d:	c3                   	retq   

0000000000801e9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	48 83 ec 08          	sub    $0x8,%rsp
  801ea6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eae:	48 89 c7             	mov    %rax,%rdi
  801eb1:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
  801ebd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec7:	c9                   	leaveq 
  801ec8:	c3                   	retq   

0000000000801ec9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec9:	55                   	push   %rbp
  801eca:	48 89 e5             	mov    %rsp,%rbp
  801ecd:	48 83 ec 18          	sub    $0x18,%rsp
  801ed1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801edc:	eb 6b                	jmp    801f49 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee1:	48 98                	cltq   
  801ee3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee9:	48 c1 e0 0c          	shl    $0xc,%rax
  801eed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef5:	48 c1 e8 15          	shr    $0x15,%rax
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f03:	01 00 00 
  801f06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0a:	83 e0 01             	and    $0x1,%eax
  801f0d:	48 85 c0             	test   %rax,%rax
  801f10:	74 21                	je     801f33 <fd_alloc+0x6a>
  801f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f16:	48 c1 e8 0c          	shr    $0xc,%rax
  801f1a:	48 89 c2             	mov    %rax,%rdx
  801f1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f24:	01 00 00 
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	48 85 c0             	test   %rax,%rax
  801f31:	75 12                	jne    801f45 <fd_alloc+0x7c>
			*fd_store = fd;
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	eb 1a                	jmp    801f5f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f49:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4d:	7e 8f                	jle    801ede <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f53:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f5a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5f:	c9                   	leaveq 
  801f60:	c3                   	retq   

0000000000801f61 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f61:	55                   	push   %rbp
  801f62:	48 89 e5             	mov    %rsp,%rbp
  801f65:	48 83 ec 20          	sub    $0x20,%rsp
  801f69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f74:	78 06                	js     801f7c <fd_lookup+0x1b>
  801f76:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f7a:	7e 07                	jle    801f83 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f81:	eb 6c                	jmp    801fef <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f86:	48 98                	cltq   
  801f88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8e:	48 c1 e0 0c          	shl    $0xc,%rax
  801f92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9a:	48 c1 e8 15          	shr    $0x15,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa8:	01 00 00 
  801fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faf:	83 e0 01             	and    $0x1,%eax
  801fb2:	48 85 c0             	test   %rax,%rax
  801fb5:	74 21                	je     801fd8 <fd_lookup+0x77>
  801fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbb:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbf:	48 89 c2             	mov    %rax,%rdx
  801fc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc9:	01 00 00 
  801fcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd0:	83 e0 01             	and    $0x1,%eax
  801fd3:	48 85 c0             	test   %rax,%rax
  801fd6:	75 07                	jne    801fdf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdd:	eb 10                	jmp    801fef <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 30          	sub    $0x30,%rsp
  801ff9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802006:	48 89 c7             	mov    %rax,%rdi
  802009:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
  802015:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802019:	48 89 d6             	mov    %rdx,%rsi
  80201c:	89 c7                	mov    %eax,%edi
  80201e:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802031:	78 0a                	js     80203d <fd_close+0x4c>
	    || fd != fd2)
  802033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802037:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80203b:	74 12                	je     80204f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80203d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802041:	74 05                	je     802048 <fd_close+0x57>
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	eb 05                	jmp    80204d <fd_close+0x5c>
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb 69                	jmp    8020b8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802053:	8b 00                	mov    (%rax),%eax
  802055:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802059:	48 89 d6             	mov    %rdx,%rsi
  80205c:	89 c7                	mov    %eax,%edi
  80205e:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax
  80206a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802071:	78 2a                	js     80209d <fd_close+0xac>
		if (dev->dev_close)
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	48 8b 40 20          	mov    0x20(%rax),%rax
  80207b:	48 85 c0             	test   %rax,%rax
  80207e:	74 16                	je     802096 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 8b 40 20          	mov    0x20(%rax),%rax
  802088:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208c:	48 89 d7             	mov    %rdx,%rdi
  80208f:	ff d0                	callq  *%rax
  802091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802094:	eb 07                	jmp    80209d <fd_close+0xac>
		else
			r = 0;
  802096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a1:	48 89 c6             	mov    %rax,%rsi
  8020a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a9:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	callq  *%rax
	return r;
  8020b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 20          	sub    $0x20,%rsp
  8020c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020d0:	eb 41                	jmp    802113 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d9:	00 00 00 
  8020dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020df:	48 63 d2             	movslq %edx,%rdx
  8020e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e6:	8b 00                	mov    (%rax),%eax
  8020e8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020eb:	75 22                	jne    80210f <dev_lookup+0x55>
			*dev = devtab[i];
  8020ed:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f4:	00 00 00 
  8020f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020fa:	48 63 d2             	movslq %edx,%rdx
  8020fd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802105:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	eb 60                	jmp    80216f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802113:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80211a:	00 00 00 
  80211d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802120:	48 63 d2             	movslq %edx,%rdx
  802123:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802127:	48 85 c0             	test   %rax,%rax
  80212a:	75 a6                	jne    8020d2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802133:	00 00 00 
  802136:	48 8b 00             	mov    (%rax),%rax
  802139:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802142:	89 c6                	mov    %eax,%esi
  802144:	48 bf 98 47 80 00 00 	movabs $0x804798,%rdi
  80214b:	00 00 00 
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  80215a:	00 00 00 
  80215d:	ff d1                	callq  *%rcx
	*dev = 0;
  80215f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802163:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80216a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <close>:

int
close(int fdnum)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 20          	sub    $0x20,%rsp
  802179:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802183:	48 89 d6             	mov    %rdx,%rsi
  802186:	89 c7                	mov    %eax,%edi
  802188:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219b:	79 05                	jns    8021a2 <close+0x31>
		return r;
  80219d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a0:	eb 18                	jmp    8021ba <close+0x49>
	else
		return fd_close(fd, 1);
  8021a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a6:	be 01 00 00 00       	mov    $0x1,%esi
  8021ab:	48 89 c7             	mov    %rax,%rdi
  8021ae:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
}
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <close_all>:

void
close_all(void)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021cb:	eb 15                	jmp    8021e2 <close_all+0x26>
		close(i);
  8021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d0:	89 c7                	mov    %eax,%edi
  8021d2:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e6:	7e e5                	jle    8021cd <close_all+0x11>
		close(i);
}
  8021e8:	c9                   	leaveq 
  8021e9:	c3                   	retq   

00000000008021ea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021ea:	55                   	push   %rbp
  8021eb:	48 89 e5             	mov    %rsp,%rbp
  8021ee:	48 83 ec 40          	sub    $0x40,%rsp
  8021f2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021ff:	48 89 d6             	mov    %rdx,%rsi
  802202:	89 c7                	mov    %eax,%edi
  802204:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
  802210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802217:	79 08                	jns    802221 <dup+0x37>
		return r;
  802219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221c:	e9 70 01 00 00       	jmpq   802391 <dup+0x1a7>
	close(newfdnum);
  802221:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802224:	89 c7                	mov    %eax,%edi
  802226:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80222d:	00 00 00 
  802230:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802232:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802235:	48 98                	cltq   
  802237:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223d:	48 c1 e0 0c          	shl    $0xc,%rax
  802241:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802249:	48 89 c7             	mov    %rax,%rdi
  80224c:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802260:	48 89 c7             	mov    %rax,%rdi
  802263:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802277:	48 c1 e8 15          	shr    $0x15,%rax
  80227b:	48 89 c2             	mov    %rax,%rdx
  80227e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802285:	01 00 00 
  802288:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228c:	83 e0 01             	and    $0x1,%eax
  80228f:	48 85 c0             	test   %rax,%rax
  802292:	74 73                	je     802307 <dup+0x11d>
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 c1 e8 0c          	shr    $0xc,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a6:	01 00 00 
  8022a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ad:	83 e0 01             	and    $0x1,%eax
  8022b0:	48 85 c0             	test   %rax,%rax
  8022b3:	74 52                	je     802307 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bd:	48 89 c2             	mov    %rax,%rdx
  8022c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c7:	01 00 00 
  8022ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dd:	41 89 c8             	mov    %ecx,%r8d
  8022e0:	48 89 d1             	mov    %rdx,%rcx
  8022e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e8:	48 89 c6             	mov    %rax,%rsi
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802303:	79 02                	jns    802307 <dup+0x11d>
			goto err;
  802305:	eb 57                	jmp    80235e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230b:	48 c1 e8 0c          	shr    $0xc,%rax
  80230f:	48 89 c2             	mov    %rax,%rdx
  802312:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802319:	01 00 00 
  80231c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802320:	25 07 0e 00 00       	and    $0xe07,%eax
  802325:	89 c1                	mov    %eax,%ecx
  802327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232f:	41 89 c8             	mov    %ecx,%r8d
  802332:	48 89 d1             	mov    %rdx,%rcx
  802335:	ba 00 00 00 00       	mov    $0x0,%edx
  80233a:	48 89 c6             	mov    %rax,%rsi
  80233d:	bf 00 00 00 00       	mov    $0x0,%edi
  802342:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  802349:	00 00 00 
  80234c:	ff d0                	callq  *%rax
  80234e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802355:	79 02                	jns    802359 <dup+0x16f>
		goto err;
  802357:	eb 05                	jmp    80235e <dup+0x174>

	return newfdnum;
  802359:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235c:	eb 33                	jmp    802391 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	48 89 c6             	mov    %rax,%rsi
  802365:	bf 00 00 00 00       	mov    $0x0,%edi
  80236a:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237a:	48 89 c6             	mov    %rax,%rsi
  80237d:	bf 00 00 00 00       	mov    $0x0,%edi
  802382:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
	return r;
  80238e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802391:	c9                   	leaveq 
  802392:	c3                   	retq   

0000000000802393 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802393:	55                   	push   %rbp
  802394:	48 89 e5             	mov    %rsp,%rbp
  802397:	48 83 ec 40          	sub    $0x40,%rsp
  80239b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ad:	48 89 d6             	mov    %rdx,%rsi
  8023b0:	89 c7                	mov    %eax,%edi
  8023b2:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c5:	78 24                	js     8023eb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	8b 00                	mov    (%rax),%eax
  8023cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <read+0x5d>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 76                	jmp    802466 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f4:	8b 40 08             	mov    0x8(%rax),%eax
  8023f7:	83 e0 03             	and    $0x3,%eax
  8023fa:	83 f8 01             	cmp    $0x1,%eax
  8023fd:	75 3a                	jne    802439 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023ff:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802406:	00 00 00 
  802409:	48 8b 00             	mov    (%rax),%rax
  80240c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802412:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802415:	89 c6                	mov    %eax,%esi
  802417:	48 bf b7 47 80 00 00 	movabs $0x8047b7,%rdi
  80241e:	00 00 00 
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  80242d:	00 00 00 
  802430:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802432:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802437:	eb 2d                	jmp    802466 <read+0xd3>
	}
	if (!dev->dev_read)
  802439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802441:	48 85 c0             	test   %rax,%rax
  802444:	75 07                	jne    80244d <read+0xba>
		return -E_NOT_SUPP;
  802446:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80244b:	eb 19                	jmp    802466 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802451:	48 8b 40 10          	mov    0x10(%rax),%rax
  802455:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802459:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802461:	48 89 cf             	mov    %rcx,%rdi
  802464:	ff d0                	callq  *%rax
}
  802466:	c9                   	leaveq 
  802467:	c3                   	retq   

0000000000802468 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802468:	55                   	push   %rbp
  802469:	48 89 e5             	mov    %rsp,%rbp
  80246c:	48 83 ec 30          	sub    $0x30,%rsp
  802470:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802473:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802477:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80247b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802482:	eb 49                	jmp    8024cd <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	48 98                	cltq   
  802489:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248d:	48 29 c2             	sub    %rax,%rdx
  802490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802493:	48 63 c8             	movslq %eax,%rcx
  802496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249a:	48 01 c1             	add    %rax,%rcx
  80249d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a0:	48 89 ce             	mov    %rcx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b8:	79 05                	jns    8024bf <readn+0x57>
			return m;
  8024ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bd:	eb 1c                	jmp    8024db <readn+0x73>
		if (m == 0)
  8024bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c3:	75 02                	jne    8024c7 <readn+0x5f>
			break;
  8024c5:	eb 11                	jmp    8024d8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ca:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d0:	48 98                	cltq   
  8024d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d6:	72 ac                	jb     802484 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 40          	sub    $0x40,%rsp
  8024e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 24                	js     802535 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	8b 00                	mov    (%rax),%eax
  802517:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <write+0x5d>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 75                	jmp    8025af <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80253a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253e:	8b 40 08             	mov    0x8(%rax),%eax
  802541:	83 e0 03             	and    $0x3,%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	75 3a                	jne    802582 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802548:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254f:	00 00 00 
  802552:	48 8b 00             	mov    (%rax),%rax
  802555:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80255b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255e:	89 c6                	mov    %eax,%esi
  802560:	48 bf d3 47 80 00 00 	movabs $0x8047d3,%rdi
  802567:	00 00 00 
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  802576:	00 00 00 
  802579:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80257b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802580:	eb 2d                	jmp    8025af <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802586:	48 8b 40 18          	mov    0x18(%rax),%rax
  80258a:	48 85 c0             	test   %rax,%rax
  80258d:	75 07                	jne    802596 <write+0xb9>
		return -E_NOT_SUPP;
  80258f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802594:	eb 19                	jmp    8025af <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025aa:	48 89 cf             	mov    %rcx,%rdi
  8025ad:	ff d0                	callq  *%rax
}
  8025af:	c9                   	leaveq 
  8025b0:	c3                   	retq   

00000000008025b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b1:	55                   	push   %rbp
  8025b2:	48 89 e5             	mov    %rsp,%rbp
  8025b5:	48 83 ec 18          	sub    $0x18,%rsp
  8025b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025bc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	89 c7                	mov    %eax,%edi
  8025cb:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <seek+0x34>
		return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 0f                	jmp    8025f4 <seek+0x43>
	fd->fd_offset = offset;
  8025e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ec:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 30          	sub    $0x30,%rsp
  8025fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802601:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802604:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802608:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	78 24                	js     802649 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802629:	8b 00                	mov    (%rax),%eax
  80262b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262f:	48 89 d6             	mov    %rdx,%rsi
  802632:	89 c7                	mov    %eax,%edi
  802634:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	79 05                	jns    80264e <ftruncate+0x58>
		return r;
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	eb 72                	jmp    8026c0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	8b 40 08             	mov    0x8(%rax),%eax
  802655:	83 e0 03             	and    $0x3,%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 3a                	jne    802696 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802663:	00 00 00 
  802666:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802669:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802672:	89 c6                	mov    %eax,%esi
  802674:	48 bf f0 47 80 00 00 	movabs $0x8047f0,%rdi
  80267b:	00 00 00 
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	48 b9 5e 06 80 00 00 	movabs $0x80065e,%rcx
  80268a:	00 00 00 
  80268d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802694:	eb 2a                	jmp    8026c0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 07                	jne    8026aa <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a8:	eb 16                	jmp    8026c0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ae:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b9:	89 ce                	mov    %ecx,%esi
  8026bb:	48 89 d7             	mov    %rdx,%rdi
  8026be:	ff d0                	callq  *%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	78 24                	js     802716 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fc:	48 89 d6             	mov    %rdx,%rsi
  8026ff:	89 c7                	mov    %eax,%edi
  802701:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802714:	79 05                	jns    80271b <fstat+0x59>
		return r;
  802716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802719:	eb 5e                	jmp    802779 <fstat+0xb7>
	if (!dev->dev_stat)
  80271b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802723:	48 85 c0             	test   %rax,%rax
  802726:	75 07                	jne    80272f <fstat+0x6d>
		return -E_NOT_SUPP;
  802728:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272d:	eb 4a                	jmp    802779 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802733:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802741:	00 00 00 
	stat->st_isdir = 0;
  802744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802748:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274f:	00 00 00 
	stat->st_dev = dev;
  802752:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802765:	48 8b 40 28          	mov    0x28(%rax),%rax
  802769:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802771:	48 89 ce             	mov    %rcx,%rsi
  802774:	48 89 d7             	mov    %rdx,%rdi
  802777:	ff d0                	callq  *%rax
}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   

000000000080277b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	48 83 ec 20          	sub    $0x20,%rsp
  802783:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	be 00 00 00 00       	mov    $0x0,%esi
  802794:	48 89 c7             	mov    %rax,%rdi
  802797:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027aa:	79 05                	jns    8027b1 <stat+0x36>
		return fd;
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	eb 2f                	jmp    8027e0 <stat+0x65>
	r = fstat(fd, stat);
  8027b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cf:	89 c7                	mov    %eax,%edi
  8027d1:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
	return r;
  8027dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 10          	sub    $0x10,%rsp
  8027ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f8:	00 00 00 
  8027fb:	8b 00                	mov    (%rax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 1d                	jne    80281e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802801:	bf 01 00 00 00       	mov    $0x1,%edi
  802806:	48 b8 6f 40 80 00 00 	movabs $0x80406f,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
  802812:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802819:	00 00 00 
  80281c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802825:	00 00 00 
  802828:	8b 00                	mov    (%rax),%eax
  80282a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802832:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802839:	00 00 00 
  80283c:	89 c7                	mov    %eax,%edi
  80283e:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	ba 00 00 00 00       	mov    $0x0,%edx
  802853:	48 89 c6             	mov    %rax,%rsi
  802856:	bf 00 00 00 00       	mov    $0x0,%edi
  80285b:	48 b8 07 3f 80 00 00 	movabs $0x803f07,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
}
  802867:	c9                   	leaveq 
  802868:	c3                   	retq   

0000000000802869 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802869:	55                   	push   %rbp
  80286a:	48 89 e5             	mov    %rsp,%rbp
  80286d:	48 83 ec 30          	sub    $0x30,%rsp
  802871:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802875:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802878:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80287f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802886:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80288d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802892:	75 08                	jne    80289c <open+0x33>
	{
		return r;
  802894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802897:	e9 f2 00 00 00       	jmpq   80298e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80289c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028b2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028b9:	7e 0a                	jle    8028c5 <open+0x5c>
	{
		return -E_BAD_PATH;
  8028bb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028c0:	e9 c9 00 00 00       	jmpq   80298e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028c5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028cc:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028cd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028d1:	48 89 c7             	mov    %rax,%rdi
  8028d4:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e7:	78 09                	js     8028f2 <open+0x89>
  8028e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ed:	48 85 c0             	test   %rax,%rax
  8028f0:	75 08                	jne    8028fa <open+0x91>
		{
			return r;
  8028f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f5:	e9 94 00 00 00       	jmpq   80298e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fe:	ba 00 04 00 00       	mov    $0x400,%edx
  802903:	48 89 c6             	mov    %rax,%rsi
  802906:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80290d:	00 00 00 
  802910:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  802917:	00 00 00 
  80291a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80291c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802923:	00 00 00 
  802926:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802929:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80292f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802933:	48 89 c6             	mov    %rax,%rsi
  802936:	bf 01 00 00 00       	mov    $0x1,%edi
  80293b:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294e:	79 2b                	jns    80297b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	be 00 00 00 00       	mov    $0x0,%esi
  802959:	48 89 c7             	mov    %rax,%rdi
  80295c:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  802963:	00 00 00 
  802966:	ff d0                	callq  *%rax
  802968:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80296b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80296f:	79 05                	jns    802976 <open+0x10d>
			{
				return d;
  802971:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802974:	eb 18                	jmp    80298e <open+0x125>
			}
			return r;
  802976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802979:	eb 13                	jmp    80298e <open+0x125>
		}	
		return fd2num(fd_store);
  80297b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297f:	48 89 c7             	mov    %rax,%rdi
  802982:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80298e:	c9                   	leaveq 
  80298f:	c3                   	retq   

0000000000802990 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802990:	55                   	push   %rbp
  802991:	48 89 e5             	mov    %rsp,%rbp
  802994:	48 83 ec 10          	sub    $0x10,%rsp
  802998:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80299c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029aa:	00 00 00 
  8029ad:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029af:	be 00 00 00 00       	mov    $0x0,%esi
  8029b4:	bf 06 00 00 00       	mov    $0x6,%edi
  8029b9:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
}
  8029c5:	c9                   	leaveq 
  8029c6:	c3                   	retq   

00000000008029c7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029c7:	55                   	push   %rbp
  8029c8:	48 89 e5             	mov    %rsp,%rbp
  8029cb:	48 83 ec 30          	sub    $0x30,%rsp
  8029cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029e7:	74 07                	je     8029f0 <devfile_read+0x29>
  8029e9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029ee:	75 07                	jne    8029f7 <devfile_read+0x30>
		return -E_INVAL;
  8029f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f5:	eb 77                	jmp    802a6e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fb:	8b 50 0c             	mov    0xc(%rax),%edx
  8029fe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a05:	00 00 00 
  802a08:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a0a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a11:	00 00 00 
  802a14:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a18:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a1c:	be 00 00 00 00       	mov    $0x0,%esi
  802a21:	bf 03 00 00 00       	mov    $0x3,%edi
  802a26:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802a2d:	00 00 00 
  802a30:	ff d0                	callq  *%rax
  802a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a39:	7f 05                	jg     802a40 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	eb 2e                	jmp    802a6e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a43:	48 63 d0             	movslq %eax,%rdx
  802a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a51:	00 00 00 
  802a54:	48 89 c7             	mov    %rax,%rdi
  802a57:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a6e:	c9                   	leaveq 
  802a6f:	c3                   	retq   

0000000000802a70 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a70:	55                   	push   %rbp
  802a71:	48 89 e5             	mov    %rsp,%rbp
  802a74:	48 83 ec 30          	sub    $0x30,%rsp
  802a78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a84:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a90:	74 07                	je     802a99 <devfile_write+0x29>
  802a92:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a97:	75 08                	jne    802aa1 <devfile_write+0x31>
		return r;
  802a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9c:	e9 9a 00 00 00       	jmpq   802b3b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	8b 50 0c             	mov    0xc(%rax),%edx
  802aa8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aaf:	00 00 00 
  802ab2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ab4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802abb:	00 
  802abc:	76 08                	jbe    802ac6 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802abe:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ac5:	00 
	}
	fsipcbuf.write.req_n = n;
  802ac6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acd:	00 00 00 
  802ad0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ad4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ad8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802adc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae0:	48 89 c6             	mov    %rax,%rsi
  802ae3:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802aea:	00 00 00 
  802aed:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802af9:	be 00 00 00 00       	mov    $0x0,%esi
  802afe:	bf 04 00 00 00       	mov    $0x4,%edi
  802b03:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
  802b0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b16:	7f 20                	jg     802b38 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b18:	48 bf 16 48 80 00 00 	movabs $0x804816,%rdi
  802b1f:	00 00 00 
  802b22:	b8 00 00 00 00       	mov    $0x0,%eax
  802b27:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802b2e:	00 00 00 
  802b31:	ff d2                	callq  *%rdx
		return r;
  802b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b36:	eb 03                	jmp    802b3b <devfile_write+0xcb>
	}
	return r;
  802b38:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b3b:	c9                   	leaveq 
  802b3c:	c3                   	retq   

0000000000802b3d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b3d:	55                   	push   %rbp
  802b3e:	48 89 e5             	mov    %rsp,%rbp
  802b41:	48 83 ec 20          	sub    $0x20,%rsp
  802b45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	8b 50 0c             	mov    0xc(%rax),%edx
  802b54:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b5b:	00 00 00 
  802b5e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b60:	be 00 00 00 00       	mov    $0x0,%esi
  802b65:	bf 05 00 00 00       	mov    $0x5,%edi
  802b6a:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
  802b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7d:	79 05                	jns    802b84 <devfile_stat+0x47>
		return r;
  802b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b82:	eb 56                	jmp    802bda <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b88:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b8f:	00 00 00 
  802b92:	48 89 c7             	mov    %rax,%rdi
  802b95:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ba1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba8:	00 00 00 
  802bab:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bc2:	00 00 00 
  802bc5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bda:	c9                   	leaveq 
  802bdb:	c3                   	retq   

0000000000802bdc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bdc:	55                   	push   %rbp
  802bdd:	48 89 e5             	mov    %rsp,%rbp
  802be0:	48 83 ec 10          	sub    $0x10,%rsp
  802be4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802be8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bef:	8b 50 0c             	mov    0xc(%rax),%edx
  802bf2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf9:	00 00 00 
  802bfc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802bfe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c05:	00 00 00 
  802c08:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c0e:	be 00 00 00 00       	mov    $0x0,%esi
  802c13:	bf 02 00 00 00       	mov    $0x2,%edi
  802c18:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	callq  *%rax
}
  802c24:	c9                   	leaveq 
  802c25:	c3                   	retq   

0000000000802c26 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c26:	55                   	push   %rbp
  802c27:	48 89 e5             	mov    %rsp,%rbp
  802c2a:	48 83 ec 10          	sub    $0x10,%rsp
  802c2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c36:	48 89 c7             	mov    %rax,%rdi
  802c39:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	callq  *%rax
  802c45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c4a:	7e 07                	jle    802c53 <remove+0x2d>
		return -E_BAD_PATH;
  802c4c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c51:	eb 33                	jmp    802c86 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c57:	48 89 c6             	mov    %rax,%rsi
  802c5a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c61:	00 00 00 
  802c64:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c70:	be 00 00 00 00       	mov    $0x0,%esi
  802c75:	bf 07 00 00 00       	mov    $0x7,%edi
  802c7a:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
}
  802c86:	c9                   	leaveq 
  802c87:	c3                   	retq   

0000000000802c88 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c8c:	be 00 00 00 00       	mov    $0x0,%esi
  802c91:	bf 08 00 00 00       	mov    $0x8,%edi
  802c96:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
}
  802ca2:	5d                   	pop    %rbp
  802ca3:	c3                   	retq   

0000000000802ca4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ca4:	55                   	push   %rbp
  802ca5:	48 89 e5             	mov    %rsp,%rbp
  802ca8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802caf:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cb6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cbd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cc4:	be 00 00 00 00       	mov    $0x0,%esi
  802cc9:	48 89 c7             	mov    %rax,%rdi
  802ccc:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdf:	79 28                	jns    802d09 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ce1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce4:	89 c6                	mov    %eax,%esi
  802ce6:	48 bf 32 48 80 00 00 	movabs $0x804832,%rdi
  802ced:	00 00 00 
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802cfc:	00 00 00 
  802cff:	ff d2                	callq  *%rdx
		return fd_src;
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	e9 74 01 00 00       	jmpq   802e7d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d09:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d10:	be 01 01 00 00       	mov    $0x101,%esi
  802d15:	48 89 c7             	mov    %rax,%rdi
  802d18:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	callq  *%rax
  802d24:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d27:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d2b:	79 39                	jns    802d66 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d30:	89 c6                	mov    %eax,%esi
  802d32:	48 bf 48 48 80 00 00 	movabs $0x804848,%rdi
  802d39:	00 00 00 
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802d48:	00 00 00 
  802d4b:	ff d2                	callq  *%rdx
		close(fd_src);
  802d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d50:	89 c7                	mov    %eax,%edi
  802d52:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
		return fd_dest;
  802d5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d61:	e9 17 01 00 00       	jmpq   802e7d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d66:	eb 74                	jmp    802ddc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d68:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d6b:	48 63 d0             	movslq %eax,%rdx
  802d6e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d78:	48 89 ce             	mov    %rcx,%rsi
  802d7b:	89 c7                	mov    %eax,%edi
  802d7d:	48 b8 dd 24 80 00 00 	movabs $0x8024dd,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d90:	79 4a                	jns    802ddc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d92:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d95:	89 c6                	mov    %eax,%esi
  802d97:	48 bf 62 48 80 00 00 	movabs $0x804862,%rdi
  802d9e:	00 00 00 
  802da1:	b8 00 00 00 00       	mov    $0x0,%eax
  802da6:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802dad:	00 00 00 
  802db0:	ff d2                	callq  *%rdx
			close(fd_src);
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	89 c7                	mov    %eax,%edi
  802db7:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
			close(fd_dest);
  802dc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
			return write_size;
  802dd4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dd7:	e9 a1 00 00 00       	jmpq   802e7d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ddc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	ba 00 02 00 00       	mov    $0x200,%edx
  802deb:	48 89 ce             	mov    %rcx,%rsi
  802dee:	89 c7                	mov    %eax,%edi
  802df0:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
  802dfc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e03:	0f 8f 5f ff ff ff    	jg     802d68 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e0d:	79 47                	jns    802e56 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e12:	89 c6                	mov    %eax,%esi
  802e14:	48 bf 75 48 80 00 00 	movabs $0x804875,%rdi
  802e1b:	00 00 00 
  802e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e23:	48 ba 5e 06 80 00 00 	movabs $0x80065e,%rdx
  802e2a:	00 00 00 
  802e2d:	ff d2                	callq  *%rdx
		close(fd_src);
  802e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e32:	89 c7                	mov    %eax,%edi
  802e34:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
		close(fd_dest);
  802e40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e43:	89 c7                	mov    %eax,%edi
  802e45:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
		return read_size;
  802e51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e54:	eb 27                	jmp    802e7d <copy+0x1d9>
	}
	close(fd_src);
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	89 c7                	mov    %eax,%edi
  802e5b:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
	close(fd_dest);
  802e67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
	return 0;
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e7d:	c9                   	leaveq 
  802e7e:	c3                   	retq   

0000000000802e7f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e7f:	55                   	push   %rbp
  802e80:	48 89 e5             	mov    %rsp,%rbp
  802e83:	48 83 ec 20          	sub    $0x20,%rsp
  802e87:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e91:	48 89 d6             	mov    %rdx,%rsi
  802e94:	89 c7                	mov    %eax,%edi
  802e96:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
  802ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea9:	79 05                	jns    802eb0 <fd2sockid+0x31>
		return r;
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	eb 24                	jmp    802ed4 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb4:	8b 10                	mov    (%rax),%edx
  802eb6:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ebd:	00 00 00 
  802ec0:	8b 00                	mov    (%rax),%eax
  802ec2:	39 c2                	cmp    %eax,%edx
  802ec4:	74 07                	je     802ecd <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802ec6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ecb:	eb 07                	jmp    802ed4 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed1:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ed4:	c9                   	leaveq 
  802ed5:	c3                   	retq   

0000000000802ed6 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ed6:	55                   	push   %rbp
  802ed7:	48 89 e5             	mov    %rsp,%rbp
  802eda:	48 83 ec 20          	sub    $0x20,%rsp
  802ede:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ee1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ee5:	48 89 c7             	mov    %rax,%rdi
  802ee8:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
  802ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efb:	78 26                	js     802f23 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f01:	ba 07 04 00 00       	mov    $0x407,%edx
  802f06:	48 89 c6             	mov    %rax,%rsi
  802f09:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0e:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f21:	79 16                	jns    802f39 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f26:	89 c7                	mov    %eax,%edi
  802f28:	48 b8 e3 33 80 00 00 	movabs $0x8033e3,%rax
  802f2f:	00 00 00 
  802f32:	ff d0                	callq  *%rax
		return r;
  802f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f37:	eb 3a                	jmp    802f73 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f44:	00 00 00 
  802f47:	8b 12                	mov    (%rdx),%edx
  802f49:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f5d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f64:	48 89 c7             	mov    %rax,%rdi
  802f67:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
}
  802f73:	c9                   	leaveq 
  802f74:	c3                   	retq   

0000000000802f75 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f75:	55                   	push   %rbp
  802f76:	48 89 e5             	mov    %rsp,%rbp
  802f79:	48 83 ec 30          	sub    $0x30,%rsp
  802f7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8b:	89 c7                	mov    %eax,%edi
  802f8d:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa0:	79 05                	jns    802fa7 <accept+0x32>
		return r;
  802fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa5:	eb 3b                	jmp    802fe2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802fa7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fab:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb2:	48 89 ce             	mov    %rcx,%rsi
  802fb5:	89 c7                	mov    %eax,%edi
  802fb7:	48 b8 c0 32 80 00 00 	movabs $0x8032c0,%rax
  802fbe:	00 00 00 
  802fc1:	ff d0                	callq  *%rax
  802fc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fca:	79 05                	jns    802fd1 <accept+0x5c>
		return r;
  802fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcf:	eb 11                	jmp    802fe2 <accept+0x6d>
	return alloc_sockfd(r);
  802fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd4:	89 c7                	mov    %eax,%edi
  802fd6:	48 b8 d6 2e 80 00 00 	movabs $0x802ed6,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
}
  802fe2:	c9                   	leaveq 
  802fe3:	c3                   	retq   

0000000000802fe4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fe4:	55                   	push   %rbp
  802fe5:	48 89 e5             	mov    %rsp,%rbp
  802fe8:	48 83 ec 20          	sub    $0x20,%rsp
  802fec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ff6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff9:	89 c7                	mov    %eax,%edi
  802ffb:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
  803007:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300e:	79 05                	jns    803015 <bind+0x31>
		return r;
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803013:	eb 1b                	jmp    803030 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803015:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803018:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80301c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301f:	48 89 ce             	mov    %rcx,%rsi
  803022:	89 c7                	mov    %eax,%edi
  803024:	48 b8 3f 33 80 00 00 	movabs $0x80333f,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
}
  803030:	c9                   	leaveq 
  803031:	c3                   	retq   

0000000000803032 <shutdown>:

int
shutdown(int s, int how)
{
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	48 83 ec 20          	sub    $0x20,%rsp
  80303a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80303d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803040:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803043:	89 c7                	mov    %eax,%edi
  803045:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803054:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803058:	79 05                	jns    80305f <shutdown+0x2d>
		return r;
  80305a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305d:	eb 16                	jmp    803075 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80305f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	89 d6                	mov    %edx,%esi
  803067:	89 c7                	mov    %eax,%edi
  803069:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  803070:	00 00 00 
  803073:	ff d0                	callq  *%rax
}
  803075:	c9                   	leaveq 
  803076:	c3                   	retq   

0000000000803077 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803077:	55                   	push   %rbp
  803078:	48 89 e5             	mov    %rsp,%rbp
  80307b:	48 83 ec 10          	sub    $0x10,%rsp
  80307f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803087:	48 89 c7             	mov    %rax,%rdi
  80308a:	48 b8 f1 40 80 00 00 	movabs $0x8040f1,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	83 f8 01             	cmp    $0x1,%eax
  803099:	75 17                	jne    8030b2 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80309b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309f:	8b 40 0c             	mov    0xc(%rax),%eax
  8030a2:	89 c7                	mov    %eax,%edi
  8030a4:	48 b8 e3 33 80 00 00 	movabs $0x8033e3,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
  8030b0:	eb 05                	jmp    8030b7 <devsock_close+0x40>
	else
		return 0;
  8030b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b7:	c9                   	leaveq 
  8030b8:	c3                   	retq   

00000000008030b9 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030b9:	55                   	push   %rbp
  8030ba:	48 89 e5             	mov    %rsp,%rbp
  8030bd:	48 83 ec 20          	sub    $0x20,%rsp
  8030c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ce:	89 c7                	mov    %eax,%edi
  8030d0:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  8030d7:	00 00 00 
  8030da:	ff d0                	callq  *%rax
  8030dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e3:	79 05                	jns    8030ea <connect+0x31>
		return r;
  8030e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e8:	eb 1b                	jmp    803105 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030ea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ed:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	48 89 ce             	mov    %rcx,%rsi
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 10 34 80 00 00 	movabs $0x803410,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
}
  803105:	c9                   	leaveq 
  803106:	c3                   	retq   

0000000000803107 <listen>:

int
listen(int s, int backlog)
{
  803107:	55                   	push   %rbp
  803108:	48 89 e5             	mov    %rsp,%rbp
  80310b:	48 83 ec 20          	sub    $0x20,%rsp
  80310f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803112:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803118:	89 c7                	mov    %eax,%edi
  80311a:	48 b8 7f 2e 80 00 00 	movabs $0x802e7f,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
  803126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312d:	79 05                	jns    803134 <listen+0x2d>
		return r;
  80312f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803132:	eb 16                	jmp    80314a <listen+0x43>
	return nsipc_listen(r, backlog);
  803134:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	89 d6                	mov    %edx,%esi
  80313c:	89 c7                	mov    %eax,%edi
  80313e:	48 b8 74 34 80 00 00 	movabs $0x803474,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
}
  80314a:	c9                   	leaveq 
  80314b:	c3                   	retq   

000000000080314c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80314c:	55                   	push   %rbp
  80314d:	48 89 e5             	mov    %rsp,%rbp
  803150:	48 83 ec 20          	sub    $0x20,%rsp
  803154:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803158:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80315c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803164:	89 c2                	mov    %eax,%edx
  803166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316a:	8b 40 0c             	mov    0xc(%rax),%eax
  80316d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803171:	b9 00 00 00 00       	mov    $0x0,%ecx
  803176:	89 c7                	mov    %eax,%edi
  803178:	48 b8 b4 34 80 00 00 	movabs $0x8034b4,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
}
  803184:	c9                   	leaveq 
  803185:	c3                   	retq   

0000000000803186 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803186:	55                   	push   %rbp
  803187:	48 89 e5             	mov    %rsp,%rbp
  80318a:	48 83 ec 20          	sub    $0x20,%rsp
  80318e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803192:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803196:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319e:	89 c2                	mov    %eax,%edx
  8031a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a4:	8b 40 0c             	mov    0xc(%rax),%eax
  8031a7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031b0:	89 c7                	mov    %eax,%edi
  8031b2:	48 b8 80 35 80 00 00 	movabs $0x803580,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
}
  8031be:	c9                   	leaveq 
  8031bf:	c3                   	retq   

00000000008031c0 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031c0:	55                   	push   %rbp
  8031c1:	48 89 e5             	mov    %rsp,%rbp
  8031c4:	48 83 ec 10          	sub    $0x10,%rsp
  8031c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d4:	48 be 90 48 80 00 00 	movabs $0x804890,%rsi
  8031db:	00 00 00 
  8031de:	48 89 c7             	mov    %rax,%rdi
  8031e1:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
	return 0;
  8031ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f2:	c9                   	leaveq 
  8031f3:	c3                   	retq   

00000000008031f4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	48 83 ec 20          	sub    $0x20,%rsp
  8031fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803202:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803205:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803208:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80320b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320e:	89 ce                	mov    %ecx,%esi
  803210:	89 c7                	mov    %eax,%edi
  803212:	48 b8 38 36 80 00 00 	movabs $0x803638,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
  80321e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803221:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803225:	79 05                	jns    80322c <socket+0x38>
		return r;
  803227:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322a:	eb 11                	jmp    80323d <socket+0x49>
	return alloc_sockfd(r);
  80322c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322f:	89 c7                	mov    %eax,%edi
  803231:	48 b8 d6 2e 80 00 00 	movabs $0x802ed6,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
}
  80323d:	c9                   	leaveq 
  80323e:	c3                   	retq   

000000000080323f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80323f:	55                   	push   %rbp
  803240:	48 89 e5             	mov    %rsp,%rbp
  803243:	48 83 ec 10          	sub    $0x10,%rsp
  803247:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80324a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803251:	00 00 00 
  803254:	8b 00                	mov    (%rax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	75 1d                	jne    803277 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80325a:	bf 02 00 00 00       	mov    $0x2,%edi
  80325f:	48 b8 6f 40 80 00 00 	movabs $0x80406f,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803272:	00 00 00 
  803275:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803277:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80327e:	00 00 00 
  803281:	8b 00                	mov    (%rax),%eax
  803283:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803286:	b9 07 00 00 00       	mov    $0x7,%ecx
  80328b:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803292:	00 00 00 
  803295:	89 c7                	mov    %eax,%edi
  803297:	48 b8 0d 40 80 00 00 	movabs $0x80400d,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8032a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a8:	be 00 00 00 00       	mov    $0x0,%esi
  8032ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b2:	48 b8 07 3f 80 00 00 	movabs $0x803f07,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
}
  8032be:	c9                   	leaveq 
  8032bf:	c3                   	retq   

00000000008032c0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032c0:	55                   	push   %rbp
  8032c1:	48 89 e5             	mov    %rsp,%rbp
  8032c4:	48 83 ec 30          	sub    $0x30,%rsp
  8032c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032da:	00 00 00 
  8032dd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032e0:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032e2:	bf 01 00 00 00       	mov    $0x1,%edi
  8032e7:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
  8032f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fa:	78 3e                	js     80333a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803303:	00 00 00 
  803306:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80330a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330e:	8b 40 10             	mov    0x10(%rax),%eax
  803311:	89 c2                	mov    %eax,%edx
  803313:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803317:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331b:	48 89 ce             	mov    %rcx,%rsi
  80331e:	48 89 c7             	mov    %rax,%rdi
  803321:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80332d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803331:	8b 50 10             	mov    0x10(%rax),%edx
  803334:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803338:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80333a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80333d:	c9                   	leaveq 
  80333e:	c3                   	retq   

000000000080333f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80333f:	55                   	push   %rbp
  803340:	48 89 e5             	mov    %rsp,%rbp
  803343:	48 83 ec 10          	sub    $0x10,%rsp
  803347:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80334a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80334e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803351:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803358:	00 00 00 
  80335b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80335e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803360:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803367:	48 89 c6             	mov    %rax,%rsi
  80336a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803371:	00 00 00 
  803374:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803380:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803387:	00 00 00 
  80338a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80338d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803390:	bf 02 00 00 00       	mov    $0x2,%edi
  803395:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 10          	sub    $0x10,%rsp
  8033ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033ae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8033b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b8:	00 00 00 
  8033bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033be:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c7:	00 00 00 
  8033ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033cd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033d0:	bf 03 00 00 00       	mov    $0x3,%edi
  8033d5:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
}
  8033e1:	c9                   	leaveq 
  8033e2:	c3                   	retq   

00000000008033e3 <nsipc_close>:

int
nsipc_close(int s)
{
  8033e3:	55                   	push   %rbp
  8033e4:	48 89 e5             	mov    %rsp,%rbp
  8033e7:	48 83 ec 10          	sub    $0x10,%rsp
  8033eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f5:	00 00 00 
  8033f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033fb:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8033fd:	bf 04 00 00 00       	mov    $0x4,%edi
  803402:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
}
  80340e:	c9                   	leaveq 
  80340f:	c3                   	retq   

0000000000803410 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803410:	55                   	push   %rbp
  803411:	48 89 e5             	mov    %rsp,%rbp
  803414:	48 83 ec 10          	sub    $0x10,%rsp
  803418:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80341f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803422:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803429:	00 00 00 
  80342c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803431:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803438:	48 89 c6             	mov    %rax,%rsi
  80343b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803442:	00 00 00 
  803445:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803451:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803458:	00 00 00 
  80345b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80345e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803461:	bf 05 00 00 00       	mov    $0x5,%edi
  803466:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
}
  803472:	c9                   	leaveq 
  803473:	c3                   	retq   

0000000000803474 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803474:	55                   	push   %rbp
  803475:	48 89 e5             	mov    %rsp,%rbp
  803478:	48 83 ec 10          	sub    $0x10,%rsp
  80347c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80347f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803482:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803489:	00 00 00 
  80348c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80348f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803491:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803498:	00 00 00 
  80349b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80349e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8034a1:	bf 06 00 00 00       	mov    $0x6,%edi
  8034a6:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
}
  8034b2:	c9                   	leaveq 
  8034b3:	c3                   	retq   

00000000008034b4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8034b4:	55                   	push   %rbp
  8034b5:	48 89 e5             	mov    %rsp,%rbp
  8034b8:	48 83 ec 30          	sub    $0x30,%rsp
  8034bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034c6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d0:	00 00 00 
  8034d3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034d6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034d8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034df:	00 00 00 
  8034e2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034e5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ef:	00 00 00 
  8034f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034f5:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034f8:	bf 07 00 00 00       	mov    $0x7,%edi
  8034fd:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
  803509:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803510:	78 69                	js     80357b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803512:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803519:	7f 08                	jg     803523 <nsipc_recv+0x6f>
  80351b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803521:	7e 35                	jle    803558 <nsipc_recv+0xa4>
  803523:	48 b9 97 48 80 00 00 	movabs $0x804897,%rcx
  80352a:	00 00 00 
  80352d:	48 ba ac 48 80 00 00 	movabs $0x8048ac,%rdx
  803534:	00 00 00 
  803537:	be 61 00 00 00       	mov    $0x61,%esi
  80353c:	48 bf c1 48 80 00 00 	movabs $0x8048c1,%rdi
  803543:	00 00 00 
  803546:	b8 00 00 00 00       	mov    $0x0,%eax
  80354b:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  803552:	00 00 00 
  803555:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355b:	48 63 d0             	movslq %eax,%rdx
  80355e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803562:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803569:	00 00 00 
  80356c:	48 89 c7             	mov    %rax,%rdi
  80356f:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
	}

	return r;
  80357b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80357e:	c9                   	leaveq 
  80357f:	c3                   	retq   

0000000000803580 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803580:	55                   	push   %rbp
  803581:	48 89 e5             	mov    %rsp,%rbp
  803584:	48 83 ec 20          	sub    $0x20,%rsp
  803588:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80358b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80358f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803592:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803595:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359c:	00 00 00 
  80359f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035a2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8035a4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8035ab:	7e 35                	jle    8035e2 <nsipc_send+0x62>
  8035ad:	48 b9 cd 48 80 00 00 	movabs $0x8048cd,%rcx
  8035b4:	00 00 00 
  8035b7:	48 ba ac 48 80 00 00 	movabs $0x8048ac,%rdx
  8035be:	00 00 00 
  8035c1:	be 6c 00 00 00       	mov    $0x6c,%esi
  8035c6:	48 bf c1 48 80 00 00 	movabs $0x8048c1,%rdi
  8035cd:	00 00 00 
  8035d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d5:	49 b8 25 04 80 00 00 	movabs $0x800425,%r8
  8035dc:	00 00 00 
  8035df:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e5:	48 63 d0             	movslq %eax,%rdx
  8035e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ec:	48 89 c6             	mov    %rax,%rsi
  8035ef:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8035f6:	00 00 00 
  8035f9:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803605:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360c:	00 00 00 
  80360f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803612:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803615:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361c:	00 00 00 
  80361f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803622:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803625:	bf 08 00 00 00       	mov    $0x8,%edi
  80362a:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
}
  803636:	c9                   	leaveq 
  803637:	c3                   	retq   

0000000000803638 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803638:	55                   	push   %rbp
  803639:	48 89 e5             	mov    %rsp,%rbp
  80363c:	48 83 ec 10          	sub    $0x10,%rsp
  803640:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803643:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803646:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803649:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803650:	00 00 00 
  803653:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803656:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803658:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80365f:	00 00 00 
  803662:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803665:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803668:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366f:	00 00 00 
  803672:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803675:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803678:	bf 09 00 00 00       	mov    $0x9,%edi
  80367d:	48 b8 3f 32 80 00 00 	movabs $0x80323f,%rax
  803684:	00 00 00 
  803687:	ff d0                	callq  *%rax
}
  803689:	c9                   	leaveq 
  80368a:	c3                   	retq   

000000000080368b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80368b:	55                   	push   %rbp
  80368c:	48 89 e5             	mov    %rsp,%rbp
  80368f:	53                   	push   %rbx
  803690:	48 83 ec 38          	sub    $0x38,%rsp
  803694:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803698:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80369c:	48 89 c7             	mov    %rax,%rdi
  80369f:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
  8036ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b2:	0f 88 bf 01 00 00    	js     803877 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bc:	ba 07 04 00 00       	mov    $0x407,%edx
  8036c1:	48 89 c6             	mov    %rax,%rsi
  8036c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c9:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036dc:	0f 88 95 01 00 00    	js     803877 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036e6:	48 89 c7             	mov    %rax,%rdi
  8036e9:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
  8036f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036fc:	0f 88 5d 01 00 00    	js     80385f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803706:	ba 07 04 00 00       	mov    $0x407,%edx
  80370b:	48 89 c6             	mov    %rax,%rsi
  80370e:	bf 00 00 00 00       	mov    $0x0,%edi
  803713:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  80371a:	00 00 00 
  80371d:	ff d0                	callq  *%rax
  80371f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803722:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803726:	0f 88 33 01 00 00    	js     80385f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80372c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803730:	48 89 c7             	mov    %rax,%rdi
  803733:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803743:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803747:	ba 07 04 00 00       	mov    $0x407,%edx
  80374c:	48 89 c6             	mov    %rax,%rsi
  80374f:	bf 00 00 00 00       	mov    $0x0,%edi
  803754:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  80375b:	00 00 00 
  80375e:	ff d0                	callq  *%rax
  803760:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803763:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803767:	79 05                	jns    80376e <pipe+0xe3>
		goto err2;
  803769:	e9 d9 00 00 00       	jmpq   803847 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803772:	48 89 c7             	mov    %rax,%rdi
  803775:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80377c:	00 00 00 
  80377f:	ff d0                	callq  *%rax
  803781:	48 89 c2             	mov    %rax,%rdx
  803784:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803788:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80378e:	48 89 d1             	mov    %rdx,%rcx
  803791:	ba 00 00 00 00       	mov    $0x0,%edx
  803796:	48 89 c6             	mov    %rax,%rsi
  803799:	bf 00 00 00 00       	mov    $0x0,%edi
  80379e:	48 b8 92 1b 80 00 00 	movabs $0x801b92,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
  8037aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b1:	79 1b                	jns    8037ce <pipe+0x143>
		goto err3;
  8037b3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b8:	48 89 c6             	mov    %rax,%rsi
  8037bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c0:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
  8037cc:	eb 79                	jmp    803847 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037d9:	00 00 00 
  8037dc:	8b 12                	mov    (%rdx),%edx
  8037de:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ef:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037f6:	00 00 00 
  8037f9:	8b 12                	mov    (%rdx),%edx
  8037fb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803801:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380c:	48 89 c7             	mov    %rax,%rdi
  80380f:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
  80381b:	89 c2                	mov    %eax,%edx
  80381d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803821:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803823:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803827:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80382b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382f:	48 89 c7             	mov    %rax,%rdi
  803832:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803840:	b8 00 00 00 00       	mov    $0x0,%eax
  803845:	eb 33                	jmp    80387a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803847:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384b:	48 89 c6             	mov    %rax,%rsi
  80384e:	bf 00 00 00 00       	mov    $0x0,%edi
  803853:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80385f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803863:	48 89 c6             	mov    %rax,%rsi
  803866:	bf 00 00 00 00       	mov    $0x0,%edi
  80386b:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
err:
	return r;
  803877:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80387a:	48 83 c4 38          	add    $0x38,%rsp
  80387e:	5b                   	pop    %rbx
  80387f:	5d                   	pop    %rbp
  803880:	c3                   	retq   

0000000000803881 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803881:	55                   	push   %rbp
  803882:	48 89 e5             	mov    %rsp,%rbp
  803885:	53                   	push   %rbx
  803886:	48 83 ec 28          	sub    $0x28,%rsp
  80388a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80388e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803892:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803899:	00 00 00 
  80389c:	48 8b 00             	mov    (%rax),%rax
  80389f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ac:	48 89 c7             	mov    %rax,%rdi
  8038af:	48 b8 f1 40 80 00 00 	movabs $0x8040f1,%rax
  8038b6:	00 00 00 
  8038b9:	ff d0                	callq  *%rax
  8038bb:	89 c3                	mov    %eax,%ebx
  8038bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c1:	48 89 c7             	mov    %rax,%rdi
  8038c4:	48 b8 f1 40 80 00 00 	movabs $0x8040f1,%rax
  8038cb:	00 00 00 
  8038ce:	ff d0                	callq  *%rax
  8038d0:	39 c3                	cmp    %eax,%ebx
  8038d2:	0f 94 c0             	sete   %al
  8038d5:	0f b6 c0             	movzbl %al,%eax
  8038d8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038db:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038e2:	00 00 00 
  8038e5:	48 8b 00             	mov    (%rax),%rax
  8038e8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038ee:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038f7:	75 05                	jne    8038fe <_pipeisclosed+0x7d>
			return ret;
  8038f9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038fc:	eb 4f                	jmp    80394d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803901:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803904:	74 42                	je     803948 <_pipeisclosed+0xc7>
  803906:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80390a:	75 3c                	jne    803948 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80390c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803913:	00 00 00 
  803916:	48 8b 00             	mov    (%rax),%rax
  803919:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80391f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803922:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803925:	89 c6                	mov    %eax,%esi
  803927:	48 bf de 48 80 00 00 	movabs $0x8048de,%rdi
  80392e:	00 00 00 
  803931:	b8 00 00 00 00       	mov    $0x0,%eax
  803936:	49 b8 5e 06 80 00 00 	movabs $0x80065e,%r8
  80393d:	00 00 00 
  803940:	41 ff d0             	callq  *%r8
	}
  803943:	e9 4a ff ff ff       	jmpq   803892 <_pipeisclosed+0x11>
  803948:	e9 45 ff ff ff       	jmpq   803892 <_pipeisclosed+0x11>
}
  80394d:	48 83 c4 28          	add    $0x28,%rsp
  803951:	5b                   	pop    %rbx
  803952:	5d                   	pop    %rbp
  803953:	c3                   	retq   

0000000000803954 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803954:	55                   	push   %rbp
  803955:	48 89 e5             	mov    %rsp,%rbp
  803958:	48 83 ec 30          	sub    $0x30,%rsp
  80395c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80395f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803963:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803966:	48 89 d6             	mov    %rdx,%rsi
  803969:	89 c7                	mov    %eax,%edi
  80396b:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80397a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397e:	79 05                	jns    803985 <pipeisclosed+0x31>
		return r;
  803980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803983:	eb 31                	jmp    8039b6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803989:	48 89 c7             	mov    %rax,%rdi
  80398c:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
  803998:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80399c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a4:	48 89 d6             	mov    %rdx,%rsi
  8039a7:	48 89 c7             	mov    %rax,%rdi
  8039aa:	48 b8 81 38 80 00 00 	movabs $0x803881,%rax
  8039b1:	00 00 00 
  8039b4:	ff d0                	callq  *%rax
}
  8039b6:	c9                   	leaveq 
  8039b7:	c3                   	retq   

00000000008039b8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039b8:	55                   	push   %rbp
  8039b9:	48 89 e5             	mov    %rsp,%rbp
  8039bc:	48 83 ec 40          	sub    $0x40,%rsp
  8039c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d0:	48 89 c7             	mov    %rax,%rdi
  8039d3:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
  8039df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039eb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f2:	00 
  8039f3:	e9 92 00 00 00       	jmpq   803a8a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039f8:	eb 41                	jmp    803a3b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039fa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039ff:	74 09                	je     803a0a <devpipe_read+0x52>
				return i;
  803a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a05:	e9 92 00 00 00       	jmpq   803a9c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a12:	48 89 d6             	mov    %rdx,%rsi
  803a15:	48 89 c7             	mov    %rax,%rdi
  803a18:	48 b8 81 38 80 00 00 	movabs $0x803881,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
  803a24:	85 c0                	test   %eax,%eax
  803a26:	74 07                	je     803a2f <devpipe_read+0x77>
				return 0;
  803a28:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2d:	eb 6d                	jmp    803a9c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a2f:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803a36:	00 00 00 
  803a39:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3f:	8b 10                	mov    (%rax),%edx
  803a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a45:	8b 40 04             	mov    0x4(%rax),%eax
  803a48:	39 c2                	cmp    %eax,%edx
  803a4a:	74 ae                	je     8039fa <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a54:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5c:	8b 00                	mov    (%rax),%eax
  803a5e:	99                   	cltd   
  803a5f:	c1 ea 1b             	shr    $0x1b,%edx
  803a62:	01 d0                	add    %edx,%eax
  803a64:	83 e0 1f             	and    $0x1f,%eax
  803a67:	29 d0                	sub    %edx,%eax
  803a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6d:	48 98                	cltq   
  803a6f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a74:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7a:	8b 00                	mov    (%rax),%eax
  803a7c:	8d 50 01             	lea    0x1(%rax),%edx
  803a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a83:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a85:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a92:	0f 82 60 ff ff ff    	jb     8039f8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a9c:	c9                   	leaveq 
  803a9d:	c3                   	retq   

0000000000803a9e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a9e:	55                   	push   %rbp
  803a9f:	48 89 e5             	mov    %rsp,%rbp
  803aa2:	48 83 ec 40          	sub    $0x40,%rsp
  803aa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aaa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ab2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab6:	48 89 c7             	mov    %rax,%rdi
  803ab9:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803ac0:	00 00 00 
  803ac3:	ff d0                	callq  *%rax
  803ac5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ac9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803acd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ad1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ad8:	00 
  803ad9:	e9 8e 00 00 00       	jmpq   803b6c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ade:	eb 31                	jmp    803b11 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ae0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae8:	48 89 d6             	mov    %rdx,%rsi
  803aeb:	48 89 c7             	mov    %rax,%rdi
  803aee:	48 b8 81 38 80 00 00 	movabs $0x803881,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
  803afa:	85 c0                	test   %eax,%eax
  803afc:	74 07                	je     803b05 <devpipe_write+0x67>
				return 0;
  803afe:	b8 00 00 00 00       	mov    $0x0,%eax
  803b03:	eb 79                	jmp    803b7e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b05:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803b0c:	00 00 00 
  803b0f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b15:	8b 40 04             	mov    0x4(%rax),%eax
  803b18:	48 63 d0             	movslq %eax,%rdx
  803b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1f:	8b 00                	mov    (%rax),%eax
  803b21:	48 98                	cltq   
  803b23:	48 83 c0 20          	add    $0x20,%rax
  803b27:	48 39 c2             	cmp    %rax,%rdx
  803b2a:	73 b4                	jae    803ae0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b30:	8b 40 04             	mov    0x4(%rax),%eax
  803b33:	99                   	cltd   
  803b34:	c1 ea 1b             	shr    $0x1b,%edx
  803b37:	01 d0                	add    %edx,%eax
  803b39:	83 e0 1f             	and    $0x1f,%eax
  803b3c:	29 d0                	sub    %edx,%eax
  803b3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b42:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b46:	48 01 ca             	add    %rcx,%rdx
  803b49:	0f b6 0a             	movzbl (%rdx),%ecx
  803b4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b50:	48 98                	cltq   
  803b52:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5a:	8b 40 04             	mov    0x4(%rax),%eax
  803b5d:	8d 50 01             	lea    0x1(%rax),%edx
  803b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b64:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b70:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b74:	0f 82 64 ff ff ff    	jb     803ade <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b7e:	c9                   	leaveq 
  803b7f:	c3                   	retq   

0000000000803b80 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b80:	55                   	push   %rbp
  803b81:	48 89 e5             	mov    %rsp,%rbp
  803b84:	48 83 ec 20          	sub    $0x20,%rsp
  803b88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b94:	48 89 c7             	mov    %rax,%rdi
  803b97:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803b9e:	00 00 00 
  803ba1:	ff d0                	callq  *%rax
  803ba3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ba7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bab:	48 be f1 48 80 00 00 	movabs $0x8048f1,%rsi
  803bb2:	00 00 00 
  803bb5:	48 89 c7             	mov    %rax,%rdi
  803bb8:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  803bbf:	00 00 00 
  803bc2:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc8:	8b 50 04             	mov    0x4(%rax),%edx
  803bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcf:	8b 00                	mov    (%rax),%eax
  803bd1:	29 c2                	sub    %eax,%edx
  803bd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803be8:	00 00 00 
	stat->st_dev = &devpipe;
  803beb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bef:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bf6:	00 00 00 
  803bf9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c05:	c9                   	leaveq 
  803c06:	c3                   	retq   

0000000000803c07 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c07:	55                   	push   %rbp
  803c08:	48 89 e5             	mov    %rsp,%rbp
  803c0b:	48 83 ec 10          	sub    $0x10,%rsp
  803c0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c17:	48 89 c6             	mov    %rax,%rsi
  803c1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1f:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803c26:	00 00 00 
  803c29:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2f:	48 89 c7             	mov    %rax,%rdi
  803c32:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803c39:	00 00 00 
  803c3c:	ff d0                	callq  *%rax
  803c3e:	48 89 c6             	mov    %rax,%rsi
  803c41:	bf 00 00 00 00       	mov    $0x0,%edi
  803c46:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
}
  803c52:	c9                   	leaveq 
  803c53:	c3                   	retq   

0000000000803c54 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c54:	55                   	push   %rbp
  803c55:	48 89 e5             	mov    %rsp,%rbp
  803c58:	48 83 ec 20          	sub    $0x20,%rsp
  803c5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c62:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c65:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c69:	be 01 00 00 00       	mov    $0x1,%esi
  803c6e:	48 89 c7             	mov    %rax,%rdi
  803c71:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803c78:	00 00 00 
  803c7b:	ff d0                	callq  *%rax
}
  803c7d:	c9                   	leaveq 
  803c7e:	c3                   	retq   

0000000000803c7f <getchar>:

int
getchar(void)
{
  803c7f:	55                   	push   %rbp
  803c80:	48 89 e5             	mov    %rsp,%rbp
  803c83:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c87:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c8b:	ba 01 00 00 00       	mov    $0x1,%edx
  803c90:	48 89 c6             	mov    %rax,%rsi
  803c93:	bf 00 00 00 00       	mov    $0x0,%edi
  803c98:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ca7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cab:	79 05                	jns    803cb2 <getchar+0x33>
		return r;
  803cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb0:	eb 14                	jmp    803cc6 <getchar+0x47>
	if (r < 1)
  803cb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb6:	7f 07                	jg     803cbf <getchar+0x40>
		return -E_EOF;
  803cb8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cbd:	eb 07                	jmp    803cc6 <getchar+0x47>
	return c;
  803cbf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cc3:	0f b6 c0             	movzbl %al,%eax
}
  803cc6:	c9                   	leaveq 
  803cc7:	c3                   	retq   

0000000000803cc8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cc8:	55                   	push   %rbp
  803cc9:	48 89 e5             	mov    %rsp,%rbp
  803ccc:	48 83 ec 20          	sub    $0x20,%rsp
  803cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cda:	48 89 d6             	mov    %rdx,%rsi
  803cdd:	89 c7                	mov    %eax,%edi
  803cdf:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
  803ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf2:	79 05                	jns    803cf9 <iscons+0x31>
		return r;
  803cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf7:	eb 1a                	jmp    803d13 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfd:	8b 10                	mov    (%rax),%edx
  803cff:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d06:	00 00 00 
  803d09:	8b 00                	mov    (%rax),%eax
  803d0b:	39 c2                	cmp    %eax,%edx
  803d0d:	0f 94 c0             	sete   %al
  803d10:	0f b6 c0             	movzbl %al,%eax
}
  803d13:	c9                   	leaveq 
  803d14:	c3                   	retq   

0000000000803d15 <opencons>:

int
opencons(void)
{
  803d15:	55                   	push   %rbp
  803d16:	48 89 e5             	mov    %rsp,%rbp
  803d19:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d1d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d21:	48 89 c7             	mov    %rax,%rdi
  803d24:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  803d2b:	00 00 00 
  803d2e:	ff d0                	callq  *%rax
  803d30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d37:	79 05                	jns    803d3e <opencons+0x29>
		return r;
  803d39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3c:	eb 5b                	jmp    803d99 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d42:	ba 07 04 00 00       	mov    $0x407,%edx
  803d47:	48 89 c6             	mov    %rax,%rsi
  803d4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d4f:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
  803d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d62:	79 05                	jns    803d69 <opencons+0x54>
		return r;
  803d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d67:	eb 30                	jmp    803d99 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d74:	00 00 00 
  803d77:	8b 12                	mov    (%rdx),%edx
  803d79:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d8a:	48 89 c7             	mov    %rax,%rdi
  803d8d:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803d94:	00 00 00 
  803d97:	ff d0                	callq  *%rax
}
  803d99:	c9                   	leaveq 
  803d9a:	c3                   	retq   

0000000000803d9b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d9b:	55                   	push   %rbp
  803d9c:	48 89 e5             	mov    %rsp,%rbp
  803d9f:	48 83 ec 30          	sub    $0x30,%rsp
  803da3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803da7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803daf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803db4:	75 07                	jne    803dbd <devcons_read+0x22>
		return 0;
  803db6:	b8 00 00 00 00       	mov    $0x0,%eax
  803dbb:	eb 4b                	jmp    803e08 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803dbd:	eb 0c                	jmp    803dcb <devcons_read+0x30>
		sys_yield();
  803dbf:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dcb:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
  803dd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dde:	74 df                	je     803dbf <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803de0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de4:	79 05                	jns    803deb <devcons_read+0x50>
		return c;
  803de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de9:	eb 1d                	jmp    803e08 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803deb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803def:	75 07                	jne    803df8 <devcons_read+0x5d>
		return 0;
  803df1:	b8 00 00 00 00       	mov    $0x0,%eax
  803df6:	eb 10                	jmp    803e08 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfb:	89 c2                	mov    %eax,%edx
  803dfd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e01:	88 10                	mov    %dl,(%rax)
	return 1;
  803e03:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e08:	c9                   	leaveq 
  803e09:	c3                   	retq   

0000000000803e0a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e0a:	55                   	push   %rbp
  803e0b:	48 89 e5             	mov    %rsp,%rbp
  803e0e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e15:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e1c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e23:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e31:	eb 76                	jmp    803ea9 <devcons_write+0x9f>
		m = n - tot;
  803e33:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e3a:	89 c2                	mov    %eax,%edx
  803e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3f:	29 c2                	sub    %eax,%edx
  803e41:	89 d0                	mov    %edx,%eax
  803e43:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e49:	83 f8 7f             	cmp    $0x7f,%eax
  803e4c:	76 07                	jbe    803e55 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e4e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e58:	48 63 d0             	movslq %eax,%rdx
  803e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5e:	48 63 c8             	movslq %eax,%rcx
  803e61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e68:	48 01 c1             	add    %rax,%rcx
  803e6b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e72:	48 89 ce             	mov    %rcx,%rsi
  803e75:	48 89 c7             	mov    %rax,%rdi
  803e78:	48 b8 37 15 80 00 00 	movabs $0x801537,%rax
  803e7f:	00 00 00 
  803e82:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e87:	48 63 d0             	movslq %eax,%rdx
  803e8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e91:	48 89 d6             	mov    %rdx,%rsi
  803e94:	48 89 c7             	mov    %rax,%rdi
  803e97:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  803e9e:	00 00 00 
  803ea1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ea3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea6:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eac:	48 98                	cltq   
  803eae:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803eb5:	0f 82 78 ff ff ff    	jb     803e33 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 08          	sub    $0x8,%rsp
  803ec8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ed1:	c9                   	leaveq 
  803ed2:	c3                   	retq   

0000000000803ed3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ed3:	55                   	push   %rbp
  803ed4:	48 89 e5             	mov    %rsp,%rbp
  803ed7:	48 83 ec 10          	sub    $0x10,%rsp
  803edb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803edf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee7:	48 be fd 48 80 00 00 	movabs $0x8048fd,%rsi
  803eee:	00 00 00 
  803ef1:	48 89 c7             	mov    %rax,%rdi
  803ef4:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  803efb:	00 00 00 
  803efe:	ff d0                	callq  *%rax
	return 0;
  803f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f05:	c9                   	leaveq 
  803f06:	c3                   	retq   

0000000000803f07 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f07:	55                   	push   %rbp
  803f08:	48 89 e5             	mov    %rsp,%rbp
  803f0b:	48 83 ec 30          	sub    $0x30,%rsp
  803f0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f1b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f22:	00 00 00 
  803f25:	48 8b 00             	mov    (%rax),%rax
  803f28:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f2e:	85 c0                	test   %eax,%eax
  803f30:	75 3c                	jne    803f6e <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f32:	48 b8 c6 1a 80 00 00 	movabs $0x801ac6,%rax
  803f39:	00 00 00 
  803f3c:	ff d0                	callq  *%rax
  803f3e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f43:	48 63 d0             	movslq %eax,%rdx
  803f46:	48 89 d0             	mov    %rdx,%rax
  803f49:	48 c1 e0 03          	shl    $0x3,%rax
  803f4d:	48 01 d0             	add    %rdx,%rax
  803f50:	48 c1 e0 05          	shl    $0x5,%rax
  803f54:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f5b:	00 00 00 
  803f5e:	48 01 c2             	add    %rax,%rdx
  803f61:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f68:	00 00 00 
  803f6b:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f6e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f73:	75 0e                	jne    803f83 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f75:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f7c:	00 00 00 
  803f7f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f87:	48 89 c7             	mov    %rax,%rdi
  803f8a:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  803f91:	00 00 00 
  803f94:	ff d0                	callq  *%rax
  803f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9d:	79 19                	jns    803fb8 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803fa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803fb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb6:	eb 53                	jmp    80400b <ipc_recv+0x104>
	}
	if(from_env_store)
  803fb8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fbd:	74 19                	je     803fd8 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803fbf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fc6:	00 00 00 
  803fc9:	48 8b 00             	mov    (%rax),%rax
  803fcc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd6:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fdd:	74 19                	je     803ff8 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803fdf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fe6:	00 00 00 
  803fe9:	48 8b 00             	mov    (%rax),%rax
  803fec:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ff2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff6:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803ff8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fff:	00 00 00 
  804002:	48 8b 00             	mov    (%rax),%rax
  804005:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80400b:	c9                   	leaveq 
  80400c:	c3                   	retq   

000000000080400d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80400d:	55                   	push   %rbp
  80400e:	48 89 e5             	mov    %rsp,%rbp
  804011:	48 83 ec 30          	sub    $0x30,%rsp
  804015:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804018:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80401b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80401f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804022:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804027:	75 0e                	jne    804037 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804029:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804030:	00 00 00 
  804033:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804037:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80403a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80403d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804041:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804044:	89 c7                	mov    %eax,%edi
  804046:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80404d:	00 00 00 
  804050:	ff d0                	callq  *%rax
  804052:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804055:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804059:	75 0c                	jne    804067 <ipc_send+0x5a>
			sys_yield();
  80405b:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804067:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80406b:	74 ca                	je     804037 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80406d:	c9                   	leaveq 
  80406e:	c3                   	retq   

000000000080406f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80406f:	55                   	push   %rbp
  804070:	48 89 e5             	mov    %rsp,%rbp
  804073:	48 83 ec 14          	sub    $0x14,%rsp
  804077:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80407a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804081:	eb 5e                	jmp    8040e1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804083:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80408a:	00 00 00 
  80408d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804090:	48 63 d0             	movslq %eax,%rdx
  804093:	48 89 d0             	mov    %rdx,%rax
  804096:	48 c1 e0 03          	shl    $0x3,%rax
  80409a:	48 01 d0             	add    %rdx,%rax
  80409d:	48 c1 e0 05          	shl    $0x5,%rax
  8040a1:	48 01 c8             	add    %rcx,%rax
  8040a4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8040aa:	8b 00                	mov    (%rax),%eax
  8040ac:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040af:	75 2c                	jne    8040dd <ipc_find_env+0x6e>
			return envs[i].env_id;
  8040b1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8040b8:	00 00 00 
  8040bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040be:	48 63 d0             	movslq %eax,%rdx
  8040c1:	48 89 d0             	mov    %rdx,%rax
  8040c4:	48 c1 e0 03          	shl    $0x3,%rax
  8040c8:	48 01 d0             	add    %rdx,%rax
  8040cb:	48 c1 e0 05          	shl    $0x5,%rax
  8040cf:	48 01 c8             	add    %rcx,%rax
  8040d2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040d8:	8b 40 08             	mov    0x8(%rax),%eax
  8040db:	eb 12                	jmp    8040ef <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040e1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040e8:	7e 99                	jle    804083 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040ef:	c9                   	leaveq 
  8040f0:	c3                   	retq   

00000000008040f1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040f1:	55                   	push   %rbp
  8040f2:	48 89 e5             	mov    %rsp,%rbp
  8040f5:	48 83 ec 18          	sub    $0x18,%rsp
  8040f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804101:	48 c1 e8 15          	shr    $0x15,%rax
  804105:	48 89 c2             	mov    %rax,%rdx
  804108:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80410f:	01 00 00 
  804112:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804116:	83 e0 01             	and    $0x1,%eax
  804119:	48 85 c0             	test   %rax,%rax
  80411c:	75 07                	jne    804125 <pageref+0x34>
		return 0;
  80411e:	b8 00 00 00 00       	mov    $0x0,%eax
  804123:	eb 53                	jmp    804178 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804129:	48 c1 e8 0c          	shr    $0xc,%rax
  80412d:	48 89 c2             	mov    %rax,%rdx
  804130:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804137:	01 00 00 
  80413a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80413e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804146:	83 e0 01             	and    $0x1,%eax
  804149:	48 85 c0             	test   %rax,%rax
  80414c:	75 07                	jne    804155 <pageref+0x64>
		return 0;
  80414e:	b8 00 00 00 00       	mov    $0x0,%eax
  804153:	eb 23                	jmp    804178 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804159:	48 c1 e8 0c          	shr    $0xc,%rax
  80415d:	48 89 c2             	mov    %rax,%rdx
  804160:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804167:	00 00 00 
  80416a:	48 c1 e2 04          	shl    $0x4,%rdx
  80416e:	48 01 d0             	add    %rdx,%rax
  804171:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804175:	0f b7 c0             	movzwl %ax,%eax
}
  804178:	c9                   	leaveq 
  804179:	c3                   	retq   
