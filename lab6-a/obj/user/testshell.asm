
obj/user/testshell.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 60 57 80 00 00 	movabs $0x805760,%rdi
  800098:	00 00 00 
  80009b:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 6d 57 80 00 00 	movabs $0x80576d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 38 4d 80 00 00 	movabs $0x804d38,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 94 57 80 00 00 	movabs $0x805794,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf a0 57 80 00 00 	movabs $0x8057a0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba c4 57 80 00 00 	movabs $0x8057c4,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 43 2d 80 00 00 	movabs $0x802d43,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 43 2d 80 00 00 	movabs $0x802d43,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba cd 57 80 00 00 	movabs $0x8057cd,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be d0 57 80 00 00 	movabs $0x8057d0,%rsi
  800200:	00 00 00 
  800203:	48 bf d3 57 80 00 00 	movabs $0x8057d3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 33 3d 80 00 00 	movabs $0x803d33,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba db 57 80 00 00 	movabs $0x8057db,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 01 53 80 00 00 	movabs $0x805301,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf e5 57 80 00 00 	movabs $0x8057e5,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba f8 57 80 00 00 	movabs $0x8057f8,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 1b 58 80 00 00 	movabs $0x80581b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba 35 58 80 00 00 	movabs $0x805835,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 83 57 80 00 00 	movabs $0x805783,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf 4f 58 80 00 00 	movabs $0x80584f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 0a 31 80 00 00 	movabs $0x80310a,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 0a 31 80 00 00 	movabs $0x80310a,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 68 58 80 00 00 	movabs $0x805868,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 8a 58 80 00 00 	movabs $0x80588a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 99 58 80 00 00 	movabs $0x805899,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf a7 58 80 00 00 	movabs $0x8058a7,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be b1 58 80 00 00 	movabs $0x8058b1,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800845:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	25 ff 03 00 00       	and    $0x3ff,%eax
  800856:	48 63 d0             	movslq %eax,%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 c1 e0 03          	shl    $0x3,%rax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	48 c1 e0 05          	shl    $0x5,%rax
  800867:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80086e:	00 00 00 
  800871:	48 01 c2             	add    %rax,%rdx
  800874:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80087b:	00 00 00 
  80087e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800885:	7e 14                	jle    80089b <libmain+0x65>
		binaryname = argv[0];
  800887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80088b:	48 8b 10             	mov    (%rax),%rdx
  80088e:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  800895:	00 00 00 
  800898:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80089b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a2:	48 89 d6             	mov    %rdx,%rsi
  8008a5:	89 c7                	mov    %eax,%edi
  8008a7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008ae:	00 00 00 
  8008b1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8008b3:	48 b8 c1 08 80 00 00 	movabs $0x8008c1,%rax
  8008ba:	00 00 00 
  8008bd:	ff d0                	callq  *%rax
}
  8008bf:	c9                   	leaveq 
  8008c0:	c3                   	retq   

00000000008008c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008c1:	55                   	push   %rbp
  8008c2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008c5:	48 b8 15 2d 80 00 00 	movabs $0x802d15,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8008d6:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  8008dd:	00 00 00 
  8008e0:	ff d0                	callq  *%rax

}
  8008e2:	5d                   	pop    %rbp
  8008e3:	c3                   	retq   

00000000008008e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	53                   	push   %rbx
  8008e9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008f0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008f7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008fd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800904:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80090b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800912:	84 c0                	test   %al,%al
  800914:	74 23                	je     800939 <_panic+0x55>
  800916:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80091d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800921:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800925:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800929:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80092d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800931:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800935:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800939:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800940:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800947:	00 00 00 
  80094a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800951:	00 00 00 
  800954:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800958:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80095f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800966:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80096d:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  800974:	00 00 00 
  800977:	48 8b 18             	mov    (%rax),%rbx
  80097a:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  800981:	00 00 00 
  800984:	ff d0                	callq  *%rax
  800986:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80098c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800993:	41 89 c8             	mov    %ecx,%r8d
  800996:	48 89 d1             	mov    %rdx,%rcx
  800999:	48 89 da             	mov    %rbx,%rdx
  80099c:	89 c6                	mov    %eax,%esi
  80099e:	48 bf c8 58 80 00 00 	movabs $0x8058c8,%rdi
  8009a5:	00 00 00 
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	49 b9 1d 0b 80 00 00 	movabs $0x800b1d,%r9
  8009b4:	00 00 00 
  8009b7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009ba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c8:	48 89 d6             	mov    %rdx,%rsi
  8009cb:	48 89 c7             	mov    %rax,%rdi
  8009ce:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  8009d5:	00 00 00 
  8009d8:	ff d0                	callq  *%rax
	cprintf("\n");
  8009da:	48 bf eb 58 80 00 00 	movabs $0x8058eb,%rdi
  8009e1:	00 00 00 
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e9:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8009f0:	00 00 00 
  8009f3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009f5:	cc                   	int3   
  8009f6:	eb fd                	jmp    8009f5 <_panic+0x111>

00000000008009f8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009f8:	55                   	push   %rbp
  8009f9:	48 89 e5             	mov    %rsp,%rbp
  8009fc:	48 83 ec 10          	sub    $0x10,%rsp
  800a00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	8d 48 01             	lea    0x1(%rax),%ecx
  800a10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a14:	89 0a                	mov    %ecx,(%rdx)
  800a16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a19:	89 d1                	mov    %edx,%ecx
  800a1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1f:	48 98                	cltq   
  800a21:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a29:	8b 00                	mov    (%rax),%eax
  800a2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a30:	75 2c                	jne    800a5e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a36:	8b 00                	mov    (%rax),%eax
  800a38:	48 98                	cltq   
  800a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a3e:	48 83 c2 08          	add    $0x8,%rdx
  800a42:	48 89 c6             	mov    %rax,%rsi
  800a45:	48 89 d7             	mov    %rdx,%rdi
  800a48:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  800a4f:	00 00 00 
  800a52:	ff d0                	callq  *%rax
        b->idx = 0;
  800a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a62:	8b 40 04             	mov    0x4(%rax),%eax
  800a65:	8d 50 01             	lea    0x1(%rax),%edx
  800a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6c:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a6f:	c9                   	leaveq 
  800a70:	c3                   	retq   

0000000000800a71 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a71:	55                   	push   %rbp
  800a72:	48 89 e5             	mov    %rsp,%rbp
  800a75:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a7c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a83:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a8a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a91:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a98:	48 8b 0a             	mov    (%rdx),%rcx
  800a9b:	48 89 08             	mov    %rcx,(%rax)
  800a9e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aa2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aa6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aaa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800aae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ab5:	00 00 00 
    b.cnt = 0;
  800ab8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800abf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ac2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ac9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ad0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ad7:	48 89 c6             	mov    %rax,%rsi
  800ada:	48 bf f8 09 80 00 00 	movabs $0x8009f8,%rdi
  800ae1:	00 00 00 
  800ae4:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  800aeb:	00 00 00 
  800aee:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800af0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800af6:	48 98                	cltq   
  800af8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800aff:	48 83 c2 08          	add    $0x8,%rdx
  800b03:	48 89 c6             	mov    %rax,%rsi
  800b06:	48 89 d7             	mov    %rdx,%rdi
  800b09:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  800b10:	00 00 00 
  800b13:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b15:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b1b:	c9                   	leaveq 
  800b1c:	c3                   	retq   

0000000000800b1d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b1d:	55                   	push   %rbp
  800b1e:	48 89 e5             	mov    %rsp,%rbp
  800b21:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b28:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b2f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b4b:	84 c0                	test   %al,%al
  800b4d:	74 20                	je     800b6f <cprintf+0x52>
  800b4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b6f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b76:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b7d:	00 00 00 
  800b80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b87:	00 00 00 
  800b8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800ba3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800baa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bb1:	48 8b 0a             	mov    (%rdx),%rcx
  800bb4:	48 89 08             	mov    %rcx,(%rax)
  800bb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bc7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	48 89 c7             	mov    %rax,%rdi
  800bdb:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	callq  *%rax
  800be7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bed:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bf3:	c9                   	leaveq 
  800bf4:	c3                   	retq   

0000000000800bf5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bf5:	55                   	push   %rbp
  800bf6:	48 89 e5             	mov    %rsp,%rbp
  800bf9:	53                   	push   %rbx
  800bfa:	48 83 ec 38          	sub    $0x38,%rsp
  800bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c0a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c0d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c11:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c1c:	77 3b                	ja     800c59 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c1e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c21:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c25:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	48 f7 f3             	div    %rbx
  800c34:	48 89 c2             	mov    %rax,%rdx
  800c37:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c3a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c3d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	41 89 f9             	mov    %edi,%r9d
  800c48:	48 89 c7             	mov    %rax,%rdi
  800c4b:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  800c52:	00 00 00 
  800c55:	ff d0                	callq  *%rax
  800c57:	eb 1e                	jmp    800c77 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c59:	eb 12                	jmp    800c6d <printnum+0x78>
			putch(padc, putdat);
  800c5b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c5f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c66:	48 89 ce             	mov    %rcx,%rsi
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c6d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c71:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c75:	7f e4                	jg     800c5b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c77:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	48 f7 f1             	div    %rcx
  800c86:	48 89 d0             	mov    %rdx,%rax
  800c89:	48 ba f0 5a 80 00 00 	movabs $0x805af0,%rdx
  800c90:	00 00 00 
  800c93:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c97:	0f be d0             	movsbl %al,%edx
  800c9a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca2:	48 89 ce             	mov    %rcx,%rsi
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	ff d0                	callq  *%rax
}
  800ca9:	48 83 c4 38          	add    $0x38,%rsp
  800cad:	5b                   	pop    %rbx
  800cae:	5d                   	pop    %rbp
  800caf:	c3                   	retq   

0000000000800cb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb0:	55                   	push   %rbp
  800cb1:	48 89 e5             	mov    %rsp,%rbp
  800cb4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cbc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cbf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cc3:	7e 52                	jle    800d17 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc9:	8b 00                	mov    (%rax),%eax
  800ccb:	83 f8 30             	cmp    $0x30,%eax
  800cce:	73 24                	jae    800cf4 <getuint+0x44>
  800cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdc:	8b 00                	mov    (%rax),%eax
  800cde:	89 c0                	mov    %eax,%eax
  800ce0:	48 01 d0             	add    %rdx,%rax
  800ce3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ce7:	8b 12                	mov    (%rdx),%edx
  800ce9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf0:	89 0a                	mov    %ecx,(%rdx)
  800cf2:	eb 17                	jmp    800d0b <getuint+0x5b>
  800cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cfc:	48 89 d0             	mov    %rdx,%rax
  800cff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d0b:	48 8b 00             	mov    (%rax),%rax
  800d0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d12:	e9 a3 00 00 00       	jmpq   800dba <getuint+0x10a>
	else if (lflag)
  800d17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d1b:	74 4f                	je     800d6c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d21:	8b 00                	mov    (%rax),%eax
  800d23:	83 f8 30             	cmp    $0x30,%eax
  800d26:	73 24                	jae    800d4c <getuint+0x9c>
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	8b 00                	mov    (%rax),%eax
  800d36:	89 c0                	mov    %eax,%eax
  800d38:	48 01 d0             	add    %rdx,%rax
  800d3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3f:	8b 12                	mov    (%rdx),%edx
  800d41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d48:	89 0a                	mov    %ecx,(%rdx)
  800d4a:	eb 17                	jmp    800d63 <getuint+0xb3>
  800d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d54:	48 89 d0             	mov    %rdx,%rax
  800d57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d63:	48 8b 00             	mov    (%rax),%rax
  800d66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d6a:	eb 4e                	jmp    800dba <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d70:	8b 00                	mov    (%rax),%eax
  800d72:	83 f8 30             	cmp    $0x30,%eax
  800d75:	73 24                	jae    800d9b <getuint+0xeb>
  800d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d83:	8b 00                	mov    (%rax),%eax
  800d85:	89 c0                	mov    %eax,%eax
  800d87:	48 01 d0             	add    %rdx,%rax
  800d8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8e:	8b 12                	mov    (%rdx),%edx
  800d90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d97:	89 0a                	mov    %ecx,(%rdx)
  800d99:	eb 17                	jmp    800db2 <getuint+0x102>
  800d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da3:	48 89 d0             	mov    %rdx,%rax
  800da6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800daa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db2:	8b 00                	mov    (%rax),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dcc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dcf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd3:	7e 52                	jle    800e27 <getint+0x67>
		x=va_arg(*ap, long long);
  800dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd9:	8b 00                	mov    (%rax),%eax
  800ddb:	83 f8 30             	cmp    $0x30,%eax
  800dde:	73 24                	jae    800e04 <getint+0x44>
  800de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	8b 00                	mov    (%rax),%eax
  800dee:	89 c0                	mov    %eax,%eax
  800df0:	48 01 d0             	add    %rdx,%rax
  800df3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df7:	8b 12                	mov    (%rdx),%edx
  800df9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800dfc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e00:	89 0a                	mov    %ecx,(%rdx)
  800e02:	eb 17                	jmp    800e1b <getint+0x5b>
  800e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e08:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e0c:	48 89 d0             	mov    %rdx,%rax
  800e0f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e17:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e1b:	48 8b 00             	mov    (%rax),%rax
  800e1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e22:	e9 a3 00 00 00       	jmpq   800eca <getint+0x10a>
	else if (lflag)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e2b:	74 4f                	je     800e7c <getint+0xbc>
		x=va_arg(*ap, long);
  800e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e31:	8b 00                	mov    (%rax),%eax
  800e33:	83 f8 30             	cmp    $0x30,%eax
  800e36:	73 24                	jae    800e5c <getint+0x9c>
  800e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	8b 00                	mov    (%rax),%eax
  800e46:	89 c0                	mov    %eax,%eax
  800e48:	48 01 d0             	add    %rdx,%rax
  800e4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4f:	8b 12                	mov    (%rdx),%edx
  800e51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e58:	89 0a                	mov    %ecx,(%rdx)
  800e5a:	eb 17                	jmp    800e73 <getint+0xb3>
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e64:	48 89 d0             	mov    %rdx,%rax
  800e67:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e73:	48 8b 00             	mov    (%rax),%rax
  800e76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e7a:	eb 4e                	jmp    800eca <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	8b 00                	mov    (%rax),%eax
  800e82:	83 f8 30             	cmp    $0x30,%eax
  800e85:	73 24                	jae    800eab <getint+0xeb>
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	8b 00                	mov    (%rax),%eax
  800e95:	89 c0                	mov    %eax,%eax
  800e97:	48 01 d0             	add    %rdx,%rax
  800e9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9e:	8b 12                	mov    (%rdx),%edx
  800ea0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea7:	89 0a                	mov    %ecx,(%rdx)
  800ea9:	eb 17                	jmp    800ec2 <getint+0x102>
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb3:	48 89 d0             	mov    %rdx,%rax
  800eb6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800eba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ec2:	8b 00                	mov    (%rax),%eax
  800ec4:	48 98                	cltq   
  800ec6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ece:	c9                   	leaveq 
  800ecf:	c3                   	retq   

0000000000800ed0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	41 54                	push   %r12
  800ed6:	53                   	push   %rbx
  800ed7:	48 83 ec 60          	sub    $0x60,%rsp
  800edb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800edf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ee3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ee7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800eeb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eef:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ef3:	48 8b 0a             	mov    (%rdx),%rcx
  800ef6:	48 89 08             	mov    %rcx,(%rax)
  800ef9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800efd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f01:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f05:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f09:	eb 17                	jmp    800f22 <vprintfmt+0x52>
			if (ch == '\0')
  800f0b:	85 db                	test   %ebx,%ebx
  800f0d:	0f 84 cc 04 00 00    	je     8013df <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800f13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1b:	48 89 d6             	mov    %rdx,%rsi
  800f1e:	89 df                	mov    %ebx,%edi
  800f20:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f22:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f2e:	0f b6 00             	movzbl (%rax),%eax
  800f31:	0f b6 d8             	movzbl %al,%ebx
  800f34:	83 fb 25             	cmp    $0x25,%ebx
  800f37:	75 d2                	jne    800f0b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f39:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f3d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f44:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f52:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f5d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f61:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f65:	0f b6 00             	movzbl (%rax),%eax
  800f68:	0f b6 d8             	movzbl %al,%ebx
  800f6b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f6e:	83 f8 55             	cmp    $0x55,%eax
  800f71:	0f 87 34 04 00 00    	ja     8013ab <vprintfmt+0x4db>
  800f77:	89 c0                	mov    %eax,%eax
  800f79:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f80:	00 
  800f81:	48 b8 18 5b 80 00 00 	movabs $0x805b18,%rax
  800f88:	00 00 00 
  800f8b:	48 01 d0             	add    %rdx,%rax
  800f8e:	48 8b 00             	mov    (%rax),%rax
  800f91:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f93:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f97:	eb c0                	jmp    800f59 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f99:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f9d:	eb ba                	jmp    800f59 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f9f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fa6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fa9:	89 d0                	mov    %edx,%eax
  800fab:	c1 e0 02             	shl    $0x2,%eax
  800fae:	01 d0                	add    %edx,%eax
  800fb0:	01 c0                	add    %eax,%eax
  800fb2:	01 d8                	add    %ebx,%eax
  800fb4:	83 e8 30             	sub    $0x30,%eax
  800fb7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fc4:	83 fb 2f             	cmp    $0x2f,%ebx
  800fc7:	7e 0c                	jle    800fd5 <vprintfmt+0x105>
  800fc9:	83 fb 39             	cmp    $0x39,%ebx
  800fcc:	7f 07                	jg     800fd5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fd3:	eb d1                	jmp    800fa6 <vprintfmt+0xd6>
			goto process_precision;
  800fd5:	eb 58                	jmp    80102f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fda:	83 f8 30             	cmp    $0x30,%eax
  800fdd:	73 17                	jae    800ff6 <vprintfmt+0x126>
  800fdf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fe3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fe6:	89 c0                	mov    %eax,%eax
  800fe8:	48 01 d0             	add    %rdx,%rax
  800feb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fee:	83 c2 08             	add    $0x8,%edx
  800ff1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ff4:	eb 0f                	jmp    801005 <vprintfmt+0x135>
  800ff6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ffa:	48 89 d0             	mov    %rdx,%rax
  800ffd:	48 83 c2 08          	add    $0x8,%rdx
  801001:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801005:	8b 00                	mov    (%rax),%eax
  801007:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80100a:	eb 23                	jmp    80102f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80100c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801010:	79 0c                	jns    80101e <vprintfmt+0x14e>
				width = 0;
  801012:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801019:	e9 3b ff ff ff       	jmpq   800f59 <vprintfmt+0x89>
  80101e:	e9 36 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801023:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80102a:	e9 2a ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80102f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801033:	79 12                	jns    801047 <vprintfmt+0x177>
				width = precision, precision = -1;
  801035:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801038:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80103b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801042:	e9 12 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>
  801047:	e9 0d ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80104c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801050:	e9 04 ff ff ff       	jmpq   800f59 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801055:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801058:	83 f8 30             	cmp    $0x30,%eax
  80105b:	73 17                	jae    801074 <vprintfmt+0x1a4>
  80105d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801061:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801064:	89 c0                	mov    %eax,%eax
  801066:	48 01 d0             	add    %rdx,%rax
  801069:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80106c:	83 c2 08             	add    $0x8,%edx
  80106f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801072:	eb 0f                	jmp    801083 <vprintfmt+0x1b3>
  801074:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801078:	48 89 d0             	mov    %rdx,%rax
  80107b:	48 83 c2 08          	add    $0x8,%rdx
  80107f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801083:	8b 10                	mov    (%rax),%edx
  801085:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801089:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80108d:	48 89 ce             	mov    %rcx,%rsi
  801090:	89 d7                	mov    %edx,%edi
  801092:	ff d0                	callq  *%rax
			break;
  801094:	e9 40 03 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801099:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80109c:	83 f8 30             	cmp    $0x30,%eax
  80109f:	73 17                	jae    8010b8 <vprintfmt+0x1e8>
  8010a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a8:	89 c0                	mov    %eax,%eax
  8010aa:	48 01 d0             	add    %rdx,%rax
  8010ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010b0:	83 c2 08             	add    $0x8,%edx
  8010b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010b6:	eb 0f                	jmp    8010c7 <vprintfmt+0x1f7>
  8010b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010bc:	48 89 d0             	mov    %rdx,%rax
  8010bf:	48 83 c2 08          	add    $0x8,%rdx
  8010c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010c7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010c9:	85 db                	test   %ebx,%ebx
  8010cb:	79 02                	jns    8010cf <vprintfmt+0x1ff>
				err = -err;
  8010cd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010cf:	83 fb 15             	cmp    $0x15,%ebx
  8010d2:	7f 16                	jg     8010ea <vprintfmt+0x21a>
  8010d4:	48 b8 40 5a 80 00 00 	movabs $0x805a40,%rax
  8010db:	00 00 00 
  8010de:	48 63 d3             	movslq %ebx,%rdx
  8010e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010e5:	4d 85 e4             	test   %r12,%r12
  8010e8:	75 2e                	jne    801118 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	89 d9                	mov    %ebx,%ecx
  8010f4:	48 ba 01 5b 80 00 00 	movabs $0x805b01,%rdx
  8010fb:	00 00 00 
  8010fe:	48 89 c7             	mov    %rax,%rdi
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	49 b8 e8 13 80 00 00 	movabs $0x8013e8,%r8
  80110d:	00 00 00 
  801110:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801113:	e9 c1 02 00 00       	jmpq   8013d9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801118:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80111c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801120:	4c 89 e1             	mov    %r12,%rcx
  801123:	48 ba 0a 5b 80 00 00 	movabs $0x805b0a,%rdx
  80112a:	00 00 00 
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	49 b8 e8 13 80 00 00 	movabs $0x8013e8,%r8
  80113c:	00 00 00 
  80113f:	41 ff d0             	callq  *%r8
			break;
  801142:	e9 92 02 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801147:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114a:	83 f8 30             	cmp    $0x30,%eax
  80114d:	73 17                	jae    801166 <vprintfmt+0x296>
  80114f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801153:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801156:	89 c0                	mov    %eax,%eax
  801158:	48 01 d0             	add    %rdx,%rax
  80115b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80115e:	83 c2 08             	add    $0x8,%edx
  801161:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801164:	eb 0f                	jmp    801175 <vprintfmt+0x2a5>
  801166:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80116a:	48 89 d0             	mov    %rdx,%rax
  80116d:	48 83 c2 08          	add    $0x8,%rdx
  801171:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801175:	4c 8b 20             	mov    (%rax),%r12
  801178:	4d 85 e4             	test   %r12,%r12
  80117b:	75 0a                	jne    801187 <vprintfmt+0x2b7>
				p = "(null)";
  80117d:	49 bc 0d 5b 80 00 00 	movabs $0x805b0d,%r12
  801184:	00 00 00 
			if (width > 0 && padc != '-')
  801187:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80118b:	7e 3f                	jle    8011cc <vprintfmt+0x2fc>
  80118d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801191:	74 39                	je     8011cc <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801193:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801196:	48 98                	cltq   
  801198:	48 89 c6             	mov    %rax,%rsi
  80119b:	4c 89 e7             	mov    %r12,%rdi
  80119e:	48 b8 94 16 80 00 00 	movabs $0x801694,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
  8011aa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011ad:	eb 17                	jmp    8011c6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011af:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011bb:	48 89 ce             	mov    %rcx,%rsi
  8011be:	89 d7                	mov    %edx,%edi
  8011c0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ca:	7f e3                	jg     8011af <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011cc:	eb 37                	jmp    801205 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011d2:	74 1e                	je     8011f2 <vprintfmt+0x322>
  8011d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8011d7:	7e 05                	jle    8011de <vprintfmt+0x30e>
  8011d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8011dc:	7e 14                	jle    8011f2 <vprintfmt+0x322>
					putch('?', putdat);
  8011de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011e6:	48 89 d6             	mov    %rdx,%rsi
  8011e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011ee:	ff d0                	callq  *%rax
  8011f0:	eb 0f                	jmp    801201 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011fa:	48 89 d6             	mov    %rdx,%rsi
  8011fd:	89 df                	mov    %ebx,%edi
  8011ff:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801201:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801205:	4c 89 e0             	mov    %r12,%rax
  801208:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	0f be d8             	movsbl %al,%ebx
  801212:	85 db                	test   %ebx,%ebx
  801214:	74 10                	je     801226 <vprintfmt+0x356>
  801216:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80121a:	78 b2                	js     8011ce <vprintfmt+0x2fe>
  80121c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801220:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801224:	79 a8                	jns    8011ce <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801226:	eb 16                	jmp    80123e <vprintfmt+0x36e>
				putch(' ', putdat);
  801228:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80122c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801230:	48 89 d6             	mov    %rdx,%rsi
  801233:	bf 20 00 00 00       	mov    $0x20,%edi
  801238:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80123a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80123e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801242:	7f e4                	jg     801228 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801244:	e9 90 01 00 00       	jmpq   8013d9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801249:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80124d:	be 03 00 00 00       	mov    $0x3,%esi
  801252:	48 89 c7             	mov    %rax,%rdi
  801255:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  80125c:	00 00 00 
  80125f:	ff d0                	callq  *%rax
  801261:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801269:	48 85 c0             	test   %rax,%rax
  80126c:	79 1d                	jns    80128b <vprintfmt+0x3bb>
				putch('-', putdat);
  80126e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801272:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801276:	48 89 d6             	mov    %rdx,%rsi
  801279:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80127e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801284:	48 f7 d8             	neg    %rax
  801287:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80128b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801292:	e9 d5 00 00 00       	jmpq   80136c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801297:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80129b:	be 03 00 00 00       	mov    $0x3,%esi
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 b8 b0 0c 80 00 00 	movabs $0x800cb0,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
  8012af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012b3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012ba:	e9 ad 00 00 00       	jmpq   80136c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8012bf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8012c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012c6:	89 d6                	mov    %edx,%esi
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
  8012d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8012db:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8012e2:	e9 85 00 00 00       	jmpq   80136c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8012e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ef:	48 89 d6             	mov    %rdx,%rsi
  8012f2:	bf 30 00 00 00       	mov    $0x30,%edi
  8012f7:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801301:	48 89 d6             	mov    %rdx,%rsi
  801304:	bf 78 00 00 00       	mov    $0x78,%edi
  801309:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80130b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80130e:	83 f8 30             	cmp    $0x30,%eax
  801311:	73 17                	jae    80132a <vprintfmt+0x45a>
  801313:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801317:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80131a:	89 c0                	mov    %eax,%eax
  80131c:	48 01 d0             	add    %rdx,%rax
  80131f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801322:	83 c2 08             	add    $0x8,%edx
  801325:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801328:	eb 0f                	jmp    801339 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80132a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80132e:	48 89 d0             	mov    %rdx,%rax
  801331:	48 83 c2 08          	add    $0x8,%rdx
  801335:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801339:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80133c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801340:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801347:	eb 23                	jmp    80136c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801349:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80134d:	be 03 00 00 00       	mov    $0x3,%esi
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 b8 b0 0c 80 00 00 	movabs $0x800cb0,%rax
  80135c:	00 00 00 
  80135f:	ff d0                	callq  *%rax
  801361:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801365:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80136c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801371:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801374:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801377:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80137f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801383:	45 89 c1             	mov    %r8d,%r9d
  801386:	41 89 f8             	mov    %edi,%r8d
  801389:	48 89 c7             	mov    %rax,%rdi
  80138c:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
			break;
  801398:	eb 3f                	jmp    8013d9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80139a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80139e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013a2:	48 89 d6             	mov    %rdx,%rsi
  8013a5:	89 df                	mov    %ebx,%edi
  8013a7:	ff d0                	callq  *%rax
			break;
  8013a9:	eb 2e                	jmp    8013d9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b3:	48 89 d6             	mov    %rdx,%rsi
  8013b6:	bf 25 00 00 00       	mov    $0x25,%edi
  8013bb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c2:	eb 05                	jmp    8013c9 <vprintfmt+0x4f9>
  8013c4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013cd:	48 83 e8 01          	sub    $0x1,%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	3c 25                	cmp    $0x25,%al
  8013d6:	75 ec                	jne    8013c4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8013d8:	90                   	nop
		}
	}
  8013d9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013da:	e9 43 fb ff ff       	jmpq   800f22 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013df:	48 83 c4 60          	add    $0x60,%rsp
  8013e3:	5b                   	pop    %rbx
  8013e4:	41 5c                	pop    %r12
  8013e6:	5d                   	pop    %rbp
  8013e7:	c3                   	retq   

