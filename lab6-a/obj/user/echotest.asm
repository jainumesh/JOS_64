
obj/user/echotest.debug:     file format elf64-x86-64


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
  80003c:	e8 d9 02 00 00       	callq  80031a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  80004f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800053:	48 89 c6             	mov    %rax,%rsi
  800056:	48 bf ee 45 80 00 00 	movabs $0x8045ee,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 a5 03 80 00 00 	movabs $0x8003a5,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <umain>:

void umain(int argc, char **argv)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 50          	sub    $0x50,%rsp
  800087:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80008a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80008e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("Connecting to:\n");
  800095:	48 bf f2 45 80 00 00 	movabs $0x8045f2,%rdi
  80009c:	00 00 00 
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8000ab:	00 00 00 
  8000ae:	ff d2                	callq  *%rdx
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  8000b0:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  8000b7:	00 00 00 
  8000ba:	48 b8 1d 41 80 00 00 	movabs $0x80411d,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	48 be 02 46 80 00 00 	movabs $0x804602,%rsi
  8000cf:	00 00 00 
  8000d2:	48 bf 0c 46 80 00 00 	movabs $0x80460c,%rdi
  8000d9:	00 00 00 
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  8000e8:	00 00 00 
  8000eb:	ff d1                	callq  *%rcx

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000ed:	ba 06 00 00 00       	mov    $0x6,%edx
  8000f2:	be 01 00 00 00       	mov    $0x1,%esi
  8000f7:	bf 02 00 00 00       	mov    $0x2,%edi
  8000fc:	48 b8 83 30 80 00 00 	movabs $0x803083,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
  800108:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80010b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80010f:	79 16                	jns    800127 <umain+0xa8>
		die("Failed to create socket");
  800111:	48 bf 21 46 80 00 00 	movabs $0x804621,%rdi
  800118:	00 00 00 
  80011b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  800127:	48 bf 39 46 80 00 00 	movabs $0x804639,%rdi
  80012e:	00 00 00 
  800131:	b8 00 00 00 00       	mov    $0x0,%eax
  800136:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  80013d:	00 00 00 
  800140:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800142:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800146:	ba 10 00 00 00       	mov    $0x10,%edx
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
  800150:	48 89 c7             	mov    %rax,%rdi
  800153:	48 b8 3b 13 80 00 00 	movabs $0x80133b,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80015f:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  800163:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  80016a:	00 00 00 
  80016d:	48 b8 1d 41 80 00 00 	movabs $0x80411d,%rax
  800174:	00 00 00 
  800177:	ff d0                	callq  *%rax
  800179:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  80017c:	bf 10 27 00 00       	mov    $0x2710,%edi
  800181:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  800188:	00 00 00 
  80018b:	ff d0                	callq  *%rax
  80018d:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to connect to server\n");
  800191:	48 bf 48 46 80 00 00 	movabs $0x804648,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8001a7:	00 00 00 
  8001aa:	ff d2                	callq  *%rdx

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8001ac:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8001b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b3:	ba 10 00 00 00       	mov    $0x10,%edx
  8001b8:	48 89 ce             	mov    %rcx,%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 48 2f 80 00 00 	movabs $0x802f48,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 16                	jns    8001e3 <umain+0x164>
		die("Failed to connect with server");
  8001cd:	48 bf 65 46 80 00 00 	movabs $0x804665,%rdi
  8001d4:	00 00 00 
  8001d7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax

	cprintf("connected to server\n");
  8001e3:	48 bf 83 46 80 00 00 	movabs $0x804683,%rdi
  8001ea:	00 00 00 
  8001ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f2:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8001f9:	00 00 00 
  8001fc:	ff d2                	callq  *%rdx

	// Send the word to the server
	echolen = strlen(msg);
  8001fe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800205:	00 00 00 
  800208:	48 8b 00             	mov    (%rax),%rax
  80020b:	48 89 c7             	mov    %rax,%rdi
  80020e:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
  80021a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(sock, msg, echolen) != echolen)
  80021d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800220:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800227:	00 00 00 
  80022a:	48 8b 08             	mov    (%rax),%rcx
  80022d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800230:	48 89 ce             	mov    %rcx,%rsi
  800233:	89 c7                	mov    %eax,%edi
  800235:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
  800241:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800244:	74 16                	je     80025c <umain+0x1dd>
		die("Mismatch in number of sent bytes");
  800246:	48 bf 98 46 80 00 00 	movabs $0x804698,%rdi
  80024d:	00 00 00 
  800250:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax

	// Receive the word back from the server
	cprintf("Received: \n");
  80025c:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  800263:	00 00 00 
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  800272:	00 00 00 
  800275:	ff d2                	callq  *%rdx
	while (received < echolen) {
  800277:	eb 6b                	jmp    8002e4 <umain+0x265>
		int bytes = 0;
  800279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800280:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800284:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800287:	ba 1f 00 00 00       	mov    $0x1f,%edx
  80028c:	48 89 ce             	mov    %rcx,%rsi
  80028f:	89 c7                	mov    %eax,%edi
  800291:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
  80029d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a4:	7f 16                	jg     8002bc <umain+0x23d>
			die("Failed to receive bytes from server");
  8002a6:	48 bf c8 46 80 00 00 	movabs $0x8046c8,%rdi
  8002ad:	00 00 00 
  8002b0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002b7:	00 00 00 
  8002ba:	ff d0                	callq  *%rax
		}
		received += bytes;
  8002bc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002bf:	01 45 fc             	add    %eax,-0x4(%rbp)
		buffer[bytes] = '\0';        // Assure null terminated string
  8002c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002c5:	48 98                	cltq   
  8002c7:	c6 44 05 c0 00       	movb   $0x0,-0x40(%rbp,%rax,1)
		cprintf(buffer);
  8002cc:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8002d0:	48 89 c7             	mov    %rax,%rdi
  8002d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d8:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8002df:	00 00 00 
  8002e2:	ff d2                	callq  *%rdx
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8002e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002ea:	72 8d                	jb     800279 <umain+0x1fa>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8002ec:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  800302:	00 00 00 
  800305:	ff d2                	callq  *%rdx

	close(sock);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	89 c7                	mov    %eax,%edi
  80030c:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 83 ec 10          	sub    $0x10,%rsp
  800322:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800325:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800329:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
  800335:	25 ff 03 00 00       	and    $0x3ff,%eax
  80033a:	48 63 d0             	movslq %eax,%rdx
  80033d:	48 89 d0             	mov    %rdx,%rax
  800340:	48 c1 e0 03          	shl    $0x3,%rax
  800344:	48 01 d0             	add    %rdx,%rax
  800347:	48 c1 e0 05          	shl    $0x5,%rax
  80034b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800352:	00 00 00 
  800355:	48 01 c2             	add    %rax,%rdx
  800358:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80035f:	00 00 00 
  800362:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800369:	7e 14                	jle    80037f <libmain+0x65>
		binaryname = argv[0];
  80036b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036f:	48 8b 10             	mov    (%rax),%rdx
  800372:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800379:	00 00 00 
  80037c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80037f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800383:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800386:	48 89 d6             	mov    %rdx,%rsi
  800389:	89 c7                	mov    %eax,%edi
  80038b:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800397:	48 b8 a5 03 80 00 00 	movabs $0x8003a5,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
}
  8003a3:	c9                   	leaveq 
  8003a4:	c3                   	retq   

00000000008003a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a5:	55                   	push   %rbp
  8003a6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003a9:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8003b0:	00 00 00 
  8003b3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ba:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax

}
  8003c6:	5d                   	pop    %rbp
  8003c7:	c3                   	retq   

00000000008003c8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	48 83 ec 10          	sub    $0x10,%rsp
  8003d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	8b 00                	mov    (%rax),%eax
  8003dd:	8d 48 01             	lea    0x1(%rax),%ecx
  8003e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e4:	89 0a                	mov    %ecx,(%rdx)
  8003e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003e9:	89 d1                	mov    %edx,%ecx
  8003eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ef:	48 98                	cltq   
  8003f1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f9:	8b 00                	mov    (%rax),%eax
  8003fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800400:	75 2c                	jne    80042e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800406:	8b 00                	mov    (%rax),%eax
  800408:	48 98                	cltq   
  80040a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040e:	48 83 c2 08          	add    $0x8,%rdx
  800412:	48 89 c6             	mov    %rax,%rsi
  800415:	48 89 d7             	mov    %rdx,%rdi
  800418:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  80041f:	00 00 00 
  800422:	ff d0                	callq  *%rax
        b->idx = 0;
  800424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800428:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80042e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800432:	8b 40 04             	mov    0x4(%rax),%eax
  800435:	8d 50 01             	lea    0x1(%rax),%edx
  800438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80043f:	c9                   	leaveq 
  800440:	c3                   	retq   

0000000000800441 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800441:	55                   	push   %rbp
  800442:	48 89 e5             	mov    %rsp,%rbp
  800445:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80044c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800453:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80045a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800461:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800468:	48 8b 0a             	mov    (%rdx),%rcx
  80046b:	48 89 08             	mov    %rcx,(%rax)
  80046e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800472:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800476:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80047a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80047e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800485:	00 00 00 
    b.cnt = 0;
  800488:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80048f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800492:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800499:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004a0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004a7:	48 89 c6             	mov    %rax,%rsi
  8004aa:	48 bf c8 03 80 00 00 	movabs $0x8003c8,%rdi
  8004b1:	00 00 00 
  8004b4:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004c0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004c6:	48 98                	cltq   
  8004c8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004cf:	48 83 c2 08          	add    $0x8,%rdx
  8004d3:	48 89 c6             	mov    %rax,%rsi
  8004d6:	48 89 d7             	mov    %rdx,%rdi
  8004d9:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004f8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ff:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800506:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80050d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800514:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80051b:	84 c0                	test   %al,%al
  80051d:	74 20                	je     80053f <cprintf+0x52>
  80051f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800523:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800527:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80052b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80052f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800533:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800537:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80053b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80053f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800546:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80054d:	00 00 00 
  800550:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800557:	00 00 00 
  80055a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80055e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800565:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80056c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800573:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80057a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800581:	48 8b 0a             	mov    (%rdx),%rcx
  800584:	48 89 08             	mov    %rcx,(%rax)
  800587:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80058b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800593:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800597:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80059e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a5:	48 89 d6             	mov    %rdx,%rsi
  8005a8:	48 89 c7             	mov    %rax,%rdi
  8005ab:	48 b8 41 04 80 00 00 	movabs $0x800441,%rax
  8005b2:	00 00 00 
  8005b5:	ff d0                	callq  *%rax
  8005b7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005bd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005c3:	c9                   	leaveq 
  8005c4:	c3                   	retq   

00000000008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %rbp
  8005c6:	48 89 e5             	mov    %rsp,%rbp
  8005c9:	53                   	push   %rbx
  8005ca:	48 83 ec 38          	sub    $0x38,%rsp
  8005ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005da:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005dd:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005e1:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005e8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ec:	77 3b                	ja     800629 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ee:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005f1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005f5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800601:	48 f7 f3             	div    %rbx
  800604:	48 89 c2             	mov    %rax,%rdx
  800607:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80060a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	41 89 f9             	mov    %edi,%r9d
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
  800627:	eb 1e                	jmp    800647 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800629:	eb 12                	jmp    80063d <printnum+0x78>
			putch(padc, putdat);
  80062b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80062f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	48 89 ce             	mov    %rcx,%rsi
  800639:	89 d7                	mov    %edx,%edi
  80063b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800641:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800645:	7f e4                	jg     80062b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800647:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80064a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80064e:	ba 00 00 00 00       	mov    $0x0,%edx
  800653:	48 f7 f1             	div    %rcx
  800656:	48 89 d0             	mov    %rdx,%rax
  800659:	48 ba f0 48 80 00 00 	movabs $0x8048f0,%rdx
  800660:	00 00 00 
  800663:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800667:	0f be d0             	movsbl %al,%edx
  80066a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80066e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800672:	48 89 ce             	mov    %rcx,%rsi
  800675:	89 d7                	mov    %edx,%edi
  800677:	ff d0                	callq  *%rax
}
  800679:	48 83 c4 38          	add    $0x38,%rsp
  80067d:	5b                   	pop    %rbx
  80067e:	5d                   	pop    %rbp
  80067f:	c3                   	retq   

0000000000800680 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
  800684:	48 83 ec 1c          	sub    $0x1c,%rsp
  800688:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80068c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80068f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800693:	7e 52                	jle    8006e7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	8b 00                	mov    (%rax),%eax
  80069b:	83 f8 30             	cmp    $0x30,%eax
  80069e:	73 24                	jae    8006c4 <getuint+0x44>
  8006a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	8b 00                	mov    (%rax),%eax
  8006ae:	89 c0                	mov    %eax,%eax
  8006b0:	48 01 d0             	add    %rdx,%rax
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	8b 12                	mov    (%rdx),%edx
  8006b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	89 0a                	mov    %ecx,(%rdx)
  8006c2:	eb 17                	jmp    8006db <getuint+0x5b>
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cc:	48 89 d0             	mov    %rdx,%rax
  8006cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006db:	48 8b 00             	mov    (%rax),%rax
  8006de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e2:	e9 a3 00 00 00       	jmpq   80078a <getuint+0x10a>
	else if (lflag)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006eb:	74 4f                	je     80073c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	83 f8 30             	cmp    $0x30,%eax
  8006f6:	73 24                	jae    80071c <getuint+0x9c>
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	8b 00                	mov    (%rax),%eax
  800706:	89 c0                	mov    %eax,%eax
  800708:	48 01 d0             	add    %rdx,%rax
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	8b 12                	mov    (%rdx),%edx
  800711:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	89 0a                	mov    %ecx,(%rdx)
  80071a:	eb 17                	jmp    800733 <getuint+0xb3>
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800724:	48 89 d0             	mov    %rdx,%rax
  800727:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800733:	48 8b 00             	mov    (%rax),%rax
  800736:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80073a:	eb 4e                	jmp    80078a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	83 f8 30             	cmp    $0x30,%eax
  800745:	73 24                	jae    80076b <getuint+0xeb>
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	89 c0                	mov    %eax,%eax
  800757:	48 01 d0             	add    %rdx,%rax
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	8b 12                	mov    (%rdx),%edx
  800760:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	89 0a                	mov    %ecx,(%rdx)
  800769:	eb 17                	jmp    800782 <getuint+0x102>
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800773:	48 89 d0             	mov    %rdx,%rax
  800776:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800782:	8b 00                	mov    (%rax),%eax
  800784:	89 c0                	mov    %eax,%eax
  800786:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80078a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80078e:	c9                   	leaveq 
  80078f:	c3                   	retq   

0000000000800790 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800790:	55                   	push   %rbp
  800791:	48 89 e5             	mov    %rsp,%rbp
  800794:	48 83 ec 1c          	sub    $0x1c,%rsp
  800798:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80079c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80079f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007a3:	7e 52                	jle    8007f7 <getint+0x67>
		x=va_arg(*ap, long long);
  8007a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a9:	8b 00                	mov    (%rax),%eax
  8007ab:	83 f8 30             	cmp    $0x30,%eax
  8007ae:	73 24                	jae    8007d4 <getint+0x44>
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	8b 00                	mov    (%rax),%eax
  8007be:	89 c0                	mov    %eax,%eax
  8007c0:	48 01 d0             	add    %rdx,%rax
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	8b 12                	mov    (%rdx),%edx
  8007c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d0:	89 0a                	mov    %ecx,(%rdx)
  8007d2:	eb 17                	jmp    8007eb <getint+0x5b>
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007dc:	48 89 d0             	mov    %rdx,%rax
  8007df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007eb:	48 8b 00             	mov    (%rax),%rax
  8007ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f2:	e9 a3 00 00 00       	jmpq   80089a <getint+0x10a>
	else if (lflag)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007fb:	74 4f                	je     80084c <getint+0xbc>
		x=va_arg(*ap, long);
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	8b 00                	mov    (%rax),%eax
  800803:	83 f8 30             	cmp    $0x30,%eax
  800806:	73 24                	jae    80082c <getint+0x9c>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	89 c0                	mov    %eax,%eax
  800818:	48 01 d0             	add    %rdx,%rax
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	8b 12                	mov    (%rdx),%edx
  800821:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	89 0a                	mov    %ecx,(%rdx)
  80082a:	eb 17                	jmp    800843 <getint+0xb3>
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800843:	48 8b 00             	mov    (%rax),%rax
  800846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084a:	eb 4e                	jmp    80089a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 24                	jae    80087b <getint+0xeb>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	89 c0                	mov    %eax,%eax
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	8b 12                	mov    (%rdx),%edx
  800870:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	89 0a                	mov    %ecx,(%rdx)
  800879:	eb 17                	jmp    800892 <getint+0x102>
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800883:	48 89 d0             	mov    %rdx,%rax
  800886:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800892:	8b 00                	mov    (%rax),%eax
  800894:	48 98                	cltq   
  800896:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80089a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80089e:	c9                   	leaveq 
  80089f:	c3                   	retq   

