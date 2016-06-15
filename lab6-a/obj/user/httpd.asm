
obj/user/httpd.debug:     file format elf64-x86-64


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
  80003c:	e8 49 0b 00 00       	callq  800b8a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
	{404, "Not Found"},
};

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
  800056:	48 bf 1c 54 80 00 00 	movabs $0x80541c,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	c9                   	leaveq 
  80007e:	c3                   	retq   

000000000080007f <req_free>:

static void
req_free(struct http_request *req)
{
  80007f:	55                   	push   %rbp
  800080:	48 89 e5             	mov    %rsp,%rbp
  800083:	48 83 ec 10          	sub    $0x10,%rsp
  800087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80008f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800093:	48 89 c7             	mov    %rax,%rdi
  800096:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	callq  *%rax
	free(req->version);
  8000a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000aa:	48 89 c7             	mov    %rax,%rdi
  8000ad:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  8000b4:	00 00 00 
  8000b7:	ff d0                	callq  *%rax
}
  8000b9:	c9                   	leaveq 
  8000ba:	c3                   	retq   

00000000008000bb <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bb:	55                   	push   %rbp
  8000bc:	48 89 e5             	mov    %rsp,%rbp
  8000bf:	48 83 ec 20          	sub    $0x20,%rsp
  8000c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d1:	00 00 00 
  8000d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d8:	eb 12                	jmp    8000ec <send_header+0x31>
		if (h->code == code)
  8000da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000de:	8b 00                	mov    (%rax),%eax
  8000e0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e3:	75 02                	jne    8000e7 <send_header+0x2c>
			break;
  8000e5:	eb 1c                	jmp    800103 <send_header+0x48>
		h++;
  8000e7:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	8b 00                	mov    (%rax),%eax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 0d                	je     800103 <send_header+0x48>
  8000f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fe:	48 85 c0             	test   %rax,%rax
  800101:	75 d7                	jne    8000da <send_header+0x1f>
		if (h->code == code)
			break;
		h++;
	}

	if (h->code == 0)
  800103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800107:	8b 00                	mov    (%rax),%eax
  800109:	85 c0                	test   %eax,%eax
  80010b:	75 07                	jne    800114 <send_header+0x59>
		return -1;
  80010d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800112:	eb 5f                	jmp    800173 <send_header+0xb8>

	int len = strlen(h->header);
  800114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800118:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011c:	48 89 c7             	mov    %rax,%rdi
  80011f:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
  80012b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  80012e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800131:	48 63 d0             	movslq %eax,%rdx
  800134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800138:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800140:	8b 00                	mov    (%rax),%eax
  800142:	48 89 ce             	mov    %rcx,%rsi
  800145:	89 c7                	mov    %eax,%edi
  800147:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
  800153:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800156:	74 16                	je     80016e <send_header+0xb3>
		die("Failed to send bytes to client");
  800158:	48 bf 20 54 80 00 00 	movabs $0x805420,%rdi
  80015f:	00 00 00 
  800162:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
	}

	return 0;
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800173:	c9                   	leaveq 
  800174:	c3                   	retq   

0000000000800175 <send_data>:

#define E1000_TXD_BUFFER_LENGTH 1518

static int
send_data(struct http_request *req, int fd)
{
  800175:	55                   	push   %rbp
  800176:	48 89 e5             	mov    %rsp,%rbp
  800179:	48 81 ec 10 06 00 00 	sub    $0x610,%rsp
  800180:	48 89 bd f8 f9 ff ff 	mov    %rdi,-0x608(%rbp)
  800187:	89 b5 f4 f9 ff ff    	mov    %esi,-0x60c(%rbp)
	// LAB 6: Your code here.
	int size = 0;
  80018d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	char buf[E1000_TXD_BUFFER_LENGTH];
	seek(fd, 0);
  800194:	8b 85 f4 f9 ff ff    	mov    -0x60c(%rbp),%eax
  80019a:	be 00 00 00 00       	mov    $0x0,%esi
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	48 b8 c4 2d 80 00 00 	movabs $0x802dc4,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax
	if ((size = readn(fd, buf, sizeof buf)) <= 0)
  8001ad:	48 8d 8d 00 fa ff ff 	lea    -0x600(%rbp),%rcx
  8001b4:	8b 85 f4 f9 ff ff    	mov    -0x60c(%rbp),%eax
  8001ba:	ba ee 05 00 00       	mov    $0x5ee,%edx
  8001bf:	48 89 ce             	mov    %rcx,%rsi
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	48 b8 7b 2c 80 00 00 	movabs $0x802c7b,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d7:	7f 30                	jg     800209 <send_data+0x94>
		panic("readn: %e", size);
  8001d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dc:	89 c1                	mov    %eax,%ecx
  8001de:	48 ba 3f 54 80 00 00 	movabs $0x80543f,%rdx
  8001e5:	00 00 00 
  8001e8:	be 56 00 00 00       	mov    $0x56,%esi
  8001ed:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  8001f4:	00 00 00 
  8001f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fc:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  800203:	00 00 00 
  800206:	41 ff d0             	callq  *%r8
	if((size = write(req->sock, buf, size)) <= 0)
  800209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020c:	48 63 d0             	movslq %eax,%rdx
  80020f:	48 8b 85 f8 f9 ff ff 	mov    -0x608(%rbp),%rax
  800216:	8b 00                	mov    (%rax),%eax
  800218:	48 8d 8d 00 fa ff ff 	lea    -0x600(%rbp),%rcx
  80021f:	48 89 ce             	mov    %rcx,%rsi
  800222:	89 c7                	mov    %eax,%edi
  800224:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	callq  *%rax
  800230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800237:	7f 30                	jg     800269 <send_data+0xf4>
		panic("socket write failed: %e", size);
  800239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023c:	89 c1                	mov    %eax,%ecx
  80023e:	48 ba 56 54 80 00 00 	movabs $0x805456,%rdx
  800245:	00 00 00 
  800248:	be 58 00 00 00       	mov    $0x58,%esi
  80024d:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  800254:	00 00 00 
  800257:	b8 00 00 00 00       	mov    $0x0,%eax
  80025c:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  800263:	00 00 00 
  800266:	41 ff d0             	callq  *%r8
	return size;
  800269:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("send_data not implemented");
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <send_size>:

static int
send_size(struct http_request *req, off_t size)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	48 83 ec 60          	sub    $0x60,%rsp
  800276:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80027a:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80027d:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  800280:	48 63 d0             	movslq %eax,%rdx
  800283:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800287:	48 89 d1             	mov    %rdx,%rcx
  80028a:	48 ba 6e 54 80 00 00 	movabs $0x80546e,%rdx
  800291:	00 00 00 
  800294:	be 40 00 00 00       	mov    $0x40,%esi
  800299:	48 89 c7             	mov    %rax,%rdi
  80029c:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a1:	49 b8 d9 18 80 00 00 	movabs $0x8018d9,%r8
  8002a8:	00 00 00 
  8002ab:	41 ff d0             	callq  *%r8
  8002ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  8002b1:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  8002b5:	7e 2a                	jle    8002e1 <send_size+0x73>
		panic("buffer too small!");
  8002b7:	48 ba 84 54 80 00 00 	movabs $0x805484,%rdx
  8002be:	00 00 00 
  8002c1:	be 65 00 00 00       	mov    $0x65,%esi
  8002c6:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  8002cd:	00 00 00 
  8002d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d5:	48 b9 38 0c 80 00 00 	movabs $0x800c38,%rcx
  8002dc:	00 00 00 
  8002df:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  8002e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e4:	48 63 d0             	movslq %eax,%rdx
  8002e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8002eb:	8b 00                	mov    (%rax),%eax
  8002ed:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  8002f1:	48 89 ce             	mov    %rcx,%rsi
  8002f4:	89 c7                	mov    %eax,%edi
  8002f6:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	callq  *%rax
  800302:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800305:	74 07                	je     80030e <send_size+0xa0>
		return -1;
  800307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80030c:	eb 05                	jmp    800313 <send_size+0xa5>

	return 0;
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800313:	c9                   	leaveq 
  800314:	c3                   	retq   

0000000000800315 <mime_type>:

static const char*
mime_type(const char *file)
{
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	48 83 ec 08          	sub    $0x8,%rsp
  80031d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  800321:	48 b8 96 54 80 00 00 	movabs $0x805496,%rax
  800328:	00 00 00 
}
  80032b:	c9                   	leaveq 
  80032c:	c3                   	retq   

000000000080032d <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  80032d:	55                   	push   %rbp
  80032e:	48 89 e5             	mov    %rsp,%rbp
  800331:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800338:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80033f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800346:	48 8b 40 08          	mov    0x8(%rax),%rax
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 15 03 80 00 00 	movabs $0x800315,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
  800359:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80035d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800362:	75 0a                	jne    80036e <send_content_type+0x41>
		return -1;
  800364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800369:	e9 9d 00 00 00       	jmpq   80040b <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  80036e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800372:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800379:	48 89 d1             	mov    %rdx,%rcx
  80037c:	48 ba a0 54 80 00 00 	movabs $0x8054a0,%rdx
  800383:	00 00 00 
  800386:	be 80 00 00 00       	mov    $0x80,%esi
  80038b:	48 89 c7             	mov    %rax,%rdi
  80038e:	b8 00 00 00 00       	mov    $0x0,%eax
  800393:	49 b8 d9 18 80 00 00 	movabs $0x8018d9,%r8
  80039a:	00 00 00 
  80039d:	41 ff d0             	callq  *%r8
  8003a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  8003a3:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8003a7:	7e 2a                	jle    8003d3 <send_content_type+0xa6>
		panic("buffer too small!");
  8003a9:	48 ba 84 54 80 00 00 	movabs $0x805484,%rdx
  8003b0:	00 00 00 
  8003b3:	be 81 00 00 00       	mov    $0x81,%esi
  8003b8:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  8003bf:	00 00 00 
  8003c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c7:	48 b9 38 0c 80 00 00 	movabs $0x800c38,%rcx
  8003ce:	00 00 00 
  8003d1:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  8003d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003d6:	48 63 d0             	movslq %eax,%rdx
  8003d9:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8003e0:	8b 00                	mov    (%rax),%eax
  8003e2:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8003e9:	48 89 ce             	mov    %rcx,%rsi
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
  8003fa:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003fd:	74 07                	je     800406 <send_content_type+0xd9>
		return -1;
  8003ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800404:	eb 05                	jmp    80040b <send_content_type+0xde>

	return 0;
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80040b:	c9                   	leaveq 
  80040c:	c3                   	retq   

000000000080040d <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  80040d:	55                   	push   %rbp
  80040e:	48 89 e5             	mov    %rsp,%rbp
  800411:	48 83 ec 20          	sub    $0x20,%rsp
  800415:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  800419:	48 b8 b3 54 80 00 00 	movabs $0x8054b3,%rax
  800420:	00 00 00 
  800423:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  800427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042b:	48 89 c7             	mov    %rax,%rdi
  80042e:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
  80043a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80043d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800440:	48 63 d0             	movslq %eax,%rdx
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	8b 00                	mov    (%rax),%eax
  800449:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80044d:	48 89 ce             	mov    %rcx,%rsi
  800450:	89 c7                	mov    %eax,%edi
  800452:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  800459:	00 00 00 
  80045c:	ff d0                	callq  *%rax
  80045e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800461:	74 07                	je     80046a <send_header_fin+0x5d>
		return -1;
  800463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800468:	eb 05                	jmp    80046f <send_header_fin+0x62>

	return 0;
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046f:	c9                   	leaveq 
  800470:	c3                   	retq   

0000000000800471 <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  800471:	55                   	push   %rbp
  800472:	48 89 e5             	mov    %rsp,%rbp
  800475:	48 83 ec 30          	sub    $0x30,%rsp
  800479:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80047d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  800481:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800486:	75 0a                	jne    800492 <http_request_parse+0x21>
		return -1;
  800488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80048d:	e9 57 01 00 00       	jmpq   8005e9 <http_request_parse+0x178>

	if (strncmp(request, "GET ", 4) != 0)
  800492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800496:	ba 04 00 00 00       	mov    $0x4,%edx
  80049b:	48 be b6 54 80 00 00 	movabs $0x8054b6,%rsi
  8004a2:	00 00 00 
  8004a5:	48 89 c7             	mov    %rax,%rdi
  8004a8:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	74 0a                	je     8004c2 <http_request_parse+0x51>
		return -E_BAD_REQ;
  8004b8:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  8004bd:	e9 27 01 00 00       	jmpq   8005e9 <http_request_parse+0x178>

	// skip GET
	request += 4;
  8004c2:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  8004c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  8004cf:	eb 05                	jmp    8004d6 <http_request_parse+0x65>
		request++;
  8004d1:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  8004d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004da:	0f b6 00             	movzbl (%rax),%eax
  8004dd:	84 c0                	test   %al,%al
  8004df:	74 0b                	je     8004ec <http_request_parse+0x7b>
  8004e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004e5:	0f b6 00             	movzbl (%rax),%eax
  8004e8:	3c 20                	cmp    $0x20,%al
  8004ea:	75 e5                	jne    8004d1 <http_request_parse+0x60>
		request++;
	url_len = request - url;
  8004ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f4:	48 29 c2             	sub    %rax,%rdx
  8004f7:	48 89 d0             	mov    %rdx,%rax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  8004fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800500:	83 c0 01             	add    $0x1,%eax
  800503:	48 98                	cltq   
  800505:	48 89 c7             	mov    %rax,%rdi
  800508:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  80050f:	00 00 00 
  800512:	ff d0                	callq  *%rax
  800514:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800518:	48 89 42 08          	mov    %rax,0x8(%rdx)
	memmove(req->url, url, url_len);
  80051c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80051f:	48 63 d0             	movslq %eax,%rdx
  800522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800526:	48 8b 40 08          	mov    0x8(%rax),%rax
  80052a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80052e:	48 89 ce             	mov    %rcx,%rsi
  800531:	48 89 c7             	mov    %rax,%rdi
  800534:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  80053b:	00 00 00 
  80053e:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800544:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800548:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054b:	48 98                	cltq   
  80054d:	48 01 d0             	add    %rdx,%rax
  800550:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800553:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  800558:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80055c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  800560:	eb 05                	jmp    800567 <http_request_parse+0xf6>
		request++;
  800562:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  800567:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80056b:	0f b6 00             	movzbl (%rax),%eax
  80056e:	84 c0                	test   %al,%al
  800570:	74 0b                	je     80057d <http_request_parse+0x10c>
  800572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800576:	0f b6 00             	movzbl (%rax),%eax
  800579:	3c 0a                	cmp    $0xa,%al
  80057b:	75 e5                	jne    800562 <http_request_parse+0xf1>
		request++;
	version_len = request - version;
  80057d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	48 29 c2             	sub    %rax,%rdx
  800588:	48 89 d0             	mov    %rdx,%rax
  80058b:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  80058e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800591:	83 c0 01             	add    $0x1,%eax
  800594:	48 98                	cltq   
  800596:	48 89 c7             	mov    %rax,%rdi
  800599:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  8005a0:	00 00 00 
  8005a3:	ff d0                	callq  *%rax
  8005a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8005a9:	48 89 42 10          	mov    %rax,0x10(%rdx)
	memmove(req->version, version, version_len);
  8005ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005b0:	48 63 d0             	movslq %eax,%rdx
  8005b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8005bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8005bf:	48 89 ce             	mov    %rcx,%rsi
  8005c2:	48 89 c7             	mov    %rax,%rdi
  8005c5:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  8005d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005dc:	48 98                	cltq   
  8005de:	48 01 d0             	add    %rdx,%rax
  8005e1:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005e9:	c9                   	leaveq 
  8005ea:	c3                   	retq   

00000000008005eb <send_error>:

static int
send_error(struct http_request *req, int code)
{
  8005eb:	55                   	push   %rbp
  8005ec:	48 89 e5             	mov    %rsp,%rbp
  8005ef:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  8005f6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8005fd:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  800603:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80060a:	00 00 00 
  80060d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  800611:	eb 15                	jmp    800628 <send_error+0x3d>
		if (e->code == code)
  800613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800617:	8b 00                	mov    (%rax),%eax
  800619:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  80061f:	75 02                	jne    800623 <send_error+0x38>
			break;
  800621:	eb 1c                	jmp    80063f <send_error+0x54>
		e++;
  800623:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	74 0d                	je     80063f <send_error+0x54>
  800632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800636:	48 8b 40 08          	mov    0x8(%rax),%rax
  80063a:	48 85 c0             	test   %rax,%rax
  80063d:	75 d4                	jne    800613 <send_error+0x28>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  80063f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800643:	8b 00                	mov    (%rax),%eax
  800645:	85 c0                	test   %eax,%eax
  800647:	75 0a                	jne    800653 <send_error+0x68>
		return -1;
  800649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80064e:	e9 8e 00 00 00       	jmpq   8006e1 <send_error+0xf6>

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800657:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80065b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80065f:	8b 38                	mov    (%rax),%edi
  800661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800665:	48 8b 70 08          	mov    0x8(%rax),%rsi
  800669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80066d:	8b 10                	mov    (%rax),%edx
  80066f:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800676:	48 89 0c 24          	mov    %rcx,(%rsp)
  80067a:	41 89 f9             	mov    %edi,%r9d
  80067d:	49 89 f0             	mov    %rsi,%r8
  800680:	89 d1                	mov    %edx,%ecx
  800682:	48 ba c0 54 80 00 00 	movabs $0x8054c0,%rdx
  800689:	00 00 00 
  80068c:	be 00 02 00 00       	mov    $0x200,%esi
  800691:	48 89 c7             	mov    %rax,%rdi
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	49 ba d9 18 80 00 00 	movabs $0x8018d9,%r10
  8006a0:	00 00 00 
  8006a3:	41 ff d2             	callq  *%r10
  8006a6:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8006a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8006ac:	48 63 d0             	movslq %eax,%rdx
  8006af:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8006b6:	8b 00                	mov    (%rax),%eax
  8006b8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8006bf:	48 89 ce             	mov    %rcx,%rsi
  8006c2:	89 c7                	mov    %eax,%edi
  8006c4:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8006cb:	00 00 00 
  8006ce:	ff d0                	callq  *%rax
  8006d0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8006d3:	74 07                	je     8006dc <send_error+0xf1>
		return -1;
  8006d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006da:	eb 05                	jmp    8006e1 <send_error+0xf6>

	return 0;
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006e1:	c9                   	leaveq 
  8006e2:	c3                   	retq   

00000000008006e3 <send_file>:

static int
send_file(struct http_request *req)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8006ee:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
	int r;
	off_t file_size = -1;
  8006f5:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	//panic("send_file not implemented");
	cprintf("url %s\n", req->url);
  8006fc:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800703:	48 8b 40 08          	mov    0x8(%rax),%rax
  800707:	48 89 c6             	mov    %rax,%rsi
  80070a:	48 bf 3b 55 80 00 00 	movabs $0x80553b,%rdi
  800711:	00 00 00 
  800714:	b8 00 00 00 00       	mov    $0x0,%eax
  800719:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  800720:	00 00 00 
  800723:	ff d2                	callq  *%rdx
	struct Stat stat;
	fd = open(req->url, O_RDONLY);
  800725:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80072c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800730:	be 00 00 00 00       	mov    $0x0,%esi
  800735:	48 89 c7             	mov    %rax,%rdi
  800738:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  80073f:	00 00 00 
  800742:	ff d0                	callq  *%rax
  800744:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(fstat(fd, &stat) != 0)
  800747:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80074e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800751:	48 89 d6             	mov    %rdx,%rsi
  800754:	89 c7                	mov    %eax,%edi
  800756:	48 b8 d5 2e 80 00 00 	movabs $0x802ed5,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
  800762:	85 c0                	test   %eax,%eax
  800764:	74 05                	je     80076b <send_file+0x88>
		goto end;
  800766:	e9 1d 01 00 00       	jmpq   800888 <send_file+0x1a5>

	//File does not exist
	if (fd < 0)
  80076b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80076f:	79 1b                	jns    80078c <send_file+0xa9>
		send_error(req, 404);
  800771:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800778:	be 94 01 00 00       	mov    $0x194,%esi
  80077d:	48 89 c7             	mov    %rax,%rdi
  800780:	48 b8 eb 05 80 00 00 	movabs $0x8005eb,%rax
  800787:	00 00 00 
  80078a:	ff d0                	callq  *%rax
	cprintf("file name is %s \n", stat.st_name);
  80078c:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  800793:	48 89 c6             	mov    %rax,%rsi
  800796:	48 bf 43 55 80 00 00 	movabs $0x805543,%rdi
  80079d:	00 00 00 
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  8007ac:	00 00 00 
  8007af:	ff d2                	callq  *%rdx

	//File is a directory
	if(stat.st_isdir)
  8007b1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	74 1b                	je     8007d3 <send_file+0xf0>
		send_error(req, 404);
  8007b8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007bf:	be 94 01 00 00       	mov    $0x194,%esi
  8007c4:	48 89 c7             	mov    %rax,%rdi
  8007c7:	48 b8 eb 05 80 00 00 	movabs $0x8005eb,%rax
  8007ce:	00 00 00 
  8007d1:	ff d0                	callq  *%rax

	file_size = stat.st_size;
  8007d3:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007d6:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((r = send_header(req, 200)) < 0)
  8007d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007e0:	be c8 00 00 00       	mov    $0xc8,%esi
  8007e5:	48 89 c7             	mov    %rax,%rdi
  8007e8:	48 b8 bb 00 80 00 00 	movabs $0x8000bb,%rax
  8007ef:	00 00 00 
  8007f2:	ff d0                	callq  *%rax
  8007f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007fb:	79 05                	jns    800802 <send_file+0x11f>
		goto end;
  8007fd:	e9 86 00 00 00       	jmpq   800888 <send_file+0x1a5>

	if ((r = send_size(req, file_size)) < 0)
  800802:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800805:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80080c:	89 d6                	mov    %edx,%esi
  80080e:	48 89 c7             	mov    %rax,%rdi
  800811:	48 b8 6e 02 80 00 00 	movabs $0x80026e,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax
  80081d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800824:	79 02                	jns    800828 <send_file+0x145>
		goto end;
  800826:	eb 60                	jmp    800888 <send_file+0x1a5>

	if ((r = send_content_type(req)) < 0)
  800828:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80082f:	48 89 c7             	mov    %rax,%rdi
  800832:	48 b8 2d 03 80 00 00 	movabs $0x80032d,%rax
  800839:	00 00 00 
  80083c:	ff d0                	callq  *%rax
  80083e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800845:	79 02                	jns    800849 <send_file+0x166>
		goto end;
  800847:	eb 3f                	jmp    800888 <send_file+0x1a5>

	if ((r = send_header_fin(req)) < 0)
  800849:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800850:	48 89 c7             	mov    %rax,%rdi
  800853:	48 b8 0d 04 80 00 00 	movabs $0x80040d,%rax
  80085a:	00 00 00 
  80085d:	ff d0                	callq  *%rax
  80085f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800866:	79 02                	jns    80086a <send_file+0x187>
		goto end;
  800868:	eb 1e                	jmp    800888 <send_file+0x1a5>

	r = send_data(req, fd);
  80086a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80086d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800874:	89 d6                	mov    %edx,%esi
  800876:	48 89 c7             	mov    %rax,%rdi
  800879:	48 b8 75 01 80 00 00 	movabs $0x800175,%rax
  800880:	00 00 00 
  800883:	ff d0                	callq  *%rax
  800885:	89 45 fc             	mov    %eax,-0x4(%rbp)

end:
	close(fd);
  800888:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80088b:	89 c7                	mov    %eax,%edi
  80088d:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  800894:	00 00 00 
  800897:	ff d0                	callq  *%rax
	return r;
  800899:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80089c:	c9                   	leaveq 
  80089d:	c3                   	retq   

000000000080089e <handle_client>:

static void
handle_client(int sock)
{
  80089e:	55                   	push   %rbp
  80089f:	48 89 e5             	mov    %rsp,%rbp
  8008a2:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  8008a9:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  8008af:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  8008b6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8008ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8008be:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8008c5:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8008cb:	ba 00 02 00 00       	mov    $0x200,%edx
  8008d0:	48 89 ce             	mov    %rcx,%rsi
  8008d3:	89 c7                	mov    %eax,%edi
  8008d5:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  8008dc:	00 00 00 
  8008df:	ff d0                	callq  *%rax
  8008e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008e8:	79 2a                	jns    800914 <handle_client+0x76>
			panic("failed to read");
  8008ea:	48 ba 55 55 80 00 00 	movabs $0x805555,%rdx
  8008f1:	00 00 00 
  8008f4:	be 1e 01 00 00       	mov    $0x11e,%esi
  8008f9:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  800900:	00 00 00 
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	48 b9 38 0c 80 00 00 	movabs $0x800c38,%rcx
  80090f:	00 00 00 
  800912:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  800914:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800918:	ba 08 00 00 00       	mov    $0x8,%edx
  80091d:	be 00 00 00 00       	mov    $0x0,%esi
  800922:	48 89 c7             	mov    %rax,%rdi
  800925:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  80092c:	00 00 00 
  80092f:	ff d0                	callq  *%rax

		req->sock = sock;
  800931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800935:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  80093b:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  80093d:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800948:	48 89 d6             	mov    %rdx,%rsi
  80094b:	48 89 c7             	mov    %rax,%rdi
  80094e:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800955:	00 00 00 
  800958:	ff d0                	callq  *%rax
  80095a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  80095d:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  800964:	75 1a                	jne    800980 <handle_client+0xe2>
			send_error(req, 400);
  800966:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80096a:	be 90 01 00 00       	mov    $0x190,%esi
  80096f:	48 89 c7             	mov    %rax,%rdi
  800972:	48 b8 eb 05 80 00 00 	movabs $0x8005eb,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	eb 43                	jmp    8009c3 <handle_client+0x125>
		else if (r < 0)
  800980:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800984:	79 2a                	jns    8009b0 <handle_client+0x112>
			panic("parse failed");
  800986:	48 ba 64 55 80 00 00 	movabs $0x805564,%rdx
  80098d:	00 00 00 
  800990:	be 28 01 00 00       	mov    $0x128,%esi
  800995:	48 bf 49 54 80 00 00 	movabs $0x805449,%rdi
  80099c:	00 00 00 
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a4:	48 b9 38 0c 80 00 00 	movabs $0x800c38,%rcx
  8009ab:	00 00 00 
  8009ae:	ff d1                	callq  *%rcx
		else
			send_file(req);
  8009b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009b4:	48 89 c7             	mov    %rax,%rdi
  8009b7:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  8009be:	00 00 00 
  8009c1:	ff d0                	callq  *%rax

		req_free(req);
  8009c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009c7:	48 89 c7             	mov    %rax,%rdi
  8009ca:	48 b8 7f 00 80 00 00 	movabs $0x80007f,%rax
  8009d1:	00 00 00 
  8009d4:	ff d0                	callq  *%rax

		// no keep alive
		break;
  8009d6:	90                   	nop
	}

	close(sock);
  8009d7:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8009dd:	89 c7                	mov    %eax,%edi
  8009df:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  8009e6:	00 00 00 
  8009e9:	ff d0                	callq  *%rax
}
  8009eb:	c9                   	leaveq 
  8009ec:	c3                   	retq   

00000000008009ed <umain>:

void
umain(int argc, char **argv)
{
  8009ed:	55                   	push   %rbp
  8009ee:	48 89 e5             	mov    %rsp,%rbp
  8009f1:	53                   	push   %rbx
  8009f2:	48 83 ec 58          	sub    $0x58,%rsp
  8009f6:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8009f9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8009fd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800a04:	00 00 00 
  800a07:	48 bb 71 55 80 00 00 	movabs $0x805571,%rbx
  800a0e:	00 00 00 
  800a11:	48 89 18             	mov    %rbx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800a14:	ba 06 00 00 00       	mov    $0x6,%edx
  800a19:	be 01 00 00 00       	mov    $0x1,%esi
  800a1e:	bf 02 00 00 00       	mov    $0x2,%edi
  800a23:	48 b8 07 3a 80 00 00 	movabs $0x803a07,%rax
  800a2a:	00 00 00 
  800a2d:	ff d0                	callq  *%rax
  800a2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800a32:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800a36:	79 16                	jns    800a4e <umain+0x61>
		die("Failed to create socket");
  800a38:	48 bf 78 55 80 00 00 	movabs $0x805578,%rdi
  800a3f:	00 00 00 
  800a42:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a49:	00 00 00 
  800a4c:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800a4e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800a52:	ba 10 00 00 00       	mov    $0x10,%edx
  800a57:	be 00 00 00 00       	mov    $0x0,%esi
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 bf 1c 80 00 00 	movabs $0x801cbf,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800a6b:	c6 45 d1 02          	movb   $0x2,-0x2f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a74:	48 b8 6b 53 80 00 00 	movabs $0x80536b,%rax
  800a7b:	00 00 00 
  800a7e:	ff d0                	callq  *%rax
  800a80:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	server.sin_port = htons(PORT);			// server port
  800a83:	bf 50 00 00 00       	mov    $0x50,%edi
  800a88:	48 b8 26 53 80 00 00 	movabs $0x805326,%rax
  800a8f:	00 00 00 
  800a92:	ff d0                	callq  *%rax
  800a94:	66 89 45 d2          	mov    %ax,-0x2e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800a98:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800a9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800a9f:	ba 10 00 00 00       	mov    $0x10,%edx
  800aa4:	48 89 ce             	mov    %rcx,%rsi
  800aa7:	89 c7                	mov    %eax,%edi
  800aa9:	48 b8 f7 37 80 00 00 	movabs $0x8037f7,%rax
  800ab0:	00 00 00 
  800ab3:	ff d0                	callq  *%rax
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	79 16                	jns    800acf <umain+0xe2>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800ab9:	48 bf 90 55 80 00 00 	movabs $0x805590,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800acf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ad2:	be 05 00 00 00       	mov    $0x5,%esi
  800ad7:	89 c7                	mov    %eax,%edi
  800ad9:	48 b8 1a 39 80 00 00 	movabs $0x80391a,%rax
  800ae0:	00 00 00 
  800ae3:	ff d0                	callq  *%rax
  800ae5:	85 c0                	test   %eax,%eax
  800ae7:	79 16                	jns    800aff <umain+0x112>
		die("Failed to listen on server socket");
  800ae9:	48 bf b8 55 80 00 00 	movabs $0x8055b8,%rdi
  800af0:	00 00 00 
  800af3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800afa:	00 00 00 
  800afd:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  800aff:	48 bf e0 55 80 00 00 	movabs $0x8055e0,%rdi
  800b06:	00 00 00 
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  800b15:	00 00 00 
  800b18:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  800b1a:	c7 45 bc 10 00 00 00 	movl   $0x10,-0x44(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800b21:	48 8d 55 bc          	lea    -0x44(%rbp),%rdx
  800b25:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  800b29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b2c:	48 89 ce             	mov    %rcx,%rsi
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	48 b8 88 37 80 00 00 	movabs $0x803788,%rax
  800b38:	00 00 00 
  800b3b:	ff d0                	callq  *%rax
  800b3d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800b44:	79 16                	jns    800b5c <umain+0x16f>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800b46:	48 bf 08 56 80 00 00 	movabs $0x805608,%rdi
  800b4d:	00 00 00 
  800b50:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800b57:	00 00 00 
  800b5a:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  800b5c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800b5f:	89 c7                	mov    %eax,%edi
  800b61:	48 b8 9e 08 80 00 00 	movabs $0x80089e,%rax
  800b68:	00 00 00 
  800b6b:	ff d0                	callq  *%rax
		cprintf("exiting");
  800b6d:	48 bf 2b 56 80 00 00 	movabs $0x80562b,%rdi
  800b74:	00 00 00 
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7c:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  800b83:	00 00 00 
  800b86:	ff d2                	callq  *%rdx
	}
  800b88:	eb 90                	jmp    800b1a <umain+0x12d>

0000000000800b8a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800b8a:	55                   	push   %rbp
  800b8b:	48 89 e5             	mov    %rsp,%rbp
  800b8e:	48 83 ec 10          	sub    $0x10,%rsp
  800b92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800b99:	48 b8 d9 22 80 00 00 	movabs $0x8022d9,%rax
  800ba0:	00 00 00 
  800ba3:	ff d0                	callq  *%rax
  800ba5:	25 ff 03 00 00       	and    $0x3ff,%eax
  800baa:	48 63 d0             	movslq %eax,%rdx
  800bad:	48 89 d0             	mov    %rdx,%rax
  800bb0:	48 c1 e0 03          	shl    $0x3,%rax
  800bb4:	48 01 d0             	add    %rdx,%rax
  800bb7:	48 c1 e0 05          	shl    $0x5,%rax
  800bbb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800bc2:	00 00 00 
  800bc5:	48 01 c2             	add    %rax,%rdx
  800bc8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800bcf:	00 00 00 
  800bd2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bd9:	7e 14                	jle    800bef <libmain+0x65>
		binaryname = argv[0];
  800bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdf:	48 8b 10             	mov    (%rax),%rdx
  800be2:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800be9:	00 00 00 
  800bec:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bf6:	48 89 d6             	mov    %rdx,%rsi
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	48 b8 ed 09 80 00 00 	movabs $0x8009ed,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800c07:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	callq  *%rax
}
  800c13:	c9                   	leaveq 
  800c14:	c3                   	retq   

0000000000800c15 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800c15:	55                   	push   %rbp
  800c16:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800c19:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800c25:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2a:	48 b8 95 22 80 00 00 	movabs $0x802295,%rax
  800c31:	00 00 00 
  800c34:	ff d0                	callq  *%rax

}
  800c36:	5d                   	pop    %rbp
  800c37:	c3                   	retq   

