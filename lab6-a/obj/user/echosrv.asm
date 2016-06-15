
obj/user/echosrv.debug:     file format elf64-x86-64


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
  80003c:	e8 12 03 00 00       	callq  800353 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

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
  800056:	48 bf 00 46 80 00 00 	movabs $0x804600,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 de 03 80 00 00 	movabs $0x8003de,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <handle_client>:

void
handle_client(int sock)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 40          	sub    $0x40,%rsp
  800087:	89 7d cc             	mov    %edi,-0x34(%rbp)
	char buffer[BUFFSIZE];
	int received = -1;
  80008a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800091:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800095:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800098:	ba 20 00 00 00       	mov    $0x20,%edx
  80009d:	48 89 ce             	mov    %rcx,%rsi
  8000a0:	89 c7                	mov    %eax,%edi
  8000a2:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b5:	79 18                	jns    8000cf <handle_client+0x50>
		die("Failed to receive initial bytes from client");
  8000b7:	48 bf 08 46 80 00 00 	movabs $0x804608,%rdi
  8000be:	00 00 00 
  8000c1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cd:	eb 77                	jmp    800146 <handle_client+0xc7>
  8000cf:	eb 75                	jmp    800146 <handle_client+0xc7>
		// Send back received data
		if (write(sock, buffer, received) != received)
  8000d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d4:	48 63 d0             	movslq %eax,%rdx
  8000d7:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8000db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8000de:	48 89 ce             	mov    %rcx,%rsi
  8000e1:	89 c7                	mov    %eax,%edi
  8000e3:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f2:	74 16                	je     80010a <handle_client+0x8b>
			die("Failed to send bytes to client");
  8000f4:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  8000fb:	00 00 00 
  8000fe:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80010a:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80010e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800111:	ba 20 00 00 00       	mov    $0x20,%edx
  800116:	48 89 ce             	mov    %rcx,%rsi
  800119:	89 c7                	mov    %eax,%edi
  80011b:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
  800127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012e:	79 16                	jns    800146 <handle_client+0xc7>
			die("Failed to receive additional bytes from client");
  800130:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  800137:	00 00 00 
  80013a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  800146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014a:	7f 85                	jg     8000d1 <handle_client+0x52>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  80014c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80014f:	89 c7                	mov    %eax,%edi
  800151:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
}
  80015d:	c9                   	leaveq 
  80015e:	c3                   	retq   

000000000080015f <umain>:

void
umain(int argc, char **argv)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 70          	sub    $0x70,%rsp
  800167:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  80016a:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
	int serversock, clientsock;
	struct sockaddr_in echoserver, echoclient;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  80016e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800175:	ba 06 00 00 00       	mov    $0x6,%edx
  80017a:	be 01 00 00 00       	mov    $0x1,%esi
  80017f:	bf 02 00 00 00       	mov    $0x2,%edi
  800184:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
  800190:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800193:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800197:	79 16                	jns    8001af <umain+0x50>
		die("Failed to create socket");
  800199:	48 bf 87 46 80 00 00 	movabs $0x804687,%rdi
  8001a0:	00 00 00 
  8001a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001af:	48 bf 9f 46 80 00 00 	movabs $0x80469f,%rdi
  8001b6:	00 00 00 
  8001b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001be:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  8001c5:	00 00 00 
  8001c8:	ff d2                	callq  *%rdx

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8001ca:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001ce:	ba 10 00 00 00       	mov    $0x10,%edx
  8001d3:	be 00 00 00 00       	mov    $0x0,%esi
  8001d8:	48 89 c7             	mov    %rax,%rdi
  8001db:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8001e7:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 aa 45 80 00 00 	movabs $0x8045aa,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  8001ff:	bf 07 00 00 00       	mov    $0x7,%edi
  800204:	48 b8 65 45 80 00 00 	movabs $0x804565,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
  800210:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800214:	48 bf ae 46 80 00 00 	movabs $0x8046ae,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80022f:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800233:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800236:	ba 10 00 00 00       	mov    $0x10,%edx
  80023b:	48 89 ce             	mov    %rcx,%rsi
  80023e:	89 c7                	mov    %eax,%edi
  800240:	48 b8 ac 2e 80 00 00 	movabs $0x802eac,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	79 16                	jns    800266 <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800250:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  800257:	00 00 00 
  80025a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800266:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800269:	be 05 00 00 00       	mov    $0x5,%esi
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 cf 2f 80 00 00 	movabs $0x802fcf,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	79 16                	jns    800296 <umain+0x137>
		die("Failed to listen on server socket");
  800280:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  800287:	00 00 00 
  80028a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax

	cprintf("bound\n");
  800296:	48 bf 0a 47 80 00 00 	movabs $0x80470a,%rdi
  80029d:	00 00 00 
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  8002ac:	00 00 00 
  8002af:	ff d2                	callq  *%rdx

	// Run until canceled
	while (1) {
		cprintf("HI\n");
  8002b1:	48 bf 11 47 80 00 00 	movabs $0x804711,%rdi
  8002b8:	00 00 00 
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c0:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  8002c7:	00 00 00 
  8002ca:	ff d2                	callq  *%rdx
		unsigned int clientlen = sizeof(echoclient);
  8002cc:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%rbp)
		// Wait for client connection
		if ((clientsock =
  8002d3:	48 8d 55 ac          	lea    -0x54(%rbp),%rdx
  8002d7:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8002db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002de:	48 89 ce             	mov    %rcx,%rsi
  8002e1:	89 c7                	mov    %eax,%edi
  8002e3:	48 b8 3d 2e 80 00 00 	movabs $0x802e3d,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	callq  *%rax
  8002ef:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002f6:	79 16                	jns    80030e <umain+0x1af>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002f8:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  8002ff:	00 00 00 
  800302:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  80030e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 33 44 80 00 00 	movabs $0x804433,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	48 89 c6             	mov    %rax,%rsi
  800322:	48 bf 3b 47 80 00 00 	movabs $0x80473b,%rdi
  800329:	00 00 00 
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  800338:	00 00 00 
  80033b:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  80033d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800340:	89 c7                	mov    %eax,%edi
  800342:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  800349:	00 00 00 
  80034c:	ff d0                	callq  *%rax
	}
  80034e:	e9 5e ff ff ff       	jmpq   8002b1 <umain+0x152>

0000000000800353 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800353:	55                   	push   %rbp
  800354:	48 89 e5             	mov    %rsp,%rbp
  800357:	48 83 ec 10          	sub    $0x10,%rsp
  80035b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800362:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  800369:	00 00 00 
  80036c:	ff d0                	callq  *%rax
  80036e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800373:	48 63 d0             	movslq %eax,%rdx
  800376:	48 89 d0             	mov    %rdx,%rax
  800379:	48 c1 e0 03          	shl    $0x3,%rax
  80037d:	48 01 d0             	add    %rdx,%rax
  800380:	48 c1 e0 05          	shl    $0x5,%rax
  800384:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80038b:	00 00 00 
  80038e:	48 01 c2             	add    %rax,%rdx
  800391:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800398:	00 00 00 
  80039b:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80039e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a2:	7e 14                	jle    8003b8 <libmain+0x65>
		binaryname = argv[0];
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	48 8b 10             	mov    (%rax),%rdx
  8003ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003b2:	00 00 00 
  8003b5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bf:	48 89 d6             	mov    %rdx,%rsi
  8003c2:	89 c7                	mov    %eax,%edi
  8003c4:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  8003cb:	00 00 00 
  8003ce:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003d0:	48 b8 de 03 80 00 00 	movabs $0x8003de,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	c9                   	leaveq 
  8003dd:	c3                   	retq   

00000000008003de <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e2:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f3:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  8003fa:	00 00 00 
  8003fd:	ff d0                	callq  *%rax

}
  8003ff:	5d                   	pop    %rbp
  800400:	c3                   	retq   

0000000000800401 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	48 83 ec 10          	sub    $0x10,%rsp
  800409:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800414:	8b 00                	mov    (%rax),%eax
  800416:	8d 48 01             	lea    0x1(%rax),%ecx
  800419:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80041d:	89 0a                	mov    %ecx,(%rdx)
  80041f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800422:	89 d1                	mov    %edx,%ecx
  800424:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800428:	48 98                	cltq   
  80042a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80042e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800432:	8b 00                	mov    (%rax),%eax
  800434:	3d ff 00 00 00       	cmp    $0xff,%eax
  800439:	75 2c                	jne    800467 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80043b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043f:	8b 00                	mov    (%rax),%eax
  800441:	48 98                	cltq   
  800443:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800447:	48 83 c2 08          	add    $0x8,%rdx
  80044b:	48 89 c6             	mov    %rax,%rsi
  80044e:	48 89 d7             	mov    %rdx,%rdi
  800451:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  800458:	00 00 00 
  80045b:	ff d0                	callq  *%rax
        b->idx = 0;
  80045d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800461:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046b:	8b 40 04             	mov    0x4(%rax),%eax
  80046e:	8d 50 01             	lea    0x1(%rax),%edx
  800471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800475:	89 50 04             	mov    %edx,0x4(%rax)
}
  800478:	c9                   	leaveq 
  800479:	c3                   	retq   

000000000080047a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800485:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80048c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800493:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80049a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004a1:	48 8b 0a             	mov    (%rdx),%rcx
  8004a4:	48 89 08             	mov    %rcx,(%rax)
  8004a7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004b3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004be:	00 00 00 
    b.cnt = 0;
  8004c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004c8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004cb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004d2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004d9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004e0:	48 89 c6             	mov    %rax,%rsi
  8004e3:	48 bf 01 04 80 00 00 	movabs $0x800401,%rdi
  8004ea:	00 00 00 
  8004ed:	48 b8 d9 08 80 00 00 	movabs $0x8008d9,%rax
  8004f4:	00 00 00 
  8004f7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004f9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004ff:	48 98                	cltq   
  800501:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800508:	48 83 c2 08          	add    $0x8,%rdx
  80050c:	48 89 c6             	mov    %rax,%rsi
  80050f:	48 89 d7             	mov    %rdx,%rdi
  800512:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  800519:	00 00 00 
  80051c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80051e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800524:	c9                   	leaveq 
  800525:	c3                   	retq   

0000000000800526 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800526:	55                   	push   %rbp
  800527:	48 89 e5             	mov    %rsp,%rbp
  80052a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800531:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800538:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80053f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800546:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80054d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800554:	84 c0                	test   %al,%al
  800556:	74 20                	je     800578 <cprintf+0x52>
  800558:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80055c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800560:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800564:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800568:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80056c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800570:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800574:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800578:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80057f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800586:	00 00 00 
  800589:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800590:	00 00 00 
  800593:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800597:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80059e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ac:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005b3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005ba:	48 8b 0a             	mov    (%rdx),%rcx
  8005bd:	48 89 08             	mov    %rcx,(%rax)
  8005c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005d0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005d7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005de:	48 89 d6             	mov    %rdx,%rsi
  8005e1:	48 89 c7             	mov    %rax,%rdi
  8005e4:	48 b8 7a 04 80 00 00 	movabs $0x80047a,%rax
  8005eb:	00 00 00 
  8005ee:	ff d0                	callq  *%rax
  8005f0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005f6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005fc:	c9                   	leaveq 
  8005fd:	c3                   	retq   

00000000008005fe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fe:	55                   	push   %rbp
  8005ff:	48 89 e5             	mov    %rsp,%rbp
  800602:	53                   	push   %rbx
  800603:	48 83 ec 38          	sub    $0x38,%rsp
  800607:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80060f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800613:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800616:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80061a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80061e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800621:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800625:	77 3b                	ja     800662 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800627:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80062a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80062e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800635:	ba 00 00 00 00       	mov    $0x0,%edx
  80063a:	48 f7 f3             	div    %rbx
  80063d:	48 89 c2             	mov    %rax,%rdx
  800640:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800643:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800646:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80064a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064e:	41 89 f9             	mov    %edi,%r9d
  800651:	48 89 c7             	mov    %rax,%rdi
  800654:	48 b8 fe 05 80 00 00 	movabs $0x8005fe,%rax
  80065b:	00 00 00 
  80065e:	ff d0                	callq  *%rax
  800660:	eb 1e                	jmp    800680 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800662:	eb 12                	jmp    800676 <printnum+0x78>
			putch(padc, putdat);
  800664:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800668:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 89 ce             	mov    %rcx,%rsi
  800672:	89 d7                	mov    %edx,%edi
  800674:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800676:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80067a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80067e:	7f e4                	jg     800664 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800680:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	48 f7 f1             	div    %rcx
  80068f:	48 89 d0             	mov    %rdx,%rax
  800692:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  800699:	00 00 00 
  80069c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006a0:	0f be d0             	movsbl %al,%edx
  8006a3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 89 ce             	mov    %rcx,%rsi
  8006ae:	89 d7                	mov    %edx,%edi
  8006b0:	ff d0                	callq  *%rax
}
  8006b2:	48 83 c4 38          	add    $0x38,%rsp
  8006b6:	5b                   	pop    %rbx
  8006b7:	5d                   	pop    %rbp
  8006b8:	c3                   	retq   

00000000008006b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b9:	55                   	push   %rbp
  8006ba:	48 89 e5             	mov    %rsp,%rbp
  8006bd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006c5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006c8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006cc:	7e 52                	jle    800720 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	83 f8 30             	cmp    $0x30,%eax
  8006d7:	73 24                	jae    8006fd <getuint+0x44>
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	89 c0                	mov    %eax,%eax
  8006e9:	48 01 d0             	add    %rdx,%rax
  8006ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f0:	8b 12                	mov    (%rdx),%edx
  8006f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f9:	89 0a                	mov    %ecx,(%rdx)
  8006fb:	eb 17                	jmp    800714 <getuint+0x5b>
  8006fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800701:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800705:	48 89 d0             	mov    %rdx,%rax
  800708:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800710:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800714:	48 8b 00             	mov    (%rax),%rax
  800717:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80071b:	e9 a3 00 00 00       	jmpq   8007c3 <getuint+0x10a>
	else if (lflag)
  800720:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800724:	74 4f                	je     800775 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072a:	8b 00                	mov    (%rax),%eax
  80072c:	83 f8 30             	cmp    $0x30,%eax
  80072f:	73 24                	jae    800755 <getuint+0x9c>
  800731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800735:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	8b 00                	mov    (%rax),%eax
  80073f:	89 c0                	mov    %eax,%eax
  800741:	48 01 d0             	add    %rdx,%rax
  800744:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800748:	8b 12                	mov    (%rdx),%edx
  80074a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800751:	89 0a                	mov    %ecx,(%rdx)
  800753:	eb 17                	jmp    80076c <getuint+0xb3>
  800755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800759:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075d:	48 89 d0             	mov    %rdx,%rax
  800760:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800768:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800773:	eb 4e                	jmp    8007c3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800779:	8b 00                	mov    (%rax),%eax
  80077b:	83 f8 30             	cmp    $0x30,%eax
  80077e:	73 24                	jae    8007a4 <getuint+0xeb>
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	8b 00                	mov    (%rax),%eax
  80078e:	89 c0                	mov    %eax,%eax
  800790:	48 01 d0             	add    %rdx,%rax
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	8b 12                	mov    (%rdx),%edx
  800799:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a0:	89 0a                	mov    %ecx,(%rdx)
  8007a2:	eb 17                	jmp    8007bb <getuint+0x102>
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ac:	48 89 d0             	mov    %rdx,%rax
  8007af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	89 c0                	mov    %eax,%eax
  8007bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007c7:	c9                   	leaveq 
  8007c8:	c3                   	retq   

00000000008007c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007c9:	55                   	push   %rbp
  8007ca:	48 89 e5             	mov    %rsp,%rbp
  8007cd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007d8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007dc:	7e 52                	jle    800830 <getint+0x67>
		x=va_arg(*ap, long long);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getint+0x44>
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
  80080b:	eb 17                	jmp    800824 <getint+0x5b>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800824:	48 8b 00             	mov    (%rax),%rax
  800827:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082b:	e9 a3 00 00 00       	jmpq   8008d3 <getint+0x10a>
	else if (lflag)
  800830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800834:	74 4f                	je     800885 <getint+0xbc>
		x=va_arg(*ap, long);
  800836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083a:	8b 00                	mov    (%rax),%eax
  80083c:	83 f8 30             	cmp    $0x30,%eax
  80083f:	73 24                	jae    800865 <getint+0x9c>
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	8b 00                	mov    (%rax),%eax
  80084f:	89 c0                	mov    %eax,%eax
  800851:	48 01 d0             	add    %rdx,%rax
  800854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800858:	8b 12                	mov    (%rdx),%edx
  80085a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800861:	89 0a                	mov    %ecx,(%rdx)
  800863:	eb 17                	jmp    80087c <getint+0xb3>
  800865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800869:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086d:	48 89 d0             	mov    %rdx,%rax
  800870:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087c:	48 8b 00             	mov    (%rax),%rax
  80087f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800883:	eb 4e                	jmp    8008d3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	8b 00                	mov    (%rax),%eax
  80088b:	83 f8 30             	cmp    $0x30,%eax
  80088e:	73 24                	jae    8008b4 <getint+0xeb>
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	8b 00                	mov    (%rax),%eax
  80089e:	89 c0                	mov    %eax,%eax
  8008a0:	48 01 d0             	add    %rdx,%rax
  8008a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a7:	8b 12                	mov    (%rdx),%edx
  8008a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b0:	89 0a                	mov    %ecx,(%rdx)
  8008b2:	eb 17                	jmp    8008cb <getint+0x102>
  8008b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008bc:	48 89 d0             	mov    %rdx,%rax
  8008bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008cb:	8b 00                	mov    (%rax),%eax
  8008cd:	48 98                	cltq   
  8008cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d7:	c9                   	leaveq 
  8008d8:	c3                   	retq   