00000000008008a0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008a0:	55                   	push   %rbp
  8008a1:	48 89 e5             	mov    %rsp,%rbp
  8008a4:	41 54                	push   %r12
  8008a6:	53                   	push   %rbx
  8008a7:	48 83 ec 60          	sub    $0x60,%rsp
  8008ab:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008af:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008b3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008bf:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008c3:	48 8b 0a             	mov    (%rdx),%rcx
  8008c6:	48 89 08             	mov    %rcx,(%rax)
  8008c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d9:	eb 17                	jmp    8008f2 <vprintfmt+0x52>
			if (ch == '\0')
  8008db:	85 db                	test   %ebx,%ebx
  8008dd:	0f 84 cc 04 00 00    	je     800daf <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8008e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008eb:	48 89 d6             	mov    %rdx,%rsi
  8008ee:	89 df                	mov    %ebx,%edi
  8008f0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008fa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fe:	0f b6 00             	movzbl (%rax),%eax
  800901:	0f b6 d8             	movzbl %al,%ebx
  800904:	83 fb 25             	cmp    $0x25,%ebx
  800907:	75 d2                	jne    8008db <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800909:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80090d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800914:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800922:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800931:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f b6 d8             	movzbl %al,%ebx
  80093b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80093e:	83 f8 55             	cmp    $0x55,%eax
  800941:	0f 87 34 04 00 00    	ja     800d7b <vprintfmt+0x4db>
  800947:	89 c0                	mov    %eax,%eax
  800949:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800950:	00 
  800951:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  800958:	00 00 00 
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	48 8b 00             	mov    (%rax),%rax
  800961:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800963:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800967:	eb c0                	jmp    800929 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800969:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80096d:	eb ba                	jmp    800929 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800976:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800979:	89 d0                	mov    %edx,%eax
  80097b:	c1 e0 02             	shl    $0x2,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d8                	add    %ebx,%eax
  800984:	83 e8 30             	sub    $0x30,%eax
  800987:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80098a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098e:	0f b6 00             	movzbl (%rax),%eax
  800991:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800994:	83 fb 2f             	cmp    $0x2f,%ebx
  800997:	7e 0c                	jle    8009a5 <vprintfmt+0x105>
  800999:	83 fb 39             	cmp    $0x39,%ebx
  80099c:	7f 07                	jg     8009a5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a3:	eb d1                	jmp    800976 <vprintfmt+0xd6>
			goto process_precision;
  8009a5:	eb 58                	jmp    8009ff <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009aa:	83 f8 30             	cmp    $0x30,%eax
  8009ad:	73 17                	jae    8009c6 <vprintfmt+0x126>
  8009af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b6:	89 c0                	mov    %eax,%eax
  8009b8:	48 01 d0             	add    %rdx,%rax
  8009bb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009be:	83 c2 08             	add    $0x8,%edx
  8009c1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c4:	eb 0f                	jmp    8009d5 <vprintfmt+0x135>
  8009c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ca:	48 89 d0             	mov    %rdx,%rax
  8009cd:	48 83 c2 08          	add    $0x8,%rdx
  8009d1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009da:	eb 23                	jmp    8009ff <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e0:	79 0c                	jns    8009ee <vprintfmt+0x14e>
				width = 0;
  8009e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e9:	e9 3b ff ff ff       	jmpq   800929 <vprintfmt+0x89>
  8009ee:	e9 36 ff ff ff       	jmpq   800929 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009fa:	e9 2a ff ff ff       	jmpq   800929 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a03:	79 12                	jns    800a17 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a05:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a08:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a0b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a12:	e9 12 ff ff ff       	jmpq   800929 <vprintfmt+0x89>
  800a17:	e9 0d ff ff ff       	jmpq   800929 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a20:	e9 04 ff ff ff       	jmpq   800929 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	83 f8 30             	cmp    $0x30,%eax
  800a2b:	73 17                	jae    800a44 <vprintfmt+0x1a4>
  800a2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	89 c0                	mov    %eax,%eax
  800a36:	48 01 d0             	add    %rdx,%rax
  800a39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3c:	83 c2 08             	add    $0x8,%edx
  800a3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a42:	eb 0f                	jmp    800a53 <vprintfmt+0x1b3>
  800a44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a48:	48 89 d0             	mov    %rdx,%rax
  800a4b:	48 83 c2 08          	add    $0x8,%rdx
  800a4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a53:	8b 10                	mov    (%rax),%edx
  800a55:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5d:	48 89 ce             	mov    %rcx,%rsi
  800a60:	89 d7                	mov    %edx,%edi
  800a62:	ff d0                	callq  *%rax
			break;
  800a64:	e9 40 03 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x1e8>
  800a71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a86:	eb 0f                	jmp    800a97 <vprintfmt+0x1f7>
  800a88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8c:	48 89 d0             	mov    %rdx,%rax
  800a8f:	48 83 c2 08          	add    $0x8,%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a99:	85 db                	test   %ebx,%ebx
  800a9b:	79 02                	jns    800a9f <vprintfmt+0x1ff>
				err = -err;
  800a9d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a9f:	83 fb 15             	cmp    $0x15,%ebx
  800aa2:	7f 16                	jg     800aba <vprintfmt+0x21a>
  800aa4:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  800aab:	00 00 00 
  800aae:	48 63 d3             	movslq %ebx,%rdx
  800ab1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab5:	4d 85 e4             	test   %r12,%r12
  800ab8:	75 2e                	jne    800ae8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800aba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	89 d9                	mov    %ebx,%ecx
  800ac4:	48 ba 01 49 80 00 00 	movabs $0x804901,%rdx
  800acb:	00 00 00 
  800ace:	48 89 c7             	mov    %rax,%rdi
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	49 b8 b8 0d 80 00 00 	movabs $0x800db8,%r8
  800add:	00 00 00 
  800ae0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae3:	e9 c1 02 00 00       	jmpq   800da9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af0:	4c 89 e1             	mov    %r12,%rcx
  800af3:	48 ba 0a 49 80 00 00 	movabs $0x80490a,%rdx
  800afa:	00 00 00 
  800afd:	48 89 c7             	mov    %rax,%rdi
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	49 b8 b8 0d 80 00 00 	movabs $0x800db8,%r8
  800b0c:	00 00 00 
  800b0f:	41 ff d0             	callq  *%r8
			break;
  800b12:	e9 92 02 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	83 f8 30             	cmp    $0x30,%eax
  800b1d:	73 17                	jae    800b36 <vprintfmt+0x296>
  800b1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b26:	89 c0                	mov    %eax,%eax
  800b28:	48 01 d0             	add    %rdx,%rax
  800b2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2e:	83 c2 08             	add    $0x8,%edx
  800b31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b34:	eb 0f                	jmp    800b45 <vprintfmt+0x2a5>
  800b36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3a:	48 89 d0             	mov    %rdx,%rax
  800b3d:	48 83 c2 08          	add    $0x8,%rdx
  800b41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b45:	4c 8b 20             	mov    (%rax),%r12
  800b48:	4d 85 e4             	test   %r12,%r12
  800b4b:	75 0a                	jne    800b57 <vprintfmt+0x2b7>
				p = "(null)";
  800b4d:	49 bc 0d 49 80 00 00 	movabs $0x80490d,%r12
  800b54:	00 00 00 
			if (width > 0 && padc != '-')
  800b57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5b:	7e 3f                	jle    800b9c <vprintfmt+0x2fc>
  800b5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b61:	74 39                	je     800b9c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b66:	48 98                	cltq   
  800b68:	48 89 c6             	mov    %rax,%rsi
  800b6b:	4c 89 e7             	mov    %r12,%rdi
  800b6e:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  800b75:	00 00 00 
  800b78:	ff d0                	callq  *%rax
  800b7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b7d:	eb 17                	jmp    800b96 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b7f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b83:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8b:	48 89 ce             	mov    %rcx,%rsi
  800b8e:	89 d7                	mov    %edx,%edi
  800b90:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9a:	7f e3                	jg     800b7f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9c:	eb 37                	jmp    800bd5 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ba2:	74 1e                	je     800bc2 <vprintfmt+0x322>
  800ba4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba7:	7e 05                	jle    800bae <vprintfmt+0x30e>
  800ba9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bac:	7e 14                	jle    800bc2 <vprintfmt+0x322>
					putch('?', putdat);
  800bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	48 89 d6             	mov    %rdx,%rsi
  800bb9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bbe:	ff d0                	callq  *%rax
  800bc0:	eb 0f                	jmp    800bd1 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	89 df                	mov    %ebx,%edi
  800bcf:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd5:	4c 89 e0             	mov    %r12,%rax
  800bd8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bdc:	0f b6 00             	movzbl (%rax),%eax
  800bdf:	0f be d8             	movsbl %al,%ebx
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	74 10                	je     800bf6 <vprintfmt+0x356>
  800be6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bea:	78 b2                	js     800b9e <vprintfmt+0x2fe>
  800bec:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bf0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bf4:	79 a8                	jns    800b9e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf6:	eb 16                	jmp    800c0e <vprintfmt+0x36e>
				putch(' ', putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	bf 20 00 00 00       	mov    $0x20,%edi
  800c08:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c12:	7f e4                	jg     800bf8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c14:	e9 90 01 00 00       	jmpq   800da9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1d:	be 03 00 00 00       	mov    $0x3,%esi
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	callq  *%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c39:	48 85 c0             	test   %rax,%rax
  800c3c:	79 1d                	jns    800c5b <vprintfmt+0x3bb>
				putch('-', putdat);
  800c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c46:	48 89 d6             	mov    %rdx,%rsi
  800c49:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c4e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c54:	48 f7 d8             	neg    %rax
  800c57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c62:	e9 d5 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6b:	be 03 00 00 00       	mov    $0x3,%esi
  800c70:	48 89 c7             	mov    %rax,%rdi
  800c73:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800c7a:	00 00 00 
  800c7d:	ff d0                	callq  *%rax
  800c7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8a:	e9 ad 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c8f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c96:	89 d6                	mov    %edx,%esi
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
  800ca7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800cab:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cb2:	e9 85 00 00 00       	jmpq   800d3c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbf:	48 89 d6             	mov    %rdx,%rsi
  800cc2:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc7:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd1:	48 89 d6             	mov    %rdx,%rsi
  800cd4:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd9:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cde:	83 f8 30             	cmp    $0x30,%eax
  800ce1:	73 17                	jae    800cfa <vprintfmt+0x45a>
  800ce3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cea:	89 c0                	mov    %eax,%eax
  800cec:	48 01 d0             	add    %rdx,%rax
  800cef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf2:	83 c2 08             	add    $0x8,%edx
  800cf5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf8:	eb 0f                	jmp    800d09 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfe:	48 89 d0             	mov    %rdx,%rax
  800d01:	48 83 c2 08          	add    $0x8,%rdx
  800d05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d09:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d10:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1d:	be 03 00 00 00       	mov    $0x3,%esi
  800d22:	48 89 c7             	mov    %rax,%rdi
  800d25:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800d2c:	00 00 00 
  800d2f:	ff d0                	callq  *%rax
  800d31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d35:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d41:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d44:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d53:	45 89 c1             	mov    %r8d,%r9d
  800d56:	41 89 f8             	mov    %edi,%r8d
  800d59:	48 89 c7             	mov    %rax,%rdi
  800d5c:	48 b8 c5 05 80 00 00 	movabs $0x8005c5,%rax
  800d63:	00 00 00 
  800d66:	ff d0                	callq  *%rax
			break;
  800d68:	eb 3f                	jmp    800da9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d72:	48 89 d6             	mov    %rdx,%rsi
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	ff d0                	callq  *%rax
			break;
  800d79:	eb 2e                	jmp    800da9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d83:	48 89 d6             	mov    %rdx,%rsi
  800d86:	bf 25 00 00 00       	mov    $0x25,%edi
  800d8b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d92:	eb 05                	jmp    800d99 <vprintfmt+0x4f9>
  800d94:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d99:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d9d:	48 83 e8 01          	sub    $0x1,%rax
  800da1:	0f b6 00             	movzbl (%rax),%eax
  800da4:	3c 25                	cmp    $0x25,%al
  800da6:	75 ec                	jne    800d94 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800da8:	90                   	nop
		}
	}
  800da9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800daa:	e9 43 fb ff ff       	jmpq   8008f2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800daf:	48 83 c4 60          	add    $0x60,%rsp
  800db3:	5b                   	pop    %rbx
  800db4:	41 5c                	pop    %r12
  800db6:	5d                   	pop    %rbp
  800db7:	c3                   	retq   

0000000000800db8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db8:	55                   	push   %rbp
  800db9:	48 89 e5             	mov    %rsp,%rbp
  800dbc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dc3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dca:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dd1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de6:	84 c0                	test   %al,%al
  800de8:	74 20                	je     800e0a <printfmt+0x52>
  800dea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dfa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e02:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e06:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e0a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e11:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e18:	00 00 00 
  800e1b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e22:	00 00 00 
  800e25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e29:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e30:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e37:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e3e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e45:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e4c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e53:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e5a:	48 89 c7             	mov    %rax,%rdi
  800e5d:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e69:	c9                   	leaveq 
  800e6a:	c3                   	retq   

0000000000800e6b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e6b:	55                   	push   %rbp
  800e6c:	48 89 e5             	mov    %rsp,%rbp
  800e6f:	48 83 ec 10          	sub    $0x10,%rsp
  800e73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7e:	8b 40 10             	mov    0x10(%rax),%eax
  800e81:	8d 50 01             	lea    0x1(%rax),%edx
  800e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e88:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8f:	48 8b 10             	mov    (%rax),%rdx
  800e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e96:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e9a:	48 39 c2             	cmp    %rax,%rdx
  800e9d:	73 17                	jae    800eb6 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 8b 00             	mov    (%rax),%rax
  800ea6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eae:	48 89 0a             	mov    %rcx,(%rdx)
  800eb1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb4:	88 10                	mov    %dl,(%rax)
}
  800eb6:	c9                   	leaveq 
  800eb7:	c3                   	retq   

0000000000800eb8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb8:	55                   	push   %rbp
  800eb9:	48 89 e5             	mov    %rsp,%rbp
  800ebc:	48 83 ec 50          	sub    $0x50,%rsp
  800ec0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ec4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ec7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ecb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ecf:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ed3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ed7:	48 8b 0a             	mov    (%rdx),%rcx
  800eda:	48 89 08             	mov    %rcx,(%rax)
  800edd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ef5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef8:	48 98                	cltq   
  800efa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800efe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f02:	48 01 d0             	add    %rdx,%rax
  800f05:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f10:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f15:	74 06                	je     800f1d <vsnprintf+0x65>
  800f17:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f1b:	7f 07                	jg     800f24 <vsnprintf+0x6c>
		return -E_INVAL;
  800f1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f22:	eb 2f                	jmp    800f53 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f24:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f28:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f2c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f30:	48 89 c6             	mov    %rax,%rsi
  800f33:	48 bf 6b 0e 80 00 00 	movabs $0x800e6b,%rdi
  800f3a:	00 00 00 
  800f3d:	48 b8 a0 08 80 00 00 	movabs $0x8008a0,%rax
  800f44:	00 00 00 
  800f47:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f4d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f50:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f53:	c9                   	leaveq 
  800f54:	c3                   	retq   

0000000000800f55 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f55:	55                   	push   %rbp
  800f56:	48 89 e5             	mov    %rsp,%rbp
  800f59:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f60:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f67:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f6d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f74:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f7b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f82:	84 c0                	test   %al,%al
  800f84:	74 20                	je     800fa6 <snprintf+0x51>
  800f86:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f8e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f92:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f96:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f9e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fa6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fad:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fb4:	00 00 00 
  800fb7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fbe:	00 00 00 
  800fc1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fcc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fda:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fe8:	48 8b 0a             	mov    (%rdx),%rcx
  800feb:	48 89 08             	mov    %rcx,(%rax)
  800fee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ffa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ffe:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801005:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80100c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801012:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801019:	48 89 c7             	mov    %rax,%rdi
  80101c:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  801023:	00 00 00 
  801026:	ff d0                	callq  *%rax
  801028:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80102e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801034:	c9                   	leaveq 
  801035:	c3                   	retq   

0000000000801036 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 83 ec 18          	sub    $0x18,%rsp
  80103e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801049:	eb 09                	jmp    801054 <strlen+0x1e>
		n++;
  80104b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	84 c0                	test   %al,%al
  80105d:	75 ec                	jne    80104b <strlen+0x15>
		n++;
	return n;
  80105f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 20          	sub    $0x20,%rsp
  80106c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80107b:	eb 0e                	jmp    80108b <strnlen+0x27>
		n++;
  80107d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801081:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801086:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80108b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801090:	74 0b                	je     80109d <strnlen+0x39>
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	84 c0                	test   %al,%al
  80109b:	75 e0                	jne    80107d <strnlen+0x19>
		n++;
	return n;
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 20          	sub    $0x20,%rsp
  8010aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010ba:	90                   	nop
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010cb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010cf:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010d3:	0f b6 12             	movzbl (%rdx),%edx
  8010d6:	88 10                	mov    %dl,(%rax)
  8010d8:	0f b6 00             	movzbl (%rax),%eax
  8010db:	84 c0                	test   %al,%al
  8010dd:	75 dc                	jne    8010bb <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 89 c7             	mov    %rax,%rdi
  8010fc:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  801103:	00 00 00 
  801106:	ff d0                	callq  *%rax
  801108:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80110b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80110e:	48 63 d0             	movslq %eax,%rdx
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	48 01 c2             	add    %rax,%rdx
  801118:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111c:	48 89 c6             	mov    %rax,%rsi
  80111f:	48 89 d7             	mov    %rdx,%rdi
  801122:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  801129:	00 00 00 
  80112c:	ff d0                	callq  *%rax
	return dst;
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 28          	sub    $0x28,%rsp
  80113c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801140:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801144:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801150:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801157:	00 
  801158:	eb 2a                	jmp    801184 <strncpy+0x50>
		*dst++ = *src;
  80115a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801162:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801166:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116a:	0f b6 12             	movzbl (%rdx),%edx
  80116d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	84 c0                	test   %al,%al
  801178:	74 05                	je     80117f <strncpy+0x4b>
			src++;
  80117a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80118c:	72 cc                	jb     80115a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801192:	c9                   	leaveq 
  801193:	c3                   	retq   

0000000000801194 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801194:	55                   	push   %rbp
  801195:	48 89 e5             	mov    %rsp,%rbp
  801198:	48 83 ec 28          	sub    $0x28,%rsp
  80119c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b5:	74 3d                	je     8011f4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011b7:	eb 1d                	jmp    8011d6 <strlcpy+0x42>
			*dst++ = *src++;
  8011b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011cd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011d1:	0f b6 12             	movzbl (%rdx),%edx
  8011d4:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011d6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011e0:	74 0b                	je     8011ed <strlcpy+0x59>
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	0f b6 00             	movzbl (%rax),%eax
  8011e9:	84 c0                	test   %al,%al
  8011eb:	75 cc                	jne    8011b9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	48 29 c2             	sub    %rax,%rdx
  8011ff:	48 89 d0             	mov    %rdx,%rax
}
  801202:	c9                   	leaveq 
  801203:	c3                   	retq   

0000000000801204 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801204:	55                   	push   %rbp
  801205:	48 89 e5             	mov    %rsp,%rbp
  801208:	48 83 ec 10          	sub    $0x10,%rsp
  80120c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801210:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801214:	eb 0a                	jmp    801220 <strcmp+0x1c>
		p++, q++;
  801216:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	84 c0                	test   %al,%al
  801229:	74 12                	je     80123d <strcmp+0x39>
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 10             	movzbl (%rax),%edx
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	38 c2                	cmp    %al,%dl
  80123b:	74 d9                	je     801216 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	0f b6 d0             	movzbl %al,%edx
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	0f b6 00             	movzbl (%rax),%eax
  80124e:	0f b6 c0             	movzbl %al,%eax
  801251:	29 c2                	sub    %eax,%edx
  801253:	89 d0                	mov    %edx,%eax
}
  801255:	c9                   	leaveq 
  801256:	c3                   	retq   