0000000000800c38 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c38:	55                   	push   %rbp
  800c39:	48 89 e5             	mov    %rsp,%rbp
  800c3c:	53                   	push   %rbx
  800c3d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800c44:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800c4b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800c51:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800c58:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800c5f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800c66:	84 c0                	test   %al,%al
  800c68:	74 23                	je     800c8d <_panic+0x55>
  800c6a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800c71:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800c75:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800c79:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800c7d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800c81:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800c85:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800c89:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800c8d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c94:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800c9b:	00 00 00 
  800c9e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800ca5:	00 00 00 
  800ca8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cac:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800cb3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800cba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800cc1:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800cc8:	00 00 00 
  800ccb:	48 8b 18             	mov    (%rax),%rbx
  800cce:	48 b8 d9 22 80 00 00 	movabs $0x8022d9,%rax
  800cd5:	00 00 00 
  800cd8:	ff d0                	callq  *%rax
  800cda:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800ce0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ce7:	41 89 c8             	mov    %ecx,%r8d
  800cea:	48 89 d1             	mov    %rdx,%rcx
  800ced:	48 89 da             	mov    %rbx,%rdx
  800cf0:	89 c6                	mov    %eax,%esi
  800cf2:	48 bf 40 56 80 00 00 	movabs $0x805640,%rdi
  800cf9:	00 00 00 
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	49 b9 71 0e 80 00 00 	movabs $0x800e71,%r9
  800d08:	00 00 00 
  800d0b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d0e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800d15:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d1c:	48 89 d6             	mov    %rdx,%rsi
  800d1f:	48 89 c7             	mov    %rax,%rdi
  800d22:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  800d29:	00 00 00 
  800d2c:	ff d0                	callq  *%rax
	cprintf("\n");
  800d2e:	48 bf 63 56 80 00 00 	movabs $0x805663,%rdi
  800d35:	00 00 00 
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  800d44:	00 00 00 
  800d47:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d49:	cc                   	int3   
  800d4a:	eb fd                	jmp    800d49 <_panic+0x111>

0000000000800d4c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800d4c:	55                   	push   %rbp
  800d4d:	48 89 e5             	mov    %rsp,%rbp
  800d50:	48 83 ec 10          	sub    $0x10,%rsp
  800d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5f:	8b 00                	mov    (%rax),%eax
  800d61:	8d 48 01             	lea    0x1(%rax),%ecx
  800d64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d68:	89 0a                	mov    %ecx,(%rdx)
  800d6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d6d:	89 d1                	mov    %edx,%ecx
  800d6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d73:	48 98                	cltq   
  800d75:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7d:	8b 00                	mov    (%rax),%eax
  800d7f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d84:	75 2c                	jne    800db2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8a:	8b 00                	mov    (%rax),%eax
  800d8c:	48 98                	cltq   
  800d8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d92:	48 83 c2 08          	add    $0x8,%rdx
  800d96:	48 89 c6             	mov    %rax,%rsi
  800d99:	48 89 d7             	mov    %rdx,%rdi
  800d9c:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	callq  *%rax
        b->idx = 0;
  800da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db6:	8b 40 04             	mov    0x4(%rax),%eax
  800db9:	8d 50 01             	lea    0x1(%rax),%edx
  800dbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc0:	89 50 04             	mov    %edx,0x4(%rax)
}
  800dc3:	c9                   	leaveq 
  800dc4:	c3                   	retq   

0000000000800dc5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800dd0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800dd7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800dde:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800de5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800dec:	48 8b 0a             	mov    (%rdx),%rcx
  800def:	48 89 08             	mov    %rcx,(%rax)
  800df2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dfa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dfe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800e02:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800e09:	00 00 00 
    b.cnt = 0;
  800e0c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800e13:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800e16:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800e1d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800e24:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800e2b:	48 89 c6             	mov    %rax,%rsi
  800e2e:	48 bf 4c 0d 80 00 00 	movabs $0x800d4c,%rdi
  800e35:	00 00 00 
  800e38:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  800e3f:	00 00 00 
  800e42:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800e44:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800e4a:	48 98                	cltq   
  800e4c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800e53:	48 83 c2 08          	add    $0x8,%rdx
  800e57:	48 89 c6             	mov    %rax,%rsi
  800e5a:	48 89 d7             	mov    %rdx,%rdi
  800e5d:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800e69:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800e6f:	c9                   	leaveq 
  800e70:	c3                   	retq   

0000000000800e71 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800e71:	55                   	push   %rbp
  800e72:	48 89 e5             	mov    %rsp,%rbp
  800e75:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800e7c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800e83:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800e8a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e91:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e98:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e9f:	84 c0                	test   %al,%al
  800ea1:	74 20                	je     800ec3 <cprintf+0x52>
  800ea3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ea7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eaf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eb3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eb7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ebb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ebf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ec3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800eca:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800ed1:	00 00 00 
  800ed4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800edb:	00 00 00 
  800ede:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ee2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ee9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ef0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800ef7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800efe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f05:	48 8b 0a             	mov    (%rdx),%rcx
  800f08:	48 89 08             	mov    %rcx,(%rax)
  800f0b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f0f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f13:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f17:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800f1b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800f22:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f29:	48 89 d6             	mov    %rdx,%rsi
  800f2c:	48 89 c7             	mov    %rax,%rdi
  800f2f:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
  800f3b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800f41:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f47:	c9                   	leaveq 
  800f48:	c3                   	retq   

0000000000800f49 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f49:	55                   	push   %rbp
  800f4a:	48 89 e5             	mov    %rsp,%rbp
  800f4d:	53                   	push   %rbx
  800f4e:	48 83 ec 38          	sub    $0x38,%rsp
  800f52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800f5e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800f61:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800f65:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f69:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800f6c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f70:	77 3b                	ja     800fad <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f72:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800f75:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800f79:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800f7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f80:	ba 00 00 00 00       	mov    $0x0,%edx
  800f85:	48 f7 f3             	div    %rbx
  800f88:	48 89 c2             	mov    %rax,%rdx
  800f8b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800f8e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800f91:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	41 89 f9             	mov    %edi,%r9d
  800f9c:	48 89 c7             	mov    %rax,%rdi
  800f9f:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	callq  *%rax
  800fab:	eb 1e                	jmp    800fcb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fad:	eb 12                	jmp    800fc1 <printnum+0x78>
			putch(padc, putdat);
  800faf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800fb3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fba:	48 89 ce             	mov    %rcx,%rsi
  800fbd:	89 d7                	mov    %edx,%edi
  800fbf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fc1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800fc5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800fc9:	7f e4                	jg     800faf <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fcb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800fce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd7:	48 f7 f1             	div    %rcx
  800fda:	48 89 d0             	mov    %rdx,%rax
  800fdd:	48 ba 70 58 80 00 00 	movabs $0x805870,%rdx
  800fe4:	00 00 00 
  800fe7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800feb:	0f be d0             	movsbl %al,%edx
  800fee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	48 89 ce             	mov    %rcx,%rsi
  800ff9:	89 d7                	mov    %edx,%edi
  800ffb:	ff d0                	callq  *%rax
}
  800ffd:	48 83 c4 38          	add    $0x38,%rsp
  801001:	5b                   	pop    %rbx
  801002:	5d                   	pop    %rbp
  801003:	c3                   	retq   

0000000000801004 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801004:	55                   	push   %rbp
  801005:	48 89 e5             	mov    %rsp,%rbp
  801008:	48 83 ec 1c          	sub    $0x1c,%rsp
  80100c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801010:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801013:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801017:	7e 52                	jle    80106b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101d:	8b 00                	mov    (%rax),%eax
  80101f:	83 f8 30             	cmp    $0x30,%eax
  801022:	73 24                	jae    801048 <getuint+0x44>
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801028:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	8b 00                	mov    (%rax),%eax
  801032:	89 c0                	mov    %eax,%eax
  801034:	48 01 d0             	add    %rdx,%rax
  801037:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103b:	8b 12                	mov    (%rdx),%edx
  80103d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801040:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801044:	89 0a                	mov    %ecx,(%rdx)
  801046:	eb 17                	jmp    80105f <getuint+0x5b>
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801050:	48 89 d0             	mov    %rdx,%rax
  801053:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801057:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80105f:	48 8b 00             	mov    (%rax),%rax
  801062:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801066:	e9 a3 00 00 00       	jmpq   80110e <getuint+0x10a>
	else if (lflag)
  80106b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80106f:	74 4f                	je     8010c0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	8b 00                	mov    (%rax),%eax
  801077:	83 f8 30             	cmp    $0x30,%eax
  80107a:	73 24                	jae    8010a0 <getuint+0x9c>
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801088:	8b 00                	mov    (%rax),%eax
  80108a:	89 c0                	mov    %eax,%eax
  80108c:	48 01 d0             	add    %rdx,%rax
  80108f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801093:	8b 12                	mov    (%rdx),%edx
  801095:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801098:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109c:	89 0a                	mov    %ecx,(%rdx)
  80109e:	eb 17                	jmp    8010b7 <getuint+0xb3>
  8010a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010a8:	48 89 d0             	mov    %rdx,%rax
  8010ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010b7:	48 8b 00             	mov    (%rax),%rax
  8010ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8010be:	eb 4e                	jmp    80110e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	8b 00                	mov    (%rax),%eax
  8010c6:	83 f8 30             	cmp    $0x30,%eax
  8010c9:	73 24                	jae    8010ef <getuint+0xeb>
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d7:	8b 00                	mov    (%rax),%eax
  8010d9:	89 c0                	mov    %eax,%eax
  8010db:	48 01 d0             	add    %rdx,%rax
  8010de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e2:	8b 12                	mov    (%rdx),%edx
  8010e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010eb:	89 0a                	mov    %ecx,(%rdx)
  8010ed:	eb 17                	jmp    801106 <getuint+0x102>
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010f7:	48 89 d0             	mov    %rdx,%rax
  8010fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801102:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801106:	8b 00                	mov    (%rax),%eax
  801108:	89 c0                	mov    %eax,%eax
  80110a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80110e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801112:	c9                   	leaveq 
  801113:	c3                   	retq   

0000000000801114 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	48 83 ec 1c          	sub    $0x1c,%rsp
  80111c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801120:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801123:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801127:	7e 52                	jle    80117b <getint+0x67>
		x=va_arg(*ap, long long);
  801129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112d:	8b 00                	mov    (%rax),%eax
  80112f:	83 f8 30             	cmp    $0x30,%eax
  801132:	73 24                	jae    801158 <getint+0x44>
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80113c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801140:	8b 00                	mov    (%rax),%eax
  801142:	89 c0                	mov    %eax,%eax
  801144:	48 01 d0             	add    %rdx,%rax
  801147:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80114b:	8b 12                	mov    (%rdx),%edx
  80114d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801150:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801154:	89 0a                	mov    %ecx,(%rdx)
  801156:	eb 17                	jmp    80116f <getint+0x5b>
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801160:	48 89 d0             	mov    %rdx,%rax
  801163:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801167:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80116b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80116f:	48 8b 00             	mov    (%rax),%rax
  801172:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801176:	e9 a3 00 00 00       	jmpq   80121e <getint+0x10a>
	else if (lflag)
  80117b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80117f:	74 4f                	je     8011d0 <getint+0xbc>
		x=va_arg(*ap, long);
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	8b 00                	mov    (%rax),%eax
  801187:	83 f8 30             	cmp    $0x30,%eax
  80118a:	73 24                	jae    8011b0 <getint+0x9c>
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	8b 00                	mov    (%rax),%eax
  80119a:	89 c0                	mov    %eax,%eax
  80119c:	48 01 d0             	add    %rdx,%rax
  80119f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a3:	8b 12                	mov    (%rdx),%edx
  8011a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ac:	89 0a                	mov    %ecx,(%rdx)
  8011ae:	eb 17                	jmp    8011c7 <getint+0xb3>
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011b8:	48 89 d0             	mov    %rdx,%rax
  8011bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011c7:	48 8b 00             	mov    (%rax),%rax
  8011ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011ce:	eb 4e                	jmp    80121e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	8b 00                	mov    (%rax),%eax
  8011d6:	83 f8 30             	cmp    $0x30,%eax
  8011d9:	73 24                	jae    8011ff <getint+0xeb>
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	8b 00                	mov    (%rax),%eax
  8011e9:	89 c0                	mov    %eax,%eax
  8011eb:	48 01 d0             	add    %rdx,%rax
  8011ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f2:	8b 12                	mov    (%rdx),%edx
  8011f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011fb:	89 0a                	mov    %ecx,(%rdx)
  8011fd:	eb 17                	jmp    801216 <getint+0x102>
  8011ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801203:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801207:	48 89 d0             	mov    %rdx,%rax
  80120a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80120e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801212:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801216:	8b 00                	mov    (%rax),%eax
  801218:	48 98                	cltq   
  80121a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	41 54                	push   %r12
  80122a:	53                   	push   %rbx
  80122b:	48 83 ec 60          	sub    $0x60,%rsp
  80122f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801233:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801237:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80123b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80123f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801243:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801247:	48 8b 0a             	mov    (%rdx),%rcx
  80124a:	48 89 08             	mov    %rcx,(%rax)
  80124d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801251:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801255:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801259:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80125d:	eb 17                	jmp    801276 <vprintfmt+0x52>
			if (ch == '\0')
  80125f:	85 db                	test   %ebx,%ebx
  801261:	0f 84 cc 04 00 00    	je     801733 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801267:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80126b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80126f:	48 89 d6             	mov    %rdx,%rsi
  801272:	89 df                	mov    %ebx,%edi
  801274:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801276:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80127a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80127e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801282:	0f b6 00             	movzbl (%rax),%eax
  801285:	0f b6 d8             	movzbl %al,%ebx
  801288:	83 fb 25             	cmp    $0x25,%ebx
  80128b:	75 d2                	jne    80125f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80128d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801291:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801298:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80129f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8012a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012ad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8012b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	0f b6 d8             	movzbl %al,%ebx
  8012bf:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8012c2:	83 f8 55             	cmp    $0x55,%eax
  8012c5:	0f 87 34 04 00 00    	ja     8016ff <vprintfmt+0x4db>
  8012cb:	89 c0                	mov    %eax,%eax
  8012cd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8012d4:	00 
  8012d5:	48 b8 98 58 80 00 00 	movabs $0x805898,%rax
  8012dc:	00 00 00 
  8012df:	48 01 d0             	add    %rdx,%rax
  8012e2:	48 8b 00             	mov    (%rax),%rax
  8012e5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8012e7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8012eb:	eb c0                	jmp    8012ad <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012ed:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8012f1:	eb ba                	jmp    8012ad <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012f3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8012fa:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8012fd:	89 d0                	mov    %edx,%eax
  8012ff:	c1 e0 02             	shl    $0x2,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d8                	add    %ebx,%eax
  801308:	83 e8 30             	sub    $0x30,%eax
  80130b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80130e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801312:	0f b6 00             	movzbl (%rax),%eax
  801315:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801318:	83 fb 2f             	cmp    $0x2f,%ebx
  80131b:	7e 0c                	jle    801329 <vprintfmt+0x105>
  80131d:	83 fb 39             	cmp    $0x39,%ebx
  801320:	7f 07                	jg     801329 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801322:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801327:	eb d1                	jmp    8012fa <vprintfmt+0xd6>
			goto process_precision;
  801329:	eb 58                	jmp    801383 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80132b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80132e:	83 f8 30             	cmp    $0x30,%eax
  801331:	73 17                	jae    80134a <vprintfmt+0x126>
  801333:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801337:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80133a:	89 c0                	mov    %eax,%eax
  80133c:	48 01 d0             	add    %rdx,%rax
  80133f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801342:	83 c2 08             	add    $0x8,%edx
  801345:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801348:	eb 0f                	jmp    801359 <vprintfmt+0x135>
  80134a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80134e:	48 89 d0             	mov    %rdx,%rax
  801351:	48 83 c2 08          	add    $0x8,%rdx
  801355:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801359:	8b 00                	mov    (%rax),%eax
  80135b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80135e:	eb 23                	jmp    801383 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801360:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801364:	79 0c                	jns    801372 <vprintfmt+0x14e>
				width = 0;
  801366:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80136d:	e9 3b ff ff ff       	jmpq   8012ad <vprintfmt+0x89>
  801372:	e9 36 ff ff ff       	jmpq   8012ad <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801377:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80137e:	e9 2a ff ff ff       	jmpq   8012ad <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801383:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801387:	79 12                	jns    80139b <vprintfmt+0x177>
				width = precision, precision = -1;
  801389:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80138c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80138f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801396:	e9 12 ff ff ff       	jmpq   8012ad <vprintfmt+0x89>
  80139b:	e9 0d ff ff ff       	jmpq   8012ad <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8013a0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8013a4:	e9 04 ff ff ff       	jmpq   8012ad <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8013a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013ac:	83 f8 30             	cmp    $0x30,%eax
  8013af:	73 17                	jae    8013c8 <vprintfmt+0x1a4>
  8013b1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013b8:	89 c0                	mov    %eax,%eax
  8013ba:	48 01 d0             	add    %rdx,%rax
  8013bd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013c0:	83 c2 08             	add    $0x8,%edx
  8013c3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013c6:	eb 0f                	jmp    8013d7 <vprintfmt+0x1b3>
  8013c8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013cc:	48 89 d0             	mov    %rdx,%rax
  8013cf:	48 83 c2 08          	add    $0x8,%rdx
  8013d3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013d7:	8b 10                	mov    (%rax),%edx
  8013d9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e1:	48 89 ce             	mov    %rcx,%rsi
  8013e4:	89 d7                	mov    %edx,%edi
  8013e6:	ff d0                	callq  *%rax
			break;
  8013e8:	e9 40 03 00 00       	jmpq   80172d <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8013ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013f0:	83 f8 30             	cmp    $0x30,%eax
  8013f3:	73 17                	jae    80140c <vprintfmt+0x1e8>
  8013f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013fc:	89 c0                	mov    %eax,%eax
  8013fe:	48 01 d0             	add    %rdx,%rax
  801401:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801404:	83 c2 08             	add    $0x8,%edx
  801407:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80140a:	eb 0f                	jmp    80141b <vprintfmt+0x1f7>
  80140c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801410:	48 89 d0             	mov    %rdx,%rax
  801413:	48 83 c2 08          	add    $0x8,%rdx
  801417:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80141b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80141d:	85 db                	test   %ebx,%ebx
  80141f:	79 02                	jns    801423 <vprintfmt+0x1ff>
				err = -err;
  801421:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801423:	83 fb 15             	cmp    $0x15,%ebx
  801426:	7f 16                	jg     80143e <vprintfmt+0x21a>
  801428:	48 b8 c0 57 80 00 00 	movabs $0x8057c0,%rax
  80142f:	00 00 00 
  801432:	48 63 d3             	movslq %ebx,%rdx
  801435:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801439:	4d 85 e4             	test   %r12,%r12
  80143c:	75 2e                	jne    80146c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80143e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801442:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801446:	89 d9                	mov    %ebx,%ecx
  801448:	48 ba 81 58 80 00 00 	movabs $0x805881,%rdx
  80144f:	00 00 00 
  801452:	48 89 c7             	mov    %rax,%rdi
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	49 b8 3c 17 80 00 00 	movabs $0x80173c,%r8
  801461:	00 00 00 
  801464:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801467:	e9 c1 02 00 00       	jmpq   80172d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80146c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801470:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801474:	4c 89 e1             	mov    %r12,%rcx
  801477:	48 ba 8a 58 80 00 00 	movabs $0x80588a,%rdx
  80147e:	00 00 00 
  801481:	48 89 c7             	mov    %rax,%rdi
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	49 b8 3c 17 80 00 00 	movabs $0x80173c,%r8
  801490:	00 00 00 
  801493:	41 ff d0             	callq  *%r8
			break;
  801496:	e9 92 02 00 00       	jmpq   80172d <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80149b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80149e:	83 f8 30             	cmp    $0x30,%eax
  8014a1:	73 17                	jae    8014ba <vprintfmt+0x296>
  8014a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014aa:	89 c0                	mov    %eax,%eax
  8014ac:	48 01 d0             	add    %rdx,%rax
  8014af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b2:	83 c2 08             	add    $0x8,%edx
  8014b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014b8:	eb 0f                	jmp    8014c9 <vprintfmt+0x2a5>
  8014ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014be:	48 89 d0             	mov    %rdx,%rax
  8014c1:	48 83 c2 08          	add    $0x8,%rdx
  8014c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014c9:	4c 8b 20             	mov    (%rax),%r12
  8014cc:	4d 85 e4             	test   %r12,%r12
  8014cf:	75 0a                	jne    8014db <vprintfmt+0x2b7>
				p = "(null)";
  8014d1:	49 bc 8d 58 80 00 00 	movabs $0x80588d,%r12
  8014d8:	00 00 00 
			if (width > 0 && padc != '-')
  8014db:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8014df:	7e 3f                	jle    801520 <vprintfmt+0x2fc>
  8014e1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8014e5:	74 39                	je     801520 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8014e7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8014ea:	48 98                	cltq   
  8014ec:	48 89 c6             	mov    %rax,%rsi
  8014ef:	4c 89 e7             	mov    %r12,%rdi
  8014f2:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  8014f9:	00 00 00 
  8014fc:	ff d0                	callq  *%rax
  8014fe:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801501:	eb 17                	jmp    80151a <vprintfmt+0x2f6>
					putch(padc, putdat);
  801503:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801507:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80150b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80150f:	48 89 ce             	mov    %rcx,%rsi
  801512:	89 d7                	mov    %edx,%edi
  801514:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801516:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80151a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80151e:	7f e3                	jg     801503 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801520:	eb 37                	jmp    801559 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801522:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801526:	74 1e                	je     801546 <vprintfmt+0x322>
  801528:	83 fb 1f             	cmp    $0x1f,%ebx
  80152b:	7e 05                	jle    801532 <vprintfmt+0x30e>
  80152d:	83 fb 7e             	cmp    $0x7e,%ebx
  801530:	7e 14                	jle    801546 <vprintfmt+0x322>
					putch('?', putdat);
  801532:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801536:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80153a:	48 89 d6             	mov    %rdx,%rsi
  80153d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801542:	ff d0                	callq  *%rax
  801544:	eb 0f                	jmp    801555 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801546:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80154a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80154e:	48 89 d6             	mov    %rdx,%rsi
  801551:	89 df                	mov    %ebx,%edi
  801553:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801555:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801559:	4c 89 e0             	mov    %r12,%rax
  80155c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	0f be d8             	movsbl %al,%ebx
  801566:	85 db                	test   %ebx,%ebx
  801568:	74 10                	je     80157a <vprintfmt+0x356>
  80156a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80156e:	78 b2                	js     801522 <vprintfmt+0x2fe>
  801570:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801574:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801578:	79 a8                	jns    801522 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80157a:	eb 16                	jmp    801592 <vprintfmt+0x36e>
				putch(' ', putdat);
  80157c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801580:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801584:	48 89 d6             	mov    %rdx,%rsi
  801587:	bf 20 00 00 00       	mov    $0x20,%edi
  80158c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80158e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801592:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801596:	7f e4                	jg     80157c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801598:	e9 90 01 00 00       	jmpq   80172d <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80159d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8015a1:	be 03 00 00 00       	mov    $0x3,%esi
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 b8 14 11 80 00 00 	movabs $0x801114,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8015b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bd:	48 85 c0             	test   %rax,%rax
  8015c0:	79 1d                	jns    8015df <vprintfmt+0x3bb>
				putch('-', putdat);
  8015c2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ca:	48 89 d6             	mov    %rdx,%rsi
  8015cd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8015d2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8015d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d8:	48 f7 d8             	neg    %rax
  8015db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8015df:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8015e6:	e9 d5 00 00 00       	jmpq   8016c0 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8015eb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8015ef:	be 03 00 00 00       	mov    $0x3,%esi
  8015f4:	48 89 c7             	mov    %rax,%rdi
  8015f7:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8015fe:	00 00 00 
  801601:	ff d0                	callq  *%rax
  801603:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801607:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80160e:	e9 ad 00 00 00       	jmpq   8016c0 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801613:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801616:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80161a:	89 d6                	mov    %edx,%esi
  80161c:	48 89 c7             	mov    %rax,%rdi
  80161f:	48 b8 14 11 80 00 00 	movabs $0x801114,%rax
  801626:	00 00 00 
  801629:	ff d0                	callq  *%rax
  80162b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80162f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801636:	e9 85 00 00 00       	jmpq   8016c0 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  80163b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80163f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801643:	48 89 d6             	mov    %rdx,%rsi
  801646:	bf 30 00 00 00       	mov    $0x30,%edi
  80164b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80164d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801651:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801655:	48 89 d6             	mov    %rdx,%rsi
  801658:	bf 78 00 00 00       	mov    $0x78,%edi
  80165d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80165f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801662:	83 f8 30             	cmp    $0x30,%eax
  801665:	73 17                	jae    80167e <vprintfmt+0x45a>
  801667:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80166b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80166e:	89 c0                	mov    %eax,%eax
  801670:	48 01 d0             	add    %rdx,%rax
  801673:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801676:	83 c2 08             	add    $0x8,%edx
  801679:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80167c:	eb 0f                	jmp    80168d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80167e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801682:	48 89 d0             	mov    %rdx,%rax
  801685:	48 83 c2 08          	add    $0x8,%rdx
  801689:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80168d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801690:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801694:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80169b:	eb 23                	jmp    8016c0 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80169d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016a1:	be 03 00 00 00       	mov    $0x3,%esi
  8016a6:	48 89 c7             	mov    %rax,%rdi
  8016a9:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8016b0:	00 00 00 
  8016b3:	ff d0                	callq  *%rax
  8016b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8016b9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016c0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8016c5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8016c8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8016cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016cf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8016d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016d7:	45 89 c1             	mov    %r8d,%r9d
  8016da:	41 89 f8             	mov    %edi,%r8d
  8016dd:	48 89 c7             	mov    %rax,%rdi
  8016e0:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  8016e7:	00 00 00 
  8016ea:	ff d0                	callq  *%rax
			break;
  8016ec:	eb 3f                	jmp    80172d <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016f6:	48 89 d6             	mov    %rdx,%rsi
  8016f9:	89 df                	mov    %ebx,%edi
  8016fb:	ff d0                	callq  *%rax
			break;
  8016fd:	eb 2e                	jmp    80172d <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801703:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801707:	48 89 d6             	mov    %rdx,%rsi
  80170a:	bf 25 00 00 00       	mov    $0x25,%edi
  80170f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801711:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801716:	eb 05                	jmp    80171d <vprintfmt+0x4f9>
  801718:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80171d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801721:	48 83 e8 01          	sub    $0x1,%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 25                	cmp    $0x25,%al
  80172a:	75 ec                	jne    801718 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80172c:	90                   	nop
		}
	}
  80172d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80172e:	e9 43 fb ff ff       	jmpq   801276 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801733:	48 83 c4 60          	add    $0x60,%rsp
  801737:	5b                   	pop    %rbx
  801738:	41 5c                	pop    %r12
  80173a:	5d                   	pop    %rbp
  80173b:	c3                   	retq   