00000000008008d9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008d9:	55                   	push   %rbp
  8008da:	48 89 e5             	mov    %rsp,%rbp
  8008dd:	41 54                	push   %r12
  8008df:	53                   	push   %rbx
  8008e0:	48 83 ec 60          	sub    $0x60,%rsp
  8008e4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008e8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ec:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008f4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008f8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008fc:	48 8b 0a             	mov    (%rdx),%rcx
  8008ff:	48 89 08             	mov    %rcx,(%rax)
  800902:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800906:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80090a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80090e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800912:	eb 17                	jmp    80092b <vprintfmt+0x52>
			if (ch == '\0')
  800914:	85 db                	test   %ebx,%ebx
  800916:	0f 84 cc 04 00 00    	je     800de8 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80091c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800920:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800924:	48 89 d6             	mov    %rdx,%rsi
  800927:	89 df                	mov    %ebx,%edi
  800929:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800933:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800937:	0f b6 00             	movzbl (%rax),%eax
  80093a:	0f b6 d8             	movzbl %al,%ebx
  80093d:	83 fb 25             	cmp    $0x25,%ebx
  800940:	75 d2                	jne    800914 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800942:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800946:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80094d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800954:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80095b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800962:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800966:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80096a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80096e:	0f b6 00             	movzbl (%rax),%eax
  800971:	0f b6 d8             	movzbl %al,%ebx
  800974:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800977:	83 f8 55             	cmp    $0x55,%eax
  80097a:	0f 87 34 04 00 00    	ja     800db4 <vprintfmt+0x4db>
  800980:	89 c0                	mov    %eax,%eax
  800982:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800989:	00 
  80098a:	48 b8 78 49 80 00 00 	movabs $0x804978,%rax
  800991:	00 00 00 
  800994:	48 01 d0             	add    %rdx,%rax
  800997:	48 8b 00             	mov    (%rax),%rax
  80099a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80099c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009a0:	eb c0                	jmp    800962 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009a6:	eb ba                	jmp    800962 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009af:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 02             	shl    $0x2,%eax
  8009b7:	01 d0                	add    %edx,%eax
  8009b9:	01 c0                	add    %eax,%eax
  8009bb:	01 d8                	add    %ebx,%eax
  8009bd:	83 e8 30             	sub    $0x30,%eax
  8009c0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c7:	0f b6 00             	movzbl (%rax),%eax
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 0c                	jle    8009de <vprintfmt+0x105>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 07                	jg     8009de <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009dc:	eb d1                	jmp    8009af <vprintfmt+0xd6>
			goto process_precision;
  8009de:	eb 58                	jmp    800a38 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 30             	cmp    $0x30,%eax
  8009e6:	73 17                	jae    8009ff <vprintfmt+0x126>
  8009e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ef:	89 c0                	mov    %eax,%eax
  8009f1:	48 01 d0             	add    %rdx,%rax
  8009f4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f7:	83 c2 08             	add    $0x8,%edx
  8009fa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x135>
  8009ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a03:	48 89 d0             	mov    %rdx,%rax
  800a06:	48 83 c2 08          	add    $0x8,%rdx
  800a0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0e:	8b 00                	mov    (%rax),%eax
  800a10:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a13:	eb 23                	jmp    800a38 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a19:	79 0c                	jns    800a27 <vprintfmt+0x14e>
				width = 0;
  800a1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a22:	e9 3b ff ff ff       	jmpq   800962 <vprintfmt+0x89>
  800a27:	e9 36 ff ff ff       	jmpq   800962 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a2c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a33:	e9 2a ff ff ff       	jmpq   800962 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3c:	79 12                	jns    800a50 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a3e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a41:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a44:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a4b:	e9 12 ff ff ff       	jmpq   800962 <vprintfmt+0x89>
  800a50:	e9 0d ff ff ff       	jmpq   800962 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a55:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a59:	e9 04 ff ff ff       	jmpq   800962 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	83 f8 30             	cmp    $0x30,%eax
  800a64:	73 17                	jae    800a7d <vprintfmt+0x1a4>
  800a66:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6d:	89 c0                	mov    %eax,%eax
  800a6f:	48 01 d0             	add    %rdx,%rax
  800a72:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a75:	83 c2 08             	add    $0x8,%edx
  800a78:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a7b:	eb 0f                	jmp    800a8c <vprintfmt+0x1b3>
  800a7d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a81:	48 89 d0             	mov    %rdx,%rax
  800a84:	48 83 c2 08          	add    $0x8,%rdx
  800a88:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8c:	8b 10                	mov    (%rax),%edx
  800a8e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a96:	48 89 ce             	mov    %rcx,%rsi
  800a99:	89 d7                	mov    %edx,%edi
  800a9b:	ff d0                	callq  *%rax
			break;
  800a9d:	e9 40 03 00 00       	jmpq   800de2 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800aa2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa5:	83 f8 30             	cmp    $0x30,%eax
  800aa8:	73 17                	jae    800ac1 <vprintfmt+0x1e8>
  800aaa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab1:	89 c0                	mov    %eax,%eax
  800ab3:	48 01 d0             	add    %rdx,%rax
  800ab6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab9:	83 c2 08             	add    $0x8,%edx
  800abc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800abf:	eb 0f                	jmp    800ad0 <vprintfmt+0x1f7>
  800ac1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac5:	48 89 d0             	mov    %rdx,%rax
  800ac8:	48 83 c2 08          	add    $0x8,%rdx
  800acc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	79 02                	jns    800ad8 <vprintfmt+0x1ff>
				err = -err;
  800ad6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ad8:	83 fb 15             	cmp    $0x15,%ebx
  800adb:	7f 16                	jg     800af3 <vprintfmt+0x21a>
  800add:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  800ae4:	00 00 00 
  800ae7:	48 63 d3             	movslq %ebx,%rdx
  800aea:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aee:	4d 85 e4             	test   %r12,%r12
  800af1:	75 2e                	jne    800b21 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800af3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800af7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afb:	89 d9                	mov    %ebx,%ecx
  800afd:	48 ba 61 49 80 00 00 	movabs $0x804961,%rdx
  800b04:	00 00 00 
  800b07:	48 89 c7             	mov    %rax,%rdi
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0f:	49 b8 f1 0d 80 00 00 	movabs $0x800df1,%r8
  800b16:	00 00 00 
  800b19:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1c:	e9 c1 02 00 00       	jmpq   800de2 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b29:	4c 89 e1             	mov    %r12,%rcx
  800b2c:	48 ba 6a 49 80 00 00 	movabs $0x80496a,%rdx
  800b33:	00 00 00 
  800b36:	48 89 c7             	mov    %rax,%rdi
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3e:	49 b8 f1 0d 80 00 00 	movabs $0x800df1,%r8
  800b45:	00 00 00 
  800b48:	41 ff d0             	callq  *%r8
			break;
  800b4b:	e9 92 02 00 00       	jmpq   800de2 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b53:	83 f8 30             	cmp    $0x30,%eax
  800b56:	73 17                	jae    800b6f <vprintfmt+0x296>
  800b58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5f:	89 c0                	mov    %eax,%eax
  800b61:	48 01 d0             	add    %rdx,%rax
  800b64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b67:	83 c2 08             	add    $0x8,%edx
  800b6a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6d:	eb 0f                	jmp    800b7e <vprintfmt+0x2a5>
  800b6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b73:	48 89 d0             	mov    %rdx,%rax
  800b76:	48 83 c2 08          	add    $0x8,%rdx
  800b7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b7e:	4c 8b 20             	mov    (%rax),%r12
  800b81:	4d 85 e4             	test   %r12,%r12
  800b84:	75 0a                	jne    800b90 <vprintfmt+0x2b7>
				p = "(null)";
  800b86:	49 bc 6d 49 80 00 00 	movabs $0x80496d,%r12
  800b8d:	00 00 00 
			if (width > 0 && padc != '-')
  800b90:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b94:	7e 3f                	jle    800bd5 <vprintfmt+0x2fc>
  800b96:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b9a:	74 39                	je     800bd5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b9f:	48 98                	cltq   
  800ba1:	48 89 c6             	mov    %rax,%rsi
  800ba4:	4c 89 e7             	mov    %r12,%rdi
  800ba7:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  800bae:	00 00 00 
  800bb1:	ff d0                	callq  *%rax
  800bb3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bb6:	eb 17                	jmp    800bcf <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bb8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bbc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc4:	48 89 ce             	mov    %rcx,%rsi
  800bc7:	89 d7                	mov    %edx,%edi
  800bc9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bcb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd3:	7f e3                	jg     800bb8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd5:	eb 37                	jmp    800c0e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bd7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bdb:	74 1e                	je     800bfb <vprintfmt+0x322>
  800bdd:	83 fb 1f             	cmp    $0x1f,%ebx
  800be0:	7e 05                	jle    800be7 <vprintfmt+0x30e>
  800be2:	83 fb 7e             	cmp    $0x7e,%ebx
  800be5:	7e 14                	jle    800bfb <vprintfmt+0x322>
					putch('?', putdat);
  800be7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	48 89 d6             	mov    %rdx,%rsi
  800bf2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bf7:	ff d0                	callq  *%rax
  800bf9:	eb 0f                	jmp    800c0a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c03:	48 89 d6             	mov    %rdx,%rsi
  800c06:	89 df                	mov    %ebx,%edi
  800c08:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0e:	4c 89 e0             	mov    %r12,%rax
  800c11:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c15:	0f b6 00             	movzbl (%rax),%eax
  800c18:	0f be d8             	movsbl %al,%ebx
  800c1b:	85 db                	test   %ebx,%ebx
  800c1d:	74 10                	je     800c2f <vprintfmt+0x356>
  800c1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c23:	78 b2                	js     800bd7 <vprintfmt+0x2fe>
  800c25:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c2d:	79 a8                	jns    800bd7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c2f:	eb 16                	jmp    800c47 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	48 89 d6             	mov    %rdx,%rsi
  800c3c:	bf 20 00 00 00       	mov    $0x20,%edi
  800c41:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c43:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4b:	7f e4                	jg     800c31 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c4d:	e9 90 01 00 00       	jmpq   800de2 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c56:	be 03 00 00 00       	mov    $0x3,%esi
  800c5b:	48 89 c7             	mov    %rax,%rdi
  800c5e:	48 b8 c9 07 80 00 00 	movabs $0x8007c9,%rax
  800c65:	00 00 00 
  800c68:	ff d0                	callq  *%rax
  800c6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c72:	48 85 c0             	test   %rax,%rax
  800c75:	79 1d                	jns    800c94 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c87:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8d:	48 f7 d8             	neg    %rax
  800c90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c94:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c9b:	e9 d5 00 00 00       	jmpq   800d75 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ca0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca4:	be 03 00 00 00       	mov    $0x3,%esi
  800ca9:	48 89 c7             	mov    %rax,%rdi
  800cac:	48 b8 b9 06 80 00 00 	movabs $0x8006b9,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
  800cb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cbc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc3:	e9 ad 00 00 00       	jmpq   800d75 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800cc8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ccb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccf:	89 d6                	mov    %edx,%esi
  800cd1:	48 89 c7             	mov    %rax,%rdi
  800cd4:	48 b8 c9 07 80 00 00 	movabs $0x8007c9,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
  800ce0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ce4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ceb:	e9 85 00 00 00       	jmpq   800d75 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800cf0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf8:	48 89 d6             	mov    %rdx,%rsi
  800cfb:	bf 30 00 00 00       	mov    $0x30,%edi
  800d00:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0a:	48 89 d6             	mov    %rdx,%rsi
  800d0d:	bf 78 00 00 00       	mov    $0x78,%edi
  800d12:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d17:	83 f8 30             	cmp    $0x30,%eax
  800d1a:	73 17                	jae    800d33 <vprintfmt+0x45a>
  800d1c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d23:	89 c0                	mov    %eax,%eax
  800d25:	48 01 d0             	add    %rdx,%rax
  800d28:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d2b:	83 c2 08             	add    $0x8,%edx
  800d2e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d31:	eb 0f                	jmp    800d42 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d37:	48 89 d0             	mov    %rdx,%rax
  800d3a:	48 83 c2 08          	add    $0x8,%rdx
  800d3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d42:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d49:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d50:	eb 23                	jmp    800d75 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d56:	be 03 00 00 00       	mov    $0x3,%esi
  800d5b:	48 89 c7             	mov    %rax,%rdi
  800d5e:	48 b8 b9 06 80 00 00 	movabs $0x8006b9,%rax
  800d65:	00 00 00 
  800d68:	ff d0                	callq  *%rax
  800d6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d6e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d75:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d7a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d7d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8c:	45 89 c1             	mov    %r8d,%r9d
  800d8f:	41 89 f8             	mov    %edi,%r8d
  800d92:	48 89 c7             	mov    %rax,%rdi
  800d95:	48 b8 fe 05 80 00 00 	movabs $0x8005fe,%rax
  800d9c:	00 00 00 
  800d9f:	ff d0                	callq  *%rax
			break;
  800da1:	eb 3f                	jmp    800de2 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800da3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dab:	48 89 d6             	mov    %rdx,%rsi
  800dae:	89 df                	mov    %ebx,%edi
  800db0:	ff d0                	callq  *%rax
			break;
  800db2:	eb 2e                	jmp    800de2 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800db4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbc:	48 89 d6             	mov    %rdx,%rsi
  800dbf:	bf 25 00 00 00       	mov    $0x25,%edi
  800dc4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dc6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dcb:	eb 05                	jmp    800dd2 <vprintfmt+0x4f9>
  800dcd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dd6:	48 83 e8 01          	sub    $0x1,%rax
  800dda:	0f b6 00             	movzbl (%rax),%eax
  800ddd:	3c 25                	cmp    $0x25,%al
  800ddf:	75 ec                	jne    800dcd <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800de1:	90                   	nop
		}
	}
  800de2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de3:	e9 43 fb ff ff       	jmpq   80092b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800de8:	48 83 c4 60          	add    $0x60,%rsp
  800dec:	5b                   	pop    %rbx
  800ded:	41 5c                	pop    %r12
  800def:	5d                   	pop    %rbp
  800df0:	c3                   	retq   

0000000000800df1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800df1:	55                   	push   %rbp
  800df2:	48 89 e5             	mov    %rsp,%rbp
  800df5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dfc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e03:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e0a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e11:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e18:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e1f:	84 c0                	test   %al,%al
  800e21:	74 20                	je     800e43 <printfmt+0x52>
  800e23:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e27:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e2b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e2f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e33:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e37:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e3b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e3f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e43:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e4a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e51:	00 00 00 
  800e54:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e5b:	00 00 00 
  800e5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e62:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e69:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e70:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e77:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e7e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e85:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e8c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e93:	48 89 c7             	mov    %rax,%rdi
  800e96:	48 b8 d9 08 80 00 00 	movabs $0x8008d9,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ea2:	c9                   	leaveq 
  800ea3:	c3                   	retq   

0000000000800ea4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ea4:	55                   	push   %rbp
  800ea5:	48 89 e5             	mov    %rsp,%rbp
  800ea8:	48 83 ec 10          	sub    $0x10,%rsp
  800eac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb7:	8b 40 10             	mov    0x10(%rax),%eax
  800eba:	8d 50 01             	lea    0x1(%rax),%edx
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec8:	48 8b 10             	mov    (%rax),%rdx
  800ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ed3:	48 39 c2             	cmp    %rax,%rdx
  800ed6:	73 17                	jae    800eef <sprintputch+0x4b>
		*b->buf++ = ch;
  800ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edc:	48 8b 00             	mov    (%rax),%rax
  800edf:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ee3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ee7:	48 89 0a             	mov    %rcx,(%rdx)
  800eea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eed:	88 10                	mov    %dl,(%rax)
}
  800eef:	c9                   	leaveq 
  800ef0:	c3                   	retq   

0000000000800ef1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef1:	55                   	push   %rbp
  800ef2:	48 89 e5             	mov    %rsp,%rbp
  800ef5:	48 83 ec 50          	sub    $0x50,%rsp
  800ef9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800efd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f00:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f04:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f08:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f0c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f10:	48 8b 0a             	mov    (%rdx),%rcx
  800f13:	48 89 08             	mov    %rcx,(%rax)
  800f16:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f1a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f1e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f22:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f2a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f2e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f31:	48 98                	cltq   
  800f33:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f3b:	48 01 d0             	add    %rdx,%rax
  800f3e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f49:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f4e:	74 06                	je     800f56 <vsnprintf+0x65>
  800f50:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f54:	7f 07                	jg     800f5d <vsnprintf+0x6c>
		return -E_INVAL;
  800f56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5b:	eb 2f                	jmp    800f8c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f5d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f61:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f65:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f69:	48 89 c6             	mov    %rax,%rsi
  800f6c:	48 bf a4 0e 80 00 00 	movabs $0x800ea4,%rdi
  800f73:	00 00 00 
  800f76:	48 b8 d9 08 80 00 00 	movabs $0x8008d9,%rax
  800f7d:	00 00 00 
  800f80:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f86:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f89:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f8c:	c9                   	leaveq 
  800f8d:	c3                   	retq   

0000000000800f8e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f8e:	55                   	push   %rbp
  800f8f:	48 89 e5             	mov    %rsp,%rbp
  800f92:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f99:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fa0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fa6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fb4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fbb:	84 c0                	test   %al,%al
  800fbd:	74 20                	je     800fdf <snprintf+0x51>
  800fbf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fc3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fc7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fcb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fcf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fd3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fd7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fdb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fdf:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fe6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fed:	00 00 00 
  800ff0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ff7:	00 00 00 
  800ffa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ffe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801005:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80100c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801013:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80101a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801021:	48 8b 0a             	mov    (%rdx),%rcx
  801024:	48 89 08             	mov    %rcx,(%rax)
  801027:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80102b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80102f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801033:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801037:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80103e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801045:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80104b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801052:	48 89 c7             	mov    %rax,%rdi
  801055:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  80105c:	00 00 00 
  80105f:	ff d0                	callq  *%rax
  801061:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801067:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 18          	sub    $0x18,%rsp
  801077:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80107b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801082:	eb 09                	jmp    80108d <strlen+0x1e>
		n++;
  801084:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801088:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80108d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801091:	0f b6 00             	movzbl (%rax),%eax
  801094:	84 c0                	test   %al,%al
  801096:	75 ec                	jne    801084 <strlen+0x15>
		n++;
	return n;
  801098:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   

000000000080109d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	48 83 ec 20          	sub    $0x20,%rsp
  8010a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010b4:	eb 0e                	jmp    8010c4 <strnlen+0x27>
		n++;
  8010b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010bf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010c9:	74 0b                	je     8010d6 <strnlen+0x39>
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 e0                	jne    8010b6 <strnlen+0x19>
		n++;
	return n;
  8010d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010d9:	c9                   	leaveq 
  8010da:	c3                   	retq   

00000000008010db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	48 83 ec 20          	sub    $0x20,%rsp
  8010e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010f3:	90                   	nop
  8010f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801100:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801104:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801108:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80110c:	0f b6 12             	movzbl (%rdx),%edx
  80110f:	88 10                	mov    %dl,(%rax)
  801111:	0f b6 00             	movzbl (%rax),%eax
  801114:	84 c0                	test   %al,%al
  801116:	75 dc                	jne    8010f4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80111c:	c9                   	leaveq 
  80111d:	c3                   	retq   

000000000080111e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
  801122:	48 83 ec 20          	sub    $0x20,%rsp
  801126:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801132:	48 89 c7             	mov    %rax,%rdi
  801135:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  80113c:	00 00 00 
  80113f:	ff d0                	callq  *%rax
  801141:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801147:	48 63 d0             	movslq %eax,%rdx
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	48 01 c2             	add    %rax,%rdx
  801151:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801155:	48 89 c6             	mov    %rax,%rsi
  801158:	48 89 d7             	mov    %rdx,%rdi
  80115b:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  801162:	00 00 00 
  801165:	ff d0                	callq  *%rax
	return dst;
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80116b:	c9                   	leaveq 
  80116c:	c3                   	retq   

000000000080116d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	48 83 ec 28          	sub    $0x28,%rsp
  801175:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801179:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801189:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801190:	00 
  801191:	eb 2a                	jmp    8011bd <strncpy+0x50>
		*dst++ = *src;
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801197:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a3:	0f b6 12             	movzbl (%rdx),%edx
  8011a6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ac:	0f b6 00             	movzbl (%rax),%eax
  8011af:	84 c0                	test   %al,%al
  8011b1:	74 05                	je     8011b8 <strncpy+0x4b>
			src++;
  8011b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011c5:	72 cc                	jb     801193 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 28          	sub    $0x28,%rsp
  8011d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ee:	74 3d                	je     80122d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011f0:	eb 1d                	jmp    80120f <strlcpy+0x42>
			*dst++ = *src++;
  8011f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801202:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801206:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80120a:	0f b6 12             	movzbl (%rdx),%edx
  80120d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80120f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801214:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801219:	74 0b                	je     801226 <strlcpy+0x59>
  80121b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121f:	0f b6 00             	movzbl (%rax),%eax
  801222:	84 c0                	test   %al,%al
  801224:	75 cc                	jne    8011f2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80122d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801231:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801235:	48 29 c2             	sub    %rax,%rdx
  801238:	48 89 d0             	mov    %rdx,%rax
}
  80123b:	c9                   	leaveq 
  80123c:	c3                   	retq   

