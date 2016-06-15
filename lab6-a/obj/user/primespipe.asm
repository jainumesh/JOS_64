
obj/user/primespipe.debug:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 00 4a 80 00 00 	movabs $0x804a00,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 41 4a 80 00 00 	movabs $0x804a41,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 c2 3d 80 00 00 	movabs $0x803dc2,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 45 4a 80 00 00 	movabs $0x804a45,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 4e 4a 80 00 00 	movabs $0x804a4e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 9f 2b 80 00 00 	movabs $0x802b9f,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 57 4a 80 00 00 	movabs $0x804a57,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba c2 04 80 00 00 	movabs $0x8004c2,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 14 2c 80 00 00 	movabs $0x802c14,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 73 4a 80 00 00 	movabs $0x804a73,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba c2 04 80 00 00 	movabs $0x8004c2,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 8d 4a 80 00 00 	movabs $0x804a8d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 c2 3d 80 00 00 	movabs $0x803dc2,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 45 4a 80 00 00 	movabs $0x804a45,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 4e 4a 80 00 00 	movabs $0x804a4e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 14 2c 80 00 00 	movabs $0x802c14,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 98 4a 80 00 00 	movabs $0x804a98,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 2f 4a 80 00 00 	movabs $0x804a2f,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800423:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800434:	48 63 d0             	movslq %eax,%rdx
  800437:	48 89 d0             	mov    %rdx,%rax
  80043a:	48 c1 e0 03          	shl    $0x3,%rax
  80043e:	48 01 d0             	add    %rdx,%rax
  800441:	48 c1 e0 05          	shl    $0x5,%rax
  800445:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80044c:	00 00 00 
  80044f:	48 01 c2             	add    %rax,%rdx
  800452:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800459:	00 00 00 
  80045c:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800463:	7e 14                	jle    800479 <libmain+0x65>
		binaryname = argv[0];
  800465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800469:	48 8b 10             	mov    (%rax),%rdx
  80046c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800473:	00 00 00 
  800476:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800479:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800491:	48 b8 9f 04 80 00 00 	movabs $0x80049f,%rax
  800498:	00 00 00 
  80049b:	ff d0                	callq  *%rax
}
  80049d:	c9                   	leaveq 
  80049e:	c3                   	retq   

000000000080049f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004a3:	48 b8 f3 28 80 00 00 	movabs $0x8028f3,%rax
  8004aa:	00 00 00 
  8004ad:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004af:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b4:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax

}
  8004c0:	5d                   	pop    %rbp
  8004c1:	c3                   	retq   

00000000008004c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c2:	55                   	push   %rbp
  8004c3:	48 89 e5             	mov    %rsp,%rbp
  8004c6:	53                   	push   %rbx
  8004c7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004ce:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004d5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004db:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004e9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f0:	84 c0                	test   %al,%al
  8004f2:	74 23                	je     800517 <_panic+0x55>
  8004f4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004fb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004ff:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800503:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800507:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80050b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80050f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800513:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800517:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80051e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800525:	00 00 00 
  800528:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80052f:	00 00 00 
  800532:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800536:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80053d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800544:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80054b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800552:	00 00 00 
  800555:	48 8b 18             	mov    (%rax),%rbx
  800558:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80055f:	00 00 00 
  800562:	ff d0                	callq  *%rax
  800564:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80056a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800571:	41 89 c8             	mov    %ecx,%r8d
  800574:	48 89 d1             	mov    %rdx,%rcx
  800577:	48 89 da             	mov    %rbx,%rdx
  80057a:	89 c6                	mov    %eax,%esi
  80057c:	48 bf c0 4a 80 00 00 	movabs $0x804ac0,%rdi
  800583:	00 00 00 
  800586:	b8 00 00 00 00       	mov    $0x0,%eax
  80058b:	49 b9 fb 06 80 00 00 	movabs $0x8006fb,%r9
  800592:	00 00 00 
  800595:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800598:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80059f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a6:	48 89 d6             	mov    %rdx,%rsi
  8005a9:	48 89 c7             	mov    %rax,%rdi
  8005ac:	48 b8 4f 06 80 00 00 	movabs $0x80064f,%rax
  8005b3:	00 00 00 
  8005b6:	ff d0                	callq  *%rax
	cprintf("\n");
  8005b8:	48 bf e3 4a 80 00 00 	movabs $0x804ae3,%rdi
  8005bf:	00 00 00 
  8005c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c7:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8005ce:	00 00 00 
  8005d1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d3:	cc                   	int3   
  8005d4:	eb fd                	jmp    8005d3 <_panic+0x111>

00000000008005d6 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005d6:	55                   	push   %rbp
  8005d7:	48 89 e5             	mov    %rsp,%rbp
  8005da:	48 83 ec 10          	sub    $0x10,%rsp
  8005de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	8d 48 01             	lea    0x1(%rax),%ecx
  8005ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f2:	89 0a                	mov    %ecx,(%rdx)
  8005f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005f7:	89 d1                	mov    %edx,%ecx
  8005f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005fd:	48 98                	cltq   
  8005ff:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800607:	8b 00                	mov    (%rax),%eax
  800609:	3d ff 00 00 00       	cmp    $0xff,%eax
  80060e:	75 2c                	jne    80063c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800614:	8b 00                	mov    (%rax),%eax
  800616:	48 98                	cltq   
  800618:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061c:	48 83 c2 08          	add    $0x8,%rdx
  800620:	48 89 c6             	mov    %rax,%rsi
  800623:	48 89 d7             	mov    %rdx,%rdi
  800626:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  80062d:	00 00 00 
  800630:	ff d0                	callq  *%rax
        b->idx = 0;
  800632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800636:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 40 04             	mov    0x4(%rax),%eax
  800643:	8d 50 01             	lea    0x1(%rax),%edx
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80064d:	c9                   	leaveq 
  80064e:	c3                   	retq   

000000000080064f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80064f:	55                   	push   %rbp
  800650:	48 89 e5             	mov    %rsp,%rbp
  800653:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80065a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800661:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800668:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80066f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800676:	48 8b 0a             	mov    (%rdx),%rcx
  800679:	48 89 08             	mov    %rcx,(%rax)
  80067c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800680:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800684:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800688:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80068c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800693:	00 00 00 
    b.cnt = 0;
  800696:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80069d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006a0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006a7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006ae:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006b5:	48 89 c6             	mov    %rax,%rsi
  8006b8:	48 bf d6 05 80 00 00 	movabs $0x8005d6,%rdi
  8006bf:	00 00 00 
  8006c2:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006ce:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006d4:	48 98                	cltq   
  8006d6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006dd:	48 83 c2 08          	add    $0x8,%rdx
  8006e1:	48 89 c6             	mov    %rax,%rsi
  8006e4:	48 89 d7             	mov    %rdx,%rdi
  8006e7:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8006ee:	00 00 00 
  8006f1:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006f9:	c9                   	leaveq 
  8006fa:	c3                   	retq   

00000000008006fb <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006fb:	55                   	push   %rbp
  8006fc:	48 89 e5             	mov    %rsp,%rbp
  8006ff:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800706:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80070d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800714:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80071b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800722:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800729:	84 c0                	test   %al,%al
  80072b:	74 20                	je     80074d <cprintf+0x52>
  80072d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800731:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800735:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800739:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80073d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800741:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800745:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800749:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80074d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800754:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80075b:	00 00 00 
  80075e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800765:	00 00 00 
  800768:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80076c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800773:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80077a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800781:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800788:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80078f:	48 8b 0a             	mov    (%rdx),%rcx
  800792:	48 89 08             	mov    %rcx,(%rax)
  800795:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800799:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80079d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007a5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b3:	48 89 d6             	mov    %rdx,%rsi
  8007b6:	48 89 c7             	mov    %rax,%rdi
  8007b9:	48 b8 4f 06 80 00 00 	movabs $0x80064f,%rax
  8007c0:	00 00 00 
  8007c3:	ff d0                	callq  *%rax
  8007c5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007cb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d1:	c9                   	leaveq 
  8007d2:	c3                   	retq   

00000000008007d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d3:	55                   	push   %rbp
  8007d4:	48 89 e5             	mov    %rsp,%rbp
  8007d7:	53                   	push   %rbx
  8007d8:	48 83 ec 38          	sub    $0x38,%rsp
  8007dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007e8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007eb:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007ef:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007fa:	77 3b                	ja     800837 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8007ff:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800803:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	48 f7 f3             	div    %rbx
  800812:	48 89 c2             	mov    %rax,%rdx
  800815:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800818:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80081b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	41 89 f9             	mov    %edi,%r9d
  800826:	48 89 c7             	mov    %rax,%rdi
  800829:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800830:	00 00 00 
  800833:	ff d0                	callq  *%rax
  800835:	eb 1e                	jmp    800855 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800837:	eb 12                	jmp    80084b <printnum+0x78>
			putch(padc, putdat);
  800839:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80083d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 89 ce             	mov    %rcx,%rsi
  800847:	89 d7                	mov    %edx,%edi
  800849:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80084f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800853:	7f e4                	jg     800839 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800855:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085c:	ba 00 00 00 00       	mov    $0x0,%edx
  800861:	48 f7 f1             	div    %rcx
  800864:	48 89 d0             	mov    %rdx,%rax
  800867:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  80086e:	00 00 00 
  800871:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800875:	0f be d0             	movsbl %al,%edx
  800878:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 89 ce             	mov    %rcx,%rsi
  800883:	89 d7                	mov    %edx,%edi
  800885:	ff d0                	callq  *%rax
}
  800887:	48 83 c4 38          	add    $0x38,%rsp
  80088b:	5b                   	pop    %rbx
  80088c:	5d                   	pop    %rbp
  80088d:	c3                   	retq   

000000000080088e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088e:	55                   	push   %rbp
  80088f:	48 89 e5             	mov    %rsp,%rbp
  800892:	48 83 ec 1c          	sub    $0x1c,%rsp
  800896:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80089a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80089d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a1:	7e 52                	jle    8008f5 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	83 f8 30             	cmp    $0x30,%eax
  8008ac:	73 24                	jae    8008d2 <getuint+0x44>
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ba:	8b 00                	mov    (%rax),%eax
  8008bc:	89 c0                	mov    %eax,%eax
  8008be:	48 01 d0             	add    %rdx,%rax
  8008c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c5:	8b 12                	mov    (%rdx),%edx
  8008c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ce:	89 0a                	mov    %ecx,(%rdx)
  8008d0:	eb 17                	jmp    8008e9 <getuint+0x5b>
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008da:	48 89 d0             	mov    %rdx,%rax
  8008dd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e9:	48 8b 00             	mov    (%rax),%rax
  8008ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f0:	e9 a3 00 00 00       	jmpq   800998 <getuint+0x10a>
	else if (lflag)
  8008f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f9:	74 4f                	je     80094a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ff:	8b 00                	mov    (%rax),%eax
  800901:	83 f8 30             	cmp    $0x30,%eax
  800904:	73 24                	jae    80092a <getuint+0x9c>
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	8b 00                	mov    (%rax),%eax
  800914:	89 c0                	mov    %eax,%eax
  800916:	48 01 d0             	add    %rdx,%rax
  800919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091d:	8b 12                	mov    (%rdx),%edx
  80091f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800926:	89 0a                	mov    %ecx,(%rdx)
  800928:	eb 17                	jmp    800941 <getuint+0xb3>
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800932:	48 89 d0             	mov    %rdx,%rax
  800935:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800941:	48 8b 00             	mov    (%rax),%rax
  800944:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800948:	eb 4e                	jmp    800998 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	83 f8 30             	cmp    $0x30,%eax
  800953:	73 24                	jae    800979 <getuint+0xeb>
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	8b 00                	mov    (%rax),%eax
  800963:	89 c0                	mov    %eax,%eax
  800965:	48 01 d0             	add    %rdx,%rax
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	8b 12                	mov    (%rdx),%edx
  80096e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	89 0a                	mov    %ecx,(%rdx)
  800977:	eb 17                	jmp    800990 <getuint+0x102>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800981:	48 89 d0             	mov    %rdx,%rax
  800984:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800990:	8b 00                	mov    (%rax),%eax
  800992:	89 c0                	mov    %eax,%eax
  800994:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80099c:	c9                   	leaveq 
  80099d:	c3                   	retq   

000000000080099e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80099e:	55                   	push   %rbp
  80099f:	48 89 e5             	mov    %rsp,%rbp
  8009a2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009aa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009ad:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b1:	7e 52                	jle    800a05 <getint+0x67>
		x=va_arg(*ap, long long);
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	83 f8 30             	cmp    $0x30,%eax
  8009bc:	73 24                	jae    8009e2 <getint+0x44>
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	89 c0                	mov    %eax,%eax
  8009ce:	48 01 d0             	add    %rdx,%rax
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	8b 12                	mov    (%rdx),%edx
  8009d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	89 0a                	mov    %ecx,(%rdx)
  8009e0:	eb 17                	jmp    8009f9 <getint+0x5b>
  8009e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ea:	48 89 d0             	mov    %rdx,%rax
  8009ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f9:	48 8b 00             	mov    (%rax),%rax
  8009fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a00:	e9 a3 00 00 00       	jmpq   800aa8 <getint+0x10a>
	else if (lflag)
  800a05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a09:	74 4f                	je     800a5a <getint+0xbc>
		x=va_arg(*ap, long);
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	83 f8 30             	cmp    $0x30,%eax
  800a14:	73 24                	jae    800a3a <getint+0x9c>
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	8b 12                	mov    (%rdx),%edx
  800a2f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a36:	89 0a                	mov    %ecx,(%rdx)
  800a38:	eb 17                	jmp    800a51 <getint+0xb3>
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a42:	48 89 d0             	mov    %rdx,%rax
  800a45:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a51:	48 8b 00             	mov    (%rax),%rax
  800a54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a58:	eb 4e                	jmp    800aa8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 24                	jae    800a89 <getint+0xeb>
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	89 c0                	mov    %eax,%eax
  800a75:	48 01 d0             	add    %rdx,%rax
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	8b 12                	mov    (%rdx),%edx
  800a7e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a85:	89 0a                	mov    %ecx,(%rdx)
  800a87:	eb 17                	jmp    800aa0 <getint+0x102>
  800a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a91:	48 89 d0             	mov    %rdx,%rax
  800a94:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa0:	8b 00                	mov    (%rax),%eax
  800aa2:	48 98                	cltq   
  800aa4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aac:	c9                   	leaveq 
  800aad:	c3                   	retq   