00000000008013e8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013e8:	55                   	push   %rbp
  8013e9:	48 89 e5             	mov    %rsp,%rbp
  8013ec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013f3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013fa:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801401:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801408:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80140f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801416:	84 c0                	test   %al,%al
  801418:	74 20                	je     80143a <printfmt+0x52>
  80141a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80141e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801422:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801426:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80142a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80142e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801432:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801436:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80143a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801441:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801448:	00 00 00 
  80144b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801452:	00 00 00 
  801455:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801459:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801460:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801467:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80146e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801475:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80147c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801483:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80148a:	48 89 c7             	mov    %rax,%rdi
  80148d:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  801494:	00 00 00 
  801497:	ff d0                	callq  *%rax
	va_end(ap);
}
  801499:	c9                   	leaveq 
  80149a:	c3                   	retq   

000000000080149b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80149b:	55                   	push   %rbp
  80149c:	48 89 e5             	mov    %rsp,%rbp
  80149f:	48 83 ec 10          	sub    $0x10,%rsp
  8014a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ae:	8b 40 10             	mov    0x10(%rax),%eax
  8014b1:	8d 50 01             	lea    0x1(%rax),%edx
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bf:	48 8b 10             	mov    (%rax),%rdx
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014ca:	48 39 c2             	cmp    %rax,%rdx
  8014cd:	73 17                	jae    8014e6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	48 8b 00             	mov    (%rax),%rax
  8014d6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014de:	48 89 0a             	mov    %rcx,(%rdx)
  8014e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014e4:	88 10                	mov    %dl,(%rax)
}
  8014e6:	c9                   	leaveq 
  8014e7:	c3                   	retq   

00000000008014e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	48 83 ec 50          	sub    $0x50,%rsp
  8014f0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014f4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014f7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014fb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014ff:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801503:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801507:	48 8b 0a             	mov    (%rdx),%rcx
  80150a:	48 89 08             	mov    %rcx,(%rax)
  80150d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801511:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801515:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801519:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80151d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801521:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801525:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801528:	48 98                	cltq   
  80152a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80152e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801532:	48 01 d0             	add    %rdx,%rax
  801535:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801539:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801540:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801545:	74 06                	je     80154d <vsnprintf+0x65>
  801547:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80154b:	7f 07                	jg     801554 <vsnprintf+0x6c>
		return -E_INVAL;
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb 2f                	jmp    801583 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801554:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801558:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80155c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801560:	48 89 c6             	mov    %rax,%rsi
  801563:	48 bf 9b 14 80 00 00 	movabs $0x80149b,%rdi
  80156a:	00 00 00 
  80156d:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  801574:	00 00 00 
  801577:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801579:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801580:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801590:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801597:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80159d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015b2:	84 c0                	test   %al,%al
  8015b4:	74 20                	je     8015d6 <snprintf+0x51>
  8015b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015d6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015dd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015e4:	00 00 00 
  8015e7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015ee:	00 00 00 
  8015f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015fc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801603:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80160a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801611:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801618:	48 8b 0a             	mov    (%rdx),%rcx
  80161b:	48 89 08             	mov    %rcx,(%rax)
  80161e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801622:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801626:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80162a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80162e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801635:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80163c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801642:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801649:	48 89 c7             	mov    %rax,%rdi
  80164c:	48 b8 e8 14 80 00 00 	movabs $0x8014e8,%rax
  801653:	00 00 00 
  801656:	ff d0                	callq  *%rax
  801658:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80165e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801664:	c9                   	leaveq 
  801665:	c3                   	retq   

0000000000801666 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 18          	sub    $0x18,%rsp
  80166e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801672:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801679:	eb 09                	jmp    801684 <strlen+0x1e>
		n++;
  80167b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80167f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	84 c0                	test   %al,%al
  80168d:	75 ec                	jne    80167b <strlen+0x15>
		n++;
	return n;
  80168f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801692:	c9                   	leaveq 
  801693:	c3                   	retq   

0000000000801694 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801694:	55                   	push   %rbp
  801695:	48 89 e5             	mov    %rsp,%rbp
  801698:	48 83 ec 20          	sub    $0x20,%rsp
  80169c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ab:	eb 0e                	jmp    8016bb <strnlen+0x27>
		n++;
  8016ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016b6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016c0:	74 0b                	je     8016cd <strnlen+0x39>
  8016c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	84 c0                	test   %al,%al
  8016cb:	75 e0                	jne    8016ad <strnlen+0x19>
		n++;
	return n;
  8016cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	48 83 ec 20          	sub    $0x20,%rsp
  8016da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016ea:	90                   	nop
  8016eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016fb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016ff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801703:	0f b6 12             	movzbl (%rdx),%edx
  801706:	88 10                	mov    %dl,(%rax)
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	84 c0                	test   %al,%al
  80170d:	75 dc                	jne    8016eb <strcpy+0x19>
		/* do nothing */;
	return ret;
  80170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	48 83 ec 20          	sub    $0x20,%rsp
  80171d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801721:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801729:	48 89 c7             	mov    %rax,%rdi
  80172c:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  801733:	00 00 00 
  801736:	ff d0                	callq  *%rax
  801738:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80173b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80173e:	48 63 d0             	movslq %eax,%rdx
  801741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801745:	48 01 c2             	add    %rax,%rdx
  801748:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80174c:	48 89 c6             	mov    %rax,%rsi
  80174f:	48 89 d7             	mov    %rdx,%rdi
  801752:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  801759:	00 00 00 
  80175c:	ff d0                	callq  *%rax
	return dst;
  80175e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801762:	c9                   	leaveq 
  801763:	c3                   	retq   

0000000000801764 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	48 83 ec 28          	sub    $0x28,%rsp
  80176c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801774:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801780:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801787:	00 
  801788:	eb 2a                	jmp    8017b4 <strncpy+0x50>
		*dst++ = *src;
  80178a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801792:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801796:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80179a:	0f b6 12             	movzbl (%rdx),%edx
  80179d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80179f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	84 c0                	test   %al,%al
  8017a8:	74 05                	je     8017af <strncpy+0x4b>
			src++;
  8017aa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017bc:	72 cc                	jb     80178a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017c2:	c9                   	leaveq 
  8017c3:	c3                   	retq   

00000000008017c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	48 83 ec 28          	sub    $0x28,%rsp
  8017cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017e5:	74 3d                	je     801824 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017e7:	eb 1d                	jmp    801806 <strlcpy+0x42>
			*dst++ = *src++;
  8017e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017f9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017fd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801801:	0f b6 12             	movzbl (%rdx),%edx
  801804:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801806:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80180b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801810:	74 0b                	je     80181d <strlcpy+0x59>
  801812:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	84 c0                	test   %al,%al
  80181b:	75 cc                	jne    8017e9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801821:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182c:	48 29 c2             	sub    %rax,%rdx
  80182f:	48 89 d0             	mov    %rdx,%rax
}
  801832:	c9                   	leaveq 
  801833:	c3                   	retq   

0000000000801834 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	48 83 ec 10          	sub    $0x10,%rsp
  80183c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801840:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801844:	eb 0a                	jmp    801850 <strcmp+0x1c>
		p++, q++;
  801846:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80184b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	84 c0                	test   %al,%al
  801859:	74 12                	je     80186d <strcmp+0x39>
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	0f b6 10             	movzbl (%rax),%edx
  801862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	38 c2                	cmp    %al,%dl
  80186b:	74 d9                	je     801846 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80186d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	0f b6 d0             	movzbl %al,%edx
  801877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	0f b6 c0             	movzbl %al,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 18          	sub    $0x18,%rsp
  80188f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801893:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801897:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80189b:	eb 0f                	jmp    8018ac <strncmp+0x25>
		n--, p++, q++;
  80189d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018b1:	74 1d                	je     8018d0 <strncmp+0x49>
  8018b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b7:	0f b6 00             	movzbl (%rax),%eax
  8018ba:	84 c0                	test   %al,%al
  8018bc:	74 12                	je     8018d0 <strncmp+0x49>
  8018be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c2:	0f b6 10             	movzbl (%rax),%edx
  8018c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	38 c2                	cmp    %al,%dl
  8018ce:	74 cd                	je     80189d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018d5:	75 07                	jne    8018de <strncmp+0x57>
		return 0;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	eb 18                	jmp    8018f6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	0f b6 d0             	movzbl %al,%edx
  8018e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ec:	0f b6 00             	movzbl (%rax),%eax
  8018ef:	0f b6 c0             	movzbl %al,%eax
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	89 d0                	mov    %edx,%eax
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 0c          	sub    $0xc,%rsp
  801900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801904:	89 f0                	mov    %esi,%eax
  801906:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801909:	eb 17                	jmp    801922 <strchr+0x2a>
		if (*s == c)
  80190b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801915:	75 06                	jne    80191d <strchr+0x25>
			return (char *) s;
  801917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191b:	eb 15                	jmp    801932 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80191d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	84 c0                	test   %al,%al
  80192b:	75 de                	jne    80190b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 0c          	sub    $0xc,%rsp
  80193c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801940:	89 f0                	mov    %esi,%eax
  801942:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801945:	eb 13                	jmp    80195a <strfind+0x26>
		if (*s == c)
  801947:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194b:	0f b6 00             	movzbl (%rax),%eax
  80194e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801951:	75 02                	jne    801955 <strfind+0x21>
			break;
  801953:	eb 10                	jmp    801965 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801955:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80195a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195e:	0f b6 00             	movzbl (%rax),%eax
  801961:	84 c0                	test   %al,%al
  801963:	75 e2                	jne    801947 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801969:	c9                   	leaveq 
  80196a:	c3                   	retq   

000000000080196b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 18          	sub    $0x18,%rsp
  801973:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801977:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80197a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80197e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801983:	75 06                	jne    80198b <memset+0x20>
		return v;
  801985:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801989:	eb 69                	jmp    8019f4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80198b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198f:	83 e0 03             	and    $0x3,%eax
  801992:	48 85 c0             	test   %rax,%rax
  801995:	75 48                	jne    8019df <memset+0x74>
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	83 e0 03             	and    $0x3,%eax
  80199e:	48 85 c0             	test   %rax,%rax
  8019a1:	75 3c                	jne    8019df <memset+0x74>
		c &= 0xFF;
  8019a3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ad:	c1 e0 18             	shl    $0x18,%eax
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019b5:	c1 e0 10             	shl    $0x10,%eax
  8019b8:	09 c2                	or     %eax,%edx
  8019ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019bd:	c1 e0 08             	shl    $0x8,%eax
  8019c0:	09 d0                	or     %edx,%eax
  8019c2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c9:	48 c1 e8 02          	shr    $0x2,%rax
  8019cd:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d7:	48 89 d7             	mov    %rdx,%rdi
  8019da:	fc                   	cld    
  8019db:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019dd:	eb 11                	jmp    8019f0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ea:	48 89 d7             	mov    %rdx,%rdi
  8019ed:	fc                   	cld    
  8019ee:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 28          	sub    $0x28,%rsp
  8019fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a22:	0f 83 88 00 00 00    	jae    801ab0 <memmove+0xba>
  801a28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a30:	48 01 d0             	add    %rdx,%rax
  801a33:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a37:	76 77                	jbe    801ab0 <memmove+0xba>
		s += n;
  801a39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	83 e0 03             	and    $0x3,%eax
  801a50:	48 85 c0             	test   %rax,%rax
  801a53:	75 3b                	jne    801a90 <memmove+0x9a>
  801a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a59:	83 e0 03             	and    $0x3,%eax
  801a5c:	48 85 c0             	test   %rax,%rax
  801a5f:	75 2f                	jne    801a90 <memmove+0x9a>
  801a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a65:	83 e0 03             	and    $0x3,%eax
  801a68:	48 85 c0             	test   %rax,%rax
  801a6b:	75 23                	jne    801a90 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a71:	48 83 e8 04          	sub    $0x4,%rax
  801a75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a79:	48 83 ea 04          	sub    $0x4,%rdx
  801a7d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a81:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 89 d6             	mov    %rdx,%rsi
  801a8b:	fd                   	std    
  801a8c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a8e:	eb 1d                	jmp    801aad <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa4:	48 89 d7             	mov    %rdx,%rdi
  801aa7:	48 89 c1             	mov    %rax,%rcx
  801aaa:	fd                   	std    
  801aab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801aad:	fc                   	cld    
  801aae:	eb 57                	jmp    801b07 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab4:	83 e0 03             	and    $0x3,%eax
  801ab7:	48 85 c0             	test   %rax,%rax
  801aba:	75 36                	jne    801af2 <memmove+0xfc>
  801abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac0:	83 e0 03             	and    $0x3,%eax
  801ac3:	48 85 c0             	test   %rax,%rax
  801ac6:	75 2a                	jne    801af2 <memmove+0xfc>
  801ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acc:	83 e0 03             	and    $0x3,%eax
  801acf:	48 85 c0             	test   %rax,%rax
  801ad2:	75 1e                	jne    801af2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad8:	48 c1 e8 02          	shr    $0x2,%rax
  801adc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ae7:	48 89 c7             	mov    %rax,%rdi
  801aea:	48 89 d6             	mov    %rdx,%rsi
  801aed:	fc                   	cld    
  801aee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801af0:	eb 15                	jmp    801b07 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801afa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801afe:	48 89 c7             	mov    %rax,%rdi
  801b01:	48 89 d6             	mov    %rdx,%rsi
  801b04:	fc                   	cld    
  801b05:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 18          	sub    $0x18,%rsp
  801b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b25:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2d:	48 89 ce             	mov    %rcx,%rsi
  801b30:	48 89 c7             	mov    %rax,%rdi
  801b33:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 28          	sub    $0x28,%rsp
  801b49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b65:	eb 36                	jmp    801b9d <memcmp+0x5c>
		if (*s1 != *s2)
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	0f b6 10             	movzbl (%rax),%edx
  801b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b72:	0f b6 00             	movzbl (%rax),%eax
  801b75:	38 c2                	cmp    %al,%dl
  801b77:	74 1a                	je     801b93 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7d:	0f b6 00             	movzbl (%rax),%eax
  801b80:	0f b6 d0             	movzbl %al,%edx
  801b83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b87:	0f b6 00             	movzbl (%rax),%eax
  801b8a:	0f b6 c0             	movzbl %al,%eax
  801b8d:	29 c2                	sub    %eax,%edx
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	eb 20                	jmp    801bb3 <memcmp+0x72>
		s1++, s2++;
  801b93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b98:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ba5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ba9:	48 85 c0             	test   %rax,%rax
  801bac:	75 b9                	jne    801b67 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 28          	sub    $0x28,%rsp
  801bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bd0:	48 01 d0             	add    %rdx,%rax
  801bd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdd:	0f b6 10             	movzbl (%rax),%edx
  801be0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be3:	38 c2                	cmp    %al,%dl
  801be5:	75 02                	jne    801be9 <memfind+0x34>
			break;
  801be7:	eb 0f                	jmp    801bf8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801be9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bf6:	72 e1                	jb     801bd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 34          	sub    $0x34,%rsp
  801c06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c0e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c18:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c1f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c20:	eb 05                	jmp    801c27 <strtol+0x29>
		s++;
  801c22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2b:	0f b6 00             	movzbl (%rax),%eax
  801c2e:	3c 20                	cmp    $0x20,%al
  801c30:	74 f0                	je     801c22 <strtol+0x24>
  801c32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c36:	0f b6 00             	movzbl (%rax),%eax
  801c39:	3c 09                	cmp    $0x9,%al
  801c3b:	74 e5                	je     801c22 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c41:	0f b6 00             	movzbl (%rax),%eax
  801c44:	3c 2b                	cmp    $0x2b,%al
  801c46:	75 07                	jne    801c4f <strtol+0x51>
		s++;
  801c48:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c4d:	eb 17                	jmp    801c66 <strtol+0x68>
	else if (*s == '-')
  801c4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c53:	0f b6 00             	movzbl (%rax),%eax
  801c56:	3c 2d                	cmp    $0x2d,%al
  801c58:	75 0c                	jne    801c66 <strtol+0x68>
		s++, neg = 1;
  801c5a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c5f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c66:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c6a:	74 06                	je     801c72 <strtol+0x74>
  801c6c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c70:	75 28                	jne    801c9a <strtol+0x9c>
  801c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c76:	0f b6 00             	movzbl (%rax),%eax
  801c79:	3c 30                	cmp    $0x30,%al
  801c7b:	75 1d                	jne    801c9a <strtol+0x9c>
  801c7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c81:	48 83 c0 01          	add    $0x1,%rax
  801c85:	0f b6 00             	movzbl (%rax),%eax
  801c88:	3c 78                	cmp    $0x78,%al
  801c8a:	75 0e                	jne    801c9a <strtol+0x9c>
		s += 2, base = 16;
  801c8c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c91:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c98:	eb 2c                	jmp    801cc6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c9e:	75 19                	jne    801cb9 <strtol+0xbb>
  801ca0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca4:	0f b6 00             	movzbl (%rax),%eax
  801ca7:	3c 30                	cmp    $0x30,%al
  801ca9:	75 0e                	jne    801cb9 <strtol+0xbb>
		s++, base = 8;
  801cab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cb7:	eb 0d                	jmp    801cc6 <strtol+0xc8>
	else if (base == 0)
  801cb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cbd:	75 07                	jne    801cc6 <strtol+0xc8>
		base = 10;
  801cbf:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cca:	0f b6 00             	movzbl (%rax),%eax
  801ccd:	3c 2f                	cmp    $0x2f,%al
  801ccf:	7e 1d                	jle    801cee <strtol+0xf0>
  801cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd5:	0f b6 00             	movzbl (%rax),%eax
  801cd8:	3c 39                	cmp    $0x39,%al
  801cda:	7f 12                	jg     801cee <strtol+0xf0>
			dig = *s - '0';
  801cdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce0:	0f b6 00             	movzbl (%rax),%eax
  801ce3:	0f be c0             	movsbl %al,%eax
  801ce6:	83 e8 30             	sub    $0x30,%eax
  801ce9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cec:	eb 4e                	jmp    801d3c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801cee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf2:	0f b6 00             	movzbl (%rax),%eax
  801cf5:	3c 60                	cmp    $0x60,%al
  801cf7:	7e 1d                	jle    801d16 <strtol+0x118>
  801cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfd:	0f b6 00             	movzbl (%rax),%eax
  801d00:	3c 7a                	cmp    $0x7a,%al
  801d02:	7f 12                	jg     801d16 <strtol+0x118>
			dig = *s - 'a' + 10;
  801d04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d08:	0f b6 00             	movzbl (%rax),%eax
  801d0b:	0f be c0             	movsbl %al,%eax
  801d0e:	83 e8 57             	sub    $0x57,%eax
  801d11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d14:	eb 26                	jmp    801d3c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1a:	0f b6 00             	movzbl (%rax),%eax
  801d1d:	3c 40                	cmp    $0x40,%al
  801d1f:	7e 48                	jle    801d69 <strtol+0x16b>
  801d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d25:	0f b6 00             	movzbl (%rax),%eax
  801d28:	3c 5a                	cmp    $0x5a,%al
  801d2a:	7f 3d                	jg     801d69 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d30:	0f b6 00             	movzbl (%rax),%eax
  801d33:	0f be c0             	movsbl %al,%eax
  801d36:	83 e8 37             	sub    $0x37,%eax
  801d39:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d3f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d42:	7c 02                	jl     801d46 <strtol+0x148>
			break;
  801d44:	eb 23                	jmp    801d69 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d46:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d4b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d4e:	48 98                	cltq   
  801d50:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d55:	48 89 c2             	mov    %rax,%rdx
  801d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d5b:	48 98                	cltq   
  801d5d:	48 01 d0             	add    %rdx,%rax
  801d60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d64:	e9 5d ff ff ff       	jmpq   801cc6 <strtol+0xc8>

	if (endptr)
  801d69:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d6e:	74 0b                	je     801d7b <strtol+0x17d>
		*endptr = (char *) s;
  801d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d78:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d7f:	74 09                	je     801d8a <strtol+0x18c>
  801d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d85:	48 f7 d8             	neg    %rax
  801d88:	eb 04                	jmp    801d8e <strtol+0x190>
  801d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 30          	sub    $0x30,%rsp
  801d98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801da0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801da4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801da8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801dac:	0f b6 00             	movzbl (%rax),%eax
  801daf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801db2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801db6:	75 06                	jne    801dbe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dbc:	eb 6b                	jmp    801e29 <strstr+0x99>

	len = strlen(str);
  801dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc2:	48 89 c7             	mov    %rax,%rdi
  801dc5:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	callq  *%rax
  801dd1:	48 98                	cltq   
  801dd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ddf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801de3:	0f b6 00             	movzbl (%rax),%eax
  801de6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801de9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ded:	75 07                	jne    801df6 <strstr+0x66>
				return (char *) 0;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	eb 33                	jmp    801e29 <strstr+0x99>
		} while (sc != c);
  801df6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801dfa:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801dfd:	75 d8                	jne    801dd7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801dff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e03:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0b:	48 89 ce             	mov    %rcx,%rsi
  801e0e:	48 89 c7             	mov    %rax,%rdi
  801e11:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	75 b6                	jne    801dd7 <strstr+0x47>

	return (char *) (in - 1);
  801e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e25:	48 83 e8 01          	sub    $0x1,%rax
}
  801e29:	c9                   	leaveq 
  801e2a:	c3                   	retq   