000000000080123d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123d:	55                   	push   %rbp
  80123e:	48 89 e5             	mov    %rsp,%rbp
  801241:	48 83 ec 10          	sub    $0x10,%rsp
  801245:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801249:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80124d:	eb 0a                	jmp    801259 <strcmp+0x1c>
		p++, q++;
  80124f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801254:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	0f b6 00             	movzbl (%rax),%eax
  801260:	84 c0                	test   %al,%al
  801262:	74 12                	je     801276 <strcmp+0x39>
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	0f b6 10             	movzbl (%rax),%edx
  80126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126f:	0f b6 00             	movzbl (%rax),%eax
  801272:	38 c2                	cmp    %al,%dl
  801274:	74 d9                	je     80124f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 00             	movzbl (%rax),%eax
  80127d:	0f b6 d0             	movzbl %al,%edx
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 c0             	movzbl %al,%eax
  80128a:	29 c2                	sub    %eax,%edx
  80128c:	89 d0                	mov    %edx,%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 18          	sub    $0x18,%rsp
  801298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012a4:	eb 0f                	jmp    8012b5 <strncmp+0x25>
		n--, p++, q++;
  8012a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ba:	74 1d                	je     8012d9 <strncmp+0x49>
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	84 c0                	test   %al,%al
  8012c5:	74 12                	je     8012d9 <strncmp+0x49>
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 10             	movzbl (%rax),%edx
  8012ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	38 c2                	cmp    %al,%dl
  8012d7:	74 cd                	je     8012a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012de:	75 07                	jne    8012e7 <strncmp+0x57>
		return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 18                	jmp    8012ff <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	0f b6 d0             	movzbl %al,%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 c0             	movzbl %al,%eax
  8012fb:	29 c2                	sub    %eax,%edx
  8012fd:	89 d0                	mov    %edx,%eax
}
  8012ff:	c9                   	leaveq 
  801300:	c3                   	retq   

0000000000801301 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801301:	55                   	push   %rbp
  801302:	48 89 e5             	mov    %rsp,%rbp
  801305:	48 83 ec 0c          	sub    $0xc,%rsp
  801309:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130d:	89 f0                	mov    %esi,%eax
  80130f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801312:	eb 17                	jmp    80132b <strchr+0x2a>
		if (*s == c)
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80131e:	75 06                	jne    801326 <strchr+0x25>
			return (char *) s;
  801320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801324:	eb 15                	jmp    80133b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801326:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132f:	0f b6 00             	movzbl (%rax),%eax
  801332:	84 c0                	test   %al,%al
  801334:	75 de                	jne    801314 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 0c          	sub    $0xc,%rsp
  801345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801349:	89 f0                	mov    %esi,%eax
  80134b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80134e:	eb 13                	jmp    801363 <strfind+0x26>
		if (*s == c)
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135a:	75 02                	jne    80135e <strfind+0x21>
			break;
  80135c:	eb 10                	jmp    80136e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80135e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801367:	0f b6 00             	movzbl (%rax),%eax
  80136a:	84 c0                	test   %al,%al
  80136c:	75 e2                	jne    801350 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801372:	c9                   	leaveq 
  801373:	c3                   	retq   

0000000000801374 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	48 83 ec 18          	sub    $0x18,%rsp
  80137c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801380:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801383:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801387:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80138c:	75 06                	jne    801394 <memset+0x20>
		return v;
  80138e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801392:	eb 69                	jmp    8013fd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	83 e0 03             	and    $0x3,%eax
  80139b:	48 85 c0             	test   %rax,%rax
  80139e:	75 48                	jne    8013e8 <memset+0x74>
  8013a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a4:	83 e0 03             	and    $0x3,%eax
  8013a7:	48 85 c0             	test   %rax,%rax
  8013aa:	75 3c                	jne    8013e8 <memset+0x74>
		c &= 0xFF;
  8013ac:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b6:	c1 e0 18             	shl    $0x18,%eax
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013be:	c1 e0 10             	shl    $0x10,%eax
  8013c1:	09 c2                	or     %eax,%edx
  8013c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c6:	c1 e0 08             	shl    $0x8,%eax
  8013c9:	09 d0                	or     %edx,%eax
  8013cb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d2:	48 c1 e8 02          	shr    $0x2,%rax
  8013d6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e0:	48 89 d7             	mov    %rdx,%rdi
  8013e3:	fc                   	cld    
  8013e4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013e6:	eb 11                	jmp    8013f9 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013f3:	48 89 d7             	mov    %rdx,%rdi
  8013f6:	fc                   	cld    
  8013f7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013fd:	c9                   	leaveq 
  8013fe:	c3                   	retq   

00000000008013ff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013ff:	55                   	push   %rbp
  801400:	48 89 e5             	mov    %rsp,%rbp
  801403:	48 83 ec 28          	sub    $0x28,%rsp
  801407:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801413:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801417:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80141b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142b:	0f 83 88 00 00 00    	jae    8014b9 <memmove+0xba>
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801439:	48 01 d0             	add    %rdx,%rax
  80143c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801440:	76 77                	jbe    8014b9 <memmove+0xba>
		s += n;
  801442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801446:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	83 e0 03             	and    $0x3,%eax
  801459:	48 85 c0             	test   %rax,%rax
  80145c:	75 3b                	jne    801499 <memmove+0x9a>
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	83 e0 03             	and    $0x3,%eax
  801465:	48 85 c0             	test   %rax,%rax
  801468:	75 2f                	jne    801499 <memmove+0x9a>
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	83 e0 03             	and    $0x3,%eax
  801471:	48 85 c0             	test   %rax,%rax
  801474:	75 23                	jne    801499 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147a:	48 83 e8 04          	sub    $0x4,%rax
  80147e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801482:	48 83 ea 04          	sub    $0x4,%rdx
  801486:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80148e:	48 89 c7             	mov    %rax,%rdi
  801491:	48 89 d6             	mov    %rdx,%rsi
  801494:	fd                   	std    
  801495:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801497:	eb 1d                	jmp    8014b6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	48 89 d7             	mov    %rdx,%rdi
  8014b0:	48 89 c1             	mov    %rax,%rcx
  8014b3:	fd                   	std    
  8014b4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014b6:	fc                   	cld    
  8014b7:	eb 57                	jmp    801510 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bd:	83 e0 03             	and    $0x3,%eax
  8014c0:	48 85 c0             	test   %rax,%rax
  8014c3:	75 36                	jne    8014fb <memmove+0xfc>
  8014c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c9:	83 e0 03             	and    $0x3,%eax
  8014cc:	48 85 c0             	test   %rax,%rax
  8014cf:	75 2a                	jne    8014fb <memmove+0xfc>
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	83 e0 03             	and    $0x3,%eax
  8014d8:	48 85 c0             	test   %rax,%rax
  8014db:	75 1e                	jne    8014fb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	48 c1 e8 02          	shr    $0x2,%rax
  8014e5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f0:	48 89 c7             	mov    %rax,%rdi
  8014f3:	48 89 d6             	mov    %rdx,%rsi
  8014f6:	fc                   	cld    
  8014f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014f9:	eb 15                	jmp    801510 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801503:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801507:	48 89 c7             	mov    %rax,%rdi
  80150a:	48 89 d6             	mov    %rdx,%rsi
  80150d:	fc                   	cld    
  80150e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801514:	c9                   	leaveq 
  801515:	c3                   	retq   

0000000000801516 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801516:	55                   	push   %rbp
  801517:	48 89 e5             	mov    %rsp,%rbp
  80151a:	48 83 ec 18          	sub    $0x18,%rsp
  80151e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801522:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801526:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80152a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80152e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801536:	48 89 ce             	mov    %rcx,%rsi
  801539:	48 89 c7             	mov    %rax,%rdi
  80153c:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  801543:	00 00 00 
  801546:	ff d0                	callq  *%rax
}
  801548:	c9                   	leaveq 
  801549:	c3                   	retq   

000000000080154a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80154a:	55                   	push   %rbp
  80154b:	48 89 e5             	mov    %rsp,%rbp
  80154e:	48 83 ec 28          	sub    $0x28,%rsp
  801552:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801556:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80155e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801562:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80156e:	eb 36                	jmp    8015a6 <memcmp+0x5c>
		if (*s1 != *s2)
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	0f b6 10             	movzbl (%rax),%edx
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 1a                	je     80159c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	0f b6 d0             	movzbl %al,%edx
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 c0             	movzbl %al,%eax
  801596:	29 c2                	sub    %eax,%edx
  801598:	89 d0                	mov    %edx,%eax
  80159a:	eb 20                	jmp    8015bc <memcmp+0x72>
		s1++, s2++;
  80159c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b2:	48 85 c0             	test   %rax,%rax
  8015b5:	75 b9                	jne    801570 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bc:	c9                   	leaveq 
  8015bd:	c3                   	retq   

00000000008015be <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	48 83 ec 28          	sub    $0x28,%rsp
  8015c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d9:	48 01 d0             	add    %rdx,%rax
  8015dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015e0:	eb 15                	jmp    8015f7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e6:	0f b6 10             	movzbl (%rax),%edx
  8015e9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015ec:	38 c2                	cmp    %al,%dl
  8015ee:	75 02                	jne    8015f2 <memfind+0x34>
			break;
  8015f0:	eb 0f                	jmp    801601 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015ff:	72 e1                	jb     8015e2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801605:	c9                   	leaveq 
  801606:	c3                   	retq   

0000000000801607 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801607:	55                   	push   %rbp
  801608:	48 89 e5             	mov    %rsp,%rbp
  80160b:	48 83 ec 34          	sub    $0x34,%rsp
  80160f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801613:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801617:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80161a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801621:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801628:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801629:	eb 05                	jmp    801630 <strtol+0x29>
		s++;
  80162b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	3c 20                	cmp    $0x20,%al
  801639:	74 f0                	je     80162b <strtol+0x24>
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 09                	cmp    $0x9,%al
  801644:	74 e5                	je     80162b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 2b                	cmp    $0x2b,%al
  80164f:	75 07                	jne    801658 <strtol+0x51>
		s++;
  801651:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801656:	eb 17                	jmp    80166f <strtol+0x68>
	else if (*s == '-')
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 2d                	cmp    $0x2d,%al
  801661:	75 0c                	jne    80166f <strtol+0x68>
		s++, neg = 1;
  801663:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801668:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80166f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801673:	74 06                	je     80167b <strtol+0x74>
  801675:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801679:	75 28                	jne    8016a3 <strtol+0x9c>
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	3c 30                	cmp    $0x30,%al
  801684:	75 1d                	jne    8016a3 <strtol+0x9c>
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	48 83 c0 01          	add    $0x1,%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	3c 78                	cmp    $0x78,%al
  801693:	75 0e                	jne    8016a3 <strtol+0x9c>
		s += 2, base = 16;
  801695:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80169a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016a1:	eb 2c                	jmp    8016cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016a7:	75 19                	jne    8016c2 <strtol+0xbb>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0e                	jne    8016c2 <strtol+0xbb>
		s++, base = 8;
  8016b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016c0:	eb 0d                	jmp    8016cf <strtol+0xc8>
	else if (base == 0)
  8016c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016c6:	75 07                	jne    8016cf <strtol+0xc8>
		base = 10;
  8016c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	0f b6 00             	movzbl (%rax),%eax
  8016d6:	3c 2f                	cmp    $0x2f,%al
  8016d8:	7e 1d                	jle    8016f7 <strtol+0xf0>
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	3c 39                	cmp    $0x39,%al
  8016e3:	7f 12                	jg     8016f7 <strtol+0xf0>
			dig = *s - '0';
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	0f be c0             	movsbl %al,%eax
  8016ef:	83 e8 30             	sub    $0x30,%eax
  8016f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f5:	eb 4e                	jmp    801745 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	0f b6 00             	movzbl (%rax),%eax
  8016fe:	3c 60                	cmp    $0x60,%al
  801700:	7e 1d                	jle    80171f <strtol+0x118>
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	3c 7a                	cmp    $0x7a,%al
  80170b:	7f 12                	jg     80171f <strtol+0x118>
			dig = *s - 'a' + 10;
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	0f be c0             	movsbl %al,%eax
  801717:	83 e8 57             	sub    $0x57,%eax
  80171a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171d:	eb 26                	jmp    801745 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	0f b6 00             	movzbl (%rax),%eax
  801726:	3c 40                	cmp    $0x40,%al
  801728:	7e 48                	jle    801772 <strtol+0x16b>
  80172a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	3c 5a                	cmp    $0x5a,%al
  801733:	7f 3d                	jg     801772 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	0f be c0             	movsbl %al,%eax
  80173f:	83 e8 37             	sub    $0x37,%eax
  801742:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801745:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801748:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80174b:	7c 02                	jl     80174f <strtol+0x148>
			break;
  80174d:	eb 23                	jmp    801772 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80174f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801754:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801757:	48 98                	cltq   
  801759:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80175e:	48 89 c2             	mov    %rax,%rdx
  801761:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801764:	48 98                	cltq   
  801766:	48 01 d0             	add    %rdx,%rax
  801769:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80176d:	e9 5d ff ff ff       	jmpq   8016cf <strtol+0xc8>

	if (endptr)
  801772:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801777:	74 0b                	je     801784 <strtol+0x17d>
		*endptr = (char *) s;
  801779:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801781:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801788:	74 09                	je     801793 <strtol+0x18c>
  80178a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80178e:	48 f7 d8             	neg    %rax
  801791:	eb 04                	jmp    801797 <strtol+0x190>
  801793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801797:	c9                   	leaveq 
  801798:	c3                   	retq   

0000000000801799 <strstr>:

char * strstr(const char *in, const char *str)
{
  801799:	55                   	push   %rbp
  80179a:	48 89 e5             	mov    %rsp,%rbp
  80179d:	48 83 ec 30          	sub    $0x30,%rsp
  8017a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b5:	0f b6 00             	movzbl (%rax),%eax
  8017b8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017bb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017bf:	75 06                	jne    8017c7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	eb 6b                	jmp    801832 <strstr+0x99>

	len = strlen(str);
  8017c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cb:	48 89 c7             	mov    %rax,%rdi
  8017ce:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  8017d5:	00 00 00 
  8017d8:	ff d0                	callq  *%rax
  8017da:	48 98                	cltq   
  8017dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017f2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017f6:	75 07                	jne    8017ff <strstr+0x66>
				return (char *) 0;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	eb 33                	jmp    801832 <strstr+0x99>
		} while (sc != c);
  8017ff:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801803:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801806:	75 d8                	jne    8017e0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801808:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	48 89 ce             	mov    %rcx,%rsi
  801817:	48 89 c7             	mov    %rax,%rdi
  80181a:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  801821:	00 00 00 
  801824:	ff d0                	callq  *%rax
  801826:	85 c0                	test   %eax,%eax
  801828:	75 b6                	jne    8017e0 <strstr+0x47>

	return (char *) (in - 1);
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	48 83 e8 01          	sub    $0x1,%rax
}
  801832:	c9                   	leaveq 
  801833:	c3                   	retq   

0000000000801834 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	53                   	push   %rbx
  801839:	48 83 ec 48          	sub    $0x48,%rsp
  80183d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801840:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801843:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801847:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80184b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80184f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801853:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801856:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80185a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80185e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801862:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801866:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80186a:	4c 89 c3             	mov    %r8,%rbx
  80186d:	cd 30                	int    $0x30
  80186f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801873:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801877:	74 3e                	je     8018b7 <syscall+0x83>
  801879:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80187e:	7e 37                	jle    8018b7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801880:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801884:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801887:	49 89 d0             	mov    %rdx,%r8
  80188a:	89 c1                	mov    %eax,%ecx
  80188c:	48 ba 28 4c 80 00 00 	movabs $0x804c28,%rdx
  801893:	00 00 00 
  801896:	be 23 00 00 00       	mov    $0x23,%esi
  80189b:	48 bf 45 4c 80 00 00 	movabs $0x804c45,%rdi
  8018a2:	00 00 00 
  8018a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018aa:	49 b9 cf 3d 80 00 00 	movabs $0x803dcf,%r9
  8018b1:	00 00 00 
  8018b4:	41 ff d1             	callq  *%r9

	return ret;
  8018b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018bb:	48 83 c4 48          	add    $0x48,%rsp
  8018bf:	5b                   	pop    %rbx
  8018c0:	5d                   	pop    %rbp
  8018c1:	c3                   	retq   

00000000008018c2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018c2:	55                   	push   %rbp
  8018c3:	48 89 e5             	mov    %rsp,%rbp
  8018c6:	48 83 ec 20          	sub    $0x20,%rsp
  8018ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e1:	00 
  8018e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ee:	48 89 d1             	mov    %rdx,%rcx
  8018f1:	48 89 c2             	mov    %rax,%rdx
  8018f4:	be 00 00 00 00       	mov    $0x0,%esi
  8018f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fe:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <sys_cgetc>:

int
sys_cgetc(void)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801914:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191b:	00 
  80191c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801922:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801928:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192d:	ba 00 00 00 00       	mov    $0x0,%edx
  801932:	be 00 00 00 00       	mov    $0x0,%esi
  801937:	bf 01 00 00 00       	mov    $0x1,%edi
  80193c:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
}
  801948:	c9                   	leaveq 
  801949:	c3                   	retq   

000000000080194a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80194a:	55                   	push   %rbp
  80194b:	48 89 e5             	mov    %rsp,%rbp
  80194e:	48 83 ec 10          	sub    $0x10,%rsp
  801952:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801958:	48 98                	cltq   
  80195a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801961:	00 
  801962:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801968:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801973:	48 89 c2             	mov    %rax,%rdx
  801976:	be 01 00 00 00       	mov    $0x1,%esi
  80197b:	bf 03 00 00 00       	mov    $0x3,%edi
  801980:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801996:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199d:	00 
  80199e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	be 00 00 00 00       	mov    $0x0,%esi
  8019b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8019be:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <sys_yield>:

void
sys_yield(void)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019db:	00 
  8019dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f2:	be 00 00 00 00       	mov    $0x0,%esi
  8019f7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019fc:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801a03:	00 00 00 
  801a06:	ff d0                	callq  *%rax
}
  801a08:	c9                   	leaveq 
  801a09:	c3                   	retq   

0000000000801a0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a0a:	55                   	push   %rbp
  801a0b:	48 89 e5             	mov    %rsp,%rbp
  801a0e:	48 83 ec 20          	sub    $0x20,%rsp
  801a12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a19:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1f:	48 63 c8             	movslq %eax,%rcx
  801a22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a29:	48 98                	cltq   
  801a2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a32:	00 
  801a33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a39:	49 89 c8             	mov    %rcx,%r8
  801a3c:	48 89 d1             	mov    %rdx,%rcx
  801a3f:	48 89 c2             	mov    %rax,%rdx
  801a42:	be 01 00 00 00       	mov    $0x1,%esi
  801a47:	bf 04 00 00 00       	mov    $0x4,%edi
  801a4c:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	callq  *%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 30          	sub    $0x30,%rsp
  801a62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a69:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a6c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a70:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a77:	48 63 c8             	movslq %eax,%rcx
  801a7a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a81:	48 63 f0             	movslq %eax,%rsi
  801a84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8b:	48 98                	cltq   
  801a8d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a91:	49 89 f9             	mov    %rdi,%r9
  801a94:	49 89 f0             	mov    %rsi,%r8
  801a97:	48 89 d1             	mov    %rdx,%rcx
  801a9a:	48 89 c2             	mov    %rax,%rdx
  801a9d:	be 01 00 00 00       	mov    $0x1,%esi
  801aa2:	bf 05 00 00 00       	mov    $0x5,%edi
  801aa7:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801aae:	00 00 00 
  801ab1:	ff d0                	callq  *%rax
}
  801ab3:	c9                   	leaveq 
  801ab4:	c3                   	retq   

0000000000801ab5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ab5:	55                   	push   %rbp
  801ab6:	48 89 e5             	mov    %rsp,%rbp
  801ab9:	48 83 ec 20          	sub    $0x20,%rsp
  801abd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acb:	48 98                	cltq   
  801acd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad4:	00 
  801ad5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae1:	48 89 d1             	mov    %rdx,%rcx
  801ae4:	48 89 c2             	mov    %rax,%rdx
  801ae7:	be 01 00 00 00       	mov    $0x1,%esi
  801aec:	bf 06 00 00 00       	mov    $0x6,%edi
  801af1:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	callq  *%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 10          	sub    $0x10,%rsp
  801b07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b10:	48 63 d0             	movslq %eax,%rdx
  801b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b16:	48 98                	cltq   
  801b18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1f:	00 
  801b20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2c:	48 89 d1             	mov    %rdx,%rcx
  801b2f:	48 89 c2             	mov    %rax,%rdx
  801b32:	be 01 00 00 00       	mov    $0x1,%esi
  801b37:	bf 08 00 00 00       	mov    $0x8,%edi
  801b3c:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 20          	sub    $0x20,%rsp
  801b52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b60:	48 98                	cltq   
  801b62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b69:	00 
  801b6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b76:	48 89 d1             	mov    %rdx,%rcx
  801b79:	48 89 c2             	mov    %rax,%rdx
  801b7c:	be 01 00 00 00       	mov    $0x1,%esi
  801b81:	bf 09 00 00 00       	mov    $0x9,%edi
  801b86:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	callq  *%rax
}
  801b92:	c9                   	leaveq 
  801b93:	c3                   	retq   