0000000000801257 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	48 83 ec 18          	sub    $0x18,%rsp
  80125f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801263:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801267:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80126b:	eb 0f                	jmp    80127c <strncmp+0x25>
		n--, p++, q++;
  80126d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80127c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801281:	74 1d                	je     8012a0 <strncmp+0x49>
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	84 c0                	test   %al,%al
  80128c:	74 12                	je     8012a0 <strncmp+0x49>
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	0f b6 10             	movzbl (%rax),%edx
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	38 c2                	cmp    %al,%dl
  80129e:	74 cd                	je     80126d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012a0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a5:	75 07                	jne    8012ae <strncmp+0x57>
		return 0;
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ac:	eb 18                	jmp    8012c6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	0f b6 d0             	movzbl %al,%edx
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	0f b6 c0             	movzbl %al,%eax
  8012c2:	29 c2                	sub    %eax,%edx
  8012c4:	89 d0                	mov    %edx,%eax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d4:	89 f0                	mov    %esi,%eax
  8012d6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d9:	eb 17                	jmp    8012f2 <strchr+0x2a>
		if (*s == c)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e5:	75 06                	jne    8012ed <strchr+0x25>
			return (char *) s;
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	eb 15                	jmp    801302 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 de                	jne    8012db <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	c9                   	leaveq 
  801303:	c3                   	retq   

0000000000801304 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801304:	55                   	push   %rbp
  801305:	48 89 e5             	mov    %rsp,%rbp
  801308:	48 83 ec 0c          	sub    $0xc,%rsp
  80130c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801310:	89 f0                	mov    %esi,%eax
  801312:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801315:	eb 13                	jmp    80132a <strfind+0x26>
		if (*s == c)
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801321:	75 02                	jne    801325 <strfind+0x21>
			break;
  801323:	eb 10                	jmp    801335 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801325:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 e2                	jne    801317 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801339:	c9                   	leaveq 
  80133a:	c3                   	retq   

000000000080133b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80133b:	55                   	push   %rbp
  80133c:	48 89 e5             	mov    %rsp,%rbp
  80133f:	48 83 ec 18          	sub    $0x18,%rsp
  801343:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801347:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80134e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801353:	75 06                	jne    80135b <memset+0x20>
		return v;
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	eb 69                	jmp    8013c4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80135b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135f:	83 e0 03             	and    $0x3,%eax
  801362:	48 85 c0             	test   %rax,%rax
  801365:	75 48                	jne    8013af <memset+0x74>
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	83 e0 03             	and    $0x3,%eax
  80136e:	48 85 c0             	test   %rax,%rax
  801371:	75 3c                	jne    8013af <memset+0x74>
		c &= 0xFF;
  801373:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80137a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137d:	c1 e0 18             	shl    $0x18,%eax
  801380:	89 c2                	mov    %eax,%edx
  801382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801385:	c1 e0 10             	shl    $0x10,%eax
  801388:	09 c2                	or     %eax,%edx
  80138a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138d:	c1 e0 08             	shl    $0x8,%eax
  801390:	09 d0                	or     %edx,%eax
  801392:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 c1 e8 02          	shr    $0x2,%rax
  80139d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a7:	48 89 d7             	mov    %rdx,%rdi
  8013aa:	fc                   	cld    
  8013ab:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013ad:	eb 11                	jmp    8013c0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013ba:	48 89 d7             	mov    %rdx,%rdi
  8013bd:	fc                   	cld    
  8013be:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c4:	c9                   	leaveq 
  8013c5:	c3                   	retq   

00000000008013c6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c6:	55                   	push   %rbp
  8013c7:	48 89 e5             	mov    %rsp,%rbp
  8013ca:	48 83 ec 28          	sub    $0x28,%rsp
  8013ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ee:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013f2:	0f 83 88 00 00 00    	jae    801480 <memmove+0xba>
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	48 01 d0             	add    %rdx,%rax
  801403:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801407:	76 77                	jbe    801480 <memmove+0xba>
		s += n;
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 3b                	jne    801460 <memmove+0x9a>
  801425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 2f                	jne    801460 <memmove+0x9a>
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 23                	jne    801460 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	48 83 e8 04          	sub    $0x4,%rax
  801445:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801449:	48 83 ea 04          	sub    $0x4,%rdx
  80144d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801451:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801455:	48 89 c7             	mov    %rax,%rdi
  801458:	48 89 d6             	mov    %rdx,%rsi
  80145b:	fd                   	std    
  80145c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145e:	eb 1d                	jmp    80147d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801464:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	48 89 d7             	mov    %rdx,%rdi
  801477:	48 89 c1             	mov    %rax,%rcx
  80147a:	fd                   	std    
  80147b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80147d:	fc                   	cld    
  80147e:	eb 57                	jmp    8014d7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	83 e0 03             	and    $0x3,%eax
  801487:	48 85 c0             	test   %rax,%rax
  80148a:	75 36                	jne    8014c2 <memmove+0xfc>
  80148c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 2a                	jne    8014c2 <memmove+0xfc>
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	83 e0 03             	and    $0x3,%eax
  80149f:	48 85 c0             	test   %rax,%rax
  8014a2:	75 1e                	jne    8014c2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	48 c1 e8 02          	shr    $0x2,%rax
  8014ac:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b7:	48 89 c7             	mov    %rax,%rdi
  8014ba:	48 89 d6             	mov    %rdx,%rsi
  8014bd:	fc                   	cld    
  8014be:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014c0:	eb 15                	jmp    8014d7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ca:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ce:	48 89 c7             	mov    %rax,%rdi
  8014d1:	48 89 d6             	mov    %rdx,%rsi
  8014d4:	fc                   	cld    
  8014d5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014db:	c9                   	leaveq 
  8014dc:	c3                   	retq   

00000000008014dd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 18          	sub    $0x18,%rsp
  8014e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	48 89 ce             	mov    %rcx,%rsi
  801500:	48 89 c7             	mov    %rax,%rdi
  801503:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  80150a:	00 00 00 
  80150d:	ff d0                	callq  *%rax
}
  80150f:	c9                   	leaveq 
  801510:	c3                   	retq   

0000000000801511 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801511:	55                   	push   %rbp
  801512:	48 89 e5             	mov    %rsp,%rbp
  801515:	48 83 ec 28          	sub    $0x28,%rsp
  801519:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801521:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801529:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80152d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801531:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801535:	eb 36                	jmp    80156d <memcmp+0x5c>
		if (*s1 != *s2)
  801537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153b:	0f b6 10             	movzbl (%rax),%edx
  80153e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	38 c2                	cmp    %al,%dl
  801547:	74 1a                	je     801563 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	0f b6 d0             	movzbl %al,%edx
  801553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	0f b6 c0             	movzbl %al,%eax
  80155d:	29 c2                	sub    %eax,%edx
  80155f:	89 d0                	mov    %edx,%eax
  801561:	eb 20                	jmp    801583 <memcmp+0x72>
		s1++, s2++;
  801563:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801568:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801579:	48 85 c0             	test   %rax,%rax
  80157c:	75 b9                	jne    801537 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	48 83 ec 28          	sub    $0x28,%rsp
  80158d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801591:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801594:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a0:	48 01 d0             	add    %rdx,%rax
  8015a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a7:	eb 15                	jmp    8015be <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ad:	0f b6 10             	movzbl (%rax),%edx
  8015b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015b3:	38 c2                	cmp    %al,%dl
  8015b5:	75 02                	jne    8015b9 <memfind+0x34>
			break;
  8015b7:	eb 0f                	jmp    8015c8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c6:	72 e1                	jb     8015a9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015cc:	c9                   	leaveq 
  8015cd:	c3                   	retq   

00000000008015ce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 34          	sub    $0x34,%rsp
  8015d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015de:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015e8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015ef:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f0:	eb 05                	jmp    8015f7 <strtol+0x29>
		s++;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 20                	cmp    $0x20,%al
  801600:	74 f0                	je     8015f2 <strtol+0x24>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 09                	cmp    $0x9,%al
  80160b:	74 e5                	je     8015f2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 2b                	cmp    $0x2b,%al
  801616:	75 07                	jne    80161f <strtol+0x51>
		s++;
  801618:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80161d:	eb 17                	jmp    801636 <strtol+0x68>
	else if (*s == '-')
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 2d                	cmp    $0x2d,%al
  801628:	75 0c                	jne    801636 <strtol+0x68>
		s++, neg = 1;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801636:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163a:	74 06                	je     801642 <strtol+0x74>
  80163c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801640:	75 28                	jne    80166a <strtol+0x9c>
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	3c 30                	cmp    $0x30,%al
  80164b:	75 1d                	jne    80166a <strtol+0x9c>
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 83 c0 01          	add    $0x1,%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 78                	cmp    $0x78,%al
  80165a:	75 0e                	jne    80166a <strtol+0x9c>
		s += 2, base = 16;
  80165c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801661:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801668:	eb 2c                	jmp    801696 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80166a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166e:	75 19                	jne    801689 <strtol+0xbb>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 30                	cmp    $0x30,%al
  801679:	75 0e                	jne    801689 <strtol+0xbb>
		s++, base = 8;
  80167b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801680:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801687:	eb 0d                	jmp    801696 <strtol+0xc8>
	else if (base == 0)
  801689:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80168d:	75 07                	jne    801696 <strtol+0xc8>
		base = 10;
  80168f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 2f                	cmp    $0x2f,%al
  80169f:	7e 1d                	jle    8016be <strtol+0xf0>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 39                	cmp    $0x39,%al
  8016aa:	7f 12                	jg     8016be <strtol+0xf0>
			dig = *s - '0';
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 30             	sub    $0x30,%eax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bc:	eb 4e                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 60                	cmp    $0x60,%al
  8016c7:	7e 1d                	jle    8016e6 <strtol+0x118>
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 7a                	cmp    $0x7a,%al
  8016d2:	7f 12                	jg     8016e6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	0f be c0             	movsbl %al,%eax
  8016de:	83 e8 57             	sub    $0x57,%eax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e4:	eb 26                	jmp    80170c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 40                	cmp    $0x40,%al
  8016ef:	7e 48                	jle    801739 <strtol+0x16b>
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 5a                	cmp    $0x5a,%al
  8016fa:	7f 3d                	jg     801739 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	0f be c0             	movsbl %al,%eax
  801706:	83 e8 37             	sub    $0x37,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80170c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801712:	7c 02                	jl     801716 <strtol+0x148>
			break;
  801714:	eb 23                	jmp    801739 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801716:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80171e:	48 98                	cltq   
  801720:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801725:	48 89 c2             	mov    %rax,%rdx
  801728:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80172b:	48 98                	cltq   
  80172d:	48 01 d0             	add    %rdx,%rax
  801730:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801734:	e9 5d ff ff ff       	jmpq   801696 <strtol+0xc8>

	if (endptr)
  801739:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80173e:	74 0b                	je     80174b <strtol+0x17d>
		*endptr = (char *) s;
  801740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801744:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801748:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80174b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174f:	74 09                	je     80175a <strtol+0x18c>
  801751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801755:	48 f7 d8             	neg    %rax
  801758:	eb 04                	jmp    80175e <strtol+0x190>
  80175a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <strstr>:

char * strstr(const char *in, const char *str)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
  801764:	48 83 ec 30          	sub    $0x30,%rsp
  801768:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80176c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801774:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801778:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801782:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801786:	75 06                	jne    80178e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	eb 6b                	jmp    8017f9 <strstr+0x99>

	len = strlen(str);
  80178e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801792:	48 89 c7             	mov    %rax,%rdi
  801795:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  80179c:	00 00 00 
  80179f:	ff d0                	callq  *%rax
  8017a1:	48 98                	cltq   
  8017a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b3:	0f b6 00             	movzbl (%rax),%eax
  8017b6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017bd:	75 07                	jne    8017c6 <strstr+0x66>
				return (char *) 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	eb 33                	jmp    8017f9 <strstr+0x99>
		} while (sc != c);
  8017c6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ca:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017cd:	75 d8                	jne    8017a7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	48 89 ce             	mov    %rcx,%rsi
  8017de:	48 89 c7             	mov    %rax,%rdi
  8017e1:	48 b8 57 12 80 00 00 	movabs $0x801257,%rax
  8017e8:	00 00 00 
  8017eb:	ff d0                	callq  *%rax
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	75 b6                	jne    8017a7 <strstr+0x47>

	return (char *) (in - 1);
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	53                   	push   %rbx
  801800:	48 83 ec 48          	sub    $0x48,%rsp
  801804:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801807:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80180a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80180e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801812:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801816:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80181a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80181d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801821:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801825:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801829:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80182d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801831:	4c 89 c3             	mov    %r8,%rbx
  801834:	cd 30                	int    $0x30
  801836:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80183a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183e:	74 3e                	je     80187e <syscall+0x83>
  801840:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801845:	7e 37                	jle    80187e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801847:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184e:	49 89 d0             	mov    %rdx,%r8
  801851:	89 c1                	mov    %eax,%ecx
  801853:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  80185a:	00 00 00 
  80185d:	be 23 00 00 00       	mov    $0x23,%esi
  801862:	48 bf e5 4b 80 00 00 	movabs $0x804be5,%rdi
  801869:	00 00 00 
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	49 b9 96 3d 80 00 00 	movabs $0x803d96,%r9
  801878:	00 00 00 
  80187b:	41 ff d1             	callq  *%r9

	return ret;
  80187e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801882:	48 83 c4 48          	add    $0x48,%rsp
  801886:	5b                   	pop    %rbx
  801887:	5d                   	pop    %rbp
  801888:	c3                   	retq   

0000000000801889 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 20          	sub    $0x20,%rsp
  801891:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801895:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a8:	00 
  8018a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b5:	48 89 d1             	mov    %rdx,%rcx
  8018b8:	48 89 c2             	mov    %rax,%rdx
  8018bb:	be 00 00 00 00       	mov    $0x0,%esi
  8018c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c5:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   

00000000008018d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e2:	00 
  8018e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	be 00 00 00 00       	mov    $0x0,%esi
  8018fe:	bf 01 00 00 00       	mov    $0x1,%edi
  801903:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80191c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191f:	48 98                	cltq   
  801921:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801928:	00 
  801929:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801935:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193a:	48 89 c2             	mov    %rax,%rdx
  80193d:	be 01 00 00 00       	mov    $0x1,%esi
  801942:	bf 03 00 00 00       	mov    $0x3,%edi
  801947:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80194e:	00 00 00 
  801951:	ff d0                	callq  *%rax
}
  801953:	c9                   	leaveq 
  801954:	c3                   	retq   

0000000000801955 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80195d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801964:	00 
  801965:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801971:	b9 00 00 00 00       	mov    $0x0,%ecx
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	be 00 00 00 00       	mov    $0x0,%esi
  801980:	bf 02 00 00 00       	mov    $0x2,%edi
  801985:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  80198c:	00 00 00 
  80198f:	ff d0                	callq  *%rax
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <sys_yield>:

void
sys_yield(void)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80199b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a2:	00 
  8019a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	be 00 00 00 00       	mov    $0x0,%esi
  8019be:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019c3:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 20          	sub    $0x20,%rsp
  8019d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e6:	48 63 c8             	movslq %eax,%rcx
  8019e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f0:	48 98                	cltq   
  8019f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f9:	00 
  8019fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a00:	49 89 c8             	mov    %rcx,%r8
  801a03:	48 89 d1             	mov    %rdx,%rcx
  801a06:	48 89 c2             	mov    %rax,%rdx
  801a09:	be 01 00 00 00       	mov    $0x1,%esi
  801a0e:	bf 04 00 00 00       	mov    $0x4,%edi
  801a13:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
}
  801a1f:	c9                   	leaveq 
  801a20:	c3                   	retq   

0000000000801a21 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a21:	55                   	push   %rbp
  801a22:	48 89 e5             	mov    %rsp,%rbp
  801a25:	48 83 ec 30          	sub    $0x30,%rsp
  801a29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a30:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a33:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a37:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a3b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3e:	48 63 c8             	movslq %eax,%rcx
  801a41:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a48:	48 63 f0             	movslq %eax,%rsi
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a58:	49 89 f9             	mov    %rdi,%r9
  801a5b:	49 89 f0             	mov    %rsi,%r8
  801a5e:	48 89 d1             	mov    %rdx,%rcx
  801a61:	48 89 c2             	mov    %rax,%rdx
  801a64:	be 01 00 00 00       	mov    $0x1,%esi
  801a69:	bf 05 00 00 00       	mov    $0x5,%edi
  801a6e:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	callq  *%rax
}
  801a7a:	c9                   	leaveq 
  801a7b:	c3                   	retq   

0000000000801a7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	48 83 ec 20          	sub    $0x20,%rsp
  801a84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a92:	48 98                	cltq   
  801a94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9b:	00 
  801a9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa8:	48 89 d1             	mov    %rdx,%rcx
  801aab:	48 89 c2             	mov    %rax,%rdx
  801aae:	be 01 00 00 00       	mov    $0x1,%esi
  801ab3:	bf 06 00 00 00       	mov    $0x6,%edi
  801ab8:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801abf:	00 00 00 
  801ac2:	ff d0                	callq  *%rax
}
  801ac4:	c9                   	leaveq 
  801ac5:	c3                   	retq   

0000000000801ac6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ac6:	55                   	push   %rbp
  801ac7:	48 89 e5             	mov    %rsp,%rbp
  801aca:	48 83 ec 10          	sub    $0x10,%rsp
  801ace:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ad4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad7:	48 63 d0             	movslq %eax,%rdx
  801ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae6:	00 
  801ae7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af3:	48 89 d1             	mov    %rdx,%rcx
  801af6:	48 89 c2             	mov    %rax,%rdx
  801af9:	be 01 00 00 00       	mov    $0x1,%esi
  801afe:	bf 08 00 00 00       	mov    $0x8,%edi
  801b03:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	callq  *%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b30:	00 
  801b31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3d:	48 89 d1             	mov    %rdx,%rcx
  801b40:	48 89 c2             	mov    %rax,%rdx
  801b43:	be 01 00 00 00       	mov    $0x1,%esi
  801b48:	bf 09 00 00 00       	mov    $0x9,%edi
  801b4d:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 20          	sub    $0x20,%rsp
  801b63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b71:	48 98                	cltq   
  801b73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7a:	00 
  801b7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b87:	48 89 d1             	mov    %rdx,%rcx
  801b8a:	48 89 c2             	mov    %rax,%rdx
  801b8d:	be 01 00 00 00       	mov    $0x1,%esi
  801b92:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b97:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 20          	sub    $0x20,%rsp
  801bad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bb8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbe:	48 63 f0             	movslq %eax,%rsi
  801bc1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd5:	00 
  801bd6:	49 89 f1             	mov    %rsi,%r9
  801bd9:	49 89 c8             	mov    %rcx,%r8
  801bdc:	48 89 d1             	mov    %rdx,%rcx
  801bdf:	48 89 c2             	mov    %rax,%rdx
  801be2:	be 00 00 00 00       	mov    $0x0,%esi
  801be7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bec:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	callq  *%rax
}
  801bf8:	c9                   	leaveq 
  801bf9:	c3                   	retq   