000000000080173c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801747:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80174e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801755:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80175c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801763:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80176a:	84 c0                	test   %al,%al
  80176c:	74 20                	je     80178e <printfmt+0x52>
  80176e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801772:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801776:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80177a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80177e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801782:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801786:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80178a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80178e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801795:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80179c:	00 00 00 
  80179f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8017a6:	00 00 00 
  8017a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8017b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8017bb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8017c2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8017c9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017d0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8017d7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8017de:	48 89 c7             	mov    %rax,%rdi
  8017e1:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8017e8:	00 00 00 
  8017eb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8017ed:	c9                   	leaveq 
  8017ee:	c3                   	retq   

00000000008017ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017ef:	55                   	push   %rbp
  8017f0:	48 89 e5             	mov    %rsp,%rbp
  8017f3:	48 83 ec 10          	sub    $0x10,%rsp
  8017f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8017fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801802:	8b 40 10             	mov    0x10(%rax),%eax
  801805:	8d 50 01             	lea    0x1(%rax),%edx
  801808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80180f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801813:	48 8b 10             	mov    (%rax),%rdx
  801816:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80181e:	48 39 c2             	cmp    %rax,%rdx
  801821:	73 17                	jae    80183a <sprintputch+0x4b>
		*b->buf++ = ch;
  801823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801827:	48 8b 00             	mov    (%rax),%rax
  80182a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80182e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801832:	48 89 0a             	mov    %rcx,(%rdx)
  801835:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801838:	88 10                	mov    %dl,(%rax)
}
  80183a:	c9                   	leaveq 
  80183b:	c3                   	retq   

000000000080183c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	48 83 ec 50          	sub    $0x50,%rsp
  801844:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801848:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80184b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80184f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801853:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801857:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80185b:	48 8b 0a             	mov    (%rdx),%rcx
  80185e:	48 89 08             	mov    %rcx,(%rax)
  801861:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801865:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801869:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80186d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801871:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801875:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801879:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80187c:	48 98                	cltq   
  80187e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801882:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801886:	48 01 d0             	add    %rdx,%rax
  801889:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80188d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801894:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801899:	74 06                	je     8018a1 <vsnprintf+0x65>
  80189b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80189f:	7f 07                	jg     8018a8 <vsnprintf+0x6c>
		return -E_INVAL;
  8018a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a6:	eb 2f                	jmp    8018d7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8018a8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8018ac:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8018b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8018b4:	48 89 c6             	mov    %rax,%rsi
  8018b7:	48 bf ef 17 80 00 00 	movabs $0x8017ef,%rdi
  8018be:	00 00 00 
  8018c1:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8018cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8018d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8018e4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8018eb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8018f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8018f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8018ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801906:	84 c0                	test   %al,%al
  801908:	74 20                	je     80192a <snprintf+0x51>
  80190a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80190e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801912:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801916:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80191a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80191e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801922:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801926:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80192a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801931:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801938:	00 00 00 
  80193b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801942:	00 00 00 
  801945:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801949:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801950:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801957:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80195e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801965:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80196c:	48 8b 0a             	mov    (%rdx),%rcx
  80196f:	48 89 08             	mov    %rcx,(%rax)
  801972:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801976:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80197a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80197e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801982:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801989:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801990:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801996:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80199d:	48 89 c7             	mov    %rax,%rdi
  8019a0:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax
  8019ac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8019b2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8019b8:	c9                   	leaveq 
  8019b9:	c3                   	retq   

00000000008019ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	48 83 ec 18          	sub    $0x18,%rsp
  8019c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8019c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8019cd:	eb 09                	jmp    8019d8 <strlen+0x1e>
		n++;
  8019cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8019d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019dc:	0f b6 00             	movzbl (%rax),%eax
  8019df:	84 c0                	test   %al,%al
  8019e1:	75 ec                	jne    8019cf <strlen+0x15>
		n++;
	return n;
  8019e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 20          	sub    $0x20,%rsp
  8019f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8019ff:	eb 0e                	jmp    801a0f <strnlen+0x27>
		n++;
  801a01:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a05:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a0a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801a0f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a14:	74 0b                	je     801a21 <strnlen+0x39>
  801a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1a:	0f b6 00             	movzbl (%rax),%eax
  801a1d:	84 c0                	test   %al,%al
  801a1f:	75 e0                	jne    801a01 <strnlen+0x19>
		n++;
	return n;
  801a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a24:	c9                   	leaveq 
  801a25:	c3                   	retq   

0000000000801a26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801a26:	55                   	push   %rbp
  801a27:	48 89 e5             	mov    %rsp,%rbp
  801a2a:	48 83 ec 20          	sub    $0x20,%rsp
  801a2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801a3e:	90                   	nop
  801a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a4f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a53:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a57:	0f b6 12             	movzbl (%rdx),%edx
  801a5a:	88 10                	mov    %dl,(%rax)
  801a5c:	0f b6 00             	movzbl (%rax),%eax
  801a5f:	84 c0                	test   %al,%al
  801a61:	75 dc                	jne    801a3f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a67:	c9                   	leaveq 
  801a68:	c3                   	retq   

0000000000801a69 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801a69:	55                   	push   %rbp
  801a6a:	48 89 e5             	mov    %rsp,%rbp
  801a6d:	48 83 ec 20          	sub    $0x20,%rsp
  801a71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801a79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a7d:	48 89 c7             	mov    %rax,%rdi
  801a80:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
  801a8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a92:	48 63 d0             	movslq %eax,%rdx
  801a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a99:	48 01 c2             	add    %rax,%rdx
  801a9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aa0:	48 89 c6             	mov    %rax,%rsi
  801aa3:	48 89 d7             	mov    %rdx,%rdi
  801aa6:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  801aad:	00 00 00 
  801ab0:	ff d0                	callq  *%rax
	return dst;
  801ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 28          	sub    $0x28,%rsp
  801ac0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ac4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ac8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801ad4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801adb:	00 
  801adc:	eb 2a                	jmp    801b08 <strncpy+0x50>
		*dst++ = *src;
  801ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ae6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801aee:	0f b6 12             	movzbl (%rdx),%edx
  801af1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801af3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af7:	0f b6 00             	movzbl (%rax),%eax
  801afa:	84 c0                	test   %al,%al
  801afc:	74 05                	je     801b03 <strncpy+0x4b>
			src++;
  801afe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b03:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801b10:	72 cc                	jb     801ade <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b16:	c9                   	leaveq 
  801b17:	c3                   	retq   

0000000000801b18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
  801b1c:	48 83 ec 28          	sub    $0x28,%rsp
  801b20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801b34:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801b39:	74 3d                	je     801b78 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801b3b:	eb 1d                	jmp    801b5a <strlcpy+0x42>
			*dst++ = *src++;
  801b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b45:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b49:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b4d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b51:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b55:	0f b6 12             	movzbl (%rdx),%edx
  801b58:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801b5a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801b5f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801b64:	74 0b                	je     801b71 <strlcpy+0x59>
  801b66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b6a:	0f b6 00             	movzbl (%rax),%eax
  801b6d:	84 c0                	test   %al,%al
  801b6f:	75 cc                	jne    801b3d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b75:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801b78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b80:	48 29 c2             	sub    %rax,%rdx
  801b83:	48 89 d0             	mov    %rdx,%rax
}
  801b86:	c9                   	leaveq 
  801b87:	c3                   	retq   

0000000000801b88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801b88:	55                   	push   %rbp
  801b89:	48 89 e5             	mov    %rsp,%rbp
  801b8c:	48 83 ec 10          	sub    $0x10,%rsp
  801b90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801b98:	eb 0a                	jmp    801ba4 <strcmp+0x1c>
		p++, q++;
  801b9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b9f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba8:	0f b6 00             	movzbl (%rax),%eax
  801bab:	84 c0                	test   %al,%al
  801bad:	74 12                	je     801bc1 <strcmp+0x39>
  801baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb3:	0f b6 10             	movzbl (%rax),%edx
  801bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bba:	0f b6 00             	movzbl (%rax),%eax
  801bbd:	38 c2                	cmp    %al,%dl
  801bbf:	74 d9                	je     801b9a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc5:	0f b6 00             	movzbl (%rax),%eax
  801bc8:	0f b6 d0             	movzbl %al,%edx
  801bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bcf:	0f b6 00             	movzbl (%rax),%eax
  801bd2:	0f b6 c0             	movzbl %al,%eax
  801bd5:	29 c2                	sub    %eax,%edx
  801bd7:	89 d0                	mov    %edx,%eax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 18          	sub    $0x18,%rsp
  801be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801beb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801bef:	eb 0f                	jmp    801c00 <strncmp+0x25>
		n--, p++, q++;
  801bf1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801bf6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bfb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801c00:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c05:	74 1d                	je     801c24 <strncmp+0x49>
  801c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0b:	0f b6 00             	movzbl (%rax),%eax
  801c0e:	84 c0                	test   %al,%al
  801c10:	74 12                	je     801c24 <strncmp+0x49>
  801c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c16:	0f b6 10             	movzbl (%rax),%edx
  801c19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c1d:	0f b6 00             	movzbl (%rax),%eax
  801c20:	38 c2                	cmp    %al,%dl
  801c22:	74 cd                	je     801bf1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801c24:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c29:	75 07                	jne    801c32 <strncmp+0x57>
		return 0;
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	eb 18                	jmp    801c4a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	0f b6 00             	movzbl (%rax),%eax
  801c39:	0f b6 d0             	movzbl %al,%edx
  801c3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c40:	0f b6 00             	movzbl (%rax),%eax
  801c43:	0f b6 c0             	movzbl %al,%eax
  801c46:	29 c2                	sub    %eax,%edx
  801c48:	89 d0                	mov    %edx,%eax
}
  801c4a:	c9                   	leaveq 
  801c4b:	c3                   	retq   

0000000000801c4c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c4c:	55                   	push   %rbp
  801c4d:	48 89 e5             	mov    %rsp,%rbp
  801c50:	48 83 ec 0c          	sub    $0xc,%rsp
  801c54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c58:	89 f0                	mov    %esi,%eax
  801c5a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801c5d:	eb 17                	jmp    801c76 <strchr+0x2a>
		if (*s == c)
  801c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c63:	0f b6 00             	movzbl (%rax),%eax
  801c66:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801c69:	75 06                	jne    801c71 <strchr+0x25>
			return (char *) s;
  801c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6f:	eb 15                	jmp    801c86 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c71:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c7a:	0f b6 00             	movzbl (%rax),%eax
  801c7d:	84 c0                	test   %al,%al
  801c7f:	75 de                	jne    801c5f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 0c          	sub    $0xc,%rsp
  801c90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c94:	89 f0                	mov    %esi,%eax
  801c96:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801c99:	eb 13                	jmp    801cae <strfind+0x26>
		if (*s == c)
  801c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9f:	0f b6 00             	movzbl (%rax),%eax
  801ca2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801ca5:	75 02                	jne    801ca9 <strfind+0x21>
			break;
  801ca7:	eb 10                	jmp    801cb9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ca9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb2:	0f b6 00             	movzbl (%rax),%eax
  801cb5:	84 c0                	test   %al,%al
  801cb7:	75 e2                	jne    801c9b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801cbd:	c9                   	leaveq 
  801cbe:	c3                   	retq   

0000000000801cbf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cbf:	55                   	push   %rbp
  801cc0:	48 89 e5             	mov    %rsp,%rbp
  801cc3:	48 83 ec 18          	sub    $0x18,%rsp
  801cc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ccb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801cce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801cd2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cd7:	75 06                	jne    801cdf <memset+0x20>
		return v;
  801cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdd:	eb 69                	jmp    801d48 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801cdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce3:	83 e0 03             	and    $0x3,%eax
  801ce6:	48 85 c0             	test   %rax,%rax
  801ce9:	75 48                	jne    801d33 <memset+0x74>
  801ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cef:	83 e0 03             	and    $0x3,%eax
  801cf2:	48 85 c0             	test   %rax,%rax
  801cf5:	75 3c                	jne    801d33 <memset+0x74>
		c &= 0xFF;
  801cf7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cfe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d01:	c1 e0 18             	shl    $0x18,%eax
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d09:	c1 e0 10             	shl    $0x10,%eax
  801d0c:	09 c2                	or     %eax,%edx
  801d0e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d11:	c1 e0 08             	shl    $0x8,%eax
  801d14:	09 d0                	or     %edx,%eax
  801d16:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801d19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1d:	48 c1 e8 02          	shr    $0x2,%rax
  801d21:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801d24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d2b:	48 89 d7             	mov    %rdx,%rdi
  801d2e:	fc                   	cld    
  801d2f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801d31:	eb 11                	jmp    801d44 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3e:	48 89 d7             	mov    %rdx,%rdi
  801d41:	fc                   	cld    
  801d42:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d48:	c9                   	leaveq 
  801d49:	c3                   	retq   

0000000000801d4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	48 83 ec 28          	sub    $0x28,%rsp
  801d52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801d5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801d6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d72:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d76:	0f 83 88 00 00 00    	jae    801e04 <memmove+0xba>
  801d7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d80:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d84:	48 01 d0             	add    %rdx,%rax
  801d87:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d8b:	76 77                	jbe    801e04 <memmove+0xba>
		s += n;
  801d8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d91:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801d95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d99:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801d9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da1:	83 e0 03             	and    $0x3,%eax
  801da4:	48 85 c0             	test   %rax,%rax
  801da7:	75 3b                	jne    801de4 <memmove+0x9a>
  801da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dad:	83 e0 03             	and    $0x3,%eax
  801db0:	48 85 c0             	test   %rax,%rax
  801db3:	75 2f                	jne    801de4 <memmove+0x9a>
  801db5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db9:	83 e0 03             	and    $0x3,%eax
  801dbc:	48 85 c0             	test   %rax,%rax
  801dbf:	75 23                	jne    801de4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc5:	48 83 e8 04          	sub    $0x4,%rax
  801dc9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dcd:	48 83 ea 04          	sub    $0x4,%rdx
  801dd1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801dd5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801dd9:	48 89 c7             	mov    %rax,%rdi
  801ddc:	48 89 d6             	mov    %rdx,%rsi
  801ddf:	fd                   	std    
  801de0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801de2:	eb 1d                	jmp    801e01 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df8:	48 89 d7             	mov    %rdx,%rdi
  801dfb:	48 89 c1             	mov    %rax,%rcx
  801dfe:	fd                   	std    
  801dff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e01:	fc                   	cld    
  801e02:	eb 57                	jmp    801e5b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e08:	83 e0 03             	and    $0x3,%eax
  801e0b:	48 85 c0             	test   %rax,%rax
  801e0e:	75 36                	jne    801e46 <memmove+0xfc>
  801e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e14:	83 e0 03             	and    $0x3,%eax
  801e17:	48 85 c0             	test   %rax,%rax
  801e1a:	75 2a                	jne    801e46 <memmove+0xfc>
  801e1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e20:	83 e0 03             	and    $0x3,%eax
  801e23:	48 85 c0             	test   %rax,%rax
  801e26:	75 1e                	jne    801e46 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2c:	48 c1 e8 02          	shr    $0x2,%rax
  801e30:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e37:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e3b:	48 89 c7             	mov    %rax,%rdi
  801e3e:	48 89 d6             	mov    %rdx,%rsi
  801e41:	fc                   	cld    
  801e42:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801e44:	eb 15                	jmp    801e5b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e4e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e52:	48 89 c7             	mov    %rax,%rdi
  801e55:	48 89 d6             	mov    %rdx,%rsi
  801e58:	fc                   	cld    
  801e59:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e5f:	c9                   	leaveq 
  801e60:	c3                   	retq   

0000000000801e61 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e61:	55                   	push   %rbp
  801e62:	48 89 e5             	mov    %rsp,%rbp
  801e65:	48 83 ec 18          	sub    $0x18,%rsp
  801e69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e71:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801e75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e79:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e81:	48 89 ce             	mov    %rcx,%rsi
  801e84:	48 89 c7             	mov    %rax,%rdi
  801e87:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  801e8e:	00 00 00 
  801e91:	ff d0                	callq  *%rax
}
  801e93:	c9                   	leaveq 
  801e94:	c3                   	retq   

0000000000801e95 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e95:	55                   	push   %rbp
  801e96:	48 89 e5             	mov    %rsp,%rbp
  801e99:	48 83 ec 28          	sub    $0x28,%rsp
  801e9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ea1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ea5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ead:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801eb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801eb9:	eb 36                	jmp    801ef1 <memcmp+0x5c>
		if (*s1 != *s2)
  801ebb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ebf:	0f b6 10             	movzbl (%rax),%edx
  801ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec6:	0f b6 00             	movzbl (%rax),%eax
  801ec9:	38 c2                	cmp    %al,%dl
  801ecb:	74 1a                	je     801ee7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801ecd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed1:	0f b6 00             	movzbl (%rax),%eax
  801ed4:	0f b6 d0             	movzbl %al,%edx
  801ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edb:	0f b6 00             	movzbl (%rax),%eax
  801ede:	0f b6 c0             	movzbl %al,%eax
  801ee1:	29 c2                	sub    %eax,%edx
  801ee3:	89 d0                	mov    %edx,%eax
  801ee5:	eb 20                	jmp    801f07 <memcmp+0x72>
		s1++, s2++;
  801ee7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801eec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ef9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801efd:	48 85 c0             	test   %rax,%rax
  801f00:	75 b9                	jne    801ebb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f07:	c9                   	leaveq 
  801f08:	c3                   	retq   

0000000000801f09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f09:	55                   	push   %rbp
  801f0a:	48 89 e5             	mov    %rsp,%rbp
  801f0d:	48 83 ec 28          	sub    $0x28,%rsp
  801f11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f15:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801f18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f24:	48 01 d0             	add    %rdx,%rax
  801f27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801f2b:	eb 15                	jmp    801f42 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f31:	0f b6 10             	movzbl (%rax),%edx
  801f34:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f37:	38 c2                	cmp    %al,%dl
  801f39:	75 02                	jne    801f3d <memfind+0x34>
			break;
  801f3b:	eb 0f                	jmp    801f4c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f3d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f46:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801f4a:	72 e1                	jb     801f2d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f50:	c9                   	leaveq 
  801f51:	c3                   	retq   