0000000000801b94 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b94:	55                   	push   %rbp
  801b95:	48 89 e5             	mov    %rsp,%rbp
  801b98:	48 83 ec 20          	sub    $0x20,%rsp
  801b9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ba3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801baa:	48 98                	cltq   
  801bac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb3:	00 
  801bb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc0:	48 89 d1             	mov    %rdx,%rcx
  801bc3:	48 89 c2             	mov    %rax,%rdx
  801bc6:	be 01 00 00 00       	mov    $0x1,%esi
  801bcb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bd0:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	callq  *%rax
}
  801bdc:	c9                   	leaveq 
  801bdd:	c3                   	retq   

0000000000801bde <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bde:	55                   	push   %rbp
  801bdf:	48 89 e5             	mov    %rsp,%rbp
  801be2:	48 83 ec 20          	sub    $0x20,%rsp
  801be6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bf1:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bf7:	48 63 f0             	movslq %eax,%rsi
  801bfa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c01:	48 98                	cltq   
  801c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0e:	00 
  801c0f:	49 89 f1             	mov    %rsi,%r9
  801c12:	49 89 c8             	mov    %rcx,%r8
  801c15:	48 89 d1             	mov    %rdx,%rcx
  801c18:	48 89 c2             	mov    %rax,%rdx
  801c1b:	be 00 00 00 00       	mov    $0x0,%esi
  801c20:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c25:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	callq  *%rax
}
  801c31:	c9                   	leaveq 
  801c32:	c3                   	retq   

0000000000801c33 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c33:	55                   	push   %rbp
  801c34:	48 89 e5             	mov    %rsp,%rbp
  801c37:	48 83 ec 10          	sub    $0x10,%rsp
  801c3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4a:	00 
  801c4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5c:	48 89 c2             	mov    %rax,%rdx
  801c5f:	be 01 00 00 00       	mov    $0x1,%esi
  801c64:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c69:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	callq  *%rax
}
  801c75:	c9                   	leaveq 
  801c76:	c3                   	retq   

0000000000801c77 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 83 ec 20          	sub    $0x20,%rsp
  801c7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801c87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c96:	00 
  801c97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca3:	48 89 d1             	mov    %rdx,%rcx
  801ca6:	48 89 c2             	mov    %rax,%rdx
  801ca9:	be 01 00 00 00       	mov    $0x1,%esi
  801cae:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cb3:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
}
  801cbf:	c9                   	leaveq 
  801cc0:	c3                   	retq   

0000000000801cc1 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801cc1:	55                   	push   %rbp
  801cc2:	48 89 e5             	mov    %rsp,%rbp
  801cc5:	48 83 ec 10          	sub    $0x10,%rsp
  801cc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd8:	00 
  801cd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cea:	48 89 c2             	mov    %rax,%rdx
  801ced:	be 00 00 00 00       	mov    $0x0,%esi
  801cf2:	bf 10 00 00 00       	mov    $0x10,%edi
  801cf7:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d14:	00 
  801d15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	be 00 00 00 00       	mov    $0x0,%esi
  801d30:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d35:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
}
  801d41:	c9                   	leaveq 
  801d42:	c3                   	retq   

0000000000801d43 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d43:	55                   	push   %rbp
  801d44:	48 89 e5             	mov    %rsp,%rbp
  801d47:	48 83 ec 08          	sub    $0x8,%rsp
  801d4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d4f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d53:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d5a:	ff ff ff 
  801d5d:	48 01 d0             	add    %rdx,%rax
  801d60:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d64:	c9                   	leaveq 
  801d65:	c3                   	retq   

0000000000801d66 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d66:	55                   	push   %rbp
  801d67:	48 89 e5             	mov    %rsp,%rbp
  801d6a:	48 83 ec 08          	sub    $0x8,%rsp
  801d6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d76:	48 89 c7             	mov    %rax,%rdi
  801d79:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  801d80:	00 00 00 
  801d83:	ff d0                	callq  *%rax
  801d85:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d8b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d8f:	c9                   	leaveq 
  801d90:	c3                   	retq   

0000000000801d91 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	48 83 ec 18          	sub    $0x18,%rsp
  801d99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801da4:	eb 6b                	jmp    801e11 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da9:	48 98                	cltq   
  801dab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801db1:	48 c1 e0 0c          	shl    $0xc,%rax
  801db5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbd:	48 c1 e8 15          	shr    $0x15,%rax
  801dc1:	48 89 c2             	mov    %rax,%rdx
  801dc4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dcb:	01 00 00 
  801dce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd2:	83 e0 01             	and    $0x1,%eax
  801dd5:	48 85 c0             	test   %rax,%rax
  801dd8:	74 21                	je     801dfb <fd_alloc+0x6a>
  801dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dde:	48 c1 e8 0c          	shr    $0xc,%rax
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dec:	01 00 00 
  801def:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df3:	83 e0 01             	and    $0x1,%eax
  801df6:	48 85 c0             	test   %rax,%rax
  801df9:	75 12                	jne    801e0d <fd_alloc+0x7c>
			*fd_store = fd;
  801dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e03:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	eb 1a                	jmp    801e27 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e0d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e11:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e15:	7e 8f                	jle    801da6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e22:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e27:	c9                   	leaveq 
  801e28:	c3                   	retq   

0000000000801e29 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	48 83 ec 20          	sub    $0x20,%rsp
  801e31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e3c:	78 06                	js     801e44 <fd_lookup+0x1b>
  801e3e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e42:	7e 07                	jle    801e4b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e49:	eb 6c                	jmp    801eb7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e4e:	48 98                	cltq   
  801e50:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e56:	48 c1 e0 0c          	shl    $0xc,%rax
  801e5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e62:	48 c1 e8 15          	shr    $0x15,%rax
  801e66:	48 89 c2             	mov    %rax,%rdx
  801e69:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e70:	01 00 00 
  801e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e77:	83 e0 01             	and    $0x1,%eax
  801e7a:	48 85 c0             	test   %rax,%rax
  801e7d:	74 21                	je     801ea0 <fd_lookup+0x77>
  801e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e83:	48 c1 e8 0c          	shr    $0xc,%rax
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e91:	01 00 00 
  801e94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e98:	83 e0 01             	and    $0x1,%eax
  801e9b:	48 85 c0             	test   %rax,%rax
  801e9e:	75 07                	jne    801ea7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ea0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea5:	eb 10                	jmp    801eb7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eaf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leaveq 
  801eb8:	c3                   	retq   

0000000000801eb9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eb9:	55                   	push   %rbp
  801eba:	48 89 e5             	mov    %rsp,%rbp
  801ebd:	48 83 ec 30          	sub    $0x30,%rsp
  801ec1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec5:	89 f0                	mov    %esi,%eax
  801ec7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ece:	48 89 c7             	mov    %rax,%rdi
  801ed1:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  801ed8:	00 00 00 
  801edb:	ff d0                	callq  *%rax
  801edd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ee1:	48 89 d6             	mov    %rdx,%rsi
  801ee4:	89 c7                	mov    %eax,%edi
  801ee6:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  801eed:	00 00 00 
  801ef0:	ff d0                	callq  *%rax
  801ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ef9:	78 0a                	js     801f05 <fd_close+0x4c>
	    || fd != fd2)
  801efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eff:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f03:	74 12                	je     801f17 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f05:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f09:	74 05                	je     801f10 <fd_close+0x57>
  801f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0e:	eb 05                	jmp    801f15 <fd_close+0x5c>
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	eb 69                	jmp    801f80 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1b:	8b 00                	mov    (%rax),%eax
  801f1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f21:	48 89 d6             	mov    %rdx,%rsi
  801f24:	89 c7                	mov    %eax,%edi
  801f26:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
  801f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f39:	78 2a                	js     801f65 <fd_close+0xac>
		if (dev->dev_close)
  801f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f43:	48 85 c0             	test   %rax,%rax
  801f46:	74 16                	je     801f5e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f54:	48 89 d7             	mov    %rdx,%rdi
  801f57:	ff d0                	callq  *%rax
  801f59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f5c:	eb 07                	jmp    801f65 <fd_close+0xac>
		else
			r = 0;
  801f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f69:	48 89 c6             	mov    %rax,%rsi
  801f6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f71:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	callq  *%rax
	return r;
  801f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f80:	c9                   	leaveq 
  801f81:	c3                   	retq   

0000000000801f82 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	48 83 ec 20          	sub    $0x20,%rsp
  801f8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f98:	eb 41                	jmp    801fdb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f9a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fa1:	00 00 00 
  801fa4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fa7:	48 63 d2             	movslq %edx,%rdx
  801faa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fae:	8b 00                	mov    (%rax),%eax
  801fb0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fb3:	75 22                	jne    801fd7 <dev_lookup+0x55>
			*dev = devtab[i];
  801fb5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fbc:	00 00 00 
  801fbf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc2:	48 63 d2             	movslq %edx,%rdx
  801fc5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	eb 60                	jmp    802037 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fd7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fdb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fe2:	00 00 00 
  801fe5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe8:	48 63 d2             	movslq %edx,%rdx
  801feb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fef:	48 85 c0             	test   %rax,%rax
  801ff2:	75 a6                	jne    801f9a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ff4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801ffb:	00 00 00 
  801ffe:	48 8b 00             	mov    (%rax),%rax
  802001:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802007:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80200a:	89 c6                	mov    %eax,%esi
  80200c:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  802013:	00 00 00 
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	48 b9 26 05 80 00 00 	movabs $0x800526,%rcx
  802022:	00 00 00 
  802025:	ff d1                	callq  *%rcx
	*dev = 0;
  802027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802032:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <close>:

int
close(int fdnum)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 20          	sub    $0x20,%rsp
  802041:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802044:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802048:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80204b:	48 89 d6             	mov    %rdx,%rsi
  80204e:	89 c7                	mov    %eax,%edi
  802050:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
  80205c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80205f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802063:	79 05                	jns    80206a <close+0x31>
		return r;
  802065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802068:	eb 18                	jmp    802082 <close+0x49>
	else
		return fd_close(fd, 1);
  80206a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206e:	be 01 00 00 00       	mov    $0x1,%esi
  802073:	48 89 c7             	mov    %rax,%rdi
  802076:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  80207d:	00 00 00 
  802080:	ff d0                	callq  *%rax
}
  802082:	c9                   	leaveq 
  802083:	c3                   	retq   

0000000000802084 <close_all>:

void
close_all(void)
{
  802084:	55                   	push   %rbp
  802085:	48 89 e5             	mov    %rsp,%rbp
  802088:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802093:	eb 15                	jmp    8020aa <close_all+0x26>
		close(i);
  802095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802098:	89 c7                	mov    %eax,%edi
  80209a:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020aa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020ae:	7e e5                	jle    802095 <close_all+0x11>
		close(i);
}
  8020b0:	c9                   	leaveq 
  8020b1:	c3                   	retq   

00000000008020b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020b2:	55                   	push   %rbp
  8020b3:	48 89 e5             	mov    %rsp,%rbp
  8020b6:	48 83 ec 40          	sub    $0x40,%rsp
  8020ba:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020bd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020c0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020c4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020c7:	48 89 d6             	mov    %rdx,%rsi
  8020ca:	89 c7                	mov    %eax,%edi
  8020cc:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020df:	79 08                	jns    8020e9 <dup+0x37>
		return r;
  8020e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e4:	e9 70 01 00 00       	jmpq   802259 <dup+0x1a7>
	close(newfdnum);
  8020e9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ec:	89 c7                	mov    %eax,%edi
  8020ee:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8020f5:	00 00 00 
  8020f8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020fd:	48 98                	cltq   
  8020ff:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802105:	48 c1 e0 0c          	shl    $0xc,%rax
  802109:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80210d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802111:	48 89 c7             	mov    %rax,%rdi
  802114:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  80211b:	00 00 00 
  80211e:	ff d0                	callq  *%rax
  802120:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802128:	48 89 c7             	mov    %rax,%rdi
  80212b:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
  802137:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80213b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213f:	48 c1 e8 15          	shr    $0x15,%rax
  802143:	48 89 c2             	mov    %rax,%rdx
  802146:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214d:	01 00 00 
  802150:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802154:	83 e0 01             	and    $0x1,%eax
  802157:	48 85 c0             	test   %rax,%rax
  80215a:	74 73                	je     8021cf <dup+0x11d>
  80215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802160:	48 c1 e8 0c          	shr    $0xc,%rax
  802164:	48 89 c2             	mov    %rax,%rdx
  802167:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216e:	01 00 00 
  802171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802175:	83 e0 01             	and    $0x1,%eax
  802178:	48 85 c0             	test   %rax,%rax
  80217b:	74 52                	je     8021cf <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	48 c1 e8 0c          	shr    $0xc,%rax
  802185:	48 89 c2             	mov    %rax,%rdx
  802188:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218f:	01 00 00 
  802192:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802196:	25 07 0e 00 00       	and    $0xe07,%eax
  80219b:	89 c1                	mov    %eax,%ecx
  80219d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	41 89 c8             	mov    %ecx,%r8d
  8021a8:	48 89 d1             	mov    %rdx,%rcx
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	48 89 c6             	mov    %rax,%rsi
  8021b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b8:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  8021bf:	00 00 00 
  8021c2:	ff d0                	callq  *%rax
  8021c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cb:	79 02                	jns    8021cf <dup+0x11d>
			goto err;
  8021cd:	eb 57                	jmp    802226 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d7:	48 89 c2             	mov    %rax,%rdx
  8021da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e1:	01 00 00 
  8021e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8021ed:	89 c1                	mov    %eax,%ecx
  8021ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f7:	41 89 c8             	mov    %ecx,%r8d
  8021fa:	48 89 d1             	mov    %rdx,%rcx
  8021fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802202:	48 89 c6             	mov    %rax,%rsi
  802205:	bf 00 00 00 00       	mov    $0x0,%edi
  80220a:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax
  802216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221d:	79 02                	jns    802221 <dup+0x16f>
		goto err;
  80221f:	eb 05                	jmp    802226 <dup+0x174>

	return newfdnum;
  802221:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802224:	eb 33                	jmp    802259 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222a:	48 89 c6             	mov    %rax,%rsi
  80222d:	bf 00 00 00 00       	mov    $0x0,%edi
  802232:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  802239:	00 00 00 
  80223c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80223e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802242:	48 89 c6             	mov    %rax,%rsi
  802245:	bf 00 00 00 00       	mov    $0x0,%edi
  80224a:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  802251:	00 00 00 
  802254:	ff d0                	callq  *%rax
	return r;
  802256:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802259:	c9                   	leaveq 
  80225a:	c3                   	retq   

000000000080225b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80225b:	55                   	push   %rbp
  80225c:	48 89 e5             	mov    %rsp,%rbp
  80225f:	48 83 ec 40          	sub    $0x40,%rsp
  802263:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802266:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80226a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80226e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802272:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802275:	48 89 d6             	mov    %rdx,%rsi
  802278:	89 c7                	mov    %eax,%edi
  80227a:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
  802286:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228d:	78 24                	js     8022b3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80228f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802293:	8b 00                	mov    (%rax),%eax
  802295:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802299:	48 89 d6             	mov    %rdx,%rsi
  80229c:	89 c7                	mov    %eax,%edi
  80229e:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
  8022aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b1:	79 05                	jns    8022b8 <read+0x5d>
		return r;
  8022b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b6:	eb 76                	jmp    80232e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bc:	8b 40 08             	mov    0x8(%rax),%eax
  8022bf:	83 e0 03             	and    $0x3,%eax
  8022c2:	83 f8 01             	cmp    $0x1,%eax
  8022c5:	75 3a                	jne    802301 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8022ce:	00 00 00 
  8022d1:	48 8b 00             	mov    (%rax),%rax
  8022d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022da:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022dd:	89 c6                	mov    %eax,%esi
  8022df:	48 bf 77 4c 80 00 00 	movabs $0x804c77,%rdi
  8022e6:	00 00 00 
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ee:	48 b9 26 05 80 00 00 	movabs $0x800526,%rcx
  8022f5:	00 00 00 
  8022f8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ff:	eb 2d                	jmp    80232e <read+0xd3>
	}
	if (!dev->dev_read)
  802301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802305:	48 8b 40 10          	mov    0x10(%rax),%rax
  802309:	48 85 c0             	test   %rax,%rax
  80230c:	75 07                	jne    802315 <read+0xba>
		return -E_NOT_SUPP;
  80230e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802313:	eb 19                	jmp    80232e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802319:	48 8b 40 10          	mov    0x10(%rax),%rax
  80231d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802321:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802325:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802329:	48 89 cf             	mov    %rcx,%rdi
  80232c:	ff d0                	callq  *%rax
}
  80232e:	c9                   	leaveq 
  80232f:	c3                   	retq   

0000000000802330 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802330:	55                   	push   %rbp
  802331:	48 89 e5             	mov    %rsp,%rbp
  802334:	48 83 ec 30          	sub    $0x30,%rsp
  802338:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80233b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80233f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802343:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80234a:	eb 49                	jmp    802395 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	48 98                	cltq   
  802351:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802355:	48 29 c2             	sub    %rax,%rdx
  802358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235b:	48 63 c8             	movslq %eax,%rcx
  80235e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802362:	48 01 c1             	add    %rax,%rcx
  802365:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802368:	48 89 ce             	mov    %rcx,%rsi
  80236b:	89 c7                	mov    %eax,%edi
  80236d:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  802374:	00 00 00 
  802377:	ff d0                	callq  *%rax
  802379:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80237c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802380:	79 05                	jns    802387 <readn+0x57>
			return m;
  802382:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802385:	eb 1c                	jmp    8023a3 <readn+0x73>
		if (m == 0)
  802387:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238b:	75 02                	jne    80238f <readn+0x5f>
			break;
  80238d:	eb 11                	jmp    8023a0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80238f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802392:	01 45 fc             	add    %eax,-0x4(%rbp)
  802395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802398:	48 98                	cltq   
  80239a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80239e:	72 ac                	jb     80234c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a3:	c9                   	leaveq 
  8023a4:	c3                   	retq   

00000000008023a5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023a5:	55                   	push   %rbp
  8023a6:	48 89 e5             	mov    %rsp,%rbp
  8023a9:	48 83 ec 40          	sub    $0x40,%rsp
  8023ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023bf:	48 89 d6             	mov    %rdx,%rsi
  8023c2:	89 c7                	mov    %eax,%edi
  8023c4:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  8023cb:	00 00 00 
  8023ce:	ff d0                	callq  *%rax
  8023d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d7:	78 24                	js     8023fd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	8b 00                	mov    (%rax),%eax
  8023df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e3:	48 89 d6             	mov    %rdx,%rsi
  8023e6:	89 c7                	mov    %eax,%edi
  8023e8:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  8023ef:	00 00 00 
  8023f2:	ff d0                	callq  *%rax
  8023f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fb:	79 05                	jns    802402 <write+0x5d>
		return r;
  8023fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802400:	eb 75                	jmp    802477 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802406:	8b 40 08             	mov    0x8(%rax),%eax
  802409:	83 e0 03             	and    $0x3,%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	75 3a                	jne    80244a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802410:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802417:	00 00 00 
  80241a:	48 8b 00             	mov    (%rax),%rax
  80241d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802423:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802426:	89 c6                	mov    %eax,%esi
  802428:	48 bf 93 4c 80 00 00 	movabs $0x804c93,%rdi
  80242f:	00 00 00 
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
  802437:	48 b9 26 05 80 00 00 	movabs $0x800526,%rcx
  80243e:	00 00 00 
  802441:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802443:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802448:	eb 2d                	jmp    802477 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80244a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802452:	48 85 c0             	test   %rax,%rax
  802455:	75 07                	jne    80245e <write+0xb9>
		return -E_NOT_SUPP;
  802457:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245c:	eb 19                	jmp    802477 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80245e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802462:	48 8b 40 18          	mov    0x18(%rax),%rax
  802466:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80246a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80246e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802472:	48 89 cf             	mov    %rcx,%rdi
  802475:	ff d0                	callq  *%rax
}
  802477:	c9                   	leaveq 
  802478:	c3                   	retq   