0000000000800aae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aae:	55                   	push   %rbp
  800aaf:	48 89 e5             	mov    %rsp,%rbp
  800ab2:	41 54                	push   %r12
  800ab4:	53                   	push   %rbx
  800ab5:	48 83 ec 60          	sub    $0x60,%rsp
  800ab9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800abd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ac1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ac5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ac9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800acd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ad1:	48 8b 0a             	mov    (%rdx),%rcx
  800ad4:	48 89 08             	mov    %rcx,(%rax)
  800ad7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800adb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800adf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ae3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ae7:	eb 17                	jmp    800b00 <vprintfmt+0x52>
			if (ch == '\0')
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	0f 84 cc 04 00 00    	je     800fbd <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800af1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af9:	48 89 d6             	mov    %rdx,%rsi
  800afc:	89 df                	mov    %ebx,%edi
  800afe:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b04:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b08:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b0c:	0f b6 00             	movzbl (%rax),%eax
  800b0f:	0f b6 d8             	movzbl %al,%ebx
  800b12:	83 fb 25             	cmp    $0x25,%ebx
  800b15:	75 d2                	jne    800ae9 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b17:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b1b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b22:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b30:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b37:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b43:	0f b6 00             	movzbl (%rax),%eax
  800b46:	0f b6 d8             	movzbl %al,%ebx
  800b49:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b4c:	83 f8 55             	cmp    $0x55,%eax
  800b4f:	0f 87 34 04 00 00    	ja     800f89 <vprintfmt+0x4db>
  800b55:	89 c0                	mov    %eax,%eax
  800b57:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b5e:	00 
  800b5f:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  800b66:	00 00 00 
  800b69:	48 01 d0             	add    %rdx,%rax
  800b6c:	48 8b 00             	mov    (%rax),%rax
  800b6f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b71:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b75:	eb c0                	jmp    800b37 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b77:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b7b:	eb ba                	jmp    800b37 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b7d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b84:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b87:	89 d0                	mov    %edx,%eax
  800b89:	c1 e0 02             	shl    $0x2,%eax
  800b8c:	01 d0                	add    %edx,%eax
  800b8e:	01 c0                	add    %eax,%eax
  800b90:	01 d8                	add    %ebx,%eax
  800b92:	83 e8 30             	sub    $0x30,%eax
  800b95:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b98:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9c:	0f b6 00             	movzbl (%rax),%eax
  800b9f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ba2:	83 fb 2f             	cmp    $0x2f,%ebx
  800ba5:	7e 0c                	jle    800bb3 <vprintfmt+0x105>
  800ba7:	83 fb 39             	cmp    $0x39,%ebx
  800baa:	7f 07                	jg     800bb3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bac:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb1:	eb d1                	jmp    800b84 <vprintfmt+0xd6>
			goto process_precision;
  800bb3:	eb 58                	jmp    800c0d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb8:	83 f8 30             	cmp    $0x30,%eax
  800bbb:	73 17                	jae    800bd4 <vprintfmt+0x126>
  800bbd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc4:	89 c0                	mov    %eax,%eax
  800bc6:	48 01 d0             	add    %rdx,%rax
  800bc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcc:	83 c2 08             	add    $0x8,%edx
  800bcf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd2:	eb 0f                	jmp    800be3 <vprintfmt+0x135>
  800bd4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd8:	48 89 d0             	mov    %rdx,%rax
  800bdb:	48 83 c2 08          	add    $0x8,%rdx
  800bdf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be3:	8b 00                	mov    (%rax),%eax
  800be5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800be8:	eb 23                	jmp    800c0d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800bea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bee:	79 0c                	jns    800bfc <vprintfmt+0x14e>
				width = 0;
  800bf0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bf7:	e9 3b ff ff ff       	jmpq   800b37 <vprintfmt+0x89>
  800bfc:	e9 36 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c01:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c08:	e9 2a ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c11:	79 12                	jns    800c25 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c16:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c19:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c20:	e9 12 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>
  800c25:	e9 0d ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c2a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c2e:	e9 04 ff ff ff       	jmpq   800b37 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c36:	83 f8 30             	cmp    $0x30,%eax
  800c39:	73 17                	jae    800c52 <vprintfmt+0x1a4>
  800c3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c42:	89 c0                	mov    %eax,%eax
  800c44:	48 01 d0             	add    %rdx,%rax
  800c47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4a:	83 c2 08             	add    $0x8,%edx
  800c4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c50:	eb 0f                	jmp    800c61 <vprintfmt+0x1b3>
  800c52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c56:	48 89 d0             	mov    %rdx,%rax
  800c59:	48 83 c2 08          	add    $0x8,%rdx
  800c5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c61:	8b 10                	mov    (%rax),%edx
  800c63:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 ce             	mov    %rcx,%rsi
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	ff d0                	callq  *%rax
			break;
  800c72:	e9 40 03 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7a:	83 f8 30             	cmp    $0x30,%eax
  800c7d:	73 17                	jae    800c96 <vprintfmt+0x1e8>
  800c7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 01 d0             	add    %rdx,%rax
  800c8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8e:	83 c2 08             	add    $0x8,%edx
  800c91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c94:	eb 0f                	jmp    800ca5 <vprintfmt+0x1f7>
  800c96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9a:	48 89 d0             	mov    %rdx,%rax
  800c9d:	48 83 c2 08          	add    $0x8,%rdx
  800ca1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	79 02                	jns    800cad <vprintfmt+0x1ff>
				err = -err;
  800cab:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cad:	83 fb 15             	cmp    $0x15,%ebx
  800cb0:	7f 16                	jg     800cc8 <vprintfmt+0x21a>
  800cb2:	48 b8 40 4c 80 00 00 	movabs $0x804c40,%rax
  800cb9:	00 00 00 
  800cbc:	48 63 d3             	movslq %ebx,%rdx
  800cbf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc3:	4d 85 e4             	test   %r12,%r12
  800cc6:	75 2e                	jne    800cf6 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cc8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	89 d9                	mov    %ebx,%ecx
  800cd2:	48 ba 01 4d 80 00 00 	movabs $0x804d01,%rdx
  800cd9:	00 00 00 
  800cdc:	48 89 c7             	mov    %rax,%rdi
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce4:	49 b8 c6 0f 80 00 00 	movabs $0x800fc6,%r8
  800ceb:	00 00 00 
  800cee:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf1:	e9 c1 02 00 00       	jmpq   800fb7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cf6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfe:	4c 89 e1             	mov    %r12,%rcx
  800d01:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  800d08:	00 00 00 
  800d0b:	48 89 c7             	mov    %rax,%rdi
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	49 b8 c6 0f 80 00 00 	movabs $0x800fc6,%r8
  800d1a:	00 00 00 
  800d1d:	41 ff d0             	callq  *%r8
			break;
  800d20:	e9 92 02 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 17                	jae    800d44 <vprintfmt+0x296>
  800d2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d34:	89 c0                	mov    %eax,%eax
  800d36:	48 01 d0             	add    %rdx,%rax
  800d39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3c:	83 c2 08             	add    $0x8,%edx
  800d3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d42:	eb 0f                	jmp    800d53 <vprintfmt+0x2a5>
  800d44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d48:	48 89 d0             	mov    %rdx,%rax
  800d4b:	48 83 c2 08          	add    $0x8,%rdx
  800d4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d53:	4c 8b 20             	mov    (%rax),%r12
  800d56:	4d 85 e4             	test   %r12,%r12
  800d59:	75 0a                	jne    800d65 <vprintfmt+0x2b7>
				p = "(null)";
  800d5b:	49 bc 0d 4d 80 00 00 	movabs $0x804d0d,%r12
  800d62:	00 00 00 
			if (width > 0 && padc != '-')
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d69:	7e 3f                	jle    800daa <vprintfmt+0x2fc>
  800d6b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d6f:	74 39                	je     800daa <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d71:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d74:	48 98                	cltq   
  800d76:	48 89 c6             	mov    %rax,%rsi
  800d79:	4c 89 e7             	mov    %r12,%rdi
  800d7c:	48 b8 72 12 80 00 00 	movabs $0x801272,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
  800d88:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d8b:	eb 17                	jmp    800da4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d8d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d91:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 ce             	mov    %rcx,%rsi
  800d9c:	89 d7                	mov    %edx,%edi
  800d9e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da8:	7f e3                	jg     800d8d <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800daa:	eb 37                	jmp    800de3 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800dac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db0:	74 1e                	je     800dd0 <vprintfmt+0x322>
  800db2:	83 fb 1f             	cmp    $0x1f,%ebx
  800db5:	7e 05                	jle    800dbc <vprintfmt+0x30e>
  800db7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dba:	7e 14                	jle    800dd0 <vprintfmt+0x322>
					putch('?', putdat);
  800dbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dcc:	ff d0                	callq  *%rax
  800dce:	eb 0f                	jmp    800ddf <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800dd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd8:	48 89 d6             	mov    %rdx,%rsi
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de3:	4c 89 e0             	mov    %r12,%rax
  800de6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800dea:	0f b6 00             	movzbl (%rax),%eax
  800ded:	0f be d8             	movsbl %al,%ebx
  800df0:	85 db                	test   %ebx,%ebx
  800df2:	74 10                	je     800e04 <vprintfmt+0x356>
  800df4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800df8:	78 b2                	js     800dac <vprintfmt+0x2fe>
  800dfa:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800dfe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e02:	79 a8                	jns    800dac <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e04:	eb 16                	jmp    800e1c <vprintfmt+0x36e>
				putch(' ', putdat);
  800e06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	48 89 d6             	mov    %rdx,%rsi
  800e11:	bf 20 00 00 00       	mov    $0x20,%edi
  800e16:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e18:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e20:	7f e4                	jg     800e06 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e22:	e9 90 01 00 00       	jmpq   800fb7 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2b:	be 03 00 00 00       	mov    $0x3,%esi
  800e30:	48 89 c7             	mov    %rax,%rdi
  800e33:	48 b8 9e 09 80 00 00 	movabs $0x80099e,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
  800e3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e47:	48 85 c0             	test   %rax,%rax
  800e4a:	79 1d                	jns    800e69 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e54:	48 89 d6             	mov    %rdx,%rsi
  800e57:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e5c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e62:	48 f7 d8             	neg    %rax
  800e65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e69:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e70:	e9 d5 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e79:	be 03 00 00 00       	mov    $0x3,%esi
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 8e 08 80 00 00 	movabs $0x80088e,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e91:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e98:	e9 ad 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e9d:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ea0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea4:	89 d6                	mov    %edx,%esi
  800ea6:	48 89 c7             	mov    %rax,%rdi
  800ea9:	48 b8 9e 09 80 00 00 	movabs $0x80099e,%rax
  800eb0:	00 00 00 
  800eb3:	ff d0                	callq  *%rax
  800eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800eb9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ec0:	e9 85 00 00 00       	jmpq   800f4a <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ec5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecd:	48 89 d6             	mov    %rdx,%rsi
  800ed0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ed5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ed7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 d6             	mov    %rdx,%rsi
  800ee2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ee7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ee9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eec:	83 f8 30             	cmp    $0x30,%eax
  800eef:	73 17                	jae    800f08 <vprintfmt+0x45a>
  800ef1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ef5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef8:	89 c0                	mov    %eax,%eax
  800efa:	48 01 d0             	add    %rdx,%rax
  800efd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f00:	83 c2 08             	add    $0x8,%edx
  800f03:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f06:	eb 0f                	jmp    800f17 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f0c:	48 89 d0             	mov    %rdx,%rax
  800f0f:	48 83 c2 08          	add    $0x8,%rdx
  800f13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f17:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f1e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f25:	eb 23                	jmp    800f4a <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f2b:	be 03 00 00 00       	mov    $0x3,%esi
  800f30:	48 89 c7             	mov    %rax,%rdi
  800f33:	48 b8 8e 08 80 00 00 	movabs $0x80088e,%rax
  800f3a:	00 00 00 
  800f3d:	ff d0                	callq  *%rax
  800f3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f43:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f4f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f52:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	45 89 c1             	mov    %r8d,%r9d
  800f64:	41 89 f8             	mov    %edi,%r8d
  800f67:	48 89 c7             	mov    %rax,%rdi
  800f6a:	48 b8 d3 07 80 00 00 	movabs $0x8007d3,%rax
  800f71:	00 00 00 
  800f74:	ff d0                	callq  *%rax
			break;
  800f76:	eb 3f                	jmp    800fb7 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f80:	48 89 d6             	mov    %rdx,%rsi
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	ff d0                	callq  *%rax
			break;
  800f87:	eb 2e                	jmp    800fb7 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f91:	48 89 d6             	mov    %rdx,%rsi
  800f94:	bf 25 00 00 00       	mov    $0x25,%edi
  800f99:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fa0:	eb 05                	jmp    800fa7 <vprintfmt+0x4f9>
  800fa2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fa7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fab:	48 83 e8 01          	sub    $0x1,%rax
  800faf:	0f b6 00             	movzbl (%rax),%eax
  800fb2:	3c 25                	cmp    $0x25,%al
  800fb4:	75 ec                	jne    800fa2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800fb6:	90                   	nop
		}
	}
  800fb7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fb8:	e9 43 fb ff ff       	jmpq   800b00 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fbd:	48 83 c4 60          	add    $0x60,%rsp
  800fc1:	5b                   	pop    %rbx
  800fc2:	41 5c                	pop    %r12
  800fc4:	5d                   	pop    %rbp
  800fc5:	c3                   	retq   

0000000000800fc6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fd1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fd8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fdf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fe6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ff4:	84 c0                	test   %al,%al
  800ff6:	74 20                	je     801018 <printfmt+0x52>
  800ff8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ffc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801000:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801004:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801008:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80100c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801010:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801014:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801018:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80101f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801026:	00 00 00 
  801029:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801030:	00 00 00 
  801033:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801037:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80103e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801045:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80104c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801053:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80105a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801061:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801068:	48 89 c7             	mov    %rax,%rdi
  80106b:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  801072:	00 00 00 
  801075:	ff d0                	callq  *%rax
	va_end(ap);
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 10          	sub    $0x10,%rsp
  801081:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801084:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108c:	8b 40 10             	mov    0x10(%rax),%eax
  80108f:	8d 50 01             	lea    0x1(%rax),%edx
  801092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801096:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109d:	48 8b 10             	mov    (%rax),%rdx
  8010a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010a8:	48 39 c2             	cmp    %rax,%rdx
  8010ab:	73 17                	jae    8010c4 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b1:	48 8b 00             	mov    (%rax),%rax
  8010b4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010bc:	48 89 0a             	mov    %rcx,(%rdx)
  8010bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010c2:	88 10                	mov    %dl,(%rax)
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 83 ec 50          	sub    $0x50,%rsp
  8010ce:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010d2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010d5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010d9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010dd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010e1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010e5:	48 8b 0a             	mov    (%rdx),%rcx
  8010e8:	48 89 08             	mov    %rcx,(%rax)
  8010eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ff:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801103:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801106:	48 98                	cltq   
  801108:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80110c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801110:	48 01 d0             	add    %rdx,%rax
  801113:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801117:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80111e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801123:	74 06                	je     80112b <vsnprintf+0x65>
  801125:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801129:	7f 07                	jg     801132 <vsnprintf+0x6c>
		return -E_INVAL;
  80112b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801130:	eb 2f                	jmp    801161 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801132:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801136:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80113a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80113e:	48 89 c6             	mov    %rax,%rsi
  801141:	48 bf 79 10 80 00 00 	movabs $0x801079,%rdi
  801148:	00 00 00 
  80114b:	48 b8 ae 0a 80 00 00 	movabs $0x800aae,%rax
  801152:	00 00 00 
  801155:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801157:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80115b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80115e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80116e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801175:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80117b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801182:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801189:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801190:	84 c0                	test   %al,%al
  801192:	74 20                	je     8011b4 <snprintf+0x51>
  801194:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801198:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80119c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011a0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011a4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011a8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011ac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011b0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011b4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011bb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011c2:	00 00 00 
  8011c5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011cc:	00 00 00 
  8011cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011d3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011da:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011e1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011e8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011ef:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011f6:	48 8b 0a             	mov    (%rdx),%rcx
  8011f9:	48 89 08             	mov    %rcx,(%rax)
  8011fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801200:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801204:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801208:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80120c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801213:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80121a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801220:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801227:	48 89 c7             	mov    %rax,%rdi
  80122a:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  801231:	00 00 00 
  801234:	ff d0                	callq  *%rax
  801236:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80123c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801242:	c9                   	leaveq 
  801243:	c3                   	retq   

0000000000801244 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	48 83 ec 18          	sub    $0x18,%rsp
  80124c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801257:	eb 09                	jmp    801262 <strlen+0x1e>
		n++;
  801259:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80125d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	84 c0                	test   %al,%al
  80126b:	75 ec                	jne    801259 <strlen+0x15>
		n++;
	return n;
  80126d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 83 ec 20          	sub    $0x20,%rsp
  80127a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801289:	eb 0e                	jmp    801299 <strnlen+0x27>
		n++;
  80128b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801294:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801299:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80129e:	74 0b                	je     8012ab <strnlen+0x39>
  8012a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a4:	0f b6 00             	movzbl (%rax),%eax
  8012a7:	84 c0                	test   %al,%al
  8012a9:	75 e0                	jne    80128b <strnlen+0x19>
		n++;
	return n;
  8012ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 20          	sub    $0x20,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012c8:	90                   	nop
  8012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012dd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012e1:	0f b6 12             	movzbl (%rdx),%edx
  8012e4:	88 10                	mov    %dl,(%rax)
  8012e6:	0f b6 00             	movzbl (%rax),%eax
  8012e9:	84 c0                	test   %al,%al
  8012eb:	75 dc                	jne    8012c9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f1:	c9                   	leaveq 
  8012f2:	c3                   	retq   

00000000008012f3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012f3:	55                   	push   %rbp
  8012f4:	48 89 e5             	mov    %rsp,%rbp
  8012f7:	48 83 ec 20          	sub    $0x20,%rsp
  8012fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801307:	48 89 c7             	mov    %rax,%rdi
  80130a:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  801311:	00 00 00 
  801314:	ff d0                	callq  *%rax
  801316:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80131c:	48 63 d0             	movslq %eax,%rdx
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 01 c2             	add    %rax,%rdx
  801326:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132a:	48 89 c6             	mov    %rax,%rsi
  80132d:	48 89 d7             	mov    %rdx,%rdi
  801330:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
	return dst;
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 28          	sub    $0x28,%rsp
  80134a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801352:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80135e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801365:	00 
  801366:	eb 2a                	jmp    801392 <strncpy+0x50>
		*dst++ = *src;
  801368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801370:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801374:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801378:	0f b6 12             	movzbl (%rdx),%edx
  80137b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80137d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	84 c0                	test   %al,%al
  801386:	74 05                	je     80138d <strncpy+0x4b>
			src++;
  801388:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801396:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80139a:	72 cc                	jb     801368 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80139c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013a0:	c9                   	leaveq 
  8013a1:	c3                   	retq   

00000000008013a2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 83 ec 28          	sub    $0x28,%rsp
  8013aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c3:	74 3d                	je     801402 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013c5:	eb 1d                	jmp    8013e4 <strlcpy+0x42>
			*dst++ = *src++;
  8013c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013db:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013df:	0f b6 12             	movzbl (%rdx),%edx
  8013e2:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013ee:	74 0b                	je     8013fb <strlcpy+0x59>
  8013f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	84 c0                	test   %al,%al
  8013f9:	75 cc                	jne    8013c7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ff:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801402:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	48 29 c2             	sub    %rax,%rdx
  80140d:	48 89 d0             	mov    %rdx,%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 10          	sub    $0x10,%rsp
  80141a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801422:	eb 0a                	jmp    80142e <strcmp+0x1c>
		p++, q++;
  801424:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801429:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	84 c0                	test   %al,%al
  801437:	74 12                	je     80144b <strcmp+0x39>
  801439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143d:	0f b6 10             	movzbl (%rax),%edx
  801440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	38 c2                	cmp    %al,%dl
  801449:	74 d9                	je     801424 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	0f b6 c0             	movzbl %al,%eax
  80145f:	29 c2                	sub    %eax,%edx
  801461:	89 d0                	mov    %edx,%eax
}
  801463:	c9                   	leaveq 
  801464:	c3                   	retq   

0000000000801465 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801465:	55                   	push   %rbp
  801466:	48 89 e5             	mov    %rsp,%rbp
  801469:	48 83 ec 18          	sub    $0x18,%rsp
  80146d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801471:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801475:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801479:	eb 0f                	jmp    80148a <strncmp+0x25>
		n--, p++, q++;
  80147b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801480:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801485:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80148a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148f:	74 1d                	je     8014ae <strncmp+0x49>
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	84 c0                	test   %al,%al
  80149a:	74 12                	je     8014ae <strncmp+0x49>
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 10             	movzbl (%rax),%edx
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	38 c2                	cmp    %al,%dl
  8014ac:	74 cd                	je     80147b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014b3:	75 07                	jne    8014bc <strncmp+0x57>
		return 0;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 18                	jmp    8014d4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	0f b6 d0             	movzbl %al,%edx
  8014c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ca:	0f b6 00             	movzbl (%rax),%eax
  8014cd:	0f b6 c0             	movzbl %al,%eax
  8014d0:	29 c2                	sub    %eax,%edx
  8014d2:	89 d0                	mov    %edx,%eax
}
  8014d4:	c9                   	leaveq 
  8014d5:	c3                   	retq   

00000000008014d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d6:	55                   	push   %rbp
  8014d7:	48 89 e5             	mov    %rsp,%rbp
  8014da:	48 83 ec 0c          	sub    $0xc,%rsp
  8014de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e2:	89 f0                	mov    %esi,%eax
  8014e4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014e7:	eb 17                	jmp    801500 <strchr+0x2a>
		if (*s == c)
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014f3:	75 06                	jne    8014fb <strchr+0x25>
			return (char *) s;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	eb 15                	jmp    801510 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	84 c0                	test   %al,%al
  801509:	75 de                	jne    8014e9 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leaveq 
  801511:	c3                   	retq   

0000000000801512 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801512:	55                   	push   %rbp
  801513:	48 89 e5             	mov    %rsp,%rbp
  801516:	48 83 ec 0c          	sub    $0xc,%rsp
  80151a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151e:	89 f0                	mov    %esi,%eax
  801520:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801523:	eb 13                	jmp    801538 <strfind+0x26>
		if (*s == c)
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80152f:	75 02                	jne    801533 <strfind+0x21>
			break;
  801531:	eb 10                	jmp    801543 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801533:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	84 c0                	test   %al,%al
  801541:	75 e2                	jne    801525 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801547:	c9                   	leaveq 
  801548:	c3                   	retq   

0000000000801549 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801549:	55                   	push   %rbp
  80154a:	48 89 e5             	mov    %rsp,%rbp
  80154d:	48 83 ec 18          	sub    $0x18,%rsp
  801551:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801555:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801558:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80155c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801561:	75 06                	jne    801569 <memset+0x20>
		return v;
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	eb 69                	jmp    8015d2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	83 e0 03             	and    $0x3,%eax
  801570:	48 85 c0             	test   %rax,%rax
  801573:	75 48                	jne    8015bd <memset+0x74>
  801575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801579:	83 e0 03             	and    $0x3,%eax
  80157c:	48 85 c0             	test   %rax,%rax
  80157f:	75 3c                	jne    8015bd <memset+0x74>
		c &= 0xFF;
  801581:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801588:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158b:	c1 e0 18             	shl    $0x18,%eax
  80158e:	89 c2                	mov    %eax,%edx
  801590:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801593:	c1 e0 10             	shl    $0x10,%eax
  801596:	09 c2                	or     %eax,%edx
  801598:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80159b:	c1 e0 08             	shl    $0x8,%eax
  80159e:	09 d0                	or     %edx,%eax
  8015a0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a7:	48 c1 e8 02          	shr    $0x2,%rax
  8015ab:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b5:	48 89 d7             	mov    %rdx,%rdi
  8015b8:	fc                   	cld    
  8015b9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015bb:	eb 11                	jmp    8015ce <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015c8:	48 89 d7             	mov    %rdx,%rdi
  8015cb:	fc                   	cld    
  8015cc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015d2:	c9                   	leaveq 
  8015d3:	c3                   	retq   