0000000000801f52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
  801f56:	48 83 ec 34          	sub    $0x34,%rsp
  801f5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f62:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801f65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801f6c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801f73:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f74:	eb 05                	jmp    801f7b <strtol+0x29>
		s++;
  801f76:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7f:	0f b6 00             	movzbl (%rax),%eax
  801f82:	3c 20                	cmp    $0x20,%al
  801f84:	74 f0                	je     801f76 <strtol+0x24>
  801f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8a:	0f b6 00             	movzbl (%rax),%eax
  801f8d:	3c 09                	cmp    $0x9,%al
  801f8f:	74 e5                	je     801f76 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f95:	0f b6 00             	movzbl (%rax),%eax
  801f98:	3c 2b                	cmp    $0x2b,%al
  801f9a:	75 07                	jne    801fa3 <strtol+0x51>
		s++;
  801f9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801fa1:	eb 17                	jmp    801fba <strtol+0x68>
	else if (*s == '-')
  801fa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa7:	0f b6 00             	movzbl (%rax),%eax
  801faa:	3c 2d                	cmp    $0x2d,%al
  801fac:	75 0c                	jne    801fba <strtol+0x68>
		s++, neg = 1;
  801fae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801fb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801fbe:	74 06                	je     801fc6 <strtol+0x74>
  801fc0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801fc4:	75 28                	jne    801fee <strtol+0x9c>
  801fc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fca:	0f b6 00             	movzbl (%rax),%eax
  801fcd:	3c 30                	cmp    $0x30,%al
  801fcf:	75 1d                	jne    801fee <strtol+0x9c>
  801fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd5:	48 83 c0 01          	add    $0x1,%rax
  801fd9:	0f b6 00             	movzbl (%rax),%eax
  801fdc:	3c 78                	cmp    $0x78,%al
  801fde:	75 0e                	jne    801fee <strtol+0x9c>
		s += 2, base = 16;
  801fe0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801fe5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801fec:	eb 2c                	jmp    80201a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801fee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ff2:	75 19                	jne    80200d <strtol+0xbb>
  801ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff8:	0f b6 00             	movzbl (%rax),%eax
  801ffb:	3c 30                	cmp    $0x30,%al
  801ffd:	75 0e                	jne    80200d <strtol+0xbb>
		s++, base = 8;
  801fff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802004:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80200b:	eb 0d                	jmp    80201a <strtol+0xc8>
	else if (base == 0)
  80200d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802011:	75 07                	jne    80201a <strtol+0xc8>
		base = 10;
  802013:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80201a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201e:	0f b6 00             	movzbl (%rax),%eax
  802021:	3c 2f                	cmp    $0x2f,%al
  802023:	7e 1d                	jle    802042 <strtol+0xf0>
  802025:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802029:	0f b6 00             	movzbl (%rax),%eax
  80202c:	3c 39                	cmp    $0x39,%al
  80202e:	7f 12                	jg     802042 <strtol+0xf0>
			dig = *s - '0';
  802030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802034:	0f b6 00             	movzbl (%rax),%eax
  802037:	0f be c0             	movsbl %al,%eax
  80203a:	83 e8 30             	sub    $0x30,%eax
  80203d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802040:	eb 4e                	jmp    802090 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802042:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802046:	0f b6 00             	movzbl (%rax),%eax
  802049:	3c 60                	cmp    $0x60,%al
  80204b:	7e 1d                	jle    80206a <strtol+0x118>
  80204d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802051:	0f b6 00             	movzbl (%rax),%eax
  802054:	3c 7a                	cmp    $0x7a,%al
  802056:	7f 12                	jg     80206a <strtol+0x118>
			dig = *s - 'a' + 10;
  802058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205c:	0f b6 00             	movzbl (%rax),%eax
  80205f:	0f be c0             	movsbl %al,%eax
  802062:	83 e8 57             	sub    $0x57,%eax
  802065:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802068:	eb 26                	jmp    802090 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80206a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206e:	0f b6 00             	movzbl (%rax),%eax
  802071:	3c 40                	cmp    $0x40,%al
  802073:	7e 48                	jle    8020bd <strtol+0x16b>
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	0f b6 00             	movzbl (%rax),%eax
  80207c:	3c 5a                	cmp    $0x5a,%al
  80207e:	7f 3d                	jg     8020bd <strtol+0x16b>
			dig = *s - 'A' + 10;
  802080:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802084:	0f b6 00             	movzbl (%rax),%eax
  802087:	0f be c0             	movsbl %al,%eax
  80208a:	83 e8 37             	sub    $0x37,%eax
  80208d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802090:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802093:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802096:	7c 02                	jl     80209a <strtol+0x148>
			break;
  802098:	eb 23                	jmp    8020bd <strtol+0x16b>
		s++, val = (val * base) + dig;
  80209a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80209f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020a2:	48 98                	cltq   
  8020a4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8020a9:	48 89 c2             	mov    %rax,%rdx
  8020ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020af:	48 98                	cltq   
  8020b1:	48 01 d0             	add    %rdx,%rax
  8020b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8020b8:	e9 5d ff ff ff       	jmpq   80201a <strtol+0xc8>

	if (endptr)
  8020bd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8020c2:	74 0b                	je     8020cf <strtol+0x17d>
		*endptr = (char *) s;
  8020c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020cc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8020cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d3:	74 09                	je     8020de <strtol+0x18c>
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	48 f7 d8             	neg    %rax
  8020dc:	eb 04                	jmp    8020e2 <strtol+0x190>
  8020de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8020e2:	c9                   	leaveq 
  8020e3:	c3                   	retq   

00000000008020e4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8020e4:	55                   	push   %rbp
  8020e5:	48 89 e5             	mov    %rsp,%rbp
  8020e8:	48 83 ec 30          	sub    $0x30,%rsp
  8020ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8020f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020fc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802100:	0f b6 00             	movzbl (%rax),%eax
  802103:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802106:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80210a:	75 06                	jne    802112 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80210c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802110:	eb 6b                	jmp    80217d <strstr+0x99>

	len = strlen(str);
  802112:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802116:	48 89 c7             	mov    %rax,%rdi
  802119:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	48 98                	cltq   
  802127:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80212b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802133:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802137:	0f b6 00             	movzbl (%rax),%eax
  80213a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80213d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802141:	75 07                	jne    80214a <strstr+0x66>
				return (char *) 0;
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	eb 33                	jmp    80217d <strstr+0x99>
		} while (sc != c);
  80214a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80214e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802151:	75 d8                	jne    80212b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802153:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802157:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80215b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215f:	48 89 ce             	mov    %rcx,%rsi
  802162:	48 89 c7             	mov    %rax,%rdi
  802165:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
  802171:	85 c0                	test   %eax,%eax
  802173:	75 b6                	jne    80212b <strstr+0x47>

	return (char *) (in - 1);
  802175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802179:	48 83 e8 01          	sub    $0x1,%rax
}
  80217d:	c9                   	leaveq 
  80217e:	c3                   	retq   

000000000080217f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80217f:	55                   	push   %rbp
  802180:	48 89 e5             	mov    %rsp,%rbp
  802183:	53                   	push   %rbx
  802184:	48 83 ec 48          	sub    $0x48,%rsp
  802188:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80218b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80218e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802192:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802196:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80219a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80219e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8021a5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8021a9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8021ad:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8021b1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8021b5:	4c 89 c3             	mov    %r8,%rbx
  8021b8:	cd 30                	int    $0x30
  8021ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8021be:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8021c2:	74 3e                	je     802202 <syscall+0x83>
  8021c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021c9:	7e 37                	jle    802202 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8021cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021d2:	49 89 d0             	mov    %rdx,%r8
  8021d5:	89 c1                	mov    %eax,%ecx
  8021d7:	48 ba 48 5b 80 00 00 	movabs $0x805b48,%rdx
  8021de:	00 00 00 
  8021e1:	be 23 00 00 00       	mov    $0x23,%esi
  8021e6:	48 bf 65 5b 80 00 00 	movabs $0x805b65,%rdi
  8021ed:	00 00 00 
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	49 b9 38 0c 80 00 00 	movabs $0x800c38,%r9
  8021fc:	00 00 00 
  8021ff:	41 ff d1             	callq  *%r9

	return ret;
  802202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802206:	48 83 c4 48          	add    $0x48,%rsp
  80220a:	5b                   	pop    %rbx
  80220b:	5d                   	pop    %rbp
  80220c:	c3                   	retq   

000000000080220d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80220d:	55                   	push   %rbp
  80220e:	48 89 e5             	mov    %rsp,%rbp
  802211:	48 83 ec 20          	sub    $0x20,%rsp
  802215:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802219:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80221d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802221:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802225:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80222c:	00 
  80222d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802233:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802239:	48 89 d1             	mov    %rdx,%rcx
  80223c:	48 89 c2             	mov    %rax,%rdx
  80223f:	be 00 00 00 00       	mov    $0x0,%esi
  802244:	bf 00 00 00 00       	mov    $0x0,%edi
  802249:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
}
  802255:	c9                   	leaveq 
  802256:	c3                   	retq   

0000000000802257 <sys_cgetc>:

int
sys_cgetc(void)
{
  802257:	55                   	push   %rbp
  802258:	48 89 e5             	mov    %rsp,%rbp
  80225b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80225f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802266:	00 
  802267:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80226d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802273:	b9 00 00 00 00       	mov    $0x0,%ecx
  802278:	ba 00 00 00 00       	mov    $0x0,%edx
  80227d:	be 00 00 00 00       	mov    $0x0,%esi
  802282:	bf 01 00 00 00       	mov    $0x1,%edi
  802287:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  80228e:	00 00 00 
  802291:	ff d0                	callq  *%rax
}
  802293:	c9                   	leaveq 
  802294:	c3                   	retq   

0000000000802295 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802295:	55                   	push   %rbp
  802296:	48 89 e5             	mov    %rsp,%rbp
  802299:	48 83 ec 10          	sub    $0x10,%rsp
  80229d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8022a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a3:	48 98                	cltq   
  8022a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022ac:	00 
  8022ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022be:	48 89 c2             	mov    %rax,%rdx
  8022c1:	be 01 00 00 00       	mov    $0x1,%esi
  8022c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8022cb:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
}
  8022d7:	c9                   	leaveq 
  8022d8:	c3                   	retq   

00000000008022d9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8022d9:	55                   	push   %rbp
  8022da:	48 89 e5             	mov    %rsp,%rbp
  8022dd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8022e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022e8:	00 
  8022e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ff:	be 00 00 00 00       	mov    $0x0,%esi
  802304:	bf 02 00 00 00       	mov    $0x2,%edi
  802309:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <sys_yield>:

void
sys_yield(void)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80231f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802326:	00 
  802327:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80232d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802333:	b9 00 00 00 00       	mov    $0x0,%ecx
  802338:	ba 00 00 00 00       	mov    $0x0,%edx
  80233d:	be 00 00 00 00       	mov    $0x0,%esi
  802342:	bf 0b 00 00 00       	mov    $0xb,%edi
  802347:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
}
  802353:	c9                   	leaveq 
  802354:	c3                   	retq   

0000000000802355 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802355:	55                   	push   %rbp
  802356:	48 89 e5             	mov    %rsp,%rbp
  802359:	48 83 ec 20          	sub    $0x20,%rsp
  80235d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802360:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802364:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80236a:	48 63 c8             	movslq %eax,%rcx
  80236d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802374:	48 98                	cltq   
  802376:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80237d:	00 
  80237e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802384:	49 89 c8             	mov    %rcx,%r8
  802387:	48 89 d1             	mov    %rdx,%rcx
  80238a:	48 89 c2             	mov    %rax,%rdx
  80238d:	be 01 00 00 00       	mov    $0x1,%esi
  802392:	bf 04 00 00 00       	mov    $0x4,%edi
  802397:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	callq  *%rax
}
  8023a3:	c9                   	leaveq 
  8023a4:	c3                   	retq   

00000000008023a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8023a5:	55                   	push   %rbp
  8023a6:	48 89 e5             	mov    %rsp,%rbp
  8023a9:	48 83 ec 30          	sub    $0x30,%rsp
  8023ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8023b7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023bb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8023bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8023c2:	48 63 c8             	movslq %eax,%rcx
  8023c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8023c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023cc:	48 63 f0             	movslq %eax,%rsi
  8023cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d6:	48 98                	cltq   
  8023d8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8023dc:	49 89 f9             	mov    %rdi,%r9
  8023df:	49 89 f0             	mov    %rsi,%r8
  8023e2:	48 89 d1             	mov    %rdx,%rcx
  8023e5:	48 89 c2             	mov    %rax,%rdx
  8023e8:	be 01 00 00 00       	mov    $0x1,%esi
  8023ed:	bf 05 00 00 00       	mov    $0x5,%edi
  8023f2:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
}
  8023fe:	c9                   	leaveq 
  8023ff:	c3                   	retq   

0000000000802400 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802400:	55                   	push   %rbp
  802401:	48 89 e5             	mov    %rsp,%rbp
  802404:	48 83 ec 20          	sub    $0x20,%rsp
  802408:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80240b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80240f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802416:	48 98                	cltq   
  802418:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80241f:	00 
  802420:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802426:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80242c:	48 89 d1             	mov    %rdx,%rcx
  80242f:	48 89 c2             	mov    %rax,%rdx
  802432:	be 01 00 00 00       	mov    $0x1,%esi
  802437:	bf 06 00 00 00       	mov    $0x6,%edi
  80243c:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 10          	sub    $0x10,%rsp
  802452:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802455:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802458:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245b:	48 63 d0             	movslq %eax,%rdx
  80245e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802461:	48 98                	cltq   
  802463:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80246a:	00 
  80246b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802471:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802477:	48 89 d1             	mov    %rdx,%rcx
  80247a:	48 89 c2             	mov    %rax,%rdx
  80247d:	be 01 00 00 00       	mov    $0x1,%esi
  802482:	bf 08 00 00 00       	mov    $0x8,%edi
  802487:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
}
  802493:	c9                   	leaveq 
  802494:	c3                   	retq   

0000000000802495 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
  802499:	48 83 ec 20          	sub    $0x20,%rsp
  80249d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8024a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ab:	48 98                	cltq   
  8024ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024b4:	00 
  8024b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024c1:	48 89 d1             	mov    %rdx,%rcx
  8024c4:	48 89 c2             	mov    %rax,%rdx
  8024c7:	be 01 00 00 00       	mov    $0x1,%esi
  8024cc:	bf 09 00 00 00       	mov    $0x9,%edi
  8024d1:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
}
  8024dd:	c9                   	leaveq 
  8024de:	c3                   	retq   

00000000008024df <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8024df:	55                   	push   %rbp
  8024e0:	48 89 e5             	mov    %rsp,%rbp
  8024e3:	48 83 ec 20          	sub    $0x20,%rsp
  8024e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8024ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	48 98                	cltq   
  8024f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024fe:	00 
  8024ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802505:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80250b:	48 89 d1             	mov    %rdx,%rcx
  80250e:	48 89 c2             	mov    %rax,%rdx
  802511:	be 01 00 00 00       	mov    $0x1,%esi
  802516:	bf 0a 00 00 00       	mov    $0xa,%edi
  80251b:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802522:	00 00 00 
  802525:	ff d0                	callq  *%rax
}
  802527:	c9                   	leaveq 
  802528:	c3                   	retq   

0000000000802529 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802529:	55                   	push   %rbp
  80252a:	48 89 e5             	mov    %rsp,%rbp
  80252d:	48 83 ec 20          	sub    $0x20,%rsp
  802531:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802538:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80253c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80253f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802542:	48 63 f0             	movslq %eax,%rsi
  802545:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254c:	48 98                	cltq   
  80254e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802552:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802559:	00 
  80255a:	49 89 f1             	mov    %rsi,%r9
  80255d:	49 89 c8             	mov    %rcx,%r8
  802560:	48 89 d1             	mov    %rdx,%rcx
  802563:	48 89 c2             	mov    %rax,%rdx
  802566:	be 00 00 00 00       	mov    $0x0,%esi
  80256b:	bf 0c 00 00 00       	mov    $0xc,%edi
  802570:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802577:	00 00 00 
  80257a:	ff d0                	callq  *%rax
}
  80257c:	c9                   	leaveq 
  80257d:	c3                   	retq   

000000000080257e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80257e:	55                   	push   %rbp
  80257f:	48 89 e5             	mov    %rsp,%rbp
  802582:	48 83 ec 10          	sub    $0x10,%rsp
  802586:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80258a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802595:	00 
  802596:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80259c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025a7:	48 89 c2             	mov    %rax,%rdx
  8025aa:	be 01 00 00 00       	mov    $0x1,%esi
  8025af:	bf 0d 00 00 00       	mov    $0xd,%edi
  8025b4:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
}
  8025c0:	c9                   	leaveq 
  8025c1:	c3                   	retq   

00000000008025c2 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  8025c2:	55                   	push   %rbp
  8025c3:	48 89 e5             	mov    %rsp,%rbp
  8025c6:	48 83 ec 20          	sub    $0x20,%rsp
  8025ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  8025d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025e1:	00 
  8025e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025ee:	48 89 d1             	mov    %rdx,%rcx
  8025f1:	48 89 c2             	mov    %rax,%rdx
  8025f4:	be 01 00 00 00       	mov    $0x1,%esi
  8025f9:	bf 0f 00 00 00       	mov    $0xf,%edi
  8025fe:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802605:	00 00 00 
  802608:	ff d0                	callq  *%rax
}
  80260a:	c9                   	leaveq 
  80260b:	c3                   	retq   

000000000080260c <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  80260c:	55                   	push   %rbp
  80260d:	48 89 e5             	mov    %rsp,%rbp
  802610:	48 83 ec 10          	sub    $0x10,%rsp
  802614:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  802618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802623:	00 
  802624:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80262a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802630:	b9 00 00 00 00       	mov    $0x0,%ecx
  802635:	48 89 c2             	mov    %rax,%rdx
  802638:	be 00 00 00 00       	mov    $0x0,%esi
  80263d:	bf 10 00 00 00       	mov    $0x10,%edi
  802642:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
}
  80264e:	c9                   	leaveq 
  80264f:	c3                   	retq   

0000000000802650 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802650:	55                   	push   %rbp
  802651:	48 89 e5             	mov    %rsp,%rbp
  802654:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802658:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80265f:	00 
  802660:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802666:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80266c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802671:	ba 00 00 00 00       	mov    $0x0,%edx
  802676:	be 00 00 00 00       	mov    $0x0,%esi
  80267b:	bf 0e 00 00 00       	mov    $0xe,%edi
  802680:	48 b8 7f 21 80 00 00 	movabs $0x80217f,%rax
  802687:	00 00 00 
  80268a:	ff d0                	callq  *%rax
}
  80268c:	c9                   	leaveq 
  80268d:	c3                   	retq   

000000000080268e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80268e:	55                   	push   %rbp
  80268f:	48 89 e5             	mov    %rsp,%rbp
  802692:	48 83 ec 08          	sub    $0x8,%rsp
  802696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80269a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80269e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026a5:	ff ff ff 
  8026a8:	48 01 d0             	add    %rdx,%rax
  8026ab:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026af:	c9                   	leaveq 
  8026b0:	c3                   	retq   

00000000008026b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026b1:	55                   	push   %rbp
  8026b2:	48 89 e5             	mov    %rsp,%rbp
  8026b5:	48 83 ec 08          	sub    $0x8,%rsp
  8026b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026c1:	48 89 c7             	mov    %rax,%rdi
  8026c4:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
  8026d0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026d6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026da:	c9                   	leaveq 
  8026db:	c3                   	retq   

00000000008026dc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026dc:	55                   	push   %rbp
  8026dd:	48 89 e5             	mov    %rsp,%rbp
  8026e0:	48 83 ec 18          	sub    $0x18,%rsp
  8026e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ef:	eb 6b                	jmp    80275c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f4:	48 98                	cltq   
  8026f6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026fc:	48 c1 e0 0c          	shl    $0xc,%rax
  802700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802708:	48 c1 e8 15          	shr    $0x15,%rax
  80270c:	48 89 c2             	mov    %rax,%rdx
  80270f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802716:	01 00 00 
  802719:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271d:	83 e0 01             	and    $0x1,%eax
  802720:	48 85 c0             	test   %rax,%rax
  802723:	74 21                	je     802746 <fd_alloc+0x6a>
  802725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802729:	48 c1 e8 0c          	shr    $0xc,%rax
  80272d:	48 89 c2             	mov    %rax,%rdx
  802730:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802737:	01 00 00 
  80273a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80273e:	83 e0 01             	and    $0x1,%eax
  802741:	48 85 c0             	test   %rax,%rax
  802744:	75 12                	jne    802758 <fd_alloc+0x7c>
			*fd_store = fd;
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80274e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
  802756:	eb 1a                	jmp    802772 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802758:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80275c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802760:	7e 8f                	jle    8026f1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80276d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802772:	c9                   	leaveq 
  802773:	c3                   	retq   

0000000000802774 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802774:	55                   	push   %rbp
  802775:	48 89 e5             	mov    %rsp,%rbp
  802778:	48 83 ec 20          	sub    $0x20,%rsp
  80277c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80277f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802783:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802787:	78 06                	js     80278f <fd_lookup+0x1b>
  802789:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80278d:	7e 07                	jle    802796 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80278f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802794:	eb 6c                	jmp    802802 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802796:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802799:	48 98                	cltq   
  80279b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027a1:	48 c1 e0 0c          	shl    $0xc,%rax
  8027a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ad:	48 c1 e8 15          	shr    $0x15,%rax
  8027b1:	48 89 c2             	mov    %rax,%rdx
  8027b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027bb:	01 00 00 
  8027be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c2:	83 e0 01             	and    $0x1,%eax
  8027c5:	48 85 c0             	test   %rax,%rax
  8027c8:	74 21                	je     8027eb <fd_lookup+0x77>
  8027ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8027d2:	48 89 c2             	mov    %rax,%rdx
  8027d5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027dc:	01 00 00 
  8027df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e3:	83 e0 01             	and    $0x1,%eax
  8027e6:	48 85 c0             	test   %rax,%rax
  8027e9:	75 07                	jne    8027f2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f0:	eb 10                	jmp    802802 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027fa:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802802:	c9                   	leaveq 
  802803:	c3                   	retq   

0000000000802804 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802804:	55                   	push   %rbp
  802805:	48 89 e5             	mov    %rsp,%rbp
  802808:	48 83 ec 30          	sub    $0x30,%rsp
  80280c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802810:	89 f0                	mov    %esi,%eax
  802812:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802819:	48 89 c7             	mov    %rax,%rdi
  80281c:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  802823:	00 00 00 
  802826:	ff d0                	callq  *%rax
  802828:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80282c:	48 89 d6             	mov    %rdx,%rsi
  80282f:	89 c7                	mov    %eax,%edi
  802831:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802838:	00 00 00 
  80283b:	ff d0                	callq  *%rax
  80283d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802844:	78 0a                	js     802850 <fd_close+0x4c>
	    || fd != fd2)
  802846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80284e:	74 12                	je     802862 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802850:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802854:	74 05                	je     80285b <fd_close+0x57>
  802856:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802859:	eb 05                	jmp    802860 <fd_close+0x5c>
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	eb 69                	jmp    8028cb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802866:	8b 00                	mov    (%rax),%eax
  802868:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80286c:	48 89 d6             	mov    %rdx,%rsi
  80286f:	89 c7                	mov    %eax,%edi
  802871:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802884:	78 2a                	js     8028b0 <fd_close+0xac>
		if (dev->dev_close)
  802886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80288e:	48 85 c0             	test   %rax,%rax
  802891:	74 16                	je     8028a9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802897:	48 8b 40 20          	mov    0x20(%rax),%rax
  80289b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80289f:	48 89 d7             	mov    %rdx,%rdi
  8028a2:	ff d0                	callq  *%rax
  8028a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a7:	eb 07                	jmp    8028b0 <fd_close+0xac>
		else
			r = 0;
  8028a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b4:	48 89 c6             	mov    %rax,%rsi
  8028b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bc:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
	return r;
  8028c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028cb:	c9                   	leaveq 
  8028cc:	c3                   	retq   

00000000008028cd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028cd:	55                   	push   %rbp
  8028ce:	48 89 e5             	mov    %rsp,%rbp
  8028d1:	48 83 ec 20          	sub    $0x20,%rsp
  8028d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028e3:	eb 41                	jmp    802926 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028e5:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8028ec:	00 00 00 
  8028ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f2:	48 63 d2             	movslq %edx,%rdx
  8028f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f9:	8b 00                	mov    (%rax),%eax
  8028fb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028fe:	75 22                	jne    802922 <dev_lookup+0x55>
			*dev = devtab[i];
  802900:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802907:	00 00 00 
  80290a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80290d:	48 63 d2             	movslq %edx,%rdx
  802910:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802918:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	eb 60                	jmp    802982 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802922:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802926:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  80292d:	00 00 00 
  802930:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802933:	48 63 d2             	movslq %edx,%rdx
  802936:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293a:	48 85 c0             	test   %rax,%rax
  80293d:	75 a6                	jne    8028e5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80293f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802946:	00 00 00 
  802949:	48 8b 00             	mov    (%rax),%rax
  80294c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802952:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802955:	89 c6                	mov    %eax,%esi
  802957:	48 bf 78 5b 80 00 00 	movabs $0x805b78,%rdi
  80295e:	00 00 00 
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
  802966:	48 b9 71 0e 80 00 00 	movabs $0x800e71,%rcx
  80296d:	00 00 00 
  802970:	ff d1                	callq  *%rcx
	*dev = 0;
  802972:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802976:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80297d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802982:	c9                   	leaveq 
  802983:	c3                   	retq   

0000000000802984 <close>:

int
close(int fdnum)
{
  802984:	55                   	push   %rbp
  802985:	48 89 e5             	mov    %rsp,%rbp
  802988:	48 83 ec 20          	sub    $0x20,%rsp
  80298c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80298f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802993:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802996:	48 89 d6             	mov    %rdx,%rsi
  802999:	89 c7                	mov    %eax,%edi
  80299b:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	callq  *%rax
  8029a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ae:	79 05                	jns    8029b5 <close+0x31>
		return r;
  8029b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b3:	eb 18                	jmp    8029cd <close+0x49>
	else
		return fd_close(fd, 1);
  8029b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b9:	be 01 00 00 00       	mov    $0x1,%esi
  8029be:	48 89 c7             	mov    %rax,%rdi
  8029c1:	48 b8 04 28 80 00 00 	movabs $0x802804,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <close_all>:

void
close_all(void)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029de:	eb 15                	jmp    8029f5 <close_all+0x26>
		close(i);
  8029e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029f1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029f5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029f9:	7e e5                	jle    8029e0 <close_all+0x11>
		close(i);
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 40          	sub    $0x40,%rsp
  802a05:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a08:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a0b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a0f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a12:	48 89 d6             	mov    %rdx,%rsi
  802a15:	89 c7                	mov    %eax,%edi
  802a17:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2a:	79 08                	jns    802a34 <dup+0x37>
		return r;
  802a2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2f:	e9 70 01 00 00       	jmpq   802ba4 <dup+0x1a7>
	close(newfdnum);
  802a34:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a37:	89 c7                	mov    %eax,%edi
  802a39:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a45:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a48:	48 98                	cltq   
  802a4a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a50:	48 c1 e0 0c          	shl    $0xc,%rax
  802a54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a5c:	48 89 c7             	mov    %rax,%rdi
  802a5f:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	callq  *%rax
  802a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a73:	48 89 c7             	mov    %rax,%rdi
  802a76:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8a:	48 c1 e8 15          	shr    $0x15,%rax
  802a8e:	48 89 c2             	mov    %rax,%rdx
  802a91:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a98:	01 00 00 
  802a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9f:	83 e0 01             	and    $0x1,%eax
  802aa2:	48 85 c0             	test   %rax,%rax
  802aa5:	74 73                	je     802b1a <dup+0x11d>
  802aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aab:	48 c1 e8 0c          	shr    $0xc,%rax
  802aaf:	48 89 c2             	mov    %rax,%rdx
  802ab2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab9:	01 00 00 
  802abc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac0:	83 e0 01             	and    $0x1,%eax
  802ac3:	48 85 c0             	test   %rax,%rax
  802ac6:	74 52                	je     802b1a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acc:	48 c1 e8 0c          	shr    $0xc,%rax
  802ad0:	48 89 c2             	mov    %rax,%rdx
  802ad3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ada:	01 00 00 
  802add:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae1:	25 07 0e 00 00       	and    $0xe07,%eax
  802ae6:	89 c1                	mov    %eax,%ecx
  802ae8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	41 89 c8             	mov    %ecx,%r8d
  802af3:	48 89 d1             	mov    %rdx,%rcx
  802af6:	ba 00 00 00 00       	mov    $0x0,%edx
  802afb:	48 89 c6             	mov    %rax,%rsi
  802afe:	bf 00 00 00 00       	mov    $0x0,%edi
  802b03:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
  802b0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b16:	79 02                	jns    802b1a <dup+0x11d>
			goto err;
  802b18:	eb 57                	jmp    802b71 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b1e:	48 c1 e8 0c          	shr    $0xc,%rax
  802b22:	48 89 c2             	mov    %rax,%rdx
  802b25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b2c:	01 00 00 
  802b2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b33:	25 07 0e 00 00       	and    $0xe07,%eax
  802b38:	89 c1                	mov    %eax,%ecx
  802b3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b42:	41 89 c8             	mov    %ecx,%r8d
  802b45:	48 89 d1             	mov    %rdx,%rcx
  802b48:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4d:	48 89 c6             	mov    %rax,%rsi
  802b50:	bf 00 00 00 00       	mov    $0x0,%edi
  802b55:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
  802b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b68:	79 02                	jns    802b6c <dup+0x16f>
		goto err;
  802b6a:	eb 05                	jmp    802b71 <dup+0x174>

	return newfdnum;
  802b6c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b6f:	eb 33                	jmp    802ba4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b75:	48 89 c6             	mov    %rax,%rsi
  802b78:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7d:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b8d:	48 89 c6             	mov    %rax,%rsi
  802b90:	bf 00 00 00 00       	mov    $0x0,%edi
  802b95:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
	return r;
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 40          	sub    $0x40,%rsp
  802bae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bb1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bb5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bb9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc0:	48 89 d6             	mov    %rdx,%rsi
  802bc3:	89 c7                	mov    %eax,%edi
  802bc5:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
  802bd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd8:	78 24                	js     802bfe <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bde:	8b 00                	mov    (%rax),%eax
  802be0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802be4:	48 89 d6             	mov    %rdx,%rsi
  802be7:	89 c7                	mov    %eax,%edi
  802be9:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfc:	79 05                	jns    802c03 <read+0x5d>
		return r;
  802bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c01:	eb 76                	jmp    802c79 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c07:	8b 40 08             	mov    0x8(%rax),%eax
  802c0a:	83 e0 03             	and    $0x3,%eax
  802c0d:	83 f8 01             	cmp    $0x1,%eax
  802c10:	75 3a                	jne    802c4c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c12:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802c19:	00 00 00 
  802c1c:	48 8b 00             	mov    (%rax),%rax
  802c1f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c25:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c28:	89 c6                	mov    %eax,%esi
  802c2a:	48 bf 97 5b 80 00 00 	movabs $0x805b97,%rdi
  802c31:	00 00 00 
  802c34:	b8 00 00 00 00       	mov    $0x0,%eax
  802c39:	48 b9 71 0e 80 00 00 	movabs $0x800e71,%rcx
  802c40:	00 00 00 
  802c43:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c4a:	eb 2d                	jmp    802c79 <read+0xd3>
	}
	if (!dev->dev_read)
  802c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c50:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c54:	48 85 c0             	test   %rax,%rax
  802c57:	75 07                	jne    802c60 <read+0xba>
		return -E_NOT_SUPP;
  802c59:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c5e:	eb 19                	jmp    802c79 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c64:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c70:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c74:	48 89 cf             	mov    %rcx,%rdi
  802c77:	ff d0                	callq  *%rax
}
  802c79:	c9                   	leaveq 
  802c7a:	c3                   	retq   

0000000000802c7b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c7b:	55                   	push   %rbp
  802c7c:	48 89 e5             	mov    %rsp,%rbp
  802c7f:	48 83 ec 30          	sub    $0x30,%rsp
  802c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c95:	eb 49                	jmp    802ce0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9a:	48 98                	cltq   
  802c9c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ca0:	48 29 c2             	sub    %rax,%rdx
  802ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca6:	48 63 c8             	movslq %eax,%rcx
  802ca9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cad:	48 01 c1             	add    %rax,%rcx
  802cb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb3:	48 89 ce             	mov    %rcx,%rsi
  802cb6:	89 c7                	mov    %eax,%edi
  802cb8:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  802cbf:	00 00 00 
  802cc2:	ff d0                	callq  *%rax
  802cc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ccb:	79 05                	jns    802cd2 <readn+0x57>
			return m;
  802ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd0:	eb 1c                	jmp    802cee <readn+0x73>
		if (m == 0)
  802cd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cd6:	75 02                	jne    802cda <readn+0x5f>
			break;
  802cd8:	eb 11                	jmp    802ceb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cdd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce3:	48 98                	cltq   
  802ce5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ce9:	72 ac                	jb     802c97 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 40          	sub    $0x40,%rsp
  802cf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cfb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d0a:	48 89 d6             	mov    %rdx,%rsi
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
  802d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d22:	78 24                	js     802d48 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d28:	8b 00                	mov    (%rax),%eax
  802d2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2e:	48 89 d6             	mov    %rdx,%rsi
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
  802d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d46:	79 05                	jns    802d4d <write+0x5d>
		return r;
  802d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4b:	eb 75                	jmp    802dc2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d51:	8b 40 08             	mov    0x8(%rax),%eax
  802d54:	83 e0 03             	and    $0x3,%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	75 3a                	jne    802d95 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d5b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802d62:	00 00 00 
  802d65:	48 8b 00             	mov    (%rax),%rax
  802d68:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d6e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d71:	89 c6                	mov    %eax,%esi
  802d73:	48 bf b3 5b 80 00 00 	movabs $0x805bb3,%rdi
  802d7a:	00 00 00 
  802d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d82:	48 b9 71 0e 80 00 00 	movabs $0x800e71,%rcx
  802d89:	00 00 00 
  802d8c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d93:	eb 2d                	jmp    802dc2 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d99:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d9d:	48 85 c0             	test   %rax,%rax
  802da0:	75 07                	jne    802da9 <write+0xb9>
		return -E_NOT_SUPP;
  802da2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802da7:	eb 19                	jmp    802dc2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dad:	48 8b 40 18          	mov    0x18(%rax),%rax
  802db1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802db5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802db9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dbd:	48 89 cf             	mov    %rcx,%rdi
  802dc0:	ff d0                	callq  *%rax
}
  802dc2:	c9                   	leaveq 
  802dc3:	c3                   	retq   

0000000000802dc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  802dc4:	55                   	push   %rbp
  802dc5:	48 89 e5             	mov    %rsp,%rbp
  802dc8:	48 83 ec 18          	sub    $0x18,%rsp
  802dcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dcf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dd2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd9:	48 89 d6             	mov    %rdx,%rsi
  802ddc:	89 c7                	mov    %eax,%edi
  802dde:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
  802dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ded:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df1:	79 05                	jns    802df8 <seek+0x34>
		return r;
  802df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df6:	eb 0f                	jmp    802e07 <seek+0x43>
	fd->fd_offset = offset;
  802df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e07:	c9                   	leaveq 
  802e08:	c3                   	retq   

0000000000802e09 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e09:	55                   	push   %rbp
  802e0a:	48 89 e5             	mov    %rsp,%rbp
  802e0d:	48 83 ec 30          	sub    $0x30,%rsp
  802e11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e14:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e17:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e1e:	48 89 d6             	mov    %rdx,%rsi
  802e21:	89 c7                	mov    %eax,%edi
  802e23:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	callq  *%rax
  802e2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e36:	78 24                	js     802e5c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3c:	8b 00                	mov    (%rax),%eax
  802e3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e42:	48 89 d6             	mov    %rdx,%rsi
  802e45:	89 c7                	mov    %eax,%edi
  802e47:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
  802e53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5a:	79 05                	jns    802e61 <ftruncate+0x58>
		return r;
  802e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5f:	eb 72                	jmp    802ed3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e65:	8b 40 08             	mov    0x8(%rax),%eax
  802e68:	83 e0 03             	and    $0x3,%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	75 3a                	jne    802ea9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e6f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802e76:	00 00 00 
  802e79:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e7c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e82:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e85:	89 c6                	mov    %eax,%esi
  802e87:	48 bf d0 5b 80 00 00 	movabs $0x805bd0,%rdi
  802e8e:	00 00 00 
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
  802e96:	48 b9 71 0e 80 00 00 	movabs $0x800e71,%rcx
  802e9d:	00 00 00 
  802ea0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ea7:	eb 2a                	jmp    802ed3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ead:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eb1:	48 85 c0             	test   %rax,%rax
  802eb4:	75 07                	jne    802ebd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802eb6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ebb:	eb 16                	jmp    802ed3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ec5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ec9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ecc:	89 ce                	mov    %ecx,%esi
  802ece:	48 89 d7             	mov    %rdx,%rdi
  802ed1:	ff d0                	callq  *%rax
}
  802ed3:	c9                   	leaveq 
  802ed4:	c3                   	retq   

0000000000802ed5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ed5:	55                   	push   %rbp
  802ed6:	48 89 e5             	mov    %rsp,%rbp
  802ed9:	48 83 ec 30          	sub    $0x30,%rsp
  802edd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ee0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ee4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ee8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f03:	78 24                	js     802f29 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f09:	8b 00                	mov    (%rax),%eax
  802f0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f0f:	48 89 d6             	mov    %rdx,%rsi
  802f12:	89 c7                	mov    %eax,%edi
  802f14:	48 b8 cd 28 80 00 00 	movabs $0x8028cd,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
  802f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f27:	79 05                	jns    802f2e <fstat+0x59>
		return r;
  802f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2c:	eb 5e                	jmp    802f8c <fstat+0xb7>
	if (!dev->dev_stat)
  802f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f32:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f36:	48 85 c0             	test   %rax,%rax
  802f39:	75 07                	jne    802f42 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f3b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f40:	eb 4a                	jmp    802f8c <fstat+0xb7>
	stat->st_name[0] = 0;
  802f42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f46:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f4d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f54:	00 00 00 
	stat->st_isdir = 0;
  802f57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f5b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f62:	00 00 00 
	stat->st_dev = dev;
  802f65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f6d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f78:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f80:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f84:	48 89 ce             	mov    %rcx,%rsi
  802f87:	48 89 d7             	mov    %rdx,%rdi
  802f8a:	ff d0                	callq  *%rax
}
  802f8c:	c9                   	leaveq 
  802f8d:	c3                   	retq   

0000000000802f8e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f8e:	55                   	push   %rbp
  802f8f:	48 89 e5             	mov    %rsp,%rbp
  802f92:	48 83 ec 20          	sub    $0x20,%rsp
  802f96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa2:	be 00 00 00 00       	mov    $0x0,%esi
  802fa7:	48 89 c7             	mov    %rax,%rdi
  802faa:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
  802fb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbd:	79 05                	jns    802fc4 <stat+0x36>
		return fd;
  802fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc2:	eb 2f                	jmp    802ff3 <stat+0x65>
	r = fstat(fd, stat);
  802fc4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcb:	48 89 d6             	mov    %rdx,%rsi
  802fce:	89 c7                	mov    %eax,%edi
  802fd0:	48 b8 d5 2e 80 00 00 	movabs $0x802ed5,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
  802fdc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe2:	89 c7                	mov    %eax,%edi
  802fe4:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
	return r;
  802ff0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ff3:	c9                   	leaveq 
  802ff4:	c3                   	retq   

0000000000802ff5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ff5:	55                   	push   %rbp
  802ff6:	48 89 e5             	mov    %rsp,%rbp
  802ff9:	48 83 ec 10          	sub    $0x10,%rsp
  802ffd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803000:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803004:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300b:	00 00 00 
  80300e:	8b 00                	mov    (%rax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	75 1d                	jne    803031 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803014:	bf 01 00 00 00       	mov    $0x1,%edi
  803019:	48 b8 0c 4e 80 00 00 	movabs $0x804e0c,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80302c:	00 00 00 
  80302f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803031:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803038:	00 00 00 
  80303b:	8b 00                	mov    (%rax),%eax
  80303d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803040:	b9 07 00 00 00       	mov    $0x7,%ecx
  803045:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80304c:	00 00 00 
  80304f:	89 c7                	mov    %eax,%edi
  803051:	48 b8 aa 4d 80 00 00 	movabs $0x804daa,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80305d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803061:	ba 00 00 00 00       	mov    $0x0,%edx
  803066:	48 89 c6             	mov    %rax,%rsi
  803069:	bf 00 00 00 00       	mov    $0x0,%edi
  80306e:	48 b8 a4 4c 80 00 00 	movabs $0x804ca4,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
}
  80307a:	c9                   	leaveq 
  80307b:	c3                   	retq   

000000000080307c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80307c:	55                   	push   %rbp
  80307d:	48 89 e5             	mov    %rsp,%rbp
  803080:	48 83 ec 30          	sub    $0x30,%rsp
  803084:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803088:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80308b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803092:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8030a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8030a5:	75 08                	jne    8030af <open+0x33>
	{
		return r;
  8030a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030aa:	e9 f2 00 00 00       	jmpq   8031a1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8030af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b3:	48 89 c7             	mov    %rax,%rdi
  8030b6:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  8030bd:	00 00 00 
  8030c0:	ff d0                	callq  *%rax
  8030c2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030c5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8030cc:	7e 0a                	jle    8030d8 <open+0x5c>
	{
		return -E_BAD_PATH;
  8030ce:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030d3:	e9 c9 00 00 00       	jmpq   8031a1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8030d8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8030df:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8030e0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030e4:	48 89 c7             	mov    %rax,%rdi
  8030e7:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
  8030f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fa:	78 09                	js     803105 <open+0x89>
  8030fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803100:	48 85 c0             	test   %rax,%rax
  803103:	75 08                	jne    80310d <open+0x91>
		{
			return r;
  803105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803108:	e9 94 00 00 00       	jmpq   8031a1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80310d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803111:	ba 00 04 00 00       	mov    $0x400,%edx
  803116:	48 89 c6             	mov    %rax,%rsi
  803119:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803120:	00 00 00 
  803123:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  80312a:	00 00 00 
  80312d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80312f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803136:	00 00 00 
  803139:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80313c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803146:	48 89 c6             	mov    %rax,%rsi
  803149:	bf 01 00 00 00       	mov    $0x1,%edi
  80314e:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
  80315a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803161:	79 2b                	jns    80318e <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803167:	be 00 00 00 00       	mov    $0x0,%esi
  80316c:	48 89 c7             	mov    %rax,%rdi
  80316f:	48 b8 04 28 80 00 00 	movabs $0x802804,%rax
  803176:	00 00 00 
  803179:	ff d0                	callq  *%rax
  80317b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80317e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803182:	79 05                	jns    803189 <open+0x10d>
			{
				return d;
  803184:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803187:	eb 18                	jmp    8031a1 <open+0x125>
			}
			return r;
  803189:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318c:	eb 13                	jmp    8031a1 <open+0x125>
		}	
		return fd2num(fd_store);
  80318e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803192:	48 89 c7             	mov    %rax,%rdi
  803195:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8031a1:	c9                   	leaveq 
  8031a2:	c3                   	retq   

00000000008031a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8031a3:	55                   	push   %rbp
  8031a4:	48 89 e5             	mov    %rsp,%rbp
  8031a7:	48 83 ec 10          	sub    $0x10,%rsp
  8031ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bd:	00 00 00 
  8031c0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031c2:	be 00 00 00 00       	mov    $0x0,%esi
  8031c7:	bf 06 00 00 00       	mov    $0x6,%edi
  8031cc:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 30          	sub    $0x30,%rsp
  8031e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8031ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8031f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031fa:	74 07                	je     803203 <devfile_read+0x29>
  8031fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803201:	75 07                	jne    80320a <devfile_read+0x30>
		return -E_INVAL;
  803203:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803208:	eb 77                	jmp    803281 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80320a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320e:	8b 50 0c             	mov    0xc(%rax),%edx
  803211:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803218:	00 00 00 
  80321b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80321d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803224:	00 00 00 
  803227:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80322b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80322f:	be 00 00 00 00       	mov    $0x0,%esi
  803234:	bf 03 00 00 00       	mov    $0x3,%edi
  803239:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  803240:	00 00 00 
  803243:	ff d0                	callq  *%rax
  803245:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803248:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324c:	7f 05                	jg     803253 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80324e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803251:	eb 2e                	jmp    803281 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803256:	48 63 d0             	movslq %eax,%rdx
  803259:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803264:	00 00 00 
  803267:	48 89 c7             	mov    %rax,%rdi
  80326a:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803271:	00 00 00 
  803274:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803276:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80327a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80327e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803281:	c9                   	leaveq 
  803282:	c3                   	retq   

0000000000803283 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803283:	55                   	push   %rbp
  803284:	48 89 e5             	mov    %rsp,%rbp
  803287:	48 83 ec 30          	sub    $0x30,%rsp
  80328b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80328f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803293:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803297:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80329e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032a3:	74 07                	je     8032ac <devfile_write+0x29>
  8032a5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032aa:	75 08                	jne    8032b4 <devfile_write+0x31>
		return r;
  8032ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032af:	e9 9a 00 00 00       	jmpq   80334e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8032b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8032bb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032c2:	00 00 00 
  8032c5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8032c7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032ce:	00 
  8032cf:	76 08                	jbe    8032d9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8032d1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032d8:	00 
	}
	fsipcbuf.write.req_n = n;
  8032d9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032e0:	00 00 00 
  8032e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032e7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8032eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f3:	48 89 c6             	mov    %rax,%rsi
  8032f6:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8032fd:	00 00 00 
  803300:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80330c:	be 00 00 00 00       	mov    $0x0,%esi
  803311:	bf 04 00 00 00       	mov    $0x4,%edi
  803316:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803329:	7f 20                	jg     80334b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80332b:	48 bf f6 5b 80 00 00 	movabs $0x805bf6,%rdi
  803332:	00 00 00 
  803335:	b8 00 00 00 00       	mov    $0x0,%eax
  80333a:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  803341:	00 00 00 
  803344:	ff d2                	callq  *%rdx
		return r;
  803346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803349:	eb 03                	jmp    80334e <devfile_write+0xcb>
	}
	return r;
  80334b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80334e:	c9                   	leaveq 
  80334f:	c3                   	retq   

0000000000803350 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803350:	55                   	push   %rbp
  803351:	48 89 e5             	mov    %rsp,%rbp
  803354:	48 83 ec 20          	sub    $0x20,%rsp
  803358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80335c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803364:	8b 50 0c             	mov    0xc(%rax),%edx
  803367:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80336e:	00 00 00 
  803371:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803373:	be 00 00 00 00       	mov    $0x0,%esi
  803378:	bf 05 00 00 00       	mov    $0x5,%edi
  80337d:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
  803389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803390:	79 05                	jns    803397 <devfile_stat+0x47>
		return r;
  803392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803395:	eb 56                	jmp    8033ed <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339b:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033a2:	00 00 00 
  8033a5:	48 89 c7             	mov    %rax,%rdi
  8033a8:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  8033af:	00 00 00 
  8033b2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033bb:	00 00 00 
  8033be:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033ce:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033d5:	00 00 00 
  8033d8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ed:	c9                   	leaveq 
  8033ee:	c3                   	retq   

00000000008033ef <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033ef:	55                   	push   %rbp
  8033f0:	48 89 e5             	mov    %rsp,%rbp
  8033f3:	48 83 ec 10          	sub    $0x10,%rsp
  8033f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033fb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803402:	8b 50 0c             	mov    0xc(%rax),%edx
  803405:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80340c:	00 00 00 
  80340f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803411:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803418:	00 00 00 
  80341b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803421:	be 00 00 00 00       	mov    $0x0,%esi
  803426:	bf 02 00 00 00       	mov    $0x2,%edi
  80342b:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
}
  803437:	c9                   	leaveq 
  803438:	c3                   	retq   

0000000000803439 <remove>:

// Delete a file
int
remove(const char *path)
{
  803439:	55                   	push   %rbp
  80343a:	48 89 e5             	mov    %rsp,%rbp
  80343d:	48 83 ec 10          	sub    $0x10,%rsp
  803441:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803449:	48 89 c7             	mov    %rax,%rdi
  80344c:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
  803458:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80345d:	7e 07                	jle    803466 <remove+0x2d>
		return -E_BAD_PATH;
  80345f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803464:	eb 33                	jmp    803499 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346a:	48 89 c6             	mov    %rax,%rsi
  80346d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803474:	00 00 00 
  803477:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803483:	be 00 00 00 00       	mov    $0x0,%esi
  803488:	bf 07 00 00 00       	mov    $0x7,%edi
  80348d:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
}
  803499:	c9                   	leaveq 
  80349a:	c3                   	retq   

000000000080349b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80349b:	55                   	push   %rbp
  80349c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80349f:	be 00 00 00 00       	mov    $0x0,%esi
  8034a4:	bf 08 00 00 00       	mov    $0x8,%edi
  8034a9:	48 b8 f5 2f 80 00 00 	movabs $0x802ff5,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
}
  8034b5:	5d                   	pop    %rbp
  8034b6:	c3                   	retq   

00000000008034b7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034b7:	55                   	push   %rbp
  8034b8:	48 89 e5             	mov    %rsp,%rbp
  8034bb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034c2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034c9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034d0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034d7:	be 00 00 00 00       	mov    $0x0,%esi
  8034dc:	48 89 c7             	mov    %rax,%rdi
  8034df:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
  8034eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8034ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f2:	79 28                	jns    80351c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8034f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f7:	89 c6                	mov    %eax,%esi
  8034f9:	48 bf 12 5c 80 00 00 	movabs $0x805c12,%rdi
  803500:	00 00 00 
  803503:	b8 00 00 00 00       	mov    $0x0,%eax
  803508:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  80350f:	00 00 00 
  803512:	ff d2                	callq  *%rdx
		return fd_src;
  803514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803517:	e9 74 01 00 00       	jmpq   803690 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80351c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803523:	be 01 01 00 00       	mov    $0x101,%esi
  803528:	48 89 c7             	mov    %rax,%rdi
  80352b:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
  803537:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80353a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80353e:	79 39                	jns    803579 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803540:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803543:	89 c6                	mov    %eax,%esi
  803545:	48 bf 28 5c 80 00 00 	movabs $0x805c28,%rdi
  80354c:	00 00 00 
  80354f:	b8 00 00 00 00       	mov    $0x0,%eax
  803554:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  80355b:	00 00 00 
  80355e:	ff d2                	callq  *%rdx
		close(fd_src);
  803560:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803563:	89 c7                	mov    %eax,%edi
  803565:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  80356c:	00 00 00 
  80356f:	ff d0                	callq  *%rax
		return fd_dest;
  803571:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803574:	e9 17 01 00 00       	jmpq   803690 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803579:	eb 74                	jmp    8035ef <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80357b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80357e:	48 63 d0             	movslq %eax,%rdx
  803581:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803588:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80358b:	48 89 ce             	mov    %rcx,%rsi
  80358e:	89 c7                	mov    %eax,%edi
  803590:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80359f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8035a3:	79 4a                	jns    8035ef <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8035a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035a8:	89 c6                	mov    %eax,%esi
  8035aa:	48 bf 42 5c 80 00 00 	movabs $0x805c42,%rdi
  8035b1:	00 00 00 
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b9:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  8035c0:	00 00 00 
  8035c3:	ff d2                	callq  *%rdx
			close(fd_src);
  8035c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c8:	89 c7                	mov    %eax,%edi
  8035ca:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  8035d1:	00 00 00 
  8035d4:	ff d0                	callq  *%rax
			close(fd_dest);
  8035d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d9:	89 c7                	mov    %eax,%edi
  8035db:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
			return write_size;
  8035e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035ea:	e9 a1 00 00 00       	jmpq   803690 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035ef:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f9:	ba 00 02 00 00       	mov    $0x200,%edx
  8035fe:	48 89 ce             	mov    %rcx,%rsi
  803601:	89 c7                	mov    %eax,%edi
  803603:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803612:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803616:	0f 8f 5f ff ff ff    	jg     80357b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80361c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803620:	79 47                	jns    803669 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803625:	89 c6                	mov    %eax,%esi
  803627:	48 bf 55 5c 80 00 00 	movabs $0x805c55,%rdi
  80362e:	00 00 00 
  803631:	b8 00 00 00 00       	mov    $0x0,%eax
  803636:	48 ba 71 0e 80 00 00 	movabs $0x800e71,%rdx
  80363d:	00 00 00 
  803640:	ff d2                	callq  *%rdx
		close(fd_src);
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	89 c7                	mov    %eax,%edi
  803647:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
		close(fd_dest);
  803653:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803656:	89 c7                	mov    %eax,%edi
  803658:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
		return read_size;
  803664:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803667:	eb 27                	jmp    803690 <copy+0x1d9>
	}
	close(fd_src);
  803669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366c:	89 c7                	mov    %eax,%edi
  80366e:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
	close(fd_dest);
  80367a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80367d:	89 c7                	mov    %eax,%edi
  80367f:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
	return 0;
  80368b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803690:	c9                   	leaveq 
  803691:	c3                   	retq   