0000000000802479 <seek>:

int
seek(int fdnum, off_t offset)
{
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	48 83 ec 18          	sub    $0x18,%rsp
  802481:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802484:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802487:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248e:	48 89 d6             	mov    %rdx,%rsi
  802491:	89 c7                	mov    %eax,%edi
  802493:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  80249a:	00 00 00 
  80249d:	ff d0                	callq  *%rax
  80249f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a6:	79 05                	jns    8024ad <seek+0x34>
		return r;
  8024a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ab:	eb 0f                	jmp    8024bc <seek+0x43>
	fd->fd_offset = offset;
  8024ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024b4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bc:	c9                   	leaveq 
  8024bd:	c3                   	retq   

00000000008024be <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024be:	55                   	push   %rbp
  8024bf:	48 89 e5             	mov    %rsp,%rbp
  8024c2:	48 83 ec 30          	sub    $0x30,%rsp
  8024c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d3:	48 89 d6             	mov    %rdx,%rsi
  8024d6:	89 c7                	mov    %eax,%edi
  8024d8:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  8024df:	00 00 00 
  8024e2:	ff d0                	callq  *%rax
  8024e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024eb:	78 24                	js     802511 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f1:	8b 00                	mov    (%rax),%eax
  8024f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	79 05                	jns    802516 <ftruncate+0x58>
		return r;
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	eb 72                	jmp    802588 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251a:	8b 40 08             	mov    0x8(%rax),%eax
  80251d:	83 e0 03             	and    $0x3,%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	75 3a                	jne    80255e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802524:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80252b:	00 00 00 
  80252e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802531:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802537:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80253a:	89 c6                	mov    %eax,%esi
  80253c:	48 bf b0 4c 80 00 00 	movabs $0x804cb0,%rdi
  802543:	00 00 00 
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	48 b9 26 05 80 00 00 	movabs $0x800526,%rcx
  802552:	00 00 00 
  802555:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255c:	eb 2a                	jmp    802588 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80255e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802562:	48 8b 40 30          	mov    0x30(%rax),%rax
  802566:	48 85 c0             	test   %rax,%rax
  802569:	75 07                	jne    802572 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80256b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802570:	eb 16                	jmp    802588 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802576:	48 8b 40 30          	mov    0x30(%rax),%rax
  80257a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80257e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802581:	89 ce                	mov    %ecx,%esi
  802583:	48 89 d7             	mov    %rdx,%rdi
  802586:	ff d0                	callq  *%rax
}
  802588:	c9                   	leaveq 
  802589:	c3                   	retq   

000000000080258a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	48 83 ec 30          	sub    $0x30,%rsp
  802592:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802595:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802599:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80259d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a0:	48 89 d6             	mov    %rdx,%rsi
  8025a3:	89 c7                	mov    %eax,%edi
  8025a5:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b8:	78 24                	js     8025de <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025be:	8b 00                	mov    (%rax),%eax
  8025c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c4:	48 89 d6             	mov    %rdx,%rsi
  8025c7:	89 c7                	mov    %eax,%edi
  8025c9:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax
  8025d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dc:	79 05                	jns    8025e3 <fstat+0x59>
		return r;
  8025de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e1:	eb 5e                	jmp    802641 <fstat+0xb7>
	if (!dev->dev_stat)
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025eb:	48 85 c0             	test   %rax,%rax
  8025ee:	75 07                	jne    8025f7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f5:	eb 4a                	jmp    802641 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802602:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802609:	00 00 00 
	stat->st_isdir = 0;
  80260c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802610:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802617:	00 00 00 
	stat->st_dev = dev;
  80261a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80261e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802622:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802631:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802635:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802639:	48 89 ce             	mov    %rcx,%rsi
  80263c:	48 89 d7             	mov    %rdx,%rdi
  80263f:	ff d0                	callq  *%rax
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 20          	sub    $0x20,%rsp
  80264b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802657:	be 00 00 00 00       	mov    $0x0,%esi
  80265c:	48 89 c7             	mov    %rax,%rdi
  80265f:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802666:	00 00 00 
  802669:	ff d0                	callq  *%rax
  80266b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802672:	79 05                	jns    802679 <stat+0x36>
		return fd;
  802674:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802677:	eb 2f                	jmp    8026a8 <stat+0x65>
	r = fstat(fd, stat);
  802679:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80267d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802680:	48 89 d6             	mov    %rdx,%rsi
  802683:	89 c7                	mov    %eax,%edi
  802685:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802694:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802697:	89 c7                	mov    %eax,%edi
  802699:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8026a0:	00 00 00 
  8026a3:	ff d0                	callq  *%rax
	return r;
  8026a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 10          	sub    $0x10,%rsp
  8026b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026b9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026c0:	00 00 00 
  8026c3:	8b 00                	mov    (%rax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	75 1d                	jne    8026e6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ce:	48 b8 4b 40 80 00 00 	movabs $0x80404b,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
  8026da:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026e1:	00 00 00 
  8026e4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026e6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ed:	00 00 00 
  8026f0:	8b 00                	mov    (%rax),%eax
  8026f2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026f5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026fa:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802701:	00 00 00 
  802704:	89 c7                	mov    %eax,%edi
  802706:	48 b8 e9 3f 80 00 00 	movabs $0x803fe9,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802716:	ba 00 00 00 00       	mov    $0x0,%edx
  80271b:	48 89 c6             	mov    %rax,%rsi
  80271e:	bf 00 00 00 00       	mov    $0x0,%edi
  802723:	48 b8 e3 3e 80 00 00 	movabs $0x803ee3,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
}
  80272f:	c9                   	leaveq 
  802730:	c3                   	retq   

0000000000802731 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 83 ec 30          	sub    $0x30,%rsp
  802739:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80273d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802740:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802747:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80274e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802755:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80275a:	75 08                	jne    802764 <open+0x33>
	{
		return r;
  80275c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275f:	e9 f2 00 00 00       	jmpq   802856 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802768:	48 89 c7             	mov    %rax,%rdi
  80276b:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80277a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802781:	7e 0a                	jle    80278d <open+0x5c>
	{
		return -E_BAD_PATH;
  802783:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802788:	e9 c9 00 00 00       	jmpq   802856 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80278d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802794:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802795:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802799:	48 89 c7             	mov    %rax,%rdi
  80279c:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027af:	78 09                	js     8027ba <open+0x89>
  8027b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b5:	48 85 c0             	test   %rax,%rax
  8027b8:	75 08                	jne    8027c2 <open+0x91>
		{
			return r;
  8027ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bd:	e9 94 00 00 00       	jmpq   802856 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c6:	ba 00 04 00 00       	mov    $0x400,%edx
  8027cb:	48 89 c6             	mov    %rax,%rsi
  8027ce:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027d5:	00 00 00 
  8027d8:	48 b8 6d 11 80 00 00 	movabs $0x80116d,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8027e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027eb:	00 00 00 
  8027ee:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027f1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fb:	48 89 c6             	mov    %rax,%rsi
  8027fe:	bf 01 00 00 00       	mov    $0x1,%edi
  802803:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
  80280f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802812:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802816:	79 2b                	jns    802843 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281c:	be 00 00 00 00       	mov    $0x0,%esi
  802821:	48 89 c7             	mov    %rax,%rdi
  802824:	48 b8 b9 1e 80 00 00 	movabs $0x801eb9,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802833:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802837:	79 05                	jns    80283e <open+0x10d>
			{
				return d;
  802839:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80283c:	eb 18                	jmp    802856 <open+0x125>
			}
			return r;
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	eb 13                	jmp    802856 <open+0x125>
		}	
		return fd2num(fd_store);
  802843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802847:	48 89 c7             	mov    %rax,%rdi
  80284a:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802856:	c9                   	leaveq 
  802857:	c3                   	retq   

0000000000802858 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802858:	55                   	push   %rbp
  802859:	48 89 e5             	mov    %rsp,%rbp
  80285c:	48 83 ec 10          	sub    $0x10,%rsp
  802860:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802868:	8b 50 0c             	mov    0xc(%rax),%edx
  80286b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802872:	00 00 00 
  802875:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802877:	be 00 00 00 00       	mov    $0x0,%esi
  80287c:	bf 06 00 00 00       	mov    $0x6,%edi
  802881:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802888:	00 00 00 
  80288b:	ff d0                	callq  *%rax
}
  80288d:	c9                   	leaveq 
  80288e:	c3                   	retq   

000000000080288f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80288f:	55                   	push   %rbp
  802890:	48 89 e5             	mov    %rsp,%rbp
  802893:	48 83 ec 30          	sub    $0x30,%rsp
  802897:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80289b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80289f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028af:	74 07                	je     8028b8 <devfile_read+0x29>
  8028b1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028b6:	75 07                	jne    8028bf <devfile_read+0x30>
		return -E_INVAL;
  8028b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028bd:	eb 77                	jmp    802936 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028cd:	00 00 00 
  8028d0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028d9:	00 00 00 
  8028dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8028e4:	be 00 00 00 00       	mov    $0x0,%esi
  8028e9:	bf 03 00 00 00       	mov    $0x3,%edi
  8028ee:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802901:	7f 05                	jg     802908 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	eb 2e                	jmp    802936 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802908:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290b:	48 63 d0             	movslq %eax,%rdx
  80290e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802912:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802919:	00 00 00 
  80291c:	48 89 c7             	mov    %rax,%rdi
  80291f:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  802926:	00 00 00 
  802929:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80292b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802933:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802936:	c9                   	leaveq 
  802937:	c3                   	retq   

0000000000802938 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	48 83 ec 30          	sub    $0x30,%rsp
  802940:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802944:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802948:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80294c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802953:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802958:	74 07                	je     802961 <devfile_write+0x29>
  80295a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80295f:	75 08                	jne    802969 <devfile_write+0x31>
		return r;
  802961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802964:	e9 9a 00 00 00       	jmpq   802a03 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296d:	8b 50 0c             	mov    0xc(%rax),%edx
  802970:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802977:	00 00 00 
  80297a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80297c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802983:	00 
  802984:	76 08                	jbe    80298e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802986:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80298d:	00 
	}
	fsipcbuf.write.req_n = n;
  80298e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802995:	00 00 00 
  802998:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80299c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a8:	48 89 c6             	mov    %rax,%rsi
  8029ab:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029b2:	00 00 00 
  8029b5:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029c1:	be 00 00 00 00       	mov    $0x0,%esi
  8029c6:	bf 04 00 00 00       	mov    $0x4,%edi
  8029cb:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  8029d2:	00 00 00 
  8029d5:	ff d0                	callq  *%rax
  8029d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029de:	7f 20                	jg     802a00 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8029e0:	48 bf d6 4c 80 00 00 	movabs $0x804cd6,%rdi
  8029e7:	00 00 00 
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ef:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  8029f6:	00 00 00 
  8029f9:	ff d2                	callq  *%rdx
		return r;
  8029fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fe:	eb 03                	jmp    802a03 <devfile_write+0xcb>
	}
	return r;
  802a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a03:	c9                   	leaveq 
  802a04:	c3                   	retq   

0000000000802a05 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a05:	55                   	push   %rbp
  802a06:	48 89 e5             	mov    %rsp,%rbp
  802a09:	48 83 ec 20          	sub    $0x20,%rsp
  802a0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a19:	8b 50 0c             	mov    0xc(%rax),%edx
  802a1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a23:	00 00 00 
  802a26:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a28:	be 00 00 00 00       	mov    $0x0,%esi
  802a2d:	bf 05 00 00 00       	mov    $0x5,%edi
  802a32:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax
  802a3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a45:	79 05                	jns    802a4c <devfile_stat+0x47>
		return r;
  802a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4a:	eb 56                	jmp    802aa2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a50:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a57:	00 00 00 
  802a5a:	48 89 c7             	mov    %rax,%rdi
  802a5d:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a69:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a70:	00 00 00 
  802a73:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a83:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a8a:	00 00 00 
  802a8d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a97:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa2:	c9                   	leaveq 
  802aa3:	c3                   	retq   

0000000000802aa4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802aa4:	55                   	push   %rbp
  802aa5:	48 89 e5             	mov    %rsp,%rbp
  802aa8:	48 83 ec 10          	sub    $0x10,%rsp
  802aac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ab0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab7:	8b 50 0c             	mov    0xc(%rax),%edx
  802aba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac1:	00 00 00 
  802ac4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ac6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acd:	00 00 00 
  802ad0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ad3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ad6:	be 00 00 00 00       	mov    $0x0,%esi
  802adb:	bf 02 00 00 00       	mov    $0x2,%edi
  802ae0:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
}
  802aec:	c9                   	leaveq 
  802aed:	c3                   	retq   

0000000000802aee <remove>:

// Delete a file
int
remove(const char *path)
{
  802aee:	55                   	push   %rbp
  802aef:	48 89 e5             	mov    %rsp,%rbp
  802af2:	48 83 ec 10          	sub    $0x10,%rsp
  802af6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afe:	48 89 c7             	mov    %rax,%rdi
  802b01:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b12:	7e 07                	jle    802b1b <remove+0x2d>
		return -E_BAD_PATH;
  802b14:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b19:	eb 33                	jmp    802b4e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1f:	48 89 c6             	mov    %rax,%rsi
  802b22:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b29:	00 00 00 
  802b2c:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b38:	be 00 00 00 00       	mov    $0x0,%esi
  802b3d:	bf 07 00 00 00       	mov    $0x7,%edi
  802b42:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	callq  *%rax
}
  802b4e:	c9                   	leaveq 
  802b4f:	c3                   	retq   

0000000000802b50 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b54:	be 00 00 00 00       	mov    $0x0,%esi
  802b59:	bf 08 00 00 00       	mov    $0x8,%edi
  802b5e:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
}
  802b6a:	5d                   	pop    %rbp
  802b6b:	c3                   	retq   

0000000000802b6c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b6c:	55                   	push   %rbp
  802b6d:	48 89 e5             	mov    %rsp,%rbp
  802b70:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b77:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b7e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b85:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b8c:	be 00 00 00 00       	mov    $0x0,%esi
  802b91:	48 89 c7             	mov    %rax,%rdi
  802b94:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba7:	79 28                	jns    802bd1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bac:	89 c6                	mov    %eax,%esi
  802bae:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  802bb5:	00 00 00 
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbd:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  802bc4:	00 00 00 
  802bc7:	ff d2                	callq  *%rdx
		return fd_src;
  802bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcc:	e9 74 01 00 00       	jmpq   802d45 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bd1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bd8:	be 01 01 00 00       	mov    $0x101,%esi
  802bdd:	48 89 c7             	mov    %rax,%rdi
  802be0:	48 b8 31 27 80 00 00 	movabs $0x802731,%rax
  802be7:	00 00 00 
  802bea:	ff d0                	callq  *%rax
  802bec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bef:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf3:	79 39                	jns    802c2e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bf5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf8:	89 c6                	mov    %eax,%esi
  802bfa:	48 bf 08 4d 80 00 00 	movabs $0x804d08,%rdi
  802c01:	00 00 00 
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  802c10:	00 00 00 
  802c13:	ff d2                	callq  *%rdx
		close(fd_src);
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	89 c7                	mov    %eax,%edi
  802c1a:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
		return fd_dest;
  802c26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c29:	e9 17 01 00 00       	jmpq   802d45 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c2e:	eb 74                	jmp    802ca4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c30:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c33:	48 63 d0             	movslq %eax,%rdx
  802c36:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c40:	48 89 ce             	mov    %rcx,%rsi
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c58:	79 4a                	jns    802ca4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c5a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c5d:	89 c6                	mov    %eax,%esi
  802c5f:	48 bf 22 4d 80 00 00 	movabs $0x804d22,%rdi
  802c66:	00 00 00 
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  802c75:	00 00 00 
  802c78:	ff d2                	callq  *%rdx
			close(fd_src);
  802c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
			close(fd_dest);
  802c8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8e:	89 c7                	mov    %eax,%edi
  802c90:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
			return write_size;
  802c9c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c9f:	e9 a1 00 00 00       	jmpq   802d45 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ca4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cae:	ba 00 02 00 00       	mov    $0x200,%edx
  802cb3:	48 89 ce             	mov    %rcx,%rsi
  802cb6:	89 c7                	mov    %eax,%edi
  802cb8:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  802cbf:	00 00 00 
  802cc2:	ff d0                	callq  *%rax
  802cc4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ccb:	0f 8f 5f ff ff ff    	jg     802c30 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cd5:	79 47                	jns    802d1e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cd7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cda:	89 c6                	mov    %eax,%esi
  802cdc:	48 bf 35 4d 80 00 00 	movabs $0x804d35,%rdi
  802ce3:	00 00 00 
  802ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ceb:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  802cf2:	00 00 00 
  802cf5:	ff d2                	callq  *%rdx
		close(fd_src);
  802cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfa:	89 c7                	mov    %eax,%edi
  802cfc:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802d03:	00 00 00 
  802d06:	ff d0                	callq  *%rax
		close(fd_dest);
  802d08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0b:	89 c7                	mov    %eax,%edi
  802d0d:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
		return read_size;
  802d19:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d1c:	eb 27                	jmp    802d45 <copy+0x1d9>
	}
	close(fd_src);
  802d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d21:	89 c7                	mov    %eax,%edi
  802d23:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax
	close(fd_dest);
  802d2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d32:	89 c7                	mov    %eax,%edi
  802d34:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802d3b:	00 00 00 
  802d3e:	ff d0                	callq  *%rax
	return 0;
  802d40:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d45:	c9                   	leaveq 
  802d46:	c3                   	retq   

0000000000802d47 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d47:	55                   	push   %rbp
  802d48:	48 89 e5             	mov    %rsp,%rbp
  802d4b:	48 83 ec 20          	sub    $0x20,%rsp
  802d4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d52:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d59:	48 89 d6             	mov    %rdx,%rsi
  802d5c:	89 c7                	mov    %eax,%edi
  802d5e:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	callq  *%rax
  802d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d71:	79 05                	jns    802d78 <fd2sockid+0x31>
		return r;
  802d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d76:	eb 24                	jmp    802d9c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7c:	8b 10                	mov    (%rax),%edx
  802d7e:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d85:	00 00 00 
  802d88:	8b 00                	mov    (%rax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	74 07                	je     802d95 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d93:	eb 07                	jmp    802d9c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d99:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d9c:	c9                   	leaveq 
  802d9d:	c3                   	retq   

0000000000802d9e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d9e:	55                   	push   %rbp
  802d9f:	48 89 e5             	mov    %rsp,%rbp
  802da2:	48 83 ec 20          	sub    $0x20,%rsp
  802da6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802da9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dad:	48 89 c7             	mov    %rax,%rdi
  802db0:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
  802dbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc3:	78 26                	js     802deb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc9:	ba 07 04 00 00       	mov    $0x407,%edx
  802dce:	48 89 c6             	mov    %rax,%rsi
  802dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  802dd6:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de9:	79 16                	jns    802e01 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802deb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dee:	89 c7                	mov    %eax,%edi
  802df0:	48 b8 ab 32 80 00 00 	movabs $0x8032ab,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
		return r;
  802dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dff:	eb 3a                	jmp    802e3b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e05:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e0c:	00 00 00 
  802e0f:	8b 12                	mov    (%rdx),%edx
  802e11:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e17:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e22:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e25:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2c:	48 89 c7             	mov    %rax,%rdi
  802e2f:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	48 83 ec 30          	sub    $0x30,%rsp
  802e45:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e53:	89 c7                	mov    %eax,%edi
  802e55:	48 b8 47 2d 80 00 00 	movabs $0x802d47,%rax
  802e5c:	00 00 00 
  802e5f:	ff d0                	callq  *%rax
  802e61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e68:	79 05                	jns    802e6f <accept+0x32>
		return r;
  802e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6d:	eb 3b                	jmp    802eaa <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e6f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e73:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7a:	48 89 ce             	mov    %rcx,%rsi
  802e7d:	89 c7                	mov    %eax,%edi
  802e7f:	48 b8 88 31 80 00 00 	movabs $0x803188,%rax
  802e86:	00 00 00 
  802e89:	ff d0                	callq  *%rax
  802e8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e92:	79 05                	jns    802e99 <accept+0x5c>
		return r;
  802e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e97:	eb 11                	jmp    802eaa <accept+0x6d>
	return alloc_sockfd(r);
  802e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9c:	89 c7                	mov    %eax,%edi
  802e9e:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
}
  802eaa:	c9                   	leaveq 
  802eab:	c3                   	retq   