00000000008015d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015d4:	55                   	push   %rbp
  8015d5:	48 89 e5             	mov    %rsp,%rbp
  8015d8:	48 83 ec 28          	sub    $0x28,%rsp
  8015dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801600:	0f 83 88 00 00 00    	jae    80168e <memmove+0xba>
  801606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	48 01 d0             	add    %rdx,%rax
  801611:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801615:	76 77                	jbe    80168e <memmove+0xba>
		s += n;
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162b:	83 e0 03             	and    $0x3,%eax
  80162e:	48 85 c0             	test   %rax,%rax
  801631:	75 3b                	jne    80166e <memmove+0x9a>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	83 e0 03             	and    $0x3,%eax
  80163a:	48 85 c0             	test   %rax,%rax
  80163d:	75 2f                	jne    80166e <memmove+0x9a>
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	83 e0 03             	and    $0x3,%eax
  801646:	48 85 c0             	test   %rax,%rax
  801649:	75 23                	jne    80166e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80164b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164f:	48 83 e8 04          	sub    $0x4,%rax
  801653:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801657:	48 83 ea 04          	sub    $0x4,%rdx
  80165b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80165f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801663:	48 89 c7             	mov    %rax,%rdi
  801666:	48 89 d6             	mov    %rdx,%rsi
  801669:	fd                   	std    
  80166a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80166c:	eb 1d                	jmp    80168b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80166e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801672:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	48 89 d7             	mov    %rdx,%rdi
  801685:	48 89 c1             	mov    %rax,%rcx
  801688:	fd                   	std    
  801689:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80168b:	fc                   	cld    
  80168c:	eb 57                	jmp    8016e5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	83 e0 03             	and    $0x3,%eax
  801695:	48 85 c0             	test   %rax,%rax
  801698:	75 36                	jne    8016d0 <memmove+0xfc>
  80169a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169e:	83 e0 03             	and    $0x3,%eax
  8016a1:	48 85 c0             	test   %rax,%rax
  8016a4:	75 2a                	jne    8016d0 <memmove+0xfc>
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	83 e0 03             	and    $0x3,%eax
  8016ad:	48 85 c0             	test   %rax,%rax
  8016b0:	75 1e                	jne    8016d0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	48 c1 e8 02          	shr    $0x2,%rax
  8016ba:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c5:	48 89 c7             	mov    %rax,%rdi
  8016c8:	48 89 d6             	mov    %rdx,%rsi
  8016cb:	fc                   	cld    
  8016cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ce:	eb 15                	jmp    8016e5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016dc:	48 89 c7             	mov    %rax,%rdi
  8016df:	48 89 d6             	mov    %rdx,%rsi
  8016e2:	fc                   	cld    
  8016e3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e9:	c9                   	leaveq 
  8016ea:	c3                   	retq   

00000000008016eb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 18          	sub    $0x18,%rsp
  8016f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801703:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170b:	48 89 ce             	mov    %rcx,%rsi
  80170e:	48 89 c7             	mov    %rax,%rdi
  801711:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801718:	00 00 00 
  80171b:	ff d0                	callq  *%rax
}
  80171d:	c9                   	leaveq 
  80171e:	c3                   	retq   

000000000080171f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80171f:	55                   	push   %rbp
  801720:	48 89 e5             	mov    %rsp,%rbp
  801723:	48 83 ec 28          	sub    $0x28,%rsp
  801727:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80172b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80172f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801737:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80173b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80173f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801743:	eb 36                	jmp    80177b <memcmp+0x5c>
		if (*s1 != *s2)
  801745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801749:	0f b6 10             	movzbl (%rax),%edx
  80174c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801750:	0f b6 00             	movzbl (%rax),%eax
  801753:	38 c2                	cmp    %al,%dl
  801755:	74 1a                	je     801771 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175b:	0f b6 00             	movzbl (%rax),%eax
  80175e:	0f b6 d0             	movzbl %al,%edx
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	0f b6 00             	movzbl (%rax),%eax
  801768:	0f b6 c0             	movzbl %al,%eax
  80176b:	29 c2                	sub    %eax,%edx
  80176d:	89 d0                	mov    %edx,%eax
  80176f:	eb 20                	jmp    801791 <memcmp+0x72>
		s1++, s2++;
  801771:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801776:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801783:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801787:	48 85 c0             	test   %rax,%rax
  80178a:	75 b9                	jne    801745 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801791:	c9                   	leaveq 
  801792:	c3                   	retq   

0000000000801793 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801793:	55                   	push   %rbp
  801794:	48 89 e5             	mov    %rsp,%rbp
  801797:	48 83 ec 28          	sub    $0x28,%rsp
  80179b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80179f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ae:	48 01 d0             	add    %rdx,%rax
  8017b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017b5:	eb 15                	jmp    8017cc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017bb:	0f b6 10             	movzbl (%rax),%edx
  8017be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c1:	38 c2                	cmp    %al,%dl
  8017c3:	75 02                	jne    8017c7 <memfind+0x34>
			break;
  8017c5:	eb 0f                	jmp    8017d6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017c7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017d4:	72 e1                	jb     8017b7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017da:	c9                   	leaveq 
  8017db:	c3                   	retq   

00000000008017dc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017dc:	55                   	push   %rbp
  8017dd:	48 89 e5             	mov    %rsp,%rbp
  8017e0:	48 83 ec 34          	sub    $0x34,%rsp
  8017e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017ec:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017f6:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017fd:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017fe:	eb 05                	jmp    801805 <strtol+0x29>
		s++;
  801800:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801809:	0f b6 00             	movzbl (%rax),%eax
  80180c:	3c 20                	cmp    $0x20,%al
  80180e:	74 f0                	je     801800 <strtol+0x24>
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	3c 09                	cmp    $0x9,%al
  801819:	74 e5                	je     801800 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 2b                	cmp    $0x2b,%al
  801824:	75 07                	jne    80182d <strtol+0x51>
		s++;
  801826:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80182b:	eb 17                	jmp    801844 <strtol+0x68>
	else if (*s == '-')
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	0f b6 00             	movzbl (%rax),%eax
  801834:	3c 2d                	cmp    $0x2d,%al
  801836:	75 0c                	jne    801844 <strtol+0x68>
		s++, neg = 1;
  801838:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80183d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801844:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801848:	74 06                	je     801850 <strtol+0x74>
  80184a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80184e:	75 28                	jne    801878 <strtol+0x9c>
  801850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801854:	0f b6 00             	movzbl (%rax),%eax
  801857:	3c 30                	cmp    $0x30,%al
  801859:	75 1d                	jne    801878 <strtol+0x9c>
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	48 83 c0 01          	add    $0x1,%rax
  801863:	0f b6 00             	movzbl (%rax),%eax
  801866:	3c 78                	cmp    $0x78,%al
  801868:	75 0e                	jne    801878 <strtol+0x9c>
		s += 2, base = 16;
  80186a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80186f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801876:	eb 2c                	jmp    8018a4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801878:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80187c:	75 19                	jne    801897 <strtol+0xbb>
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	3c 30                	cmp    $0x30,%al
  801887:	75 0e                	jne    801897 <strtol+0xbb>
		s++, base = 8;
  801889:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801895:	eb 0d                	jmp    8018a4 <strtol+0xc8>
	else if (base == 0)
  801897:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80189b:	75 07                	jne    8018a4 <strtol+0xc8>
		base = 10;
  80189d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	3c 2f                	cmp    $0x2f,%al
  8018ad:	7e 1d                	jle    8018cc <strtol+0xf0>
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	3c 39                	cmp    $0x39,%al
  8018b8:	7f 12                	jg     8018cc <strtol+0xf0>
			dig = *s - '0';
  8018ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	0f be c0             	movsbl %al,%eax
  8018c4:	83 e8 30             	sub    $0x30,%eax
  8018c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ca:	eb 4e                	jmp    80191a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	0f b6 00             	movzbl (%rax),%eax
  8018d3:	3c 60                	cmp    $0x60,%al
  8018d5:	7e 1d                	jle    8018f4 <strtol+0x118>
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	0f b6 00             	movzbl (%rax),%eax
  8018de:	3c 7a                	cmp    $0x7a,%al
  8018e0:	7f 12                	jg     8018f4 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e6:	0f b6 00             	movzbl (%rax),%eax
  8018e9:	0f be c0             	movsbl %al,%eax
  8018ec:	83 e8 57             	sub    $0x57,%eax
  8018ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f2:	eb 26                	jmp    80191a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f8:	0f b6 00             	movzbl (%rax),%eax
  8018fb:	3c 40                	cmp    $0x40,%al
  8018fd:	7e 48                	jle    801947 <strtol+0x16b>
  8018ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	3c 5a                	cmp    $0x5a,%al
  801908:	7f 3d                	jg     801947 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80190a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190e:	0f b6 00             	movzbl (%rax),%eax
  801911:	0f be c0             	movsbl %al,%eax
  801914:	83 e8 37             	sub    $0x37,%eax
  801917:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80191a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80191d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801920:	7c 02                	jl     801924 <strtol+0x148>
			break;
  801922:	eb 23                	jmp    801947 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801924:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801929:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80192c:	48 98                	cltq   
  80192e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801933:	48 89 c2             	mov    %rax,%rdx
  801936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801939:	48 98                	cltq   
  80193b:	48 01 d0             	add    %rdx,%rax
  80193e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801942:	e9 5d ff ff ff       	jmpq   8018a4 <strtol+0xc8>

	if (endptr)
  801947:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80194c:	74 0b                	je     801959 <strtol+0x17d>
		*endptr = (char *) s;
  80194e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801952:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801956:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801959:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80195d:	74 09                	je     801968 <strtol+0x18c>
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	48 f7 d8             	neg    %rax
  801966:	eb 04                	jmp    80196c <strtol+0x190>
  801968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <strstr>:

char * strstr(const char *in, const char *str)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 30          	sub    $0x30,%rsp
  801976:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80197a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80197e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801982:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801986:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80198a:	0f b6 00             	movzbl (%rax),%eax
  80198d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801990:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801994:	75 06                	jne    80199c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199a:	eb 6b                	jmp    801a07 <strstr+0x99>

	len = strlen(str);
  80199c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a0:	48 89 c7             	mov    %rax,%rdi
  8019a3:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
  8019af:	48 98                	cltq   
  8019b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019c1:	0f b6 00             	movzbl (%rax),%eax
  8019c4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019c7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019cb:	75 07                	jne    8019d4 <strstr+0x66>
				return (char *) 0;
  8019cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d2:	eb 33                	jmp    801a07 <strstr+0x99>
		} while (sc != c);
  8019d4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019d8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019db:	75 d8                	jne    8019b5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	48 89 ce             	mov    %rcx,%rsi
  8019ec:	48 89 c7             	mov    %rax,%rdi
  8019ef:	48 b8 65 14 80 00 00 	movabs $0x801465,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	75 b6                	jne    8019b5 <strstr+0x47>

	return (char *) (in - 1);
  8019ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a03:	48 83 e8 01          	sub    $0x1,%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	53                   	push   %rbx
  801a0e:	48 83 ec 48          	sub    $0x48,%rsp
  801a12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a15:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a18:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a1c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a20:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a24:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a28:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a2b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a2f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a33:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a37:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a3b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a3f:	4c 89 c3             	mov    %r8,%rbx
  801a42:	cd 30                	int    $0x30
  801a44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a4c:	74 3e                	je     801a8c <syscall+0x83>
  801a4e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a53:	7e 37                	jle    801a8c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a5c:	49 89 d0             	mov    %rdx,%r8
  801a5f:	89 c1                	mov    %eax,%ecx
  801a61:	48 ba c8 4f 80 00 00 	movabs $0x804fc8,%rdx
  801a68:	00 00 00 
  801a6b:	be 23 00 00 00       	mov    $0x23,%esi
  801a70:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801a77:	00 00 00 
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7f:	49 b9 c2 04 80 00 00 	movabs $0x8004c2,%r9
  801a86:	00 00 00 
  801a89:	41 ff d1             	callq  *%r9

	return ret;
  801a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a90:	48 83 c4 48          	add    $0x48,%rsp
  801a94:	5b                   	pop    %rbx
  801a95:	5d                   	pop    %rbp
  801a96:	c3                   	retq   

0000000000801a97 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	48 83 ec 20          	sub    $0x20,%rsp
  801a9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801aa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab6:	00 
  801ab7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac3:	48 89 d1             	mov    %rdx,%rcx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 00 00 00 00       	mov    $0x0,%esi
  801ace:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad3:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	be 00 00 00 00       	mov    $0x0,%esi
  801b0c:	bf 01 00 00 00       	mov    $0x1,%edi
  801b11:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 10          	sub    $0x10,%rsp
  801b27:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b36:	00 
  801b37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b48:	48 89 c2             	mov    %rax,%rdx
  801b4b:	be 01 00 00 00       	mov    $0x1,%esi
  801b50:	bf 03 00 00 00       	mov    $0x3,%edi
  801b55:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b72:	00 
  801b73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	be 00 00 00 00       	mov    $0x0,%esi
  801b8e:	bf 02 00 00 00       	mov    $0x2,%edi
  801b93:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_yield>:

void
sys_yield(void)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc7:	be 00 00 00 00       	mov    $0x0,%esi
  801bcc:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bd1:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
}
  801bdd:	c9                   	leaveq 
  801bde:	c3                   	retq   

0000000000801bdf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	48 83 ec 20          	sub    $0x20,%rsp
  801be7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bee:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf4:	48 63 c8             	movslq %eax,%rcx
  801bf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfe:	48 98                	cltq   
  801c00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c07:	00 
  801c08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0e:	49 89 c8             	mov    %rcx,%r8
  801c11:	48 89 d1             	mov    %rdx,%rcx
  801c14:	48 89 c2             	mov    %rax,%rdx
  801c17:	be 01 00 00 00       	mov    $0x1,%esi
  801c1c:	bf 04 00 00 00       	mov    $0x4,%edi
  801c21:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
}
  801c2d:	c9                   	leaveq 
  801c2e:	c3                   	retq   

0000000000801c2f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c2f:	55                   	push   %rbp
  801c30:	48 89 e5             	mov    %rsp,%rbp
  801c33:	48 83 ec 30          	sub    $0x30,%rsp
  801c37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c3e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c41:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c45:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c49:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c4c:	48 63 c8             	movslq %eax,%rcx
  801c4f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c56:	48 63 f0             	movslq %eax,%rsi
  801c59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c60:	48 98                	cltq   
  801c62:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c66:	49 89 f9             	mov    %rdi,%r9
  801c69:	49 89 f0             	mov    %rsi,%r8
  801c6c:	48 89 d1             	mov    %rdx,%rcx
  801c6f:	48 89 c2             	mov    %rax,%rdx
  801c72:	be 01 00 00 00       	mov    $0x1,%esi
  801c77:	bf 05 00 00 00       	mov    $0x5,%edi
  801c7c:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	callq  *%rax
}
  801c88:	c9                   	leaveq 
  801c89:	c3                   	retq   

0000000000801c8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c8a:	55                   	push   %rbp
  801c8b:	48 89 e5             	mov    %rsp,%rbp
  801c8e:	48 83 ec 20          	sub    $0x20,%rsp
  801c92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca0:	48 98                	cltq   
  801ca2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca9:	00 
  801caa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb6:	48 89 d1             	mov    %rdx,%rcx
  801cb9:	48 89 c2             	mov    %rax,%rdx
  801cbc:	be 01 00 00 00       	mov    $0x1,%esi
  801cc1:	bf 06 00 00 00       	mov    $0x6,%edi
  801cc6:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 10          	sub    $0x10,%rsp
  801cdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce5:	48 63 d0             	movslq %eax,%rdx
  801ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ceb:	48 98                	cltq   
  801ced:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf4:	00 
  801cf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d01:	48 89 d1             	mov    %rdx,%rcx
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	be 01 00 00 00       	mov    $0x1,%esi
  801d0c:	bf 08 00 00 00       	mov    $0x8,%edi
  801d11:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 20          	sub    $0x20,%rsp
  801d27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d35:	48 98                	cltq   
  801d37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3e:	00 
  801d3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4b:	48 89 d1             	mov    %rdx,%rcx
  801d4e:	48 89 c2             	mov    %rax,%rdx
  801d51:	be 01 00 00 00       	mov    $0x1,%esi
  801d56:	bf 09 00 00 00       	mov    $0x9,%edi
  801d5b:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801d62:	00 00 00 
  801d65:	ff d0                	callq  *%rax
}
  801d67:	c9                   	leaveq 
  801d68:	c3                   	retq   

0000000000801d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	48 83 ec 20          	sub    $0x20,%rsp
  801d71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7f:	48 98                	cltq   
  801d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d88:	00 
  801d89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d95:	48 89 d1             	mov    %rdx,%rcx
  801d98:	48 89 c2             	mov    %rax,%rdx
  801d9b:	be 01 00 00 00       	mov    $0x1,%esi
  801da0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801da5:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 20          	sub    $0x20,%rsp
  801dbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dc2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dc6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dcc:	48 63 f0             	movslq %eax,%rsi
  801dcf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd6:	48 98                	cltq   
  801dd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de3:	00 
  801de4:	49 89 f1             	mov    %rsi,%r9
  801de7:	49 89 c8             	mov    %rcx,%r8
  801dea:	48 89 d1             	mov    %rdx,%rcx
  801ded:	48 89 c2             	mov    %rax,%rdx
  801df0:	be 00 00 00 00       	mov    $0x0,%esi
  801df5:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dfa:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e01:	00 00 00 
  801e04:	ff d0                	callq  *%rax
}
  801e06:	c9                   	leaveq 
  801e07:	c3                   	retq   

0000000000801e08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e08:	55                   	push   %rbp
  801e09:	48 89 e5             	mov    %rsp,%rbp
  801e0c:	48 83 ec 10          	sub    $0x10,%rsp
  801e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1f:	00 
  801e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e31:	48 89 c2             	mov    %rax,%rdx
  801e34:	be 01 00 00 00       	mov    $0x1,%esi
  801e39:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e3e:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	callq  *%rax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	48 83 ec 20          	sub    $0x20,%rsp
  801e54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801e5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6b:	00 
  801e6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e78:	48 89 d1             	mov    %rdx,%rcx
  801e7b:	48 89 c2             	mov    %rax,%rdx
  801e7e:	be 01 00 00 00       	mov    $0x1,%esi
  801e83:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e88:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	callq  *%rax
}
  801e94:	c9                   	leaveq 
  801e95:	c3                   	retq   