0000000000803692 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803692:	55                   	push   %rbp
  803693:	48 89 e5             	mov    %rsp,%rbp
  803696:	48 83 ec 20          	sub    $0x20,%rsp
  80369a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80369d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a4:	48 89 d6             	mov    %rdx,%rsi
  8036a7:	89 c7                	mov    %eax,%edi
  8036a9:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  8036b0:	00 00 00 
  8036b3:	ff d0                	callq  *%rax
  8036b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bc:	79 05                	jns    8036c3 <fd2sockid+0x31>
		return r;
  8036be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c1:	eb 24                	jmp    8036e7 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c7:	8b 10                	mov    (%rax),%edx
  8036c9:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  8036d0:	00 00 00 
  8036d3:	8b 00                	mov    (%rax),%eax
  8036d5:	39 c2                	cmp    %eax,%edx
  8036d7:	74 07                	je     8036e0 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036de:	eb 07                	jmp    8036e7 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e4:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 83 ec 20          	sub    $0x20,%rsp
  8036f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036f8:	48 89 c7             	mov    %rax,%rdi
  8036fb:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
  803707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370e:	78 26                	js     803736 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	ba 07 04 00 00       	mov    $0x407,%edx
  803719:	48 89 c6             	mov    %rax,%rsi
  80371c:	bf 00 00 00 00       	mov    $0x0,%edi
  803721:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  803728:	00 00 00 
  80372b:	ff d0                	callq  *%rax
  80372d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803730:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803734:	79 16                	jns    80374c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803736:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803739:	89 c7                	mov    %eax,%edi
  80373b:	48 b8 f6 3b 80 00 00 	movabs $0x803bf6,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
		return r;
  803747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374a:	eb 3a                	jmp    803786 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80374c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803750:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803757:	00 00 00 
  80375a:	8b 12                	mov    (%rdx),%edx
  80375c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80375e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803762:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803770:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803777:	48 89 c7             	mov    %rax,%rdi
  80377a:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
}
  803786:	c9                   	leaveq 
  803787:	c3                   	retq   

0000000000803788 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803788:	55                   	push   %rbp
  803789:	48 89 e5             	mov    %rsp,%rbp
  80378c:	48 83 ec 30          	sub    $0x30,%rsp
  803790:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803793:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803797:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80379b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379e:	89 c7                	mov    %eax,%edi
  8037a0:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	callq  *%rax
  8037ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b3:	79 05                	jns    8037ba <accept+0x32>
		return r;
  8037b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b8:	eb 3b                	jmp    8037f5 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037be:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c5:	48 89 ce             	mov    %rcx,%rsi
  8037c8:	89 c7                	mov    %eax,%edi
  8037ca:	48 b8 d3 3a 80 00 00 	movabs $0x803ad3,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
  8037d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037dd:	79 05                	jns    8037e4 <accept+0x5c>
		return r;
  8037df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e2:	eb 11                	jmp    8037f5 <accept+0x6d>
	return alloc_sockfd(r);
  8037e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e7:	89 c7                	mov    %eax,%edi
  8037e9:	48 b8 e9 36 80 00 00 	movabs $0x8036e9,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
}
  8037f5:	c9                   	leaveq 
  8037f6:	c3                   	retq   

00000000008037f7 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037f7:	55                   	push   %rbp
  8037f8:	48 89 e5             	mov    %rsp,%rbp
  8037fb:	48 83 ec 20          	sub    $0x20,%rsp
  8037ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803802:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803806:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803809:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380c:	89 c7                	mov    %eax,%edi
  80380e:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
  80381a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803821:	79 05                	jns    803828 <bind+0x31>
		return r;
  803823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803826:	eb 1b                	jmp    803843 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803828:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80382b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80382f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803832:	48 89 ce             	mov    %rcx,%rsi
  803835:	89 c7                	mov    %eax,%edi
  803837:	48 b8 52 3b 80 00 00 	movabs $0x803b52,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <shutdown>:

int
shutdown(int s, int how)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 20          	sub    $0x20,%rsp
  80384d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803850:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803853:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803856:	89 c7                	mov    %eax,%edi
  803858:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386b:	79 05                	jns    803872 <shutdown+0x2d>
		return r;
  80386d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803870:	eb 16                	jmp    803888 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803872:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	89 d6                	mov    %edx,%esi
  80387a:	89 c7                	mov    %eax,%edi
  80387c:	48 b8 b6 3b 80 00 00 	movabs $0x803bb6,%rax
  803883:	00 00 00 
  803886:	ff d0                	callq  *%rax
}
  803888:	c9                   	leaveq 
  803889:	c3                   	retq   

000000000080388a <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80388a:	55                   	push   %rbp
  80388b:	48 89 e5             	mov    %rsp,%rbp
  80388e:	48 83 ec 10          	sub    $0x10,%rsp
  803892:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803896:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 8e 4e 80 00 00 	movabs $0x804e8e,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	83 f8 01             	cmp    $0x1,%eax
  8038ac:	75 17                	jne    8038c5 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8038ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b2:	8b 40 0c             	mov    0xc(%rax),%eax
  8038b5:	89 c7                	mov    %eax,%edi
  8038b7:	48 b8 f6 3b 80 00 00 	movabs $0x803bf6,%rax
  8038be:	00 00 00 
  8038c1:	ff d0                	callq  *%rax
  8038c3:	eb 05                	jmp    8038ca <devsock_close+0x40>
	else
		return 0;
  8038c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 20          	sub    $0x20,%rsp
  8038d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038db:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038e1:	89 c7                	mov    %eax,%edi
  8038e3:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
  8038ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f6:	79 05                	jns    8038fd <connect+0x31>
		return r;
  8038f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fb:	eb 1b                	jmp    803918 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803900:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803907:	48 89 ce             	mov    %rcx,%rsi
  80390a:	89 c7                	mov    %eax,%edi
  80390c:	48 b8 23 3c 80 00 00 	movabs $0x803c23,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
}
  803918:	c9                   	leaveq 
  803919:	c3                   	retq   

000000000080391a <listen>:

int
listen(int s, int backlog)
{
  80391a:	55                   	push   %rbp
  80391b:	48 89 e5             	mov    %rsp,%rbp
  80391e:	48 83 ec 20          	sub    $0x20,%rsp
  803922:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803925:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803928:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392b:	89 c7                	mov    %eax,%edi
  80392d:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  803934:	00 00 00 
  803937:	ff d0                	callq  *%rax
  803939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803940:	79 05                	jns    803947 <listen+0x2d>
		return r;
  803942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803945:	eb 16                	jmp    80395d <listen+0x43>
	return nsipc_listen(r, backlog);
  803947:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80394a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394d:	89 d6                	mov    %edx,%esi
  80394f:	89 c7                	mov    %eax,%edi
  803951:	48 b8 87 3c 80 00 00 	movabs $0x803c87,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
}
  80395d:	c9                   	leaveq 
  80395e:	c3                   	retq   

000000000080395f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80395f:	55                   	push   %rbp
  803960:	48 89 e5             	mov    %rsp,%rbp
  803963:	48 83 ec 20          	sub    $0x20,%rsp
  803967:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80396b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80396f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803977:	89 c2                	mov    %eax,%edx
  803979:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397d:	8b 40 0c             	mov    0xc(%rax),%eax
  803980:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803984:	b9 00 00 00 00       	mov    $0x0,%ecx
  803989:	89 c7                	mov    %eax,%edi
  80398b:	48 b8 c7 3c 80 00 00 	movabs $0x803cc7,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
}
  803997:	c9                   	leaveq 
  803998:	c3                   	retq   

0000000000803999 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803999:	55                   	push   %rbp
  80399a:	48 89 e5             	mov    %rsp,%rbp
  80399d:	48 83 ec 20          	sub    $0x20,%rsp
  8039a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8039ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b1:	89 c2                	mov    %eax,%edx
  8039b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b7:	8b 40 0c             	mov    0xc(%rax),%eax
  8039ba:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039c3:	89 c7                	mov    %eax,%edi
  8039c5:	48 b8 93 3d 80 00 00 	movabs $0x803d93,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
}
  8039d1:	c9                   	leaveq 
  8039d2:	c3                   	retq   

00000000008039d3 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039d3:	55                   	push   %rbp
  8039d4:	48 89 e5             	mov    %rsp,%rbp
  8039d7:	48 83 ec 10          	sub    $0x10,%rsp
  8039db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e7:	48 be 70 5c 80 00 00 	movabs $0x805c70,%rsi
  8039ee:	00 00 00 
  8039f1:	48 89 c7             	mov    %rax,%rdi
  8039f4:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
	return 0;
  803a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a05:	c9                   	leaveq 
  803a06:	c3                   	retq   

0000000000803a07 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a07:	55                   	push   %rbp
  803a08:	48 89 e5             	mov    %rsp,%rbp
  803a0b:	48 83 ec 20          	sub    $0x20,%rsp
  803a0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a12:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a15:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a18:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a1b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a21:	89 ce                	mov    %ecx,%esi
  803a23:	89 c7                	mov    %eax,%edi
  803a25:	48 b8 4b 3e 80 00 00 	movabs $0x803e4b,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
  803a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a38:	79 05                	jns    803a3f <socket+0x38>
		return r;
  803a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3d:	eb 11                	jmp    803a50 <socket+0x49>
	return alloc_sockfd(r);
  803a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a42:	89 c7                	mov    %eax,%edi
  803a44:	48 b8 e9 36 80 00 00 	movabs $0x8036e9,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 83 ec 10          	sub    $0x10,%rsp
  803a5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a5d:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a64:	00 00 00 
  803a67:	8b 00                	mov    (%rax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	75 1d                	jne    803a8a <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a6d:	bf 02 00 00 00       	mov    $0x2,%edi
  803a72:	48 b8 0c 4e 80 00 00 	movabs $0x804e0c,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803a85:	00 00 00 
  803a88:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a8a:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a91:	00 00 00 
  803a94:	8b 00                	mov    (%rax),%eax
  803a96:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a99:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a9e:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803aa5:	00 00 00 
  803aa8:	89 c7                	mov    %eax,%edi
  803aaa:	48 b8 aa 4d 80 00 00 	movabs $0x804daa,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  803abb:	be 00 00 00 00       	mov    $0x0,%esi
  803ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac5:	48 b8 a4 4c 80 00 00 	movabs $0x804ca4,%rax
  803acc:	00 00 00 
  803acf:	ff d0                	callq  *%rax
}
  803ad1:	c9                   	leaveq 
  803ad2:	c3                   	retq   

0000000000803ad3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ad3:	55                   	push   %rbp
  803ad4:	48 89 e5             	mov    %rsp,%rbp
  803ad7:	48 83 ec 30          	sub    $0x30,%rsp
  803adb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ade:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ae2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ae6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aed:	00 00 00 
  803af0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803af3:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803af5:	bf 01 00 00 00       	mov    $0x1,%edi
  803afa:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803b01:	00 00 00 
  803b04:	ff d0                	callq  *%rax
  803b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b0d:	78 3e                	js     803b4d <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b16:	00 00 00 
  803b19:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b21:	8b 40 10             	mov    0x10(%rax),%eax
  803b24:	89 c2                	mov    %eax,%edx
  803b26:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2e:	48 89 ce             	mov    %rcx,%rsi
  803b31:	48 89 c7             	mov    %rax,%rdi
  803b34:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b44:	8b 50 10             	mov    0x10(%rax),%edx
  803b47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b4b:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b50:	c9                   	leaveq 
  803b51:	c3                   	retq   

0000000000803b52 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b52:	55                   	push   %rbp
  803b53:	48 89 e5             	mov    %rsp,%rbp
  803b56:	48 83 ec 10          	sub    $0x10,%rsp
  803b5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b61:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b64:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b6b:	00 00 00 
  803b6e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b71:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b73:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	48 89 c6             	mov    %rax,%rsi
  803b7d:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b84:	00 00 00 
  803b87:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b93:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b9a:	00 00 00 
  803b9d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ba0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ba3:	bf 02 00 00 00       	mov    $0x2,%edi
  803ba8:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
}
  803bb4:	c9                   	leaveq 
  803bb5:	c3                   	retq   

0000000000803bb6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803bb6:	55                   	push   %rbp
  803bb7:	48 89 e5             	mov    %rsp,%rbp
  803bba:	48 83 ec 10          	sub    $0x10,%rsp
  803bbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bc1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803bc4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bcb:	00 00 00 
  803bce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bd1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bd3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bda:	00 00 00 
  803bdd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803be0:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803be3:	bf 03 00 00 00       	mov    $0x3,%edi
  803be8:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803bef:	00 00 00 
  803bf2:	ff d0                	callq  *%rax
}
  803bf4:	c9                   	leaveq 
  803bf5:	c3                   	retq   

0000000000803bf6 <nsipc_close>:

int
nsipc_close(int s)
{
  803bf6:	55                   	push   %rbp
  803bf7:	48 89 e5             	mov    %rsp,%rbp
  803bfa:	48 83 ec 10          	sub    $0x10,%rsp
  803bfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c01:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c08:	00 00 00 
  803c0b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c0e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c10:	bf 04 00 00 00       	mov    $0x4,%edi
  803c15:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803c1c:	00 00 00 
  803c1f:	ff d0                	callq  *%rax
}
  803c21:	c9                   	leaveq 
  803c22:	c3                   	retq   

0000000000803c23 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c23:	55                   	push   %rbp
  803c24:	48 89 e5             	mov    %rsp,%rbp
  803c27:	48 83 ec 10          	sub    $0x10,%rsp
  803c2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c32:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c35:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3c:	00 00 00 
  803c3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c42:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c44:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4b:	48 89 c6             	mov    %rax,%rsi
  803c4e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c55:	00 00 00 
  803c58:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c64:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6b:	00 00 00 
  803c6e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c71:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c74:	bf 05 00 00 00       	mov    $0x5,%edi
  803c79:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	callq  *%rax
}
  803c85:	c9                   	leaveq 
  803c86:	c3                   	retq   

0000000000803c87 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c87:	55                   	push   %rbp
  803c88:	48 89 e5             	mov    %rsp,%rbp
  803c8b:	48 83 ec 10          	sub    $0x10,%rsp
  803c8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c92:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c9c:	00 00 00 
  803c9f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ca2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ca4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cab:	00 00 00 
  803cae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb1:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803cb4:	bf 06 00 00 00       	mov    $0x6,%edi
  803cb9:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803cc0:	00 00 00 
  803cc3:	ff d0                	callq  *%rax
}
  803cc5:	c9                   	leaveq 
  803cc6:	c3                   	retq   

0000000000803cc7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cc7:	55                   	push   %rbp
  803cc8:	48 89 e5             	mov    %rsp,%rbp
  803ccb:	48 83 ec 30          	sub    $0x30,%rsp
  803ccf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cd6:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cd9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cdc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce3:	00 00 00 
  803ce6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ce9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ceb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf2:	00 00 00 
  803cf5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cf8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803cfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d02:	00 00 00 
  803d05:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d08:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d0b:	bf 07 00 00 00       	mov    $0x7,%edi
  803d10:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
  803d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d23:	78 69                	js     803d8e <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d25:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d2c:	7f 08                	jg     803d36 <nsipc_recv+0x6f>
  803d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d31:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d34:	7e 35                	jle    803d6b <nsipc_recv+0xa4>
  803d36:	48 b9 77 5c 80 00 00 	movabs $0x805c77,%rcx
  803d3d:	00 00 00 
  803d40:	48 ba 8c 5c 80 00 00 	movabs $0x805c8c,%rdx
  803d47:	00 00 00 
  803d4a:	be 61 00 00 00       	mov    $0x61,%esi
  803d4f:	48 bf a1 5c 80 00 00 	movabs $0x805ca1,%rdi
  803d56:	00 00 00 
  803d59:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5e:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  803d65:	00 00 00 
  803d68:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	48 63 d0             	movslq %eax,%rdx
  803d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d75:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d7c:	00 00 00 
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
	}

	return r;
  803d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d91:	c9                   	leaveq 
  803d92:	c3                   	retq   

0000000000803d93 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d93:	55                   	push   %rbp
  803d94:	48 89 e5             	mov    %rsp,%rbp
  803d97:	48 83 ec 20          	sub    $0x20,%rsp
  803d9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803da2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803da5:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803da8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803daf:	00 00 00 
  803db2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803db5:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803db7:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803dbe:	7e 35                	jle    803df5 <nsipc_send+0x62>
  803dc0:	48 b9 ad 5c 80 00 00 	movabs $0x805cad,%rcx
  803dc7:	00 00 00 
  803dca:	48 ba 8c 5c 80 00 00 	movabs $0x805c8c,%rdx
  803dd1:	00 00 00 
  803dd4:	be 6c 00 00 00       	mov    $0x6c,%esi
  803dd9:	48 bf a1 5c 80 00 00 	movabs $0x805ca1,%rdi
  803de0:	00 00 00 
  803de3:	b8 00 00 00 00       	mov    $0x0,%eax
  803de8:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  803def:	00 00 00 
  803df2:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803df5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df8:	48 63 d0             	movslq %eax,%rdx
  803dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dff:	48 89 c6             	mov    %rax,%rsi
  803e02:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e09:	00 00 00 
  803e0c:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e18:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e1f:	00 00 00 
  803e22:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e25:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e28:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e2f:	00 00 00 
  803e32:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e35:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e38:	bf 08 00 00 00       	mov    $0x8,%edi
  803e3d:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803e44:	00 00 00 
  803e47:	ff d0                	callq  *%rax
}
  803e49:	c9                   	leaveq 
  803e4a:	c3                   	retq   

0000000000803e4b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e4b:	55                   	push   %rbp
  803e4c:	48 89 e5             	mov    %rsp,%rbp
  803e4f:	48 83 ec 10          	sub    $0x10,%rsp
  803e53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e56:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e59:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e5c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e63:	00 00 00 
  803e66:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e69:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e6b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e72:	00 00 00 
  803e75:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e78:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e7b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e82:	00 00 00 
  803e85:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e88:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e8b:	bf 09 00 00 00       	mov    $0x9,%edi
  803e90:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803e97:	00 00 00 
  803e9a:	ff d0                	callq  *%rax
}
  803e9c:	c9                   	leaveq 
  803e9d:	c3                   	retq   