0000000000801e2b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e2b:	55                   	push   %rbp
  801e2c:	48 89 e5             	mov    %rsp,%rbp
  801e2f:	53                   	push   %rbx
  801e30:	48 83 ec 48          	sub    $0x48,%rsp
  801e34:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e37:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e3a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e3e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e42:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e46:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e4d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e51:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e55:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e59:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e5d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e61:	4c 89 c3             	mov    %r8,%rbx
  801e64:	cd 30                	int    $0x30
  801e66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e6e:	74 3e                	je     801eae <syscall+0x83>
  801e70:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e75:	7e 37                	jle    801eae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e7b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e7e:	49 89 d0             	mov    %rdx,%r8
  801e81:	89 c1                	mov    %eax,%ecx
  801e83:	48 ba c8 5d 80 00 00 	movabs $0x805dc8,%rdx
  801e8a:	00 00 00 
  801e8d:	be 23 00 00 00       	mov    $0x23,%esi
  801e92:	48 bf e5 5d 80 00 00 	movabs $0x805de5,%rdi
  801e99:	00 00 00 
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	49 b9 e4 08 80 00 00 	movabs $0x8008e4,%r9
  801ea8:	00 00 00 
  801eab:	41 ff d1             	callq  *%r9

	return ret;
  801eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eb2:	48 83 c4 48          	add    $0x48,%rsp
  801eb6:	5b                   	pop    %rbx
  801eb7:	5d                   	pop    %rbp
  801eb8:	c3                   	retq   

0000000000801eb9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801eb9:	55                   	push   %rbp
  801eba:	48 89 e5             	mov    %rsp,%rbp
  801ebd:	48 83 ec 20          	sub    $0x20,%rsp
  801ec1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed8:	00 
  801ed9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801edf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee5:	48 89 d1             	mov    %rdx,%rcx
  801ee8:	48 89 c2             	mov    %rax,%rdx
  801eeb:	be 00 00 00 00       	mov    $0x0,%esi
  801ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef5:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	callq  *%rax
}
  801f01:	c9                   	leaveq 
  801f02:	c3                   	retq   

0000000000801f03 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f12:	00 
  801f13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	be 00 00 00 00       	mov    $0x0,%esi
  801f2e:	bf 01 00 00 00       	mov    $0x1,%edi
  801f33:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 10          	sub    $0x10,%rsp
  801f49:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4f:	48 98                	cltq   
  801f51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f58:	00 
  801f59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6a:	48 89 c2             	mov    %rax,%rdx
  801f6d:	be 01 00 00 00       	mov    $0x1,%esi
  801f72:	bf 03 00 00 00       	mov    $0x3,%edi
  801f77:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f94:	00 
  801f95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fab:	be 00 00 00 00       	mov    $0x0,%esi
  801fb0:	bf 02 00 00 00       	mov    $0x2,%edi
  801fb5:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <sys_yield>:

void
sys_yield(void)
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fcb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd2:	00 
  801fd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe9:	be 00 00 00 00       	mov    $0x0,%esi
  801fee:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ff3:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
}
  801fff:	c9                   	leaveq 
  802000:	c3                   	retq   

0000000000802001 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802001:	55                   	push   %rbp
  802002:	48 89 e5             	mov    %rsp,%rbp
  802005:	48 83 ec 20          	sub    $0x20,%rsp
  802009:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80200c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802010:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802013:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802016:	48 63 c8             	movslq %eax,%rcx
  802019:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80201d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802020:	48 98                	cltq   
  802022:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802029:	00 
  80202a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802030:	49 89 c8             	mov    %rcx,%r8
  802033:	48 89 d1             	mov    %rdx,%rcx
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	be 01 00 00 00       	mov    $0x1,%esi
  80203e:	bf 04 00 00 00       	mov    $0x4,%edi
  802043:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
}
  80204f:	c9                   	leaveq 
  802050:	c3                   	retq   

0000000000802051 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	48 83 ec 30          	sub    $0x30,%rsp
  802059:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80205c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802060:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802063:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802067:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80206b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80206e:	48 63 c8             	movslq %eax,%rcx
  802071:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802075:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802078:	48 63 f0             	movslq %eax,%rsi
  80207b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802082:	48 98                	cltq   
  802084:	48 89 0c 24          	mov    %rcx,(%rsp)
  802088:	49 89 f9             	mov    %rdi,%r9
  80208b:	49 89 f0             	mov    %rsi,%r8
  80208e:	48 89 d1             	mov    %rdx,%rcx
  802091:	48 89 c2             	mov    %rax,%rdx
  802094:	be 01 00 00 00       	mov    $0x1,%esi
  802099:	bf 05 00 00 00       	mov    $0x5,%edi
  80209e:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
}
  8020aa:	c9                   	leaveq 
  8020ab:	c3                   	retq   

00000000008020ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	48 83 ec 20          	sub    $0x20,%rsp
  8020b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c2:	48 98                	cltq   
  8020c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020cb:	00 
  8020cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020d8:	48 89 d1             	mov    %rdx,%rcx
  8020db:	48 89 c2             	mov    %rax,%rdx
  8020de:	be 01 00 00 00       	mov    $0x1,%esi
  8020e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8020e8:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
}
  8020f4:	c9                   	leaveq 
  8020f5:	c3                   	retq   

00000000008020f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020f6:	55                   	push   %rbp
  8020f7:	48 89 e5             	mov    %rsp,%rbp
  8020fa:	48 83 ec 10          	sub    $0x10,%rsp
  8020fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802101:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802104:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802107:	48 63 d0             	movslq %eax,%rdx
  80210a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210d:	48 98                	cltq   
  80210f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802116:	00 
  802117:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80211d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802123:	48 89 d1             	mov    %rdx,%rcx
  802126:	48 89 c2             	mov    %rax,%rdx
  802129:	be 01 00 00 00       	mov    $0x1,%esi
  80212e:	bf 08 00 00 00       	mov    $0x8,%edi
  802133:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 20          	sub    $0x20,%rsp
  802149:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80214c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802150:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802157:	48 98                	cltq   
  802159:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802160:	00 
  802161:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802167:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80216d:	48 89 d1             	mov    %rdx,%rcx
  802170:	48 89 c2             	mov    %rax,%rdx
  802173:	be 01 00 00 00       	mov    $0x1,%esi
  802178:	bf 09 00 00 00       	mov    $0x9,%edi
  80217d:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
}
  802189:	c9                   	leaveq 
  80218a:	c3                   	retq   

000000000080218b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80218b:	55                   	push   %rbp
  80218c:	48 89 e5             	mov    %rsp,%rbp
  80218f:	48 83 ec 20          	sub    $0x20,%rsp
  802193:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802196:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80219a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80219e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a1:	48 98                	cltq   
  8021a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021aa:	00 
  8021ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021b7:	48 89 d1             	mov    %rdx,%rcx
  8021ba:	48 89 c2             	mov    %rax,%rdx
  8021bd:	be 01 00 00 00       	mov    $0x1,%esi
  8021c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021c7:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	callq  *%rax
}
  8021d3:	c9                   	leaveq 
  8021d4:	c3                   	retq   

00000000008021d5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021d5:	55                   	push   %rbp
  8021d6:	48 89 e5             	mov    %rsp,%rbp
  8021d9:	48 83 ec 20          	sub    $0x20,%rsp
  8021dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021e8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021ee:	48 63 f0             	movslq %eax,%rsi
  8021f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f8:	48 98                	cltq   
  8021fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802205:	00 
  802206:	49 89 f1             	mov    %rsi,%r9
  802209:	49 89 c8             	mov    %rcx,%r8
  80220c:	48 89 d1             	mov    %rdx,%rcx
  80220f:	48 89 c2             	mov    %rax,%rdx
  802212:	be 00 00 00 00       	mov    $0x0,%esi
  802217:	bf 0c 00 00 00       	mov    $0xc,%edi
  80221c:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
}
  802228:	c9                   	leaveq 
  802229:	c3                   	retq   

000000000080222a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80222a:	55                   	push   %rbp
  80222b:	48 89 e5             	mov    %rsp,%rbp
  80222e:	48 83 ec 10          	sub    $0x10,%rsp
  802232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802241:	00 
  802242:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802248:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80224e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802253:	48 89 c2             	mov    %rax,%rdx
  802256:	be 01 00 00 00       	mov    $0x1,%esi
  80225b:	bf 0d 00 00 00       	mov    $0xd,%edi
  802260:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 20          	sub    $0x20,%rsp
  802276:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80227a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  80227e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802282:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802286:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80228d:	00 
  80228e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802294:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80229a:	48 89 d1             	mov    %rdx,%rcx
  80229d:	48 89 c2             	mov    %rax,%rdx
  8022a0:	be 01 00 00 00       	mov    $0x1,%esi
  8022a5:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022aa:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8022b1:	00 00 00 
  8022b4:	ff d0                	callq  *%rax
}
  8022b6:	c9                   	leaveq 
  8022b7:	c3                   	retq   

00000000008022b8 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8022b8:	55                   	push   %rbp
  8022b9:	48 89 e5             	mov    %rsp,%rbp
  8022bc:	48 83 ec 10          	sub    $0x10,%rsp
  8022c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8022c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cf:	00 
  8022d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022e1:	48 89 c2             	mov    %rax,%rdx
  8022e4:	be 00 00 00 00       	mov    $0x0,%esi
  8022e9:	bf 10 00 00 00       	mov    $0x10,%edi
  8022ee:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	callq  *%rax
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802304:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80230b:	00 
  80230c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802312:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802318:	b9 00 00 00 00       	mov    $0x0,%ecx
  80231d:	ba 00 00 00 00       	mov    $0x0,%edx
  802322:	be 00 00 00 00       	mov    $0x0,%esi
  802327:	bf 0e 00 00 00       	mov    $0xe,%edi
  80232c:	48 b8 2b 1e 80 00 00 	movabs $0x801e2b,%rax
  802333:	00 00 00 
  802336:	ff d0                	callq  *%rax
}
  802338:	c9                   	leaveq 
  802339:	c3                   	retq   

000000000080233a <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  80233a:	55                   	push   %rbp
  80233b:	48 89 e5             	mov    %rsp,%rbp
  80233e:	48 83 ec 30          	sub    $0x30,%rsp
  802342:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802346:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80234a:	48 8b 00             	mov    (%rax),%rax
  80234d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802355:	48 8b 40 08          	mov    0x8(%rax),%rax
  802359:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  80235c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80235f:	83 e0 02             	and    $0x2,%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	75 4d                	jne    8023b3 <pgfault+0x79>
  802366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236a:	48 c1 e8 0c          	shr    $0xc,%rax
  80236e:	48 89 c2             	mov    %rax,%rdx
  802371:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802378:	01 00 00 
  80237b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237f:	25 00 08 00 00       	and    $0x800,%eax
  802384:	48 85 c0             	test   %rax,%rax
  802387:	74 2a                	je     8023b3 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802389:	48 ba f8 5d 80 00 00 	movabs $0x805df8,%rdx
  802390:	00 00 00 
  802393:	be 23 00 00 00       	mov    $0x23,%esi
  802398:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80239f:	00 00 00 
  8023a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a7:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8023ae:	00 00 00 
  8023b1:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8023b3:	ba 07 00 00 00       	mov    $0x7,%edx
  8023b8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c2:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	0f 85 cd 00 00 00    	jne    8024a3 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8023d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8023e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8023ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f5:	48 89 c6             	mov    %rax,%rsi
  8023f8:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023fd:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802409:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802413:	48 89 c1             	mov    %rax,%rcx
  802416:	ba 00 00 00 00       	mov    $0x0,%edx
  80241b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802420:	bf 00 00 00 00       	mov    $0x0,%edi
  802425:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80242c:	00 00 00 
  80242f:	ff d0                	callq  *%rax
  802431:	85 c0                	test   %eax,%eax
  802433:	79 2a                	jns    80245f <pgfault+0x125>
				panic("Page map at temp address failed");
  802435:	48 ba 38 5e 80 00 00 	movabs $0x805e38,%rdx
  80243c:	00 00 00 
  80243f:	be 30 00 00 00       	mov    $0x30,%esi
  802444:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80244b:	00 00 00 
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80245a:	00 00 00 
  80245d:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80245f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802464:	bf 00 00 00 00       	mov    $0x0,%edi
  802469:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802470:	00 00 00 
  802473:	ff d0                	callq  *%rax
  802475:	85 c0                	test   %eax,%eax
  802477:	79 54                	jns    8024cd <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802479:	48 ba 58 5e 80 00 00 	movabs $0x805e58,%rdx
  802480:	00 00 00 
  802483:	be 32 00 00 00       	mov    $0x32,%esi
  802488:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  80248f:	00 00 00 
  802492:	b8 00 00 00 00       	mov    $0x0,%eax
  802497:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80249e:	00 00 00 
  8024a1:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8024a3:	48 ba 80 5e 80 00 00 	movabs $0x805e80,%rdx
  8024aa:	00 00 00 
  8024ad:	be 34 00 00 00       	mov    $0x34,%esi
  8024b2:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8024b9:	00 00 00 
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8024c8:	00 00 00 
  8024cb:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8024cd:	c9                   	leaveq 
  8024ce:	c3                   	retq   

00000000008024cf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	48 83 ec 20          	sub    $0x20,%rsp
  8024d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024da:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8024dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024e4:	01 00 00 
  8024e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8024f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8024f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8024f9:	48 c1 e0 0c          	shl    $0xc,%rax
  8024fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802504:	25 00 04 00 00       	and    $0x400,%eax
  802509:	85 c0                	test   %eax,%eax
  80250b:	74 57                	je     802564 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80250d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802510:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802514:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251b:	41 89 f0             	mov    %esi,%r8d
  80251e:	48 89 c6             	mov    %rax,%rsi
  802521:	bf 00 00 00 00       	mov    $0x0,%edi
  802526:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80252d:	00 00 00 
  802530:	ff d0                	callq  *%rax
  802532:	85 c0                	test   %eax,%eax
  802534:	0f 8e 52 01 00 00    	jle    80268c <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80253a:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  802541:	00 00 00 
  802544:	be 4e 00 00 00       	mov    $0x4e,%esi
  802549:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802550:	00 00 00 
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  80255f:	00 00 00 
  802562:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802567:	83 e0 02             	and    $0x2,%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	75 10                	jne    80257e <duppage+0xaf>
  80256e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802571:	25 00 08 00 00       	and    $0x800,%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	0f 84 bb 00 00 00    	je     802639 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802581:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802586:	80 cc 08             	or     $0x8,%ah
  802589:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80258c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80258f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802593:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	41 89 f0             	mov    %esi,%r8d
  80259d:	48 89 c6             	mov    %rax,%rsi
  8025a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a5:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	7e 2a                	jle    8025df <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8025b5:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  8025bc:	00 00 00 
  8025bf:	be 55 00 00 00       	mov    $0x55,%esi
  8025c4:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8025cb:	00 00 00 
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d3:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8025da:	00 00 00 
  8025dd:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8025df:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8025e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ea:	41 89 c8             	mov    %ecx,%r8d
  8025ed:	48 89 d1             	mov    %rdx,%rcx
  8025f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f5:	48 89 c6             	mov    %rax,%rsi
  8025f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025fd:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802604:	00 00 00 
  802607:	ff d0                	callq  *%rax
  802609:	85 c0                	test   %eax,%eax
  80260b:	7e 2a                	jle    802637 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80260d:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  802614:	00 00 00 
  802617:	be 57 00 00 00       	mov    $0x57,%esi
  80261c:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802623:	00 00 00 
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802632:	00 00 00 
  802635:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802637:	eb 53                	jmp    80268c <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802639:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80263c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802640:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802647:	41 89 f0             	mov    %esi,%r8d
  80264a:	48 89 c6             	mov    %rax,%rsi
  80264d:	bf 00 00 00 00       	mov    $0x0,%edi
  802652:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802659:	00 00 00 
  80265c:	ff d0                	callq  *%rax
  80265e:	85 c0                	test   %eax,%eax
  802660:	7e 2a                	jle    80268c <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802662:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  802669:	00 00 00 
  80266c:	be 5b 00 00 00       	mov    $0x5b,%esi
  802671:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802678:	00 00 00 
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  802687:	00 00 00 
  80268a:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802691:	c9                   	leaveq 
  802692:	c3                   	retq   

0000000000802693 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802693:	55                   	push   %rbp
  802694:	48 89 e5             	mov    %rsp,%rbp
  802697:	48 83 ec 18          	sub    $0x18,%rsp
  80269b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80269f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8026a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ab:	48 c1 e8 27          	shr    $0x27,%rax
  8026af:	48 89 c2             	mov    %rax,%rdx
  8026b2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8026b9:	01 00 00 
  8026bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c0:	83 e0 01             	and    $0x1,%eax
  8026c3:	48 85 c0             	test   %rax,%rax
  8026c6:	74 51                	je     802719 <pt_is_mapped+0x86>
  8026c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cc:	48 c1 e0 0c          	shl    $0xc,%rax
  8026d0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026d4:	48 89 c2             	mov    %rax,%rdx
  8026d7:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8026de:	01 00 00 
  8026e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e5:	83 e0 01             	and    $0x1,%eax
  8026e8:	48 85 c0             	test   %rax,%rax
  8026eb:	74 2c                	je     802719 <pt_is_mapped+0x86>
  8026ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f1:	48 c1 e0 0c          	shl    $0xc,%rax
  8026f5:	48 c1 e8 15          	shr    $0x15,%rax
  8026f9:	48 89 c2             	mov    %rax,%rdx
  8026fc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802703:	01 00 00 
  802706:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270a:	83 e0 01             	and    $0x1,%eax
  80270d:	48 85 c0             	test   %rax,%rax
  802710:	74 07                	je     802719 <pt_is_mapped+0x86>
  802712:	b8 01 00 00 00       	mov    $0x1,%eax
  802717:	eb 05                	jmp    80271e <pt_is_mapped+0x8b>
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	83 e0 01             	and    $0x1,%eax
}
  802721:	c9                   	leaveq 
  802722:	c3                   	retq   

0000000000802723 <fork>:

envid_t
fork(void)
{
  802723:	55                   	push   %rbp
  802724:	48 89 e5             	mov    %rsp,%rbp
  802727:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80272b:	48 bf 3a 23 80 00 00 	movabs $0x80233a,%rdi
  802732:	00 00 00 
  802735:	48 b8 9e 53 80 00 00 	movabs $0x80539e,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802741:	b8 07 00 00 00       	mov    $0x7,%eax
  802746:	cd 30                	int    $0x30
  802748:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80274b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80274e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802755:	79 30                	jns    802787 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802757:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80275a:	89 c1                	mov    %eax,%ecx
  80275c:	48 ba d0 5e 80 00 00 	movabs $0x805ed0,%rdx
  802763:	00 00 00 
  802766:	be 86 00 00 00       	mov    $0x86,%esi
  80276b:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  802772:	00 00 00 
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  802781:	00 00 00 
  802784:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80278b:	75 46                	jne    8027d3 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80278d:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	25 ff 03 00 00       	and    $0x3ff,%eax
  80279e:	48 63 d0             	movslq %eax,%rdx
  8027a1:	48 89 d0             	mov    %rdx,%rax
  8027a4:	48 c1 e0 03          	shl    $0x3,%rax
  8027a8:	48 01 d0             	add    %rdx,%rax
  8027ab:	48 c1 e0 05          	shl    $0x5,%rax
  8027af:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027b6:	00 00 00 
  8027b9:	48 01 c2             	add    %rax,%rdx
  8027bc:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8027c3:	00 00 00 
  8027c6:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ce:	e9 d1 01 00 00       	jmpq   8029a4 <fork+0x281>
	}
	uint64_t ad = 0;
  8027d3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027da:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8027db:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8027e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8027e4:	e9 df 00 00 00       	jmpq   8028c8 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8027e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ed:	48 c1 e8 27          	shr    $0x27,%rax
  8027f1:	48 89 c2             	mov    %rax,%rdx
  8027f4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8027fb:	01 00 00 
  8027fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802802:	83 e0 01             	and    $0x1,%eax
  802805:	48 85 c0             	test   %rax,%rax
  802808:	0f 84 9e 00 00 00    	je     8028ac <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80280e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802812:	48 c1 e8 1e          	shr    $0x1e,%rax
  802816:	48 89 c2             	mov    %rax,%rdx
  802819:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802820:	01 00 00 
  802823:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802827:	83 e0 01             	and    $0x1,%eax
  80282a:	48 85 c0             	test   %rax,%rax
  80282d:	74 73                	je     8028a2 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80282f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802833:	48 c1 e8 15          	shr    $0x15,%rax
  802837:	48 89 c2             	mov    %rax,%rdx
  80283a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802841:	01 00 00 
  802844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802848:	83 e0 01             	and    $0x1,%eax
  80284b:	48 85 c0             	test   %rax,%rax
  80284e:	74 48                	je     802898 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802854:	48 c1 e8 0c          	shr    $0xc,%rax
  802858:	48 89 c2             	mov    %rax,%rdx
  80285b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802862:	01 00 00 
  802865:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802869:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80286d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802871:	83 e0 01             	and    $0x1,%eax
  802874:	48 85 c0             	test   %rax,%rax
  802877:	74 47                	je     8028c0 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80287d:	48 c1 e8 0c          	shr    $0xc,%rax
  802881:	89 c2                	mov    %eax,%edx
  802883:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802886:	89 d6                	mov    %edx,%esi
  802888:	89 c7                	mov    %eax,%edi
  80288a:	48 b8 cf 24 80 00 00 	movabs $0x8024cf,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
  802896:	eb 28                	jmp    8028c0 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802898:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80289f:	00 
  8028a0:	eb 1e                	jmp    8028c0 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8028a2:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8028a9:	40 
  8028aa:	eb 14                	jmp    8028c0 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8028ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b0:	48 c1 e8 27          	shr    $0x27,%rax
  8028b4:	48 83 c0 01          	add    $0x1,%rax
  8028b8:	48 c1 e0 27          	shl    $0x27,%rax
  8028bc:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8028c0:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8028c7:	00 
  8028c8:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8028cf:	00 
  8028d0:	0f 87 13 ff ff ff    	ja     8027e9 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028d9:	ba 07 00 00 00       	mov    $0x7,%edx
  8028de:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8028e3:	89 c7                	mov    %eax,%edi
  8028e5:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8028f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028f4:	ba 07 00 00 00       	mov    $0x7,%edx
  8028f9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8028fe:	89 c7                	mov    %eax,%edi
  802900:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80290c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80290f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802915:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80291a:	ba 00 00 00 00       	mov    $0x0,%edx
  80291f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802924:	89 c7                	mov    %eax,%edi
  802926:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  80292d:	00 00 00 
  802930:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802932:	ba 00 10 00 00       	mov    $0x1000,%edx
  802937:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80293c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802941:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80294d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802952:	bf 00 00 00 00       	mov    $0x0,%edi
  802957:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802963:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80296a:	00 00 00 
  80296d:	48 8b 00             	mov    (%rax),%rax
  802970:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802977:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80297a:	48 89 d6             	mov    %rdx,%rsi
  80297d:	89 c7                	mov    %eax,%edi
  80297f:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80298b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80298e:	be 02 00 00 00       	mov    $0x2,%esi
  802993:	89 c7                	mov    %eax,%edi
  802995:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	callq  *%rax

	return envid;
  8029a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8029a4:	c9                   	leaveq 
  8029a5:	c3                   	retq   

00000000008029a6 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8029aa:	48 ba e8 5e 80 00 00 	movabs $0x805ee8,%rdx
  8029b1:	00 00 00 
  8029b4:	be bf 00 00 00       	mov    $0xbf,%esi
  8029b9:	48 bf 2d 5e 80 00 00 	movabs $0x805e2d,%rdi
  8029c0:	00 00 00 
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c8:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  8029cf:	00 00 00 
  8029d2:	ff d1                	callq  *%rcx

00000000008029d4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029d4:	55                   	push   %rbp
  8029d5:	48 89 e5             	mov    %rsp,%rbp
  8029d8:	48 83 ec 08          	sub    $0x8,%rsp
  8029dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029e4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8029eb:	ff ff ff 
  8029ee:	48 01 d0             	add    %rdx,%rax
  8029f1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8029f5:	c9                   	leaveq 
  8029f6:	c3                   	retq   

00000000008029f7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 08          	sub    $0x8,%rsp
  8029ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a07:	48 89 c7             	mov    %rax,%rdi
  802a0a:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a1c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a20:	c9                   	leaveq 
  802a21:	c3                   	retq   

0000000000802a22 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a22:	55                   	push   %rbp
  802a23:	48 89 e5             	mov    %rsp,%rbp
  802a26:	48 83 ec 18          	sub    $0x18,%rsp
  802a2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a35:	eb 6b                	jmp    802aa2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	48 98                	cltq   
  802a3c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a42:	48 c1 e0 0c          	shl    $0xc,%rax
  802a46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	48 c1 e8 15          	shr    $0x15,%rax
  802a52:	48 89 c2             	mov    %rax,%rdx
  802a55:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a5c:	01 00 00 
  802a5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a63:	83 e0 01             	and    $0x1,%eax
  802a66:	48 85 c0             	test   %rax,%rax
  802a69:	74 21                	je     802a8c <fd_alloc+0x6a>
  802a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6f:	48 c1 e8 0c          	shr    $0xc,%rax
  802a73:	48 89 c2             	mov    %rax,%rdx
  802a76:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a7d:	01 00 00 
  802a80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a84:	83 e0 01             	and    $0x1,%eax
  802a87:	48 85 c0             	test   %rax,%rax
  802a8a:	75 12                	jne    802a9e <fd_alloc+0x7c>
			*fd_store = fd;
  802a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a94:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9c:	eb 1a                	jmp    802ab8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a9e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aa2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802aa6:	7e 8f                	jle    802a37 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802ab3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802ab8:	c9                   	leaveq 
  802ab9:	c3                   	retq   

0000000000802aba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802aba:	55                   	push   %rbp
  802abb:	48 89 e5             	mov    %rsp,%rbp
  802abe:	48 83 ec 20          	sub    $0x20,%rsp
  802ac2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802ac9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802acd:	78 06                	js     802ad5 <fd_lookup+0x1b>
  802acf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802ad3:	7e 07                	jle    802adc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ad5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ada:	eb 6c                	jmp    802b48 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802adc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802adf:	48 98                	cltq   
  802ae1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ae7:	48 c1 e0 0c          	shl    $0xc,%rax
  802aeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af3:	48 c1 e8 15          	shr    $0x15,%rax
  802af7:	48 89 c2             	mov    %rax,%rdx
  802afa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b01:	01 00 00 
  802b04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b08:	83 e0 01             	and    $0x1,%eax
  802b0b:	48 85 c0             	test   %rax,%rax
  802b0e:	74 21                	je     802b31 <fd_lookup+0x77>
  802b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b14:	48 c1 e8 0c          	shr    $0xc,%rax
  802b18:	48 89 c2             	mov    %rax,%rdx
  802b1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b22:	01 00 00 
  802b25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b29:	83 e0 01             	and    $0x1,%eax
  802b2c:	48 85 c0             	test   %rax,%rax
  802b2f:	75 07                	jne    802b38 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b36:	eb 10                	jmp    802b48 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b40:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 30          	sub    $0x30,%rsp
  802b52:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b56:	89 f0                	mov    %esi,%eax
  802b58:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b5f:	48 89 c7             	mov    %rax,%rdi
  802b62:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
  802b6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b72:	48 89 d6             	mov    %rdx,%rsi
  802b75:	89 c7                	mov    %eax,%edi
  802b77:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	78 0a                	js     802b96 <fd_close+0x4c>
	    || fd != fd2)
  802b8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b90:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b94:	74 12                	je     802ba8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b96:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b9a:	74 05                	je     802ba1 <fd_close+0x57>
  802b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9f:	eb 05                	jmp    802ba6 <fd_close+0x5c>
  802ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba6:	eb 69                	jmp    802c11 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802ba8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bac:	8b 00                	mov    (%rax),%eax
  802bae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bb2:	48 89 d6             	mov    %rdx,%rsi
  802bb5:	89 c7                	mov    %eax,%edi
  802bb7:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	callq  *%rax
  802bc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bca:	78 2a                	js     802bf6 <fd_close+0xac>
		if (dev->dev_close)
  802bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd0:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bd4:	48 85 c0             	test   %rax,%rax
  802bd7:	74 16                	je     802bef <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdd:	48 8b 40 20          	mov    0x20(%rax),%rax
  802be1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be5:	48 89 d7             	mov    %rdx,%rdi
  802be8:	ff d0                	callq  *%rax
  802bea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bed:	eb 07                	jmp    802bf6 <fd_close+0xac>
		else
			r = 0;
  802bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802bf6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bfa:	48 89 c6             	mov    %rax,%rsi
  802bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  802c02:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802c09:	00 00 00 
  802c0c:	ff d0                	callq  *%rax
	return r;
  802c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c11:	c9                   	leaveq 
  802c12:	c3                   	retq   

0000000000802c13 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c13:	55                   	push   %rbp
  802c14:	48 89 e5             	mov    %rsp,%rbp
  802c17:	48 83 ec 20          	sub    $0x20,%rsp
  802c1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c29:	eb 41                	jmp    802c6c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c2b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c32:	00 00 00 
  802c35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c38:	48 63 d2             	movslq %edx,%rdx
  802c3b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c3f:	8b 00                	mov    (%rax),%eax
  802c41:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c44:	75 22                	jne    802c68 <dev_lookup+0x55>
			*dev = devtab[i];
  802c46:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c4d:	00 00 00 
  802c50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c53:	48 63 d2             	movslq %edx,%rdx
  802c56:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
  802c66:	eb 60                	jmp    802cc8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c68:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c6c:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c73:	00 00 00 
  802c76:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c79:	48 63 d2             	movslq %edx,%rdx
  802c7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c80:	48 85 c0             	test   %rax,%rax
  802c83:	75 a6                	jne    802c2b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c85:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802c8c:	00 00 00 
  802c8f:	48 8b 00             	mov    (%rax),%rax
  802c92:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c98:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c9b:	89 c6                	mov    %eax,%esi
  802c9d:	48 bf 00 5f 80 00 00 	movabs $0x805f00,%rdi
  802ca4:	00 00 00 
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cac:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802cb3:	00 00 00 
  802cb6:	ff d1                	callq  *%rcx
	*dev = 0;
  802cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802cc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802cc8:	c9                   	leaveq 
  802cc9:	c3                   	retq   

0000000000802cca <close>:

int
close(int fdnum)
{
  802cca:	55                   	push   %rbp
  802ccb:	48 89 e5             	mov    %rsp,%rbp
  802cce:	48 83 ec 20          	sub    $0x20,%rsp
  802cd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdc:	48 89 d6             	mov    %rdx,%rsi
  802cdf:	89 c7                	mov    %eax,%edi
  802ce1:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
  802ced:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf4:	79 05                	jns    802cfb <close+0x31>
		return r;
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf9:	eb 18                	jmp    802d13 <close+0x49>
	else
		return fd_close(fd, 1);
  802cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cff:	be 01 00 00 00       	mov    $0x1,%esi
  802d04:	48 89 c7             	mov    %rax,%rdi
  802d07:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
}
  802d13:	c9                   	leaveq 
  802d14:	c3                   	retq   

0000000000802d15 <close_all>:

void
close_all(void)
{
  802d15:	55                   	push   %rbp
  802d16:	48 89 e5             	mov    %rsp,%rbp
  802d19:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d24:	eb 15                	jmp    802d3b <close_all+0x26>
		close(i);
  802d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d29:	89 c7                	mov    %eax,%edi
  802d2b:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d3b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d3f:	7e e5                	jle    802d26 <close_all+0x11>
		close(i);
}
  802d41:	c9                   	leaveq 
  802d42:	c3                   	retq   

0000000000802d43 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d43:	55                   	push   %rbp
  802d44:	48 89 e5             	mov    %rsp,%rbp
  802d47:	48 83 ec 40          	sub    $0x40,%rsp
  802d4b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d4e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d51:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d55:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d58:	48 89 d6             	mov    %rdx,%rsi
  802d5b:	89 c7                	mov    %eax,%edi
  802d5d:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  802d64:	00 00 00 
  802d67:	ff d0                	callq  *%rax
  802d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d70:	79 08                	jns    802d7a <dup+0x37>
		return r;
  802d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d75:	e9 70 01 00 00       	jmpq   802eea <dup+0x1a7>
	close(newfdnum);
  802d7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d7d:	89 c7                	mov    %eax,%edi
  802d7f:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d8b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d8e:	48 98                	cltq   
  802d90:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d96:	48 c1 e0 0c          	shl    $0xc,%rax
  802d9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da2:	48 89 c7             	mov    %rax,%rdi
  802da5:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
  802db1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db9:	48 89 c7             	mov    %rax,%rdi
  802dbc:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	callq  *%rax
  802dc8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd0:	48 c1 e8 15          	shr    $0x15,%rax
  802dd4:	48 89 c2             	mov    %rax,%rdx
  802dd7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802dde:	01 00 00 
  802de1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802de5:	83 e0 01             	and    $0x1,%eax
  802de8:	48 85 c0             	test   %rax,%rax
  802deb:	74 73                	je     802e60 <dup+0x11d>
  802ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df1:	48 c1 e8 0c          	shr    $0xc,%rax
  802df5:	48 89 c2             	mov    %rax,%rdx
  802df8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dff:	01 00 00 
  802e02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e06:	83 e0 01             	and    $0x1,%eax
  802e09:	48 85 c0             	test   %rax,%rax
  802e0c:	74 52                	je     802e60 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e12:	48 c1 e8 0c          	shr    $0xc,%rax
  802e16:	48 89 c2             	mov    %rax,%rdx
  802e19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e20:	01 00 00 
  802e23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e27:	25 07 0e 00 00       	and    $0xe07,%eax
  802e2c:	89 c1                	mov    %eax,%ecx
  802e2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e36:	41 89 c8             	mov    %ecx,%r8d
  802e39:	48 89 d1             	mov    %rdx,%rcx
  802e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e41:	48 89 c6             	mov    %rax,%rsi
  802e44:	bf 00 00 00 00       	mov    $0x0,%edi
  802e49:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
  802e55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5c:	79 02                	jns    802e60 <dup+0x11d>
			goto err;
  802e5e:	eb 57                	jmp    802eb7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e64:	48 c1 e8 0c          	shr    $0xc,%rax
  802e68:	48 89 c2             	mov    %rax,%rdx
  802e6b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e72:	01 00 00 
  802e75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e79:	25 07 0e 00 00       	and    $0xe07,%eax
  802e7e:	89 c1                	mov    %eax,%ecx
  802e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e88:	41 89 c8             	mov    %ecx,%r8d
  802e8b:	48 89 d1             	mov    %rdx,%rcx
  802e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e93:	48 89 c6             	mov    %rax,%rsi
  802e96:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9b:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
  802ea7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eae:	79 02                	jns    802eb2 <dup+0x16f>
		goto err;
  802eb0:	eb 05                	jmp    802eb7 <dup+0x174>

	return newfdnum;
  802eb2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eb5:	eb 33                	jmp    802eea <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebb:	48 89 c6             	mov    %rax,%rsi
  802ebe:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec3:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ecf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed3:	48 89 c6             	mov    %rax,%rsi
  802ed6:	bf 00 00 00 00       	mov    $0x0,%edi
  802edb:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
	return r;
  802ee7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802eea:	c9                   	leaveq 
  802eeb:	c3                   	retq   

0000000000802eec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802eec:	55                   	push   %rbp
  802eed:	48 89 e5             	mov    %rsp,%rbp
  802ef0:	48 83 ec 40          	sub    $0x40,%rsp
  802ef4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802efb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802eff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f06:	48 89 d6             	mov    %rdx,%rsi
  802f09:	89 c7                	mov    %eax,%edi
  802f0b:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	callq  *%rax
  802f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1e:	78 24                	js     802f44 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f24:	8b 00                	mov    (%rax),%eax
  802f26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f2a:	48 89 d6             	mov    %rdx,%rsi
  802f2d:	89 c7                	mov    %eax,%edi
  802f2f:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  802f36:	00 00 00 
  802f39:	ff d0                	callq  *%rax
  802f3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f42:	79 05                	jns    802f49 <read+0x5d>
		return r;
  802f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f47:	eb 76                	jmp    802fbf <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4d:	8b 40 08             	mov    0x8(%rax),%eax
  802f50:	83 e0 03             	and    $0x3,%eax
  802f53:	83 f8 01             	cmp    $0x1,%eax
  802f56:	75 3a                	jne    802f92 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f58:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  802f5f:	00 00 00 
  802f62:	48 8b 00             	mov    (%rax),%rax
  802f65:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f6b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f6e:	89 c6                	mov    %eax,%esi
  802f70:	48 bf 1f 5f 80 00 00 	movabs $0x805f1f,%rdi
  802f77:	00 00 00 
  802f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7f:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  802f86:	00 00 00 
  802f89:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f90:	eb 2d                	jmp    802fbf <read+0xd3>
	}
	if (!dev->dev_read)
  802f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f96:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f9a:	48 85 c0             	test   %rax,%rax
  802f9d:	75 07                	jne    802fa6 <read+0xba>
		return -E_NOT_SUPP;
  802f9f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fa4:	eb 19                	jmp    802fbf <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802faa:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fb2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fba:	48 89 cf             	mov    %rcx,%rdi
  802fbd:	ff d0                	callq  *%rax
}
  802fbf:	c9                   	leaveq 
  802fc0:	c3                   	retq   

0000000000802fc1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802fc1:	55                   	push   %rbp
  802fc2:	48 89 e5             	mov    %rsp,%rbp
  802fc5:	48 83 ec 30          	sub    $0x30,%rsp
  802fc9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fdb:	eb 49                	jmp    803026 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe0:	48 98                	cltq   
  802fe2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fe6:	48 29 c2             	sub    %rax,%rdx
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	48 63 c8             	movslq %eax,%rcx
  802fef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff3:	48 01 c1             	add    %rax,%rcx
  802ff6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff9:	48 89 ce             	mov    %rcx,%rsi
  802ffc:	89 c7                	mov    %eax,%edi
  802ffe:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80300d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803011:	79 05                	jns    803018 <readn+0x57>
			return m;
  803013:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803016:	eb 1c                	jmp    803034 <readn+0x73>
		if (m == 0)
  803018:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80301c:	75 02                	jne    803020 <readn+0x5f>
			break;
  80301e:	eb 11                	jmp    803031 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803020:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803023:	01 45 fc             	add    %eax,-0x4(%rbp)
  803026:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803029:	48 98                	cltq   
  80302b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80302f:	72 ac                	jb     802fdd <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803031:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803034:	c9                   	leaveq 
  803035:	c3                   	retq   

0000000000803036 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803036:	55                   	push   %rbp
  803037:	48 89 e5             	mov    %rsp,%rbp
  80303a:	48 83 ec 40          	sub    $0x40,%rsp
  80303e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803041:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803045:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803049:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80304d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	89 c7                	mov    %eax,%edi
  803055:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803064:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803068:	78 24                	js     80308e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80306a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306e:	8b 00                	mov    (%rax),%eax
  803070:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803074:	48 89 d6             	mov    %rdx,%rsi
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308c:	79 05                	jns    803093 <write+0x5d>
		return r;
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	eb 75                	jmp    803108 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803097:	8b 40 08             	mov    0x8(%rax),%eax
  80309a:	83 e0 03             	and    $0x3,%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	75 3a                	jne    8030db <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030a1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8030a8:	00 00 00 
  8030ab:	48 8b 00             	mov    (%rax),%rax
  8030ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030b7:	89 c6                	mov    %eax,%esi
  8030b9:	48 bf 3b 5f 80 00 00 	movabs $0x805f3b,%rdi
  8030c0:	00 00 00 
  8030c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c8:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  8030cf:	00 00 00 
  8030d2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030d9:	eb 2d                	jmp    803108 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8030db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030df:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030e3:	48 85 c0             	test   %rax,%rax
  8030e6:	75 07                	jne    8030ef <write+0xb9>
		return -E_NOT_SUPP;
  8030e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030ed:	eb 19                	jmp    803108 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8030ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030f7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030ff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803103:	48 89 cf             	mov    %rcx,%rdi
  803106:	ff d0                	callq  *%rax
}
  803108:	c9                   	leaveq 
  803109:	c3                   	retq   

000000000080310a <seek>:

int
seek(int fdnum, off_t offset)
{
  80310a:	55                   	push   %rbp
  80310b:	48 89 e5             	mov    %rsp,%rbp
  80310e:	48 83 ec 18          	sub    $0x18,%rsp
  803112:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803115:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803118:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80311c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80311f:	48 89 d6             	mov    %rdx,%rsi
  803122:	89 c7                	mov    %eax,%edi
  803124:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
  803130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803137:	79 05                	jns    80313e <seek+0x34>
		return r;
  803139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313c:	eb 0f                	jmp    80314d <seek+0x43>
	fd->fd_offset = offset;
  80313e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803142:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80314d:	c9                   	leaveq 
  80314e:	c3                   	retq   

000000000080314f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	48 83 ec 30          	sub    $0x30,%rsp
  803157:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80315a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80315d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803161:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803164:	48 89 d6             	mov    %rdx,%rsi
  803167:	89 c7                	mov    %eax,%edi
  803169:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  803170:	00 00 00 
  803173:	ff d0                	callq  *%rax
  803175:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803178:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317c:	78 24                	js     8031a2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80317e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803182:	8b 00                	mov    (%rax),%eax
  803184:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803188:	48 89 d6             	mov    %rdx,%rsi
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a0:	79 05                	jns    8031a7 <ftruncate+0x58>
		return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a5:	eb 72                	jmp    803219 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ab:	8b 40 08             	mov    0x8(%rax),%eax
  8031ae:	83 e0 03             	and    $0x3,%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	75 3a                	jne    8031ef <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8031b5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8031bc:	00 00 00 
  8031bf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8031c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031cb:	89 c6                	mov    %eax,%esi
  8031cd:	48 bf 58 5f 80 00 00 	movabs $0x805f58,%rdi
  8031d4:	00 00 00 
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031dc:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  8031e3:	00 00 00 
  8031e6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8031e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031ed:	eb 2a                	jmp    803219 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8031ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031f7:	48 85 c0             	test   %rax,%rax
  8031fa:	75 07                	jne    803203 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8031fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803201:	eb 16                	jmp    803219 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803207:	48 8b 40 30          	mov    0x30(%rax),%rax
  80320b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80320f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803212:	89 ce                	mov    %ecx,%esi
  803214:	48 89 d7             	mov    %rdx,%rdi
  803217:	ff d0                	callq  *%rax
}
  803219:	c9                   	leaveq 
  80321a:	c3                   	retq   

000000000080321b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80321b:	55                   	push   %rbp
  80321c:	48 89 e5             	mov    %rsp,%rbp
  80321f:	48 83 ec 30          	sub    $0x30,%rsp
  803223:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803226:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80322a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80322e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803231:	48 89 d6             	mov    %rdx,%rsi
  803234:	89 c7                	mov    %eax,%edi
  803236:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803245:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803249:	78 24                	js     80326f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80324b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324f:	8b 00                	mov    (%rax),%eax
  803251:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803255:	48 89 d6             	mov    %rdx,%rsi
  803258:	89 c7                	mov    %eax,%edi
  80325a:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326d:	79 05                	jns    803274 <fstat+0x59>
		return r;
  80326f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803272:	eb 5e                	jmp    8032d2 <fstat+0xb7>
	if (!dev->dev_stat)
  803274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803278:	48 8b 40 28          	mov    0x28(%rax),%rax
  80327c:	48 85 c0             	test   %rax,%rax
  80327f:	75 07                	jne    803288 <fstat+0x6d>
		return -E_NOT_SUPP;
  803281:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803286:	eb 4a                	jmp    8032d2 <fstat+0xb7>
	stat->st_name[0] = 0;
  803288:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80328f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803293:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80329a:	00 00 00 
	stat->st_isdir = 0;
  80329d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032a8:	00 00 00 
	stat->st_dev = dev;
  8032ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8032ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032be:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032ca:	48 89 ce             	mov    %rcx,%rsi
  8032cd:	48 89 d7             	mov    %rdx,%rdi
  8032d0:	ff d0                	callq  *%rax
}
  8032d2:	c9                   	leaveq 
  8032d3:	c3                   	retq   

00000000008032d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032d4:	55                   	push   %rbp
  8032d5:	48 89 e5             	mov    %rsp,%rbp
  8032d8:	48 83 ec 20          	sub    $0x20,%rsp
  8032dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e8:	be 00 00 00 00       	mov    $0x0,%esi
  8032ed:	48 89 c7             	mov    %rax,%rdi
  8032f0:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
  8032fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803303:	79 05                	jns    80330a <stat+0x36>
		return fd;
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	eb 2f                	jmp    803339 <stat+0x65>
	r = fstat(fd, stat);
  80330a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80330e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803311:	48 89 d6             	mov    %rdx,%rsi
  803314:	89 c7                	mov    %eax,%edi
  803316:	48 b8 1b 32 80 00 00 	movabs $0x80321b,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803325:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803328:	89 c7                	mov    %eax,%edi
  80332a:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803331:	00 00 00 
  803334:	ff d0                	callq  *%rax
	return r;
  803336:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803339:	c9                   	leaveq 
  80333a:	c3                   	retq   

000000000080333b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80333b:	55                   	push   %rbp
  80333c:	48 89 e5             	mov    %rsp,%rbp
  80333f:	48 83 ec 10          	sub    $0x10,%rsp
  803343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80334a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803351:	00 00 00 
  803354:	8b 00                	mov    (%rax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	75 1d                	jne    803377 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80335a:	bf 01 00 00 00       	mov    $0x1,%edi
  80335f:	48 b8 46 56 80 00 00 	movabs $0x805646,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
  80336b:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803372:	00 00 00 
  803375:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803377:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80337e:	00 00 00 
  803381:	8b 00                	mov    (%rax),%eax
  803383:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803386:	b9 07 00 00 00       	mov    $0x7,%ecx
  80338b:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803392:	00 00 00 
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 e4 55 80 00 00 	movabs $0x8055e4,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ac:	48 89 c6             	mov    %rax,%rsi
  8033af:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b4:	48 b8 de 54 80 00 00 	movabs $0x8054de,%rax
  8033bb:	00 00 00 
  8033be:	ff d0                	callq  *%rax
}
  8033c0:	c9                   	leaveq 
  8033c1:	c3                   	retq   

00000000008033c2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8033c2:	55                   	push   %rbp
  8033c3:	48 89 e5             	mov    %rsp,%rbp
  8033c6:	48 83 ec 30          	sub    $0x30,%rsp
  8033ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033ce:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8033d1:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8033d8:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8033df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8033e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033eb:	75 08                	jne    8033f5 <open+0x33>
	{
		return r;
  8033ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f0:	e9 f2 00 00 00       	jmpq   8034e7 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8033f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80340b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803412:	7e 0a                	jle    80341e <open+0x5c>
	{
		return -E_BAD_PATH;
  803414:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803419:	e9 c9 00 00 00       	jmpq   8034e7 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80341e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803425:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803426:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80342a:	48 89 c7             	mov    %rax,%rdi
  80342d:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
  803439:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803440:	78 09                	js     80344b <open+0x89>
  803442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803446:	48 85 c0             	test   %rax,%rax
  803449:	75 08                	jne    803453 <open+0x91>
		{
			return r;
  80344b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344e:	e9 94 00 00 00       	jmpq   8034e7 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803457:	ba 00 04 00 00       	mov    $0x400,%edx
  80345c:	48 89 c6             	mov    %rax,%rsi
  80345f:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803466:	00 00 00 
  803469:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  803470:	00 00 00 
  803473:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803475:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347c:	00 00 00 
  80347f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803482:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348c:	48 89 c6             	mov    %rax,%rsi
  80348f:	bf 01 00 00 00       	mov    $0x1,%edi
  803494:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  80349b:	00 00 00 
  80349e:	ff d0                	callq  *%rax
  8034a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a7:	79 2b                	jns    8034d4 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8034a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ad:	be 00 00 00 00       	mov    $0x0,%esi
  8034b2:	48 89 c7             	mov    %rax,%rdi
  8034b5:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034c8:	79 05                	jns    8034cf <open+0x10d>
			{
				return d;
  8034ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034cd:	eb 18                	jmp    8034e7 <open+0x125>
			}
			return r;
  8034cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d2:	eb 13                	jmp    8034e7 <open+0x125>
		}	
		return fd2num(fd_store);
  8034d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d8:	48 89 c7             	mov    %rax,%rdi
  8034db:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  8034e2:	00 00 00 
  8034e5:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8034e7:	c9                   	leaveq 
  8034e8:	c3                   	retq   

00000000008034e9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034e9:	55                   	push   %rbp
  8034ea:	48 89 e5             	mov    %rsp,%rbp
  8034ed:	48 83 ec 10          	sub    $0x10,%rsp
  8034f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f9:	8b 50 0c             	mov    0xc(%rax),%edx
  8034fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803503:	00 00 00 
  803506:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803508:	be 00 00 00 00       	mov    $0x0,%esi
  80350d:	bf 06 00 00 00       	mov    $0x6,%edi
  803512:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
}
  80351e:	c9                   	leaveq 
  80351f:	c3                   	retq   

0000000000803520 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803520:	55                   	push   %rbp
  803521:	48 89 e5             	mov    %rsp,%rbp
  803524:	48 83 ec 30          	sub    $0x30,%rsp
  803528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80352c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80353b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803540:	74 07                	je     803549 <devfile_read+0x29>
  803542:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803547:	75 07                	jne    803550 <devfile_read+0x30>
		return -E_INVAL;
  803549:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80354e:	eb 77                	jmp    8035c7 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803554:	8b 50 0c             	mov    0xc(%rax),%edx
  803557:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355e:	00 00 00 
  803561:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803563:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356a:	00 00 00 
  80356d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803571:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803575:	be 00 00 00 00       	mov    $0x0,%esi
  80357a:	bf 03 00 00 00       	mov    $0x3,%edi
  80357f:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803592:	7f 05                	jg     803599 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803597:	eb 2e                	jmp    8035c7 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	48 63 d0             	movslq %eax,%rdx
  80359f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035aa:	00 00 00 
  8035ad:	48 89 c7             	mov    %rax,%rdi
  8035b0:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8035bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8035c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 30          	sub    $0x30,%rsp
  8035d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8035dd:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8035e4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035e9:	74 07                	je     8035f2 <devfile_write+0x29>
  8035eb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035f0:	75 08                	jne    8035fa <devfile_write+0x31>
		return r;
  8035f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f5:	e9 9a 00 00 00       	jmpq   803694 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8035fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fe:	8b 50 0c             	mov    0xc(%rax),%edx
  803601:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803608:	00 00 00 
  80360b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80360d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803614:	00 
  803615:	76 08                	jbe    80361f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803617:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80361e:	00 
	}
	fsipcbuf.write.req_n = n;
  80361f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803626:	00 00 00 
  803629:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80362d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803631:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803639:	48 89 c6             	mov    %rax,%rsi
  80363c:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803643:	00 00 00 
  803646:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803652:	be 00 00 00 00       	mov    $0x0,%esi
  803657:	bf 04 00 00 00       	mov    $0x4,%edi
  80365c:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
  803668:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366f:	7f 20                	jg     803691 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803671:	48 bf 7e 5f 80 00 00 	movabs $0x805f7e,%rdi
  803678:	00 00 00 
  80367b:	b8 00 00 00 00       	mov    $0x0,%eax
  803680:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803687:	00 00 00 
  80368a:	ff d2                	callq  *%rdx
		return r;
  80368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368f:	eb 03                	jmp    803694 <devfile_write+0xcb>
	}
	return r;
  803691:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 20          	sub    $0x20,%rsp
  80369e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8036ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b4:	00 00 00 
  8036b7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036b9:	be 00 00 00 00       	mov    $0x0,%esi
  8036be:	bf 05 00 00 00       	mov    $0x5,%edi
  8036c3:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
  8036cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d6:	79 05                	jns    8036dd <devfile_stat+0x47>
		return r;
  8036d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036db:	eb 56                	jmp    803733 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e1:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8036e8:	00 00 00 
  8036eb:	48 89 c7             	mov    %rax,%rdi
  8036ee:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803701:	00 00 00 
  803704:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80370a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803714:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371b:	00 00 00 
  80371e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803724:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803728:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80372e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803733:	c9                   	leaveq 
  803734:	c3                   	retq   

0000000000803735 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803735:	55                   	push   %rbp
  803736:	48 89 e5             	mov    %rsp,%rbp
  803739:	48 83 ec 10          	sub    $0x10,%rsp
  80373d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803741:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803748:	8b 50 0c             	mov    0xc(%rax),%edx
  80374b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803752:	00 00 00 
  803755:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803757:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80375e:	00 00 00 
  803761:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803764:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803767:	be 00 00 00 00       	mov    $0x0,%esi
  80376c:	bf 02 00 00 00       	mov    $0x2,%edi
  803771:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
}
  80377d:	c9                   	leaveq 
  80377e:	c3                   	retq   

000000000080377f <remove>:

// Delete a file
int
remove(const char *path)
{
  80377f:	55                   	push   %rbp
  803780:	48 89 e5             	mov    %rsp,%rbp
  803783:	48 83 ec 10          	sub    $0x10,%rsp
  803787:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80378b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378f:	48 89 c7             	mov    %rax,%rdi
  803792:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803799:	00 00 00 
  80379c:	ff d0                	callq  *%rax
  80379e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037a3:	7e 07                	jle    8037ac <remove+0x2d>
		return -E_BAD_PATH;
  8037a5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037aa:	eb 33                	jmp    8037df <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b0:	48 89 c6             	mov    %rax,%rsi
  8037b3:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8037ba:	00 00 00 
  8037bd:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8037c9:	be 00 00 00 00       	mov    $0x0,%esi
  8037ce:	bf 07 00 00 00       	mov    $0x7,%edi
  8037d3:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
}
  8037df:	c9                   	leaveq 
  8037e0:	c3                   	retq   

00000000008037e1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037e5:	be 00 00 00 00       	mov    $0x0,%esi
  8037ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8037ef:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  8037f6:	00 00 00 
  8037f9:	ff d0                	callq  *%rax
}
  8037fb:	5d                   	pop    %rbp
  8037fc:	c3                   	retq   

00000000008037fd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037fd:	55                   	push   %rbp
  8037fe:	48 89 e5             	mov    %rsp,%rbp
  803801:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803808:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80380f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803816:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80381d:	be 00 00 00 00       	mov    $0x0,%esi
  803822:	48 89 c7             	mov    %rax,%rdi
  803825:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  80382c:	00 00 00 
  80382f:	ff d0                	callq  *%rax
  803831:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803834:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803838:	79 28                	jns    803862 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80383a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383d:	89 c6                	mov    %eax,%esi
  80383f:	48 bf 9a 5f 80 00 00 	movabs $0x805f9a,%rdi
  803846:	00 00 00 
  803849:	b8 00 00 00 00       	mov    $0x0,%eax
  80384e:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803855:	00 00 00 
  803858:	ff d2                	callq  *%rdx
		return fd_src;
  80385a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385d:	e9 74 01 00 00       	jmpq   8039d6 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803862:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803869:	be 01 01 00 00       	mov    $0x101,%esi
  80386e:	48 89 c7             	mov    %rax,%rdi
  803871:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803880:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803884:	79 39                	jns    8038bf <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803886:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803889:	89 c6                	mov    %eax,%esi
  80388b:	48 bf b0 5f 80 00 00 	movabs $0x805fb0,%rdi
  803892:	00 00 00 
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  8038a1:	00 00 00 
  8038a4:	ff d2                	callq  *%rdx
		close(fd_src);
  8038a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a9:	89 c7                	mov    %eax,%edi
  8038ab:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
		return fd_dest;
  8038b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ba:	e9 17 01 00 00       	jmpq   8039d6 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8038bf:	eb 74                	jmp    803935 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8038c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038c4:	48 63 d0             	movslq %eax,%rdx
  8038c7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038d1:	48 89 ce             	mov    %rcx,%rsi
  8038d4:	89 c7                	mov    %eax,%edi
  8038d6:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  8038dd:	00 00 00 
  8038e0:	ff d0                	callq  *%rax
  8038e2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038e9:	79 4a                	jns    803935 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038eb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038ee:	89 c6                	mov    %eax,%esi
  8038f0:	48 bf ca 5f 80 00 00 	movabs $0x805fca,%rdi
  8038f7:	00 00 00 
  8038fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ff:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803906:	00 00 00 
  803909:	ff d2                	callq  *%rdx
			close(fd_src);
  80390b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80390e:	89 c7                	mov    %eax,%edi
  803910:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
			close(fd_dest);
  80391c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80391f:	89 c7                	mov    %eax,%edi
  803921:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803928:	00 00 00 
  80392b:	ff d0                	callq  *%rax
			return write_size;
  80392d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803930:	e9 a1 00 00 00       	jmpq   8039d6 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803935:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393f:	ba 00 02 00 00       	mov    $0x200,%edx
  803944:	48 89 ce             	mov    %rcx,%rsi
  803947:	89 c7                	mov    %eax,%edi
  803949:	48 b8 ec 2e 80 00 00 	movabs $0x802eec,%rax
  803950:	00 00 00 
  803953:	ff d0                	callq  *%rax
  803955:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803958:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80395c:	0f 8f 5f ff ff ff    	jg     8038c1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803962:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803966:	79 47                	jns    8039af <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803968:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80396b:	89 c6                	mov    %eax,%esi
  80396d:	48 bf dd 5f 80 00 00 	movabs $0x805fdd,%rdi
  803974:	00 00 00 
  803977:	b8 00 00 00 00       	mov    $0x0,%eax
  80397c:	48 ba 1d 0b 80 00 00 	movabs $0x800b1d,%rdx
  803983:	00 00 00 
  803986:	ff d2                	callq  *%rdx
		close(fd_src);
  803988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398b:	89 c7                	mov    %eax,%edi
  80398d:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
		close(fd_dest);
  803999:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399c:	89 c7                	mov    %eax,%edi
  80399e:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
		return read_size;
  8039aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039ad:	eb 27                	jmp    8039d6 <copy+0x1d9>
	}
	close(fd_src);
  8039af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b2:	89 c7                	mov    %eax,%edi
  8039b4:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
	close(fd_dest);
  8039c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c3:	89 c7                	mov    %eax,%edi
  8039c5:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
	return 0;
  8039d1:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8039d6:	c9                   	leaveq 
  8039d7:	c3                   	retq   

00000000008039d8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8039d8:	55                   	push   %rbp
  8039d9:	48 89 e5             	mov    %rsp,%rbp
  8039dc:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8039e3:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8039ea:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8039f1:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8039f8:	be 00 00 00 00       	mov    $0x0,%esi
  8039fd:	48 89 c7             	mov    %rax,%rdi
  803a00:	48 b8 c2 33 80 00 00 	movabs $0x8033c2,%rax
  803a07:	00 00 00 
  803a0a:	ff d0                	callq  *%rax
  803a0c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a13:	79 08                	jns    803a1d <spawn+0x45>
		return r;
  803a15:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a18:	e9 14 03 00 00       	jmpq   803d31 <spawn+0x359>
	fd = r;
  803a1d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a20:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803a23:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803a2a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803a2e:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803a35:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a38:	ba 00 02 00 00       	mov    $0x200,%edx
  803a3d:	48 89 ce             	mov    %rcx,%rsi
  803a40:	89 c7                	mov    %eax,%edi
  803a42:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	3d 00 02 00 00       	cmp    $0x200,%eax
  803a53:	75 0d                	jne    803a62 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a59:	8b 00                	mov    (%rax),%eax
  803a5b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803a60:	74 43                	je     803aa5 <spawn+0xcd>
		close(fd);
  803a62:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a65:	89 c7                	mov    %eax,%edi
  803a67:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803a73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a77:	8b 00                	mov    (%rax),%eax
  803a79:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803a7e:	89 c6                	mov    %eax,%esi
  803a80:	48 bf f8 5f 80 00 00 	movabs $0x805ff8,%rdi
  803a87:	00 00 00 
  803a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8f:	48 b9 1d 0b 80 00 00 	movabs $0x800b1d,%rcx
  803a96:	00 00 00 
  803a99:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803a9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803aa0:	e9 8c 02 00 00       	jmpq   803d31 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803aa5:	b8 07 00 00 00       	mov    $0x7,%eax
  803aaa:	cd 30                	int    $0x30
  803aac:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803aaf:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803ab2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ab5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ab9:	79 08                	jns    803ac3 <spawn+0xeb>
		return r;
  803abb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803abe:	e9 6e 02 00 00       	jmpq   803d31 <spawn+0x359>
	child = r;
  803ac3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ac6:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803ac9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803acc:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ad1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ad8:	00 00 00 
  803adb:	48 63 d0             	movslq %eax,%rdx
  803ade:	48 89 d0             	mov    %rdx,%rax
  803ae1:	48 c1 e0 03          	shl    $0x3,%rax
  803ae5:	48 01 d0             	add    %rdx,%rax
  803ae8:	48 c1 e0 05          	shl    $0x5,%rax
  803aec:	48 01 c8             	add    %rcx,%rax
  803aef:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803af6:	48 89 c6             	mov    %rax,%rsi
  803af9:	b8 18 00 00 00       	mov    $0x18,%eax
  803afe:	48 89 d7             	mov    %rdx,%rdi
  803b01:	48 89 c1             	mov    %rax,%rcx
  803b04:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803b07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0b:	48 8b 40 18          	mov    0x18(%rax),%rax
  803b0f:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803b16:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803b1d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803b24:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803b2b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b2e:	48 89 ce             	mov    %rcx,%rsi
  803b31:	89 c7                	mov    %eax,%edi
  803b33:	48 b8 9b 3f 80 00 00 	movabs $0x803f9b,%rax
  803b3a:	00 00 00 
  803b3d:	ff d0                	callq  *%rax
  803b3f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b42:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b46:	79 08                	jns    803b50 <spawn+0x178>
		return r;
  803b48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b4b:	e9 e1 01 00 00       	jmpq   803d31 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803b50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b54:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b58:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803b5f:	48 01 d0             	add    %rdx,%rax
  803b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b6d:	e9 a3 00 00 00       	jmpq   803c15 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	8b 00                	mov    (%rax),%eax
  803b78:	83 f8 01             	cmp    $0x1,%eax
  803b7b:	74 05                	je     803b82 <spawn+0x1aa>
			continue;
  803b7d:	e9 8a 00 00 00       	jmpq   803c0c <spawn+0x234>
		perm = PTE_P | PTE_U;
  803b82:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8d:	8b 40 04             	mov    0x4(%rax),%eax
  803b90:	83 e0 02             	and    $0x2,%eax
  803b93:	85 c0                	test   %eax,%eax
  803b95:	74 04                	je     803b9b <spawn+0x1c3>
			perm |= PTE_W;
  803b97:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803ba3:	41 89 c1             	mov    %eax,%r9d
  803ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803baa:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb2:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bba:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803bbe:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803bc1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803bc4:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803bc7:	89 3c 24             	mov    %edi,(%rsp)
  803bca:	89 c7                	mov    %eax,%edi
  803bcc:	48 b8 44 42 80 00 00 	movabs $0x804244,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax
  803bd8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803bdb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803bdf:	79 2b                	jns    803c0c <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803be1:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803be2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803be5:	89 c7                	mov    %eax,%edi
  803be7:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  803bee:	00 00 00 
  803bf1:	ff d0                	callq  *%rax
	close(fd);
  803bf3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bf6:	89 c7                	mov    %eax,%edi
  803bf8:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803bff:	00 00 00 
  803c02:	ff d0                	callq  *%rax
	return r;
  803c04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c07:	e9 25 01 00 00       	jmpq   803d31 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803c0c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c10:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803c15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c19:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803c1d:	0f b7 c0             	movzwl %ax,%eax
  803c20:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803c23:	0f 8f 49 ff ff ff    	jg     803b72 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803c29:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c2c:	89 c7                	mov    %eax,%edi
  803c2e:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803c35:	00 00 00 
  803c38:	ff d0                	callq  *%rax
	fd = -1;
  803c3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803c41:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c44:	89 c7                	mov    %eax,%edi
  803c46:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803c55:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803c59:	79 30                	jns    803c8b <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803c5b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c5e:	89 c1                	mov    %eax,%ecx
  803c60:	48 ba 12 60 80 00 00 	movabs $0x806012,%rdx
  803c67:	00 00 00 
  803c6a:	be 82 00 00 00       	mov    $0x82,%esi
  803c6f:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803c76:	00 00 00 
  803c79:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7e:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803c85:	00 00 00 
  803c88:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803c8b:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803c92:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803c95:	48 89 d6             	mov    %rdx,%rsi
  803c98:	89 c7                	mov    %eax,%edi
  803c9a:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
  803ca6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803ca9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803cad:	79 30                	jns    803cdf <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803caf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cb2:	89 c1                	mov    %eax,%ecx
  803cb4:	48 ba 34 60 80 00 00 	movabs $0x806034,%rdx
  803cbb:	00 00 00 
  803cbe:	be 85 00 00 00       	mov    $0x85,%esi
  803cc3:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803cca:	00 00 00 
  803ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd2:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803cd9:	00 00 00 
  803cdc:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803cdf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803ce2:	be 02 00 00 00       	mov    $0x2,%esi
  803ce7:	89 c7                	mov    %eax,%edi
  803ce9:	48 b8 f6 20 80 00 00 	movabs $0x8020f6,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803cf8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803cfc:	79 30                	jns    803d2e <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803cfe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d01:	89 c1                	mov    %eax,%ecx
  803d03:	48 ba 4e 60 80 00 00 	movabs $0x80604e,%rdx
  803d0a:	00 00 00 
  803d0d:	be 88 00 00 00       	mov    $0x88,%esi
  803d12:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  803d19:	00 00 00 
  803d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d21:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  803d28:	00 00 00 
  803d2b:	41 ff d0             	callq  *%r8

	return child;
  803d2e:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803d31:	c9                   	leaveq 
  803d32:	c3                   	retq   