0000000000801e96 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801e96:	55                   	push   %rbp
  801e97:	48 89 e5             	mov    %rsp,%rbp
  801e9a:	48 83 ec 10          	sub    $0x10,%rsp
  801e9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ead:	00 
  801eae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	be 00 00 00 00       	mov    $0x0,%esi
  801ec7:	bf 10 00 00 00       	mov    $0x10,%edi
  801ecc:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
}
  801ed8:	c9                   	leaveq 
  801ed9:	c3                   	retq   

0000000000801eda <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
  801ede:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ee2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee9:	00 
  801eea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801efb:	ba 00 00 00 00       	mov    $0x0,%edx
  801f00:	be 00 00 00 00       	mov    $0x0,%esi
  801f05:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f0a:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
}
  801f16:	c9                   	leaveq 
  801f17:	c3                   	retq   

0000000000801f18 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f18:	55                   	push   %rbp
  801f19:	48 89 e5             	mov    %rsp,%rbp
  801f1c:	48 83 ec 30          	sub    $0x30,%rsp
  801f20:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f28:	48 8b 00             	mov    (%rax),%rax
  801f2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f33:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f37:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f3d:	83 e0 02             	and    $0x2,%eax
  801f40:	85 c0                	test   %eax,%eax
  801f42:	75 4d                	jne    801f91 <pgfault+0x79>
  801f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f48:	48 c1 e8 0c          	shr    $0xc,%rax
  801f4c:	48 89 c2             	mov    %rax,%rdx
  801f4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f56:	01 00 00 
  801f59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5d:	25 00 08 00 00       	and    $0x800,%eax
  801f62:	48 85 c0             	test   %rax,%rax
  801f65:	74 2a                	je     801f91 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f67:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  801f6e:	00 00 00 
  801f71:	be 23 00 00 00       	mov    $0x23,%esi
  801f76:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  801f7d:	00 00 00 
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  801f8c:	00 00 00 
  801f8f:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f91:	ba 07 00 00 00       	mov    $0x7,%edx
  801f96:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa0:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	callq  *%rax
  801fac:	85 c0                	test   %eax,%eax
  801fae:	0f 85 cd 00 00 00    	jne    802081 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801fca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fce:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fd3:	48 89 c6             	mov    %rax,%rsi
  801fd6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fdb:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801feb:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ff1:	48 89 c1             	mov    %rax,%rcx
  801ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ffe:	bf 00 00 00 00       	mov    $0x0,%edi
  802003:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
  80200f:	85 c0                	test   %eax,%eax
  802011:	79 2a                	jns    80203d <pgfault+0x125>
				panic("Page map at temp address failed");
  802013:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  80201a:	00 00 00 
  80201d:	be 30 00 00 00       	mov    $0x30,%esi
  802022:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802029:	00 00 00 
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802038:	00 00 00 
  80203b:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80203d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802042:	bf 00 00 00 00       	mov    $0x0,%edi
  802047:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
  802053:	85 c0                	test   %eax,%eax
  802055:	79 54                	jns    8020ab <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802057:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  80205e:	00 00 00 
  802061:	be 32 00 00 00       	mov    $0x32,%esi
  802066:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80206d:	00 00 00 
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  80207c:	00 00 00 
  80207f:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802081:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802088:	00 00 00 
  80208b:	be 34 00 00 00       	mov    $0x34,%esi
  802090:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802097:	00 00 00 
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8020a6:	00 00 00 
  8020a9:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8020ab:	c9                   	leaveq 
  8020ac:	c3                   	retq   

00000000008020ad <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020ad:	55                   	push   %rbp
  8020ae:	48 89 e5             	mov    %rsp,%rbp
  8020b1:	48 83 ec 20          	sub    $0x20,%rsp
  8020b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8020bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c2:	01 00 00 
  8020c5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8020d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8020db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8020df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e2:	25 00 04 00 00       	and    $0x400,%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 57                	je     802142 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020eb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ee:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f9:	41 89 f0             	mov    %esi,%r8d
  8020fc:	48 89 c6             	mov    %rax,%rsi
  8020ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802104:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
  802110:	85 c0                	test   %eax,%eax
  802112:	0f 8e 52 01 00 00    	jle    80226a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802118:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  80211f:	00 00 00 
  802122:	be 4e 00 00 00       	mov    $0x4e,%esi
  802127:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80212e:	00 00 00 
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
  802136:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  80213d:	00 00 00 
  802140:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802145:	83 e0 02             	and    $0x2,%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 10                	jne    80215c <duppage+0xaf>
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	25 00 08 00 00       	and    $0x800,%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	0f 84 bb 00 00 00    	je     802217 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80215c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215f:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802164:	80 cc 08             	or     $0x8,%ah
  802167:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80216a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80216d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802171:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802178:	41 89 f0             	mov    %esi,%r8d
  80217b:	48 89 c6             	mov    %rax,%rsi
  80217e:	bf 00 00 00 00       	mov    $0x0,%edi
  802183:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	callq  *%rax
  80218f:	85 c0                	test   %eax,%eax
  802191:	7e 2a                	jle    8021bd <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802193:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  80219a:	00 00 00 
  80219d:	be 55 00 00 00       	mov    $0x55,%esi
  8021a2:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  8021a9:	00 00 00 
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8021b8:	00 00 00 
  8021bb:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021bd:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8021c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c8:	41 89 c8             	mov    %ecx,%r8d
  8021cb:	48 89 d1             	mov    %rdx,%rcx
  8021ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d3:	48 89 c6             	mov    %rax,%rsi
  8021d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021db:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  8021e2:	00 00 00 
  8021e5:	ff d0                	callq  *%rax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	7e 2a                	jle    802215 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8021eb:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  8021f2:	00 00 00 
  8021f5:	be 57 00 00 00       	mov    $0x57,%esi
  8021fa:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802201:	00 00 00 
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
  802209:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802210:	00 00 00 
  802213:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802215:	eb 53                	jmp    80226a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802217:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80221a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80221e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802225:	41 89 f0             	mov    %esi,%r8d
  802228:	48 89 c6             	mov    %rax,%rsi
  80222b:	bf 00 00 00 00       	mov    $0x0,%edi
  802230:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	7e 2a                	jle    80226a <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802240:	48 ba b2 50 80 00 00 	movabs $0x8050b2,%rdx
  802247:	00 00 00 
  80224a:	be 5b 00 00 00       	mov    $0x5b,%esi
  80224f:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802256:	00 00 00 
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
  80225e:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  802265:	00 00 00 
  802268:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226f:	c9                   	leaveq 
  802270:	c3                   	retq   

0000000000802271 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802271:	55                   	push   %rbp
  802272:	48 89 e5             	mov    %rsp,%rbp
  802275:	48 83 ec 18          	sub    $0x18,%rsp
  802279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80227d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802281:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802289:	48 c1 e8 27          	shr    $0x27,%rax
  80228d:	48 89 c2             	mov    %rax,%rdx
  802290:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802297:	01 00 00 
  80229a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229e:	83 e0 01             	and    $0x1,%eax
  8022a1:	48 85 c0             	test   %rax,%rax
  8022a4:	74 51                	je     8022f7 <pt_is_mapped+0x86>
  8022a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ae:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022b2:	48 89 c2             	mov    %rax,%rdx
  8022b5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022bc:	01 00 00 
  8022bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c3:	83 e0 01             	and    $0x1,%eax
  8022c6:	48 85 c0             	test   %rax,%rax
  8022c9:	74 2c                	je     8022f7 <pt_is_mapped+0x86>
  8022cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d3:	48 c1 e8 15          	shr    $0x15,%rax
  8022d7:	48 89 c2             	mov    %rax,%rdx
  8022da:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022e1:	01 00 00 
  8022e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e8:	83 e0 01             	and    $0x1,%eax
  8022eb:	48 85 c0             	test   %rax,%rax
  8022ee:	74 07                	je     8022f7 <pt_is_mapped+0x86>
  8022f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f5:	eb 05                	jmp    8022fc <pt_is_mapped+0x8b>
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	83 e0 01             	and    $0x1,%eax
}
  8022ff:	c9                   	leaveq 
  802300:	c3                   	retq   

0000000000802301 <fork>:

envid_t
fork(void)
{
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802309:	48 bf 18 1f 80 00 00 	movabs $0x801f18,%rdi
  802310:	00 00 00 
  802313:	48 b8 3e 46 80 00 00 	movabs $0x80463e,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80231f:	b8 07 00 00 00       	mov    $0x7,%eax
  802324:	cd 30                	int    $0x30
  802326:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802329:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80232c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802333:	79 30                	jns    802365 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802335:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802338:	89 c1                	mov    %eax,%ecx
  80233a:	48 ba d0 50 80 00 00 	movabs $0x8050d0,%rdx
  802341:	00 00 00 
  802344:	be 86 00 00 00       	mov    $0x86,%esi
  802349:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  802350:	00 00 00 
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  80235f:	00 00 00 
  802362:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802369:	75 46                	jne    8023b1 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80236b:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
  802377:	25 ff 03 00 00       	and    $0x3ff,%eax
  80237c:	48 63 d0             	movslq %eax,%rdx
  80237f:	48 89 d0             	mov    %rdx,%rax
  802382:	48 c1 e0 03          	shl    $0x3,%rax
  802386:	48 01 d0             	add    %rdx,%rax
  802389:	48 c1 e0 05          	shl    $0x5,%rax
  80238d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802394:	00 00 00 
  802397:	48 01 c2             	add    %rax,%rdx
  80239a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023a1:	00 00 00 
  8023a4:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	e9 d1 01 00 00       	jmpq   802582 <fork+0x281>
	}
	uint64_t ad = 0;
  8023b1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023b8:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023b9:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c2:	e9 df 00 00 00       	jmpq   8024a6 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cb:	48 c1 e8 27          	shr    $0x27,%rax
  8023cf:	48 89 c2             	mov    %rax,%rdx
  8023d2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023d9:	01 00 00 
  8023dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e0:	83 e0 01             	and    $0x1,%eax
  8023e3:	48 85 c0             	test   %rax,%rax
  8023e6:	0f 84 9e 00 00 00    	je     80248a <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8023ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023f4:	48 89 c2             	mov    %rax,%rdx
  8023f7:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023fe:	01 00 00 
  802401:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802405:	83 e0 01             	and    $0x1,%eax
  802408:	48 85 c0             	test   %rax,%rax
  80240b:	74 73                	je     802480 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80240d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802411:	48 c1 e8 15          	shr    $0x15,%rax
  802415:	48 89 c2             	mov    %rax,%rdx
  802418:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80241f:	01 00 00 
  802422:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802426:	83 e0 01             	and    $0x1,%eax
  802429:	48 85 c0             	test   %rax,%rax
  80242c:	74 48                	je     802476 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80242e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802432:	48 c1 e8 0c          	shr    $0xc,%rax
  802436:	48 89 c2             	mov    %rax,%rdx
  802439:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802440:	01 00 00 
  802443:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802447:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80244b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244f:	83 e0 01             	and    $0x1,%eax
  802452:	48 85 c0             	test   %rax,%rax
  802455:	74 47                	je     80249e <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245b:	48 c1 e8 0c          	shr    $0xc,%rax
  80245f:	89 c2                	mov    %eax,%edx
  802461:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802464:	89 d6                	mov    %edx,%esi
  802466:	89 c7                	mov    %eax,%edi
  802468:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
  802474:	eb 28                	jmp    80249e <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802476:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80247d:	00 
  80247e:	eb 1e                	jmp    80249e <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802480:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802487:	40 
  802488:	eb 14                	jmp    80249e <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80248a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248e:	48 c1 e8 27          	shr    $0x27,%rax
  802492:	48 83 c0 01          	add    $0x1,%rax
  802496:	48 c1 e0 27          	shl    $0x27,%rax
  80249a:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80249e:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024a5:	00 
  8024a6:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8024ad:	00 
  8024ae:	0f 87 13 ff ff ff    	ja     8023c7 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024b7:	ba 07 00 00 00       	mov    $0x7,%edx
  8024bc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024c1:	89 c7                	mov    %eax,%edi
  8024c3:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d2:	ba 07 00 00 00       	mov    $0x7,%edx
  8024d7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024ed:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024f3:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8024f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fd:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802502:	89 c7                	mov    %eax,%edi
  802504:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802510:	ba 00 10 00 00       	mov    $0x1000,%edx
  802515:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80251a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80251f:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  802526:	00 00 00 
  802529:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80252b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802530:	bf 00 00 00 00       	mov    $0x0,%edi
  802535:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802541:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802548:	00 00 00 
  80254b:	48 8b 00             	mov    (%rax),%rax
  80254e:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802555:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802569:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80256c:	be 02 00 00 00       	mov    $0x2,%esi
  802571:	89 c7                	mov    %eax,%edi
  802573:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  80257a:	00 00 00 
  80257d:	ff d0                	callq  *%rax

	return envid;
  80257f:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802582:	c9                   	leaveq 
  802583:	c3                   	retq   

0000000000802584 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802584:	55                   	push   %rbp
  802585:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802588:	48 ba e8 50 80 00 00 	movabs $0x8050e8,%rdx
  80258f:	00 00 00 
  802592:	be bf 00 00 00       	mov    $0xbf,%esi
  802597:	48 bf 2d 50 80 00 00 	movabs $0x80502d,%rdi
  80259e:	00 00 00 
  8025a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a6:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8025ad:	00 00 00 
  8025b0:	ff d1                	callq  *%rcx

00000000008025b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025b2:	55                   	push   %rbp
  8025b3:	48 89 e5             	mov    %rsp,%rbp
  8025b6:	48 83 ec 08          	sub    $0x8,%rsp
  8025ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025c2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025c9:	ff ff ff 
  8025cc:	48 01 d0             	add    %rdx,%rax
  8025cf:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025d3:	c9                   	leaveq 
  8025d4:	c3                   	retq   

00000000008025d5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025d5:	55                   	push   %rbp
  8025d6:	48 89 e5             	mov    %rsp,%rbp
  8025d9:	48 83 ec 08          	sub    $0x8,%rsp
  8025dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e5:	48 89 c7             	mov    %rax,%rdi
  8025e8:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
  8025f4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025fa:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025fe:	c9                   	leaveq 
  8025ff:	c3                   	retq   

0000000000802600 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802600:	55                   	push   %rbp
  802601:	48 89 e5             	mov    %rsp,%rbp
  802604:	48 83 ec 18          	sub    $0x18,%rsp
  802608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80260c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802613:	eb 6b                	jmp    802680 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802618:	48 98                	cltq   
  80261a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802620:	48 c1 e0 0c          	shl    $0xc,%rax
  802624:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262c:	48 c1 e8 15          	shr    $0x15,%rax
  802630:	48 89 c2             	mov    %rax,%rdx
  802633:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80263a:	01 00 00 
  80263d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802641:	83 e0 01             	and    $0x1,%eax
  802644:	48 85 c0             	test   %rax,%rax
  802647:	74 21                	je     80266a <fd_alloc+0x6a>
  802649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264d:	48 c1 e8 0c          	shr    $0xc,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	75 12                	jne    80267c <fd_alloc+0x7c>
			*fd_store = fd;
  80266a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802672:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
  80267a:	eb 1a                	jmp    802696 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80267c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802680:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802684:	7e 8f                	jle    802615 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802691:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 20          	sub    $0x20,%rsp
  8026a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026ab:	78 06                	js     8026b3 <fd_lookup+0x1b>
  8026ad:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026b1:	7e 07                	jle    8026ba <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026b8:	eb 6c                	jmp    802726 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026bd:	48 98                	cltq   
  8026bf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c5:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d1:	48 c1 e8 15          	shr    $0x15,%rax
  8026d5:	48 89 c2             	mov    %rax,%rdx
  8026d8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026df:	01 00 00 
  8026e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e6:	83 e0 01             	and    $0x1,%eax
  8026e9:	48 85 c0             	test   %rax,%rax
  8026ec:	74 21                	je     80270f <fd_lookup+0x77>
  8026ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f2:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f6:	48 89 c2             	mov    %rax,%rdx
  8026f9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802700:	01 00 00 
  802703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802707:	83 e0 01             	and    $0x1,%eax
  80270a:	48 85 c0             	test   %rax,%rax
  80270d:	75 07                	jne    802716 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80270f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802714:	eb 10                	jmp    802726 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802716:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80271a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80271e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802726:	c9                   	leaveq 
  802727:	c3                   	retq   

0000000000802728 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802728:	55                   	push   %rbp
  802729:	48 89 e5             	mov    %rsp,%rbp
  80272c:	48 83 ec 30          	sub    $0x30,%rsp
  802730:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802734:	89 f0                	mov    %esi,%eax
  802736:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273d:	48 89 c7             	mov    %rax,%rdi
  802740:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
  80274c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802750:	48 89 d6             	mov    %rdx,%rsi
  802753:	89 c7                	mov    %eax,%edi
  802755:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  80275c:	00 00 00 
  80275f:	ff d0                	callq  *%rax
  802761:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802764:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802768:	78 0a                	js     802774 <fd_close+0x4c>
	    || fd != fd2)
  80276a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802772:	74 12                	je     802786 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802774:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802778:	74 05                	je     80277f <fd_close+0x57>
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277d:	eb 05                	jmp    802784 <fd_close+0x5c>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	eb 69                	jmp    8027ef <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278a:	8b 00                	mov    (%rax),%eax
  80278c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802790:	48 89 d6             	mov    %rdx,%rsi
  802793:	89 c7                	mov    %eax,%edi
  802795:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax
  8027a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a8:	78 2a                	js     8027d4 <fd_close+0xac>
		if (dev->dev_close)
  8027aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ae:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027b2:	48 85 c0             	test   %rax,%rax
  8027b5:	74 16                	je     8027cd <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c3:	48 89 d7             	mov    %rdx,%rdi
  8027c6:	ff d0                	callq  *%rax
  8027c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cb:	eb 07                	jmp    8027d4 <fd_close+0xac>
		else
			r = 0;
  8027cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d8:	48 89 c6             	mov    %rax,%rsi
  8027db:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e0:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
	return r;
  8027ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027ef:	c9                   	leaveq 
  8027f0:	c3                   	retq   

00000000008027f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027f1:	55                   	push   %rbp
  8027f2:	48 89 e5             	mov    %rsp,%rbp
  8027f5:	48 83 ec 20          	sub    $0x20,%rsp
  8027f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802800:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802807:	eb 41                	jmp    80284a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802809:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802810:	00 00 00 
  802813:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802816:	48 63 d2             	movslq %edx,%rdx
  802819:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281d:	8b 00                	mov    (%rax),%eax
  80281f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802822:	75 22                	jne    802846 <dev_lookup+0x55>
			*dev = devtab[i];
  802824:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80282b:	00 00 00 
  80282e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802831:	48 63 d2             	movslq %edx,%rdx
  802834:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802838:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80283f:	b8 00 00 00 00       	mov    $0x0,%eax
  802844:	eb 60                	jmp    8028a6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802846:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80284a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802851:	00 00 00 
  802854:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802857:	48 63 d2             	movslq %edx,%rdx
  80285a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285e:	48 85 c0             	test   %rax,%rax
  802861:	75 a6                	jne    802809 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802863:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80286a:	00 00 00 
  80286d:	48 8b 00             	mov    (%rax),%rax
  802870:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802876:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802879:	89 c6                	mov    %eax,%esi
  80287b:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802882:	00 00 00 
  802885:	b8 00 00 00 00       	mov    $0x0,%eax
  80288a:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802891:	00 00 00 
  802894:	ff d1                	callq  *%rcx
	*dev = 0;
  802896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028a6:	c9                   	leaveq 
  8028a7:	c3                   	retq   