0000000000803e9e <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803e9e:	55                   	push   %rbp
  803e9f:	48 89 e5             	mov    %rsp,%rbp
  803ea2:	48 83 ec 20          	sub    $0x20,%rsp
  803ea6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803eae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb6:	48 01 d0             	add    %rdx,%rax
  803eb9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803ec5:	eb 64                	jmp    803f2b <isfree+0x8d>
		if (va >= (uintptr_t) mend
  803ec7:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803ece:	00 00 00 
  803ed1:	48 8b 00             	mov    (%rax),%rax
  803ed4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803ed8:	76 42                	jbe    803f1c <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ede:	48 c1 e8 15          	shr    $0x15,%rax
  803ee2:	48 89 c2             	mov    %rax,%rdx
  803ee5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eec:	01 00 00 
  803eef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ef3:	83 e0 01             	and    $0x1,%eax
  803ef6:	48 85 c0             	test   %rax,%rax
  803ef9:	74 28                	je     803f23 <isfree+0x85>
  803efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eff:	48 c1 e8 0c          	shr    $0xc,%rax
  803f03:	48 89 c2             	mov    %rax,%rdx
  803f06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f0d:	01 00 00 
  803f10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f14:	83 e0 01             	and    $0x1,%eax
  803f17:	48 85 c0             	test   %rax,%rax
  803f1a:	74 07                	je     803f23 <isfree+0x85>
			return 0;
  803f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f21:	eb 17                	jmp    803f3a <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803f23:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f2a:	00 
  803f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803f33:	72 92                	jb     803ec7 <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803f35:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f3a:	c9                   	leaveq 
  803f3b:	c3                   	retq   

0000000000803f3c <malloc>:

void*
malloc(size_t n)
{
  803f3c:	55                   	push   %rbp
  803f3d:	48 89 e5             	mov    %rsp,%rbp
  803f40:	48 83 ec 60          	sub    $0x60,%rsp
  803f44:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803f48:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f4f:	00 00 00 
  803f52:	48 8b 00             	mov    (%rax),%rax
  803f55:	48 85 c0             	test   %rax,%rax
  803f58:	75 1a                	jne    803f74 <malloc+0x38>
		mptr = mbegin;
  803f5a:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803f61:	00 00 00 
  803f64:	48 8b 10             	mov    (%rax),%rdx
  803f67:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f6e:	00 00 00 
  803f71:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803f74:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803f7b:	00 
  803f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f80:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803f84:	48 01 d0             	add    %rdx,%rax
  803f87:	48 83 e8 01          	sub    $0x1,%rax
  803f8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f93:	ba 00 00 00 00       	mov    $0x0,%edx
  803f98:	48 f7 75 f0          	divq   -0x10(%rbp)
  803f9c:	48 89 d0             	mov    %rdx,%rax
  803f9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fa3:	48 29 c2             	sub    %rax,%rdx
  803fa6:	48 89 d0             	mov    %rdx,%rax
  803fa9:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  803fad:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  803fb4:	00 
  803fb5:	76 0a                	jbe    803fc1 <malloc+0x85>
		return 0;
  803fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbc:	e9 f7 02 00 00       	jmpq   8042b8 <malloc+0x37c>

	if ((uintptr_t) mptr % PGSIZE){
  803fc1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fc8:	00 00 00 
  803fcb:	48 8b 00             	mov    (%rax),%rax
  803fce:	25 ff 0f 00 00       	and    $0xfff,%eax
  803fd3:	48 85 c0             	test   %rax,%rax
  803fd6:	0f 84 15 01 00 00    	je     8040f1 <malloc+0x1b5>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803fdc:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803fe3:	00 
  803fe4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803feb:	00 00 00 
  803fee:	48 8b 00             	mov    (%rax),%rax
  803ff1:	48 89 c2             	mov    %rax,%rdx
  803ff4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff8:	48 01 d0             	add    %rdx,%rax
  803ffb:	48 83 e8 01          	sub    $0x1,%rax
  803fff:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804003:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804007:	ba 00 00 00 00       	mov    $0x0,%edx
  80400c:	48 f7 75 e0          	divq   -0x20(%rbp)
  804010:	48 89 d0             	mov    %rdx,%rax
  804013:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804017:	48 29 c2             	sub    %rax,%rdx
  80401a:	48 89 d0             	mov    %rdx,%rax
  80401d:	48 83 e8 04          	sub    $0x4,%rax
  804021:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  804025:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80402c:	00 00 00 
  80402f:	48 8b 00             	mov    (%rax),%rax
  804032:	48 c1 e8 0c          	shr    $0xc,%rax
  804036:	48 89 c1             	mov    %rax,%rcx
  804039:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804040:	00 00 00 
  804043:	48 8b 00             	mov    (%rax),%rax
  804046:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80404a:	48 83 c2 03          	add    $0x3,%rdx
  80404e:	48 01 d0             	add    %rdx,%rax
  804051:	48 c1 e8 0c          	shr    $0xc,%rax
  804055:	48 39 c1             	cmp    %rax,%rcx
  804058:	75 4a                	jne    8040a4 <malloc+0x168>
			(*ref)++;
  80405a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80405e:	8b 00                	mov    (%rax),%eax
  804060:	8d 50 01             	lea    0x1(%rax),%edx
  804063:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804067:	89 10                	mov    %edx,(%rax)
			v = mptr;
  804069:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804070:	00 00 00 
  804073:	48 8b 00             	mov    (%rax),%rax
  804076:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  80407a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804081:	00 00 00 
  804084:	48 8b 10             	mov    (%rax),%rdx
  804087:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80408b:	48 01 c2             	add    %rax,%rdx
  80408e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804095:	00 00 00 
  804098:	48 89 10             	mov    %rdx,(%rax)
			return v;
  80409b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80409f:	e9 14 02 00 00       	jmpq   8042b8 <malloc+0x37c>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  8040a4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040ab:	00 00 00 
  8040ae:	48 8b 00             	mov    (%rax),%rax
  8040b1:	48 89 c7             	mov    %rax,%rdi
  8040b4:	48 b8 ba 42 80 00 00 	movabs $0x8042ba,%rax
  8040bb:	00 00 00 
  8040be:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8040c0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040c7:	00 00 00 
  8040ca:	48 8b 00             	mov    (%rax),%rax
  8040cd:	48 05 00 10 00 00    	add    $0x1000,%rax
  8040d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8040d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040db:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8040e1:	48 89 c2             	mov    %rax,%rdx
  8040e4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8040eb:	00 00 00 
  8040ee:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  8040f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  8040f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8040fc:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804100:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804107:	00 00 00 
  80410a:	48 8b 00             	mov    (%rax),%rax
  80410d:	48 89 d6             	mov    %rdx,%rsi
  804110:	48 89 c7             	mov    %rax,%rdi
  804113:	48 b8 9e 3e 80 00 00 	movabs $0x803e9e,%rax
  80411a:	00 00 00 
  80411d:	ff d0                	callq  *%rax
  80411f:	85 c0                	test   %eax,%eax
  804121:	74 0d                	je     804130 <malloc+0x1f4>
			break;
  804123:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  804124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80412b:	e9 14 01 00 00       	jmpq   804244 <malloc+0x308>
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
  804130:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804137:	00 00 00 
  80413a:	48 8b 00             	mov    (%rax),%rax
  80413d:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  804144:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80414b:	00 00 00 
  80414e:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  804151:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804158:	00 00 00 
  80415b:	48 8b 10             	mov    (%rax),%rdx
  80415e:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804165:	00 00 00 
  804168:	48 8b 00             	mov    (%rax),%rax
  80416b:	48 39 c2             	cmp    %rax,%rdx
  80416e:	75 2e                	jne    80419e <malloc+0x262>
			mptr = mbegin;
  804170:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  804177:	00 00 00 
  80417a:	48 8b 10             	mov    (%rax),%rdx
  80417d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804184:	00 00 00 
  804187:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  80418a:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80418e:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  804192:	75 0a                	jne    80419e <malloc+0x262>
				return 0;	/* out of address space */
  804194:	b8 00 00 00 00       	mov    $0x0,%eax
  804199:	e9 1a 01 00 00       	jmpq   8042b8 <malloc+0x37c>
		}
	}
  80419e:	e9 55 ff ff ff       	jmpq   8040f8 <malloc+0x1bc>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8041a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a6:	05 00 10 00 00       	add    $0x1000,%eax
  8041ab:	48 98                	cltq   
  8041ad:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8041b1:	48 83 c2 04          	add    $0x4,%rdx
  8041b5:	48 39 d0             	cmp    %rdx,%rax
  8041b8:	73 07                	jae    8041c1 <malloc+0x285>
  8041ba:	b8 00 04 00 00       	mov    $0x400,%eax
  8041bf:	eb 05                	jmp    8041c6 <malloc+0x28a>
  8041c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c6:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8041c9:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8041cc:	83 c8 07             	or     $0x7,%eax
  8041cf:	89 c2                	mov    %eax,%edx
  8041d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041d8:	00 00 00 
  8041db:	48 8b 08             	mov    (%rax),%rcx
  8041de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e1:	48 98                	cltq   
  8041e3:	48 01 c8             	add    %rcx,%rax
  8041e6:	48 89 c6             	mov    %rax,%rsi
  8041e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ee:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  8041f5:	00 00 00 
  8041f8:	ff d0                	callq  *%rax
  8041fa:	85 c0                	test   %eax,%eax
  8041fc:	79 3f                	jns    80423d <malloc+0x301>
			for (; i >= 0; i -= PGSIZE)
  8041fe:	eb 30                	jmp    804230 <malloc+0x2f4>
				sys_page_unmap(0, mptr + i);
  804200:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804207:	00 00 00 
  80420a:	48 8b 10             	mov    (%rax),%rdx
  80420d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804210:	48 98                	cltq   
  804212:	48 01 d0             	add    %rdx,%rax
  804215:	48 89 c6             	mov    %rax,%rsi
  804218:	bf 00 00 00 00       	mov    $0x0,%edi
  80421d:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  804224:	00 00 00 
  804227:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  804229:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  804230:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804234:	79 ca                	jns    804200 <malloc+0x2c4>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  804236:	b8 00 00 00 00       	mov    $0x0,%eax
  80423b:	eb 7b                	jmp    8042b8 <malloc+0x37c>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  80423d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804247:	48 98                	cltq   
  804249:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80424d:	48 83 c2 04          	add    $0x4,%rdx
  804251:	48 39 d0             	cmp    %rdx,%rax
  804254:	0f 82 49 ff ff ff    	jb     8041a3 <malloc+0x267>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  80425a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804261:	00 00 00 
  804264:	48 8b 00             	mov    (%rax),%rax
  804267:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80426a:	48 63 d2             	movslq %edx,%rdx
  80426d:	48 83 ea 04          	sub    $0x4,%rdx
  804271:	48 01 d0             	add    %rdx,%rax
  804274:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  804278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80427c:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  804282:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804289:	00 00 00 
  80428c:	48 8b 00             	mov    (%rax),%rax
  80428f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  804293:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80429a:	00 00 00 
  80429d:	48 8b 10             	mov    (%rax),%rdx
  8042a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8042a4:	48 01 c2             	add    %rax,%rdx
  8042a7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042ae:	00 00 00 
  8042b1:	48 89 10             	mov    %rdx,(%rax)
	return v;
  8042b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  8042b8:	c9                   	leaveq 
  8042b9:	c3                   	retq   

00000000008042ba <free>:

void
free(void *v)
{
  8042ba:	55                   	push   %rbp
  8042bb:	48 89 e5             	mov    %rsp,%rbp
  8042be:	48 83 ec 30          	sub    $0x30,%rsp
  8042c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8042c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042cb:	75 05                	jne    8042d2 <free+0x18>
		return;
  8042cd:	e9 54 01 00 00       	jmpq   804426 <free+0x16c>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8042d2:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  8042d9:	00 00 00 
  8042dc:	48 8b 00             	mov    (%rax),%rax
  8042df:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8042e3:	77 13                	ja     8042f8 <free+0x3e>
  8042e5:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8042ec:	00 00 00 
  8042ef:	48 8b 00             	mov    (%rax),%rax
  8042f2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8042f6:	72 35                	jb     80432d <free+0x73>
  8042f8:	48 b9 c0 5c 80 00 00 	movabs $0x805cc0,%rcx
  8042ff:	00 00 00 
  804302:	48 ba ee 5c 80 00 00 	movabs $0x805cee,%rdx
  804309:	00 00 00 
  80430c:	be 7a 00 00 00       	mov    $0x7a,%esi
  804311:	48 bf 03 5d 80 00 00 	movabs $0x805d03,%rdi
  804318:	00 00 00 
  80431b:	b8 00 00 00 00       	mov    $0x0,%eax
  804320:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  804327:	00 00 00 
  80432a:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  80432d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804331:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  804335:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804339:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80433f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  804343:	eb 7b                	jmp    8043c0 <free+0x106>
		sys_page_unmap(0, c);
  804345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804349:	48 89 c6             	mov    %rax,%rsi
  80434c:	bf 00 00 00 00       	mov    $0x0,%edi
  804351:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  804358:	00 00 00 
  80435b:	ff d0                	callq  *%rax
		c += PGSIZE;
  80435d:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  804364:	00 
		assert(mbegin <= c && c < mend);
  804365:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  80436c:	00 00 00 
  80436f:	48 8b 00             	mov    (%rax),%rax
  804372:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  804376:	77 13                	ja     80438b <free+0xd1>
  804378:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80437f:	00 00 00 
  804382:	48 8b 00             	mov    (%rax),%rax
  804385:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  804389:	72 35                	jb     8043c0 <free+0x106>
  80438b:	48 b9 10 5d 80 00 00 	movabs $0x805d10,%rcx
  804392:	00 00 00 
  804395:	48 ba ee 5c 80 00 00 	movabs $0x805cee,%rdx
  80439c:	00 00 00 
  80439f:	be 81 00 00 00       	mov    $0x81,%esi
  8043a4:	48 bf 03 5d 80 00 00 	movabs $0x805d03,%rdi
  8043ab:	00 00 00 
  8043ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b3:	49 b8 38 0c 80 00 00 	movabs $0x800c38,%r8
  8043ba:	00 00 00 
  8043bd:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8043c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8043c8:	48 89 c2             	mov    %rax,%rdx
  8043cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043d2:	01 00 00 
  8043d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043d9:	25 00 04 00 00       	and    $0x400,%eax
  8043de:	48 85 c0             	test   %rax,%rax
  8043e1:	0f 85 5e ff ff ff    	jne    804345 <free+0x8b>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  8043e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043eb:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  8043f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  8043f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f9:	8b 00                	mov    (%rax),%eax
  8043fb:	8d 50 ff             	lea    -0x1(%rax),%edx
  8043fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804402:	89 10                	mov    %edx,(%rax)
  804404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804408:	8b 00                	mov    (%rax),%eax
  80440a:	85 c0                	test   %eax,%eax
  80440c:	75 18                	jne    804426 <free+0x16c>
		sys_page_unmap(0, c);
  80440e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804412:	48 89 c6             	mov    %rax,%rsi
  804415:	bf 00 00 00 00       	mov    $0x0,%edi
  80441a:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  804421:	00 00 00 
  804424:	ff d0                	callq  *%rax
}
  804426:	c9                   	leaveq 
  804427:	c3                   	retq   

0000000000804428 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804428:	55                   	push   %rbp
  804429:	48 89 e5             	mov    %rsp,%rbp
  80442c:	53                   	push   %rbx
  80442d:	48 83 ec 38          	sub    $0x38,%rsp
  804431:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804435:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804439:	48 89 c7             	mov    %rax,%rdi
  80443c:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  804443:	00 00 00 
  804446:	ff d0                	callq  *%rax
  804448:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80444b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80444f:	0f 88 bf 01 00 00    	js     804614 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804459:	ba 07 04 00 00       	mov    $0x407,%edx
  80445e:	48 89 c6             	mov    %rax,%rsi
  804461:	bf 00 00 00 00       	mov    $0x0,%edi
  804466:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  80446d:	00 00 00 
  804470:	ff d0                	callq  *%rax
  804472:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804475:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804479:	0f 88 95 01 00 00    	js     804614 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80447f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804483:	48 89 c7             	mov    %rax,%rdi
  804486:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
  804492:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804495:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804499:	0f 88 5d 01 00 00    	js     8045fc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80449f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a3:	ba 07 04 00 00       	mov    $0x407,%edx
  8044a8:	48 89 c6             	mov    %rax,%rsi
  8044ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8044b0:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  8044b7:	00 00 00 
  8044ba:	ff d0                	callq  *%rax
  8044bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044c3:	0f 88 33 01 00 00    	js     8045fc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8044c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044cd:	48 89 c7             	mov    %rax,%rdi
  8044d0:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  8044d7:	00 00 00 
  8044da:	ff d0                	callq  *%rax
  8044dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8044e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8044e9:	48 89 c6             	mov    %rax,%rsi
  8044ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8044f1:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  8044f8:	00 00 00 
  8044fb:	ff d0                	callq  *%rax
  8044fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804500:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804504:	79 05                	jns    80450b <pipe+0xe3>
		goto err2;
  804506:	e9 d9 00 00 00       	jmpq   8045e4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80450b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80450f:	48 89 c7             	mov    %rax,%rdi
  804512:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  804519:	00 00 00 
  80451c:	ff d0                	callq  *%rax
  80451e:	48 89 c2             	mov    %rax,%rdx
  804521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804525:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80452b:	48 89 d1             	mov    %rdx,%rcx
  80452e:	ba 00 00 00 00       	mov    $0x0,%edx
  804533:	48 89 c6             	mov    %rax,%rsi
  804536:	bf 00 00 00 00       	mov    $0x0,%edi
  80453b:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  804542:	00 00 00 
  804545:	ff d0                	callq  *%rax
  804547:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80454a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80454e:	79 1b                	jns    80456b <pipe+0x143>
		goto err3;
  804550:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804555:	48 89 c6             	mov    %rax,%rsi
  804558:	bf 00 00 00 00       	mov    $0x0,%edi
  80455d:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  804564:	00 00 00 
  804567:	ff d0                	callq  *%rax
  804569:	eb 79                	jmp    8045e4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80456b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80456f:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804576:	00 00 00 
  804579:	8b 12                	mov    (%rdx),%edx
  80457b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80457d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804581:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804588:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80458c:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804593:	00 00 00 
  804596:	8b 12                	mov    (%rdx),%edx
  804598:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80459a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80459e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8045a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a9:	48 89 c7             	mov    %rax,%rdi
  8045ac:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  8045b3:	00 00 00 
  8045b6:	ff d0                	callq  *%rax
  8045b8:	89 c2                	mov    %eax,%edx
  8045ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045be:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8045c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045c4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8045c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045cc:	48 89 c7             	mov    %rax,%rdi
  8045cf:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  8045d6:	00 00 00 
  8045d9:	ff d0                	callq  *%rax
  8045db:	89 03                	mov    %eax,(%rbx)
	return 0;
  8045dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e2:	eb 33                	jmp    804617 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8045e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045e8:	48 89 c6             	mov    %rax,%rsi
  8045eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8045f0:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8045f7:	00 00 00 
  8045fa:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8045fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804600:	48 89 c6             	mov    %rax,%rsi
  804603:	bf 00 00 00 00       	mov    $0x0,%edi
  804608:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  80460f:	00 00 00 
  804612:	ff d0                	callq  *%rax
err:
	return r;
  804614:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804617:	48 83 c4 38          	add    $0x38,%rsp
  80461b:	5b                   	pop    %rbx
  80461c:	5d                   	pop    %rbp
  80461d:	c3                   	retq   

000000000080461e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80461e:	55                   	push   %rbp
  80461f:	48 89 e5             	mov    %rsp,%rbp
  804622:	53                   	push   %rbx
  804623:	48 83 ec 28          	sub    $0x28,%rsp
  804627:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80462b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80462f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804636:	00 00 00 
  804639:	48 8b 00             	mov    (%rax),%rax
  80463c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804642:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804649:	48 89 c7             	mov    %rax,%rdi
  80464c:	48 b8 8e 4e 80 00 00 	movabs $0x804e8e,%rax
  804653:	00 00 00 
  804656:	ff d0                	callq  *%rax
  804658:	89 c3                	mov    %eax,%ebx
  80465a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80465e:	48 89 c7             	mov    %rax,%rdi
  804661:	48 b8 8e 4e 80 00 00 	movabs $0x804e8e,%rax
  804668:	00 00 00 
  80466b:	ff d0                	callq  *%rax
  80466d:	39 c3                	cmp    %eax,%ebx
  80466f:	0f 94 c0             	sete   %al
  804672:	0f b6 c0             	movzbl %al,%eax
  804675:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804678:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80467f:	00 00 00 
  804682:	48 8b 00             	mov    (%rax),%rax
  804685:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80468b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80468e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804691:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804694:	75 05                	jne    80469b <_pipeisclosed+0x7d>
			return ret;
  804696:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804699:	eb 4f                	jmp    8046ea <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80469b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80469e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8046a1:	74 42                	je     8046e5 <_pipeisclosed+0xc7>
  8046a3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8046a7:	75 3c                	jne    8046e5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8046a9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8046b0:	00 00 00 
  8046b3:	48 8b 00             	mov    (%rax),%rax
  8046b6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8046bc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8046bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046c2:	89 c6                	mov    %eax,%esi
  8046c4:	48 bf 2d 5d 80 00 00 	movabs $0x805d2d,%rdi
  8046cb:	00 00 00 
  8046ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d3:	49 b8 71 0e 80 00 00 	movabs $0x800e71,%r8
  8046da:	00 00 00 
  8046dd:	41 ff d0             	callq  *%r8
	}
  8046e0:	e9 4a ff ff ff       	jmpq   80462f <_pipeisclosed+0x11>
  8046e5:	e9 45 ff ff ff       	jmpq   80462f <_pipeisclosed+0x11>
}
  8046ea:	48 83 c4 28          	add    $0x28,%rsp
  8046ee:	5b                   	pop    %rbx
  8046ef:	5d                   	pop    %rbp
  8046f0:	c3                   	retq   

00000000008046f1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8046f1:	55                   	push   %rbp
  8046f2:	48 89 e5             	mov    %rsp,%rbp
  8046f5:	48 83 ec 30          	sub    $0x30,%rsp
  8046f9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8046fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804700:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804703:	48 89 d6             	mov    %rdx,%rsi
  804706:	89 c7                	mov    %eax,%edi
  804708:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  80470f:	00 00 00 
  804712:	ff d0                	callq  *%rax
  804714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80471b:	79 05                	jns    804722 <pipeisclosed+0x31>
		return r;
  80471d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804720:	eb 31                	jmp    804753 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804726:	48 89 c7             	mov    %rax,%rdi
  804729:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  804730:	00 00 00 
  804733:	ff d0                	callq  *%rax
  804735:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804741:	48 89 d6             	mov    %rdx,%rsi
  804744:	48 89 c7             	mov    %rax,%rdi
  804747:	48 b8 1e 46 80 00 00 	movabs $0x80461e,%rax
  80474e:	00 00 00 
  804751:	ff d0                	callq  *%rax
}
  804753:	c9                   	leaveq 
  804754:	c3                   	retq   

0000000000804755 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804755:	55                   	push   %rbp
  804756:	48 89 e5             	mov    %rsp,%rbp
  804759:	48 83 ec 40          	sub    $0x40,%rsp
  80475d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804761:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804765:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80476d:	48 89 c7             	mov    %rax,%rdi
  804770:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  804777:	00 00 00 
  80477a:	ff d0                	callq  *%rax
  80477c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804784:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804788:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80478f:	00 
  804790:	e9 92 00 00 00       	jmpq   804827 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804795:	eb 41                	jmp    8047d8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804797:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80479c:	74 09                	je     8047a7 <devpipe_read+0x52>
				return i;
  80479e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047a2:	e9 92 00 00 00       	jmpq   804839 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8047a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047af:	48 89 d6             	mov    %rdx,%rsi
  8047b2:	48 89 c7             	mov    %rax,%rdi
  8047b5:	48 b8 1e 46 80 00 00 	movabs $0x80461e,%rax
  8047bc:	00 00 00 
  8047bf:	ff d0                	callq  *%rax
  8047c1:	85 c0                	test   %eax,%eax
  8047c3:	74 07                	je     8047cc <devpipe_read+0x77>
				return 0;
  8047c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ca:	eb 6d                	jmp    804839 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8047cc:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8047d3:	00 00 00 
  8047d6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8047d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047dc:	8b 10                	mov    (%rax),%edx
  8047de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e2:	8b 40 04             	mov    0x4(%rax),%eax
  8047e5:	39 c2                	cmp    %eax,%edx
  8047e7:	74 ae                	je     804797 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8047e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047f1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8047f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047f9:	8b 00                	mov    (%rax),%eax
  8047fb:	99                   	cltd   
  8047fc:	c1 ea 1b             	shr    $0x1b,%edx
  8047ff:	01 d0                	add    %edx,%eax
  804801:	83 e0 1f             	and    $0x1f,%eax
  804804:	29 d0                	sub    %edx,%eax
  804806:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80480a:	48 98                	cltq   
  80480c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804811:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804817:	8b 00                	mov    (%rax),%eax
  804819:	8d 50 01             	lea    0x1(%rax),%edx
  80481c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804820:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804822:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80482f:	0f 82 60 ff ff ff    	jb     804795 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804835:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804839:	c9                   	leaveq 
  80483a:	c3                   	retq   

000000000080483b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80483b:	55                   	push   %rbp
  80483c:	48 89 e5             	mov    %rsp,%rbp
  80483f:	48 83 ec 40          	sub    $0x40,%rsp
  804843:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804847:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80484b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80484f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804853:	48 89 c7             	mov    %rax,%rdi
  804856:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80485d:	00 00 00 
  804860:	ff d0                	callq  *%rax
  804862:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804866:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80486a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80486e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804875:	00 
  804876:	e9 8e 00 00 00       	jmpq   804909 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80487b:	eb 31                	jmp    8048ae <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80487d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804885:	48 89 d6             	mov    %rdx,%rsi
  804888:	48 89 c7             	mov    %rax,%rdi
  80488b:	48 b8 1e 46 80 00 00 	movabs $0x80461e,%rax
  804892:	00 00 00 
  804895:	ff d0                	callq  *%rax
  804897:	85 c0                	test   %eax,%eax
  804899:	74 07                	je     8048a2 <devpipe_write+0x67>
				return 0;
  80489b:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a0:	eb 79                	jmp    80491b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8048a2:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8048a9:	00 00 00 
  8048ac:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8048ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048b2:	8b 40 04             	mov    0x4(%rax),%eax
  8048b5:	48 63 d0             	movslq %eax,%rdx
  8048b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048bc:	8b 00                	mov    (%rax),%eax
  8048be:	48 98                	cltq   
  8048c0:	48 83 c0 20          	add    $0x20,%rax
  8048c4:	48 39 c2             	cmp    %rax,%rdx
  8048c7:	73 b4                	jae    80487d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8048c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048cd:	8b 40 04             	mov    0x4(%rax),%eax
  8048d0:	99                   	cltd   
  8048d1:	c1 ea 1b             	shr    $0x1b,%edx
  8048d4:	01 d0                	add    %edx,%eax
  8048d6:	83 e0 1f             	and    $0x1f,%eax
  8048d9:	29 d0                	sub    %edx,%eax
  8048db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8048df:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8048e3:	48 01 ca             	add    %rcx,%rdx
  8048e6:	0f b6 0a             	movzbl (%rdx),%ecx
  8048e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048ed:	48 98                	cltq   
  8048ef:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8048f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048f7:	8b 40 04             	mov    0x4(%rax),%eax
  8048fa:	8d 50 01             	lea    0x1(%rax),%edx
  8048fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804901:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804904:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804909:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80490d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804911:	0f 82 64 ff ff ff    	jb     80487b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80491b:	c9                   	leaveq 
  80491c:	c3                   	retq   

000000000080491d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80491d:	55                   	push   %rbp
  80491e:	48 89 e5             	mov    %rsp,%rbp
  804921:	48 83 ec 20          	sub    $0x20,%rsp
  804925:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804929:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80492d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804931:	48 89 c7             	mov    %rax,%rdi
  804934:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  80493b:	00 00 00 
  80493e:	ff d0                	callq  *%rax
  804940:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804944:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804948:	48 be 40 5d 80 00 00 	movabs $0x805d40,%rsi
  80494f:	00 00 00 
  804952:	48 89 c7             	mov    %rax,%rdi
  804955:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  80495c:	00 00 00 
  80495f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804961:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804965:	8b 50 04             	mov    0x4(%rax),%edx
  804968:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80496c:	8b 00                	mov    (%rax),%eax
  80496e:	29 c2                	sub    %eax,%edx
  804970:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804974:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80497a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80497e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804985:	00 00 00 
	stat->st_dev = &devpipe;
  804988:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80498c:	48 b9 40 71 80 00 00 	movabs $0x807140,%rcx
  804993:	00 00 00 
  804996:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80499d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049a2:	c9                   	leaveq 
  8049a3:	c3                   	retq   

00000000008049a4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8049a4:	55                   	push   %rbp
  8049a5:	48 89 e5             	mov    %rsp,%rbp
  8049a8:	48 83 ec 10          	sub    $0x10,%rsp
  8049ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8049b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049b4:	48 89 c6             	mov    %rax,%rsi
  8049b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8049bc:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8049c3:	00 00 00 
  8049c6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8049c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049cc:	48 89 c7             	mov    %rax,%rdi
  8049cf:	48 b8 b1 26 80 00 00 	movabs $0x8026b1,%rax
  8049d6:	00 00 00 
  8049d9:	ff d0                	callq  *%rax
  8049db:	48 89 c6             	mov    %rax,%rsi
  8049de:	bf 00 00 00 00       	mov    $0x0,%edi
  8049e3:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8049ea:	00 00 00 
  8049ed:	ff d0                	callq  *%rax
}
  8049ef:	c9                   	leaveq 
  8049f0:	c3                   	retq   

00000000008049f1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8049f1:	55                   	push   %rbp
  8049f2:	48 89 e5             	mov    %rsp,%rbp
  8049f5:	48 83 ec 20          	sub    $0x20,%rsp
  8049f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8049fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049ff:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804a02:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804a06:	be 01 00 00 00       	mov    $0x1,%esi
  804a0b:	48 89 c7             	mov    %rax,%rdi
  804a0e:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  804a15:	00 00 00 
  804a18:	ff d0                	callq  *%rax
}
  804a1a:	c9                   	leaveq 
  804a1b:	c3                   	retq   

0000000000804a1c <getchar>:

int
getchar(void)
{
  804a1c:	55                   	push   %rbp
  804a1d:	48 89 e5             	mov    %rsp,%rbp
  804a20:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804a24:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804a28:	ba 01 00 00 00       	mov    $0x1,%edx
  804a2d:	48 89 c6             	mov    %rax,%rsi
  804a30:	bf 00 00 00 00       	mov    $0x0,%edi
  804a35:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  804a3c:	00 00 00 
  804a3f:	ff d0                	callq  *%rax
  804a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a48:	79 05                	jns    804a4f <getchar+0x33>
		return r;
  804a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a4d:	eb 14                	jmp    804a63 <getchar+0x47>
	if (r < 1)
  804a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a53:	7f 07                	jg     804a5c <getchar+0x40>
		return -E_EOF;
  804a55:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804a5a:	eb 07                	jmp    804a63 <getchar+0x47>
	return c;
  804a5c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804a60:	0f b6 c0             	movzbl %al,%eax
}
  804a63:	c9                   	leaveq 
  804a64:	c3                   	retq   

0000000000804a65 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804a65:	55                   	push   %rbp
  804a66:	48 89 e5             	mov    %rsp,%rbp
  804a69:	48 83 ec 20          	sub    $0x20,%rsp
  804a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a70:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804a74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a77:	48 89 d6             	mov    %rdx,%rsi
  804a7a:	89 c7                	mov    %eax,%edi
  804a7c:	48 b8 74 27 80 00 00 	movabs $0x802774,%rax
  804a83:	00 00 00 
  804a86:	ff d0                	callq  *%rax
  804a88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a8f:	79 05                	jns    804a96 <iscons+0x31>
		return r;
  804a91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a94:	eb 1a                	jmp    804ab0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a9a:	8b 10                	mov    (%rax),%edx
  804a9c:	48 b8 80 71 80 00 00 	movabs $0x807180,%rax
  804aa3:	00 00 00 
  804aa6:	8b 00                	mov    (%rax),%eax
  804aa8:	39 c2                	cmp    %eax,%edx
  804aaa:	0f 94 c0             	sete   %al
  804aad:	0f b6 c0             	movzbl %al,%eax
}
  804ab0:	c9                   	leaveq 
  804ab1:	c3                   	retq   

0000000000804ab2 <opencons>:

int
opencons(void)
{
  804ab2:	55                   	push   %rbp
  804ab3:	48 89 e5             	mov    %rsp,%rbp
  804ab6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804aba:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804abe:	48 89 c7             	mov    %rax,%rdi
  804ac1:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  804ac8:	00 00 00 
  804acb:	ff d0                	callq  *%rax
  804acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ad4:	79 05                	jns    804adb <opencons+0x29>
		return r;
  804ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ad9:	eb 5b                	jmp    804b36 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804adf:	ba 07 04 00 00       	mov    $0x407,%edx
  804ae4:	48 89 c6             	mov    %rax,%rsi
  804ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  804aec:	48 b8 55 23 80 00 00 	movabs $0x802355,%rax
  804af3:	00 00 00 
  804af6:	ff d0                	callq  *%rax
  804af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804aff:	79 05                	jns    804b06 <opencons+0x54>
		return r;
  804b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b04:	eb 30                	jmp    804b36 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b0a:	48 ba 80 71 80 00 00 	movabs $0x807180,%rdx
  804b11:	00 00 00 
  804b14:	8b 12                	mov    (%rdx),%edx
  804b16:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b1c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b27:	48 89 c7             	mov    %rax,%rdi
  804b2a:	48 b8 8e 26 80 00 00 	movabs $0x80268e,%rax
  804b31:	00 00 00 
  804b34:	ff d0                	callq  *%rax
}
  804b36:	c9                   	leaveq 
  804b37:	c3                   	retq   