0000000000802eac <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802eac:	55                   	push   %rbp
  802ead:	48 89 e5             	mov    %rsp,%rbp
  802eb0:	48 83 ec 20          	sub    $0x20,%rsp
  802eb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ebb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ebe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec1:	89 c7                	mov    %eax,%edi
  802ec3:	48 b8 47 2d 80 00 00 	movabs $0x802d47,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
  802ecf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed6:	79 05                	jns    802edd <bind+0x31>
		return r;
  802ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edb:	eb 1b                	jmp    802ef8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802edd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ee0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee7:	48 89 ce             	mov    %rcx,%rsi
  802eea:	89 c7                	mov    %eax,%edi
  802eec:	48 b8 07 32 80 00 00 	movabs $0x803207,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <shutdown>:

int
shutdown(int s, int how)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	48 83 ec 20          	sub    $0x20,%rsp
  802f02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f05:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0b:	89 c7                	mov    %eax,%edi
  802f0d:	48 b8 47 2d 80 00 00 	movabs $0x802d47,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f20:	79 05                	jns    802f27 <shutdown+0x2d>
		return r;
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	eb 16                	jmp    802f3d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f27:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2d:	89 d6                	mov    %edx,%esi
  802f2f:	89 c7                	mov    %eax,%edi
  802f31:	48 b8 6b 32 80 00 00 	movabs $0x80326b,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
}
  802f3d:	c9                   	leaveq 
  802f3e:	c3                   	retq   

0000000000802f3f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f3f:	55                   	push   %rbp
  802f40:	48 89 e5             	mov    %rsp,%rbp
  802f43:	48 83 ec 10          	sub    $0x10,%rsp
  802f47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4f:	48 89 c7             	mov    %rax,%rdi
  802f52:	48 b8 cd 40 80 00 00 	movabs $0x8040cd,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
  802f5e:	83 f8 01             	cmp    $0x1,%eax
  802f61:	75 17                	jne    802f7a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f67:	8b 40 0c             	mov    0xc(%rax),%eax
  802f6a:	89 c7                	mov    %eax,%edi
  802f6c:	48 b8 ab 32 80 00 00 	movabs $0x8032ab,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	callq  *%rax
  802f78:	eb 05                	jmp    802f7f <devsock_close+0x40>
	else
		return 0;
  802f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f7f:	c9                   	leaveq 
  802f80:	c3                   	retq   

0000000000802f81 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f81:	55                   	push   %rbp
  802f82:	48 89 e5             	mov    %rsp,%rbp
  802f85:	48 83 ec 20          	sub    $0x20,%rsp
  802f89:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f90:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f96:	89 c7                	mov    %eax,%edi
  802f98:	48 b8 47 2d 80 00 00 	movabs $0x802d47,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
  802fa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fab:	79 05                	jns    802fb2 <connect+0x31>
		return r;
  802fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb0:	eb 1b                	jmp    802fcd <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fb2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fb5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbc:	48 89 ce             	mov    %rcx,%rsi
  802fbf:	89 c7                	mov    %eax,%edi
  802fc1:	48 b8 d8 32 80 00 00 	movabs $0x8032d8,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
}
  802fcd:	c9                   	leaveq 
  802fce:	c3                   	retq   

0000000000802fcf <listen>:

int
listen(int s, int backlog)
{
  802fcf:	55                   	push   %rbp
  802fd0:	48 89 e5             	mov    %rsp,%rbp
  802fd3:	48 83 ec 20          	sub    $0x20,%rsp
  802fd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fda:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe0:	89 c7                	mov    %eax,%edi
  802fe2:	48 b8 47 2d 80 00 00 	movabs $0x802d47,%rax
  802fe9:	00 00 00 
  802fec:	ff d0                	callq  *%rax
  802fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff5:	79 05                	jns    802ffc <listen+0x2d>
		return r;
  802ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffa:	eb 16                	jmp    803012 <listen+0x43>
	return nsipc_listen(r, backlog);
  802ffc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803002:	89 d6                	mov    %edx,%esi
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 3c 33 80 00 00 	movabs $0x80333c,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
}
  803012:	c9                   	leaveq 
  803013:	c3                   	retq   

0000000000803014 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803014:	55                   	push   %rbp
  803015:	48 89 e5             	mov    %rsp,%rbp
  803018:	48 83 ec 20          	sub    $0x20,%rsp
  80301c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803020:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803024:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302c:	89 c2                	mov    %eax,%edx
  80302e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803032:	8b 40 0c             	mov    0xc(%rax),%eax
  803035:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803039:	b9 00 00 00 00       	mov    $0x0,%ecx
  80303e:	89 c7                	mov    %eax,%edi
  803040:	48 b8 7c 33 80 00 00 	movabs $0x80337c,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
}
  80304c:	c9                   	leaveq 
  80304d:	c3                   	retq   

000000000080304e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80304e:	55                   	push   %rbp
  80304f:	48 89 e5             	mov    %rsp,%rbp
  803052:	48 83 ec 20          	sub    $0x20,%rsp
  803056:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80305e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803066:	89 c2                	mov    %eax,%edx
  803068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306c:	8b 40 0c             	mov    0xc(%rax),%eax
  80306f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803073:	b9 00 00 00 00       	mov    $0x0,%ecx
  803078:	89 c7                	mov    %eax,%edi
  80307a:	48 b8 48 34 80 00 00 	movabs $0x803448,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
  80308c:	48 83 ec 10          	sub    $0x10,%rsp
  803090:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803094:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 be 50 4d 80 00 00 	movabs $0x804d50,%rsi
  8030a3:	00 00 00 
  8030a6:	48 89 c7             	mov    %rax,%rdi
  8030a9:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
	return 0;
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <socket>:

int
socket(int domain, int type, int protocol)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 20          	sub    $0x20,%rsp
  8030c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030ca:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030cd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030d0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d6:	89 ce                	mov    %ecx,%esi
  8030d8:	89 c7                	mov    %eax,%edi
  8030da:	48 b8 00 35 80 00 00 	movabs $0x803500,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ed:	79 05                	jns    8030f4 <socket+0x38>
		return r;
  8030ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f2:	eb 11                	jmp    803105 <socket+0x49>
	return alloc_sockfd(r);
  8030f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 9e 2d 80 00 00 	movabs $0x802d9e,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
}
  803105:	c9                   	leaveq 
  803106:	c3                   	retq   

0000000000803107 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803107:	55                   	push   %rbp
  803108:	48 89 e5             	mov    %rsp,%rbp
  80310b:	48 83 ec 10          	sub    $0x10,%rsp
  80310f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803112:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803119:	00 00 00 
  80311c:	8b 00                	mov    (%rax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	75 1d                	jne    80313f <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803122:	bf 02 00 00 00       	mov    $0x2,%edi
  803127:	48 b8 4b 40 80 00 00 	movabs $0x80404b,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
  803133:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80313a:	00 00 00 
  80313d:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80313f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803146:	00 00 00 
  803149:	8b 00                	mov    (%rax),%eax
  80314b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80314e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803153:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80315a:	00 00 00 
  80315d:	89 c7                	mov    %eax,%edi
  80315f:	48 b8 e9 3f 80 00 00 	movabs $0x803fe9,%rax
  803166:	00 00 00 
  803169:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80316b:	ba 00 00 00 00       	mov    $0x0,%edx
  803170:	be 00 00 00 00       	mov    $0x0,%esi
  803175:	bf 00 00 00 00       	mov    $0x0,%edi
  80317a:	48 b8 e3 3e 80 00 00 	movabs $0x803ee3,%rax
  803181:	00 00 00 
  803184:	ff d0                	callq  *%rax
}
  803186:	c9                   	leaveq 
  803187:	c3                   	retq   

0000000000803188 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803188:	55                   	push   %rbp
  803189:	48 89 e5             	mov    %rsp,%rbp
  80318c:	48 83 ec 30          	sub    $0x30,%rsp
  803190:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803193:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803197:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80319b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031a2:	00 00 00 
  8031a5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031a8:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8031af:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	78 3e                	js     803202 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031cb:	00 00 00 
  8031ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8031d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d6:	8b 40 10             	mov    0x10(%rax),%eax
  8031d9:	89 c2                	mov    %eax,%edx
  8031db:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e3:	48 89 ce             	mov    %rcx,%rsi
  8031e6:	48 89 c7             	mov    %rax,%rdi
  8031e9:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f9:	8b 50 10             	mov    0x10(%rax),%edx
  8031fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803200:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803205:	c9                   	leaveq 
  803206:	c3                   	retq   

0000000000803207 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803207:	55                   	push   %rbp
  803208:	48 89 e5             	mov    %rsp,%rbp
  80320b:	48 83 ec 10          	sub    $0x10,%rsp
  80320f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803216:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803219:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803220:	00 00 00 
  803223:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803226:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803228:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80322b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322f:	48 89 c6             	mov    %rax,%rsi
  803232:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803239:	00 00 00 
  80323c:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  803243:	00 00 00 
  803246:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803248:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80324f:	00 00 00 
  803252:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803255:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803258:	bf 02 00 00 00       	mov    $0x2,%edi
  80325d:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
}
  803269:	c9                   	leaveq 
  80326a:	c3                   	retq   

000000000080326b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80326b:	55                   	push   %rbp
  80326c:	48 89 e5             	mov    %rsp,%rbp
  80326f:	48 83 ec 10          	sub    $0x10,%rsp
  803273:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803276:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803279:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803280:	00 00 00 
  803283:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803286:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803288:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328f:	00 00 00 
  803292:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803295:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803298:	bf 03 00 00 00       	mov    $0x3,%edi
  80329d:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
}
  8032a9:	c9                   	leaveq 
  8032aa:	c3                   	retq   

00000000008032ab <nsipc_close>:

int
nsipc_close(int s)
{
  8032ab:	55                   	push   %rbp
  8032ac:	48 89 e5             	mov    %rsp,%rbp
  8032af:	48 83 ec 10          	sub    $0x10,%rsp
  8032b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bd:	00 00 00 
  8032c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c3:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032c5:	bf 04 00 00 00       	mov    $0x4,%edi
  8032ca:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
}
  8032d6:	c9                   	leaveq 
  8032d7:	c3                   	retq   

00000000008032d8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032d8:	55                   	push   %rbp
  8032d9:	48 89 e5             	mov    %rsp,%rbp
  8032dc:	48 83 ec 10          	sub    $0x10,%rsp
  8032e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032e7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f1:	00 00 00 
  8032f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032f7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032f9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	48 89 c6             	mov    %rax,%rsi
  803303:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80330a:	00 00 00 
  80330d:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803319:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803320:	00 00 00 
  803323:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803326:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803329:	bf 05 00 00 00       	mov    $0x5,%edi
  80332e:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  803335:	00 00 00 
  803338:	ff d0                	callq  *%rax
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 10          	sub    $0x10,%rsp
  803344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803347:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80334a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803351:	00 00 00 
  803354:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803357:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803359:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803360:	00 00 00 
  803363:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803366:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803369:	bf 06 00 00 00       	mov    $0x6,%edi
  80336e:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
}
  80337a:	c9                   	leaveq 
  80337b:	c3                   	retq   

000000000080337c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80337c:	55                   	push   %rbp
  80337d:	48 89 e5             	mov    %rsp,%rbp
  803380:	48 83 ec 30          	sub    $0x30,%rsp
  803384:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338b:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80338e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803391:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803398:	00 00 00 
  80339b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80339e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033a0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a7:	00 00 00 
  8033aa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033ad:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b7:	00 00 00 
  8033ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033bd:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033c0:	bf 07 00 00 00       	mov    $0x7,%edi
  8033c5:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
  8033d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d8:	78 69                	js     803443 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033da:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033e1:	7f 08                	jg     8033eb <nsipc_recv+0x6f>
  8033e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e6:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033e9:	7e 35                	jle    803420 <nsipc_recv+0xa4>
  8033eb:	48 b9 57 4d 80 00 00 	movabs $0x804d57,%rcx
  8033f2:	00 00 00 
  8033f5:	48 ba 6c 4d 80 00 00 	movabs $0x804d6c,%rdx
  8033fc:	00 00 00 
  8033ff:	be 61 00 00 00       	mov    $0x61,%esi
  803404:	48 bf 81 4d 80 00 00 	movabs $0x804d81,%rdi
  80340b:	00 00 00 
  80340e:	b8 00 00 00 00       	mov    $0x0,%eax
  803413:	49 b8 cf 3d 80 00 00 	movabs $0x803dcf,%r8
  80341a:	00 00 00 
  80341d:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803423:	48 63 d0             	movslq %eax,%rdx
  803426:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80342a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803431:	00 00 00 
  803434:	48 89 c7             	mov    %rax,%rdi
  803437:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
	}

	return r;
  803443:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803446:	c9                   	leaveq 
  803447:	c3                   	retq   

0000000000803448 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803448:	55                   	push   %rbp
  803449:	48 89 e5             	mov    %rsp,%rbp
  80344c:	48 83 ec 20          	sub    $0x20,%rsp
  803450:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803453:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803457:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80345a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80345d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803464:	00 00 00 
  803467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80346a:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80346c:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803473:	7e 35                	jle    8034aa <nsipc_send+0x62>
  803475:	48 b9 8d 4d 80 00 00 	movabs $0x804d8d,%rcx
  80347c:	00 00 00 
  80347f:	48 ba 6c 4d 80 00 00 	movabs $0x804d6c,%rdx
  803486:	00 00 00 
  803489:	be 6c 00 00 00       	mov    $0x6c,%esi
  80348e:	48 bf 81 4d 80 00 00 	movabs $0x804d81,%rdi
  803495:	00 00 00 
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
  80349d:	49 b8 cf 3d 80 00 00 	movabs $0x803dcf,%r8
  8034a4:	00 00 00 
  8034a7:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ad:	48 63 d0             	movslq %eax,%rdx
  8034b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b4:	48 89 c6             	mov    %rax,%rsi
  8034b7:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8034be:	00 00 00 
  8034c1:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d4:	00 00 00 
  8034d7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034da:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e4:	00 00 00 
  8034e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ea:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034ed:	bf 08 00 00 00       	mov    $0x8,%edi
  8034f2:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
}
  8034fe:	c9                   	leaveq 
  8034ff:	c3                   	retq   

0000000000803500 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803500:	55                   	push   %rbp
  803501:	48 89 e5             	mov    %rsp,%rbp
  803504:	48 83 ec 10          	sub    $0x10,%rsp
  803508:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80350b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80350e:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803511:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803518:	00 00 00 
  80351b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80351e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803520:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803527:	00 00 00 
  80352a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80352d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803530:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803537:	00 00 00 
  80353a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80353d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803540:	bf 09 00 00 00       	mov    $0x9,%edi
  803545:	48 b8 07 31 80 00 00 	movabs $0x803107,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
}
  803551:	c9                   	leaveq 
  803552:	c3                   	retq   

0000000000803553 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803553:	55                   	push   %rbp
  803554:	48 89 e5             	mov    %rsp,%rbp
  803557:	53                   	push   %rbx
  803558:	48 83 ec 38          	sub    $0x38,%rsp
  80355c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803560:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803564:	48 89 c7             	mov    %rax,%rdi
  803567:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803576:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80357a:	0f 88 bf 01 00 00    	js     80373f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803584:	ba 07 04 00 00       	mov    $0x407,%edx
  803589:	48 89 c6             	mov    %rax,%rsi
  80358c:	bf 00 00 00 00       	mov    $0x0,%edi
  803591:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
  80359d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a4:	0f 88 95 01 00 00    	js     80373f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035aa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035ae:	48 89 c7             	mov    %rax,%rdi
  8035b1:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
  8035bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035c4:	0f 88 5d 01 00 00    	js     803727 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8035d3:	48 89 c6             	mov    %rax,%rsi
  8035d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035db:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
  8035e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ee:	0f 88 33 01 00 00    	js     803727 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f8:	48 89 c7             	mov    %rax,%rdi
  8035fb:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
  803607:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80360b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80360f:	ba 07 04 00 00       	mov    $0x407,%edx
  803614:	48 89 c6             	mov    %rax,%rsi
  803617:	bf 00 00 00 00       	mov    $0x0,%edi
  80361c:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
  803628:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80362b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80362f:	79 05                	jns    803636 <pipe+0xe3>
		goto err2;
  803631:	e9 d9 00 00 00       	jmpq   80370f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803636:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80363a:	48 89 c7             	mov    %rax,%rdi
  80363d:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	48 89 c2             	mov    %rax,%rdx
  80364c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803650:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803656:	48 89 d1             	mov    %rdx,%rcx
  803659:	ba 00 00 00 00       	mov    $0x0,%edx
  80365e:	48 89 c6             	mov    %rax,%rsi
  803661:	bf 00 00 00 00       	mov    $0x0,%edi
  803666:	48 b8 5a 1a 80 00 00 	movabs $0x801a5a,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
  803672:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803675:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803679:	79 1b                	jns    803696 <pipe+0x143>
		goto err3;
  80367b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80367c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803680:	48 89 c6             	mov    %rax,%rsi
  803683:	bf 00 00 00 00       	mov    $0x0,%edi
  803688:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	eb 79                	jmp    80370f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80369a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036a1:	00 00 00 
  8036a4:	8b 12                	mov    (%rdx),%edx
  8036a6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036be:	00 00 00 
  8036c1:	8b 12                	mov    (%rdx),%edx
  8036c3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d4:	48 89 c7             	mov    %rax,%rdi
  8036d7:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
  8036e3:	89 c2                	mov    %eax,%edx
  8036e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036e9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036ef:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f7:	48 89 c7             	mov    %rax,%rdi
  8036fa:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	89 03                	mov    %eax,(%rbx)
	return 0;
  803708:	b8 00 00 00 00       	mov    $0x0,%eax
  80370d:	eb 33                	jmp    803742 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80370f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803713:	48 89 c6             	mov    %rax,%rsi
  803716:	bf 00 00 00 00       	mov    $0x0,%edi
  80371b:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372b:	48 89 c6             	mov    %rax,%rsi
  80372e:	bf 00 00 00 00       	mov    $0x0,%edi
  803733:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
err:
	return r;
  80373f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803742:	48 83 c4 38          	add    $0x38,%rsp
  803746:	5b                   	pop    %rbx
  803747:	5d                   	pop    %rbp
  803748:	c3                   	retq   