0000000000801bfa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
  801c02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c23:	48 89 c2             	mov    %rax,%rdx
  801c26:	be 01 00 00 00       	mov    $0x1,%esi
  801c2b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c30:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	48 83 ec 20          	sub    $0x20,%rsp
  801c46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 01 00 00 00       	mov    $0x1,%esi
  801c75:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c7a:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 10          	sub    $0x10,%rsp
  801c90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 00 00 00 00       	mov    $0x0,%esi
  801cb9:	bf 10 00 00 00       	mov    $0x10,%edi
  801cbe:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdb:	00 
  801cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf2:	be 00 00 00 00       	mov    $0x0,%esi
  801cf7:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cfc:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801d03:	00 00 00 
  801d06:	ff d0                	callq  *%rax
}
  801d08:	c9                   	leaveq 
  801d09:	c3                   	retq   

0000000000801d0a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d0a:	55                   	push   %rbp
  801d0b:	48 89 e5             	mov    %rsp,%rbp
  801d0e:	48 83 ec 08          	sub    $0x8,%rsp
  801d12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d16:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d1a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d21:	ff ff ff 
  801d24:	48 01 d0             	add    %rdx,%rax
  801d27:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d2b:	c9                   	leaveq 
  801d2c:	c3                   	retq   

0000000000801d2d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d2d:	55                   	push   %rbp
  801d2e:	48 89 e5             	mov    %rsp,%rbp
  801d31:	48 83 ec 08          	sub    $0x8,%rsp
  801d35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
  801d4c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d52:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d56:	c9                   	leaveq 
  801d57:	c3                   	retq   

0000000000801d58 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d58:	55                   	push   %rbp
  801d59:	48 89 e5             	mov    %rsp,%rbp
  801d5c:	48 83 ec 18          	sub    $0x18,%rsp
  801d60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d6b:	eb 6b                	jmp    801dd8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d70:	48 98                	cltq   
  801d72:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d78:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d84:	48 c1 e8 15          	shr    $0x15,%rax
  801d88:	48 89 c2             	mov    %rax,%rdx
  801d8b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d92:	01 00 00 
  801d95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d99:	83 e0 01             	and    $0x1,%eax
  801d9c:	48 85 c0             	test   %rax,%rax
  801d9f:	74 21                	je     801dc2 <fd_alloc+0x6a>
  801da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da5:	48 c1 e8 0c          	shr    $0xc,%rax
  801da9:	48 89 c2             	mov    %rax,%rdx
  801dac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db3:	01 00 00 
  801db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dba:	83 e0 01             	and    $0x1,%eax
  801dbd:	48 85 c0             	test   %rax,%rax
  801dc0:	75 12                	jne    801dd4 <fd_alloc+0x7c>
			*fd_store = fd;
  801dc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dca:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	eb 1a                	jmp    801dee <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dd4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dd8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ddc:	7e 8f                	jle    801d6d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801de9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dee:	c9                   	leaveq 
  801def:	c3                   	retq   

0000000000801df0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	48 83 ec 20          	sub    $0x20,%rsp
  801df8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e03:	78 06                	js     801e0b <fd_lookup+0x1b>
  801e05:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e09:	7e 07                	jle    801e12 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e10:	eb 6c                	jmp    801e7e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e15:	48 98                	cltq   
  801e17:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e1d:	48 c1 e0 0c          	shl    $0xc,%rax
  801e21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e29:	48 c1 e8 15          	shr    $0x15,%rax
  801e2d:	48 89 c2             	mov    %rax,%rdx
  801e30:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e37:	01 00 00 
  801e3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3e:	83 e0 01             	and    $0x1,%eax
  801e41:	48 85 c0             	test   %rax,%rax
  801e44:	74 21                	je     801e67 <fd_lookup+0x77>
  801e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4a:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4e:	48 89 c2             	mov    %rax,%rdx
  801e51:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e58:	01 00 00 
  801e5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5f:	83 e0 01             	and    $0x1,%eax
  801e62:	48 85 c0             	test   %rax,%rax
  801e65:	75 07                	jne    801e6e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6c:	eb 10                	jmp    801e7e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e72:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e76:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7e:	c9                   	leaveq 
  801e7f:	c3                   	retq   

0000000000801e80 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e80:	55                   	push   %rbp
  801e81:	48 89 e5             	mov    %rsp,%rbp
  801e84:	48 83 ec 30          	sub    $0x30,%rsp
  801e88:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e8c:	89 f0                	mov    %esi,%eax
  801e8e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e95:	48 89 c7             	mov    %rax,%rdi
  801e98:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	callq  *%rax
  801ea4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ea8:	48 89 d6             	mov    %rdx,%rsi
  801eab:	89 c7                	mov    %eax,%edi
  801ead:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
  801eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec0:	78 0a                	js     801ecc <fd_close+0x4c>
	    || fd != fd2)
  801ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eca:	74 12                	je     801ede <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ecc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ed0:	74 05                	je     801ed7 <fd_close+0x57>
  801ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed5:	eb 05                	jmp    801edc <fd_close+0x5c>
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	eb 69                	jmp    801f47 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee2:	8b 00                	mov    (%rax),%eax
  801ee4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ee8:	48 89 d6             	mov    %rdx,%rsi
  801eeb:	89 c7                	mov    %eax,%edi
  801eed:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f00:	78 2a                	js     801f2c <fd_close+0xac>
		if (dev->dev_close)
  801f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f06:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f0a:	48 85 c0             	test   %rax,%rax
  801f0d:	74 16                	je     801f25 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f13:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f17:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f1b:	48 89 d7             	mov    %rdx,%rdi
  801f1e:	ff d0                	callq  *%rax
  801f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f23:	eb 07                	jmp    801f2c <fd_close+0xac>
		else
			r = 0;
  801f25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f30:	48 89 c6             	mov    %rax,%rsi
  801f33:	bf 00 00 00 00       	mov    $0x0,%edi
  801f38:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	callq  *%rax
	return r;
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	48 83 ec 20          	sub    $0x20,%rsp
  801f51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f5f:	eb 41                	jmp    801fa2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f61:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f68:	00 00 00 
  801f6b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f6e:	48 63 d2             	movslq %edx,%rdx
  801f71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f75:	8b 00                	mov    (%rax),%eax
  801f77:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f7a:	75 22                	jne    801f9e <dev_lookup+0x55>
			*dev = devtab[i];
  801f7c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f83:	00 00 00 
  801f86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f89:	48 63 d2             	movslq %edx,%rdx
  801f8c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f94:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	eb 60                	jmp    801ffe <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f9e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fa2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fa9:	00 00 00 
  801fac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801faf:	48 63 d2             	movslq %edx,%rdx
  801fb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb6:	48 85 c0             	test   %rax,%rax
  801fb9:	75 a6                	jne    801f61 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fbb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fc2:	00 00 00 
  801fc5:	48 8b 00             	mov    (%rax),%rax
  801fc8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fce:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fd1:	89 c6                	mov    %eax,%esi
  801fd3:	48 bf f8 4b 80 00 00 	movabs $0x804bf8,%rdi
  801fda:	00 00 00 
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  801fe9:	00 00 00 
  801fec:	ff d1                	callq  *%rcx
	*dev = 0;
  801fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ff9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ffe:	c9                   	leaveq 
  801fff:	c3                   	retq   

0000000000802000 <close>:

int
close(int fdnum)
{
  802000:	55                   	push   %rbp
  802001:	48 89 e5             	mov    %rsp,%rbp
  802004:	48 83 ec 20          	sub    $0x20,%rsp
  802008:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80200b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80200f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802012:	48 89 d6             	mov    %rdx,%rsi
  802015:	89 c7                	mov    %eax,%edi
  802017:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802026:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202a:	79 05                	jns    802031 <close+0x31>
		return r;
  80202c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202f:	eb 18                	jmp    802049 <close+0x49>
	else
		return fd_close(fd, 1);
  802031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802035:	be 01 00 00 00       	mov    $0x1,%esi
  80203a:	48 89 c7             	mov    %rax,%rdi
  80203d:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  802044:	00 00 00 
  802047:	ff d0                	callq  *%rax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <close_all>:

void
close_all(void)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80205a:	eb 15                	jmp    802071 <close_all+0x26>
		close(i);
  80205c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205f:	89 c7                	mov    %eax,%edi
  802061:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802068:	00 00 00 
  80206b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80206d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802071:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802075:	7e e5                	jle    80205c <close_all+0x11>
		close(i);
}
  802077:	c9                   	leaveq 
  802078:	c3                   	retq   

0000000000802079 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802079:	55                   	push   %rbp
  80207a:	48 89 e5             	mov    %rsp,%rbp
  80207d:	48 83 ec 40          	sub    $0x40,%rsp
  802081:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802084:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802087:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80208b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80208e:	48 89 d6             	mov    %rdx,%rsi
  802091:	89 c7                	mov    %eax,%edi
  802093:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
  80209f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a6:	79 08                	jns    8020b0 <dup+0x37>
		return r;
  8020a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ab:	e9 70 01 00 00       	jmpq   802220 <dup+0x1a7>
	close(newfdnum);
  8020b0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b3:	89 c7                	mov    %eax,%edi
  8020b5:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020c1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c4:	48 98                	cltq   
  8020c6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020cc:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d8:	48 89 c7             	mov    %rax,%rdi
  8020db:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
  8020e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ef:	48 89 c7             	mov    %rax,%rdi
  8020f2:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
  8020fe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802106:	48 c1 e8 15          	shr    $0x15,%rax
  80210a:	48 89 c2             	mov    %rax,%rdx
  80210d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802114:	01 00 00 
  802117:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211b:	83 e0 01             	and    $0x1,%eax
  80211e:	48 85 c0             	test   %rax,%rax
  802121:	74 73                	je     802196 <dup+0x11d>
  802123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802127:	48 c1 e8 0c          	shr    $0xc,%rax
  80212b:	48 89 c2             	mov    %rax,%rdx
  80212e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802135:	01 00 00 
  802138:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213c:	83 e0 01             	and    $0x1,%eax
  80213f:	48 85 c0             	test   %rax,%rax
  802142:	74 52                	je     802196 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802148:	48 c1 e8 0c          	shr    $0xc,%rax
  80214c:	48 89 c2             	mov    %rax,%rdx
  80214f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802156:	01 00 00 
  802159:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215d:	25 07 0e 00 00       	and    $0xe07,%eax
  802162:	89 c1                	mov    %eax,%ecx
  802164:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216c:	41 89 c8             	mov    %ecx,%r8d
  80216f:	48 89 d1             	mov    %rdx,%rcx
  802172:	ba 00 00 00 00       	mov    $0x0,%edx
  802177:	48 89 c6             	mov    %rax,%rsi
  80217a:	bf 00 00 00 00       	mov    $0x0,%edi
  80217f:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  802186:	00 00 00 
  802189:	ff d0                	callq  *%rax
  80218b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802192:	79 02                	jns    802196 <dup+0x11d>
			goto err;
  802194:	eb 57                	jmp    8021ed <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802196:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219a:	48 c1 e8 0c          	shr    $0xc,%rax
  80219e:	48 89 c2             	mov    %rax,%rdx
  8021a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a8:	01 00 00 
  8021ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021af:	25 07 0e 00 00       	and    $0xe07,%eax
  8021b4:	89 c1                	mov    %eax,%ecx
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021be:	41 89 c8             	mov    %ecx,%r8d
  8021c1:	48 89 d1             	mov    %rdx,%rcx
  8021c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c9:	48 89 c6             	mov    %rax,%rsi
  8021cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d1:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e4:	79 02                	jns    8021e8 <dup+0x16f>
		goto err;
  8021e6:	eb 05                	jmp    8021ed <dup+0x174>

	return newfdnum;
  8021e8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021eb:	eb 33                	jmp    802220 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f1:	48 89 c6             	mov    %rax,%rsi
  8021f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f9:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  802200:	00 00 00 
  802203:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802209:	48 89 c6             	mov    %rax,%rsi
  80220c:	bf 00 00 00 00       	mov    $0x0,%edi
  802211:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  802218:	00 00 00 
  80221b:	ff d0                	callq  *%rax
	return r;
  80221d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
  802226:	48 83 ec 40          	sub    $0x40,%rsp
  80222a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80222d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802231:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802235:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802239:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80223c:	48 89 d6             	mov    %rdx,%rsi
  80223f:	89 c7                	mov    %eax,%edi
  802241:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802250:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802254:	78 24                	js     80227a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225a:	8b 00                	mov    (%rax),%eax
  80225c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802260:	48 89 d6             	mov    %rdx,%rsi
  802263:	89 c7                	mov    %eax,%edi
  802265:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  80226c:	00 00 00 
  80226f:	ff d0                	callq  *%rax
  802271:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802274:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802278:	79 05                	jns    80227f <read+0x5d>
		return r;
  80227a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227d:	eb 76                	jmp    8022f5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80227f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802283:	8b 40 08             	mov    0x8(%rax),%eax
  802286:	83 e0 03             	and    $0x3,%eax
  802289:	83 f8 01             	cmp    $0x1,%eax
  80228c:	75 3a                	jne    8022c8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80228e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802295:	00 00 00 
  802298:	48 8b 00             	mov    (%rax),%rax
  80229b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022a1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022a4:	89 c6                	mov    %eax,%esi
  8022a6:	48 bf 17 4c 80 00 00 	movabs $0x804c17,%rdi
  8022ad:	00 00 00 
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b5:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  8022bc:	00 00 00 
  8022bf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c6:	eb 2d                	jmp    8022f5 <read+0xd3>
	}
	if (!dev->dev_read)
  8022c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d0:	48 85 c0             	test   %rax,%rax
  8022d3:	75 07                	jne    8022dc <read+0xba>
		return -E_NOT_SUPP;
  8022d5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022da:	eb 19                	jmp    8022f5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022ec:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022f0:	48 89 cf             	mov    %rcx,%rdi
  8022f3:	ff d0                	callq  *%rax
}
  8022f5:	c9                   	leaveq 
  8022f6:	c3                   	retq   

00000000008022f7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022f7:	55                   	push   %rbp
  8022f8:	48 89 e5             	mov    %rsp,%rbp
  8022fb:	48 83 ec 30          	sub    $0x30,%rsp
  8022ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802306:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80230a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802311:	eb 49                	jmp    80235c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802316:	48 98                	cltq   
  802318:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80231c:	48 29 c2             	sub    %rax,%rdx
  80231f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802322:	48 63 c8             	movslq %eax,%rcx
  802325:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802329:	48 01 c1             	add    %rax,%rcx
  80232c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80232f:	48 89 ce             	mov    %rcx,%rsi
  802332:	89 c7                	mov    %eax,%edi
  802334:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
  802340:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802343:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802347:	79 05                	jns    80234e <readn+0x57>
			return m;
  802349:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80234c:	eb 1c                	jmp    80236a <readn+0x73>
		if (m == 0)
  80234e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802352:	75 02                	jne    802356 <readn+0x5f>
			break;
  802354:	eb 11                	jmp    802367 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802356:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802359:	01 45 fc             	add    %eax,-0x4(%rbp)
  80235c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235f:	48 98                	cltq   
  802361:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802365:	72 ac                	jb     802313 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802367:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 40          	sub    $0x40,%rsp
  802374:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802377:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80237b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80237f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802383:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802386:	48 89 d6             	mov    %rdx,%rsi
  802389:	89 c7                	mov    %eax,%edi
  80238b:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax
  802397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239e:	78 24                	js     8023c4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a4:	8b 00                	mov    (%rax),%eax
  8023a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023aa:	48 89 d6             	mov    %rdx,%rsi
  8023ad:	89 c7                	mov    %eax,%edi
  8023af:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  8023b6:	00 00 00 
  8023b9:	ff d0                	callq  *%rax
  8023bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c2:	79 05                	jns    8023c9 <write+0x5d>
		return r;
  8023c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c7:	eb 75                	jmp    80243e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cd:	8b 40 08             	mov    0x8(%rax),%eax
  8023d0:	83 e0 03             	and    $0x3,%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	75 3a                	jne    802411 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023d7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8023de:	00 00 00 
  8023e1:	48 8b 00             	mov    (%rax),%rax
  8023e4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023ed:	89 c6                	mov    %eax,%esi
  8023ef:	48 bf 33 4c 80 00 00 	movabs $0x804c33,%rdi
  8023f6:	00 00 00 
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fe:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  802405:	00 00 00 
  802408:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80240a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80240f:	eb 2d                	jmp    80243e <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802415:	48 8b 40 18          	mov    0x18(%rax),%rax
  802419:	48 85 c0             	test   %rax,%rax
  80241c:	75 07                	jne    802425 <write+0xb9>
		return -E_NOT_SUPP;
  80241e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802423:	eb 19                	jmp    80243e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802429:	48 8b 40 18          	mov    0x18(%rax),%rax
  80242d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802431:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802435:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802439:	48 89 cf             	mov    %rcx,%rdi
  80243c:	ff d0                	callq  *%rax
}
  80243e:	c9                   	leaveq 
  80243f:	c3                   	retq   

0000000000802440 <seek>:

int
seek(int fdnum, off_t offset)
{
  802440:	55                   	push   %rbp
  802441:	48 89 e5             	mov    %rsp,%rbp
  802444:	48 83 ec 18          	sub    $0x18,%rsp
  802448:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80244b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80244e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802452:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802455:	48 89 d6             	mov    %rdx,%rsi
  802458:	89 c7                	mov    %eax,%edi
  80245a:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  802461:	00 00 00 
  802464:	ff d0                	callq  *%rax
  802466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246d:	79 05                	jns    802474 <seek+0x34>
		return r;
  80246f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802472:	eb 0f                	jmp    802483 <seek+0x43>
	fd->fd_offset = offset;
  802474:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802478:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80247b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 30          	sub    $0x30,%rsp
  80248d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802490:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802493:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802497:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80249a:	48 89 d6             	mov    %rdx,%rsi
  80249d:	89 c7                	mov    %eax,%edi
  80249f:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	callq  *%rax
  8024ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b2:	78 24                	js     8024d8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b8:	8b 00                	mov    (%rax),%eax
  8024ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024be:	48 89 d6             	mov    %rdx,%rsi
  8024c1:	89 c7                	mov    %eax,%edi
  8024c3:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
  8024cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d6:	79 05                	jns    8024dd <ftruncate+0x58>
		return r;
  8024d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024db:	eb 72                	jmp    80254f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e1:	8b 40 08             	mov    0x8(%rax),%eax
  8024e4:	83 e0 03             	and    $0x3,%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	75 3a                	jne    802525 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024eb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024f2:	00 00 00 
  8024f5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024f8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024fe:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802501:	89 c6                	mov    %eax,%esi
  802503:	48 bf 50 4c 80 00 00 	movabs $0x804c50,%rdi
  80250a:	00 00 00 
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
  802512:	48 b9 ed 04 80 00 00 	movabs $0x8004ed,%rcx
  802519:	00 00 00 
  80251c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80251e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802523:	eb 2a                	jmp    80254f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802529:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252d:	48 85 c0             	test   %rax,%rax
  802530:	75 07                	jne    802539 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802532:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802537:	eb 16                	jmp    80254f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802541:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802545:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802548:	89 ce                	mov    %ecx,%esi
  80254a:	48 89 d7             	mov    %rdx,%rdi
  80254d:	ff d0                	callq  *%rax
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 30          	sub    $0x30,%rsp
  802559:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80255c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802560:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802564:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802567:	48 89 d6             	mov    %rdx,%rsi
  80256a:	89 c7                	mov    %eax,%edi
  80256c:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257f:	78 24                	js     8025a5 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802585:	8b 00                	mov    (%rax),%eax
  802587:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80258b:	48 89 d6             	mov    %rdx,%rsi
  80258e:	89 c7                	mov    %eax,%edi
  802590:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a3:	79 05                	jns    8025aa <fstat+0x59>
		return r;
  8025a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a8:	eb 5e                	jmp    802608 <fstat+0xb7>
	if (!dev->dev_stat)
  8025aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ae:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025b2:	48 85 c0             	test   %rax,%rax
  8025b5:	75 07                	jne    8025be <fstat+0x6d>
		return -E_NOT_SUPP;
  8025b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025bc:	eb 4a                	jmp    802608 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025d0:	00 00 00 
	stat->st_isdir = 0;
  8025d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025de:	00 00 00 
	stat->st_dev = dev;
  8025e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025fc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802600:	48 89 ce             	mov    %rcx,%rsi
  802603:	48 89 d7             	mov    %rdx,%rdi
  802606:	ff d0                	callq  *%rax
}
  802608:	c9                   	leaveq 
  802609:	c3                   	retq   

000000000080260a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80260a:	55                   	push   %rbp
  80260b:	48 89 e5             	mov    %rsp,%rbp
  80260e:	48 83 ec 20          	sub    $0x20,%rsp
  802612:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802616:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80261a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261e:	be 00 00 00 00       	mov    $0x0,%esi
  802623:	48 89 c7             	mov    %rax,%rdi
  802626:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
  802632:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802639:	79 05                	jns    802640 <stat+0x36>
		return fd;
  80263b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263e:	eb 2f                	jmp    80266f <stat+0x65>
	r = fstat(fd, stat);
  802640:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802644:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80265b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265e:	89 c7                	mov    %eax,%edi
  802660:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802667:	00 00 00 
  80266a:	ff d0                	callq  *%rax
	return r;
  80266c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80266f:	c9                   	leaveq 
  802670:	c3                   	retq   

0000000000802671 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802671:	55                   	push   %rbp
  802672:	48 89 e5             	mov    %rsp,%rbp
  802675:	48 83 ec 10          	sub    $0x10,%rsp
  802679:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80267c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802680:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802687:	00 00 00 
  80268a:	8b 00                	mov    (%rax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	75 1d                	jne    8026ad <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802690:	bf 01 00 00 00       	mov    $0x1,%edi
  802695:	48 b8 12 40 80 00 00 	movabs $0x804012,%rax
  80269c:	00 00 00 
  80269f:	ff d0                	callq  *%rax
  8026a1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026a8:	00 00 00 
  8026ab:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026b4:	00 00 00 
  8026b7:	8b 00                	mov    (%rax),%eax
  8026b9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026bc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026c1:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026c8:	00 00 00 
  8026cb:	89 c7                	mov    %eax,%edi
  8026cd:	48 b8 b0 3f 80 00 00 	movabs $0x803fb0,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e2:	48 89 c6             	mov    %rax,%rsi
  8026e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ea:	48 b8 aa 3e 80 00 00 	movabs $0x803eaa,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
}
  8026f6:	c9                   	leaveq 
  8026f7:	c3                   	retq   

00000000008026f8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026f8:	55                   	push   %rbp
  8026f9:	48 89 e5             	mov    %rsp,%rbp
  8026fc:	48 83 ec 30          	sub    $0x30,%rsp
  802700:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802704:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802707:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80270e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802715:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80271c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802721:	75 08                	jne    80272b <open+0x33>
	{
		return r;
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	e9 f2 00 00 00       	jmpq   80281d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80272b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80272f:	48 89 c7             	mov    %rax,%rdi
  802732:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax
  80273e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802741:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802748:	7e 0a                	jle    802754 <open+0x5c>
	{
		return -E_BAD_PATH;
  80274a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80274f:	e9 c9 00 00 00       	jmpq   80281d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802754:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80275b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80275c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802760:	48 89 c7             	mov    %rax,%rdi
  802763:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  80276a:	00 00 00 
  80276d:	ff d0                	callq  *%rax
  80276f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802772:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802776:	78 09                	js     802781 <open+0x89>
  802778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277c:	48 85 c0             	test   %rax,%rax
  80277f:	75 08                	jne    802789 <open+0x91>
		{
			return r;
  802781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802784:	e9 94 00 00 00       	jmpq   80281d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278d:	ba 00 04 00 00       	mov    $0x400,%edx
  802792:	48 89 c6             	mov    %rax,%rsi
  802795:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80279c:	00 00 00 
  80279f:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b2:	00 00 00 
  8027b5:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027b8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c2:	48 89 c6             	mov    %rax,%rsi
  8027c5:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ca:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027dd:	79 2b                	jns    80280a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e3:	be 00 00 00 00       	mov    $0x0,%esi
  8027e8:	48 89 c7             	mov    %rax,%rdi
  8027eb:	48 b8 80 1e 80 00 00 	movabs $0x801e80,%rax
  8027f2:	00 00 00 
  8027f5:	ff d0                	callq  *%rax
  8027f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027fa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027fe:	79 05                	jns    802805 <open+0x10d>
			{
				return d;
  802800:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802803:	eb 18                	jmp    80281d <open+0x125>
			}
			return r;
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802808:	eb 13                	jmp    80281d <open+0x125>
		}	
		return fd2num(fd_store);
  80280a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280e:	48 89 c7             	mov    %rax,%rdi
  802811:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  802818:	00 00 00 
  80281b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80281d:	c9                   	leaveq 
  80281e:	c3                   	retq   

000000000080281f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80281f:	55                   	push   %rbp
  802820:	48 89 e5             	mov    %rsp,%rbp
  802823:	48 83 ec 10          	sub    $0x10,%rsp
  802827:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80282b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282f:	8b 50 0c             	mov    0xc(%rax),%edx
  802832:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802839:	00 00 00 
  80283c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80283e:	be 00 00 00 00       	mov    $0x0,%esi
  802843:	bf 06 00 00 00       	mov    $0x6,%edi
  802848:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
}
  802854:	c9                   	leaveq 
  802855:	c3                   	retq   

0000000000802856 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802856:	55                   	push   %rbp
  802857:	48 89 e5             	mov    %rsp,%rbp
  80285a:	48 83 ec 30          	sub    $0x30,%rsp
  80285e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802862:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802866:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80286a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802871:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802876:	74 07                	je     80287f <devfile_read+0x29>
  802878:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80287d:	75 07                	jne    802886 <devfile_read+0x30>
		return -E_INVAL;
  80287f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802884:	eb 77                	jmp    8028fd <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288a:	8b 50 0c             	mov    0xc(%rax),%edx
  80288d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802894:	00 00 00 
  802897:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802899:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a0:	00 00 00 
  8028a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028a7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028ab:	be 00 00 00 00       	mov    $0x0,%esi
  8028b0:	bf 03 00 00 00       	mov    $0x3,%edi
  8028b5:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c8:	7f 05                	jg     8028cf <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cd:	eb 2e                	jmp    8028fd <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d2:	48 63 d0             	movslq %eax,%rdx
  8028d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028e0:	00 00 00 
  8028e3:	48 89 c7             	mov    %rax,%rdi
  8028e6:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8028ed:	00 00 00 
  8028f0:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028fd:	c9                   	leaveq 
  8028fe:	c3                   	retq   

00000000008028ff <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028ff:	55                   	push   %rbp
  802900:	48 89 e5             	mov    %rsp,%rbp
  802903:	48 83 ec 30          	sub    $0x30,%rsp
  802907:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80290b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80290f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802913:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80291a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80291f:	74 07                	je     802928 <devfile_write+0x29>
  802921:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802926:	75 08                	jne    802930 <devfile_write+0x31>
		return r;
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	e9 9a 00 00 00       	jmpq   8029ca <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	8b 50 0c             	mov    0xc(%rax),%edx
  802937:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80293e:	00 00 00 
  802941:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802943:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80294a:	00 
  80294b:	76 08                	jbe    802955 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80294d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802954:	00 
	}
	fsipcbuf.write.req_n = n;
  802955:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295c:	00 00 00 
  80295f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802963:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802967:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80296b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296f:	48 89 c6             	mov    %rax,%rsi
  802972:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802979:	00 00 00 
  80297c:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802988:	be 00 00 00 00       	mov    $0x0,%esi
  80298d:	bf 04 00 00 00       	mov    $0x4,%edi
  802992:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  802999:	00 00 00 
  80299c:	ff d0                	callq  *%rax
  80299e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a5:	7f 20                	jg     8029c7 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029a7:	48 bf 76 4c 80 00 00 	movabs $0x804c76,%rdi
  8029ae:	00 00 00 
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b6:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  8029bd:	00 00 00 
  8029c0:	ff d2                	callq  *%rdx
		return r;
  8029c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c5:	eb 03                	jmp    8029ca <devfile_write+0xcb>
	}
	return r;
  8029c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029ca:	c9                   	leaveq 
  8029cb:	c3                   	retq   

00000000008029cc <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 20          	sub    $0x20,%rsp
  8029d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ea:	00 00 00 
  8029ed:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029ef:	be 00 00 00 00       	mov    $0x0,%esi
  8029f4:	bf 05 00 00 00       	mov    $0x5,%edi
  8029f9:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0c:	79 05                	jns    802a13 <devfile_stat+0x47>
		return r;
  802a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a11:	eb 56                	jmp    802a69 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a17:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a1e:	00 00 00 
  802a21:	48 89 c7             	mov    %rax,%rdi
  802a24:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a30:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a37:	00 00 00 
  802a3a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a44:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a51:	00 00 00 
  802a54:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a69:	c9                   	leaveq 
  802a6a:	c3                   	retq   

0000000000802a6b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a6b:	55                   	push   %rbp
  802a6c:	48 89 e5             	mov    %rsp,%rbp
  802a6f:	48 83 ec 10          	sub    $0x10,%rsp
  802a73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a77:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7e:	8b 50 0c             	mov    0xc(%rax),%edx
  802a81:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a88:	00 00 00 
  802a8b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a94:	00 00 00 
  802a97:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a9d:	be 00 00 00 00       	mov    $0x0,%esi
  802aa2:	bf 02 00 00 00       	mov    $0x2,%edi
  802aa7:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  802aae:	00 00 00 
  802ab1:	ff d0                	callq  *%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 10          	sub    $0x10,%rsp
  802abd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac5:	48 89 c7             	mov    %rax,%rdi
  802ac8:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ad9:	7e 07                	jle    802ae2 <remove+0x2d>
		return -E_BAD_PATH;
  802adb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ae0:	eb 33                	jmp    802b15 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ae2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae6:	48 89 c6             	mov    %rax,%rsi
  802ae9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802af0:	00 00 00 
  802af3:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aff:	be 00 00 00 00       	mov    $0x0,%esi
  802b04:	bf 07 00 00 00       	mov    $0x7,%edi
  802b09:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  802b10:	00 00 00 
  802b13:	ff d0                	callq  *%rax
}
  802b15:	c9                   	leaveq 
  802b16:	c3                   	retq   

0000000000802b17 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b1b:	be 00 00 00 00       	mov    $0x0,%esi
  802b20:	bf 08 00 00 00       	mov    $0x8,%edi
  802b25:	48 b8 71 26 80 00 00 	movabs $0x802671,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
}
  802b31:	5d                   	pop    %rbp
  802b32:	c3                   	retq   

0000000000802b33 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b3e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b45:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b4c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b53:	be 00 00 00 00       	mov    $0x0,%esi
  802b58:	48 89 c7             	mov    %rax,%rdi
  802b5b:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  802b62:	00 00 00 
  802b65:	ff d0                	callq  *%rax
  802b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6e:	79 28                	jns    802b98 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b73:	89 c6                	mov    %eax,%esi
  802b75:	48 bf 92 4c 80 00 00 	movabs $0x804c92,%rdi
  802b7c:	00 00 00 
  802b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b84:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802b8b:	00 00 00 
  802b8e:	ff d2                	callq  *%rdx
		return fd_src;
  802b90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b93:	e9 74 01 00 00       	jmpq   802d0c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b98:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b9f:	be 01 01 00 00       	mov    $0x101,%esi
  802ba4:	48 89 c7             	mov    %rax,%rdi
  802ba7:	48 b8 f8 26 80 00 00 	movabs $0x8026f8,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
  802bb3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bb6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bba:	79 39                	jns    802bf5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bbf:	89 c6                	mov    %eax,%esi
  802bc1:	48 bf a8 4c 80 00 00 	movabs $0x804ca8,%rdi
  802bc8:	00 00 00 
  802bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd0:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802bd7:	00 00 00 
  802bda:	ff d2                	callq  *%rdx
		close(fd_src);
  802bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
		return fd_dest;
  802bed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf0:	e9 17 01 00 00       	jmpq   802d0c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bf5:	eb 74                	jmp    802c6b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bf7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bfa:	48 63 d0             	movslq %eax,%rdx
  802bfd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c07:	48 89 ce             	mov    %rcx,%rsi
  802c0a:	89 c7                	mov    %eax,%edi
  802c0c:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
  802c18:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c1f:	79 4a                	jns    802c6b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c21:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c24:	89 c6                	mov    %eax,%esi
  802c26:	48 bf c2 4c 80 00 00 	movabs $0x804cc2,%rdi
  802c2d:	00 00 00 
  802c30:	b8 00 00 00 00       	mov    $0x0,%eax
  802c35:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802c3c:	00 00 00 
  802c3f:	ff d2                	callq  *%rdx
			close(fd_src);
  802c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c44:	89 c7                	mov    %eax,%edi
  802c46:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
			close(fd_dest);
  802c52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
			return write_size;
  802c63:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c66:	e9 a1 00 00 00       	jmpq   802d0c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c6b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c75:	ba 00 02 00 00       	mov    $0x200,%edx
  802c7a:	48 89 ce             	mov    %rcx,%rsi
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c92:	0f 8f 5f ff ff ff    	jg     802bf7 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c9c:	79 47                	jns    802ce5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ca1:	89 c6                	mov    %eax,%esi
  802ca3:	48 bf d5 4c 80 00 00 	movabs $0x804cd5,%rdi
  802caa:	00 00 00 
  802cad:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb2:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  802cb9:	00 00 00 
  802cbc:	ff d2                	callq  *%rdx
		close(fd_src);
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	89 c7                	mov    %eax,%edi
  802cc3:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
		close(fd_dest);
  802ccf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
		return read_size;
  802ce0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce3:	eb 27                	jmp    802d0c <copy+0x1d9>
	}
	close(fd_src);
  802ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
	close(fd_dest);
  802cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
	return 0;
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 20          	sub    $0x20,%rsp
  802d16:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d20:	48 89 d6             	mov    %rdx,%rsi
  802d23:	89 c7                	mov    %eax,%edi
  802d25:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
  802d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d38:	79 05                	jns    802d3f <fd2sockid+0x31>
		return r;
  802d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3d:	eb 24                	jmp    802d63 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d43:	8b 10                	mov    (%rax),%edx
  802d45:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d4c:	00 00 00 
  802d4f:	8b 00                	mov    (%rax),%eax
  802d51:	39 c2                	cmp    %eax,%edx
  802d53:	74 07                	je     802d5c <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d55:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d5a:	eb 07                	jmp    802d63 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d60:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d63:	c9                   	leaveq 
  802d64:	c3                   	retq   

0000000000802d65 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d65:	55                   	push   %rbp
  802d66:	48 89 e5             	mov    %rsp,%rbp
  802d69:	48 83 ec 20          	sub    $0x20,%rsp
  802d6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d70:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d74:	48 89 c7             	mov    %rax,%rdi
  802d77:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	78 26                	js     802db2 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d90:	ba 07 04 00 00       	mov    $0x407,%edx
  802d95:	48 89 c6             	mov    %rax,%rsi
  802d98:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9d:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db0:	79 16                	jns    802dc8 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802db2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802db5:	89 c7                	mov    %eax,%edi
  802db7:	48 b8 72 32 80 00 00 	movabs $0x803272,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
		return r;
  802dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc6:	eb 3a                	jmp    802e02 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcc:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802dd3:	00 00 00 
  802dd6:	8b 12                	mov    (%rdx),%edx
  802dd8:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dec:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df3:	48 89 c7             	mov    %rax,%rdi
  802df6:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
}
  802e02:	c9                   	leaveq 
  802e03:	c3                   	retq   

0000000000802e04 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e04:	55                   	push   %rbp
  802e05:	48 89 e5             	mov    %rsp,%rbp
  802e08:	48 83 ec 30          	sub    $0x30,%rsp
  802e0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e1a:	89 c7                	mov    %eax,%edi
  802e1c:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2f:	79 05                	jns    802e36 <accept+0x32>
		return r;
  802e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e34:	eb 3b                	jmp    802e71 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e36:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e3a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e41:	48 89 ce             	mov    %rcx,%rsi
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 4f 31 80 00 00 	movabs $0x80314f,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
  802e52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e59:	79 05                	jns    802e60 <accept+0x5c>
		return r;
  802e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5e:	eb 11                	jmp    802e71 <accept+0x6d>
	return alloc_sockfd(r);
  802e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 20          	sub    $0x20,%rsp
  802e7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e82:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
  802e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9d:	79 05                	jns    802ea4 <bind+0x31>
		return r;
  802e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea2:	eb 1b                	jmp    802ebf <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ea4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ea7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	48 89 ce             	mov    %rcx,%rsi
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	48 b8 ce 31 80 00 00 	movabs $0x8031ce,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
}
  802ebf:	c9                   	leaveq 
  802ec0:	c3                   	retq   