0000000000804b38 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804b38:	55                   	push   %rbp
  804b39:	48 89 e5             	mov    %rsp,%rbp
  804b3c:	48 83 ec 30          	sub    $0x30,%rsp
  804b40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804b4c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b51:	75 07                	jne    804b5a <devcons_read+0x22>
		return 0;
  804b53:	b8 00 00 00 00       	mov    $0x0,%eax
  804b58:	eb 4b                	jmp    804ba5 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804b5a:	eb 0c                	jmp    804b68 <devcons_read+0x30>
		sys_yield();
  804b5c:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  804b63:	00 00 00 
  804b66:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804b68:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  804b6f:	00 00 00 
  804b72:	ff d0                	callq  *%rax
  804b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b7b:	74 df                	je     804b5c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b81:	79 05                	jns    804b88 <devcons_read+0x50>
		return c;
  804b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b86:	eb 1d                	jmp    804ba5 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804b88:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804b8c:	75 07                	jne    804b95 <devcons_read+0x5d>
		return 0;
  804b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b93:	eb 10                	jmp    804ba5 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b98:	89 c2                	mov    %eax,%edx
  804b9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b9e:	88 10                	mov    %dl,(%rax)
	return 1;
  804ba0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804ba5:	c9                   	leaveq 
  804ba6:	c3                   	retq   

0000000000804ba7 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804ba7:	55                   	push   %rbp
  804ba8:	48 89 e5             	mov    %rsp,%rbp
  804bab:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804bb2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804bb9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804bc0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804bc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bce:	eb 76                	jmp    804c46 <devcons_write+0x9f>
		m = n - tot;
  804bd0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804bd7:	89 c2                	mov    %eax,%edx
  804bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bdc:	29 c2                	sub    %eax,%edx
  804bde:	89 d0                	mov    %edx,%eax
  804be0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804be3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804be6:	83 f8 7f             	cmp    $0x7f,%eax
  804be9:	76 07                	jbe    804bf2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804beb:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804bf2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bf5:	48 63 d0             	movslq %eax,%rdx
  804bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bfb:	48 63 c8             	movslq %eax,%rcx
  804bfe:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804c05:	48 01 c1             	add    %rax,%rcx
  804c08:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804c0f:	48 89 ce             	mov    %rcx,%rsi
  804c12:	48 89 c7             	mov    %rax,%rdi
  804c15:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  804c1c:	00 00 00 
  804c1f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804c21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c24:	48 63 d0             	movslq %eax,%rdx
  804c27:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804c2e:	48 89 d6             	mov    %rdx,%rsi
  804c31:	48 89 c7             	mov    %rax,%rdi
  804c34:	48 b8 0d 22 80 00 00 	movabs $0x80220d,%rax
  804c3b:	00 00 00 
  804c3e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804c40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c43:	01 45 fc             	add    %eax,-0x4(%rbp)
  804c46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c49:	48 98                	cltq   
  804c4b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804c52:	0f 82 78 ff ff ff    	jb     804bd0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804c5b:	c9                   	leaveq 
  804c5c:	c3                   	retq   

0000000000804c5d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804c5d:	55                   	push   %rbp
  804c5e:	48 89 e5             	mov    %rsp,%rbp
  804c61:	48 83 ec 08          	sub    $0x8,%rsp
  804c65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c6e:	c9                   	leaveq 
  804c6f:	c3                   	retq   

0000000000804c70 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804c70:	55                   	push   %rbp
  804c71:	48 89 e5             	mov    %rsp,%rbp
  804c74:	48 83 ec 10          	sub    $0x10,%rsp
  804c78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804c7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c84:	48 be 4c 5d 80 00 00 	movabs $0x805d4c,%rsi
  804c8b:	00 00 00 
  804c8e:	48 89 c7             	mov    %rax,%rdi
  804c91:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  804c98:	00 00 00 
  804c9b:	ff d0                	callq  *%rax
	return 0;
  804c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ca2:	c9                   	leaveq 
  804ca3:	c3                   	retq   

0000000000804ca4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804ca4:	55                   	push   %rbp
  804ca5:	48 89 e5             	mov    %rsp,%rbp
  804ca8:	48 83 ec 30          	sub    $0x30,%rsp
  804cac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804cb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804cb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804cb8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804cbf:	00 00 00 
  804cc2:	48 8b 00             	mov    (%rax),%rax
  804cc5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804ccb:	85 c0                	test   %eax,%eax
  804ccd:	75 3c                	jne    804d0b <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804ccf:	48 b8 d9 22 80 00 00 	movabs $0x8022d9,%rax
  804cd6:	00 00 00 
  804cd9:	ff d0                	callq  *%rax
  804cdb:	25 ff 03 00 00       	and    $0x3ff,%eax
  804ce0:	48 63 d0             	movslq %eax,%rdx
  804ce3:	48 89 d0             	mov    %rdx,%rax
  804ce6:	48 c1 e0 03          	shl    $0x3,%rax
  804cea:	48 01 d0             	add    %rdx,%rax
  804ced:	48 c1 e0 05          	shl    $0x5,%rax
  804cf1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804cf8:	00 00 00 
  804cfb:	48 01 c2             	add    %rax,%rdx
  804cfe:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804d05:	00 00 00 
  804d08:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804d0b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804d10:	75 0e                	jne    804d20 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804d12:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804d19:	00 00 00 
  804d1c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804d20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d24:	48 89 c7             	mov    %rax,%rdi
  804d27:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  804d2e:	00 00 00 
  804d31:	ff d0                	callq  *%rax
  804d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d3a:	79 19                	jns    804d55 <ipc_recv+0xb1>
		*from_env_store = 0;
  804d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d40:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d4a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804d50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d53:	eb 53                	jmp    804da8 <ipc_recv+0x104>
	}
	if(from_env_store)
  804d55:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d5a:	74 19                	je     804d75 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804d5c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804d63:	00 00 00 
  804d66:	48 8b 00             	mov    (%rax),%rax
  804d69:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d73:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804d75:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d7a:	74 19                	je     804d95 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804d7c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804d83:	00 00 00 
  804d86:	48 8b 00             	mov    (%rax),%rax
  804d89:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804d8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d93:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804d95:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804d9c:	00 00 00 
  804d9f:	48 8b 00             	mov    (%rax),%rax
  804da2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804da8:	c9                   	leaveq 
  804da9:	c3                   	retq   

0000000000804daa <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804daa:	55                   	push   %rbp
  804dab:	48 89 e5             	mov    %rsp,%rbp
  804dae:	48 83 ec 30          	sub    $0x30,%rsp
  804db2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804db5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804db8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804dbc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804dbf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804dc4:	75 0e                	jne    804dd4 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804dc6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804dcd:	00 00 00 
  804dd0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804dd4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804dd7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804dda:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804dde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804de1:	89 c7                	mov    %eax,%edi
  804de3:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  804dea:	00 00 00 
  804ded:	ff d0                	callq  *%rax
  804def:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804df2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804df6:	75 0c                	jne    804e04 <ipc_send+0x5a>
			sys_yield();
  804df8:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  804dff:	00 00 00 
  804e02:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804e04:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804e08:	74 ca                	je     804dd4 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804e0a:	c9                   	leaveq 
  804e0b:	c3                   	retq   

0000000000804e0c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804e0c:	55                   	push   %rbp
  804e0d:	48 89 e5             	mov    %rsp,%rbp
  804e10:	48 83 ec 14          	sub    $0x14,%rsp
  804e14:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804e17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e1e:	eb 5e                	jmp    804e7e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804e20:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e27:	00 00 00 
  804e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e2d:	48 63 d0             	movslq %eax,%rdx
  804e30:	48 89 d0             	mov    %rdx,%rax
  804e33:	48 c1 e0 03          	shl    $0x3,%rax
  804e37:	48 01 d0             	add    %rdx,%rax
  804e3a:	48 c1 e0 05          	shl    $0x5,%rax
  804e3e:	48 01 c8             	add    %rcx,%rax
  804e41:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804e47:	8b 00                	mov    (%rax),%eax
  804e49:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e4c:	75 2c                	jne    804e7a <ipc_find_env+0x6e>
			return envs[i].env_id;
  804e4e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e55:	00 00 00 
  804e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e5b:	48 63 d0             	movslq %eax,%rdx
  804e5e:	48 89 d0             	mov    %rdx,%rax
  804e61:	48 c1 e0 03          	shl    $0x3,%rax
  804e65:	48 01 d0             	add    %rdx,%rax
  804e68:	48 c1 e0 05          	shl    $0x5,%rax
  804e6c:	48 01 c8             	add    %rcx,%rax
  804e6f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804e75:	8b 40 08             	mov    0x8(%rax),%eax
  804e78:	eb 12                	jmp    804e8c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804e7a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804e7e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804e85:	7e 99                	jle    804e20 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e8c:	c9                   	leaveq 
  804e8d:	c3                   	retq   

0000000000804e8e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804e8e:	55                   	push   %rbp
  804e8f:	48 89 e5             	mov    %rsp,%rbp
  804e92:	48 83 ec 18          	sub    $0x18,%rsp
  804e96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e9e:	48 c1 e8 15          	shr    $0x15,%rax
  804ea2:	48 89 c2             	mov    %rax,%rdx
  804ea5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804eac:	01 00 00 
  804eaf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804eb3:	83 e0 01             	and    $0x1,%eax
  804eb6:	48 85 c0             	test   %rax,%rax
  804eb9:	75 07                	jne    804ec2 <pageref+0x34>
		return 0;
  804ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ec0:	eb 53                	jmp    804f15 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ec6:	48 c1 e8 0c          	shr    $0xc,%rax
  804eca:	48 89 c2             	mov    %rax,%rdx
  804ecd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ed4:	01 00 00 
  804ed7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804edb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ee3:	83 e0 01             	and    $0x1,%eax
  804ee6:	48 85 c0             	test   %rax,%rax
  804ee9:	75 07                	jne    804ef2 <pageref+0x64>
		return 0;
  804eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef0:	eb 23                	jmp    804f15 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ef6:	48 c1 e8 0c          	shr    $0xc,%rax
  804efa:	48 89 c2             	mov    %rax,%rdx
  804efd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804f04:	00 00 00 
  804f07:	48 c1 e2 04          	shl    $0x4,%rdx
  804f0b:	48 01 d0             	add    %rdx,%rax
  804f0e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804f12:	0f b7 c0             	movzwl %ax,%eax
}
  804f15:	c9                   	leaveq 
  804f16:	c3                   	retq   

0000000000804f17 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804f17:	55                   	push   %rbp
  804f18:	48 89 e5             	mov    %rsp,%rbp
  804f1b:	48 83 ec 20          	sub    $0x20,%rsp
  804f1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804f23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f2b:	48 89 d6             	mov    %rdx,%rsi
  804f2e:	48 89 c7             	mov    %rax,%rdi
  804f31:	48 b8 4d 4f 80 00 00 	movabs $0x804f4d,%rax
  804f38:	00 00 00 
  804f3b:	ff d0                	callq  *%rax
  804f3d:	85 c0                	test   %eax,%eax
  804f3f:	74 05                	je     804f46 <inet_addr+0x2f>
    return (val.s_addr);
  804f41:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804f44:	eb 05                	jmp    804f4b <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804f4b:	c9                   	leaveq 
  804f4c:	c3                   	retq   

0000000000804f4d <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804f4d:	55                   	push   %rbp
  804f4e:	48 89 e5             	mov    %rsp,%rbp
  804f51:	48 83 ec 40          	sub    $0x40,%rsp
  804f55:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804f59:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804f5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804f61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  804f65:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804f69:	0f b6 00             	movzbl (%rax),%eax
  804f6c:	0f be c0             	movsbl %al,%eax
  804f6f:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804f72:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f75:	3c 2f                	cmp    $0x2f,%al
  804f77:	76 07                	jbe    804f80 <inet_aton+0x33>
  804f79:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f7c:	3c 39                	cmp    $0x39,%al
  804f7e:	76 0a                	jbe    804f8a <inet_aton+0x3d>
      return (0);
  804f80:	b8 00 00 00 00       	mov    $0x0,%eax
  804f85:	e9 68 02 00 00       	jmpq   8051f2 <inet_aton+0x2a5>
    val = 0;
  804f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  804f91:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  804f98:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  804f9c:	75 40                	jne    804fde <inet_aton+0x91>
      c = *++cp;
  804f9e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804fa3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804fa7:	0f b6 00             	movzbl (%rax),%eax
  804faa:	0f be c0             	movsbl %al,%eax
  804fad:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  804fb0:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  804fb4:	74 06                	je     804fbc <inet_aton+0x6f>
  804fb6:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804fba:	75 1b                	jne    804fd7 <inet_aton+0x8a>
        base = 16;
  804fbc:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  804fc3:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804fc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804fcc:	0f b6 00             	movzbl (%rax),%eax
  804fcf:	0f be c0             	movsbl %al,%eax
  804fd2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804fd5:	eb 07                	jmp    804fde <inet_aton+0x91>
      } else
        base = 8;
  804fd7:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804fde:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804fe1:	3c 2f                	cmp    $0x2f,%al
  804fe3:	76 2f                	jbe    805014 <inet_aton+0xc7>
  804fe5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804fe8:	3c 39                	cmp    $0x39,%al
  804fea:	77 28                	ja     805014 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  804fec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804fef:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804ff3:	89 c2                	mov    %eax,%edx
  804ff5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804ff8:	01 d0                	add    %edx,%eax
  804ffa:	83 e8 30             	sub    $0x30,%eax
  804ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805000:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805005:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805009:	0f b6 00             	movzbl (%rax),%eax
  80500c:	0f be c0             	movsbl %al,%eax
  80500f:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  805012:	eb ca                	jmp    804fde <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  805014:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  805018:	75 72                	jne    80508c <inet_aton+0x13f>
  80501a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80501d:	3c 2f                	cmp    $0x2f,%al
  80501f:	76 07                	jbe    805028 <inet_aton+0xdb>
  805021:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805024:	3c 39                	cmp    $0x39,%al
  805026:	76 1c                	jbe    805044 <inet_aton+0xf7>
  805028:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80502b:	3c 60                	cmp    $0x60,%al
  80502d:	76 07                	jbe    805036 <inet_aton+0xe9>
  80502f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805032:	3c 66                	cmp    $0x66,%al
  805034:	76 0e                	jbe    805044 <inet_aton+0xf7>
  805036:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805039:	3c 40                	cmp    $0x40,%al
  80503b:	76 4f                	jbe    80508c <inet_aton+0x13f>
  80503d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805040:	3c 46                	cmp    $0x46,%al
  805042:	77 48                	ja     80508c <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  805044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805047:	c1 e0 04             	shl    $0x4,%eax
  80504a:	89 c2                	mov    %eax,%edx
  80504c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80504f:	8d 48 0a             	lea    0xa(%rax),%ecx
  805052:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805055:	3c 60                	cmp    $0x60,%al
  805057:	76 0e                	jbe    805067 <inet_aton+0x11a>
  805059:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80505c:	3c 7a                	cmp    $0x7a,%al
  80505e:	77 07                	ja     805067 <inet_aton+0x11a>
  805060:	b8 61 00 00 00       	mov    $0x61,%eax
  805065:	eb 05                	jmp    80506c <inet_aton+0x11f>
  805067:	b8 41 00 00 00       	mov    $0x41,%eax
  80506c:	29 c1                	sub    %eax,%ecx
  80506e:	89 c8                	mov    %ecx,%eax
  805070:	09 d0                	or     %edx,%eax
  805072:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805075:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80507a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80507e:	0f b6 00             	movzbl (%rax),%eax
  805081:	0f be c0             	movsbl %al,%eax
  805084:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  805087:	e9 52 ff ff ff       	jmpq   804fde <inet_aton+0x91>
    if (c == '.') {
  80508c:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  805090:	75 40                	jne    8050d2 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  805092:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805096:	48 83 c0 0c          	add    $0xc,%rax
  80509a:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  80509e:	72 0a                	jb     8050aa <inet_aton+0x15d>
        return (0);
  8050a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8050a5:	e9 48 01 00 00       	jmpq   8051f2 <inet_aton+0x2a5>
      *pp++ = val;
  8050aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050ae:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8050b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8050b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8050b9:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  8050bb:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8050c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8050c4:	0f b6 00             	movzbl (%rax),%eax
  8050c7:	0f be c0             	movsbl %al,%eax
  8050ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8050cd:	e9 a0 fe ff ff       	jmpq   804f72 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8050d2:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8050d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8050d7:	74 3c                	je     805115 <inet_aton+0x1c8>
  8050d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050dc:	3c 1f                	cmp    $0x1f,%al
  8050de:	76 2b                	jbe    80510b <inet_aton+0x1be>
  8050e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050e3:	84 c0                	test   %al,%al
  8050e5:	78 24                	js     80510b <inet_aton+0x1be>
  8050e7:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8050eb:	74 28                	je     805115 <inet_aton+0x1c8>
  8050ed:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8050f1:	74 22                	je     805115 <inet_aton+0x1c8>
  8050f3:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8050f7:	74 1c                	je     805115 <inet_aton+0x1c8>
  8050f9:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8050fd:	74 16                	je     805115 <inet_aton+0x1c8>
  8050ff:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805103:	74 10                	je     805115 <inet_aton+0x1c8>
  805105:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  805109:	74 0a                	je     805115 <inet_aton+0x1c8>
    return (0);
  80510b:	b8 00 00 00 00       	mov    $0x0,%eax
  805110:	e9 dd 00 00 00       	jmpq   8051f2 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  805115:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805119:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80511d:	48 29 c2             	sub    %rax,%rdx
  805120:	48 89 d0             	mov    %rdx,%rax
  805123:	48 c1 f8 02          	sar    $0x2,%rax
  805127:	83 c0 01             	add    $0x1,%eax
  80512a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80512d:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  805131:	0f 87 98 00 00 00    	ja     8051cf <inet_aton+0x282>
  805137:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80513a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805141:	00 
  805142:	48 b8 58 5d 80 00 00 	movabs $0x805d58,%rax
  805149:	00 00 00 
  80514c:	48 01 d0             	add    %rdx,%rax
  80514f:	48 8b 00             	mov    (%rax),%rax
  805152:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  805154:	b8 00 00 00 00       	mov    $0x0,%eax
  805159:	e9 94 00 00 00       	jmpq   8051f2 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  80515e:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  805165:	76 0a                	jbe    805171 <inet_aton+0x224>
      return (0);
  805167:	b8 00 00 00 00       	mov    $0x0,%eax
  80516c:	e9 81 00 00 00       	jmpq   8051f2 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  805171:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805174:	c1 e0 18             	shl    $0x18,%eax
  805177:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80517a:	eb 53                	jmp    8051cf <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80517c:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  805183:	76 07                	jbe    80518c <inet_aton+0x23f>
      return (0);
  805185:	b8 00 00 00 00       	mov    $0x0,%eax
  80518a:	eb 66                	jmp    8051f2 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80518c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80518f:	c1 e0 18             	shl    $0x18,%eax
  805192:	89 c2                	mov    %eax,%edx
  805194:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805197:	c1 e0 10             	shl    $0x10,%eax
  80519a:	09 d0                	or     %edx,%eax
  80519c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80519f:	eb 2e                	jmp    8051cf <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8051a1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  8051a8:	76 07                	jbe    8051b1 <inet_aton+0x264>
      return (0);
  8051aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8051af:	eb 41                	jmp    8051f2 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8051b1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8051b4:	c1 e0 18             	shl    $0x18,%eax
  8051b7:	89 c2                	mov    %eax,%edx
  8051b9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8051bc:	c1 e0 10             	shl    $0x10,%eax
  8051bf:	09 c2                	or     %eax,%edx
  8051c1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8051c4:	c1 e0 08             	shl    $0x8,%eax
  8051c7:	09 d0                	or     %edx,%eax
  8051c9:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8051cc:	eb 01                	jmp    8051cf <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8051ce:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8051cf:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8051d4:	74 17                	je     8051ed <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  8051d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051d9:	89 c7                	mov    %eax,%edi
  8051db:	48 b8 6b 53 80 00 00 	movabs $0x80536b,%rax
  8051e2:	00 00 00 
  8051e5:	ff d0                	callq  *%rax
  8051e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8051eb:	89 02                	mov    %eax,(%rdx)
  return (1);
  8051ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8051f2:	c9                   	leaveq 
  8051f3:	c3                   	retq   

00000000008051f4 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8051f4:	55                   	push   %rbp
  8051f5:	48 89 e5             	mov    %rsp,%rbp
  8051f8:	48 83 ec 30          	sub    $0x30,%rsp
  8051fc:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8051ff:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805202:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  805205:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80520c:	00 00 00 
  80520f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  805213:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805217:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80521b:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80521f:	e9 e0 00 00 00       	jmpq   805304 <inet_ntoa+0x110>
    i = 0;
  805224:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  805228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80522c:	0f b6 08             	movzbl (%rax),%ecx
  80522f:	0f b6 d1             	movzbl %cl,%edx
  805232:	89 d0                	mov    %edx,%eax
  805234:	c1 e0 02             	shl    $0x2,%eax
  805237:	01 d0                	add    %edx,%eax
  805239:	c1 e0 03             	shl    $0x3,%eax
  80523c:	01 d0                	add    %edx,%eax
  80523e:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805245:	01 d0                	add    %edx,%eax
  805247:	66 c1 e8 08          	shr    $0x8,%ax
  80524b:	c0 e8 03             	shr    $0x3,%al
  80524e:	88 45 ed             	mov    %al,-0x13(%rbp)
  805251:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805255:	89 d0                	mov    %edx,%eax
  805257:	c1 e0 02             	shl    $0x2,%eax
  80525a:	01 d0                	add    %edx,%eax
  80525c:	01 c0                	add    %eax,%eax
  80525e:	29 c1                	sub    %eax,%ecx
  805260:	89 c8                	mov    %ecx,%eax
  805262:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  805265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805269:	0f b6 00             	movzbl (%rax),%eax
  80526c:	0f b6 d0             	movzbl %al,%edx
  80526f:	89 d0                	mov    %edx,%eax
  805271:	c1 e0 02             	shl    $0x2,%eax
  805274:	01 d0                	add    %edx,%eax
  805276:	c1 e0 03             	shl    $0x3,%eax
  805279:	01 d0                	add    %edx,%eax
  80527b:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805282:	01 d0                	add    %edx,%eax
  805284:	66 c1 e8 08          	shr    $0x8,%ax
  805288:	89 c2                	mov    %eax,%edx
  80528a:	c0 ea 03             	shr    $0x3,%dl
  80528d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805291:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805293:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805297:	8d 50 01             	lea    0x1(%rax),%edx
  80529a:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80529d:	0f b6 c0             	movzbl %al,%eax
  8052a0:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8052a4:	83 c2 30             	add    $0x30,%edx
  8052a7:	48 98                	cltq   
  8052a9:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  8052ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052b1:	0f b6 00             	movzbl (%rax),%eax
  8052b4:	84 c0                	test   %al,%al
  8052b6:	0f 85 6c ff ff ff    	jne    805228 <inet_ntoa+0x34>
    while(i--)
  8052bc:	eb 1a                	jmp    8052d8 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  8052be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8052c6:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8052ca:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8052ce:	48 63 d2             	movslq %edx,%rdx
  8052d1:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8052d6:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8052d8:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8052dc:	8d 50 ff             	lea    -0x1(%rax),%edx
  8052df:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8052e2:	84 c0                	test   %al,%al
  8052e4:	75 d8                	jne    8052be <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8052e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8052ee:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8052f2:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8052f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8052fa:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8052fe:	83 c0 01             	add    $0x1,%eax
  805301:	88 45 ef             	mov    %al,-0x11(%rbp)
  805304:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  805308:	0f 86 16 ff ff ff    	jbe    805224 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80530e:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805317:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80531a:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  805321:	00 00 00 
}
  805324:	c9                   	leaveq 
  805325:	c3                   	retq   

0000000000805326 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  805326:	55                   	push   %rbp
  805327:	48 89 e5             	mov    %rsp,%rbp
  80532a:	48 83 ec 04          	sub    $0x4,%rsp
  80532e:	89 f8                	mov    %edi,%eax
  805330:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  805334:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805338:	c1 e0 08             	shl    $0x8,%eax
  80533b:	89 c2                	mov    %eax,%edx
  80533d:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805341:	66 c1 e8 08          	shr    $0x8,%ax
  805345:	09 d0                	or     %edx,%eax
}
  805347:	c9                   	leaveq 
  805348:	c3                   	retq   

0000000000805349 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  805349:	55                   	push   %rbp
  80534a:	48 89 e5             	mov    %rsp,%rbp
  80534d:	48 83 ec 08          	sub    $0x8,%rsp
  805351:	89 f8                	mov    %edi,%eax
  805353:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  805357:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80535b:	89 c7                	mov    %eax,%edi
  80535d:	48 b8 26 53 80 00 00 	movabs $0x805326,%rax
  805364:	00 00 00 
  805367:	ff d0                	callq  *%rax
}
  805369:	c9                   	leaveq 
  80536a:	c3                   	retq   

000000000080536b <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80536b:	55                   	push   %rbp
  80536c:	48 89 e5             	mov    %rsp,%rbp
  80536f:	48 83 ec 04          	sub    $0x4,%rsp
  805373:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  805376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805379:	c1 e0 18             	shl    $0x18,%eax
  80537c:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  80537e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805381:	25 00 ff 00 00       	and    $0xff00,%eax
  805386:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805389:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  80538b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80538e:	25 00 00 ff 00       	and    $0xff0000,%eax
  805393:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805397:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80539c:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80539f:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8053a1:	c9                   	leaveq 
  8053a2:	c3                   	retq   

00000000008053a3 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8053a3:	55                   	push   %rbp
  8053a4:	48 89 e5             	mov    %rsp,%rbp
  8053a7:	48 83 ec 08          	sub    $0x8,%rsp
  8053ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8053ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053b1:	89 c7                	mov    %eax,%edi
  8053b3:	48 b8 6b 53 80 00 00 	movabs $0x80536b,%rax
  8053ba:	00 00 00 
  8053bd:	ff d0                	callq  *%rax
}
  8053bf:	c9                   	leaveq 
  8053c0:	c3                   	retq   