0000000000803749 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803749:	55                   	push   %rbp
  80374a:	48 89 e5             	mov    %rsp,%rbp
  80374d:	53                   	push   %rbx
  80374e:	48 83 ec 28          	sub    $0x28,%rsp
  803752:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803756:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80375a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803761:	00 00 00 
  803764:	48 8b 00             	mov    (%rax),%rax
  803767:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80376d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803774:	48 89 c7             	mov    %rax,%rdi
  803777:	48 b8 cd 40 80 00 00 	movabs $0x8040cd,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
  803783:	89 c3                	mov    %eax,%ebx
  803785:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803789:	48 89 c7             	mov    %rax,%rdi
  80378c:	48 b8 cd 40 80 00 00 	movabs $0x8040cd,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	39 c3                	cmp    %eax,%ebx
  80379a:	0f 94 c0             	sete   %al
  80379d:	0f b6 c0             	movzbl %al,%eax
  8037a0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037a3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8037aa:	00 00 00 
  8037ad:	48 8b 00             	mov    (%rax),%rax
  8037b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037b6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037bc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037bf:	75 05                	jne    8037c6 <_pipeisclosed+0x7d>
			return ret;
  8037c1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037c4:	eb 4f                	jmp    803815 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8037c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037cc:	74 42                	je     803810 <_pipeisclosed+0xc7>
  8037ce:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8037d2:	75 3c                	jne    803810 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8037d4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8037db:	00 00 00 
  8037de:	48 8b 00             	mov    (%rax),%rax
  8037e1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037e7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ed:	89 c6                	mov    %eax,%esi
  8037ef:	48 bf 9e 4d 80 00 00 	movabs $0x804d9e,%rdi
  8037f6:	00 00 00 
  8037f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fe:	49 b8 26 05 80 00 00 	movabs $0x800526,%r8
  803805:	00 00 00 
  803808:	41 ff d0             	callq  *%r8
	}
  80380b:	e9 4a ff ff ff       	jmpq   80375a <_pipeisclosed+0x11>
  803810:	e9 45 ff ff ff       	jmpq   80375a <_pipeisclosed+0x11>
}
  803815:	48 83 c4 28          	add    $0x28,%rsp
  803819:	5b                   	pop    %rbx
  80381a:	5d                   	pop    %rbp
  80381b:	c3                   	retq   

000000000080381c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80381c:	55                   	push   %rbp
  80381d:	48 89 e5             	mov    %rsp,%rbp
  803820:	48 83 ec 30          	sub    $0x30,%rsp
  803824:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803827:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80382b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80382e:	48 89 d6             	mov    %rdx,%rsi
  803831:	89 c7                	mov    %eax,%edi
  803833:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
  80383f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803846:	79 05                	jns    80384d <pipeisclosed+0x31>
		return r;
  803848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384b:	eb 31                	jmp    80387e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80384d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803851:	48 89 c7             	mov    %rax,%rdi
  803854:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80386c:	48 89 d6             	mov    %rdx,%rsi
  80386f:	48 89 c7             	mov    %rax,%rdi
  803872:	48 b8 49 37 80 00 00 	movabs $0x803749,%rax
  803879:	00 00 00 
  80387c:	ff d0                	callq  *%rax
}
  80387e:	c9                   	leaveq 
  80387f:	c3                   	retq   

0000000000803880 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803880:	55                   	push   %rbp
  803881:	48 89 e5             	mov    %rsp,%rbp
  803884:	48 83 ec 40          	sub    $0x40,%rsp
  803888:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80388c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803890:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803898:	48 89 c7             	mov    %rax,%rdi
  80389b:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  8038a2:	00 00 00 
  8038a5:	ff d0                	callq  *%rax
  8038a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038b3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038ba:	00 
  8038bb:	e9 92 00 00 00       	jmpq   803952 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8038c0:	eb 41                	jmp    803903 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038c2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038c7:	74 09                	je     8038d2 <devpipe_read+0x52>
				return i;
  8038c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038cd:	e9 92 00 00 00       	jmpq   803964 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038da:	48 89 d6             	mov    %rdx,%rsi
  8038dd:	48 89 c7             	mov    %rax,%rdi
  8038e0:	48 b8 49 37 80 00 00 	movabs $0x803749,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
  8038ec:	85 c0                	test   %eax,%eax
  8038ee:	74 07                	je     8038f7 <devpipe_read+0x77>
				return 0;
  8038f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f5:	eb 6d                	jmp    803964 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038f7:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803907:	8b 10                	mov    (%rax),%edx
  803909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390d:	8b 40 04             	mov    0x4(%rax),%eax
  803910:	39 c2                	cmp    %eax,%edx
  803912:	74 ae                	je     8038c2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80391c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803924:	8b 00                	mov    (%rax),%eax
  803926:	99                   	cltd   
  803927:	c1 ea 1b             	shr    $0x1b,%edx
  80392a:	01 d0                	add    %edx,%eax
  80392c:	83 e0 1f             	and    $0x1f,%eax
  80392f:	29 d0                	sub    %edx,%eax
  803931:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803935:	48 98                	cltq   
  803937:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80393c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80393e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803942:	8b 00                	mov    (%rax),%eax
  803944:	8d 50 01             	lea    0x1(%rax),%edx
  803947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80394d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803952:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803956:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80395a:	0f 82 60 ff ff ff    	jb     8038c0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803964:	c9                   	leaveq 
  803965:	c3                   	retq   

0000000000803966 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803966:	55                   	push   %rbp
  803967:	48 89 e5             	mov    %rsp,%rbp
  80396a:	48 83 ec 40          	sub    $0x40,%rsp
  80396e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803972:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803976:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80397a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397e:	48 89 c7             	mov    %rax,%rdi
  803981:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
  80398d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803991:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803995:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803999:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039a0:	00 
  8039a1:	e9 8e 00 00 00       	jmpq   803a34 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039a6:	eb 31                	jmp    8039d9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b0:	48 89 d6             	mov    %rdx,%rsi
  8039b3:	48 89 c7             	mov    %rax,%rdi
  8039b6:	48 b8 49 37 80 00 00 	movabs $0x803749,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	74 07                	je     8039cd <devpipe_write+0x67>
				return 0;
  8039c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cb:	eb 79                	jmp    803a46 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039cd:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8039d4:	00 00 00 
  8039d7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039dd:	8b 40 04             	mov    0x4(%rax),%eax
  8039e0:	48 63 d0             	movslq %eax,%rdx
  8039e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e7:	8b 00                	mov    (%rax),%eax
  8039e9:	48 98                	cltq   
  8039eb:	48 83 c0 20          	add    $0x20,%rax
  8039ef:	48 39 c2             	cmp    %rax,%rdx
  8039f2:	73 b4                	jae    8039a8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f8:	8b 40 04             	mov    0x4(%rax),%eax
  8039fb:	99                   	cltd   
  8039fc:	c1 ea 1b             	shr    $0x1b,%edx
  8039ff:	01 d0                	add    %edx,%eax
  803a01:	83 e0 1f             	and    $0x1f,%eax
  803a04:	29 d0                	sub    %edx,%eax
  803a06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a0a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a0e:	48 01 ca             	add    %rcx,%rdx
  803a11:	0f b6 0a             	movzbl (%rdx),%ecx
  803a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a18:	48 98                	cltq   
  803a1a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a22:	8b 40 04             	mov    0x4(%rax),%eax
  803a25:	8d 50 01             	lea    0x1(%rax),%edx
  803a28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a2f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a38:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a3c:	0f 82 64 ff ff ff    	jb     8039a6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a46:	c9                   	leaveq 
  803a47:	c3                   	retq   

0000000000803a48 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a48:	55                   	push   %rbp
  803a49:	48 89 e5             	mov    %rsp,%rbp
  803a4c:	48 83 ec 20          	sub    $0x20,%rsp
  803a50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a73:	48 be b1 4d 80 00 00 	movabs $0x804db1,%rsi
  803a7a:	00 00 00 
  803a7d:	48 89 c7             	mov    %rax,%rdi
  803a80:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  803a87:	00 00 00 
  803a8a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a90:	8b 50 04             	mov    0x4(%rax),%edx
  803a93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a97:	8b 00                	mov    (%rax),%eax
  803a99:	29 c2                	sub    %eax,%edx
  803a9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803aa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ab0:	00 00 00 
	stat->st_dev = &devpipe;
  803ab3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab7:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803abe:	00 00 00 
  803ac1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803acd:	c9                   	leaveq 
  803ace:	c3                   	retq   

0000000000803acf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803acf:	55                   	push   %rbp
  803ad0:	48 89 e5             	mov    %rsp,%rbp
  803ad3:	48 83 ec 10          	sub    $0x10,%rsp
  803ad7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803adb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803adf:	48 89 c6             	mov    %rax,%rsi
  803ae2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae7:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  803aee:	00 00 00 
  803af1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af7:	48 89 c7             	mov    %rax,%rdi
  803afa:	48 b8 66 1d 80 00 00 	movabs $0x801d66,%rax
  803b01:	00 00 00 
  803b04:	ff d0                	callq  *%rax
  803b06:	48 89 c6             	mov    %rax,%rsi
  803b09:	bf 00 00 00 00       	mov    $0x0,%edi
  803b0e:	48 b8 b5 1a 80 00 00 	movabs $0x801ab5,%rax
  803b15:	00 00 00 
  803b18:	ff d0                	callq  *%rax
}
  803b1a:	c9                   	leaveq 
  803b1b:	c3                   	retq   

0000000000803b1c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b1c:	55                   	push   %rbp
  803b1d:	48 89 e5             	mov    %rsp,%rbp
  803b20:	48 83 ec 20          	sub    $0x20,%rsp
  803b24:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b2a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b2d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b31:	be 01 00 00 00       	mov    $0x1,%esi
  803b36:	48 89 c7             	mov    %rax,%rdi
  803b39:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
}
  803b45:	c9                   	leaveq 
  803b46:	c3                   	retq   

0000000000803b47 <getchar>:

int
getchar(void)
{
  803b47:	55                   	push   %rbp
  803b48:	48 89 e5             	mov    %rsp,%rbp
  803b4b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b4f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b53:	ba 01 00 00 00       	mov    $0x1,%edx
  803b58:	48 89 c6             	mov    %rax,%rsi
  803b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b60:	48 b8 5b 22 80 00 00 	movabs $0x80225b,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
  803b6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b73:	79 05                	jns    803b7a <getchar+0x33>
		return r;
  803b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b78:	eb 14                	jmp    803b8e <getchar+0x47>
	if (r < 1)
  803b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7e:	7f 07                	jg     803b87 <getchar+0x40>
		return -E_EOF;
  803b80:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b85:	eb 07                	jmp    803b8e <getchar+0x47>
	return c;
  803b87:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b8b:	0f b6 c0             	movzbl %al,%eax
}
  803b8e:	c9                   	leaveq 
  803b8f:	c3                   	retq   

0000000000803b90 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b90:	55                   	push   %rbp
  803b91:	48 89 e5             	mov    %rsp,%rbp
  803b94:	48 83 ec 20          	sub    $0x20,%rsp
  803b98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba2:	48 89 d6             	mov    %rdx,%rsi
  803ba5:	89 c7                	mov    %eax,%edi
  803ba7:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
  803bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bba:	79 05                	jns    803bc1 <iscons+0x31>
		return r;
  803bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbf:	eb 1a                	jmp    803bdb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc5:	8b 10                	mov    (%rax),%edx
  803bc7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803bce:	00 00 00 
  803bd1:	8b 00                	mov    (%rax),%eax
  803bd3:	39 c2                	cmp    %eax,%edx
  803bd5:	0f 94 c0             	sete   %al
  803bd8:	0f b6 c0             	movzbl %al,%eax
}
  803bdb:	c9                   	leaveq 
  803bdc:	c3                   	retq   

0000000000803bdd <opencons>:

int
opencons(void)
{
  803bdd:	55                   	push   %rbp
  803bde:	48 89 e5             	mov    %rsp,%rbp
  803be1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803be5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803be9:	48 89 c7             	mov    %rax,%rdi
  803bec:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803bf3:	00 00 00 
  803bf6:	ff d0                	callq  *%rax
  803bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bff:	79 05                	jns    803c06 <opencons+0x29>
		return r;
  803c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c04:	eb 5b                	jmp    803c61 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0a:	ba 07 04 00 00       	mov    $0x407,%edx
  803c0f:	48 89 c6             	mov    %rax,%rsi
  803c12:	bf 00 00 00 00       	mov    $0x0,%edi
  803c17:	48 b8 0a 1a 80 00 00 	movabs $0x801a0a,%rax
  803c1e:	00 00 00 
  803c21:	ff d0                	callq  *%rax
  803c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2a:	79 05                	jns    803c31 <opencons+0x54>
		return r;
  803c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2f:	eb 30                	jmp    803c61 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c35:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c3c:	00 00 00 
  803c3f:	8b 12                	mov    (%rdx),%edx
  803c41:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c47:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c52:	48 89 c7             	mov    %rax,%rdi
  803c55:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  803c5c:	00 00 00 
  803c5f:	ff d0                	callq  *%rax
}
  803c61:	c9                   	leaveq 
  803c62:	c3                   	retq   

0000000000803c63 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c63:	55                   	push   %rbp
  803c64:	48 89 e5             	mov    %rsp,%rbp
  803c67:	48 83 ec 30          	sub    $0x30,%rsp
  803c6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c73:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c77:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c7c:	75 07                	jne    803c85 <devcons_read+0x22>
		return 0;
  803c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c83:	eb 4b                	jmp    803cd0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c85:	eb 0c                	jmp    803c93 <devcons_read+0x30>
		sys_yield();
  803c87:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803c8e:	00 00 00 
  803c91:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c93:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
  803c9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca6:	74 df                	je     803c87 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cac:	79 05                	jns    803cb3 <devcons_read+0x50>
		return c;
  803cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb1:	eb 1d                	jmp    803cd0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803cb3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803cb7:	75 07                	jne    803cc0 <devcons_read+0x5d>
		return 0;
  803cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbe:	eb 10                	jmp    803cd0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc3:	89 c2                	mov    %eax,%edx
  803cc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc9:	88 10                	mov    %dl,(%rax)
	return 1;
  803ccb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cd0:	c9                   	leaveq 
  803cd1:	c3                   	retq   

0000000000803cd2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803cd2:	55                   	push   %rbp
  803cd3:	48 89 e5             	mov    %rsp,%rbp
  803cd6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803cdd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ce4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ceb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cf9:	eb 76                	jmp    803d71 <devcons_write+0x9f>
		m = n - tot;
  803cfb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d02:	89 c2                	mov    %eax,%edx
  803d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d07:	29 c2                	sub    %eax,%edx
  803d09:	89 d0                	mov    %edx,%eax
  803d0b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d11:	83 f8 7f             	cmp    $0x7f,%eax
  803d14:	76 07                	jbe    803d1d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d16:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d20:	48 63 d0             	movslq %eax,%rdx
  803d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d26:	48 63 c8             	movslq %eax,%rcx
  803d29:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d30:	48 01 c1             	add    %rax,%rcx
  803d33:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d3a:	48 89 ce             	mov    %rcx,%rsi
  803d3d:	48 89 c7             	mov    %rax,%rdi
  803d40:	48 b8 ff 13 80 00 00 	movabs $0x8013ff,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d4f:	48 63 d0             	movslq %eax,%rdx
  803d52:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d59:	48 89 d6             	mov    %rdx,%rsi
  803d5c:	48 89 c7             	mov    %rax,%rdi
  803d5f:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d6e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d74:	48 98                	cltq   
  803d76:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d7d:	0f 82 78 ff ff ff    	jb     803cfb <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d86:	c9                   	leaveq 
  803d87:	c3                   	retq   

0000000000803d88 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d88:	55                   	push   %rbp
  803d89:	48 89 e5             	mov    %rsp,%rbp
  803d8c:	48 83 ec 08          	sub    $0x8,%rsp
  803d90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d99:	c9                   	leaveq 
  803d9a:	c3                   	retq   

0000000000803d9b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d9b:	55                   	push   %rbp
  803d9c:	48 89 e5             	mov    %rsp,%rbp
  803d9f:	48 83 ec 10          	sub    $0x10,%rsp
  803da3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803da7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803dab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803daf:	48 be bd 4d 80 00 00 	movabs $0x804dbd,%rsi
  803db6:	00 00 00 
  803db9:	48 89 c7             	mov    %rax,%rdi
  803dbc:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
	return 0;
  803dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dcd:	c9                   	leaveq 
  803dce:	c3                   	retq   

0000000000803dcf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803dcf:	55                   	push   %rbp
  803dd0:	48 89 e5             	mov    %rsp,%rbp
  803dd3:	53                   	push   %rbx
  803dd4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ddb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803de2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803de8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803def:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803df6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803dfd:	84 c0                	test   %al,%al
  803dff:	74 23                	je     803e24 <_panic+0x55>
  803e01:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803e08:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803e0c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803e10:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803e14:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803e18:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803e1c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803e20:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803e24:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803e2b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803e32:	00 00 00 
  803e35:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803e3c:	00 00 00 
  803e3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e43:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803e4a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e51:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e58:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803e5f:	00 00 00 
  803e62:	48 8b 18             	mov    (%rax),%rbx
  803e65:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
  803e71:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e77:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e7e:	41 89 c8             	mov    %ecx,%r8d
  803e81:	48 89 d1             	mov    %rdx,%rcx
  803e84:	48 89 da             	mov    %rbx,%rdx
  803e87:	89 c6                	mov    %eax,%esi
  803e89:	48 bf c8 4d 80 00 00 	movabs $0x804dc8,%rdi
  803e90:	00 00 00 
  803e93:	b8 00 00 00 00       	mov    $0x0,%eax
  803e98:	49 b9 26 05 80 00 00 	movabs $0x800526,%r9
  803e9f:	00 00 00 
  803ea2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803ea5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803eac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803eb3:	48 89 d6             	mov    %rdx,%rsi
  803eb6:	48 89 c7             	mov    %rax,%rdi
  803eb9:	48 b8 7a 04 80 00 00 	movabs $0x80047a,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
	cprintf("\n");
  803ec5:	48 bf eb 4d 80 00 00 	movabs $0x804deb,%rdi
  803ecc:	00 00 00 
  803ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed4:	48 ba 26 05 80 00 00 	movabs $0x800526,%rdx
  803edb:	00 00 00 
  803ede:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803ee0:	cc                   	int3   
  803ee1:	eb fd                	jmp    803ee0 <_panic+0x111>

0000000000803ee3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 83 ec 30          	sub    $0x30,%rsp
  803eeb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ef3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803ef7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803efe:	00 00 00 
  803f01:	48 8b 00             	mov    (%rax),%rax
  803f04:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f0a:	85 c0                	test   %eax,%eax
  803f0c:	75 3c                	jne    803f4a <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f0e:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  803f15:	00 00 00 
  803f18:	ff d0                	callq  *%rax
  803f1a:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f1f:	48 63 d0             	movslq %eax,%rdx
  803f22:	48 89 d0             	mov    %rdx,%rax
  803f25:	48 c1 e0 03          	shl    $0x3,%rax
  803f29:	48 01 d0             	add    %rdx,%rax
  803f2c:	48 c1 e0 05          	shl    $0x5,%rax
  803f30:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f37:	00 00 00 
  803f3a:	48 01 c2             	add    %rax,%rdx
  803f3d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803f44:	00 00 00 
  803f47:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f4a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f4f:	75 0e                	jne    803f5f <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f51:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f58:	00 00 00 
  803f5b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f63:	48 89 c7             	mov    %rax,%rdi
  803f66:	48 b8 33 1c 80 00 00 	movabs $0x801c33,%rax
  803f6d:	00 00 00 
  803f70:	ff d0                	callq  *%rax
  803f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f79:	79 19                	jns    803f94 <ipc_recv+0xb1>
		*from_env_store = 0;
  803f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f89:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f92:	eb 53                	jmp    803fe7 <ipc_recv+0x104>
	}
	if(from_env_store)
  803f94:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f99:	74 19                	je     803fb4 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f9b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fa2:	00 00 00 
  803fa5:	48 8b 00             	mov    (%rax),%rax
  803fa8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb2:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fb4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fb9:	74 19                	je     803fd4 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803fbb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fc2:	00 00 00 
  803fc5:	48 8b 00             	mov    (%rax),%rax
  803fc8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd2:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803fd4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  803fdb:	00 00 00 
  803fde:	48 8b 00             	mov    (%rax),%rax
  803fe1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803fe7:	c9                   	leaveq 
  803fe8:	c3                   	retq   