0000000000802ec1 <shutdown>:

int
shutdown(int s, int how)
{
  802ec1:	55                   	push   %rbp
  802ec2:	48 89 e5             	mov    %rsp,%rbp
  802ec5:	48 83 ec 20          	sub    $0x20,%rsp
  802ec9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ecc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee7:	79 05                	jns    802eee <shutdown+0x2d>
		return r;
  802ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eec:	eb 16                	jmp    802f04 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802eee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef4:	89 d6                	mov    %edx,%esi
  802ef6:	89 c7                	mov    %eax,%edi
  802ef8:	48 b8 32 32 80 00 00 	movabs $0x803232,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
}
  802f04:	c9                   	leaveq 
  802f05:	c3                   	retq   

0000000000802f06 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f06:	55                   	push   %rbp
  802f07:	48 89 e5             	mov    %rsp,%rbp
  802f0a:	48 83 ec 10          	sub    $0x10,%rsp
  802f0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f16:	48 89 c7             	mov    %rax,%rdi
  802f19:	48 b8 94 40 80 00 00 	movabs $0x804094,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
  802f25:	83 f8 01             	cmp    $0x1,%eax
  802f28:	75 17                	jne    802f41 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2e:	8b 40 0c             	mov    0xc(%rax),%eax
  802f31:	89 c7                	mov    %eax,%edi
  802f33:	48 b8 72 32 80 00 00 	movabs $0x803272,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
  802f3f:	eb 05                	jmp    802f46 <devsock_close+0x40>
	else
		return 0;
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 20          	sub    $0x20,%rsp
  802f50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f57:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f5d:	89 c7                	mov    %eax,%edi
  802f5f:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
  802f6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f72:	79 05                	jns    802f79 <connect+0x31>
		return r;
  802f74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f77:	eb 1b                	jmp    802f94 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f79:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f7c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f83:	48 89 ce             	mov    %rcx,%rsi
  802f86:	89 c7                	mov    %eax,%edi
  802f88:	48 b8 9f 32 80 00 00 	movabs $0x80329f,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
}
  802f94:	c9                   	leaveq 
  802f95:	c3                   	retq   

0000000000802f96 <listen>:

int
listen(int s, int backlog)
{
  802f96:	55                   	push   %rbp
  802f97:	48 89 e5             	mov    %rsp,%rbp
  802f9a:	48 83 ec 20          	sub    $0x20,%rsp
  802f9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fa1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbc:	79 05                	jns    802fc3 <listen+0x2d>
		return r;
  802fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc1:	eb 16                	jmp    802fd9 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fc3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc9:	89 d6                	mov    %edx,%esi
  802fcb:	89 c7                	mov    %eax,%edi
  802fcd:	48 b8 03 33 80 00 00 	movabs $0x803303,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
}
  802fd9:	c9                   	leaveq 
  802fda:	c3                   	retq   

0000000000802fdb <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802fdb:	55                   	push   %rbp
  802fdc:	48 89 e5             	mov    %rsp,%rbp
  802fdf:	48 83 ec 20          	sub    $0x20,%rsp
  802fe3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fe7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802feb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff3:	89 c2                	mov    %eax,%edx
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	8b 40 0c             	mov    0xc(%rax),%eax
  802ffc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803000:	b9 00 00 00 00       	mov    $0x0,%ecx
  803005:	89 c7                	mov    %eax,%edi
  803007:	48 b8 43 33 80 00 00 	movabs $0x803343,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 20          	sub    $0x20,%rsp
  80301d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803021:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803025:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302d:	89 c2                	mov    %eax,%edx
  80302f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803033:	8b 40 0c             	mov    0xc(%rax),%eax
  803036:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80303a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80303f:	89 c7                	mov    %eax,%edi
  803041:	48 b8 0f 34 80 00 00 	movabs $0x80340f,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
}
  80304d:	c9                   	leaveq 
  80304e:	c3                   	retq   

000000000080304f <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80304f:	55                   	push   %rbp
  803050:	48 89 e5             	mov    %rsp,%rbp
  803053:	48 83 ec 10          	sub    $0x10,%rsp
  803057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80305f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803063:	48 be f0 4c 80 00 00 	movabs $0x804cf0,%rsi
  80306a:	00 00 00 
  80306d:	48 89 c7             	mov    %rax,%rdi
  803070:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
	return 0;
  80307c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803081:	c9                   	leaveq 
  803082:	c3                   	retq   

0000000000803083 <socket>:

int
socket(int domain, int type, int protocol)
{
  803083:	55                   	push   %rbp
  803084:	48 89 e5             	mov    %rsp,%rbp
  803087:	48 83 ec 20          	sub    $0x20,%rsp
  80308b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80308e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803091:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803094:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803097:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80309a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309d:	89 ce                	mov    %ecx,%esi
  80309f:	89 c7                	mov    %eax,%edi
  8030a1:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b4:	79 05                	jns    8030bb <socket+0x38>
		return r;
  8030b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b9:	eb 11                	jmp    8030cc <socket+0x49>
	return alloc_sockfd(r);
  8030bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030be:	89 c7                	mov    %eax,%edi
  8030c0:	48 b8 65 2d 80 00 00 	movabs $0x802d65,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
}
  8030cc:	c9                   	leaveq 
  8030cd:	c3                   	retq   

00000000008030ce <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030ce:	55                   	push   %rbp
  8030cf:	48 89 e5             	mov    %rsp,%rbp
  8030d2:	48 83 ec 10          	sub    $0x10,%rsp
  8030d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030d9:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030e0:	00 00 00 
  8030e3:	8b 00                	mov    (%rax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	75 1d                	jne    803106 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ee:	48 b8 12 40 80 00 00 	movabs $0x804012,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803101:	00 00 00 
  803104:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803106:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80310d:	00 00 00 
  803110:	8b 00                	mov    (%rax),%eax
  803112:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803115:	b9 07 00 00 00       	mov    $0x7,%ecx
  80311a:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803121:	00 00 00 
  803124:	89 c7                	mov    %eax,%edi
  803126:	48 b8 b0 3f 80 00 00 	movabs $0x803fb0,%rax
  80312d:	00 00 00 
  803130:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803132:	ba 00 00 00 00       	mov    $0x0,%edx
  803137:	be 00 00 00 00       	mov    $0x0,%esi
  80313c:	bf 00 00 00 00       	mov    $0x0,%edi
  803141:	48 b8 aa 3e 80 00 00 	movabs $0x803eaa,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
}
  80314d:	c9                   	leaveq 
  80314e:	c3                   	retq   

000000000080314f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	48 83 ec 30          	sub    $0x30,%rsp
  803157:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80315a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80315e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803162:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803169:	00 00 00 
  80316c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80316f:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803171:	bf 01 00 00 00       	mov    $0x1,%edi
  803176:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
  803182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803189:	78 3e                	js     8031c9 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80318b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803192:	00 00 00 
  803195:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319d:	8b 40 10             	mov    0x10(%rax),%eax
  8031a0:	89 c2                	mov    %eax,%edx
  8031a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031aa:	48 89 ce             	mov    %rcx,%rsi
  8031ad:	48 89 c7             	mov    %rax,%rdi
  8031b0:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c0:	8b 50 10             	mov    0x10(%rax),%edx
  8031c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c7:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031cc:	c9                   	leaveq 
  8031cd:	c3                   	retq   

00000000008031ce <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031ce:	55                   	push   %rbp
  8031cf:	48 89 e5             	mov    %rsp,%rbp
  8031d2:	48 83 ec 10          	sub    $0x10,%rsp
  8031d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031dd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031e0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e7:	00 00 00 
  8031ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031ed:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f6:	48 89 c6             	mov    %rax,%rsi
  8031f9:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803200:	00 00 00 
  803203:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  80320a:	00 00 00 
  80320d:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80320f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803216:	00 00 00 
  803219:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80321c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80321f:	bf 02 00 00 00       	mov    $0x2,%edi
  803224:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
}
  803230:	c9                   	leaveq 
  803231:	c3                   	retq   

0000000000803232 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803232:	55                   	push   %rbp
  803233:	48 89 e5             	mov    %rsp,%rbp
  803236:	48 83 ec 10          	sub    $0x10,%rsp
  80323a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80323d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803240:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803247:	00 00 00 
  80324a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80324d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80324f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803256:	00 00 00 
  803259:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80325f:	bf 03 00 00 00       	mov    $0x3,%edi
  803264:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
}
  803270:	c9                   	leaveq 
  803271:	c3                   	retq   

0000000000803272 <nsipc_close>:

int
nsipc_close(int s)
{
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
  803276:	48 83 ec 10          	sub    $0x10,%rsp
  80327a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80327d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803284:	00 00 00 
  803287:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80328a:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80328c:	bf 04 00 00 00       	mov    $0x4,%edi
  803291:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
}
  80329d:	c9                   	leaveq 
  80329e:	c3                   	retq   

000000000080329f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80329f:	55                   	push   %rbp
  8032a0:	48 89 e5             	mov    %rsp,%rbp
  8032a3:	48 83 ec 10          	sub    $0x10,%rsp
  8032a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032ae:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b8:	00 00 00 
  8032bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032be:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c7:	48 89 c6             	mov    %rax,%rsi
  8032ca:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032d1:	00 00 00 
  8032d4:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  8032db:	00 00 00 
  8032de:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032e0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e7:	00 00 00 
  8032ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ed:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032f0:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f5:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
}
  803301:	c9                   	leaveq 
  803302:	c3                   	retq   

0000000000803303 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803303:	55                   	push   %rbp
  803304:	48 89 e5             	mov    %rsp,%rbp
  803307:	48 83 ec 10          	sub    $0x10,%rsp
  80330b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80330e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803311:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803318:	00 00 00 
  80331b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80331e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803320:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803327:	00 00 00 
  80332a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803330:	bf 06 00 00 00       	mov    $0x6,%edi
  803335:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  80333c:	00 00 00 
  80333f:	ff d0                	callq  *%rax
}
  803341:	c9                   	leaveq 
  803342:	c3                   	retq   

0000000000803343 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803343:	55                   	push   %rbp
  803344:	48 89 e5             	mov    %rsp,%rbp
  803347:	48 83 ec 30          	sub    $0x30,%rsp
  80334b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80334e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803352:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803355:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803358:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335f:	00 00 00 
  803362:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803365:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803367:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336e:	00 00 00 
  803371:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803374:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803377:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80337e:	00 00 00 
  803381:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803384:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803387:	bf 07 00 00 00       	mov    $0x7,%edi
  80338c:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
  803398:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339f:	78 69                	js     80340a <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033a1:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033a8:	7f 08                	jg     8033b2 <nsipc_recv+0x6f>
  8033aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ad:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033b0:	7e 35                	jle    8033e7 <nsipc_recv+0xa4>
  8033b2:	48 b9 f7 4c 80 00 00 	movabs $0x804cf7,%rcx
  8033b9:	00 00 00 
  8033bc:	48 ba 0c 4d 80 00 00 	movabs $0x804d0c,%rdx
  8033c3:	00 00 00 
  8033c6:	be 61 00 00 00       	mov    $0x61,%esi
  8033cb:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  8033d2:	00 00 00 
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	49 b8 96 3d 80 00 00 	movabs $0x803d96,%r8
  8033e1:	00 00 00 
  8033e4:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ea:	48 63 d0             	movslq %eax,%rdx
  8033ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f1:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033f8:	00 00 00 
  8033fb:	48 89 c7             	mov    %rax,%rdi
  8033fe:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
	}

	return r;
  80340a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80340d:	c9                   	leaveq 
  80340e:	c3                   	retq   

000000000080340f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80340f:	55                   	push   %rbp
  803410:	48 89 e5             	mov    %rsp,%rbp
  803413:	48 83 ec 20          	sub    $0x20,%rsp
  803417:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80341a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80341e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803421:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803424:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342b:	00 00 00 
  80342e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803431:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803433:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80343a:	7e 35                	jle    803471 <nsipc_send+0x62>
  80343c:	48 b9 2d 4d 80 00 00 	movabs $0x804d2d,%rcx
  803443:	00 00 00 
  803446:	48 ba 0c 4d 80 00 00 	movabs $0x804d0c,%rdx
  80344d:	00 00 00 
  803450:	be 6c 00 00 00       	mov    $0x6c,%esi
  803455:	48 bf 21 4d 80 00 00 	movabs $0x804d21,%rdi
  80345c:	00 00 00 
  80345f:	b8 00 00 00 00       	mov    $0x0,%eax
  803464:	49 b8 96 3d 80 00 00 	movabs $0x803d96,%r8
  80346b:	00 00 00 
  80346e:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803471:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803474:	48 63 d0             	movslq %eax,%rdx
  803477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347b:	48 89 c6             	mov    %rax,%rsi
  80347e:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803485:	00 00 00 
  803488:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803494:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80349b:	00 00 00 
  80349e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034a4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ab:	00 00 00 
  8034ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034b1:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034b4:	bf 08 00 00 00       	mov    $0x8,%edi
  8034b9:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 10          	sub    $0x10,%rsp
  8034cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d2:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034d5:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034d8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034df:	00 00 00 
  8034e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034e5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8034e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ee:	00 00 00 
  8034f1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fe:	00 00 00 
  803501:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803504:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803507:	bf 09 00 00 00       	mov    $0x9,%edi
  80350c:	48 b8 ce 30 80 00 00 	movabs $0x8030ce,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
}
  803518:	c9                   	leaveq 
  803519:	c3                   	retq   

000000000080351a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80351a:	55                   	push   %rbp
  80351b:	48 89 e5             	mov    %rsp,%rbp
  80351e:	53                   	push   %rbx
  80351f:	48 83 ec 38          	sub    $0x38,%rsp
  803523:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803527:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80352b:	48 89 c7             	mov    %rax,%rdi
  80352e:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
  80353a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803541:	0f 88 bf 01 00 00    	js     803706 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354b:	ba 07 04 00 00       	mov    $0x407,%edx
  803550:	48 89 c6             	mov    %rax,%rsi
  803553:	bf 00 00 00 00       	mov    $0x0,%edi
  803558:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803567:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356b:	0f 88 95 01 00 00    	js     803706 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803571:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803575:	48 89 c7             	mov    %rax,%rdi
  803578:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
  803584:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803587:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80358b:	0f 88 5d 01 00 00    	js     8036ee <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803591:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803595:	ba 07 04 00 00       	mov    $0x407,%edx
  80359a:	48 89 c6             	mov    %rax,%rsi
  80359d:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a2:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
  8035ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b5:	0f 88 33 01 00 00    	js     8036ee <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bf:	48 89 c7             	mov    %rax,%rdi
  8035c2:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
  8035ce:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8035db:	48 89 c6             	mov    %rax,%rsi
  8035de:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e3:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
  8035ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f6:	79 05                	jns    8035fd <pipe+0xe3>
		goto err2;
  8035f8:	e9 d9 00 00 00       	jmpq   8036d6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803601:	48 89 c7             	mov    %rax,%rdi
  803604:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
  803610:	48 89 c2             	mov    %rax,%rdx
  803613:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803617:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80361d:	48 89 d1             	mov    %rdx,%rcx
  803620:	ba 00 00 00 00       	mov    $0x0,%edx
  803625:	48 89 c6             	mov    %rax,%rsi
  803628:	bf 00 00 00 00       	mov    $0x0,%edi
  80362d:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
  803639:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803640:	79 1b                	jns    80365d <pipe+0x143>
		goto err3;
  803642:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803643:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803647:	48 89 c6             	mov    %rax,%rsi
  80364a:	bf 00 00 00 00       	mov    $0x0,%edi
  80364f:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803656:	00 00 00 
  803659:	ff d0                	callq  *%rax
  80365b:	eb 79                	jmp    8036d6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80365d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803661:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803668:	00 00 00 
  80366b:	8b 12                	mov    (%rdx),%edx
  80366d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80366f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803673:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80367a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803685:	00 00 00 
  803688:	8b 12                	mov    (%rdx),%edx
  80368a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80368c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803690:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80369b:	48 89 c7             	mov    %rax,%rdi
  80369e:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
  8036aa:	89 c2                	mov    %eax,%edx
  8036ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036b0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036b6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036be:	48 89 c7             	mov    %rax,%rdi
  8036c1:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  8036c8:	00 00 00 
  8036cb:	ff d0                	callq  *%rax
  8036cd:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d4:	eb 33                	jmp    803709 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8036d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036da:	48 89 c6             	mov    %rax,%rsi
  8036dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e2:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f2:	48 89 c6             	mov    %rax,%rsi
  8036f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fa:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
err:
	return r;
  803706:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803709:	48 83 c4 38          	add    $0x38,%rsp
  80370d:	5b                   	pop    %rbx
  80370e:	5d                   	pop    %rbp
  80370f:	c3                   	retq   

0000000000803710 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	53                   	push   %rbx
  803715:	48 83 ec 28          	sub    $0x28,%rsp
  803719:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80371d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803721:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803728:	00 00 00 
  80372b:	48 8b 00             	mov    (%rax),%rax
  80372e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803734:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373b:	48 89 c7             	mov    %rax,%rdi
  80373e:	48 b8 94 40 80 00 00 	movabs $0x804094,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
  80374a:	89 c3                	mov    %eax,%ebx
  80374c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803750:	48 89 c7             	mov    %rax,%rdi
  803753:	48 b8 94 40 80 00 00 	movabs $0x804094,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
  80375f:	39 c3                	cmp    %eax,%ebx
  803761:	0f 94 c0             	sete   %al
  803764:	0f b6 c0             	movzbl %al,%eax
  803767:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80376a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803771:	00 00 00 
  803774:	48 8b 00             	mov    (%rax),%rax
  803777:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80377d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803783:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803786:	75 05                	jne    80378d <_pipeisclosed+0x7d>
			return ret;
  803788:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80378b:	eb 4f                	jmp    8037dc <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80378d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803790:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803793:	74 42                	je     8037d7 <_pipeisclosed+0xc7>
  803795:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803799:	75 3c                	jne    8037d7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80379b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8037a2:	00 00 00 
  8037a5:	48 8b 00             	mov    (%rax),%rax
  8037a8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037ae:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b4:	89 c6                	mov    %eax,%esi
  8037b6:	48 bf 3e 4d 80 00 00 	movabs $0x804d3e,%rdi
  8037bd:	00 00 00 
  8037c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c5:	49 b8 ed 04 80 00 00 	movabs $0x8004ed,%r8
  8037cc:	00 00 00 
  8037cf:	41 ff d0             	callq  *%r8
	}
  8037d2:	e9 4a ff ff ff       	jmpq   803721 <_pipeisclosed+0x11>
  8037d7:	e9 45 ff ff ff       	jmpq   803721 <_pipeisclosed+0x11>
}
  8037dc:	48 83 c4 28          	add    $0x28,%rsp
  8037e0:	5b                   	pop    %rbx
  8037e1:	5d                   	pop    %rbp
  8037e2:	c3                   	retq   