00000000008028a8 <close>:

int
close(int fdnum)
{
  8028a8:	55                   	push   %rbp
  8028a9:	48 89 e5             	mov    %rsp,%rbp
  8028ac:	48 83 ec 20          	sub    $0x20,%rsp
  8028b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028ba:	48 89 d6             	mov    %rdx,%rsi
  8028bd:	89 c7                	mov    %eax,%edi
  8028bf:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	callq  *%rax
  8028cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d2:	79 05                	jns    8028d9 <close+0x31>
		return r;
  8028d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d7:	eb 18                	jmp    8028f1 <close+0x49>
	else
		return fd_close(fd, 1);
  8028d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028dd:	be 01 00 00 00       	mov    $0x1,%esi
  8028e2:	48 89 c7             	mov    %rax,%rdi
  8028e5:	48 b8 28 27 80 00 00 	movabs $0x802728,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax
}
  8028f1:	c9                   	leaveq 
  8028f2:	c3                   	retq   

00000000008028f3 <close_all>:

void
close_all(void)
{
  8028f3:	55                   	push   %rbp
  8028f4:	48 89 e5             	mov    %rsp,%rbp
  8028f7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802902:	eb 15                	jmp    802919 <close_all+0x26>
		close(i);
  802904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802907:	89 c7                	mov    %eax,%edi
  802909:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802915:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802919:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80291d:	7e e5                	jle    802904 <close_all+0x11>
		close(i);
}
  80291f:	c9                   	leaveq 
  802920:	c3                   	retq   

0000000000802921 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802921:	55                   	push   %rbp
  802922:	48 89 e5             	mov    %rsp,%rbp
  802925:	48 83 ec 40          	sub    $0x40,%rsp
  802929:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80292c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80292f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802933:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802936:	48 89 d6             	mov    %rdx,%rsi
  802939:	89 c7                	mov    %eax,%edi
  80293b:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294e:	79 08                	jns    802958 <dup+0x37>
		return r;
  802950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802953:	e9 70 01 00 00       	jmpq   802ac8 <dup+0x1a7>
	close(newfdnum);
  802958:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80295b:	89 c7                	mov    %eax,%edi
  80295d:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802964:	00 00 00 
  802967:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802969:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80296c:	48 98                	cltq   
  80296e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802974:	48 c1 e0 0c          	shl    $0xc,%rax
  802978:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80297c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802980:	48 89 c7             	mov    %rax,%rdi
  802983:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
  80298f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802997:	48 89 c7             	mov    %rax,%rdi
  80299a:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	callq  *%rax
  8029a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ae:	48 c1 e8 15          	shr    $0x15,%rax
  8029b2:	48 89 c2             	mov    %rax,%rdx
  8029b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029bc:	01 00 00 
  8029bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c3:	83 e0 01             	and    $0x1,%eax
  8029c6:	48 85 c0             	test   %rax,%rax
  8029c9:	74 73                	je     802a3e <dup+0x11d>
  8029cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8029d3:	48 89 c2             	mov    %rax,%rdx
  8029d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029dd:	01 00 00 
  8029e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e4:	83 e0 01             	and    $0x1,%eax
  8029e7:	48 85 c0             	test   %rax,%rax
  8029ea:	74 52                	je     802a3e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f4:	48 89 c2             	mov    %rax,%rdx
  8029f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029fe:	01 00 00 
  802a01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a05:	25 07 0e 00 00       	and    $0xe07,%eax
  802a0a:	89 c1                	mov    %eax,%ecx
  802a0c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	41 89 c8             	mov    %ecx,%r8d
  802a17:	48 89 d1             	mov    %rdx,%rcx
  802a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1f:	48 89 c6             	mov    %rax,%rsi
  802a22:	bf 00 00 00 00       	mov    $0x0,%edi
  802a27:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
  802a33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3a:	79 02                	jns    802a3e <dup+0x11d>
			goto err;
  802a3c:	eb 57                	jmp    802a95 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a42:	48 c1 e8 0c          	shr    $0xc,%rax
  802a46:	48 89 c2             	mov    %rax,%rdx
  802a49:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a50:	01 00 00 
  802a53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a57:	25 07 0e 00 00       	and    $0xe07,%eax
  802a5c:	89 c1                	mov    %eax,%ecx
  802a5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a66:	41 89 c8             	mov    %ecx,%r8d
  802a69:	48 89 d1             	mov    %rdx,%rcx
  802a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a71:	48 89 c6             	mov    %rax,%rsi
  802a74:	bf 00 00 00 00       	mov    $0x0,%edi
  802a79:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
  802a85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8c:	79 02                	jns    802a90 <dup+0x16f>
		goto err;
  802a8e:	eb 05                	jmp    802a95 <dup+0x174>

	return newfdnum;
  802a90:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a93:	eb 33                	jmp    802ac8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 89 c6             	mov    %rax,%rsi
  802a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa1:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802aad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab1:	48 89 c6             	mov    %rax,%rsi
  802ab4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab9:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
	return r;
  802ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac8:	c9                   	leaveq 
  802ac9:	c3                   	retq   

0000000000802aca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	48 83 ec 40          	sub    $0x40,%rsp
  802ad2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ad9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802add:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae4:	48 89 d6             	mov    %rdx,%rsi
  802ae7:	89 c7                	mov    %eax,%edi
  802ae9:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802af0:	00 00 00 
  802af3:	ff d0                	callq  *%rax
  802af5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afc:	78 24                	js     802b22 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b02:	8b 00                	mov    (%rax),%eax
  802b04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b08:	48 89 d6             	mov    %rdx,%rsi
  802b0b:	89 c7                	mov    %eax,%edi
  802b0d:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	callq  *%rax
  802b19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b20:	79 05                	jns    802b27 <read+0x5d>
		return r;
  802b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b25:	eb 76                	jmp    802b9d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2b:	8b 40 08             	mov    0x8(%rax),%eax
  802b2e:	83 e0 03             	and    $0x3,%eax
  802b31:	83 f8 01             	cmp    $0x1,%eax
  802b34:	75 3a                	jne    802b70 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b36:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b3d:	00 00 00 
  802b40:	48 8b 00             	mov    (%rax),%rax
  802b43:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b49:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4c:	89 c6                	mov    %eax,%esi
  802b4e:	48 bf 1f 51 80 00 00 	movabs $0x80511f,%rdi
  802b55:	00 00 00 
  802b58:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5d:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802b64:	00 00 00 
  802b67:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6e:	eb 2d                	jmp    802b9d <read+0xd3>
	}
	if (!dev->dev_read)
  802b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b74:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b78:	48 85 c0             	test   %rax,%rax
  802b7b:	75 07                	jne    802b84 <read+0xba>
		return -E_NOT_SUPP;
  802b7d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b82:	eb 19                	jmp    802b9d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b8c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b94:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b98:	48 89 cf             	mov    %rcx,%rdi
  802b9b:	ff d0                	callq  *%rax
}
  802b9d:	c9                   	leaveq 
  802b9e:	c3                   	retq   

0000000000802b9f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	48 83 ec 30          	sub    $0x30,%rsp
  802ba7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802baa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb9:	eb 49                	jmp    802c04 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbe:	48 98                	cltq   
  802bc0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc4:	48 29 c2             	sub    %rax,%rdx
  802bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bca:	48 63 c8             	movslq %eax,%rcx
  802bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd1:	48 01 c1             	add    %rax,%rcx
  802bd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd7:	48 89 ce             	mov    %rcx,%rsi
  802bda:	89 c7                	mov    %eax,%edi
  802bdc:	48 b8 ca 2a 80 00 00 	movabs $0x802aca,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
  802be8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802beb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bef:	79 05                	jns    802bf6 <readn+0x57>
			return m;
  802bf1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf4:	eb 1c                	jmp    802c12 <readn+0x73>
		if (m == 0)
  802bf6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bfa:	75 02                	jne    802bfe <readn+0x5f>
			break;
  802bfc:	eb 11                	jmp    802c0f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c01:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c07:	48 98                	cltq   
  802c09:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c0d:	72 ac                	jb     802bbb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c12:	c9                   	leaveq 
  802c13:	c3                   	retq   

0000000000802c14 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c14:	55                   	push   %rbp
  802c15:	48 89 e5             	mov    %rsp,%rbp
  802c18:	48 83 ec 40          	sub    $0x40,%rsp
  802c1c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c1f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c23:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c27:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c2b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c2e:	48 89 d6             	mov    %rdx,%rsi
  802c31:	89 c7                	mov    %eax,%edi
  802c33:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
  802c3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c46:	78 24                	js     802c6c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4c:	8b 00                	mov    (%rax),%eax
  802c4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c52:	48 89 d6             	mov    %rdx,%rsi
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6a:	79 05                	jns    802c71 <write+0x5d>
		return r;
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	eb 75                	jmp    802ce6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c75:	8b 40 08             	mov    0x8(%rax),%eax
  802c78:	83 e0 03             	and    $0x3,%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	75 3a                	jne    802cb9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c7f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c86:	00 00 00 
  802c89:	48 8b 00             	mov    (%rax),%rax
  802c8c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c92:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c95:	89 c6                	mov    %eax,%esi
  802c97:	48 bf 3b 51 80 00 00 	movabs $0x80513b,%rdi
  802c9e:	00 00 00 
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802cad:	00 00 00 
  802cb0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cb7:	eb 2d                	jmp    802ce6 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbd:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cc1:	48 85 c0             	test   %rax,%rax
  802cc4:	75 07                	jne    802ccd <write+0xb9>
		return -E_NOT_SUPP;
  802cc6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ccb:	eb 19                	jmp    802ce6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cd5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cd9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cdd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ce1:	48 89 cf             	mov    %rcx,%rdi
  802ce4:	ff d0                	callq  *%rax
}
  802ce6:	c9                   	leaveq 
  802ce7:	c3                   	retq   

0000000000802ce8 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ce8:	55                   	push   %rbp
  802ce9:	48 89 e5             	mov    %rsp,%rbp
  802cec:	48 83 ec 18          	sub    $0x18,%rsp
  802cf0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cf3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cf6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cfa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cfd:	48 89 d6             	mov    %rdx,%rsi
  802d00:	89 c7                	mov    %eax,%edi
  802d02:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802d09:	00 00 00 
  802d0c:	ff d0                	callq  *%rax
  802d0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d15:	79 05                	jns    802d1c <seek+0x34>
		return r;
  802d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1a:	eb 0f                	jmp    802d2b <seek+0x43>
	fd->fd_offset = offset;
  802d1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d20:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d23:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2b:	c9                   	leaveq 
  802d2c:	c3                   	retq   

0000000000802d2d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d2d:	55                   	push   %rbp
  802d2e:	48 89 e5             	mov    %rsp,%rbp
  802d31:	48 83 ec 30          	sub    $0x30,%rsp
  802d35:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d38:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d3b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d42:	48 89 d6             	mov    %rdx,%rsi
  802d45:	89 c7                	mov    %eax,%edi
  802d47:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax
  802d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5a:	78 24                	js     802d80 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d60:	8b 00                	mov    (%rax),%eax
  802d62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d66:	48 89 d6             	mov    %rdx,%rsi
  802d69:	89 c7                	mov    %eax,%edi
  802d6b:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
  802d77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7e:	79 05                	jns    802d85 <ftruncate+0x58>
		return r;
  802d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d83:	eb 72                	jmp    802df7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d89:	8b 40 08             	mov    0x8(%rax),%eax
  802d8c:	83 e0 03             	and    $0x3,%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	75 3a                	jne    802dcd <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d93:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d9a:	00 00 00 
  802d9d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802da0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da9:	89 c6                	mov    %eax,%esi
  802dab:	48 bf 58 51 80 00 00 	movabs $0x805158,%rdi
  802db2:	00 00 00 
  802db5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dba:	48 b9 fb 06 80 00 00 	movabs $0x8006fb,%rcx
  802dc1:	00 00 00 
  802dc4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dcb:	eb 2a                	jmp    802df7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dd5:	48 85 c0             	test   %rax,%rax
  802dd8:	75 07                	jne    802de1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dda:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ddf:	eb 16                	jmp    802df7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802de1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802de9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ded:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802df0:	89 ce                	mov    %ecx,%esi
  802df2:	48 89 d7             	mov    %rdx,%rdi
  802df5:	ff d0                	callq  *%rax
}
  802df7:	c9                   	leaveq 
  802df8:	c3                   	retq   

0000000000802df9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802df9:	55                   	push   %rbp
  802dfa:	48 89 e5             	mov    %rsp,%rbp
  802dfd:	48 83 ec 30          	sub    $0x30,%rsp
  802e01:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e04:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e08:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e0c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e0f:	48 89 d6             	mov    %rdx,%rsi
  802e12:	89 c7                	mov    %eax,%edi
  802e14:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e27:	78 24                	js     802e4d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2d:	8b 00                	mov    (%rax),%eax
  802e2f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e33:	48 89 d6             	mov    %rdx,%rsi
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 f1 27 80 00 00 	movabs $0x8027f1,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4b:	79 05                	jns    802e52 <fstat+0x59>
		return r;
  802e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e50:	eb 5e                	jmp    802eb0 <fstat+0xb7>
	if (!dev->dev_stat)
  802e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e56:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e5a:	48 85 c0             	test   %rax,%rax
  802e5d:	75 07                	jne    802e66 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e5f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e64:	eb 4a                	jmp    802eb0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e6a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e71:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e78:	00 00 00 
	stat->st_isdir = 0;
  802e7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e86:	00 00 00 
	stat->st_dev = dev;
  802e89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e91:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ea0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ea4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ea8:	48 89 ce             	mov    %rcx,%rsi
  802eab:	48 89 d7             	mov    %rdx,%rdi
  802eae:	ff d0                	callq  *%rax
}
  802eb0:	c9                   	leaveq 
  802eb1:	c3                   	retq   

0000000000802eb2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802eb2:	55                   	push   %rbp
  802eb3:	48 89 e5             	mov    %rsp,%rbp
  802eb6:	48 83 ec 20          	sub    $0x20,%rsp
  802eba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ebe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec6:	be 00 00 00 00       	mov    $0x0,%esi
  802ecb:	48 89 c7             	mov    %rax,%rdi
  802ece:	48 b8 a0 2f 80 00 00 	movabs $0x802fa0,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
  802eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee1:	79 05                	jns    802ee8 <stat+0x36>
		return fd;
  802ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee6:	eb 2f                	jmp    802f17 <stat+0x65>
	r = fstat(fd, stat);
  802ee8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eef:	48 89 d6             	mov    %rdx,%rsi
  802ef2:	89 c7                	mov    %eax,%edi
  802ef4:	48 b8 f9 2d 80 00 00 	movabs $0x802df9,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f06:	89 c7                	mov    %eax,%edi
  802f08:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
	return r;
  802f14:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f17:	c9                   	leaveq 
  802f18:	c3                   	retq   

0000000000802f19 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f19:	55                   	push   %rbp
  802f1a:	48 89 e5             	mov    %rsp,%rbp
  802f1d:	48 83 ec 10          	sub    $0x10,%rsp
  802f21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f2f:	00 00 00 
  802f32:	8b 00                	mov    (%rax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	75 1d                	jne    802f55 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f38:	bf 01 00 00 00       	mov    $0x1,%edi
  802f3d:	48 b8 e6 48 80 00 00 	movabs $0x8048e6,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f50:	00 00 00 
  802f53:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5c:	00 00 00 
  802f5f:	8b 00                	mov    (%rax),%eax
  802f61:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f64:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f69:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802f70:	00 00 00 
  802f73:	89 c7                	mov    %eax,%edi
  802f75:	48 b8 84 48 80 00 00 	movabs $0x804884,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f85:	ba 00 00 00 00       	mov    $0x0,%edx
  802f8a:	48 89 c6             	mov    %rax,%rsi
  802f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f92:	48 b8 7e 47 80 00 00 	movabs $0x80477e,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
}
  802f9e:	c9                   	leaveq 
  802f9f:	c3                   	retq   

0000000000802fa0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fa0:	55                   	push   %rbp
  802fa1:	48 89 e5             	mov    %rsp,%rbp
  802fa4:	48 83 ec 30          	sub    $0x30,%rsp
  802fa8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fac:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802faf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802fb6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802fbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802fc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802fc9:	75 08                	jne    802fd3 <open+0x33>
	{
		return r;
  802fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fce:	e9 f2 00 00 00       	jmpq   8030c5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd7:	48 89 c7             	mov    %rax,%rdi
  802fda:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
  802fe6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fe9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ff0:	7e 0a                	jle    802ffc <open+0x5c>
	{
		return -E_BAD_PATH;
  802ff2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff7:	e9 c9 00 00 00       	jmpq   8030c5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ffc:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803003:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803004:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803008:	48 89 c7             	mov    %rax,%rdi
  80300b:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
  803017:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301e:	78 09                	js     803029 <open+0x89>
  803020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803024:	48 85 c0             	test   %rax,%rax
  803027:	75 08                	jne    803031 <open+0x91>
		{
			return r;
  803029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302c:	e9 94 00 00 00       	jmpq   8030c5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803035:	ba 00 04 00 00       	mov    $0x400,%edx
  80303a:	48 89 c6             	mov    %rax,%rsi
  80303d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803044:	00 00 00 
  803047:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803053:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80305a:	00 00 00 
  80305d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803060:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306a:	48 89 c6             	mov    %rax,%rsi
  80306d:	bf 01 00 00 00       	mov    $0x1,%edi
  803072:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
  80307e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803081:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803085:	79 2b                	jns    8030b2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	48 89 c7             	mov    %rax,%rdi
  803093:	48 b8 28 27 80 00 00 	movabs $0x802728,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8030a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030a6:	79 05                	jns    8030ad <open+0x10d>
			{
				return d;
  8030a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ab:	eb 18                	jmp    8030c5 <open+0x125>
			}
			return r;
  8030ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b0:	eb 13                	jmp    8030c5 <open+0x125>
		}	
		return fd2num(fd_store);
  8030b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b6:	48 89 c7             	mov    %rax,%rdi
  8030b9:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8030c5:	c9                   	leaveq 
  8030c6:	c3                   	retq   

00000000008030c7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030c7:	55                   	push   %rbp
  8030c8:	48 89 e5             	mov    %rsp,%rbp
  8030cb:	48 83 ec 10          	sub    $0x10,%rsp
  8030cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8030da:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030e1:	00 00 00 
  8030e4:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030e6:	be 00 00 00 00       	mov    $0x0,%esi
  8030eb:	bf 06 00 00 00       	mov    $0x6,%edi
  8030f0:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
}
  8030fc:	c9                   	leaveq 
  8030fd:	c3                   	retq   

00000000008030fe <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030fe:	55                   	push   %rbp
  8030ff:	48 89 e5             	mov    %rsp,%rbp
  803102:	48 83 ec 30          	sub    $0x30,%rsp
  803106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80310a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80310e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803119:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80311e:	74 07                	je     803127 <devfile_read+0x29>
  803120:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803125:	75 07                	jne    80312e <devfile_read+0x30>
		return -E_INVAL;
  803127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80312c:	eb 77                	jmp    8031a5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80312e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803132:	8b 50 0c             	mov    0xc(%rax),%edx
  803135:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80313c:	00 00 00 
  80313f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803141:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803148:	00 00 00 
  80314b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80314f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803153:	be 00 00 00 00       	mov    $0x0,%esi
  803158:	bf 03 00 00 00       	mov    $0x3,%edi
  80315d:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
  803169:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803170:	7f 05                	jg     803177 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803175:	eb 2e                	jmp    8031a5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317a:	48 63 d0             	movslq %eax,%rdx
  80317d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803181:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803188:	00 00 00 
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80319a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8031a5:	c9                   	leaveq 
  8031a6:	c3                   	retq   

00000000008031a7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031a7:	55                   	push   %rbp
  8031a8:	48 89 e5             	mov    %rsp,%rbp
  8031ab:	48 83 ec 30          	sub    $0x30,%rsp
  8031af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8031bb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8031c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031c7:	74 07                	je     8031d0 <devfile_write+0x29>
  8031c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031ce:	75 08                	jne    8031d8 <devfile_write+0x31>
		return r;
  8031d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d3:	e9 9a 00 00 00       	jmpq   803272 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dc:	8b 50 0c             	mov    0xc(%rax),%edx
  8031df:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031e6:	00 00 00 
  8031e9:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031eb:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031f2:	00 
  8031f3:	76 08                	jbe    8031fd <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031f5:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031fc:	00 
	}
	fsipcbuf.write.req_n = n;
  8031fd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803204:	00 00 00 
  803207:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80320f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803217:	48 89 c6             	mov    %rax,%rsi
  80321a:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803221:	00 00 00 
  803224:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803230:	be 00 00 00 00       	mov    $0x0,%esi
  803235:	bf 04 00 00 00       	mov    $0x4,%edi
  80323a:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
  803246:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803249:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324d:	7f 20                	jg     80326f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80324f:	48 bf 7e 51 80 00 00 	movabs $0x80517e,%rdi
  803256:	00 00 00 
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
  80325e:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803265:	00 00 00 
  803268:	ff d2                	callq  *%rdx
		return r;
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326d:	eb 03                	jmp    803272 <devfile_write+0xcb>
	}
	return r;
  80326f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803272:	c9                   	leaveq 
  803273:	c3                   	retq   