0000000000803fe9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fe9:	55                   	push   %rbp
  803fea:	48 89 e5             	mov    %rsp,%rbp
  803fed:	48 83 ec 30          	sub    $0x30,%rsp
  803ff1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ff4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ff7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ffb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803ffe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804003:	75 0e                	jne    804013 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804005:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80400c:	00 00 00 
  80400f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804013:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804016:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804019:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80401d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804020:	89 c7                	mov    %eax,%edi
  804022:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804031:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804035:	75 0c                	jne    804043 <ipc_send+0x5a>
			sys_yield();
  804037:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  80403e:	00 00 00 
  804041:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804043:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804047:	74 ca                	je     804013 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804049:	c9                   	leaveq 
  80404a:	c3                   	retq   

000000000080404b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80404b:	55                   	push   %rbp
  80404c:	48 89 e5             	mov    %rsp,%rbp
  80404f:	48 83 ec 14          	sub    $0x14,%rsp
  804053:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80405d:	eb 5e                	jmp    8040bd <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80405f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804066:	00 00 00 
  804069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406c:	48 63 d0             	movslq %eax,%rdx
  80406f:	48 89 d0             	mov    %rdx,%rax
  804072:	48 c1 e0 03          	shl    $0x3,%rax
  804076:	48 01 d0             	add    %rdx,%rax
  804079:	48 c1 e0 05          	shl    $0x5,%rax
  80407d:	48 01 c8             	add    %rcx,%rax
  804080:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804086:	8b 00                	mov    (%rax),%eax
  804088:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80408b:	75 2c                	jne    8040b9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80408d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804094:	00 00 00 
  804097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409a:	48 63 d0             	movslq %eax,%rdx
  80409d:	48 89 d0             	mov    %rdx,%rax
  8040a0:	48 c1 e0 03          	shl    $0x3,%rax
  8040a4:	48 01 d0             	add    %rdx,%rax
  8040a7:	48 c1 e0 05          	shl    $0x5,%rax
  8040ab:	48 01 c8             	add    %rcx,%rax
  8040ae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040b4:	8b 40 08             	mov    0x8(%rax),%eax
  8040b7:	eb 12                	jmp    8040cb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040c4:	7e 99                	jle    80405f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040cb:	c9                   	leaveq 
  8040cc:	c3                   	retq   

00000000008040cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040cd:	55                   	push   %rbp
  8040ce:	48 89 e5             	mov    %rsp,%rbp
  8040d1:	48 83 ec 18          	sub    $0x18,%rsp
  8040d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040dd:	48 c1 e8 15          	shr    $0x15,%rax
  8040e1:	48 89 c2             	mov    %rax,%rdx
  8040e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040eb:	01 00 00 
  8040ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040f2:	83 e0 01             	and    $0x1,%eax
  8040f5:	48 85 c0             	test   %rax,%rax
  8040f8:	75 07                	jne    804101 <pageref+0x34>
		return 0;
  8040fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ff:	eb 53                	jmp    804154 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804105:	48 c1 e8 0c          	shr    $0xc,%rax
  804109:	48 89 c2             	mov    %rax,%rdx
  80410c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804113:	01 00 00 
  804116:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80411a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80411e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804122:	83 e0 01             	and    $0x1,%eax
  804125:	48 85 c0             	test   %rax,%rax
  804128:	75 07                	jne    804131 <pageref+0x64>
		return 0;
  80412a:	b8 00 00 00 00       	mov    $0x0,%eax
  80412f:	eb 23                	jmp    804154 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804135:	48 c1 e8 0c          	shr    $0xc,%rax
  804139:	48 89 c2             	mov    %rax,%rdx
  80413c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804143:	00 00 00 
  804146:	48 c1 e2 04          	shl    $0x4,%rdx
  80414a:	48 01 d0             	add    %rdx,%rax
  80414d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804151:	0f b7 c0             	movzwl %ax,%eax
}
  804154:	c9                   	leaveq 
  804155:	c3                   	retq   

0000000000804156 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804156:	55                   	push   %rbp
  804157:	48 89 e5             	mov    %rsp,%rbp
  80415a:	48 83 ec 20          	sub    $0x20,%rsp
  80415e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804162:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416a:	48 89 d6             	mov    %rdx,%rsi
  80416d:	48 89 c7             	mov    %rax,%rdi
  804170:	48 b8 8c 41 80 00 00 	movabs $0x80418c,%rax
  804177:	00 00 00 
  80417a:	ff d0                	callq  *%rax
  80417c:	85 c0                	test   %eax,%eax
  80417e:	74 05                	je     804185 <inet_addr+0x2f>
    return (val.s_addr);
  804180:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804183:	eb 05                	jmp    80418a <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80418a:	c9                   	leaveq 
  80418b:	c3                   	retq   

000000000080418c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80418c:	55                   	push   %rbp
  80418d:	48 89 e5             	mov    %rsp,%rbp
  804190:	48 83 ec 40          	sub    $0x40,%rsp
  804194:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804198:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80419c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8041a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041a8:	0f b6 00             	movzbl (%rax),%eax
  8041ab:	0f be c0             	movsbl %al,%eax
  8041ae:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8041b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041b4:	3c 2f                	cmp    $0x2f,%al
  8041b6:	76 07                	jbe    8041bf <inet_aton+0x33>
  8041b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041bb:	3c 39                	cmp    $0x39,%al
  8041bd:	76 0a                	jbe    8041c9 <inet_aton+0x3d>
      return (0);
  8041bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c4:	e9 68 02 00 00       	jmpq   804431 <inet_aton+0x2a5>
    val = 0;
  8041c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8041d0:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8041d7:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8041db:	75 40                	jne    80421d <inet_aton+0x91>
      c = *++cp;
  8041dd:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8041e2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041e6:	0f b6 00             	movzbl (%rax),%eax
  8041e9:	0f be c0             	movsbl %al,%eax
  8041ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8041ef:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8041f3:	74 06                	je     8041fb <inet_aton+0x6f>
  8041f5:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8041f9:	75 1b                	jne    804216 <inet_aton+0x8a>
        base = 16;
  8041fb:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804202:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804207:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80420b:	0f b6 00             	movzbl (%rax),%eax
  80420e:	0f be c0             	movsbl %al,%eax
  804211:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804214:	eb 07                	jmp    80421d <inet_aton+0x91>
      } else
        base = 8;
  804216:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80421d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804220:	3c 2f                	cmp    $0x2f,%al
  804222:	76 2f                	jbe    804253 <inet_aton+0xc7>
  804224:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804227:	3c 39                	cmp    $0x39,%al
  804229:	77 28                	ja     804253 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80422b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80422e:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804232:	89 c2                	mov    %eax,%edx
  804234:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804237:	01 d0                	add    %edx,%eax
  804239:	83 e8 30             	sub    $0x30,%eax
  80423c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80423f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804244:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804248:	0f b6 00             	movzbl (%rax),%eax
  80424b:	0f be c0             	movsbl %al,%eax
  80424e:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804251:	eb ca                	jmp    80421d <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804253:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  804257:	75 72                	jne    8042cb <inet_aton+0x13f>
  804259:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80425c:	3c 2f                	cmp    $0x2f,%al
  80425e:	76 07                	jbe    804267 <inet_aton+0xdb>
  804260:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804263:	3c 39                	cmp    $0x39,%al
  804265:	76 1c                	jbe    804283 <inet_aton+0xf7>
  804267:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80426a:	3c 60                	cmp    $0x60,%al
  80426c:	76 07                	jbe    804275 <inet_aton+0xe9>
  80426e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804271:	3c 66                	cmp    $0x66,%al
  804273:	76 0e                	jbe    804283 <inet_aton+0xf7>
  804275:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804278:	3c 40                	cmp    $0x40,%al
  80427a:	76 4f                	jbe    8042cb <inet_aton+0x13f>
  80427c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80427f:	3c 46                	cmp    $0x46,%al
  804281:	77 48                	ja     8042cb <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804286:	c1 e0 04             	shl    $0x4,%eax
  804289:	89 c2                	mov    %eax,%edx
  80428b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80428e:	8d 48 0a             	lea    0xa(%rax),%ecx
  804291:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804294:	3c 60                	cmp    $0x60,%al
  804296:	76 0e                	jbe    8042a6 <inet_aton+0x11a>
  804298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80429b:	3c 7a                	cmp    $0x7a,%al
  80429d:	77 07                	ja     8042a6 <inet_aton+0x11a>
  80429f:	b8 61 00 00 00       	mov    $0x61,%eax
  8042a4:	eb 05                	jmp    8042ab <inet_aton+0x11f>
  8042a6:	b8 41 00 00 00       	mov    $0x41,%eax
  8042ab:	29 c1                	sub    %eax,%ecx
  8042ad:	89 c8                	mov    %ecx,%eax
  8042af:	09 d0                	or     %edx,%eax
  8042b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8042b4:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8042bd:	0f b6 00             	movzbl (%rax),%eax
  8042c0:	0f be c0             	movsbl %al,%eax
  8042c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8042c6:	e9 52 ff ff ff       	jmpq   80421d <inet_aton+0x91>
    if (c == '.') {
  8042cb:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8042cf:	75 40                	jne    804311 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8042d1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8042d5:	48 83 c0 0c          	add    $0xc,%rax
  8042d9:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8042dd:	72 0a                	jb     8042e9 <inet_aton+0x15d>
        return (0);
  8042df:	b8 00 00 00 00       	mov    $0x0,%eax
  8042e4:	e9 48 01 00 00       	jmpq   804431 <inet_aton+0x2a5>
      *pp++ = val;
  8042e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ed:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8042f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8042f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042f8:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8042fa:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804303:	0f b6 00             	movzbl (%rax),%eax
  804306:	0f be c0             	movsbl %al,%eax
  804309:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  80430c:	e9 a0 fe ff ff       	jmpq   8041b1 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804311:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804312:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804316:	74 3c                	je     804354 <inet_aton+0x1c8>
  804318:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80431b:	3c 1f                	cmp    $0x1f,%al
  80431d:	76 2b                	jbe    80434a <inet_aton+0x1be>
  80431f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804322:	84 c0                	test   %al,%al
  804324:	78 24                	js     80434a <inet_aton+0x1be>
  804326:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80432a:	74 28                	je     804354 <inet_aton+0x1c8>
  80432c:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804330:	74 22                	je     804354 <inet_aton+0x1c8>
  804332:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804336:	74 1c                	je     804354 <inet_aton+0x1c8>
  804338:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80433c:	74 16                	je     804354 <inet_aton+0x1c8>
  80433e:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804342:	74 10                	je     804354 <inet_aton+0x1c8>
  804344:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804348:	74 0a                	je     804354 <inet_aton+0x1c8>
    return (0);
  80434a:	b8 00 00 00 00       	mov    $0x0,%eax
  80434f:	e9 dd 00 00 00       	jmpq   804431 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804354:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804358:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80435c:	48 29 c2             	sub    %rax,%rdx
  80435f:	48 89 d0             	mov    %rdx,%rax
  804362:	48 c1 f8 02          	sar    $0x2,%rax
  804366:	83 c0 01             	add    $0x1,%eax
  804369:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80436c:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  804370:	0f 87 98 00 00 00    	ja     80440e <inet_aton+0x282>
  804376:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804379:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804380:	00 
  804381:	48 b8 f0 4d 80 00 00 	movabs $0x804df0,%rax
  804388:	00 00 00 
  80438b:	48 01 d0             	add    %rdx,%rax
  80438e:	48 8b 00             	mov    (%rax),%rax
  804391:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804393:	b8 00 00 00 00       	mov    $0x0,%eax
  804398:	e9 94 00 00 00       	jmpq   804431 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  80439d:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8043a4:	76 0a                	jbe    8043b0 <inet_aton+0x224>
      return (0);
  8043a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ab:	e9 81 00 00 00       	jmpq   804431 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  8043b0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043b3:	c1 e0 18             	shl    $0x18,%eax
  8043b6:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043b9:	eb 53                	jmp    80440e <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8043bb:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8043c2:	76 07                	jbe    8043cb <inet_aton+0x23f>
      return (0);
  8043c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c9:	eb 66                	jmp    804431 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8043cb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043ce:	c1 e0 18             	shl    $0x18,%eax
  8043d1:	89 c2                	mov    %eax,%edx
  8043d3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043d6:	c1 e0 10             	shl    $0x10,%eax
  8043d9:	09 d0                	or     %edx,%eax
  8043db:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8043de:	eb 2e                	jmp    80440e <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8043e0:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8043e7:	76 07                	jbe    8043f0 <inet_aton+0x264>
      return (0);
  8043e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ee:	eb 41                	jmp    804431 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8043f0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8043f3:	c1 e0 18             	shl    $0x18,%eax
  8043f6:	89 c2                	mov    %eax,%edx
  8043f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8043fb:	c1 e0 10             	shl    $0x10,%eax
  8043fe:	09 c2                	or     %eax,%edx
  804400:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804403:	c1 e0 08             	shl    $0x8,%eax
  804406:	09 d0                	or     %edx,%eax
  804408:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80440b:	eb 01                	jmp    80440e <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80440d:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80440e:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804413:	74 17                	je     80442c <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  804415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804418:	89 c7                	mov    %eax,%edi
  80441a:	48 b8 aa 45 80 00 00 	movabs $0x8045aa,%rax
  804421:	00 00 00 
  804424:	ff d0                	callq  *%rax
  804426:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80442a:	89 02                	mov    %eax,(%rdx)
  return (1);
  80442c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804431:	c9                   	leaveq 
  804432:	c3                   	retq   

0000000000804433 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804433:	55                   	push   %rbp
  804434:	48 89 e5             	mov    %rsp,%rbp
  804437:	48 83 ec 30          	sub    $0x30,%rsp
  80443b:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80443e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804441:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804444:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80444b:	00 00 00 
  80444e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804452:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804456:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80445a:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80445e:	e9 e0 00 00 00       	jmpq   804543 <inet_ntoa+0x110>
    i = 0;
  804463:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  804467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80446b:	0f b6 08             	movzbl (%rax),%ecx
  80446e:	0f b6 d1             	movzbl %cl,%edx
  804471:	89 d0                	mov    %edx,%eax
  804473:	c1 e0 02             	shl    $0x2,%eax
  804476:	01 d0                	add    %edx,%eax
  804478:	c1 e0 03             	shl    $0x3,%eax
  80447b:	01 d0                	add    %edx,%eax
  80447d:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804484:	01 d0                	add    %edx,%eax
  804486:	66 c1 e8 08          	shr    $0x8,%ax
  80448a:	c0 e8 03             	shr    $0x3,%al
  80448d:	88 45 ed             	mov    %al,-0x13(%rbp)
  804490:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804494:	89 d0                	mov    %edx,%eax
  804496:	c1 e0 02             	shl    $0x2,%eax
  804499:	01 d0                	add    %edx,%eax
  80449b:	01 c0                	add    %eax,%eax
  80449d:	29 c1                	sub    %eax,%ecx
  80449f:	89 c8                	mov    %ecx,%eax
  8044a1:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8044a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a8:	0f b6 00             	movzbl (%rax),%eax
  8044ab:	0f b6 d0             	movzbl %al,%edx
  8044ae:	89 d0                	mov    %edx,%eax
  8044b0:	c1 e0 02             	shl    $0x2,%eax
  8044b3:	01 d0                	add    %edx,%eax
  8044b5:	c1 e0 03             	shl    $0x3,%eax
  8044b8:	01 d0                	add    %edx,%eax
  8044ba:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8044c1:	01 d0                	add    %edx,%eax
  8044c3:	66 c1 e8 08          	shr    $0x8,%ax
  8044c7:	89 c2                	mov    %eax,%edx
  8044c9:	c0 ea 03             	shr    $0x3,%dl
  8044cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d0:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8044d2:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8044d6:	8d 50 01             	lea    0x1(%rax),%edx
  8044d9:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8044dc:	0f b6 c0             	movzbl %al,%eax
  8044df:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8044e3:	83 c2 30             	add    $0x30,%edx
  8044e6:	48 98                	cltq   
  8044e8:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8044ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f0:	0f b6 00             	movzbl (%rax),%eax
  8044f3:	84 c0                	test   %al,%al
  8044f5:	0f 85 6c ff ff ff    	jne    804467 <inet_ntoa+0x34>
    while(i--)
  8044fb:	eb 1a                	jmp    804517 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8044fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804501:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804505:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804509:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80450d:	48 63 d2             	movslq %edx,%rdx
  804510:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804515:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  804517:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80451b:	8d 50 ff             	lea    -0x1(%rax),%edx
  80451e:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804521:	84 c0                	test   %al,%al
  804523:	75 d8                	jne    8044fd <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  804525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804529:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80452d:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804531:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804534:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  804539:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80453d:	83 c0 01             	add    $0x1,%eax
  804540:	88 45 ef             	mov    %al,-0x11(%rbp)
  804543:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  804547:	0f 86 16 ff ff ff    	jbe    804463 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80454d:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804556:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  804559:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804560:	00 00 00 
}
  804563:	c9                   	leaveq 
  804564:	c3                   	retq   

0000000000804565 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804565:	55                   	push   %rbp
  804566:	48 89 e5             	mov    %rsp,%rbp
  804569:	48 83 ec 04          	sub    $0x4,%rsp
  80456d:	89 f8                	mov    %edi,%eax
  80456f:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  804573:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804577:	c1 e0 08             	shl    $0x8,%eax
  80457a:	89 c2                	mov    %eax,%edx
  80457c:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  804580:	66 c1 e8 08          	shr    $0x8,%ax
  804584:	09 d0                	or     %edx,%eax
}
  804586:	c9                   	leaveq 
  804587:	c3                   	retq   

0000000000804588 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804588:	55                   	push   %rbp
  804589:	48 89 e5             	mov    %rsp,%rbp
  80458c:	48 83 ec 08          	sub    $0x8,%rsp
  804590:	89 f8                	mov    %edi,%eax
  804592:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  804596:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80459a:	89 c7                	mov    %eax,%edi
  80459c:	48 b8 65 45 80 00 00 	movabs $0x804565,%rax
  8045a3:	00 00 00 
  8045a6:	ff d0                	callq  *%rax
}
  8045a8:	c9                   	leaveq 
  8045a9:	c3                   	retq   

00000000008045aa <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8045aa:	55                   	push   %rbp
  8045ab:	48 89 e5             	mov    %rsp,%rbp
  8045ae:	48 83 ec 04          	sub    $0x4,%rsp
  8045b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8045b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b8:	c1 e0 18             	shl    $0x18,%eax
  8045bb:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8045bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c0:	25 00 ff 00 00       	and    $0xff00,%eax
  8045c5:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045c8:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8045ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045cd:	25 00 00 ff 00       	and    $0xff0000,%eax
  8045d2:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045d6:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8045d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045db:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8045de:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8045e0:	c9                   	leaveq 
  8045e1:	c3                   	retq   

00000000008045e2 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8045e2:	55                   	push   %rbp
  8045e3:	48 89 e5             	mov    %rsp,%rbp
  8045e6:	48 83 ec 08          	sub    $0x8,%rsp
  8045ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8045ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f0:	89 c7                	mov    %eax,%edi
  8045f2:	48 b8 aa 45 80 00 00 	movabs $0x8045aa,%rax
  8045f9:	00 00 00 
  8045fc:	ff d0                	callq  *%rax
}
  8045fe:	c9                   	leaveq 
  8045ff:	c3                   	retq   