0000000000803d33 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803d33:	55                   	push   %rbp
  803d34:	48 89 e5             	mov    %rsp,%rbp
  803d37:	41 55                	push   %r13
  803d39:	41 54                	push   %r12
  803d3b:	53                   	push   %rbx
  803d3c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d43:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803d4a:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803d51:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803d58:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803d5f:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803d66:	84 c0                	test   %al,%al
  803d68:	74 26                	je     803d90 <spawnl+0x5d>
  803d6a:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803d71:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803d78:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803d7c:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803d80:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803d84:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803d88:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803d8c:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803d90:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803d97:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803d9e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803da1:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803da8:	00 00 00 
  803dab:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803db2:	00 00 00 
  803db5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803db9:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803dc0:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803dc7:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803dce:	eb 07                	jmp    803dd7 <spawnl+0xa4>
		argc++;
  803dd0:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803dd7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803ddd:	83 f8 30             	cmp    $0x30,%eax
  803de0:	73 23                	jae    803e05 <spawnl+0xd2>
  803de2:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803de9:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803def:	89 c0                	mov    %eax,%eax
  803df1:	48 01 d0             	add    %rdx,%rax
  803df4:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803dfa:	83 c2 08             	add    $0x8,%edx
  803dfd:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803e03:	eb 15                	jmp    803e1a <spawnl+0xe7>
  803e05:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803e0c:	48 89 d0             	mov    %rdx,%rax
  803e0f:	48 83 c2 08          	add    $0x8,%rdx
  803e13:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e1a:	48 8b 00             	mov    (%rax),%rax
  803e1d:	48 85 c0             	test   %rax,%rax
  803e20:	75 ae                	jne    803dd0 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803e22:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e28:	83 c0 02             	add    $0x2,%eax
  803e2b:	48 89 e2             	mov    %rsp,%rdx
  803e2e:	48 89 d3             	mov    %rdx,%rbx
  803e31:	48 63 d0             	movslq %eax,%rdx
  803e34:	48 83 ea 01          	sub    $0x1,%rdx
  803e38:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803e3f:	48 63 d0             	movslq %eax,%rdx
  803e42:	49 89 d4             	mov    %rdx,%r12
  803e45:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803e4b:	48 63 d0             	movslq %eax,%rdx
  803e4e:	49 89 d2             	mov    %rdx,%r10
  803e51:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803e57:	48 98                	cltq   
  803e59:	48 c1 e0 03          	shl    $0x3,%rax
  803e5d:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803e61:	b8 10 00 00 00       	mov    $0x10,%eax
  803e66:	48 83 e8 01          	sub    $0x1,%rax
  803e6a:	48 01 d0             	add    %rdx,%rax
  803e6d:	bf 10 00 00 00       	mov    $0x10,%edi
  803e72:	ba 00 00 00 00       	mov    $0x0,%edx
  803e77:	48 f7 f7             	div    %rdi
  803e7a:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803e7e:	48 29 c4             	sub    %rax,%rsp
  803e81:	48 89 e0             	mov    %rsp,%rax
  803e84:	48 83 c0 07          	add    $0x7,%rax
  803e88:	48 c1 e8 03          	shr    $0x3,%rax
  803e8c:	48 c1 e0 03          	shl    $0x3,%rax
  803e90:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803e97:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803e9e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803ea5:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803ea8:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803eae:	8d 50 01             	lea    0x1(%rax),%edx
  803eb1:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803eb8:	48 63 d2             	movslq %edx,%rdx
  803ebb:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803ec2:	00 

	va_start(vl, arg0);
  803ec3:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803eca:	00 00 00 
  803ecd:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ed4:	00 00 00 
  803ed7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803edb:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803ee2:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803ee9:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803ef0:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803ef7:	00 00 00 
  803efa:	eb 63                	jmp    803f5f <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803efc:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803f02:	8d 70 01             	lea    0x1(%rax),%esi
  803f05:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f0b:	83 f8 30             	cmp    $0x30,%eax
  803f0e:	73 23                	jae    803f33 <spawnl+0x200>
  803f10:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803f17:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803f1d:	89 c0                	mov    %eax,%eax
  803f1f:	48 01 d0             	add    %rdx,%rax
  803f22:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803f28:	83 c2 08             	add    $0x8,%edx
  803f2b:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803f31:	eb 15                	jmp    803f48 <spawnl+0x215>
  803f33:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803f3a:	48 89 d0             	mov    %rdx,%rax
  803f3d:	48 83 c2 08          	add    $0x8,%rdx
  803f41:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803f48:	48 8b 08             	mov    (%rax),%rcx
  803f4b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f52:	89 f2                	mov    %esi,%edx
  803f54:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803f58:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803f5f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803f65:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803f6b:	77 8f                	ja     803efc <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803f6d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803f74:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803f7b:	48 89 d6             	mov    %rdx,%rsi
  803f7e:	48 89 c7             	mov    %rax,%rdi
  803f81:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
  803f8d:	48 89 dc             	mov    %rbx,%rsp
}
  803f90:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803f94:	5b                   	pop    %rbx
  803f95:	41 5c                	pop    %r12
  803f97:	41 5d                	pop    %r13
  803f99:	5d                   	pop    %rbp
  803f9a:	c3                   	retq   

0000000000803f9b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803f9b:	55                   	push   %rbp
  803f9c:	48 89 e5             	mov    %rsp,%rbp
  803f9f:	48 83 ec 50          	sub    $0x50,%rsp
  803fa3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803fa6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803faa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803fae:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fb5:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803fbd:	eb 33                	jmp    803ff2 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803fbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803fc2:	48 98                	cltq   
  803fc4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803fcb:	00 
  803fcc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803fd0:	48 01 d0             	add    %rdx,%rax
  803fd3:	48 8b 00             	mov    (%rax),%rax
  803fd6:	48 89 c7             	mov    %rax,%rdi
  803fd9:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  803fe0:	00 00 00 
  803fe3:	ff d0                	callq  *%rax
  803fe5:	83 c0 01             	add    $0x1,%eax
  803fe8:	48 98                	cltq   
  803fea:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803fee:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803ff2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ff5:	48 98                	cltq   
  803ff7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ffe:	00 
  803fff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804003:	48 01 d0             	add    %rdx,%rax
  804006:	48 8b 00             	mov    (%rax),%rax
  804009:	48 85 c0             	test   %rax,%rax
  80400c:	75 b1                	jne    803fbf <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80400e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804012:	48 f7 d8             	neg    %rax
  804015:	48 05 00 10 40 00    	add    $0x401000,%rax
  80401b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80401f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804023:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804027:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80402f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804032:	83 c2 01             	add    $0x1,%edx
  804035:	c1 e2 03             	shl    $0x3,%edx
  804038:	48 63 d2             	movslq %edx,%rdx
  80403b:	48 f7 da             	neg    %rdx
  80403e:	48 01 d0             	add    %rdx,%rax
  804041:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804045:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804049:	48 83 e8 10          	sub    $0x10,%rax
  80404d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804053:	77 0a                	ja     80405f <init_stack+0xc4>
		return -E_NO_MEM;
  804055:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80405a:	e9 e3 01 00 00       	jmpq   804242 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80405f:	ba 07 00 00 00       	mov    $0x7,%edx
  804064:	be 00 00 40 00       	mov    $0x400000,%esi
  804069:	bf 00 00 00 00       	mov    $0x0,%edi
  80406e:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
  80407a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80407d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804081:	79 08                	jns    80408b <init_stack+0xf0>
		return r;
  804083:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804086:	e9 b7 01 00 00       	jmpq   804242 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80408b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804092:	e9 8a 00 00 00       	jmpq   804121 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804097:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80409a:	48 98                	cltq   
  80409c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040a3:	00 
  8040a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a8:	48 01 c2             	add    %rax,%rdx
  8040ab:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8040b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b4:	48 01 c8             	add    %rcx,%rax
  8040b7:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8040bd:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8040c0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040c3:	48 98                	cltq   
  8040c5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040cc:	00 
  8040cd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040d1:	48 01 d0             	add    %rdx,%rax
  8040d4:	48 8b 10             	mov    (%rax),%rdx
  8040d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040db:	48 89 d6             	mov    %rdx,%rsi
  8040de:	48 89 c7             	mov    %rax,%rdi
  8040e1:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8040ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8040f0:	48 98                	cltq   
  8040f2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8040f9:	00 
  8040fa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040fe:	48 01 d0             	add    %rdx,%rax
  804101:	48 8b 00             	mov    (%rax),%rax
  804104:	48 89 c7             	mov    %rax,%rdi
  804107:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  80410e:	00 00 00 
  804111:	ff d0                	callq  *%rax
  804113:	48 98                	cltq   
  804115:	48 83 c0 01          	add    $0x1,%rax
  804119:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80411d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804121:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804124:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804127:	0f 8c 6a ff ff ff    	jl     804097 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80412d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804130:	48 98                	cltq   
  804132:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804139:	00 
  80413a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413e:	48 01 d0             	add    %rdx,%rax
  804141:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804148:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80414f:	00 
  804150:	74 35                	je     804187 <init_stack+0x1ec>
  804152:	48 b9 68 60 80 00 00 	movabs $0x806068,%rcx
  804159:	00 00 00 
  80415c:	48 ba 8e 60 80 00 00 	movabs $0x80608e,%rdx
  804163:	00 00 00 
  804166:	be f1 00 00 00       	mov    $0xf1,%esi
  80416b:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  804172:	00 00 00 
  804175:	b8 00 00 00 00       	mov    $0x0,%eax
  80417a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804181:	00 00 00 
  804184:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804187:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80418b:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80418f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804194:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804198:	48 01 c8             	add    %rcx,%rax
  80419b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8041a1:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8041a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a8:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8041ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041af:	48 98                	cltq   
  8041b1:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8041b4:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8041b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041bd:	48 01 d0             	add    %rdx,%rax
  8041c0:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8041c6:	48 89 c2             	mov    %rax,%rdx
  8041c9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041cd:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8041d0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8041d3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8041d9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8041de:	89 c2                	mov    %eax,%edx
  8041e0:	be 00 00 40 00       	mov    $0x400000,%esi
  8041e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ea:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8041f1:	00 00 00 
  8041f4:	ff d0                	callq  *%rax
  8041f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041fd:	79 02                	jns    804201 <init_stack+0x266>
		goto error;
  8041ff:	eb 28                	jmp    804229 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804201:	be 00 00 40 00       	mov    $0x400000,%esi
  804206:	bf 00 00 00 00       	mov    $0x0,%edi
  80420b:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
  804217:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80421a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80421e:	79 02                	jns    804222 <init_stack+0x287>
		goto error;
  804220:	eb 07                	jmp    804229 <init_stack+0x28e>

	return 0;
  804222:	b8 00 00 00 00       	mov    $0x0,%eax
  804227:	eb 19                	jmp    804242 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804229:	be 00 00 40 00       	mov    $0x400000,%esi
  80422e:	bf 00 00 00 00       	mov    $0x0,%edi
  804233:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80423a:	00 00 00 
  80423d:	ff d0                	callq  *%rax
	return r;
  80423f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804242:	c9                   	leaveq 
  804243:	c3                   	retq   

0000000000804244 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804244:	55                   	push   %rbp
  804245:	48 89 e5             	mov    %rsp,%rbp
  804248:	48 83 ec 50          	sub    $0x50,%rsp
  80424c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80424f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804253:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804257:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80425a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80425e:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804262:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804266:	25 ff 0f 00 00       	and    $0xfff,%eax
  80426b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80426e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804272:	74 21                	je     804295 <map_segment+0x51>
		va -= i;
  804274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804277:	48 98                	cltq   
  804279:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80427d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804280:	48 98                	cltq   
  804282:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804286:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804289:	48 98                	cltq   
  80428b:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80428f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804292:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804295:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80429c:	e9 79 01 00 00       	jmpq   80441a <map_segment+0x1d6>
		if (i >= filesz) {
  8042a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a4:	48 98                	cltq   
  8042a6:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8042aa:	72 3c                	jb     8042e8 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8042ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042af:	48 63 d0             	movslq %eax,%rdx
  8042b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042b6:	48 01 d0             	add    %rdx,%rax
  8042b9:	48 89 c1             	mov    %rax,%rcx
  8042bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042bf:	8b 55 10             	mov    0x10(%rbp),%edx
  8042c2:	48 89 ce             	mov    %rcx,%rsi
  8042c5:	89 c7                	mov    %eax,%edi
  8042c7:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8042ce:	00 00 00 
  8042d1:	ff d0                	callq  *%rax
  8042d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8042da:	0f 89 33 01 00 00    	jns    804413 <map_segment+0x1cf>
				return r;
  8042e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042e3:	e9 46 01 00 00       	jmpq   80442e <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8042e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8042ed:	be 00 00 40 00       	mov    $0x400000,%esi
  8042f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f7:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8042fe:	00 00 00 
  804301:	ff d0                	callq  *%rax
  804303:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804306:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80430a:	79 08                	jns    804314 <map_segment+0xd0>
				return r;
  80430c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80430f:	e9 1a 01 00 00       	jmpq   80442e <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804317:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80431a:	01 c2                	add    %eax,%edx
  80431c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80431f:	89 d6                	mov    %edx,%esi
  804321:	89 c7                	mov    %eax,%edi
  804323:	48 b8 0a 31 80 00 00 	movabs $0x80310a,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
  80432f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804332:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804336:	79 08                	jns    804340 <map_segment+0xfc>
				return r;
  804338:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80433b:	e9 ee 00 00 00       	jmpq   80442e <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804340:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434a:	48 98                	cltq   
  80434c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804350:	48 29 c2             	sub    %rax,%rdx
  804353:	48 89 d0             	mov    %rdx,%rax
  804356:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80435a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80435d:	48 63 d0             	movslq %eax,%rdx
  804360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804364:	48 39 c2             	cmp    %rax,%rdx
  804367:	48 0f 47 d0          	cmova  %rax,%rdx
  80436b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80436e:	be 00 00 40 00       	mov    $0x400000,%esi
  804373:	89 c7                	mov    %eax,%edi
  804375:	48 b8 c1 2f 80 00 00 	movabs $0x802fc1,%rax
  80437c:	00 00 00 
  80437f:	ff d0                	callq  *%rax
  804381:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804384:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804388:	79 08                	jns    804392 <map_segment+0x14e>
				return r;
  80438a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80438d:	e9 9c 00 00 00       	jmpq   80442e <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  804392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804395:	48 63 d0             	movslq %eax,%rdx
  804398:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80439c:	48 01 d0             	add    %rdx,%rax
  80439f:	48 89 c2             	mov    %rax,%rdx
  8043a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043a5:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8043a9:	48 89 d1             	mov    %rdx,%rcx
  8043ac:	89 c2                	mov    %eax,%edx
  8043ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8043b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8043b8:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8043bf:	00 00 00 
  8043c2:	ff d0                	callq  *%rax
  8043c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8043c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8043cb:	79 30                	jns    8043fd <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8043cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043d0:	89 c1                	mov    %eax,%ecx
  8043d2:	48 ba a3 60 80 00 00 	movabs $0x8060a3,%rdx
  8043d9:	00 00 00 
  8043dc:	be 24 01 00 00       	mov    $0x124,%esi
  8043e1:	48 bf 28 60 80 00 00 	movabs $0x806028,%rdi
  8043e8:	00 00 00 
  8043eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f0:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  8043f7:	00 00 00 
  8043fa:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8043fd:	be 00 00 40 00       	mov    $0x400000,%esi
  804402:	bf 00 00 00 00       	mov    $0x0,%edi
  804407:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  80440e:	00 00 00 
  804411:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804413:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80441a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441d:	48 98                	cltq   
  80441f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804423:	0f 82 78 fe ff ff    	jb     8042a1 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80442e:	c9                   	leaveq 
  80442f:	c3                   	retq   

0000000000804430 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804430:	55                   	push   %rbp
  804431:	48 89 e5             	mov    %rsp,%rbp
  804434:	48 83 ec 20          	sub    $0x20,%rsp
  804438:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80443b:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  804442:	00 
  804443:	e9 c9 00 00 00       	jmpq   804511 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  804448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80444c:	48 c1 e8 27          	shr    $0x27,%rax
  804450:	48 89 c2             	mov    %rax,%rdx
  804453:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80445a:	01 00 00 
  80445d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804461:	48 85 c0             	test   %rax,%rax
  804464:	74 3c                	je     8044a2 <copy_shared_pages+0x72>
  804466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80446e:	48 89 c2             	mov    %rax,%rdx
  804471:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804478:	01 00 00 
  80447b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80447f:	48 85 c0             	test   %rax,%rax
  804482:	74 1e                	je     8044a2 <copy_shared_pages+0x72>
  804484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804488:	48 c1 e8 15          	shr    $0x15,%rax
  80448c:	48 89 c2             	mov    %rax,%rdx
  80448f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804496:	01 00 00 
  804499:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449d:	48 85 c0             	test   %rax,%rax
  8044a0:	75 02                	jne    8044a4 <copy_shared_pages+0x74>
                continue;
  8044a2:	eb 65                	jmp    804509 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8044a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8044ac:	48 89 c2             	mov    %rax,%rdx
  8044af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044b6:	01 00 00 
  8044b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044bd:	25 00 04 00 00       	and    $0x400,%eax
  8044c2:	48 85 c0             	test   %rax,%rax
  8044c5:	74 42                	je     804509 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8044c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8044cf:	48 89 c2             	mov    %rax,%rdx
  8044d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044d9:	01 00 00 
  8044dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8044e5:	89 c6                	mov    %eax,%esi
  8044e7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8044eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8044f2:	41 89 f0             	mov    %esi,%r8d
  8044f5:	48 89 c6             	mov    %rax,%rsi
  8044f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8044fd:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  804504:	00 00 00 
  804507:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  804509:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  804510:	00 
  804511:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  804518:	00 00 00 
  80451b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80451f:	0f 86 23 ff ff ff    	jbe    804448 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  804525:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80452a:	c9                   	leaveq 
  80452b:	c3                   	retq   

000000000080452c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80452c:	55                   	push   %rbp
  80452d:	48 89 e5             	mov    %rsp,%rbp
  804530:	48 83 ec 20          	sub    $0x20,%rsp
  804534:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804537:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80453b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80453e:	48 89 d6             	mov    %rdx,%rsi
  804541:	89 c7                	mov    %eax,%edi
  804543:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  80454a:	00 00 00 
  80454d:	ff d0                	callq  *%rax
  80454f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804552:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804556:	79 05                	jns    80455d <fd2sockid+0x31>
		return r;
  804558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455b:	eb 24                	jmp    804581 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80455d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804561:	8b 10                	mov    (%rax),%edx
  804563:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  80456a:	00 00 00 
  80456d:	8b 00                	mov    (%rax),%eax
  80456f:	39 c2                	cmp    %eax,%edx
  804571:	74 07                	je     80457a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  804573:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804578:	eb 07                	jmp    804581 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80457a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  804581:	c9                   	leaveq 
  804582:	c3                   	retq   

0000000000804583 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  804583:	55                   	push   %rbp
  804584:	48 89 e5             	mov    %rsp,%rbp
  804587:	48 83 ec 20          	sub    $0x20,%rsp
  80458b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80458e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804592:	48 89 c7             	mov    %rax,%rdi
  804595:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  80459c:	00 00 00 
  80459f:	ff d0                	callq  *%rax
  8045a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a8:	78 26                	js     8045d0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8045aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8045b3:	48 89 c6             	mov    %rax,%rsi
  8045b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8045bb:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ce:	79 16                	jns    8045e6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8045d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d3:	89 c7                	mov    %eax,%edi
  8045d5:	48 b8 90 4a 80 00 00 	movabs $0x804a90,%rax
  8045dc:	00 00 00 
  8045df:	ff d0                	callq  *%rax
		return r;
  8045e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e4:	eb 3a                	jmp    804620 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8045e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ea:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  8045f1:	00 00 00 
  8045f4:	8b 12                	mov    (%rdx),%edx
  8045f6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8045f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804607:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80460a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80460d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804611:	48 89 c7             	mov    %rax,%rdi
  804614:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  80461b:	00 00 00 
  80461e:	ff d0                	callq  *%rax
}
  804620:	c9                   	leaveq 
  804621:	c3                   	retq   