0000000000803274 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803274:	55                   	push   %rbp
  803275:	48 89 e5             	mov    %rsp,%rbp
  803278:	48 83 ec 20          	sub    $0x20,%rsp
  80327c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803280:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803288:	8b 50 0c             	mov    0xc(%rax),%edx
  80328b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803292:	00 00 00 
  803295:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803297:	be 00 00 00 00       	mov    $0x0,%esi
  80329c:	bf 05 00 00 00       	mov    $0x5,%edi
  8032a1:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b4:	79 05                	jns    8032bb <devfile_stat+0x47>
		return r;
  8032b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b9:	eb 56                	jmp    803311 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bf:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032c6:	00 00 00 
  8032c9:	48 89 c7             	mov    %rax,%rdi
  8032cc:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8032d3:	00 00 00 
  8032d6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032d8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032df:	00 00 00 
  8032e2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ec:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032f2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032f9:	00 00 00 
  8032fc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803302:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803306:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80330c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803311:	c9                   	leaveq 
  803312:	c3                   	retq   

0000000000803313 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803313:	55                   	push   %rbp
  803314:	48 89 e5             	mov    %rsp,%rbp
  803317:	48 83 ec 10          	sub    $0x10,%rsp
  80331b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80331f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803326:	8b 50 0c             	mov    0xc(%rax),%edx
  803329:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803330:	00 00 00 
  803333:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803335:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80333c:	00 00 00 
  80333f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803342:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803345:	be 00 00 00 00       	mov    $0x0,%esi
  80334a:	bf 02 00 00 00       	mov    $0x2,%edi
  80334f:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
}
  80335b:	c9                   	leaveq 
  80335c:	c3                   	retq   

000000000080335d <remove>:

// Delete a file
int
remove(const char *path)
{
  80335d:	55                   	push   %rbp
  80335e:	48 89 e5             	mov    %rsp,%rbp
  803361:	48 83 ec 10          	sub    $0x10,%rsp
  803365:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336d:	48 89 c7             	mov    %rax,%rdi
  803370:	48 b8 44 12 80 00 00 	movabs $0x801244,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803381:	7e 07                	jle    80338a <remove+0x2d>
		return -E_BAD_PATH;
  803383:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803388:	eb 33                	jmp    8033bd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80338a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338e:	48 89 c6             	mov    %rax,%rsi
  803391:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803398:	00 00 00 
  80339b:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033a7:	be 00 00 00 00       	mov    $0x0,%esi
  8033ac:	bf 07 00 00 00       	mov    $0x7,%edi
  8033b1:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
}
  8033bd:	c9                   	leaveq 
  8033be:	c3                   	retq   

00000000008033bf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033bf:	55                   	push   %rbp
  8033c0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033c3:	be 00 00 00 00       	mov    $0x0,%esi
  8033c8:	bf 08 00 00 00       	mov    $0x8,%edi
  8033cd:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
}
  8033d9:	5d                   	pop    %rbp
  8033da:	c3                   	retq   

00000000008033db <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033db:	55                   	push   %rbp
  8033dc:	48 89 e5             	mov    %rsp,%rbp
  8033df:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033e6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033ed:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033f4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033fb:	be 00 00 00 00       	mov    $0x0,%esi
  803400:	48 89 c7             	mov    %rax,%rdi
  803403:	48 b8 a0 2f 80 00 00 	movabs $0x802fa0,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
  80340f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803412:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803416:	79 28                	jns    803440 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341b:	89 c6                	mov    %eax,%esi
  80341d:	48 bf 9a 51 80 00 00 	movabs $0x80519a,%rdi
  803424:	00 00 00 
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803433:	00 00 00 
  803436:	ff d2                	callq  *%rdx
		return fd_src;
  803438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343b:	e9 74 01 00 00       	jmpq   8035b4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803440:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803447:	be 01 01 00 00       	mov    $0x101,%esi
  80344c:	48 89 c7             	mov    %rax,%rdi
  80344f:	48 b8 a0 2f 80 00 00 	movabs $0x802fa0,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80345e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803462:	79 39                	jns    80349d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803464:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803467:	89 c6                	mov    %eax,%esi
  803469:	48 bf b0 51 80 00 00 	movabs $0x8051b0,%rdi
  803470:	00 00 00 
  803473:	b8 00 00 00 00       	mov    $0x0,%eax
  803478:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  80347f:	00 00 00 
  803482:	ff d2                	callq  *%rdx
		close(fd_src);
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803487:	89 c7                	mov    %eax,%edi
  803489:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
		return fd_dest;
  803495:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803498:	e9 17 01 00 00       	jmpq   8035b4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80349d:	eb 74                	jmp    803513 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80349f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a2:	48 63 d0             	movslq %eax,%rdx
  8034a5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034af:	48 89 ce             	mov    %rcx,%rsi
  8034b2:	89 c7                	mov    %eax,%edi
  8034b4:	48 b8 14 2c 80 00 00 	movabs $0x802c14,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
  8034c0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034c7:	79 4a                	jns    803513 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8034c9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034cc:	89 c6                	mov    %eax,%esi
  8034ce:	48 bf ca 51 80 00 00 	movabs $0x8051ca,%rdi
  8034d5:	00 00 00 
  8034d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dd:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  8034e4:	00 00 00 
  8034e7:	ff d2                	callq  *%rdx
			close(fd_src);
  8034e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ec:	89 c7                	mov    %eax,%edi
  8034ee:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  8034f5:	00 00 00 
  8034f8:	ff d0                	callq  *%rax
			close(fd_dest);
  8034fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034fd:	89 c7                	mov    %eax,%edi
  8034ff:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
			return write_size;
  80350b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80350e:	e9 a1 00 00 00       	jmpq   8035b4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803513:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80351a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351d:	ba 00 02 00 00       	mov    $0x200,%edx
  803522:	48 89 ce             	mov    %rcx,%rsi
  803525:	89 c7                	mov    %eax,%edi
  803527:	48 b8 ca 2a 80 00 00 	movabs $0x802aca,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
  803533:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803536:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80353a:	0f 8f 5f ff ff ff    	jg     80349f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803540:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803544:	79 47                	jns    80358d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803546:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803549:	89 c6                	mov    %eax,%esi
  80354b:	48 bf dd 51 80 00 00 	movabs $0x8051dd,%rdi
  803552:	00 00 00 
  803555:	b8 00 00 00 00       	mov    $0x0,%eax
  80355a:	48 ba fb 06 80 00 00 	movabs $0x8006fb,%rdx
  803561:	00 00 00 
  803564:	ff d2                	callq  *%rdx
		close(fd_src);
  803566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803569:	89 c7                	mov    %eax,%edi
  80356b:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
		close(fd_dest);
  803577:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80357a:	89 c7                	mov    %eax,%edi
  80357c:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
		return read_size;
  803588:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80358b:	eb 27                	jmp    8035b4 <copy+0x1d9>
	}
	close(fd_src);
  80358d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803590:	89 c7                	mov    %eax,%edi
  803592:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
	close(fd_dest);
  80359e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a1:	89 c7                	mov    %eax,%edi
  8035a3:	48 b8 a8 28 80 00 00 	movabs $0x8028a8,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
	return 0;
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8035b4:	c9                   	leaveq 
  8035b5:	c3                   	retq   

00000000008035b6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8035b6:	55                   	push   %rbp
  8035b7:	48 89 e5             	mov    %rsp,%rbp
  8035ba:	48 83 ec 20          	sub    $0x20,%rsp
  8035be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c8:	48 89 d6             	mov    %rdx,%rsi
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e0:	79 05                	jns    8035e7 <fd2sockid+0x31>
		return r;
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	eb 24                	jmp    80360b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8035e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035eb:	8b 10                	mov    (%rax),%edx
  8035ed:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8035f4:	00 00 00 
  8035f7:	8b 00                	mov    (%rax),%eax
  8035f9:	39 c2                	cmp    %eax,%edx
  8035fb:	74 07                	je     803604 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8035fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803602:	eb 07                	jmp    80360b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803608:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80360b:	c9                   	leaveq 
  80360c:	c3                   	retq   

000000000080360d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80360d:	55                   	push   %rbp
  80360e:	48 89 e5             	mov    %rsp,%rbp
  803611:	48 83 ec 20          	sub    $0x20,%rsp
  803615:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803618:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80361c:	48 89 c7             	mov    %rax,%rdi
  80361f:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
  80362b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803632:	78 26                	js     80365a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803638:	ba 07 04 00 00       	mov    $0x407,%edx
  80363d:	48 89 c6             	mov    %rax,%rsi
  803640:	bf 00 00 00 00       	mov    $0x0,%edi
  803645:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
  803651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803658:	79 16                	jns    803670 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80365a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80365d:	89 c7                	mov    %eax,%edi
  80365f:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
		return r;
  80366b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366e:	eb 3a                	jmp    8036aa <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803674:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80367b:	00 00 00 
  80367e:	8b 12                	mov    (%rdx),%edx
  803680:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803686:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80368d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803691:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803694:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369b:	48 89 c7             	mov    %rax,%rdi
  80369e:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
}
  8036aa:	c9                   	leaveq 
  8036ab:	c3                   	retq   

00000000008036ac <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036ac:	55                   	push   %rbp
  8036ad:	48 89 e5             	mov    %rsp,%rbp
  8036b0:	48 83 ec 30          	sub    $0x30,%rsp
  8036b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
  8036d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d7:	79 05                	jns    8036de <accept+0x32>
		return r;
  8036d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036dc:	eb 3b                	jmp    803719 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8036de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036e2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e9:	48 89 ce             	mov    %rcx,%rsi
  8036ec:	89 c7                	mov    %eax,%edi
  8036ee:	48 b8 f7 39 80 00 00 	movabs $0x8039f7,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
  8036fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803701:	79 05                	jns    803708 <accept+0x5c>
		return r;
  803703:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803706:	eb 11                	jmp    803719 <accept+0x6d>
	return alloc_sockfd(r);
  803708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370b:	89 c7                	mov    %eax,%edi
  80370d:	48 b8 0d 36 80 00 00 	movabs $0x80360d,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
}
  803719:	c9                   	leaveq 
  80371a:	c3                   	retq   

000000000080371b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80371b:	55                   	push   %rbp
  80371c:	48 89 e5             	mov    %rsp,%rbp
  80371f:	48 83 ec 20          	sub    $0x20,%rsp
  803723:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803726:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80372a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80372d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803730:	89 c7                	mov    %eax,%edi
  803732:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  803739:	00 00 00 
  80373c:	ff d0                	callq  *%rax
  80373e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803741:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803745:	79 05                	jns    80374c <bind+0x31>
		return r;
  803747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374a:	eb 1b                	jmp    803767 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80374c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80374f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803756:	48 89 ce             	mov    %rcx,%rsi
  803759:	89 c7                	mov    %eax,%edi
  80375b:	48 b8 76 3a 80 00 00 	movabs $0x803a76,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <shutdown>:

int
shutdown(int s, int how)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 20          	sub    $0x20,%rsp
  803771:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803774:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803777:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377a:	89 c7                	mov    %eax,%edi
  80377c:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378f:	79 05                	jns    803796 <shutdown+0x2d>
		return r;
  803791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803794:	eb 16                	jmp    8037ac <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803796:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379c:	89 d6                	mov    %edx,%esi
  80379e:	89 c7                	mov    %eax,%edi
  8037a0:	48 b8 da 3a 80 00 00 	movabs $0x803ada,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	callq  *%rax
}
  8037ac:	c9                   	leaveq 
  8037ad:	c3                   	retq   

00000000008037ae <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8037ae:	55                   	push   %rbp
  8037af:	48 89 e5             	mov    %rsp,%rbp
  8037b2:	48 83 ec 10          	sub    $0x10,%rsp
  8037b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8037ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037be:	48 89 c7             	mov    %rax,%rdi
  8037c1:	48 b8 68 49 80 00 00 	movabs $0x804968,%rax
  8037c8:	00 00 00 
  8037cb:	ff d0                	callq  *%rax
  8037cd:	83 f8 01             	cmp    $0x1,%eax
  8037d0:	75 17                	jne    8037e9 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8037d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d6:	8b 40 0c             	mov    0xc(%rax),%eax
  8037d9:	89 c7                	mov    %eax,%edi
  8037db:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
  8037e7:	eb 05                	jmp    8037ee <devsock_close+0x40>
	else
		return 0;
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ee:	c9                   	leaveq 
  8037ef:	c3                   	retq   

00000000008037f0 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037f0:	55                   	push   %rbp
  8037f1:	48 89 e5             	mov    %rsp,%rbp
  8037f4:	48 83 ec 20          	sub    $0x20,%rsp
  8037f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ff:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803802:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803805:	89 c7                	mov    %eax,%edi
  803807:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803816:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381a:	79 05                	jns    803821 <connect+0x31>
		return r;
  80381c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381f:	eb 1b                	jmp    80383c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803821:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803824:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382b:	48 89 ce             	mov    %rcx,%rsi
  80382e:	89 c7                	mov    %eax,%edi
  803830:	48 b8 47 3b 80 00 00 	movabs $0x803b47,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
}
  80383c:	c9                   	leaveq 
  80383d:	c3                   	retq   

000000000080383e <listen>:

int
listen(int s, int backlog)
{
  80383e:	55                   	push   %rbp
  80383f:	48 89 e5             	mov    %rsp,%rbp
  803842:	48 83 ec 20          	sub    $0x20,%rsp
  803846:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803849:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384f:	89 c7                	mov    %eax,%edi
  803851:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
  80385d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803864:	79 05                	jns    80386b <listen+0x2d>
		return r;
  803866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803869:	eb 16                	jmp    803881 <listen+0x43>
	return nsipc_listen(r, backlog);
  80386b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80386e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803871:	89 d6                	mov    %edx,%esi
  803873:	89 c7                	mov    %eax,%edi
  803875:	48 b8 ab 3b 80 00 00 	movabs $0x803bab,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
}
  803881:	c9                   	leaveq 
  803882:	c3                   	retq   

0000000000803883 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803883:	55                   	push   %rbp
  803884:	48 89 e5             	mov    %rsp,%rbp
  803887:	48 83 ec 20          	sub    $0x20,%rsp
  80388b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80388f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803893:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389b:	89 c2                	mov    %eax,%edx
  80389d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a1:	8b 40 0c             	mov    0xc(%rax),%eax
  8038a4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038ad:	89 c7                	mov    %eax,%edi
  8038af:	48 b8 eb 3b 80 00 00 	movabs $0x803beb,%rax
  8038b6:	00 00 00 
  8038b9:	ff d0                	callq  *%rax
}
  8038bb:	c9                   	leaveq 
  8038bc:	c3                   	retq   

00000000008038bd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8038bd:	55                   	push   %rbp
  8038be:	48 89 e5             	mov    %rsp,%rbp
  8038c1:	48 83 ec 20          	sub    $0x20,%rsp
  8038c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8038d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d5:	89 c2                	mov    %eax,%edx
  8038d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038db:	8b 40 0c             	mov    0xc(%rax),%eax
  8038de:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038e7:	89 c7                	mov    %eax,%edi
  8038e9:	48 b8 b7 3c 80 00 00 	movabs $0x803cb7,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
}
  8038f5:	c9                   	leaveq 
  8038f6:	c3                   	retq   

00000000008038f7 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8038f7:	55                   	push   %rbp
  8038f8:	48 89 e5             	mov    %rsp,%rbp
  8038fb:	48 83 ec 10          	sub    $0x10,%rsp
  8038ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803903:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390b:	48 be f8 51 80 00 00 	movabs $0x8051f8,%rsi
  803912:	00 00 00 
  803915:	48 89 c7             	mov    %rax,%rdi
  803918:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
	return 0;
  803924:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803929:	c9                   	leaveq 
  80392a:	c3                   	retq   

000000000080392b <socket>:

int
socket(int domain, int type, int protocol)
{
  80392b:	55                   	push   %rbp
  80392c:	48 89 e5             	mov    %rsp,%rbp
  80392f:	48 83 ec 20          	sub    $0x20,%rsp
  803933:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803936:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803939:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80393c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80393f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803942:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803945:	89 ce                	mov    %ecx,%esi
  803947:	89 c7                	mov    %eax,%edi
  803949:	48 b8 6f 3d 80 00 00 	movabs $0x803d6f,%rax
  803950:	00 00 00 
  803953:	ff d0                	callq  *%rax
  803955:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803958:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395c:	79 05                	jns    803963 <socket+0x38>
		return r;
  80395e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803961:	eb 11                	jmp    803974 <socket+0x49>
	return alloc_sockfd(r);
  803963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803966:	89 c7                	mov    %eax,%edi
  803968:	48 b8 0d 36 80 00 00 	movabs $0x80360d,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
}
  803974:	c9                   	leaveq 
  803975:	c3                   	retq   