00000000008037e3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	48 83 ec 30          	sub    $0x30,%rsp
  8037eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037f5:	48 89 d6             	mov    %rdx,%rsi
  8037f8:	89 c7                	mov    %eax,%edi
  8037fa:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380d:	79 05                	jns    803814 <pipeisclosed+0x31>
		return r;
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	eb 31                	jmp    803845 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803818:	48 89 c7             	mov    %rax,%rdi
  80381b:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
  803827:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80382b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803833:	48 89 d6             	mov    %rdx,%rsi
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
}
  803845:	c9                   	leaveq 
  803846:	c3                   	retq   

0000000000803847 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803847:	55                   	push   %rbp
  803848:	48 89 e5             	mov    %rsp,%rbp
  80384b:	48 83 ec 40          	sub    $0x40,%rsp
  80384f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803853:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803857:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80385b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385f:	48 89 c7             	mov    %rax,%rdi
  803862:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  803869:	00 00 00 
  80386c:	ff d0                	callq  *%rax
  80386e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803876:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80387a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803881:	00 
  803882:	e9 92 00 00 00       	jmpq   803919 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803887:	eb 41                	jmp    8038ca <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803889:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80388e:	74 09                	je     803899 <devpipe_read+0x52>
				return i;
  803890:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803894:	e9 92 00 00 00       	jmpq   80392b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80389d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a1:	48 89 d6             	mov    %rdx,%rsi
  8038a4:	48 89 c7             	mov    %rax,%rdi
  8038a7:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	74 07                	je     8038be <devpipe_read+0x77>
				return 0;
  8038b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bc:	eb 6d                	jmp    80392b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038be:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ce:	8b 10                	mov    (%rax),%edx
  8038d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d4:	8b 40 04             	mov    0x4(%rax),%eax
  8038d7:	39 c2                	cmp    %eax,%edx
  8038d9:	74 ae                	je     803889 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038e3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038eb:	8b 00                	mov    (%rax),%eax
  8038ed:	99                   	cltd   
  8038ee:	c1 ea 1b             	shr    $0x1b,%edx
  8038f1:	01 d0                	add    %edx,%eax
  8038f3:	83 e0 1f             	and    $0x1f,%eax
  8038f6:	29 d0                	sub    %edx,%eax
  8038f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038fc:	48 98                	cltq   
  8038fe:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803903:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803909:	8b 00                	mov    (%rax),%eax
  80390b:	8d 50 01             	lea    0x1(%rax),%edx
  80390e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803912:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803914:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803921:	0f 82 60 ff ff ff    	jb     803887 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 40          	sub    $0x40,%rsp
  803935:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803939:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80393d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803941:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803945:	48 89 c7             	mov    %rax,%rdi
  803948:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
  803954:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803958:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80395c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803960:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803967:	00 
  803968:	e9 8e 00 00 00       	jmpq   8039fb <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80396d:	eb 31                	jmp    8039a0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80396f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803977:	48 89 d6             	mov    %rdx,%rsi
  80397a:	48 89 c7             	mov    %rax,%rdi
  80397d:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
  803989:	85 c0                	test   %eax,%eax
  80398b:	74 07                	je     803994 <devpipe_write+0x67>
				return 0;
  80398d:	b8 00 00 00 00       	mov    $0x0,%eax
  803992:	eb 79                	jmp    803a0d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803994:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a4:	8b 40 04             	mov    0x4(%rax),%eax
  8039a7:	48 63 d0             	movslq %eax,%rdx
  8039aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ae:	8b 00                	mov    (%rax),%eax
  8039b0:	48 98                	cltq   
  8039b2:	48 83 c0 20          	add    $0x20,%rax
  8039b6:	48 39 c2             	cmp    %rax,%rdx
  8039b9:	73 b4                	jae    80396f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bf:	8b 40 04             	mov    0x4(%rax),%eax
  8039c2:	99                   	cltd   
  8039c3:	c1 ea 1b             	shr    $0x1b,%edx
  8039c6:	01 d0                	add    %edx,%eax
  8039c8:	83 e0 1f             	and    $0x1f,%eax
  8039cb:	29 d0                	sub    %edx,%eax
  8039cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039d1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039d5:	48 01 ca             	add    %rcx,%rdx
  8039d8:	0f b6 0a             	movzbl (%rdx),%ecx
  8039db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039df:	48 98                	cltq   
  8039e1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e9:	8b 40 04             	mov    0x4(%rax),%eax
  8039ec:	8d 50 01             	lea    0x1(%rax),%edx
  8039ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ff:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a03:	0f 82 64 ff ff ff    	jb     80396d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a0d:	c9                   	leaveq 
  803a0e:	c3                   	retq   

0000000000803a0f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a0f:	55                   	push   %rbp
  803a10:	48 89 e5             	mov    %rsp,%rbp
  803a13:	48 83 ec 20          	sub    $0x20,%rsp
  803a17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a23:	48 89 c7             	mov    %rax,%rdi
  803a26:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3a:	48 be 51 4d 80 00 00 	movabs $0x804d51,%rsi
  803a41:	00 00 00 
  803a44:	48 89 c7             	mov    %rax,%rdi
  803a47:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a57:	8b 50 04             	mov    0x4(%rax),%edx
  803a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5e:	8b 00                	mov    (%rax),%eax
  803a60:	29 c2                	sub    %eax,%edx
  803a62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a66:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a77:	00 00 00 
	stat->st_dev = &devpipe;
  803a7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7e:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a85:	00 00 00 
  803a88:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a94:	c9                   	leaveq 
  803a95:	c3                   	retq   

0000000000803a96 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a96:	55                   	push   %rbp
  803a97:	48 89 e5             	mov    %rsp,%rbp
  803a9a:	48 83 ec 10          	sub    $0x10,%rsp
  803a9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa6:	48 89 c6             	mov    %rax,%rsi
  803aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  803aae:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803aba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abe:	48 89 c7             	mov    %rax,%rdi
  803ac1:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
  803acd:	48 89 c6             	mov    %rax,%rsi
  803ad0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad5:	48 b8 7c 1a 80 00 00 	movabs $0x801a7c,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
}
  803ae1:	c9                   	leaveq 
  803ae2:	c3                   	retq   

0000000000803ae3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ae3:	55                   	push   %rbp
  803ae4:	48 89 e5             	mov    %rsp,%rbp
  803ae7:	48 83 ec 20          	sub    $0x20,%rsp
  803aeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803af4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803af8:	be 01 00 00 00       	mov    $0x1,%esi
  803afd:	48 89 c7             	mov    %rax,%rdi
  803b00:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  803b07:	00 00 00 
  803b0a:	ff d0                	callq  *%rax
}
  803b0c:	c9                   	leaveq 
  803b0d:	c3                   	retq   

0000000000803b0e <getchar>:

int
getchar(void)
{
  803b0e:	55                   	push   %rbp
  803b0f:	48 89 e5             	mov    %rsp,%rbp
  803b12:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b16:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b1a:	ba 01 00 00 00       	mov    $0x1,%edx
  803b1f:	48 89 c6             	mov    %rax,%rsi
  803b22:	bf 00 00 00 00       	mov    $0x0,%edi
  803b27:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3a:	79 05                	jns    803b41 <getchar+0x33>
		return r;
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	eb 14                	jmp    803b55 <getchar+0x47>
	if (r < 1)
  803b41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b45:	7f 07                	jg     803b4e <getchar+0x40>
		return -E_EOF;
  803b47:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b4c:	eb 07                	jmp    803b55 <getchar+0x47>
	return c;
  803b4e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b52:	0f b6 c0             	movzbl %al,%eax
}
  803b55:	c9                   	leaveq 
  803b56:	c3                   	retq   

0000000000803b57 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b57:	55                   	push   %rbp
  803b58:	48 89 e5             	mov    %rsp,%rbp
  803b5b:	48 83 ec 20          	sub    $0x20,%rsp
  803b5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b69:	48 89 d6             	mov    %rdx,%rsi
  803b6c:	89 c7                	mov    %eax,%edi
  803b6e:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
  803b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b81:	79 05                	jns    803b88 <iscons+0x31>
		return r;
  803b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b86:	eb 1a                	jmp    803ba2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8c:	8b 10                	mov    (%rax),%edx
  803b8e:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b95:	00 00 00 
  803b98:	8b 00                	mov    (%rax),%eax
  803b9a:	39 c2                	cmp    %eax,%edx
  803b9c:	0f 94 c0             	sete   %al
  803b9f:	0f b6 c0             	movzbl %al,%eax
}
  803ba2:	c9                   	leaveq 
  803ba3:	c3                   	retq   

0000000000803ba4 <opencons>:

int
opencons(void)
{
  803ba4:	55                   	push   %rbp
  803ba5:	48 89 e5             	mov    %rsp,%rbp
  803ba8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803bac:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 58 1d 80 00 00 	movabs $0x801d58,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
  803bbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc6:	79 05                	jns    803bcd <opencons+0x29>
		return r;
  803bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcb:	eb 5b                	jmp    803c28 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd1:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd6:	48 89 c6             	mov    %rax,%rsi
  803bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bde:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
  803bea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf1:	79 05                	jns    803bf8 <opencons+0x54>
		return r;
  803bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf6:	eb 30                	jmp    803c28 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfc:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c03:	00 00 00 
  803c06:	8b 12                	mov    (%rdx),%edx
  803c08:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c19:	48 89 c7             	mov    %rax,%rdi
  803c1c:	48 b8 0a 1d 80 00 00 	movabs $0x801d0a,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
}
  803c28:	c9                   	leaveq 
  803c29:	c3                   	retq   

0000000000803c2a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c2a:	55                   	push   %rbp
  803c2b:	48 89 e5             	mov    %rsp,%rbp
  803c2e:	48 83 ec 30          	sub    $0x30,%rsp
  803c32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c3a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c3e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c43:	75 07                	jne    803c4c <devcons_read+0x22>
		return 0;
  803c45:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4a:	eb 4b                	jmp    803c97 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c4c:	eb 0c                	jmp    803c5a <devcons_read+0x30>
		sys_yield();
  803c4e:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c5a:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
  803c66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6d:	74 df                	je     803c4e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	79 05                	jns    803c7a <devcons_read+0x50>
		return c;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	eb 1d                	jmp    803c97 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c7e:	75 07                	jne    803c87 <devcons_read+0x5d>
		return 0;
  803c80:	b8 00 00 00 00       	mov    $0x0,%eax
  803c85:	eb 10                	jmp    803c97 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8a:	89 c2                	mov    %eax,%edx
  803c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c90:	88 10                	mov    %dl,(%rax)
	return 1;
  803c92:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c97:	c9                   	leaveq 
  803c98:	c3                   	retq   

0000000000803c99 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c99:	55                   	push   %rbp
  803c9a:	48 89 e5             	mov    %rsp,%rbp
  803c9d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ca4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803cab:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cb2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cc0:	eb 76                	jmp    803d38 <devcons_write+0x9f>
		m = n - tot;
  803cc2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cc9:	89 c2                	mov    %eax,%edx
  803ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cce:	29 c2                	sub    %eax,%edx
  803cd0:	89 d0                	mov    %edx,%eax
  803cd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd8:	83 f8 7f             	cmp    $0x7f,%eax
  803cdb:	76 07                	jbe    803ce4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cdd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ce4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ce7:	48 63 d0             	movslq %eax,%rdx
  803cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ced:	48 63 c8             	movslq %eax,%rcx
  803cf0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cf7:	48 01 c1             	add    %rax,%rcx
  803cfa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d01:	48 89 ce             	mov    %rcx,%rsi
  803d04:	48 89 c7             	mov    %rax,%rdi
  803d07:	48 b8 c6 13 80 00 00 	movabs $0x8013c6,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d16:	48 63 d0             	movslq %eax,%rdx
  803d19:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d20:	48 89 d6             	mov    %rdx,%rsi
  803d23:	48 89 c7             	mov    %rax,%rdi
  803d26:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  803d2d:	00 00 00 
  803d30:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d35:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3b:	48 98                	cltq   
  803d3d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d44:	0f 82 78 ff ff ff    	jb     803cc2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d4d:	c9                   	leaveq 
  803d4e:	c3                   	retq   

0000000000803d4f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d4f:	55                   	push   %rbp
  803d50:	48 89 e5             	mov    %rsp,%rbp
  803d53:	48 83 ec 08          	sub    $0x8,%rsp
  803d57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d60:	c9                   	leaveq 
  803d61:	c3                   	retq   

0000000000803d62 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d62:	55                   	push   %rbp
  803d63:	48 89 e5             	mov    %rsp,%rbp
  803d66:	48 83 ec 10          	sub    $0x10,%rsp
  803d6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d76:	48 be 5d 4d 80 00 00 	movabs $0x804d5d,%rsi
  803d7d:	00 00 00 
  803d80:	48 89 c7             	mov    %rax,%rdi
  803d83:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
	return 0;
  803d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d94:	c9                   	leaveq 
  803d95:	c3                   	retq   

0000000000803d96 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803d96:	55                   	push   %rbp
  803d97:	48 89 e5             	mov    %rsp,%rbp
  803d9a:	53                   	push   %rbx
  803d9b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803da2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803da9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803daf:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803db6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803dbd:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803dc4:	84 c0                	test   %al,%al
  803dc6:	74 23                	je     803deb <_panic+0x55>
  803dc8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803dcf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803dd3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803dd7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803ddb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803ddf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803de3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803de7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803deb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803df2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803df9:	00 00 00 
  803dfc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803e03:	00 00 00 
  803e06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e0a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803e11:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e18:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e1f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803e26:	00 00 00 
  803e29:	48 8b 18             	mov    (%rax),%rbx
  803e2c:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803e33:	00 00 00 
  803e36:	ff d0                	callq  *%rax
  803e38:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e3e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e45:	41 89 c8             	mov    %ecx,%r8d
  803e48:	48 89 d1             	mov    %rdx,%rcx
  803e4b:	48 89 da             	mov    %rbx,%rdx
  803e4e:	89 c6                	mov    %eax,%esi
  803e50:	48 bf 68 4d 80 00 00 	movabs $0x804d68,%rdi
  803e57:	00 00 00 
  803e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5f:	49 b9 ed 04 80 00 00 	movabs $0x8004ed,%r9
  803e66:	00 00 00 
  803e69:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803e6c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803e73:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e7a:	48 89 d6             	mov    %rdx,%rsi
  803e7d:	48 89 c7             	mov    %rax,%rdi
  803e80:	48 b8 41 04 80 00 00 	movabs $0x800441,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
	cprintf("\n");
  803e8c:	48 bf 8b 4d 80 00 00 	movabs $0x804d8b,%rdi
  803e93:	00 00 00 
  803e96:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9b:	48 ba ed 04 80 00 00 	movabs $0x8004ed,%rdx
  803ea2:	00 00 00 
  803ea5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803ea7:	cc                   	int3   
  803ea8:	eb fd                	jmp    803ea7 <_panic+0x111>

0000000000803eaa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eaa:	55                   	push   %rbp
  803eab:	48 89 e5             	mov    %rsp,%rbp
  803eae:	48 83 ec 30          	sub    $0x30,%rsp
  803eb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803ebe:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803ec5:	00 00 00 
  803ec8:	48 8b 00             	mov    (%rax),%rax
  803ecb:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803ed1:	85 c0                	test   %eax,%eax
  803ed3:	75 3c                	jne    803f11 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803ed5:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
  803ee1:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ee6:	48 63 d0             	movslq %eax,%rdx
  803ee9:	48 89 d0             	mov    %rdx,%rax
  803eec:	48 c1 e0 03          	shl    $0x3,%rax
  803ef0:	48 01 d0             	add    %rdx,%rax
  803ef3:	48 c1 e0 05          	shl    $0x5,%rax
  803ef7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803efe:	00 00 00 
  803f01:	48 01 c2             	add    %rax,%rdx
  803f04:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f0b:	00 00 00 
  803f0e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f11:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f16:	75 0e                	jne    803f26 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f18:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f1f:	00 00 00 
  803f22:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f2a:	48 89 c7             	mov    %rax,%rdi
  803f2d:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  803f34:	00 00 00 
  803f37:	ff d0                	callq  *%rax
  803f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f40:	79 19                	jns    803f5b <ipc_recv+0xb1>
		*from_env_store = 0;
  803f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f46:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f50:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f59:	eb 53                	jmp    803fae <ipc_recv+0x104>
	}
	if(from_env_store)
  803f5b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f60:	74 19                	je     803f7b <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f62:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f69:	00 00 00 
  803f6c:	48 8b 00             	mov    (%rax),%rax
  803f6f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f79:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f7b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f80:	74 19                	je     803f9b <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f82:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f89:	00 00 00 
  803f8c:	48 8b 00             	mov    (%rax),%rax
  803f8f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f99:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f9b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fa2:	00 00 00 
  803fa5:	48 8b 00             	mov    (%rax),%rax
  803fa8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803fae:	c9                   	leaveq 
  803faf:	c3                   	retq   

0000000000803fb0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fb0:	55                   	push   %rbp
  803fb1:	48 89 e5             	mov    %rsp,%rbp
  803fb4:	48 83 ec 30          	sub    $0x30,%rsp
  803fb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fbb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fbe:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fc2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803fc5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fca:	75 0e                	jne    803fda <ipc_send+0x2a>
		pg = (void*)UTOP;
  803fcc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fd3:	00 00 00 
  803fd6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803fda:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fdd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fe0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe7:	89 c7                	mov    %eax,%edi
  803fe9:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  803ff0:	00 00 00 
  803ff3:	ff d0                	callq  *%rax
  803ff5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803ff8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ffc:	75 0c                	jne    80400a <ipc_send+0x5a>
			sys_yield();
  803ffe:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80400a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80400e:	74 ca                	je     803fda <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804010:	c9                   	leaveq 
  804011:	c3                   	retq   