0000000000804622 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804622:	55                   	push   %rbp
  804623:	48 89 e5             	mov    %rsp,%rbp
  804626:	48 83 ec 30          	sub    $0x30,%rsp
  80462a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80462d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804631:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804635:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804638:	89 c7                	mov    %eax,%edi
  80463a:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  804641:	00 00 00 
  804644:	ff d0                	callq  *%rax
  804646:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80464d:	79 05                	jns    804654 <accept+0x32>
		return r;
  80464f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804652:	eb 3b                	jmp    80468f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804654:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804658:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80465c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465f:	48 89 ce             	mov    %rcx,%rsi
  804662:	89 c7                	mov    %eax,%edi
  804664:	48 b8 6d 49 80 00 00 	movabs $0x80496d,%rax
  80466b:	00 00 00 
  80466e:	ff d0                	callq  *%rax
  804670:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804677:	79 05                	jns    80467e <accept+0x5c>
		return r;
  804679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80467c:	eb 11                	jmp    80468f <accept+0x6d>
	return alloc_sockfd(r);
  80467e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804681:	89 c7                	mov    %eax,%edi
  804683:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
}
  80468f:	c9                   	leaveq 
  804690:	c3                   	retq   

0000000000804691 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804691:	55                   	push   %rbp
  804692:	48 89 e5             	mov    %rsp,%rbp
  804695:	48 83 ec 20          	sub    $0x20,%rsp
  804699:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80469c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8046a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046a6:	89 c7                	mov    %eax,%edi
  8046a8:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  8046af:	00 00 00 
  8046b2:	ff d0                	callq  *%rax
  8046b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046bb:	79 05                	jns    8046c2 <bind+0x31>
		return r;
  8046bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046c0:	eb 1b                	jmp    8046dd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8046c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8046c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8046c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046cc:	48 89 ce             	mov    %rcx,%rsi
  8046cf:	89 c7                	mov    %eax,%edi
  8046d1:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  8046d8:	00 00 00 
  8046db:	ff d0                	callq  *%rax
}
  8046dd:	c9                   	leaveq 
  8046de:	c3                   	retq   

00000000008046df <shutdown>:

int
shutdown(int s, int how)
{
  8046df:	55                   	push   %rbp
  8046e0:	48 89 e5             	mov    %rsp,%rbp
  8046e3:	48 83 ec 20          	sub    $0x20,%rsp
  8046e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046ea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8046ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046f0:	89 c7                	mov    %eax,%edi
  8046f2:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  8046f9:	00 00 00 
  8046fc:	ff d0                	callq  *%rax
  8046fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804705:	79 05                	jns    80470c <shutdown+0x2d>
		return r;
  804707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80470a:	eb 16                	jmp    804722 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80470c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80470f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804712:	89 d6                	mov    %edx,%esi
  804714:	89 c7                	mov    %eax,%edi
  804716:	48 b8 50 4a 80 00 00 	movabs $0x804a50,%rax
  80471d:	00 00 00 
  804720:	ff d0                	callq  *%rax
}
  804722:	c9                   	leaveq 
  804723:	c3                   	retq   

0000000000804724 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804724:	55                   	push   %rbp
  804725:	48 89 e5             	mov    %rsp,%rbp
  804728:	48 83 ec 10          	sub    $0x10,%rsp
  80472c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804734:	48 89 c7             	mov    %rax,%rdi
  804737:	48 b8 c8 56 80 00 00 	movabs $0x8056c8,%rax
  80473e:	00 00 00 
  804741:	ff d0                	callq  *%rax
  804743:	83 f8 01             	cmp    $0x1,%eax
  804746:	75 17                	jne    80475f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80474c:	8b 40 0c             	mov    0xc(%rax),%eax
  80474f:	89 c7                	mov    %eax,%edi
  804751:	48 b8 90 4a 80 00 00 	movabs $0x804a90,%rax
  804758:	00 00 00 
  80475b:	ff d0                	callq  *%rax
  80475d:	eb 05                	jmp    804764 <devsock_close+0x40>
	else
		return 0;
  80475f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804764:	c9                   	leaveq 
  804765:	c3                   	retq   

0000000000804766 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804766:	55                   	push   %rbp
  804767:	48 89 e5             	mov    %rsp,%rbp
  80476a:	48 83 ec 20          	sub    $0x20,%rsp
  80476e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804771:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804775:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804778:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80477b:	89 c7                	mov    %eax,%edi
  80477d:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  804784:	00 00 00 
  804787:	ff d0                	callq  *%rax
  804789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80478c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804790:	79 05                	jns    804797 <connect+0x31>
		return r;
  804792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804795:	eb 1b                	jmp    8047b2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804797:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80479a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80479e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a1:	48 89 ce             	mov    %rcx,%rsi
  8047a4:	89 c7                	mov    %eax,%edi
  8047a6:	48 b8 bd 4a 80 00 00 	movabs $0x804abd,%rax
  8047ad:	00 00 00 
  8047b0:	ff d0                	callq  *%rax
}
  8047b2:	c9                   	leaveq 
  8047b3:	c3                   	retq   

00000000008047b4 <listen>:

int
listen(int s, int backlog)
{
  8047b4:	55                   	push   %rbp
  8047b5:	48 89 e5             	mov    %rsp,%rbp
  8047b8:	48 83 ec 20          	sub    $0x20,%rsp
  8047bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047bf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047c5:	89 c7                	mov    %eax,%edi
  8047c7:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  8047ce:	00 00 00 
  8047d1:	ff d0                	callq  *%rax
  8047d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047da:	79 05                	jns    8047e1 <listen+0x2d>
		return r;
  8047dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047df:	eb 16                	jmp    8047f7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8047e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8047e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e7:	89 d6                	mov    %edx,%esi
  8047e9:	89 c7                	mov    %eax,%edi
  8047eb:	48 b8 21 4b 80 00 00 	movabs $0x804b21,%rax
  8047f2:	00 00 00 
  8047f5:	ff d0                	callq  *%rax
}
  8047f7:	c9                   	leaveq 
  8047f8:	c3                   	retq   

00000000008047f9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8047f9:	55                   	push   %rbp
  8047fa:	48 89 e5             	mov    %rsp,%rbp
  8047fd:	48 83 ec 20          	sub    $0x20,%rsp
  804801:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804805:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804809:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80480d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804811:	89 c2                	mov    %eax,%edx
  804813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804817:	8b 40 0c             	mov    0xc(%rax),%eax
  80481a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80481e:	b9 00 00 00 00       	mov    $0x0,%ecx
  804823:	89 c7                	mov    %eax,%edi
  804825:	48 b8 61 4b 80 00 00 	movabs $0x804b61,%rax
  80482c:	00 00 00 
  80482f:	ff d0                	callq  *%rax
}
  804831:	c9                   	leaveq 
  804832:	c3                   	retq   

0000000000804833 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804833:	55                   	push   %rbp
  804834:	48 89 e5             	mov    %rsp,%rbp
  804837:	48 83 ec 20          	sub    $0x20,%rsp
  80483b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80483f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804843:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80484b:	89 c2                	mov    %eax,%edx
  80484d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804851:	8b 40 0c             	mov    0xc(%rax),%eax
  804854:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804858:	b9 00 00 00 00       	mov    $0x0,%ecx
  80485d:	89 c7                	mov    %eax,%edi
  80485f:	48 b8 2d 4c 80 00 00 	movabs $0x804c2d,%rax
  804866:	00 00 00 
  804869:	ff d0                	callq  *%rax
}
  80486b:	c9                   	leaveq 
  80486c:	c3                   	retq   

000000000080486d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80486d:	55                   	push   %rbp
  80486e:	48 89 e5             	mov    %rsp,%rbp
  804871:	48 83 ec 10          	sub    $0x10,%rsp
  804875:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804879:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80487d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804881:	48 be c5 60 80 00 00 	movabs $0x8060c5,%rsi
  804888:	00 00 00 
  80488b:	48 89 c7             	mov    %rax,%rdi
  80488e:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  804895:	00 00 00 
  804898:	ff d0                	callq  *%rax
	return 0;
  80489a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80489f:	c9                   	leaveq 
  8048a0:	c3                   	retq   

00000000008048a1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8048a1:	55                   	push   %rbp
  8048a2:	48 89 e5             	mov    %rsp,%rbp
  8048a5:	48 83 ec 20          	sub    $0x20,%rsp
  8048a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048ac:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8048af:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8048b2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8048b5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8048b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048bb:	89 ce                	mov    %ecx,%esi
  8048bd:	89 c7                	mov    %eax,%edi
  8048bf:	48 b8 e5 4c 80 00 00 	movabs $0x804ce5,%rax
  8048c6:	00 00 00 
  8048c9:	ff d0                	callq  *%rax
  8048cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048d2:	79 05                	jns    8048d9 <socket+0x38>
		return r;
  8048d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d7:	eb 11                	jmp    8048ea <socket+0x49>
	return alloc_sockfd(r);
  8048d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048dc:	89 c7                	mov    %eax,%edi
  8048de:	48 b8 83 45 80 00 00 	movabs $0x804583,%rax
  8048e5:	00 00 00 
  8048e8:	ff d0                	callq  *%rax
}
  8048ea:	c9                   	leaveq 
  8048eb:	c3                   	retq   

00000000008048ec <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8048ec:	55                   	push   %rbp
  8048ed:	48 89 e5             	mov    %rsp,%rbp
  8048f0:	48 83 ec 10          	sub    $0x10,%rsp
  8048f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8048f7:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  8048fe:	00 00 00 
  804901:	8b 00                	mov    (%rax),%eax
  804903:	85 c0                	test   %eax,%eax
  804905:	75 1d                	jne    804924 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804907:	bf 02 00 00 00       	mov    $0x2,%edi
  80490c:	48 b8 46 56 80 00 00 	movabs $0x805646,%rax
  804913:	00 00 00 
  804916:	ff d0                	callq  *%rax
  804918:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  80491f:	00 00 00 
  804922:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804924:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  80492b:	00 00 00 
  80492e:	8b 00                	mov    (%rax),%eax
  804930:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804933:	b9 07 00 00 00       	mov    $0x7,%ecx
  804938:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80493f:	00 00 00 
  804942:	89 c7                	mov    %eax,%edi
  804944:	48 b8 e4 55 80 00 00 	movabs $0x8055e4,%rax
  80494b:	00 00 00 
  80494e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804950:	ba 00 00 00 00       	mov    $0x0,%edx
  804955:	be 00 00 00 00       	mov    $0x0,%esi
  80495a:	bf 00 00 00 00       	mov    $0x0,%edi
  80495f:	48 b8 de 54 80 00 00 	movabs $0x8054de,%rax
  804966:	00 00 00 
  804969:	ff d0                	callq  *%rax
}
  80496b:	c9                   	leaveq 
  80496c:	c3                   	retq   

000000000080496d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80496d:	55                   	push   %rbp
  80496e:	48 89 e5             	mov    %rsp,%rbp
  804971:	48 83 ec 30          	sub    $0x30,%rsp
  804975:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804978:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80497c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804980:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804987:	00 00 00 
  80498a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80498d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80498f:	bf 01 00 00 00       	mov    $0x1,%edi
  804994:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  80499b:	00 00 00 
  80499e:	ff d0                	callq  *%rax
  8049a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049a7:	78 3e                	js     8049e7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8049a9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049b0:	00 00 00 
  8049b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8049b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049bb:	8b 40 10             	mov    0x10(%rax),%eax
  8049be:	89 c2                	mov    %eax,%edx
  8049c0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8049c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049c8:	48 89 ce             	mov    %rcx,%rsi
  8049cb:	48 89 c7             	mov    %rax,%rdi
  8049ce:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8049d5:	00 00 00 
  8049d8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8049da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049de:	8b 50 10             	mov    0x10(%rax),%edx
  8049e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049e5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8049e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8049ea:	c9                   	leaveq 
  8049eb:	c3                   	retq   

00000000008049ec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8049ec:	55                   	push   %rbp
  8049ed:	48 89 e5             	mov    %rsp,%rbp
  8049f0:	48 83 ec 10          	sub    $0x10,%rsp
  8049f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8049fb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8049fe:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a05:	00 00 00 
  804a08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a0b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804a0d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a14:	48 89 c6             	mov    %rax,%rsi
  804a17:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804a1e:	00 00 00 
  804a21:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804a28:	00 00 00 
  804a2b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804a2d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a34:	00 00 00 
  804a37:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a3a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804a3d:	bf 02 00 00 00       	mov    $0x2,%edi
  804a42:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804a49:	00 00 00 
  804a4c:	ff d0                	callq  *%rax
}
  804a4e:	c9                   	leaveq 
  804a4f:	c3                   	retq   

0000000000804a50 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804a50:	55                   	push   %rbp
  804a51:	48 89 e5             	mov    %rsp,%rbp
  804a54:	48 83 ec 10          	sub    $0x10,%rsp
  804a58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a5b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804a5e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a65:	00 00 00 
  804a68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a6b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804a6d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a74:	00 00 00 
  804a77:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804a7a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804a7d:	bf 03 00 00 00       	mov    $0x3,%edi
  804a82:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804a89:	00 00 00 
  804a8c:	ff d0                	callq  *%rax
}
  804a8e:	c9                   	leaveq 
  804a8f:	c3                   	retq   

0000000000804a90 <nsipc_close>:

int
nsipc_close(int s)
{
  804a90:	55                   	push   %rbp
  804a91:	48 89 e5             	mov    %rsp,%rbp
  804a94:	48 83 ec 10          	sub    $0x10,%rsp
  804a98:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  804a9b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804aa2:	00 00 00 
  804aa5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804aa8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804aaa:	bf 04 00 00 00       	mov    $0x4,%edi
  804aaf:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804ab6:	00 00 00 
  804ab9:	ff d0                	callq  *%rax
}
  804abb:	c9                   	leaveq 
  804abc:	c3                   	retq   

0000000000804abd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804abd:	55                   	push   %rbp
  804abe:	48 89 e5             	mov    %rsp,%rbp
  804ac1:	48 83 ec 10          	sub    $0x10,%rsp
  804ac5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804acc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804acf:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ad6:	00 00 00 
  804ad9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804adc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804ade:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae5:	48 89 c6             	mov    %rax,%rsi
  804ae8:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804aef:	00 00 00 
  804af2:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804af9:	00 00 00 
  804afc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804afe:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b05:	00 00 00 
  804b08:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b0b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804b0e:	bf 05 00 00 00       	mov    $0x5,%edi
  804b13:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804b1a:	00 00 00 
  804b1d:	ff d0                	callq  *%rax
}
  804b1f:	c9                   	leaveq 
  804b20:	c3                   	retq   

0000000000804b21 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804b21:	55                   	push   %rbp
  804b22:	48 89 e5             	mov    %rsp,%rbp
  804b25:	48 83 ec 10          	sub    $0x10,%rsp
  804b29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b2c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804b2f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b36:	00 00 00 
  804b39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b3c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804b3e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b45:	00 00 00 
  804b48:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b4b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804b4e:	bf 06 00 00 00       	mov    $0x6,%edi
  804b53:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804b5a:	00 00 00 
  804b5d:	ff d0                	callq  *%rax
}
  804b5f:	c9                   	leaveq 
  804b60:	c3                   	retq   

0000000000804b61 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804b61:	55                   	push   %rbp
  804b62:	48 89 e5             	mov    %rsp,%rbp
  804b65:	48 83 ec 30          	sub    $0x30,%rsp
  804b69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b70:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804b73:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804b76:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b7d:	00 00 00 
  804b80:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804b83:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804b85:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b8c:	00 00 00 
  804b8f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804b92:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804b95:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b9c:	00 00 00 
  804b9f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804ba2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804ba5:	bf 07 00 00 00       	mov    $0x7,%edi
  804baa:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804bb1:	00 00 00 
  804bb4:	ff d0                	callq  *%rax
  804bb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804bb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bbd:	78 69                	js     804c28 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804bbf:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804bc6:	7f 08                	jg     804bd0 <nsipc_recv+0x6f>
  804bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bcb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804bce:	7e 35                	jle    804c05 <nsipc_recv+0xa4>
  804bd0:	48 b9 cc 60 80 00 00 	movabs $0x8060cc,%rcx
  804bd7:	00 00 00 
  804bda:	48 ba e1 60 80 00 00 	movabs $0x8060e1,%rdx
  804be1:	00 00 00 
  804be4:	be 61 00 00 00       	mov    $0x61,%esi
  804be9:	48 bf f6 60 80 00 00 	movabs $0x8060f6,%rdi
  804bf0:	00 00 00 
  804bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  804bf8:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804bff:	00 00 00 
  804c02:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c08:	48 63 d0             	movslq %eax,%rdx
  804c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c0f:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804c16:	00 00 00 
  804c19:	48 89 c7             	mov    %rax,%rdi
  804c1c:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804c23:	00 00 00 
  804c26:	ff d0                	callq  *%rax
	}

	return r;
  804c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c2b:	c9                   	leaveq 
  804c2c:	c3                   	retq   

0000000000804c2d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804c2d:	55                   	push   %rbp
  804c2e:	48 89 e5             	mov    %rsp,%rbp
  804c31:	48 83 ec 20          	sub    $0x20,%rsp
  804c35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804c3f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804c42:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c49:	00 00 00 
  804c4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804c4f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804c51:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804c58:	7e 35                	jle    804c8f <nsipc_send+0x62>
  804c5a:	48 b9 02 61 80 00 00 	movabs $0x806102,%rcx
  804c61:	00 00 00 
  804c64:	48 ba e1 60 80 00 00 	movabs $0x8060e1,%rdx
  804c6b:	00 00 00 
  804c6e:	be 6c 00 00 00       	mov    $0x6c,%esi
  804c73:	48 bf f6 60 80 00 00 	movabs $0x8060f6,%rdi
  804c7a:	00 00 00 
  804c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  804c82:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  804c89:	00 00 00 
  804c8c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804c8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c92:	48 63 d0             	movslq %eax,%rdx
  804c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c99:	48 89 c6             	mov    %rax,%rsi
  804c9c:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804ca3:	00 00 00 
  804ca6:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  804cad:	00 00 00 
  804cb0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804cb2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cb9:	00 00 00 
  804cbc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804cbf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804cc2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cc9:	00 00 00 
  804ccc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804ccf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804cd2:	bf 08 00 00 00       	mov    $0x8,%edi
  804cd7:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804cde:	00 00 00 
  804ce1:	ff d0                	callq  *%rax
}
  804ce3:	c9                   	leaveq 
  804ce4:	c3                   	retq   

0000000000804ce5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804ce5:	55                   	push   %rbp
  804ce6:	48 89 e5             	mov    %rsp,%rbp
  804ce9:	48 83 ec 10          	sub    $0x10,%rsp
  804ced:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804cf0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804cf3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804cf6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804cfd:	00 00 00 
  804d00:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804d03:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804d05:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d0c:	00 00 00 
  804d0f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804d12:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804d15:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804d1c:	00 00 00 
  804d1f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804d22:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804d25:	bf 09 00 00 00       	mov    $0x9,%edi
  804d2a:	48 b8 ec 48 80 00 00 	movabs $0x8048ec,%rax
  804d31:	00 00 00 
  804d34:	ff d0                	callq  *%rax
}
  804d36:	c9                   	leaveq 
  804d37:	c3                   	retq   

0000000000804d38 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804d38:	55                   	push   %rbp
  804d39:	48 89 e5             	mov    %rsp,%rbp
  804d3c:	53                   	push   %rbx
  804d3d:	48 83 ec 38          	sub    $0x38,%rsp
  804d41:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804d45:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804d49:	48 89 c7             	mov    %rax,%rdi
  804d4c:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  804d53:	00 00 00 
  804d56:	ff d0                	callq  *%rax
  804d58:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804d5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d5f:	0f 88 bf 01 00 00    	js     804f24 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804d65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d69:	ba 07 04 00 00       	mov    $0x407,%edx
  804d6e:	48 89 c6             	mov    %rax,%rsi
  804d71:	bf 00 00 00 00       	mov    $0x0,%edi
  804d76:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804d7d:	00 00 00 
  804d80:	ff d0                	callq  *%rax
  804d82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804d85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d89:	0f 88 95 01 00 00    	js     804f24 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804d8f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804d93:	48 89 c7             	mov    %rax,%rdi
  804d96:	48 b8 22 2a 80 00 00 	movabs $0x802a22,%rax
  804d9d:	00 00 00 
  804da0:	ff d0                	callq  *%rax
  804da2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804da5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804da9:	0f 88 5d 01 00 00    	js     804f0c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804daf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804db3:	ba 07 04 00 00       	mov    $0x407,%edx
  804db8:	48 89 c6             	mov    %rax,%rsi
  804dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  804dc0:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804dc7:	00 00 00 
  804dca:	ff d0                	callq  *%rax
  804dcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804dcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804dd3:	0f 88 33 01 00 00    	js     804f0c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804dd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ddd:	48 89 c7             	mov    %rax,%rdi
  804de0:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  804de7:	00 00 00 
  804dea:	ff d0                	callq  *%rax
  804dec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804df4:	ba 07 04 00 00       	mov    $0x407,%edx
  804df9:	48 89 c6             	mov    %rax,%rsi
  804dfc:	bf 00 00 00 00       	mov    $0x0,%edi
  804e01:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  804e08:	00 00 00 
  804e0b:	ff d0                	callq  *%rax
  804e0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e14:	79 05                	jns    804e1b <pipe+0xe3>
		goto err2;
  804e16:	e9 d9 00 00 00       	jmpq   804ef4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804e1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e1f:	48 89 c7             	mov    %rax,%rdi
  804e22:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  804e29:	00 00 00 
  804e2c:	ff d0                	callq  *%rax
  804e2e:	48 89 c2             	mov    %rax,%rdx
  804e31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e35:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804e3b:	48 89 d1             	mov    %rdx,%rcx
  804e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  804e43:	48 89 c6             	mov    %rax,%rsi
  804e46:	bf 00 00 00 00       	mov    $0x0,%edi
  804e4b:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  804e52:	00 00 00 
  804e55:	ff d0                	callq  *%rax
  804e57:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e5e:	79 1b                	jns    804e7b <pipe+0x143>
		goto err3;
  804e60:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804e61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e65:	48 89 c6             	mov    %rax,%rsi
  804e68:	bf 00 00 00 00       	mov    $0x0,%edi
  804e6d:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804e74:	00 00 00 
  804e77:	ff d0                	callq  *%rax
  804e79:	eb 79                	jmp    804ef4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804e7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e7f:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804e86:	00 00 00 
  804e89:	8b 12                	mov    (%rdx),%edx
  804e8b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804e8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804e98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e9c:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804ea3:	00 00 00 
  804ea6:	8b 12                	mov    (%rdx),%edx
  804ea8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804eaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804eb9:	48 89 c7             	mov    %rax,%rdi
  804ebc:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  804ec3:	00 00 00 
  804ec6:	ff d0                	callq  *%rax
  804ec8:	89 c2                	mov    %eax,%edx
  804eca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ece:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804ed0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804ed4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804ed8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804edc:	48 89 c7             	mov    %rax,%rdi
  804edf:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  804ee6:	00 00 00 
  804ee9:	ff d0                	callq  *%rax
  804eeb:	89 03                	mov    %eax,(%rbx)
	return 0;
  804eed:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef2:	eb 33                	jmp    804f27 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804ef4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef8:	48 89 c6             	mov    %rax,%rsi
  804efb:	bf 00 00 00 00       	mov    $0x0,%edi
  804f00:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804f07:	00 00 00 
  804f0a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804f0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f10:	48 89 c6             	mov    %rax,%rsi
  804f13:	bf 00 00 00 00       	mov    $0x0,%edi
  804f18:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  804f1f:	00 00 00 
  804f22:	ff d0                	callq  *%rax