0000000000803976 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803976:	55                   	push   %rbp
  803977:	48 89 e5             	mov    %rsp,%rbp
  80397a:	48 83 ec 10          	sub    $0x10,%rsp
  80397e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803981:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803988:	00 00 00 
  80398b:	8b 00                	mov    (%rax),%eax
  80398d:	85 c0                	test   %eax,%eax
  80398f:	75 1d                	jne    8039ae <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803991:	bf 02 00 00 00       	mov    $0x2,%edi
  803996:	48 b8 e6 48 80 00 00 	movabs $0x8048e6,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8039a9:	00 00 00 
  8039ac:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039ae:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039b5:	00 00 00 
  8039b8:	8b 00                	mov    (%rax),%eax
  8039ba:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8039bd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8039c2:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8039c9:	00 00 00 
  8039cc:	89 c7                	mov    %eax,%edi
  8039ce:	48 b8 84 48 80 00 00 	movabs $0x804884,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8039da:	ba 00 00 00 00       	mov    $0x0,%edx
  8039df:	be 00 00 00 00       	mov    $0x0,%esi
  8039e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e9:	48 b8 7e 47 80 00 00 	movabs $0x80477e,%rax
  8039f0:	00 00 00 
  8039f3:	ff d0                	callq  *%rax
}
  8039f5:	c9                   	leaveq 
  8039f6:	c3                   	retq   

00000000008039f7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039f7:	55                   	push   %rbp
  8039f8:	48 89 e5             	mov    %rsp,%rbp
  8039fb:	48 83 ec 30          	sub    $0x30,%rsp
  8039ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a0a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a11:	00 00 00 
  803a14:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a17:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a19:	bf 01 00 00 00       	mov    $0x1,%edi
  803a1e:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803a25:	00 00 00 
  803a28:	ff d0                	callq  *%rax
  803a2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a31:	78 3e                	js     803a71 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a33:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a3a:	00 00 00 
  803a3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a45:	8b 40 10             	mov    0x10(%rax),%eax
  803a48:	89 c2                	mov    %eax,%edx
  803a4a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a52:	48 89 ce             	mov    %rcx,%rsi
  803a55:	48 89 c7             	mov    %rax,%rdi
  803a58:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803a5f:	00 00 00 
  803a62:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a68:	8b 50 10             	mov    0x10(%rax),%edx
  803a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a74:	c9                   	leaveq 
  803a75:	c3                   	retq   

0000000000803a76 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a76:	55                   	push   %rbp
  803a77:	48 89 e5             	mov    %rsp,%rbp
  803a7a:	48 83 ec 10          	sub    $0x10,%rsp
  803a7e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a85:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a88:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a8f:	00 00 00 
  803a92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a95:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a97:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9e:	48 89 c6             	mov    %rax,%rsi
  803aa1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803aa8:	00 00 00 
  803aab:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803ab7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803abe:	00 00 00 
  803ac1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ac4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ac7:	bf 02 00 00 00       	mov    $0x2,%edi
  803acc:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
}
  803ad8:	c9                   	leaveq 
  803ad9:	c3                   	retq   

0000000000803ada <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ada:	55                   	push   %rbp
  803adb:	48 89 e5             	mov    %rsp,%rbp
  803ade:	48 83 ec 10          	sub    $0x10,%rsp
  803ae2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ae5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ae8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aef:	00 00 00 
  803af2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803af7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803afe:	00 00 00 
  803b01:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b04:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b07:	bf 03 00 00 00       	mov    $0x3,%edi
  803b0c:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
}
  803b18:	c9                   	leaveq 
  803b19:	c3                   	retq   

0000000000803b1a <nsipc_close>:

int
nsipc_close(int s)
{
  803b1a:	55                   	push   %rbp
  803b1b:	48 89 e5             	mov    %rsp,%rbp
  803b1e:	48 83 ec 10          	sub    $0x10,%rsp
  803b22:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b25:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b2c:	00 00 00 
  803b2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b32:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b34:	bf 04 00 00 00       	mov    $0x4,%edi
  803b39:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
}
  803b45:	c9                   	leaveq 
  803b46:	c3                   	retq   

0000000000803b47 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b47:	55                   	push   %rbp
  803b48:	48 89 e5             	mov    %rsp,%rbp
  803b4b:	48 83 ec 10          	sub    $0x10,%rsp
  803b4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b56:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803b59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b60:	00 00 00 
  803b63:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b66:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b68:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6f:	48 89 c6             	mov    %rax,%rsi
  803b72:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b79:	00 00 00 
  803b7c:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b88:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8f:	00 00 00 
  803b92:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b95:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b98:	bf 05 00 00 00       	mov    $0x5,%edi
  803b9d:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803ba4:	00 00 00 
  803ba7:	ff d0                	callq  *%rax
}
  803ba9:	c9                   	leaveq 
  803baa:	c3                   	retq   

0000000000803bab <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803bab:	55                   	push   %rbp
  803bac:	48 89 e5             	mov    %rsp,%rbp
  803baf:	48 83 ec 10          	sub    $0x10,%rsp
  803bb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bb6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803bb9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc0:	00 00 00 
  803bc3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bc6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803bc8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bcf:	00 00 00 
  803bd2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bd5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803bd8:	bf 06 00 00 00       	mov    $0x6,%edi
  803bdd:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
}
  803be9:	c9                   	leaveq 
  803bea:	c3                   	retq   

0000000000803beb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803beb:	55                   	push   %rbp
  803bec:	48 89 e5             	mov    %rsp,%rbp
  803bef:	48 83 ec 30          	sub    $0x30,%rsp
  803bf3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bfa:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803bfd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c00:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c07:	00 00 00 
  803c0a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c0d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c16:	00 00 00 
  803c19:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c1c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c26:	00 00 00 
  803c29:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c2c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c2f:	bf 07 00 00 00       	mov    $0x7,%edi
  803c34:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803c3b:	00 00 00 
  803c3e:	ff d0                	callq  *%rax
  803c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c47:	78 69                	js     803cb2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c49:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803c50:	7f 08                	jg     803c5a <nsipc_recv+0x6f>
  803c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c55:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803c58:	7e 35                	jle    803c8f <nsipc_recv+0xa4>
  803c5a:	48 b9 ff 51 80 00 00 	movabs $0x8051ff,%rcx
  803c61:	00 00 00 
  803c64:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803c6b:	00 00 00 
  803c6e:	be 61 00 00 00       	mov    $0x61,%esi
  803c73:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803c7a:	00 00 00 
  803c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c82:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  803c89:	00 00 00 
  803c8c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c92:	48 63 d0             	movslq %eax,%rdx
  803c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c99:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803ca0:	00 00 00 
  803ca3:	48 89 c7             	mov    %rax,%rdi
  803ca6:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803cad:	00 00 00 
  803cb0:	ff d0                	callq  *%rax
	}

	return r;
  803cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cb5:	c9                   	leaveq 
  803cb6:	c3                   	retq   

0000000000803cb7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803cb7:	55                   	push   %rbp
  803cb8:	48 89 e5             	mov    %rsp,%rbp
  803cbb:	48 83 ec 20          	sub    $0x20,%rsp
  803cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cc6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803cc9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ccc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd3:	00 00 00 
  803cd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cd9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803cdb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803ce2:	7e 35                	jle    803d19 <nsipc_send+0x62>
  803ce4:	48 b9 35 52 80 00 00 	movabs $0x805235,%rcx
  803ceb:	00 00 00 
  803cee:	48 ba 14 52 80 00 00 	movabs $0x805214,%rdx
  803cf5:	00 00 00 
  803cf8:	be 6c 00 00 00       	mov    $0x6c,%esi
  803cfd:	48 bf 29 52 80 00 00 	movabs $0x805229,%rdi
  803d04:	00 00 00 
  803d07:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0c:	49 b8 c2 04 80 00 00 	movabs $0x8004c2,%r8
  803d13:	00 00 00 
  803d16:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d1c:	48 63 d0             	movslq %eax,%rdx
  803d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d23:	48 89 c6             	mov    %rax,%rsi
  803d26:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d2d:	00 00 00 
  803d30:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  803d37:	00 00 00 
  803d3a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d3c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d43:	00 00 00 
  803d46:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d49:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d4c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d53:	00 00 00 
  803d56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d59:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803d5c:	bf 08 00 00 00       	mov    $0x8,%edi
  803d61:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
}
  803d6d:	c9                   	leaveq 
  803d6e:	c3                   	retq   

0000000000803d6f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803d6f:	55                   	push   %rbp
  803d70:	48 89 e5             	mov    %rsp,%rbp
  803d73:	48 83 ec 10          	sub    $0x10,%rsp
  803d77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d7a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d7d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803d80:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d87:	00 00 00 
  803d8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d8d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d96:	00 00 00 
  803d99:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d9c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da6:	00 00 00 
  803da9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803dac:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803daf:	bf 09 00 00 00       	mov    $0x9,%edi
  803db4:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
}
  803dc0:	c9                   	leaveq 
  803dc1:	c3                   	retq   

0000000000803dc2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803dc2:	55                   	push   %rbp
  803dc3:	48 89 e5             	mov    %rsp,%rbp
  803dc6:	53                   	push   %rbx
  803dc7:	48 83 ec 38          	sub    $0x38,%rsp
  803dcb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803dcf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803dd3:	48 89 c7             	mov    %rax,%rdi
  803dd6:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803ddd:	00 00 00 
  803de0:	ff d0                	callq  *%rax
  803de2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803de5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803de9:	0f 88 bf 01 00 00    	js     803fae <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803def:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df3:	ba 07 04 00 00       	mov    $0x407,%edx
  803df8:	48 89 c6             	mov    %rax,%rsi
  803dfb:	bf 00 00 00 00       	mov    $0x0,%edi
  803e00:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e07:	00 00 00 
  803e0a:	ff d0                	callq  *%rax
  803e0c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e13:	0f 88 95 01 00 00    	js     803fae <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e19:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e1d:	48 89 c7             	mov    %rax,%rdi
  803e20:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  803e27:	00 00 00 
  803e2a:	ff d0                	callq  *%rax
  803e2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e33:	0f 88 5d 01 00 00    	js     803f96 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3d:	ba 07 04 00 00       	mov    $0x407,%edx
  803e42:	48 89 c6             	mov    %rax,%rsi
  803e45:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4a:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e51:	00 00 00 
  803e54:	ff d0                	callq  *%rax
  803e56:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e5d:	0f 88 33 01 00 00    	js     803f96 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e67:	48 89 c7             	mov    %rax,%rdi
  803e6a:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  803e71:	00 00 00 
  803e74:	ff d0                	callq  *%rax
  803e76:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e7e:	ba 07 04 00 00       	mov    $0x407,%edx
  803e83:	48 89 c6             	mov    %rax,%rsi
  803e86:	bf 00 00 00 00       	mov    $0x0,%edi
  803e8b:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803e92:	00 00 00 
  803e95:	ff d0                	callq  *%rax
  803e97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e9e:	79 05                	jns    803ea5 <pipe+0xe3>
		goto err2;
  803ea0:	e9 d9 00 00 00       	jmpq   803f7e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ea5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea9:	48 89 c7             	mov    %rax,%rdi
  803eac:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  803eb3:	00 00 00 
  803eb6:	ff d0                	callq  *%rax
  803eb8:	48 89 c2             	mov    %rax,%rdx
  803ebb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ebf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ec5:	48 89 d1             	mov    %rdx,%rcx
  803ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  803ecd:	48 89 c6             	mov    %rax,%rsi
  803ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed5:	48 b8 2f 1c 80 00 00 	movabs $0x801c2f,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
  803ee1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ee8:	79 1b                	jns    803f05 <pipe+0x143>
		goto err3;
  803eea:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803eeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eef:	48 89 c6             	mov    %rax,%rsi
  803ef2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef7:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	eb 79                	jmp    803f7e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f09:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f10:	00 00 00 
  803f13:	8b 12                	mov    (%rdx),%edx
  803f15:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f26:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f2d:	00 00 00 
  803f30:	8b 12                	mov    (%rdx),%edx
  803f32:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f38:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f43:	48 89 c7             	mov    %rax,%rdi
  803f46:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  803f4d:	00 00 00 
  803f50:	ff d0                	callq  *%rax
  803f52:	89 c2                	mov    %eax,%edx
  803f54:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f58:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f5e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f66:	48 89 c7             	mov    %rax,%rdi
  803f69:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  803f70:	00 00 00 
  803f73:	ff d0                	callq  *%rax
  803f75:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f77:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7c:	eb 33                	jmp    803fb1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f82:	48 89 c6             	mov    %rax,%rsi
  803f85:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8a:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803f91:	00 00 00 
  803f94:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f9a:	48 89 c6             	mov    %rax,%rsi
  803f9d:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa2:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  803fa9:	00 00 00 
  803fac:	ff d0                	callq  *%rax
err:
	return r;
  803fae:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fb1:	48 83 c4 38          	add    $0x38,%rsp
  803fb5:	5b                   	pop    %rbx
  803fb6:	5d                   	pop    %rbp
  803fb7:	c3                   	retq   

0000000000803fb8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fb8:	55                   	push   %rbp
  803fb9:	48 89 e5             	mov    %rsp,%rbp
  803fbc:	53                   	push   %rbx
  803fbd:	48 83 ec 28          	sub    $0x28,%rsp
  803fc1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fc5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fc9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fd0:	00 00 00 
  803fd3:	48 8b 00             	mov    (%rax),%rax
  803fd6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fdc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803fdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe3:	48 89 c7             	mov    %rax,%rdi
  803fe6:	48 b8 68 49 80 00 00 	movabs $0x804968,%rax
  803fed:	00 00 00 
  803ff0:	ff d0                	callq  *%rax
  803ff2:	89 c3                	mov    %eax,%ebx
  803ff4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff8:	48 89 c7             	mov    %rax,%rdi
  803ffb:	48 b8 68 49 80 00 00 	movabs $0x804968,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
  804007:	39 c3                	cmp    %eax,%ebx
  804009:	0f 94 c0             	sete   %al
  80400c:	0f b6 c0             	movzbl %al,%eax
  80400f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804012:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804019:	00 00 00 
  80401c:	48 8b 00             	mov    (%rax),%rax
  80401f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804025:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804028:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80402e:	75 05                	jne    804035 <_pipeisclosed+0x7d>
			return ret;
  804030:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804033:	eb 4f                	jmp    804084 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804035:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804038:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80403b:	74 42                	je     80407f <_pipeisclosed+0xc7>
  80403d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804041:	75 3c                	jne    80407f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804043:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80404a:	00 00 00 
  80404d:	48 8b 00             	mov    (%rax),%rax
  804050:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804056:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804059:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80405c:	89 c6                	mov    %eax,%esi
  80405e:	48 bf 46 52 80 00 00 	movabs $0x805246,%rdi
  804065:	00 00 00 
  804068:	b8 00 00 00 00       	mov    $0x0,%eax
  80406d:	49 b8 fb 06 80 00 00 	movabs $0x8006fb,%r8
  804074:	00 00 00 
  804077:	41 ff d0             	callq  *%r8
	}
  80407a:	e9 4a ff ff ff       	jmpq   803fc9 <_pipeisclosed+0x11>
  80407f:	e9 45 ff ff ff       	jmpq   803fc9 <_pipeisclosed+0x11>
}
  804084:	48 83 c4 28          	add    $0x28,%rsp
  804088:	5b                   	pop    %rbx
  804089:	5d                   	pop    %rbp
  80408a:	c3                   	retq   

000000000080408b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80408b:	55                   	push   %rbp
  80408c:	48 89 e5             	mov    %rsp,%rbp
  80408f:	48 83 ec 30          	sub    $0x30,%rsp
  804093:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804096:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80409a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80409d:	48 89 d6             	mov    %rdx,%rsi
  8040a0:	89 c7                	mov    %eax,%edi
  8040a2:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  8040a9:	00 00 00 
  8040ac:	ff d0                	callq  *%rax
  8040ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b5:	79 05                	jns    8040bc <pipeisclosed+0x31>
		return r;
  8040b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ba:	eb 31                	jmp    8040ed <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c0:	48 89 c7             	mov    %rax,%rdi
  8040c3:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040db:	48 89 d6             	mov    %rdx,%rsi
  8040de:	48 89 c7             	mov    %rax,%rdi
  8040e1:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
}
  8040ed:	c9                   	leaveq 
  8040ee:	c3                   	retq   

00000000008040ef <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040ef:	55                   	push   %rbp
  8040f0:	48 89 e5             	mov    %rsp,%rbp
  8040f3:	48 83 ec 40          	sub    $0x40,%rsp
  8040f7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040ff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80411a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804122:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804129:	00 
  80412a:	e9 92 00 00 00       	jmpq   8041c1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80412f:	eb 41                	jmp    804172 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804131:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804136:	74 09                	je     804141 <devpipe_read+0x52>
				return i;
  804138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413c:	e9 92 00 00 00       	jmpq   8041d3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804141:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804145:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804149:	48 89 d6             	mov    %rdx,%rsi
  80414c:	48 89 c7             	mov    %rax,%rdi
  80414f:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  804156:	00 00 00 
  804159:	ff d0                	callq  *%rax
  80415b:	85 c0                	test   %eax,%eax
  80415d:	74 07                	je     804166 <devpipe_read+0x77>
				return 0;
  80415f:	b8 00 00 00 00       	mov    $0x0,%eax
  804164:	eb 6d                	jmp    8041d3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804166:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  80416d:	00 00 00 
  804170:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804176:	8b 10                	mov    (%rax),%edx
  804178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417c:	8b 40 04             	mov    0x4(%rax),%eax
  80417f:	39 c2                	cmp    %eax,%edx
  804181:	74 ae                	je     804131 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804187:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80418b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80418f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804193:	8b 00                	mov    (%rax),%eax
  804195:	99                   	cltd   
  804196:	c1 ea 1b             	shr    $0x1b,%edx
  804199:	01 d0                	add    %edx,%eax
  80419b:	83 e0 1f             	and    $0x1f,%eax
  80419e:	29 d0                	sub    %edx,%eax
  8041a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a4:	48 98                	cltq   
  8041a6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041ab:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b1:	8b 00                	mov    (%rax),%eax
  8041b3:	8d 50 01             	lea    0x1(%rax),%edx
  8041b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ba:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041c5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041c9:	0f 82 60 ff ff ff    	jb     80412f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8041cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041d3:	c9                   	leaveq 
  8041d4:	c3                   	retq   