0000000000804012 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804012:	55                   	push   %rbp
  804013:	48 89 e5             	mov    %rsp,%rbp
  804016:	48 83 ec 14          	sub    $0x14,%rsp
  80401a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80401d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804024:	eb 5e                	jmp    804084 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804026:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80402d:	00 00 00 
  804030:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804033:	48 63 d0             	movslq %eax,%rdx
  804036:	48 89 d0             	mov    %rdx,%rax
  804039:	48 c1 e0 03          	shl    $0x3,%rax
  80403d:	48 01 d0             	add    %rdx,%rax
  804040:	48 c1 e0 05          	shl    $0x5,%rax
  804044:	48 01 c8             	add    %rcx,%rax
  804047:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80404d:	8b 00                	mov    (%rax),%eax
  80404f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804052:	75 2c                	jne    804080 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804054:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80405b:	00 00 00 
  80405e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804061:	48 63 d0             	movslq %eax,%rdx
  804064:	48 89 d0             	mov    %rdx,%rax
  804067:	48 c1 e0 03          	shl    $0x3,%rax
  80406b:	48 01 d0             	add    %rdx,%rax
  80406e:	48 c1 e0 05          	shl    $0x5,%rax
  804072:	48 01 c8             	add    %rcx,%rax
  804075:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80407b:	8b 40 08             	mov    0x8(%rax),%eax
  80407e:	eb 12                	jmp    804092 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804080:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804084:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80408b:	7e 99                	jle    804026 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80408d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804092:	c9                   	leaveq 
  804093:	c3                   	retq   

0000000000804094 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804094:	55                   	push   %rbp
  804095:	48 89 e5             	mov    %rsp,%rbp
  804098:	48 83 ec 18          	sub    $0x18,%rsp
  80409c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a4:	48 c1 e8 15          	shr    $0x15,%rax
  8040a8:	48 89 c2             	mov    %rax,%rdx
  8040ab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040b2:	01 00 00 
  8040b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b9:	83 e0 01             	and    $0x1,%eax
  8040bc:	48 85 c0             	test   %rax,%rax
  8040bf:	75 07                	jne    8040c8 <pageref+0x34>
		return 0;
  8040c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c6:	eb 53                	jmp    80411b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8040d0:	48 89 c2             	mov    %rax,%rdx
  8040d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040da:	01 00 00 
  8040dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e9:	83 e0 01             	and    $0x1,%eax
  8040ec:	48 85 c0             	test   %rax,%rax
  8040ef:	75 07                	jne    8040f8 <pageref+0x64>
		return 0;
  8040f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f6:	eb 23                	jmp    80411b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fc:	48 c1 e8 0c          	shr    $0xc,%rax
  804100:	48 89 c2             	mov    %rax,%rdx
  804103:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80410a:	00 00 00 
  80410d:	48 c1 e2 04          	shl    $0x4,%rdx
  804111:	48 01 d0             	add    %rdx,%rax
  804114:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804118:	0f b7 c0             	movzwl %ax,%eax
}
  80411b:	c9                   	leaveq 
  80411c:	c3                   	retq   

000000000080411d <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  80411d:	55                   	push   %rbp
  80411e:	48 89 e5             	mov    %rsp,%rbp
  804121:	48 83 ec 20          	sub    $0x20,%rsp
  804125:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804129:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80412d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804131:	48 89 d6             	mov    %rdx,%rsi
  804134:	48 89 c7             	mov    %rax,%rdi
  804137:	48 b8 53 41 80 00 00 	movabs $0x804153,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
  804143:	85 c0                	test   %eax,%eax
  804145:	74 05                	je     80414c <inet_addr+0x2f>
    return (val.s_addr);
  804147:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80414a:	eb 05                	jmp    804151 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80414c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804151:	c9                   	leaveq 
  804152:	c3                   	retq   

0000000000804153 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804153:	55                   	push   %rbp
  804154:	48 89 e5             	mov    %rsp,%rbp
  804157:	48 83 ec 40          	sub    $0x40,%rsp
  80415b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80415f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804163:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804167:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  80416b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80416f:	0f b6 00             	movzbl (%rax),%eax
  804172:	0f be c0             	movsbl %al,%eax
  804175:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804178:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80417b:	3c 2f                	cmp    $0x2f,%al
  80417d:	76 07                	jbe    804186 <inet_aton+0x33>
  80417f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804182:	3c 39                	cmp    $0x39,%al
  804184:	76 0a                	jbe    804190 <inet_aton+0x3d>
      return (0);
  804186:	b8 00 00 00 00       	mov    $0x0,%eax
  80418b:	e9 68 02 00 00       	jmpq   8043f8 <inet_aton+0x2a5>
    val = 0;
  804190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804197:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  80419e:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8041a2:	75 40                	jne    8041e4 <inet_aton+0x91>
      c = *++cp;
  8041a4:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041a9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041ad:	0f b6 00             	movzbl (%rax),%eax
  8041b0:	0f be c0             	movsbl %al,%eax
  8041b3:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8041b6:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8041ba:	74 06                	je     8041c2 <inet_aton+0x6f>
  8041bc:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8041c0:	75 1b                	jne    8041dd <inet_aton+0x8a>
        base = 16;
  8041c2:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  8041c9:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041d2:	0f b6 00             	movzbl (%rax),%eax
  8041d5:	0f be c0             	movsbl %al,%eax
  8041d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8041db:	eb 07                	jmp    8041e4 <inet_aton+0x91>
      } else
        base = 8;
  8041dd:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  8041e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041e7:	3c 2f                	cmp    $0x2f,%al
  8041e9:	76 2f                	jbe    80421a <inet_aton+0xc7>
  8041eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041ee:	3c 39                	cmp    $0x39,%al
  8041f0:	77 28                	ja     80421a <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  8041f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041f5:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8041f9:	89 c2                	mov    %eax,%edx
  8041fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041fe:	01 d0                	add    %edx,%eax
  804200:	83 e8 30             	sub    $0x30,%eax
  804203:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804206:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80420b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80420f:	0f b6 00             	movzbl (%rax),%eax
  804212:	0f be c0             	movsbl %al,%eax
  804215:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804218:	eb ca                	jmp    8041e4 <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  80421a:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80421e:	75 72                	jne    804292 <inet_aton+0x13f>
  804220:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804223:	3c 2f                	cmp    $0x2f,%al
  804225:	76 07                	jbe    80422e <inet_aton+0xdb>
  804227:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80422a:	3c 39                	cmp    $0x39,%al
  80422c:	76 1c                	jbe    80424a <inet_aton+0xf7>
  80422e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804231:	3c 60                	cmp    $0x60,%al
  804233:	76 07                	jbe    80423c <inet_aton+0xe9>
  804235:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804238:	3c 66                	cmp    $0x66,%al
  80423a:	76 0e                	jbe    80424a <inet_aton+0xf7>
  80423c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80423f:	3c 40                	cmp    $0x40,%al
  804241:	76 4f                	jbe    804292 <inet_aton+0x13f>
  804243:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804246:	3c 46                	cmp    $0x46,%al
  804248:	77 48                	ja     804292 <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80424a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424d:	c1 e0 04             	shl    $0x4,%eax
  804250:	89 c2                	mov    %eax,%edx
  804252:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804255:	8d 48 0a             	lea    0xa(%rax),%ecx
  804258:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80425b:	3c 60                	cmp    $0x60,%al
  80425d:	76 0e                	jbe    80426d <inet_aton+0x11a>
  80425f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804262:	3c 7a                	cmp    $0x7a,%al
  804264:	77 07                	ja     80426d <inet_aton+0x11a>
  804266:	b8 61 00 00 00       	mov    $0x61,%eax
  80426b:	eb 05                	jmp    804272 <inet_aton+0x11f>
  80426d:	b8 41 00 00 00       	mov    $0x41,%eax
  804272:	29 c1                	sub    %eax,%ecx
  804274:	89 c8                	mov    %ecx,%eax
  804276:	09 d0                	or     %edx,%eax
  804278:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80427b:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804280:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804284:	0f b6 00             	movzbl (%rax),%eax
  804287:	0f be c0             	movsbl %al,%eax
  80428a:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  80428d:	e9 52 ff ff ff       	jmpq   8041e4 <inet_aton+0x91>
    if (c == '.') {
  804292:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804296:	75 40                	jne    8042d8 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804298:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80429c:	48 83 c0 0c          	add    $0xc,%rax
  8042a0:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8042a4:	72 0a                	jb     8042b0 <inet_aton+0x15d>
        return (0);
  8042a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ab:	e9 48 01 00 00       	jmpq   8043f8 <inet_aton+0x2a5>
      *pp++ = val;
  8042b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b4:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8042b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8042bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042bf:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8042c1:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042ca:	0f b6 00             	movzbl (%rax),%eax
  8042cd:	0f be c0             	movsbl %al,%eax
  8042d0:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8042d3:	e9 a0 fe ff ff       	jmpq   804178 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8042d8:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8042d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8042dd:	74 3c                	je     80431b <inet_aton+0x1c8>
  8042df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042e2:	3c 1f                	cmp    $0x1f,%al
  8042e4:	76 2b                	jbe    804311 <inet_aton+0x1be>
  8042e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042e9:	84 c0                	test   %al,%al
  8042eb:	78 24                	js     804311 <inet_aton+0x1be>
  8042ed:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8042f1:	74 28                	je     80431b <inet_aton+0x1c8>
  8042f3:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8042f7:	74 22                	je     80431b <inet_aton+0x1c8>
  8042f9:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8042fd:	74 1c                	je     80431b <inet_aton+0x1c8>
  8042ff:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  804303:	74 16                	je     80431b <inet_aton+0x1c8>
  804305:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804309:	74 10                	je     80431b <inet_aton+0x1c8>
  80430b:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80430f:	74 0a                	je     80431b <inet_aton+0x1c8>
    return (0);
  804311:	b8 00 00 00 00       	mov    $0x0,%eax
  804316:	e9 dd 00 00 00       	jmpq   8043f8 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80431b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80431f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804323:	48 29 c2             	sub    %rax,%rdx
  804326:	48 89 d0             	mov    %rdx,%rax
  804329:	48 c1 f8 02          	sar    $0x2,%rax
  80432d:	83 c0 01             	add    $0x1,%eax
  804330:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  804333:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804337:	0f 87 98 00 00 00    	ja     8043d5 <inet_aton+0x282>
  80433d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804340:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804347:	00 
  804348:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  80434f:	00 00 00 
  804352:	48 01 d0             	add    %rdx,%rax
  804355:	48 8b 00             	mov    (%rax),%rax
  804358:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  80435a:	b8 00 00 00 00       	mov    $0x0,%eax
  80435f:	e9 94 00 00 00       	jmpq   8043f8 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804364:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  80436b:	76 0a                	jbe    804377 <inet_aton+0x224>
      return (0);
  80436d:	b8 00 00 00 00       	mov    $0x0,%eax
  804372:	e9 81 00 00 00       	jmpq   8043f8 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  804377:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80437a:	c1 e0 18             	shl    $0x18,%eax
  80437d:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  804380:	eb 53                	jmp    8043d5 <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804382:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804389:	76 07                	jbe    804392 <inet_aton+0x23f>
      return (0);
  80438b:	b8 00 00 00 00       	mov    $0x0,%eax
  804390:	eb 66                	jmp    8043f8 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804392:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804395:	c1 e0 18             	shl    $0x18,%eax
  804398:	89 c2                	mov    %eax,%edx
  80439a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80439d:	c1 e0 10             	shl    $0x10,%eax
  8043a0:	09 d0                	or     %edx,%eax
  8043a2:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043a5:	eb 2e                	jmp    8043d5 <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8043a7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8043ae:	76 07                	jbe    8043b7 <inet_aton+0x264>
      return (0);
  8043b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b5:	eb 41                	jmp    8043f8 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8043b7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043ba:	c1 e0 18             	shl    $0x18,%eax
  8043bd:	89 c2                	mov    %eax,%edx
  8043bf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043c2:	c1 e0 10             	shl    $0x10,%eax
  8043c5:	09 c2                	or     %eax,%edx
  8043c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8043ca:	c1 e0 08             	shl    $0x8,%eax
  8043cd:	09 d0                	or     %edx,%eax
  8043cf:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043d2:	eb 01                	jmp    8043d5 <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8043d4:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8043d5:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8043da:	74 17                	je     8043f3 <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  8043dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043df:	89 c7                	mov    %eax,%edi
  8043e1:	48 b8 71 45 80 00 00 	movabs $0x804571,%rax
  8043e8:	00 00 00 
  8043eb:	ff d0                	callq  *%rax
  8043ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8043f1:	89 02                	mov    %eax,(%rdx)
  return (1);
  8043f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043f8:	c9                   	leaveq 
  8043f9:	c3                   	retq   

00000000008043fa <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8043fa:	55                   	push   %rbp
  8043fb:	48 89 e5             	mov    %rsp,%rbp
  8043fe:	48 83 ec 30          	sub    $0x30,%rsp
  804402:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804405:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804408:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80440b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804412:	00 00 00 
  804415:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804419:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80441d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  804421:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  804425:	e9 e0 00 00 00       	jmpq   80450a <inet_ntoa+0x110>
    i = 0;
  80442a:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80442e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804432:	0f b6 08             	movzbl (%rax),%ecx
  804435:	0f b6 d1             	movzbl %cl,%edx
  804438:	89 d0                	mov    %edx,%eax
  80443a:	c1 e0 02             	shl    $0x2,%eax
  80443d:	01 d0                	add    %edx,%eax
  80443f:	c1 e0 03             	shl    $0x3,%eax
  804442:	01 d0                	add    %edx,%eax
  804444:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80444b:	01 d0                	add    %edx,%eax
  80444d:	66 c1 e8 08          	shr    $0x8,%ax
  804451:	c0 e8 03             	shr    $0x3,%al
  804454:	88 45 ed             	mov    %al,-0x13(%rbp)
  804457:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80445b:	89 d0                	mov    %edx,%eax
  80445d:	c1 e0 02             	shl    $0x2,%eax
  804460:	01 d0                	add    %edx,%eax
  804462:	01 c0                	add    %eax,%eax
  804464:	29 c1                	sub    %eax,%ecx
  804466:	89 c8                	mov    %ecx,%eax
  804468:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80446b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80446f:	0f b6 00             	movzbl (%rax),%eax
  804472:	0f b6 d0             	movzbl %al,%edx
  804475:	89 d0                	mov    %edx,%eax
  804477:	c1 e0 02             	shl    $0x2,%eax
  80447a:	01 d0                	add    %edx,%eax
  80447c:	c1 e0 03             	shl    $0x3,%eax
  80447f:	01 d0                	add    %edx,%eax
  804481:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804488:	01 d0                	add    %edx,%eax
  80448a:	66 c1 e8 08          	shr    $0x8,%ax
  80448e:	89 c2                	mov    %eax,%edx
  804490:	c0 ea 03             	shr    $0x3,%dl
  804493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804497:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804499:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80449d:	8d 50 01             	lea    0x1(%rax),%edx
  8044a0:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044a3:	0f b6 c0             	movzbl %al,%eax
  8044a6:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8044aa:	83 c2 30             	add    $0x30,%edx
  8044ad:	48 98                	cltq   
  8044af:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8044b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b7:	0f b6 00             	movzbl (%rax),%eax
  8044ba:	84 c0                	test   %al,%al
  8044bc:	0f 85 6c ff ff ff    	jne    80442e <inet_ntoa+0x34>
    while(i--)
  8044c2:	eb 1a                	jmp    8044de <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8044c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8044cc:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8044d0:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8044d4:	48 63 d2             	movslq %edx,%rdx
  8044d7:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8044dc:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8044de:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8044e2:	8d 50 ff             	lea    -0x1(%rax),%edx
  8044e5:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044e8:	84 c0                	test   %al,%al
  8044ea:	75 d8                	jne    8044c4 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8044ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8044f4:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8044f8:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8044fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804500:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804504:	83 c0 01             	add    $0x1,%eax
  804507:	88 45 ef             	mov    %al,-0x11(%rbp)
  80450a:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80450e:	0f 86 16 ff ff ff    	jbe    80442a <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804514:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80451d:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804520:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804527:	00 00 00 
}
  80452a:	c9                   	leaveq 
  80452b:	c3                   	retq   

000000000080452c <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80452c:	55                   	push   %rbp
  80452d:	48 89 e5             	mov    %rsp,%rbp
  804530:	48 83 ec 04          	sub    $0x4,%rsp
  804534:	89 f8                	mov    %edi,%eax
  804536:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80453a:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80453e:	c1 e0 08             	shl    $0x8,%eax
  804541:	89 c2                	mov    %eax,%edx
  804543:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804547:	66 c1 e8 08          	shr    $0x8,%ax
  80454b:	09 d0                	or     %edx,%eax
}
  80454d:	c9                   	leaveq 
  80454e:	c3                   	retq   

000000000080454f <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80454f:	55                   	push   %rbp
  804550:	48 89 e5             	mov    %rsp,%rbp
  804553:	48 83 ec 08          	sub    $0x8,%rsp
  804557:	89 f8                	mov    %edi,%eax
  804559:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  80455d:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804561:	89 c7                	mov    %eax,%edi
  804563:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  80456a:	00 00 00 
  80456d:	ff d0                	callq  *%rax
}
  80456f:	c9                   	leaveq 
  804570:	c3                   	retq   

0000000000804571 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  804571:	55                   	push   %rbp
  804572:	48 89 e5             	mov    %rsp,%rbp
  804575:	48 83 ec 04          	sub    $0x4,%rsp
  804579:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80457c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457f:	c1 e0 18             	shl    $0x18,%eax
  804582:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804587:	25 00 ff 00 00       	and    $0xff00,%eax
  80458c:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80458f:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  804591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804594:	25 00 00 ff 00       	and    $0xff0000,%eax
  804599:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80459d:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80459f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a2:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045a5:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8045a7:	c9                   	leaveq 
  8045a8:	c3                   	retq   

00000000008045a9 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8045a9:	55                   	push   %rbp
  8045aa:	48 89 e5             	mov    %rsp,%rbp
  8045ad:	48 83 ec 08          	sub    $0x8,%rsp
  8045b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8045b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b7:	89 c7                	mov    %eax,%edi
  8045b9:	48 b8 71 45 80 00 00 	movabs $0x804571,%rax
  8045c0:	00 00 00 
  8045c3:	ff d0                	callq  *%rax
}
  8045c5:	c9                   	leaveq 
  8045c6:	c3                   	retq   