err:
	return r;
  804f24:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804f27:	48 83 c4 38          	add    $0x38,%rsp
  804f2b:	5b                   	pop    %rbx
  804f2c:	5d                   	pop    %rbp
  804f2d:	c3                   	retq   

0000000000804f2e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804f2e:	55                   	push   %rbp
  804f2f:	48 89 e5             	mov    %rsp,%rbp
  804f32:	53                   	push   %rbx
  804f33:	48 83 ec 28          	sub    $0x28,%rsp
  804f37:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804f3b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804f3f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804f46:	00 00 00 
  804f49:	48 8b 00             	mov    (%rax),%rax
  804f4c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804f52:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804f55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f59:	48 89 c7             	mov    %rax,%rdi
  804f5c:	48 b8 c8 56 80 00 00 	movabs $0x8056c8,%rax
  804f63:	00 00 00 
  804f66:	ff d0                	callq  *%rax
  804f68:	89 c3                	mov    %eax,%ebx
  804f6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f6e:	48 89 c7             	mov    %rax,%rdi
  804f71:	48 b8 c8 56 80 00 00 	movabs $0x8056c8,%rax
  804f78:	00 00 00 
  804f7b:	ff d0                	callq  *%rax
  804f7d:	39 c3                	cmp    %eax,%ebx
  804f7f:	0f 94 c0             	sete   %al
  804f82:	0f b6 c0             	movzbl %al,%eax
  804f85:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804f88:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804f8f:	00 00 00 
  804f92:	48 8b 00             	mov    (%rax),%rax
  804f95:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804f9b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804f9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fa1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804fa4:	75 05                	jne    804fab <_pipeisclosed+0x7d>
			return ret;
  804fa6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804fa9:	eb 4f                	jmp    804ffa <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804fab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fae:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804fb1:	74 42                	je     804ff5 <_pipeisclosed+0xc7>
  804fb3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804fb7:	75 3c                	jne    804ff5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804fb9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804fc0:	00 00 00 
  804fc3:	48 8b 00             	mov    (%rax),%rax
  804fc6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804fcc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804fcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fd2:	89 c6                	mov    %eax,%esi
  804fd4:	48 bf 13 61 80 00 00 	movabs $0x806113,%rdi
  804fdb:	00 00 00 
  804fde:	b8 00 00 00 00       	mov    $0x0,%eax
  804fe3:	49 b8 1d 0b 80 00 00 	movabs $0x800b1d,%r8
  804fea:	00 00 00 
  804fed:	41 ff d0             	callq  *%r8
	}
  804ff0:	e9 4a ff ff ff       	jmpq   804f3f <_pipeisclosed+0x11>
  804ff5:	e9 45 ff ff ff       	jmpq   804f3f <_pipeisclosed+0x11>
}
  804ffa:	48 83 c4 28          	add    $0x28,%rsp
  804ffe:	5b                   	pop    %rbx
  804fff:	5d                   	pop    %rbp
  805000:	c3                   	retq   

0000000000805001 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805001:	55                   	push   %rbp
  805002:	48 89 e5             	mov    %rsp,%rbp
  805005:	48 83 ec 30          	sub    $0x30,%rsp
  805009:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80500c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805010:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805013:	48 89 d6             	mov    %rdx,%rsi
  805016:	89 c7                	mov    %eax,%edi
  805018:	48 b8 ba 2a 80 00 00 	movabs $0x802aba,%rax
  80501f:	00 00 00 
  805022:	ff d0                	callq  *%rax
  805024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80502b:	79 05                	jns    805032 <pipeisclosed+0x31>
		return r;
  80502d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805030:	eb 31                	jmp    805063 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805036:	48 89 c7             	mov    %rax,%rdi
  805039:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  805040:	00 00 00 
  805043:	ff d0                	callq  *%rax
  805045:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805049:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80504d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805051:	48 89 d6             	mov    %rdx,%rsi
  805054:	48 89 c7             	mov    %rax,%rdi
  805057:	48 b8 2e 4f 80 00 00 	movabs $0x804f2e,%rax
  80505e:	00 00 00 
  805061:	ff d0                	callq  *%rax
}
  805063:	c9                   	leaveq 
  805064:	c3                   	retq   

0000000000805065 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805065:	55                   	push   %rbp
  805066:	48 89 e5             	mov    %rsp,%rbp
  805069:	48 83 ec 40          	sub    $0x40,%rsp
  80506d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805071:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805075:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80507d:	48 89 c7             	mov    %rax,%rdi
  805080:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  805087:	00 00 00 
  80508a:	ff d0                	callq  *%rax
  80508c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805090:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805094:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805098:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80509f:	00 
  8050a0:	e9 92 00 00 00       	jmpq   805137 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8050a5:	eb 41                	jmp    8050e8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8050a7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8050ac:	74 09                	je     8050b7 <devpipe_read+0x52>
				return i;
  8050ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050b2:	e9 92 00 00 00       	jmpq   805149 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8050b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050bf:	48 89 d6             	mov    %rdx,%rsi
  8050c2:	48 89 c7             	mov    %rax,%rdi
  8050c5:	48 b8 2e 4f 80 00 00 	movabs $0x804f2e,%rax
  8050cc:	00 00 00 
  8050cf:	ff d0                	callq  *%rax
  8050d1:	85 c0                	test   %eax,%eax
  8050d3:	74 07                	je     8050dc <devpipe_read+0x77>
				return 0;
  8050d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8050da:	eb 6d                	jmp    805149 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8050dc:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8050e3:	00 00 00 
  8050e6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8050e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050ec:	8b 10                	mov    (%rax),%edx
  8050ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050f2:	8b 40 04             	mov    0x4(%rax),%eax
  8050f5:	39 c2                	cmp    %eax,%edx
  8050f7:	74 ae                	je     8050a7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8050f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805101:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805109:	8b 00                	mov    (%rax),%eax
  80510b:	99                   	cltd   
  80510c:	c1 ea 1b             	shr    $0x1b,%edx
  80510f:	01 d0                	add    %edx,%eax
  805111:	83 e0 1f             	and    $0x1f,%eax
  805114:	29 d0                	sub    %edx,%eax
  805116:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80511a:	48 98                	cltq   
  80511c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805121:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805127:	8b 00                	mov    (%rax),%eax
  805129:	8d 50 01             	lea    0x1(%rax),%edx
  80512c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805130:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805132:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80513b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80513f:	0f 82 60 ff ff ff    	jb     8050a5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805149:	c9                   	leaveq 
  80514a:	c3                   	retq   

000000000080514b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80514b:	55                   	push   %rbp
  80514c:	48 89 e5             	mov    %rsp,%rbp
  80514f:	48 83 ec 40          	sub    $0x40,%rsp
  805153:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805157:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80515b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80515f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805163:	48 89 c7             	mov    %rax,%rdi
  805166:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  80516d:	00 00 00 
  805170:	ff d0                	callq  *%rax
  805172:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805176:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80517a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80517e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805185:	00 
  805186:	e9 8e 00 00 00       	jmpq   805219 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80518b:	eb 31                	jmp    8051be <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80518d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805191:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805195:	48 89 d6             	mov    %rdx,%rsi
  805198:	48 89 c7             	mov    %rax,%rdi
  80519b:	48 b8 2e 4f 80 00 00 	movabs $0x804f2e,%rax
  8051a2:	00 00 00 
  8051a5:	ff d0                	callq  *%rax
  8051a7:	85 c0                	test   %eax,%eax
  8051a9:	74 07                	je     8051b2 <devpipe_write+0x67>
				return 0;
  8051ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8051b0:	eb 79                	jmp    80522b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8051b2:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  8051b9:	00 00 00 
  8051bc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8051be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051c2:	8b 40 04             	mov    0x4(%rax),%eax
  8051c5:	48 63 d0             	movslq %eax,%rdx
  8051c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051cc:	8b 00                	mov    (%rax),%eax
  8051ce:	48 98                	cltq   
  8051d0:	48 83 c0 20          	add    $0x20,%rax
  8051d4:	48 39 c2             	cmp    %rax,%rdx
  8051d7:	73 b4                	jae    80518d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8051d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051dd:	8b 40 04             	mov    0x4(%rax),%eax
  8051e0:	99                   	cltd   
  8051e1:	c1 ea 1b             	shr    $0x1b,%edx
  8051e4:	01 d0                	add    %edx,%eax
  8051e6:	83 e0 1f             	and    $0x1f,%eax
  8051e9:	29 d0                	sub    %edx,%eax
  8051eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8051ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8051f3:	48 01 ca             	add    %rcx,%rdx
  8051f6:	0f b6 0a             	movzbl (%rdx),%ecx
  8051f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8051fd:	48 98                	cltq   
  8051ff:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805207:	8b 40 04             	mov    0x4(%rax),%eax
  80520a:	8d 50 01             	lea    0x1(%rax),%edx
  80520d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805211:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805214:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80521d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805221:	0f 82 64 ff ff ff    	jb     80518b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80522b:	c9                   	leaveq 
  80522c:	c3                   	retq   

000000000080522d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80522d:	55                   	push   %rbp
  80522e:	48 89 e5             	mov    %rsp,%rbp
  805231:	48 83 ec 20          	sub    $0x20,%rsp
  805235:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805239:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80523d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805241:	48 89 c7             	mov    %rax,%rdi
  805244:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  80524b:	00 00 00 
  80524e:	ff d0                	callq  *%rax
  805250:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805254:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805258:	48 be 26 61 80 00 00 	movabs $0x806126,%rsi
  80525f:	00 00 00 
  805262:	48 89 c7             	mov    %rax,%rdi
  805265:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80526c:	00 00 00 
  80526f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805275:	8b 50 04             	mov    0x4(%rax),%edx
  805278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80527c:	8b 00                	mov    (%rax),%eax
  80527e:	29 c2                	sub    %eax,%edx
  805280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805284:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80528a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80528e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805295:	00 00 00 
	stat->st_dev = &devpipe;
  805298:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80529c:	48 b9 00 81 80 00 00 	movabs $0x808100,%rcx
  8052a3:	00 00 00 
  8052a6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8052ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8052b2:	c9                   	leaveq 
  8052b3:	c3                   	retq   

00000000008052b4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8052b4:	55                   	push   %rbp
  8052b5:	48 89 e5             	mov    %rsp,%rbp
  8052b8:	48 83 ec 10          	sub    $0x10,%rsp
  8052bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8052c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052c4:	48 89 c6             	mov    %rax,%rsi
  8052c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8052cc:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8052d3:	00 00 00 
  8052d6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8052d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052dc:	48 89 c7             	mov    %rax,%rdi
  8052df:	48 b8 f7 29 80 00 00 	movabs $0x8029f7,%rax
  8052e6:	00 00 00 
  8052e9:	ff d0                	callq  *%rax
  8052eb:	48 89 c6             	mov    %rax,%rsi
  8052ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8052f3:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8052fa:	00 00 00 
  8052fd:	ff d0                	callq  *%rax
}
  8052ff:	c9                   	leaveq 
  805300:	c3                   	retq   

0000000000805301 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805301:	55                   	push   %rbp
  805302:	48 89 e5             	mov    %rsp,%rbp
  805305:	48 83 ec 20          	sub    $0x20,%rsp
  805309:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80530c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805310:	75 35                	jne    805347 <wait+0x46>
  805312:	48 b9 2d 61 80 00 00 	movabs $0x80612d,%rcx
  805319:	00 00 00 
  80531c:	48 ba 38 61 80 00 00 	movabs $0x806138,%rdx
  805323:	00 00 00 
  805326:	be 09 00 00 00       	mov    $0x9,%esi
  80532b:	48 bf 4d 61 80 00 00 	movabs $0x80614d,%rdi
  805332:	00 00 00 
  805335:	b8 00 00 00 00       	mov    $0x0,%eax
  80533a:	49 b8 e4 08 80 00 00 	movabs $0x8008e4,%r8
  805341:	00 00 00 
  805344:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805347:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80534a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80534f:	48 63 d0             	movslq %eax,%rdx
  805352:	48 89 d0             	mov    %rdx,%rax
  805355:	48 c1 e0 03          	shl    $0x3,%rax
  805359:	48 01 d0             	add    %rdx,%rax
  80535c:	48 c1 e0 05          	shl    $0x5,%rax
  805360:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805367:	00 00 00 
  80536a:	48 01 d0             	add    %rdx,%rax
  80536d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  805371:	eb 0c                	jmp    80537f <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  805373:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  80537a:	00 00 00 
  80537d:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80537f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805383:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805389:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80538c:	75 0e                	jne    80539c <wait+0x9b>
  80538e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805392:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805398:	85 c0                	test   %eax,%eax
  80539a:	75 d7                	jne    805373 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80539c:	c9                   	leaveq 
  80539d:	c3                   	retq   

000000000080539e <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80539e:	55                   	push   %rbp
  80539f:	48 89 e5             	mov    %rsp,%rbp
  8053a2:	48 83 ec 10          	sub    $0x10,%rsp
  8053a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8053aa:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8053b1:	00 00 00 
  8053b4:	48 8b 00             	mov    (%rax),%rax
  8053b7:	48 85 c0             	test   %rax,%rax
  8053ba:	0f 85 84 00 00 00    	jne    805444 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8053c0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8053c7:	00 00 00 
  8053ca:	48 8b 00             	mov    (%rax),%rax
  8053cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8053d3:	ba 07 00 00 00       	mov    $0x7,%edx
  8053d8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8053dd:	89 c7                	mov    %eax,%edi
  8053df:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  8053e6:	00 00 00 
  8053e9:	ff d0                	callq  *%rax
  8053eb:	85 c0                	test   %eax,%eax
  8053ed:	79 2a                	jns    805419 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8053ef:	48 ba 58 61 80 00 00 	movabs $0x806158,%rdx
  8053f6:	00 00 00 
  8053f9:	be 23 00 00 00       	mov    $0x23,%esi
  8053fe:	48 bf 7f 61 80 00 00 	movabs $0x80617f,%rdi
  805405:	00 00 00 
  805408:	b8 00 00 00 00       	mov    $0x0,%eax
  80540d:	48 b9 e4 08 80 00 00 	movabs $0x8008e4,%rcx
  805414:	00 00 00 
  805417:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  805419:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  805420:	00 00 00 
  805423:	48 8b 00             	mov    (%rax),%rax
  805426:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80542c:	48 be 57 54 80 00 00 	movabs $0x805457,%rsi
  805433:	00 00 00 
  805436:	89 c7                	mov    %eax,%edi
  805438:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  80543f:	00 00 00 
  805442:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805444:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80544b:	00 00 00 
  80544e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805452:	48 89 10             	mov    %rdx,(%rax)
}
  805455:	c9                   	leaveq 
  805456:	c3                   	retq   

0000000000805457 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805457:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80545a:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  805461:	00 00 00 
call *%rax
  805464:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  805466:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80546d:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80546e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805475:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  805476:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80547a:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80547d:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805484:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  805485:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  805489:	4c 8b 3c 24          	mov    (%rsp),%r15
  80548d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805492:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805497:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80549c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8054a1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8054a6:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8054ab:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8054b0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8054b5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8054ba:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8054bf:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8054c4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8054c9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8054ce:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8054d3:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8054d7:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8054db:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8054dc:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8054dd:	c3                   	retq   

00000000008054de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8054de:	55                   	push   %rbp
  8054df:	48 89 e5             	mov    %rsp,%rbp
  8054e2:	48 83 ec 30          	sub    $0x30,%rsp
  8054e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8054ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8054ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8054f2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8054f9:	00 00 00 
  8054fc:	48 8b 00             	mov    (%rax),%rax
  8054ff:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805505:	85 c0                	test   %eax,%eax
  805507:	75 3c                	jne    805545 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  805509:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  805510:	00 00 00 
  805513:	ff d0                	callq  *%rax
  805515:	25 ff 03 00 00       	and    $0x3ff,%eax
  80551a:	48 63 d0             	movslq %eax,%rdx
  80551d:	48 89 d0             	mov    %rdx,%rax
  805520:	48 c1 e0 03          	shl    $0x3,%rax
  805524:	48 01 d0             	add    %rdx,%rax
  805527:	48 c1 e0 05          	shl    $0x5,%rax
  80552b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805532:	00 00 00 
  805535:	48 01 c2             	add    %rax,%rdx
  805538:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80553f:	00 00 00 
  805542:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805545:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80554a:	75 0e                	jne    80555a <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80554c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805553:	00 00 00 
  805556:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80555a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80555e:	48 89 c7             	mov    %rax,%rdi
  805561:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  805568:	00 00 00 
  80556b:	ff d0                	callq  *%rax
  80556d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805574:	79 19                	jns    80558f <ipc_recv+0xb1>
		*from_env_store = 0;
  805576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80557a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  805580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805584:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80558a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80558d:	eb 53                	jmp    8055e2 <ipc_recv+0x104>
	}
	if(from_env_store)
  80558f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805594:	74 19                	je     8055af <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  805596:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80559d:	00 00 00 
  8055a0:	48 8b 00             	mov    (%rax),%rax
  8055a3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8055a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055ad:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8055af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8055b4:	74 19                	je     8055cf <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8055b6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055bd:	00 00 00 
  8055c0:	48 8b 00             	mov    (%rax),%rax
  8055c3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8055c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055cd:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8055cf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8055d6:	00 00 00 
  8055d9:	48 8b 00             	mov    (%rax),%rax
  8055dc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8055e2:	c9                   	leaveq 
  8055e3:	c3                   	retq   

00000000008055e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8055e4:	55                   	push   %rbp
  8055e5:	48 89 e5             	mov    %rsp,%rbp
  8055e8:	48 83 ec 30          	sub    $0x30,%rsp
  8055ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055ef:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8055f2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8055f6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8055f9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8055fe:	75 0e                	jne    80560e <ipc_send+0x2a>
		pg = (void*)UTOP;
  805600:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805607:	00 00 00 
  80560a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80560e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805611:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805614:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805618:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80561b:	89 c7                	mov    %eax,%edi
  80561d:	48 b8 d5 21 80 00 00 	movabs $0x8021d5,%rax
  805624:	00 00 00 
  805627:	ff d0                	callq  *%rax
  805629:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80562c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805630:	75 0c                	jne    80563e <ipc_send+0x5a>
			sys_yield();
  805632:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  805639:	00 00 00 
  80563c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80563e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805642:	74 ca                	je     80560e <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  805644:	c9                   	leaveq 
  805645:	c3                   	retq   

0000000000805646 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805646:	55                   	push   %rbp
  805647:	48 89 e5             	mov    %rsp,%rbp
  80564a:	48 83 ec 14          	sub    $0x14,%rsp
  80564e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805651:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805658:	eb 5e                	jmp    8056b8 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80565a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805661:	00 00 00 
  805664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805667:	48 63 d0             	movslq %eax,%rdx
  80566a:	48 89 d0             	mov    %rdx,%rax
  80566d:	48 c1 e0 03          	shl    $0x3,%rax
  805671:	48 01 d0             	add    %rdx,%rax
  805674:	48 c1 e0 05          	shl    $0x5,%rax
  805678:	48 01 c8             	add    %rcx,%rax
  80567b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805681:	8b 00                	mov    (%rax),%eax
  805683:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805686:	75 2c                	jne    8056b4 <ipc_find_env+0x6e>
			return envs[i].env_id;
  805688:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80568f:	00 00 00 
  805692:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805695:	48 63 d0             	movslq %eax,%rdx
  805698:	48 89 d0             	mov    %rdx,%rax
  80569b:	48 c1 e0 03          	shl    $0x3,%rax
  80569f:	48 01 d0             	add    %rdx,%rax
  8056a2:	48 c1 e0 05          	shl    $0x5,%rax
  8056a6:	48 01 c8             	add    %rcx,%rax
  8056a9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8056af:	8b 40 08             	mov    0x8(%rax),%eax
  8056b2:	eb 12                	jmp    8056c6 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8056b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8056b8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8056bf:	7e 99                	jle    80565a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8056c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8056c6:	c9                   	leaveq 
  8056c7:	c3                   	retq   

00000000008056c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8056c8:	55                   	push   %rbp
  8056c9:	48 89 e5             	mov    %rsp,%rbp
  8056cc:	48 83 ec 18          	sub    $0x18,%rsp
  8056d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8056d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056d8:	48 c1 e8 15          	shr    $0x15,%rax
  8056dc:	48 89 c2             	mov    %rax,%rdx
  8056df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8056e6:	01 00 00 
  8056e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056ed:	83 e0 01             	and    $0x1,%eax
  8056f0:	48 85 c0             	test   %rax,%rax
  8056f3:	75 07                	jne    8056fc <pageref+0x34>
		return 0;
  8056f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8056fa:	eb 53                	jmp    80574f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8056fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805700:	48 c1 e8 0c          	shr    $0xc,%rax
  805704:	48 89 c2             	mov    %rax,%rdx
  805707:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80570e:	01 00 00 
  805711:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805715:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80571d:	83 e0 01             	and    $0x1,%eax
  805720:	48 85 c0             	test   %rax,%rax
  805723:	75 07                	jne    80572c <pageref+0x64>
		return 0;
  805725:	b8 00 00 00 00       	mov    $0x0,%eax
  80572a:	eb 23                	jmp    80574f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80572c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805730:	48 c1 e8 0c          	shr    $0xc,%rax
  805734:	48 89 c2             	mov    %rax,%rdx
  805737:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80573e:	00 00 00 
  805741:	48 c1 e2 04          	shl    $0x4,%rdx
  805745:	48 01 d0             	add    %rdx,%rax
  805748:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80574c:	0f b7 c0             	movzwl %ax,%eax
}
  80574f:	c9                   	leaveq 
  805750:	c3                   	retq   