00000000008041d5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041d5:	55                   	push   %rbp
  8041d6:	48 89 e5             	mov    %rsp,%rbp
  8041d9:	48 83 ec 40          	sub    $0x40,%rsp
  8041dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ed:	48 89 c7             	mov    %rax,%rdi
  8041f0:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  8041f7:	00 00 00 
  8041fa:	ff d0                	callq  *%rax
  8041fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804200:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804204:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804208:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80420f:	00 
  804210:	e9 8e 00 00 00       	jmpq   8042a3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804215:	eb 31                	jmp    804248 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804217:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80421b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80421f:	48 89 d6             	mov    %rdx,%rsi
  804222:	48 89 c7             	mov    %rax,%rdi
  804225:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  80422c:	00 00 00 
  80422f:	ff d0                	callq  *%rax
  804231:	85 c0                	test   %eax,%eax
  804233:	74 07                	je     80423c <devpipe_write+0x67>
				return 0;
  804235:	b8 00 00 00 00       	mov    $0x0,%eax
  80423a:	eb 79                	jmp    8042b5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80423c:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  804243:	00 00 00 
  804246:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424c:	8b 40 04             	mov    0x4(%rax),%eax
  80424f:	48 63 d0             	movslq %eax,%rdx
  804252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804256:	8b 00                	mov    (%rax),%eax
  804258:	48 98                	cltq   
  80425a:	48 83 c0 20          	add    $0x20,%rax
  80425e:	48 39 c2             	cmp    %rax,%rdx
  804261:	73 b4                	jae    804217 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804267:	8b 40 04             	mov    0x4(%rax),%eax
  80426a:	99                   	cltd   
  80426b:	c1 ea 1b             	shr    $0x1b,%edx
  80426e:	01 d0                	add    %edx,%eax
  804270:	83 e0 1f             	and    $0x1f,%eax
  804273:	29 d0                	sub    %edx,%eax
  804275:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804279:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80427d:	48 01 ca             	add    %rcx,%rdx
  804280:	0f b6 0a             	movzbl (%rdx),%ecx
  804283:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804287:	48 98                	cltq   
  804289:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80428d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804291:	8b 40 04             	mov    0x4(%rax),%eax
  804294:	8d 50 01             	lea    0x1(%rax),%edx
  804297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80429e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042ab:	0f 82 64 ff ff ff    	jb     804215 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042b5:	c9                   	leaveq 
  8042b6:	c3                   	retq   

00000000008042b7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042b7:	55                   	push   %rbp
  8042b8:	48 89 e5             	mov    %rsp,%rbp
  8042bb:	48 83 ec 20          	sub    $0x20,%rsp
  8042bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042cb:	48 89 c7             	mov    %rax,%rdi
  8042ce:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
  8042da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042e2:	48 be 59 52 80 00 00 	movabs $0x805259,%rsi
  8042e9:	00 00 00 
  8042ec:	48 89 c7             	mov    %rax,%rdi
  8042ef:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8042f6:	00 00 00 
  8042f9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8042fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ff:	8b 50 04             	mov    0x4(%rax),%edx
  804302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804306:	8b 00                	mov    (%rax),%eax
  804308:	29 c2                	sub    %eax,%edx
  80430a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80430e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804314:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804318:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80431f:	00 00 00 
	stat->st_dev = &devpipe;
  804322:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804326:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80432d:	00 00 00 
  804330:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80433c:	c9                   	leaveq 
  80433d:	c3                   	retq   

000000000080433e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80433e:	55                   	push   %rbp
  80433f:	48 89 e5             	mov    %rsp,%rbp
  804342:	48 83 ec 10          	sub    $0x10,%rsp
  804346:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80434a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80434e:	48 89 c6             	mov    %rax,%rsi
  804351:	bf 00 00 00 00       	mov    $0x0,%edi
  804356:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  80435d:	00 00 00 
  804360:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804366:	48 89 c7             	mov    %rax,%rdi
  804369:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  804370:	00 00 00 
  804373:	ff d0                	callq  *%rax
  804375:	48 89 c6             	mov    %rax,%rsi
  804378:	bf 00 00 00 00       	mov    $0x0,%edi
  80437d:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  804384:	00 00 00 
  804387:	ff d0                	callq  *%rax
}
  804389:	c9                   	leaveq 
  80438a:	c3                   	retq   

000000000080438b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80438b:	55                   	push   %rbp
  80438c:	48 89 e5             	mov    %rsp,%rbp
  80438f:	48 83 ec 20          	sub    $0x20,%rsp
  804393:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804396:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804399:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80439c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043a0:	be 01 00 00 00       	mov    $0x1,%esi
  8043a5:	48 89 c7             	mov    %rax,%rdi
  8043a8:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8043af:	00 00 00 
  8043b2:	ff d0                	callq  *%rax
}
  8043b4:	c9                   	leaveq 
  8043b5:	c3                   	retq   

00000000008043b6 <getchar>:

int
getchar(void)
{
  8043b6:	55                   	push   %rbp
  8043b7:	48 89 e5             	mov    %rsp,%rbp
  8043ba:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043be:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8043c7:	48 89 c6             	mov    %rax,%rsi
  8043ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cf:	48 b8 ca 2a 80 00 00 	movabs $0x802aca,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
  8043db:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043e2:	79 05                	jns    8043e9 <getchar+0x33>
		return r;
  8043e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e7:	eb 14                	jmp    8043fd <getchar+0x47>
	if (r < 1)
  8043e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ed:	7f 07                	jg     8043f6 <getchar+0x40>
		return -E_EOF;
  8043ef:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8043f4:	eb 07                	jmp    8043fd <getchar+0x47>
	return c;
  8043f6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8043fa:	0f b6 c0             	movzbl %al,%eax
}
  8043fd:	c9                   	leaveq 
  8043fe:	c3                   	retq   

00000000008043ff <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8043ff:	55                   	push   %rbp
  804400:	48 89 e5             	mov    %rsp,%rbp
  804403:	48 83 ec 20          	sub    $0x20,%rsp
  804407:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80440a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80440e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804411:	48 89 d6             	mov    %rdx,%rsi
  804414:	89 c7                	mov    %eax,%edi
  804416:	48 b8 98 26 80 00 00 	movabs $0x802698,%rax
  80441d:	00 00 00 
  804420:	ff d0                	callq  *%rax
  804422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804429:	79 05                	jns    804430 <iscons+0x31>
		return r;
  80442b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442e:	eb 1a                	jmp    80444a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804434:	8b 10                	mov    (%rax),%edx
  804436:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80443d:	00 00 00 
  804440:	8b 00                	mov    (%rax),%eax
  804442:	39 c2                	cmp    %eax,%edx
  804444:	0f 94 c0             	sete   %al
  804447:	0f b6 c0             	movzbl %al,%eax
}
  80444a:	c9                   	leaveq 
  80444b:	c3                   	retq   

000000000080444c <opencons>:

int
opencons(void)
{
  80444c:	55                   	push   %rbp
  80444d:	48 89 e5             	mov    %rsp,%rbp
  804450:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804454:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804458:	48 89 c7             	mov    %rax,%rdi
  80445b:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
  804467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80446a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446e:	79 05                	jns    804475 <opencons+0x29>
		return r;
  804470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804473:	eb 5b                	jmp    8044d0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804479:	ba 07 04 00 00       	mov    $0x407,%edx
  80447e:	48 89 c6             	mov    %rax,%rsi
  804481:	bf 00 00 00 00       	mov    $0x0,%edi
  804486:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
  804492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804499:	79 05                	jns    8044a0 <opencons+0x54>
		return r;
  80449b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449e:	eb 30                	jmp    8044d0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a4:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044ab:	00 00 00 
  8044ae:	8b 12                	mov    (%rdx),%edx
  8044b0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c1:	48 89 c7             	mov    %rax,%rdi
  8044c4:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  8044cb:	00 00 00 
  8044ce:	ff d0                	callq  *%rax
}
  8044d0:	c9                   	leaveq 
  8044d1:	c3                   	retq   

00000000008044d2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044d2:	55                   	push   %rbp
  8044d3:	48 89 e5             	mov    %rsp,%rbp
  8044d6:	48 83 ec 30          	sub    $0x30,%rsp
  8044da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044eb:	75 07                	jne    8044f4 <devcons_read+0x22>
		return 0;
  8044ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f2:	eb 4b                	jmp    80453f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8044f4:	eb 0c                	jmp    804502 <devcons_read+0x30>
		sys_yield();
  8044f6:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8044fd:	00 00 00 
  804500:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804502:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  804509:	00 00 00 
  80450c:	ff d0                	callq  *%rax
  80450e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804515:	74 df                	je     8044f6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804517:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80451b:	79 05                	jns    804522 <devcons_read+0x50>
		return c;
  80451d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804520:	eb 1d                	jmp    80453f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804522:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804526:	75 07                	jne    80452f <devcons_read+0x5d>
		return 0;
  804528:	b8 00 00 00 00       	mov    $0x0,%eax
  80452d:	eb 10                	jmp    80453f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80452f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804532:	89 c2                	mov    %eax,%edx
  804534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804538:	88 10                	mov    %dl,(%rax)
	return 1;
  80453a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80453f:	c9                   	leaveq 
  804540:	c3                   	retq   

0000000000804541 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804541:	55                   	push   %rbp
  804542:	48 89 e5             	mov    %rsp,%rbp
  804545:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80454c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804553:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80455a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804568:	eb 76                	jmp    8045e0 <devcons_write+0x9f>
		m = n - tot;
  80456a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804571:	89 c2                	mov    %eax,%edx
  804573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804576:	29 c2                	sub    %eax,%edx
  804578:	89 d0                	mov    %edx,%eax
  80457a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80457d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804580:	83 f8 7f             	cmp    $0x7f,%eax
  804583:	76 07                	jbe    80458c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804585:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80458c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80458f:	48 63 d0             	movslq %eax,%rdx
  804592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804595:	48 63 c8             	movslq %eax,%rcx
  804598:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80459f:	48 01 c1             	add    %rax,%rcx
  8045a2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045a9:	48 89 ce             	mov    %rcx,%rsi
  8045ac:	48 89 c7             	mov    %rax,%rdi
  8045af:	48 b8 d4 15 80 00 00 	movabs $0x8015d4,%rax
  8045b6:	00 00 00 
  8045b9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045be:	48 63 d0             	movslq %eax,%rdx
  8045c1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045c8:	48 89 d6             	mov    %rdx,%rsi
  8045cb:	48 89 c7             	mov    %rax,%rdi
  8045ce:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8045d5:	00 00 00 
  8045d8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045dd:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e3:	48 98                	cltq   
  8045e5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045ec:	0f 82 78 ff ff ff    	jb     80456a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8045f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045f5:	c9                   	leaveq 
  8045f6:	c3                   	retq   

00000000008045f7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8045f7:	55                   	push   %rbp
  8045f8:	48 89 e5             	mov    %rsp,%rbp
  8045fb:	48 83 ec 08          	sub    $0x8,%rsp
  8045ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804608:	c9                   	leaveq 
  804609:	c3                   	retq   

000000000080460a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80460a:	55                   	push   %rbp
  80460b:	48 89 e5             	mov    %rsp,%rbp
  80460e:	48 83 ec 10          	sub    $0x10,%rsp
  804612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804616:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80461a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80461e:	48 be 65 52 80 00 00 	movabs $0x805265,%rsi
  804625:	00 00 00 
  804628:	48 89 c7             	mov    %rax,%rdi
  80462b:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  804632:	00 00 00 
  804635:	ff d0                	callq  *%rax
	return 0;
  804637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80463c:	c9                   	leaveq 
  80463d:	c3                   	retq   

000000000080463e <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80463e:	55                   	push   %rbp
  80463f:	48 89 e5             	mov    %rsp,%rbp
  804642:	48 83 ec 10          	sub    $0x10,%rsp
  804646:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80464a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804651:	00 00 00 
  804654:	48 8b 00             	mov    (%rax),%rax
  804657:	48 85 c0             	test   %rax,%rax
  80465a:	0f 85 84 00 00 00    	jne    8046e4 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804660:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804667:	00 00 00 
  80466a:	48 8b 00             	mov    (%rax),%rax
  80466d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804673:	ba 07 00 00 00       	mov    $0x7,%edx
  804678:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80467d:	89 c7                	mov    %eax,%edi
  80467f:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  804686:	00 00 00 
  804689:	ff d0                	callq  *%rax
  80468b:	85 c0                	test   %eax,%eax
  80468d:	79 2a                	jns    8046b9 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80468f:	48 ba 70 52 80 00 00 	movabs $0x805270,%rdx
  804696:	00 00 00 
  804699:	be 23 00 00 00       	mov    $0x23,%esi
  80469e:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  8046a5:	00 00 00 
  8046a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ad:	48 b9 c2 04 80 00 00 	movabs $0x8004c2,%rcx
  8046b4:	00 00 00 
  8046b7:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8046b9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046c0:	00 00 00 
  8046c3:	48 8b 00             	mov    (%rax),%rax
  8046c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8046cc:	48 be f7 46 80 00 00 	movabs $0x8046f7,%rsi
  8046d3:	00 00 00 
  8046d6:	89 c7                	mov    %eax,%edi
  8046d8:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8046df:	00 00 00 
  8046e2:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046e4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046eb:	00 00 00 
  8046ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046f2:	48 89 10             	mov    %rdx,(%rax)
}
  8046f5:	c9                   	leaveq 
  8046f6:	c3                   	retq   

00000000008046f7 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046f7:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046fa:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804701:	00 00 00 
call *%rax
  804704:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804706:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80470d:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80470e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804715:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804716:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80471a:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80471d:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804724:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804725:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804729:	4c 8b 3c 24          	mov    (%rsp),%r15
  80472d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804732:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804737:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80473c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804741:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804746:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80474b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804750:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804755:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80475a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80475f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804764:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804769:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80476e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804773:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804777:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80477b:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80477c:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80477d:	c3                   	retq   

000000000080477e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80477e:	55                   	push   %rbp
  80477f:	48 89 e5             	mov    %rsp,%rbp
  804782:	48 83 ec 30          	sub    $0x30,%rsp
  804786:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80478a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80478e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804792:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804799:	00 00 00 
  80479c:	48 8b 00             	mov    (%rax),%rax
  80479f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8047a5:	85 c0                	test   %eax,%eax
  8047a7:	75 3c                	jne    8047e5 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8047a9:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8047b0:	00 00 00 
  8047b3:	ff d0                	callq  *%rax
  8047b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8047ba:	48 63 d0             	movslq %eax,%rdx
  8047bd:	48 89 d0             	mov    %rdx,%rax
  8047c0:	48 c1 e0 03          	shl    $0x3,%rax
  8047c4:	48 01 d0             	add    %rdx,%rax
  8047c7:	48 c1 e0 05          	shl    $0x5,%rax
  8047cb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8047d2:	00 00 00 
  8047d5:	48 01 c2             	add    %rax,%rdx
  8047d8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8047df:	00 00 00 
  8047e2:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8047e5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047ea:	75 0e                	jne    8047fa <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8047ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047f3:	00 00 00 
  8047f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8047fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047fe:	48 89 c7             	mov    %rax,%rdi
  804801:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  804808:	00 00 00 
  80480b:	ff d0                	callq  *%rax
  80480d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804810:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804814:	79 19                	jns    80482f <ipc_recv+0xb1>
		*from_env_store = 0;
  804816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80481a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804824:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80482a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482d:	eb 53                	jmp    804882 <ipc_recv+0x104>
	}
	if(from_env_store)
  80482f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804834:	74 19                	je     80484f <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804836:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80483d:	00 00 00 
  804840:	48 8b 00             	mov    (%rax),%rax
  804843:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80484d:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80484f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804854:	74 19                	je     80486f <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804856:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80485d:	00 00 00 
  804860:	48 8b 00             	mov    (%rax),%rax
  804863:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80486d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80486f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804876:	00 00 00 
  804879:	48 8b 00             	mov    (%rax),%rax
  80487c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804882:	c9                   	leaveq 
  804883:	c3                   	retq   

0000000000804884 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804884:	55                   	push   %rbp
  804885:	48 89 e5             	mov    %rsp,%rbp
  804888:	48 83 ec 30          	sub    $0x30,%rsp
  80488c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80488f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804892:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804896:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804899:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80489e:	75 0e                	jne    8048ae <ipc_send+0x2a>
		pg = (void*)UTOP;
  8048a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048a7:	00 00 00 
  8048aa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8048ae:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048b1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048bb:	89 c7                	mov    %eax,%edi
  8048bd:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8048c4:	00 00 00 
  8048c7:	ff d0                	callq  *%rax
  8048c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8048cc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048d0:	75 0c                	jne    8048de <ipc_send+0x5a>
			sys_yield();
  8048d2:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  8048d9:	00 00 00 
  8048dc:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8048de:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048e2:	74 ca                	je     8048ae <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8048e4:	c9                   	leaveq 
  8048e5:	c3                   	retq   

00000000008048e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8048e6:	55                   	push   %rbp
  8048e7:	48 89 e5             	mov    %rsp,%rbp
  8048ea:	48 83 ec 14          	sub    $0x14,%rsp
  8048ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8048f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048f8:	eb 5e                	jmp    804958 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804901:	00 00 00 
  804904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804907:	48 63 d0             	movslq %eax,%rdx
  80490a:	48 89 d0             	mov    %rdx,%rax
  80490d:	48 c1 e0 03          	shl    $0x3,%rax
  804911:	48 01 d0             	add    %rdx,%rax
  804914:	48 c1 e0 05          	shl    $0x5,%rax
  804918:	48 01 c8             	add    %rcx,%rax
  80491b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804921:	8b 00                	mov    (%rax),%eax
  804923:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804926:	75 2c                	jne    804954 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804928:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80492f:	00 00 00 
  804932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804935:	48 63 d0             	movslq %eax,%rdx
  804938:	48 89 d0             	mov    %rdx,%rax
  80493b:	48 c1 e0 03          	shl    $0x3,%rax
  80493f:	48 01 d0             	add    %rdx,%rax
  804942:	48 c1 e0 05          	shl    $0x5,%rax
  804946:	48 01 c8             	add    %rcx,%rax
  804949:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80494f:	8b 40 08             	mov    0x8(%rax),%eax
  804952:	eb 12                	jmp    804966 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804954:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804958:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80495f:	7e 99                	jle    8048fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804961:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804966:	c9                   	leaveq 
  804967:	c3                   	retq   

0000000000804968 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804968:	55                   	push   %rbp
  804969:	48 89 e5             	mov    %rsp,%rbp
  80496c:	48 83 ec 18          	sub    $0x18,%rsp
  804970:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804978:	48 c1 e8 15          	shr    $0x15,%rax
  80497c:	48 89 c2             	mov    %rax,%rdx
  80497f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804986:	01 00 00 
  804989:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80498d:	83 e0 01             	and    $0x1,%eax
  804990:	48 85 c0             	test   %rax,%rax
  804993:	75 07                	jne    80499c <pageref+0x34>
		return 0;
  804995:	b8 00 00 00 00       	mov    $0x0,%eax
  80499a:	eb 53                	jmp    8049ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80499c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8049a4:	48 89 c2             	mov    %rax,%rdx
  8049a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049ae:	01 00 00 
  8049b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8049b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049bd:	83 e0 01             	and    $0x1,%eax
  8049c0:	48 85 c0             	test   %rax,%rax
  8049c3:	75 07                	jne    8049cc <pageref+0x64>
		return 0;
  8049c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ca:	eb 23                	jmp    8049ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8049cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8049d4:	48 89 c2             	mov    %rax,%rdx
  8049d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049de:	00 00 00 
  8049e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8049e5:	48 01 d0             	add    %rdx,%rax
  8049e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049ec:	0f b7 c0             	movzwl %ax,%eax
}
  8049ef:	c9                   	leaveq 
  8049f0:	c3                   	retq   
